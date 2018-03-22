Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-eopbgr10088.outbound.protection.outlook.com ([40.107.1.88]:15291
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753181AbeCVPNz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 22 Mar 2018 11:13:55 -0400
From: Nipun Gupta <nipun.gupta@nxp.com>
To: Christoph Hellwig <hch@lst.de>
CC: "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
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
Subject: RE: [PATCH v2 2/2] drivers: remove force dma flag from buses
Date: Thu, 22 Mar 2018 15:13:49 +0000
Message-ID: <HE1PR0401MB2425407DADB19FCF6E016456E6A90@HE1PR0401MB2425.eurprd04.prod.outlook.com> (sfid-20180322_161513_578894_2980FDD9)
References: <1520868292-2479-1-git-send-email-nipun.gupta@nxp.com>
 <1521615323-4752-1-git-send-email-nipun.gupta@nxp.com>
 <1521615323-4752-2-git-send-email-nipun.gupta@nxp.com>
 <20180322081926.GC29444@lst.de>
In-Reply-To: <20180322081926.GC29444@lst.de>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



> -----Original Message-----
> From: Christoph Hellwig [mailto:hch@lst.de]
> Sent: Thursday, March 22, 2018 13:49
> To: Nipun Gupta <nipun.gupta@nxp.com>
>=20
> > --- a/drivers/dma/qcom/hidma_mgmt.c
> > +++ b/drivers/dma/qcom/hidma_mgmt.c
> > @@ -398,7 +398,7 @@ static int __init
> hidma_mgmt_of_populate_channels(struct device_node *np)
> >  		}
> >  		of_node_get(child);
> >  		new_pdev->dev.of_node =3D child;
> > -		of_dma_configure(&new_pdev->dev, child);
> > +		of_dma_configure(&new_pdev->dev, child, true);
> >  		/*
> >  		 * It is assumed that calling of_msi_configure is safe on
> >  		 * platforms with or without MSI support.
>=20
> Where did we mark this bus as force_dma before?

I thought these devices to be on the platform bus as the device is of type
'struct platform_device', though I am not sure then why 'of_dma_configure()=
'
is called here. Is this not on platform bus?

>=20
> > diff --git a/drivers/of/of_reserved_mem.c b/drivers/of/of_reserved_mem.=
c
> > index 9a4f4246..895c83e 100644
> > --- a/drivers/of/of_reserved_mem.c
> > +++ b/drivers/of/of_reserved_mem.c
> > @@ -353,7 +353,7 @@ int of_reserved_mem_device_init_by_idx(struct devic=
e
> *dev,
> >  		/* ensure that dma_ops is set for virtual devices
> >  		 * using reserved memory
> >  		 */
> > -		of_dma_configure(dev, np);
> > +		of_dma_configure(dev, np, true);
>=20
> Did all the callers of this one really force dma?  I have a hard time
> untangling the call stacks unfortunately.

I see this API being called indirectly from NXP DPAA device driver which
is for platform bus devices. So I marked 'true' out here. There are more pl=
aces
from where it is being called.

Thanks,
Nipun
