Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bues.ch ([80.190.117.144]:37148 "EHLO bues.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751014AbbKZMkp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Nov 2015 07:40:45 -0500
Date: Thu, 26 Nov 2015 13:40:30 +0100
From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: zajec5@gmail.com, linux-wireless@vger.kernel.org,
	b43-dev@lists.infradead.org
Subject: Re: (bug report) b43: precendence error
Message-ID: <20151126134030.63bd44aa@wiggum> (sfid-20151126_134047_826433_70B677D0)
In-Reply-To: <20151126115843.GH10556@mwanda>
References: <20151126115843.GH10556@mwanda>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/VbnMQq.R3MdnNh+Gf1ym1T4"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--Sig_/VbnMQq.R3MdnNh+Gf1ym1T4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Thu, 26 Nov 2015 14:58:43 +0300
Dan Carpenter <dan.carpenter@oracle.com> wrote:

> [ All the old wireless Smatch warnings are showing up as new ones
>   because of the path reshuffle in linux-next.  I'm going through and
>   reporting the extra suspicious ones.  -dan ]
>=20
> Hello Rafa=C5=82 Mi=C5=82ecki,
>=20
> The patch 6f98e62a9f1b: "b43: update cordic code to match current
> specs" from Jan 25, 2010, leads to the following static checker
> warning:
>=20
> 	drivers/net/wireless/broadcom/b43/phy_lp.c:1803 lpphy_start_tx_tone()
> 	warn: mask and shift to zero
>=20
> drivers/net/wireless/broadcom/b43/phy_lp.c
>   1800          for (i =3D 0; i < samples; i++) {
>   1801                  sample =3D b43_cordic(angle);
>   1802                  angle +=3D rotation;
>   1803                  buf[i] =3D CORDIC_CONVERT((sample.i * max) & 0xFF=
) << 8;
>   1804                  buf[i] |=3D CORDIC_CONVERT((sample.q * max) & 0xF=
F);
>=20
> Maybe the intention was:
>=20
> 			buf[i] =3D (CORDIC_CONVERT(sample.i * max) & 0xFF) << 8;
> 			buf[i] |=3D CORDIC_CONVERT((sample.q * max) & 0xFF;
>=20
>   1805          }
>   1806 =20


This looks like a bug indeed.
Rafa=C5=82, do you have hw to check this?

 			buf[i] =3D (CORDIC_CONVERT(sample.i * max) & 0xFF) << 8;
 			buf[i] |=3D CORDIC_CONVERT(sample.q * max) & 0xFF;

--=20
Michael

--Sig_/VbnMQq.R3MdnNh+Gf1ym1T4
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWVv2+AAoJEPUyvh2QjYsO4I4QANiK0AzprVzbly8VzBX1yU1A
Vwt9snS96zyGJUowezo45gAJUAZNSeg5h2UN/OOF9RZHEdDHY8CJuiP5OiVNK46C
JOg8vGBWhfs36UeCqYHP0J3NdSuZLjbiEHVt6VqhU/9G626/4rl37a6iiPSFQ71H
izswy6EqdUaTs1GdiTosG6ZfqGRTFxdbUjHBHZRDurueZvi6m0oOn4webM/lGa1y
QbKJOI0ylbVhvQ5AYCHzsO5EYDGqfVBk9/kEH6PZAY4pchra6ImV7JzJVZel6P1c
66FK1Nbo4//de2KsZynfuh0wi9Ldq8qbblSaMTlYumphXSNsNHo5oo/Lj8niaR0E
xmAMVjEwlkqFV7Jro34gWhuZShDT3DEGvNGYNMxmm50NiWOSPT9JFMOpBC08LpYn
IeylXYINNiDg2YJ4SjwlrkPV+JmFCCBZ/qwgbbtJlC1IMmJqG+E7bM3sz2hPlMM3
7B1XcAKmagYzaUcv7j4q6KS9/vLX6hsNXTkGtpyuvudGra7ldEWsZhUHKi9HYyI0
acNwV5AZW1pUJwIcIXt2KNdGr1cOVFDEZ8b4FthnH23oB+8O6+PlWccl/Rn+SNBB
FqXdJxLKC8tFFTpeRa73j+dAIKck6DYBxHUUhahZnZJRFsvzQG8KYOyWeW0Z9eem
XG9oLk3q/ow313kIpirF
=KSgs
-----END PGP SIGNATURE-----

--Sig_/VbnMQq.R3MdnNh+Gf1ym1T4--
