Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.toke.dk ([52.28.52.200]:45699 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750950AbdJFO3j (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 6 Oct 2017 10:29:39 -0400
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Johannes Berg <johannes@sipsolutions.net>,
        make-wifi-fast@lists.bufferbloat.net,
        linux-wireless@vger.kernel.org
Subject: Re: [RFC] mac80211: Add airtime fairness accounting
In-Reply-To: <1507298832.19300.20.camel@sipsolutions.net>
References: <20171006115232.28688-1-toke@toke.dk> <1507298832.19300.20.camel@sipsolutions.net>
Date: Fri, 06 Oct 2017 16:29:35 +0200
Message-ID: <87lgkoqrhs.fsf@toke.dk> (sfid-20171006_162943_513894_0EC0B695)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> On Fri, 2017-10-06 at 13:52 +0200, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>> This adds accounting of each station's airtime usage to mac80211. On
>> the RX side, airtime is calculated from the packet length and
>> duration.
>
> I think you should probably try to get something here from the driver?
> Doing the calculations is really awkward, because you have to take
> into account aggregation, etc.

Well, calculating the duration from the rate and size is what ath9k is
currently doing, and that has all the information available to do so (I
did verify that the airtime was almost identical on the TX and RX side
for the same traffic). But yeah, I guess that is not necessarily the
case for all drivers? Maybe having a field that the driver can fill in
is better (that also has the nice property that a driver that doesn't
supply any airtime information won't get the scheduling; which is
probably desirable).

> However, I'm not even sure that you _want_ to use RX airtime at all? I
> guess this is a fairly fundamental philosophical question, but there's
> no way to feed back "you're sending too much" to a station, so if it
> starts consuming a lot of airtime with (what we see as) RX, and we
> throttle sending to it, then I'm not sure that will have much effect?
> Maybe with TCP, but not really with anything else.

You're right that it does nothing for one-way UDP, of course. But not a
lot of traffic is actually one-way (most is either TCP or something like
Quic that also has a feedback loop). So in most of our tests we saw a
pretty nice effect from TCP back-pressure.

> You also can't really know what AC this was on, and it doesn't make all
> that much sense?
>
> Then again, I'm not even sure yet why you care about the AC at all?
> Should fairness really be something that's within an AC?

No, ideally it shouldn't. This is mostly an artifact of how ath9k
schedules TXQs independently for each AC. This means that if (say) three
stations are back-logged on the BE queue, and one of those also has the
occasional packet on the VO queue, if the deficit is shared between all
levels, every time a VO packet arrives that station effectively gets its
deficit reset to zero, meaning it will get too much airtime.

Having a separate deficit for each AC level is a crude workaround for
this, which is what we went with for the initial version in ath9k; and
this patch is just a straight-forward port of that. But I guess this is
a good opportunity to figure out how to solve this properly; I'll think
about how to do that (ideas welcome!)...

-Toke
