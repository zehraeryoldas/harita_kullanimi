import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
    late BitmapDescriptor konumIcon;

  //AIzaSyDJurAbfNMSY5UaXpOCcJcPaCKzv4_y6yI
  //haritayı kontrol etmek için öncelikle bir nesne tanımlamamız gerekiyor

  Completer<GoogleMapController> haritaKontrol = Completer();
  List<Marker> isaretler = <Marker>[];
  var baslangicKonum =
      CameraPosition(target: LatLng(38.7412482, 26.1844276), zoom: 4);

  Future<void> konumaGit() async {
    GoogleMapController controller = await haritaKontrol.future;

    var gidilecekIsaret = Marker(
        markerId: MarkerId("Id"),
        position: LatLng(41.0039643, 28.4517462),
        infoWindow: InfoWindow(title: "İstanbul", snippet: "Evim"),
        icon: konumIcon,
        );

    setState(() {
      isaretler.add(gidilecekIsaret);
    });

    var gidilecekKonum =
        CameraPosition(target: LatLng(41.0039643, 28.4517462), zoom: 8);
    controller.animateCamera(CameraUpdate.newCameraPosition(gidilecekKonum));
  }

  iconOlustur(context){
    ImageConfiguration configuration=createLocalImageConfiguration(context);
    BitmapDescriptor.fromAssetImage(configuration, "resimler/konum_resim.png").then((icon){
      konumIcon=icon;
    });
  } 


  @override
  Widget build(BuildContext context) {
    iconOlustur(context);
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          children: <Widget>[
            SizedBox(
              width: 400,
              height: 300,
              child: GoogleMap(
                mapType: MapType.normal,
                initialCameraPosition: baslangicKonum,
                markers: Set<Marker>.of(isaretler),
                onMapCreated: (GoogleMapController controller) {
                  haritaKontrol.complete(controller);
                },
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  konumaGit();
                },
                child: Text(
                  " Konuma Git",
                ))
          ],
        ),
      ),
    );
  }
}
