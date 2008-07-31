Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:59648 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759958AbYGaWOF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Jul 2008 18:14:05 -0400
Message-ID: <4892391D.2010305@imap.cc> (sfid-20080801_001418_089112_322D4D3A)
Date: Fri, 01 Aug 2008 00:13:49 +0200
From: Tilman Schmidt <tilman@imap.cc>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	linux-usb@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: Q: support for AVM Fritz! WLAN USB in kernel 2.6.25+
References: <4891D1B9.70703@imap.cc> <1217517915.10489.143.camel@johannes.berg> <4891E97C.1060302@imap.cc> <20080731165054.GA14485@tuxdriver.com>
In-Reply-To: <20080731165054.GA14485@tuxdriver.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig223C8FDF347A4533755BA947"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig223C8FDF347A4533755BA947
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

John W. Linville schrieb:
> Did the acx100 driver work with your card?

Not on its own, no. But if I interpret the kernel messages correctly, it =
is
actually involved in driving the device when the AVM driver is present.
This is how it looks when the device is inserted:

Jul 29 08:19:00 compaq kernel: usb 2-2: new high speed USB device using e=
hci_hcd and address 2
Jul 29 08:19:00 compaq kernel: usb 2-2: configuration #1 chosen from 1 ch=
oice
Jul 29 08:19:00 compaq kernel: usb 2-2: New USB device found, idVendor=3D=
057c, idProduct=3D62ff
Jul 29 08:19:00 compaq kernel: usb 2-2: New USB device strings: Mfr=3D3, =
Product=3D2, SerialNumber=3D1
Jul 29 08:19:00 compaq kernel: usb 2-2: Product: WLAN USB Device
Jul 29 08:19:00 compaq kernel: usb 2-2: Manufacturer: AVM GmbH
Jul 29 08:19:00 compaq kernel: usb 2-2: SerialNumber: 001C4AF1E469
Jul 29 08:19:01 compaq kernel: fwlanusb: AVM FRITZ!WLAN USB Stick driver,=
 revision 1.00.00
Jul 29 08:19:01 compaq kernel: fwlanusb: (fwlanusb built on Jul 28 2008 a=
t 02:39:48)
Jul 29 08:19:01 compaq kernel: fwlanusb: -- 32 bit driver --
Jul 29 08:19:01 compaq kernel: fwlanusb: Loading...
Jul 29 08:19:01 compaq kernel: fwlanusb: Found FRITZ!Wlan device in cdrom=
 mode.
Jul 29 08:19:01 compaq kernel: fwlanusb: Doing fast eject.
Jul 29 08:19:01 compaq kernel: usb 2-2: USB disconnect, address 2
Jul 29 08:19:01 compaq kernel: usbcore: registered new interface driver f=
wlanusb
Jul 29 08:19:01 compaq kernel: fwlanusb: Loaded.
Jul 29 08:19:01 compaq kernel: Initializing USB Mass Storage driver...
Jul 29 08:19:01 compaq kernel: usbcore: registered new interface driver u=
sb-storage
Jul 29 08:19:01 compaq kernel: USB Mass Storage support registered.
Jul 29 08:19:02 compaq kernel: usb 2-2: new high speed USB device using e=
hci_hcd and address 3
Jul 29 08:19:02 compaq kernel: usb 2-2: configuration #1 chosen from 1 ch=
oice
Jul 29 08:19:02 compaq kernel: fwlanusb: Found FRITZ!Wlan device.
Jul 29 08:19:02 compaq kernel: fwlanusb: Driver 'fwlanusb' attached to fw=
lanusb-stack version [Protokollstack=3D1.00.00]. (176)
Jul 29 08:19:02 compaq kernel: usb 2-2: reset high speed USB device using=
 ehci_hcd and address 3
Jul 29 08:19:02 compaq kernel: acx: this driver is still EXPERIMENTAL
Jul 29 08:19:02 compaq kernel: acx: reading README file and/or Craig's HO=
WTO is recommended, visit http://acx100.sf.net in case of further questio=
ns/discussion
Jul 29 08:19:02 compaq kernel: acx: compiled to use 32bit I/O access. I/O=
 timing issues might occur, such as non-working firmware upload. Report t=
hem
Jul 29 08:19:02 compaq kernel: acx: running on a little-endian CPU
Jul 29 08:19:02 compaq kernel: acx: PCI/VLYNQ module v0.3.37 initialized,=
 waiting for cards to probe...
Jul 29 08:19:02 compaq kernel: USB module v0.3.37 initialized, probing fo=
r devices...
Jul 29 08:19:03 compaq kernel: fwlanusb: Config manager successully creat=
ed and started.
Jul 29 08:19:03 compaq kernel: usb 2-2: New USB device found, idVendor=3D=
057c, idProduct=3D6201
Jul 29 08:19:03 compaq kernel: usb 2-2: New USB device strings: Mfr=3D3, =
Product=3D2, SerialNumber=3D1
Jul 29 08:19:03 compaq kernel: usb 2-2: Product: WLAN USB Device
Jul 29 08:19:03 compaq kernel: usb 2-2: Manufacturer: AVM GmbH
Jul 29 08:19:03 compaq kernel: usb 2-2: SerialNumber: 001C4AF1E469
Jul 29 08:19:03 compaq kernel: usbcore: registered new interface driver a=
cx_usb
Jul 29 08:19:03 compaq ifup:     wlan0    =20
Jul 29 08:19:03 compaq ifup:               No configuration found for wla=
n0

So as soon as the AVM driver switches the stick from storage mode (where =
it
offers Windows drivers for installation) to WLAN mode, the acx module sho=
ws
up.

Anything I should try?

Thanks,
Tilman


--------------enig223C8FDF347A4533755BA947
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4-svn0 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iD8DBQFIkjknQ3+did9BuFsRApz2AJ9yFbI3G1xeIpqCAbeWTtNCeYXONQCfU3g1
LAzmlBOm10fUZruBHdFpr1w=
=Cnsq
-----END PGP SIGNATURE-----

--------------enig223C8FDF347A4533755BA947--
