Return-Path: <SRS0=48GF=S2=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03801C10F03
	for <linux-wireless@archiver.kernel.org>; Wed, 24 Apr 2019 01:09:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B63352148D
	for <linux-wireless@archiver.kernel.org>; Wed, 24 Apr 2019 01:09:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="fr50Z5vg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728867AbfDXBJd (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 23 Apr 2019 21:09:33 -0400
Received: from mail-vk1-f195.google.com ([209.85.221.195]:36676 "EHLO
        mail-vk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726840AbfDXBJd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 23 Apr 2019 21:09:33 -0400
Received: by mail-vk1-f195.google.com with SMTP id w140so3655261vkd.3
        for <linux-wireless@vger.kernel.org>; Tue, 23 Apr 2019 18:09:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2oqPjMyQseedgcBAwrPIUkhy4f51e0TPWLOI4MD8uyk=;
        b=fr50Z5vg/i8u/My7dlGlG6B1BLTT67r8Bme8belsC4m2zyb1aH5hxRMEq4CKaj+7oS
         jpDZjpArU829DDNj/kIYxTe80EE3NspkOMJ2Wr94sBAiIzt8ou6DS2nqmLLFIPyp26cL
         wf/lZP+7japEB/m4DGZvJ66fmX1sEej3KNesI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2oqPjMyQseedgcBAwrPIUkhy4f51e0TPWLOI4MD8uyk=;
        b=TUHIr22iSHN7dy9D4IoFOY5mpFZXpbBeFhGa+W0fLgeLDHGYBnw2k9Ajr0QROP+hus
         3nhaC3LKiKWZTZYV8UJsmjYJnu7KV3GrEEn1tQgPpEXCStX5aueJZ3tSL/UNrbPeCrRQ
         S2QMkvIuAEFgnD0OxGy2HY2bcaZGJACRsGn8pG1bJdPrlxVnfdL+4ulBNfCOFtqh+qNw
         f+B6oQ6eW3OwHHx6Ytm2+FPsSujz5J4SE+3+QjY5uzUFVaDCz5wZ42mCRz36N0FRK4dD
         x05OgyGHtQhZynvrc2kjMHemmXWLq/xdjWGlDTmpM9HRKBTX5eKtBqFJw42+XQJvPhsn
         b08Q==
X-Gm-Message-State: APjAAAU5/mNqTIplOskujY9/6r4TLo3EefZUhlGJJQB11tMjk+U+YRUs
        JchJOt+av2Ggerz5m8xx7OnKfZELrIs=
X-Google-Smtp-Source: APXvYqzahf1wLsVoFes/4Dhp5BafVYe58IPHxjvMQ0AdVc/fBRlC6a/5WG0API59Id2fJPB5Zl6Pmw==
X-Received: by 2002:a1f:30ce:: with SMTP id w197mr15648944vkw.8.1556068172392;
        Tue, 23 Apr 2019 18:09:32 -0700 (PDT)
Received: from mail-vs1-f54.google.com (mail-vs1-f54.google.com. [209.85.217.54])
        by smtp.gmail.com with ESMTPSA id d134sm7565180vkf.6.2019.04.23.18.09.31
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Tue, 23 Apr 2019 18:09:31 -0700 (PDT)
Received: by mail-vs1-f54.google.com with SMTP id o10so9414869vsp.12
        for <linux-wireless@vger.kernel.org>; Tue, 23 Apr 2019 18:09:31 -0700 (PDT)
X-Received: by 2002:a67:e258:: with SMTP id w24mr15056333vse.20.1556068170633;
 Tue, 23 Apr 2019 18:09:30 -0700 (PDT)
MIME-Version: 1.0
References: <20190410221237.160856-1-dianders@chromium.org>
 <CAD=FV=Wm+T+W=LWTSiwBT3UQWG7YKQdGuL2+BmAFQhk8CYY1mQ@mail.gmail.com> <6e5c9395-51b0-7f28-ec91-de95cb54f58d@rock-chips.com>
In-Reply-To: <6e5c9395-51b0-7f28-ec91-de95cb54f58d@rock-chips.com>
From:   Doug Anderson <dianders@chromium.org>
Date:   Tue, 23 Apr 2019 18:09:19 -0700
X-Gmail-Original-Message-ID: <CAD=FV=XuCrymazJDKBYqLezkYkikzGNiv6X0FdzNG0SaR8PuRw@mail.gmail.com>
Message-ID: <CAD=FV=XuCrymazJDKBYqLezkYkikzGNiv6X0FdzNG0SaR8PuRw@mail.gmail.com>
Subject: Re: [PATCH] mmc: dw_mmc: Disable SDIO interrupts while suspended to
 fix suspend/resume
To:     Shawn Lin <shawn.lin@rock-chips.com>
Cc:     Jaehoon Chung <jh80.chung@samsung.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Kalle Valo <kvalo@codeaurora.org>,
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

On Tue, Apr 23, 2019 at 5:57 PM Shawn Lin <shawn.lin@rock-chips.com> wrote:
>
> The intention seems reasonable to me, but just wonder if we need
> mask/unmask SDIO interrupt when it's never used?

I don't think we do.

Specifically "client_sdio_enb" starts out as false.  If nobody ever
calls dw_mci_enable_sdio_irq() then "client_sdio_enb" will always
continue to be false.

Now at suspend time we'll call "__dw_mci_enable_sdio_irq".  Because
"client_sdio_enb" is false then the local variable "enb" will always
be false.  Sure we'll clear the "SDMMC_INT_SDIO" from the "INTMASK"
register, but it should already have been cleared so this is a no-op.

...at resume time we'll have a similar situation where
"client_sdio_enb" is false and thus we'll (again) just clear the
"SDMMC_INT_SDIO" from the "INTMASK".

I could potentially optimize away the "mci_writel()" if we're not
changing anything if you're worried about that?


> It's the same
> situation for SDMMC_CLKEN_LOW_PWR that we couldn't stop providing
> clock for SDIO cards, so I guess we need to check MMC_CAP_SDIO_IRQ
> as well.

I think it might be a slightly different situation though.  In this
case I believe it's not just a problem with clock stoppage.  I believe
the problem is that the interrupt will be passed to the SDIO device
driver right away and that'll call back into dw_mmc.  dw_mmc is just
not in a state to handle it until we've more fully resumed things.

In any case with my patch the only way we'd ever end up unmasking the
SDIO IRQ here would be if dw_mci_enable_sdio_irq() was called.  That
will only happen if there's an SDIO card plugged in.


-Doug
