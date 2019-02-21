Return-Path: <SRS0=z+ld=Q4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6528CC43381
	for <linux-wireless@archiver.kernel.org>; Thu, 21 Feb 2019 17:29:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 297142083E
	for <linux-wireless@archiver.kernel.org>; Thu, 21 Feb 2019 17:29:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=candelatech.com header.i=@candelatech.com header.b="q7+apsOx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726626AbfBUR36 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 21 Feb 2019 12:29:58 -0500
Received: from mail2.candelatech.com ([208.74.158.173]:34880 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725831AbfBUR35 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 21 Feb 2019 12:29:57 -0500
Received: from [192.168.100.195] (firewall.candelatech.com [50.251.239.81])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail2.candelatech.com (Postfix) with ESMTPSA id D70D440A626;
        Thu, 21 Feb 2019 09:29:54 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail2.candelatech.com D70D440A626
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
        s=default; t=1550770195;
        bh=ce3i0JE25yQBx34CKg2dlKSQRQrS0gOFUsBG8Q1+wNU=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=q7+apsOx6PAoxpGg8i1NzZyb07QSxUgp6A8UQlWKCPZ/V3y92pi27MXBV2k2z84Gm
         6lgki2GOZm9HJNVU/9cDeFcblN8JnRi480SXffB9gO1S6flBSgn6dszG1BCaEIUVfg
         HQGef/tgWnJY9S1ATuCGXD/9OdmP0ao/3VP+gMgQ=
Subject: Re: [PATCH v2 2/2] ath10k: Set sk_pacing_shift to 6 for 11AC WiFi
 chips
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@toke.dk>,
        Kalle Valo <kvalo@codeaurora.org>
Cc:     Grant Grundler <grundler@google.com>, Kan Yan <kyan@google.com>,
        linux-wireless@vger.kernel.org,
        Johannes Berg <johannes@sipsolutions.net>,
        wgong@qti.qualcomm.com, ath10k@lists.infradead.org,
        wgong@codeaurora.org
References: <1533724802-30944-1-git-send-email-wgong@codeaurora.org>
 <1533724802-30944-3-git-send-email-wgong@codeaurora.org>
 <87sh3pdtpg.fsf@toke.dk>
 <f185ab8722e84c959b375e606d25a29b@aptaiexm02f.ap.qualcomm.com>
 <87mutue4y8.fsf@toke.dk>
 <ef7b317006964c0fa72763bbfc5149e5@aptaiexm02f.ap.qualcomm.com>
 <CANEJEGvcj9gPT8yy++qvi3hz3t9pAXyeUves06gr+ADfn9Ouhg@mail.gmail.com>
 <1535967508.3437.31.camel@sipsolutions.net> <87in3m25uu.fsf@toke.dk>
 <1535975240.3437.61.camel@sipsolutions.net> <878t4i1z74.fsf@toke.dk>
 <CANEJEGsm_BKM6g2x0+a7_5dBy5jkROs+jEjHmrcneGrMdDK41g@mail.gmail.com>
 <871sa7ylmi.fsf@toke.dk>
 <CANEJEGuBoRMBJBOrFOYyPtiJSMfTahrVgTfxZ2ift6Q5uGazFA@mail.gmail.com>
 <87r2c1i1vj.fsf@toke.dk> <871s41nmvx.fsf@kamboji.qca.qualcomm.com>
 <ecc20e01-1515-d227-62d8-377f3c35e449@candelatech.com>
 <87ftshhzby.fsf@toke.dk>
 <587631dd-f96a-999a-d61d-e5df5796766f@candelatech.com>
 <87d0nlhxl9.fsf@toke.dk>
From:   Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
Message-ID: <80d93903-0aac-ebde-711f-4d4254275aad@candelatech.com>
Date:   Thu, 21 Feb 2019 09:29:54 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <87d0nlhxl9.fsf@toke.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 2/21/19 9:15 AM, Toke Høiland-Jørgensen wrote:
> Ben Greear <greearb@candelatech.com> writes:
> 
>> On 2/21/19 8:37 AM, Toke Høiland-Jørgensen wrote:
>>> Ben Greear <greearb@candelatech.com> writes:
>>>
>>>> On 2/21/19 8:10 AM, Kalle Valo wrote:
>>>>> Toke Høiland-Jørgensen <toke@toke.dk> writes:
>>>>>
>>>>>> Grant Grundler <grundler@google.com> writes:
>>>>>>
>>>>>>> On Thu, Sep 6, 2018 at 3:18 AM Toke Høiland-Jørgensen <toke@toke.dk> wrote:
>>>>>>>>
>>>>>>>> Grant Grundler <grundler@google.com> writes:
>>>>>>>>
>>>>>>>>>> And, well, Grant's data is from a single test in a noisy
>>>>>>>>>> environment where the time series graph shows that throughput is all over
>>>>>>>>>> the place for the duration of the test; so it's hard to draw solid
>>>>>>>>>> conclusions from (for instance, for the 5-stream test, the average
>>>>>>>>>> throughput for 6 is 331 and 379 Mbps for the two repetitions, and for 7
>>>>>>>>>> it's 326 and 371 Mbps) . Unfortunately I don't have the same hardware
>>>>>>>>>> used in this test, so I can't go verify it myself; so the only thing I
>>>>>>>>>> can do is grumble about it here... :)
>>>>>>>>>
>>>>>>>>> It's a fair complaint and I agree with it. My counter argument is the
>>>>>>>>> opposite is true too: most ideal benchmarks don't measure what most
>>>>>>>>> users see. While the data wgong provided are way more noisy than I
>>>>>>>>> like, my overall "confidence" in the "conclusion" I offered is still
>>>>>>>>> positive.
>>>>>>>>
>>>>>>>> Right. I guess I would just prefer a slightly more comprehensive
>>>>>>>> evaluation to base a 4x increase in buffer size on...
>>>>>>>
>>>>>>> Kalle, is this why you didn't accept this patch? Other reasons?
>>>>>>>
>>>>>>> Toke, what else would you like to see evaluated?
>>>>>>>
>>>>>>> I generally want to see three things measured when "benchmarking"
>>>>>>> technologies: throughput, latency, cpu utilization
>>>>>>> We've covered those three I think "reasonably".
>>>>>>
>>>>>> Hmm, going back and looking at this (I'd completely forgotten about this
>>>>>> patch), I think I had two main concerns:
>>>>>>
>>>>>> 1. What happens in a degraded signal situation, where the throughput is
>>>>>>       limited by the signal conditions, or by contention with other devices.
>>>>>>       Both of these happen regularly, and I worry that latency will be
>>>>>>       badly affected under those conditions.
>>>>>>
>>>>>> 2. What happens with old hardware that has worse buffer management in
>>>>>>       the driver->firmware path (especially drivers without push/pull mode
>>>>>>       support)? For these, the lower-level queueing structure is less
>>>>>>       effective at controlling queueing latency.
>>>>>
>>>>> Do note that this patch changes behaviour _only_ for QCA6174 and QCA9377
>>>>> PCI devices, which IIRC do not even support push/pull mode. All the
>>>>> rest, including QCA988X and QCA9984 are unaffected.
>>>>
>>>> Just as a note, at least kernels such as 4.14.whatever perform poorly when
>>>> running ath10k on 9984 when acting as TCP endpoints.  This makes them not
>>>> really usable for stuff like serving video to lots of clients.
>>>>
>>>> Tweaking TCP (I do it a bit differently, but either way) can significantly
>>>> improve performance.
>>>
>>> Differently how? Did you have to do more than fiddle with the pacing_shift?
>>
>> This one, or a slightly tweaked version that applies to different kernels:
>>
>> https://github.com/greearb/linux-ct-4.16/commit/3e14e8491a5b31ce994fb2752347145e6ab7eaf5
> 
> Right; but the current mac80211 default (pacing shift 8) corresponds to
> setting your sysctl to 4...
> 
>>>> Recently I helped a user that could get barely 70 stations streaming
>>>> at 1Mbps on stock kernel (using one wave1 on 2.4, one wave-2 on 5Ghz),
>>>> and we got 110 working with a tweaked TCP stack. These were /n
>>>> stations too.
>>>>
>>>> I think it is lame that it _still_ requires out of tree patches to
>>>> make TCP work well on ath10k...even if you want to default to current
>>>> behaviour, you should allow users to tweak it to work with their use
>>>> case.
>>>
>>> Well if TCP is broken to the point of being unusable I do think we
>>> should fix it; but I think "just provide a configuration knob" should be
>>> the last resort...
>>
>> So, it has been broken for years, and waiting for a perfect solution
>> has not gotten the problem fixed.
> 
> Well, the current default should at least be closer to something that
> works well.
> 
> I do think I may have erred on the wrong side of the optimum when I
> submitted the original patch to set the default to 8; that should
> probably have been 7 (i.e., 8 ms; the optimum in the evaluation we did
> was around 6 ms, which is sadly not a power of two). Maybe changing that
> default is actually better than having to redo the testing for all the
> different devices as we're discussing in the context of this patch.
> Maybe I should just send a patch to do that...

It is hubris to think one setting works well for everyone.  Sure, set a good
default, but also let people tune the value.

And send the patches to stable so that users on older kernels can have good
performance.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

