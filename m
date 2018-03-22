Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:46071 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752476AbeCVIPd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 22 Mar 2018 04:15:33 -0400
Date: Thu, 22 Mar 2018 09:15:30 +0100
From: Christoph Hellwig <hch@lst.de>
To: Nipun Gupta <nipun.gupta@nxp.com>
Cc: robin.murphy@arm.com, hch@lst.de, linux@armlinux.org.uk,
        gregkh@linuxfoundation.org, m.szyprowski@samsung.com,
        bhelgaas@google.com, zajec5@gmail.com, andy.gross@linaro.org,
        david.brown@linaro.org, dan.j.williams@intel.com,
        vinod.koul@intel.com, thierry.reding@gmail.com, robh+dt@kernel.org,
        frowand.list@gmail.com, jarkko.sakkinen@linux.intel.com,
        rafael.j.wysocki@intel.com, dmitry.torokhov@gmail.com,
        johan@kernel.org, msuchanek@suse.de, linux-kernel@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-wireless@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-soc@vger.kernel.org,
        dmaengine@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-tegra@vger.kernel.org, devicetree@vger.kernel.org,
        linux-pci@vger.kernel.org, bharat.bhushan@nxp.com,
        leoyang.li@nxp.com
Subject: Re: [PATCH v2 1/2] dma-mapping: move dma configuration to bus
        infrastructure
Message-ID: <20180322081530.GA29444@lst.de> (sfid-20180322_091546_264615_93C66FE2)
References: <1520868292-2479-1-git-send-email-nipun.gupta@nxp.com> <1521615323-4752-1-git-send-email-nipun.gupta@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1521615323-4752-1-git-send-email-nipun.gupta@nxp.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> +static int amba_dma_configure(struct device *dev)
> +{
> +	return dma_common_configure(dev);
> +}

So it turns out we only end with two callers of dma_common_configure
after this series.  Based ont hat I'm tempted with the suggestion
from Robin to just have amba call platform_dma_configure, and move
the code from dma_common_configure to platform_dma_configure.

> +int dma_configure(struct device *dev)
> +{
> +	if (dev->bus->dma_configure)
> +		return dev->bus->dma_configure(dev);
> +
> +	return 0;
> +}
>  void dma_deconfigure(struct device *dev)

As grep pointed out this wants a blank line after the function, and while
in nitpicking mode I'd suggest to remove the blank line above the return
statement while at it.

> diff --git a/drivers/gpu/host1x/bus.c b/drivers/gpu/host1x/bus.c
> index 88a3558..fa9896d 100644
> --- a/drivers/gpu/host1x/bus.c
> +++ b/drivers/gpu/host1x/bus.c
> @@ -314,6 +314,14 @@ static int host1x_device_match(struct device *dev, struct device_driver *drv)
>  	return strcmp(dev_name(dev), drv->name) == 0;
>  }
>  
> +static int host1x_dma_configure(struct device *dev)
> +{
> +	if (dev->of_node)
> +		return of_dma_configure(dev, dev->of_node);
> +
> +	return 0;

Same here.

> + */
> +static int pci_dma_configure(struct device *dev)
> +{
> +	struct device *bridge;
> +	enum dev_dma_attr attr;
> +	int ret = 0;
> +
> +	bridge = pci_get_host_bridge_device(to_pci_dev(dev));
> +
> +	if (IS_ENABLED(CONFIG_OF) && bridge->parent &&
> +	    bridge->parent->of_node) {
> +		ret = of_dma_configure(dev, bridge->parent->of_node);
> +	} else if (has_acpi_companion(bridge)) {
> +		attr = acpi_get_dma_attr(to_acpi_device_node(bridge->fwnode));
> +		if (attr != DEV_DMA_NOT_SUPPORTED)
> +			ret = acpi_dma_configure(dev, attr);
> +	}

The attr declaration can be moved into the inner scope here.

> +	pci_put_host_bridge_device(bridge);
> +
> +	return ret;

Drop the blank line after the return, please.
