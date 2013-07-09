Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:42677 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751728Ab3GIPW2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Jul 2013 11:22:28 -0400
Message-ID: <1373383341.8241.8.camel@jlt4.sipsolutions.net> (sfid-20130709_172231_305907_B1C674E0)
Subject: Re: [PATCH v13 2/2] cfg80211: P2P find phase offload
From: Johannes Berg <johannes@sipsolutions.net>
To: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>,
	"John W . Linville" <linville@tuxdriver.com>,
	Jouni Malinen <jouni@qca.qualcomm.com>,
	Arend van Spriel <arend@broadcom.com>,
	Ilan Peer <ilan.peer@intel.com>
Date: Tue, 09 Jul 2013 17:22:21 +0200
In-Reply-To: <9095491.AkZl2nGOCe@lx-vladimir>
References: <1372331863-14083-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
	 <9095491.AkZl2nGOCe@lx-vladimir>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


A few nits, since you're going to have to resend anyway (this patch is
also line-wrapped)


> NL80211_FEATURE_P2P_PROBE_RESP_OFFLOAD

Is that actually needed at all? Now that we have the "replied" flag in
the first patch, it seems like this wouldn't be used at all?

>  			CMD(crit_proto_stop, CRIT_PROTOCOL_STOP);
> +			CMD(start_p2p_find, START_P2P_FIND);
> +			CMD(stop_p2p_find, STOP_P2P_FIND);

That'll probably have to be changed when mac80211 supports this, but we
don't have to worry about it right now.

> +}
> +static int nl80211_start_p2p_find(struct sk_buff *skb, struct genl_info 
> *info)

There should be a blank line between the two functions

> +	params.channels = kzalloc(n_channels * sizeof(*params.channels),
> +				  GFP_KERNEL);

kcalloc? Probably doesn't matter much though.

> +	attr = info->attrs[NL80211_ATTR_MIN_DISCOVERABLE_INTERVAL];
> +	if (attr)
> +		params.min_discoverable_interval = nla_get_u32(attr);
> +
> +	attr = info->attrs[NL80211_ATTR_MAX_DISCOVERABLE_INTERVAL];
> +	if (attr)
> +		params.max_discoverable_interval = nla_get_u32(attr);

No validation at all? What if I pass 7/3 for min/max (yes, in that
order)?

johannes

