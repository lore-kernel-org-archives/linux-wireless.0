Return-Path: <SRS0=OO7s=S4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 636E2C43218
	for <linux-wireless@archiver.kernel.org>; Fri, 26 Apr 2019 22:15:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2E62E2084F
	for <linux-wireless@archiver.kernel.org>; Fri, 26 Apr 2019 22:15:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="H+uaSFEH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727032AbfDZWPF (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 26 Apr 2019 18:15:05 -0400
Received: from mail-ua1-f66.google.com ([209.85.222.66]:38332 "EHLO
        mail-ua1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726871AbfDZWPF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 26 Apr 2019 18:15:05 -0400
Received: by mail-ua1-f66.google.com with SMTP id t15so1709507uao.5
        for <linux-wireless@vger.kernel.org>; Fri, 26 Apr 2019 15:15:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GieBCUtlVhWnwVg6ldcc309iSPs6ZMuQyRIOEMRGO10=;
        b=H+uaSFEHe4LRsSOYpZo/5LQgBlLfDu5tdW/8Kg6h2tBCW3VKfBLB+uUVjh4j5SJf76
         fwur2wzuNO8o1l7FUcOO0L6Tu3WbFJ6eZYdrmQGCuFIz0X6mUn0w5vJ6djySHbp8be/0
         0FOz1LLV1he7mDMIz1pvJO95opBALai1ZtH/M=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GieBCUtlVhWnwVg6ldcc309iSPs6ZMuQyRIOEMRGO10=;
        b=JUcS00GoLAIiOoFspCdnh+D/pRuDvTziW3EOQ1nlEFkzSg4PxMpulxbsMcDaGx13oe
         ibBCJCjz2NjxhLRRU3IMvZNaQqPj4ajd7h3kDLilH1J6O/LzsK0CRPMJ7SVDYnN98qx4
         hags8g7pjJAmqToEx2an6z4DifIwXdDkvTbFxQ6CF+szNaQVDxyldepsIjH81lnOfSNd
         hllkuBiad2FRSXESYJ46dw3rqFGDcd3tdw9fZ9siBoCXLLDAiMV1aQYMmajWXud+IEbj
         8uWohx8ZuPbyoSbBBUDoQ9ABN3fOP8e3SjZN10AgcCI60Phx2ZSNHgII0F5pp6xCbups
         OvGA==
X-Gm-Message-State: APjAAAUvFMSvQ8LlyfwOL1iCymMzXeJ5ckwAd4DnZ9Gazy3KwHuFtwFe
        Xq0jGqE/5qfVsb6loC5nRVQ/Ua4Sy3Q=
X-Google-Smtp-Source: APXvYqy/N1C8v0JZk/Li7ZNc27/VP5wg0dmzGrwja3JNFKkDAKjh5/qKCIpiDPbTkQpgj94w3TDKyQ==
X-Received: by 2002:ab0:3495:: with SMTP id c21mr8978572uar.46.1556316903509;
        Fri, 26 Apr 2019 15:15:03 -0700 (PDT)
Received: from mail-vs1-f41.google.com (mail-vs1-f41.google.com. [209.85.217.41])
        by smtp.gmail.com with ESMTPSA id s194sm11049247vkf.37.2019.04.26.15.15.03
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Fri, 26 Apr 2019 15:15:03 -0700 (PDT)
Received: by mail-vs1-f41.google.com with SMTP id e2so2790604vsc.13
        for <linux-wireless@vger.kernel.org>; Fri, 26 Apr 2019 15:15:03 -0700 (PDT)
X-Received: by 2002:a67:7b53:: with SMTP id w80mr26588048vsc.144.1556316532790;
 Fri, 26 Apr 2019 15:08:52 -0700 (PDT)
MIME-Version: 1.0
References: <20190410221237.160856-1-dianders@chromium.org>
 <CANBLGcwmNowj9GSmE3bbo1t1o6EF8q-RiJftfdOQnJB9_8aSKg@mail.gmail.com>
 <CAD=FV=UW6d2QHzxx-Vtr+WwC1dkpUfCjxCLnfaP5S2UQxRh1oQ@mail.gmail.com> <CANBLGcxpjDFKNdT7uk8uCS=C8Gjxc9wVqDs_ZGHqRpLFVsJxxQ@mail.gmail.com>
In-Reply-To: <CANBLGcxpjDFKNdT7uk8uCS=C8Gjxc9wVqDs_ZGHqRpLFVsJxxQ@mail.gmail.com>
From:   Doug Anderson <dianders@chromium.org>
Date:   Fri, 26 Apr 2019 15:08:41 -0700
X-Gmail-Original-Message-ID: <CAD=FV=UzRbp0w_cN07kQ9dH1B3+v7fmA4_t46kP3cy1k_hn9Ug@mail.gmail.com>
Message-ID: <CAD=FV=UzRbp0w_cN07kQ9dH1B3+v7fmA4_t46kP3cy1k_hn9Ug@mail.gmail.com>
Subject: Re: [PATCH] mmc: dw_mmc: Disable SDIO interrupts while suspended to
 fix suspend/resume
To:     Emil Renner Berthing <emil.renner.berthing@gmail.com>
Cc:     Jaehoon Chung <jh80.chung@samsung.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Shawn Lin <shawn.lin@rock-chips.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Brian Norris <briannorris@chromium.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        stable@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        Matthias Kaehlcke <mka@chromium.org>,
        Ryan Case <ryandcase@chromium.org>,
        Kalle Valo <kvalo@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi,

On Fri, Apr 26, 2019 at 10:19 AM Emil Renner Berthing
<emil.renner.berthing@gmail.com> wrote:
>
> Hi Doug,
>
> TLDR: I'm no longer convinced this patch breaks suspend/resume more
> than it already is. Sorry about the noise.
>
> On Thu, 25 Apr 2019 at 23:25, Doug Anderson <dianders@chromium.org> wrote:
> >
> > Hi,
> >
> > On Wed, Apr 24, 2019 at 1:19 AM Emil Renner Berthing
> > <emil.renner.berthing@gmail.com> wrote:
> > >
> > > Hi Douglas,
> > >
> > > Unfortunately this seems to beak resume on my rk3399-gru-kevin. I have
> > > a semi-complicated setup with my rootfs as a btrfs on dmcrypt on
> > > mmcblk0 which is the dw_mmc, so I'm guessing something goes wrong when
> > > waking up the dm_mmc which probably wasn't suspended before this
> > > patch. It's not 100% consistent though. Sometimes I see it resume the
> > > first time I try suspending, but then 2nd time I suspend it won't come
> > > back.
> >
> > Thanks for testing!
>
> Thanks for your detailed response. It made me want to make absolutely
> sure that this patch is the culprit.
> As a baseline I booted a vanilla 5.0.9 and suspend/resumed it about a
> dusin times without any errors.
> So I applied this patch and immediately it crashed on suspend, but in
> a way that I could still see the kernel log,
> and it was the mwifiex driver that crashed. I rebooted and tried
> supend/resume again and
> this time it seemed like it was the dwc3 or usb3-phy that crashed.
> I still have the kernel log if anyone is interested.
> However 3rd time booting 5.0.9 with this patch suspend/resume just works.
> At least the 2 dusin times I tried before giving up on making it crash.
> I went back to vanilla 5.0.9 and after a few tries I managed to make
> that one crash too.
> I guess that means this patch is off the hook. I'm sorry about the
> false report :/

No worries, I've certainly been there and I'm super happy to have
people testing patches.  :-)

Odd that you're having suspend/resume patches.  My first guess for
super randomness would be WiFi.  The PCIe bus on rk3399 causes the
most impossible to debug problems if you try to access it at the wrong
time.  If you disable WiFi do all your problems go away?  I tried
putting v5.0.9 on the kevin sitting on my desk and it seems to
suspend/resume OK (25 cycles), but:

* I just jammed it straight onto a normal Chrome OS root filesystem.
Since that filesystem expects the GPU to be there, I'm just booting to
a serial prompt and the screen just displays the boot splash.

* I didn't try to configure WiFi or anything.

* I'm using the Chrome OS "fallback config" for the kernel (the config
our build system picks if building an upstream kernel without the
normal split config).  AKA:
<https://chromium.googlesource.com/chromiumos/overlays/chromiumos-overlay/+/refs/heads/master/eclass/cros-kernel/rockchip64_defconfig>.
I'm not 100% sure everything is enabled there...

* I'm booting w/ serial console enabled and doing my testing with "no
console suspend" which can certainly affect suspend/resume timing.


Best of luck tracking your problems down!  I suppose if things used to
work maybe a bisect would be possible?

-Doug
