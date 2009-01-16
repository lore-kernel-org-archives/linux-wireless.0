Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:44828 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751753AbZAPJYV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Jan 2009 04:24:21 -0500
Subject: Re: [PATCH 07/13] cfg80211: only export disable flag on channel
	disablement
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1232064746-17134-8-git-send-email-lrodriguez@atheros.com>
References: <1232064746-17134-1-git-send-email-lrodriguez@atheros.com>
	 <1232064746-17134-2-git-send-email-lrodriguez@atheros.com>
	 <1232064746-17134-3-git-send-email-lrodriguez@atheros.com>
	 <1232064746-17134-4-git-send-email-lrodriguez@atheros.com>
	 <1232064746-17134-5-git-send-email-lrodriguez@atheros.com>
	 <1232064746-17134-6-git-send-email-lrodriguez@atheros.com>
	 <1232064746-17134-7-git-send-email-lrodriguez@atheros.com>
	 <1232064746-17134-8-git-send-email-lrodriguez@atheros.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Np4nashr1hgSEozMclhi"
Date: Fri, 16 Jan 2009 10:23:47 +0100
Message-Id: <1232097827.3854.25.camel@johannes> (sfid-20090116_102426_801706_072226B5)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Np4nashr1hgSEozMclhi
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-01-15 at 16:12 -0800, Luis R. Rodriguez wrote:
> When a channel is disabled there is no need to stuff it
> with more flags.

> -	u32 flags;
> +	u32 flags, rule_flags;
>  	u32 max_bandwidth =3D 0;
>  	const struct ieee80211_reg_rule *reg_rule =3D NULL;
>  	const struct ieee80211_power_rule *power_rule =3D NULL;
> @@ -913,15 +913,19 @@ static void handle_channel(struct wiphy *wiphy, enu=
m ieee80211_band band,
>  					"Country IE\n",
>  					chan->center_freq, wiphy_name(wiphy));
>  #endif
> -			flags |=3D IEEE80211_CHAN_DISABLED;
> -			chan->flags =3D flags;
> +			chan->flags =3D IEEE80211_CHAN_DISABLED;
>  		}
>  		return;
>  	}
> =20
>  	power_rule =3D &reg_rule->power_rule;
> =20
> -	chan->flags =3D flags | map_regdom_flags(reg_rule->flags);
> +	rule_flags =3D map_regdom_flags(reg_rule->flags);
> +	if (flags & IEEE80211_CHAN_DISABLED)
> +		chan->flags =3D IEEE80211_CHAN_DISABLED;
> +	else
> +		chan->flags =3D flags | rule_flags;

but why bother with more complicated code when adding a few more flags
doesn't hurt?

johannes

--=-Np4nashr1hgSEozMclhi
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJcFIYAAoJEKVg1VMiehFY3DQP/0oEM+xFr41QA+6zUWC2HNJg
4bE312WnKv2IrREwODJq0y2i6HDkwwYjXfZ23IRQUNm04SwwDaIgp7+zOQ7L7Mi3
AxBfBXnMsDHnrjhIRw5MAR9rwbiE05a0wF5MTMYZneJ7TIWYKUpRJ5L5xG1G26SN
crApklpI47cpaGCW4AD9svPRxdCwCqMB8DHwAtsaf9iOzWbUuwKr1nMrBRPNNTnN
XD2I9s+aH/mKcuCaT/yI7EuX9x92HjvlTGgxULpW3B91EuF8IivRsQo2IO9a5226
4T3yCwSJPYUvS/ey5VC3dpzaRaWotSPqICu9Yak0SDw/2yr8jXuzXKLLiMdOE5qz
KoopAHJ/5FuCv+B1TamZEbUtxhdoElBvJhcg8TsaguLMTgKTzXL4I89rXpq9kouM
Y2LVbqzf6/YtBB+qnMD9sRkOs+NtvMYnQfSLLIj8ySgyjTrGIu50+m2FzGpAgpQJ
HsGFP+HeNjO3mrR4+ncipBJYr0VjVNntAEMYl8ZpZkp6K1TZZ3qQAcTHDTDQbn4w
a3qld7wumbBkpIWZu25p80n36aetNmJ1QM166nFQaDtsA+p/vyr/FoJlwB5MKy9P
N976IGjJ1664WmnUNV9Urk3WhwRlcHq11AVDyKBLtZKTKBRVEPkRHU95Z40YGARb
Vl/u3LjXx1oadLd9LMIH
=13AG
-----END PGP SIGNATURE-----

--=-Np4nashr1hgSEozMclhi--

