Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:41324 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752277AbYKZLXA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Nov 2008 06:23:00 -0500
Subject: Re: [RFC] nl80211: Add frequency configuration (including HT40)
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: Sujith <m.sujith@gmail.com>, linux-wireless@vger.kernel.org
In-Reply-To: <20081126083841.GC31499@jm.kir.nu>
References: <20081125190533.GA27879@jm.kir.nu>
	 <20081126083841.GC31499@jm.kir.nu>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-6cAStchEl5r1oDnQ5HCT"
Date: Wed, 26 Nov 2008 12:04:24 +0100
Message-Id: <1227697465.4613.95.camel@johannes.berg> (sfid-20081126_122313_245322_BB2DA0AA)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-6cAStchEl5r1oDnQ5HCT
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-11-26 at 10:38 +0200, Jouni Malinen wrote:
> On Tue, Nov 25, 2008 at 09:05:33PM +0200, Jouni Malinen wrote:
> > This patch adds new NL80211_CMD_SET_WIPHY attributes
> > NL80211_ATTR_WIPHY_FREQ and NL80211_ATTR_WIPHY_SEC_CHAN_OFFSET to allow
> > userspace to set the operating channel (e.g., hostapd for AP mode).
>=20
> This version addresses the feedback I received by adding regulatory
> enforcement in net/wireless/nl80211.c and mechanism for indicating
> non-HT vs. HT20. In addition, the ht_enable/sec_chan_offset values are
> now handled similarly to local->oper_channel to avoid changing
> parameters for scan.

Thanks. A few other things that I just thought of:

> @@ -26,8 +26,9 @@
>   * @NL80211_CMD_GET_WIPHY: request information about a wiphy or dump req=
uest
>   *	to get a list of all present wiphys.
>   * @NL80211_CMD_SET_WIPHY: set wiphy parameters, needs %NL80211_ATTR_WIP=
HY or
> - *	%NL80211_ATTR_IFINDEX; can be used to set %NL80211_ATTR_WIPHY_NAME
> - *	and/or %NL80211_ATTR_WIPHY_TXQ_PARAMS.
> + *	%NL80211_ATTR_IFINDEX; can be used to set %NL80211_ATTR_WIPHY_NAME,
> + *	%NL80211_ATTR_WIPHY_TXQ_PARAMS, %NL80211_ATTR_WIPHY_FREQ, and/or
> + *	%NL80211_ATTR_WIPHY_SEC_CHAN_OFFSET.
>   * @NL80211_CMD_NEW_WIPHY: Newly created wiphy, response to get request
>   *	or rename notification. Has attributes %NL80211_ATTR_WIPHY and
>   *	%NL80211_ATTR_WIPHY_NAME.
> @@ -180,6 +181,12 @@
>   *	/sys/class/ieee80211/<phyname>/index
>   * @NL80211_ATTR_WIPHY_NAME: wiphy name (used for renaming)
>   * @NL80211_ATTR_WIPHY_TXQ_PARAMS: a nested array of TX queue parameters
> + * @NL80211_ATTR_WIPHY_FREQ: frequency of the selected channel in MHz
> + * @NL80211_ATTR_WIPHY_SEC_CHAN_OFFSET: included with NL80211_ATTR_WIPHY=
_FREQ
> + *	if HT20 or HT40 are allowed (i.e., 802.11n disabled if not included):

It's also possible to explicitly give the _NO_HT value too.

> + *	NL80211_SEC_CHAN_DISABLED =3D HT20 only
> + *	NL80211_SEC_CHAN_BELOW =3D secondary channel is below the primary cha=
nnel
> + *	NL80211_SEC_CHAN_ABOVE =3D secondary channel is above the primary cha=
nnel


