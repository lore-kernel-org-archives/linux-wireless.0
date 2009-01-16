Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:44881 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755084AbZAPJZy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Jan 2009 04:25:54 -0500
Subject: Re: [PATCH 08/13] cfg80211: save original values on regulatory
	hints
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1232064746-17134-9-git-send-email-lrodriguez@atheros.com>
References: <1232064746-17134-1-git-send-email-lrodriguez@atheros.com>
	 <1232064746-17134-2-git-send-email-lrodriguez@atheros.com>
	 <1232064746-17134-3-git-send-email-lrodriguez@atheros.com>
	 <1232064746-17134-4-git-send-email-lrodriguez@atheros.com>
	 <1232064746-17134-5-git-send-email-lrodriguez@atheros.com>
	 <1232064746-17134-6-git-send-email-lrodriguez@atheros.com>
	 <1232064746-17134-7-git-send-email-lrodriguez@atheros.com>
	 <1232064746-17134-8-git-send-email-lrodriguez@atheros.com>
	 <1232064746-17134-9-git-send-email-lrodriguez@atheros.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-NH3xOPEcBzKH7yFflKVo"
Date: Fri, 16 Jan 2009 10:25:21 +0100
Message-Id: <1232097921.3854.28.camel@johannes> (sfid-20090116_102558_914151_D24EE3C8)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-NH3xOPEcBzKH7yFflKVo
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-01-15 at 16:12 -0800, Luis R. Rodriguez wrote:
> When a driver issues a regulatory_hint() lets save the received
> values as original channel settings. This allows users to change
> regulatory domains multiple times while always respecting the driver's
> own regulatory setings.

This definitely isn't the right way to do things here. This means that
my card that's programmed to US can never do channel 13 here, something
which on b43 we definitely want to allow.

> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
> ---
>  net/wireless/reg.c |   10 ++++++++++
>  1 files changed, 10 insertions(+), 0 deletions(-)
>=20
> diff --git a/net/wireless/reg.c b/net/wireless/reg.c
> index 499bbbe..f0ad937 100644
> --- a/net/wireless/reg.c
> +++ b/net/wireless/reg.c
> @@ -914,6 +914,9 @@ static void handle_channel(struct wiphy *wiphy, enum =
ieee80211_band band,
>  					chan->center_freq, wiphy_name(wiphy));
>  #endif
>  			chan->flags =3D IEEE80211_CHAN_DISABLED;
> +			if (last_request->initiator =3D=3D REGDOM_SET_BY_DRIVER &&
> +			    last_request->wiphy && last_request->wiphy =3D=3D wiphy)
> +				chan->orig_flags =3D chan->flags;
>  		}
>  		return;
>  	}
> @@ -934,6 +937,13 @@ static void handle_channel(struct wiphy *wiphy, enum=
 ieee80211_band band,
>  			(int) MBM_TO_DBM(power_rule->max_eirp));
>  	else
>  		chan->max_power =3D (int) MBM_TO_DBM(power_rule->max_eirp);
> +
> +	if (last_request->initiator =3D=3D REGDOM_SET_BY_DRIVER &&
> +	    last_request->wiphy && last_request->wiphy =3D=3D wiphy) {
> +		chan->orig_flags =3D chan->flags;
> +		chan->orig_mag =3D chan->max_antenna_gain;
> +		chan->orig_mpwr =3D chan->max_power;
> +	}
>  }
> =20
>  static void handle_channel_custom(struct wiphy *wiphy,

--=-NH3xOPEcBzKH7yFflKVo
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJcFJ/AAoJEKVg1VMiehFY6VoP/3SUUZhdCYWUitiYh/hUsNMA
kdTuFafDSJ1YP4ZuaSFexGGz8+ruMYhPh6PE6gEo7roqg7JtVtySwsMc8B6EIBN7
qLfPGlkMOALXGue8s9Amwx0D6psnYbpxdmmU3CebH/8vBPVNVkHqbPYTGaeYu51y
YSGe2Xfp4ndPwfRzYzJ92Jx8VoRaE6x8nSdUC13Ij86ZWaPkBFRP3HDx/QhJbDYf
aBoewfqTN73Ta4DvtifblDE1yXY70ylwRT6110Am8LqVBtzeyd06q27xNEFTqtAi
jEp8+00ajMKCq4gqcQaHSH0bEEdhDIJFW0vWVEZG7+77bOQ6PCzLoZPkV+W+ZzZT
zgP8QRTQFgWsf5KL/ujwnb/00w+/Lsg3XZGKxrP3FlmnSA7+NQFuwMk5YT1s5Usf
BculnW4Krt5/URaUcentaBmx4jWzeOUbbd4MWk3VROMjzM6HDhRH+tv9eAS1ghnO
poFFK2t7XNkQM99f/+KMeZfuMqXm7vtnHtm6x+BvLx5Oa6oYjqCk0fjRpz9GKta/
T/KfpN3yT5cvuMIoO+umvfeNdJW/9Y2qGAhgA7SnAfo0GUdSYcKs+ig2GKyfzTmz
Tetbiw28WM2r3RKSjZcK3ONKyntmXpAJ2futz2/kVLvkwYP7NGDR3nMdSPsqx1/8
QWaLX38nHG+ccEyq1oVY
=theG
-----END PGP SIGNATURE-----

--=-NH3xOPEcBzKH7yFflKVo--

