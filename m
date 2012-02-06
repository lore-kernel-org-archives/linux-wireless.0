Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:32355 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754041Ab2BFQll (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Feb 2012 11:41:41 -0500
Subject: Re: [RFC 4/4] iwlwifi: use writeb,writel,readl directly
From: wwguy <wey-yi.w.guy@intel.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Intel Linux Wireless <ilw@linux.intel.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1328544564-8696-4-git-send-email-sgruszka@redhat.com>
References: <1328544564-8696-1-git-send-email-sgruszka@redhat.com>
	 <1328544564-8696-4-git-send-email-sgruszka@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 06 Feb 2012 08:32:52 -0800
Message-ID: <1328545972.14547.15.camel@wwguy-ubuntu> (sfid-20120206_174144_635214_0CA252E8)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-02-06 at 17:09 +0100, Stanislaw Gruszka wrote:
> That will save us some CPU cycles at run time.
> 
> Obviously I do not think port-based IO is possible, but I added
> check for that during probe just in case.
> 
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> ---
>  drivers/net/wireless/iwlwifi/iwl-pci.c |   12 ++++++++----
>  1 files changed, 8 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/wireless/iwlwifi/iwl-pci.c b/drivers/net/wireless/iwlwifi/iwl-pci.c
> index 03702a2..32b326d 100644
> --- a/drivers/net/wireless/iwlwifi/iwl-pci.c
> +++ b/drivers/net/wireless/iwlwifi/iwl-pci.c
> @@ -153,18 +153,17 @@ static u32 iwl_pci_get_hw_id(struct iwl_bus *bus)
>  
>  static void iwl_pci_write8(struct iwl_bus *bus, u32 ofs, u8 val)
>  {
> -	iowrite8(val, IWL_BUS_GET_PCI_BUS(bus)->hw_base + ofs);
> +	writeb(val, IWL_BUS_GET_PCI_BUS(bus)->hw_base + ofs);
>  }
>  
>  static void iwl_pci_write32(struct iwl_bus *bus, u32 ofs, u32 val)
>  {
> -	iowrite32(val, IWL_BUS_GET_PCI_BUS(bus)->hw_base + ofs);
> +	writel(val, IWL_BUS_GET_PCI_BUS(bus)->hw_base + ofs);
>  }
>  http://www.gossamer-threads.com/lists/linux/kernel/960145
>  static u32 iwl_pci_read32(struct iwl_bus *bus, u32 ofs)
>  {
> -	u32 val = ioread32(IWL_BUS_GET_PCI_BUS(bus)->hw_base + ofs);
> -	return val;
> +	return readl(IWL_BUS_GET_PCI_BUS(bus)->hw_base + ofs);
>  }
>  
>  static const struct iwl_bus_ops bus_ops_pci = {
> @@ -417,6 +416,11 @@ static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
>  		goto out_pci_disable_device;
>  	}
>  
> +	if (pci_resource_flags(pdev, 0) & IORESOURCE_IO) {
> +		dev_printk(KERN_ERR, bus->dev, "not supported I/O method");
> +		goto out_pci_disable_device;
> +	}
> +
>  	pci_bus->hw_base = pci_iomap(pdev, 0, 0);
>  	if (!pci_bus->hw_base) {
>  		dev_printk(KERN_ERR, bus->dev, "pci_iomap failed");

I believe iwl driver were use readl/writel before switch to
ioread32/iowrite32 (long time ago)

http://www.gossamer-threads.com/lists/linux/kernel/960145

also, AFAIK, the readl/writel IO functions still works but their use in
new code is discouraged.

Wey
 