> + *
> + * @set_channel: Set channel (freq =3D frequency in MHz, sec_chan_offset=
:
> + *	0 =3D HT40 disabled; 1 =3D HT40 enabled, secondary channel above prim=
ary;
> + *	-1 =3D HT40 enabled, secondary channel below primary)
>   */
>  struct cfg80211_ops {
>  	int	(*add_virtual_intf)(struct wiphy *wiphy, char *name,
> @@ -513,6 +517,9 @@
> =20
>  	int	(*set_txq_params)(struct wiphy *wiphy,
>  				  struct ieee80211_txq_params *params);
> +
> +	int	(*set_channel)(struct wiphy *wiphy, int freq, bool ht_enabled,
> +			       int sec_chan_offset);

I wonder if we shouldn't simply pass in the enum nl80211_sec_chan_offset
value here, that seems easier to understand when you're looking at the
whole thing from userspace down to a possible non-mac80211 driver. Not
that I think that'll ever happen, but still? It might even make sense to
use that value within mac80211's driver API at some point, instead of
the enabled / +/-1 thing.
=20
> +static int ieee80211_set_channel(struct wiphy *wiphy, int freq,
> +				 bool ht_enabled, int sec_chan_offset)
> +{
> +	struct ieee80211_local *local =3D wiphy_priv(wiphy);
> +	struct ieee80211_channel *chan;
> +
> +	chan =3D ieee80211_get_channel(local->hw.wiphy, freq);
> +	if (!chan)
> +		return -EINVAL;
> +
> +	local->oper_channel =3D chan;
> +	local->oper_ht_enabled =3D ht_enabled;
> +	local->oper_sec_chan_offset =3D sec_chan_offset;

And you could even store the enum here, and translate it only in
_hw_config.

> +	[NL80211_ATTR_WIPHY_FREQ] =3D { .type =3D NLA_U32 },
> +	[NL80211_ATTR_WIPHY_SEC_CHAN_OFFSET] =3D { .type =3D NLA_U8 },

I think it's more "normal" to use a u32 for an enum although I don't
think we'll ever add anything, so I guess it doesn't actually matter.

> +		freq =3D nla_get_u32(info->attrs[NL80211_ATTR_WIPHY_FREQ]);
> +		chan =3D ieee80211_get_channel(&rdev->wiphy, freq);


> +		result =3D rdev->ops->set_channel(&rdev->wiphy, freq, ht_enabled,
> +						sec_chan_offset);

would it make sense to pass in 'chan'? mac80211 will do the lookup
again, and if a driver doesn't it can just use chan->center_freq.

johannes

--=-6cAStchEl5r1oDnQ5HCT
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJLS0zAAoJEKVg1VMiehFYYTAP/jRuImeclYAm+OChuOiSpbSy
yIWK9sRoqWPZupQzjh/OUTuYdk/oTREveXcDjqMBd1mdE6kT9EsXg//RKsyHvpOP
VEks34/Fe5XEzlTq9uC8IsRVmvxaX8BBaKQiKU18uoN6HtTCvklhffWXNEBUOMit
0/qVovy8+TzLwM5eIMTgylbn8qWf/wwEwppHEaZMd6fEeWsuatqDjXpDkcVT4iQj
Cmr2cK0nTZeDPcyapdwOH6RVGWjRpl9XUBsARyAHV+TWDDYlTEEQ/cnnZyJOhDjv
yivluXlEKA2Fhzygp3JWdwMUIfd/p60PyZR84IgPUtfJ4/8ViG14J1jFrp27tZ89
oAEvwCT9x6XAy72eO8FYEGQeO+YG9iER2idHWP6t92w+w9RyygPXZkM5/4r8afYf
8cywPQtWo/sdhSverjwTzgS65tc7g3Zp7WM2w5qQPmG1dbGm8PHDTumU6JiWpUA2
vP2FgZBRybrRJ0zU2U0wsNPQ0N2mdaDm8sQRID7iyuh9EecYNqdeMimG24IXPFUV
09by5mhe6bZT5/EfC2uIG+S9HnYGiPWqJA7Axyo0DMosFlsNuO7NmeFebrr7baPD
fgzQtYxzUZVVr51yIDLrhU6WmY9m84GLKn9fSRFNXk045wB+O385sQg7iTJdP0X+
Sb/3rBUYxngd+b5CI39J
=d7lA
-----END PGP SIGNATURE-----

--=-6cAStchEl5r1oDnQ5HCT--

