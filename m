Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:54319 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752277AbYKZN5M (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Nov 2008 08:57:12 -0500
Subject: Re: [RFC] nl80211: Add frequency configuration (including HT40)
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: Sujith <m.sujith@gmail.com>, linux-wireless@vger.kernel.org
In-Reply-To: <20081126133851.GA8022@jm.kir.nu>
References: <20081125190533.GA27879@jm.kir.nu>
	 <20081126083841.GC31499@jm.kir.nu> <1227697465.4613.95.camel@johannes.berg>
	 <20081126133851.GA8022@jm.kir.nu>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Tn3Pvf92rjmvBwNrNUXp"
Date: Wed, 26 Nov 2008 14:55:25 +0100
Message-Id: <1227707725.4613.102.camel@johannes.berg> (sfid-20081126_145718_320494_1D11E912)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Tn3Pvf92rjmvBwNrNUXp
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-11-26 at 15:38 +0200, Jouni Malinen wrote:
> On Wed, Nov 26, 2008 at 12:04:24PM +0100, Johannes Berg wrote:
>=20
> > Thanks. A few other things that I just thought of:
>=20
> This version adds comment about _NO_HT, moves enum
> nl80211_sec_chan_offset conversion from nl80211.c into
> ieee80211_hw_config, changes enum to use NLA_U32, passes chan structure
> (instead of freq int) into set_channel() handler.

Cool, thanks, and sorry for all the delays.

Acked-by: Johannes Berg <johannes@sipsolutions.net>

>=20
> Index: wireless-testing/include/linux/nl80211.h
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- wireless-testing.orig/include/linux/nl80211.h	2008-11-26 15:15:31.000=
000000 +0200
> +++ wireless-testing/include/linux/nl80211.h	2008-11-26 15:16:59.00000000=
0 +0200
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
> @@ -180,6 +181,14 @@
>   *	/sys/class/ieee80211/<phyname>/index
>   * @NL80211_ATTR_WIPHY_NAME: wiphy name (used for renaming)
>   * @NL80211_ATTR_WIPHY_TXQ_PARAMS: a nested array of TX queue parameters
> + * @NL80211_ATTR_WIPHY_FREQ: frequency of the selected channel in MHz
> + * @NL80211_ATTR_WIPHY_SEC_CHAN_OFFSET: included with NL80211_ATTR_WIPHY=
_FREQ
> + *	if HT20 or HT40 are allowed (i.e., 802.11n disabled if not included):
> + *	NL80211_SEC_CHAN_NO_HT =3D HT not allowed (i.e., same as not includin=
g
> + *		this attribute)
> + *	NL80211_SEC_CHAN_DISABLED =3D HT20 only
> + *	NL80211_SEC_CHAN_BELOW =3D secondary channel is below the primary cha=
nnel
> + *	NL80211_SEC_CHAN_ABOVE =3D secondary channel is above the primary cha=
nnel
>   *
>   * @NL80211_ATTR_IFINDEX: network interface index of the device to opera=
te on
>   * @NL80211_ATTR_IFNAME: network interface name
> @@ -315,6 +324,8 @@
>  	NL80211_ATTR_BSS_BASIC_RATES,
> =20
>  	NL80211_ATTR_WIPHY_TXQ_PARAMS,
> +	NL80211_ATTR_WIPHY_FREQ,
> +	NL80211_ATTR_WIPHY_SEC_CHAN_OFFSET,
> =20
>  	/* add attributes here, update the policy in nl80211.c */
> =20
> @@ -329,6 +340,8 @@
>  #define NL80211_ATTR_HT_CAPABILITY NL80211_ATTR_HT_CAPABILITY
>  #define NL80211_ATTR_BSS_BASIC_RATES NL80211_ATTR_BSS_BASIC_RATES
>  #define NL80211_ATTR_WIPHY_TXQ_PARAMS NL80211_ATTR_WIPHY_TXQ_PARAMS
> +#define NL80211_ATTR_WIPHY_FREQ NL80211_ATTR_WIPHY_FREQ
> +#define NL80211_ATTR_WIPHY_SEC_CHAN_OFFSET NL80211_ATTR_WIPHY_SEC_CHAN_O=
FFSET
> =20
>  #define NL80211_MAX_SUPP_RATES			32
>  #define NL80211_MAX_SUPP_REG_RULES		32
> @@ -742,4 +755,10 @@
>  	NL80211_TXQ_Q_BK
>  };
> =20
> +enum nl80211_sec_chan_offset {
> +	NL80211_SEC_CHAN_NO_HT /* No HT */,
> +	NL80211_SEC_CHAN_DISABLED /* HT20 only */,
> +	NL80211_SEC_CHAN_BELOW /* HT40- */,
> +	NL80211_SEC_CHAN_ABOVE /* HT40+ */
> +};
>  #endif /* __LINUX_NL80211_H */
> Index: wireless-testing/include/net/cfg80211.h
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- wireless-testing.orig/include/net/cfg80211.h	2008-11-26 15:15:31.0000=
00000 +0200
> +++ wireless-testing/include/net/cfg80211.h	2008-11-26 15:29:50.000000000=
 +0200
