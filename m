Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f170.google.com ([209.85.214.170]:46405 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752091AbaBFUdQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Feb 2014 15:33:16 -0500
Received: by mail-ob0-f170.google.com with SMTP id va2so2889642obc.1
        for <linux-wireless@vger.kernel.org>; Thu, 06 Feb 2014 12:33:16 -0800 (PST)
Message-ID: <52F3F18A.1020301@lwfinger.net> (sfid-20140206_213320_181079_7DB727D0)
Date: Thu, 06 Feb 2014 14:33:14 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: andrea merello <andrea.merello@gmail.com>, linville@tuxdriver.com
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2/4]  Add error check for pci_map_single return value
 in rtl8180 RX path
References: <1391636287-17712-1-git-send-email-andrea.merello@gmail.com> <1391636287-17712-3-git-send-email-andrea.merello@gmail.com>
In-Reply-To: <1391636287-17712-3-git-send-email-andrea.merello@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/05/2014 03:38 PM, andrea merello wrote:
> From: "andrea.merello" <andrea.merello@gmail.com>
>
> In original code the old RX DMA buffer is unmapped and processed and at the end
> of the isr a new buffer is mapped with pci_map_single and attached to the RX
> descriptor.
>
> If pci_map_single fails then the RX descriptor remains with no valid DMA buffer
> attached.
> In this condition the DMA will target where it shouldn't with obvious evil
> consequences.
>
> Simply avoiding re-arming the descriptor will prevent buggy DMA but it will
> result soon in RX stuck.
>
> This patch move the DMA mapping of the new buffer at the beginning of the ISR
> (and it adds error check for pci_map_single success/fail).
>
> If the DMA mapping fails then we do not unmap the old buffer and we re-arm the
> descriptor without processing it, with the old DMA buffer still attached.
>
> In this way we lose the currently RX-ed packet, but whenever next calls to
> pci_map_single will succeed again,then the RX process will go on without stuck.
>
> Signed-off-by: andrea.merello <andrea.merello@gmail.com>
> Signed-off-by: andrea merello <andrea.merello@gmail.com>

I have no way to test this patch, but it looks OK.

Larry

> ---
>   drivers/net/wireless/rtl818x/rtl8180/dev.c | 16 +++++++++++++---
>   1 file changed, 13 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/net/wireless/rtl818x/rtl8180/dev.c b/drivers/net/wireless/rtl818x/rtl8180/dev.c
> index 79b9398..1c6ac25 100644
> --- a/drivers/net/wireless/rtl818x/rtl8180/dev.c
> +++ b/drivers/net/wireless/rtl818x/rtl8180/dev.c
> @@ -107,6 +107,7 @@ static void rtl8180_handle_rx(struct ieee80211_hw *dev)
>   	struct rtl8180_priv *priv = dev->priv;
>   	unsigned int count = 32;
>   	u8 signal, agc, sq;
> +	dma_addr_t mapping;
>
>   	while (count--) {
>   		struct rtl8180_rx_desc *entry = &priv->rx_ring[priv->rx_idx];
> @@ -128,6 +129,17 @@ static void rtl8180_handle_rx(struct ieee80211_hw *dev)
>   			if (unlikely(!new_skb))
>   				goto done;
>
> +			mapping = pci_map_single(priv->pdev,
> +					       skb_tail_pointer(new_skb),
> +					       MAX_RX_SIZE, PCI_DMA_FROMDEVICE);
> +
> +			if (pci_dma_mapping_error(priv->pdev, mapping)) {
> +				kfree_skb(new_skb);
> +				dev_err(&priv->pdev->dev, "RX DMA map error\n");
> +
> +				goto done;
> +			}
> +
>   			pci_unmap_single(priv->pdev,
>   					 *((dma_addr_t *)skb->cb),
>   					 MAX_RX_SIZE, PCI_DMA_FROMDEVICE);
> @@ -158,9 +170,7 @@ static void rtl8180_handle_rx(struct ieee80211_hw *dev)
>
>   			skb = new_skb;
>   			priv->rx_buf[priv->rx_idx] = skb;
> -			*((dma_addr_t *) skb->cb) =
> -				pci_map_single(priv->pdev, skb_tail_pointer(skb),
> -					       MAX_RX_SIZE, PCI_DMA_FROMDEVICE);
> +			*((dma_addr_t *) skb->cb) = mapping;
>   		}
>
>   	done:
>

