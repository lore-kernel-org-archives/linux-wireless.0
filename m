Return-Path: <SRS0=vb4L=PY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E3B4C43387
	for <linux-wireless@archiver.kernel.org>; Wed, 16 Jan 2019 16:18:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E969A20651
	for <linux-wireless@archiver.kernel.org>; Wed, 16 Jan 2019 16:18:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="ZXUj2Jdt";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="HnKlDb9O"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405362AbfAPQSJ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 16 Jan 2019 11:18:09 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:41384 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728055AbfAPQSJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 16 Jan 2019 11:18:09 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 0A97B60C88; Wed, 16 Jan 2019 16:18:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1547655488;
        bh=yGiryjewCdi98umIS3eEjPSOfpjeW+E5TX1N9WW5cXA=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=ZXUj2Jdtc3VyUre5WYgYVfQIcmr/STCZEs3+sYJP6A8xhlcZwF3le4ThP4oCrZXHm
         C6TRpxo5PU+aT6i21OgXYJCflK57Q+Km8ZWofz7qML2AiRLJnA82EFFbPL7VjmYDsv
         5F3A+Ed8PAAhpYYrsNhBT+vRJJ4gktCqS597++6o=
Received: from x230.qca.qualcomm.com (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 424D96086A;
        Wed, 16 Jan 2019 16:18:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1547655486;
        bh=yGiryjewCdi98umIS3eEjPSOfpjeW+E5TX1N9WW5cXA=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=HnKlDb9O2h9l1caUtreEWgvU4UR5Gnobz+c5T3x7ZwoAYypCeAeES1JyBQsezxXDD
         sXofkNr6P2iPdJ/edd/zIasJawwdqus6ItOEN9PrWWhFIMESPfj9wT9kAGJd1Zfvha
         YOilUkY2X3mjSccgkKNEXq4UquNUV3ParMTOW59g=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 424D96086A
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Ulf Hansson <ulf.hansson@linaro.org>
Cc:     Tony Lindgren <tony@atomide.com>, Eyal Reizer <eyalr@ti.com>,
        linux-wireless@vger.kernel.org,
        Ricardo Salveti <rsalveti@rsalveti.net>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Anders Roxell <anders.roxell@linaro.org>,
        John Stultz <john.stultz@linaro.org>,
        Jan Kiszka <jan.kiszka@web.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-omap <linux-omap@vger.kernel.org>
Subject: Re: [PATCH V2] wlcore: sdio: Fixup power on/off sequence
References: <20190116113723.15668-1-ulf.hansson@linaro.org>
        <20190116154311.GP5544@atomide.com>
        <CAPDyKFpAc=xSsLKgMm-2H4WkD34ieRS91wH4GbwD=GH01-pt3A@mail.gmail.com>
Date:   Wed, 16 Jan 2019 18:18:00 +0200
In-Reply-To: <CAPDyKFpAc=xSsLKgMm-2H4WkD34ieRS91wH4GbwD=GH01-pt3A@mail.gmail.com>
        (Ulf Hansson's message of "Wed, 16 Jan 2019 16:48:40 +0100")
Message-ID: <87muo04lvr.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Ulf Hansson <ulf.hansson@linaro.org> writes:

> On Wed, 16 Jan 2019 at 16:43, Tony Lindgren <tony@atomide.com> wrote:
>>
>> * Ulf Hansson <ulf.hansson@linaro.org> [190116 11:37]:
>> > During "wlan-up", we are programming the FW into the WiFi-chip. However,
>> > re-programming the FW doesn't work, unless a power cycle of the WiFi-chip
>> > is made in-between the programmings.
>> >
>> > To conform to this requirement and to fix the regression in a simple way,
>> > let's start by allowing that the SDIO card (WiFi-chip) may stay powered on
>> > (runtime resumed) when wl12xx_sdio_power_off() returns. The intent with the
>> > current code is to treat this scenario as an error, but unfortunate this
>> > doesn't work as expected, so let's fix this.
>> >
>> > The other part is to guarantee that a power cycle of the SDIO card has been
>> > completed when wl12xx_sdio_power_on() returns, as to allow the FW
>> > programming to succeed. However, relying solely on runtime PM to deal with
>> > this isn't sufficient. For example, userspace may prevent runtime suspend
>> > via sysfs for the device that represents the SDIO card, leading to that the
>> > mmc core also keeps it powered on. For this reason, let's instead do a
>> > brute force power cycle in wl12xx_sdio_power_on().
>> >
>> > Fixes: 728a9dc61f13 ("wlcore: sdio: Fix flakey SDIO runtime PM handling")
>> > Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
>> > ---
>> >
>> > Changes in v2:
>> >       - Keep the SDIO host claimed when calling mmc_hw_reset().
>> >       - Add a fixes tag.
>>
>> This v2 version works for me as tested with:
>>
>> # while [ 1 ]; do ifconfig wlan0 down; ifconfig wlan0 up; done
>> [  181.364990] wlcore: down
>> [  182.116424] wlcore: firmware booted (Rev 6.3.10.0.141)
>> [  182.151641] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
>> [  182.166778] wlcore: down
>> [  182.773132] wlcore: firmware booted (Rev 6.3.10.0.141)
>> [  182.811096] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
>> ...
>>
>> Thanks for fixing this issue properly, and feel free to add:
>>
>> Tested-by: Tony Lindgren <tony@atomide.com>
>
> Thanks for testing, great news!
>
> Before queuing this as fix, let's also see what the Hikey folkz thinks
> of this. I have pinged Anders and he is currently running a test
> suite.
>
> Kalle, can you please tag this for stable as well?

Ok, I'll queue this for 5.0 (but wait for testing feedback at least a
day) and add:

Cc: <stable@vger.kernel.org>

-- 
Kalle Valo
