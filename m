Return-Path: <SRS0=MtVb=O3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34B79C43387
	for <linux-wireless@archiver.kernel.org>; Tue, 18 Dec 2018 12:34:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E9A5720874
	for <linux-wireless@archiver.kernel.org>; Tue, 18 Dec 2018 12:34:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linaro.org header.i=@linaro.org header.b="WFASKtVI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726614AbeLRMeo (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 18 Dec 2018 07:34:44 -0500
Received: from mail-vs1-f65.google.com ([209.85.217.65]:40315 "EHLO
        mail-vs1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726379AbeLRMen (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 18 Dec 2018 07:34:43 -0500
Received: by mail-vs1-f65.google.com with SMTP id z3so9865139vsf.7
        for <linux-wireless@vger.kernel.org>; Tue, 18 Dec 2018 04:34:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dQG/KZeaM733azimMJJebUr46id+H5VoNSOWGwmYzrs=;
        b=WFASKtVIvZBOHX0MwqHezYSJj4nQK1umUpBfiQkJsSutS9zKLaTezPeynPTXLkxLQp
         9/U3jhuomyCB96WGWoXBfjpSJgOuKfGCMGunlilWuhVGf68DvGScMd1/vTGmDVkEcmn4
         0geqFQUiU/IJpsZD4+hmdZosC2VmroVPTb48E=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dQG/KZeaM733azimMJJebUr46id+H5VoNSOWGwmYzrs=;
        b=LYoqGuzUcZpoiAp5M59RrSiibkqc0+2smGojIDgJ0C1icuvNeUPEZOlY+UR+Smont6
         lPXh2VMrW9LmkZ/8p87n/RmwarXLXa4KI2KS2dE2rxhlY7Mo2Xx5xykcH1fdveUn0IQI
         4NIusQhdAzDBdjTlDSBqHy+gm7Xa6W5cLF39bm91AYNR6obIsHMA5H770uO/bPk6N29L
         d7xwovECJPZhAoeUubNgQn6WblMN8miTH60TNPnnuqtyzNnwXab5MAL4T4tWjDIG3NvB
         3Pu53chBDHmQlIu+nA0byxuvA8T/+undFdmZ+QLpv4sOzvdG/PM2deR0zzhqOgLa+frp
         fp+A==
X-Gm-Message-State: AA+aEWY2me5JXM9PDMhF5q04GLLkFp0bGpi+WgWnQJDKb+SNktWxfgf4
        rSkfhP76vzc6UWnzRwAmMW82Vhh/sMBSlKAbIM18uQ==
X-Google-Smtp-Source: AFSGD/VglgCKVqZ8H7jv/8BnGvEurIWuYO/p7wzJ3ImHKm+G8tuzczAmFDKvyXp0cXsN5WcQW1tz2Jv7N1ZicB/Xhn4=
X-Received: by 2002:a67:1a84:: with SMTP id a126mr8132060vsa.165.1545136482064;
 Tue, 18 Dec 2018 04:34:42 -0800 (PST)
MIME-Version: 1.0
References: <20181217164207.20081-1-tony@atomide.com>
In-Reply-To: <20181217164207.20081-1-tony@atomide.com>
From:   Ulf Hansson <ulf.hansson@linaro.org>
Date:   Tue, 18 Dec 2018 13:34:06 +0100
Message-ID: <CAPDyKFoLnNWsBfaUwqwL31J=zb0UOQjXUKi7Sj0AUsnNoC6bYg@mail.gmail.com>
Subject: Re: [PATCH] wlcore: Fix bringing up wlan0 again if powered down briefly
To:     Tony Lindgren <tony@atomide.com>
Cc:     Kalle Valo <kvalo@codeaurora.org>, Eyal Reizer <eyalr@ti.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Guy Mishol <guym@ti.com>, linux-wireless@vger.kernel.org,
        linux-omap <linux-omap@vger.kernel.org>,
        Anders Roxell <anders.roxell@linaro.org>,
        John Stultz <john.stultz@linaro.org>,
        Ricardo Salveti <rsalveti@rsalveti.net>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Mon, 17 Dec 2018 at 17:42, Tony Lindgren <tony@atomide.com> wrote:
>
> At least HiKey board can fail to bring up wireless interface again
> if the interface is brought down and up with no delay inbetween.
>
> This can be done tested with:
>
> # while true; do ifconfig wlan0 down; ifconfig wlan0 up; done
>
> According to Ricardo Salveti <rsalveti@rsalveti.net>, we need to
> wait between 30 - 40 ms on HiKey. This seems to happen when we
> get -EBUSY returned by pm_runtime_put() basedon the check in
> rpm_check_suspend_allowed(). But as it still unclear if part of
> the delay needed is because of capacitance, let's always do a
> at least 50 ms msleep even if no -EBUSY is returned.
>
> Cc: Anders Roxell <anders.roxell@linaro.org>
> Cc: Eyal Reizer <eyalr@ti.com>
> Cc: John Stultz <john.stultz@linaro.org>
> Cc: Ricardo Salveti <rsalveti@rsalveti.net>
> Cc: Ulf Hansson <ulf.hansson@linaro.org>
> Reported-by: Ricardo Salveti <rsalveti@rsalveti.net>
> Fixes: 60f36637bbbd ("wlcore: sdio: allow pm to handle sdio power")
> Signed-off-by: Tony Lindgren <tony@atomide.com>
> ---
>
> Uffe, do you have some better ideas on how to fix this issue?
>
> ---
>  drivers/net/wireless/ti/wlcore/sdio.c | 13 ++++++++++++-
>  1 file changed, 12 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/net/wireless/ti/wlcore/sdio.c b/drivers/net/wireless/ti/wlcore/sdio.c
> --- a/drivers/net/wireless/ti/wlcore/sdio.c
> +++ b/drivers/net/wireless/ti/wlcore/sdio.c
> @@ -174,7 +174,7 @@ static int wl12xx_sdio_power_off(struct wl12xx_sdio_glue *glue)
>  {
>         struct sdio_func *func = dev_to_sdio_func(glue->dev);
>         struct mmc_card *card = func->card;
> -       int error;
> +       int error, retries = 5;
>
>         sdio_claim_host(func);
>         sdio_disable_func(func);
> @@ -188,6 +188,17 @@ static int wl12xx_sdio_power_off(struct wl12xx_sdio_glue *glue)
>                 return error;
>         }
>
> +       /* Wait a bit to ensure the card gets power off. Otherwise
> +        * bringing interface down and up again may not power off the
> +        * card inbetween. And then firmware load will fail on trying
> +        * to bring the card up again. We need to wait between 30 - 40
> +        * ms for this based on measurements on HiKey board.
> +        */
> +       do {
> +               msleep(50);
> +       } while (error == -EBUSY && !pm_runtime_suspended(&card->dev) &&
> +                retries--);
> +

To me, this looks wrong, let me explain why.

I assume wl12xx_sdio_power_off() is being called, at "ifconfig wlan0
down". Although, could wl12xx_sdio_power_off() also be called during
system suspend, or you have another function dealing with that path?

Anyway, the call to pm_runtime_put*() a few lines above the new code
added in $subject patch, doesn't guarantee that the device ever
becomes runtime suspended. During system suspend, that is for sure,
but even when the platform is up an running, as userspace may prevent
it via the device's sysfs nobs.

That said, checking the state of the device with
pm_runtime_suspended() here, doesn't really play well.

Instead, it looks like what you need, is a way to keep track of
whether the SDIO card, became power cycled or if it stayed powered on,
when "ifconfig wlan0 up" is done. In case of a power cycle, you need
to re-program the firmware, right?

Would it be possible to re-program the firmware, even if the SDIO card
stayed powered-on?

In regards to delays needed due to a capacitance. If that really is
the case, that shall be the managed by the mmc core, as it's there the
power cycle sequence is being done. As a matter of fact, you should be
able to use drivers/mmc/core/pwrseq_simple.c and extend
"power-off-delay-us" in the DTB for Hikey if that is needed.

Kind regards
Uffe
