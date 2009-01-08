Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:46010 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753391AbZAHNCR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Jan 2009 08:02:17 -0500
Subject: Re: [PATCH 5/6] cfg80211: Fix regression with 11d on bands
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1231379017-28363-6-git-send-email-lrodriguez@atheros.com>
References: <1231379017-28363-1-git-send-email-lrodriguez@atheros.com>
	 <1231379017-28363-2-git-send-email-lrodriguez@atheros.com>
	 <1231379017-28363-3-git-send-email-lrodriguez@atheros.com>
	 <1231379017-28363-4-git-send-email-lrodriguez@atheros.com>
	 <1231379017-28363-5-git-send-email-lrodriguez@atheros.com>
	 <1231379017-28363-6-git-send-email-lrodriguez@atheros.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-jnYIUSCmHDJGkgD/iZ91"
Date: Thu, 08 Jan 2009 14:03:14 +0100
Message-Id: <1231419794.3685.10.camel@johannes> (sfid-20090108_140222_042381_BC5BB064)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-jnYIUSCmHDJGkgD/iZ91
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-01-07 at 17:43 -0800, Luis R. Rodriguez wrote:
> This fixes a regression on disallowing bands introduced with the new
> 802.11d support. The issue is that IEEE-802.11 allows APs to send
> a subset of what a country regulatory domain defines. This was clarified
> in this document:
>=20
> http://tinyurl.com/11d-clarification

I think you should give the full link, regardless of how long it is.
It's just on the 802 docserver, no?

> As such it is possible, and this is what is done in practice, that a
> single band 2.4 GHz AP will only send 2.4 GHz band regulatory information
> through the 802.11 country information element and then the current
> intersection with what CRDA provided yields a regulatory domain with
> no 5 GHz information -- even though that country may actually allow
> 5 GHz operation. We correct this by only applying the intersection rules
> on a channel if the the intersection yields a regulatory rule on the
> same band the channel is on.

Seems sane to me.

> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>

Acked-by: Johannes Berg <johannes@sipsolutions.net>

