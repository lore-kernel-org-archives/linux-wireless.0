Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:56096 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751126AbaBSMdo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Feb 2014 07:33:44 -0500
Message-ID: <1392813218.4733.20.camel@jlt4.sipsolutions.net> (sfid-20140219_133348_690533_E8FAD4DD)
Subject: Re: [PATCH 1/2] mac80211: fix calling ieee80211_free_txskb with
 NULL skb
From: Johannes Berg <johannes@sipsolutions.net>
To: Stanislaw Gruszka <sgruszka@redhat.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 19 Feb 2014 13:33:38 +0100
In-Reply-To: <1392812916-13656-1-git-send-email-sgruszka@redhat.com> (sfid-20140219_132640_718975_460F3097)
References: <1392812916-13656-1-git-send-email-sgruszka@redhat.com>
	 (sfid-20140219_132640_718975_460F3097)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

+Emmanuel

Interesting. We just ran into the same issue as well.

> +		struct sk_buff *old_skb = NULL;
> +		unsigned long flags;
>  
>  		ps_dbg(sta->sdata, "STA %pM aid %d: PS buffer for AC %d\n",
>  		       sta->sta.addr, sta->sta.aid, ac);
>  		if (tx->local->total_ps_buffered >= TOTAL_MAX_TX_BUFFER)
>  			purge_old_ps_buffers(tx->local);
>  		if (skb_queue_len(&sta->ps_tx_buf[ac]) >= STA_MAX_TX_BUFFER) {
> -			struct sk_buff *old = skb_dequeue(&sta->ps_tx_buf[ac]);
> +			spin_lock_irqsave(&sta->ps_tx_buf[ac].lock, flags);
> +			/* queue could be modified, recheck length with lock taken */
> +			if (skb_queue_len(&sta->ps_tx_buf[ac]) >= STA_MAX_TX_BUFFER)
> +				old_skb = __skb_dequeue(&sta->ps_tx_buf[ac]);
> +			spin_unlock_irqrestore(&sta->ps_tx_buf[ac].lock, flags);
> +		}
> +		if (old_skb) {

I think that's pointless, you can just say "if (old)" instead as the
dequeue would return NULL.

In any case, while this solves the crash which is a good thing, it still
leaves the code buggy. This crash seems to occur in the following racy
scenario:

 * station is sleeping
 * frame TX to station begins
 * station wakes up
 * frame TX goes into the queue length check, finds long queue
 * pending frames are transmitted
 * queue is now empty
 * old = skb_dequeue() returns NULL
 * *kaboom*

The problem is that you're just fixing the "*kaboom*" part, so the code
will continue like this:

 * old is NULL
 * no kaboom
 * new frame is queued on ps_tx_buf queue
 * frame never gets transmitted

johannes