> @@ -392,6 +392,9 @@
>  /* from net/wireless.h */
>  struct wiphy;
> =20
> +/* from net/ieee80211.h */
> +struct ieee80211_channel;
> +
>  /**
>   * struct cfg80211_ops - backend description for wireless configuration
>   *
> @@ -450,6 +453,8 @@
>   * @change_bss: Modify parameters for a given BSS.
>   *
>   * @set_txq_params: Set TX queue parameters
> + *
> + * @set_channel: Set channel
>   */
>  struct cfg80211_ops {
>  	int	(*add_virtual_intf)(struct wiphy *wiphy, char *name,
> @@ -513,6 +518,10 @@
> =20
>  	int	(*set_txq_params)(struct wiphy *wiphy,
>  				  struct ieee80211_txq_params *params);
> +
> +	int	(*set_channel)(struct wiphy *wiphy,
> +			       struct ieee80211_channel *chan,
> +			       enum nl80211_sec_chan_offset);
>  };
> =20
>  #endif /* __NET_CFG80211_H */
> Index: wireless-testing/net/mac80211/cfg.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- wireless-testing.orig/net/mac80211/cfg.c	2008-11-26 15:15:31.00000000=
0 +0200
> +++ wireless-testing/net/mac80211/cfg.c	2008-11-26 15:19:34.000000000 +02=
00
> @@ -1095,6 +1095,18 @@
>  	return 0;
>  }
> =20
> +static int ieee80211_set_channel(struct wiphy *wiphy,
> +				 struct ieee80211_channel *chan,
> +				 enum nl80211_sec_chan_offset sec_chan_offset)
> +{
> +	struct ieee80211_local *local =3D wiphy_priv(wiphy);
> +
> +	local->oper_channel =3D chan;
> +	local->oper_sec_chan_offset =3D sec_chan_offset;
> +
> +	return ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_CHANNEL);
> +}
> +
>  struct cfg80211_ops mac80211_config_ops =3D {
>  	.add_virtual_intf =3D ieee80211_add_iface,
>  	.del_virtual_intf =3D ieee80211_del_iface,
> @@ -1122,4 +1134,5 @@
>  #endif
>  	.change_bss =3D ieee80211_change_bss,
>  	.set_txq_params =3D ieee80211_set_txq_params,
> +	.set_channel =3D ieee80211_set_channel,
>  };
> Index: wireless-testing/net/wireless/nl80211.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- wireless-testing.orig/net/wireless/nl80211.c	2008-11-26 15:15:31.0000=
00000 +0200
> +++ wireless-testing/net/wireless/nl80211.c	2008-11-26 15:31:31.000000000=
 +0200
