Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.toke.dk ([52.28.52.200]:35363 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750883AbdJKO3K (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 11 Oct 2017 10:29:10 -0400
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Johannes Berg <johannes@sipsolutions.net>,
        make-wifi-fast@lists.bufferbloat.net,
        linux-wireless@vger.kernel.org
Subject: Re: [RFC 1/3] mac80211: Add TXQ scheduling API
In-Reply-To: <1507731344.1998.36.camel@sipsolutions.net>
References: <20171010140208.1515-1-toke@toke.dk> <1507651555.26041.81.camel@sipsolutions.net> <87fuaq7ubo.fsf@toke.dk> <1507711498.1998.18.camel@sipsolutions.net> <87tvz5pymm.fsf@toke.dk> <1507731344.1998.36.camel@sipsolutions.net>
Date: Wed, 11 Oct 2017 16:29:07 +0200
Message-ID: <87fuapbvws.fsf@toke.dk> (sfid-20171011_162931_467271_3AF4D94E)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> On Wed, 2017-10-11 at 16:06 +0200, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>
>> > Hmm, not sure. We really want this to be scheduled pretty much
>> > immediately because the other side will be waiting for the frames,
>> > and
>> > if we don't get an answer out quickly it'll have to assume we're
>> > broken. I don't know what the limit here is for our firmware, but
>> > we
>> > should really get this out as soon as possible in this case.
>>=20
>> OK. But presumably it can't preempt packets already pushed to the
>> hardware, right?=20
>
> True. If there are still packets scheduled then it needs even more
> driver tricks to drop those back to tx_pending first ...

Only for packets to the same station, right?

>> So telling the driver to immediately schedule a packet,
>> and making sure that the txq it gets from next_txq() is the right one
>> should do the trick? But I guess it's a bit of a roundabout way,
>> which may not be worth it to avoid an extra callback...
>
> Yeah, might work, but remember that we need to mangle the packet, and
> for that we need to know how many packets will go out. E.g. with U-
> APSD, if we tell the driver 8 packets are OK, and it only wants 6, then
> that's acceptable, but we have to tag the last of those with EOSP ...
>
> So one way or another I think we need a separate callback here, and
> perhaps just have the driver do the EOSP tagging, or have a separate
> function to pull the frames so mac80211 can do the tagging, dunno.

Yeah, sounds like it'll need a separate callback, or at least a flag.

What part of the standard do I have to read to learn how this is
supposed to work, BTW? Or even better, is there a resource that
describes how PS works that is more accessible than the standard itself?

> Note that this is only for _some_ drivers, others will implement much
> of this in firmware.

Right, of course. Fun times! :)

-Toke
