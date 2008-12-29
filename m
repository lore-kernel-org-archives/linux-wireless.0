Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:39715 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752463AbYL2Ku4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Dec 2008 05:50:56 -0500
Subject: Re: [PATCH v2] mac80211: make wake/stop_queue_by_reason()
	functions static
From: Johannes Berg <johannes@sipsolutions.net>
To: Kalle Valo <kalle.valo@iki.fi>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20081229080248.29905.35613.stgit@tikku> (sfid-20081229_090256_174706_F66F5E52)
References: <87sko7ikls.fsf@litku.valot.fi>
	 <20081229080248.29905.35613.stgit@tikku>
	 (sfid-20081229_090256_174706_F66F5E52)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-KWI0ufoFhQO7mQ3P5GxP"
Date: Mon, 29 Dec 2008 11:51:17 +0100
Message-Id: <1230547877.3116.9.camel@johannes> (sfid-20081229_115101_290321_17498429)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-KWI0ufoFhQO7mQ3P5GxP
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-12-29 at 10:02 +0200, Kalle Valo wrote:
> Fixes sparse warnings:
>=20
> net/mac80211/util.c:355:6: warning: symbol
>   'ieee80211_wake_queue_by_reason' was not declared. Should it be static?
> net/mac80211/util.c:385:6: warning: symbol
>   'ieee80211_stop_queue_by_reason' was not declared. Should it be static?
>=20
> Thanks to Johannes Berg for reporting this.
>=20
> Signed-off-by: Kalle Valo <kalle.valo@iki.fi>

Acked-by: Johannes Berg <johannes@sipsolutions.net>

Your discussion was a little quirky though; they weren't exported to
drivers by listing them in ieee80211_i.h, and we might well want to use
them in other parts of mac80211 later (and will just make them
non-static at that point)

> ---
>=20
>  net/mac80211/util.c |    8 ++++----
>  1 files changed, 4 insertions(+), 4 deletions(-)
>=20
> diff --git a/net/mac80211/util.c b/net/mac80211/util.c
> index fb89e1d..5cd4303 100644
> --- a/net/mac80211/util.c
> +++ b/net/mac80211/util.c
> @@ -352,8 +352,8 @@ static void __ieee80211_wake_queue(struct ieee80211_h=
w *hw, int queue,
>  	}
>  }
> =20
> -void ieee80211_wake_queue_by_reason(struct ieee80211_hw *hw, int queue,
> -				    enum queue_stop_reason reason)
> +static void ieee80211_wake_queue_by_reason(struct ieee80211_hw *hw, int =
queue,
> +					   enum queue_stop_reason reason)
>  {
>  	struct ieee80211_local *local =3D hw_to_local(hw);
>  	unsigned long flags;
> @@ -382,8 +382,8 @@ static void __ieee80211_stop_queue(struct ieee80211_h=
w *hw, int queue,
>  	netif_stop_subqueue(local->mdev, queue);
>  }
> =20
> -void ieee80211_stop_queue_by_reason(struct ieee80211_hw *hw, int queue,
> -				    enum queue_stop_reason reason)
> +static void ieee80211_stop_queue_by_reason(struct ieee80211_hw *hw, int =
queue,
> +					   enum queue_stop_reason reason)
>  {
>  	struct ieee80211_local *local =3D hw_to_local(hw);
>  	unsigned long flags;
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20

--=-KWI0ufoFhQO7mQ3P5GxP
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJWKujAAoJEKVg1VMiehFYWqEP/2XZBp0LU4eNU7V2Zn/k2Hcb
ExxX8X10hRAHiGBZzWRn+2C8nvuCch3Km9rwEZ9OZt8kx/2tpKL+acXkGjrDbmCm
VI5DZeFT8LQ5w2rm9bmUZBXnPTD2BcEhm3TIgmyrXdkN7KhiTjizz0u83RpZh9FV
+6/EVtfuIPfghxa5AEn/bxky4i1DKLVodIwa4UP2ZUyiBQ+y7IR8HCFJGopwdio9
8nIikl6RvqCdv8qJdAhs4xCUv6J5bvtuPWWp4ZysxXM1DfhivUxrG5zoXHH1ZVUI
o6rckqdalBtWSbVRBySVHErr4Nz6gSICs39gRoRrFTa8AFERf+ouvaa4smWbasBh
yMc9TYMv6U5Ycn33vs08Js/1AtK1PsOrbaNDdQ428A4jD401EAKJ1vgjSY/VSih7
BWpi/ZwwmRAszVqqEz0LAOPRyrhCYjCfHPJ3P7Sh0A+7B5pHyLwwEAzHpri21wBQ
Jik2ghMRp9PhqCP4+EXdhIsSBz3QvDg4w6Mb+jkxu5dkapthEyVygwoD3I+9QhVh
YdPBoB2D1DhZycJdNVMaan5FO/EwPEQVu2gXUp/HEn1huZzMHZ4DoMwvhLP1wwm3
MX9jQT0HxEX+ZJgqVvlLoBW1WQoDFh0WziArSp7E/QH52e4YgHT+ZMA1+/f56L60
QGCA2A4i0v4nD/cvujG1
=J2Lk
-----END PGP SIGNATURE-----

--=-KWI0ufoFhQO7mQ3P5GxP--

