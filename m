Return-Path: <SRS0=/Gk3=PL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6143AC43387
	for <linux-wireless@archiver.kernel.org>; Thu,  3 Jan 2019 21:33:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2C251217F5
	for <linux-wireless@archiver.kernel.org>; Thu,  3 Jan 2019 21:33:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linaro.org header.i=@linaro.org header.b="jaXlM75I"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727959AbfACVdM (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 3 Jan 2019 16:33:12 -0500
Received: from mail-ua1-f66.google.com ([209.85.222.66]:44431 "EHLO
        mail-ua1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727939AbfACVdM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 3 Jan 2019 16:33:12 -0500
Received: by mail-ua1-f66.google.com with SMTP id d19so11395395uaq.11
        for <linux-wireless@vger.kernel.org>; Thu, 03 Jan 2019 13:33:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hRdhXbAsuNg1Aq90NHt2icvWZc4/LaxBRWRFkVibi80=;
        b=jaXlM75IMQPRGV2NwZfFifOVgF9ct7F3py/oDVehhJx61PzEon4Fcb2QghfpsirQpM
         xGh1Tym4VdtxMyhPYXjdI/DYc4hSRdFtKpjC6EKYFYQ+8R4Qe+KmUW6J5xcSL48BQf05
         PzLFKpDnN97VWxgSOO+HUdDMDPiEyq26Rj2+I=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hRdhXbAsuNg1Aq90NHt2icvWZc4/LaxBRWRFkVibi80=;
        b=OgbBHUDvzySpTDZnoquaprHIL3W/V4eLEHJex181n48tSXbIdZBQrb5711iwNzWED6
         bA4m8sK4o/QGFdJenEG+QBiJ0t4yj5lrtXa8moTABoZHCOvqwJnEH4UT7Bb0BVwaFgfg
         CMShmL6vFcqLR9rjjAnBpMF0OSF2GSLh4nanl/UT/DfHcoDN7tIVET1Z01/ilApN3/p8
         AvQGg9vd2Gw0CkyaJb6kC39slu6GOjr6yRAbyqBjh3FMHisYnugnYhQf3igpwF/Hb22E
         +dDJdeoczsOT2wR3oMYebm9JtkvCib3fQYycX9pd9Y/w4ML3e2np4r46wPAQx0LyPK7j
         PTRg==
X-Gm-Message-State: AJcUukcRfr2ZUEQW/WUiMULDKtcWPx0hrUhBx59Hog3IiqugOLGFgj3n
        74kw9Ssea9cMfHwcr1ycWcLolEiaJi8A0fPrUXADLA==
X-Google-Smtp-Source: ALg8bN5NkbkO9tYoEuTdpj293GY/U5b40mMrfrC3ezDIED1PONNxYJYygwxA9EDQbVMC4qlpE11fAKkCoid7G6Qffvg=
X-Received: by 2002:ab0:3484:: with SMTP id c4mr18290931uar.39.1546551190827;
 Thu, 03 Jan 2019 13:33:10 -0800 (PST)
MIME-Version: 1.0
References: <6ccac7db-3ab7-e396-90be-8681a8ee336b@web.de> <CALAqxLXz_s6B=NzSp17Lj6xMTYybEsMh4jDR8COXnWQCnFTrsw@mail.gmail.com>
In-Reply-To: <CALAqxLXz_s6B=NzSp17Lj6xMTYybEsMh4jDR8COXnWQCnFTrsw@mail.gmail.com>
From:   Ulf Hansson <ulf.hansson@linaro.org>
Date:   Thu, 3 Jan 2019 22:32:35 +0100
Message-ID: <CAPDyKFrY58-x3SsUwhfrLvf=hayhdjQZJWqUpmegArmnEsWATg@mail.gmail.com>
Subject: Re: [PATCH] arm64: dts: hikey: Give wifi some time after power-on
To:     John Stultz <john.stultz@linaro.org>,
        Jan Kiszka <jan.kiszka@web.de>
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
        Ricardo Salveti <rsalveti@rsalveti.net>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, 2 Jan 2019 at 23:21, John Stultz <john.stultz@linaro.org> wrote:
>
> Adding a few folks to cc from the thread here:
> https://patchwork.kernel.org/patch/10734021/
>
> As this sounds like a very similar issue.
> thanks
> -john

John, thanks for looping me in.

>
> On Sun, Dec 30, 2018 at 3:38 AM Jan Kiszka <jan.kiszka@web.de> wrote:
> >
> > From: Jan Kiszka <jan.kiszka@siemens.com>
> >
> > Somewhere along recent changes to power control of the wl1835, power-on
> > became very unreliable on the hikey, failing like this:
> >
> > wl1271_sdio: probe of mmc2:0001:1 failed with error -16
> > wl1271_sdio: probe of mmc2:0001:2 failed with error -16
> >
> > After playing with some dt parameters and comparing to other users of
> > this chip, it turned out we need some power-on delay to make things
> > stable again. In contrast to those other users which define 200 ms, the
> > hikey is already very happy with 1 ms.

According to the discussions we had so far, this doesn't sound like
the correct solution.

I am intending to post patch soon, however, I am not sure exactly what
solution to pick yet. I will keep you on cc - and of course I
appreciate if you could help to test.

Kind regards
Uffe

> >
> > Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
> > ---
> >
> > Tested with 4.19 and linus/master.
> >
> >   arch/arm64/boot/dts/hisilicon/hi6220-hikey.dts | 1 +
> >   1 file changed, 1 insertion(+)
> >
> > diff --git a/arch/arm64/boot/dts/hisilicon/hi6220-hikey.dts
> > b/arch/arm64/boot/dts/hisilicon/hi6220-hikey.dts
> > index f4964bee6a1a..1e771bf201b9 100644
> > --- a/arch/arm64/boot/dts/hisilicon/hi6220-hikey.dts
> > +++ b/arch/arm64/boot/dts/hisilicon/hi6220-hikey.dts
> > @@ -118,6 +118,7 @@
> >                 reset-gpios = <&gpio0 5 GPIO_ACTIVE_LOW>;
> >                 clocks = <&pmic>;
> >                 clock-names = "ext_clock";
> > +               post-power-on-delay-ms = <1>;
> >                 power-off-delay-us = <10>;
> >         };
> >
> > --
> > 2.16.4
