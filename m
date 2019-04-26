Return-Path: <SRS0=OO7s=S4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D7A1C43218
	for <linux-wireless@archiver.kernel.org>; Fri, 26 Apr 2019 17:20:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 03F8F212F5
	for <linux-wireless@archiver.kernel.org>; Fri, 26 Apr 2019 17:20:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fgPi2ed0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726170AbfDZRT5 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 26 Apr 2019 13:19:57 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:37257 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725944AbfDZRT4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 26 Apr 2019 13:19:56 -0400
Received: by mail-io1-f68.google.com with SMTP id a23so3576171iot.4;
        Fri, 26 Apr 2019 10:19:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6RhyZrNZwjSd8duPbbJh0QjUHOd9upb57vvukrqOPyw=;
        b=fgPi2ed0hON7GBQV9AXLvlIFngg+XmXBq5b54A/oTf3p9/O+fGDFcRiIZtjJIPsXN8
         9G2zRTere33aqyxdkSi4i3fuO9+zMtf2ASdQIDSfg05AHI+dApk+iR7iX0cSEXnjsV5r
         j/c818mFiBf4yQmBkd183XXFqq5EmfZ45YnnCIizDE43bb6fzY7Cf4Qa8Da4N2M59rsT
         sIb3zDKp0xHlFVfV4UZS85L0bVQeIEhsHrq0rLa1Ek8DpHmrn6085RsjwFsUFhXtao2O
         661Le3VdgjI8eis30aBygQiRFe9UiuHzOul3iWyd//WKTn2sOryT++suBD0ujM/I7moR
         ZVSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6RhyZrNZwjSd8duPbbJh0QjUHOd9upb57vvukrqOPyw=;
        b=bWDR0Z01gc1jvKOyLxShdpJBUxEKJT54k8pXgnkmFpTGfy9ENI3W3Z6wMyxDY1bKxl
         ZJ2iXvVXc8Q+RuN9I15TtVFx6ymZBuXaem/dfyvjUdDaNqWBBOtO/BYx0lv6nEuEhvy8
         ESvds9EX6I3fYXx9TQ11Bk/D4wrAfEXp6DBinjMZLY1N+6bCgfNf45TTulGT0jASBchZ
         fxmDMGqjEmkwWCutFcdkuqFoeY0n++0zECa16N+2fD350ObRWZIqIRNdQonZGL0oE9sQ
         9xUR6zGr7n5dRVb99xUpK3nLqNBMMZ/ISaPGVwIRWsrHzueA56fa1J6986Ht/94OJbV5
         1gIQ==
X-Gm-Message-State: APjAAAUiXonLQpWlfEmFvU3k7pkcB5BSBapmE7U3DDUKwGkOqh3/Qwd9
        WxamY7lLZy4tm/JobhE/l4GhFsVR4AucshpGC68=
X-Google-Smtp-Source: APXvYqwDgeTyqhbmOujKb58870SOkNxEzB9N9uTsw4Hwr8qXR5eGBV+EZVd/MbHb6BN3Dbybe9RW5XTBNH3/8DM0hrk=
X-Received: by 2002:a6b:7417:: with SMTP id s23mr1315489iog.2.1556299195506;
 Fri, 26 Apr 2019 10:19:55 -0700 (PDT)
MIME-Version: 1.0
References: <20190410221237.160856-1-dianders@chromium.org>
 <CANBLGcwmNowj9GSmE3bbo1t1o6EF8q-RiJftfdOQnJB9_8aSKg@mail.gmail.com> <CAD=FV=UW6d2QHzxx-Vtr+WwC1dkpUfCjxCLnfaP5S2UQxRh1oQ@mail.gmail.com>
In-Reply-To: <CAD=FV=UW6d2QHzxx-Vtr+WwC1dkpUfCjxCLnfaP5S2UQxRh1oQ@mail.gmail.com>
From:   Emil Renner Berthing <emil.renner.berthing@gmail.com>
Date:   Fri, 26 Apr 2019 19:19:42 +0200
Message-ID: <CANBLGcxpjDFKNdT7uk8uCS=C8Gjxc9wVqDs_ZGHqRpLFVsJxxQ@mail.gmail.com>
Subject: Re: [PATCH] mmc: dw_mmc: Disable SDIO interrupts while suspended to
 fix suspend/resume
To:     Doug Anderson <dianders@chromium.org>
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

Hi Doug,

TLDR: I'm no longer convinced this patch breaks suspend/resume more
than it already is. Sorry about the noise.

On Thu, 25 Apr 2019 at 23:25, Doug Anderson <dianders@chromium.org> wrote:
>
> Hi,
>
> On Wed, Apr 24, 2019 at 1:19 AM Emil Renner Berthing
> <emil.renner.berthing@gmail.com> wrote:
> >
> > Hi Douglas,
> >
> > Unfortunately this seems to beak resume on my rk3399-gru-kevin. I have
> > a semi-complicated setup with my rootfs as a btrfs on dmcrypt on
> > mmcblk0 which is the dw_mmc, so I'm guessing something goes wrong when
> > waking up the dm_mmc which probably wasn't suspended before this
> > patch. It's not 100% consistent though. Sometimes I see it resume the
> > first time I try suspending, but then 2nd time I suspend it won't come
> > back.
>
> Thanks for testing!

Thanks for your detailed response. It made me want to make absolutely
sure that this patch is the culprit.
As a baseline I booted a vanilla 5.0.9 and suspend/resumed it about a
dusin times without any errors.
So I applied this patch and immediately it crashed on suspend, but in
a way that I could still see the kernel log,
and it was the mwifiex driver that crashed. I rebooted and tried
supend/resume again and
this time it seemed like it was the dwc3 or usb3-phy that crashed.
I still have the kernel log if anyone is interested.
However 3rd time booting 5.0.9 with this patch suspend/resume just works.
At least the 2 dusin times I tried before giving up on making it crash.
I went back to vanilla 5.0.9 and after a few tries I managed to make
that one crash too.
I guess that means this patch is off the hook. I'm sorry about the
false report :/

/Emil
