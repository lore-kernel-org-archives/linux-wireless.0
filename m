Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:54505 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751285Ab3ALOFW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 Jan 2013 09:05:22 -0500
Message-ID: <50F16D97.6010802@hauke-m.de> (sfid-20130112_150530_183124_E2F30C3E)
Date: Sat, 12 Jan 2013 15:05:11 +0100
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: Nathan Hintz <nlhintz@hotmail.com>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 5/5] bcma: use consistent case for 'hex' constants
References: <1357987577-20661-1-git-send-email-nlhintz@hotmail.com> <BLU0-SMTP988620BB0129B03EE7F0EBAC280@phx.gbl>
In-Reply-To: <BLU0-SMTP988620BB0129B03EE7F0EBAC280@phx.gbl>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/12/2013 11:46 AM, Nathan Hintz wrote:
> 
> Signed-off-by: Nathan Hintz <nlhintz@hotmail.com>

Acked-by: Hauke Mehrtens <hauke@hauke-m.de>

> ---
>  drivers/bcma/driver_pci_host.c |   10 +++++-----
>  1 files changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/bcma/driver_pci_host.c b/drivers/bcma/driver_pci_host.c
> index 92800b4..d3bde6c 100644
> --- a/drivers/bcma/driver_pci_host.c
> +++ b/drivers/bcma/driver_pci_host.c
> @@ -106,7 +106,7 @@ static int bcma_extpci_read_config(struct bcma_drv_pci *pc, unsigned int dev,
>  		} else {
>  			addr = BCMA_CORE_PCI_PCICFG0;
>  			addr |= (func << 8);
> -			addr |= (off & 0xfc);
> +			addr |= (off & 0xFC);
>  			val = pcicore_read32(pc, addr);
>  		}
>  	} else {
> @@ -119,7 +119,7 @@ static int bcma_extpci_read_config(struct bcma_drv_pci *pc, unsigned int dev,
>  			goto out;
>  
>  		if (mips_busprobe32(val, mmio)) {
> -			val = 0xffffffff;
> +			val = 0xFFFFFFFF;
>  			goto unmap;
>  		}
>  	}
> @@ -171,7 +171,7 @@ static int bcma_extpci_write_config(struct bcma_drv_pci *pc, unsigned int dev,
>  		} else {
>  			addr = BCMA_CORE_PCI_PCICFG0;
>  			addr |= (func << 8);
> -			addr |= (off & 0xfc);
> +			addr |= (off & 0xFC);
>  			val = pcicore_read32(pc, addr);
>  		}
>  	} else {
> @@ -184,7 +184,7 @@ static int bcma_extpci_write_config(struct bcma_drv_pci *pc, unsigned int dev,
>  			goto out;
>  
>  		if (mips_busprobe32(val, mmio)) {
> -			val = 0xffffffff;
> +			val = 0xFFFFFFFF;
>  			goto unmap;
>  		}
>  	}
> @@ -279,7 +279,7 @@ static u8 bcma_find_pci_capability(struct bcma_drv_pci *pc, unsigned int dev,
>  	/* check for Header type 0 */
>  	bcma_extpci_read_config(pc, dev, func, PCI_HEADER_TYPE, &byte_val,
>  				sizeof(u8));
> -	if ((byte_val & 0x7f) != PCI_HEADER_TYPE_NORMAL)
> +	if ((byte_val & 0x7F) != PCI_HEADER_TYPE_NORMAL)
>  		return cap_ptr;
>  
>  	/* check if the capability pointer field exists */
> 

