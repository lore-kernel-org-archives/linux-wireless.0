Return-Path: <SRS0=+yu+=PF=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 628B3C43387
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Dec 2018 11:01:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 329BB20879
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Dec 2018 11:01:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linaro.org header.i=@linaro.org header.b="LnuFCWGa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729587AbeL1LBj (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 28 Dec 2018 06:01:39 -0500
Received: from mail-vk1-f193.google.com ([209.85.221.193]:39980 "EHLO
        mail-vk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728367AbeL1LBj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 28 Dec 2018 06:01:39 -0500
Received: by mail-vk1-f193.google.com with SMTP id v70so4485693vkv.7
        for <linux-wireless@vger.kernel.org>; Fri, 28 Dec 2018 03:01:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/dVER2SVx/UNhoG7yZEwBp4mYlPy79dQP84QAxPAfV4=;
        b=LnuFCWGapiWS0W1rOnFAbabMIuKU/eCrP1yG7xC5u1qGYomAOblswa1cPpQDd/ALMu
         paTd/2OJlqnPcKFRZl5Ff4p4isTXpW2vXR7YVEFx3uwotCEMU6uAYhOhGv7RLjitSXRu
         tHbdBFBH2RMwaU1A5Mw7LXdOQo8Xa1aaUAK7Q=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/dVER2SVx/UNhoG7yZEwBp4mYlPy79dQP84QAxPAfV4=;
        b=kD2uWIPzVMQj/CEolHMRsiNuiGS6Xi0zt44lWoml3zU1Gw42hVuNWFInhtU3ivqjH3
         Qwjk3gNdoK/gmYi7ur0jMkBk8aJJMpV+Up2k+MAqw3b2VEr1qwuttR2qVXvH7xJNqsCp
         cxlfAaZ+9CW7FPsMF2CoK1xBS9zQB5iXoiPuhS03LC2+0K22ikpjPYwgVrdUaCHr6Lt7
         YJBDVhGVG8lJEthIJqV7DPD2k4PTwARZeZxvC9JSvsAHBwO6Gw4kuwGTjpMM3MgRZY5s
         QTi8bY0L9eOoZfcZ2wUHBSwns7ztkMFz7ZlHfVXD8am59SMePEgpCzMKXJLR+jO1NAVy
         f45g==
X-Gm-Message-State: AJcUukcSUGpmj0Sy5CGSZosRt4aWFA867oFKBfGpvcjaNHsRGJh1+jWD
        694AjvflT2HvoA1ZTbbFvTDHOP4rf2L/Z6LA4XBV1Q==
X-Google-Smtp-Source: ALg8bN7dx6hcavqbShweJ6R9gayZPg6jtdO+rwUe7QkWm8O8GG2Hpnq1zz8xA70o5Ckm6ly+ziYyhzpphARtseNsp9A=
X-Received: by 2002:a1f:298e:: with SMTP id p136mr9885262vkp.40.1545994896286;
 Fri, 28 Dec 2018 03:01:36 -0800 (PST)
MIME-Version: 1.0
References: <20181217164207.20081-1-tony@atomide.com> <CAPDyKFoLnNWsBfaUwqwL31J=zb0UOQjXUKi7Sj0AUsnNoC6bYg@mail.gmail.com>
 <20181218155439.GB6707@atomide.com> <CAPDyKFr2xx6fmdgjd10C1jekWg-yZPk32fGWEPO2PyexjofJ1A@mail.gmail.com>
 <20181220231401.GG6707@atomide.com> <c22e2ab61b494ea0852c0f4654fef92d@ti.com> <20181223160226.GK6707@atomide.com>
In-Reply-To: <20181223160226.GK6707@atomide.com>
From:   Ulf Hansson <ulf.hansson@linaro.org>
Date:   Fri, 28 Dec 2018 12:01:00 +0100
Message-ID: <CAPDyKFoEOGACs4Wnm7UgKab2b1-7+v8+31DpC+p=8XxcQhSpcQ@mail.gmail.com>
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

On Sun, 23 Dec 2018 at 17:02, Tony Lindgren <tony@atomide.com> wrote:
>
> Hi,
>
> * Reizer, Eyal <eyalr@ti.com> [181223 07:38]:
> > You are ok as long as the wlan_enable pin Does go down for a sufficient amount of time
> > turning the wl18xx device off.
> > The firmware can only be downloaded once after power on.
> > In between down/up you have to make sure the wlan_enable is fully going through on->off->on
> > and the wl18xx device is fully reset.
> > On power on the firmware is loaded by the driver and this will fail in case the reset didn't happen
>
> OK thanks for confirming that it's the enable pin that needs to toggle.
>
> Sounds like I need to get the wlcore pwrseq changes done and posted as
> the long term solution.

Just to make sure we are talking about the same things here. The
pwrseq thingy, is already implemented in the mmc core. When it comes
to Hikey, there is already a pwrseq node deployed in the DTB. So, we
should be fine.

Here are the MMC pwrseq bindings:
Documentation/devicetree/bindings/mmc/mmc-pwrseq-simple.txt
Documentation/devicetree/bindings/mmc/mmc.txt

Here is the Hikey DTS file:
arch/arm64/boot/dts/hisilicon/hi6220-hikey.dts

>
> And for a short term fix, we should just add msleep(50) for now with
> updated patch description.
>
> Does that that sound OK to everybody?

Unfortunate, that doesn't work. Because, if user space via sysfs has
prevented runtime suspend, the SDIO card never becomes power off with
a call to pm_runtime_put*(), not even after waiting 50 ms.

If we need a short term solution, I think there are two options.

1) Call pm_runtime_force_suspend() instead of pm_runtime_put*() at
"down". This makes sure the card becomes powered off. At "up", call
pm_runtime_force_resume() instead of pm_runtime_get_sync(). Because
the runtime PM usage count it > 1, at "up", pm_runtime_force_resume()
will power up the card, rather than deferring it.

The problem with 1), is if there is an ACPI PM domain attached to the
SDIO card device. Then this doesn't work. I can't tell if that is ever
the case here.

2) At "up", after the call to pm_runtime_get_sync(), add a call to
mmc_hw_reset(). This forces the mmc core to power cycle and re-init
the SDIO card. This may in some cases be a waste, as the card may
already have been power cycled, but at least we should now always be
able to re-program the firmware.

If there is no rush, I think we may consider to move away from using
runtime PM to control power for SDIO cards. Because, what we seem to
need, is a simple interface (reference counted) to power-on/off SDIO
cards.

Kind regards
Uffe
