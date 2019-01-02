Return-Path: <SRS0=/oVT=PK=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D211BC43387
	for <linux-wireless@archiver.kernel.org>; Wed,  2 Jan 2019 15:50:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A247D2171F
	for <linux-wireless@archiver.kernel.org>; Wed,  2 Jan 2019 15:50:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730080AbfABPuK (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 2 Jan 2019 10:50:10 -0500
Received: from mx1.mailbox.org ([80.241.60.212]:25726 "EHLO mx1.mailbox.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727038AbfABPuK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 2 Jan 2019 10:50:10 -0500
Received: from smtp1.mailbox.org (smtp1.mailbox.org [80.241.60.240])
        (using TLSv1.2 with cipher ECDHE-RSA-CHACHA20-POLY1305 (256/256 bits))
        (No client certificate requested)
        by mx1.mailbox.org (Postfix) with ESMTPS id F12484C99C;
        Wed,  2 Jan 2019 16:50:06 +0100 (CET)
X-Virus-Scanned: amavisd-new at heinlein-support.de
Received: from smtp1.mailbox.org ([80.241.60.240])
        by spamfilter03.heinlein-hosting.de (spamfilter03.heinlein-hosting.de [80.241.56.117]) (amavisd-new, port 10030)
        with ESMTP id 1q_dZWsbFwhf; Wed,  2 Jan 2019 16:50:05 +0100 (CET)
Subject: Re: [PATCH mips-fixes] MIPS: BCM47XX: Setup struct device for the SoC
To:     =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Paul Burton <paul.burton@mips.com>
Cc:     Ralf Baechle <ralf@linux-mips.org>,
        James Hogan <jhogan@kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
References: <20190102125147.3282-1-zajec5@gmail.com>
From:   Hauke Mehrtens <hauke@hauke-m.de>
Message-ID: <c09303d8-a74b-a472-485e-2b4ed7f97acf@hauke-m.de>
Date:   Wed, 2 Jan 2019 16:50:03 +0100
MIME-Version: 1.0
In-Reply-To: <20190102125147.3282-1-zajec5@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 1/2/19 1:51 PM, Rafał Miłecki wrote:
> From: Rafał Miłecki <rafal@milecki.pl>
> 
> So far we never had any device registered for the SoC. This resulted in
> some small issues that we kept ignoring like:
> 1) Not working GPIOLIB_IRQCHIP (gpiochip_irqchip_add_key() failing)
> 2) Lack of proper tree in the /sys/devices/
> 3) mips_dma_alloc_coherent() silently handling empty coherent_dma_mask
> 
> Kernel 4.19 came with a lot of DMA changes and caused a regression on
> bcm47xx. Starting with the commit f8c55dc6e828 ("MIPS: use generic dma
> noncoherent ops for simple noncoherent platforms") DMA coherent
> allocations just fail. Example:
> [    1.114914] bgmac_bcma bcma0:2: Allocation of TX ring 0x200 failed
> [    1.121215] bgmac_bcma bcma0:2: Unable to alloc memory for DMA
> [    1.127626] bgmac_bcma: probe of bcma0:2 failed with error -12
> [    1.133838] bgmac_bcma: Broadcom 47xx GBit MAC driver loaded
> 
> The bgmac driver also triggers a WARNING:
> [    0.959486] ------------[ cut here ]------------
> [    0.964387] WARNING: CPU: 0 PID: 1 at ./include/linux/dma-mapping.h:516 bgmac_enet_probe+0x1b4/0x5c4
> [    0.973751] Modules linked in:
> [    0.976913] CPU: 0 PID: 1 Comm: swapper Not tainted 4.19.9 #0
> [    0.982750] Stack : 804a0000 804597c4 00000000 00000000 80458fd8 8381bc2c 838282d4 80481a47
> [    0.991367]         8042e3ec 00000001 804d38f0 00000204 83980000 00000065 8381bbe0 6f55b24f
> [    0.999975]         00000000 00000000 80520000 00002018 00000000 00000075 00000007 00000000
> [    1.008583]         00000000 80480000 000ee811 00000000 00000000 00000000 80432c00 80248db8
> [    1.017196]         00000009 00000204 83980000 803ad7b0 00000000 801feeec 00000000 804d0000
> [    1.025804]         ...
> [    1.028325] Call Trace:
> [    1.030875] [<8000aef8>] show_stack+0x58/0x100
> [    1.035513] [<8001f8b4>] __warn+0xe4/0x118
> [    1.039708] [<8001f9a4>] warn_slowpath_null+0x48/0x64
> [    1.044935] [<80248db8>] bgmac_enet_probe+0x1b4/0x5c4
> [    1.050101] [<802498e0>] bgmac_probe+0x558/0x590
> [    1.054906] [<80252fd0>] bcma_device_probe+0x38/0x70
> [    1.060017] [<8020e1e8>] really_probe+0x170/0x2e8
> [    1.064891] [<8020e714>] __driver_attach+0xa4/0xec
> [    1.069784] [<8020c1e0>] bus_for_each_dev+0x58/0xb0
> [    1.074833] [<8020d590>] bus_add_driver+0xf8/0x218
> [    1.079731] [<8020ef24>] driver_register+0xcc/0x11c
> [    1.084804] [<804b54cc>] bgmac_init+0x1c/0x44
> [    1.089258] [<8000121c>] do_one_initcall+0x7c/0x1a0
> [    1.094343] [<804a1d34>] kernel_init_freeable+0x150/0x218
> [    1.099886] [<803a082c>] kernel_init+0x10/0x104
> [    1.104583] [<80005878>] ret_from_kernel_thread+0x14/0x1c
> [    1.110107] ---[ end trace f441c0d873d1fb5b ]---
> 
> This patch setups a "struct device" (and passes it to the bcma) which
> allows fixing all the mentioned problems. It'll also require a tiny bcma
> patch which will follow through the wireless tree & its maintainer.
> 
> Fixes: f8c55dc6e828 ("MIPS: use generic dma noncoherent ops for simple noncoherent platforms")
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: stable@vger.kernel.org # v4.19+
> Signed-off-by: Rafał Miłecki <rafal@milecki.pl>

Acked-by: Hauke Mehrtens <hauke@hauke-m.de>

I assume that the old ssb based devices also have such problems did you 
had a look into those?

> ---
>   arch/mips/bcm47xx/setup.c     | 30 ++++++++++++++++++++++++++++++
>   include/linux/bcma/bcma_soc.h |  1 +
>   2 files changed, 31 insertions(+)
> 
> diff --git a/arch/mips/bcm47xx/setup.c b/arch/mips/bcm47xx/setup.c
> index 6054d49e608e..9339a31a0a87 100644
> --- a/arch/mips/bcm47xx/setup.c
> +++ b/arch/mips/bcm47xx/setup.c
> @@ -173,6 +173,31 @@ void __init plat_mem_setup(void)
>   	pm_power_off = bcm47xx_machine_halt;
>   }
>   
> +#ifdef CONFIG_BCM47XX_BCMA
> +static struct device * __init bcm47xx_setup_device(void)
> +{
> +	struct device *dev;
> +	int err;
> +
> +	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
> +	if (!dev)
> +		return NULL;
> +
> +	err = dev_set_name(dev, "bcm47xx_soc");
> +	if (err) {
> +		pr_err("Failed to set SoC device name: %d\n", err);
> +		kfree(dev);
> +		return NULL;
> +	}
> +
> +	err = dma_coerce_mask_and_coherent(dev, DMA_BIT_MASK(32));
> +	if (err)
> +		pr_err("Failed to set SoC DMA mask: %d\n", err);
> +
> +	return dev;
> +}
> +#endif
> +
>   /*
>    * This finishes bus initialization doing things that were not possible without
>    * kmalloc. Make sure to call it late enough (after mm_init).
> @@ -183,6 +208,10 @@ void __init bcm47xx_bus_setup(void)
>   	if (bcm47xx_bus_type == BCM47XX_BUS_TYPE_BCMA) {
>   		int err;
>   
> +		bcm47xx_bus.bcma.dev = bcm47xx_setup_device();
> +		if (!bcm47xx_bus.bcma.dev)
> +			panic("Failed to setup SoC device\n");
> +
>   		err = bcma_host_soc_init(&bcm47xx_bus.bcma);
>   		if (err)
>   			panic("Failed to initialize BCMA bus (err %d)", err);
> @@ -235,6 +264,7 @@ static int __init bcm47xx_register_bus_complete(void)
>   #endif
>   #ifdef CONFIG_BCM47XX_BCMA
>   	case BCM47XX_BUS_TYPE_BCMA:
> +		device_register(bcm47xx_bus.bcma.dev);
>   		bcma_bus_register(&bcm47xx_bus.bcma.bus);
>   		break;
>   #endif
> diff --git a/include/linux/bcma/bcma_soc.h b/include/linux/bcma/bcma_soc.h
> index 7cca5f859a90..72a9a5cf962b 100644
> --- a/include/linux/bcma/bcma_soc.h
> +++ b/include/linux/bcma/bcma_soc.h
> @@ -5,6 +5,7 @@
>   #include <linux/bcma/bcma.h>
>   
>   struct bcma_soc {
> +	struct device *dev;
>   	struct bcma_bus bus;

I would add this to the end, the access to the first member should be 
faster.

Hauke
