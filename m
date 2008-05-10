Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.188]:21084 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753265AbYEJMKN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 May 2008 08:10:13 -0400
Received: by nf-out-0910.google.com with SMTP id d3so883147nfc.21
        for <linux-wireless@vger.kernel.org>; Sat, 10 May 2008 05:10:12 -0700 (PDT)
To: linville@tuxdriver.com
Subject: [PATCH 11/16] rt2x00: Only initialize the minimum needed fields of PCI TX descriptors.
Date: Sat, 10 May 2008 13:44:14 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200805101337.14536.IvDoorn@gmail.com>
In-Reply-To: <200805101337.14536.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200805101344.14973.IvDoorn@gmail.com> (sfid-20080510_141029_549407_8F433586)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Gertjan van Wingerde <gwingerde@kpnplanet.nl>

In preparation of replacing the statically allocated data DMA buffers with DMA-mapped
skb's we need to change the TXD handling of the PCI drivers, by moving the programming
of the buffer address fields to the actual TXD writing at TX time, instead of at start-up
time.

Signed-off-by: Gertjan van Wingerde <gwingerde@kpnplanet.nl>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2400pci.c |   15 ++++++---------
 drivers/net/wireless/rt2x00/rt2500pci.c |    9 +++++----
 drivers/net/wireless/rt2x00/rt61pci.c   |   24 ++++++++++--------------
 3 files changed, 21 insertions(+), 27 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2400pci.c b/drivers/net/wireless/rt2x00/rt2400pci.c
