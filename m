Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:60644 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760487AbZAHM5x (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Jan 2009 07:57:53 -0500
Subject: Re: [PATCH 2/6] cfg80211: make handle_band() and handle_channel()
	wiphy specific
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1231379017-28363-3-git-send-email-lrodriguez@atheros.com>
References: <1231379017-28363-1-git-send-email-lrodriguez@atheros.com>
	 <1231379017-28363-2-git-send-email-lrodriguez@atheros.com>
	 <1231379017-28363-3-git-send-email-lrodriguez@atheros.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-tTdhccT/O0/rB3OIGGnc"
Date: Thu, 08 Jan 2009 13:58:49 +0100
Message-Id: <1231419529.3685.2.camel@johannes> (sfid-20090108_135816_595009_E9FD9CD9)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-tTdhccT/O0/rB3OIGGnc
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-01-07 at 17:43 -0800, Luis R. Rodriguez wrote:
> This allows us to make more wiphy specific judgements when
> handling the channels later on.
>=20
> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>

Acked-by: Johannes Berg <johannes@sipsolutions.net>

> ---
>  net/wireless/reg.c |   25 +++++++++++++++++++------
>  1 files changed, 19 insertions(+), 6 deletions(-)
>=20
> diff --git a/net/wireless/reg.c b/net/wireless/reg.c
> index 2f2ba92..87b3011 100644
> --- a/net/wireless/reg.c
> +++ b/net/wireless/reg.c
> @@ -778,13 +778,22 @@ static int freq_reg_info(u32 center_freq, u32 *band=
width,
>  	return !max_bandwidth;
>  }
> =20
> -static void handle_channel(struct ieee80211_channel *chan)
> +static void handle_channel(struct wiphy *wiphy, enum ieee80211_band band=
,
> +			   unsigned int chan_idx)
>  {
>  	int r;
> -	u32 flags =3D chan->orig_flags;
> +	u32 flags;
>  	u32 max_bandwidth =3D 0;
>  	const struct ieee80211_reg_rule *reg_rule =3D NULL;
>  	const struct ieee80211_power_rule *power_rule =3D NULL;
> +	struct ieee80211_supported_band *sband;
> +	struct ieee80211_channel *chan;
> +
> +	sband =3D wiphy->bands[band];
> +	BUG_ON(chan_idx >=3D sband->n_channels);
> +	chan =3D &sband->channels[chan_idx];
> +
> +	flags =3D chan->orig_flags;
> =20
>  	r =3D freq_reg_info(MHZ_TO_KHZ(chan->center_freq),
>  		&max_bandwidth, &reg_rule);
> @@ -808,12 +817,16 @@ static void handle_channel(struct ieee80211_channel=
 *chan)
>  		chan->max_power =3D (int) MBM_TO_DBM(power_rule->max_eirp);
>  }
> =20
> -static void handle_band(struct ieee80211_supported_band *sband)
> +static void handle_band(struct wiphy *wiphy, enum ieee80211_band band)
>  {
> -	int i;
> +	unsigned int i;
> +	struct ieee80211_supported_band *sband;
> +
> +	BUG_ON(!wiphy->bands[band]);
> +	sband =3D wiphy->bands[band];
> =20
>  	for (i =3D 0; i < sband->n_channels; i++)
> -		handle_channel(&sband->channels[i]);
> +		handle_channel(wiphy, band, i);
>  }
> =20
>  static bool ignore_reg_update(struct wiphy *wiphy, enum reg_set_by setby=
)
> @@ -840,7 +853,7 @@ void wiphy_update_regulatory(struct wiphy *wiphy, enu=
m reg_set_by setby)
>  	enum ieee80211_band band;
>  	for (band =3D 0; band < IEEE80211_NUM_BANDS; band++) {
>  		if (wiphy->bands[band])
> -			handle_band(wiphy->bands[band]);
> +			handle_band(wiphy, band);
>  	}
>  	if (wiphy->reg_notifier)
>  		wiphy->reg_notifier(wiphy, setby);

--=-tTdhccT/O0/rB3OIGGnc
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJZfiHAAoJEKVg1VMiehFYRbQP/ihQ4LWXcnr38pIB/4Gf5iM8
svPnTRFRTo2F0zc+NkMfQWNKN1W33zcgaxKWil9Eu6IYYpmOx2H/ZbpBhk89gfLw
hElypICoB5LwYJ9MzDYDcxascryj2emBcFN0fSmD9SudQpBQDOdOpMn8dlUFT8+M
YvTjj57s8cJDxolIy1p4D+qwHbhEsjrCHwUShMQwveOEz/a7NYlXKeGv7fcI60AL
5fKOSeZr7PbrZV1ir71LbStM8cIirqlK6FD4DIf1earuHuB9zH7bdt8gC++73GYv
Hlu1uAl8eazFyPq+an3eBRuSJ0QUWdrgp+H99p2m+Z8NgiHLClgYiuCBykm+iD79
NfDWpk6xQfyw/Zoe69cCUJbXFQhk0FqBQ+6cTiGrQUc+Tk9J6vjg4G+6nljKasEo
AVM1lQn7GW1RE47jKCsWM5+hRW8ft+Ok9EhjVFRE8On6e9z2EeLf5IA9hVNNMWrp
n9PT3VK1qGCA9eiQlmjR/W9E0o1KTZeHKoGP6cSdiI04RGGUKAliWBXZ25634et1
6dBYmk2SSpoTP321cwNGSU15Pxe51JfXZAVhZYVl1ttcCuDs9DMFWOcXqSlyZsBF
ZnTP75u6OJYCAmUewbmmrhBsVlLG8+zQa3wgzyZiZ354L7znW+E8DMRKYE0PFMoz
e4TlVMu3FEqrSeOMii2V
=0+Ft
-----END PGP SIGNATURE-----

--=-tTdhccT/O0/rB3OIGGnc--

