Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:40986 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752450Ab2LJQEr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Dec 2012 11:04:47 -0500
Message-ID: <50C6080C.8040104@hauke-m.de> (sfid-20121210_170453_801092_1E031742)
Date: Mon, 10 Dec 2012 17:04:28 +0100
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>, stable@vger.kernel.org
Subject: Re: [PATCH] bcma: mips: fix clearing device IRQ
References: <1355122436-32196-1-git-send-email-zajec5@gmail.com>
In-Reply-To: <1355122436-32196-1-git-send-email-zajec5@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/10/2012 07:53 AM, Rafał Miłecki wrote:
> We were using wrong IRQ number so clearing wasn't working at all.
> Depending on a platform this could result in a one device having two
> interrupts assigned. On BCM4706 this resulted in all IRQs being broken.
> 
> Cc: Hauke Mehrtens <hauke@hauke-m.de>
> Cc: stable@vger.kernel.org
> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>

Acked-by: Hauke Mehrtens <hauke@hauke-m.de>

> ---
> John: I guess it's too late for 3.7 fixes, so I just hope it'll hit
>       3.7.x (and olders) via stable.
> ---
>  drivers/bcma/driver_mips.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/bcma/driver_mips.c b/drivers/bcma/driver_mips.c
> index c45ded8..792daad 100644
> --- a/drivers/bcma/driver_mips.c
> +++ b/drivers/bcma/driver_mips.c
> @@ -115,7 +115,7 @@ static void bcma_core_mips_set_irq(struct bcma_device *dev, unsigned int irq)
>  			    bcma_read32(mdev, BCMA_MIPS_MIPS74K_INTMASK(0)) &
>  			    ~(1 << irqflag));
>  	else
> -		bcma_write32(mdev, BCMA_MIPS_MIPS74K_INTMASK(irq), 0);
> +		bcma_write32(mdev, BCMA_MIPS_MIPS74K_INTMASK(oldirq), 0);
>  
>  	/* assign the new one */
>  	if (irq == 0) {
> 

