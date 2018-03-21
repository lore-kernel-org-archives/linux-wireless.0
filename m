Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-eopbgr30089.outbound.protection.outlook.com ([40.107.3.89]:43136
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751423AbeCUQ2x (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 21 Mar 2018 12:28:53 -0400
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
Subject: RE: [PATCH v2 2/2] drivers: remove force dma flag from buses
Date: Wed, 21 Mar 2018 16:28:46 +0000
Message-ID: <HE1PR0401MB2425644F72A063ED42B79D5FE6AA0@HE1PR0401MB2425.eurprd04.prod.outlook.com> (sfid-20180321_172908_255484_8C495665)
References: <1520868292-2479-1-git-send-email-nipun.gupta@nxp.com>
 <1521615323-4752-1-git-send-email-nipun.gupta@nxp.com>
 <1521615323-4752-2-git-send-email-nipun.gupta@nxp.com>
 <20180321093525.GT14085@kroah.com>
In-Reply-To: <20180321093525.GT14085@kroah.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



> -----Original Message-----
> From: Greg KH [mailto:gregkh@linuxfoundation.org]
> Sent: Wednesday, March 21, 2018 15:05
> To: Nipun Gupta <nipun.gupta@nxp.com>
> Cc: robin.murphy@arm.com; hch@lst.de; linux@armlinux.org.uk;
> m.szyprowski@samsung.com; bhelgaas@google.com; zajec5@gmail.com;
> andy.gross@linaro.org; david.brown@linaro.org; dan.j.williams@intel.com;
> vinod.koul@intel.com; thierry.reding@gmail.com; robh+dt@kernel.org;
> frowand.list@gmail.com; jarkko.sakkinen@linux.intel.com;
> rafael.j.wysocki@intel.com; dmitry.torokhov@gmail.com; johan@kernel.org;
> msuchanek@suse.de; linux-kernel@vger.kernel.org; iommu@lists.linux-
> foundation.org; linux-wireless@vger.kernel.org; linux-arm-
> msm@vger.kernel.org; linux-soc@vger.kernel.org; dmaengine@vger.kernel.org=
;
> dri-devel@lists.freedesktop.org; linux-tegra@vger.kernel.org;
> devicetree@vger.kernel.org; linux-pci@vger.kernel.org; Bharat Bhushan
> <bharat.bhushan@nxp.com>; Leo Li <leoyang.li@nxp.com>
> Subject: Re: [PATCH v2 2/2] drivers: remove force dma flag from buses
>=20
> On Wed, Mar 21, 2018 at 12:25:23PM +0530, Nipun Gupta wrote:
> > With each bus implementing its own DMA configuration callback,
> > there is no need for bus to explicitly have force_dma in its
> > global structure. This patch modifies of_dma_configure API to
> > accept an input parameter which specifies if implicit DMA
> > configuration is required even when it is not described by the
> > firmware.
>=20
> Having to "remember" what that bool variable means on the end of the
> function call is a royal pain over time, right?
>=20
> Why not just create a new function:
> 	dma_common_configure_force(dma)
> that always does this?  Leave "dma_common_configure()" alone, and then
> wrap the old code with these two helper functions that call the 'core'
> code with the bool set properly?
>=20
> That way you do not have to "know" what that parameter is, the function
> name just documents it automatically, so when you see it in the
> bus-specific code, no need to go and have to hunt for anything.  And if
> you are reading the dma core code, it's obvious what is happening as the
> functions are all right there.

How about we do not pass any flag in 'dma_common_configure()', and inside t=
his
API we pass "true" to 'of_dma_configure()'? I am saying this because curren=
tly
both the busses (platform and AMBA) which uses 'dma_common_configure()' pas=
ses
"true" value. If we create additional 'dma_common_configure_force()', then
'dma_common_configure()' will not be used anytime and will become redundant=
.

If someday new busses come and they needs to use similar functionality whic=
h
'dma_common_configure()' provides, but with passing "false" to 'of_dma_conf=
igure()',
then what you suggests of having two separate such API's will be more reaso=
nable
and can be implemented?

Thanks,
Nipun

>=20
> thanks,
>=20
> greg k-h
