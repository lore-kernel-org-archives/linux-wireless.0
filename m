Return-Path: <SRS0=z+ld=Q4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 334EBC43381
	for <linux-wireless@archiver.kernel.org>; Thu, 21 Feb 2019 04:39:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EC8E32148D
	for <linux-wireless@archiver.kernel.org>; Thu, 21 Feb 2019 04:39:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="KVltXBZg";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="LVhXjlYp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726234AbfBUEjw (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 20 Feb 2019 23:39:52 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:39812 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726080AbfBUEjv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 20 Feb 2019 23:39:51 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id B82AA608FB; Thu, 21 Feb 2019 04:39:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1550723990;
        bh=ziBRonHZubtJ/YGdZVpTd1BLIdHGV2jWG7r5H2Ec+Cs=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=KVltXBZgvWqfHXtLoAVkfG44/zQUu40vCFGgnyRTxJkLzbmoxkQx2/XqwCV1tFzgJ
         9FHcEW2MQYOI9392LCfC+qw1sgAf4Rag6ae7GGzYteY2T47d9gEQWiMKquzLsgCJjN
         W38h9hgVFuzxlynxV6WeaS+c+VuniXvYQDIZhMuw=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 1E375605FC;
        Thu, 21 Feb 2019 04:39:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1550723979;
        bh=ziBRonHZubtJ/YGdZVpTd1BLIdHGV2jWG7r5H2Ec+Cs=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=LVhXjlYpIHs5izlScGxFoYPfEuRJcrsg45jcmZhFaLdQgZcl2ZNetTJURZ19pxsVx
         BAx1BmuYiPCcloHe9JeTC22vbmF9Z5ngEOpPxCqX5czIuagkIDCETuWI4UwEAItMSw
         LQbfHRpMEmgABPC5Pn8ewfy0LJ17ag6y5sYy3a0k=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 1E375605FC
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Grant Grundler <grundler@google.com>
Cc:     Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
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
Date:   Thu, 21 Feb 2019 06:39:35 +0200
In-Reply-To: <CANEJEGuBoRMBJBOrFOYyPtiJSMfTahrVgTfxZ2ift6Q5uGazFA@mail.gmail.com>
        (Grant Grundler's message of "Wed, 20 Feb 2019 11:15:02 -0800")
Message-ID: <87ftshpxfc.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
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

Just for reference, here are patchwork links:

https://patchwork.kernel.org/cover/10559729/
https://patchwork.kernel.org/patch/10559731/
https://patchwork.kernel.org/patch/10559733/

The mac80211 patch is accepted and the ath10k patch is deferred. IIRC I
put it deferred as I didn't see a real consensus about the patch and was
supposed to look at it later, but haven't done yet. I don't have any
issues with the patch, except maybe removing the duplicate define for
9377 (which I can easily fix in the pending branch).

--=20
Kalle Valo
