Return-Path: <SRS0=80NG=P2=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 094D0C43387
	for <linux-wireless@archiver.kernel.org>; Fri, 18 Jan 2019 15:09:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C708520883
	for <linux-wireless@archiver.kernel.org>; Fri, 18 Jan 2019 15:09:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linaro.org header.i=@linaro.org header.b="evlTGw64"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727934AbfARPJq (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 18 Jan 2019 10:09:46 -0500
Received: from mail-vs1-f67.google.com ([209.85.217.67]:44639 "EHLO
        mail-vs1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727776AbfARPJp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 18 Jan 2019 10:09:45 -0500
Received: by mail-vs1-f67.google.com with SMTP id u11so8566592vsp.11
        for <linux-wireless@vger.kernel.org>; Fri, 18 Jan 2019 07:09:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NHFly/v61mvCmonveHs5OnrdmVAmcAvbhRggQrkvSiI=;
        b=evlTGw64hmaQo60zjnihzf7gEJ4uKFXwR5cI0xPEoPOXlgwbysQbNRprGYwUUqIM2/
         O7zsspW01A9EJVpnu9DGwK0LM57v2n6bV9socZsUdPf2SBDJ05Tm9Q2TTd9p65831zrg
         x+C703vo1VsDa4IJz2PNXC7V8qE5fed0D1xcM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NHFly/v61mvCmonveHs5OnrdmVAmcAvbhRggQrkvSiI=;
        b=Pf2hFIfuPHmGxf58yLRvHd7fGocEhKHHMyr+qQxNMikDap+mMtxWxU7M86E3lGpeMB
         vWKy8FEcNnwGELgBrukt4yh+8tFstUKSF9KU1e4RO1llnFwGXhd8ez4kUdAQ6lPaBzYT
         7MUbrAgU3BvYSczQLM7QFkdTJTGnvTVn8OIRXBmQVYFKpzatK3sGeqIGZHRjDEHtW+qR
         msGBUgXGS/9iIQUAia33EYBpsXAw+s2+NBpgjZiMdd6nhnJMJvK97ThqO+ys+upS0jay
         oyPEqdVMRFyOjYfTwaWyLuAmXN0UWUzrYo9UIoVErm4a3oSHoOmG4zJZ1O55WAOyj59R
         tSuA==
X-Gm-Message-State: AJcUukce5mllU/pL8Qpjt7w23Pceyjd2a6QHqSunN15/q7xRXxxJVXm1
        QLsLr0vMcZ5ZK6uB4bKokm1pvRB4sdP6wGaVl4KojA==
X-Google-Smtp-Source: ALg8bN4uExFtvZJSW5nxX+16W95s11RtgTlXYVvhKD3EpBpeg3eP9YQGWffyDR5KnGp8jtLjmVZaHexjw+WgOxW7l8E=
X-Received: by 2002:a67:d00f:: with SMTP id r15mr7881959vsi.191.1547824183844;
 Fri, 18 Jan 2019 07:09:43 -0800 (PST)
MIME-Version: 1.0
References: <20190116113723.15668-1-ulf.hansson@linaro.org>
 <258ecb6b-c2b2-c8b8-9804-4df69002d9f5@web.de> <CAPDyKFoqfyvQRnSBRvPVxrL-nmf1YoSzxRkPfGwr==L3LOwgaw@mail.gmail.com>
 <5bf8514a-eb15-b098-1857-835b36d4a67c@web.de>
In-Reply-To: <5bf8514a-eb15-b098-1857-835b36d4a67c@web.de>
From:   Ulf Hansson <ulf.hansson@linaro.org>
Date:   Fri, 18 Jan 2019 16:09:07 +0100
Message-ID: <CAPDyKFo=m50jiQ639xzP9tzn+=Bn0CXXwO6p0_jPH0EnSc0UQg@mail.gmail.com>
Subject: Re: [PATCH V2] wlcore: sdio: Fixup power on/off sequence
To:     Jan Kiszka <jan.kiszka@web.de>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        Tony Lindgren <tony@atomide.com>, Eyal Reizer <eyalr@ti.com>,
        linux-wireless@vger.kernel.org,
        Ricardo Salveti <rsalveti@rsalveti.net>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Anders Roxell <anders.roxell@linaro.org>,
        John Stultz <john.stultz@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-omap <linux-omap@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Fri, 18 Jan 2019 at 13:09, Jan Kiszka <jan.kiszka@web.de> wrote:
>
> On 17.01.19 10:54, Ulf Hansson wrote:
> > On Wed, 16 Jan 2019 at 21:26, Jan Kiszka <jan.kiszka@web.de> wrote:
> >>
> >> On 16.01.19 12:37, Ulf Hansson wrote:
> >>> During "wlan-up", we are programming the FW into the WiFi-chip. However,
> >>> re-programming the FW doesn't work, unless a power cycle of the WiFi-chip
> >>> is made in-between the programmings.
> >>>
> >>> To conform to this requirement and to fix the regression in a simple way,
> >>> let's start by allowing that the SDIO card (WiFi-chip) may stay powered on
> >>> (runtime resumed) when wl12xx_sdio_power_off() returns. The intent with the
> >>> current code is to treat this scenario as an error, but unfortunate this
> >>> doesn't work as expected, so let's fix this.
> >>>
> >>> The other part is to guarantee that a power cycle of the SDIO card has been
> >>> completed when wl12xx_sdio_power_on() returns, as to allow the FW
> >>> programming to succeed. However, relying solely on runtime PM to deal with
> >>> this isn't sufficient. For example, userspace may prevent runtime suspend
> >>> via sysfs for the device that represents the SDIO card, leading to that the
> >>> mmc core also keeps it powered on. For this reason, let's instead do a
> >>> brute force power cycle in wl12xx_sdio_power_on().
> >>>
> >>> Fixes: 728a9dc61f13 ("wlcore: sdio: Fix flakey SDIO runtime PM handling")
> >>> Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
> >>> ---
> >>>
> >>> Changes in v2:
> >>>        - Keep the SDIO host claimed when calling mmc_hw_reset().
> >>>        - Add a fixes tag.
> >>> ---
> >>>    drivers/net/wireless/ti/wlcore/sdio.c | 15 +++++++--------
> >>>    1 file changed, 7 insertions(+), 8 deletions(-)
> >>>
> >>> diff --git a/drivers/net/wireless/ti/wlcore/sdio.c b/drivers/net/wireless/ti/wlcore/sdio.c
> >>> index bd10165d7eec..4d4b07701149 100644
> >>> --- a/drivers/net/wireless/ti/wlcore/sdio.c
> >>> +++ b/drivers/net/wireless/ti/wlcore/sdio.c
> >>> @@ -164,6 +164,12 @@ static int wl12xx_sdio_power_on(struct wl12xx_sdio_glue *glue)
> >>>        }
> >>>
> >>>        sdio_claim_host(func);
> >>> +     /*
> >>> +      * To guarantee that the SDIO card is power cycled, as required to make
> >>> +      * the FW programming to succeed, let's do a brute force HW reset.
> >>> +      */
> >>> +     mmc_hw_reset(card->host);
> >>> +
> >>>        sdio_enable_func(func);
> >>>        sdio_release_host(func);
> >>>
> >>> @@ -174,20 +180,13 @@ static int wl12xx_sdio_power_off(struct wl12xx_sdio_glue *glue)
> >>>    {
> >>>        struct sdio_func *func = dev_to_sdio_func(glue->dev);
> >>>        struct mmc_card *card = func->card;
> >>> -     int error;
> >>>
> >>>        sdio_claim_host(func);
> >>>        sdio_disable_func(func);
> >>>        sdio_release_host(func);
> >>>
> >>>        /* Let runtime PM know the card is powered off */
> >>> -     error = pm_runtime_put(&card->dev);
> >>> -     if (error < 0 && error != -EBUSY) {
> >>> -             dev_err(&card->dev, "%s failed: %i\n", __func__, error);
> >>> -
> >>> -             return error;
> >>> -     }
> >>> -
> >>> +     pm_runtime_put(&card->dev);
> >>>        return 0;
> >>>    }
> >>>
> >>>
> >>
> >> Just tested on both HiKey (620) and Ultra96 but it fails to fix the issue on
> >> both. I'm getting
> >>
> >> wl1271_sdio: probe of mmc2:0001:1 failed with error -16
> >>
> >> during boot again, and the interface is not available.
> >
> > Okay, sounds like this may be a different problem then. Can you share
> > the complete log and the kernel config?
>
> You can find the config here [1], log from the HiKey boot attached.
>
> > I can prepare a debug patch as well, if you are willing to re-run the test?
>
> Sure, send it over, I can run it.

Alright, sounds great. However, I need to defer that to Monday/Tuesday
next week.

>
> >
> > Adding a post-power-on-delay-ms of 1 ms as you suggested [1], doesn't
> > sounds like the correct solution to me, unless I am overlooking some
> > things. The point is, since the mmc core succeeds to detect and
> > initialize the SDIO card, the power sequence seems to be correct.
>
> Yeah, I'm not claiming at all I know what I'm doing there, just that it happens
> to work.

I see. Good to know, thanks!

>
> Jan
>
> [1]
> https://github.com/siemens/jailhouse-images/blob/next/recipes-kernel/linux/files/arm64_defconfig_4.19

I have looked through the log and the defconfig. No obvious things
found at this point. Thanks for sharing them!

Kind regards
Uffe
