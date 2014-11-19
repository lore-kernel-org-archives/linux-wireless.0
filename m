Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:40307 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755474AbaKSSfZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Nov 2014 13:35:25 -0500
Message-ID: <1416422117.9374.22.camel@sipsolutions.net> (sfid-20141119_193533_158871_30D74330)
Subject: Re: [PATCH 3/6] mac80211: add tx_status_noskb to rate_control_ops
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 19 Nov 2014 19:35:17 +0100
In-Reply-To: <1416094080-49220-3-git-send-email-nbd@openwrt.org>
References: <1416094080-49220-1-git-send-email-nbd@openwrt.org>
	 <1416094080-49220-3-git-send-email-nbd@openwrt.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> +++ b/net/mac80211/rate.h
> @@ -37,11 +37,15 @@ static inline void rate_control_tx_status(struct ieee80211_local *local,
>  	struct rate_control_ref *ref = local->rate_ctrl;
>  	struct ieee80211_sta *ista = &sta->sta;
>  	void *priv_sta = sta->rate_ctrl_priv;
> +	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
>  
>  	if (!ref || !test_sta_flag(sta, WLAN_STA_RATE_CONTROL))
>  		return;
>  
> -	ref->ops->tx_status(ref->priv, sband, ista, priv_sta, skb);
> +	if (ref->ops->tx_status)
> +		ref->ops->tx_status(ref->priv, sband, ista, priv_sta, skb);
> +	else
> +		ref->ops->tx_status_noskb(ref->priv, sband, ista, priv_sta, info);

I can't say I like this - you're going to have to pass NULL or something
as the SKB pointer, and then rely on having a rate control algorithm
that deals with it, etc....

johannes

