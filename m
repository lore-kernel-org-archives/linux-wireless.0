Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:54491 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750757AbbEPFna (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 May 2015 01:43:30 -0400
Message-ID: <5556D8F4.5010509@rempel-privat.de> (sfid-20150516_074408_607250_39DCB500)
Date: Sat, 16 May 2015 07:43:16 +0200
From: Oleksij Rempel <linux@rempel-privat.de>
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: ath9k-devel@qca.qualcomm.com, kvalo@codeaurora.org,
	linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net
Subject: Re: [PATCH] ath9k: add phy.c
References: <1431693340-8861-1-git-send-email-linux@rempel-privat.de>	 <1431714904.15709.24.camel@perches.com> <5556D546.6010703@rempel-privat.de> <1431754580.15709.55.camel@perches.com>
In-Reply-To: <1431754580.15709.55.camel@perches.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="T1k2Ueu7lVLkedIKOfJOJT4JvdasAVGJI"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--T1k2Ueu7lVLkedIKOfJOJT4JvdasAVGJI
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Am 16.05.2015 um 07:36 schrieb Joe Perches:
> On Sat, 2015-05-16 at 07:27 +0200, Oleksij Rempel wrote:
>=20
>> Am 15.05.2015 um 20:35 schrieb Joe Perches:
>>> On Fri, 2015-05-15 at 14:35 +0200, Oleksij Rempel wrote:
>>>> ... and move dup code from ar5008_phy.c and ar9002_phy.c to phy.c
>>> []
>>>> diff --git a/drivers/net/wireless/ath/ath9k/phy.c b/drivers/net/wire=
less/ath/ath9k/phy.c
>>>
>>>> +void phy_hw_spur_mitigate(struct ath_hw *ah,
>>>> +			  struct ath9k_channel *chan, int bin)
>>>> +{
> []
>>>> +	static int inc[4] =3D { 0, 100, 0, 0 };
>>>
>>> static const
>=20
>> This is cleanup patch, no fixes optimisations
>> or regressions should be introduced.
>=20
> Hello Oleksij.
>=20
> One of the old compilation units (ar9002_phy.c) had const on
> all those arrays, the other did not.

ok, thanks. changed to const version.

> const should be used here.
>=20
>> If you see some problems in this
>> code, you are welcome to provide a patch on top of this one :)
>=20
> I think you should take comments on the patches you submit.

What do you mean?

--=20
Regards,
Oleksij


--T1k2Ueu7lVLkedIKOfJOJT4JvdasAVGJI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iF4EAREIAAYFAlVW2PgACgkQHwImuRkmbWlo1AEAkCWUzIofvcU04AAKTPUcVRAA
CfVwgd+qU8WwQNhewDYA/1VyfmyE7qdtE49D3oinUSayN4/gfdyOL5AZTrEdefok
=WAHB
-----END PGP SIGNATURE-----

--T1k2Ueu7lVLkedIKOfJOJT4JvdasAVGJI--
