Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:40463 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752022AbZJaFn5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 31 Oct 2009 01:43:57 -0400
Subject: Re: [PATCH 2/2] nl80211: allow to authenticate to access point
 that we already authenticated
From: Johannes Berg <johannes@sipsolutions.net>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"hostap@lists.shmoo.com" <hostap@lists.shmoo.com>
In-Reply-To: <1256939694.31271.16.camel@maxim-laptop>
References: <1256939391.31271.11.camel@maxim-laptop>
	 <1256939694.31271.16.camel@maxim-laptop>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-3EKP84mV1GohqPQBc3ze"
Date: Sat, 31 Oct 2009 06:44:00 +0100
Message-ID: <1256967840.3555.70.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-3EKP84mV1GohqPQBc3ze
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-10-30 at 23:54 +0200, Maxim Levitsky wrote:
> >From 02be2525b95ec3c57323dda1a9e0c6da3a9817e6 Mon Sep 17 00:00:00 2001
> From: Maxim Levitsky <maximlevitsky@gmail.com>
> Date: Fri, 30 Oct 2009 23:50:27 +0200
> Subject: [PATCH 2/2] nl80211: allow to authenticate to access point that =
we already authenticated
>=20
> This is permitted by standards, and used by driver_nl80211 of wpa_supplic=
ant
> Just start new authentication as if we weren't authenticated before

NACK. This leaks the auth request here and in mac80211, so we cannot do
it this simply. Again though, the case you're running into should be
fixed by that wpa_supplicant patch.

johannes

> ---
>  net/wireless/mlme.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>=20
> diff --git a/net/wireless/mlme.c b/net/wireless/mlme.c
> index 83c2a28..3d91b4e 100644
> --- a/net/wireless/mlme.c
> +++ b/net/wireless/mlme.c
> @@ -372,7 +372,7 @@ int __cfg80211_mlme_auth(struct cfg80211_registered_d=
evice *rdev,
>  		if (wdev->auth_bsses[i] &&
>  		    memcmp(bssid, wdev->auth_bsses[i]->pub.bssid,
>  						ETH_ALEN) =3D=3D 0)
> -			return -EALREADY;
> +			wdev->auth_bsses[i] =3D NULL;
>  	}
> =20
>  	memset(&req, 0, sizeof(req));


--=-3EKP84mV1GohqPQBc3ze
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJK686bAAoJEODzc/N7+QmanWQP/RqLRQcJygRXBdKRKqe7T6LQ
zWWMzLdDY+K+bpqOf/oa3gzqHl9z4C4Dey/ElrxQp1SQCUfeKv0l4wYnPDZPNvrp
gAO+iaUZjuBJ9W4ajvIfrFopdBHu9y3jF8z1gaidw2BvGdrwxdIkSUTTCqdeBaaH
S5CNZKtn/yw7jd8UpBKz5kJBA/yfsMYyMMv1mUBKig+66/vXHAlaysqsEmDugG9r
s1qEEgqGwHShUy6g6HrbgK1mlL6csR/e2Q3qraJbCNNJ2p2c7aa0RoxLKmzjeO0B
kq/C4t3uapIUrV0l4UUOJW9rofMWCuOS3pe9kYoWlcEFwu3RGPgWsgZ/+2KkuIN1
gc637LLlKyrjOnoPr6gnCoX3HHi/hxWjt//h+hqNtPjIG9JkXfJJwi3PQD4lFpoe
gISEx9REly9KmCiQw6FjokffIzwltxURrlqXsk7N4pHGXIM40m+vfxG7IZKgPXNV
a8W4qcm8xfk1xHss8nkUkc19VnD4SPden+WbwUlagT0aVZSKUqUOOdN7CXB7Tcba
K9A0h9TQirVmuBcr4u9CLB7kQJO/l0Q8jgDcLHhPyLp+64FWJlrD12C1CnczW9f1
Mt7Rmwr0VT7dAHM3FclKhhf7fg7++Sqf3yr4419JqIvwDqSzYFY3p99z9zakBBGS
GuqLcP2ufsXJ1GrYiZ+F
=HuUU
-----END PGP SIGNATURE-----

--=-3EKP84mV1GohqPQBc3ze--

