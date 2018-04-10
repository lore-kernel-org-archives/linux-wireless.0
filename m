Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:48190 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752434AbeDJTVx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 10 Apr 2018 15:21:53 -0400
Date: Tue, 10 Apr 2018 14:21:51 -0500
From: Bjorn Helgaas <helgaas@kernel.org>
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
Subject: Re: [PATCH v3 2/2] drivers: remove force dma flag from buses
Message-ID: <20180410192151.GB54986@bhelgaas-glaptop.roam.corp.google.com> (sfid-20180410_212159_554166_88701413)
References: <1520868292-2479-1-git-send-email-nipun.gupta@nxp.com>
 <1522396485-10248-1-git-send-email-nipun.gupta@nxp.com>
 <1522396485-10248-2-git-send-email-nipun.gupta@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1522396485-10248-2-git-send-email-nipun.gupta@nxp.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Mar 30, 2018 at 01:24:45PM +0530, Nipun Gupta wrote:
> With each bus implementing its own DMA configuration callback,
> there is no need for bus to explicitly have force_dma in its
> global structure. This patch modifies of_dma_configure API to
> accept an input parameter which specifies if implicit DMA
> configuration is required even when it is not described by the
> firmware.
> 
> Signed-off-by: Nipun Gupta <nipun.gupta@nxp.com>

Acked-by: Bjorn Helgaas <bhelgaas@google.com>  # PCI parts

