Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.172]:28480 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756136AbYAFWj4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Jan 2008 17:39:56 -0500
Received: by ug-out-1314.google.com with SMTP id z38so3071045ugc.16
        for <linux-wireless@vger.kernel.org>; Sun, 06 Jan 2008 14:39:55 -0800 (PST)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 04/12] rt2x00: Store queue idx and entry idx in data_ring and data_entry
Date: Sun, 6 Jan 2008 23:39:25 +0100
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200801062337.35904.IvDoorn@gmail.com>
In-Reply-To: <200801062337.35904.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200801062339.25255.IvDoorn@gmail.com> (sfid-20080106_224013_848154_482C9288)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Store the queue idx inside structure data_ring
Store the entry idx inside structure data_entry
This saves us a few calls to ARRAY_INDEX() which is now unused.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00.h      |    6 ------
 drivers/net/wireless/rt2x00/rt2x00debug.c |    8 ++------
 drivers/net/wireless/rt2x00/rt2x00dev.c   |    4 ++++
 drivers/net/wireless/rt2x00/rt2x00ring.h  |   12 ++++++++++++
 drivers/net/wireless/rt2x00/rt61pci.c     |    6 ++++--
 5 files changed, 22 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index 87c2c05..af0bf4b 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -796,12 +796,6 @@ struct rt2x00_dev {
 	ring_loop(__entry, (__dev)->tx, ring_end(__dev))
 
 /*
- * Compute an array index from a pointer to an element and the base pointer.
- */
-#define ARRAY_INDEX(__elem, __base) \
-	( ((char *)(__elem) - (char *)(__base)) / sizeof(*(__elem)) )
-
-/*
  * Generic RF access.
  * The RF is being accessed by word index.
  */
diff --git a/drivers/net/wireless/rt2x00/rt2x00debug.c b/drivers/net/wireless/rt2x00/rt2x00debug.c
index c55bf0e..b44a9f4 100644
--- a/drivers/net/wireless/rt2x00/rt2x00debug.c
+++ b/drivers/net/wireless/rt2x00/rt2x00debug.c
@@ -120,12 +120,8 @@ void rt2x00debug_dump_frame(struct rt2x00_dev *rt2x00dev,
 	struct sk_buff *skbcopy;
 	struct rt2x00dump_hdr *dump_hdr;
 	struct timeval timestamp;
-	unsigned int ring_index;
-	unsigned int entry_index;
 
 	do_gettimeofday(&timestamp);
-	ring_index = ARRAY_INDEX(desc->ring, rt2x00dev->rx);
-	entry_index = ARRAY_INDEX(desc->entry, desc->ring->entry);
 
 	if (!test_bit(FRAME_DUMP_FILE_OPEN, &intf->frame_dump_flags))
 		return;
@@ -151,8 +147,8 @@ void rt2x00debug_dump_frame(struct rt2x00_dev *rt2x00dev,
 	dump_hdr->chip_rf = cpu_to_le16(rt2x00dev->chip.rf);
 	dump_hdr->chip_rev = cpu_to_le32(rt2x00dev->chip.rev);
 	dump_hdr->type = cpu_to_le16(desc->frame_type);
-	dump_hdr->ring_index = ring_index;
-	dump_hdr->entry_index = entry_index;
+	dump_hdr->ring_index = desc->ring->queue_idx;
+	dump_hdr->entry_index = desc->entry->entry_idx;
 	dump_hdr->timestamp_sec = cpu_to_le32(timestamp.tv_sec);
 	dump_hdr->timestamp_usec = cpu_to_le32(timestamp.tv_usec);
 
diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index a771a09..9b2bd91 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -988,6 +988,7 @@ static int rt2x00lib_alloc_entries(struct data_ring *ring,
 		entry[i].flags = 0;
 		entry[i].ring = ring;
 		entry[i].skb = NULL;
+		entry[i].entry_idx = i;
 	}
 
 	ring->entry = entry;
@@ -1115,6 +1116,7 @@ exit:
 static int rt2x00lib_alloc_rings(struct rt2x00_dev *rt2x00dev)
 {
 	struct data_ring *ring;
+	unsigned int index;
 
 	/*
 	 * We need the following rings:
@@ -1145,8 +1147,10 @@ static int rt2x00lib_alloc_rings(struct rt2x00_dev *rt2x00dev)
 	 * cw_min: 2^5 = 32.
 	 * cw_max: 2^10 = 1024.
 	 */
+	index = 0;
 	ring_for_each(rt2x00dev, ring) {
 		ring->rt2x00dev = rt2x00dev;
+		ring->queue_idx = index++;
 		ring->tx_params.aifs = 2;
 		ring->tx_params.cw_min = 5;
 		ring->tx_params.cw_max = 10;
diff --git a/drivers/net/wireless/rt2x00/rt2x00ring.h b/drivers/net/wireless/rt2x00/rt2x00ring.h
index 5b32f3e..e9a5648 100644
--- a/drivers/net/wireless/rt2x00/rt2x00ring.h
+++ b/drivers/net/wireless/rt2x00/rt2x00ring.h
@@ -143,6 +143,11 @@ struct data_entry {
 	 */
 	void *data_addr;
 	dma_addr_t data_dma;
+
+	/*
+	 * Entry identification number (index).
+	 */
+	unsigned int entry_idx;
 };
 
 /*
@@ -181,6 +186,13 @@ struct data_ring {
 	void *data_addr;
 
 	/*
+	 * Queue identification number:
+	 * RX: 0
+	 * TX: IEEE80211_TX_*
+	 */
+	unsigned int queue_idx;
+
+	/*
 	 * Index variables.
 	 */
 	u16 index;
diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index f5b3378..3bfc5af 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -1031,8 +1031,10 @@ static void rt61pci_init_txring(struct rt2x00_dev *rt2x00dev, const int queue)
 		rt2x00_desc_write(txd, 1, word);
 
 		rt2x00_desc_read(txd, 5, &word);
-		rt2x00_set_field32(&word, TXD_W5_PID_TYPE, queue);
-		rt2x00_set_field32(&word, TXD_W5_PID_SUBTYPE, i);
+		rt2x00_set_field32(&word, TXD_W5_PID_TYPE,
+				   ring->queue_idx);
+		rt2x00_set_field32(&word, TXD_W5_PID_SUBTYPE,
+				   ring->entry[i].entry_idx);
 		rt2x00_desc_write(txd, 5, word);
 
 		rt2x00_desc_read(txd, 6, &word);
-- 
1.5.3.7

