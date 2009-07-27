Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:45273 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754118AbZG0AEo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 26 Jul 2009 20:04:44 -0400
Subject: Re: [PATCH 1/3] mac80211: cooperate more with network namespaces
From: Pavel Roskin <proski@gnu.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20090713223413.255405284@sipsolutions.net>
References: <20090713223333.042733013@sipsolutions.net>
	 <20090713223413.255405284@sipsolutions.net>
Content-Type: text/plain
Date: Sun, 26 Jul 2009 20:04:42 -0400
Message-Id: <1248653082.3106.7.camel@mj>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2009-07-14 at 00:33 +0200, Johannes Berg wrote:
> @@ -1900,10 +1880,16 @@ void ieee80211_tx_pending(unsigned long 
>  
>  		while (!skb_queue_empty(&local->pending[i])) {
>  			struct sk_buff *skb = __skb_dequeue(&local->pending[i]);
> +			struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
> +			struct ieee80211_sub_if_data *sdata;
> +
> +			sdata = vif_to_sdata(info->control.vif);
> +			dev_hold(sdata->dev);

I'm getting a panic at this point if I run hostapd on ath9k and a
Windows client tries to authenticate with a wrong WPA key.

Debugging shows that sdata->dev is NULL.

The current wireless-testing is affected.  The revision preceding to
this patch is not affected.

CONFIG_NET_NS is not enabled.  The architecture is x86_64.

-- 
Regards,
Pavel Roskin
