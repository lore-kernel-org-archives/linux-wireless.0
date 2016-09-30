Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:42725 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932496AbcI3Mnh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 30 Sep 2016 08:43:37 -0400
Message-ID: <1475239412.17481.59.camel@sipsolutions.net> (sfid-20160930_144341_020560_8A558425)
Subject: Re: [PATCH v9 2/2] mac80211: Move reorder-sensitive TX handlers to
 after TXQ dequeue
From: Johannes Berg <johannes@sipsolutions.net>
To: Toke =?ISO-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@toke.dk>
Cc: make-wifi-fast@lists.bufferbloat.net,
        linux-wireless@vger.kernel.org
Date: Fri, 30 Sep 2016 14:43:32 +0200
In-Reply-To: <87y4295zpy.fsf@toke.dk>
References: <20160922170420.5193-1-toke@toke.dk>
         <20160922170420.5193-3-toke@toke.dk>
         <1475231220.17481.32.camel@sipsolutions.net> <87y4295zpy.fsf@toke.dk>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Because I need to run it anyway for the xmit_fast path on dequeue. I
> thought doing it this way simplifies the code (at the cost of the
> handler getting called twice when xmit_fast is not active).

Ok, that's fair.

> > I *think* it should commute with the rate control handler, but even
> > so, wouldn't it make more sense to have rate control late? Assuming
> > the packets are queued for some amount of time, having rate control
> > information queued with them would get stale.
> 
> Yes, having rate control run at dequeue would be good, and that's
> what I did initially. However, I found that this would lead to a
> deadlock because the rate control handler would send out packets in
> some cases (I forget the details but can go back and check if
> needed). And since the dequeue function is called with the driver TXQ
> lock held, that would lead to a deadlock when those packets made it
> to the driver TX path.

That seems really odd, but I can see how a deadlock happens then.

> So I decided to just keep it this way for now; I plan to go poking
> into the rate controller later anyway, so moving the handler to later
> could be part of that.

Sure, that's fair.

> But that handler only sets a few flags? Is
> tx->sdata->control_port_protocol likely to change while the packet is
> queued?

Oh right, I confused things there. We check the controlled port much
earlier, but anyway that should be OK.

> > It's a bit unfortunate that you lose fast-xmit here completely for
> > the key stuff, but I don't see a good way to avoid that, other than
> > completely rejiggering all the (possibly affected) queues when keys
> > change... might be very complex to do that, certainly a follow-up
> > patch if it's desired.
> 
> Yeah, figured it was better to have something that's correct and then
> go back and change it if the performance hit turns out to be too
> high.

Makes sense.

> > This check seems a bit weird though - how could fast-xmit be set
> > without a TXQ station?
> 
> I think that is probably just left over from before I introduced the
> control flag. Should be fine to remove it.

Ok.

> > 
> > > 
> > > +++ b/net/mac80211/util.c
> > > @@ -3393,11 +3393,18 @@ void ieee80211_txq_get_depth(struct
> > > ieee80211_txq *txq,
> > >  			     unsigned long *byte_cnt)
> > >  {
> > >  	struct txq_info *txqi = to_txq_info(txq);
> > > +	u32 frag_cnt = 0, frag_bytes = 0;
> > > +	struct sk_buff *skb;
> > > +
> > > +	skb_queue_walk(&txqi->frags, skb) {
> > > +		frag_cnt++;
> > > +		frag_bytes += skb->len;
> > > +	}
> > 
> > I hope this is called infrequently :)
> 
> Well, ath10k is the only user. It does get called on each
> wake_tx_queue, though, so not that infrequently. My reasoning was
> that since the frags queue is never going to have more than a fairly
> small number of packets in it (those produced from a single split
> packet), counting this way is acceptable instead of keeping a state
> variable up to date. Can change it if you disagree :)

No, I guess you're right, it can't be a long queue.

> Not sure if you want a v10, or if you're satisfied with the above
> comments and will just fix up the nits on merging?
> 

I'll fix it up. Thanks!

johannes
