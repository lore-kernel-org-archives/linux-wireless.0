Return-Path: <SRS0=+yu+=PF=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78858C43387
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Dec 2018 19:59:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4A7ED20866
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Dec 2018 19:59:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732249AbeL1T7I (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 28 Dec 2018 14:59:08 -0500
Received: from muru.com ([72.249.23.125]:59606 "EHLO muru.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732233AbeL1T7I (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 28 Dec 2018 14:59:08 -0500
Received: from atomide.com (localhost [127.0.0.1])
        by muru.com (Postfix) with ESMTPS id C89FB80BF;
        Fri, 28 Dec 2018 19:59:11 +0000 (UTC)
Date:   Fri, 28 Dec 2018 11:59:03 -0800
From:   Tony Lindgren <tony@atomide.com>
To:     Ulf Hansson <ulf.hansson@linaro.org>
Cc:     "Reizer, Eyal" <eyalr@ti.com>, Kalle Valo <kvalo@codeaurora.org>,
        KISHON VIJAY ABRAHAM <kishon@ti.com>,
        "Mishol, Guy" <guym@ti.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        linux-omap <linux-omap@vger.kernel.org>,
        Anders Roxell <anders.roxell@linaro.org>,
        John Stultz <john.stultz@linaro.org>,
        Ricardo Salveti <rsalveti@rsalveti.net>
Subject: Re: [EXTERNAL] Re: [PATCH] wlcore: Fix bringing up wlan0 again if
 powered down briefly
Message-ID: <20181228195903.GX6707@atomide.com>
References: <20181217164207.20081-1-tony@atomide.com>
 <CAPDyKFoLnNWsBfaUwqwL31J=zb0UOQjXUKi7Sj0AUsnNoC6bYg@mail.gmail.com>
 <20181218155439.GB6707@atomide.com>
 <CAPDyKFr2xx6fmdgjd10C1jekWg-yZPk32fGWEPO2PyexjofJ1A@mail.gmail.com>
 <20181220231401.GG6707@atomide.com>
 <c22e2ab61b494ea0852c0f4654fef92d@ti.com>
 <20181223160226.GK6707@atomide.com>
 <CAPDyKFoEOGACs4Wnm7UgKab2b1-7+v8+31DpC+p=8XxcQhSpcQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPDyKFoEOGACs4Wnm7UgKab2b1-7+v8+31DpC+p=8XxcQhSpcQ@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi,

* Ulf Hansson <ulf.hansson@linaro.org> [181228 11:01]:
> On Sun, 23 Dec 2018 at 17:02, Tony Lindgren <tony@atomide.com> wrote:
> >
> > Hi,
> >
> > * Reizer, Eyal <eyalr@ti.com> [181223 07:38]:
> > > You are ok as long as the wlan_enable pin Does go down for a sufficient amount of time
> > > turning the wl18xx device off.
> > > The firmware can only be downloaded once after power on.
> > > In between down/up you have to make sure the wlan_enable is fully going through on->off->on
> > > and the wl18xx device is fully reset.
> > > On power on the firmware is loaded by the driver and this will fail in case the reset didn't happen
> >
> > OK thanks for confirming that it's the enable pin that needs to toggle.
> >
> > Sounds like I need to get the wlcore pwrseq changes done and posted as
> > the long term solution.
> 
> Just to make sure we are talking about the same things here. The
> pwrseq thingy, is already implemented in the mmc core. When it comes
> to Hikey, there is already a pwrseq node deployed in the DTB. So, we
> should be fine.
> 
> Here are the MMC pwrseq bindings:
> Documentation/devicetree/bindings/mmc/mmc-pwrseq-simple.txt
> Documentation/devicetree/bindings/mmc/mmc.txt
> 
> Here is the Hikey DTS file:
> arch/arm64/boot/dts/hisilicon/hi6220-hikey.dts

Oh so it seems. And looking at my earlier pwrseq_wlcore.c hacks, I only
added pinctrl handling to work around a GPIO glitch on some SoCs for
deeper idle states. So I don't think we need a pwrseq_wlcore.c as
I've found a better way to deal with the GPIO glitch by implementing
gpiochip for the pinctrl driver.

> > And for a short term fix, we should just add msleep(50) for now with
> > updated patch description.
> >
> > Does that that sound OK to everybody?
> 
> Unfortunate, that doesn't work. Because, if user space via sysfs has
> prevented runtime suspend, the SDIO card never becomes power off with
> a call to pm_runtime_put*(), not even after waiting 50 ms.

Yes you're right.

> If we need a short term solution, I think there are two options.
> 
> 1) Call pm_runtime_force_suspend() instead of pm_runtime_put*() at
> "down". This makes sure the card becomes powered off. At "up", call
> pm_runtime_force_resume() instead of pm_runtime_get_sync(). Because
> the runtime PM usage count it > 1, at "up", pm_runtime_force_resume()
> will power up the card, rather than deferring it.
> 
> The problem with 1), is if there is an ACPI PM domain attached to the
> SDIO card device. Then this doesn't work. I can't tell if that is ever
> the case here.

Hmm..

> 2) At "up", after the call to pm_runtime_get_sync(), add a call to
> mmc_hw_reset(). This forces the mmc core to power cycle and re-init
> the SDIO card. This may in some cases be a waste, as the card may
> already have been power cycled, but at least we should now always be
> able to re-program the firmware.

Option 2 sounds more generic to me. Do you have some test patch for
this?

Sounds like you're thinking about adding this to the MMC framework?

If the only issue is if the card must be powered off when ifconfig
wlan0 returns, I think that's a cosmetic issue. For example,
switching to wlcore test mode after ifconfig wlan0 down might need
the card powered down, but then again the test mode resets things
anyway. Eyal?

> If there is no rush, I think we may consider to move away from using
> runtime PM to control power for SDIO cards. Because, what we seem to
> need, is a simple interface (reference counted) to power-on/off SDIO
> cards.

Well we should fix the regression in a minimal way first though.
And to me it sounds like option 2 above should do the trick, not
sure if we need something beyond that.

Regards,

Tony
