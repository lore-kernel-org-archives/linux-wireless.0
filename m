Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57070 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752122AbeCURt0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 21 Mar 2018 13:49:26 -0400
Date: Wed, 21 Mar 2018 18:49:24 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: Nipun Gupta <nipun.gupta@nxp.com>
Cc: "robin.murphy@arm.com" <robin.murphy@arm.com>,
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
Subject: Re: [PATCH v2 2/2] drivers: remove force dma flag from buses
Message-ID: <20180321174924.GA11141@kroah.com> (sfid-20180321_184940_838298_AEA73011)
References: <1520868292-2479-1-git-send-email-nipun.gupta@nxp.com>
 <1521615323-4752-1-git-send-email-nipun.gupta@nxp.com>
 <1521615323-4752-2-git-send-email-nipun.gupta@nxp.com>
 <20180321093525.GT14085@kroah.com>
 <HE1PR0401MB2425644F72A063ED42B79D5FE6AA0@HE1PR0401MB2425.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <HE1PR0401MB2425644F72A063ED42B79D5FE6AA0@HE1PR0401MB2425.eurprd04.prod.outlook.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Mar 21, 2018 at 04:28:46PM +0000, Nipun Gupta wrote:
> 
> 
> > -----Original Message-----
> > From: Greg KH [mailto:gregkh@linuxfoundation.org]
> > Sent: Wednesday, March 21, 2018 15:05
> > To: Nipun Gupta <nipun.gupta@nxp.com>
> > Cc: robin.murphy@arm.com; hch@lst.de; linux@armlinux.org.uk;
> > m.szyprowski@samsung.com; bhelgaas@google.com; zajec5@gmail.com;
> > andy.gross@linaro.org; david.brown@linaro.org; dan.j.williams@intel.com;
> > vinod.koul@intel.com; thierry.reding@gmail.com; robh+dt@kernel.org;
> > frowand.list@gmail.com; jarkko.sakkinen@linux.intel.com;
> > rafael.j.wysocki@intel.com; dmitry.torokhov@gmail.com; johan@kernel.org;
> > msuchanek@suse.de; linux-kernel@vger.kernel.org; iommu@lists.linux-
> > foundation.org; linux-wireless@vger.kernel.org; linux-arm-
> > msm@vger.kernel.org; linux-soc@vger.kernel.org; dmaengine@vger.kernel.org;
> > dri-devel@lists.freedesktop.org; linux-tegra@vger.kernel.org;
> > devicetree@vger.kernel.org; linux-pci@vger.kernel.org; Bharat Bhushan
> > <bharat.bhushan@nxp.com>; Leo Li <leoyang.li@nxp.com>
> > Subject: Re: [PATCH v2 2/2] drivers: remove force dma flag from buses
> > 
> > On Wed, Mar 21, 2018 at 12:25:23PM +0530, Nipun Gupta wrote:
> > > With each bus implementing its own DMA configuration callback,
> > > there is no need for bus to explicitly have force_dma in its
> > > global structure. This patch modifies of_dma_configure API to
> > > accept an input parameter which specifies if implicit DMA
> > > configuration is required even when it is not described by the
> > > firmware.
> > 
> > Having to "remember" what that bool variable means on the end of the
> > function call is a royal pain over time, right?
> > 
> > Why not just create a new function:
> > 	dma_common_configure_force(dma)
> > that always does this?  Leave "dma_common_configure()" alone, and then
> > wrap the old code with these two helper functions that call the 'core'
> > code with the bool set properly?
> > 
> > That way you do not have to "know" what that parameter is, the function
> > name just documents it automatically, so when you see it in the
> > bus-specific code, no need to go and have to hunt for anything.  And if
> > you are reading the dma core code, it's obvious what is happening as the
> > functions are all right there.
> 
> How about we do not pass any flag in 'dma_common_configure()', and inside this
> API we pass "true" to 'of_dma_configure()'? I am saying this because currently
> both the busses (platform and AMBA) which uses 'dma_common_configure()' passes
> "true" value. If we create additional 'dma_common_configure_force()', then
> 'dma_common_configure()' will not be used anytime and will become redundant.
> 
> If someday new busses come and they needs to use similar functionality which
> 'dma_common_configure()' provides, but with passing "false" to 'of_dma_configure()',
> then what you suggests of having two separate such API's will be more reasonable
> and can be implemented?

If that makes things "simple", yes, sounds good.

greg k-h
