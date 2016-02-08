Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f175.google.com ([209.85.214.175]:36305 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753024AbcBHRql (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Feb 2016 12:46:41 -0500
Received: by mail-ob0-f175.google.com with SMTP id ba1so163100655obb.3
        for <linux-wireless@vger.kernel.org>; Mon, 08 Feb 2016 09:46:41 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <56B87ABA.5000307@openwrt.org>
References: <1454920723-48071-1-git-send-email-nbd@openwrt.org>
	<CANUX_P2qQmCPvFV4SqWxGQb_JzVqQ+_nT6LFtcYb37s5KfEfdw@mail.gmail.com>
	<CABPxzY+dgMWDeQ=_c0xyFq0g7HcP459b5Ypy3OoUwjDi+eooMA@mail.gmail.com>
	<56B87625.6040206@openwrt.org>
	<CABPxzY+ub1Qtwawzge2XCo67OPba1Rgd6HZTm6bhjzfOuNtFEw@mail.gmail.com>
	<56B87ABA.5000307@openwrt.org>
Date: Mon, 8 Feb 2016 09:46:41 -0800
Message-ID: <CAA93jw4t_uCShbVoJ-XV8E8_8-SBvrSqQE49d2c8GzddwE=kZQ@mail.gmail.com> (sfid-20160208_184645_911364_F3F037A2)
Subject: Re: [RFC v4] mac80211: add A-MSDU tx support
From: Dave Taht <dave.taht@gmail.com>
To: Felix Fietkau <nbd@openwrt.org>
Cc: Krishna Chaitanya <chaitanya.mgit@gmail.com>,
	Emmanuel Grumbach <egrumbach@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	Stuart Cheshire <cheshire@gmail.com>,
	Juliusz Chroboczek <jch@pps.univ-paris-diderot.fr>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 8, 2016 at 3:23 AM, Felix Fietkau <nbd@openwrt.org> wrote:
> On 2016-02-08 12:06, Krishna Chaitanya wrote:
>> On Mon, Feb 8, 2016 at 4:34 PM, Felix Fietkau <nbd@openwrt.org> wrote:
>>> On 2016-02-08 10:54, Krishna Chaitanya wrote:
>>>> On Mon, Feb 8, 2016 at 2:56 PM, Emmanuel Grumbach <egrumbach@gmail.com> wrote:
>>>>> On Mon, Feb 8, 2016 at 10:38 AM, Felix Fietkau <nbd@openwrt.org> wrote:
>>>>>> Requires software tx queueing support. frag_list support (for zero-copy)
>>>>>> is optional.
>>>>>>
>>>>>> Signed-off-by: Felix Fietkau <nbd@openwrt.org>
>>>>>> ---
>>>>>
>>>>>
>>>>> Ok - looks fine, but... and here comes the hard stuff.
>>>>> The frame size in the PLCP is limited in a way that you can't - from a
>>>>> spec POV - enable A-MSDU for low rates. Of course, you don't want to
>>>>> do that for low rates at all regardless of the spec.
>>>>> Since you build the A-MSDU in the mac80211 Tx queue which is not aware
>>>>> of the link quality, how do we prevent A-MSDU if the rate is low /
>>>>> dropping.
>>>>> I'd even argue that when the rates get lower, you'll  have more
>>>>> packets piling up in the software queue and ... even more chance to
>>>>> get A-MSDU in the exact case where you really want to avoid it?
>>>>
>>>> Similar to triggering AMPDU setup, we should put this control
>>>> in RC (minstrel) to start/stop AMSDU based on link quality/if the rates
>>>> drop below a pre-defined MCS (or) only for best-throughput rates.
>>> I think starting/stopping A-MSDU based on the rate is a bad idea.
>>> Even with low rates, using A-MSDU can be a good thing (especially for
>>> TCP ACKs), it just needs different size limits.
>>
>> By low rates, i was referring to bad channel conditions (more
>> retries/crc errors)
>> so using AMSDU might trigger more TCP level retries and for case
>> of TCP ACK's its still worse in that it triggers TCP data retires from the
>> peer.
> Based on the research and data from the Bufferbloat project, I'd say
> that in this case the latency due to queue buildup is a lot more harmful
> than lost packets.

+1.

> With unmanaged queues, the latency will cause unnecessary
> retransmissions anyway.

typically at greater than 250ms, yes.

It's my hope that everyone has agreed that > 250ms of queuing is bad,
except for actual transit to the moon and back, at this point. My hope
is that everyone can aim for < 20ms in the more general case.

I was very happy to see the iwl patch go by cutting things down from
seconds to 30-250ms under load, but am now puzzled.

One iwl user has reported that AMPDUs are disabled by default on iwl,
and had to do this:

options iwlwifi 11n_disable=8

For a 4fold reduction in latency under load in his tests, iwl to ath9k.

What enables/disable AMPDU and AMSDU in the general case?

> With managed queues, packet drops start increasing with latency until
> TCP starts behaving properly.
> In both cases you have extra TCP retransmissions...

One thrust of mine has been to get ecn more widely adopted, which
would eliminate the tcp retransmit problem on devices using it for
congestion control (except on actual loss).

Apple turned ecn on universally on all dev devices last august. They
ran into trouble with one major ISP and had to turn it off, I am not
sure if they shipped with it on or not.

https://plus.google.com/u/0/107942175615993706558/posts/1j8nXtLGZDm

Stuart Cheshire also points at a real case where excessive queuing
hurts and fq doesn't help - screen sharing - with a nice demo
combining fq_codel + the tcp_netsent_lowat option. (his talk starts at
about 16 minutes in, he goes into the relevant bits at about 24
minutes in, and I'm sorry for always pointing people at talks rather
than papers)

Toke ("the good, the bad, and the wifi") points to excessive queuing
*not* being a problem so long as the fq portion is sufficiently close
to the hardware, in other scenarios.

http://www.sciencedirect.com/science/article/pii/S1389128615002479

Now, as to whether a driver or device doing retransmits should (or
even could) drop or mark packets is a good question. I am biased
towards achieving low latency and per device fairness so I lean
towards giving up a lot sooner in bad conditions and moving on....

> With bad conditions you also get a strong increase in per-TXOP latency.

Having an agreed upon table for all the "bad" conditions and what
should be done in these cases would be good. I don't regard
"contention" as a bad condition, but as an indicator to be smarter
about bunching up and/or discarding packets. Interference is a "bad"
condition. Low rates for one station compared to the others is not a
bad condition, as striving for airtime fairness between all stations
is a reasonable goal... etc...


> With A-MSDU you need fewer TXOPs for the same amount of data in the queue.

I like it. :)

I note that for stations, I am perpetually seeing this sort of behavior:

ap -> transmits a bunch of packets to station
station -> takes 2 or more txops to respond

why? it takes some processing time for the station to send out it's
next batch of packets. Slightly better to wait until more stuff is
batched up (and I know, this is hard)

(it sounds like the iwl defers the aggregation decision, so might not
do this. ath9k will do this)

I would like to be testing for this behavior.


>
> - Felix
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
