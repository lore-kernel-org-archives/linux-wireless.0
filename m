Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:56090 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753324Ab2E2HRe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 May 2012 03:17:34 -0400
Message-ID: <1338275857.4342.27.camel@jlt3.sipsolutions.net> (sfid-20120529_091751_607115_E51257D3)
Subject: Re: [PATCH] mac80211: use offchannel queue only when supported
From: Johannes Berg <johannes@sipsolutions.net>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 29 May 2012 09:17:37 +0200
In-Reply-To: <1336916826-22462-1-git-send-email-eliad@wizery.com> (sfid-20120513_154740_384276_F977E330)
References: <1336916826-22462-1-git-send-email-eliad@wizery.com>
	 (sfid-20120513_154740_384276_F977E330)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2012-05-13 at 16:47 +0300, Eliad Peller wrote:
> Commit 3a25a8c ("mac80211: add improved HW queue control")
> added support for offchannel queue mapping. However, this
> mapping is only valid when the driver supports
> IEEE80211_HW_QUEUE_CONTROL.
> 
> Check whether the driver supports IEEE80211_HW_QUEUE_CONTROL
> before setting the hw_queue to the mapped offchannel queue.
> 
> (This patch doesn't have any actual effect, because
> hw_queue is overridden in ieee80211_tx() anyway,
> so this is merely some cleanup)
> 
> Signed-off-by: Eliad Peller <eliad@wizery.com>

Acked-by: Johannes Berg <johannes@sipsolutions.net>

> ---
>  net/mac80211/cfg.c |    8 +++++---
>  1 files changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
> index 6a82ae3..6b60593 100644
> --- a/net/mac80211/cfg.c
> +++ b/net/mac80211/cfg.c
> @@ -2303,7 +2303,8 @@ static int ieee80211_mgmt_tx(struct wiphy *wiphy, struct net_device *dev,
>  
>  	IEEE80211_SKB_CB(skb)->flags = flags;
>  
> -	if (flags & IEEE80211_TX_CTL_TX_OFFCHAN)
> +	if (local->hw.flags & IEEE80211_HW_QUEUE_CONTROL &&
> +	    flags & IEEE80211_TX_CTL_TX_OFFCHAN)
>  		IEEE80211_SKB_CB(skb)->hw_queue =
>  			local->hw.offchannel_tx_hw_queue;
>  
> @@ -2348,8 +2349,9 @@ static int ieee80211_mgmt_tx(struct wiphy *wiphy, struct net_device *dev,
>  		/* modify cookie to prevent API mismatches */
>  		*cookie ^= 2;
>  		IEEE80211_SKB_CB(skb)->flags |= IEEE80211_TX_CTL_TX_OFFCHAN;
> -		IEEE80211_SKB_CB(skb)->hw_queue =
> -			local->hw.offchannel_tx_hw_queue;
> +		if (local->hw.flags & IEEE80211_HW_QUEUE_CONTROL)
> +			IEEE80211_SKB_CB(skb)->hw_queue =
> +				local->hw.offchannel_tx_hw_queue;
>  		local->hw_roc_skb = skb;
>  		local->hw_roc_skb_for_status = skb;
>  		mutex_unlock(&local->mtx);


