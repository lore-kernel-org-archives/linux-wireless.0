Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:43841 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751833AbeECMTH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 3 May 2018 08:19:07 -0400
Date: Thu, 3 May 2018 14:21:47 +0200
From: Christoph Hellwig <hch@lst.de>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Nipun Gupta <nipun.gupta@nxp.com>, robin.murphy@arm.com,
        hch@lst.de, linux@armlinux.org.uk, gregkh@linuxfoundation.org,
        m.szyprowski@samsung.com, bhelgaas@google.com, zajec5@gmail.com,
        andy.gross@linaro.org, david.brown@linaro.org,
        dan.j.williams@intel.com, vinod.koul@intel.com, robh+dt@kernel.org,
        frowand.list@gmail.com, jarkko.sakkinen@linux.intel.com,
        rafael.j.wysocki@intel.com, dmitry.torokhov@gmail.com,
        johan@kernel.org, msuchanek@suse.de, linux-kernel@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-wireless@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-soc@vger.kernel.org,
        dmaengine@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-tegra@vger.kernel.org, devicetree@vger.kernel.org,
        linux-pci@vger.kernel.org, bharat.bhushan@nxp.com,
        leoyang.li@nxp.com
Subject: Re: [PATCH v4 1/2] dma-mapping: move dma configuration to bus
        infrastructure
Message-ID: <20180503122147.GB18590@lst.de> (sfid-20180503_141915_129455_3AC02C24)
References: <1520868292-2479-1-git-send-email-nipun.gupta@nxp.com> <1524883919-29484-1-git-send-email-nipun.gupta@nxp.com> <20180430104124.GE2476@ulmo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180430104124.GE2476@ulmo>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Apr 30, 2018 at 12:41:24PM +0200, Thierry Reding wrote:
> On Sat, Apr 28, 2018 at 08:21:58AM +0530, Nipun Gupta wrote:
> [...]
> > diff --git a/drivers/gpu/host1x/bus.c b/drivers/gpu/host1x/bus.c
> > index 88a3558..a9ec99d 100644
> > --- a/drivers/gpu/host1x/bus.c
> > +++ b/drivers/gpu/host1x/bus.c
> > @@ -314,6 +314,13 @@ static int host1x_device_match(struct device *dev, struct device_driver *drv)
> >  	return strcmp(dev_name(dev), drv->name) == 0;
> >  }
> >  
> > +static int host1x_dma_configure(struct device *dev)
> > +{
> > +	if (dev->of_node)
> > +		return of_dma_configure(dev, dev->of_node);
> 
> The conditional here is somewhat pointless since the of_node should
> always be set. If it weren't it should be considered a bug and this
> function welcome to crash to make that very obvious.

Agreed.  Please remove the check for the resend.
