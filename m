Return-Path: <SRS0=vb4L=PY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 127CAC43387
	for <linux-wireless@archiver.kernel.org>; Wed, 16 Jan 2019 15:49:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D23B220657
	for <linux-wireless@archiver.kernel.org>; Wed, 16 Jan 2019 15:49:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linaro.org header.i=@linaro.org header.b="EZw8P00p"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405053AbfAPPtR (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 16 Jan 2019 10:49:17 -0500
Received: from mail-vs1-f68.google.com ([209.85.217.68]:46441 "EHLO
        mail-vs1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730014AbfAPPtR (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 16 Jan 2019 10:49:17 -0500
Received: by mail-vs1-f68.google.com with SMTP id n10so4156916vso.13
        for <linux-wireless@vger.kernel.org>; Wed, 16 Jan 2019 07:49:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+0LKnHhEAo1Zg5SyA+dBZ+txrenPWIeLyQvrzPfqWUI=;
        b=EZw8P00px9kBeqe/8GFdu+UQBh7+Z0kbo7UrXB9JBsirPlAvWLtxtrcM+iM0Fvvjon
         LwYes8BWmNVildhrob8KdHcd3Lpp4iZ8kc9iJMpAEqz2h+Dh78IgUYHUNUhZyoAkzLB+
         tkOaqSmMdXMmHp8G7Mp0ug54FMytzYdLnM1CY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+0LKnHhEAo1Zg5SyA+dBZ+txrenPWIeLyQvrzPfqWUI=;
        b=DZ0l8Fy8CG8ZZINjAmMPcHt6TPsqBOFoCDvV1SaFKt/0YkBTFljtPxfn9LRBm+Y4Rk
         Y/8RiMtFTUuro+ke0bI1qyMyRoImS2G9yD/GEp1mcwzsxeY1PmwJbRqF6HrBScZ1JJT7
         E3oGreOG139ZPyDUtDQM6XXLzDwOomIvhNW8YTnglmNtqsaxh0Y4sNNaTZG71VM3gdkq
         APZVwdS34Kepmsy34cTlTyHcixiaYm2i2lKP2Z7A2XLwIOotDQikTaZChSkh4hbf6sYJ
         BhLbTIRn4mp6fICVZMK/YEoVdPZJ3FkFREnUrlYGdXRl/8reIkhUC7jrvyIS50KRNpCN
         qfjQ==
X-Gm-Message-State: AJcUukeDiH7BbnUXxuIKsKXHV1rEncDzIgZm4JM7Z/JSDXov/6HOZDoJ
        Rfe14j1hhpF77WUf/Om5n0dVrfbNV8QA7Jein9lKPw==
X-Google-Smtp-Source: ALg8bN7o2u+KA+zkb9oL5j5FLNxHvyd/QM5H6X9P8pSwU2ctMqw8238As8GtV/b3kFz9S5PH0xG/R0Hh9CUTQCIFFqg=
X-Received: by 2002:a67:74c2:: with SMTP id p185mr4203543vsc.34.1547653756405;
 Wed, 16 Jan 2019 07:49:16 -0800 (PST)
MIME-Version: 1.0
References: <20190116113723.15668-1-ulf.hansson@linaro.org> <20190116154311.GP5544@atomide.com>
In-Reply-To: <20190116154311.GP5544@atomide.com>
From:   Ulf Hansson <ulf.hansson@linaro.org>
Date:   Wed, 16 Jan 2019 16:48:40 +0100
Message-ID: <CAPDyKFpAc=xSsLKgMm-2H4WkD34ieRS91wH4GbwD=GH01-pt3A@mail.gmail.com>
Subject: Re: [PATCH V2] wlcore: sdio: Fixup power on/off sequence
To:     Tony Lindgren <tony@atomide.com>, Kalle Valo <kvalo@codeaurora.org>
Cc:     Eyal Reizer <eyalr@ti.com>, linux-wireless@vger.kernel.org,
        Ricardo Salveti <rsalveti@rsalveti.net>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Anders Roxell <anders.roxell@linaro.org>,
        John Stultz <john.stultz@linaro.org>,
        Jan Kiszka <jan.kiszka@web.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-omap <linux-omap@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, 16 Jan 2019 at 16:43, Tony Lindgren <tony@atomide.com> wrote:
>
> * Ulf Hansson <ulf.hansson@linaro.org> [190116 11:37]:
> > During "wlan-up", we are programming the FW into the WiFi-chip. However,
> > re-programming the FW doesn't work, unless a power cycle of the WiFi-chip
> > is made in-between the programmings.
> >
> > To conform to this requirement and to fix the regression in a simple way,
> > let's start by allowing that the SDIO card (WiFi-chip) may stay powered on
> > (runtime resumed) when wl12xx_sdio_power_off() returns. The intent with the
> > current code is to treat this scenario as an error, but unfortunate this
> > doesn't work as expected, so let's fix this.
> >
> > The other part is to guarantee that a power cycle of the SDIO card has been
> > completed when wl12xx_sdio_power_on() returns, as to allow the FW
> > programming to succeed. However, relying solely on runtime PM to deal with
> > this isn't sufficient. For example, userspace may prevent runtime suspend
> > via sysfs for the device that represents the SDIO card, leading to that the
> > mmc core also keeps it powered on. For this reason, let's instead do a
> > brute force power cycle in wl12xx_sdio_power_on().
> >
> > Fixes: 728a9dc61f13 ("wlcore: sdio: Fix flakey SDIO runtime PM handling")
> > Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
> > ---
> >
> > Changes in v2:
> >       - Keep the SDIO host claimed when calling mmc_hw_reset().
> >       - Add a fixes tag.
>
> This v2 version works for me as tested with:
>
> # while [ 1 ]; do ifconfig wlan0 down; ifconfig wlan0 up; done
> [  181.364990] wlcore: down
> [  182.116424] wlcore: firmware booted (Rev 6.3.10.0.141)
> [  182.151641] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
> [  182.166778] wlcore: down
> [  182.773132] wlcore: firmware booted (Rev 6.3.10.0.141)
> [  182.811096] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
> ...
>
> Thanks for fixing this issue properly, and feel free to add:
>
> Tested-by: Tony Lindgren <tony@atomide.com>

Thanks for testing, great news!

Before queuing this as fix, let's also see what the Hikey folkz thinks
of this. I have pinged Anders and he is currently running a test
suite.

Kalle, can you please tag this for stable as well?

Kind regards
Uffe
