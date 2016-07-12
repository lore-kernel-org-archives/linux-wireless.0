Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42434 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750780AbcGLSsK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Jul 2016 14:48:10 -0400
Date: Tue, 12 Jul 2016 20:48:02 +0200
From: Igor Mammedov <imammedo@redhat.com>
To: =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Cc: Kalle Valo <kvalo@codeaurora.org>, Stable <stable@vger.kernel.org>,
	linux-wireless@vger.kernel.org (open list:BROADCOM SPECIFIC AMBA DRIVER
	(BCMA)), linux-kernel@vger.kernel.org (open list)
Subject: Re: [PATCH FIX 4.6+] bcma: add PCI ID for Foxconn's BCM43142 device
Message-ID: <20160712204803.77bf3c59@igors-macbook-pro.local> (sfid-20160712_204834_720996_93A43EB2)
In-Reply-To: <1468270896-2988-1-git-send-email-zajec5@gmail.com>
References: <1468270896-2988-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 11 Jul 2016 23:01:36 +0200
Rafał Miłecki <zajec5@gmail.com> wrote:

> After discovering there are 2 very different 14e4:4365 PCI devices we
> made ID tables less generic. Back then we believed there are only 2
> such devices:
> 1) 14e4:4365 1028:0016 with SoftMAC BCM43142 chipset
> 2) 14e4:4365 14e4:4365 with FullMAC BCM4366 chipset
> 
> From the recent report it appears there is also 14e4:4365 105b:e092
> which should be claimed by bcma. Add back support for it.
> 
> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=121881
> Fixes: 515b399c9a20 ("bcma: claim only 14e4:4365 PCI Dell card with
> SoftMAC BCM43142") Reported-by: Igor Mammedov <imammedo@redhat.com>
> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
> Cc: Stable <stable@vger.kernel.org> [4.6+]
Tested-by: Igor Mammedov <imammedo@redhat.com>

> ---
>  drivers/bcma/host_pci.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/bcma/host_pci.c b/drivers/bcma/host_pci.c
> index cae5385..bd46569 100644
> --- a/drivers/bcma/host_pci.c
> +++ b/drivers/bcma/host_pci.c
> @@ -295,6 +295,7 @@ static const struct pci_device_id
> bcma_pci_bridge_tbl[] = { { PCI_DEVICE(PCI_VENDOR_ID_BROADCOM,
> 0x4359) }, { PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x4360) },
>  	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_BROADCOM, 0x4365,
> PCI_VENDOR_ID_DELL, 0x0016) },
> +	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_BROADCOM, 0x4365,
> PCI_VENDOR_ID_FOXCONN, 0xe092) },
> { PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x43a0) },
> { PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x43a9) },
> { PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x43aa) },

