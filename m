Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.mailbox.org ([80.241.60.212]:46840 "EHLO mx1.mailbox.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752867AbdJPVVw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 16 Oct 2017 17:21:52 -0400
Subject: Re: [PATCH] bcma: use bcma_debug and pr_cont in MIPS driver
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org
Cc: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
References: <20171016125432.11655-1-zajec5@gmail.com>
From: Hauke Mehrtens <hauke@hauke-m.de>
Message-ID: <50b62ff7-40c2-6980-27f8-4776b059800c@hauke-m.de> (sfid-20171016_232157_052957_9D1E95E1)
Date: Mon, 16 Oct 2017 23:21:47 +0200
MIME-Version: 1.0
In-Reply-To: <20171016125432.11655-1-zajec5@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/16/2017 02:54 PM, Rafał Miłecki wrote:
> From: Rafał Miłecki <rafal@milecki.pl>
> 
> Using bcma_debug gives a device-specific prefix for messages and pr_cont
> is a common helper for continuing a line.
> 
> Signed-off-by: Rafał Miłecki <rafal@milecki.pl>

Acked-By: Hauke Mehrtens <hauke@hauke-m.de>

> ---
>  drivers/bcma/driver_mips.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/bcma/driver_mips.c b/drivers/bcma/driver_mips.c
> index 89af807cf29c..5904ef1aa624 100644
> --- a/drivers/bcma/driver_mips.c
> +++ b/drivers/bcma/driver_mips.c
> @@ -184,10 +184,11 @@ static void bcma_core_mips_print_irq(struct bcma_device *dev, unsigned int irq)
>  {
>  	int i;
>  	static const char *irq_name[] = {"2(S)", "3", "4", "5", "6", "D", "I"};
> -	printk(KERN_DEBUG KBUILD_MODNAME ": core 0x%04x, irq :", dev->id.id);
> +
> +	bcma_debug(dev->bus, "core 0x%04x, irq :", dev->id.id);
>  	for (i = 0; i <= 6; i++)
> -		printk(" %s%s", irq_name[i], i == irq ? "*" : " ");
> -	printk("\n");
> +		pr_cont(" %s%s", irq_name[i], i == irq ? "*" : " ");
> +	pr_cont("\n");
>  }
>  
>  static void bcma_core_mips_dump_irq(struct bcma_bus *bus)
> 
