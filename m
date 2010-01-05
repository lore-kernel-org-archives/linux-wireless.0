Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:45079 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750716Ab0AEJjx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jan 2010 04:39:53 -0500
Subject: Re: [PATCH 3/3] nl80211: New command for setting TX rate mask for
 rate control
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <jouni.malinen@atheros.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, Jouni Malinen <j@w1.fi>
In-Reply-To: <20091229105945.GD18493@jm.kir.nu>
References: <20091229105945.GD18493@jm.kir.nu>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-Pg3GRo/dn12PGVwvGeDz"
Date: Tue, 05 Jan 2010 10:39:46 +0100
Message-ID: <1262684386.20098.20.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Pg3GRo/dn12PGVwvGeDz
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-12-29 at 12:59 +0200, Jouni Malinen wrote:
> plain text document attachment (nl80211-rc-rate-mask.patch)
> Add a new NL80211_CMD_SET_TX_BITRATE_MASK command and related
> attributes to provide support for setting TX rate mask for rate
> control. This uses the existing cfg80211 set_bitrate_mask operation
> that was previously used only with WEXT compat code (SIOCSIWRATE). The
> nl80211 command allows more generic configuration of allowed rates as
> a mask instead of fixed/max rate.
>=20
> Signed-off-by: Jouni Malinen <jouni.malinen@atheros.com>

Looks fine.

Acked-by: Johannes Berg <johannes@sipsolutions.net>

