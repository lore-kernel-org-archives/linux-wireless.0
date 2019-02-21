Return-Path: <SRS0=z+ld=Q4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79388C43381
	for <linux-wireless@archiver.kernel.org>; Thu, 21 Feb 2019 16:10:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 39A912083E
	for <linux-wireless@archiver.kernel.org>; Thu, 21 Feb 2019 16:10:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="DENS+qbQ";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="ZvIUXQej"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728037AbfBUQKT (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 21 Feb 2019 11:10:19 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:40516 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725880AbfBUQKT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 21 Feb 2019 11:10:19 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id C4E0E60D02; Thu, 21 Feb 2019 16:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1550765418;
        bh=mdoWTmLIp6jcSgRnPkX8mo2XSJbNsazpfOKQb0tnWxE=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=DENS+qbQTbxUT6PcVxvLy3p1rusE1hHFV3evhov/rikEJ4H5ZTJZhr+nCyxCiTTnX
         2xFd0ytQdVRnwBsNJ0LkEornFUY2QYu5qhRbyYUIJneqL50Ikd2o5lr+VDckU2yaFk
         uOE6CV43IFY2CsDvmI8/r2lOpAYqzpVemP+S5wVw=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 0920460C88;
        Thu, 21 Feb 2019 16:10:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1550765415;
        bh=mdoWTmLIp6jcSgRnPkX8mo2XSJbNsazpfOKQb0tnWxE=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=ZvIUXQejZ45Crnz5F0gsq9S7vZeYWjMKX5nfREVUT6TDrroV9VTcp5RHrlxrhWXSS
         GhvPntAXsUNlHbRIjvxzHGGCMf4YUeqO5VE+rAryl/sOXpEFosTFvJQ4Q8bRvCZvU3
         O7x4/+om8q1mlSDxDoPiv/0ZXwQ0mVabwwFUKDJg=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 0920460C88
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
Cc:     Grant Grundler <grundler@google.com>, Kan Yan <kyan@google.com>,
        linux-wireless@vger.kernel.org,
        Johannes Berg <johannes@sipsolutions.net>,
        wgong@qti.qualcomm.com, ath10k@lists.infradead.org,
        wgong@codeaurora.org
Subject: Re: [PATCH v2 2/2] ath10k: Set sk_pacing_shift to 6 for 11AC WiFi chips
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
        <87r2c1i1vj.fsf@toke.dk>
Date:   Thu, 21 Feb 2019 18:10:10 +0200
In-Reply-To: <87r2c1i1vj.fsf@toke.dk> ("Toke \=\?utf-8\?Q\?H\=C3\=B8iland-J\?\=
 \=\?utf-8\?Q\?\=C3\=B8rgensen\=22's\?\= message of
        "Thu, 21 Feb 2019 16:42:56 +0100")
Message-ID: <871s41nmvx.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke.dk> writes:

> Grant Grundler <grundler@google.com> writes:
>
>> On Thu, Sep 6, 2018 at 3:18 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@to=
ke.dk> wrote:
>>>
>>> Grant Grundler <grundler@google.com> writes:
>>>
>>> >> And, well, Grant's data is from a single test in a noisy
>>> >> environment where the time series graph shows that throughput is all=
 over
>>> >> the place for the duration of the test; so it's hard to draw solid
>>> >> conclusions from (for instance, for the 5-stream test, the average
>>> >> throughput for 6 is 331 and 379 Mbps for the two repetitions, and fo=
r 7
>>> >> it's 326 and 371 Mbps) . Unfortunately I don't have the same hardware
>>> >> used in this test, so I can't go verify it myself; so the only thing=
 I
>>> >> can do is grumble about it here... :)
>>> >
>>> > It's a fair complaint and I agree with it. My counter argument is the
>>> > opposite is true too: most ideal benchmarks don't measure what most
>>> > users see. While the data wgong provided are way more noisy than I
>>> > like, my overall "confidence" in the "conclusion" I offered is still
>>> > positive.
>>>
>>> Right. I guess I would just prefer a slightly more comprehensive
>>> evaluation to base a 4x increase in buffer size on...
>>
>> Kalle, is this why you didn't accept this patch? Other reasons?
>>
>> Toke, what else would you like to see evaluated?
>>
>> I generally want to see three things measured when "benchmarking"
>> technologies: throughput, latency, cpu utilization
>> We've covered those three I think "reasonably".
>
> Hmm, going back and looking at this (I'd completely forgotten about this
> patch), I think I had two main concerns:
>
> 1. What happens in a degraded signal situation, where the throughput is
>    limited by the signal conditions, or by contention with other devices.
>    Both of these happen regularly, and I worry that latency will be
>    badly affected under those conditions.
>
> 2. What happens with old hardware that has worse buffer management in
>    the driver->firmware path (especially drivers without push/pull mode
>    support)? For these, the lower-level queueing structure is less
>    effective at controlling queueing latency.

Do note that this patch changes behaviour _only_ for QCA6174 and QCA9377
PCI devices, which IIRC do not even support push/pull mode. All the
rest, including QCA988X and QCA9984 are unaffected.

--=20
Kalle Valo
