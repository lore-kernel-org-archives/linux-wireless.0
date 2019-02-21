Return-Path: <SRS0=z+ld=Q4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97155C43381
	for <linux-wireless@archiver.kernel.org>; Thu, 21 Feb 2019 17:15:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 667002083B
	for <linux-wireless@archiver.kernel.org>; Thu, 21 Feb 2019 17:15:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toke.dk header.i=@toke.dk header.b="k4UZdcJE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728482AbfBURPd (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 21 Feb 2019 12:15:33 -0500
Received: from mail.toke.dk ([52.28.52.200]:55595 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725823AbfBURPc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 21 Feb 2019 12:15:32 -0500
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=toke.dk; s=20161023;
        t=1550769330; bh=xgRMWZapN7RJybSL4nbf7WBoCk7TUo1gpMSKkfCA0x4=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=k4UZdcJESt78uB2WMj8Xg1xAmvmRb+1IOPTc1zezN1yEVYy/EItLpoNxcFZJyAcTM
         +Mya/8e0z4PaG/A6csPbJH0y92DaUTwcbSPqmLLaPzAdyDakZWpOlEeoeug1BE+aqi
         oWsUzCeiNm0mymh33CaMYlR2G7ehuj/dhEYxgpTCgjEjJivawLX8rrlYcHnggYBAGm
         kFVcshUux+sXNRocv52FOCxZ39LA7Mn+C6Te6Vp0/ennNQTbTDqpWy6emct/CKVMtb
         thHNujrBYJOWdiMhnK6fHQtBXSE7jpRfLMNEgF5mSF4FAHHJNJrdSp3j4lqhuA/SU0
         hkIZAqSrcK8fw==
To:     Ben Greear <greearb@candelatech.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc:     Grant Grundler <grundler@google.com>, Kan Yan <kyan@google.com>,
        linux-wireless@vger.kernel.org,
        Johannes Berg <johannes@sipsolutions.net>,
        wgong@qti.qualcomm.com, ath10k@lists.infradead.org,
        wgong@codeaurora.org
Subject: Re: [PATCH v2 2/2] ath10k: Set sk_pacing_shift to 6 for 11AC WiFi chips
In-Reply-To: <587631dd-f96a-999a-d61d-e5df5796766f@candelatech.com>
References: <1533724802-30944-1-git-send-email-wgong@codeaurora.org> <1533724802-30944-3-git-send-email-wgong@codeaurora.org> <87sh3pdtpg.fsf@toke.dk> <f185ab8722e84c959b375e606d25a29b@aptaiexm02f.ap.qualcomm.com> <87mutue4y8.fsf@toke.dk> <ef7b317006964c0fa72763bbfc5149e5@aptaiexm02f.ap.qualcomm.com> <CANEJEGvcj9gPT8yy++qvi3hz3t9pAXyeUves06gr+ADfn9Ouhg@mail.gmail.com> <1535967508.3437.31.camel@sipsolutions.net> <87in3m25uu.fsf@toke.dk> <1535975240.3437.61.camel@sipsolutions.net> <878t4i1z74.fsf@toke.dk> <CANEJEGsm_BKM6g2x0+a7_5dBy5jkROs+jEjHmrcneGrMdDK41g@mail.gmail.com> <871sa7ylmi.fsf@toke.dk> <CANEJEGuBoRMBJBOrFOYyPtiJSMfTahrVgTfxZ2ift6Q5uGazFA@mail.gmail.com> <87r2c1i1vj.fsf@toke.dk> <871s41nmvx.fsf@kamboji.qca.qualcomm.com> <ecc20e01-1515-d227-62d8-377f3c35e449@candelatech.com> <87ftshhzby.fsf@toke.dk> <587631dd-f96a-999a-d61d-e5df5796766f@candelatech.com>
Date:   Thu, 21 Feb 2019 18:15:30 +0100
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <87d0nlhxl9.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Ben Greear <greearb@candelatech.com> writes:

> On 2/21/19 8:37 AM, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>> Ben Greear <greearb@candelatech.com> writes:
>>=20
>>> On 2/21/19 8:10 AM, Kalle Valo wrote:
>>>> Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke.dk> writes:
>>>>
>>>>> Grant Grundler <grundler@google.com> writes:
>>>>>
>>>>>> On Thu, Sep 6, 2018 at 3:18 AM Toke H=C3=B8iland-J=C3=B8rgensen <tok=
e@toke.dk> wrote:
>>>>>>>
>>>>>>> Grant Grundler <grundler@google.com> writes:
>>>>>>>
>>>>>>>>> And, well, Grant's data is from a single test in a noisy
>>>>>>>>> environment where the time series graph shows that throughput is =
all over
>>>>>>>>> the place for the duration of the test; so it's hard to draw solid
>>>>>>>>> conclusions from (for instance, for the 5-stream test, the average
>>>>>>>>> throughput for 6 is 331 and 379 Mbps for the two repetitions, and=
 for 7
>>>>>>>>> it's 326 and 371 Mbps) . Unfortunately I don't have the same hard=
ware
>>>>>>>>> used in this test, so I can't go verify it myself; so the only th=
ing I
>>>>>>>>> can do is grumble about it here... :)
>>>>>>>>
>>>>>>>> It's a fair complaint and I agree with it. My counter argument is =
the
>>>>>>>> opposite is true too: most ideal benchmarks don't measure what most
>>>>>>>> users see. While the data wgong provided are way more noisy than I
>>>>>>>> like, my overall "confidence" in the "conclusion" I offered is sti=
ll
>>>>>>>> positive.
>>>>>>>
>>>>>>> Right. I guess I would just prefer a slightly more comprehensive
>>>>>>> evaluation to base a 4x increase in buffer size on...
>>>>>>
>>>>>> Kalle, is this why you didn't accept this patch? Other reasons?
>>>>>>
>>>>>> Toke, what else would you like to see evaluated?
>>>>>>
>>>>>> I generally want to see three things measured when "benchmarking"
>>>>>> technologies: throughput, latency, cpu utilization
>>>>>> We've covered those three I think "reasonably".
>>>>>
>>>>> Hmm, going back and looking at this (I'd completely forgotten about t=
his
>>>>> patch), I think I had two main concerns:
>>>>>
>>>>> 1. What happens in a degraded signal situation, where the throughput =
is
>>>>>      limited by the signal conditions, or by contention with other de=
vices.
>>>>>      Both of these happen regularly, and I worry that latency will be
>>>>>      badly affected under those conditions.
>>>>>
>>>>> 2. What happens with old hardware that has worse buffer management in
>>>>>      the driver->firmware path (especially drivers without push/pull =
mode
>>>>>      support)? For these, the lower-level queueing structure is less
>>>>>      effective at controlling queueing latency.
>>>>
>>>> Do note that this patch changes behaviour _only_ for QCA6174 and QCA93=
77
>>>> PCI devices, which IIRC do not even support push/pull mode. All the
>>>> rest, including QCA988X and QCA9984 are unaffected.
>>>
>>> Just as a note, at least kernels such as 4.14.whatever perform poorly w=
hen
>>> running ath10k on 9984 when acting as TCP endpoints.  This makes them n=
ot
>>> really usable for stuff like serving video to lots of clients.
>>>
>>> Tweaking TCP (I do it a bit differently, but either way) can significan=
tly
>>> improve performance.
>>=20
>> Differently how? Did you have to do more than fiddle with the pacing_shi=
ft?
>
> This one, or a slightly tweaked version that applies to different kernels:
>
> https://github.com/greearb/linux-ct-4.16/commit/3e14e8491a5b31ce994fb2752=
347145e6ab7eaf5

Right; but the current mac80211 default (pacing shift 8) corresponds to
setting your sysctl to 4...

>>> Recently I helped a user that could get barely 70 stations streaming
>>> at 1Mbps on stock kernel (using one wave1 on 2.4, one wave-2 on 5Ghz),
>>> and we got 110 working with a tweaked TCP stack. These were /n
>>> stations too.
>>>
>>> I think it is lame that it _still_ requires out of tree patches to
>>> make TCP work well on ath10k...even if you want to default to current
>>> behaviour, you should allow users to tweak it to work with their use
>>> case.
>>=20
>> Well if TCP is broken to the point of being unusable I do think we
>> should fix it; but I think "just provide a configuration knob" should be
>> the last resort...
>
> So, it has been broken for years, and waiting for a perfect solution
> has not gotten the problem fixed.

Well, the current default should at least be closer to something that
works well.

I do think I may have erred on the wrong side of the optimum when I
submitted the original patch to set the default to 8; that should
probably have been 7 (i.e., 8 ms; the optimum in the evaluation we did
was around 6 ms, which is sadly not a power of two). Maybe changing that
default is actually better than having to redo the testing for all the
different devices as we're discussing in the context of this patch.
Maybe I should just send a patch to do that...

-Toke
