Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:61775 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752586Ab0KDTno (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Nov 2010 15:43:44 -0400
Received: by ewy7 with SMTP id 7so1281934ewy.19
        for <linux-wireless@vger.kernel.org>; Thu, 04 Nov 2010 12:43:43 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 04/13] rt2x00: Reduce tx descriptor size
Date: Thu, 4 Nov 2010 20:38:15 +0100
Cc: Helmut Schaa <helmut.schaa@googlemail.com>
References: <201011042037.00178.IvDoorn@gmail.com> <201011042037.23442.IvDoorn@gmail.com> <201011042037.47939.IvDoorn@gmail.com>
In-Reply-To: <201011042037.47939.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201011042038.16312.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Helmut Schaa <helmut.schaa@googlemail.com>

The tx descriptor values qid, cw_min, cw_max and aifs are directly
accessible through the tx entry struct. So there's no need to copy
them into the tx descriptor and passing them to the indiviual drivers.
Instead we can just get the correct value from the tx entry.

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2500pci.c   |    6 +++---
 drivers/net/wireless/rt2x00/rt2500usb.c   |    6 +++---
 drivers/net/wireless/rt2x00/rt2800lib.c   |    2 +-
 drivers/net/wireless/rt2x00/rt2x00queue.c |    8 --------
 drivers/net/wireless/rt2x00/rt2x00queue.h |    9 ---------
 drivers/net/wireless/rt2x00/rt61pci.c     |   14 +++++++-------
 drivers/net/wireless/rt2x00/rt73usb.c     |    8 ++++----
 7 files changed, 18 insertions(+), 35 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2500pci.c b/drivers/net/wireless/rt2x00/rt2500pci.c
