Return-Path: <SRS0=z+ld=Q4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC465C43381
	for <linux-wireless@archiver.kernel.org>; Thu, 21 Feb 2019 16:37:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8936B2083B
	for <linux-wireless@archiver.kernel.org>; Thu, 21 Feb 2019 16:37:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toke.dk header.i=@toke.dk header.b="gn5sGb9V"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726344AbfBUQhz (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 21 Feb 2019 11:37:55 -0500
Received: from mail.toke.dk ([52.28.52.200]:58383 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725767AbfBUQhz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 21 Feb 2019 11:37:55 -0500
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=toke.dk; s=20161023;
        t=1550767073; bh=aoMjcOS2+u4QXHdpGGrxL0br5vR83sXLCT2ccGpK37g=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=gn5sGb9VAptEF+PoQAi5vNPGl5g6AeWkwazidxar3/LfkJEUVnFg1ALs/zlbgkSfS
         DpiFOYyMUEqF+rqFW7cHpb0waROLDlTjjb3k5GkWK55dA87HdH2ooHpYYnQ6CumcZ0
         TVcNYV3X0jO6ny2aqNyOQyOEmC8UeWnQqtYUaHNahQOcuusAzP7MDu8X26jcK7jj7V
         LNoiAP9Hg4omleblWwzCApv3X0CSUHFUXlOAQV4YnExAkpUSh56e38o/epMpuGaxfy
         tcl3crO69XxFHd5yFqHN4Ae8sAcFEmfLOP9M+S84/uqMwcM7H0vGvzP/i0ztbhp9lL
         iv+Pds+sYLw5w==
To:     Ben Greear <greearb@candelatech.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc:     Grant Grundler <grundler@google.com>, Kan Yan <kyan@google.com>,
        linux-wireless@vger.kernel.org,
        Johannes Berg <johannes@sipsolutions.net>,
        wgong@qti.qualcomm.com, ath10k@lists.infradead.org,
        wgong@codeaurora.org
Subject: Re: [PATCH v2 2/2] ath10k: Set sk_pacing_shift to 6 for 11AC WiFi chips
In-Reply-To: <ecc20e01-1515-d227-62d8-377f3c35e449@candelatech.com>
References: <1533724802-30944-1-git-send-email-wgong@codeaurora.org> <1533724802-30944-3-git-send-email-wgong@codeaurora.org> <87sh3pdtpg.fsf@toke.dk> <f185ab8722e84c959b375e606d25a29b@aptaiexm02f.ap.qualcomm.com> <87mutue4y8.fsf@toke.dk> <ef7b317006964c0fa72763bbfc5149e5@aptaiexm02f.ap.qualcomm.com> <CANEJEGvcj9gPT8yy++qvi3hz3t9pAXyeUves06gr+ADfn9Ouhg@mail.gmail.com> <1535967508.3437.31.camel@sipsolutions.net> <87in3m25uu.fsf@toke.dk> <1535975240.3437.61.camel@sipsolutions.net> <878t4i1z74.fsf@toke.dk> <CANEJEGsm_BKM6g2x0+a7_5dBy5jkROs+jEjHmrcneGrMdDK41g@mail.gmail.com> <871sa7ylmi.fsf@toke.dk> <CANEJEGuBoRMBJBOrFOYyPtiJSMfTahrVgTfxZ2ift6Q5uGazFA@mail.gmail.com> <87r2c1i1vj.fsf@toke.dk> <871s41nmvx.fsf@kamboji.qca.qualcomm.com> <ecc20e01-1515-d227-62d8-377f3c35e449@candelatech.com>
Date:   Thu, 21 Feb 2019 17:37:53 +0100
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <87ftshhzby.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Ben Greear <greearb@candelatech.com> writes:

> On 2/21/19 8:10 AM, Kalle Valo wrote:
>> Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke.dk> writes:
>>=20
>>> Grant Grundler <grundler@google.com> writes:
>>>
>>>> On Thu, Sep 6, 2018 at 3:18 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@=
toke.dk> wrote:
>>>>>
>>>>> Grant Grundler <grundler@google.com> writes:
>>>>>
>>>>>>> And, well, Grant's data is from a single test in a noisy
>>>>>>> environment where the time series graph shows that throughput is al=
l over
>>>>>>> the place for the duration of the test; so it's hard to draw solid
>>>>>>> conclusions from (for instance, for the 5-stream test, the average
>>>>>>> throughput for 6 is 331 and 379 Mbps for the two repetitions, and f=
or 7
>>>>>>> it's 326 and 371 Mbps) . Unfortunately I don't have the same hardwa=
re
>>>>>>> used in this test, so I can't go verify it myself; so the only thin=
g I
>>>>>>> can do is grumble about it here... :)
>>>>>>
>>>>>> It's a fair complaint and I agree with it. My counter argument is the
>>>>>> opposite is true too: most ideal benchmarks don't measure what most
>>>>>> users see. While the data wgong provided are way more noisy than I
>>>>>> like, my overall "confidence" in the "conclusion" I offered is still
>>>>>> positive.
>>>>>
>>>>> Right. I guess I would just prefer a slightly more comprehensive
>>>>> evaluation to base a 4x increase in buffer size on...
>>>>
>>>> Kalle, is this why you didn't accept this patch? Other reasons?
>>>>
>>>> Toke, what else would you like to see evaluated?
>>>>
>>>> I generally want to see three things measured when "benchmarking"
>>>> technologies: throughput, latency, cpu utilization
>>>> We've covered those three I think "reasonably".
>>>
>>> Hmm, going back and looking at this (I'd completely forgotten about this
>>> patch), I think I had two main concerns:
>>>
>>> 1. What happens in a degraded signal situation, where the throughput is
>>>     limited by the signal conditions, or by contention with other devic=
es.
>>>     Both of these happen regularly, and I worry that latency will be
>>>     badly affected under those conditions.
>>>
>>> 2. What happens with old hardware that has worse buffer management in
>>>     the driver->firmware path (especially drivers without push/pull mode
>>>     support)? For these, the lower-level queueing structure is less
>>>     effective at controlling queueing latency.
>>=20
>> Do note that this patch changes behaviour _only_ for QCA6174 and QCA9377
>> PCI devices, which IIRC do not even support push/pull mode. All the
>> rest, including QCA988X and QCA9984 are unaffected.
>
> Just as a note, at least kernels such as 4.14.whatever perform poorly when
> running ath10k on 9984 when acting as TCP endpoints.  This makes them not
> really usable for stuff like serving video to lots of clients.
>
> Tweaking TCP (I do it a bit differently, but either way) can significantly
> improve performance.

Differently how? Did you have to do more than fiddle with the pacing_shift?

> Recently I helped a user that could get barely 70 stations streaming
> at 1Mbps on stock kernel (using one wave1 on 2.4, one wave-2 on 5Ghz),
> and we got 110 working with a tweaked TCP stack. These were /n
> stations too.
>
> I think it is lame that it _still_ requires out of tree patches to
> make TCP work well on ath10k...even if you want to default to current
> behaviour, you should allow users to tweak it to work with their use
> case.

Well if TCP is broken to the point of being unusable I do think we
should fix it; but I think "just provide a configuration knob" should be
the last resort...

-Toke
