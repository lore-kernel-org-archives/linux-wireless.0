Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.toke.dk ([52.28.52.200]:34429 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751184AbdJIJmz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 9 Oct 2017 05:42:55 -0400
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Johannes Berg <johannes@sipsolutions.net>,
        make-wifi-fast@lists.bufferbloat.net,
        linux-wireless@vger.kernel.org
Subject: Re: [RFC] mac80211: Add airtime fairness accounting
In-Reply-To: <1507533328.26041.12.camel@sipsolutions.net>
References: <20171006115232.28688-1-toke@toke.dk> <1507298832.19300.20.camel@sipsolutions.net> <87lgkoqrhs.fsf@toke.dk> <1507310319.19300.28.camel@sipsolutions.net> <87infrqk28.fsf@toke.dk> <1507533328.26041.12.camel@sipsolutions.net>
Date: Mon, 09 Oct 2017 11:42:50 +0200
Message-ID: <878tgkd5d1.fsf@toke.dk> (sfid-20171009_114319_522810_AED75EF6)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> On Sat, 2017-10-07 at 13:22 +0200, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>
>> Guess you are right that it will be difficult to get a completely
>> accurate number. But as David Lang notes, as long as we are off by
>> the same amount for all stations, that is fine - we're just
>> interested in relative numbers.
>
> That's not quite true though, you'd overestimate most on stations that
> are using aggregation, assuming you take into account the whole frame
> exchange sequence time. But maybe giving less than their fair share to
> fast stations isn't really that much of a problem.

Well, the padding and spacing between frames is at most 11 bytes (4-byte
delimiter, 4-byte FCS and 3-byte padding), which is ~0.7% of a
full-sized frame. I'm not too worried about errors on that scale, TBH.
Sure, it would be better to have it be accurate, but there are other
imperfections, especially on the RX side (we can't count
retransmissions, for instance, since the receiver obviously doesn't see
those).

>> > So ... no, I don't understand. You have a TXQ per _TID_, so
>> > splitting up this per _AC_ still doesn't make sense since you have
>> > two TXQs for each AC?
>>=20
>> Yeah, but ath9k schedules all TIDs on the same AC together. So if
>> station A has two TIDs active and station B one, the scheduling order
>> will be A1, A2, B1, basically. This is fine as long as they are all
>> on the same AC and scheduled together (in which case A1 and A2 will
>> just share the same deficit).
>
> Huh, I'm confused. Can you elaborate on this? How does it schedule two
> TIDs for _different_ ACs then?

There's a separate scheduling loop for each hardware queue (one per AC),
which only schedules all TXQs with that AC. The hardware will prioritise
higher ACs by dequeueing from the high-priority hardware queue first.

> It seems to me that to actually get the right QoS behaviour you have
> to schedule *stations*, and then while you're looking at a station,
> you need to select the highest-priority TXQ that has data? Otherwise,
> don't you end up doing fairness on a STA/AC rather than just on a STA,
> so that a station that uses two ACs gets twice as much airtime as one
> using just a single AC?

Yeah, that's what we have currently in ath9k. However, it's rare in
practice that a station transmits the same amount of data on all ACs
(for one, since the max aggregation size is smaller at the higher ACs
that becomes difficult). But you are quite right that this is something
that should be fixed :)

>> Ideally, I would prefer the scheduling to be "two-pass": First,
>> decide which physical station to send to, then decide which TID on
>> that station to service.=20
>
> Yeah, that would make more sense.
>
>> But because everything is done at the TID/TXQ level, that is not
>> quite trivial to achieve I think...
>
> Well you can group the TXQs, I guess. They all have a STA pointer, so
> you could put a one- or two-bit "schedule color" field into each
> station and if you find a TXQ with the same station color you just
> skip it or something like that?

Couldn't we add something like a get_next_txq(phy) function to mac80211
that the drivers can call to get the queue to pull packets from? That
way, responsibility for scheduling both stations and QoS levels falls to
mac80211, which makes it possible to do clever scheduling stuff without
having to re-implement it in every driver. Also, this function could
handle all the special TXQs for PS and non-data frames that you were
talking about in your other email?

Unless there's some reason I'm missing that the driver really needs to
schedule the TXQs, I think this would make a lot of sense?

-Toke
