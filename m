Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f170.google.com ([209.85.216.170]:35755 "EHLO
        mail-qt0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751067AbdAMFYS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 13 Jan 2017 00:24:18 -0500
Received: by mail-qt0-f170.google.com with SMTP id x49so38444610qtc.2
        for <linux-wireless@vger.kernel.org>; Thu, 12 Jan 2017 21:24:17 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20170113052218.10534-3-matt@ranostay.consulting>
References: <20170113052218.10534-1-matt@ranostay.consulting> <20170113052218.10534-3-matt@ranostay.consulting>
From: Matt Ranostay <matt@ranostay.consulting>
Date: Thu, 12 Jan 2017 21:24:16 -0800
Message-ID: <CAJ_EiSR=1ZyRvc95ZTtFgMccpzXF0v=J2qYSFP5GWYSGePFs2g@mail.gmail.com> (sfid-20170113_062421_813474_C883E9D6)
Subject: Re: [PATCH v2 2/2] mmc: pwrseq: add support for Marvell SD8787 chip
To: linux-wireless@vger.kernel.org,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-mmc@vger.kernel.org, devicetree@vger.kernel.org
Cc: Tony Lindgren <tony@atomide.com>,
        Matt Ranostay <matt@ranostay.consulting>,
        Ulf Hansson <ulf.hansson@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jan 12, 2017 at 9:22 PM, Matt Ranostay <matt@ranostay.consulting> wrote:
> Allow power sequencing for the Marvell SD8787 Wifi/BT chip.
> This can be abstracted to other chipsets if needed in the future.


Er crap seems how the main patch file got dropped out. Resubmitting in
a minute... sorry!

>
> Cc: Tony Lindgren <tony@atomide.com>
> Cc: Ulf Hansson <ulf.hansson@linaro.org>
> Signed-off-by: Matt Ranostay <matt@ranostay.consulting>
> ---
>  drivers/mmc/core/Kconfig  | 10 ++++++++++
>  drivers/mmc/core/Makefile |  1 +
>  2 files changed, 11 insertions(+)
>
> diff --git a/drivers/mmc/core/Kconfig b/drivers/mmc/core/Kconfig
> index cdfa8520a4b1..fc1ecdaaa9ca 100644
> --- a/drivers/mmc/core/Kconfig
> +++ b/drivers/mmc/core/Kconfig
> @@ -12,6 +12,16 @@ config PWRSEQ_EMMC
>           This driver can also be built as a module. If so, the module
>           will be called pwrseq_emmc.
>
> +config PWRSEQ_SD8787
> +       tristate "HW reset support for SD8787 BT + Wifi module"
> +       depends on OF && (MWIFIEX || BT_MRVL_SDIO)
> +       help
> +         This selects hardware reset support for the SD8787 BT + Wifi
> +         module. By default this option is set to n.
> +
> +         This driver can also be built as a module. If so, the module
> +         will be called pwrseq_sd8787.
> +
>  config PWRSEQ_SIMPLE
>         tristate "Simple HW reset support for MMC"
>         default y
> diff --git a/drivers/mmc/core/Makefile b/drivers/mmc/core/Makefile
> index b2a257dc644f..0f81464fa824 100644
> --- a/drivers/mmc/core/Makefile
> +++ b/drivers/mmc/core/Makefile
> @@ -10,6 +10,7 @@ mmc_core-y                    := core.o bus.o host.o \
>                                    quirks.o slot-gpio.o
>  mmc_core-$(CONFIG_OF)          += pwrseq.o
>  obj-$(CONFIG_PWRSEQ_SIMPLE)    += pwrseq_simple.o
> +obj-$(CONFIG_PWRSEQ_SD8787)    += pwrseq_sd8787.o
>  obj-$(CONFIG_PWRSEQ_EMMC)      += pwrseq_emmc.o
>  mmc_core-$(CONFIG_DEBUG_FS)    += debugfs.o
>  obj-$(CONFIG_MMC_BLOCK)                += mmc_block.o
> --
> 2.10.2
>
