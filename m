Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from gloria.sntech.de ([95.129.55.99]:53579 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752204Ab3ITR1N (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Sep 2013 13:27:13 -0400
From: Heiko =?utf-8?q?St=C3=BCbner?= <heiko@sntech.de>
To: Russell King <rmk+kernel@arm.linux.org.uk>
Subject: Re: [PATCH 24/51] DMA-API: dma: pl330: add dma_set_mask_and_coherent() call
Date: Fri, 20 Sep 2013 19:26:27 +0200
Cc: alsa-devel@alsa-project.org, b43-dev@lists.infradead.org,
	devel@driverdev.osuosl.org, devicetree@vger.kernel.org,
	dri-devel@lists.freedesktop.org, e1000-devel@lists.sourceforge.net,
	linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-fbdev@vger.kernel.org,
	linux-ide@vger.kernel.org, linux-media@vger.kernel.org,
	linux-mmc@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-omap@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
	linux-samsung-soc@vger.kernel.org, linux-scsi@vger.kernel.org,
	linux-tegra@vger.kernel.org, linux-usb@vger.kernel.org,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	Solarflare linux maintainers <linux-net-drivers@solarflare.com>,
	uclinux-dist-devel@blackfin.uclinux.org,
	Dan Williams <dan.j.williams@intel.com>,
	Vinod Koul <vinod.koul@intel.com>
References: <20130919212235.GD12758@n2100.arm.linux.org.uk> <E1VMm5t-0007i5-V7@rmk-PC.arm.linux.org.uk>
In-Reply-To: <E1VMm5t-0007i5-V7@rmk-PC.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201309201926.29084.heiko@sntech.de> (sfid-20130920_192725_941930_5BE43643)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Donnerstag, 19. September 2013, 23:49:01 schrieb Russell King:
> The DMA API requires drivers to call the appropriate dma_set_mask()
> functions before doing any DMA mapping.  Add this required call to
> the AMBA PL08x driver.
			^--- copy and paste error - should of course be PL330


> Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
> ---
>  drivers/dma/pl330.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/dma/pl330.c b/drivers/dma/pl330.c
> index a562d24..df8b10f 100644
> --- a/drivers/dma/pl330.c
> +++ b/drivers/dma/pl330.c
> @@ -2903,6 +2903,10 @@ pl330_probe(struct amba_device *adev, const struct
> amba_id *id)
> 
>  	pdat = dev_get_platdata(&adev->dev);
> 
> +	ret = dma_set_mask_and_coherent(&adev->dev, DMA_BIT_MASK(32));
> +	if (ret)
> +		return ret;
> +
>  	/* Allocate a new DMAC and its Channels */
>  	pdmac = devm_kzalloc(&adev->dev, sizeof(*pdmac), GFP_KERNEL);
>  	if (!pdmac) {

