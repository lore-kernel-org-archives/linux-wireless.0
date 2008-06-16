Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ogre.sisk.pl ([217.79.144.158]:54952 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750916AbYFPBQE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Jun 2008 21:16:04 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH v2] mac80211: detect driver tx bugs
Date: Mon, 16 Jun 2008 03:17:08 +0200
Cc: John Linville <linville@tuxdriver.com>,
	Michael Buesch <mb@bu3sch.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
References: <1213534025.3803.2.camel@johannes.berg> <1213534540.3803.5.camel@johannes.berg>
In-Reply-To: <1213534540.3803.5.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200806160317.08609.rjw@sisk.pl> (sfid-20080616_031610_339728_06C9578F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday, 15 of June 2008, Johannes Berg wrote:
> When a driver rejects a frame in it's ->tx() callback, it must also
> stop queues, otherwise mac80211 can go into a loop here. Detect this
> situation and abort the loop after five retries, warning about the
> driver bug.
> 
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

I'm unable to test this patch at the moment, because suspend is broken with
linux-next on my box.  Tomorrow I'll try to find out why.

Thanks,
Rafael


> ---
> v2: Michael suggested to use WARN_ON_ONCE instead
> 
>  net/mac80211/tx.c |    9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
> 
> --- everything.orig/net/mac80211/tx.c	2008-06-15 14:19:10.000000000 +0200
> +++ everything/net/mac80211/tx.c	2008-06-15 14:53:52.000000000 +0200
> @@ -1091,7 +1091,7 @@ static int ieee80211_tx(struct net_devic
>  	struct ieee80211_tx_data tx;
>  	ieee80211_tx_result res = TX_DROP, res_prepare;
>  	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
> -	int ret, i;
> +	int ret, i, retries = 0;
>  	u16 queue;
>  
>  	queue = skb_get_queue_mapping(skb);
> @@ -1189,6 +1189,13 @@ retry:
>  		 */
>  		if (!__netif_subqueue_stopped(local->mdev, queue)) {
>  			clear_bit(queue, local->queues_pending);
> +			retries++;
> +			/*
> +			 * Driver bug, it's rejecting packets but
> +			 * not stopping queues.
> +			 */
> +			if (WARN_ON_ONCE(retries > 5))
> +				goto drop;
>  			goto retry;
>  		}
>  		store->skb = skb;
> 
