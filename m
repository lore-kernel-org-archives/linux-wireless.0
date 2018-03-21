Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-he1eur01on0055.outbound.protection.outlook.com ([104.47.0.55]:32144
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751854AbeCUQNq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 21 Mar 2018 12:13:46 -0400
From: Nipun Gupta <nipun.gupta@nxp.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "hch@lst.de" <hch@lst.de>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "m.szyprowski@samsung.com" <m.szyprowski@samsung.com>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "zajec5@gmail.com" <zajec5@gmail.com>,
        "andy.gross@linaro.org" <andy.gross@linaro.org>,
        "david.brown@linaro.org" <david.brown@linaro.org>,
        "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        "vinod.koul@intel.com" <vinod.koul@intel.com>,
        "thierry.reding@gmail.com" <thierry.reding@gmail.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "frowand.list@gmail.com" <frowand.list@gmail.com>,
        "jarkko.sakkinen@linux.intel.com" <jarkko.sakkinen@linux.intel.com>,
        "rafael.j.wysocki@intel.com" <rafael.j.wysocki@intel.com>,
        "dmitry.torokhov@gmail.com" <dmitry.torokhov@gmail.com>,
        "johan@kernel.org" <johan@kernel.org>,
        "msuchanek@suse.de" <msuchanek@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-soc@vger.kernel.org" <linux-soc@vger.kernel.org>,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Bharat Bhushan <bharat.bhushan@nxp.com>,
        Leo Li <leoyang.li@nxp.com>
Subject: RE: [PATCH v2 1/2] dma-mapping: move dma configuration to bus
 infrastructure
Date: Wed, 21 Mar 2018 16:13:38 +0000
Message-ID: <HE1PR0401MB242585F3CB211F71AF29791EE6AA0@HE1PR0401MB2425.eurprd04.prod.outlook.com> (sfid-20180321_171356_426244_4A965ECE)
References: <1520868292-2479-1-git-send-email-nipun.gupta@nxp.com>
 <1521615323-4752-1-git-send-email-nipun.gupta@nxp.com>
 <20180321092954.GS14085@kroah.com>
In-Reply-To: <20180321092954.GS14085@kroah.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



> -----Original Message-----
> From: Greg KH [mailto:gregkh@linuxfoundation.org]
> Sent: Wednesday, March 21, 2018 15:00

<snip>

> > +int dma_configure(struct device *dev)
> > +{
> > +	if (dev->bus->dma_configure)
> > +		return dev->bus->dma_configure(dev);
> > +
> > +	return 0;
> > +}
> >  void dma_deconfigure(struct device *dev)
>=20
> Empty line after this new function?  Sorry, couldn't help it :)
>=20
> >  {
> >  	of_dma_deconfigure(dev);
> > diff --git a/drivers/base/platform.c b/drivers/base/platform.c
> > index f1bf7b3..d2d5891 100644
> > --- a/drivers/base/platform.c
> > +++ b/drivers/base/platform.c
> > @@ -1130,6 +1130,11 @@ int platform_pm_restore(struct device *dev)
> >
> >  #endif /* CONFIG_HIBERNATE_CALLBACKS */
> >

<snip>

> > +
> >  	const struct dev_pm_ops *pm;
> >
> >  	const struct iommu_ops *iommu_ops;
> > diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
> > index eb9eab4..c15986b 100644
> > --- a/include/linux/dma-mapping.h
> > +++ b/include/linux/dma-mapping.h
> > @@ -761,6 +761,7 @@ void *dma_mark_declared_memory_occupied(struct
> device *dev,
> >  }
> >  #endif /* CONFIG_HAVE_GENERIC_DMA_COHERENT */
> >
> > +int dma_common_configure(struct device *dev);
> >  #ifdef CONFIG_HAS_DMA
>=20
> Blank line after the new function declaration?
>=20
> Other than those very minor things, nice job, this looks good:
>=20
> Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Thank you for the review :). I will fix your comments in next version.

Regards,
Nipun
