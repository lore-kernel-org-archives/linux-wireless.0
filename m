Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:50052 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751180AbbASGxf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Jan 2015 01:53:35 -0500
Message-ID: <54BCA9DF.4040006@rempel-privat.de> (sfid-20150119_075350_427349_A4513FBC)
Date: Mon, 19 Jan 2015 07:53:19 +0100
From: Oleksij Rempel <linux@rempel-privat.de>
MIME-Version: 1.0
To: Jeremy Audet <ichimonji10@gmail.com>
CC: linux-wireless@vger.kernel.org, Adrian Chadd <adrian@freebsd.org>
Subject: Re: bug report for ath9k_htc driver
References: <CA+A7n+jFWWs-U2DapExRqYgK=e2kGowPzFHJPh72DRwzBmVggg@mail.gmail.com>	<54991B32.2010105@rempel-privat.de>	<CA+A7n+hbr2ctPkSta9-MWT1opAT2hCB9jYHvFu7N3C_ZvxXSzw@mail.gmail.com>	<5499A391.2060705@rempel-privat.de>	<CA+A7n+iHKBxy3qfjzrnN7GdZhJ-WwoDdi6hjw8RSaDs8TBznvw@mail.gmail.com>	<549E6C1A.7010805@rempel-privat.de>	<CA+A7n+gP6h1HT5F7oDY-SDrrAAjbtTHAtY0683Fe7QdVb7byfQ@mail.gmail.com>	<CA+A7n+jQQNWk2CqoS9QQFODRsi8k4asjWE=5_q681E6PTiQM+A@mail.gmail.com>	<54B69807.9030906@rempel-privat.de>	<CA+A7n+gzarweW+ENOfx+QmCGHy+0Vu6qzPM70cPMxe5FTMwCUw@mail.gmail.com> <CA+A7n+j4dcsRc9yb6PyWAJZD-eUu2SQsy+R_Rk0NbSmfN_RVeA@mail.gmail.com>
In-Reply-To: <CA+A7n+j4dcsRc9yb6PyWAJZD-eUu2SQsy+R_Rk0NbSmfN_RVeA@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="9verM77Lvr761iMKm7R8DAnbqmkxhV41d"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--9verM77Lvr761iMKm7R8DAnbqmkxhV41d
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Am 19.01.2015 um 02:31 schrieb Jeremy Audet:
> No luck. [1] For what it's worth, the TL-WN722N's LEDs did not light
> up after executing `ip link set dev $device up`, so I am pretty sure
> that the `echo none > ...` command worked. I do see that version 1.4
> of the firmware may be released. [2] I can build and install the
> firmware and see what happens. Is that worth doing? I'm not 100% which
> firmware version is provided by your repo. [3]
>=20
> [1] http://www.ichimonji10.name/downloads/2015-01-18.txt
> [2] https://github.com/qca/open-ath9k-htc-firmware/issues/65
> [3] https://github.com/olerem/ath9k-htc-firmware-blob
>=20
> =E2=80=94Jeremy 'Ichimonji10' Audet
>=20

my repo[3] provides latest git build. There is no need to build own FW.

According to the bug which you get, you should update FW:
WARNING: CPU: 1 PID: 559 at drivers/usb/core/urb.c:450
usb_submit_urb+0x265/0x5f0 [usbcore]()
usb 2-4.2: BOGUS urb xfer, pipe 1 !=3D type 3

This part of the log, means: FW restarted with other usb setting which
are not compatible with settings used by kernel. This issue was fixed
for one or two ears in 1.4.

--=20
Regards,
Oleksij


--9verM77Lvr761iMKm7R8DAnbqmkxhV41d
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iF4EAREIAAYFAlS8qeMACgkQHwImuRkmbWmIKgEAgrJrzZuCeZ1PmTkKNIhRfZ3/
6MPv1VIfoK7MMU4vSpAA/3Tqe24MjSM2cjrU5n5UUVJx52hmyZupzDXsYp6N2b0h
=zm38
-----END PGP SIGNATURE-----

--9verM77Lvr761iMKm7R8DAnbqmkxhV41d--
