Return-Path: <SRS0=ZGUU=N3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F12A4C43441
	for <linux-wireless@archiver.kernel.org>; Fri, 16 Nov 2018 10:15:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B8A21208E3
	for <linux-wireless@archiver.kernel.org>; Fri, 16 Nov 2018 10:15:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="kcu0BD0g";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="AvxDUOLo"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B8A21208E3
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727630AbeKPU0q (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 16 Nov 2018 15:26:46 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:36424 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727454AbeKPU0p (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 16 Nov 2018 15:26:45 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id F3239612F3; Fri, 16 Nov 2018 10:15:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1542363305;
        bh=dlTW5ELU6sT+EzPDlJ/bdlTI9lbRzlOWNxXypVwzB3w=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=kcu0BD0g9VKFxVMSAyZr5g58CmjbL6IQTvoax/xr/1jFweceEHdNnxZ+9UN3J0DEI
         g7lb1GcoJM3N0t2vqQvHe6iUvxHdJ0xP8tGm5GxHAO6UXF4JOiTH3qwXKBFZZGd7uV
         52LFScBhWXPc3rLD6NyaV066FQ83/Yh6Eyf0YWOE=
Received: from x230.qca.qualcomm.com (87-95-226-75.bb.dnainternet.fi [87.95.226.75])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id BFDEF60C4C;
        Fri, 16 Nov 2018 10:15:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1542363304;
        bh=dlTW5ELU6sT+EzPDlJ/bdlTI9lbRzlOWNxXypVwzB3w=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=AvxDUOLosOaNGl1jjdYy0BPnUUG/yBid15Z3YRBz5yi58PoBx2bdc+C7sLwg/EoTk
         MxveKnoUXRB5PTdSyOHlet96xgSmDdyBhewOTJV6AmxOgCnT50B/cIVX0CfS30ecCy
         smZZohoyr2mUsQ8dCvxARJWAsIsFpOYtoYRmPxKI=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org BFDEF60C4C
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Brian Norris <briannorris@chromium.org>
Cc:     govinds@codeaurora.org, yyuwang@codeaurora.org,
        rmanohar@codeaurora.org, linux-wireless-owner@vger.kernel.org,
        linux-wireless@vger.kernel.org,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        ath10k@lists.infradead.org, pillair@codeaurora.org,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH REGRESSION] Revert "ath10k: add quiet mode support for QCA6174/QCA9377"
References: <20181107185643.240346-1-briannorris@chromium.org>
        <7f2ef494f4a2aba1845a157da8fec449@codeaurora.org>
        <b1a64bd66fa25f274af8c018c6fc02f4@codeaurora.org>
        <CA+ASDXOqJ1-G2amyu7sJCnzKf1oY_2j9Qw4WS0VTf8EqGr6Uqw@mail.gmail.com>
Date:   Fri, 16 Nov 2018 12:14:59 +0200
In-Reply-To: <CA+ASDXOqJ1-G2amyu7sJCnzKf1oY_2j9Qw4WS0VTf8EqGr6Uqw@mail.gmail.com>
        (Brian Norris's message of "Thu, 8 Nov 2018 09:30:43 -0800")
Message-ID: <87k1ld72ho.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Brian Norris <briannorris@chromium.org> writes:

> On Wed, Nov 7, 2018 at 8:32 PM Govind Singh <govinds@codeaurora.org> wrote:
>> On 2018-11-08 03:00, Rajkumar Manoharan wrote:
>> > On 2018-11-07 10:56, Brian Norris wrote:
>> >> This reverts commit cfb353c0dc058bc1619cc226d3cbbda1f360bdd3.
>> >>
>> >> WCN3990 firmware does not yet implement this feature, and so it
>> >> crashes
>> >> like this:
>> >>
>> >>   fatal error received: err_qdi.c:456:EX:wlan_process:1:WLAN
>> >> RT:207a:PC=b001b4f0
>> >>
>> >> This feature can be re-implemented with a proper service bitmap or
>> >> other
>> >> feature-discovery mechanism in the future. But it should not break
>> >> working boards.
>> >>
>> > Brian,
>> >
>> > The change "ath10k: add quiet mode support for QCA6174/QCA9377" was
>> > merged even
>> > before full WCN3990 device support was added in ath10k. How come it
>> > could be regression
>> > for WCN3990. I know both are sharing same WMI-TLV interface but
>> > reverting this
>> > will break QCA6174/QCA9377. no?
>
> I don't see how the revert would "break" QCA6174 -- QCA6174 worked
> just fine without this feature and should continue to do so.
>
>> This regression is found while we switched from 4.18 + WCN3990
>> back-ports to 4.19.
>
> ^^ What Govind said. WCN3990 support has been trickling in over a few
> releases, and it doesn't seem kosher to allow people to submit
> regressions in the midst of that.

Yeah, I agree.

>> > I would prefer to handle this within WMI callback or upper layer.
>> >
>>
>> IMO, we should use (WMI_SERVICE_THERMAL_MGMT | WMI_SERVICE_THERM_THROT )
>> service bitmap check and call
>> ath10k_thermal_set_throttling only if fw supports THERMAL THROTTLE
>> feature. But we need to ensure all
>> available ath10k fw's are reporting this service.
>
> And the above notes from Govind highlight this -- if the feature was
> not protected by the appropriate service flags, then we can't be sure
> that you didn't break a bunch of other firmware releases out there.
> Linux should not break for everyone just because you spun a firmware
> release.
>
> Of course, I'll leave it up to Kalle as to how he wants to mediate
> this. And if you come up with a solid patch soon that can fix this
> without dropping the feature, then so be it.

We should have a fix for this available next week which I'm planning to
push to 4.20. If that does not happen my plan B is to apply Brian's
revert to make wcn3990 working on 4.20.

Thanks Brian for investigating this and providing the revert!

-- 
Kalle Valo
