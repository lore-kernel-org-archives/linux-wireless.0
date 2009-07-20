Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:34756 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751846AbZGTKes (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Jul 2009 06:34:48 -0400
Subject: Re: [PATCH 1/5] cfg80211: set_default_key only for WEP
From: Johannes Berg <johannes@sipsolutions.net>
To: Zhu Yi <yi.zhu@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1248061667-8614-2-git-send-email-yi.zhu@intel.com>
References: <1248061667-8614-1-git-send-email-yi.zhu@intel.com>
	 <1248061667-8614-2-git-send-email-yi.zhu@intel.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-GEULKHNUvspws8GhCp9S"
Date: Mon, 20 Jul 2009 12:34:44 +0200
Message-Id: <1248086084.4204.7.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-GEULKHNUvspws8GhCp9S
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-07-20 at 11:47 +0800, Zhu Yi wrote:
> We invoke the cfg80211 set_default_key callback only for WEP key
> configuring.
>=20
> Signed-off-by: Zhu Yi <yi.zhu@intel.com>

Acked-by: Johannes Berg <johannes@sipsolutions.net>

> ---
>  net/wireless/wext-compat.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
>=20
> diff --git a/net/wireless/wext-compat.c b/net/wireless/wext-compat.c
> index aa80c0c..c63e10e 100644
> --- a/net/wireless/wext-compat.c
> +++ b/net/wireless/wext-compat.c
> @@ -531,7 +531,8 @@ static int __cfg80211_set_encryption(struct cfg80211_=
registered_device *rdev,
>  			wdev->wext.keys->data[idx];
>  	}
> =20
> -	if (params->cipher !=3D WLAN_CIPHER_SUITE_AES_CMAC &&
> +	if ((params->cipher =3D=3D WLAN_CIPHER_SUITE_WEP40 ||
> +	     params->cipher =3D=3D WLAN_CIPHER_SUITE_WEP104) &&
>  	    (tx_key || (!addr && wdev->wext.default_key =3D=3D -1))) {
>  		if (wdev->current_bss)
>  			err =3D rdev->ops->set_default_key(&rdev->wiphy,

--=-GEULKHNUvspws8GhCp9S
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKZEhAAAoJEODzc/N7+QmapK4QAMRIKye19cY765i50gSfEJwm
PIn6JJzYqZ0lgYVhtpgvIS+f3/prC+6rPwkfCGWKC78DbeYIDLbnqjQv4o95B1lJ
saG0d4sfPgYu74oEIdc3JEHyGQ/nJ1uiDckBBZtXK//bRvH+k6D5ytkHbxlfnUKC
V8hp/l9TpxP5NCp2wXP8IyTI6TgXMA2QEwyU7GNlr2CVoQyfBYxQNo2afSvUGzdA
d12hXG87IRKdUGRNIWDMvzsn3drHPwdtutNX3W4CLHZA/+NV0vE/2wWDgXn7XUvG
SdTA9z2DQIHPIl7egyZ5gfkXTM/BPJ+9/5OsNr7P65/SsHVYsSVwFuAQX49lw3+o
vq1v01OEx/9sKEeG7k9f4BnkbcNNNPuxkXN+m1unIHHqkpUnSzQxTabG0XNUtxYO
hlygvZAHsN9YTnn/9hXn9cn+k3uwsSnxU1rwKNtqB9do2i1yPnHFZtMXTSMy3xwS
4m1ZOo/Xn/eRE2KhdDz1WLldxTqjvZmNaz2I47kGWAErTLsQdg4BK2jV9igd6/br
k0kGw+F5hBQ9UlGdvzln2Tux06JK3b/Ak9h7QsiL910z1w2CK+w94yKNQDWK6Weo
Q8GRpLqIkhL8VUq38qaysueVrt3VfI4FT/zC65x/zT1phm+W7iyz7P2dsB8v8EVQ
7NbWn+E32IxvqZnlqOnv
=lNrV
-----END PGP SIGNATURE-----

--=-GEULKHNUvspws8GhCp9S--