> @@ -59,6 +59,8 @@
>  	[NL80211_ATTR_WIPHY_NAME] =3D { .type =3D NLA_NUL_STRING,
>  				      .len =3D BUS_ID_SIZE-1 },
>  	[NL80211_ATTR_WIPHY_TXQ_PARAMS] =3D { .type =3D NLA_NESTED },
> +	[NL80211_ATTR_WIPHY_FREQ] =3D { .type =3D NLA_U32 },
> +	[NL80211_ATTR_WIPHY_SEC_CHAN_OFFSET] =3D { .type =3D NLA_U32 },
> =20
>  	[NL80211_ATTR_IFTYPE] =3D { .type =3D NLA_U32 },
>  	[NL80211_ATTR_IFINDEX] =3D { .type =3D NLA_U32 },
> @@ -359,6 +361,61 @@
>  		}
>  	}
> =20
> +	if (info->attrs[NL80211_ATTR_WIPHY_FREQ]) {
> +		enum nl80211_sec_chan_offset sec_chan_offset =3D
> +			NL80211_SEC_CHAN_NO_HT;
> +		struct ieee80211_channel *chan;
> +		u32 freq, sec_freq;
> +
> +		if (!rdev->ops->set_channel) {
> +			result =3D -EOPNOTSUPP;
> +			goto bad_res;
> +		}
> +
> +		if (info->attrs[NL80211_ATTR_WIPHY_SEC_CHAN_OFFSET]) {
> +			sec_chan_offset =3D nla_get_u32(
> +				info->attrs[
> +					NL80211_ATTR_WIPHY_SEC_CHAN_OFFSET]);
> +			if (sec_chan_offset !=3D NL80211_SEC_CHAN_NO_HT &&
> +			    sec_chan_offset !=3D NL80211_SEC_CHAN_DISABLED &&
> +			    sec_chan_offset !=3D NL80211_SEC_CHAN_BELOW &&
> +			    sec_chan_offset !=3D NL80211_SEC_CHAN_ABOVE) {
> +				result =3D -EINVAL;
> +				goto bad_res;
> +			}
> +		}
> +
> +		freq =3D nla_get_u32(info->attrs[NL80211_ATTR_WIPHY_FREQ]);
> +		chan =3D ieee80211_get_channel(&rdev->wiphy, freq);
> +		if (!chan || chan->flags & IEEE80211_CHAN_DISABLED) {
> +			/* Primary channel not allowed */
> +			result =3D -EINVAL;
> +			goto bad_res;
> +		}
> +		if (sec_chan_offset =3D=3D NL80211_SEC_CHAN_BELOW)
> +			sec_freq =3D freq - 20;
> +		else if (sec_chan_offset =3D=3D NL80211_SEC_CHAN_ABOVE)
> +			sec_freq =3D freq + 20;
> +		else
> +			sec_freq =3D 0;
> +
> +		if (sec_freq) {
> +			struct ieee80211_channel *schan;
> +			schan =3D ieee80211_get_channel(&rdev->wiphy, sec_freq);
> +			if (!schan || schan->flags & IEEE80211_CHAN_DISABLED) {
> +				/* Secondary channel not allowed */
> +				result =3D -EINVAL;
> +				goto bad_res;
> +			}
> +		}
> +
> +		result =3D rdev->ops->set_channel(&rdev->wiphy, chan,
> +						sec_chan_offset);
> +		if (result)
> +			goto bad_res;
> +	}
> +
> +
>  bad_res:
>  	cfg80211_put_dev(rdev);
>  	return result;
> Index: wireless-testing/include/net/mac80211.h
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- wireless-testing.orig/include/net/mac80211.h	2008-11-26 15:15:31.0000=
00000 +0200
> +++ wireless-testing/include/net/mac80211.h	2008-11-26 15:15:47.000000000=
 +0200
