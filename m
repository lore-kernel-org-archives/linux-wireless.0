Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:46734 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932244AbZKRUXd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Nov 2009 15:23:33 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 18 Nov 2009 12:23:40 -0800
Date: Wed, 18 Nov 2009 12:23:34 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: "Luis R. Rodriguez" <mcgrof@bombadil.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>
Subject: Re: [RFC] mac80211: move TX status processing to process context
Message-ID: <20091118202334.GG6581@tux>
References: <1258571772.30511.54.camel@johannes.local> <20091118195339.GB25188@bombadil.infradead.org> <1258574517.30511.61.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1258574517.30511.61.camel@johannes.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 18, 2009 at 12:01:57PM -0800, Johannes Berg wrote:
> On Wed, 2009-11-18 at 14:53 -0500, Luis R. Rodriguez wrote:
> > I'm not opposed to changing ath[59]k, in fact I want this change to
> > happen; in the future more of our drivers will hopefully share more
> > code and this then does mean eventually doing more things in process
> > context. But if something is affecting performance terribly without proper
> > coordination for a specific kernel release it would be terrible for
> > us and would prefer to try to avoid it. Can you test to see how much
> > performance difference you see with this? 
> 
> Not really, I think it'd be hard to test, I expect a really small
> increase in CPU utilisation. It's only a difference between processing
> it, and putting it on a list, pulling it off a list and processing it.

Sure, I understand, I wouldn't expect much difference either.

> > > --- wireless-testing.orig/net/mac80211/main.c	2009-11-18 19:40:08.000000000 +0100
> > > +++ wireless-testing/net/mac80211/main.c	2009-11-18 19:51:51.000000000 +0100
> > > @@ -625,16 +623,20 @@ void ieee80211_unregister_hw(struct ieee
> > >  
> > >  	cancel_work_sync(&local->reconfig_filter);
> > >  
> > > +	cancel_work_sync(&local->tx_status_work);
> > > +
> > 
> > Are there changes required during suspend as well?
> 
> Good question, but I think not since we don't touch the tasklet during
> suspend right now. Now, that might be wrong too, but at least it
> wouldn't change anything

OK -- just wanted to make sure.

> (actually we flush the workqueue for suspend anyway, don't we?)

Yes.

> > > --- wireless-testing.orig/net/mac80211/status.c	2009-11-18 19:40:08.000000000 +0100
> > > +++ wireless-testing/net/mac80211/status.c	2009-11-18 20:05:55.000000000 +0100
> > > @@ -16,25 +16,31 @@
> > >  #include "led.h"
> > >  
> > >  
> > > -void ieee80211_tx_status_irqsafe(struct ieee80211_hw *hw,
> > > -				 struct sk_buff *skb)
> > > +void ieee80211_tx_status_irqsafe(struct ieee80211_hw *hw, struct sk_buff *skb)
> > >  {
> > >  	struct ieee80211_local *local = hw_to_local(hw);
> > >  	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
> > > -	int tmp;
> > > +	struct sk_buff_head *queue;
> > > +	int num;
> > >  
> > > -	skb->pkt_type = IEEE80211_TX_STATUS_MSG;
> > > -	skb_queue_tail(info->flags & IEEE80211_TX_CTL_REQ_TX_STATUS ?
> > > -		       &local->skb_queue : &local->skb_queue_unreliable, skb);
> > > -	tmp = skb_queue_len(&local->skb_queue) +
> > > -		skb_queue_len(&local->skb_queue_unreliable);
> > > -	while (tmp > IEEE80211_IRQSAFE_QUEUE_LIMIT &&
> > > -	       (skb = skb_dequeue(&local->skb_queue_unreliable))) {
> > > +	if (info->flags & IEEE80211_TX_CTL_REQ_TX_STATUS)
> > > +		queue = &local->tx_status;
> > > +	else
> > > +		queue = &local->tx_status_unreliable;
> > > +
> > > +	skb_queue_tail(queue, skb);
> > 
> > This sort of change could go into a seprate patch to help review
> > easier.
> 
> Huh? The patch really only changes the if from being inlined into the
> function call to not being there .. while changing the skb queue names
> anyway.

Its a small change hence why I used could not should. If you send
an RFC and tell me that it could potentially have an impact on ath9k
I'm going to read it carefully, the smaller the patch the easier the
review.

> > > +	/* if we got over the limit with this frame, try to make room */
> > > +	if (num > IEEE80211_TX_STATUS_QUEUE_LIMIT &&
> > > +	    (skb = skb_dequeue(&local->tx_status_unreliable))) {
> > >  		dev_kfree_skb_irq(skb);
> > 
> > Note before there was a while loop and now just a if branch. Why can we
> > get away with freeing now just one buffer? It would be nice to see
> > this explained in the commit log entry as it is not obvious to me.
> 
> Ah yes, I meant to explain that. We only use the status queues for TX
> status now and not for RX too as before, so before it could actually
> happen that we could free more than one off the unreliable queue, while
> now it really can only be one.

Ah, thanks, so, that skb_queue can go and we can just have one
unreliable sk_buff ?

> Not that it actually matters, I just realised we never ever even use the
> unreliable queue since we _always_ set the
> IEEE80211_TX_CTL_REQ_TX_STATUS bit!
> 
> > > -		tmp--;
> > >  		I802_DEBUG_INC(local->tx_status_drop);
> > >  	}
> > > -	tasklet_schedule(&local->tasklet);
> > > +
> > > +	ieee80211_queue_work(&local->hw, &local->tx_status_work);
> > 
> > How about just moving this last party to a helper as well while at it?
> 
> What?

I mean that ieee80211_tx_status_irqsafe() is basicaly doing this:

ieee80211_tx_status_irqsafe()
{
	skb_queue_tail(queue, skb);
	clear_unreliable_if_needed();
	ieee80211_queue_work(&local->hw, &local->tx_status_work);
}

Would be easier to read that way too.

> > > -	rcu_read_lock();
> > > -	list_for_each_entry_rcu(sdata, &local->interfaces, list) {
> > > +	mutex_lock(&local->iflist_mtx);
> > 
> > Hm, what change here allows us to lift the rcu_read_lock, I
> > was under the impression it would be the for sdata.
> 
> Well yeah, but we have the mutex now instead.

Ah got it.

> > > --- wireless-testing.orig/include/net/mac80211.h	2009-11-18 20:09:21.000000000 +0100
> > > +++ wireless-testing/include/net/mac80211.h	2009-11-18 20:11:00.000000000 +0100
> > > @@ -1734,31 +1737,28 @@ static inline void ieee80211_rx_ni(struc
> > >   * transmitted. It is permissible to not call this function for
> > >   * multicast frames but this can affect statistics.
> > >   *
> > > - * This function may not be called in IRQ context. Calls to this function
> >                                          ^^^
> > 
> > > - * for a single hardware must be synchronized against each other. Calls
> > > - * to this function and ieee80211_tx_status_irqsafe() may not be mixed
> > > - * for a single hardware.
> > > + * This function may not be called in hard or soft IRQ context. Calls
> >                                          ^^^^ ^^ ^^^^ ^^^
> 
> ?

I was just highlighting the current kdoc for my first point on the e-mail.

  Luis