> ---
>  include/linux/nl80211.h |   44 +++++++++++++++++++
>  include/net/cfg80211.h  |    4 -
>  net/wireless/nl80211.c  |  111
> ++++++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 157 insertions(+), 2 deletions(-)
>=20
> --- wireless-testing.orig/include/linux/nl80211.h	2009-12-29
> 10:50:56.000000000 +0200
> +++ wireless-testing/include/linux/nl80211.h	2009-12-29
> 10:56:42.000000000 +0200
> @@ -295,6 +295,10 @@
>   *	This command is also used as an event to notify when a requested
>   *	remain-on-channel duration has expired.
>   *
> + * @NL80211_CMD_SET_TX_BITRATE_MASK: Set the mask of rates to be used
> in TX
> + *	rate selection. %NL80211_ATTR_IFINDEX is used to specify the
> interface
> + *	and @NL80211_ATTR_TX_RATES the set of allowed rates.
> + *
>   * @NL80211_CMD_MAX: highest used command number
>   * @__NL80211_CMD_AFTER_LAST: internal use
>   */
> @@ -381,6 +385,8 @@ enum nl80211_commands {
>  	NL80211_CMD_REMAIN_ON_CHANNEL,
>  	NL80211_CMD_CANCEL_REMAIN_ON_CHANNEL,
> =20
> +	NL80211_CMD_SET_TX_BITRATE_MASK,
> +
>  	/* add new commands above here */
> =20
>  	/* used to define NL80211_CMD_MAX below */
> @@ -638,6 +644,13 @@ enum nl80211_commands {
>   *
>   * @NL80211_ATTR_COOKIE: Generic 64-bit cookie to identify objects.
>   *
> + * @NL80211_ATTR_TX_RATES: Nested set of attributes
> + *	(enum nl80211_tx_rate_attributes) describing TX rates per band.
> The
> + *	enum nl80211_band value is used as the index (nla_type() of the
> nested
> + *	data. If a band is not included, it will be configured to allow
> all
> + *	rates based on negotiated supported rates information. This
> attribute
> + *	is used with %NL80211_CMD_SET_TX_BITRATE_MASK.
> + *
>   * @NL80211_ATTR_MAX: highest attribute number currently defined
>   * @__NL80211_ATTR_AFTER_LAST: internal use
>   */
> @@ -779,6 +792,8 @@ enum nl80211_attrs {
> =20
>  	NL80211_ATTR_COOKIE,
> =20
> +	NL80211_ATTR_TX_RATES,
> +
>  	/* add attributes here, update the policy in nl80211.c */
> =20
>  	__NL80211_ATTR_AFTER_LAST,
> @@ -1478,4 +1493,33 @@ enum nl80211_key_attributes {
>  	NL80211_KEY_MAX =3D __NL80211_KEY_AFTER_LAST - 1
>  };
> =20
> +/**
> + * enum nl80211_tx_rate_attributes - TX rate set attributes
> + * @__NL80211_TXRATE_INVALID: invalid
> + * @NL80211_TXRATE_LEGACY: Legacy (non-MCS) rates allowed for TX rate
> selection
> + *	in an array of rates as defined in IEEE 802.11 7.3.2.2 (u8 values
> with
> + *	1 =3D 500 kbps) but without the IE length restriction (at most
> + *	%NL80211_MAX_SUPP_RATES in a single array).
> + * @__NL80211_TXRATE_AFTER_LAST: internal
> + * @NL80211_TXRATE_MAX: highest TX rate attribute
> + */
> +enum nl80211_tx_rate_attributes {
> +	__NL80211_TXRATE_INVALID,
> +	NL80211_TXRATE_LEGACY,
> +
> +	/* keep last */
> +	__NL80211_TXRATE_AFTER_LAST,
> +	NL80211_TXRATE_MAX =3D __NL80211_TXRATE_AFTER_LAST - 1
> +};
> +
> +/**
> + * enum nl80211_band - Frequency band
> + * @NL80211_BAND_2GHZ - 2.4 GHz ISM band
> + * @NL80211_BAND_5GHZ - around 5 GHz band (4.9 - 5.7 GHz)
> + */
> +enum nl80211_band {
> +	NL80211_BAND_2GHZ,
> +	NL80211_BAND_5GHZ,
> +};
> +
>  #endif /* __LINUX_NL80211_H */
> --- wireless-testing.orig/net/wireless/nl80211.c	2009-12-29
> 10:50:57.000000000 +0200
> +++ wireless-testing/net/wireless/nl80211.c	2009-12-29
> 10:57:37.000000000 +0200
> @@ -143,6 +143,7 @@ static struct nla_policy nl80211_policy[
>  				 .len =3D WLAN_PMKID_LEN },
>  	[NL80211_ATTR_DURATION] =3D { .type =3D NLA_U32 },
>  	[NL80211_ATTR_COOKIE] =3D { .type =3D NLA_U64 },
> +	[NL80211_ATTR_TX_RATES] =3D { .type =3D NLA_NESTED },
>  };
> =20
>  /* policy for the attributes */
> @@ -572,6 +573,7 @@ static int nl80211_send_wiphy(struct sk_
>  	CMD(del_pmksa, DEL_PMKSA);
>  	CMD(flush_pmksa, FLUSH_PMKSA);
>  	CMD(remain_on_channel, REMAIN_ON_CHANNEL);
> +	CMD(set_bitrate_mask, SET_TX_BITRATE_MASK);
>  	if (dev->wiphy.flags & WIPHY_FLAG_NETNS_OK) {
>  		i++;
>  		NLA_PUT_U32(msg, i, NL80211_CMD_SET_WIPHY_NETNS);
> @@ -4423,6 +4425,109 @@ static int nl80211_cancel_remain_on_chan
>  	return err;
>  }
> =20
> +static u32 rateset_to_mask(struct ieee80211_supported_band *sband,
> +			   u8 *rates, u8 rates_len)
> +{
> +	u8 i;
> +	u32 mask =3D 0;
> +
> +	for (i =3D 0; i < rates_len; i++) {
> +		int rate =3D (rates[i] & 0x7f) * 5;
> +		int ridx;
> +		for (ridx =3D 0; ridx < sband->n_bitrates; ridx++) {
> +			struct ieee80211_rate *srate =3D
> +				&sband->bitrates[ridx];
> +			if (rate =3D=3D srate->bitrate) {
> +				mask |=3D 1 << ridx;
> +				break;
> +			}
> +		}
> +		if (ridx =3D=3D sband->n_bitrates)
> +			return 0; /* rate not found */
> +	}
> +
> +	return mask;
> +}
> +
> +static struct nla_policy
> +nl80211_txattr_policy[NL80211_TXRATE_MAX + 1] __read_mostly =3D {
> +	[NL80211_TXRATE_LEGACY] =3D { .type =3D NLA_BINARY,
> +				    .len =3D NL80211_MAX_SUPP_RATES },
> +};
> +
> +static int nl80211_set_tx_bitrate_mask(struct sk_buff *skb,
> +				       struct genl_info *info)
> +{
> +	struct nlattr *tb[NL80211_TXRATE_MAX + 1];
> +	struct cfg80211_registered_device *rdev;
> +	struct cfg80211_bitrate_mask mask;
> +	int err, rem, i;
> +	struct net_device *dev;
> +	struct nlattr *tx_rates;
> +	struct ieee80211_supported_band *sband;
> +
> +	if (info->attrs[NL80211_ATTR_TX_RATES] =3D=3D NULL)
> +		return -EINVAL;
> +
> +	rtnl_lock();
> +
> +	err =3D get_rdev_dev_by_info_ifindex(info, &rdev, &dev);
> +	if (err)
> +		goto unlock_rtnl;
> +
> +	if (!rdev->ops->set_bitrate_mask) {
> +		err =3D -EOPNOTSUPP;
> +		goto unlock;
> +	}
> +
> +	memset(&mask, 0, sizeof(mask));
> +	/* Default to all rates enabled */
> +	for (i =3D 0; i < IEEE80211_NUM_BANDS; i++) {
> +		sband =3D rdev->wiphy.bands[i];
> +		mask.control[i].legacy =3D
> +			sband ? (1 << sband->n_bitrates) - 1 : 0;
> +	}
> +
> +	/*
> +	 * The nested attribute uses enum nl80211_band as the index. This
> maps
> +	 * directly to the enum ieee80211_band values used in cfg80211.
> +	 */
> +	nla_for_each_nested(tx_rates, info->attrs[NL80211_ATTR_TX_RATES],
> rem)
> +	{
> +		enum ieee80211_band band =3D nla_type(tx_rates);
> +		if (band < 0 || band >=3D IEEE80211_NUM_BANDS) {
> +			err =3D -EINVAL;
> +			goto unlock;
> +		}
> +		sband =3D rdev->wiphy.bands[band];
> +		if (sband =3D=3D NULL) {
> +			err =3D -EINVAL;
> +			goto unlock;
> +		}
> +		nla_parse(tb, NL80211_TXRATE_MAX, nla_data(tx_rates),
> +			  nla_len(tx_rates), nl80211_txattr_policy);
> +		if (tb[NL80211_TXRATE_LEGACY]) {
> +			mask.control[band].legacy =3D rateset_to_mask(
> +				sband,
> +				nla_data(tb[NL80211_TXRATE_LEGACY]),
> +				nla_len(tb[NL80211_TXRATE_LEGACY]));
> +			if (mask.control[band].legacy =3D=3D 0) {
> +				err =3D -EINVAL;
> +				goto unlock;
> +			}
> +		}
> +	}
> +
> +	err =3D rdev->ops->set_bitrate_mask(&rdev->wiphy, dev, NULL, &mask);
> +
> + unlock:
> +	dev_put(dev);
> +	cfg80211_unlock_rdev(rdev);
> + unlock_rtnl:
> +	rtnl_unlock();
> +	return err;
> +}
> +
>  static struct genl_ops nl80211_ops[] =3D {
>  	{
>  		.cmd =3D NL80211_CMD_GET_WIPHY,
> @@ -4697,6 +4802,12 @@ static struct genl_ops nl80211_ops[] =3D {
>  		.policy =3D nl80211_policy,
>  		.flags =3D GENL_ADMIN_PERM,
>  	},
> +	{
> +		.cmd =3D NL80211_CMD_SET_TX_BITRATE_MASK,
> +		.doit =3D nl80211_set_tx_bitrate_mask,
> +		.policy =3D nl80211_policy,
> +		.flags =3D GENL_ADMIN_PERM,
> +	},
>  };
> =20
>  static struct genl_multicast_group nl80211_mlme_mcgrp =3D {
> --- wireless-testing.orig/include/net/cfg80211.h	2009-12-29
> 10:54:29.000000000 +0200
> +++ wireless-testing/include/net/cfg80211.h	2009-12-29
> 10:55:52.000000000 +0200
> @@ -39,8 +39,8 @@
>   * @IEEE80211_BAND_5GHZ: around 5GHz band (4.9-5.7)
>   */
>  enum ieee80211_band {
> -	IEEE80211_BAND_2GHZ,
> -	IEEE80211_BAND_5GHZ,
> +	IEEE80211_BAND_2GHZ =3D NL80211_BAND_2GHZ,
> +	IEEE80211_BAND_5GHZ =3D NL80211_BAND_5GHZ,
> =20
>  	/* keep last */
>  	IEEE80211_NUM_BANDS
>=20
> --=20
>=20


--=-Pg3GRo/dn12PGVwvGeDz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLQwjfAAoJEODzc/N7+QmanJwP/38Uz5NafOWdqexHDUonhE+A
YWJBCZvFyKrWWsjXOYgYe5vchoyadBWBfGtohV/YL/WhTuPRWGEsvqWdwuI0fyno
Q6OoHRqlic43yH0j4gpxrwl9PaTRMX9l5tIsM+rXOJhNVixxyJO5O5VZjN+LdU9D
rqnMYOjkZwx0UiFi7PONl9ukuZPIFwovHX1X/HKtT6FPgIJ2HhUxxziEy6pltXaC
4WnXaF8RJTRlz8vtNc7orCEd4gJkcooiFbWFEISmkmH3ayEbWyPYbMXwOCZs+UUn
r1C4Aaq09mHE0H3DmWngS7aCPtd0+Z21Hq05Eks1KxHwCL3f3bxs43i3wfWHlIRu
uMvckFi//94E8iQI/qswUf4/op2S31rE6A8DSXO+3Ep1eIwzS5YShgmEDjlFo8X/
+erntrW6Svlln1yJx8f/ltoEfnoy8NHDpb0cpBq0VM3iiBcfkrml9te3v6L/ewRc
aUBda6JKSUX7H2ZRf0zEObFLmESVzBD8QZageTVGJyMUI8FNidIIhIwyAfyYaVKW
QnW5/ctf+5NCmIvdRngd6uCIThO+LeThiXTr+cN67Tbi3qIMeNElEddizRvpdont
/X6kZnuCDGe7HXimuGHSpD2mumwbTOGbJMCfbNXUY4f8iegAuLXm28EqldW5ObRG
YaJzBK+C80fgUqQRnLE8
=BHlA
-----END PGP SIGNATURE-----

--=-Pg3GRo/dn12PGVwvGeDz--