> ---
>  net/wireless/reg.c |   77 ++++++++++++++++++++++++++++++++++++++++++++++=
++++-
>  1 files changed, 75 insertions(+), 2 deletions(-)
>=20
> diff --git a/net/wireless/reg.c b/net/wireless/reg.c
> index 3d56a1d..bea98ed 100644
> --- a/net/wireless/reg.c
> +++ b/net/wireless/reg.c
> @@ -421,6 +421,31 @@ static u32 freq_max_bandwidth(const struct ieee80211=
_freq_range *freq_range,
>  	return 0;
>  }
> =20
> +/**
> + * freq_in_rule_band - tells us if a frequency is in a frequency band
> + * @freq_range: frequency rule we want to query
> + * @freq_khz: frequency we are inquiring about
> + *
> + * This lets us know if a specific frequency rule is or is not relevant =
to
> + * a specific frequency's band. Bands are device specific and artificial
> + * definitions (the "2.4 GHz band" and the "5 GHz band"), however it is
> + * safe for now to assume that a frequency rule should not be part of a
> + * frequency's band if the start freq or end freq are off by more than 2=
 GHz.
> + * This resolution can be lowered and should be considered as we add
> + * regulatory rule support for other "bands".
> + **/
> +static bool freq_in_rule_band(const struct ieee80211_freq_range *freq_ra=
nge,
> +	u32 freq_khz)
> +{
> +#define ONE_GHZ_IN_KHZ	1000000
> +	if (abs(freq_khz - freq_range->start_freq_khz) <=3D (2 * ONE_GHZ_IN_KHZ=
))
> +		return true;
> +	if (abs(freq_khz - freq_range->end_freq_khz) <=3D (2 * ONE_GHZ_IN_KHZ))
> +		return true;
> +	return false;
> +#undef ONE_GHZ_IN_KHZ
> +}
> +
>  /* Converts a country IE to a regulatory domain. A regulatory domain
>   * structure has a lot of information which the IE doesn't yet have,
>   * so for the other values we use upper max values as we will intersect
> @@ -753,11 +778,19 @@ static u32 map_regdom_flags(u32 rd_flags)
>   * a given wireless device. If the device has a specific regulatory doma=
in
>   * it wants to follow we respect that unless a country IE has been recei=
ved
>   * and processed already.
> + *
> + * Returns 0 if it was able to find a valid regulatory rule which does
> + * apply to the given center_freq otherwise it returns non-zero. It will
> + * also return -ERANGE if we determine the given center_freq does not ev=
en have
> + * a regulatory rule for a frequency range in the center_freq's band. Se=
e
> + * freq_in_rule_band() for our current definition of a band -- this is p=
urely
> + * subjective and right now its 802.11 specific.
>   */
>  static int freq_reg_info(struct wiphy *wiphy, u32 center_freq, u32 *band=
width,
>  			 const struct ieee80211_reg_rule **reg_rule)
>  {
>  	int i;
> +	bool band_rule_found =3D false;
>  	const struct ieee80211_regdomain *regd;
>  	u32 max_bandwidth =3D 0;
> =20
> @@ -780,7 +813,15 @@ static int freq_reg_info(struct wiphy *wiphy, u32 ce=
nter_freq, u32 *bandwidth,
>  		rr =3D &regd->reg_rules[i];
>  		fr =3D &rr->freq_range;
>  		pr =3D &rr->power_rule;
> +
> +		/* We only need to know if one frequency rule was
> +		 * was in center_freq's band, that's enough, so lets
> +		 * not overwrite it once found */
> +		if (!band_rule_found)
> +			band_rule_found =3D freq_in_rule_band(fr, center_freq);
> +
>  		max_bandwidth =3D freq_max_bandwidth(fr, center_freq);
> +
>  		if (max_bandwidth && *bandwidth <=3D max_bandwidth) {
>  			*reg_rule =3D rr;
>  			*bandwidth =3D max_bandwidth;
> @@ -788,6 +829,9 @@ static int freq_reg_info(struct wiphy *wiphy, u32 cen=
ter_freq, u32 *bandwidth,
>  		}
>  	}
> =20
> +	if (!band_rule_found)
> +		return -ERANGE;
> +
>  	return !max_bandwidth;
>  }
> =20
> @@ -812,8 +856,37 @@ static void handle_channel(struct wiphy *wiphy, enum=
 ieee80211_band band,
>  		&max_bandwidth, &reg_rule);
> =20
>  	if (r) {
> -		flags |=3D IEEE80211_CHAN_DISABLED;
> -		chan->flags =3D flags;
> +		/* This means no regulatory rule was found in the country IE
> +		 * with a frequency range on the center_freq's band, since
> +		 * IEEE-802.11 allows for a country IE to have a subset of the
> +		 * regulatory information provided in a country we ignore
> +		 * disabling the channel unless at least one reg rule was
> +		 * found on the center_freq's band. For details see this
> +		 * clarification:
> +		 *
> +		 * http://tinyurl.com/11d-clarification
> +		 */
> +		if (r =3D=3D -ERANGE &&
> +		    last_request->initiator =3D=3D REGDOM_SET_BY_COUNTRY_IE) {
> +#ifdef CONFIG_CFG80211_REG_DEBUG
> +			printk(KERN_DEBUG "cfg80211: Leaving channel %d MHz "
> +				"intact on %s - no rule found in band on "
> +				"Country IE\n",
> +				chan->center_freq, wiphy_name(wiphy));
> +#endif
> +		} else {
> +		/* In this case we know the country IE has at least one reg rule
> +		 * for the band so we respect its band definitions */
> +#ifdef CONFIG_CFG80211_REG_DEBUG
> +			if (last_request->initiator =3D=3D REGDOM_SET_BY_COUNTRY_IE)
> +				printk(KERN_DEBUG "cfg80211: Disabling "
> +					"channel %d MHz on %s due to "
> +					"Country IE\n",
> +					chan->center_freq, wiphy_name(wiphy));
> +#endif
> +			flags |=3D IEEE80211_CHAN_DISABLED;
> +			chan->flags =3D flags;
> +		}
>  		return;
>  	}
> =20

--=-jnYIUSCmHDJGkgD/iZ91
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJZfmPAAoJEKVg1VMiehFY0/4P/RxUoLqyV2jLS4WDFAS56wtb
oMG7e1aju7tbcHu+JunGKsziNyamg9y52ecawadWaWHxpfh2+bwt4u7tVX2d23VA
080HYJOsVP0xd26tPOtwjzSytNpKerxZKMfpRKjzZCiSSXoNzNbYQkmBKjv+vrtD
yi27/5fK883OSZ+Equx6Y4bvJysE/sb6bOpNFSufZBhF3FM+iFZH44B3lZoP+ne/
Tf0JuEHQra5Wq8AwZpBn7rq3Rdo764eqdvYHQfqMMfapvQcqg7jgUQiw7WSHzYS+
DEwsJvDj1OcC3BTn2Pih3IvwBnQ2ofkfUa/IdVig8DyuHdbF6EW9EAEdvU6GNOWi
6pXXI0Ww+8Sa8OhkBKZNkFfrbUft+dTj+V9lV1anbB7bDjD2XEXxpW30vRgctEZV
teO4LT7FN3VisE0RC5/X7/Tf+FyBpyLt5lqxsOPeLoD6eQEPkn59ruw04xkrmlE7
ZRP4uaSvAGNDOBD7KctRb4EMtKglniQsbMsrw4mbNq3PXJ5lpmE8RAtSle3CKmBf
HiCrYctFFkN/T3JyKncHBYhPADK8hxee7oQBHmEbox2fIn00mclacVsHgu94u8kN
OaoiKkv4RuGghC3ckOuNVrPp4C/iJQ9ud8HLbcj3Z+CFt2U1If4YHiJ9zfiCfAi4
8lkt60OeYFIbMxfYjJgP
=b3Mh
-----END PGP SIGNATURE-----

--=-jnYIUSCmHDJGkgD/iZ91--

