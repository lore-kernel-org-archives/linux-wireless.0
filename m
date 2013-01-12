Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:54722 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753387Ab3ALOo3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 Jan 2013 09:44:29 -0500
Message-ID: <50F176C3.2070200@hauke-m.de> (sfid-20130112_154432_550119_775D1558)
Date: Sat, 12 Jan 2013 15:44:19 +0100
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: Nathan Hintz <nlhintz@hotmail.com>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 4/5] bcma: add support for 1 and 2 byte extended config
 space access
References: <1357987577-20661-1-git-send-email-nlhintz@hotmail.com> <BLU0-SMTP989EDC8A841E1B9D693EC8AC280@phx.gbl>
In-Reply-To: <BLU0-SMTP989EDC8A841E1B9D693EC8AC280@phx.gbl>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/12/2013 11:46 AM, Nathan Hintz wrote:
> The sanity checks allow 1 and 2 byte reads/writes of the extended
> PCI config space to proceed; however, the code only supports 4
> byte reads/writes.  This patch adds support for 1 and 2 byte
> reads/writes of the extended PCI config space.
> 
> Signed-off-by: Nathan Hintz <nlhintz@hotmail.com>

Acked-by: Hauke Mehrtens <hauke@hauke-m.de>

> ---
>  drivers/bcma/driver_pci_host.c |   15 ++++++++-------
>  1 files changed, 8 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/bcma/driver_pci_host.c b/drivers/bcma/driver_pci_host.c
> index e1381ba..92800b4 100644
> --- a/drivers/bcma/driver_pci_host.c
> +++ b/drivers/bcma/driver_pci_host.c
> @@ -101,7 +101,7 @@ static int bcma_extpci_read_config(struct bcma_drv_pci *pc, unsigned int dev,
>  		 */
>  		if (off >= PCI_CONFIG_SPACE_SIZE) {
>  			addr = (func << 12);
> -			addr |= (off & 0x0FFF);
> +			addr |= (off & 0x0FFC);
>  			val = bcma_pcie_read_config(pc, addr);
>  		} else {
>  			addr = BCMA_CORE_PCI_PCICFG0;
> @@ -164,7 +164,11 @@ static int bcma_extpci_write_config(struct bcma_drv_pci *pc, unsigned int dev,
>  		/* accesses to config registers with offsets >= 256
>  		 * requires indirect access.
>  		 */
> -		if (off < PCI_CONFIG_SPACE_SIZE) {
> +		if (off >= PCI_CONFIG_SPACE_SIZE) {
> +			addr = (func << 12);
> +			addr |= (off & 0x0FFC);
> +			val = bcma_pcie_read_config(pc, addr);
> +		} else {
>  			addr = BCMA_CORE_PCI_PCICFG0;
>  			addr |= (func << 8);
>  			addr |= (off & 0xfc);
> @@ -202,13 +206,10 @@ static int bcma_extpci_write_config(struct bcma_drv_pci *pc, unsigned int dev,
>  		/* accesses to config registers with offsets >= 256
>  		 * requires indirect access.
>  		 */
> -		if (off >= PCI_CONFIG_SPACE_SIZE) {
> -			addr = (func << 12);
> -			addr |= (off & 0x0FFF);
> +		if (off >= PCI_CONFIG_SPACE_SIZE)
>  			bcma_pcie_write_config(pc, addr, val);
> -		} else {
> +		else
>  			pcicore_write32(pc, addr, val);
> -		}
>  	} else {
>  		writel(val, mmio);
>  
> 

