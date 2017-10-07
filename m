Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.toke.dk ([52.28.52.200]:48503 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750931AbdJGLW1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 7 Oct 2017 07:22:27 -0400
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Johannes Berg <johannes@sipsolutions.net>,
        make-wifi-fast@lists.bufferbloat.net,
        linux-wireless@vger.kernel.org
Subject: Re: [RFC] mac80211: Add airtime fairness accounting
In-Reply-To: <1507310319.19300.28.camel@sipsolutions.net>
References: <20171006115232.28688-1-toke@toke.dk> <1507298832.19300.20.camel@sipsolutions.net> <87lgkoqrhs.fsf@toke.dk> <1507310319.19300.28.camel@sipsolutions.net>
Date: Sat, 07 Oct 2017 13:22:23 +0200
Message-ID: <87infrqk28.fsf@toke.dk> (sfid-20171007_132231_499752_1BFADE53)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> On Fri, 2017-10-06 at 16:29 +0200, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>> Johannes Berg <johannes@sipsolutions.net> writes:
>>=20
>> Well, calculating the duration from the rate and size is what ath9k
>> is currently doing, and that has all the information available to do
>> so (I did verify that the airtime was almost identical on the TX and
>> RX side for the same traffic).
>
> It's still iffy - with aggregation you might have a better idea of the
> total airtime, but not really see - in the higher layers - all the
> padding that comes between A-MPDUs etc. I think many drivers could do
> better by exposing the total airtime from the device/firmware, whereas
> exposing _all_ the little details that you need to calculate it post-
> facto will be really difficult, and make the calculation really hard.

Guess you are right that it will be difficult to get a completely
accurate number. But as David Lang notes, as long as we are off by the
same amount for all stations, that is fine - we're just interested in
relative numbers.

>> But yeah, I guess that is not necessarily the case for all drivers?
>> Maybe having a field that the driver can fill in is better (that also
>> has the nice property that a driver that doesn't supply any airtime
>> information won't get the scheduling; which is probably desirable).
>
> I think that'd be better, yes. Perhaps for some simple cases a helper
> function can be provided, but I'd want to actually know about those
> drivers before adding that.

Right, I'll add a field to rx_status instead that drivers can use.

>> You're right that it does nothing for one-way UDP, of course. But not
>> a lot of traffic is actually one-way (most is either TCP or something
>> like Quic that also has a feedback loop). So in most of our tests we
>> saw a pretty nice effect from TCP back-pressure.
>
> Yeah that makes some sense. I'm a bit concerned about pathological
> corner cases, you don't really know about the protocol used on top.
> Can a client starve itself by sending things? And perhaps, if it has a
> dumb higher layer protocol, it'll retransmit rather than back off, if
> it doesn't get the higher layer ACK?

I suppose a station that keeps sending flooding the airwaves (say, an
upstream CBR UDP flow with no feedback loop, at a rate higher than it
has bandwidth for) can lock itself out to some extent. I'll see if I can
get this to happen in my testbed with the ath9k code and report back on
what happens.

But for anything TCP-like with a feedback loop, the starvation will be
temporary as the lack of ACKs will cause the sender to eventually slow
down enough to get below its fair share.

>> Having a separate deficit for each AC level is a crude workaround for
>> this, which is what we went with for the initial version in ath9k;
>> and this patch is just a straight-forward port of that. But I guess
>> this is a good opportunity to figure out how to solve this properly;
>> I'll think about how to do that (ideas welcome!)...
>
> So ... no, I don't understand. You have a TXQ per _TID_, so splitting
> up this per _AC_ still doesn't make sense since you have two TXQs for
> each AC?

Yeah, but ath9k schedules all TIDs on the same AC together. So if
station A has two TIDs active and station B one, the scheduling order
will be A1, A2, B1, basically. This is fine as long as they are all on
the same AC and scheduled together (in which case A1 and A2 will just
share the same deficit).

But if there is only one TXQ active, every time that queue is scheduled,
the scheduler will loop until its deficit becomes positive (which is
generally good; that is how we make sure the scheduler is
work-conserving). However, if the deficit is shared with another
scheduling group (which in ath9k is another AC), the station in the
group by itself will not be limited to its fair share, because every
time it is scheduled by itself, its deficit is "reset".

Ideally, I would prefer the scheduling to be "two-pass": First, decide
which physical station to send to, then decide which TID on that station
to service. But because everything is done at the TID/TXQ level, that is
not quite trivial to achieve I think...

-Toke
