Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:39157 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751097AbZAPJVb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Jan 2009 04:21:31 -0500
Subject: Re: [PATCH 03/13] cfg80211: add wiphy_apply_custom_regulatory()
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1232064746-17134-4-git-send-email-lrodriguez@atheros.com>
References: <1232064746-17134-1-git-send-email-lrodriguez@atheros.com>
	 <1232064746-17134-2-git-send-email-lrodriguez@atheros.com>
	 <1232064746-17134-3-git-send-email-lrodriguez@atheros.com>
	 <1232064746-17134-4-git-send-email-lrodriguez@atheros.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-xw3PSLOSoFNAIvWkS4hR"
Date: Fri, 16 Jan 2009 10:20:59 +0100
Message-Id: <1232097659.3854.20.camel@johannes> (sfid-20090116_102136_918575_4C90B696)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-xw3PSLOSoFNAIvWkS4hR
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-01-15 at 16:12 -0800, Luis R. Rodriguez wrote:

>  /**
>   * enum reg_set_by - Indicates who is trying to set the regulatory domai=
n
> + * @REGDOM_SET_BY_PROBE: regulatory domain applied came prior to wiphy
> + * 	registration by the driver itself using some custom regulatory
> + * 	information.

This is unnecessary, I think.

> +/**
> + * freq_reg_info - get regulatory information for the given frequency
> + * @wiphy: the wiphy for which we want to process this rule for
> + * @center_freq: Frequency in KHz for which we want regulatory informati=
on for
> + * @bandwidth: the bandwidth requirement you have in KHz, if you do not =
have one
> + * 	you can set this to 0. If this frequency is allowed we then set
> + * 	this value to the maximum allowed bandwidth.
> + * @reg_rule: the regulatory rule which we have for this frequency
> + *
> + * Use this function to get the regulatory rule for a specific frequency=
 on
> + * a given wireless device. If the device has a specific regulatory doma=
in
> + * it wants to follow we respect that unless a country IE has been recei=
ved
> + * and processed already.
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
> + */
> +static int freq_reg_info(struct wiphy *wiphy, u32 center_freq, u32 *band=
width,
> +			 const struct ieee80211_reg_rule **reg_rule)
> +{
> +	return freq_reg_info_regd(wiphy, center_freq,
> +		bandwidth, reg_rule, NULL);
> +}

Are you not using this or am I just not seeing the user?

