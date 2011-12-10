Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34986 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751485Ab1LJXv0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 Dec 2011 18:51:26 -0500
Message-ID: <1323561071.25752.20.camel@deadeye> (sfid-20111211_005137_384554_5FF5AFED)
Subject: Re: Bug#651622: linux-2.6: Sitecom WLA-2000 v1.001 WLAN stick not
 supported
From: Ben Hutchings <ben@decadent.org.uk>
To: Larry Finger <Larry.Finger@lwfinger.net>, 651622@bugs.debian.org
Cc: Roland Gruber <post@rolandgruber.de>,
	linux-wireless@vger.kernel.org
Date: Sat, 10 Dec 2011 23:51:11 +0000
In-Reply-To: <4EE3E9A1.8000004@lwfinger.net>
References: <20111210162607.1020.50335.reportbug@roland>
			 <1323537258.18450.100.camel@deadeye> <4EE39C40.4030802@rolandgruber.de>
		 <1323543622.25752.4.camel@deadeye> <4EE3D447.7030108@rolandgruber.de>
	 <1323554710.25752.18.camel@deadeye> <4EE3DF19.6080106@rolandgruber.de>
	 <4EE3E9A1.8000004@lwfinger.net>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-kmF1C8XcDCekSlAKSUU/"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-kmF1C8XcDCekSlAKSUU/
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2011-12-10 at 17:22 -0600, Larry Finger wrote:
> On 12/10/2011 04:37 PM, Roland Gruber wrote:
> > -----BEGIN PGP SIGNED MESSAGE-----
> > Hash: SHA1
> >
> > Hi,
> >
> > I have some problem to get a Sitecom USB WLAN stick to run.
> > Ben tried to help me but we did not get it to work. So he pointed me to=
 you. :)
> >
> > It is the Sitecom WLA-2000 v1.001.
> >
> > Vendor 0df6
> > Product 005d
> > Chipset Realtek RTL8191S
> >
> > Dec 10 18:45:10 roland kernel: [18513.016012] usb 2-3: new high speed U=
SB device number 9 using ehci_hcd
> > Dec 10 18:45:10 roland kernel: [18513.151122] usb 2-3: New USB device f=
ound, idVendor=3D0df6, idProduct=3D005d
> > Dec 10 18:45:10 roland kernel: [18513.151126] usb 2-3: New USB device s=
trings: Mfr=3D1, Product=3D2, SerialNumber=3D3
> > Dec 10 18:45:10 roland kernel: [18513.151129] usb 2-3: Product: RTL8191=
S WLAN Adapter
> > Dec 10 18:45:10 roland kernel: [18513.151130] usb 2-3: Manufacturer: Ma=
nufacturer Realtek
> > Dec 10 18:45:10 roland kernel: [18513.151132] usb 2-3: SerialNumber: 00=
e04c000001
> >
> > We tried to use the kernel module rtl8192cu by adding the IDs with "ech=
o 0df6 005d>  /sys/bus/usb/drivers/rtl8192cu/new_id".
> > But this led to a kernel oops.
> >
> > Is there any way to setup the rtl8192cu kernel module so that it accept=
s the WLAN stick?
> > We also tried the module r8192u_usb but it complains about firmware loa=
ding problems when connecting the stick.
>=20
> If rtl8192cu generates an oops when you use the new_id, then it is the wr=
ong=20
> driver for your device.

Isn't this really just because using new_id results in
driver_info =3D NULL?

Ben.

> The driver for the RTL8188SU is r8712u. Try
>=20
> modprobe -rv r8712u
> echo 0df6 005d >  /sys/bus/usb/drivers/r8712u/new_id
>=20
> If that works, I can add that device ID to the driver.

--=20
Ben Hutchings
Teamwork is essential - it allows you to blame someone else.

--=-kmF1C8XcDCekSlAKSUU/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUATuPwb+e/yOyVhhEJAQqn4A//X/UbGO8SciXeXDeKQG04gH8uLZiZRSgP
0LVRX1rJmJcWVO8U1lo6aUsMhW94q9f+PpubdES/M9KTfNFRs4xoTZ7XbPr7KFTP
xSYxrnCABpgvYSDSJYGGu8kHNCSTvvbJQUdyEYDt59feJ2GQIV/ALTaEYTIhkQrI
T01OGZwv0VuLhfnrYvGfk2sdu6g7qzCPHHTvIfKh2zMV14AHUd6BrpZzDzVjwjbO
9BO28YNQ2vBZUNbwPtS3rpB0PfDwt8k8sdwbbFTgSub4XP8cWWbjvLRQEhoaNj9K
u4gYXDwll/mtjjUhKzUzSVfrsa08OaonDOLNBppQPZZGybWUTZmDht7nXqrReU1y
irpUaU6ur21NMwoPMaJhwtvE2G5Y7I3fuHK963UnHuGyNJG9GALq7UTNKBJXJkPe
RP1mSXH/zuc8VslEGDZUltHIwAlbif5h9xPFe65IBe/l7iCQnrhedzsOQlIECt6k
Yq6SPp0bUOfDZQSJm4muf+Zv/rkTMVQF9Up3aEb2yPUfSk1jrn7FsH9TbobYR298
zKQi98UksSGfPS0wxjfeBSg3F434i62xyrWTtrOECrZXCtqqptP8Tgb0NLn3S08f
XNma0j0hDJnoZyRCvb6sId7PxHIixGmoNA9gw0z7jmXGtUx4kPkVsiTOuOEa/Bth
n+zjHKlhye0=
=dg0+
-----END PGP SIGNATURE-----

--=-kmF1C8XcDCekSlAKSUU/--
