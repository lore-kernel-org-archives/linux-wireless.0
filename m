Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:36085 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754111AbeDIU1r (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 9 Apr 2018 16:27:47 -0400
Date: Mon, 9 Apr 2018 15:27:45 -0500
From: Rob Herring <robh@kernel.org>
To: Nipun Gupta <nipun.gupta@nxp.com>
Cc: robin.murphy@arm.com, hch@lst.de, linux@armlinux.org.uk,
        gregkh@linuxfoundation.org, m.szyprowski@samsung.com,
        bhelgaas@google.com, zajec5@gmail.com, andy.gross@linaro.org,
        david.brown@linaro.org, dan.j.williams@intel.com,
        vinod.koul@intel.com, thierry.reding@gmail.com,
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
Message-ID: <20180409202745.p6hxkyy4n7fin3bd@rob-hp-laptop> (sfid-20180409_223054_484785_A62727B1)
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

Reviewed-by: Rob Herring <robh@kernel.org>
