Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hauke-m.de ([5.39.93.123]:39011 "EHLO hauke-m.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751327AbbHBSDr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Aug 2015 14:03:47 -0400
Message-ID: <55BE5B82.7060301@hauke-m.de> (sfid-20150802_200406_256898_872256D7)
Date: Sun, 02 Aug 2015 20:03:46 +0200
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	linux-wireless@vger.kernel.org
CC: Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] bcma: populate bus DT subnodes as platform_device-s
References: <1435504633-20831-1-git-send-email-zajec5@gmail.com>
In-Reply-To: <1435504633-20831-1-git-send-email-zajec5@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/28/2015 05:17 PM, Rafał Miłecki wrote:
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
>  		bcma_core_pci_early_init(&bus->drv_pci[0]);
>  	}
>  
> +	if (bus->host_pdev) {

Here is an other problem. So many bugs in this line. ;-)
host_pdev is in a union so this is also true for PCIe devices, but then
the offset of the dev structure probably is wrong. You should check for
the hosttype. I will send a patch.

> +		struct device *dev = &bus->host_pdev->dev;
> +
> +		of_platform_populate(dev->of_node, of_default_bus_match_table,
> +				     NULL, dev);
> +	}
> +
>  	/* Cores providing flash access go before SPROM init */
>  	list_for_each_entry(core, &bus->cores, list) {
>  		if (bcma_is_core_needed_early(core->id.id))
> 

