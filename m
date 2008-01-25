Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:48428 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752524AbYAYLWz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Jan 2008 06:22:55 -0500
From: Michael Buesch <mb@bu3sch.de>
To: stable@kernel.org
Subject: [PATCH stable 2/3] b43: Drop packets we are not able to encrypt
Date: Fri, 25 Jan 2008 12:15:07 +0100
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200801251215.08164.mb@bu3sch.de> (sfid-20080125_112303_198291_DEE4C91A)
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

Signed-off-by: Michael Buesch <mb@bu3sch.de>

---

This patch is upstream inside of the netdev tree.


Index: linux-2.6.24/drivers/net/wireless/b43/dma.c
===================================================================
--- linux-2.6.24.orig/drivers/net/wireless/b43/dma.c	2008-01-25 11:48:25.000000000 +0100
+++ linux-2.6.24/drivers/net/wireless/b43/dma.c	2008-01-25 11:48:31.000000000 +0100
@@ -1122,9 +1122,11 @@ static int dma_tx_fragment(struct b43_dm
 	memset(meta_hdr, 0, sizeof(*meta_hdr));
 
 	header = &(ring->txhdr_cache[slot * sizeof(struct b43_txhdr_fw4)]);
-	b43_generate_txhdr(ring->dev, header,
+	err = b43_generate_txhdr(ring->dev, header,
 			   skb->data, skb->len, ctl,
 			   generate_cookie(ring, slot));
+	if (unlikely(err))
+		return err;
 
 	meta_hdr->dmaaddr = map_descbuffer(ring, (unsigned char *)header,
 					   sizeof(struct b43_txhdr_fw4), 1);
@@ -1219,6 +1221,13 @@ int b43_dma_tx(struct b43_wldev *dev,
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
Index: linux-2.6.24/drivers/net/wireless/b43/xmit.c
===================================================================
--- linux-2.6.24.orig/drivers/net/wireless/b43/xmit.c	2008-01-25 11:48:25.000000000 +0100
+++ linux-2.6.24/drivers/net/wireless/b43/xmit.c	2008-01-25 11:48:31.000000000 +0100
@@ -177,7 +177,7 @@ static u8 b43_calc_fallback_rate(u8 bitr
 	return 0;
 }
 
-static void generate_txhdr_fw4(struct b43_wldev *dev,
+static int generate_txhdr_fw4(struct b43_wldev *dev,
 			       struct b43_txhdr_fw4 *txhdr,
 			       const unsigned char *fragment_data,
 			       unsigned int fragment_len,
@@ -235,7 +235,15 @@ static void generate_txhdr_fw4(struct b4
 
 		B43_WARN_ON(key_idx >= dev->max_nr_keys);
 		key = &(dev->key[key_idx]);
-		B43_WARN_ON(!key->keyconf);
+
+		if (unlikely(!key->keyconf)) {
+			/* This key is invalid. This might only happen
+			 * in a short timeframe after machine resume before
+			 * we were able to reconfigure keys.
+			 * Drop this packet completely. Do not transmit it
+			 * unencrypted to avoid leaking information. */
+			return -ENOKEY;
+		}
 
 		/* Hardware appends ICV. */
 		plcp_fragment_len += txctl->icv_len;
@@ -352,16 +360,18 @@ static void generate_txhdr_fw4(struct b4
 	txhdr->mac_ctl = cpu_to_le32(mac_ctl);
 	txhdr->phy_ctl = cpu_to_le16(phy_ctl);
 	txhdr->extra_ft = extra_ft;
+
+	return 0;
 }
 
-void b43_generate_txhdr(struct b43_wldev *dev,
+int b43_generate_txhdr(struct b43_wldev *dev,
 			u8 * txhdr,
 			const unsigned char *fragment_data,
 			unsigned int fragment_len,
 			const struct ieee80211_tx_control *txctl, u16 cookie)
 {
-	generate_txhdr_fw4(dev, (struct b43_txhdr_fw4 *)txhdr,
-			   fragment_data, fragment_len, txctl, cookie);
+	return generate_txhdr_fw4(dev, (struct b43_txhdr_fw4 *)txhdr,
+				  fragment_data, fragment_len, txctl, cookie);
 }
 
 static s8 b43_rssi_postprocess(struct b43_wldev *dev,
Index: linux-2.6.24/drivers/net/wireless/b43/xmit.h
===================================================================
--- linux-2.6.24.orig/drivers/net/wireless/b43/xmit.h	2008-01-25 11:48:25.000000000 +0100
+++ linux-2.6.24/drivers/net/wireless/b43/xmit.h	2008-01-25 11:48:31.000000000 +0100
@@ -82,7 +82,7 @@ struct b43_txhdr_fw4 {
 #define  B43_TX4_PHY_ANT1		0x0100	/* Use antenna 1 */
 #define  B43_TX4_PHY_ANTLAST	0x0300	/* Use last used antenna */
 
-void b43_generate_txhdr(struct b43_wldev *dev,
+int b43_generate_txhdr(struct b43_wldev *dev,
 			u8 * txhdr,
 			const unsigned char *fragment_data,
 			unsigned int fragment_len,