> @@ -507,6 +507,9 @@
> =20
>  struct ieee80211_ht_conf {
>  	bool enabled;
> +	int sec_chan_offset; /* 0 =3D HT40 disabled; -1 =3D HT40 enabled, secon=
dary
> +			      * channel below primary; 1 =3D HT40 enabled,
> +			      * secondary channel above primary */
>  };
> =20
>  /**
> Index: wireless-testing/net/mac80211/util.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- wireless-testing.orig/net/mac80211/util.c	2008-11-26 15:15:31.0000000=
00 +0200
> +++ wireless-testing/net/mac80211/util.c	2008-11-26 15:20:26.000000000 +0=
200
> @@ -641,6 +641,7 @@
>  		    chan->flags & IEEE80211_CHAN_NO_IBSS)
>  			return ret;
>  		local->oper_channel =3D chan;
> +		local->oper_sec_chan_offset =3D NL80211_SEC_CHAN_NO_HT;
> =20
>  		if (local->sw_scanning || local->hw_scanning)
>  			ret =3D 0;
> Index: wireless-testing/net/mac80211/ieee80211_i.h
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- wireless-testing.orig/net/mac80211/ieee80211_i.h	2008-11-26 15:15:31.=
000000000 +0200
> +++ wireless-testing/net/mac80211/ieee80211_i.h	2008-11-26 15:20:12.00000=
0000 +0200
> @@ -626,6 +626,7 @@
>  	struct delayed_work scan_work;
>  	struct ieee80211_sub_if_data *scan_sdata;
>  	struct ieee80211_channel *oper_channel, *scan_channel;
> +	enum nl80211_sec_chan_offset oper_sec_chan_offset;
>  	u8 scan_ssid[IEEE80211_MAX_SSID_LEN];
>  	size_t scan_ssid_len;
>  	struct list_head bss_list;
> Index: wireless-testing/net/mac80211/main.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- wireless-testing.orig/net/mac80211/main.c	2008-11-26 15:15:31.0000000=
00 +0200
> +++ wireless-testing/net/mac80211/main.c	2008-11-26 15:29:09.000000000 +0=
200
> @@ -195,20 +195,42 @@
>  	struct ieee80211_channel *chan;
>  	int ret =3D 0;
>  	int power;
> +	enum nl80211_sec_chan_offset sec_chan_offset;
> =20
>  	might_sleep();
> =20
> -	if (local->sw_scanning)
> +	if (local->sw_scanning) {
>  		chan =3D local->scan_channel;
> -	else
> +		sec_chan_offset =3D NL80211_SEC_CHAN_NO_HT;
> +	} else {
>  		chan =3D local->oper_channel;
> +		sec_chan_offset =3D local->oper_sec_chan_offset;
> +	}
> =20
> -	if (chan !=3D local->hw.conf.channel) {
> +	if (chan !=3D local->hw.conf.channel ||
> +	    sec_chan_offset !=3D local->hw.conf.ht.sec_chan_offset) {
>  		local->hw.conf.channel =3D chan;
> +		switch (sec_chan_offset) {
> +		case NL80211_SEC_CHAN_NO_HT:
> +			local->hw.conf.ht.enabled =3D false;
> +			local->hw.conf.ht.sec_chan_offset =3D 0;
> +			break;
> +		case NL80211_SEC_CHAN_DISABLED:
> +			local->hw.conf.ht.enabled =3D true;
> +			local->hw.conf.ht.sec_chan_offset =3D 0;
> +			break;
> +		case NL80211_SEC_CHAN_BELOW:
> +			local->hw.conf.ht.enabled =3D true;
> +			local->hw.conf.ht.sec_chan_offset =3D -1;
> +			break;
> +		case NL80211_SEC_CHAN_ABOVE:
> +			local->hw.conf.ht.enabled =3D true;
> +			local->hw.conf.ht.sec_chan_offset =3D 1;
> +			break;
> +		}
>  		changed |=3D IEEE80211_CONF_CHANGE_CHANNEL;
>  	}
> =20
> -
>  	if (!local->hw.conf.power_level)
>  		power =3D chan->max_power;
>  	else

--=-Tn3Pvf92rjmvBwNrNUXp
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJLVVJAAoJEKVg1VMiehFYsjkP/iLCCST5UwcTDyr5BAJ4Sh7A
nF9a9eoKl4XhmBee3sZ5fLUhUWe3IBbU7rDKXRMl+ChQqEAvQuDTY+zxkuoAwSJy
3+IWw+3G68eoWIYcYFJgooBzIlLarAyRCycig76bfx0GGUzUT8zqAX+16wPAxeoE
zLr/oEZdVgatDq/0v7imYghMubwkIuKPeCvBvcncDTigQSP4aI/w0H61WzG+DBf5
4wLZCI6hPzpv+o75AL9KnpknFT8W2xoANLAcYRS4hUTlKRYUxh2zyISlGR08l5eN
3PmBS4oAS+yBKjkoEEEIFJ83RFvb3QOnnbJfMNZI+/8QTkQybg3JCQ/Amt+jwYbF
D7tpduD6iIAINqkOcD7d6fHUh2R+TYvfYrYMgUB+ahzVtrVlzljnTNUXP1HkQwOx
EFpkH0pMiR8P7xkrTX7okUyKAn7r4hTZMbiBEYtsH2aU95JAjPKVyJcNH58py/fa
ZRaaLI51El6HrXFr27NMgUSneU8id8l9aV9tvBCgnnSXbDOjKeXo2wTEWXkrx5hO
eiIgnb+duJ9U6dxEdfZ4AANGAXcQ8UkBH6qKRL1Lq3dkHfGe4eAR3WAsgAX+UNhZ
3WsfkzjC4zO9FKIT7I01Hgy70VfpkAjvF9n8nw411FMw8FxOhlfEVKCqI8P4IlQS
qpJF68k/RP9WHC4kjDHY
=oWWs
-----END PGP SIGNATURE-----

--=-Tn3Pvf92rjmvBwNrNUXp--

