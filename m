Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:38436 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754129AbdJILk0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 9 Oct 2017 07:40:26 -0400
Message-ID: <1507549222.26041.38.camel@sipsolutions.net> (sfid-20171009_134032_153917_4C895360)
Subject: Re: [RFC] mac80211: Add airtime fairness accounting
From: Johannes Berg <johannes@sipsolutions.net>
To: Toke =?ISO-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@toke.dk>,
        make-wifi-fast@lists.bufferbloat.net,
        linux-wireless@vger.kernel.org
Date: Mon, 09 Oct 2017 13:40:22 +0200
In-Reply-To: <878tgkd5d1.fsf@toke.dk>
References: <20171006115232.28688-1-toke@toke.dk>
         <1507298832.19300.20.camel@sipsolutions.net> <87lgkoqrhs.fsf@toke.dk>
         <1507310319.19300.28.camel@sipsolutions.net> <87infrqk28.fsf@toke.dk>
         <1507533328.26041.12.camel@sipsolutions.net> <878tgkd5d1.fsf@toke.dk>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2017-10-09 at 11:42 +0200, Toke Høiland-Jørgensen wrote:

> Well, the padding and spacing between frames is at most 11 bytes (4-
> byte delimiter, 4-byte FCS and 3-byte padding), which is ~0.7% of a
> full-sized frame. I'm not too worried about errors on that scale,
> TBH.

I'm not sure - this really should take the whole frame exchange
sequence into consideration, since the "dead" IFS time and the ACK etc.
is also airtime consumed for that station, even if there's no actual
transmission going on.

If you factor that in, the overhead reduction with aggregation is
considerable! With an 80 MHz 2x2 MCS 9 (866Mbps PHY rate) A-MPDU
containing 64 packets, you can reach >650Mbps (with protection),
without A-MPDU you can reach only about 45Mbps I think.

You'd think that a 1500 byte frame takes 1.5ms for the 1Mbps client,
and ~14µs for the above mentioned VHT rate.

In reality, however, the overhead for both is comparable in absolute
numbers, it's >200µs.

If you don't take any of this overhead into account at all, then you'll
vastly over-allocate time for clients sending small (non-aggregated)
frames, because for those - even with slow rates - the overhead will
dominate.

If you do take this overhead into account but don't account for
aggregation, you'll vastly under-allocate time for HT/VHT clients that
use aggregation.

I don't know if there's an easy answer. Perhaps not accounting for the
overhead but assuming that clients won't be stupid and will actually do
aggregation when they ramp up their rates is reasonable in most
scenarios, but I'm afraid that we'll find interop issues - we found for
example that if you enable U-APSD lots of devices won't do aggregation
any more ...

> Sure, it would be better to have it be accurate, but there are other
> imperfections, especially on the RX side (we can't count
> retransmissions, for instance, since the receiver obviously doesn't
> see those).

Sure.

> There's a separate scheduling loop for each hardware queue (one per
> AC), which only schedules all TXQs with that AC. The hardware will
> prioritise higher ACs by dequeueing from the high-priority hardware
> queue first.

Ok, I guess that addresses that issue.

> Yeah, that's what we have currently in ath9k. However, it's rare in
> practice that a station transmits the same amount of data on all ACs
> (for one, since the max aggregation size is smaller at the higher ACs
> that becomes difficult). But you are quite right that this is
> something that should be fixed :)

Not sure the amount of data matters that much, but ok.

> > > Ideally, I would prefer the scheduling to be "two-pass": First,
> > > decide which physical station to send to, then decide which TID
> > > on that station to service. 
> > 
> > Yeah, that would make more sense.
> > 
> > > But because everything is done at the TID/TXQ level, that is not
> > > quite trivial to achieve I think...
> > 
> > Well you can group the TXQs, I guess. They all have a STA pointer,
> > so
> > you could put a one- or two-bit "schedule color" field into each
> > station and if you find a TXQ with the same station color you just
> > skip it or something like that?
> 
> Couldn't we add something like a get_next_txq(phy) function to
> mac80211 that the drivers can call to get the queue to pull packets
> from? That way, responsibility for scheduling both stations and QoS
> levels falls to mac80211, which makes it possible to do clever
> scheduling stuff without having to re-implement it in every driver.
> Also, this function could handle all the special TXQs for PS and non-
> data frames that you were talking about in your other email?
> 
> Unless there's some reason I'm missing that the driver really needs
> to schedule the TXQs, I think this would make a lot of sense?

I have no idea, that's something you'll have to ask Felix I guess. I'd
think it should work, but the scheduling might have other constraints
like wanting to fill certain A-MPDU buffers, or getting a specific
channel (though that's already decided once you pick the station).

It might also be hard to combine that - if you have space on your VI
queue, how do you then pick the queue? We can't really go *all* the way
and do scheduling *entirely* in software, getting rid of per-AC queues,
since the per-AC queues also work to assign the EDCA parameters etc.

Also, in iwlwifi we actually have a HW queue per TID to facilitate
aggregation, though we could just let mac80211 pick the next TXQ to
serve and skip in the unlikely case that the HW queue for that is
already full (which really shouldn't happen).

johannes
