Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpo-eml06.kpnxchange.com ([213.75.38.155]:46532 "EHLO
	cpsmtpo-eml06.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755000AbYFTWEO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Jun 2008 18:04:14 -0400
Message-ID: <485C25CA.6000607@kpnplanet.nl> (sfid-20080621_000419_850906_AFE7287E)
Date: Fri, 20 Jun 2008 23:48:58 +0200
From: Gertjan van Wingerde <gwingerde@kpnplanet.nl>
MIME-Version: 1.0
To: Ivo van Doorn <ivdoorn@gmail.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
Subject: Re: [PATCH] rt2x00: Remove duplicate deinitialization
References: <200806202210.54248.IvDoorn@gmail.com>
In-Reply-To: <200806202210.54248.IvDoorn@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Ivo,


Ivo van Doorn wrote:
> When rt2x00queue_alloc_rxskbs() fails rt2x00queue_unitialize()
> will be called which will free all rxskb. So we don't need
> to do this in the rt2x00queue_alloc_rxskb() function as well.
>
> rt2x00queue_free_skb() unmaps the DMA but doesn't clear the
> allocation flag. Since the code is copied from rt2x00queue_unmap_skb()
> anyway (and that function does clear the flag) we might as well
> use that function directly.
>
> Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
> ---
>
> This patch depends on patches from the pull request of June 16
>
>  drivers/net/wireless/rt2x00/rt2x00queue.c |   20 ++------------------
>  1 files changed, 2 insertions(+), 18 deletions(-)
>
> diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.c b/drivers/net/wireless/rt2x00/rt2x00queue.c
> index 49d3bb8..8e86611 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00queue.c
> +++ b/drivers/net/wireless/rt2x00/rt2x00queue.c
> @@ -107,18 +107,7 @@ void rt2x00queue_unmap_skb(struct rt2x00_dev *rt2x00dev, struct sk_buff *skb)
>  
>  void rt2x00queue_free_skb(struct rt2x00_dev *rt2x00dev, struct sk_buff *skb)
>  {
> -	struct skb_frame_desc *skbdesc = get_skb_frame_desc(skb);
> -
> -	if (skbdesc->flags & SKBDESC_DMA_MAPPED_RX) {
> -		dma_unmap_single(rt2x00dev->dev, skbdesc->skb_dma, skb->len,
> -				 DMA_FROM_DEVICE);
> -	}
> -
> -	if (skbdesc->flags & SKBDESC_DMA_MAPPED_TX) {
> -		dma_unmap_single(rt2x00dev->dev, skbdesc->skb_dma, skb->len,
> -				 DMA_TO_DEVICE);
> -	}
> -
> +	rt2x00queue_unmap_skb(rt2x00dev, skb);
>  	dev_kfree_skb_any(skb);
>  }
>  
> @@ -509,16 +498,11 @@ static int rt2x00queue_alloc_rxskbs(struct rt2x00_dev *rt2x00dev,
>  	for (i = 0; i < queue->limit; i++) {
>  		skb = rt2x00queue_alloc_rxskb(rt2x00dev, &queue->entries[i]);
>  		if (!skb)
> -			goto exit;
> +			return -ENOMEM;
>  		queue->entries[i].skb = skb;
>  	}
>  
>  	return 0;
> -
> -exit:
> -	rt2x00queue_free_skbs(rt2x00dev, queue);
> -
> -	return -ENOMEM;
>  }
>  
>  int rt2x00queue_initialize(struct rt2x00_dev *rt2x00dev)
>   


I find this last hunk of the patch a bit dubious. IMHO a function should 
never rely on letting his caller do the right thing and clean up for it, 
in case of failures; it should always clean up after itself. It is true 
that in this case the caller will also attempt to clean up these 
structures, but that doesn't mean that any potential future users of 
such a function should be bothered with doing the same thing.

---
Gertjan
