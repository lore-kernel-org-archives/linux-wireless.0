Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:46329 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755413AbYKEMAz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Nov 2008 07:00:55 -0500
Subject: Re: [PATCH 4/7] cfg80211: separate intersection section in
	__set_regdom()
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1225853406-16322-5-git-send-email-lrodriguez@atheros.com>
References: <1225853406-16322-1-git-send-email-lrodriguez@atheros.com>
	 <1225853406-16322-2-git-send-email-lrodriguez@atheros.com>
	 <1225853406-16322-3-git-send-email-lrodriguez@atheros.com>
	 <1225853406-16322-4-git-send-email-lrodriguez@atheros.com>
	 <1225853406-16322-5-git-send-email-lrodriguez@atheros.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-PbC8SMETE02QBqR1e+JQ"
Date: Wed, 05 Nov 2008 13:00:56 +0100
Message-Id: <1225886456.3619.82.camel@johannes.berg> (sfid-20081105_130057_550524_EDA04074)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-PbC8SMETE02QBqR1e+JQ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-11-04 at 18:50 -0800, Luis R. Rodriguez wrote:
> So far the __set_regdom() code is pretty generic as the
> intersection case is fairly straight forward; this will however
> change when 802.11d support is added so lets separate intersection
> code for now in preparation for 802.11d support.
>=20
> This patch only has slight functional changes.
>=20
> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>

Acked-by: Johannes Berg <johannes@sipsolutions.net>

> ---
>  net/wireless/reg.c |   29 +++++++++++++++++++++--------
>  1 files changed, 21 insertions(+), 8 deletions(-)
>=20
> diff --git a/net/wireless/reg.c b/net/wireless/reg.c
> index 290ecec..845e2d3 100644
> --- a/net/wireless/reg.c
> +++ b/net/wireless/reg.c
> @@ -826,10 +826,6 @@ static int __set_regdom(const struct ieee80211_regdo=
main *rd)
>  	if (WARN_ON(!reg_is_valid_request(rd->alpha2)))
>  		return -EINVAL;
> =20
> -	reset_regdomains();
> -
> -	/* Country IE parsing coming soon */
> -
>  	if (!is_valid_rd(rd)) {
>  		printk(KERN_ERR "cfg80211: Invalid "
>  			"regulatory domain detected:\n");
> @@ -837,16 +833,33 @@ static int __set_regdom(const struct ieee80211_regd=
omain *rd)
>  		return -EINVAL;
>  	}
> =20
> -	if (unlikely(last_request->intersect)) {
> +	if (!last_request->intersect) {
> +		reset_regdomains();
> +		cfg80211_regdomain =3D rd;
> +		return 0;
> +	}
> +
> +	/* Intersection requires a bit more work */
> +
> +	if (last_request->initiator !=3D REGDOM_SET_BY_COUNTRY_IE) {
> +
>  		intersected_rd =3D regdom_intersect(rd, cfg80211_regdomain);
>  		if (!intersected_rd)
>  			return -EINVAL;
> +
> +		/* We can trash what CRDA provided now */
>  		kfree(rd);
> -		rd =3D intersected_rd;
> +		rd =3D NULL;
> +
> +		reset_regdomains();
> +		cfg80211_regdomain =3D intersected_rd;
> +
> +		return 0;
>  	}
> =20
> -	/* Tada! */
> -	cfg80211_regdomain =3D rd;
> +	/* Country IE parsing coming soon */
> +	reset_regdomains();
> +	WARN_ON(1);
> =20
>  	return 0;
>  }

--=-PbC8SMETE02QBqR1e+JQ
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJEYr0AAoJEKVg1VMiehFY9AQP/3vY+xF29x84+dFku7vNiF07
z+Fefqd+nKectCM2bMol1KZUqJtaU9DhhdqzGB4Jou0ty/u0rth77A5rnkgNwvAJ
5bK+UGk4g0JttgLC+hWBrxkQZaK3FCYGpZo270XQFZewRQQy+t93CaIa+CgWNg3r
//41u9LqpRfxdUaWwfQo5ws+VTTQ8WS9J0AsNiZSkWikHNNAsNsPKN1CVbzJQW0/
w+jGTK0PMJzmm8bIIOorYOT/yEQt7XEb+O+2Femgs1cHVPPl/k87nR57JzXJRfjH
ogEEj4rV6LfFEbWsujGFugkPxHtH/NLh2ejPZxOiTv34MOnckhWj1a7qeunrLtf1
tdDIN54zV2EljIQr7YImv5ThHyWbo7uJ06h1Byl7Q7DRpw15i/bQfvlHDIa/omw+
rX9oqiyAQwwOMdm1CxHZGnDUfBFC4rCrELYi9Rcf+5/2eY3Rkm/rUR8X3/RFYTrJ
I/EelO8sRy/89miHUNXWEa7OZQO3fw+yhEzN2x0uXCcW94nxZOmooNRCkS1v9JzT
N8sdb+pjL13s+poRGkFBXELHY49DrWOZ5rW3wUQQwAFox+SjdnFJ/i3v4SY4pZCp
JgwybpBlyngi65t8cllodRdIOpA4lRsV60WkMSO0DcxSvFyEtiNyNAi2nzEfZROX
peia+H5zk65T6zOwDxMv
=cIyX
-----END PGP SIGNATURE-----

--=-PbC8SMETE02QBqR1e+JQ--

