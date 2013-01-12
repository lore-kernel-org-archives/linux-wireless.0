Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:54694 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753292Ab3ALOjM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 Jan 2013 09:39:12 -0500
Message-ID: <50F17583.2000309@hauke-m.de> (sfid-20130112_153915_232835_0F85EFFC)
Date: Sat, 12 Jan 2013 15:38:59 +0100
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: Nathan Hintz <nlhintz@hotmail.com>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 3/5] bcma: don't map/unmap a subset of the PCI config
 space
References: <1357987577-20661-1-git-send-email-nlhintz@hotmail.com> <BLU0-SMTP98B4D57175D7A700330D59AC280@phx.gbl>
In-Reply-To: <BLU0-SMTP98B4D57175D7A700330D59AC280@phx.gbl>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/12/2013 11:46 AM, Nathan Hintz wrote:
> For PCI config space access offsets < 256 for device '0',
> bcma_extpci_write_config performs an 'ioremap_nocache' on a 4 byte
> section of the PCI config space (an area that has already
> previously been mapped), and then subsequently unmaps that 4 byte
> section.  This can't be a good thing for future read access from
> that now unmapped location.  Modify the config space writes to use
> the existing access functions (similar to how it is done for the reads).
> 
> Signed-off-by: Nathan Hintz <nlhintz@hotmail.com>
> ---
>  drivers/bcma/driver_pci_host.c |   22 +++++++++++-----------
>  1 files changed, 11 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/bcma/driver_pci_host.c b/drivers/bcma/driver_pci_host.c
> index 187cc9f..e1381ba 100644
> --- a/drivers/bcma/driver_pci_host.c
> +++ b/drivers/bcma/driver_pci_host.c
> @@ -149,7 +149,7 @@ static int bcma_extpci_write_config(struct bcma_drv_pci *pc, unsigned int dev,
>  				   const void *buf, int len)
>  {
>  	int err = -EINVAL;
> -	u32 addr = 0, val = 0;
> +	u32 addr, val;
>  	void __iomem *mmio = 0;
>  	u16 chipid = pc->core->bus->chipinfo.id;
>  
> @@ -165,12 +165,10 @@ static int bcma_extpci_write_config(struct bcma_drv_pci *pc, unsigned int dev,
>  		 * requires indirect access.
>  		 */
>  		if (off < PCI_CONFIG_SPACE_SIZE) {
> -			addr = pc->core->addr + BCMA_CORE_PCI_PCICFG0;
> +			addr = BCMA_CORE_PCI_PCICFG0;
>  			addr |= (func << 8);
>  			addr |= (off & 0xfc);
> -			mmio = ioremap_nocache(addr, sizeof(val));
> -			if (!mmio)
> -				goto out;
> +			val = pcicore_read32(pc, addr);
>  		}

off >= PCI_CONFIG_SPACE_SIZE is not handled here, but I think it should
be. This part of the function should use the same code as used in
bcma_extpci_read_config().

Your patch improves this, but I think there is an other flaw in the code.

>  	} else {
>  		addr = bcma_get_cfgspace_addr(pc, dev, func, off);
> @@ -189,12 +187,10 @@ static int bcma_extpci_write_config(struct bcma_drv_pci *pc, unsigned int dev,
>  
>  	switch (len) {
>  	case 1:
> -		val = readl(mmio);
>  		val &= ~(0xFF << (8 * (off & 3)));
>  		val |= *((const u8 *)buf) << (8 * (off & 3));
>  		break;
>  	case 2:
> -		val = readl(mmio);
>  		val &= ~(0xFFFF << (8 * (off & 3)));
>  		val |= *((const u16 *)buf) << (8 * (off & 3));
>  		break;
> @@ -202,13 +198,17 @@ static int bcma_extpci_write_config(struct bcma_drv_pci *pc, unsigned int dev,
>  		val = *((const u32 *)buf);
>  		break;
>  	}
> -	if (dev == 0 && !addr) {
> +	if (dev == 0) {
>  		/* accesses to config registers with offsets >= 256
>  		 * requires indirect access.
>  		 */
> -		addr = (func << 12);
> -		addr |= (off & 0x0FFF);
> -		bcma_pcie_write_config(pc, addr, val);
> +		if (off >= PCI_CONFIG_SPACE_SIZE) {
> +			addr = (func << 12);
> +			addr |= (off & 0x0FFF);
> +			bcma_pcie_write_config(pc, addr, val);
> +		} else {
> +			pcicore_write32(pc, addr, val);
> +		}
>  	} else {
>  		writel(val, mmio);
>  
> 

