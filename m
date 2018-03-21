Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40632 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751455AbeCUJf2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 21 Mar 2018 05:35:28 -0400
Date: Wed, 21 Mar 2018 10:35:25 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: Nipun Gupta <nipun.gupta@nxp.com>
Cc: robin.murphy@arm.com, hch@lst.de, linux@armlinux.org.uk,
        m.szyprowski@samsung.com, bhelgaas@google.com, zajec5@gmail.com,
        andy.gross@linaro.org, david.brown@linaro.org,
        dan.j.williams@intel.com, vinod.koul@intel.com,
        thierry.reding@gmail.com, robh+dt@kernel.org,
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
Message-ID: <20180321093525.GT14085@kroah.com> (sfid-20180321_103534_858424_18A862EB)
References: <1520868292-2479-1-git-send-email-nipun.gupta@nxp.com>
 <1521615323-4752-1-git-send-email-nipun.gupta@nxp.com>
 <1521615323-4752-2-git-send-email-nipun.gupta@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1521615323-4752-2-git-send-email-nipun.gupta@nxp.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Mar 21, 2018 at 12:25:23PM +0530, Nipun Gupta wrote:
> With each bus implementing its own DMA configuration callback,
> there is no need for bus to explicitly have force_dma in its
> global structure. This patch modifies of_dma_configure API to
> accept an input parameter which specifies if implicit DMA
> configuration is required even when it is not described by the
> firmware.

Having to "remember" what that bool variable means on the end of the
function call is a royal pain over time, right?

Why not just create a new function:
	dma_common_configure_force(dma)
that always does this?  Leave "dma_common_configure()" alone, and then
wrap the old code with these two helper functions that call the 'core'
code with the bool set properly?

That way you do not have to "know" what that parameter is, the function
name just documents it automatically, so when you see it in the
bus-specific code, no need to go and have to hunt for anything.  And if
you are reading the dma core code, it's obvious what is happening as the
functions are all right there.

thanks,

greg k-h
