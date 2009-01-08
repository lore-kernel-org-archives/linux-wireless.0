Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:60624 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760179AbZAHM5U (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Jan 2009 07:57:20 -0500
Subject: Re: [PATCH 1/6] cfg80211: call reg_notifier() once
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1231379017-28363-2-git-send-email-lrodriguez@atheros.com>
References: <1231379017-28363-1-git-send-email-lrodriguez@atheros.com>
	 <1231379017-28363-2-git-send-email-lrodriguez@atheros.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-ZGNgQrwsfd4k7/KzLRVr"
Date: Thu, 08 Jan 2009 13:58:12 +0100
Message-Id: <1231419492.3685.0.camel@johannes> (sfid-20090108_135742_226075_276830E3)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-ZGNgQrwsfd4k7/KzLRVr
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-01-07 at 17:43 -0800, Luis R. Rodriguez wrote:
> We are calling the reg_notifier() callback per band, this is
> not necessary, just call it once.
>=20
> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>

Acked-by: Johannes Berg <johannes@sipsolutions.net>

> ---
>  net/wireless/reg.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/net/wireless/reg.c b/net/wireless/reg.c
> index 4f87753..2f2ba92 100644
> --- a/net/wireless/reg.c
> +++ b/net/wireless/reg.c
> @@ -841,9 +841,9 @@ void wiphy_update_regulatory(struct wiphy *wiphy, enu=
m reg_set_by setby)
>  	for (band =3D 0; band < IEEE80211_NUM_BANDS; band++) {
>  		if (wiphy->bands[band])
>  			handle_band(wiphy->bands[band]);
> -		if (wiphy->reg_notifier)
> -			wiphy->reg_notifier(wiphy, setby);
>  	}
> +	if (wiphy->reg_notifier)
> +		wiphy->reg_notifier(wiphy, setby);
>  }
> =20
>  /* Return value which can be used by ignore_request() to indicate

--=-ZGNgQrwsfd4k7/KzLRVr
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJZfhhAAoJEKVg1VMiehFYMbsP/3Pf69LQPQKM5YvoF29GUdEz
ib0SqewtiuAZalKNAwS9RCMMP79bYhu8wELu1YCDNHi8EOM1UnnKsuUeJowL8g8o
2EQzvY7C/qR2mQPbfns3v7V5HWQsFqkeVBI3ksgAs97RXVSApVfmWtN/QzA8E84B
pHEFmfuihJra76IZMaMnmeDaqO8vVJ/PZBPr/G0XTgHAlKtQiNQPY9A4rEJgWbFs
WXEA3KGBB/6qTgkRRP9wU/9gCiFHQJskqHw3CQmni2oc5fIIAiUKoBp9gijKFWOI
by5kYhIciqL79NTjQhra8gKf1v1hVX374eTbY/1YflZRRnE8uSaAiWM0ByQG/AaT
SfHu9MK4Fsvp2LRvr1Dk/mGSq9WOcvMJ4KeBP6lo8rcHe4TwVZY0/QQ8029t1HpL
8Sf3YzSfmqAVh356CLwa8Uroh55cemene7EA+C1hCG9Pu9ySr/2Lp7jMiERA4ET4
36SViI/PKZPzz3gguVWZ19XOjNILfN6CYNhYzB7eaTKXvODBgMCO5hHU7PNmXRlf
UVDtkZ5u3UQlV05opOohS3HbmsuTwBiGya8rwzFsIdAzB6MCyytwd02Xjf7PN1Kk
Aqz3YgM2Qph1yN/kq+cEBVZx9XJqkkq7OaoeKdd49kqs5P0ngBTt57FPmb9vu6NT
XEm4tUrjkfbAdxTURAP9
=/Dvr
-----END PGP SIGNATURE-----

--=-ZGNgQrwsfd4k7/KzLRVr--

