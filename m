Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from daemonizer.de ([178.77.99.65]:38536 "EHLO daemonizer.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752300Ab2HZNoF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 26 Aug 2012 09:44:05 -0400
From: Maximilian Engelhardt <maxi@daemonizer.de>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: Roman Thiele <roman.thiele@stusta.mhn.de>
Subject: Getting ASUS USB-N53 out of CONFIG_RT2800USB_UNKNOWN
Date: Sun, 26 Aug 2012 15:33:29 +0200
Message-ID: <17042485.dTE7gQicta@eisbaer> (sfid-20120826_154509_381909_1A44EAD3)
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart3928826.deT8OT8ISR"; micalg="pgp-sha512"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--nextPart3928826.deT8OT8ISR
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

Hallo,

I recently bought an Asus USB-N53 Dual Band Wireless Network Adapter and 
noticed that I have to enable CONFIG_RT2800USB_UNKNOWN to get it working. With 
this option enabled everything is working fine as far as I have tested.

So I'd line to get things right and move this device out of 
CONFIG_RT2800USB_UNKNOWN to where it belongs.


Here is the information I have about this device, feel tree to ask if you need 
anything addition.

Asus Website about the device:
http://www.asus.com/Networks/Wireless_Adapters/USBN53/

output of lsusb:
Bus 005 Device 013: ID 0b05:179d ASUSTek Computer, Inc. USB-N53 802.11abgn 
Network Adapter [Ralink RT3572]

output of dmesg:
usb 5-6: new high-speed USB device number 13 using ehci_hcd
usb 5-6: New USB device found, idVendor=0b05, idProduct=179d
usb 5-6: New USB device strings: Mfr=1, Product=2, SerialNumber=3
usb 5-6: Product: 802.11 n WLAN
usb 5-6: Manufacturer: Ralink
usb 5-6: SerialNumber: 1.0
usb 5-6: reset high-speed USB device number 13 using ehci_hcd
ieee80211 phy6: Selected rate control algorithm 'minstrel_ht'
Registered led device: rt2800usb-phy6::radio
Registered led device: rt2800usb-phy6::assoc
Registered led device: rt2800usb-phy6::quality


So according to lsusb this is a RT3572 device, which does also match with the 
chip description from ralink: 
http://www.ralinktech.com/en/02_products/product.php?sn=1009

I suggest moving the device to the CONFIG_RT2800USB_RT35XX section in 
rt2800usb.c, see attached patch.


diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
index 6cf3365..6681bfc 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -1157,6 +1157,8 @@ static struct usb_device_id rt2800usb_device_table[] = {
        { USB_DEVICE(0x1690, 0x0744) },
        { USB_DEVICE(0x1690, 0x0761) },
        { USB_DEVICE(0x1690, 0x0764) },
+       /* ASUS */
+       { USB_DEVICE(0x0b05, 0x179d) },
        /* Cisco */
        { USB_DEVICE(0x167b, 0x4001) },
        /* EnGenius */
@@ -1222,7 +1224,6 @@ static struct usb_device_id rt2800usb_device_table[] = {
        { USB_DEVICE(0x0b05, 0x1760) },
        { USB_DEVICE(0x0b05, 0x1761) },
        { USB_DEVICE(0x0b05, 0x1790) },
-       { USB_DEVICE(0x0b05, 0x179d) },
        /* AzureWave */
        { USB_DEVICE(0x13d3, 0x3262) },
        { USB_DEVICE(0x13d3, 0x3284) },


Greeting,
Maxi
--nextPart3928826.deT8OT8ISR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABCgAGBQJQOiWpAAoJEIHqZH0kK9IVOEUP/ja1mnOimMGz8uj1Chlx56Gc
bwmyVNk6Tvuf1ix0LlHKvvinb+ejLAXNZWwWB+YPQ+IjUm+huS8iK76vRtsljrD3
e5F7TnjHe4xG7ChQCM04P+kpbTA7aHP4Z+/P7TJlp2ky1pH8rj/QbaAUtvQkB7IF
2AXc+4VCd4LAlfhpF3uCGCreWYYABSaovDtIzhu/59H1Uo0c96yh6Srh1arAzNMu
7ULPm0wuPXEMq1Td6QfArNb/LPcYVP97yW95FKxMUkT0sJXIRz9dwUC2wDKs0llW
VVr6tVtQuuBjiBXLo5Tx24V8dSTlw80IAB69F5igk4IWG9iNsGRKcswVqiUYI5Za
I4xvrd1k3LRQs5f/4GkcpfrX4FX772Gf4J4atQv4pyVPaGhuqtjIFBP2NSIgikGg
C3R4nE6oM+G4OOIqpqu4uiBeg+M1DDydHJ+NJzkQv/cbpo36/Ma2cGTYDT1GkYNv
2bl+FUVTfRkIVIyv08+SMzUzuIeZdRnrJIMRxtuUsWcF8tCLY4gjonIWIgTvHEEu
KLiTU39T6T2i2fN/Tg3oEh6I/gLaPcbjquatsSqa5qTJXbvhv4Me5tSaKgixjRDw
0rkV1YqzXgPy93TgMglZn9hXPZ8Wlj7ZFUgaJvXKcWl/jPYZD6X+uPsGJ9/aE5Yl
cICapGk0ekkr3+kgBWEX
=mQuY
-----END PGP SIGNATURE-----

--nextPart3928826.deT8OT8ISR--

