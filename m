Return-Path: <SRS0=j5ME=N6=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25BA6C43441
	for <linux-wireless@archiver.kernel.org>; Mon, 19 Nov 2018 18:01:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CFC7221104
	for <linux-wireless@archiver.kernel.org>; Mon, 19 Nov 2018 18:01:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CFC7221104
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=taht.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731600AbeKTE0P convert rfc822-to-8bit (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 19 Nov 2018 23:26:15 -0500
Received: from mail.taht.net ([176.58.107.8]:56594 "EHLO mail.taht.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730227AbeKTE0O (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Nov 2018 23:26:14 -0500
X-Greylist: delayed 370 seconds by postgrey-1.27 at vger.kernel.org; Mon, 19 Nov 2018 23:26:13 EST
Received: from dancer.taht.net (unknown [IPv6:2603:3024:1536:86f0:eea8:6bff:fefe:9a2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.taht.net (Postfix) with ESMTPSA id 4E44121367;
        Mon, 19 Nov 2018 17:55:29 +0000 (UTC)
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
        <87sh02tfsp.fsf@toke.dk>
Date:   Mon, 19 Nov 2018 09:55:16 -0800
In-Reply-To: <87sh02tfsp.fsf@toke.dk> ("Toke \=\?utf-8\?Q\?H\=C3\=B8iland-J\?\=
 \=\?utf-8\?Q\?\=C3\=B8rgensen\=22's\?\= message of
        "Thu, 15 Nov 2018 09:24:22 -0800")
Message-ID: <878t1p2bqz.fsf@taht.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Toke Høiland-Jørgensen <toke@toke.dk> writes:

> Felix Fietkau <nbd@nbd.name> writes:
>
>> On 2018-11-14 18:40, Toke Høiland-Jørgensen wrote:
>>>> This part doesn't really make much sense to me, but maybe I'm
>>>> misunderstanding how the code works.
>>>> Let's assume we have a driver like ath9k or mt76, which tries to keep a
>>>> number of aggregates in the hardware queue, and the hardware queue is
>>>> currently empty.
>>>> If the current txq entry is kept at the head of the schedule list,
>>>> wouldn't the code just pull from that one over and over again, until
>>>> enough packets are transmitted by the hardware and their tx status
>>>> processed?
>>>> It seems to me that while fairness is still preserved in the long run,
>>>> this could lead to rather bursty scheduling, which may not be
>>>> particularly latency friendly.
>>> 
>>> Yes, it'll be a bit more bursty when the hardware queue is completely
>>> empty. However, when a TX completion comes back, that will adjust the
>>> deficit of that sta and cause it to be rotated on the next dequeue. This
>>> obviously relies on the fact that the lower-level hardware queue is
>>> sufficiently shallow to not add a lot of latency. But we want that to be
>>> the case anyway. In practice, it works quite well for ath9k, but not so
>>> well for ath10k because it has a large buffer in firmware.
>>> 
>>> If we requeue the TXQ at the end of the list, a station that is taking
>>> up too much airtime will fail to be throttled properly, so the
>>> queue-at-head is kinda needed to ensure fairness...
>> Thanks for the explanation, that makes sense to me. I have an idea on
>> how to mitigate the burstiness within the driver. I'll write it down in
>> pseudocode, please let me know if you think that'll work.
>
> I don't think it will, unfortunately. For example, consider the case
> where there are two stations queued; one with a large negative deficit
> (say, -10ms), and one with a positive deficit.

Perhaps a flag for one way or the other?

if(driver->has_absurd_hardware_queue_depth) doitthisway(); else
doitabetterway();

>
> In this case, we really need to throttle the station with a negative
> deficit. But if the driver loops and caches txqs, we'll get something
> like the following:
>
> - First driver loop iteration: returns TXQ with positive deficit.
> - Second driver loop iteration: Only the negative-deficit TXQ is in the
>   mac80211 list, so it will loop until that TXQ's deficit turns positive
>   and return it.
>
> Because of this, the negative-deficit station won't be throttled, and we
> won't get fairness.
>
> How many frames will mt76 queue up below the driver point? I.e., how
> much burstiness are you expecting this will introduce on that driver?
>
> Taking a step back, it's clear that it would be good to be able to
> dequeue packets to multiple STAs at once (we need that for MU-MIMO on
> ath10k as well). However, I don't think we can do that with the
> round-robin fairness scheduler; so we are going to need a different
> algorithm. I *think* it may be possible to do this with a virtual-time
> scheduler, but I haven't sat down and worked out the details yet...

The answer to which did not fit on the margins of your thesis. :)

I too have been trying to come up with a better means of gang
scheduling... for about 2 years now. In terms of bitmaps it looks a bit
like QFQ, but honestly...

Is there going to be some point where whatever we have here is
significantly better than what we had? Or not significantly worse? Or
handwavy enough to fix the rest once enlightenment arrives?

The perfect is the enemy of the good.

I'd rather like the intel folk to be weighing in on this stuff, too,
trying to get an API right requires use cases.

>
> -Toke
> _______________________________________________
> Make-wifi-fast mailing list
> Make-wifi-fast@lists.bufferbloat.net
> https://lists.bufferbloat.net/listinfo/make-wifi-fast
