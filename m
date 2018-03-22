Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:46117 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752542AbeCVIT3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 22 Mar 2018 04:19:29 -0400
Date: Thu, 22 Mar 2018 09:19:26 +0100
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
Subject: Re: [PATCH v2 2/2] drivers: remove force dma flag from buses
Message-ID: <20180322081926.GC29444@lst.de> (sfid-20180322_092005_315497_733E7992)
References: <1520868292-2479-1-git-send-email-nipun.gupta@nxp.com> <1521615323-4752-1-git-send-email-nipun.gupta@nxp.com> <1521615323-4752-2-git-send-email-nipun.gupta@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1521615323-4752-2-git-send-email-nipun.gupta@nxp.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

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

Where did we mark this bus as force_dma before?

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

Did all the callers of this one really force dma?  I have a hard time
untangling the call stacks unfortunately.
