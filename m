Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:56060 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758246Ab2HVSPP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Aug 2012 14:15:15 -0400
Date: Wed, 22 Aug 2012 14:13:24 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] bcma: handle BCM43227
Message-ID: <20120822181324.GB14913@tuxdriver.com> (sfid-20120822_201519_177924_8216A680)
References: <1345277555-13013-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1345277555-13013-1-git-send-email-zajec5@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

What are the prerequisite patches for this one?  It seems to be based
on something other than wireless-next.

John

On Sat, Aug 18, 2012 at 10:12:35AM +0200, Rafał Miłecki wrote:
> 
> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
> Tested-by: Jack <x6719620@gmail.com>
> ---
>  drivers/bcma/host_pci.c |    1 +
>  drivers/bcma/sprom.c    |    2 ++
>  2 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/bcma/host_pci.c b/drivers/bcma/host_pci.c
> index f7b0af7..b6b4b5e 100644
> --- a/drivers/bcma/host_pci.c
> +++ b/drivers/bcma/host_pci.c
> @@ -273,6 +273,7 @@ static DEFINE_PCI_DEVICE_TABLE(bcma_pci_bridge_tbl) = {
>  	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x4331) },
>  	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x4353) },
>  	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x4357) },
> +	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x4358) },
>  	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x4359) },
>  	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x4727) },
>  	{ 0, },
> diff --git a/drivers/bcma/sprom.c b/drivers/bcma/sprom.c
> index 9ea4627..0d546b6 100644
> --- a/drivers/bcma/sprom.c
> +++ b/drivers/bcma/sprom.c
> @@ -507,7 +507,9 @@ static bool bcma_sprom_onchip_available(struct bcma_bus *bus)
>  		/* for these chips OTP is always available */
>  		present = true;
>  		break;
> +	case BCMA_CHIP_ID_BCM43227:
>  	case BCMA_CHIP_ID_BCM43228:
> +	case BCMA_CHIP_ID_BCM43428:
>  		present = chip_status & BCMA_CC_CHIPST_43228_OTP_PRESENT;
>  		break;
>  	default:
> -- 
> 1.7.7
> 
> 

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
