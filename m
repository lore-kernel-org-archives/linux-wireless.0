Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:54629 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753292Ab3ALOQo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 Jan 2013 09:16:44 -0500
Message-ID: <50F17041.6050309@hauke-m.de> (sfid-20130112_151648_758105_FF4ECDE7)
Date: Sat, 12 Jan 2013 15:16:33 +0100
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: Nathan Hintz <nlhintz@hotmail.com>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/5] bcma: delete duplicate readl
References: <1357987577-20661-1-git-send-email-nlhintz@hotmail.com> <BLU0-SMTP98CC9B048B90AD9E8ECA82AC280@phx.gbl>
In-Reply-To: <BLU0-SMTP98CC9B048B90AD9E8ECA82AC280@phx.gbl>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/12/2013 11:46 AM, Nathan Hintz wrote:
> The 'val' has already been read by the prior call to 'mips_busprobe32';
> this 'readl' is unnecessary.
> 
> Signed-off-by: Nathan Hintz <nlhintz@hotmail.com>

Acked-by: Hauke Mehrtens <hauke@hauke-m.de>

> ---
>  drivers/bcma/driver_pci_host.c |    2 --
>  1 files changed, 0 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/bcma/driver_pci_host.c b/drivers/bcma/driver_pci_host.c
> index 536d353..56073a5 100644
> --- a/drivers/bcma/driver_pci_host.c
> +++ b/drivers/bcma/driver_pci_host.c
> @@ -122,8 +122,6 @@ static int bcma_extpci_read_config(struct bcma_drv_pci *pc, unsigned int dev,
>  			val = 0xffffffff;
>  			goto unmap;
>  		}
> -
> -		val = readl(mmio);
>  	}
>  	val >>= (8 * (off & 3));
>  
> 

