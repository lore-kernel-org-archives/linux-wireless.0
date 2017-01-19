Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f44.google.com ([74.125.82.44]:36583 "EHLO
        mail-wm0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752762AbdASOWK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 19 Jan 2017 09:22:10 -0500
Received: by mail-wm0-f44.google.com with SMTP id c85so290630509wmi.1
        for <linux-wireless@vger.kernel.org>; Thu, 19 Jan 2017 06:21:15 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20170113052937.12538-3-matt@ranostay.consulting>
References: <20170113052937.12538-1-matt@ranostay.consulting> <20170113052937.12538-3-matt@ranostay.consulting>
From: Ulf Hansson <ulf.hansson@linaro.org>
Date: Thu, 19 Jan 2017 15:13:12 +0100
Message-ID: <CAPDyKFpcKuybQmhqCkaAkOM5d+ubU8O8=adLm+PXwc=+N87vng@mail.gmail.com> (sfid-20170119_152256_701871_081763AA)
Subject: Re: [PATCH v3 2/2] mmc: pwrseq: add support for Marvell SD8787 chip
To: Matt Ranostay <matt@ranostay.consulting>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>,
        Shawn Lin <shawn.lin@rock-chips.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

+Shawn

On 13 January 2017 at 06:29, Matt Ranostay <matt@ranostay.consulting> wrote:
> Allow power sequencing for the Marvell SD8787 Wifi/BT chip.
> This can be abstracted to other chipsets if needed in the future.
>
> Cc: Tony Lindgren <tony@atomide.com>
> Cc: Ulf Hansson <ulf.hansson@linaro.org>
> Signed-off-by: Matt Ranostay <matt@ranostay.consulting>
> ---
>  drivers/mmc/core/Kconfig         |  10 ++++
>  drivers/mmc/core/Makefile        |   1 +
>  drivers/mmc/core/pwrseq_sd8787.c | 117 +++++++++++++++++++++++++++++++++++++++
>  3 files changed, 128 insertions(+)
>  create mode 100644 drivers/mmc/core/pwrseq_sd8787.c
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
> diff --git a/drivers/mmc/core/pwrseq_sd8787.c b/drivers/mmc/core/pwrseq_sd8787.c
> new file mode 100644
> index 000000000000..f4080fe6439e
> --- /dev/null
> +++ b/drivers/mmc/core/pwrseq_sd8787.c
> @@ -0,0 +1,117 @@
> +/*
> + * pwrseq_sd8787.c - power sequence support for Marvell SD8787 BT + Wifi chip
> + *
> + * Copyright (C) 2016 Matt Ranostay <matt@ranostay.consulting>
> + *
> + * Based on the original work pwrseq_simple.c
> + *  Copyright (C) 2014 Linaro Ltd
> + *  Author: Ulf Hansson <ulf.hansson@linaro.org>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
> + * GNU General Public License for more details.
> + *
> + */
> +
> +#include <linux/delay.h>
> +#include <linux/init.h>
> +#include <linux/kernel.h>
> +#include <linux/platform_device.h>
> +#include <linux/module.h>
> +#include <linux/slab.h>
> +#include <linux/device.h>
> +#include <linux/err.h>
> +#include <linux/gpio/consumer.h>
> +
> +#include <linux/mmc/host.h>
> +
> +#include "pwrseq.h"
> +
> +struct mmc_pwrseq_sd8787 {
> +       struct mmc_pwrseq pwrseq;
> +       struct gpio_desc *reset_gpio;
> +       struct gpio_desc *pwrdn_gpio;
> +};
> +
> +#define to_pwrseq_sd8787(p) container_of(p, struct mmc_pwrseq_sd8787, pwrseq)
> +
> +static void mmc_pwrseq_sd8787_pre_power_on(struct mmc_host *host)
> +{
> +       struct mmc_pwrseq_sd8787 *pwrseq = to_pwrseq_sd8787(host->pwrseq);
> +
> +       gpiod_set_value_cansleep(pwrseq->reset_gpio, 1);
> +
> +       msleep(300);
> +       gpiod_set_value_cansleep(pwrseq->pwrdn_gpio, 1);
> +}
> +
> +static void mmc_pwrseq_sd8787_power_off(struct mmc_host *host)
> +{
> +       struct mmc_pwrseq_sd8787 *pwrseq = to_pwrseq_sd8787(host->pwrseq);
> +
> +       gpiod_set_value_cansleep(pwrseq->pwrdn_gpio, 0);
> +       gpiod_set_value_cansleep(pwrseq->reset_gpio, 0);
> +}
> +
> +static const struct mmc_pwrseq_ops mmc_pwrseq_sd8787_ops = {
> +       .pre_power_on = mmc_pwrseq_sd8787_pre_power_on,
> +       .power_off = mmc_pwrseq_sd8787_power_off,
> +};
> +
> +static const struct of_device_id mmc_pwrseq_sd8787_of_match[] = {
> +       { .compatible = "mmc-pwrseq-sd8787",},
> +       {/* sentinel */},
> +};
> +MODULE_DEVICE_TABLE(of, mmc_pwrseq_sd8787_of_match);
> +
> +static int mmc_pwrseq_sd8787_probe(struct platform_device *pdev)
> +{
> +       struct mmc_pwrseq_sd8787 *pwrseq;
> +       struct device *dev = &pdev->dev;
> +
> +       pwrseq = devm_kzalloc(dev, sizeof(*pwrseq), GFP_KERNEL);
> +       if (!pwrseq)
> +               return -ENOMEM;
> +
> +       pwrseq->pwrdn_gpio = devm_gpiod_get(dev, "pwrdn", GPIOD_OUT_LOW);
> +       if (IS_ERR(pwrseq->pwrdn_gpio))
> +               return PTR_ERR(pwrseq->pwrdn_gpio);
> +
> +       pwrseq->reset_gpio = devm_gpiod_get(dev, "reset", GPIOD_OUT_LOW);
> +       if (IS_ERR(pwrseq->reset_gpio))
> +               return PTR_ERR(pwrseq->reset_gpio);
> +
> +       pwrseq->pwrseq.dev = dev;
> +       pwrseq->pwrseq.ops = &mmc_pwrseq_sd8787_ops;
> +       pwrseq->pwrseq.owner = THIS_MODULE;
> +       platform_set_drvdata(pdev, pwrseq);
> +
> +       return mmc_pwrseq_register(&pwrseq->pwrseq);
> +}
> +
> +static int mmc_pwrseq_sd8787_remove(struct platform_device *pdev)
> +{
> +       struct mmc_pwrseq_sd8787 *pwrseq = platform_get_drvdata(pdev);
> +
> +       mmc_pwrseq_unregister(&pwrseq->pwrseq);
> +
> +       return 0;
> +}
> +
> +static struct platform_driver mmc_pwrseq_sd8787_driver = {
> +       .probe = mmc_pwrseq_sd8787_probe,
> +       .remove = mmc_pwrseq_sd8787_remove,
> +       .driver = {
> +               .name = "pwrseq_sd8787",
> +               .of_match_table = mmc_pwrseq_sd8787_of_match,
> +       },
> +};
> +
> +module_platform_driver(mmc_pwrseq_sd8787_driver);
> +MODULE_LICENSE("GPL v2");
> --
> 2.10.2
>

Twisting my head around how this could be integrated smoothly into
pwrseq simple. No, I just can find a good way forward without messing
up pwrseq simple itself.

So, for now I decided (once more :-), that let's keep this as separate driver!

Perhaps, following device specific mmc pwrseq drivers will needs
something similar, but in such case we can look into that then.
Thinking about cw1200 for example.

Let's get Rob's ack for the DT bindings, seems almost there, then I
will queue this.

Kind regards
Uffe
