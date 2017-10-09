Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.toke.dk ([52.28.52.200]:49627 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751241AbdJIMim (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 9 Oct 2017 08:38:42 -0400
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Johannes Berg <johannes@sipsolutions.net>,
        make-wifi-fast@lists.bufferbloat.net,
        linux-wireless@vger.kernel.org
Subject: Re: [RFC] mac80211: Add airtime fairness accounting
In-Reply-To: <1507549222.26041.38.camel@sipsolutions.net>
References: <20171006115232.28688-1-toke@toke.dk> <1507298832.19300.20.camel@sipsolutions.net> <87lgkoqrhs.fsf@toke.dk> <1507310319.19300.28.camel@sipsolutions.net> <87infrqk28.fsf@toke.dk> <1507533328.26041.12.camel@sipsolutions.net> <878tgkd5d1.fsf@toke.dk> <1507549222.26041.38.camel@sipsolutions.net>
Date: Mon, 09 Oct 2017 14:38:37 +0200
Message-ID: <87zi90binm.fsf@toke.dk> (sfid-20171009_143845_847093_F435768E)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> On Mon, 2017-10-09 at 11:42 +0200, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>
>> Well, the padding and spacing between frames is at most 11 bytes (4-
>> byte delimiter, 4-byte FCS and 3-byte padding), which is ~0.7% of a
>> full-sized frame. I'm not too worried about errors on that scale,
>> TBH.
>
> I'm not sure - this really should take the whole frame exchange
> sequence into consideration, since the "dead" IFS time and the ACK etc.
> is also airtime consumed for that station, even if there's no actual
> transmission going on.
>
> If you factor that in, the overhead reduction with aggregation is
> considerable! With an 80 MHz 2x2 MCS 9 (866Mbps PHY rate) A-MPDU
> containing 64 packets, you can reach >650Mbps (with protection),
> without A-MPDU you can reach only about 45Mbps I think.
>
> You'd think that a 1500 byte frame takes 1.5ms for the 1Mbps client,
> and ~14=C2=B5s for the above mentioned VHT rate.
>
> In reality, however, the overhead for both is comparable in absolute
> numbers, it's >200=C2=B5s.
>
> If you don't take any of this overhead into account at all, then you'll
> vastly over-allocate time for clients sending small (non-aggregated)
> frames, because for those - even with slow rates - the overhead will
> dominate.

Right, but most of these are constant values that are straight forward
to add as long as you know how the frame was received, no? Maybe not as
a general function in mac80211, but the driver should be able to
perform a reasonable computation in the absence of information from the
hardware.

What does iwl put into the status.tx_time field of ieee80211_tx_info,
BTW? That was the only driver I could find that used the field, and it
looks like it just writes something it gets from the hardware into it.
So does that value include overhead? And what about retransmissions?

> I don't know if there's an easy answer. Perhaps not accounting for the
> overhead but assuming that clients won't be stupid and will actually
> do aggregation when they ramp up their rates is reasonable in most
> scenarios, but I'm afraid that we'll find interop issues - we found
> for example that if you enable U-APSD lots of devices won't do
> aggregation any more ...

What do you mean by "interop" here, exactly? Just that stations doing
weird things will see reduced performance?

>> > > Ideally, I would prefer the scheduling to be "two-pass": First,
>> > > decide which physical station to send to, then decide which TID
>> > > on that station to service.=20
>> >=20
>> > Yeah, that would make more sense.
>> >=20
>> > > But because everything is done at the TID/TXQ level, that is not
>> > > quite trivial to achieve I think...
>> >=20
>> > Well you can group the TXQs, I guess. They all have a STA pointer,
>> > so
>> > you could put a one- or two-bit "schedule color" field into each
>> > station and if you find a TXQ with the same station color you just
>> > skip it or something like that?
>>=20
>> Couldn't we add something like a get_next_txq(phy) function to
>> mac80211 that the drivers can call to get the queue to pull packets
>> from? That way, responsibility for scheduling both stations and QoS
>> levels falls to mac80211, which makes it possible to do clever
>> scheduling stuff without having to re-implement it in every driver.
>> Also, this function could handle all the special TXQs for PS and non-
>> data frames that you were talking about in your other email?
>>=20
>> Unless there's some reason I'm missing that the driver really needs
>> to schedule the TXQs, I think this would make a lot of sense?
>
> I have no idea, that's something you'll have to ask Felix I guess. I'd
> think it should work, but the scheduling might have other constraints
> like wanting to fill certain A-MPDU buffers, or getting a specific
> channel (though that's already decided once you pick the station).

I'm pretty sure it will work for ath9k. That just picks a TXQ and keeps
pulling packets until it has filled an aggregate. That would still be
possible if mac80211 picks the TXQ instead of the driver itself. So I
was asking more generally, but if you don't see anything obvious that
would prevent me from doing this, I guess I'll go and try it out :)

> It might also be hard to combine that - if you have space on your VI
> queue, how do you then pick the queue? We can't really go *all* the
> way and do scheduling *entirely* in software, getting rid of per-AC
> queues, since the per-AC queues also work to assign the EDCA
> parameters etc.

We'll need to keep putting packets into different hardware queues, sure.
But deciding which one can be done at the last instant (i.e., for ath9k,
ask mac80211 for a TXQ, look at which AC that TXQ belongs to, and start
putting packets into that hardware queue).

One of the things I would also like to try, is to sometimes promote or
demote packets between AC levels. E.g., if a station has one VO packet
and a bunch of BE packets queued, it may sometimes be more efficient to
just put the VO packet at the beginning of a BE aggregate. I still need
to figure out for which values of 'sometimes' this is a good idea, but
I'd like to at least be able to support this sort of shenanigans, which
I believe what I proposed above will.

> Also, in iwlwifi we actually have a HW queue per TID to facilitate
> aggregation, though we could just let mac80211 pick the next TXQ to
> serve and skip in the unlikely case that the HW queue for that is
> already full (which really shouldn't happen).

Yeah, there may be a need for the driver to be able to express some
constraints on the queues it can accept currently; may a bitmap of
eligible TID numbers, or just a way of saying "can't use this TXQ,
please give me another". But it may also be that it's enough for the
driver to just give up and try again later if it can't use the TXQ it is
assigned...

-Toke
