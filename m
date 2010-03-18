Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f227.google.com ([209.85.217.227]:39442 "EHLO
	mail-gx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753152Ab0CRM4V (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Mar 2010 08:56:21 -0400
Received: by gxk27 with SMTP id 27so1809154gxk.1
        for <linux-wireless@vger.kernel.org>; Thu, 18 Mar 2010 05:56:18 -0700 (PDT)
Message-ID: <4BA222EF.2020901@lwfinger.net>
Date: Thu, 18 Mar 2010 07:56:15 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
CC: br1@einfach.org, ht6100@gmail.com, linux-wireless@vger.kernel.org
Subject: Re: pending queue depth in ieee80211_local data structure
References: <f74418681003180312k30dd39adtd00bd427cb88a710@mail.gmail.com>	 <201003181944.32081.br1@einfach.org> <f74418681003180435v3b762257q89c636d834897a5f@mail.gmail.com>
In-Reply-To: <f74418681003180435v3b762257q89c636d834897a5f@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/18/2010 06:35 AM, Lorenzo Bianconi wrote:
> Hi all,
> 
> I pasted the first version of the patch where I missed to unlock the
> spinlock in the  ieee80211_tx().
> This is the last version of the patch.

Probably not.

> Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
> 
> --- a/net/mac80211/ieee80211_i.h
> +++ b/net/mac80211/ieee80211_i.h
> @@ -708,6 +708,8 @@
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
> @@ -1449,14 +1449,18 @@
>  		skb = tx.skb;
> 
>  		spin_lock_irqsave(&local->queue_stop_reason_lock, flags);
> -
> +		

The new line here has trailing white space. I wondered why you were changing one
blank line for another. You should use scripts/checkpatch to verify your patch.
That script would have caught this.

>  		if (local->queue_stop_reasons[queue] ||
>  		    !skb_queue_empty(&local->pending[queue])) {
>  			/*
> -			 * if queue is stopped, queue up frames for later
> -			 * transmission from the tasklet
> +			 * if queue is stopped and there is enough space in the queue,
> +			 * queue up frames for later transmission from the tasklet
>  			 */
> -			do {
> +			if (skb_queue_len(&local->pending[queue]) >= PENDING_BUF) {
> +				spin_unlock_irqrestore(&local->queue_stop_reason_lock,
> +							flags);
> +				goto drop;
> +			} do {
>  				next = skb->next;
>  				skb->next = NULL;
>  				if (unlikely(txpending))
> @@ -2074,8 +2078,12 @@
>  						flags);
> 
>  			txok = ieee80211_tx_pending_skb(local, skb);
> -			if (!txok)
> -				__skb_queue_head(&local->pending[i], skb);
> +			if (!txok) {
> +				if (skb_queue_len(&local->pending[i]) < PENDING_BUF)
> +					__skb_queue_head(&local->pending[i], skb);
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
>  	__ieee80211_stop_queue(hw, queue, IEEE80211_QUEUE_STOP_REASON_SKB_ADD);
> -	__skb_queue_tail(&local->pending[queue], skb);
> +	if (skb_queue_len(&local->pending[queue]) < PENDING_BUF)
> +		__skb_queue_tail(&local->pending[queue], skb);
> +	else
> +		kfree_skb(skb);	
>  	__ieee80211_wake_queue(hw, queue, IEEE80211_QUEUE_STOP_REASON_SKB_ADD);
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

John Linville's efforts as the wireless maintainer are made easier when everyone
follows the guidelines in Documentation/SubmittingPatches. For instance, this
patch should have been submitted with the subject "[PATCH V2] mac80211: Revise
pending queue depth in ieee80211_local data structure", or some such title. At
the beginning of the submission, you should describe the problem following the
guidelines mentioned above. This section is followed by the "Signed-off-by:"
line with a line consisting of "---". Everything above this line becomes part of
the official record if/when the patch is accepted. In this case, the quoting of
previous emails and the inclusion of the previous patch is inappropriate. Below
the ---, you can include additional information such as how this version differs
from previous submissions, and any instructions to John.

I have not reviewed the content of this patch - only the problem with the white
space caught my eye.

Larry
