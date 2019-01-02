Return-Path: <SRS0=/oVT=PK=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B58B3C43387
	for <linux-wireless@archiver.kernel.org>; Wed,  2 Jan 2019 12:02:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7A8E4218D3
	for <linux-wireless@archiver.kernel.org>; Wed,  2 Jan 2019 12:02:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linaro.org header.i=@linaro.org header.b="hV1eTRD9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729824AbfABMC3 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 2 Jan 2019 07:02:29 -0500
Received: from mail-vs1-f65.google.com ([209.85.217.65]:40731 "EHLO
        mail-vs1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729788AbfABMC3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 2 Jan 2019 07:02:29 -0500
Received: by mail-vs1-f65.google.com with SMTP id z3so18716203vsf.7
        for <linux-wireless@vger.kernel.org>; Wed, 02 Jan 2019 04:02:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ApOf9iCAd37OWdntDNTpKVlcF4InyKhMWN6Sd8ISTUQ=;
        b=hV1eTRD9jfVPuPKNascbDyT7OqgHg6dTZAuvDLTJYWrBEy1VEBkfvl9DmGDSDx1APY
         c1TN6JR/Hn3WRhfchj02Vc86GfWPfgpkVJv1bHP+xj0/06bSWComDxQ+3eoxwaLQb56y
         iCexEW+onEwvMPcRL6xRpKI66nH7TufhtunEs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ApOf9iCAd37OWdntDNTpKVlcF4InyKhMWN6Sd8ISTUQ=;
        b=qcNjHzewcHHgl8FvHbsVf9fb7kE81icNm6jStD1R2cXsuuHm5n/JfzFXA2QNJm/MjB
         XqxjlBE0XnpoMfyml5mQazO1i7QM7uHyHk5yjm6/dQ5yqRSZ12rWzQi62jM602Q1rcdy
         tZGV932pTpjzEbZK2A653eXc39+Hp+oPZWSkbiKtphHwKOyO6oF+PdXIGDOkhE4izaI6
         uaQtPGMLUNTKZ+zPkMIrePTIZj52XvQWC4RnCs6TIQ70cHuOikFnX/FAdLvEN+wDDKxs
         /BNjYj5KC0dgEEyGIshlUGYwQTuALiS2mpXBDfJ4GK+MHORWVG8wsDoS/WiHabpFimrN
         PwrA==
X-Gm-Message-State: AJcUukddFA8yEEpUcy1mFddmk908iAJ23gwm8QA/r9rGhryDF+Vqq+SO
        ptflhcD8EEFm5DRjHZFfBXmhy9n/HjJspnPzc5c87w==
X-Google-Smtp-Source: ALg8bN48T5tEzb+Muzlf/v3xJJQ/ymrSl+IObOIT0B2G7tE5WvxDSPTFuyqYoW+D0OYi6Xh4v6Wm5efNCtXeyPbU5BE=
X-Received: by 2002:a67:1a84:: with SMTP id a126mr3815985vsa.165.1546430546761;
 Wed, 02 Jan 2019 04:02:26 -0800 (PST)
MIME-Version: 1.0
References: <20181217164207.20081-1-tony@atomide.com> <CAPDyKFoLnNWsBfaUwqwL31J=zb0UOQjXUKi7Sj0AUsnNoC6bYg@mail.gmail.com>
 <20181218155439.GB6707@atomide.com> <CAPDyKFr2xx6fmdgjd10C1jekWg-yZPk32fGWEPO2PyexjofJ1A@mail.gmail.com>
 <20181220231401.GG6707@atomide.com> <c22e2ab61b494ea0852c0f4654fef92d@ti.com>
 <20181223160226.GK6707@atomide.com> <CAPDyKFoEOGACs4Wnm7UgKab2b1-7+v8+31DpC+p=8XxcQhSpcQ@mail.gmail.com>
 <20181228195903.GX6707@atomide.com>
In-Reply-To: <20181228195903.GX6707@atomide.com>
From:   Ulf Hansson <ulf.hansson@linaro.org>
Date:   Wed, 2 Jan 2019 13:01:50 +0100
Message-ID: <CAPDyKFq9XmRueJEFKVb03hqLuoB84TGjrdvEjre46ezYbk_wgw@mail.gmail.com>
Subject: Re: [EXTERNAL] Re: [PATCH] wlcore: Fix bringing up wlan0 again if
 powered down briefly
To:     Tony Lindgren <tony@atomide.com>
Cc:     "Reizer, Eyal" <eyalr@ti.com>, Kalle Valo <kvalo@codeaurora.org>,
        KISHON VIJAY ABRAHAM <kishon@ti.com>,
        "Mishol, Guy" <guym@ti.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        linux-omap <linux-omap@vger.kernel.org>,
        Anders Roxell <anders.roxell@linaro.org>,
        John Stultz <john.stultz@linaro.org>,
        Ricardo Salveti <rsalveti@rsalveti.net>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Fri, 28 Dec 2018 at 20:59, Tony Lindgren <tony@atomide.com> wrote:
>
> Hi,
>
> * Ulf Hansson <ulf.hansson@linaro.org> [181228 11:01]:
> > On Sun, 23 Dec 2018 at 17:02, Tony Lindgren <tony@atomide.com> wrote:
> > >
> > > Hi,
> > >
> > > * Reizer, Eyal <eyalr@ti.com> [181223 07:38]:
> > > > You are ok as long as the wlan_enable pin Does go down for a sufficient amount of time
> > > > turning the wl18xx device off.
> > > > The firmware can only be downloaded once after power on.
> > > > In between down/up you have to make sure the wlan_enable is fully going through on->off->on
> > > > and the wl18xx device is fully reset.
> > > > On power on the firmware is loaded by the driver and this will fail in case the reset didn't happen
> > >
> > > OK thanks for confirming that it's the enable pin that needs to toggle.
> > >
> > > Sounds like I need to get the wlcore pwrseq changes done and posted as
> > > the long term solution.
> >
> > Just to make sure we are talking about the same things here. The
> > pwrseq thingy, is already implemented in the mmc core. When it comes
> > to Hikey, there is already a pwrseq node deployed in the DTB. So, we
> > should be fine.
> >
> > Here are the MMC pwrseq bindings:
> > Documentation/devicetree/bindings/mmc/mmc-pwrseq-simple.txt
> > Documentation/devicetree/bindings/mmc/mmc.txt
> >
> > Here is the Hikey DTS file:
> > arch/arm64/boot/dts/hisilicon/hi6220-hikey.dts
>
> Oh so it seems. And looking at my earlier pwrseq_wlcore.c hacks, I only
> added pinctrl handling to work around a GPIO glitch on some SoCs for
> deeper idle states. So I don't think we need a pwrseq_wlcore.c as
> I've found a better way to deal with the GPIO glitch by implementing
> gpiochip for the pinctrl driver.
>

If you have a "default" pinctrl state defined in the mmc-pwrseq node
that state will be set during probe. That's because we have made each
pwrseq provider being a standalone driver, thus pinctrl_bind_pins()
get called by driver core. I realize that we should update the DT
bindings for mmc pwrseq to reflect that, I will send a patch for that.

If you need some additional pinctrl states for the mmc pwrseq_simple
driver, for example, we can easily add that. I assume putting the pins
in a sleep state once powering off the wifi chip could make sense.

However, if this is about an out-of-band IRQ line, instead of using
the SDIO IRQs on DAT1, I think management of that, belongs in the wlan
(or gpiochip) layers.

> > > And for a short term fix, we should just add msleep(50) for now with
> > > updated patch description.
> > >
> > > Does that that sound OK to everybody?
> >
> > Unfortunate, that doesn't work. Because, if user space via sysfs has
> > prevented runtime suspend, the SDIO card never becomes power off with
> > a call to pm_runtime_put*(), not even after waiting 50 ms.
>
> Yes you're right.
>
> > If we need a short term solution, I think there are two options.
> >
> > 1) Call pm_runtime_force_suspend() instead of pm_runtime_put*() at
> > "down". This makes sure the card becomes powered off. At "up", call
> > pm_runtime_force_resume() instead of pm_runtime_get_sync(). Because
> > the runtime PM usage count it > 1, at "up", pm_runtime_force_resume()
> > will power up the card, rather than deferring it.
> >
> > The problem with 1), is if there is an ACPI PM domain attached to the
> > SDIO card device. Then this doesn't work. I can't tell if that is ever
> > the case here.
>
> Hmm..
>
> > 2) At "up", after the call to pm_runtime_get_sync(), add a call to
> > mmc_hw_reset(). This forces the mmc core to power cycle and re-init
> > the SDIO card. This may in some cases be a waste, as the card may
> > already have been power cycled, but at least we should now always be
> > able to re-program the firmware.
>
> Option 2 sounds more generic to me. Do you have some test patch for
> this?

I can send a formal patch, but not sure which of the option to pick
yet, (if any).

>
> Sounds like you're thinking about adding this to the MMC framework?

Both 1) and 2) is doable already, without having to change the MMC framework.

>
> If the only issue is if the card must be powered off when ifconfig
> wlan0 returns, I think that's a cosmetic issue. For example,
> switching to wlcore test mode after ifconfig wlan0 down might need
> the card powered down, but then again the test mode resets things
> anyway. Eyal?

I am not convinced, sorry.

We have to distinguish if "down" has a strict requirement to power off
the wlan-chip.

For example, in "flight mode", is it okay to leave the wlan chip
powered on and thus potentially also having its radio part active?

>
> > If there is no rush, I think we may consider to move away from using
> > runtime PM to control power for SDIO cards. Because, what we seem to
> > need, is a simple interface (reference counted) to power-on/off SDIO
> > cards.
>
> Well we should fix the regression in a minimal way first though.
> And to me it sounds like option 2 above should do the trick, not
> sure if we need something beyond that.

Okay, let's focus on fixing the regression first, then we can look
into more long term improvements.

Kind regards
Uffe
