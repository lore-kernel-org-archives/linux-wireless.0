Return-Path: <SRS0=tUzJ=SY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9BE8C282CE
	for <linux-wireless@archiver.kernel.org>; Mon, 22 Apr 2019 15:21:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8D1F820859
	for <linux-wireless@archiver.kernel.org>; Mon, 22 Apr 2019 15:21:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="HP46O8oI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727463AbfDVPVp (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 22 Apr 2019 11:21:45 -0400
Received: from mail-vs1-f68.google.com ([209.85.217.68]:36159 "EHLO
        mail-vs1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727309AbfDVPVm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 22 Apr 2019 11:21:42 -0400
Received: by mail-vs1-f68.google.com with SMTP id n4so6422121vsm.3
        for <linux-wireless@vger.kernel.org>; Mon, 22 Apr 2019 08:21:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Jo4QnBFvCI2pSHJjt+WPg9GxNe4IYci0262Mc3uaeAs=;
        b=HP46O8oItxx97YrVVEwduwNQuCIzdcSk2DQTaaBQwOeSRtttO73+dUOYaPxAf1Ny18
         ETS3YeHtwlYUBEGcWEW/skIgQBGKGC5RsOSYTglryb9V/0nk10CGB5dLbs8OKTNJWlsj
         9J9ZukCuBgs882Ewzbap7mIB0wN7Mbxncq23k=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Jo4QnBFvCI2pSHJjt+WPg9GxNe4IYci0262Mc3uaeAs=;
        b=CMMBVMW4pEGKYq4+NPPHrjtDugop1FDxkKmhm+TBZvFhijZMkiQ/4dYQ4BaNpwbF/7
         7RBBM8pYiyMLfACMdd6+1EILIX4I7x/NfoRzqXVDaKqkR9ZgH4d4IHLRkuxO700LDfGP
         jf4TK5HAE+Ti0QWJFQAR7GlxZaQSdB4P8VSBKVEdOCgQvJFqgFIVq1l3+yeHDGOqX0Y3
         T/S+vmVu+FGaHZA7FAU+4H56zPJrir8z35r0AUOdj8JmRVpOtRn4VeznhswDzsHSNkfw
         CDll2NcByhgFJNkmnXAgYHb3qKYWlaj4Oul9RwcfOH873bwqL+aEaqckgvFsH2bKPuwa
         GIKw==
X-Gm-Message-State: APjAAAWA48uS30iujQ3Ouoe8EvJxpaY0DZo5ywruYWFVvJjqkuFBbg5L
        2Nf2+orJYiKJfatopo5JJqQXyb2annM=
X-Google-Smtp-Source: APXvYqwvwMqx+sD7ho4Mc2v0r9bLwHHW1AtMf5jO5vHIW3ISKSscpGCyOvQWDRt4hb6LbleqksAGdA==
X-Received: by 2002:a67:fe13:: with SMTP id l19mr10635392vsr.143.1555946500875;
        Mon, 22 Apr 2019 08:21:40 -0700 (PDT)
Received: from mail-vs1-f54.google.com (mail-vs1-f54.google.com. [209.85.217.54])
        by smtp.gmail.com with ESMTPSA id m23sm19936634vsl.24.2019.04.22.08.21.39
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Mon, 22 Apr 2019 08:21:39 -0700 (PDT)
Received: by mail-vs1-f54.google.com with SMTP id t78so6435963vsc.1
        for <linux-wireless@vger.kernel.org>; Mon, 22 Apr 2019 08:21:39 -0700 (PDT)
X-Received: by 2002:a67:c812:: with SMTP id u18mr9580850vsk.87.1555946498770;
 Mon, 22 Apr 2019 08:21:38 -0700 (PDT)
MIME-Version: 1.0
References: <20190410221237.160856-1-dianders@chromium.org>
In-Reply-To: <20190410221237.160856-1-dianders@chromium.org>
From:   Doug Anderson <dianders@chromium.org>
Date:   Mon, 22 Apr 2019 08:21:27 -0700
X-Gmail-Original-Message-ID: <CAD=FV=Wm+T+W=LWTSiwBT3UQWG7YKQdGuL2+BmAFQhk8CYY1mQ@mail.gmail.com>
Message-ID: <CAD=FV=Wm+T+W=LWTSiwBT3UQWG7YKQdGuL2+BmAFQhk8CYY1mQ@mail.gmail.com>
Subject: Re: [PATCH] mmc: dw_mmc: Disable SDIO interrupts while suspended to
 fix suspend/resume
To:     Jaehoon Chung <jh80.chung@samsung.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Shawn Lin <shawn.lin@rock-chips.com>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        Brian Norris <briannorris@chromium.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Matthias Kaehlcke <mka@chromium.org>,
        Ryan Case <ryandcase@chromium.org>, stable@vger.kernel.org,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi,

On Wed, Apr 10, 2019 at 3:13 PM Douglas Anderson <dianders@chromium.org> wrote:
>
> Processing SDIO interrupts while dw_mmc is suspended (or partly
> suspended) seems like a bad idea.  We really don't want to be
> processing them until we've gotten ourselves fully powered up.
>
> You might be wondering how it's even possible to become suspended when
> an SDIO interrupt is active.  As can be seen in
> dw_mci_enable_sdio_irq(), we explicitly keep dw_mmc out of runtime
> suspend when the SDIO interrupt is enabled.  ...but even though we
> stop normal runtime suspend transitions when SDIO interrupts are
> enabled, the dw_mci_runtime_suspend() can still get called for a full
> system suspend.
>
> Let's handle all this by explicitly masking SDIO interrupts in the
> suspend call and unmasking them later in the resume call.  To do this
> cleanly I'll keep track of whether the client requested that SDIO
> interrupts be enabled so that we can reliably restore them regardless
> of whether we're masking them for one reason or another.
>
> Without this fix it can be seen that rk3288-veyron Chromebooks with
> Marvell WiFi would sometimes fail to resume WiFi even after picking my
> recent mwifiex patch [1].  Specifically you'd see messages like this:
>   mwifiex_sdio mmc1:0001:1: Firmware wakeup failed
>   mwifiex_sdio mmc1:0001:1: PREP_CMD: FW in reset state
>
> ...and tracing through the resume code in the failing cases showed
> that we were processing a SDIO interrupt really early in the resume
> call.
>
> NOTE: downstream in Chrome OS 3.14 and 3.18 kernels (both of which
> support the Marvell SDIO WiFi card) we had a patch ("CHROMIUM: sdio:
> Defer SDIO interrupt handling until after resume") [2].  Presumably
> this is the same problem that was solved by that patch.
>
> [1] https://lkml.kernel.org/r/20190404040106.40519-1-dianders@chromium.org
> [2] https://crrev.com/c/230765
>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Douglas Anderson <dianders@chromium.org>
> ---
> I didn't put any "Fixes" tag here, but presumably this could be
> backported to whichever kernels folks found it useful for.  I have at
> least confirmed that kernels v4.14 and v4.19 (as well as v5.1-rc2)
> show the problem.  It is very easy to pick this to v4.19 and it
> definitely fixes the problem there.
>
> I haven't spent the time to pick this to 4.14 myself, but presumably
> it wouldn't be too hard to backport this as far as v4.13 since that
> contains commit 32dba73772f8 ("mmc: dw_mmc: Convert to use
> MMC_CAP2_SDIO_IRQ_NOTHREAD for SDIO IRQs").  Prior to that it might
> make sense for anyone experiencing this problem to just pick the old
> CHROMIUM patch to fix them.
>
>  drivers/mmc/host/dw_mmc.c | 24 ++++++++++++++++++++----
>  drivers/mmc/host/dw_mmc.h |  3 +++
>  2 files changed, 23 insertions(+), 4 deletions(-)

Jaehoon / Shawn: any thoughts on this patch?

-Doug
