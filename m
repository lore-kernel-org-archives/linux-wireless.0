Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54369 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753150Ab1DJRt1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Apr 2011 13:49:27 -0400
From: Ben Hutchings <ben@decadent.org.uk>
To: Ivo Van Doorn <ivdoorn@gmail.com>
Cc: Gertjan van Wingerde <gwingerde@gmail.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <BANLkTi=-bRn_6yie1b=wxgVowqZq6+03CQ@mail.gmail.com>
References: <1302450962.5282.129.camel@localhost>
	 <BANLkTi=-bRn_6yie1b=wxgVowqZq6+03CQ@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha512"; protocol="application/pgp-signature"; boundary="=-04Jr8TzYl2z2629ypoET"
Date: Sun, 10 Apr 2011 18:49:14 +0100
Message-ID: <1302457754.5282.219.camel@localhost>
Mime-Version: 1.0
Subject: Re: Firmware files for Ralink RT28x0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-04Jr8TzYl2z2629ypoET
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 2011-04-10 at 18:35 +0200, Ivo Van Doorn wrote:
> Hi,
>=20
> On Sun, Apr 10, 2011 at 5:56 PM, Ben Hutchings <ben@decadent.org.uk> wrot=
e:
> > I notice that rt2800{pci,usb} each specify only one firmware image,
> > regardless of the controller version.
> >
> > This is inconsistent with rt28{6,7}0sta and with the firmware images in
> > linux-firmware.
>=20
> Well the rt2800pci/usb firmware behavior is consistent with the original
> Ralink drivers (Not sure about the staging drivers, I only look to the dr=
ivers
> on the Ralink website).

Are you referring to the #ifdef BIN_IN_FILE code?  This code is not
enabled, so you should assume it is broken.  I suspect that it was
intended to ease firmware development.

Ralink provides multiple drivers per bus type for RT28xx and later
chips.  For PCI devices they split between RT2860 and RT309x; for USB
devices they split between RT2870 and RT307x (I think - the chip model
numbers don't seem to be stated consistently).

In addition, the USB drivers have two separate images packed together
and they can select different images based on the controller version:

#ifdef RTMP_MAC_USB
		if ((Version !=3D 0x2860) && (Version !=3D 0x2872) && (Version !=3D 0x307=
0))=20
		{	// Use Firmware V2.
			//printk("KH:Use New Version,part2\n");
			pFirmwareImage =3D (PUCHAR)&FirmwareImage[FIRMWAREIMAGEV1_LENGTH];
			FileLength =3D FIRMWAREIMAGEV2_LENGTH;
		}
		else
		{
			//printk("KH:Use New Version,part1\n");
			pFirmwareImage =3D FirmwareImage;
			FileLength =3D FIRMWAREIMAGEV1_LENGTH;
		}
#endif // RTMP_MAC_USB //

The firmware blobs in RT2870 version 2009-08-20 and RT3070 version
2009-05-25 are all marked as version 17 (or 0.17), but *they all have
different contents*.

I attempted to maintain the same version selection logic when converting
the staging drivers to use the firmware loader, since I assumed there
was a good reason for it.

> As for the linux-firmware that contains some firmware files for rt30** ch=
ipsets,
> but that are not used by rt2800pci/usb for the simple reason that the lat=
est
> version of the rt2860.bin and rt2870.bin files contain support for
> those chipsets
> as well.

So I have heard.  But do they still support the original chips
correctly?

> > If you think that a single image per bus type can cover all controllers=
,
> > please identify those firmware images, test them on each hardware
> > generation, and get them into linux-firmware.
>=20
> Updating the firmware files in the linux-firmware tree seems to be
> close to impossible. Multiple attempts have been made to update the
> firmware files for rt73usb, rt61pci, rt2800pci and rt2800usb, and every
> attempt has been ignored.
> Even when Ralink sent the update directly, and it seemed that the patches
> were accepted, they were still not applied.

This roughly matches my experience, except that I have been persistent
enough to get my changes applied eventually.

> So honestly, I think it might be easier to simply remove the Ralink firmw=
are
> files from the linux-firmware tree, as then at least the users won't acci=
dently
> use the outdated firmware files from that tree.

linux-firmware is supposed to have all firmware files referenced by any
version of Linux; therefore these files must not be removed.

If just two files are sufficient then the other files could be replaced
by symlinks to them.

Ben.

--=20
Ben Hutchings
Once a job is fouled up, anything done to improve it makes it worse.

--=-04Jr8TzYl2z2629ypoET
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUATaHtlee/yOyVhhEJAQpc1Q/+NTmYzegsEIEPOHGQbUwxJL7vHsDTEuay
KtuzqT9yc5tby3ufVStSESUzejhoTKvATRPCIsddJVepHMxeps92PDI12Jw3GB0o
ykSe9EI3gICHBd+gug8CY59H9jVLBIUSUSatZAdQvlKuV+bad8jKRiyHsRwky9Tl
1e0NDUZm6Zc01AT87yVbvxIbpGbGvM/xPimZ/o2jd2l4JYZYeXHMC9g1sf7CZwMT
PyUdP7Tk4pPe+Ghbc/HG8rm3xSkyqsc1J5yeQGFtal9J3mt/B+n4R6oD47AOxFVn
Vv1vaujdhXBcblwTMFWWxMroed8Vnr38WNi82SzNiOwl4LPdnCArDtEOYQ5/fL7m
65Zl+eVg6wrcy6ZNtrz7OjFtbMWyMf1i3LNUIHu636jYDqGkSxUjXndMcqVmvd2D
t1i7Zfg8SNvstqEJpZSt4YBLAxJJatM4tYtXbKvS2cmYQGkoDl5EujzmE3rtTGAc
z1pNFoHf1pxwtAYj/Ouh1CHyYrzQEPaw5aZRc8L9A8+iW3gxfHxx3zJi0+e8ruAp
dgd9jStyFvjlyhbrlPZ4No+yMFtCd2ON/JIu5ODCd0l7xlxxLSZ2yihA0XDRKdcY
rf6PEmi8J8Qw/FGnFcDNkHEdWLry7vVUW3L6fjkrJJTAc4vs4D18weQINJxrCMuG
Dnyyzu4fXrc=
=FDS6
-----END PGP SIGNATURE-----

--=-04Jr8TzYl2z2629ypoET--
