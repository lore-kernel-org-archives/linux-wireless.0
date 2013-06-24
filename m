Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f175.google.com ([74.125.82.175]:38823 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750964Ab3FXR3M convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Jun 2013 13:29:12 -0400
Received: by mail-we0-f175.google.com with SMTP id t59so8236166wes.6
        for <linux-wireless@vger.kernel.org>; Mon, 24 Jun 2013 10:29:11 -0700 (PDT)
References: <1371911519-13135-1-git-send-email-juhosg@openwrt.org>
Mime-Version: 1.0 (1.0)
In-Reply-To: <1371911519-13135-1-git-send-email-juhosg@openwrt.org>
Content-Type: text/plain;
	charset=us-ascii
Message-Id: <C2F193F2-5A6C-4143-A750-AB02BC570F5E@gmail.com> (sfid-20130624_192916_604536_E0AAA868)
Cc: John Linville <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"users@rt2x00.serialmonkey.com" <users@rt2x00.serialmonkey.com>,
	Gabor Juhos <juhosg@openwrt.org>
From: Gertjan van Wingerde <gwingerde@gmail.com>
Subject: Re: [PATCH 1/2] rt2x00: rt2800pci: don't use TXWI_DESC_SIZE directly
Date: Mon, 24 Jun 2013 19:29:07 +0200
To: Gabor Juhos <juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



Sent from my iPad

On 22 jun. 2013, at 16:31, Gabor Juhos <juhosg@openwrt.org> wrote:

> Different chipsets may use different TXWI descriptor
> size. Instead of using a hardcoded value, use the
> 'queue->winfo_size' which holds the correct value for
> a given device.
> 
> Signed-off-by: Gabor Juhos <juhosg@openwrt.org>

Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>

> ---
> drivers/net/wireless/rt2x00/rt2800pci.c |    5 +++--
> 1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
> index 7c74782..e664918 100644
> --- a/drivers/net/wireless/rt2x00/rt2800pci.c
> +++ b/drivers/net/wireless/rt2x00/rt2800pci.c
> @@ -637,6 +637,7 @@ static void rt2800pci_write_tx_desc(struct queue_entry *entry,
>    struct queue_entry_priv_mmio *entry_priv = entry->priv_data;
>    __le32 *txd = entry_priv->desc;
>    u32 word;
> +    const unsigned int txwi_size = entry->queue->winfo_size;
> 
>    /*
>     * The buffers pointed by SD_PTR0/SD_LEN0 and SD_PTR1/SD_LEN1
> @@ -659,14 +660,14 @@ static void rt2800pci_write_tx_desc(struct queue_entry *entry,
>               !test_bit(ENTRY_TXD_MORE_FRAG, &txdesc->flags));
>    rt2x00_set_field32(&word, TXD_W1_BURST,
>               test_bit(ENTRY_TXD_BURST, &txdesc->flags));
> -    rt2x00_set_field32(&word, TXD_W1_SD_LEN0, TXWI_DESC_SIZE);
> +    rt2x00_set_field32(&word, TXD_W1_SD_LEN0, txwi_size);
>    rt2x00_set_field32(&word, TXD_W1_LAST_SEC0, 0);
>    rt2x00_set_field32(&word, TXD_W1_DMA_DONE, 0);
>    rt2x00_desc_write(txd, 1, word);
> 
>    word = 0;
>    rt2x00_set_field32(&word, TXD_W2_SD_PTR1,
> -               skbdesc->skb_dma + TXWI_DESC_SIZE);
> +               skbdesc->skb_dma + txwi_size);
>    rt2x00_desc_write(txd, 2, word);
> 
>    word = 0;
> -- 
> 1.7.10
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
