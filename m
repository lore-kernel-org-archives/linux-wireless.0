Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sd-mail-sa-01.sanoma.fi ([158.127.18.161]:47151 "EHLO
	sd-mail-sa-01.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750855Ab3CQJMx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 Mar 2013 05:12:53 -0400
Message-ID: <5145890A.7070308@iki.fi> (sfid-20130317_101302_104245_5AE83D91)
Date: Sun, 17 Mar 2013 11:12:42 +0200
From: Jussi Kivilinna <jussi.kivilinna@iki.fi>
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: Christian Clauss <cclauss@bluewin.ch>, ziv_huang@realtek.com,
	georgia@realtek.com,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: rtl8192cu NOT working on Raspberry Pi
References: <041DFAF5-BEDE-4C1A-9863-A04F2DD3049A@bluewin.ch> <5144FECC.6050504@lwfinger.net>
In-Reply-To: <5144FECC.6050504@lwfinger.net>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="----enig2KMGACUGSRNQCPIROVFPE"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
------enig2KMGACUGSRNQCPIROVFPE
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 17.03.2013 01:22, Larry Finger wrote:
> On 03/16/2013 05:03 PM, Christian Clauss wrote:
>> Hi Larry, Ziv, and Georgia,
>>
>>     These rtl8192cu drivers seem to be very flakey / non-functional on=
 Raspberry Pi.
>>
>>      https://github.com/hexameron/rtlwifi
>>
>>      http://www.raspberrypi.org/phpBB3/viewtopic.php?f=3D71&t=3D24951
>=20
> Sorry, but I only support the drivers in the current Linux kernel, and =
as backported with compat-drivers.
>=20

Problems I had with rtl8192cu on arm/sunxi, were mostly related to USB ho=
st driver not handling unaligned and/or overlapping URB buffers correctly=
 which lead to memory corruption and random crashes. So if you get proble=
matic behavior with latest compat-drivers (+ with the patch Larry pointed=
 out), I'd say look at USB host driver of raspberry.

You can check the workarounds for sunxi-ehci/ohci and tegra-ehci at:
 https://github.com/linux-sunxi/linux-sunxi/blob/stage/sunxi-3.4/drivers/=
usb/host/ehci-tegra.c#L386
 https://github.com/linux-sunxi/linux-sunxi/blob/stage/sunxi-3.4/drivers/=
usb/host/sw_hci_sunxi.c#L633

-Jussi

<snip>
>=20
> There is a major bug in rtl8192cu that was just fixed this past week. S=
ee http://marc.info/?l=3Dlinux-wireless&m=3D136319807619280&w=3D2 for the=
 patch.
>=20
> Larry
>=20


------enig2KMGACUGSRNQCPIROVFPE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQGcBAEBCAAGBQJRRYkRAAoJEAaL+yOpMWaGmvwL/j2UAbSC4fDwH3nMNPxe5YVC
vzd2/BLkHwa4j7+KY3O2lzRULgJAJSWKOsLmmL40QhVRGTtvLWi4BJbbQf5Jvz+e
QY7x4m7SZlQBXIsIhUdb0CElEDQSMsFPlUvX48yWVjqhvGf6bwBqj6ML2wuDaPQe
01OcFV5YYZu75lEqj8DLW4p6WmYAn2aBMY3DLs6AnXsyiCR/b3X07Prd22IsL4ok
mZSYYLjJWjbP411bH4tDZT7yf0QwYrFYasjQj4DXo9sCHi2cNKryyIPA3BS+Etzs
gZyy8TEsVvi6pNt/UbalCLiCQbdq38Mks7nl7/3AN9QdksqJ3AF1FvhxeNFinu8L
BVln24K4x4gO614o5j/2sc8Ec1cFuwoWmXfhGUjUFydr1k1iWLHY5i0aqGu9mSTn
8+XfLS26LnGpewhx9TAW4qGvYuF4Y+IyoLYPWL64Rs/ikSqIzQNK7MHrX18GMSp6
tCs/kAHHsME4wVpmLUYF2PZxnPGanSpx4tY6Pm2H6g==
=3ENf
-----END PGP SIGNATURE-----

------enig2KMGACUGSRNQCPIROVFPE--
