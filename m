Return-Path: <SRS0=pyzf=O5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69004C43387
	for <linux-wireless@archiver.kernel.org>; Thu, 20 Dec 2018 10:15:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2AB7620989
	for <linux-wireless@archiver.kernel.org>; Thu, 20 Dec 2018 10:15:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linaro.org header.i=@linaro.org header.b="A03g0ZiT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730532AbeLTKPc (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 20 Dec 2018 05:15:32 -0500
Received: from mail-vs1-f66.google.com ([209.85.217.66]:34613 "EHLO
        mail-vs1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730450AbeLTKPc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 20 Dec 2018 05:15:32 -0500
Received: by mail-vs1-f66.google.com with SMTP id y27so724407vsi.1
        for <linux-wireless@vger.kernel.org>; Thu, 20 Dec 2018 02:15:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Egd2MQIO74eEgWCnGB+c9Bv3Y0bvjdimnfcBNFZmX64=;
        b=A03g0ZiTOoUJx2bt59qiP3LqmXxXqmvnH4SDPdmhadnaYQA+V361Sp4Eno9veJmOnF
         +zDpjnOO/D30JFNm27d+vueZz7ynTWD3yx7f2r5tovOIe6a7+F+P10BEHcKUmFJBp7Ub
         Uw5y8ZjnnPrEFv0XlI+XhESIY6DJFfSVxF2ow=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Egd2MQIO74eEgWCnGB+c9Bv3Y0bvjdimnfcBNFZmX64=;
        b=JZei/DuvPkAB4BHw+OlrQOhq0wgoNHIgqgZHw2FIdlzoZ5MrtVcWfk3vl0ShmCukUG
         ApMaVOIDgR0Q4uVdIhl0bUuHGBx8mcZRZejScvtuqxKkNV3x+DaSvfBUsJ7VVlROJqCv
         7Q/D3mByWy5OBZP3q5eS6tCcytwZ9RrOiI7vit3T6HedqjlAfCadLQkG3YF8gVJ2brl5
         j71ie2qEuFAkdmTNyfnr7NnB8wQE6Op39vGECjO8A8L/9ft99pGqeJQ7lQoSD0J90cfg
         5Br3Ty9ZHjDIKSQzEEpDIEanmsHtt6vhjAaZ0Tn/TxqtZiewHXNhUM8nYO9wSgySwxQH
         wHQg==
X-Gm-Message-State: AA+aEWZ6UGHEFkbUQ/zFlPbn/2++gg1P/dvb1BjMLipdFhxI4k9tXsFO
        BHr2/q6Q9UFmJtZaMbVu3fZKz8BEAdW8HC4DILWMhA==
X-Google-Smtp-Source: AFSGD/VZGQPkkrUFM12lTY4kf7zHUfyoE1DV6mucV0hBcFm+7Lx8AyokNfr59IPD6owo1fz0sz07LUi6Ki/bLUz3cdM=
X-Received: by 2002:a67:7685:: with SMTP id r127mr11747848vsc.35.1545300931521;
 Thu, 20 Dec 2018 02:15:31 -0800 (PST)
MIME-Version: 1.0
References: <20181217164207.20081-1-tony@atomide.com> <CAPDyKFoLnNWsBfaUwqwL31J=zb0UOQjXUKi7Sj0AUsnNoC6bYg@mail.gmail.com>
 <20181218155439.GB6707@atomide.com>
In-Reply-To: <20181218155439.GB6707@atomide.com>
From:   Ulf Hansson <ulf.hansson@linaro.org>
Date:   Thu, 20 Dec 2018 11:14:55 +0100
Message-ID: <CAPDyKFr2xx6fmdgjd10C1jekWg-yZPk32fGWEPO2PyexjofJ1A@mail.gmail.com>
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

On Tue, 18 Dec 2018 at 16:54, Tony Lindgren <tony@atomide.com> wrote:
>
> Hi,
>
> * Ulf Hansson <ulf.hansson@linaro.org> [181218 12:34]:
> > Instead, it looks like what you need, is a way to keep track of
> > whether the SDIO card, became power cycled or if it stayed powered on,
> > when "ifconfig wlan0 up" is done. In case of a power cycle, you need
> > to re-program the firmware, right?
>
> Yeah mostly. But we also need to ensure things do get powered down
> properly after ifconfig wlan0 down :) IMO after ifconfig wlan0 down
> returns, there should be no waiting needed.
>
> > Would it be possible to re-program the firmware, even if the SDIO card
> > stayed powered-on?
>
> That might help for some cases, but the problem of how to ensure the
> card is powered down after ifconfig wlan0 down returns still exists.

Well, does the SDIO card really have to be powered down before
"ifconfig wlan0 down" returns? If so, why?

An option would be to call pm_runtime_get_sync() at "ifconfig wlan0
up" (I assume you already do that) and then re-program the firmware,
even if the card hasn't been power cycled. Wouldn't that work?

Or perhaps this is the problem you are encountering, that the FW can't
be reprogrammed, unless the card has been power cycled? You can easily
test that, by simply bumping the runtime usage count for the card
device via sysfs, before doing the "ifconfig wlan0 up/down" thingy.

>
> > In regards to delays needed due to a capacitance. If that really is
> > the case, that shall be the managed by the mmc core, as it's there the
> > power cycle sequence is being done. As a matter of fact, you should be
> > able to use drivers/mmc/core/pwrseq_simple.c and extend
> > "power-off-delay-us" in the DTB for Hikey if that is needed.
>
> Hmm I do have a mostly done wlcore pwrseq driver here somewhere that
> I have not had a chance to finish again. But that's not going to work
> for a fix and needs updating of the related dts files too.

Right. Let's see what we can figure out.

Kind regards
Uffe
