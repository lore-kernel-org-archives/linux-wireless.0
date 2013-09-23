Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:6474 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753159Ab3IWLDH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Sep 2013 07:03:07 -0400
Date: Mon, 23 Sep 2013 15:42:22 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Russell King <rmk+kernel@arm.linux.org.uk>
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
	Dan Williams <dan.j.williams@intel.com>
Subject: Re: [alsa-devel] [PATCH 23/51] DMA-API: dma: pl08x: add
 dma_set_mask_and_coherent() call
Message-ID: <20130923101222.GH17188@intel.com> (sfid-20130923_130318_944210_468E36FF)
References: <20130919212235.GD12758@n2100.arm.linux.org.uk>
 <E1VMm4v-0007hz-RC@rmk-PC.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <E1VMm4v-0007hz-RC@rmk-PC.arm.linux.org.uk>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 19, 2013 at 10:48:01PM +0100, Russell King wrote:
> The DMA API requires drivers to call the appropriate dma_set_mask()
> functions before doing any DMA mapping.  Add this required call to
> the AMBA PL08x driver.
> 
> Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Acked-by: Vinod Koul <vinod.koul@intel.com>

~Vinod
> ---
>  drivers/dma/amba-pl08x.c |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/dma/amba-pl08x.c b/drivers/dma/amba-pl08x.c
> index fce46c5..e51a983 100644
> --- a/drivers/dma/amba-pl08x.c
> +++ b/drivers/dma/amba-pl08x.c
> @@ -2055,6 +2055,11 @@ static int pl08x_probe(struct amba_device *adev, const struct amba_id *id)
>  	if (ret)
>  		return ret;
>  
> +	/* Ensure that we can do DMA */
> +	ret = dma_set_mask_and_coherent(&adev->dev, DMA_BIT_MASK(32));
> +	if (ret)
> +		goto out_no_pl08x;
> +
>  	/* Create the driver state holder */
>  	pl08x = kzalloc(sizeof(*pl08x), GFP_KERNEL);
>  	if (!pl08x) {
> -- 
> 1.7.4.4
> 
> _______________________________________________
> Alsa-devel mailing list
> Alsa-devel@alsa-project.org
> http://mailman.alsa-project.org/mailman/listinfo/alsa-devel

-- 
