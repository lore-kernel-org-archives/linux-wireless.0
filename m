Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from store.laptop.org ([18.85.44.157]:35259 "EHLO swan.laptop.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751005AbdJSFfe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 19 Oct 2017 01:35:34 -0400
Date: Thu, 19 Oct 2017 16:35:24 +1100
From: James Cameron <quozl@laptop.org>
To: Joe Perches <joe@perches.com>
Cc: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] bcma: Use bcma_debug and not pr_cont in MIPS driver
Message-ID: <20171019053524.GH641@us.netrek.org> (sfid-20171019_073537_766301_E4D1C90D)
References: <12998e0384c614c633148ea4dee48b95822d6425.1508389862.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <12998e0384c614c633148ea4dee48b95822d6425.1508389862.git.joe@perches.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 18, 2017 at 10:12:18PM -0700, Joe Perches wrote:
> Commit 66cc04424960 ("bcma: use bcma_debug and pr_cont in MIPS driver")
> converted a printk(KERN_DEBUG to bcma_debug.
> 
> bcma_debug is guarded by a #define DEBUG via pr_debug.
> 
> This means that the bcma_debug will generally not be emitted
> but any pr_cont following the bcma_debug will be emitted.
> 
> Correct this by removing the uses of pr_cont by using a temporary.
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  drivers/bcma/driver_mips.c | 11 +++++++----
>  1 file changed, 7 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/bcma/driver_mips.c b/drivers/bcma/driver_mips.c
> index 5904ef1aa624..a929956150eb 100644
> --- a/drivers/bcma/driver_mips.c
> +++ b/drivers/bcma/driver_mips.c
> @@ -184,11 +184,14 @@ static void bcma_core_mips_print_irq(struct bcma_device *dev, unsigned int irq)
>  {
>  	int i;
>  	static const char *irq_name[] = {"2(S)", "3", "4", "5", "6", "D", "I"};
> +        char interrupts[20];
> +        char *ints = interrupts;

Tabs were changed to spaces.

>  
> -	bcma_debug(dev->bus, "core 0x%04x, irq :", dev->id.id);
> -	for (i = 0; i <= 6; i++)
> -		pr_cont(" %s%s", irq_name[i], i == irq ? "*" : " ");
> -	pr_cont("\n");
> +        for (i = 0; i < ARRAY_SIZE(irq_name); i++)
> +                ints += sprintf(ints, " %s%c",
> +				irq_name[i], i == irq ? '*' : ' ');

But not on this line.

> +
> +        bcma_debug(dev->bus, "core 0x%04x, irq:%s\n", dev->id.id, interrupts);
>  }
>  
>  static void bcma_core_mips_dump_irq(struct bcma_bus *bus)
> -- 
> 2.10.0.rc2.1.g053435c
> 

-- 
James Cameron
http://quozl.netrek.org/
