Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:58368 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757742AbcILNTs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 12 Sep 2016 09:19:48 -0400
Message-ID: <1473686383.29016.54.camel@sipsolutions.net> (sfid-20160912_151952_007443_95D2E375)
Subject: Re: [PATCH v8] mac80211: Move reorder-sensitive TX handlers to
 after TXQ dequeue.
From: Johannes Berg <johannes@sipsolutions.net>
To: Toke =?ISO-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@toke.dk>
Cc: make-wifi-fast@lists.bufferbloat.net,
        linux-wireless@vger.kernel.org
Date: Mon, 12 Sep 2016 15:19:43 +0200
In-Reply-To: <87wpihe045.fsf@toke.dk>
References: <20160905113042.22271-1-toke@toke.dk>
         <20160906114426.25520-1-toke@toke.dk>
         <1473683716.29016.37.camel@sipsolutions.net> <87wpihe045.fsf@toke.dk>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> Well, the TXQ already adds a lot of other overhead (hashing on the
> packet header, for one), so my guess would be that this would be
> negligible compared to all that? 
> 
> > 
> > I suppose I don't have to care all that much about the TXQs, but
> > ...
> > 
> > Then again, adding a field in the skb->cb for the sake of this? No,
> > not really either.
> 
> So that's a "keep it", then? :)

Yeah I think so :)

> > > +		ieee80211_xmit_fast_finish(sta->sdata, sta,
> > > pn_offs,
> > > +					   info->control.hw_key, 
> > > skb);
> > 
> > I don't see how keeping the info->control.hw_key pointer across the
> > TXQ/FQ/Codel queueing isn't a potential bug? Probably one that
> > already exists in your code today, before this patch, of course.
> 
> You mean the key could get removed from the hardware while the packet
> was queued? Can certainly add a check for that. Under what conditions
> does that happen? Does it make sense to try to recover from it (I
> guess by calling tx_h_select_key), or is it rare enough that giving
> up and dropping the packet makes more sense?

Not just from the hardware, more importantly the whole key structure
can be kfree()d, leading to use-after-free here, no?

Fast-xmit solves this by invalidating the fast-xmit cache when the key
pointer changes/goes away and possibly punting some frames to the slow
path, but you've absolutely no protection on these pointers here within
the TXQs, afaict?

A similar situation occurs with other pointers, like stations and vifs,
but when those are removed then obviously the entire TXQs are flushed,
so they're not relevant.

With the key though, frames can be on the queue while a key is removed,
and even before this patch, drivers would consequently access an
invalid key pointer.

Mind you, as I just wrote I think that issue exists even before this
patch, so you should probably look at it separately. Felix might know
better too.

johannes