index 0db4b52..15d3e41 100644
--- a/drivers/net/wireless/rt2x00/rt2400pci.c
+++ b/drivers/net/wireless/rt2x00/rt2400pci.c
@@ -643,15 +643,6 @@ static void rt2400pci_init_txentry(struct rt2x00_dev *rt2x00dev,
 	struct queue_entry_priv_pci_tx *priv_tx = entry->priv_data;
 	u32 word;
 
-	rt2x00_desc_read(priv_tx->desc, 1, &word);
-	rt2x00_set_field32(&word, TXD_W1_BUFFER_ADDRESS, priv_tx->data_dma);
-	rt2x00_desc_write(priv_tx->desc, 1, word);
-
-	rt2x00_desc_read(priv_tx->desc, 2, &word);
-	rt2x00_set_field32(&word, TXD_W2_BUFFER_LENGTH,
-			   entry->queue->data_size);
-	rt2x00_desc_write(priv_tx->desc, 2, word);
-
 	rt2x00_desc_read(priv_tx->desc, 0, &word);
 	rt2x00_set_field32(&word, TXD_W0_VALID, 0);
 	rt2x00_set_field32(&word, TXD_W0_OWNER_NIC, 0);
@@ -1004,13 +995,19 @@ static void rt2400pci_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 				    struct txentry_desc *txdesc)
 {
 	struct skb_frame_desc *skbdesc = get_skb_frame_desc(skb);
+	struct queue_entry_priv_pci_tx *entry_priv = skbdesc->entry->priv_data;
 	__le32 *txd = skbdesc->desc;
 	u32 word;
 
 	/*
 	 * Start writing the descriptor words.
 	 */
+	rt2x00_desc_read(entry_priv->desc, 1, &word);
+	rt2x00_set_field32(&word, TXD_W1_BUFFER_ADDRESS, entry_priv->data_dma);
+	rt2x00_desc_write(entry_priv->desc, 1, word);
+
 	rt2x00_desc_read(txd, 2, &word);
+	rt2x00_set_field32(&word, TXD_W2_BUFFER_LENGTH, skbdesc->data_len);
 	rt2x00_set_field32(&word, TXD_W2_DATABYTE_COUNT, skbdesc->data_len);
 	rt2x00_desc_write(txd, 2, word);
 
diff --git a/drivers/net/wireless/rt2x00/rt2500pci.c b/drivers/net/wireless/rt2x00/rt2500pci.c
index b62dd59..480ed47 100644
--- a/drivers/net/wireless/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/rt2x00/rt2500pci.c
@@ -733,10 +733,6 @@ static void rt2500pci_init_txentry(struct rt2x00_dev *rt2x00dev,
 	struct queue_entry_priv_pci_tx *priv_tx = entry->priv_data;
 	u32 word;
 
-	rt2x00_desc_read(priv_tx->desc, 1, &word);
-	rt2x00_set_field32(&word, TXD_W1_BUFFER_ADDRESS, priv_tx->data_dma);
-	rt2x00_desc_write(priv_tx->desc, 1, word);
-
 	rt2x00_desc_read(priv_tx->desc, 0, &word);
 	rt2x00_set_field32(&word, TXD_W0_VALID, 0);
 	rt2x00_set_field32(&word, TXD_W0_OWNER_NIC, 0);
@@ -1158,12 +1154,17 @@ static void rt2500pci_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 				    struct txentry_desc *txdesc)
 {
 	struct skb_frame_desc *skbdesc = get_skb_frame_desc(skb);
+	struct queue_entry_priv_pci_tx *entry_priv = skbdesc->entry->priv_data;
 	__le32 *txd = skbdesc->desc;
 	u32 word;
 
 	/*
 	 * Start writing the descriptor words.
 	 */
+	rt2x00_desc_read(entry_priv->desc, 1, &word);
+	rt2x00_set_field32(&word, TXD_W1_BUFFER_ADDRESS, entry_priv->data_dma);
+	rt2x00_desc_write(entry_priv->desc, 1, word);
+
 	rt2x00_desc_read(txd, 2, &word);
 	rt2x00_set_field32(&word, TXD_W2_IV_OFFSET, IEEE80211_HEADER);
 	rt2x00_set_field32(&word, TXD_W2_AIFS, txdesc->aifs);
diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index 913ef3f..ced8ae6 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -1037,20 +1037,6 @@ static void rt61pci_init_txentry(struct rt2x00_dev *rt2x00dev,
 	struct queue_entry_priv_pci_tx *priv_tx = entry->priv_data;
 	u32 word;
 
-	rt2x00_desc_read(priv_tx->desc, 1, &word);
-	rt2x00_set_field32(&word, TXD_W1_BUFFER_COUNT, 1);
-	rt2x00_desc_write(priv_tx->desc, 1, word);
-
-	rt2x00_desc_read(priv_tx->desc, 5, &word);
-	rt2x00_set_field32(&word, TXD_W5_PID_TYPE, entry->queue->qid);
-	rt2x00_set_field32(&word, TXD_W5_PID_SUBTYPE, entry->entry_idx);
-	rt2x00_desc_write(priv_tx->desc, 5, word);
-
-	rt2x00_desc_read(priv_tx->desc, 6, &word);
-	rt2x00_set_field32(&word, TXD_W6_BUFFER_PHYSICAL_ADDRESS,
-			   priv_tx->data_dma);
-	rt2x00_desc_write(priv_tx->desc, 6, word);
-
 	rt2x00_desc_read(priv_tx->desc, 0, &word);
 	rt2x00_set_field32(&word, TXD_W0_VALID, 0);
 	rt2x00_set_field32(&word, TXD_W0_OWNER_NIC, 0);
@@ -1529,6 +1515,7 @@ static void rt61pci_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 				    struct txentry_desc *txdesc)
 {
 	struct skb_frame_desc *skbdesc = get_skb_frame_desc(skb);
+	struct queue_entry_priv_pci_tx *entry_priv = skbdesc->entry->priv_data;
 	__le32 *txd = skbdesc->desc;
 	u32 word;
 
@@ -1542,6 +1529,7 @@ static void rt61pci_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 	rt2x00_set_field32(&word, TXD_W1_CWMAX, txdesc->cw_max);
 	rt2x00_set_field32(&word, TXD_W1_IV_OFFSET, IEEE80211_HEADER);
 	rt2x00_set_field32(&word, TXD_W1_HW_SEQUENCE, 1);
+	rt2x00_set_field32(&word, TXD_W1_BUFFER_COUNT, 1);
 	rt2x00_desc_write(txd, 1, word);
 
 	rt2x00_desc_read(txd, 2, &word);
@@ -1552,11 +1540,19 @@ static void rt61pci_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 	rt2x00_desc_write(txd, 2, word);
 
 	rt2x00_desc_read(txd, 5, &word);
+	rt2x00_set_field32(&word, TXD_W5_PID_TYPE, skbdesc->entry->queue->qid);
+	rt2x00_set_field32(&word, TXD_W5_PID_SUBTYPE,
+			   skbdesc->entry->entry_idx);
 	rt2x00_set_field32(&word, TXD_W5_TX_POWER,
 			   TXPOWER_TO_DEV(rt2x00dev->tx_power));
 	rt2x00_set_field32(&word, TXD_W5_WAITING_DMA_DONE_INT, 1);
 	rt2x00_desc_write(txd, 5, word);
 
+	rt2x00_desc_read(txd, 6, &word);
+	rt2x00_set_field32(&word, TXD_W6_BUFFER_PHYSICAL_ADDRESS,
+			   entry_priv->data_dma);
+	rt2x00_desc_write(txd, 6, word);
+
 	if (skbdesc->desc_len > TXINFO_SIZE) {
 		rt2x00_desc_read(txd, 11, &word);
 		rt2x00_set_field32(&word, TXD_W11_BUFFER_LENGTH0, skbdesc->data_len);
-- 
1.5.5.1

