Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:7810 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752231AbbC2Qpw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 29 Mar 2015 12:45:52 -0400
Message-ID: <55182C3A.7020302@broadcom.com> (sfid-20150329_184613_546699_A632E79D)
Date: Sun, 29 Mar 2015 18:45:46 +0200
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: <linux-kernel@vger.kernel.org>,
	Brett Rudley <brudley@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Hante Meuleman <meuleman@broadcom.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	"Pieter-Paul Giesberts" <pieterpg@broadcom.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Hans de Goede <hdegoede@redhat.com>,
	"Daniel (Deognyoun) Kim" <dekim@broadcom.com>,
	=?UTF-8?B?UmFmYcWCIE1pxYJl?= =?UTF-8?B?Y2tp?= <zajec5@gmail.com>,
	Julia Lawall <Julia.Lawall@lip6.fr>,
	Brian Norris <computersforpeace@gmail.com>,
	Dan Carpenter <dan.carpenter@oracle.com>,
	Markus Elfring <elfring@users.sourceforge.net>,
	<linux-wireless@vger.kernel.org>,
	<brcm80211-dev-list@broadcom.com>, <netdev@vger.kernel.org>
Subject: Re: [PATCH 57/86] brcm80211: use uapi/linux/pci_ids.h directly
References: <1427635734-24786-1-git-send-email-mst@redhat.com> <1427635734-24786-58-git-send-email-mst@redhat.com>
In-Reply-To: <1427635734-24786-58-git-send-email-mst@redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/29/15 15:41, Michael S. Tsirkin wrote:
> Header moved from linux/pci_ids.h to uapi/linux/pci_ids.h,
> use the new header directly so we can drop
> the wrapper in include/linux/pci_ids.h.

Acked-by: Arend van Spriel <arend@broadcom.com>
> Signed-off-by: Michael S. Tsirkin<mst@redhat.com>
> ---
>   drivers/net/wireless/brcm80211/include/brcm_hw_ids.h | 2 +-
>   drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c     | 2 +-
>   drivers/net/wireless/brcm80211/brcmfmac/sdio.c       | 2 +-
>   drivers/net/wireless/brcm80211/brcmsmac/main.c       | 2 +-
>   4 files changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/net/wireless/brcm80211/include/brcm_hw_ids.h b/drivers/net/wireless/brcm80211/include/brcm_hw_ids.h
> index 2124a17..bd1370e 100644
> --- a/drivers/net/wireless/brcm80211/include/brcm_hw_ids.h
> +++ b/drivers/net/wireless/brcm80211/include/brcm_hw_ids.h
> @@ -17,7 +17,7 @@
>   #ifndef	_BRCM_HW_IDS_H_
>   #define	_BRCM_HW_IDS_H_
>
> -#include<linux/pci_ids.h>
> +#include<uapi/linux/pci_ids.h>
>   #include<linux/mmc/sdio_ids.h>
>
>   #define BRCM_USB_VENDOR_ID_BROADCOM	0x0a5c
> diff --git a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
> index 7944224..227cb33 100644
> --- a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
> +++ b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
> @@ -18,7 +18,7 @@
>   #include<linux/types.h>
>   #include<linux/netdevice.h>
>   #include<linux/pci.h>
> -#include<linux/pci_ids.h>
> +#include<uapi/linux/pci_ids.h>

I was surprised seeing this include here, but you deal with that in 
subsequent patches. Thanks.

Regards,
Arend
