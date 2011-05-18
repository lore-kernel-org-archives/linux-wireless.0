Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1296 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756860Ab1ERKj3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 May 2011 06:39:29 -0400
Message-ID: <4DD3A1CD.3040304@broadcom.com> (sfid-20110518_123932_187136_B86A5C38)
Date: Wed, 18 May 2011 12:39:09 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH] bcma: pci: implement enabling interrupts
References: <1305716294-5753-1-git-send-email-zajec5@gmail.com>
In-Reply-To: <1305716294-5753-1-git-send-email-zajec5@gmail.com>
Content-Type: text/plain;
 charset=utf-8;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/18/2011 12:58 PM, Rafał Miłecki wrote:
> Signed-off-by: Rafał Miłecki<zajec5@gmail.com>
> ---
>   drivers/bcma/driver_pci.c |   18 ++++++++++++++++++
>   1 files changed, 18 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/bcma/driver_pci.c b/drivers/bcma/driver_pci.c
> index e757e4e..879fe1d 100644
> --- a/drivers/bcma/driver_pci.c
> +++ b/drivers/bcma/driver_pci.c
> @@ -161,3 +161,21 @@ void bcma_core_pci_init(struct bcma_drv_pci *pc)
>   {
>   	bcma_pcicore_serdes_workaround(pc);
>   }
> +
> +int bcma_core_pci_irq_enable(struct bcma_drv_pci *pc, struct bcma_device *core)
> +{
> +	struct pci_dev *pdev = pc->core->bus->host_pci;
> +	u32 coremask, tmp;
> +	int err;
> +
> +	coremask = BIT(core->core_index);
> +
> +	err = pci_read_config_dword(pdev, BCMA_PCI_IRQMASK,&tmp);
> +	if (err)
> +		goto out;
> +	tmp |= coremask<<  8;
> +	err = pci_write_config_dword(pdev, BCMA_PCI_IRQMASK, tmp);
> +
> +out:
> +	return err;
> +}
Hi Rafał,

Do you intend to have a disable as well?

Gr. AvS

-- 
Almost nobody dances sober, unless they happen to be insane.
-- H.P. Lovecraft --


