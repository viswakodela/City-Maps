//
//  ViewController.swift
//  City Maps
//
//  Created by Viswa Kodela on 9/12/18.
//  Copyright © 2018 Viswa Kodela. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapScreen: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var addressLabel: UILabel!
    
    let locationManager = CLLocationManager()
    let regionInMeters: Double = 10000
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkLoactionServiceEnabled()
    }
    
    
    func setUpLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func checkLoactionServiceEnabled() {
        
        if CLLocationManager.locationServicesEnabled() {
            setUpLocationManager()
            checkLocationAutherizationForOurApp()
            
        } else {
            // Let the user know that hid Location Services are not Enabled in the Settings App
        }
    }
    
    func checkLocationAutherizationForOurApp() {
        
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            // Show an alert saying that the current user is not allowed
            break
        case .denied:
            // Let the User know when can they turn on the Location
            break
        case .authorizedAlways:
            break
        case .authorizedWhenInUse:
            // Do map stuff
            mapView.showsUserLocation = true
            let currentLocation = locationManager.location?.coordinate
            centerViewOnUserLocation(location: currentLocation)
            locationManager.startUpdatingLocation()
        }
    }
    
    func centerViewOnUserLocation(location: CLLocationCoordinate2D?) {
        guard let location = location else {return}
        let region = MKCoordinateRegionMakeWithDistance(location, regionInMeters, regionInMeters)
        mapView.setRegion(region, animated: true)
    }
}

extension MapScreen: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let location = locations.last else {return}
        self.centerViewOnUserLocation(location: location.coordinate)
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        // When ever the authorization changes
        checkLocationAutherizationForOurApp()
    }
}


