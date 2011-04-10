Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:36497 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754681Ab1DJTEI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Apr 2011 15:04:08 -0400
From: Ben Hutchings <ben@decadent.org.uk>
To: Ivo Van Doorn <ivdoorn@gmail.com>
Cc: Gertjan van Wingerde <gwingerde@gmail.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <BANLkTi=o3P7PbcjW1n_dnhtwX08UE4t2+Q@mail.gmail.com>
References: <1302450962.5282.129.camel@localhost>
	 <BANLkTi=-bRn_6yie1b=wxgVowqZq6+03CQ@mail.gmail.com>
	 <1302457754.5282.219.camel@localhost>
	 <BANLkTi=o3P7PbcjW1n_dnhtwX08UE4t2+Q@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha512"; protocol="application/pgp-signature"; boundary="=-yRohupRBK1tnl59PKWCC"
Date: Sun, 10 Apr 2011 20:04:01 +0100
Message-ID: <1302462241.5282.232.camel@localhost>
Mime-Version: 1.0
Subject: Re: Firmware files for Ralink RT28x0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-yRohupRBK1tnl59PKWCC
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 2011-04-10 at 20:06 +0200, Ivo Van Doorn wrote:
> Hi,
>=20
> >> On Sun, Apr 10, 2011 at 5:56 PM, Ben Hutchings <ben@decadent.org.uk> w=
rote:
> >> > I notice that rt2800{pci,usb} each specify only one firmware image,
> >> > regardless of the controller version.
> >> >
> >> > This is inconsistent with rt28{6,7}0sta and with the firmware images=
 in
> >> > linux-firmware.
> >>
> >> Well the rt2800pci/usb firmware behavior is consistent with the origin=
al
> >> Ralink drivers (Not sure about the staging drivers, I only look to the=
 drivers
> >> on the Ralink website).
> >
> > Are you referring to the #ifdef BIN_IN_FILE code?  This code is not
> > enabled, so you should assume it is broken.  I suspect that it was
> > intended to ease firmware development.
>=20
> Not only BIN_IN_FILE, but the .bin files provided in the Ralink package
> itself. At some point I grabbed all .bin files from all Ralink packages,
> and compared them.

But this proves nothing, because the Ralink drivers don't use those
files!

[...]
> > The firmware blobs in RT2870 version 2009-08-20 and RT3070 version
> > 2009-05-25 are all marked as version 17 (or 0.17), but *they all have
> > different contents*.
>=20
> How do you determine this version? I usually check the last couple
> of bytes of the firmware file. (The last 2 bytes of the firmware is the C=
RC,
> but the 2 bytes before that is the version).

That's exactly what I'm looking at, in the file include/firmware.h.
There are 256 lines * 16 bytes for each image, so the images end with:

RT2870 image 1: 0x00, 0x11, 0xc2, 0x7a=20
RT2870 image 2: 0x00, 0x11, 0x77, 0x81
RT3070 image 1: 0x00, 0x11, 0x7b, 0xc4
RT3070 image 2: 0x00, 0x11, 0x65, 0xd3

By the way, there is a comment in common/rtmp_mcu.c which says the
version number for these chips is only 1 byte.

[...]
> > linux-firmware is supposed to have all firmware files referenced by any
                                       ---                              ---
> > version of Linux; therefore these files must not be removed.
>=20
> I agree that the firmware should be in linux-firmware, but only if they
> are the latest version (and it is possible to keep them up-to-date). Havi=
ng
> outdated firmware in the linux-firmware tree only causes more problems.
>=20
> > If just two files are sufficient then the other files could be replaced
> > by symlinks to them.
>=20
> Why? The patch to remove the staging drivers has been sent out a few
> days ago. After that we only have rt2800pci and rt2800usb drivers,
> so we can get rid of the rt30xx files completely. ;)

No.  Read what I said again.

Ben.

--=20
Ben Hutchings
Once a job is fouled up, anything done to improve it makes it worse.

--=-yRohupRBK1tnl59PKWCC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUATaH/G+e/yOyVhhEJAQr1HA//R4lfGZGvnFokBiWXLFnF6Hq4igX4p1mR
OAKR6Q5f90GvPnXTnHN1vtGfjKcgHV6k2vdwe0DNQyWuey6zMOGtZ0wRRZ/+jAs6
xsY5VNDciI2M+N5CkwLu7AE+bw/8DebDMsDvJJQx99GCezxilACYsxaZYI0JJ04I
n6R0a9s+i/uMK92VWBYtHkak1LySMU/ELvcUqlSYBoPib5hZd09QSEdNl6TOOKb5
P4F3zejq4SGLa9Ka+lSwgGboNSYGRN0oz+ctTJQxCbbV5gWGlAS+LCj4qgdggfup
6jUvSyY0U2bgbTxf/fLOxCao4FHBOgmzO514bIGO7UY5AR8CKuL1s1vyxdSYEgnE
nfVU3ckfhF03h6ozpE1zOrwdigSv3SITG+WlzY44I+0i9RwNWHkNBGPWcAuRbk80
mM7P4tbS1GxYkFLpq4qr8zLTNornRR/dM8vEXF6RU4T2TLT8AZA7I/zA95TS2nTU
4wKekcAhpSXjh+2FTDydk5XIrIxrRhd7vBICIuGoi6VGx4syv0QPLkAB0ZO5AKbV
14bNb/EmNMQv5frP31Pxmiz9c8tXh3vznBX1i8XEOY4rkSExMnua+rBGpQJCoxgE
f0DkwGwJU6hp86DGkOmoXd/tlJcRYulTwG9IqCfLMvvUXKrEnDjNACuaiVe7Yv5+
8VtanbNgCtI=
=NnF3
-----END PGP SIGNATURE-----

--=-yRohupRBK1tnl59PKWCC--
