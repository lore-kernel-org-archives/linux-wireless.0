Return-Path: <SRS0=48GF=S2=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E74D2C10F11
	for <linux-wireless@archiver.kernel.org>; Wed, 24 Apr 2019 08:19:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A3FFF208E4
	for <linux-wireless@archiver.kernel.org>; Wed, 24 Apr 2019 08:19:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Y8GpLlfe"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727664AbfDXITT (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 24 Apr 2019 04:19:19 -0400
Received: from mail-it1-f196.google.com ([209.85.166.196]:33894 "EHLO
        mail-it1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726232AbfDXITT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 24 Apr 2019 04:19:19 -0400
Received: by mail-it1-f196.google.com with SMTP id z17so4081426itc.1;
        Wed, 24 Apr 2019 01:19:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZjKhUZ7gEWOzQQFEWpw5e1wcmuD64iwsgugMOYWU/u0=;
        b=Y8GpLlfe0orvSOtGAw3uLcr9Mb1Vh7C+RsSbCQhr8B0i2EXEKmEsxCDkmea3R2QM/i
         jWyA+1aj+cBv5rPZObfsARZhWLn+HxIDQv8DCpcgkyX12Nk45YCDVmF6uEcAf/VBN1ym
         umJR9bS1cwFw4MeRPpxEvfoSxKRsaW8o1ZIms+WrQ0ZjTrbZOiXt7SBp3gwVvCO1F9W+
         YfIbnfpC4J/VSkWdjdPXjPWeVF7r4KgrO55e+oi+8YL41HMk186+AvIb8EuyxEclIvYq
         b7D5qVnCftuc2rUvDzEfkwq0A5YQssKUMQqzwUdJDpBfeiJYSSGDP791zeqX8TuXcHFY
         WteQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZjKhUZ7gEWOzQQFEWpw5e1wcmuD64iwsgugMOYWU/u0=;
        b=pNgcu9E823sRQRLN5s1Yz+LDvT2dpXWf8QU00t+VgjOjccc1xjFRPPYBbvbIL1srMb
         YJA+uMZOPc3n9JLXXwkgjTjfsn6+U/Gglc4VXFPwnRRYcPZWbQ7CWkyC0BYiXtW76q4a
         d9tzJHTl6cxt/bCsihR6Wr43erSehyGTHcZhbausqTc3mShnCEMcCrTKtvyYH8OHsLby
         XVbk8wyntGln0bc/5ETO5Rh2GuuyFHwFj8K/jFtYJIXIRMwwB/v7GDNd8EwqXvm8Dtzo
         ynfco4ipkt+lUUbqNHPZQREsvZOtyf+R/X2xDwcu8SPzdKtPnhHD+jWb6RlheVdbpaXG
         iN8A==
X-Gm-Message-State: APjAAAXWC4TpAHVUhBROeDkcMvd095jVs1hQbn7ojVnNHPwgsQ6Wjfqr
        TeRM9PkN8t2qwW+dke8eBy98PqXmQk0QVEP11fs=
X-Google-Smtp-Source: APXvYqyKUApUYZGrz+1lnuMMo9leSsB/++FlSl+qeVogMFLyT7RXmccFbDZvs6xSpUiZdzzeQG+hyv3FeaBtahw8OvE=
X-Received: by 2002:a24:59c1:: with SMTP id p184mr6167489itb.158.1556093957836;
 Wed, 24 Apr 2019 01:19:17 -0700 (PDT)
MIME-Version: 1.0
References: <20190410221237.160856-1-dianders@chromium.org>
In-Reply-To: <20190410221237.160856-1-dianders@chromium.org>
From:   Emil Renner Berthing <emil.renner.berthing@gmail.com>
Date:   Wed, 24 Apr 2019 10:19:06 +0200
Message-ID: <CANBLGcwmNowj9GSmE3bbo1t1o6EF8q-RiJftfdOQnJB9_8aSKg@mail.gmail.com>
Subject: Re: [PATCH] mmc: dw_mmc: Disable SDIO interrupts while suspended to
 fix suspend/resume
To:     Douglas Anderson <dianders@chromium.org>
Cc:     Jaehoon Chung <jh80.chung@samsung.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Shawn Lin <shawn.lin@rock-chips.com>,
        Heiko Stuebner <heiko@sntech.de>, linux-mmc@vger.kernel.org,
        Brian Norris <briannorris@chromium.org>,
        linux-wireless@vger.kernel.org, stable@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        Matthias Kaehlcke <mka@chromium.org>, ryandcase@chromium.org,
        Kalle Valo <kvalo@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi Douglas,

Unfortunately this seems to beak resume on my rk3399-gru-kevin. I have
a semi-complicated setup with my rootfs as a btrfs on dmcrypt on
mmcblk0 which is the dw_mmc, so I'm guessing something goes wrong when
waking up the dm_mmc which probably wasn't suspended before this
patch. It's not 100% consistent though. Sometimes I see it resume the
first time I try suspending, but then 2nd time I suspend it won't come
back.

Let me know if I can do something to help debug this.

/Emil


On Thu, 11 Apr 2019 at 00:13, Douglas Anderson <dianders@chromium.org> wrote:
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
>
> diff --git a/drivers/mmc/host/dw_mmc.c b/drivers/mmc/host/dw_mmc.c
> index 80dc2fd6576c..432f6e3ddd43 100644
> --- a/drivers/mmc/host/dw_mmc.c
> +++ b/drivers/mmc/host/dw_mmc.c
> @@ -1664,7 +1664,8 @@ static void dw_mci_init_card(struct mmc_host *mmc, struct mmc_card *card)
>         }
>  }
>
> -static void __dw_mci_enable_sdio_irq(struct dw_mci_slot *slot, int enb)
> +static void __dw_mci_enable_sdio_irq(struct dw_mci_slot *slot, bool enb,
> +                                    bool client_requested)
>  {
>         struct dw_mci *host = slot->host;
>         unsigned long irqflags;
> @@ -1672,6 +1673,17 @@ static void __dw_mci_enable_sdio_irq(struct dw_mci_slot *slot, int enb)
>
>         spin_lock_irqsave(&host->irq_lock, irqflags);
>
> +       /*
> +        * If this was requested by the client save the request.  If this
> +        * wasn't required by the client then logically AND it with the
> +        * client request since we want to disable if either the client
> +        * disabled OR we have some other reason to disable.
> +        */
> +       if (client_requested)
> +               host->client_sdio_enb = enb;
> +       else if (!host->client_sdio_enb)
> +               enb = 0;
> +
>         /* Enable/disable Slot Specific SDIO interrupt */
>         int_mask = mci_readl(host, INTMASK);
>         if (enb)
> @@ -1688,7 +1700,7 @@ static void dw_mci_enable_sdio_irq(struct mmc_host *mmc, int enb)
>         struct dw_mci_slot *slot = mmc_priv(mmc);
>         struct dw_mci *host = slot->host;
>
> -       __dw_mci_enable_sdio_irq(slot, enb);
> +       __dw_mci_enable_sdio_irq(slot, enb, true);
>
>         /* Avoid runtime suspending the device when SDIO IRQ is enabled */
>         if (enb)
> @@ -1701,7 +1713,7 @@ static void dw_mci_ack_sdio_irq(struct mmc_host *mmc)
>  {
>         struct dw_mci_slot *slot = mmc_priv(mmc);
>
> -       __dw_mci_enable_sdio_irq(slot, 1);
> +       __dw_mci_enable_sdio_irq(slot, true, false);
>  }
>
>  static int dw_mci_execute_tuning(struct mmc_host *mmc, u32 opcode)
> @@ -2734,7 +2746,7 @@ static irqreturn_t dw_mci_interrupt(int irq, void *dev_id)
>                 if (pending & SDMMC_INT_SDIO(slot->sdio_id)) {
>                         mci_writel(host, RINTSTS,
>                                    SDMMC_INT_SDIO(slot->sdio_id));
> -                       __dw_mci_enable_sdio_irq(slot, 0);
> +                       __dw_mci_enable_sdio_irq(slot, false, false);
>                         sdio_signal_irq(slot->mmc);
>                 }
>
> @@ -3424,6 +3436,8 @@ int dw_mci_runtime_suspend(struct device *dev)
>  {
>         struct dw_mci *host = dev_get_drvdata(dev);
>
> +       __dw_mci_enable_sdio_irq(host->slot, false, false);
> +
>         if (host->use_dma && host->dma_ops->exit)
>                 host->dma_ops->exit(host);
>
> @@ -3490,6 +3504,8 @@ int dw_mci_runtime_resume(struct device *dev)
>         /* Now that slots are all setup, we can enable card detect */
>         dw_mci_enable_cd(host);
>
> +       __dw_mci_enable_sdio_irq(host->slot, true, false);
> +
>         return 0;
>
>  err:
> diff --git a/drivers/mmc/host/dw_mmc.h b/drivers/mmc/host/dw_mmc.h
> index 46e9f8ec5398..dfbace0f5043 100644
> --- a/drivers/mmc/host/dw_mmc.h
> +++ b/drivers/mmc/host/dw_mmc.h
> @@ -127,6 +127,7 @@ struct dw_mci_dma_slave {
>   * @cmd11_timer: Timer for SD3.0 voltage switch over scheme.
>   * @cto_timer: Timer for broken command transfer over scheme.
>   * @dto_timer: Timer for broken data transfer over scheme.
> + * @client_sdio_enb: The value last passed to enable_sdio_irq.
>   *
>   * Locking
>   * =======
> @@ -234,6 +235,8 @@ struct dw_mci {
>         struct timer_list       cmd11_timer;
>         struct timer_list       cto_timer;
>         struct timer_list       dto_timer;
> +
> +       bool                    client_sdio_enb;
>  };
>
>  /* DMA ops for Internal/External DMAC interface */
> --
> 2.21.0.392.gf8f6787159e-goog
>
>
> _______________________________________________
> Linux-rockchip mailing list
> Linux-rockchip@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-rockchip
