Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:52934 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751702AbYAWUpw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Jan 2008 15:45:52 -0500
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] b43: Drop packets that we are not able to encrypt
Date: Wed, 23 Jan 2008 21:44:15 +0100
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org,
	Stefano Brivio <stefano.brivio@polimi.it>
MIME-Version: 1.0
Message-Id: <200801232144.15455.mb@bu3sch.de> (sfid-20080123_204554_954404_71B28718)
Content-Type: text/plain;
  charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We must not transmit packets we're not able to encrypt.

This fixes a bug where in a tiny timeframe after machine resume
packets can get sent unencrypted and might leak information.

This also fixes three small resource leakages I spotted while fixing
the security problem. Properly deallocate the DMA slots in any DMA
allocation error path.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

---

This is _not_ only a theoretical problem. I saw a few packets hitting
this race condition.

John, please try to push for 2.6.24, as this is a security fix.

Stefano, this might need porting to legacy.


Index: wireless-2.6/drivers/net/wireless/b43/dma.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43/dma.c	2008-01-22 18:43:47.000000000 +0100
+++ wireless-2.6/drivers/net/wireless/b43/dma.c	2008-01-23 21:34:42.000000000 +0100
@@ -1111,38 +1111,49 @@ struct b43_dmaring *parse_cookie(struct 
 static int dma_tx_fragment(struct b43_dmaring *ring,
 			   struct sk_buff *skb,
 			   struct ieee80211_tx_control *ctl)
 {
 	const struct b43_dma_ops *ops = ring->ops;
 	u8 *header;
-	int slot;
+	int slot, old_top_slot, old_used_slots;
 	int err;
 	struct b43_dmadesc_generic *desc;
 	struct b43_dmadesc_meta *meta;
 	struct b43_dmadesc_meta *meta_hdr;
 	struct sk_buff *bounce_skb;
 	u16 cookie;
 	size_t hdrsize = b43_txhdr_size(ring->dev);
 
 #define SLOTS_PER_PACKET  2
 	B43_WARN_ON(skb_shinfo(skb)->nr_frags);
 
+	old_top_slot = ring->current_slot;
+	old_used_slots = ring->used_slots;
+
 	/* Get a slot for the header. */
 	slot = request_slot(ring);
 	desc = ops->idx2desc(ring, slot, &meta_hdr);
 	memset(meta_hdr, 0, sizeof(*meta_hdr));
 
 	header = &(ring->txhdr_cache[slot * hdrsize]);
 	cookie = generate_cookie(ring, slot);
-	b43_generate_txhdr(ring->dev, header,
-			   skb->data, skb->len, ctl, cookie);
+	err = b43_generate_txhdr(ring->dev, header,
+				 skb->data, skb->len, ctl, cookie);
+	if (unlikely(err)) {
+		ring->current_slot = old_top_slot;
+		ring->used_slots = old_used_slots;
+		return err;
+	}
 
 	meta_hdr->dmaaddr = map_descbuffer(ring, (unsigned char *)header,
 					   hdrsize, 1);
-	if (dma_mapping_error(meta_hdr->dmaaddr))
+	if (dma_mapping_error(meta_hdr->dmaaddr)) {
+		ring->current_slot = old_top_slot;
+		ring->used_slots = old_used_slots;
 		return -EIO;
+	}
 	ops->fill_descriptor(ring, desc, meta_hdr->dmaaddr,
 			     hdrsize, 1, 0, 0);
 
 	/* Get a slot for the payload. */
 	slot = request_slot(ring);
 	desc = ops->idx2desc(ring, slot, &meta);
@@ -1154,22 +1165,26 @@ static int dma_tx_fragment(struct b43_dm
 
 	meta->dmaaddr = map_descbuffer(ring, skb->data, skb->len, 1);
 	/* create a bounce buffer in zone_dma on mapping failure. */
 	if (dma_mapping_error(meta->dmaaddr)) {
 		bounce_skb = __dev_alloc_skb(skb->len, GFP_ATOMIC | GFP_DMA);
 		if (!bounce_skb) {
+			ring->current_slot = old_top_slot;
+			ring->used_slots = old_used_slots;
 			err = -ENOMEM;
 			goto out_unmap_hdr;
 		}
 
 		memcpy(skb_put(bounce_skb, skb->len), skb->data, skb->len);
 		dev_kfree_skb_any(skb);
 		skb = bounce_skb;
 		meta->skb = skb;
 		meta->dmaaddr = map_descbuffer(ring, skb->data, skb->len, 1);
 		if (dma_mapping_error(meta->dmaaddr)) {
+			ring->current_slot = old_top_slot;
+			ring->used_slots = old_used_slots;
 			err = -EIO;
 			goto out_free_bounce;
 		}
 	}
 
 	ops->fill_descriptor(ring, desc, meta->dmaaddr, skb->len, 0, 1, 1);
@@ -1249,12 +1264,19 @@ int b43_dma_tx(struct b43_wldev *dev,
 	/* Check if the queue was stopped in mac80211,
 	 * but we got called nevertheless.
 	 * That would be a mac80211 bug. */
 	B43_WARN_ON(ring->stopped);
 
 	err = dma_tx_fragment(ring, skb, ctl);
+	if (unlikely(err == -ENOKEY)) {
+		/* Drop this packet, as we don't have the encryption key
+		 * anymore and must not transmit it unencrypted. */
+		dev_kfree_skb_any(skb);
+		err = 0;
+		goto out_unlock;
+	}
 	if (unlikely(err)) {
 		b43err(dev->wl, "DMA tx mapping failure\n");
 		goto out_unlock;
 	}
 	ring->nr_tx_packets++;
 	if ((free_slots(ring) < SLOTS_PER_PACKET) ||
Index: wireless-2.6/drivers/net/wireless/b43/xmit.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43/xmit.c	2008-01-23 21:02:16.000000000 +0100
+++ wireless-2.6/drivers/net/wireless/b43/xmit.c	2008-01-23 21:34:53.000000000 +0100
@@ -175,18 +175,18 @@ static u8 b43_calc_fallback_rate(u8 bitr
 	}
 	B43_WARN_ON(1);
 	return 0;
 }
 
 /* Generate a TX data header. */
-void b43_generate_txhdr(struct b43_wldev *dev,
-			u8 *_txhdr,
-			const unsigned char *fragment_data,
-			unsigned int fragment_len,
-			const struct ieee80211_tx_control *txctl,
-			u16 cookie)
+int b43_generate_txhdr(struct b43_wldev *dev,
+		       u8 *_txhdr,
+		       const unsigned char *fragment_data,
+		       unsigned int fragment_len,
+		       const struct ieee80211_tx_control *txctl,
+		       u16 cookie)
 {
 	struct b43_txhdr *txhdr = (struct b43_txhdr *)_txhdr;
 	const struct b43_phy *phy = &dev->phy;
 	const struct ieee80211_hdr *wlhdr =
 	    (const struct ieee80211_hdr *)fragment_data;
 	int use_encryption = (!(txctl->flags & IEEE80211_TXCTL_DO_NOT_ENCRYPT));
@@ -235,28 +235,33 @@ void b43_generate_txhdr(struct b43_wldev
 		int wlhdr_len;
 		size_t iv_len;
 
 		B43_WARN_ON(key_idx >= dev->max_nr_keys);
 		key = &(dev->key[key_idx]);
 
-		if (likely(key->keyconf)) {
-			/* This key is valid. Use it for encryption. */
+		if (unlikely(!key->keyconf)) {
+			/* This key is invalid. This might only happen
+			 * in a short timeframe after machine resume before
+			 * we were able to reconfigure keys.
+			 * Drop this packet completely. Do not transmit it
+			 * unencrypted to avoid leaking information. */
+			return -ENOKEY;
+		}
 
-			/* Hardware appends ICV. */
-			plcp_fragment_len += txctl->icv_len;
+		/* Hardware appends ICV. */
+		plcp_fragment_len += txctl->icv_len;
 
-			key_idx = b43_kidx_to_fw(dev, key_idx);
-			mac_ctl |= (key_idx << B43_TXH_MAC_KEYIDX_SHIFT) &
-				   B43_TXH_MAC_KEYIDX;
-			mac_ctl |= (key->algorithm << B43_TXH_MAC_KEYALG_SHIFT) &
-				   B43_TXH_MAC_KEYALG;
-			wlhdr_len = ieee80211_get_hdrlen(fctl);
-			iv_len = min((size_t) txctl->iv_len,
-				     ARRAY_SIZE(txhdr->iv));
-			memcpy(txhdr->iv, ((u8 *) wlhdr) + wlhdr_len, iv_len);
-		}
+		key_idx = b43_kidx_to_fw(dev, key_idx);
+		mac_ctl |= (key_idx << B43_TXH_MAC_KEYIDX_SHIFT) &
+			   B43_TXH_MAC_KEYIDX;
+		mac_ctl |= (key->algorithm << B43_TXH_MAC_KEYALG_SHIFT) &
+			   B43_TXH_MAC_KEYALG;
+		wlhdr_len = ieee80211_get_hdrlen(fctl);
+		iv_len = min((size_t) txctl->iv_len,
+			     ARRAY_SIZE(txhdr->iv));
+		memcpy(txhdr->iv, ((u8 *) wlhdr) + wlhdr_len, iv_len);
 	}
 	if (b43_is_old_txhdr_format(dev)) {
 		b43_generate_plcp_hdr((struct b43_plcp_hdr4 *)(&txhdr->old_format.plcp),
 				      plcp_fragment_len, rate);
 	} else {
 		b43_generate_plcp_hdr((struct b43_plcp_hdr4 *)(&txhdr->new_format.plcp),
@@ -408,12 +413,13 @@ void b43_generate_txhdr(struct b43_wldev
 
 	/* Apply the bitfields */
 	txhdr->mac_ctl = cpu_to_le32(mac_ctl);
 	txhdr->phy_ctl = cpu_to_le16(phy_ctl);
 	txhdr->extra_ft = extra_ft;
 
+	return 0;
 }
 
 static s8 b43_rssi_postprocess(struct b43_wldev *dev,
 			       u8 in_rssi, int ofdm,
 			       int adjust_2053, int adjust_2050)
 {
Index: wireless-2.6/drivers/net/wireless/b43/xmit.h
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43/xmit.h	2008-01-23 12:38:42.000000000 +0100
+++ wireless-2.6/drivers/net/wireless/b43/xmit.h	2008-01-23 21:13:02.000000000 +0100
@@ -171,17 +171,17 @@ size_t b43_txhdr_size(struct b43_wldev *
 	if (b43_is_old_txhdr_format(dev))
 		return 100 + sizeof(struct b43_plcp_hdr6);
 	return 104 + sizeof(struct b43_plcp_hdr6);
 }
 
 
-void b43_generate_txhdr(struct b43_wldev *dev,
-			u8 * txhdr,
-			const unsigned char *fragment_data,
-			unsigned int fragment_len,
-			const struct ieee80211_tx_control *txctl, u16 cookie);
+int b43_generate_txhdr(struct b43_wldev *dev,
+		       u8 * txhdr,
+		       const unsigned char *fragment_data,
+		       unsigned int fragment_len,
+		       const struct ieee80211_tx_control *txctl, u16 cookie);
 
 /* Transmit Status */
 struct b43_txstatus {
 	u16 cookie;		/* The cookie from the txhdr */
 	u16 seq;		/* Sequence number */
 	u8 phy_stat;		/* PHY TX status */
