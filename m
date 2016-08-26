Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:47522 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751742AbcHZIid (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 26 Aug 2016 04:38:33 -0400
Message-ID: <1472200706.390.29.camel@sipsolutions.net> (sfid-20160826_103848_061733_C19D3240)
Subject: Re: [Make-wifi-fast] [PATCH v2] mac80211: Move crypto IV generation
 to after TXQ dequeue.
From: Johannes Berg <johannes@sipsolutions.net>
To: Toke =?ISO-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@toke.dk>
Cc: Dave Taht <dave.taht@gmail.com>,
        make-wifi-fast@lists.bufferbloat.net,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Felix Fietkau <nbd@nbd.name>
Date: Fri, 26 Aug 2016 10:38:26 +0200
In-Reply-To: <87oa4k508r.fsf@toke.dk>
References: <20160817125800.19154-1-toke@toke.dk>
         <20160817144531.4285-1-toke@toke.dk>
         <1471463348.5173.16.camel@sipsolutions.net>
         <CAA93jw4+WTiFAdUJkPaf5aRDy81vMW34TPQt7xSgv95tsXU=cA@mail.gmail.com>
         <1471466600.5173.21.camel@sipsolutions.net> <87oa4k508r.fsf@toke.dk>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2016-08-22 at 16:47 +0200, Toke Høiland-Jørgensen wrote:
> 
> I suppose that could be a way to do it (i.e. have
> ieee80211_tx_dequeue call all the TX hooks etc), but am not sure
> whether there would be problems doing all this work in the loop
> that's building aggregates (which is what would happen for ath9k at
> least).

I don't know, but it seems that it's worth trying.

> An alternative could be to split the process up in two: An "early"
> and "late" stage, where the early stage does everything that is not
> sensitive to reordering and the occasional drop, and the late stage
> is everything that is. Then the queueing step could happen in-between 
> the two stages, and the non-queueing path could just call both stages
> at once. In effect, this would just make the current work-arounds be
> more explicit in the structure, rather than being marked as
> exceptions.

I'm not sure that works the way you think it does.

What you did works for fast-xmit, but *only* because that doesn't do
software crypto. If, for some reason, the TXQ stuff combines with
software crypto, which doesn't seem impossible (ath9k even has a module
parameter, iirc), then you have no way for this to work.

> > Now, it's unlikely to be that simple - fragmentation, for example,
> > might mess this up.
> > 
> > Overall though, I'm definitely wondering if it should be this way,
> > since all the special cases just add complexity.
> 
> I agree that the work-arounds are iffy, but I do also think it's
> important to keep in mind that we are improving latency by orders of
> magnitude here. A few special cases is worth it to achieve that, IMO.
> And then iterating towards a design that don't need them, of course
> :)

I don't really agree, I'm not going to treat this unlike any other
feature, which gets merged when it's ready for that.

Right now, your code here obviously isn't, since it doesn't even
address the cases that ath9k could run into, so either ath9k shouldn't
use this mac80211 feature, or the mac80211 feature needs to be fixed
before ath9k can use it.

I have no problems with documenting that the TXQ stuff can only be used
with full hardware crypto, but then we should add some checks and
warnings in mac80211 to ensure that, i.e. not allow software keys when
TXQ stuff is used, nor allow keys with mac80211 PN assignment, etc.

Even QoS-seqno assignment will be broken btw, so you do need a bunch
more offloads to make this work.

johannes
