Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hiems2.ing.unibs.it ([192.167.23.204]:37545 "EHLO
	hiems2.ing.unibs.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759735AbZC3Vfl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Mar 2009 17:35:41 -0400
Cc: linville@tuxdriver.com, bcm43xx-dev@lists.berlios.de,
	linux-wireless@vger.kernel.org
Message-Id: <C0D59D9C-FC8A-4C79-B777-AF2F166D9711@ing.unibs.it> (sfid-20090330_233549_900057_D72C8B8D)
From: Francesco Gringoli <francesco.gringoli@ing.unibs.it>
To: Michael Buesch <mb@bu3sch.de>
In-Reply-To: <200903280041.25265.mb@bu3sch.de>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Mime-Version: 1.0 (Apple Message framework v930.3)
Subject: Re: [PATCH] b43: Refresh RX poison on buffer recycling
Date: Mon, 30 Mar 2009 23:35:34 +0200
References: <200903280041.25265.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Mar 28, 2009, at 12:41 AM, Michael Buesch wrote:

> The RX buffer poison needs to be refreshed, if we recycle an RX  
> buffer,
> because it might be (partially) overwritten by some DMA operations.
>
> Cc: stable@kernel.org
> Cc: Francesco Gringoli <francesco.gringoli@ing.unibs.it>
> Signed-off-by: Michael Buesch <mb@bu3sch.de>
>
> ---
>
> Francesco, please stresstest this on top of the other patch that  
> adds poisoning.
Hi Michael,

great work! No more crashes with the two patches. I will continue  
stress testing anyway but it seems stable.

I have one more question: the hardware seems to allow frames that are  
longer than 2352 bytes. If we monitor the firmware during receiving we  
get up to 0x1005 bytes long frames. When such frames arrives, the  
kernel drops them as the "The data did not fit into one descriptor  
buffer and is split over multiple buffers." I tried to increase  
B43_DMA0_RX_BUFFERSIZE up to 0x1006 but I get problems with dma and  
the driver keeps restarting the hardware forever. What is wrong with  
increasing this value above IEEE80211_MAX_FRAME_LEN?

Many thanks,
Cheers
-FG


>
> John, please queue as bugfix.
>
>
> Index: wireless-testing/drivers/net/wireless/b43/dma.c
> ===================================================================
> --- wireless-testing.orig/drivers/net/wireless/b43/dma.c	2009-03-27  
> 23:15:36.000000000 +0100
> +++ wireless-testing/drivers/net/wireless/b43/dma.c	2009-03-27  
> 23:30:17.000000000 +0100
> @@ -1503,20 +1503,16 @@ static void dma_rx(struct b43_dmaring *r
> 			len = le16_to_cpu(rxhdr->frame_len);
> 		} while (len == 0 && i++ < 5);
> 		if (unlikely(len == 0)) {
> -			/* recycle the descriptor buffer. */
> -			sync_descbuffer_for_device(ring, meta->dmaaddr,
> -						   ring->rx_buffersize);
> -			goto drop;
> +			dmaaddr = meta->dmaaddr;
> +			goto drop_recycle_buffer;
> 		}
> 	}
> 	if (unlikely(b43_rx_buffer_is_poisoned(ring, skb))) {
> 		/* Something went wrong with the DMA.
> 		 * The device did not touch the buffer and did not overwrite the  
> poison. */
> 		b43dbg(ring->dev->wl, "DMA RX: Dropping poisoned buffer.\n");
> -		/* recycle the descriptor buffer. */
> -		sync_descbuffer_for_device(ring, meta->dmaaddr,
> -					   ring->rx_buffersize);
> -		goto drop;
> +		dmaaddr = meta->dmaaddr;
> +		goto drop_recycle_buffer;
> 	}
> 	if (unlikely(len > ring->rx_buffersize)) {
> 		/* The data did not fit into one descriptor buffer
> @@ -1530,6 +1526,7 @@ static void dma_rx(struct b43_dmaring *r
> 		while (1) {
> 			desc = ops->idx2desc(ring, *slot, &meta);
> 			/* recycle the descriptor buffer. */
> +			b43_poison_rx_buffer(ring, meta->skb);
> 			sync_descbuffer_for_device(ring, meta->dmaaddr,
> 						   ring->rx_buffersize);
> 			*slot = next_slot(ring, *slot);
> @@ -1548,8 +1545,7 @@ static void dma_rx(struct b43_dmaring *r
> 	err = setup_rx_descbuffer(ring, desc, meta, GFP_ATOMIC);
> 	if (unlikely(err)) {
> 		b43dbg(ring->dev->wl, "DMA RX: setup_rx_descbuffer() failed\n");
> -		sync_descbuffer_for_device(ring, dmaaddr, ring->rx_buffersize);
> -		goto drop;
> +		goto drop_recycle_buffer;
> 	}
>
> 	unmap_descbuffer(ring, dmaaddr, ring->rx_buffersize, 0);
> @@ -1559,6 +1555,11 @@ static void dma_rx(struct b43_dmaring *r
> 	b43_rx(ring->dev, skb, rxhdr);
> drop:
> 	return;
> +
> +drop_recycle_buffer:
> +	/* Poison and recycle the RX buffer. */
> +	b43_poison_rx_buffer(ring, skb);
> +	sync_descbuffer_for_device(ring, dmaaddr, ring->rx_buffersize);
> }
>
> void b43_dma_rx(struct b43_dmaring *ring)
>
> -- 
> Greetings, Michael.

-------

Francesco Gringoli, PhD - Assistant Professor
Dept. of Electrical Engineering for Automation
University of Brescia
via Branze, 38
25123 Brescia
ITALY

Ph:  ++39.030.3715843
FAX: ++39.030.380014
WWW: http://www.ing.unibs.it/~gringoli




