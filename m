Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpb-ews10.kpnxchange.com ([213.75.39.15]:1460 "EHLO
	cpsmtpb-ews10.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758062Ab0LUHmL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Dec 2010 02:42:11 -0500
Message-ID: <4D105A51.9070702@gmail.com>
Date: Tue, 21 Dec 2010 08:42:09 +0100
From: Gertjan van Wingerde <gwingerde@gmail.com>
MIME-Version: 1.0
To: Hauke Mehrtens <hauke@hauke-m.de>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Ivo van Doorn <IvDoorn@gmail.com>
Subject: Re: [PATCH 4/7] rt2x00: Use pci_is_pcie()
References: <1292893316-26694-1-git-send-email-hauke@hauke-m.de> <1292893316-26694-5-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1292893316-26694-5-git-send-email-hauke@hauke-m.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/21/10 02:01, Hauke Mehrtens wrote:
> Use function pci_is_pcie() instead of accessing struct member directly.
> 
> CC: Ivo van Doorn <IvDoorn@gmail.com>
> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>

Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>

> ---
>  drivers/net/wireless/rt2x00/rt2x00pci.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/net/wireless/rt2x00/rt2x00pci.c b/drivers/net/wireless/rt2x00/rt2x00pci.c
> index 28e6ff1..73631c6 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00pci.c
> +++ b/drivers/net/wireless/rt2x00/rt2x00pci.c
> @@ -286,7 +286,7 @@ int rt2x00pci_probe(struct pci_dev *pci_dev, const struct pci_device_id *id)
>  	rt2x00dev->irq = pci_dev->irq;
>  	rt2x00dev->name = pci_name(pci_dev);
>  
> -	if (pci_dev->is_pcie)
> +	if (pci_is_pcie(pci_dev))
>  		rt2x00_set_chip_intf(rt2x00dev, RT2X00_CHIP_INTF_PCIE);
>  	else
>  		rt2x00_set_chip_intf(rt2x00dev, RT2X00_CHIP_INTF_PCI);

