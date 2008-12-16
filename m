Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:38099 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750983AbYLPUnO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Dec 2008 15:43:14 -0500
Subject: Re: [PATCH] mac80211: fix an error in ieee80211_send_assoc()
	method.
From: Johannes Berg <johannes@sipsolutions.net>
To: Rami Rosen <ramirose@gmail.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <eb3ff54b0812161238y1ffdff2blf383e5354fdd5232@mail.gmail.com> (sfid-20081216_213837_081698_0C74E741)
References: <eb3ff54b0812161238y1ffdff2blf383e5354fdd5232@mail.gmail.com>
	 (sfid-20081216_213837_081698_0C74E741)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-f18mrPQFt3+DiTgd+oM8"
Date: Tue, 16 Dec 2008 21:43:11 +0100
Message-Id: <1229460192.4471.50.camel@johannes.berg> (sfid-20081216_214318_506800_90BF34D6)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-f18mrPQFt3+DiTgd+oM8
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-12-16 at 22:38 +0200, Rami Rosen wrote:
> This patch fixes an error in ieee80211_send_assoc(), net/mac80211/mlme.c.
>=20
> The error is usage of a wrong member when building
> the ie80211 management frame (it should be assoc_req, and not reassoc_req=
).
>=20
> This error is due to commit ea95bba41e69c616bb1512cf59d22f33266b8568,
> which dealt with configuring a listen interval , from Jul 18, 2008.

> -		mgmt->u.reassoc_req.listen_interval =3D
> +		mgmt->u.assoc_req.listen_interval =3D
>  				cpu_to_le16(local->hw.conf.listen_interval);

Seems fine, but, uh, it's not a bug.

johannes

--=-f18mrPQFt3+DiTgd+oM8
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJSBLcAAoJEKVg1VMiehFYrzsP/jBguJAxSgSCBeqmHsVbp1C7
wZH4LWkwZsU9n4CzcVwJQkWgTdDgv4SPVLv7GKsekLHk0Kj8Ks/h+4Lp4HocBI42
qb1gzYhpTqixL/QdViGptejwsLoSXpx/IPb5T8RbdxYmjatQj++zMwfWSWpGX4WS
oBQlSi0Va4bGwdGeYSt7WM4iY5Z77MPNzkcdn7HN69NXf3FjmLuL/b2wJk5AI5W9
jrN2FSDTUAlPAVdq8Q+5Vt6Ishn6WW8rvgZ5lEv+haFlAOcbwEA4HAf88z5j7k4k
VMMLw57Gbozz79KNjNgsGiW8CmjgJz3BSB2g4G5HDV4e2Z0UkMueZOmeE/6WQJJ3
YwmSWAvHQOh49DdT6+/MGe4QpDCVKYmlyi7O7HHUGzVHUNmvTZ+E2d5SVwRiYpZf
SiMXAtT7q6VyeWDiyQ4mLe8KGwm2IpX1nCUgoOb7yv1JcPkSZkGErpGTGCEMp+qm
q+MM7OtvldGjFzfe/EKeUkCQOAeUwyDxOdsVqUwWyzqQREKDh0hf2mqF2lofSUcA
kVEg/Y1S4VutbgxRX4kJxzqB7xLbbBTSkaK0Vh3X4HY/fL9oKR6ypo6vcBTA2lPA
XCqe2wFiU8So3JWyLnnAdA4j68eJihzGLRBQsaSTSN81CqeeMkd5h2XhmcFhIi5l
BldPT8zrIlt2b8Rj8AOV
=Comg
-----END PGP SIGNATURE-----

--=-f18mrPQFt3+DiTgd+oM8--