> +static void handle_channel_custom(struct wiphy *wiphy,
> +				  enum ieee80211_band band,
> +				  unsigned int chan_idx,
> +				  const struct ieee80211_regdomain *regd)
> +{
> +	int r;
> +	u32 max_bandwidth =3D 0;
> +	const struct ieee80211_reg_rule *reg_rule =3D NULL;
> +	const struct ieee80211_power_rule *power_rule =3D NULL;
> +	struct ieee80211_supported_band *sband;
> +	struct ieee80211_channel *chan;
> +
> +	sband =3D wiphy->bands[band];
> +	BUG_ON(chan_idx >=3D sband->n_channels);
> +	chan =3D &sband->channels[chan_idx];
> +
> +	r =3D freq_reg_info_regd(wiphy, MHZ_TO_KHZ(chan->center_freq),
> +		&max_bandwidth, &reg_rule, regd);
> +
> +	if (r) {
> +		chan->flags =3D IEEE80211_CHAN_DISABLED;
> +		return;
> +	}
> +
> +	power_rule =3D &reg_rule->power_rule;
> +
> +	chan->flags |=3D map_regdom_flags(reg_rule->flags);
> +	chan->max_antenna_gain =3D (int) MBI_TO_DBI(power_rule->max_antenna_gai=
n);
> +	chan->max_bandwidth =3D KHZ_TO_MHZ(max_bandwidth);
> +	chan->max_power =3D (int) MBM_TO_DBM(power_rule->max_eirp);
> +}
> +
> +
>  static void handle_band(struct wiphy *wiphy, enum ieee80211_band band)
>  {
>  	unsigned int i;
> @@ -947,6 +989,19 @@ static void handle_band(struct wiphy *wiphy, enum ie=
ee80211_band band)
>  		handle_channel(wiphy, band, i);
>  }
> =20
> +static void handle_band_custom(struct wiphy *wiphy, enum ieee80211_band =
band,
> +			       const struct ieee80211_regdomain *regd)
> +{
> +	unsigned int i;
> +	struct ieee80211_supported_band *sband;
> +
> +	BUG_ON(!wiphy->bands[band]);
> +	sband =3D wiphy->bands[band];
> +
> +	for (i =3D 0; i < sband->n_channels; i++)
> +		handle_channel_custom(wiphy, band, i, regd);
> +}
> +
>  static bool ignore_reg_update(struct wiphy *wiphy, enum reg_set_by setby=
)
>  {
>  	if (!last_request)
> @@ -977,6 +1032,20 @@ void wiphy_update_regulatory(struct wiphy *wiphy, e=
num reg_set_by setby)
>  		wiphy->reg_notifier(wiphy, setby);
>  }
> =20
> +/* Used by drivers prior to wiphy registration */
> +void wiphy_apply_custom_regulatory(struct wiphy *wiphy,
> +				   const struct ieee80211_regdomain *regd)
> +{
> +	enum ieee80211_band band;
> +	for (band =3D 0; band < IEEE80211_NUM_BANDS; band++) {
> +		if (wiphy->bands[band])
> +			handle_band_custom(wiphy, band, regd);
> +	}
> +	if (wiphy->reg_notifier)
> +		wiphy->reg_notifier(wiphy, REGDOM_SET_BY_PROBE);
> +}
> +EXPORT_SYMBOL(wiphy_apply_custom_regulatory);

Can you group all these functions together, rather than interspersing
them with the others? Also, I don't think calling the notifier is
appropriate since the driver just called this function.

johannes

--=-xw3PSLOSoFNAIvWkS4hR
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJcFF4AAoJEKVg1VMiehFYpj4P/0EyYHFuiSC6HxQDiQqvLEED
i8TvtcMy/B7LgdplhhvFO0pYXvW9Z1qrCAGVo9aopauw42a9w1Mq43m/HI30UXiO
39Om32xyB/pnjtIj3KMuz83C9A9aHA0X2vUwF88dn5Y7E+saB6T+TgtsKV+T5vlr
zr5jXEiV5RzXwk21i5ktUDnBCcvM8iLFMOMqA1x/DOuNXF1/rCT4uP6UazbXT/Tx
1duUQYzIUfhbvf4gG9S3RVfkhbJhKbgG1G5hN9U5D8IlPRCHymVz38eWRo+zOUh+
Q6SkBC+Ud1IYUk/BjIvWisPxJjDPaC0kqkTv1yWU3KF7z6sPjApSnwRwiZ/pL8AF
mEQk+7huMtetlRuLofNFN7F1X4gEUktJUwzZ8kTa0A7GkGk6Pi3yccoCqP5MSzuN
9t+O1OZezIvqf5Hpuj+xePy9zMJmnRp6n49wsALPc2bZb30aUjeFy5LUDYDigie6
yM5JLCrk/Db8YQR6+NxVcweQoe1mP8NoSXojKLudDjRuIvRkxGobakZ256fjoSpT
6q0GpVbtFlHOYjaekyeSN8FKw/4UpQXHJvB5joFm7HW/oLBR3N9Tv6Ud1tRePMsB
hHt1RgutfGUcBdCR/S5DupKjlzxljViIzJvwxqyBwvaiYvtiqZupngFhl8VV4vAA
Pe5/BnUpPGYz1sQNClyW
=2+md
-----END PGP SIGNATURE-----

--=-xw3PSLOSoFNAIvWkS4hR--

