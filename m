Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:46090 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752504AbeCVIRH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 22 Mar 2018 04:17:07 -0400
Date: Thu, 22 Mar 2018 09:17:05 +0100
From: "hch@lst.de" <hch@lst.de>
To: Bharat Bhushan <bharat.bhushan@nxp.com>
Cc: Nipun Gupta <nipun.gupta@nxp.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "hch@lst.de" <hch@lst.de>,
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
        Leo Li <leoyang.li@nxp.com>
Subject: Re: [PATCH v2 1/2] dma-mapping: move dma configuration to bus
        infrastructure
Message-ID: <20180322081705.GB29444@lst.de> (sfid-20180322_091716_219618_76F9448B)
References: <1520868292-2479-1-git-send-email-nipun.gupta@nxp.com> <1521615323-4752-1-git-send-email-nipun.gupta@nxp.com> <AM5PR0401MB254503027680DE6A23355D909AAA0@AM5PR0401MB2545.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <AM5PR0401MB254503027680DE6A23355D909AAA0@AM5PR0401MB2545.eurprd04.prod.outlook.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> > +int dma_configure(struct device *dev)
> > +{
> > +	if (dev->bus->dma_configure)
> > +		return dev->bus->dma_configure(dev);
> 
> What if dma_common_configure() is called in case "bus->dma_configure" is not defined?

Then we'd still have a dependency of common code on OF and ACPI.

On the other hand we'd get free OF and ACPI dma ranges parsing for
everyone, which might be handy.  And which would really help mitigating
the risk that we missed some bus that gets dma configuration from OF,
so maybe it actually is a good idea.  I'd just rename it to
dma_default_configure or similar in that case.
