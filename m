Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:33078 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754239Ab1BKBgD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Feb 2011 20:36:03 -0500
Received: by vxb37 with SMTP id 37so1073234vxb.19
        for <linux-wireless@vger.kernel.org>; Thu, 10 Feb 2011 17:36:02 -0800 (PST)
Message-ID: <4D5492BC.4030104@lwfinger.net>
Date: Thu, 10 Feb 2011 19:37:00 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Christian Lamparter <chunkeey@googlemail.com>
CC: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Subject: Re: [PATCH for-2.6.38] p54pci: update receive dma buffers before
 and after processing
References: <201102110148.43155.chunkeey@googlemail.com>
In-Reply-To: <201102110148.43155.chunkeey@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/10/2011 06:48 PM, Christian Lamparter wrote:
> Documentation/DMA-API-HOWTO.txt states:
> 
> "DMA transfers need to be synced properly in order for
> the cpu and device to see the most uptodate and correct
> copy of the DMA buffer."
> 
> Cc: <stable@kernel.org>
> Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
> ---
> Embarrassingly, this bug is unique to p54 and has been around
> since 2.6.25. This tells us something interesting about our
> userbase.

I do use it on a LE system that probably has coherent DMA. Did someone run into
this bug?

> ---
> diff --git a/drivers/net/wireless/p54/p54pci.c b/drivers/net/wireless/p54/p54pci.c
> index 1eacba4..0494d7b 100644
> --- a/drivers/net/wireless/p54/p54pci.c
> +++ b/drivers/net/wireless/p54/p54pci.c
> @@ -199,6 +199,7 @@ static void p54p_check_rx_ring(struct ieee80211_hw *dev, u32 *index,
>  	while (i != idx) {
>  		u16 len;
>  		struct sk_buff *skb;
> +		dma_addr_t dma_addr;
>  		desc = &ring[i];
>  		len = le16_to_cpu(desc->len);
>  		skb = rx_buf[i];
> @@ -216,17 +217,20 @@ static void p54p_check_rx_ring(struct ieee80211_hw *dev, u32 *index,
>  
>  			len = priv->common.rx_mtu;
>  		}
> +		dma_addr = le32_to_cpu(desc->host_addr);
> +		pci_dma_sync_single_for_cpu(priv->pdev, dma_addr,
> +			priv->common.rx_mtu + 32, PCI_DMA_FROMDEVICE);
>  		skb_put(skb, len);
>  
>  		if (p54_rx(dev, skb)) {
> -			pci_unmap_single(priv->pdev,
> -					 le32_to_cpu(desc->host_addr),
> -					 priv->common.rx_mtu + 32,
> -					 PCI_DMA_FROMDEVICE);
> +			pci_unmap_single(priv->pdev, dma_addr,
> +				priv->common.rx_mtu + 32, PCI_DMA_FROMDEVICE);
>  			rx_buf[i] = NULL;
> -			desc->host_addr = 0;
> +			desc->host_addr = cpu_to_le32(0);

How does a BE zero differ from a LE zero? Using it this way emphasizes that it
needs to be translated - I'm not objecting, just curious.

Larry
