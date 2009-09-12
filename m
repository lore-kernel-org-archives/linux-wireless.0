Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:43037 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752360AbZILO4v (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 Sep 2009 10:56:51 -0400
Subject: Re: [PATCH] cfg80211: allow scanning on specified frequencies when
 using wext-compatibility
From: Johannes Berg <johannes@sipsolutions.net>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: John W Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <200909110952.14644.hs4233@mail.mn-solutions.de>
References: <200909091309.55068.hs4233@mail.mn-solutions.de>
	 <1252629664.23427.4.camel@johannes.local>
	 <200909110952.14644.hs4233@mail.mn-solutions.de>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-6YSdcb7zVarSZR1KkFwC"
Date: Sat, 12 Sep 2009 08:56:46 -0600
Message-Id: <1252767406.23427.25.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-6YSdcb7zVarSZR1KkFwC
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-09-11 at 09:52 +0200, Holger Schurig wrote:

> Now, if I want to report an -EINVAL for every possibly invalid=20
> scan-request channel, I'd have to do this:
>=20
>=20
> If scan-request has freqs:
>    Loop over all scan-request freqs
>       Loop over all bands
>          Loop over all channels
>             search for freq
>    if found:
>        Stick channel to scan request
>    else:
>        err =3D -EINVAL
> else:
>    Loop over all bands
>       Loop over all channels
>          Stick channel to scan request
>=20
> This is considerable code-bloat for such a seldom-used function.

Doesn't seem that bad considering that the inner loop is already in an
existing function.

> I'd rather do it like this:
>=20
>=20
> Loop over all bands
>    Loop over all channels
>       If scan-request hasn't this channel freq: continue
>       Stick channel to scan request
> if no channels:
>    err =3D -EINVAL
>=20
> That's a compromise :-)

I guess. I'd still prefer the other way, but it's wext, so I don't
really care :)

johannes


--=-6YSdcb7zVarSZR1KkFwC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKq7arAAoJEODzc/N7+QmaWlYQAJy/uCSh9yga9Of6OvuGnOKc
hNsg4IchqFLxqQQGf+RB3ZDq2KztfTwE1ppSb22u8v4M32e8UtNSy7ggVSCgNvOM
o1h+ryVJ+b39NuacPI6RUCTLwMqNbrJ5AuTSM90hVlxf+6Pst68yZvSCIfoOxq3X
xErRoRqxLqyx9oHiBtj+6P0v4dCK4gxxRXpTBKq4mT71uwxjMhdTuLRKlAEGKnQM
i2YLWKMlqEfoknTsZKxo2wo46wZk68Ur3r5oaDBb2karvkW6M0GX6QEih6THSN6K
1hp8g0J2DelOD05G7uv4+IDusd0zAY7twraxQIVTRxttVtLVvHJ8Kma1VgRTJogc
XR/1GAaszs5qOecJahjVA1HlVuOixNfUCloADIpVOF/YLo2U3WQXxFng/I3L4UBm
eOe41Gtx09wpoIMLVH2cKMSFJMsp+vyUCN5HMr1yB9bKOkcetyQto5GXFdl+NclL
lpvArKop1v3WGedwIr1qxhUk3axcvDowZ1bR+G8K5Ei7aF9JhOylePD64hJPbdZd
OB9S49F5k0LpsX9p9m0efJN7oYv+x1oGGj3SkzSKxMWWb+/dMNNO0FBAc/YZ2b7f
4fm95LwoDytQGoOiPfFJyLGkhjP27EWlNHjXzOXTauzlyqu4eqHPAgBnnhocWvw6
f7nkJh1XQbOiR0qmpfpn
=3Stp
-----END PGP SIGNATURE-----

--=-6YSdcb7zVarSZR1KkFwC--

