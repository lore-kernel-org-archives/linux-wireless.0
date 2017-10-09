Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.toke.dk ([52.28.52.200]:44377 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754373AbdJIUZi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 9 Oct 2017 16:25:38 -0400
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Johannes Berg <johannes@sipsolutions.net>,
        make-wifi-fast@lists.bufferbloat.net,
        linux-wireless@vger.kernel.org
Subject: Re: [RFC] mac80211: Add airtime fairness accounting
In-Reply-To: <1507575007.26041.59.camel@sipsolutions.net>
References: <20171006115232.28688-1-toke@toke.dk> <1507298832.19300.20.camel@sipsolutions.net> <87lgkoqrhs.fsf@toke.dk> <1507310319.19300.28.camel@sipsolutions.net> <87infrqk28.fsf@toke.dk> <1507533328.26041.12.camel@sipsolutions.net> <878tgkd5d1.fsf@toke.dk> <1507549222.26041.38.camel@sipsolutions.net> <87zi90binm.fsf@toke.dk> <1507575007.26041.59.camel@sipsolutions.net>
Date: Mon, 09 Oct 2017 22:25:34 +0200
Message-ID: <87376sqda9.fsf@toke.dk> (sfid-20171009_222652_969900_7E5D962E)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> Hi,
>
>> Right, but most of these are constant values that are straight
>> forward to add as long as you know how the frame was received, no?
>> Maybe not as a general function in mac80211, but the driver should be
>> able to perform a reasonable computation in the absence of
>> information from the hardware.
>
> Yes, I think so.

Cool. I'll go with that, then.

>> What does iwl put into the status.tx_time field of ieee80211_tx_info,
>> BTW? That was the only driver I could find that used the field, and
>> it looks like it just writes something it gets from the hardware into
>> it.
>> So does that value include overhead? And what about retransmissions?
>
> It comes from the firmware - as far as I can tell, yes, it'll include
> retransmissions and the whole frame exchange sequence
> (RTS-CTS-data-ack or RTS-CTS-ampdu-blockack).

Excellent! Just what we need :)

>> > I don't know if there's an easy answer. Perhaps not accounting for
>> > the
>> > overhead but assuming that clients won't be stupid and will
>> > actually
>> > do aggregation when they ramp up their rates is reasonable in most
>> > scenarios, but I'm afraid that we'll find interop issues - we found
>> > for example that if you enable U-APSD lots of devices won't do
>> > aggregation any more ...
>> 
>> What do you mean by "interop" here, exactly? Just that stations doing
>> weird things will see reduced performance?
>
> Well, the case that we did find is that sometimes U-APSD kills
> aggregation, so then you'd have a lot of single frames and
> significantly under-estimate air-time usage in this case. Thus, this
> station would get far more than its fair share of air time, because of
> a bug that makes it not use aggregation... That doesn't sound very
> good to me.
>
> Perhaps at least taking aggregation into account would be doable - we
> _should_ know this, at least partially.

Yeah, ath9k certainly gets that as part of the RX information from the
chip.

>> One of the things I would also like to try, is to sometimes promote
>> or demote packets between AC levels. E.g., if a station has one VO
>> packet and a bunch of BE packets queued, it may sometimes be more
>> efficient to just put the VO packet at the beginning of a BE
>> aggregate. I still need to figure out for which values of 'sometimes'
>> this is a good idea, but I'd like to at least be able to support this
>> sort of shenanigans, which I believe what I proposed above will.
>
> I don't think that's a good idea. It's possible (and this can be done
> at least in synthetic scenarios) that VO traffic _completely_ drowns
> out all lower-priority traffic, so demoting frames that way would get
> them the wrong EDCA parameters.
>
> Yes, it might be better for throughput, but it would almost certainly
> be worse for latency for those frames, which is kinda the whole point
> of the ACs.

Well, some of the tests I did while porting ath9k to the iTXQs indicated
that for voice-like traffic we can get very close to the same actual
end-to-end latency for BE-marked traffic that we do with VO-marked
traffic. This is in part because the FQ sparse flow prioritisation makes
sure that such flows get queueing priority.

Now obviously, there are going to be tradeoffs, and scenarios where
latency will suffer. But I would at least like to be able to explore
this, and I think with the API we are currently discussing that will be
possible. Another thing I want to explore is doing soft admission
control; i.e., if someone sends bulk traffic marked as VO, it will be
automatically demoted to BE traffic rather than locking everyone else
out. We've tested that with some success in the Cake scheduler, and it
may be applicable to WiFi as well.

>> > Also, in iwlwifi we actually have a HW queue per TID to facilitate
>> > aggregation, though we could just let mac80211 pick the next TXQ to
>> > serve and skip in the unlikely case that the HW queue for that is
>> > already full (which really shouldn't happen).
>> 
>> Yeah, there may be a need for the driver to be able to express some
>> constraints on the queues it can accept currently; may a bitmap of
>> eligible TID numbers, or just a way of saying "can't use this TXQ,
>> please give me another". But it may also be that it's enough for the
>> driver to just give up and try again later if it can't use the TXQ it
>> is assigned...
>
> I guess it could just move on to the next TID. There doesn't seem to
> be much point in saying "I can't service this high-priority TID, give
> me something lower priority instead" because it really should be
> servicing the higher priority first anyway, so just skipping if it
> can't be serviced seems fine.

Suppose so. I'll try it out :)

-Toke
