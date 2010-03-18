Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from home.einfach.org ([80.86.92.145]:40509 "EHLO home.einfach.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752171Ab0CRKos (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Mar 2010 06:44:48 -0400
From: Bruno Randolf <br1@einfach.org>
To: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
Subject: Re: pending queue depth in ieee80211_local data structure
Date: Thu, 18 Mar 2010 19:44:31 +0900
Cc: linux-wireless@vger.kernel.org
References: <f74418681003180312k30dd39adtd00bd427cb88a710@mail.gmail.com>
In-Reply-To: <f74418681003180312k30dd39adtd00bd427cb88a710@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201003181944.32081.br1@einfach.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 18 March 2010 19:12:32 Lorenzo Bianconi wrote:
> Hi all,
> 
> I noticed a possible issue in the pending queue management of the
> ieee80211_local data structure.
> In particular, there is no control of the queue depth and this could
> cause a memory overflow.
> In the test I carried out this happen when I use a low priority queue
> (e.g. Backgreound queue) and
> I transmit a data stream that exceeds the channel capacity (e.g.
> 50Mbps@MCS 3, 800ns GI and 20MHz
> channel width). I wrote this patch in order to fix the issue.

i think, i noticed the same issue: sending a UDP stream which is higher than 
the possible bandwidth will eventually cause an out of memory panic.

bruno

> Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
> 
> --- a/net/mac80211/ieee80211_i.h
> +++ b/net/mac80211/ieee80211_i.h
> @@ -703,6 +703,8 @@
>  	struct work_struct sta_finish_work;
>  	int sta_generation;
> 
> +	/* Pending buffer dimension */
> +	#define PENDING_BUF	512
>  	struct sk_buff_head pending[IEEE80211_MAX_QUEUES];
>  	struct tasklet_struct tx_pending_tasklet;
> 
> --- a/net/mac80211/tx.c
> +++ b/net/mac80211/tx.c
> @@ -1399,13 +1399,15 @@
>  		skb = tx.skb;
> 
>  		spin_lock_irqsave(&local->queue_stop_reason_lock, flags);
> -
> +
>  		if (local->queue_stop_reasons[queue] ||
>  		    !skb_queue_empty(&local->pending[queue])) {
>  			/*
> -			 * if queue is stopped, queue up frames for later
> -			 * transmission from the tasklet
> +			 * if queue is stopped and there is enough space in 
the queue,
> +			 * queue up frames for later transmission from the 
tasklet
>  			 */
> +			if (skb_queue_len(&local->pending[queue]) >= 
PENDING_BUF)
> +				goto drop;
>  			do {
>  				next = skb->next;
>  				skb->next = NULL;
> @@ -2028,8 +2030,12 @@
>  						flags);
> 
>  			txok = ieee80211_tx_pending_skb(local, skb);
> -			if (!txok)
> -				__skb_queue_head(&local->pending[i], skb);
> +			if (!txok) {
> +				if (skb_queue_len(&local->pending[i]) < 
PENDING_BUF)
> +					__skb_queue_head(&local->pending[i], 
skb);
> +				else
> +					kfree_skb(skb);
> +			}
>  			spin_lock_irqsave(&local->queue_stop_reason_lock,
>  					  flags);
>  			if (!txok)
> --- a/net/mac80211/util.c
> +++ b/net/mac80211/util.c
> @@ -383,7 +383,10 @@
> 
>  	spin_lock_irqsave(&local->queue_stop_reason_lock, flags);
>  	__ieee80211_stop_queue(hw, queue, 
IEEE80211_QUEUE_STOP_REASON_SKB_ADD);
> -	__skb_queue_tail(&local->pending[queue], skb);
> +	if (skb_queue_len(&local->pending[queue]) < PENDING_BUF)
> +		__skb_queue_tail(&local->pending[queue], skb);
> +	else
> +		kfree_skb(skb);
>  	__ieee80211_wake_queue(hw, queue, 
IEEE80211_QUEUE_STOP_REASON_SKB_ADD);
>  	spin_unlock_irqrestore(&local->queue_stop_reason_lock, flags);
>  }
> @@ -409,9 +412,12 @@
>  			continue;
>  		}
> 
> -		ret++;
>  		queue = skb_get_queue_mapping(skb);
> -		__skb_queue_tail(&local->pending[queue], skb);
> +		if (skb_queue_len(&local->pending[queue]) < PENDING_BUF) {
> +			ret++;
> +			__skb_queue_tail(&local->pending[queue], skb);
> +		} else
> +			kfree_skb(skb);
>  	}
> 
>  	for (i = 0; i < hw->queues; i++)
> 
> 
> Regards
> 
> Lorenzo
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless"
> in the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
