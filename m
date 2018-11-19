Return-Path: <SRS0=j5ME=N6=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0922C43441
	for <linux-wireless@archiver.kernel.org>; Mon, 19 Nov 2018 23:30:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8EF5420851
	for <linux-wireless@archiver.kernel.org>; Mon, 19 Nov 2018 23:30:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8EF5420851
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=taht.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731677AbeKTJ4b convert rfc822-to-8bit (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 20 Nov 2018 04:56:31 -0500
Received: from mail.taht.net ([176.58.107.8]:56654 "EHLO mail.taht.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730692AbeKTJ4b (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 20 Nov 2018 04:56:31 -0500
Received: from dancer.taht.net (unknown [IPv6:2603:3024:1536:86f0:eea8:6bff:fefe:9a2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.taht.net (Postfix) with ESMTPSA id 4D1A2228A5;
        Mon, 19 Nov 2018 23:30:24 +0000 (UTC)
From:   Dave Taht <dave@taht.net>
To:     Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
Cc:     Felix Fietkau <nbd@nbd.name>,
        Rajkumar Manoharan <rmanohar@codeaurora.org>,
        linux-wireless@vger.kernel.org, ath10k@lists.infradead.org,
        make-wifi-fast@lists.bufferbloat.net
Subject: Re: [Make-wifi-fast] [PATCH v3 3/6] mac80211: Add airtime accounting and scheduling to TXQs
References: <1542063113-22438-1-git-send-email-rmanohar@codeaurora.org>
        <1542063113-22438-4-git-send-email-rmanohar@codeaurora.org>
        <e5344cad-2a18-a938-f2ed-43870027251c@nbd.name>
        <871s7nv9pl.fsf@toke.dk>
        <8e7847ff-4c88-10ae-2223-2fc7321641d9@nbd.name>
        <87sh02tfsp.fsf@toke.dk> <878t1p2bqz.fsf@taht.net>
        <87muq4sn50.fsf@toke.dk>
Date:   Mon, 19 Nov 2018 15:30:12 -0800
In-Reply-To: <87muq4sn50.fsf@toke.dk> ("Toke \=\?utf-8\?Q\?H\=C3\=B8iland-J\?\=
 \=\?utf-8\?Q\?\=C3\=B8rgensen\=22's\?\= message of
        "Mon, 19 Nov 2018 14:44:43 -0800")
Message-ID: <87efbgejcr.fsf@taht.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Toke Høiland-Jørgensen <toke@toke.dk> writes:

> Dave Taht <dave@taht.net> writes:
>
>> Toke Høiland-Jørgensen <toke@toke.dk> writes:
>>
>>> Felix Fietkau <nbd@nbd.name> writes:
>>>
>>>> On 2018-11-14 18:40, Toke Høiland-Jørgensen wrote:
>>>>>> This part doesn't really make much sense to me, but maybe I'm
>>>>>> misunderstanding how the code works.
>>>>>> Let's assume we have a driver like ath9k or mt76, which tries to keep a
>>>>>> number of aggregates in the hardware queue, and the hardware queue is
>>>>>> currently empty.
>>>>>> If the current txq entry is kept at the head of the schedule list,
>>>>>> wouldn't the code just pull from that one over and over again, until
>>>>>> enough packets are transmitted by the hardware and their tx status
>>>>>> processed?
>>>>>> It seems to me that while fairness is still preserved in the long run,
>>>>>> this could lead to rather bursty scheduling, which may not be
>>>>>> particularly latency friendly.
>>>>> 
>>>>> Yes, it'll be a bit more bursty when the hardware queue is completely
>>>>> empty. However, when a TX completion comes back, that will adjust the
>>>>> deficit of that sta and cause it to be rotated on the next dequeue. This
>>>>> obviously relies on the fact that the lower-level hardware queue is
>>>>> sufficiently shallow to not add a lot of latency. But we want that to be
>>>>> the case anyway. In practice, it works quite well for ath9k, but not so
>>>>> well for ath10k because it has a large buffer in firmware.
>>>>> 
>>>>> If we requeue the TXQ at the end of the list, a station that is taking
>>>>> up too much airtime will fail to be throttled properly, so the
>>>>> queue-at-head is kinda needed to ensure fairness...
>>>> Thanks for the explanation, that makes sense to me. I have an idea on
>>>> how to mitigate the burstiness within the driver. I'll write it down in
>>>> pseudocode, please let me know if you think that'll work.
>>>
>>> I don't think it will, unfortunately. For example, consider the case
>>> where there are two stations queued; one with a large negative deficit
>>> (say, -10ms), and one with a positive deficit.
>>
>> Perhaps a flag for one way or the other?
>>
>> if(driver->has_absurd_hardware_queue_depth) doitthisway(); else
>> doitabetterway();
>
> Well, there's going to be a BQL-like queue limit (but for airtime) on
> top, which drivers can opt-in to if the hardware has too much queueing.
>
>>> In this case, we really need to throttle the station with a negative
>>> deficit. But if the driver loops and caches txqs, we'll get something
>>> like the following:
>>>
>>> - First driver loop iteration: returns TXQ with positive deficit.
>>> - Second driver loop iteration: Only the negative-deficit TXQ is in the
>>>   mac80211 list, so it will loop until that TXQ's deficit turns positive
>>>   and return it.
>>>
>>> Because of this, the negative-deficit station won't be throttled, and we
>>> won't get fairness.
>>>
>>> How many frames will mt76 queue up below the driver point? I.e., how
>>> much burstiness are you expecting this will introduce on that driver?
>>>
>>> Taking a step back, it's clear that it would be good to be able to
>>> dequeue packets to multiple STAs at once (we need that for MU-MIMO on
>>> ath10k as well). However, I don't think we can do that with the
>>> round-robin fairness scheduler; so we are going to need a different
>>> algorithm. I *think* it may be possible to do this with a virtual-time
>>> scheduler, but I haven't sat down and worked out the details yet...
>>
>> The answer to which did not fit on the margins of your thesis. :)
>>
>> I too have been trying to come up with a better means of gang
>> scheduling... for about 2 years now. In terms of bitmaps it looks a bit
>> like QFQ, but honestly...
>
> It's not the gang scheduling we need, deciding which devices to send to
> at once is generally done in firmware anyway.

I have a long held dream that one day some firmware will be able to send
an interrupt and some information along...

"Hi, I'll be done transmitting/receiving in about 1ms, here's who I
think I can talk to next, and here's who else I maybe could gang schedule".

That would let us get away from 5ms wasted in the "ready to go" portion
of the algo, and share the highest likelyhood "groups" with the higher
layer.

> We just need to be able to
> dequeue packets for more than one station when possible.

And a huge fantasy is in some future 802.11ZZZ standard the on-board firmware and
the linux drivers can be co-designed, even, dare I say, open sourced, to
better evolve to meet real world requirements.

mbox's per station would be nice, with scatter/gather I/O... I
can think of a zillion things I'd want the firmware to handle (other
than buffering)

> I don't think
> we need the fancy bitmap stuff from QFQ since we don't have that many
> stations to schedule at once; so we can probably live with O(log(n)) in
> the number of active stations.

Best of two or three "groups", per above, from the firmware.

>> Is there going to be some point where whatever we have here is
>> significantly better than what we had? Or not significantly worse? Or
>> handwavy enough to fix the rest once enlightenment arrives?
>>
>> The perfect is the enemy of the good.
>
> Well, what we have now works for ath9k, works reasonably well for ath10k
> in pull mode, not so well for ath10k in push mode, and then there's
> Felix' comments in this thread...

So how about, an ath10k in a friggin "co-operative" mode? 

What are the performance differences in ath10k in push mode? Why do we
care if this mode works at all? 

Perfect, verses "good".

>> I'd rather like the intel folk to be weighing in on this stuff, too,
>> trying to get an API right requires use cases.
>
> Johannes has already reviewed a previous version, and I do believe he
> said he'd review it again once we have converged on something :)

Would intel care if only the pull mode worked well on their hardware? Do
they have a pull or push mode?

