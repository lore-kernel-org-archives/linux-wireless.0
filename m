Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:6972 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753477AbaBSNTN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Feb 2014 08:19:13 -0500
Date: Wed, 19 Feb 2014 14:21:35 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/2] mac80211: fix calling ieee80211_free_txskb with NULL
 skb
Message-ID: <20140219132134.GD1851@redhat.com> (sfid-20140219_141921_624081_6E98D712)
References: <1392812916-13656-1-git-send-email-sgruszka@redhat.com>
 <1392813218.4733.20.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1392813218.4733.20.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 19, 2014 at 01:33:38PM +0100, Johannes Berg wrote:
> +Emmanuel
> 
> Interesting. We just ran into the same issue as well.
> 
> > +		struct sk_buff *old_skb = NULL;
> > +		unsigned long flags;
> >  
> >  		ps_dbg(sta->sdata, "STA %pM aid %d: PS buffer for AC %d\n",
> >  		       sta->sta.addr, sta->sta.aid, ac);
> >  		if (tx->local->total_ps_buffered >= TOTAL_MAX_TX_BUFFER)
> >  			purge_old_ps_buffers(tx->local);
> >  		if (skb_queue_len(&sta->ps_tx_buf[ac]) >= STA_MAX_TX_BUFFER) {
> > -			struct sk_buff *old = skb_dequeue(&sta->ps_tx_buf[ac]);
> > +			spin_lock_irqsave(&sta->ps_tx_buf[ac].lock, flags);
> > +			/* queue could be modified, recheck length with lock taken */
> > +			if (skb_queue_len(&sta->ps_tx_buf[ac]) >= STA_MAX_TX_BUFFER)
> > +				old_skb = __skb_dequeue(&sta->ps_tx_buf[ac]);
> > +			spin_unlock_irqrestore(&sta->ps_tx_buf[ac].lock, flags);
> > +		}
> > +		if (old_skb) {
> 
> I think that's pointless, you can just say "if (old)" instead as the
> dequeue would return NULL.

I think it helps if queue was only partially empted, then we do not
drop oldest frame.

> In any case, while this solves the crash which is a good thing, it still
> leaves the code buggy. This crash seems to occur in the following racy
> scenario:
> 
>  * station is sleeping
>  * frame TX to station begins
>  * station wakes up
>  * frame TX goes into the queue length check, finds long queue
>  * pending frames are transmitted
>  * queue is now empty
>  * old = skb_dequeue() returns NULL
>  * *kaboom*
> 
> The problem is that you're just fixing the "*kaboom*" part, so the code
> will continue like this:
> 
>  * old is NULL
>  * no kaboom
>  * new frame is queued on ps_tx_buf queue
>  * frame never gets transmitted

When started to look at that code I found at least 3 bugs, but miss
this one :-)

Why frame will not be transmitted, we are disabling PS, but buffers
stays not empty ?

Stanislaw
