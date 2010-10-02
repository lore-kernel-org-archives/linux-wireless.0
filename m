Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:41875 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753980Ab0JBJf0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Oct 2010 05:35:26 -0400
Received: by mail-wy0-f174.google.com with SMTP id 28so3658555wyb.19
        for <linux-wireless@vger.kernel.org>; Sat, 02 Oct 2010 02:35:26 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 07/20] rt2x00: Fix race between dma mapping and clearing rx entries in rt2800pci
Date: Sat, 2 Oct 2010 11:29:30 +0200
Cc: users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org,
	Helmut Schaa <helmut.schaa@googlemail.com>
References: <201010021126.18748.IvDoorn@gmail.com> <201010021128.35449.IvDoorn@gmail.com> <201010021129.09422.IvDoorn@gmail.com>
In-Reply-To: <201010021129.09422.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201010021129.31357.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Helmut Schaa <helmut.schaa@googlemail.com>

During rx, rt2x00lib calls rt2800pci_fill_rxdone to read the RX
descriptor. At that time the skb is already dma unmapped but no new skb
was dma mapped for this entry again. However, rt2800pci_fill_rxdone also
moves the hw rx queue index, marking this entry to be available for
reuse. Since no new skb was dma mapped and also the previous skb was
unmapped this might lead to strange hw behavior.

To fix this issue move the hw rx queue index increment to
rt2800pci_clear_entry where a new skb was already dma mapped and can be
safely used by the hw.

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800pci.c |   15 ++++++++-------
 1 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
index 3806454..85a134c 100644
--- a/drivers/net/wireless/rt2x00/rt2800pci.c
+++ b/drivers/net/wireless/rt2x00/rt2800pci.c
@@ -241,6 +241,7 @@ static void rt2800pci_clear_entry(struct queue_entry *entry)
 {
 	struct queue_entry_priv_pci *entry_priv = entry->priv_data;
 	struct skb_frame_desc *skbdesc = get_skb_frame_desc(entry->skb);
+	struct rt2x00_dev *rt2x00dev = entry->queue->rt2x00dev;
 	u32 word;
 
 	if (entry->queue->qid == QID_RX) {
@@ -251,6 +252,13 @@ static void rt2800pci_clear_entry(struct queue_entry *entry)
 		rt2x00_desc_read(entry_priv->desc, 1, &word);
 		rt2x00_set_field32(&word, RXD_W1_DMA_DONE, 0);
 		rt2x00_desc_write(entry_priv->desc, 1, word);
+
+		/*
+		 * Set RX IDX in register to inform hardware that we have
+		 * handled this entry and it is available for reuse again.
+		 */
+		rt2800_register_write(rt2x00dev, RX_CRX_IDX,
+				      entry->entry_idx);
 	} else {
 		rt2x00_desc_read(entry_priv->desc, 1, &word);
 		rt2x00_set_field32(&word, TXD_W1_DMA_DONE, 1);
@@ -599,7 +607,6 @@ static void rt2800pci_kill_tx_queue(struct data_queue *queue)
 static void rt2800pci_fill_rxdone(struct queue_entry *entry,
 				  struct rxdone_entry_desc *rxdesc)
 {
-	struct rt2x00_dev *rt2x00dev = entry->queue->rt2x00dev;
 	struct queue_entry_priv_pci *entry_priv = entry->priv_data;
 	__le32 *rxd = entry_priv->desc;
 	u32 word;
@@ -641,12 +648,6 @@ static void rt2800pci_fill_rxdone(struct queue_entry *entry,
 	 * Process the RXWI structure that is at the start of the buffer.
 	 */
 	rt2800_process_rxwi(entry, rxdesc);
-
-	/*
-	 * Set RX IDX in register to inform hardware that we have handled
-	 * this entry and it is available for reuse again.
-	 */
-	rt2800_register_write(rt2x00dev, RX_CRX_IDX, entry->entry_idx);
 }
 
 /*
-- 
1.7.2.3

