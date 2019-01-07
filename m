Return-Path: <SRS0=TVdy=PP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13AA2C43387
	for <linux-wireless@archiver.kernel.org>; Mon,  7 Jan 2019 16:12:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D477E2173C
	for <linux-wireless@archiver.kernel.org>; Mon,  7 Jan 2019 16:12:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="leHdzZLb";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="bl0Qr7tE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727340AbfAGQM3 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 7 Jan 2019 11:12:29 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:42884 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727191AbfAGQM2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 7 Jan 2019 11:12:28 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id C395C606AC; Mon,  7 Jan 2019 16:12:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1546877547;
        bh=jAzkNIH+xjpMML9p0X+xwFPJAjwQOEwKLdpxnBGYfT4=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=leHdzZLbpsJVWyjzRz+vdx0XLKzJSds93ZeZoF/yEUKq5dsysuzF/aDVQsZ9vD2Vu
         PDf33jT/eTepx2UuRWkGbePCzP8H/AHf6mk+VT6/ZhTxNa6MxjVNeKGroWTTuRuWgZ
         l7USucnv8EMHMCbpLP7zhnMb6vXloD5RzJNAa1N4=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 0577160247;
        Mon,  7 Jan 2019 16:12:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1546877546;
        bh=jAzkNIH+xjpMML9p0X+xwFPJAjwQOEwKLdpxnBGYfT4=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=bl0Qr7tE+1mbX4COOEq5LG33pxZd68R/YEtnoNc65bZf9wgjAJININQAUQ7z58D2X
         R16EpvhpAkKUTcraCF8yhUcHf4jixsVjXqTzJ2KS77mKLBPf/UCOtJFdxMJLk9TP1E
         V6jNuHPWAvQb0/yuHrp4c/Udhbudj0cgmVfYQGXI=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 0577160247
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Tony Lindgren <tony@atomide.com>
Cc:     Ulf Hansson <ulf.hansson@linaro.org>,
        "Reizer\, Eyal" <eyalr@ti.com>,
        KISHON VIJAY ABRAHAM <kishon@ti.com>,
        "Mishol\, Guy" <guym@ti.com>,
        "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        linux-omap <linux-omap@vger.kernel.org>,
        Anders Roxell <anders.roxell@linaro.org>,
        John Stultz <john.stultz@linaro.org>,
        Ricardo Salveti <rsalveti@rsalveti.net>
Subject: Re: [EXTERNAL] Re: [PATCH] wlcore: Fix bringing up wlan0 again if powered down briefly
References: <20181217164207.20081-1-tony@atomide.com>
        <CAPDyKFoLnNWsBfaUwqwL31J=zb0UOQjXUKi7Sj0AUsnNoC6bYg@mail.gmail.com>
        <20181218155439.GB6707@atomide.com>
        <CAPDyKFr2xx6fmdgjd10C1jekWg-yZPk32fGWEPO2PyexjofJ1A@mail.gmail.com>
        <20181220231401.GG6707@atomide.com>
        <c22e2ab61b494ea0852c0f4654fef92d@ti.com>
        <20181223160226.GK6707@atomide.com>
        <CAPDyKFoEOGACs4Wnm7UgKab2b1-7+v8+31DpC+p=8XxcQhSpcQ@mail.gmail.com>
        <20181228195903.GX6707@atomide.com>
        <CAPDyKFq9XmRueJEFKVb03hqLuoB84TGjrdvEjre46ezYbk_wgw@mail.gmail.com>
        <20190107151849.GC5544@atomide.com>
Date:   Mon, 07 Jan 2019 18:12:21 +0200
In-Reply-To: <20190107151849.GC5544@atomide.com> (Tony Lindgren's message of
        "Mon, 7 Jan 2019 07:18:49 -0800")
Message-ID: <87k1jgsaze.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Tony Lindgren <tony@atomide.com> writes:

> * Ulf Hansson <ulf.hansson@linaro.org> [190102 12:02]:
>>
>> However, if this is about an out-of-band IRQ line, instead of using
>> the SDIO IRQs on DAT1, I think management of that, belongs in the wlan
>> (or gpiochip) layers.
>
> Yes this can be handled at the gpiochip layer.
>
>> We have to distinguish if "down" has a strict requirement to power off
>> the wlan-chip.
>> 
>> For example, in "flight mode", is it okay to leave the wlan chip
>> powered on and thus potentially also having its radio part active?
>
> I don't know. If unsure, we should at least have that possibility
> available for future versions if needed. It might also help a bit
> with PM measurements :)

I don't know if there are any written rules but I have preferred that in
wireless drivers "ifconfig down" means that all power is turned off on
the device, at least this way user space can achive maximum power
savings. And there's also a simple way to start the firmware from clean
state, we all know how buggy firmwares are so I think that's important
as well.

-- 
Kalle Valo
