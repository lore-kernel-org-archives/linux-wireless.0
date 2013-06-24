Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f175.google.com ([74.125.82.175]:55560 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750964Ab3FXR36 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Jun 2013 13:29:58 -0400
Received: by mail-we0-f175.google.com with SMTP id t59so8236783wes.6
        for <linux-wireless@vger.kernel.org>; Mon, 24 Jun 2013 10:29:57 -0700 (PDT)
References: <1371911519-13135-1-git-send-email-juhosg@openwrt.org> <1371911519-13135-2-git-send-email-juhosg@openwrt.org>
Mime-Version: 1.0 (1.0)
In-Reply-To: <1371911519-13135-2-git-send-email-juhosg@openwrt.org>
Content-Type: text/plain;
	charset=us-ascii
Message-Id: <CEA89371-4BFB-4663-BD89-FAE3E1D176D2@gmail.com> (sfid-20130624_193002_254684_342B492A)
Cc: John Linville <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"users@rt2x00.serialmonkey.com" <users@rt2x00.serialmonkey.com>,
	Gabor Juhos <juhosg@openwrt.org>
From: Gertjan van Wingerde <gwingerde@gmail.com>
Subject: Re: [PATCH 2/2] rt2x00: rt2800: unify [RT]XWI_SIZE defines
Date: Mon, 24 Jun 2013 19:29:54 +0200
To: Gabor Juhos <juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



Sent from my iPad

On 22 jun. 2013, at 16:31, Gabor Juhos <juhosg@openwrt.org> wrote:

> Use common names instead of chip specific ones.
> The patch contains no functional changes, but
> it makes it easier to add support for further
> descriptor sizes.
> 
> Signed-off-by: Gabor Juhos <juhosg@openwrt.org>

Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>

> ---
> drivers/net/wireless/rt2x00/rt2800.h    |   10 ++++++----
> drivers/net/wireless/rt2x00/rt2800pci.c |    6 +++---
> drivers/net/wireless/rt2x00/rt2800usb.c |    8 ++++----
> 3 files changed, 13 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/net/wireless/rt2x00/rt2800.h b/drivers/net/wireless/rt2x00/rt2800.h
> index a7630d5..fe43d01 100644
> --- a/drivers/net/wireless/rt2x00/rt2800.h
> +++ b/drivers/net/wireless/rt2x00/rt2800.h
> @@ -2625,11 +2625,13 @@ struct mac_iveiv_entry {
> /*
>  * DMA descriptor defines.
>  */
> -#define TXWI_DESC_SIZE            (4 * sizeof(__le32))
> -#define RXWI_DESC_SIZE            (4 * sizeof(__le32))
> 
> -#define TXWI_DESC_SIZE_5592        (5 * sizeof(__le32))
> -#define RXWI_DESC_SIZE_5592        (6 * sizeof(__le32))
> +#define TXWI_DESC_SIZE_4WORDS        (4 * sizeof(__le32))
> +#define TXWI_DESC_SIZE_5WORDS        (5 * sizeof(__le32))
> +
> +#define RXWI_DESC_SIZE_4WORDS        (4 * sizeof(__le32))
> +#define RXWI_DESC_SIZE_6WORDS        (6 * sizeof(__le32))
> +
> /*
>  * TX WI structure
>  */
> diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
> index e664918..0005562 100644
> --- a/drivers/net/wireless/rt2x00/rt2800pci.c
> +++ b/drivers/net/wireless/rt2x00/rt2800pci.c
> @@ -1194,7 +1194,7 @@ static void rt2800pci_queue_init(struct data_queue *queue)
>        queue->limit = 128;
>        queue->data_size = AGGREGATION_SIZE;
>        queue->desc_size = RXD_DESC_SIZE;
> -        queue->winfo_size = RXWI_DESC_SIZE;
> +        queue->winfo_size = RXWI_DESC_SIZE_4WORDS;
>        queue->priv_size = sizeof(struct queue_entry_priv_mmio);
>        break;
> 
> @@ -1205,7 +1205,7 @@ static void rt2800pci_queue_init(struct data_queue *queue)
>        queue->limit = 64;
>        queue->data_size = AGGREGATION_SIZE;
>        queue->desc_size = TXD_DESC_SIZE;
> -        queue->winfo_size = TXWI_DESC_SIZE;
> +        queue->winfo_size = TXWI_DESC_SIZE_4WORDS;
>        queue->priv_size = sizeof(struct queue_entry_priv_mmio);
>        break;
> 
> @@ -1213,7 +1213,7 @@ static void rt2800pci_queue_init(struct data_queue *queue)
>        queue->limit = 8;
>        queue->data_size = 0; /* No DMA required for beacons */
>        queue->desc_size = TXD_DESC_SIZE;
> -        queue->winfo_size = TXWI_DESC_SIZE;
> +        queue->winfo_size = TXWI_DESC_SIZE_4WORDS;
>        queue->priv_size = sizeof(struct queue_entry_priv_mmio);
>        break;
> 
> diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
> index 7edd903..840833b 100644
> --- a/drivers/net/wireless/rt2x00/rt2800usb.c
> +++ b/drivers/net/wireless/rt2x00/rt2800usb.c
> @@ -855,11 +855,11 @@ static void rt2800usb_queue_init(struct data_queue *queue)
>    unsigned short txwi_size, rxwi_size;
> 
>    if (rt2x00_rt(rt2x00dev, RT5592)) {
> -        txwi_size = TXWI_DESC_SIZE_5592;
> -        rxwi_size = RXWI_DESC_SIZE_5592;
> +        txwi_size = TXWI_DESC_SIZE_5WORDS;
> +        rxwi_size = RXWI_DESC_SIZE_6WORDS;
>    } else {
> -        txwi_size = TXWI_DESC_SIZE;
> -        rxwi_size = RXWI_DESC_SIZE;
> +        txwi_size = TXWI_DESC_SIZE_4WORDS;
> +        rxwi_size = RXWI_DESC_SIZE_4WORDS;
>    }
> 
>    switch (queue->qid) {
> -- 
> 1.7.10
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
