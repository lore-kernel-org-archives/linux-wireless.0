Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:57245 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756983AbZKFRcy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Nov 2009 12:32:54 -0500
From: Michael Buesch <mb@bu3sch.de>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] b43: Rewrite TX bounce buffer handling
Date: Fri, 6 Nov 2009 18:32:44 +0100
Cc: Broadcom Wireless <bcm43xx-dev@lists.berlios.de>,
	"linux-wireless" <linux-wireless@vger.kernel.org>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Christian Casteyde <casteyde.christian@free.fr>
MIME-Version: 1.0
Message-Id: <200911061832.45534.mb@bu3sch.de>
Content-Type: text/plain;
  charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Do not mess with the original skb, but allocate an independent bouncebuffer.
This protects against bad interference with mac80211's assumptions about
the skb (which already caused bugs).

Signed-off-by: Michael Buesch <mb@bu3sch.de>

---

Might also be worth applying to b43legacy.


Index: wireless-testing/drivers/net/wireless/b43/dma.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/dma.c	2009-11-06 16:55:02.000000000 +0100
+++ wireless-testing/drivers/net/wireless/b43/dma.c	2009-11-06 18:26:23.000000000 +0100
@@ -1157,18 +1157,17 @@ struct b43_dmaring *parse_cookie(struct 
 }
 
 static int dma_tx_fragment(struct b43_dmaring *ring,
-			   struct sk_buff **in_skb)
+			   struct sk_buff *skb)
 {
-	struct sk_buff *skb = *in_skb;
 	const struct b43_dma_ops *ops = ring->ops;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+	struct b43_private_tx_info *priv_info = b43_get_priv_tx_info(info);
 	u8 *header;
 	int slot, old_top_slot, old_used_slots;
 	int err;
 	struct b43_dmadesc_generic *desc;
 	struct b43_dmadesc_meta *meta;
 	struct b43_dmadesc_meta *meta_hdr;
-	struct sk_buff *bounce_skb;
 	u16 cookie;
 	size_t hdrsize = b43_txhdr_size(ring->dev);
 
@@ -1212,34 +1211,28 @@ static int dma_tx_fragment(struct b43_dm
 
 	meta->skb = skb;
 	meta->is_last_fragment = 1;
+	priv_info->bouncebuffer = NULL;
 
 	meta->dmaaddr = map_descbuffer(ring, skb->data, skb->len, 1);
 	/* create a bounce buffer in zone_dma on mapping failure. */
 	if (b43_dma_mapping_error(ring, meta->dmaaddr, skb->len, 1)) {
-		bounce_skb = __dev_alloc_skb(skb->len, GFP_ATOMIC | GFP_DMA);
-		if (!bounce_skb) {
+		priv_info->bouncebuffer = kmalloc(skb->len, GFP_ATOMIC | GFP_DMA);
+		if (!priv_info->bouncebuffer) {
 			ring->current_slot = old_top_slot;
 			ring->used_slots = old_used_slots;
 			err = -ENOMEM;
 			goto out_unmap_hdr;
 		}
+		memcpy(priv_info->bouncebuffer, skb->data, skb->len);
 
-		memcpy(skb_put(bounce_skb, skb->len), skb->data, skb->len);
-		memcpy(bounce_skb->cb, skb->cb, sizeof(skb->cb));
-		bounce_skb->dev = skb->dev;
-		skb_set_queue_mapping(bounce_skb, skb_get_queue_mapping(skb));
-		info = IEEE80211_SKB_CB(bounce_skb);
-
-		dev_kfree_skb_any(skb);
-		skb = bounce_skb;
-		*in_skb = bounce_skb;
-		meta->skb = skb;
-		meta->dmaaddr = map_descbuffer(ring, skb->data, skb->len, 1);
+		meta->dmaaddr = map_descbuffer(ring, priv_info->bouncebuffer, skb->len, 1);
 		if (b43_dma_mapping_error(ring, meta->dmaaddr, skb->len, 1)) {
+			kfree(priv_info->bouncebuffer);
+			priv_info->bouncebuffer = NULL;
 			ring->current_slot = old_top_slot;
 			ring->used_slots = old_used_slots;
 			err = -EIO;
-			goto out_free_bounce;
+			goto out_unmap_hdr;
 		}
 	}
 
@@ -1256,8 +1249,6 @@ static int dma_tx_fragment(struct b43_dm
 	ops->poke_tx(ring, next_slot(ring, slot));
 	return 0;
 
-out_free_bounce:
-	dev_kfree_skb_any(skb);
 out_unmap_hdr:
 	unmap_descbuffer(ring, meta_hdr->dmaaddr,
 			 hdrsize, 1);
@@ -1362,11 +1353,7 @@ int b43_dma_tx(struct b43_wldev *dev, st
 	 * static, so we don't need to store it per frame. */
 	ring->queue_prio = skb_get_queue_mapping(skb);
 
-	/* dma_tx_fragment might reallocate the skb, so invalidate pointers pointing
-	 * into the skb data or cb now. */
-	hdr = NULL;
-	info = NULL;
-	err = dma_tx_fragment(ring, &skb);
+	err = dma_tx_fragment(ring, skb);
 	if (unlikely(err == -ENOKEY)) {
 		/* Drop this packet, as we don't have the encryption key
 		 * anymore and must not transmit it unencrypted. */
@@ -1413,12 +1400,17 @@ void b43_dma_handle_txstatus(struct b43_
 		B43_WARN_ON(!(slot >= 0 && slot < ring->nr_slots));
 		desc = ops->idx2desc(ring, slot, &meta);
 
-		if (meta->skb)
-			unmap_descbuffer(ring, meta->dmaaddr, meta->skb->len,
-					 1);
-		else
+		if (meta->skb) {
+			struct b43_private_tx_info *priv_info =
+				b43_get_priv_tx_info(IEEE80211_SKB_CB(meta->skb));
+
+			unmap_descbuffer(ring, meta->dmaaddr, meta->skb->len, 1);
+			kfree(priv_info->bouncebuffer);
+			priv_info->bouncebuffer = NULL;
+		} else {
 			unmap_descbuffer(ring, meta->dmaaddr,
 					 b43_txhdr_size(dev), 1);
+		}
 
 		if (meta->is_last_fragment) {
 			struct ieee80211_tx_info *info;
Index: wireless-testing/drivers/net/wireless/b43/xmit.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/xmit.h	2009-11-06 16:55:02.000000000 +0100
+++ wireless-testing/drivers/net/wireless/b43/xmit.h	2009-11-06 18:25:56.000000000 +0100
@@ -2,6 +2,8 @@
 #define B43_XMIT_H_
 
 #include "main.h"
+#include <net/mac80211.h>
+
 
 #define _b43_declare_plcp_hdr(size) \
 	struct b43_plcp_hdr##size {		\
@@ -332,4 +334,21 @@ static inline u8 b43_kidx_to_raw(struct 
 	return raw_kidx;
 }
 
+/* struct b43_private_tx_info - TX info private to b43.
+ * The structure is placed in (struct ieee80211_tx_info *)->rate_driver_data
+ *
+ * @bouncebuffer: DMA Bouncebuffer (if used)
+ */
+struct b43_private_tx_info {
+	void *bouncebuffer;
+};
+
+static inline struct b43_private_tx_info *
+b43_get_priv_tx_info(struct ieee80211_tx_info *info)
+{
+	BUILD_BUG_ON(sizeof(struct b43_private_tx_info) >
+		     sizeof(info->rate_driver_data));
+	return (struct b43_private_tx_info *)info->rate_driver_data;
+}
+
 #endif /* B43_XMIT_H_ */

-- 
Greetings, Michael.
