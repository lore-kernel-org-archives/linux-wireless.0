Return-Path: <SRS0=z+ld=Q4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00ED5C43381
	for <linux-wireless@archiver.kernel.org>; Thu, 21 Feb 2019 15:43:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BF8C120823
	for <linux-wireless@archiver.kernel.org>; Thu, 21 Feb 2019 15:43:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toke.dk header.i=@toke.dk header.b="kN8JXnHB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726359AbfBUPnA (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 21 Feb 2019 10:43:00 -0500
Received: from mail.toke.dk ([52.28.52.200]:54309 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725858AbfBUPm7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 21 Feb 2019 10:42:59 -0500
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=toke.dk; s=20161023;
        t=1550763777; bh=doaz1XB0TUc9c1ENlxALGOQFvxjfF+zYyZMvP62z2CE=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=kN8JXnHBaw7nEuC82cV6dftzgZNhngmJfsMjM8Su8caRaUKGzy5HxeBFHGgtFrKga
         ctDQNjwcOrryPEUPe3befoGH2sydZrgR4gaCUeRv7jH4sVXvHUcSQxFtzhdyTR/x/u
         RKRUnMy0aTc/qiDXRkvsqN+bXTsAbFOhsbLf3Mtyl9Dp5M1lHb8GqSNqdxEA0MQC+Z
         B1RC2wFsdITIoCK/Ol3/9PqymzMEgKN8nV6nrcXKz91MXJe39WaNVnQ5SZuW39KdA5
         Gbq9AV0HiBjECxPJ1C34+u1ojYQufroWPTU0t8iWsnaljpXTdpDc5WkMCdJ7oQXDZ2
         kQvkfDMj64oMw==
To:     Grant Grundler <grundler@google.com>, Kan Yan <kyan@google.com>
Cc:     Johannes Berg <johannes@sipsolutions.net>, wgong@qti.qualcomm.com,
        wgong@codeaurora.org, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2 2/2] ath10k: Set sk_pacing_shift to 6 for 11AC WiFi chips
In-Reply-To: <CANEJEGuBoRMBJBOrFOYyPtiJSMfTahrVgTfxZ2ift6Q5uGazFA@mail.gmail.com>
References: <1533724802-30944-1-git-send-email-wgong@codeaurora.org> <1533724802-30944-3-git-send-email-wgong@codeaurora.org> <87sh3pdtpg.fsf@toke.dk> <f185ab8722e84c959b375e606d25a29b@aptaiexm02f.ap.qualcomm.com> <87mutue4y8.fsf@toke.dk> <ef7b317006964c0fa72763bbfc5149e5@aptaiexm02f.ap.qualcomm.com> <CANEJEGvcj9gPT8yy++qvi3hz3t9pAXyeUves06gr+ADfn9Ouhg@mail.gmail.com> <1535967508.3437.31.camel@sipsolutions.net> <87in3m25uu.fsf@toke.dk> <1535975240.3437.61.camel@sipsolutions.net> <878t4i1z74.fsf@toke.dk> <CANEJEGsm_BKM6g2x0+a7_5dBy5jkROs+jEjHmrcneGrMdDK41g@mail.gmail.com> <871sa7ylmi.fsf@toke.dk> <CANEJEGuBoRMBJBOrFOYyPtiJSMfTahrVgTfxZ2ift6Q5uGazFA@mail.gmail.com>
Date:   Thu, 21 Feb 2019 16:42:56 +0100
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <87r2c1i1vj.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Grant Grundler <grundler@google.com> writes:

> On Thu, Sep 6, 2018 at 3:18 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@tok=
e.dk> wrote:
>>
>> Grant Grundler <grundler@google.com> writes:
>>
>> >> And, well, Grant's data is from a single test in a noisy
>> >> environment where the time series graph shows that throughput is all =
over
>> >> the place for the duration of the test; so it's hard to draw solid
>> >> conclusions from (for instance, for the 5-stream test, the average
>> >> throughput for 6 is 331 and 379 Mbps for the two repetitions, and for=
 7
>> >> it's 326 and 371 Mbps) . Unfortunately I don't have the same hardware
>> >> used in this test, so I can't go verify it myself; so the only thing I
>> >> can do is grumble about it here... :)
>> >
>> > It's a fair complaint and I agree with it. My counter argument is the
>> > opposite is true too: most ideal benchmarks don't measure what most
>> > users see. While the data wgong provided are way more noisy than I
>> > like, my overall "confidence" in the "conclusion" I offered is still
>> > positive.
>>
>> Right. I guess I would just prefer a slightly more comprehensive
>> evaluation to base a 4x increase in buffer size on...
>
> Kalle, is this why you didn't accept this patch? Other reasons?
>
> Toke, what else would you like to see evaluated?
>
> I generally want to see three things measured when "benchmarking"
> technologies: throughput, latency, cpu utilization
> We've covered those three I think "reasonably".

Hmm, going back and looking at this (I'd completely forgotten about this
patch), I think I had two main concerns:

1. What happens in a degraded signal situation, where the throughput is
   limited by the signal conditions, or by contention with other devices.
   Both of these happen regularly, and I worry that latency will be
   badly affected under those conditions.

2. What happens with old hardware that has worse buffer management in
   the driver->firmware path (especially drivers without push/pull mode
   support)? For these, the lower-level queueing structure is less
   effective at controlling queueing latency.

Getting the queue size limit patches from ChromeOS ported would
alleviate point 2. I do believe Kan said he'd look into that once the
airtime patches were merged. So Kan, any progress on that front? :)

> What does a "4x increase in memory" mean here? Wen, how much more
> memory does this cause ath10k to use?

I didn't say "memory", I said "buffer size"... :)
I.e., it's the latency impact of the increased buffering I'm worried
about (see above), not the system memory usage.

-Toke
