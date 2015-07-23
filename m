Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:34848 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752589AbbGWAam convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jul 2015 20:30:42 -0400
Received: by iecri3 with SMTP id ri3so85379821iec.2
        for <linux-wireless@vger.kernel.org>; Wed, 22 Jul 2015 17:30:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1435504633-20831-1-git-send-email-zajec5@gmail.com>
References: <1435504633-20831-1-git-send-email-zajec5@gmail.com>
Date: Thu, 23 Jul 2015 02:30:41 +0200
Message-ID: <CACna6rzFYpwbzM+s-KzFQmTym4iLVn+Ap+DWgFmAZzhWKTQfJw@mail.gmail.com> (sfid-20150723_023045_693768_E56FE52B)
Subject: Re: [PATCH] bcma: populate bus DT subnodes as platform_device-s
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Cc: Hauke Mehrtens <hauke@hauke-m.de>, Arnd Bergmann <arnd@arndb.de>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	=?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 28 June 2015 at 17:17, Rafał Miłecki <zajec5@gmail.com> wrote:
> Our bus should allow defining children nodes as we may want to specify
> devices attached to the bus. This is required e.g. to specify NAND or
> ChipCommon cores and use bus's address and IRQ mappings.
>
> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
> ---
>  drivers/bcma/main.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
>
> diff --git a/drivers/bcma/main.c b/drivers/bcma/main.c
> index 9635f10..5912847 100644
> --- a/drivers/bcma/main.c
> +++ b/drivers/bcma/main.c
> @@ -12,6 +12,7 @@
>  #include <linux/slab.h>
>  #include <linux/of_address.h>
>  #include <linux/of_irq.h>
> +#include <linux/of_platform.h>
>
>  MODULE_DESCRIPTION("Broadcom's specific AMBA driver");
>  MODULE_LICENSE("GPL");
> @@ -409,6 +410,13 @@ int bcma_bus_register(struct bcma_bus *bus)
>                 bcma_core_pci_early_init(&bus->drv_pci[0]);
>         }
>
> +       if (bus->host_pdev) {
> +               struct device *dev = &bus->host_pdev->dev;
> +
> +               of_platform_populate(dev->of_node, of_default_bus_match_table,
> +                                    NULL, dev);
> +       }
> +

This caused a compile error when using bcma as module:
ERROR: "of_default_bus_match_table" [drivers/bcma/bcma.ko] undefined!

There are two options I guess:
1) Export of_default_bus_match_table
2) Use some better condition like
if (IS_BUILTIN(CONFIG_BCMA) && bus->host_pdev)

Unfortunately I'm on my long holidays right now.

Hauke: do you think you can find a moment to handle this?

Sorry for the problem :|

-- 
Rafał
