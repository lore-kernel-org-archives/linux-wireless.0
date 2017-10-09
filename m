Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:44808 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754473AbdJISuK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 9 Oct 2017 14:50:10 -0400
Message-ID: <1507575007.26041.59.camel@sipsolutions.net> (sfid-20171009_205020_725591_1B43A4FE)
Subject: Re: [RFC] mac80211: Add airtime fairness accounting
From: Johannes Berg <johannes@sipsolutions.net>
To: Toke =?ISO-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@toke.dk>,
        make-wifi-fast@lists.bufferbloat.net,
        linux-wireless@vger.kernel.org
Date: Mon, 09 Oct 2017 20:50:07 +0200
In-Reply-To: <87zi90binm.fsf@toke.dk>
References: <20171006115232.28688-1-toke@toke.dk>
         <1507298832.19300.20.camel@sipsolutions.net> <87lgkoqrhs.fsf@toke.dk>
         <1507310319.19300.28.camel@sipsolutions.net> <87infrqk28.fsf@toke.dk>
         <1507533328.26041.12.camel@sipsolutions.net> <878tgkd5d1.fsf@toke.dk>
         <1507549222.26041.38.camel@sipsolutions.net> <87zi90binm.fsf@toke.dk>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> Right, but most of these are constant values that are straight
> forward to add as long as you know how the frame was received, no?
> Maybe not as a general function in mac80211, but the driver should be
> able to perform a reasonable computation in the absence of
> information from the hardware.

Yes, I think so.

> What does iwl put into the status.tx_time field of ieee80211_tx_info,
> BTW? That was the only driver I could find that used the field, and
> it looks like it just writes something it gets from the hardware into
> it.
> So does that value include overhead? And what about retransmissions?

It comes from the firmware - as far as I can tell, yes, it'll include
retransmissions and the whole frame exchange sequence (RTS-CTS-data-ack 
or RTS-CTS-ampdu-blockack).

> > I don't know if there's an easy answer. Perhaps not accounting for
> > the
> > overhead but assuming that clients won't be stupid and will
> > actually
> > do aggregation when they ramp up their rates is reasonable in most
> > scenarios, but I'm afraid that we'll find interop issues - we found
> > for example that if you enable U-APSD lots of devices won't do
> > aggregation any more ...
> 
> What do you mean by "interop" here, exactly? Just that stations doing
> weird things will see reduced performance?

Well, the case that we did find is that sometimes U-APSD kills
aggregation, so then you'd have a lot of single frames and
significantly under-estimate air-time usage in this case. Thus, this
station would get far more than its fair share of air time, because of
a bug that makes it not use aggregation... That doesn't sound very good
to me.

Perhaps at least taking aggregation into account would be doable - we
_should_ know this, at least partially.

> I'm pretty sure it will work for ath9k. That just picks a TXQ and
> keeps pulling packets until it has filled an aggregate. 

OK

> That would still be possible if mac80211 picks the TXQ instead of the
> driver itself. 

Right.

> So I was asking more generally, but if you don't see anything obvious
> that would prevent me from doing this, I guess I'll go and try it out
> :)

:-)

> > It might also be hard to combine that - if you have space on your
> > VI
> > queue, how do you then pick the queue? We can't really go *all* the
> > way and do scheduling *entirely* in software, getting rid of per-AC
> > queues, since the per-AC queues also work to assign the EDCA
> > parameters etc.
> 
> We'll need to keep putting packets into different hardware queues,
> sure.

> But deciding which one can be done at the last instant (i.e., for
> ath9k,
> ask mac80211 for a TXQ, look at which AC that TXQ belongs to, and
> start
> putting packets into that hardware queue).

Right.

> One of the things I would also like to try, is to sometimes promote
> or demote packets between AC levels. E.g., if a station has one VO
> packet and a bunch of BE packets queued, it may sometimes be more
> efficient to just put the VO packet at the beginning of a BE
> aggregate. I still need to figure out for which values of 'sometimes'
> this is a good idea, but I'd like to at least be able to support this
> sort of shenanigans, which I believe what I proposed above will.

I don't think that's a good idea. It's possible (and this can be done
at least in synthetic scenarios) that VO traffic _completely_ drowns
out all lower-priority traffic, so demoting frames that way would get
them the wrong EDCA parameters.

Yes, it might be better for throughput, but it would almost certainly
be worse for latency for those frames, which is kinda the whole point
of the ACs.

> > Also, in iwlwifi we actually have a HW queue per TID to facilitate
> > aggregation, though we could just let mac80211 pick the next TXQ to
> > serve and skip in the unlikely case that the HW queue for that is
> > already full (which really shouldn't happen).
> 
> Yeah, there may be a need for the driver to be able to express some
> constraints on the queues it can accept currently; may a bitmap of
> eligible TID numbers, or just a way of saying "can't use this TXQ,
> please give me another". But it may also be that it's enough for the
> driver to just give up and try again later if it can't use the TXQ it
> is assigned...

I guess it could just move on to the next TID. There doesn't seem to be
much point in saying "I can't service this high-priority TID, give me
something lower priority instead" because it really should be servicing
the higher priority first anyway, so just skipping if it can't be
serviced seems fine.

johannes
