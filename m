Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:40723 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752653Ab3EXUjH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 May 2013 16:39:07 -0400
Message-ID: <1369427943.13623.8.camel@johannes> (sfid-20130524_223911_606477_1C146BFC)
Subject: Re: [PATCH] cfg80211: Allow TDLS peer AID to be configured for VHT
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <jouni@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 24 May 2013 22:39:03 +0200
In-Reply-To: <20130516171108.GA27497@jouni.qca.qualcomm.com>
References: <20130516171108.GA27497@jouni.qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-05-16 at 20:11 +0300, Jouni Malinen wrote:

> -	if (!info->attrs[NL80211_ATTR_STA_AID])
> +	if (!info->attrs[NL80211_ATTR_STA_AID] &&
> +	    !info->attrs[NL80211_ATTR_PEER_AID])
>  		return -EINVAL;

Technically here I think you could check that this attribute isn't used
with non-TDLS stations, since in new_station you know what it's going to
be, right?

> @@ -3985,7 +3989,10 @@ static int nl80211_new_station(struct sk_buff *skb, struct genl_info *info)
>  	params.listen_interval =
>  		nla_get_u16(info->attrs[NL80211_ATTR_STA_LISTEN_INTERVAL]);
>  
> -	params.aid = nla_get_u16(info->attrs[NL80211_ATTR_STA_AID]);
> +	if (info->attrs[NL80211_ATTR_STA_AID])
> +		params.aid = nla_get_u16(info->attrs[NL80211_ATTR_STA_AID]);
> +	else
> +		params.aid = nla_get_u16(info->attrs[NL80211_ATTR_PEER_AID]);

This is a bit strange? Wouldn't you want to prefer the new attribute, so
you can put some possibly invalid value into the old attribute for old
kernels? Otherwise what's the reason for even reading the new attribute
in this code at all, if new userspace code must set the old attribute
for old kernels anyway?

johannes

