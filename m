Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:43796 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752193AbZC0WWz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Mar 2009 18:22:55 -0400
Date: Fri, 27 Mar 2009 18:22:51 -0400
From: "Luis R. Rodriguez" <mcgrof@bombadil.infradead.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 3/8] mac80211: rework the pending packets code
Message-ID: <20090327222251.GB5543@bombadil.infradead.org> (sfid-20090327_232258_613577_2A9F9BAE)
References: <20090323162834.154525349@sipsolutions.net> <20090323163052.298348347@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20090323163052.298348347@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Mar 23, 2009 at 05:28:37PM +0100, Johannes Berg wrote:
> The pending packets code is quite incomprehensible, uses memory barriers
> nobody really understands, etc. This patch reworks it entirely, using
> the queue spinlock, proper stop bits and the skb queues themselves to
> indicate whether packets are pending or not (rather than a separate
> variable like before).
> 
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

<-- snip -->

>  /*
> @@ -1830,40 +1829,57 @@ void ieee80211_tx_pending(unsigned long 
>  {
>  	struct ieee80211_local *local = (struct ieee80211_local *)data;
>  	struct net_device *dev = local->mdev;
> -	struct ieee80211_tx_stored_packet *store;
>  	struct ieee80211_hdr *hdr;
> +	unsigned long flags;
>  	struct ieee80211_tx_data tx;
>  	int i, ret;
> +	bool next;
>  
>  	rcu_read_lock();
>  	netif_tx_lock_bh(dev);
> +
>  	for (i = 0; i < local->hw.queues; i++) {
> -		/* Check that this queue is ok */
> -		if (__netif_subqueue_stopped(local->mdev, i) &&
> -		    !test_bit(i, local->queues_pending_run))
> -			continue;
> +		/*
> +		 * If queue is stopped by something other than due to pending
> +		 * frames, or we have no pending frames, proceed to next queue.
> +		 */
> +		spin_lock_irqsave(&local->queue_stop_reason_lock, flags);
> +		next = false;
> +		if (local->queue_stop_reasons[i] !=
> +			BIT(IEEE80211_QUEUE_STOP_REASON_PENDING) ||
> +		    skb_queue_empty(&local->pending[i]))
> +			next = true;
> +		spin_unlock_irqrestore(&local->queue_stop_reason_lock, flags);
>  
> -		if (!test_bit(i, local->queues_pending)) {
> -			clear_bit(i, local->queues_pending_run);
> -			ieee80211_wake_queue(&local->hw, i);
> +		if (next)
>  			continue;
> -		}
>  
> -		clear_bit(i, local->queues_pending_run);
> +		/*
> +		 * start the queue now to allow processing our packets,
> +		 * we're under the tx lock here anyway so nothing will
> +		 * happen as a result of this
> +		 */
>  		netif_start_subqueue(local->mdev, i);
>  
> -		store = &local->pending_packet[i];
> -		tx.flags = 0;
> -		tx.skb = store->skb;
> -		hdr = (struct ieee80211_hdr *)tx.skb->data;
> -		tx.sta = sta_info_get(local, hdr->addr1);
> -		ret = __ieee80211_tx(local, &tx);
> -		store->skb = tx.skb;
> -		if (!ret) {
> -			clear_bit(i, local->queues_pending);
> -			ieee80211_wake_queue(&local->hw, i);
> +		while (!skb_queue_empty(&local->pending[i])) {
> +			tx.flags = 0;
> +			tx.skb = skb_dequeue(&local->pending[i]);
> +			hdr = (struct ieee80211_hdr *)tx.skb->data;
> +			tx.sta = sta_info_get(local, hdr->addr1);
> +
> +			ret = __ieee80211_tx(local, &tx);
> +			if (ret != IEEE80211_TX_OK) {
> +				skb_queue_head(&local->pending[i], tx.skb);
> +				break;
> +			}
>  		}

So this is good functional change, might be worth mentioning in the
commit log, that is, we now requeue onto the pending queue the skb
when the driver's tx() didn't return NETDEV_TX_OK or when __ieee80211_tx()
returns IEEE80211_TX_PENDING (which happens when the queue is stopped).
Maybe even better as a seperate patch. Before this we were just dropping
the skbs in the pending queue under those same conditions.

Other than that:

Reviewed-by: Luis R. Rodriguez <lrodriguez@atheros.com>

  Luis
