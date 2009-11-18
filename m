Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:49461 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758372AbZKRVGx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Nov 2009 16:06:53 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 18 Nov 2009 13:07:00 -0800
Date: Wed, 18 Nov 2009 13:06:54 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"Luis R. Rodriguez" <mcgrof@bombadil.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [RFC] mac80211: move TX status processing to process context
Message-ID: <20091118210654.GI6581@tux>
References: <1258571772.30511.54.camel@johannes.local> <20091118195339.GB25188@bombadil.infradead.org> <1258574517.30511.61.camel@johannes.local> <20091118202334.GG6581@tux> <1258576479.30511.65.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1258576479.30511.65.camel@johannes.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 18, 2009 at 12:34:39PM -0800, Johannes Berg wrote:
> On Wed, 2009-11-18 at 12:23 -0800, Luis R. Rodriguez wrote:
> 
> > > > > +	/* if we got over the limit with this frame, try to make room */
> > > > > +	if (num > IEEE80211_TX_STATUS_QUEUE_LIMIT &&
> > > > > +	    (skb = skb_dequeue(&local->tx_status_unreliable))) {
> > > > >  		dev_kfree_skb_irq(skb);
> > > > 
> > > > Note before there was a while loop and now just a if branch. Why can we
> > > > get away with freeing now just one buffer? It would be nice to see
> > > > this explained in the commit log entry as it is not obvious to me.
> > > 
> > > Ah yes, I meant to explain that. We only use the status queues for TX
> > > status now and not for RX too as before, so before it could actually
> > > happen that we could free more than one off the unreliable queue, while
> > > now it really can only be one.
> > 
> > Ah, thanks, so, that skb_queue can go and we can just have one
> > unreliable sk_buff ?
> 
> No, you misunderstood. Because I'm separating the queue for the tasklet
> (tasklet_queue) and for TX status (tx_status/tx_status_unreliable) we
> can only possibly free one since we only added one -- the count cannot
> increase over that. The loop would only loop once at most.

OK, but can't you still have a driver spam mac80211 with a lot of
ieee80211_tx_status_irqsafe() calls in soft irq context with the final
skb requiring the tx complete, in that case the queue *will* get stuffed
and you could potentially free more if so desired.

Also, if our goal is to just avoid adding the skb if it does not require
a tx complete and our queue size is too large

	if (!(info->flags & IEEE80211_TX_CTL_REQ_TX_STATUS) &&
	    num + 1 > IEEE80211_TX_STATUS_QUEUE_LIMIT)
		dev_kfree_skb_irq(skb);
	else
		skb_queue_tail(&local->skb_queue)

> However ... right now we never use _any_ unreliable at all, but I
> suspect we will want to change that again at some point.

Just curious -- what would be a use case for that?

  Luis
