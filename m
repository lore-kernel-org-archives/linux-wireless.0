Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:56893 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758404AbZKRTxd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Nov 2009 14:53:33 -0500
Date: Wed, 18 Nov 2009 14:53:39 -0500
From: "Luis R. Rodriguez" <mcgrof@bombadil.infradead.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, lrodriguez@atheros.com
Subject: Re: [RFC] mac80211: move TX status processing to process context
Message-ID: <20091118195339.GB25188@bombadil.infradead.org>
References: <1258571772.30511.54.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1258571772.30511.54.camel@johannes.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 18, 2009 at 08:16:11PM +0100, Johannes Berg wrote:
> I see no real reason for status processing to be in
> tasklet context, and moving it into process context
> will make implementing some things that look at TX
> status information easier.
> 
> There are 5 drivers that use ieee80211_tx_status():
> ath5k, ath9k, b43, wl1251 and wl1271. Out of those,
> only ath5k and ath9k call it from tasklet context,
> so need to be changed, the others already call it
> from process context.
> 
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> ---
> Ok so this might /slightly/ impact ath5k/ath9k performance, but maybe
> they shouldn't be using a tasklet anyway but also use work structs...

Shoudln't by current mac80211 API documentation or shouldn't as in
it'd be good to change it? From the current docs I read hard IRQ
context but that could be clarified.

I'm not opposed to changing ath[59]k, in fact I want this change to
happen; in the future more of our drivers will hopefully share more
code and this then does mean eventually doing more things in process
context. But if something is affecting performance terribly without proper
coordination for a specific kernel release it would be terrible for
us and would prefer to try to avoid it. Can you test to see how much
performance difference you see with this? We can do so our our side
as well. If performance is affected this would be a good example of
one of those changes which could potentially be good for development
but might bad for users if not coordinated well.

> Any other objections? It'll make things that need to know the frame
> status easier, like client-side SM PS or anything else that requires
> knowing the frame was ACKed and not lost somewhere on the way.

Just a few comments below.

> --- wireless-testing.orig/net/mac80211/main.c	2009-11-18 19:40:08.000000000 +0100
> +++ wireless-testing/net/mac80211/main.c	2009-11-18 19:51:51.000000000 +0100
> @@ -625,16 +623,20 @@ void ieee80211_unregister_hw(struct ieee
>  
>  	cancel_work_sync(&local->reconfig_filter);
>  
> +	cancel_work_sync(&local->tx_status_work);
> +

Are there changes required during suspend as well?

> --- wireless-testing.orig/net/mac80211/status.c	2009-11-18 19:40:08.000000000 +0100
> +++ wireless-testing/net/mac80211/status.c	2009-11-18 20:05:55.000000000 +0100
> @@ -16,25 +16,31 @@
>  #include "led.h"
>  
>  
> -void ieee80211_tx_status_irqsafe(struct ieee80211_hw *hw,
> -				 struct sk_buff *skb)
> +void ieee80211_tx_status_irqsafe(struct ieee80211_hw *hw, struct sk_buff *skb)
>  {
>  	struct ieee80211_local *local = hw_to_local(hw);
>  	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
> -	int tmp;
> +	struct sk_buff_head *queue;
> +	int num;
>  
> -	skb->pkt_type = IEEE80211_TX_STATUS_MSG;
> -	skb_queue_tail(info->flags & IEEE80211_TX_CTL_REQ_TX_STATUS ?
> -		       &local->skb_queue : &local->skb_queue_unreliable, skb);
> -	tmp = skb_queue_len(&local->skb_queue) +
> -		skb_queue_len(&local->skb_queue_unreliable);
> -	while (tmp > IEEE80211_IRQSAFE_QUEUE_LIMIT &&
> -	       (skb = skb_dequeue(&local->skb_queue_unreliable))) {
> +	if (info->flags & IEEE80211_TX_CTL_REQ_TX_STATUS)
> +		queue = &local->tx_status;
> +	else
> +		queue = &local->tx_status_unreliable;
> +
> +	skb_queue_tail(queue, skb);

This sort of change could go into a seprate patch to help review
easier.

> +
> +	num = skb_queue_len(&local->tx_status) +
> +		skb_queue_len(&local->tx_status_unreliable);
> +
> +	/* if we got over the limit with this frame, try to make room */
> +	if (num > IEEE80211_TX_STATUS_QUEUE_LIMIT &&
> +	    (skb = skb_dequeue(&local->tx_status_unreliable))) {
>  		dev_kfree_skb_irq(skb);

Note before there was a while loop and now just a if branch. Why can we
get away with freeing now just one buffer? It would be nice to see
this explained in the commit log entry as it is not obvious to me.

> -		tmp--;
>  		I802_DEBUG_INC(local->tx_status_drop);
>  	}
> -	tasklet_schedule(&local->tasklet);
> +
> +	ieee80211_queue_work(&local->hw, &local->tx_status_work);

How about just moving this last party to a helper as well while at it?

>  }
>  EXPORT_SYMBOL(ieee80211_tx_status_irqsafe);
>  
> @@ -304,8 +310,8 @@ void ieee80211_tx_status(struct ieee8021
>  	skb->protocol = htons(ETH_P_802_2);
>  	memset(skb->cb, 0, sizeof(skb->cb));
>  
> -	rcu_read_lock();
> -	list_for_each_entry_rcu(sdata, &local->interfaces, list) {
> +	mutex_lock(&local->iflist_mtx);

Hm, what change here allows us to lift the rcu_read_lock, I
was under the impression it would be the for sdata.

> --- wireless-testing.orig/include/net/mac80211.h	2009-11-18 20:09:21.000000000 +0100
> +++ wireless-testing/include/net/mac80211.h	2009-11-18 20:11:00.000000000 +0100
> @@ -1734,31 +1737,28 @@ static inline void ieee80211_rx_ni(struc
>   * transmitted. It is permissible to not call this function for
>   * multicast frames but this can affect statistics.
>   *
> - * This function may not be called in IRQ context. Calls to this function
                                         ^^^

> - * for a single hardware must be synchronized against each other. Calls
> - * to this function and ieee80211_tx_status_irqsafe() may not be mixed
> - * for a single hardware.
> + * This function may not be called in hard or soft IRQ context. Calls
                                         ^^^^ ^^ ^^^^ ^^^

> + * to this function for a single hardware must be synchronized against
> + * each other. Calls to this function and ieee80211_tx_status_irqsafe()
> + * may not be mixed for a single device.

  Luis
