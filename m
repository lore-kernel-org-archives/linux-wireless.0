Return-Path: <SRS0=xI28=P5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6789AC2F426
	for <linux-wireless@archiver.kernel.org>; Mon, 21 Jan 2019 14:46:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 425C120879
	for <linux-wireless@archiver.kernel.org>; Mon, 21 Jan 2019 14:46:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729693AbfAUOqk (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 21 Jan 2019 09:46:40 -0500
Received: from verein.lst.de ([213.95.11.211]:58922 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729393AbfAUOqk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 21 Jan 2019 09:46:40 -0500
Received: by newverein.lst.de (Postfix, from userid 2407)
        id 9B5F368DD6; Mon, 21 Jan 2019 15:46:38 +0100 (CET)
Date:   Mon, 21 Jan 2019 15:46:38 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc:     Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org,
        Hauke Mehrtens <hauke@hauke-m.de>,
        =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>,
        linux-mips@linux-mips.org, Christoph Hellwig <hch@lst.de>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH wireless-drivers-next] bcma: get SoC device struct &
 copy its DMA params to the subdevices
Message-ID: <20190121144638.GA27203@lst.de>
References: <20190121101121.24555-1-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190121101121.24555-1-zajec5@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Mon, Jan 21, 2019 at 11:11:21AM +0100, Rafał Miłecki wrote:
> From: Rafał Miłecki <rafal@milecki.pl>
> 
> For bus devices to be fully usable it's required to set their DMA
> parameters.
> 
> For years it has been missing and remained unnoticed because of
> mips_dma_alloc_coherent() silently handling the empty coherent_dma_mask.
> Kernel 4.19 came with a lot of DMA changes and caused a regression on
> the bcm47xx. Starting with the commit f8c55dc6e828 ("MIPS: use generic
> dma noncoherent ops for simple noncoherent platforms") DMA coherent
> allocations just fail. Example:
> [    1.114914] bgmac_bcma bcma0:2: Allocation of TX ring 0x200 failed
> [    1.121215] bgmac_bcma bcma0:2: Unable to alloc memory for DMA
> [    1.127626] bgmac_bcma: probe of bcma0:2 failed with error -12
> [    1.133838] bgmac_bcma: Broadcom 47xx GBit MAC driver loaded
> 
> This change fixes above regression in addition to the MIPS bcm47xx
> commit 321c46b91550 ("MIPS: BCM47XX: Setup struct device for the SoC").
> 
> It also fixes another *old* GPIO regression caused by a parent pointing
> to the NULL:
> [    0.157054] missing gpiochip .dev parent pointer
> [    0.157287] bcma: bus0: Error registering GPIO driver: -22
> introduced by the commit 74f4e0cc6108 ("bcma: switch GPIO portions to
> use GPIOLIB_IRQCHIP").
> 
> Fixes: f8c55dc6e828 ("MIPS: use generic dma noncoherent ops for simple noncoherent platforms")
> Fixes: 74f4e0cc6108 ("bcma: switch GPIO portions to use GPIOLIB_IRQCHIP")
> Cc: linux-mips@linux-mips.org
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
> ---
> While this patch is a regression fix, it depends on a change present in
> the wireless-drivers-next.git:
> bcma: keep a direct pointer to the struct device
> 
> That's why I suggest pushing it into the wireless-drivers-next.git and I
> can take care of picking it for the stable@kernel.org later.
> 
> Another option would be cherry-picking commit 5a1c18b761dd ("bcma: keep
> a direct pointer to the struct device") to the wireless-drivers.git but
> I don't think it's a common practice.
> ---
>  drivers/bcma/host_soc.c       | 2 ++
>  drivers/bcma/main.c           | 6 +++++-
>  include/linux/bcma/bcma_soc.h | 1 +
>  3 files changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/bcma/host_soc.c b/drivers/bcma/host_soc.c
> index c8073b509a2b..1fdfb704f22d 100644
> --- a/drivers/bcma/host_soc.c
> +++ b/drivers/bcma/host_soc.c
> @@ -191,6 +191,8 @@ int __init bcma_host_soc_init(struct bcma_soc *soc)
>  	struct bcma_bus *bus = &soc->bus;
>  	int err;
>  
> +	bus->dev = soc->dev;
> +
>  	/* Scan bus and initialize it */
>  	err = bcma_bus_early_register(bus);
>  	if (err)
> diff --git a/drivers/bcma/main.c b/drivers/bcma/main.c
> index 6535614a7dc1..433ca5e2ed2c 100644
> --- a/drivers/bcma/main.c
> +++ b/drivers/bcma/main.c
> @@ -236,12 +236,16 @@ EXPORT_SYMBOL(bcma_core_irq);
>  
>  void bcma_prepare_core(struct bcma_bus *bus, struct bcma_device *core)
>  {
> +	struct device *dev = &core->dev;
> +
>  	core->dev.release = bcma_release_core_dev;
>  	core->dev.bus = &bcma_bus_type;
>  	dev_set_name(&core->dev, "bcma%d:%d", bus->num, core->core_index);
>  	core->dev.parent = bus->dev;
> -	if (bus->dev)
> +	if (bus->dev) {
>  		bcma_of_fill_device(bus->dev, core);
> +		dma_coerce_mask_and_coherent(dev, bus->dev->coherent_dma_mask);
> +	}

I don't think this does the right thing for bcma devices behind
PCI/PCIe, as those might need a IOMMU which relies on having a device
it has properly enumerated to be passed into the DMA API.  In other
words:  I think you need to change the layering so that the DMA API
is always called on the underlying PCI/PCIe/platform device, not of
the child bus.
