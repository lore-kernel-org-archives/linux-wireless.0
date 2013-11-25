Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:38447 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753923Ab3KYQI3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Nov 2013 11:08:29 -0500
Message-ID: <1385395707.4443.37.camel@jlt4.sipsolutions.net> (sfid-20131125_170833_349092_82EABA5E)
Subject: Re: [PATCH 1/2] cfg80211: Add support for QoS mapping
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <jouni@qca.qualcomm.com>
Cc: Kyeyoon Park <kyeyoonp@qca.qualcomm.com>,
	linux-wireless@vger.kernel.org
Date: Mon, 25 Nov 2013 17:08:27 +0100
In-Reply-To: <20131120102828.GA26154@jouni.qca.qualcomm.com>
References: <20131120102828.GA26154@jouni.qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-11-20 at 12:28 +0200, Jouni Malinen wrote:

> +struct cfg80211_qos_map {
> +	bool valid;

why do we need a validity flag? isn't NULL pointer enough?

> + * @set_qos_map: Set QoS mapping information to the driver
>   */
>  struct cfg80211_ops {
>  	int	(*suspend)(struct wiphy *wiphy, struct cfg80211_wowlan *wow);
> @@ -2428,6 +2476,9 @@ struct cfg80211_ops {
>  	int	(*channel_switch)(struct wiphy *wiphy,
>  				  struct net_device *dev,
>  				  struct cfg80211_csa_settings *params);
> +	int     (*set_qos_map)(struct wiphy *wiphy,
> +			       struct net_device *dev,
> +			       struct cfg80211_qos_map *qos_map);

I wonder if this is necessary? The driver could just have a flag for
"support QoS mapping" and having such support requires using
classify8021d(). OTOH, that function needs to gain a parameter anyway,
so it's not really worth it. Also, it's something that could be changed
purely internal to the kernel, so I guess I'm not worried about it much.

> + * @NL80211_CMD_SET_QOS_MAP: Set Interworking QoS mapping for IP DSCP values.
> + *	The QoS mapping information is included in %NL80211_ATTR_QOS_MAP. If
> + *	that attribute is not included, QoS mapping is disabled.

Might be useful to say that this is only valid while associated?

In fact, why is this even a new operation? Can this change during the
lifetime of the BSS? If not, then it might be worth just putting the
attribute into START_AP and ASSOCIATE/CONNECT etc?

> +		if (len & 1 || len < IEEE80211_QOS_MAP_LEN_MIN ||

I think len%2 would be easier to read? Not that it makes a big
difference, but fundamentally this isn't a bitop thing, it's a "length
must be even" thing.

> @@ -9564,6 +9606,14 @@ static struct genl_ops nl80211_ops[] = {
>  		.internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
>  				  NL80211_FLAG_NEED_RTNL,
>  	},
> +	{
> +		.cmd = NL80211_CMD_SET_QOS_MAP,

You forgot to advertise availability of the operation, but then again
see above - is it even needed?

> @@ -720,6 +721,21 @@ unsigned int cfg80211_classify8021d(struct sk_buff *skb)
>  		return 0;
>  	}
>  
> +	if (qos_map && qos_map->valid) {
> +		unsigned int i, tmp_dscp = dscp >> 2;
> +
> +		for (i = 0; i < qos_map->num_des; i++) {
> +			if (tmp_dscp == qos_map->dscp_exception[i].dscp)
> +				return qos_map->dscp_exception[i].up;
> +		}
> +
> +		for (i = 0; i < 8; i++) {
> +			if (tmp_dscp >= qos_map->up[i].low &&
> +			    tmp_dscp <= qos_map->up[i].high)
> +				return i;
> +		}
> +	}

Much better than the first version I saw :)

johannes

