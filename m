Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mfe1.polimi.it ([131.175.12.23]:52066 "EHLO polimi.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754871AbYAYNkP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Jan 2008 08:40:15 -0500
Date: Fri, 25 Jan 2008 14:29:50 +0100
From: Stefano Brivio <stefano.brivio@polimi.it>
To: stable@kernel.org
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org,
	Michael Buesch <mb@bu3sch.de>
Subject: [PATCH stable 3/4] b43legacy: drop packets we are not able to
 encrypt
Message-ID: <20080125142950.3146020a@morte> (sfid-20080125_134020_284675_F0DE93D7)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We must drop any packets we are not able to encrypt.
We must not send them unencrypted or with an all-zero-key (which
basically is the same as unencrypted, from a security point of view).

This might only trigger shortly after resume before mac80211 reassociated
and reconfigured the keys.

It is safe to drop these packets, as the association they belong to
is not guaranteed anymore anyway.
This is a security fix in the sense that it prevents information leakage.

This patch by Michael Buesch has been ported to b43legacy.

Cc: Michael Buesch <mb@bu3sch.de>
Signed-off-by: Stefano Brivio <stefano.brivio@polimi.it>
---
Index: linux-2.6.24/drivers/net/wireless/b43legacy/dma.c
===================================================================
--- linux-2.6.24.orig/drivers/net/wireless/b43legacy/dma.c
+++ linux-2.6.24/drivers/net/wireless/b43legacy/dma.c
@@ -1181,9 +1181,11 @@ static int dma_tx_fragment(struct b43leg
 
 	header = &(ring->txhdr_cache[slot * sizeof(
 			       struct b43legacy_txhdr_fw3)]);
-	b43legacy_generate_txhdr(ring->dev, header,
+	err = b43legacy_generate_txhdr(ring->dev, header,
 				 skb->data, skb->len, ctl,
 				 generate_cookie(ring, slot));
+	if (unlikely(err))
+		return err;
 
 	meta_hdr->dmaaddr = map_descbuffer(ring, (unsigned char *)header,
 				       sizeof(struct b43legacy_txhdr_fw3), 1);
@@ -1282,6 +1284,13 @@ int b43legacy_dma_tx(struct b43legacy_wl
 	B43legacy_BUG_ON(ring->stopped);
 
 	err = dma_tx_fragment(ring, skb, ctl);
+	if (unlikely(err == -ENOKEY)) {
+		/* Drop this packet, as we don't have the encryption key
+		 * anymore and must not transmit it unencrypted. */
+		dev_kfree_skb_any(skb);
+		err = 0;
+		goto out_unlock;
+	}
 	if (unlikely(err)) {
 		b43legacyerr(dev->wl, "DMA tx mapping failure\n");
 		goto out_unlock;
Index: linux-2.6.24/drivers/net/wireless/b43legacy/pio.c
===================================================================
--- linux-2.6.24.orig/drivers/net/wireless/b43legacy/pio.c
+++ linux-2.6.24/drivers/net/wireless/b43legacy/pio.c
@@ -181,7 +181,7 @@ union txhdr_union {
 	struct b43legacy_txhdr_fw3 txhdr_fw3;
 };
 
-static void pio_tx_write_fragment(struct b43legacy_pioqueue *queue,
+static int pio_tx_write_fragment(struct b43legacy_pioqueue *queue,
 				  struct sk_buff *skb,
 				  struct b43legacy_pio_txpacket *packet,
 				  size_t txhdr_size)
@@ -189,14 +189,17 @@ static void pio_tx_write_fragment(struct
 	union txhdr_union txhdr_data;
 	u8 *txhdr = NULL;
 	unsigned int octets;
+	int err;
 
 	txhdr = (u8 *)(&txhdr_data.txhdr_fw3);
 
 	B43legacy_WARN_ON(skb_shinfo(skb)->nr_frags != 0);
-	b43legacy_generate_txhdr(queue->dev,
+	err = b43legacy_generate_txhdr(queue->dev,
 				 txhdr, skb->data, skb->len,
 				 &packet->txstat.control,
 				 generate_cookie(queue, packet));
+	if (err)
+		return err;
 
 	tx_start(queue);
 	octets = skb->len + txhdr_size;
@@ -204,6 +207,8 @@ static void pio_tx_write_fragment(struct
 		octets--;
 	tx_data(queue, txhdr, (u8 *)skb->data, octets);
 	tx_complete(queue, skb);
+
+	return 0;
 }
 
 static void free_txpacket(struct b43legacy_pio_txpacket *packet,
@@ -226,6 +231,7 @@ static int pio_tx_packet(struct b43legac
 	struct b43legacy_pioqueue *queue = packet->queue;
 	struct sk_buff *skb = packet->skb;
 	u16 octets;
+	int err;
 
 	octets = (u16)skb->len + sizeof(struct b43legacy_txhdr_fw3);
 	if (queue->tx_devq_size < octets) {
@@ -247,8 +253,14 @@ static int pio_tx_packet(struct b43legac
 	if (queue->tx_devq_used + octets > queue->tx_devq_size)
 		return -EBUSY;
 	/* Now poke the device. */
-	pio_tx_write_fragment(queue, skb, packet,
+	err = pio_tx_write_fragment(queue, skb, packet,
 			      sizeof(struct b43legacy_txhdr_fw3));
+	if (unlikely(err == -ENOKEY)) {
+		/* Drop this packet, as we don't have the encryption key
+		 * anymore and must not transmit it unencrypted. */
+		free_txpacket(packet, 1);
+		return 0;
+	}
 
 	/* Account for the packet size.
 	 * (We must not overflow the device TX queue)
Index: linux-2.6.24/drivers/net/wireless/b43legacy/xmit.c
===================================================================
--- linux-2.6.24.orig/drivers/net/wireless/b43legacy/xmit.c
+++ linux-2.6.24/drivers/net/wireless/b43legacy/xmit.c
@@ -181,7 +181,7 @@ static u8 b43legacy_calc_fallback_rate(u
 	return 0;
 }
 
-static void generate_txhdr_fw3(struct b43legacy_wldev *dev,
+static int generate_txhdr_fw3(struct b43legacy_wldev *dev,
 			       struct b43legacy_txhdr_fw3 *txhdr,
 			       const unsigned char *fragment_data,
 			       unsigned int fragment_len,
@@ -252,6 +252,13 @@ static void generate_txhdr_fw3(struct b4
 			iv_len = min((size_t)txctl->iv_len,
 				     ARRAY_SIZE(txhdr->iv));
 			memcpy(txhdr->iv, ((u8 *)wlhdr) + wlhdr_len, iv_len);
+		} else {
+			/* This key is invalid. This might only happen
+			 * in a short timeframe after machine resume before
+			 * we were able to reconfigure keys.
+			 * Drop this packet completely. Do not transmit it
+			 * unencrypted to avoid leaking information. */
+			return -ENOKEY;
 		}
 	}
 	b43legacy_generate_plcp_hdr((struct b43legacy_plcp_hdr4 *)
@@ -344,16 +351,18 @@ static void generate_txhdr_fw3(struct b4
 	/* Apply the bitfields */
 	txhdr->mac_ctl = cpu_to_le32(mac_ctl);
 	txhdr->phy_ctl = cpu_to_le16(phy_ctl);
+
+	return 0;
 }
 
-void b43legacy_generate_txhdr(struct b43legacy_wldev *dev,
+int b43legacy_generate_txhdr(struct b43legacy_wldev *dev,
 			      u8 *txhdr,
 			      const unsigned char *fragment_data,
 			      unsigned int fragment_len,
 			      const struct ieee80211_tx_control *txctl,
 			      u16 cookie)
 {
-	generate_txhdr_fw3(dev, (struct b43legacy_txhdr_fw3 *)txhdr,
+	return generate_txhdr_fw3(dev, (struct b43legacy_txhdr_fw3 *)txhdr,
 			   fragment_data, fragment_len,
 			   txctl, cookie);
 }
Index: linux-2.6.24/drivers/net/wireless/b43legacy/xmit.h
===================================================================
--- linux-2.6.24.orig/drivers/net/wireless/b43legacy/xmit.h
+++ linux-2.6.24/drivers/net/wireless/b43legacy/xmit.h
@@ -76,7 +76,7 @@ struct b43legacy_txhdr_fw3 {
 
 
 
-void b43legacy_generate_txhdr(struct b43legacy_wldev *dev,
+int b43legacy_generate_txhdr(struct b43legacy_wldev *dev,
 			      u8 *txhdr,
 			      const unsigned char *fragment_data,
 			      unsigned int fragment_len,


--
Ciao
Stefano