> ---
> Changes in v2:
>   - This is a new change suggested by Robin and Christoph
>     and is added to the series.
> 
> Changes in v3:
>   - Rebase and changes corresponding to the changes in patch 1/2
> 
>  drivers/amba/bus.c            | 1 -
>  drivers/base/platform.c       | 3 +--
>  drivers/bcma/main.c           | 2 +-
>  drivers/dma/qcom/hidma_mgmt.c | 2 +-
>  drivers/gpu/host1x/bus.c      | 5 ++---
>  drivers/of/device.c           | 6 ++++--
>  drivers/of/of_reserved_mem.c  | 2 +-
>  drivers/pci/pci-driver.c      | 3 +--
>  include/linux/device.h        | 4 ----
>  include/linux/of_device.h     | 8 ++++++--
>  10 files changed, 17 insertions(+), 19 deletions(-)
> 
> diff --git a/drivers/amba/bus.c b/drivers/amba/bus.c
> index 867dc2b..abe73c4 100644
> --- a/drivers/amba/bus.c
> +++ b/drivers/amba/bus.c
> @@ -199,7 +199,6 @@ struct bus_type amba_bustype = {
>  	.uevent		= amba_uevent,
>  	.dma_configure	= platform_dma_configure,
>  	.pm		= &amba_pm,
> -	.force_dma	= true,
>  };
>  
>  static int __init amba_init(void)
> diff --git a/drivers/base/platform.c b/drivers/base/platform.c
> index 72fdbf6..cfbc569 100644
> --- a/drivers/base/platform.c
> +++ b/drivers/base/platform.c
> @@ -1136,7 +1136,7 @@ int platform_dma_configure(struct device *dev)
>  	int ret = 0;
>  
>  	if (dev->of_node) {
> -		ret = of_dma_configure(dev, dev->of_node);
> +		ret = of_dma_configure(dev, dev->of_node, true);
>  	} else if (has_acpi_companion(dev)) {
>  		attr = acpi_get_dma_attr(to_acpi_device_node(dev->fwnode));
>  		if (attr != DEV_DMA_NOT_SUPPORTED)
> @@ -1159,7 +1159,6 @@ struct bus_type platform_bus_type = {
>  	.uevent		= platform_uevent,
>  	.dma_configure	= platform_dma_configure,
>  	.pm		= &platform_dev_pm_ops,
> -	.force_dma	= true,
>  };
>  EXPORT_SYMBOL_GPL(platform_bus_type);
>  
> diff --git a/drivers/bcma/main.c b/drivers/bcma/main.c
> index e6986c7..fc1f4ac 100644
> --- a/drivers/bcma/main.c
> +++ b/drivers/bcma/main.c
> @@ -207,7 +207,7 @@ static void bcma_of_fill_device(struct device *parent,
>  
>  	core->irq = bcma_of_get_irq(parent, core, 0);
>  
> -	of_dma_configure(&core->dev, node);
> +	of_dma_configure(&core->dev, node, false);
>  }
>  
>  unsigned int bcma_core_irq(struct bcma_device *core, int num)
> diff --git a/drivers/dma/qcom/hidma_mgmt.c b/drivers/dma/qcom/hidma_mgmt.c
> index 000c7019..d64edeb 100644
> --- a/drivers/dma/qcom/hidma_mgmt.c
> +++ b/drivers/dma/qcom/hidma_mgmt.c
> @@ -398,7 +398,7 @@ static int __init hidma_mgmt_of_populate_channels(struct device_node *np)
>  		}
>  		of_node_get(child);
>  		new_pdev->dev.of_node = child;
> -		of_dma_configure(&new_pdev->dev, child);
> +		of_dma_configure(&new_pdev->dev, child, true);
>  		/*
>  		 * It is assumed that calling of_msi_configure is safe on
>  		 * platforms with or without MSI support.
> diff --git a/drivers/gpu/host1x/bus.c b/drivers/gpu/host1x/bus.c
> index a9ec99d..b39c1e9 100644
> --- a/drivers/gpu/host1x/bus.c
> +++ b/drivers/gpu/host1x/bus.c
> @@ -317,7 +317,7 @@ static int host1x_device_match(struct device *dev, struct device_driver *drv)
>  static int host1x_dma_configure(struct device *dev)
>  {
>  	if (dev->of_node)
> -		return of_dma_configure(dev, dev->of_node);
> +		return of_dma_configure(dev, dev->of_node, true);
>  	return 0;
>  }
>  
> @@ -335,7 +335,6 @@ struct bus_type host1x_bus_type = {
>  	.match = host1x_device_match,
>  	.dma_configure	= host1x_dma_configure,
>  	.pm = &host1x_device_pm_ops,
> -	.force_dma = true,
>  };
>  
>  static void __host1x_device_del(struct host1x_device *device)
> @@ -424,7 +423,7 @@ static int host1x_device_add(struct host1x *host1x,
>  	device->dev.bus = &host1x_bus_type;
>  	device->dev.parent = host1x->dev;
>  
> -	of_dma_configure(&device->dev, host1x->dev->of_node);
> +	of_dma_configure(&device->dev, host1x->dev->of_node, true);
>  
>  	err = host1x_device_parse_dt(device, driver);
>  	if (err < 0) {
> diff --git a/drivers/of/device.c b/drivers/of/device.c
> index 064c818..33d8551 100644
> --- a/drivers/of/device.c
> +++ b/drivers/of/device.c
> @@ -76,6 +76,8 @@ int of_device_add(struct platform_device *ofdev)
>   * of_dma_configure - Setup DMA configuration
>   * @dev:	Device to apply DMA configuration
>   * @np:		Pointer to OF node having DMA configuration
> + * @force_dma:  Whether device is to be set up by of_dma_configure() even if
> + *		DMA capability is not explicitly described by firmware.
>   *
>   * Try to get devices's DMA configuration from DT and update it
>   * accordingly.
> @@ -84,7 +86,7 @@ int of_device_add(struct platform_device *ofdev)
>   * can use a platform bus notifier and handle BUS_NOTIFY_ADD_DEVICE events
>   * to fix up DMA configuration.
>   */
> -int of_dma_configure(struct device *dev, struct device_node *np)
> +int of_dma_configure(struct device *dev, struct device_node *np, bool force_dma)
>  {
>  	u64 dma_addr, paddr, size = 0;
>  	int ret;
> @@ -100,7 +102,7 @@ int of_dma_configure(struct device *dev, struct device_node *np)
>  		 * DMA configuration regardless of whether "dma-ranges" is
>  		 * correctly specified or not.
>  		 */
> -		if (!dev->bus->force_dma)
> +		if (!force_dma)
>  			return ret == -ENODEV ? 0 : ret;
>  
>  		dma_addr = offset = 0;
> diff --git a/drivers/of/of_reserved_mem.c b/drivers/of/of_reserved_mem.c
> index 9a4f4246..895c83e 100644
> --- a/drivers/of/of_reserved_mem.c
> +++ b/drivers/of/of_reserved_mem.c
> @@ -353,7 +353,7 @@ int of_reserved_mem_device_init_by_idx(struct device *dev,
>  		/* ensure that dma_ops is set for virtual devices
>  		 * using reserved memory
>  		 */
> -		of_dma_configure(dev, np);
> +		of_dma_configure(dev, np, true);
>  
>  		dev_info(dev, "assigned reserved memory node %s\n", rmem->name);
>  	} else {
> diff --git a/drivers/pci/pci-driver.c b/drivers/pci/pci-driver.c
> index 78e507f..27c832f 100644
> --- a/drivers/pci/pci-driver.c
> +++ b/drivers/pci/pci-driver.c
> @@ -1540,7 +1540,7 @@ static int pci_dma_configure(struct device *dev)
>  
>  	if (IS_ENABLED(CONFIG_OF) && bridge->parent &&
>  	    bridge->parent->of_node) {
> -		ret = of_dma_configure(dev, bridge->parent->of_node);
> +		ret = of_dma_configure(dev, bridge->parent->of_node, true);
>  	} else if (has_acpi_companion(bridge)) {
>  		struct acpi_device *adev = to_acpi_device_node(bridge->fwnode);
>  		enum dev_dma_attr attr = acpi_get_dma_attr(adev);
> @@ -1566,7 +1566,6 @@ struct bus_type pci_bus_type = {
>  	.pm		= PCI_PM_OPS_PTR,
>  	.num_vf		= pci_bus_num_vf,
>  	.dma_configure	= pci_dma_configure,
> -	.force_dma	= true,
>  };
>  EXPORT_SYMBOL(pci_bus_type);
>  
> diff --git a/include/linux/device.h b/include/linux/device.h
> index 1832d90..92c530e 100644
> --- a/include/linux/device.h
> +++ b/include/linux/device.h
> @@ -98,8 +98,6 @@ extern int __must_check bus_create_file(struct bus_type *,
>   * @p:		The private data of the driver core, only the driver core can
>   *		touch this.
>   * @lock_key:	Lock class key for use by the lock validator
> - * @force_dma:	Assume devices on this bus should be set up by dma_configure()
> - * 		even if DMA capability is not explicitly described by firmware.
>   *
>   * A bus is a channel between the processor and one or more devices. For the
>   * purposes of the device model, all devices are connected via a bus, even if
> @@ -140,8 +138,6 @@ struct bus_type {
>  
>  	struct subsys_private *p;
>  	struct lock_class_key lock_key;
> -
> -	bool force_dma;
>  };
>  
>  extern int __must_check bus_register(struct bus_type *bus);
> diff --git a/include/linux/of_device.h b/include/linux/of_device.h
> index 8da5a1b..165fd30 100644
> --- a/include/linux/of_device.h
> +++ b/include/linux/of_device.h
> @@ -55,7 +55,9 @@ static inline struct device_node *of_cpu_device_node_get(int cpu)
>  	return of_node_get(cpu_dev->of_node);
>  }
>  
> -int of_dma_configure(struct device *dev, struct device_node *np);
> +int of_dma_configure(struct device *dev,
> +		     struct device_node *np,
> +		     bool force_dma);
>  void of_dma_deconfigure(struct device *dev);
>  #else /* CONFIG_OF */
>  
> @@ -105,7 +107,9 @@ static inline struct device_node *of_cpu_device_node_get(int cpu)
>  	return NULL;
>  }
>  
> -static inline int of_dma_configure(struct device *dev, struct device_node *np)
> +static inline int of_dma_configure(struct device *dev,
> +				   struct device_node *np,
> +				   bool force_dma)
>  {
>  	return 0;
>  }
> -- 
> 1.9.1
> 
