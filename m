Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:42497 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752233Ab0H3TQY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Aug 2010 15:16:24 -0400
Received: by eyg5 with SMTP id 5so3422616eyg.19
        for <linux-wireless@vger.kernel.org>; Mon, 30 Aug 2010 12:16:22 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Subject: [PATCH 01/10] rt2x00: Rename txentry_desc.queue -> txentry_desc.qid
Date: Mon, 30 Aug 2010 21:12:24 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201008302112.25578.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Helmut Schaa <helmut.schaa@googlemail.com>

Variables containing queue ids are called qid everywhere else, hence
rename the queue field in txentry_desc to qid as well.

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800lib.c   |    2 +-
 drivers/net/wireless/rt2x00/rt2x00queue.c |    2 +-
 drivers/net/wireless/rt2x00/rt2x00queue.h |    4 ++--
 drivers/net/wireless/rt2x00/rt61pci.c     |    6 +++---
 drivers/net/wireless/rt2x00/rt73usb.c     |    2 +-
 5 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 2fd326c..ac92e7c 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -469,7 +469,7 @@ void rt2800_write_tx_data(struct queue_entry *entry,
 			   txdesc->key_idx : 0xff);
 	rt2x00_set_field32(&word, TXWI_W1_MPDU_TOTAL_BYTE_COUNT,
 			   txdesc->length);
-	rt2x00_set_field32(&word, TXWI_W1_PACKETID, txdesc->queue + 1);
+	rt2x00_set_field32(&word, TXWI_W1_PACKETID, txdesc->qid + 1);
 	rt2x00_desc_write(txwi, 1, word);
 
 	/*
diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.c b/drivers/net/wireless/rt2x00/rt2x00queue.c
index a2bd176..7b25d66 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.c
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.c
@@ -312,7 +312,7 @@ static void rt2x00queue_create_tx_descriptor(struct queue_entry *entry,
 	/*
 	 * Initialize information from queue
 	 */
-	txdesc->queue = entry->queue->qid;
+	txdesc->qid = entry->queue->qid;
 	txdesc->cw_min = entry->queue->cw_min;
 	txdesc->cw_max = entry->queue->cw_max;
 	txdesc->aifs = entry->queue->aifs;
diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.h b/drivers/net/wireless/rt2x00/rt2x00queue.h
index c451a50..0e38a91 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.h
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.h
@@ -296,7 +296,7 @@ enum txentry_desc_flags {
  * Summary of information for the frame descriptor before sending a TX frame.
  *
  * @flags: Descriptor flags (See &enum queue_entry_flags).
- * @queue: Queue identification (See &enum data_queue_qid).
+ * @qid: Queue identification (See &enum data_queue_qid).
  * @length: Length of the entire frame.
  * @header_length: Length of 802.11 header.
  * @length_high: PLCP length high word.
@@ -322,7 +322,7 @@ enum txentry_desc_flags {
 struct txentry_desc {
 	unsigned long flags;
 
-	enum data_queue_qid queue;
+	enum data_queue_qid qid;
 
 	u16 length;
 	u16 header_length;
diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index 8b67cfd..3a77599 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -1778,7 +1778,7 @@ static void rt61pci_write_tx_desc(struct queue_entry *entry,
 	 * Start writing the descriptor words.
 	 */
 	rt2x00_desc_read(txd, 1, &word);
-	rt2x00_set_field32(&word, TXD_W1_HOST_Q_ID, txdesc->queue);
+	rt2x00_set_field32(&word, TXD_W1_HOST_Q_ID, txdesc->qid);
 	rt2x00_set_field32(&word, TXD_W1_AIFSN, txdesc->aifs);
 	rt2x00_set_field32(&word, TXD_W1_CWMIN, txdesc->cw_min);
 	rt2x00_set_field32(&word, TXD_W1_CWMAX, txdesc->cw_max);
@@ -1809,7 +1809,7 @@ static void rt61pci_write_tx_desc(struct queue_entry *entry,
 	rt2x00_set_field32(&word, TXD_W5_WAITING_DMA_DONE_INT, 1);
 	rt2x00_desc_write(txd, 5, word);
 
-	if (txdesc->queue != QID_BEACON) {
+	if (txdesc->qid != QID_BEACON) {
 		rt2x00_desc_read(txd, 6, &word);
 		rt2x00_set_field32(&word, TXD_W6_BUFFER_PHYSICAL_ADDRESS,
 				   skbdesc->skb_dma);
@@ -1856,7 +1856,7 @@ static void rt61pci_write_tx_desc(struct queue_entry *entry,
 	 */
 	skbdesc->desc = txd;
 	skbdesc->desc_len =
-		(txdesc->queue == QID_BEACON) ?  TXINFO_SIZE : TXD_DESC_SIZE;
+		(txdesc->qid == QID_BEACON) ?  TXINFO_SIZE : TXD_DESC_SIZE;
 }
 
 /*
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index b04e618..b9dfa7b 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -1463,7 +1463,7 @@ static void rt73usb_write_tx_desc(struct queue_entry *entry,
 	rt2x00_desc_write(txd, 0, word);
 
 	rt2x00_desc_read(txd, 1, &word);
-	rt2x00_set_field32(&word, TXD_W1_HOST_Q_ID, txdesc->queue);
+	rt2x00_set_field32(&word, TXD_W1_HOST_Q_ID, txdesc->qid);
 	rt2x00_set_field32(&word, TXD_W1_AIFSN, txdesc->aifs);
 	rt2x00_set_field32(&word, TXD_W1_CWMIN, txdesc->cw_min);
 	rt2x00_set_field32(&word, TXD_W1_CWMAX, txdesc->cw_max);
-- 
1.7.2.2

