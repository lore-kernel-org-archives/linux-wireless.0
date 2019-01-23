Return-Path: <SRS0=ZHYo=P7=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60077C282C0
	for <linux-wireless@archiver.kernel.org>; Wed, 23 Jan 2019 21:19:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2373A2184C
	for <linux-wireless@archiver.kernel.org>; Wed, 23 Jan 2019 21:19:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linaro.org header.i=@linaro.org header.b="bbZWZ2A5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726803AbfAWVTD (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 23 Jan 2019 16:19:03 -0500
Received: from mail-vs1-f65.google.com ([209.85.217.65]:44099 "EHLO
        mail-vs1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726366AbfAWVTD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 23 Jan 2019 16:19:03 -0500
Received: by mail-vs1-f65.google.com with SMTP id u11so2204782vsp.11
        for <linux-wireless@vger.kernel.org>; Wed, 23 Jan 2019 13:19:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rQ+KNXYtfh0lLrH9AE8eIx1liek8JORdiOs3vrvOVbs=;
        b=bbZWZ2A5unH7aMKORScfxp5ab8Fg7d4UQntyZKE57I6wWNdc/UKKza6N0XYyVhHcCm
         X1EfvK+Xnu15T4Ojaf7nm49aH4NmrboCKVE1ObiMTOV779xgIvASg6GqninRL63gDcMx
         IKLzGZd6IvteqHRRRQA8FZsakLJLClmxev77I=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rQ+KNXYtfh0lLrH9AE8eIx1liek8JORdiOs3vrvOVbs=;
        b=gZMBrhBP7u1nLmq51dCEA7yfgVqGbEyDJx/yVGBvffmDorAxni07N7/iw3E0kIxF3e
         N5jju7w8IRV92GHffyZxYxGng+WRkWUVuAZxC4GgXFF4w1rPZ7V+XRNea6sk9s9qRy+w
         aBe1VWmc7UxxQh9jCVRK5OyUIHPLxK5k6RaVeZK2uEfD1tomrC0T/ScZIrmgyQiri+EU
         NTYD1Vy/Vgy//E0Q7zHXdwx/tWZdqPFr8jruTuO/r0j/GZQV8GiG6n5vsquQO6quKKMt
         NYrI4GY2h26E18nwOlMV928mdff7jqAzTHJCTebnCMqiCzVtLY9Vq5lRqlXY6UPahq5I
         KvIA==
X-Gm-Message-State: AJcUukdlMNKnpWbHVyjMhEGLOUbAzho8FUgJC8C/Gkn90nVJljmMqW4j
        MhTNTmgBY1b6Cwr7gnHk2BEnOPiqPEyFVF7OYj29DA==
X-Google-Smtp-Source: ALg8bN4PN1cuoL3ORhGL5d746MNe7QAePwkJHDJA0t48nHKD2dogmO93mL+z7SZKDIsdVDHaVGMGMfdr+dyrRv8KQvI=
X-Received: by 2002:a67:b245:: with SMTP id s5mr1578312vsh.200.1548278341746;
 Wed, 23 Jan 2019 13:19:01 -0800 (PST)
MIME-Version: 1.0
References: <20190116113723.15668-1-ulf.hansson@linaro.org>
 <258ecb6b-c2b2-c8b8-9804-4df69002d9f5@web.de> <CAPDyKFoqfyvQRnSBRvPVxrL-nmf1YoSzxRkPfGwr==L3LOwgaw@mail.gmail.com>
 <5bf8514a-eb15-b098-1857-835b36d4a67c@web.de> <CAPDyKFo=m50jiQ639xzP9tzn+=Bn0CXXwO6p0_jPH0EnSc0UQg@mail.gmail.com>
 <CAPDyKFrt3+i83x_qyTrVVCSxda_+3HpJPR6RuPBxzRHnZTRVvA@mail.gmail.com>
 <be41bf8a-df36-7f21-7616-b1983f78b5c7@web.de> <CAPDyKFpj1yU0dDWjZnJN5uqkjcQSy=3gRo1=6grAfdTTD6Z+zg@mail.gmail.com>
 <179da213-d7e1-74c5-8f67-fcbf6337264f@web.de>
In-Reply-To: <179da213-d7e1-74c5-8f67-fcbf6337264f@web.de>
From:   Ulf Hansson <ulf.hansson@linaro.org>
Date:   Wed, 23 Jan 2019 22:18:25 +0100
Message-ID: <CAPDyKFoDWzydAxTTTR7w4Jqr9rWfhTyhaS3q4aSBwY6ORi6xFQ@mail.gmail.com>
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

On Wed, 23 Jan 2019 at 21:17, Jan Kiszka <jan.kiszka@web.de> wrote:
>
> On 23.01.19 09:50, Ulf Hansson wrote:
> > On Tue, 22 Jan 2019 at 17:08, Jan Kiszka <jan.kiszka@web.de> wrote:
> >>
> >> On 21.01.19 15:40, Ulf Hansson wrote:
> >>> On Fri, 18 Jan 2019 at 16:09, Ulf Hansson <ulf.hansson@linaro.org> wrote:
> >>>>
> >>>> On Fri, 18 Jan 2019 at 13:09, Jan Kiszka <jan.kiszka@web.de> wrote:
> >>>>>
> >>>>> On 17.01.19 10:54, Ulf Hansson wrote:
> >>>>>> On Wed, 16 Jan 2019 at 21:26, Jan Kiszka <jan.kiszka@web.de> wrote:
> >>>>>>>
> >>>>>>> On 16.01.19 12:37, Ulf Hansson wrote:
> >>>>>>>> During "wlan-up", we are programming the FW into the WiFi-chip. However,
> >>>>>>>> re-programming the FW doesn't work, unless a power cycle of the WiFi-chip
> >>>>>>>> is made in-between the programmings.
> >>>>>>>>
> >>>>>>>> To conform to this requirement and to fix the regression in a simple way,
> >>>>>>>> let's start by allowing that the SDIO card (WiFi-chip) may stay powered on
> >>>>>>>> (runtime resumed) when wl12xx_sdio_power_off() returns. The intent with the
> >>>>>>>> current code is to treat this scenario as an error, but unfortunate this
> >>>>>>>> doesn't work as expected, so let's fix this.
> >>>>>>>>
> >>>>>>>> The other part is to guarantee that a power cycle of the SDIO card has been
> >>>>>>>> completed when wl12xx_sdio_power_on() returns, as to allow the FW
> >>>>>>>> programming to succeed. However, relying solely on runtime PM to deal with
> >>>>>>>> this isn't sufficient. For example, userspace may prevent runtime suspend
> >>>>>>>> via sysfs for the device that represents the SDIO card, leading to that the
> >>>>>>>> mmc core also keeps it powered on. For this reason, let's instead do a
> >>>>>>>> brute force power cycle in wl12xx_sdio_power_on().
> >>>>>>>>
> >>>>>>>> Fixes: 728a9dc61f13 ("wlcore: sdio: Fix flakey SDIO runtime PM handling")
> >>>>>>>> Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
> >>>>>>>> ---
> >>>>>>>>
> >>>>>>>> Changes in v2:
> >>>>>>>>          - Keep the SDIO host claimed when calling mmc_hw_reset().
> >>>>>>>>          - Add a fixes tag.
> >>>>>>>> ---
> >>>>>>>>      drivers/net/wireless/ti/wlcore/sdio.c | 15 +++++++--------
> >>>>>>>>      1 file changed, 7 insertions(+), 8 deletions(-)
> >>>>>>>>
> >>>>>>>> diff --git a/drivers/net/wireless/ti/wlcore/sdio.c b/drivers/net/wireless/ti/wlcore/sdio.c
> >>>>>>>> index bd10165d7eec..4d4b07701149 100644
> >>>>>>>> --- a/drivers/net/wireless/ti/wlcore/sdio.c
> >>>>>>>> +++ b/drivers/net/wireless/ti/wlcore/sdio.c
> >>>>>>>> @@ -164,6 +164,12 @@ static int wl12xx_sdio_power_on(struct wl12xx_sdio_glue *glue)
> >>>>>>>>          }
> >>>>>>>>
> >>>>>>>>          sdio_claim_host(func);
> >>>>>>>> +     /*
> >>>>>>>> +      * To guarantee that the SDIO card is power cycled, as required to make
> >>>>>>>> +      * the FW programming to succeed, let's do a brute force HW reset.
> >>>>>>>> +      */
> >>>>>>>> +     mmc_hw_reset(card->host);
> >>>>>>>> +
> >>>>>>>>          sdio_enable_func(func);
> >>>>>>>>          sdio_release_host(func);
> >>>>>>>>
> >>>>>>>> @@ -174,20 +180,13 @@ static int wl12xx_sdio_power_off(struct wl12xx_sdio_glue *glue)
> >>>>>>>>      {
> >>>>>>>>          struct sdio_func *func = dev_to_sdio_func(glue->dev);
> >>>>>>>>          struct mmc_card *card = func->card;
> >>>>>>>> -     int error;
> >>>>>>>>
> >>>>>>>>          sdio_claim_host(func);
> >>>>>>>>          sdio_disable_func(func);
> >>>>>>>>          sdio_release_host(func);
> >>>>>>>>
> >>>>>>>>          /* Let runtime PM know the card is powered off */
> >>>>>>>> -     error = pm_runtime_put(&card->dev);
> >>>>>>>> -     if (error < 0 && error != -EBUSY) {
> >>>>>>>> -             dev_err(&card->dev, "%s failed: %i\n", __func__, error);
> >>>>>>>> -
> >>>>>>>> -             return error;
> >>>>>>>> -     }
> >>>>>>>> -
> >>>>>>>> +     pm_runtime_put(&card->dev);
> >>>>>>>>          return 0;
> >>>>>>>>      }
> >>>>>>>>
> >>>>>>>>
> >>>>>>>
> >>>>>>> Just tested on both HiKey (620) and Ultra96 but it fails to fix the issue on
> >>>>>>> both. I'm getting
> >>>>>>>
> >>>>>>> wl1271_sdio: probe of mmc2:0001:1 failed with error -16
> >>>>>>>
> >>>>>>> during boot again, and the interface is not available.
> >>>>>>
> >>>>>> Okay, sounds like this may be a different problem then. Can you share
> >>>>>> the complete log and the kernel config?
> >>>>>
> >>>>> You can find the config here [1], log from the HiKey boot attached.
> >>>>>
> >>>>>> I can prepare a debug patch as well, if you are willing to re-run the test?
> >>>>>
> >>>>> Sure, send it over, I can run it.
> >>>>
> >>>> Alright, sounds great. However, I need to defer that to Monday/Tuesday
> >>>> next week.
> >>>>
> >>>>>
> >>>>>>
> >>>>>> Adding a post-power-on-delay-ms of 1 ms as you suggested [1], doesn't
> >>>>>> sounds like the correct solution to me, unless I am overlooking some
> >>>>>> things. The point is, since the mmc core succeeds to detect and
> >>>>>> initialize the SDIO card, the power sequence seems to be correct.
> >>>>>
> >>>>> Yeah, I'm not claiming at all I know what I'm doing there, just that it happens
> >>>>> to work.
> >>>>
> >>>> I see. Good to know, thanks!
> >>>>
> >>>>>
> >>>>> Jan
> >>>>>
> >>>>> [1]
> >>>>> https://github.com/siemens/jailhouse-images/blob/next/recipes-kernel/linux/files/arm64_defconfig_4.19
> >>>>
> >>>> I have looked through the log and the defconfig. No obvious things
> >>>> found at this point. Thanks for sharing them!
> >>>>
> >>>
> >>> So, I have put together a debug patch, mostly to verify that things
> >>> seems to be correct in regards to runtime PM. It should produce some
> >>> prints to the log, particular during power on/off of the SDIO card and
> >>> during probe of the wifi driver. Please re-run the test on top of the
> >>> v2 version of the $subject patch.
> >>>
> >>
> >> Log attached.
> >
> > Thanks! Okay, so the re-initialization of the SDIO card is failing,
> > that's very valuable information.
> >
> > I noticed one difference while comparing your log with the one I
> > received (offlist) from Anders... In your case the initialization
> > frequency that works the first time is 300KHz, while in Anders case
> > it's 100KHz. This sounds a bit fishy to me, so maybe there are some
> > problems with the pwrseq after all.
> >
> > Let me think a bit and see what I can come up with as a possible solution.
> >
> > In the meantime, can you re-run the test with same debug patch, but
> > change the post-power-on-delay-ms to let's say 10 ms in the DTS? I am
> > going to ask Anders to do the same test on his side, as to see if we
> > get different values of the found initialization frequency.
>
> Here is a log with 10 ms power-on-delay.

Thanks!

According to the log, we are now using 400KHz as the init frequency,
because we succeeds to initialize the SDIO card already at the first
attempt. The same thing happens to Anders' new tests.

Conclusion from my side: We need the delay, probably because the
internals of the WiFi chip isn't ready as soon as the WiFi spec
states. In either case, I suggest you to re-spin your patch [1] and
extend to delay to 10ms (instead of 1ms, just to be safe). Let it have
also have the below fixes tag (as it seems like an original problem
with the pwrseq) and also tag it for stable.

Fixes: ea452678734e ("arm64: dts: hikey: Fix WiFi support")

Finally, feel free to add my ack for it.

Kind regards
Uffe

[1]
https://patchwork.kernel.org/patch/10745075/
