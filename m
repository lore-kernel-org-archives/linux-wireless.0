Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp1-g21.free.fr ([212.27.42.1]:33311 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754762AbZKBXmu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Nov 2009 18:42:50 -0500
From: Christian Casteyde <casteyde.christian@free.fr>
To: Michael Buesch <mb@bu3sch.de>
Subject: Re: 2.6.32-rc5-git3: Reported regressions from 2.6.31
Date: Tue, 3 Nov 2009 00:43:26 +0100
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
References: <Sj-rRjx6TwF.A.djE.vqe5KB@chimera> <200910282138.37401.casteyde.christian@free.fr> <200911011628.34535.mb@bu3sch.de>
In-Reply-To: <200911011628.34535.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <200911030043.26510.casteyde.christian@free.fr>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Nothing to mention: it seems to work, at least on my hardware.
I got the Allocated bounce buffer log, and managed to boot without any error, 
associate and access the web/ssh another computer (and didn't get any 
kmemcheck error of course).

CC

Le dimanche 01 novembre 2009 16:28:34, Michael Buesch a écrit :
> On Wednesday 28 October 2009 21:38:37 Christian Casteyde wrote:
> > I've just tested the patch posted in bugzilla: it works.
> > That is, I do not manage to get the warning anymore in 3 boots in a row.
> 
> Can you try this patch (on top of the previous one), please?
> It should fix the issue correctly by removing the skb copying.
> While testing make sure the debugging message
> "Allocated bounce buffer"
> shows up in the kernel log.
> 
> 
> 
> Index: wireless-testing/drivers/net/wireless/b43/dma.c
> ===================================================================
> --- wireless-testing.orig/drivers/net/wireless/b43/dma.c	2009-11-01
>  15:10:48.000000000 +0100 +++
>  wireless-testing/drivers/net/wireless/b43/dma.c	2009-11-01
>  16:26:00.000000000 +0100 @@ -1157,18 +1157,17 @@ struct b43_dmaring
>  *parse_cookie(struct
>  }
> 
>  static int dma_tx_fragment(struct b43_dmaring *ring,
> -			   struct sk_buff **in_skb)
> +			   struct sk_buff *skb)
>  {
> -	struct sk_buff *skb = *in_skb;
>  	const struct b43_dma_ops *ops = ring->ops;
>  	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
> +	struct b43_private_tx_info *priv_info = b43_get_priv_tx_info(info);
>  	u8 *header;
>  	int slot, old_top_slot, old_used_slots;
>  	int err;
>  	struct b43_dmadesc_generic *desc;
>  	struct b43_dmadesc_meta *meta;
>  	struct b43_dmadesc_meta *meta_hdr;
> -	struct sk_buff *bounce_skb;
>  	u16 cookie;
>  	size_t hdrsize = b43_txhdr_size(ring->dev);
> 
> @@ -1212,34 +1211,34 @@ static int dma_tx_fragment(struct b43_dm
> 
>  	meta->skb = skb;
>  	meta->is_last_fragment = 1;
> +	priv_info->bouncebuffer = NULL;
> 
>  	meta->dmaaddr = map_descbuffer(ring, skb->data, skb->len, 1);
>  	/* create a bounce buffer in zone_dma on mapping failure. */
>  	if (b43_dma_mapping_error(ring, meta->dmaaddr, skb->len, 1)) {
> -		bounce_skb = __dev_alloc_skb(skb->len, GFP_ATOMIC | GFP_DMA);
> -		if (!bounce_skb) {
> +
> +{
> +static unsigned int count;
> +if (count++ < 10)
> +	printk(KERN_DEBUG "Allocated bounce buffer\n");
> +}
> +		priv_info->bouncebuffer = kmalloc(skb->len, GFP_ATOMIC | GFP_DMA);
> +		if (!priv_info->bouncebuffer) {
>  			ring->current_slot = old_top_slot;
>  			ring->used_slots = old_used_slots;
>  			err = -ENOMEM;
>  			goto out_unmap_hdr;
>  		}
> +		memcpy(priv_info->bouncebuffer, skb->data, skb->len);
> 
> -		memcpy(skb_put(bounce_skb, skb->len), skb->data, skb->len);
> -		memcpy(bounce_skb->cb, skb->cb, sizeof(skb->cb));
> -		bounce_skb->dev = skb->dev;
> -		skb_set_queue_mapping(bounce_skb, skb_get_queue_mapping(skb));
> -		info = IEEE80211_SKB_CB(bounce_skb);
> -
> -		dev_kfree_skb_any(skb);
> -		skb = bounce_skb;
> -		*in_skb = bounce_skb;
> -		meta->skb = skb;
> -		meta->dmaaddr = map_descbuffer(ring, skb->data, skb->len, 1);
> +		meta->dmaaddr = map_descbuffer(ring, priv_info->bouncebuffer, skb->len,
>  1); if (b43_dma_mapping_error(ring, meta->dmaaddr, skb->len, 1)) {
> +			kfree(priv_info->bouncebuffer);
> +			priv_info->bouncebuffer = NULL;
>  			ring->current_slot = old_top_slot;
>  			ring->used_slots = old_used_slots;
>  			err = -EIO;
> -			goto out_free_bounce;
> +			goto out_unmap_hdr;
>  		}
>  	}
> 
> @@ -1256,8 +1255,6 @@ static int dma_tx_fragment(struct b43_dm
>  	ops->poke_tx(ring, next_slot(ring, slot));
>  	return 0;
> 
> -out_free_bounce:
> -	dev_kfree_skb_any(skb);
>  out_unmap_hdr:
>  	unmap_descbuffer(ring, meta_hdr->dmaaddr,
>  			 hdrsize, 1);
> @@ -1362,11 +1359,7 @@ int b43_dma_tx(struct b43_wldev *dev, st
>  	 * static, so we don't need to store it per frame. */
>  	ring->queue_prio = skb_get_queue_mapping(skb);
> 
> -	/* dma_tx_fragment might reallocate the skb, so invalidate pointers
>  pointing -	 * into the skb data or cb now. */
> -	hdr = NULL;
> -	info = NULL;
> -	err = dma_tx_fragment(ring, &skb);
> +	err = dma_tx_fragment(ring, skb);
>  	if (unlikely(err == -ENOKEY)) {
>  		/* Drop this packet, as we don't have the encryption key
>  		 * anymore and must not transmit it unencrypted. */
> @@ -1413,12 +1406,17 @@ void b43_dma_handle_txstatus(struct b43_
>  		B43_WARN_ON(!(slot >= 0 && slot < ring->nr_slots));
>  		desc = ops->idx2desc(ring, slot, &meta);
> 
> -		if (meta->skb)
> -			unmap_descbuffer(ring, meta->dmaaddr, meta->skb->len,
> -					 1);
> -		else
> +		if (meta->skb) {
> +			struct b43_private_tx_info *priv_info =
> +				b43_get_priv_tx_info(IEEE80211_SKB_CB(meta->skb));
> +
> +			unmap_descbuffer(ring, meta->dmaaddr, meta->skb->len, 1);
> +			kfree(priv_info->bouncebuffer);
> +			priv_info->bouncebuffer = NULL;
> +		} else {
>  			unmap_descbuffer(ring, meta->dmaaddr,
>  					 b43_txhdr_size(dev), 1);
> +		}
> 
>  		if (meta->is_last_fragment) {
>  			struct ieee80211_tx_info *info;
> Index: wireless-testing/drivers/net/wireless/b43/xmit.h
> ===================================================================
> --- wireless-testing.orig/drivers/net/wireless/b43/xmit.h	2009-10-09
>  19:50:15.000000000 +0200 +++
>  wireless-testing/drivers/net/wireless/b43/xmit.h	2009-11-01
>  16:05:46.000000000 +0100 @@ -2,6 +2,8 @@
>  #define B43_XMIT_H_
> 
>  #include "main.h"
> +#include <net/mac80211.h>
> +
> 
>  #define _b43_declare_plcp_hdr(size) \
>  	struct b43_plcp_hdr##size {		\
> @@ -332,4 +334,21 @@ static inline u8 b43_kidx_to_raw(struct
>  	return raw_kidx;
>  }
> 
> +/* struct b43_private_tx_info - TX info private to b43.
> + * The structure is placed in (struct ieee80211_tx_info
>  *)->rate_driver_data + *
> + * @bouncebuffer: DMA Bouncebuffer (if used)
> + */
> +struct b43_private_tx_info {
> +	void *bouncebuffer;
> +};
> +
> +static inline struct b43_private_tx_info *
> +b43_get_priv_tx_info(struct ieee80211_tx_info *info)
> +{
> +	BUILD_BUG_ON(sizeof(struct b43_private_tx_info) >
> +		     sizeof(info->rate_driver_data));
> +	return (struct b43_private_tx_info *)info->rate_driver_data;
> +}
> +
>  #endif /* B43_XMIT_H_ */
> 
