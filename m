Return-Path: <SRS0=6Uy3=QL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 023E4C282D7
	for <linux-wireless@archiver.kernel.org>; Mon,  4 Feb 2019 06:07:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C8D73217D9
	for <linux-wireless@archiver.kernel.org>; Mon,  4 Feb 2019 06:07:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linaro.org header.i=@linaro.org header.b="X2q4F2LN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725928AbfBDGHU (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 4 Feb 2019 01:07:20 -0500
Received: from mail-ua1-f65.google.com ([209.85.222.65]:45979 "EHLO
        mail-ua1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725906AbfBDGHU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 4 Feb 2019 01:07:20 -0500
Received: by mail-ua1-f65.google.com with SMTP id e16so4073471uam.12
        for <linux-wireless@vger.kernel.org>; Sun, 03 Feb 2019 22:07:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KG15wM6Jwx9Avl8HGL6Rq2KKwKL64VNzgD6ZPPI8pTY=;
        b=X2q4F2LNVwkuzn5p6WpLwB3s2R5YFu7qGAr55eorUXnrm0NoV8nlSzjilmwHg1qcXl
         DD6qzO39oFADV329MhsvAveYtE/qJWzZIiMgpZ46M+yTGpYmvGL4fp+KV+aoDMRxJP3L
         ifeZ7aS7tZsRCC4eECwsQwQ31mQRPrsQlY9oI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KG15wM6Jwx9Avl8HGL6Rq2KKwKL64VNzgD6ZPPI8pTY=;
        b=nsM0Co5bj1Hfjoi1UMHhVO4O1yCL49/yF6UlI8kICPsv1LiPj4DjEPk+MVmhr2VBz3
         1YS729/hWgDngBSDbbIcrQMddPxaUo/s3hXHCvoFvoOygTNl8JSiGnUsDrtlPyhlS2hN
         6T6hK5KtAV8l9W2BvULG42cr60Hn0G5TBed8Uz1834qVa/RCIykPL21KfB9qV85rh5ri
         0MIEmHujhXwdwNsmnk1B0imk4HjiQdZ3K6OaKiq4KqbWn1Z+w46nyz8CFPQyoxfwPhil
         4TIbDv+JvH8qYA9HjW4qYr3ywuaH5EkBZmfApAm9yRhoWqJOOsqj5R8ZRsIkGGY+QQDt
         rkVQ==
X-Gm-Message-State: AJcUukfdPvDY198DgiumZzgUra45UtWymUyG51vQZ7dt3NYk1ylobtkC
        //ixmmJFZYLY4B3C1oe+V01tPB1hxB5J1xLccPRWCA==
X-Google-Smtp-Source: ALg8bN4FpJdHRTRWA4ygDlfIdgG0Zg11v1m6of6DJzSd7yJ27nXx183e6ThqUE4MLG7Ixl95gvAUFuazndfxxCxBKSo=
X-Received: by 2002:ab0:31d5:: with SMTP id e21mr21397916uan.107.1549260438893;
 Sun, 03 Feb 2019 22:07:18 -0800 (PST)
MIME-Version: 1.0
References: <e944650d-514f-3727-2e68-b318aab9ee7f@web.de> <14a011aa-862f-7132-8741-df5173875f34@hisilicon.com>
In-Reply-To: <14a011aa-862f-7132-8741-df5173875f34@hisilicon.com>
From:   Ulf Hansson <ulf.hansson@linaro.org>
Date:   Mon, 4 Feb 2019 07:06:41 +0100
Message-ID: <CAPDyKFqYWGv7bWW7rcCYhc-PdmRCBdskUTycFxK25VQgd0TWeg@mail.gmail.com>
Subject: Re: [PATCH v2] arm64: dts: hikey: Give wifi some time after power-on
To:     Wei Xu <xuwei5@hisilicon.com>
Cc:     Jan Kiszka <jan.kiszka@web.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Ryan Grachek <ryan@edited.us>,
        John Stultz <john.stultz@linaro.org>,
        linux-wireless@vger.kernel.org, "Reizer, Eyal" <eyalr@ti.com>,
        Valentin Schneider <valentin.schneider@arm.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Tony Lindgren <tony@atomide.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Fri, 1 Feb 2019 at 17:34, Wei Xu <xuwei5@hisilicon.com> wrote:
>
> Hi Jan,
>
> On 1/24/2019 7:52 AM, Jan Kiszka wrote:
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
> > hikey would already be happy with 1 ms. Still, we use the safer 10 ms,
> > like on the Ultra96.
> >
> > Fixes: ea452678734e ("arm64: dts: hikey: Fix WiFi support")
> > Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
> > Acked-by: Ulf Hansson <ulf.hansson@linaro.org>
>
> Applied to the hisilicon soc dt tree.

Wei, can you please also add a stable tag to it?

[...]

Thanks and kind regards
Uffe
