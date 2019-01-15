Return-Path: <SRS0=v11p=PX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 169ADC43387
	for <linux-wireless@archiver.kernel.org>; Tue, 15 Jan 2019 08:13:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D738920859
	for <linux-wireless@archiver.kernel.org>; Tue, 15 Jan 2019 08:13:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linaro.org header.i=@linaro.org header.b="UlDnvDHO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728437AbfAOINm (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 15 Jan 2019 03:13:42 -0500
Received: from mail-vk1-f194.google.com ([209.85.221.194]:40582 "EHLO
        mail-vk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728095AbfAOINm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 15 Jan 2019 03:13:42 -0500
Received: by mail-vk1-f194.google.com with SMTP id v70so402206vkv.7
        for <linux-wireless@vger.kernel.org>; Tue, 15 Jan 2019 00:13:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mOwjrPx16pxEEqmyAWoh2wbog93QbCSIHUTMPwWkDog=;
        b=UlDnvDHOYd5hJgglipj/ld7jFnRO/DXzNHcUwrkTFqHouwQSmr//EgtCZtVZSffRA1
         hHC0YCEY/8XjJspdNh5RSUfpZgq626egdXOd1rS9+I9Ej3LXz/PoZYm31ppNFc1ccF9L
         zSHm+aRl2T4WBhWMJGqoNPEt9KkeKbglQEymY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mOwjrPx16pxEEqmyAWoh2wbog93QbCSIHUTMPwWkDog=;
        b=kpfbEEKQpkeCzc/zJOsBQ6CerOmPCE2cSxi3tL7F7ymB8wxGFpC2NihPzq5v04+J6d
         Wya2aEfSxMkOcMKQIDL47BSvG+73be4p5sOquY24UXgv+bjYjLqlPeFstOVm17Nbbwik
         /tTKP1i6uReLzSKsuL6dvc8NZIjeqIiNZfZB04bKIorF0UcCwkG+BfSnCPODgpFl262O
         3Yk0nTrQA7Hd6wRHYGzooayTp9ogVZKSZhGR3j7sp+7eTudTPz0y8ILMr6i9AlneCLvW
         2JfTCfqY9zxMPAmqh/gXetIzprODGB/dZlD76iSnBVcULIAqnczPGoMDZYN/q4OREvRn
         J4HQ==
X-Gm-Message-State: AJcUukdm/yoeo9urOeJxajcaCAoR6A9oIeLpPVFwkOdUVsaXTEoXH/jt
        /MsAnAA5YrcQw8f9KT3z3jC6JtIcnMqmDaCio24p4g==
X-Google-Smtp-Source: ALg8bN6gCHBi+6s8lgFGvvg1TGiaWGpigxX44RPrtFeCZOeFlTD8yBRb2V1j9rO5duDIPLB72+3Hfr9nNkPrl6LD58o=
X-Received: by 2002:a1f:9042:: with SMTP id s63mr991999vkd.17.1547540020554;
 Tue, 15 Jan 2019 00:13:40 -0800 (PST)
MIME-Version: 1.0
References: <6ccac7db-3ab7-e396-90be-8681a8ee336b@web.de> <CALAqxLXz_s6B=NzSp17Lj6xMTYybEsMh4jDR8COXnWQCnFTrsw@mail.gmail.com>
 <CAPDyKFrY58-x3SsUwhfrLvf=hayhdjQZJWqUpmegArmnEsWATg@mail.gmail.com>
 <e4977d44-567a-5266-4617-ba62d194a666@web.de> <0a6e6ca5-3ea0-4f6a-63f1-96187700a4bc@web.de>
In-Reply-To: <0a6e6ca5-3ea0-4f6a-63f1-96187700a4bc@web.de>
From:   Ulf Hansson <ulf.hansson@linaro.org>
Date:   Tue, 15 Jan 2019 09:13:03 +0100
Message-ID: <CAPDyKFpmFGu6R4PkBe_8z7NcwewZrJ_Cv0ywj0+jwO7_WLZgrQ@mail.gmail.com>
Subject: Re: [PATCH] arm64: dts: hikey: Give wifi some time after power-on
To:     Jan Kiszka <jan.kiszka@web.de>
Cc:     John Stultz <john.stultz@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
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

On Tue, 15 Jan 2019 at 09:10, Jan Kiszka <jan.kiszka@web.de> wrote:
>
> On 06.01.19 10:53, Jan Kiszka wrote:
> > On 03.01.19 22:32, Ulf Hansson wrote:
> >> On Wed, 2 Jan 2019 at 23:21, John Stultz <john.stultz@linaro.org> wrote:
> >>>
> >>> Adding a few folks to cc from the thread here:
> >>> https://patchwork.kernel.org/patch/10734021/
> >>>
> >>> As this sounds like a very similar issue.
> >>> thanks
> >>> -john
> >>
> >> John, thanks for looping me in.
> >>
> >>>
> >>> On Sun, Dec 30, 2018 at 3:38 AM Jan Kiszka <jan.kiszka@web.de> wrote:
> >>>>
> >>>> From: Jan Kiszka <jan.kiszka@siemens.com>
> >>>>
> >>>> Somewhere along recent changes to power control of the wl1835, power-on
> >>>> became very unreliable on the hikey, failing like this:
> >>>>
> >>>> wl1271_sdio: probe of mmc2:0001:1 failed with error -16
> >>>> wl1271_sdio: probe of mmc2:0001:2 failed with error -16
> >>>>
> >>>> After playing with some dt parameters and comparing to other users of
> >>>> this chip, it turned out we need some power-on delay to make things
> >>>> stable again. In contrast to those other users which define 200 ms, the
> >>>> hikey is already very happy with 1 ms.
> >>
> >> According to the discussions we had so far, this doesn't sound like
> >> the correct solution.
> >>
> >> I am intending to post patch soon, however, I am not sure exactly what
> >> solution to pick yet. I will keep you on cc - and of course I
> >> appreciate if you could help to test.
> >>
> >
> > FWIW, the Ultra96 is also affected. Here I worked around it by using a 10 ms
> > power-on delay. The original workaround from the other thread did not help.
> > Looking forward to the proper fix now!
> >
>
> Any news on this regression?

I will post a (or two) patch during the day.

Kind regards
Uffe
