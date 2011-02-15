Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f174.google.com ([209.85.212.174]:40307 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754710Ab1BOQD0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Feb 2011 11:03:26 -0500
Received: by pxi15 with SMTP id 15so44285pxi.19
        for <linux-wireless@vger.kernel.org>; Tue, 15 Feb 2011 08:03:26 -0800 (PST)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19802.41912.909410.520385@gargle.gargle.HOWL>
Date: Tue, 15 Feb 2011 21:33:04 +0530
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: [RFC/RFT] mac80211: make tx() operation return void
In-Reply-To: <1297778837.8664.0.camel@jlt3.sipsolutions.net>
References: <1297778837.8664.0.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> The return value of the tx operation is commonly
> misused by drivers, leading to errors. All drivers
> will drop frames if they fail to TX the frame, and
> they must also properly manage the queues (if they
> didn't, mac80211 would already warn).
> 
> Removing the ability for drivers to return a BUSY
> value also allows significant cleanups of the TX
> TX handling code in mac80211.
> 
> NB: Also fixes a bug in ath9k_htc.

[snip]

> --- wireless-testing.orig/drivers/net/wireless/ath/ath9k/htc_drv_main.c	2011-02-15 13:53:38.000000000 +0100
> +++ wireless-testing/drivers/net/wireless/ath/ath9k/htc_drv_main.c	2011-02-15 13:55:02.000000000 +0100
> @@ -903,7 +903,7 @@ set_timer:
>  /* mac80211 Callbacks */
>  /**********************/
>  
> -static int ath9k_htc_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
> +static void ath9k_htc_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
>  {
>  	struct ieee80211_hdr *hdr;
>  	struct ath9k_htc_priv *priv = hw->priv;
> @@ -916,7 +916,7 @@ static int ath9k_htc_tx(struct ieee80211
>  	padsize = padpos & 3;
>  	if (padsize && skb->len > padpos) {
>  		if (skb_headroom(skb) < padsize)
> -			return -1;
> +			goto fail_tx;
>  		skb_push(skb, padsize);
>  		memmove(skb->data, skb->data + padsize, padpos);
>  	}
> @@ -937,11 +937,10 @@ static int ath9k_htc_tx(struct ieee80211
>  		goto fail_tx;
>  	}
>  
> -	return 0;
> +	return;
>  
>  fail_tx:
>  	dev_kfree_skb_any(skb);
> -	return 0;
>  }

No problems with this change for ath9k_htc, but if required I can
send this as a separate patch...

Sujith
