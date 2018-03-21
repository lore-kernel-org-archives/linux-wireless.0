Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-he1eur01on0069.outbound.protection.outlook.com ([104.47.0.69]:35072
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751040AbeCUH3s (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 21 Mar 2018 03:29:48 -0400
From: Nipun Gupta <nipun.gupta@nxp.com>
To: Bharat Bhushan <bharat.bhushan@nxp.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "hch@lst.de" <hch@lst.de>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "m.szyprowski@samsung.com" <m.szyprowski@samsung.com>
CC: "bhelgaas@google.com" <bhelgaas@google.com>,
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
        Leo Li <leoyang.li@nxp.com>
Subject: RE: [PATCH v2 1/2] dma-mapping: move dma configuration to bus
 infrastructure
Date: Wed, 21 Mar 2018 07:29:38 +0000
Message-ID: <HE1PR0401MB24254A28553F17384BC9F785E6AA0@HE1PR0401MB2425.eurprd04.prod.outlook.com> (sfid-20180321_083006_202234_59491DFF)
References: <1520868292-2479-1-git-send-email-nipun.gupta@nxp.com>
 <1521615323-4752-1-git-send-email-nipun.gupta@nxp.com>
 <AM5PR0401MB254503027680DE6A23355D909AAA0@AM5PR0401MB2545.eurprd04.prod.outlook.com>
In-Reply-To: <AM5PR0401MB254503027680DE6A23355D909AAA0@AM5PR0401MB2545.eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



> -----Original Message-----
> From: Bharat Bhushan
> Sent: Wednesday, March 21, 2018 12:49

> >
> > +int dma_configure(struct device *dev)
> > +{
> > +	if (dev->bus->dma_configure)
> > +		return dev->bus->dma_configure(dev);
>=20
> What if dma_common_configure() is called in case "bus->dma_configure" is
> not defined?
>=20
> Thanks
> -Bharat

I think it is cleaner for bus to call '/dma_common_configure/' rather
than this been called implicitly, but Robin/Christoph can comment
better on this.

Thanks,
Nipun
