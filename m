Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:48215 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755034Ab0HMPpr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Aug 2010 11:45:47 -0400
Subject: Re: [PATCH] ath5k: disable ASPM L0s for all cards
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ath5k-devel@lists.ath5k.org, linux-kernel@vger.kernel.org,
	David Quan <David.Quan@atheros.com>,
	Matthew Garrett <mjg59@srcf.ucam.org>,
	Tim Gardner <tim.gardner@canonical.com>,
	Jussi Kivilinna <jussi.kivilinna@mbnet.fi>, stable@kernel.org
In-Reply-To: <1281713248-25761-1-git-send-email-lrodriguez@atheros.com>
References: <1281713248-25761-1-git-send-email-lrodriguez@atheros.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 13 Aug 2010 18:45:39 +0300
Message-ID: <1281714339.10222.3.camel@maxim-laptop>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2010-08-13 at 11:27 -0400, Luis R. Rodriguez wrote: 
> From: Maxim Levitsky <maximlevitsky@gmail.com>
> 
> Atheros PCIe wireless cards handled by ath5k do require L0s disabled.
> For distributions shipping with CONFIG_PCIEASPM (this will be enabled
> by default in the future in 2.6.36) this will also mean both L1 and L0s
> will be disabled when a pre 1.1 PCIe device is detected. We do know L1
> works correctly even for all ath5k pre 1.1 PCIe devices though but cannot
> currently undue the effect of a blacklist, for details you can read
> pcie_aspm_sanity_check() and see how it adjusts the device link
> capability.
> 
> It may be possible in the future to implement some PCI API to allow
> drivers to override blacklists for pre 1.1 PCIe but for now it is
> best to accept that both L0s and L1 will be disabled completely for
> distributions shipping with CONFIG_PCIEASPM rather than having this
> issue present. Motivation for adding this new API will be to help
> with power consumption for some of these devices.
> 
> Example of issues you'd see:
> 
>   - On the Acer Aspire One (AOA150, Atheros Communications Inc. AR5001
>     Wireless Network Adapter [168c:001c] (rev 01)) doesn't work well
>     with ASPM enabled, the card will eventually stall on heavy traffic
>     with often 'unsupported jumbo' warnings appearing. Disabling
>     ASPM L0s in ath5k fixes these problems.
> 
>   - On the same card you would see a storm of RXORN interrupts
>     even though medium is idle.
> 
> Credit for root causing and fixing the bug goes to Jussi Kivilinna.
> 
> Cc: David Quan <David.Quan@atheros.com>
> Cc: Matthew Garrett <mjg59@srcf.ucam.org>
> Cc: Tim Gardner <tim.gardner@canonical.com>
> Cc: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
> Cc: stable@kernel.org
> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
> Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
> ---
> 
> Maxim, it was just reported this patch never made it upstream
> so I just took the liberty to submit it and also clear up the
> commit log and comments a little more in terms of actual impact
> and possible future fixes. I've also Cc'd stable so this can
> get propagated down to 2.6.32 as well.
Sure. In fact I don't deserve much credit on this patch. It is just one
line and besides ASPM is disabled anyway.

Thanks for Jussi Kivilinna again for finding this.

Best regards,
Maxim Levitsky


> 
>  drivers/net/wireless/ath/ath5k/base.c |   21 +++++++++++++++++++++
>  1 files changed, 21 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
> index 0d5de25..373dcfe 100644
> --- a/drivers/net/wireless/ath/ath5k/base.c
> +++ b/drivers/net/wireless/ath/ath5k/base.c
> @@ -48,6 +48,7 @@
>  #include <linux/netdevice.h>
>  #include <linux/cache.h>
>  #include <linux/pci.h>
> +#include <linux/pci-aspm.h>
>  #include <linux/ethtool.h>
>  #include <linux/uaccess.h>
>  #include <linux/slab.h>
> @@ -476,6 +477,26 @@ ath5k_pci_probe(struct pci_dev *pdev,
>  	int ret;
>  	u8 csz;
>  
> +	/*
> +	 * L0s needs to be disabled on all ath5k cards.
> +	 *
> +	 * For distributions shipping with CONFIG_PCIEASPM (this will be enabled
> +	 * by default in the future in 2.6.36) this will also mean both L1 and
> +	 * L0s will be disabled when a pre 1.1 PCIe device is detected. We do
> +	 * know L1 works correctly even for all ath5k pre 1.1 PCIe devices
> +	 * though but cannot currently undue the effect of a blacklist, for
> +	 * details you can read pcie_aspm_sanity_check() and see how it adjusts
> +	 * the device link capability.
> +	 *
> +	 * It may be possible in the future to implement some PCI API to allow
> +	 * drivers to override blacklists for pre 1.1 PCIe but for now it is
> +	 * best to accept that both L0s and L1 will be disabled completely for
> +	 * distributions shipping with CONFIG_PCIEASPM rather than having this
> +	 * issue present. Motivation for adding this new API will be to help
> +	 * with power consumption for some of these devices.
> +	 */
> +	pci_disable_link_state(pdev, PCIE_LINK_STATE_L0S);
> +
>  	ret = pci_enable_device(pdev);
>  	if (ret) {
>  		dev_err(&pdev->dev, "can't enable device\n");


