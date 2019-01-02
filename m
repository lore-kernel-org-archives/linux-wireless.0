Return-Path: <SRS0=/oVT=PK=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54DD1C43387
	for <linux-wireless@archiver.kernel.org>; Wed,  2 Jan 2019 22:21:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 234A6214C6
	for <linux-wireless@archiver.kernel.org>; Wed,  2 Jan 2019 22:21:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linaro.org header.i=@linaro.org header.b="cTFLusnh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729685AbfABWVP (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 2 Jan 2019 17:21:15 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:37599 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729666AbfABWVP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 2 Jan 2019 17:21:15 -0500
Received: by mail-wm1-f68.google.com with SMTP id g67so28797495wmd.2
        for <linux-wireless@vger.kernel.org>; Wed, 02 Jan 2019 14:21:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6ojsTVbVTAIs/niPLHtQCX4zbvkoWHK82NQCIk9i6+8=;
        b=cTFLusnhZoz3q1fJeFAUiB9UfM8v2Go7kbvchGEIQFjv/F/Jemi0KXEmU4+B+Lo2xR
         /Ur3P+C+vywRWfDPC+I/Grv3M0zWL8yUbTGNxhg0Z1jS0R0hYhoArKUOpuuJYDt2lhh2
         +lgm7ZEyR5gDCcTaNI76Br9Y5TgDDYLLzsAKs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6ojsTVbVTAIs/niPLHtQCX4zbvkoWHK82NQCIk9i6+8=;
        b=HIDThsMA/RM/QGAz2GVf0GR2exBdFBYW1KCqcoz2uNUkIoJwkRjHGhoz0LLN5yIHPv
         zqb6taqPlcBOmo4MF7yZofVE3bGCKh1q2lnfx89NhPlKft97V733Y2iendrs50Y1tjtT
         O+0W5lhYEFURhY87ouUe8Dzez++8Z4S9ZZh9ziRTK0uTqoKfxDhiVBgNked5nrAI/Iow
         y6MQQu4iLO2UOXGLs8st9NpN7QCb4MTa4VCm6EZV4KP85ApmCvpyfbqWCtrhANapxJX2
         oykKNHdXhFx0EyrpPb7q+wAoL1mXvXgiWiuiqrZ8PHNhlkhDRoiJDBxrVDHKYzZCcDdI
         edqw==
X-Gm-Message-State: AA+aEWZcgdwFyQHZeErcijX/TxGzoImcKc/fBeiSJZOBpt52qPBIN5hZ
        FHlHeJAyY7DcnO+Uj98sLI6ey+nKuOFElGdobMNi1Q==
X-Google-Smtp-Source: ALg8bN43iK9qfYLUWpVldk4Xure8bzEyIOlklXkgIW3+BA1O8pwlUcSS5szn/Ni7Hv4AI6gY8ogyoKnoxOp3SRHZiHc=
X-Received: by 2002:a1c:b456:: with SMTP id d83mr38299481wmf.115.1546467673353;
 Wed, 02 Jan 2019 14:21:13 -0800 (PST)
MIME-Version: 1.0
References: <6ccac7db-3ab7-e396-90be-8681a8ee336b@web.de>
In-Reply-To: <6ccac7db-3ab7-e396-90be-8681a8ee336b@web.de>
From:   John Stultz <john.stultz@linaro.org>
Date:   Wed, 2 Jan 2019 14:21:01 -0800
Message-ID: <CALAqxLXz_s6B=NzSp17Lj6xMTYybEsMh4jDR8COXnWQCnFTrsw@mail.gmail.com>
Subject: Re: [PATCH] arm64: dts: hikey: Give wifi some time after power-on
To:     Jan Kiszka <jan.kiszka@web.de>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Wei Xu <xuwei5@hisilicon.com>, Ryan Grachek <ryan@edited.us>,
        linux-wireless@vger.kernel.org, "Reizer, Eyal" <eyalr@ti.com>,
        Valentin Schneider <valentin.schneider@arm.com>,
        Tony Lindgren <tony@atomide.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        KISHON VIJAY ABRAHAM <kishon@ti.com>,
        "Mishol, Guy" <guym@ti.com>,
        Anders Roxell <anders.roxell@linaro.org>,
        Ricardo Salveti <rsalveti@rsalveti.net>,
        Ulf Hansson <ulf.hansson@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Adding a few folks to cc from the thread here:
https://patchwork.kernel.org/patch/10734021/

As this sounds like a very similar issue.
thanks
-john

On Sun, Dec 30, 2018 at 3:38 AM Jan Kiszka <jan.kiszka@web.de> wrote:
>
> From: Jan Kiszka <jan.kiszka@siemens.com>
>
> Somewhere along recent changes to power control of the wl1835, power-on
> became very unreliable on the hikey, failing like this:
>
> wl1271_sdio: probe of mmc2:0001:1 failed with error -16
> wl1271_sdio: probe of mmc2:0001:2 failed with error -16
>
> After playing with some dt parameters and comparing to other users of
> this chip, it turned out we need some power-on delay to make things
> stable again. In contrast to those other users which define 200 ms, the
> hikey is already very happy with 1 ms.
>
> Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
> ---
>
> Tested with 4.19 and linus/master.
>
>   arch/arm64/boot/dts/hisilicon/hi6220-hikey.dts | 1 +
>   1 file changed, 1 insertion(+)
>
> diff --git a/arch/arm64/boot/dts/hisilicon/hi6220-hikey.dts
> b/arch/arm64/boot/dts/hisilicon/hi6220-hikey.dts
> index f4964bee6a1a..1e771bf201b9 100644
> --- a/arch/arm64/boot/dts/hisilicon/hi6220-hikey.dts
> +++ b/arch/arm64/boot/dts/hisilicon/hi6220-hikey.dts
> @@ -118,6 +118,7 @@
>                 reset-gpios = <&gpio0 5 GPIO_ACTIVE_LOW>;
>                 clocks = <&pmic>;
>                 clock-names = "ext_clock";
> +               post-power-on-delay-ms = <1>;
>                 power-off-delay-us = <10>;
>         };
>
> --
> 2.16.4
