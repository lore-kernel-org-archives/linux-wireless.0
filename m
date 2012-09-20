Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:39063 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752146Ab2ITMxH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Sep 2012 08:53:07 -0400
Message-ID: <505B11A7.4040001@hauke-m.de> (sfid-20120920_145321_930189_9035BD61)
Date: Thu, 20 Sep 2012 14:52:55 +0200
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH] bcma: use udelay for short waits
References: <1348123339-15210-1-git-send-email-zajec5@gmail.com>
In-Reply-To: <1348123339-15210-1-git-send-email-zajec5@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/20/2012 08:42 AM, Rafał Miłecki wrote:
> msleep shouldn't be used for less than 20ms
> 
> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
> ---
>  drivers/bcma/driver_pci.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/bcma/driver_pci.c b/drivers/bcma/driver_pci.c
> index c32ebd5..e78e6a8 100644
> --- a/drivers/bcma/driver_pci.c
> +++ b/drivers/bcma/driver_pci.c
> @@ -51,7 +51,7 @@ static void bcma_pcie_mdio_set_phy(struct bcma_drv_pci *pc, u8 phy)
>  		v = pcicore_read32(pc, BCMA_CORE_PCI_MDIO_CONTROL);
>  		if (v & BCMA_CORE_PCI_MDIOCTL_ACCESS_DONE)
>  			break;
> -		msleep(1);
> +		udelay(1000);
>  	}
>  }
>  
> @@ -92,7 +92,7 @@ static u16 bcma_pcie_mdio_read(struct bcma_drv_pci *pc, u8 device, u8 address)
>  			ret = pcicore_read32(pc, BCMA_CORE_PCI_MDIO_DATA);
>  			break;
>  		}
> -		msleep(1);
> +		udelay(1000);
>  	}
>  	pcicore_write32(pc, BCMA_CORE_PCI_MDIO_CONTROL, 0);
>  	return ret;
> @@ -132,7 +132,7 @@ static void bcma_pcie_mdio_write(struct bcma_drv_pci *pc, u8 device,
>  		v = pcicore_read32(pc, BCMA_CORE_PCI_MDIO_CONTROL);
>  		if (v & BCMA_CORE_PCI_MDIOCTL_ACCESS_DONE)
>  			break;
> -		msleep(1);
> +		udelay(1000);
>  	}
>  	pcicore_write32(pc, BCMA_CORE_PCI_MDIO_CONTROL, 0);
>  }
> 

Using msleep(1) here is not correct, but I do not know if udelay(1000)
is better. The BCM4706 SoC or more the kernel code you are using seams
to have problems with sleeping, at least that is my current assumption.
when I add an msleep(1) somewhere into the code the exception stops
there without an exception from the CPU.

According to Documentation/timers/timers-howto.txt we should use
usleep_range for values from 10us to 20ms, but that also causes the same
problem as msleep() on this SoC.

Hauke