index ab6c9ec..b69e55f 100644
--- a/drivers/net/wireless/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/rt2x00/rt2500pci.c
@@ -1193,9 +1193,9 @@ static void rt2500pci_write_tx_desc(struct queue_entry *entry,
 
 	rt2x00_desc_read(txd, 2, &word);
 	rt2x00_set_field32(&word, TXD_W2_IV_OFFSET, IEEE80211_HEADER);
-	rt2x00_set_field32(&word, TXD_W2_AIFS, txdesc->aifs);
-	rt2x00_set_field32(&word, TXD_W2_CWMIN, txdesc->cw_min);
-	rt2x00_set_field32(&word, TXD_W2_CWMAX, txdesc->cw_max);
+	rt2x00_set_field32(&word, TXD_W2_AIFS, entry->queue->aifs);
+	rt2x00_set_field32(&word, TXD_W2_CWMIN, entry->queue->cw_min);
+	rt2x00_set_field32(&word, TXD_W2_CWMAX, entry->queue->cw_max);
 	rt2x00_desc_write(txd, 2, word);
 
 	rt2x00_desc_read(txd, 3, &word);
diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
index 725ae34..f20ab79 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/rt2x00/rt2500usb.c
@@ -1081,9 +1081,9 @@ static void rt2500usb_write_tx_desc(struct queue_entry *entry,
 
 	rt2x00_desc_read(txd, 1, &word);
 	rt2x00_set_field32(&word, TXD_W1_IV_OFFSET, txdesc->iv_offset);
-	rt2x00_set_field32(&word, TXD_W1_AIFS, txdesc->aifs);
-	rt2x00_set_field32(&word, TXD_W1_CWMIN, txdesc->cw_min);
-	rt2x00_set_field32(&word, TXD_W1_CWMAX, txdesc->cw_max);
+	rt2x00_set_field32(&word, TXD_W1_AIFS, entry->queue->aifs);
+	rt2x00_set_field32(&word, TXD_W1_CWMIN, entry->queue->cw_min);
+	rt2x00_set_field32(&word, TXD_W1_CWMAX, entry->queue->cw_max);
 	rt2x00_desc_write(txd, 1, word);
 
 	rt2x00_desc_read(txd, 2, &word);
diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index dcd3a89..6fa6549 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -487,7 +487,7 @@ void rt2800_write_tx_data(struct queue_entry *entry,
 			   txdesc->key_idx : 0xff);
 	rt2x00_set_field32(&word, TXWI_W1_MPDU_TOTAL_BYTE_COUNT,
 			   txdesc->length);
-	rt2x00_set_field32(&word, TXWI_W1_PACKETID_QUEUE, txdesc->qid);
+	rt2x00_set_field32(&word, TXWI_W1_PACKETID_QUEUE, entry->queue->qid);
 	rt2x00_set_field32(&word, TXWI_W1_PACKETID_ENTRY, (entry->entry_idx % 3) + 1);
 	rt2x00_desc_write(txwi, 1, word);
 
diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.c b/drivers/net/wireless/rt2x00/rt2x00queue.c
index e360d28..4e2a8c2 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.c
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.c
@@ -311,14 +311,6 @@ static void rt2x00queue_create_tx_descriptor(struct queue_entry *entry,
 	memset(txdesc, 0, sizeof(*txdesc));
 
 	/*
-	 * Initialize information from queue
-	 */
-	txdesc->qid = entry->queue->qid;
-	txdesc->cw_min = entry->queue->cw_min;
-	txdesc->cw_max = entry->queue->cw_max;
-	txdesc->aifs = entry->queue->aifs;
-
-	/*
 	 * Header and frame information.
 	 */
 	txdesc->length = entry->skb->len;
diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.h b/drivers/net/wireless/rt2x00/rt2x00queue.h
index 64acfb6..8a36ef3 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.h
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.h
@@ -280,7 +280,6 @@ enum txentry_desc_flags {
  * Summary of information for the frame descriptor before sending a TX frame.
  *
  * @flags: Descriptor flags (See &enum queue_entry_flags).
- * @qid: Queue identification (See &enum data_queue_qid).
  * @length: Length of the entire frame.
  * @header_length: Length of 802.11 header.
  * @length_high: PLCP length high word.
@@ -293,11 +292,8 @@ enum txentry_desc_flags {
  * @rate_mode: Rate mode (See @enum rate_modulation).
  * @mpdu_density: MDPU density.
  * @retry_limit: Max number of retries.
- * @aifs: AIFS value.
  * @ifs: IFS value.
  * @txop: IFS value for 11n capable chips.
- * @cw_min: cwmin value.
- * @cw_max: cwmax value.
  * @cipher: Cipher type used for encryption.
  * @key_idx: Key index used for encryption.
  * @iv_offset: Position where IV should be inserted by hardware.
@@ -306,8 +302,6 @@ enum txentry_desc_flags {
 struct txentry_desc {
 	unsigned long flags;
 
-	enum data_queue_qid qid;
-
 	u16 length;
 	u16 header_length;
 
@@ -323,11 +317,8 @@ struct txentry_desc {
 	u16 mpdu_density;
 
 	short retry_limit;
-	short aifs;
 	short ifs;
 	short txop;
-	short cw_min;
-	short cw_max;
 
 	enum cipher cipher;
 	u16 key_idx;
diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index 3232336..fba9ee1 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -1789,10 +1789,10 @@ static void rt61pci_write_tx_desc(struct queue_entry *entry,
 	 * Start writing the descriptor words.
 	 */
 	rt2x00_desc_read(txd, 1, &word);
-	rt2x00_set_field32(&word, TXD_W1_HOST_Q_ID, txdesc->qid);
-	rt2x00_set_field32(&word, TXD_W1_AIFSN, txdesc->aifs);
-	rt2x00_set_field32(&word, TXD_W1_CWMIN, txdesc->cw_min);
-	rt2x00_set_field32(&word, TXD_W1_CWMAX, txdesc->cw_max);
+	rt2x00_set_field32(&word, TXD_W1_HOST_Q_ID, entry->queue->qid);
+	rt2x00_set_field32(&word, TXD_W1_AIFSN, entry->queue->aifs);
+	rt2x00_set_field32(&word, TXD_W1_CWMIN, entry->queue->cw_min);
+	rt2x00_set_field32(&word, TXD_W1_CWMAX, entry->queue->cw_max);
 	rt2x00_set_field32(&word, TXD_W1_IV_OFFSET, txdesc->iv_offset);
 	rt2x00_set_field32(&word, TXD_W1_HW_SEQUENCE,
 			   test_bit(ENTRY_TXD_GENERATE_SEQ, &txdesc->flags));
@@ -1820,7 +1820,7 @@ static void rt61pci_write_tx_desc(struct queue_entry *entry,
 	rt2x00_set_field32(&word, TXD_W5_WAITING_DMA_DONE_INT, 1);
 	rt2x00_desc_write(txd, 5, word);
 
-	if (txdesc->qid != QID_BEACON) {
+	if (entry->queue->qid != QID_BEACON) {
 		rt2x00_desc_read(txd, 6, &word);
 		rt2x00_set_field32(&word, TXD_W6_BUFFER_PHYSICAL_ADDRESS,
 				   skbdesc->skb_dma);
@@ -1866,8 +1866,8 @@ static void rt61pci_write_tx_desc(struct queue_entry *entry,
 	 * Register descriptor details in skb frame descriptor.
 	 */
 	skbdesc->desc = txd;
-	skbdesc->desc_len =
-		(txdesc->qid == QID_BEACON) ?  TXINFO_SIZE : TXD_DESC_SIZE;
+	skbdesc->desc_len = (entry->queue->qid == QID_BEACON) ? TXINFO_SIZE :
+			    TXD_DESC_SIZE;
 }
 
 /*
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index 67447ec..3c86f00 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -1472,10 +1472,10 @@ static void rt73usb_write_tx_desc(struct queue_entry *entry,
 	rt2x00_desc_write(txd, 0, word);
 
 	rt2x00_desc_read(txd, 1, &word);
-	rt2x00_set_field32(&word, TXD_W1_HOST_Q_ID, txdesc->qid);
-	rt2x00_set_field32(&word, TXD_W1_AIFSN, txdesc->aifs);
-	rt2x00_set_field32(&word, TXD_W1_CWMIN, txdesc->cw_min);
-	rt2x00_set_field32(&word, TXD_W1_CWMAX, txdesc->cw_max);
+	rt2x00_set_field32(&word, TXD_W1_HOST_Q_ID, entry->queue->qid);
+	rt2x00_set_field32(&word, TXD_W1_AIFSN, entry->queue->aifs);
+	rt2x00_set_field32(&word, TXD_W1_CWMIN, entry->queue->cw_min);
+	rt2x00_set_field32(&word, TXD_W1_CWMAX, entry->queue->cw_max);
 	rt2x00_set_field32(&word, TXD_W1_IV_OFFSET, txdesc->iv_offset);
 	rt2x00_set_field32(&word, TXD_W1_HW_SEQUENCE,
 			   test_bit(ENTRY_TXD_GENERATE_SEQ, &txdesc->flags));
-- 
1.7.2.3

