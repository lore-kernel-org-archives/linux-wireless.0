Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:54582 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751192Ab1AEQCU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Jan 2011 11:02:20 -0500
Subject: Re: [RFC] cfg80211: Add HT BSS attributes
From: Johannes Berg <johannes@sipsolutions.net>
To: Sujith <m.sujith@gmail.com>
Cc: Jouni.Malinen@atheros.com,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <19748.37551.23627.698571@gargle.gargle.HOWL>
References: <19748.37551.23627.698571@gargle.gargle.HOWL>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 05 Jan 2011 17:02:18 +0100
Message-ID: <1294243338.3590.11.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-01-05 at 21:17 +0530, Sujith wrote:
> From: Sujith Manoharan <Sujith.Manoharan@atheros.com>
> 
> Add two new per-BSS attributes to allow configuration of
> HT capabilites and operational parameters by hostapd.

Looks fine, but

> @@ -2597,6 +2597,12 @@ static int nl80211_set_bss(struct sk_buff *skb, struct genl_info *info)
>  	if (info->attrs[NL80211_ATTR_BSS_HT_OPMODE])
>  		params.ht_opmode =
>  			nla_get_u16(info->attrs[NL80211_ATTR_BSS_HT_OPMODE]);
> +	if (info->attrs[NL80211_ATTR_BSS_HT_CAPAB])
> +		params.ht_capab =
> +			nla_get_u16(info->attrs[NL80211_ATTR_BSS_HT_CAPAB]);
> +	if (info->attrs[NL80211_ATTR_BSS_HT_PARAM])
> +		params.ht_param =
> +			nla_get_u8(info->attrs[NL80211_ATTR_BSS_HT_PARAM]);
>  
>  	if (!rdev->ops->change_bss)
>  		return -EOPNOTSUPP;

This appears to be missing a -1 initialisation?

johannes

