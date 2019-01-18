Return-Path: <SRS0=80NG=P2=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 154A3C43387
	for <linux-wireless@archiver.kernel.org>; Fri, 18 Jan 2019 15:05:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DA70E2086D
	for <linux-wireless@archiver.kernel.org>; Fri, 18 Jan 2019 15:05:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linaro.org header.i=@linaro.org header.b="Jwk7Y2mz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727765AbfARPFi (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 18 Jan 2019 10:05:38 -0500
Received: from mail-yb1-f195.google.com ([209.85.219.195]:37437 "EHLO
        mail-yb1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727415AbfARPFi (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 18 Jan 2019 10:05:38 -0500
Received: by mail-yb1-f195.google.com with SMTP id 2so4454343ybw.4
        for <linux-wireless@vger.kernel.org>; Fri, 18 Jan 2019 07:05:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=m+JIDFKXyEotGis6+4coVIxtbcNzy1N6Mp6UKUpr4gY=;
        b=Jwk7Y2mzgYm0CH3bkavaHIHrFrH8VDS6o45o03ukqIRRk2xztttSIOD5MkDqOaFgJT
         THGuBRgJYvgZCHpwQ3fmJQ1pETpbx4n0dlfqvz9zxX0Uw4ZadlBAYeEmOSfyYZC4KoIL
         vmGIvYHbPUmDmGCpts8tgzAUQYfI978Ox3Qr0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=m+JIDFKXyEotGis6+4coVIxtbcNzy1N6Mp6UKUpr4gY=;
        b=KtKHoJiC5hAApH5I5tI0d4Pql9iFy4va5EUTJrFOOfcsVaU0rTGwdg1ywgbUmP3kSF
         XbNqGYz9G+S5GacL3LN/IBXzuF4ndogSK3G0dW2Pn1bt2NVDAH3u8YyPSEDyquF2+UmD
         uaPQFeechU0KXKsfhcdjKAbgVnAzUMpLi+RoIFJYXnvSKFwmAd+C05z1OuXqOchNfL9e
         TRbjHiiOpOrA0N1WrEjuj4qiZrgb520FNgL43lf91fAsQwBVPJpcAiO60XdPIUMP+50D
         DLwptkcqL/b2DdN6BMbMqxWVhfpASE0fAOnFErzZEQda2VXMB+qa7ghaaslZnByl3u1p
         MUYw==
X-Gm-Message-State: AJcUukeu1ZIZoUHOOHDa1x8T4t3OyLB54IJ6cBEdXIDb7ONrggNFTVaX
        i5vvTwc3E4PRXuas+eg/MeO1DM3zr+aKrJksKf9rug==
X-Google-Smtp-Source: ALg8bN76/PHFLRsOIf3qPohMidEFqljem8pKK7UAocSZF7n5HqqLEERi4GZvDaVvTUSFk73Adluz6SF5MZgvjiuM7x4=
X-Received: by 2002:a25:7008:: with SMTP id l8mr6621103ybc.270.1547823936592;
 Fri, 18 Jan 2019 07:05:36 -0800 (PST)
MIME-Version: 1.0
References: <20190116113723.15668-1-ulf.hansson@linaro.org> <20190116154311.GP5544@atomide.com>
In-Reply-To: <20190116154311.GP5544@atomide.com>
From:   Anders Roxell <anders.roxell@linaro.org>
Date:   Fri, 18 Jan 2019 16:05:25 +0100
Message-ID: <CADYN=9L-x2Ar5COE3mJRZz_V-7TNOF__8Rh4Hq7YJ=PoHFrR3Q@mail.gmail.com>
Subject: Re: [PATCH V2] wlcore: sdio: Fixup power on/off sequence
To:     Tony Lindgren <tony@atomide.com>
Cc:     Ulf Hansson <ulf.hansson@linaro.org>,
        Kalle Valo <kvalo@codeaurora.org>, Eyal Reizer <eyalr@ti.com>,
        linux-wireless@vger.kernel.org,
        Ricardo Salveti <rsalveti@rsalveti.net>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        John Stultz <john.stultz@linaro.org>,
        Jan Kiszka <jan.kiszka@web.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-omap@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, 16 Jan 2019 at 16:43, Tony Lindgren <tony@atomide.com> wrote:
>
> * Ulf Hansson <ulf.hansson@linaro.org> [190116 11:37]:
> > During "wlan-up", we are programming the FW into the WiFi-chip. However,
> > re-programming the FW doesn't work, unless a power cycle of the WiFi-chip
> > is made in-between the programmings.
> >
> > To conform to this requirement and to fix the regression in a simple way,
> > let's start by allowing that the SDIO card (WiFi-chip) may stay powered on
> > (runtime resumed) when wl12xx_sdio_power_off() returns. The intent with the
> > current code is to treat this scenario as an error, but unfortunate this
> > doesn't work as expected, so let's fix this.
> >
> > The other part is to guarantee that a power cycle of the SDIO card has been
> > completed when wl12xx_sdio_power_on() returns, as to allow the FW
> > programming to succeed. However, relying solely on runtime PM to deal with
> > this isn't sufficient. For example, userspace may prevent runtime suspend
> > via sysfs for the device that represents the SDIO card, leading to that the
> > mmc core also keeps it powered on. For this reason, let's instead do a
> > brute force power cycle in wl12xx_sdio_power_on().
> >
> > Fixes: 728a9dc61f13 ("wlcore: sdio: Fix flakey SDIO runtime PM handling")
> > Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
> > ---
> >
> > Changes in v2:
> >       - Keep the SDIO host claimed when calling mmc_hw_reset().
> >       - Add a fixes tag.
>
> This v2 version works for me as tested with:
>
> # while [ 1 ]; do ifconfig wlan0 down; ifconfig wlan0 up; done
> [  181.364990] wlcore: down
> [  182.116424] wlcore: firmware booted (Rev 6.3.10.0.141)
> [  182.151641] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
> [  182.166778] wlcore: down
> [  182.773132] wlcore: firmware booted (Rev 6.3.10.0.141)
> [  182.811096] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
> ...
>
> Thanks for fixing this issue properly, and feel free to add:
>
> Tested-by: Tony Lindgren <tony@atomide.com>

Tested-by: Anders Roxell <anders.roxell@linaro.org>

I tested it on a hikey-6220, and it worked.

Cheers,
Anders
