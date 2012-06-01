Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:2659 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758621Ab2FAH6t (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Jun 2012 03:58:49 -0400
Message-ID: <4FC8762D.8090807@broadcom.com> (sfid-20120601_095852_809260_558AB288)
Date: Fri, 1 Jun 2012 09:58:37 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Hauke Mehrtens" <hauke@hauke-m.de>
cc: linville@tuxdriver.com, zajec5@gmail.com,
	b43-dev@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] bcma: make some functions static
References: <1338496859-16436-1-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1338496859-16436-1-git-send-email-hauke@hauke-m.de>
Content-Type: text/plain;
 charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/31/2012 10:40 PM, Hauke Mehrtens wrote:
> The functions and structs are not used in an other file and the
> prototypes are in no header file, just make them static so the compiler
> is able to optimize them better.
> 
> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
> ---
> diff --git a/drivers/bcma/host_pci.c b/drivers/bcma/host_pci.c
> index 6c05cf4..f7fbae7 100644
> --- a/drivers/bcma/host_pci.c
> +++ b/drivers/bcma/host_pci.c
> @@ -77,8 +77,8 @@ static void bcma_host_pci_write32(struct bcma_device *core, u16 offset,
>  }
>  
>  #ifdef CONFIG_BCMA_BLOCKIO
> -void bcma_host_pci_block_read(struct bcma_device *core, void *buffer,
> -			      size_t count, u16 offset, u8 reg_width)
> +static void bcma_host_pci_block_read(struct bcma_device *core, void *buffer,
> +				     size_t count, u16 offset, u8 reg_width)

align this with struct keyword above.

>  {
>  	void __iomem *addr = core->bus->mmio + offset;
>  	if (core->bus->mapped_core != core)
> @@ -100,8 +100,9 @@ void bcma_host_pci_block_read(struct bcma_device *core, void *buffer,
>  	}
>  }
>  
> -void bcma_host_pci_block_write(struct bcma_device *core, const void *buffer,
> -			       size_t count, u16 offset, u8 reg_width)
> +static void bcma_host_pci_block_write(struct bcma_device *core,
> +				      const void *buffer, size_t count,
> +				      u16 offset, u8 reg_width)

same here. checkpatch also spews warnings about DOS line endings.

Gr. AvS

