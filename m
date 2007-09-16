Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.250]:52973 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751608AbXIPMIC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 16 Sep 2007 08:08:02 -0400
Received: by an-out-0708.google.com with SMTP id d31so189208and
        for <linux-wireless@vger.kernel.org>; Sun, 16 Sep 2007 05:08:01 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 7/24] rt2x00: Cleanup entry->flags
Date: Sun, 16 Sep 2007 14:18:22 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200709161403.11332.IvDoorn@gmail.com>
In-Reply-To: <200709161403.11332.IvDoorn@gmail.com>
MIME-Version: 1.0
Message-Id: <200709161418.23564.IvDoorn@gmail.com>
Content-Type: text/plain;
  charset="utf-8"
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

By moving all TXD flags from entry->flags to the
desc->flags we can remove entry argument for
write_tx_desc and replace it with the ring argument.

This will remove unrequired access to the entry array
inside the dataring.

Remove entry argument from write_tx_desc, by adding
rt2x00_get_ring from write_tx_ring itself we can better
check for NULL and we can use a fallback ring to get
the cw_min/cw_max values from.

Also remove the ring usage from beacon_update in
rt61pci and rt73usb. Since they no longer use the
beacon ring DMA, they shouldn't use the ring structure
either.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2400pci.c  |    7 ++---
 drivers/net/wireless/rt2x00/rt2500pci.c  |   15 +++++------
 drivers/net/wireless/rt2x00/rt2500usb.c  |   16 +++++-------
 drivers/net/wireless/rt2x00/rt2x00.h     |    3 +-
 drivers/net/wireless/rt2x00/rt2x00dev.c  |   37 +++++++++++++++++++++--------
 drivers/net/wireless/rt2x00/rt2x00pci.c  |    4 +-
 drivers/net/wireless/rt2x00/rt2x00ring.h |   23 +++++++++++++-----
 drivers/net/wireless/rt2x00/rt2x00usb.c  |    5 +--
 drivers/net/wireless/rt2x00/rt61pci.c    |   31 ++++++++++--------------
 drivers/net/wireless/rt2x00/rt73usb.c    |   28 +++++++++-------------
 10 files changed, 90 insertions(+), 79 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2400pci.c b/drivers/net/wireless/rt2x00/rt2400pci.c
index cdafbee..22834a5 100644
--- a/drivers/net/wireless/rt2x00/rt2400pci.c
+++ b/drivers/net/wireless/rt2x00/rt2400pci.c
@@ -1091,7 +1091,6 @@ static int rt2400pci_set_device_state(struct rt2x00_dev *rt2x00dev,
  * TX descriptor initialization
  */
 static void rt2400pci_write_tx_desc(struct rt2x00_dev *rt2x00dev,
-				    struct data_entry *entry,
 				    struct data_desc *txd,
 				    struct data_entry_desc *desc,
 				    struct ieee80211_hdr *ieee80211hdr,
@@ -1145,13 +1144,13 @@ static void rt2400pci_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 	rt2x00_set_field32(&word, TXD_W0_OWNER_NIC, 1);
 	rt2x00_set_field32(&word, TXD_W0_VALID, 1);
 	rt2x00_set_field32(&word, TXD_W0_MORE_FRAG,
-			   test_bit(ENTRY_TXD_MORE_FRAG, &entry->flags));
+			   test_bit(ENTRY_TXD_MORE_FRAG, &desc->flags));
 	rt2x00_set_field32(&word, TXD_W0_ACK,
 			   !(control->flags & IEEE80211_TXCTL_NO_ACK));
 	rt2x00_set_field32(&word, TXD_W0_TIMESTAMP,
-			   test_bit(ENTRY_TXD_REQ_TIMESTAMP, &entry->flags));
+			   test_bit(ENTRY_TXD_REQ_TIMESTAMP, &desc->flags));
 	rt2x00_set_field32(&word, TXD_W0_RTS,
-			   test_bit(ENTRY_TXD_RTS_FRAME, &entry->flags));
+			   test_bit(ENTRY_TXD_RTS_FRAME, &desc->flags));
 	rt2x00_set_field32(&word, TXD_W0_IFS, desc->ifs);
 	rt2x00_set_field32(&word, TXD_W0_RETRY_MODE,
 			   !!(control->flags &
diff --git a/drivers/net/wireless/rt2x00/rt2500pci.c b/drivers/net/wireless/rt2x00/rt2500pci.c
index 03c85a2..be82f2d 100644
--- a/drivers/net/wireless/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/rt2x00/rt2500pci.c
@@ -1236,7 +1236,6 @@ static int rt2500pci_set_device_state(struct rt2x00_dev *rt2x00dev,
  * TX descriptor initialization
  */
 static void rt2500pci_write_tx_desc(struct rt2x00_dev *rt2x00dev,
-				    struct data_entry *entry,
 				    struct data_desc *txd,
 				    struct data_entry_desc *desc,
 				    struct ieee80211_hdr *ieee80211hdr,
@@ -1250,9 +1249,9 @@ static void rt2500pci_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 	 */
 	rt2x00_desc_read(txd, 2, &word);
 	rt2x00_set_field32(&word, TXD_W2_IV_OFFSET, IEEE80211_HEADER);
-	rt2x00_set_field32(&word, TXD_W2_AIFS, entry->ring->tx_params.aifs);
-	rt2x00_set_field32(&word, TXD_W2_CWMIN, entry->ring->tx_params.cw_min);
-	rt2x00_set_field32(&word, TXD_W2_CWMAX, entry->ring->tx_params.cw_max);
+	rt2x00_set_field32(&word, TXD_W2_AIFS, desc->aifs);
+	rt2x00_set_field32(&word, TXD_W2_CWMIN, desc->cw_min);
+	rt2x00_set_field32(&word, TXD_W2_CWMAX, desc->cw_max);
 	rt2x00_desc_write(txd, 2, word);
 
 	rt2x00_desc_read(txd, 3, &word);
@@ -1264,20 +1263,20 @@ static void rt2500pci_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 
 	rt2x00_desc_read(txd, 10, &word);
 	rt2x00_set_field32(&word, TXD_W10_RTS,
-			   test_bit(ENTRY_TXD_RTS_FRAME, &entry->flags));
+			   test_bit(ENTRY_TXD_RTS_FRAME, &desc->flags));
 	rt2x00_desc_write(txd, 10, word);
 
 	rt2x00_desc_read(txd, 0, &word);
 	rt2x00_set_field32(&word, TXD_W0_OWNER_NIC, 1);
 	rt2x00_set_field32(&word, TXD_W0_VALID, 1);
 	rt2x00_set_field32(&word, TXD_W0_MORE_FRAG,
-			   test_bit(ENTRY_TXD_MORE_FRAG, &entry->flags));
+			   test_bit(ENTRY_TXD_MORE_FRAG, &desc->flags));
 	rt2x00_set_field32(&word, TXD_W0_ACK,
 			   !(control->flags & IEEE80211_TXCTL_NO_ACK));
 	rt2x00_set_field32(&word, TXD_W0_TIMESTAMP,
-			   test_bit(ENTRY_TXD_REQ_TIMESTAMP, &entry->flags));
+			   test_bit(ENTRY_TXD_REQ_TIMESTAMP, &desc->flags));
 	rt2x00_set_field32(&word, TXD_W0_OFDM,
-			   test_bit(ENTRY_TXD_OFDM_RATE, &entry->flags));
+			   test_bit(ENTRY_TXD_OFDM_RATE, &desc->flags));
 	rt2x00_set_field32(&word, TXD_W0_CIPHER_OWNER, 1);
 	rt2x00_set_field32(&word, TXD_W0_IFS, desc->ifs);
 	rt2x00_set_field32(&word, TXD_W0_RETRY_MODE,
diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
index 06219ce..c4f12cd 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/rt2x00/rt2500usb.c
@@ -1034,7 +1034,6 @@ static int rt2500usb_set_device_state(struct rt2x00_dev *rt2x00dev,
  * TX descriptor initialization
  */
 static void rt2500usb_write_tx_desc(struct rt2x00_dev *rt2x00dev,
-				    struct data_entry *entry,
 				    struct data_desc *txd,
 				    struct data_entry_desc *desc,
 				    struct ieee80211_hdr *ieee80211hdr,
@@ -1048,9 +1047,9 @@ static void rt2500usb_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 	 */
 	rt2x00_desc_read(txd, 1, &word);
 	rt2x00_set_field32(&word, TXD_W1_IV_OFFSET, IEEE80211_HEADER);
-	rt2x00_set_field32(&word, TXD_W1_AIFS, entry->ring->tx_params.aifs);
-	rt2x00_set_field32(&word, TXD_W1_CWMIN, entry->ring->tx_params.cw_min);
-	rt2x00_set_field32(&word, TXD_W1_CWMAX, entry->ring->tx_params.cw_max);
+	rt2x00_set_field32(&word, TXD_W1_AIFS, desc->aifs);
+	rt2x00_set_field32(&word, TXD_W1_CWMIN, desc->cw_min);
+	rt2x00_set_field32(&word, TXD_W1_CWMAX, desc->cw_max);
 	rt2x00_desc_write(txd, 1, word);
 
 	rt2x00_desc_read(txd, 2, &word);
@@ -1063,13 +1062,13 @@ static void rt2500usb_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 	rt2x00_desc_read(txd, 0, &word);
 	rt2x00_set_field32(&word, TXD_W0_RETRY_LIMIT, control->retry_limit);
 	rt2x00_set_field32(&word, TXD_W0_MORE_FRAG,
-			   test_bit(ENTRY_TXD_MORE_FRAG, &entry->flags));
+			   test_bit(ENTRY_TXD_MORE_FRAG, &desc->flags));
 	rt2x00_set_field32(&word, TXD_W0_ACK,
 			   !(control->flags & IEEE80211_TXCTL_NO_ACK));
 	rt2x00_set_field32(&word, TXD_W0_TIMESTAMP,
-			   test_bit(ENTRY_TXD_REQ_TIMESTAMP, &entry->flags));
+			   test_bit(ENTRY_TXD_REQ_TIMESTAMP, &desc->flags));
 	rt2x00_set_field32(&word, TXD_W0_OFDM,
-			   test_bit(ENTRY_TXD_OFDM_RATE, &entry->flags));
+			   test_bit(ENTRY_TXD_OFDM_RATE, &desc->flags));
 	rt2x00_set_field32(&word, TXD_W0_NEW_SEQ,
 			   !!(control->flags & IEEE80211_TXCTL_FIRST_FRAGMENT));
 	rt2x00_set_field32(&word, TXD_W0_IFS, desc->ifs);
@@ -1620,8 +1619,7 @@ static int rt2500usb_beacon_update(struct ieee80211_hw *hw,
 	 * First we create the beacon.
 	 */
 	skb_push(skb, ring->desc_size);
-	rt2x00lib_write_tx_desc(rt2x00dev, beacon,
-				(struct data_desc *)skb->data,
+	rt2x00lib_write_tx_desc(rt2x00dev, (struct data_desc *)skb->data,
 				(struct ieee80211_hdr *)(skb->data +
 							 ring->desc_size),
 				skb->len - ring->desc_size, control);
diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index 1f5b3cb..40dd52b 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -401,7 +401,6 @@ struct rt2x00lib_ops {
 	 * TX control handlers
 	 */
 	void (*write_tx_desc) (struct rt2x00_dev *rt2x00dev,
-			       struct data_entry *entry,
 			       struct data_desc *txd,
 			       struct data_entry_desc *desc,
 			       struct ieee80211_hdr *ieee80211hdr,
@@ -763,7 +762,7 @@ void rt2x00lib_rxdone(struct data_entry *entry, struct sk_buff *skb,
  * TX descriptor initializer
  */
 void rt2x00lib_write_tx_desc(struct rt2x00_dev *rt2x00dev,
-			     struct data_entry *entry, struct data_desc *txd,
+			     struct data_desc *txd,
 			     struct ieee80211_hdr *ieee80211hdr,
 			     unsigned int length,
 			     struct ieee80211_tx_control *control);
diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index 09c31e3..fed2cce 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -388,13 +388,13 @@ EXPORT_SYMBOL_GPL(rt2x00lib_rxdone);
  * TX descriptor initializer
  */
 void rt2x00lib_write_tx_desc(struct rt2x00_dev *rt2x00dev,
-			     struct data_entry *entry,
 			     struct data_desc *txd,
 			     struct ieee80211_hdr *ieee80211hdr,
 			     unsigned int length,
 			     struct ieee80211_tx_control *control)
 {
 	struct data_entry_desc desc;
+	struct data_ring *ring;
 	int tx_rate;
 	int bitrate;
 	int duration;
@@ -403,6 +403,23 @@ void rt2x00lib_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 	u16 seq_ctrl;
 
 	/*
+	 * Make sure the descriptor is properly cleared.
+	 */
+	memset(&desc, 0x00, sizeof(desc));
+
+	/*
+	 * Get ring pointer, if we fail to obtain the
+	 * correct ring, then use the first TX ring.
+	 */
+	ring = rt2x00lib_get_ring(rt2x00dev, control->queue);
+	if (!ring)
+		ring = rt2x00lib_get_ring(rt2x00dev, IEEE80211_TX_QUEUE_DATA0);
+
+	desc.cw_min = ring->tx_params.cw_min;
+	desc.cw_max = ring->tx_params.cw_max;
+	desc.aifs = ring->tx_params.aifs;
+
+	/*
 	 * Identify queue
 	 */
 	if (control->queue < rt2x00dev->hw->queues)
@@ -422,9 +439,9 @@ void rt2x00lib_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 	 * Check if this is a RTS/CTS frame
 	 */
 	if (is_rts_frame(frame_control) || is_cts_frame(frame_control)) {
-		__set_bit(ENTRY_TXD_BURST, &entry->flags);
+		__set_bit(ENTRY_TXD_BURST, &desc.flags);
 		if (is_rts_frame(frame_control))
-			__set_bit(ENTRY_TXD_RTS_FRAME, &entry->flags);
+			__set_bit(ENTRY_TXD_RTS_FRAME, &desc.flags);
 		if (control->rts_cts_rate)
 			tx_rate = control->rts_cts_rate;
 	}
@@ -433,14 +450,14 @@ void rt2x00lib_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 	 * Check for OFDM
 	 */
 	if (DEVICE_GET_RATE_FIELD(tx_rate, RATEMASK) & DEV_OFDM_RATEMASK)
-		__set_bit(ENTRY_TXD_OFDM_RATE, &entry->flags);
+		__set_bit(ENTRY_TXD_OFDM_RATE, &desc.flags);
 
 	/*
 	 * Check if more fragments are pending
 	 */
 	if (ieee80211_get_morefrag(ieee80211hdr)) {
-		__set_bit(ENTRY_TXD_BURST, &entry->flags);
-		__set_bit(ENTRY_TXD_MORE_FRAG, &entry->flags);
+		__set_bit(ENTRY_TXD_BURST, &desc.flags);
+		__set_bit(ENTRY_TXD_MORE_FRAG, &desc.flags);
 	}
 
 	/*
@@ -449,7 +466,7 @@ void rt2x00lib_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 	 */
 	if (control->queue == IEEE80211_TX_QUEUE_BEACON ||
 	    is_probe_resp(frame_control))
-		__set_bit(ENTRY_TXD_REQ_TIMESTAMP, &entry->flags);
+		__set_bit(ENTRY_TXD_REQ_TIMESTAMP, &desc.flags);
 
 	/*
 	 * Determine with what IFS priority this frame should be send.
@@ -457,7 +474,7 @@ void rt2x00lib_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 	 * or this fragment came after RTS/CTS.
 	 */
 	if ((seq_ctrl & IEEE80211_SCTL_FRAG) > 0 ||
-	    test_bit(ENTRY_TXD_RTS_FRAME, &entry->flags))
+	    test_bit(ENTRY_TXD_RTS_FRAME, &desc.flags))
 		desc.ifs = IFS_SIFS;
 	else
 		desc.ifs = IFS_BACKOFF;
@@ -469,7 +486,7 @@ void rt2x00lib_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 	desc.signal = DEVICE_GET_RATE_FIELD(tx_rate, PLCP);
 	desc.service = 0x04;
 
-	if (test_bit(ENTRY_TXD_OFDM_RATE, &entry->flags)) {
+	if (test_bit(ENTRY_TXD_OFDM_RATE, &desc.flags)) {
 		desc.length_high = ((length + FCS_LEN) >> 6) & 0x3f;
 		desc.length_low = ((length + FCS_LEN) & 0x3f);
 	} else {
@@ -502,7 +519,7 @@ void rt2x00lib_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 			desc.signal |= 0x08;
 	}
 
-	rt2x00dev->ops->lib->write_tx_desc(rt2x00dev, entry, txd, &desc,
+	rt2x00dev->ops->lib->write_tx_desc(rt2x00dev, txd, &desc,
 					   ieee80211hdr, length, control);
 }
 EXPORT_SYMBOL_GPL(rt2x00lib_write_tx_desc);
diff --git a/drivers/net/wireless/rt2x00/rt2x00pci.c b/drivers/net/wireless/rt2x00/rt2x00pci.c
index 66fce58..f61cc7f 100644
--- a/drivers/net/wireless/rt2x00/rt2x00pci.c
+++ b/drivers/net/wireless/rt2x00/rt2x00pci.c
@@ -58,7 +58,7 @@ int rt2x00pci_beacon_update(struct ieee80211_hw *hw, struct sk_buff *skb,
 	 * Update the beacon entry.
 	 */
 	memcpy(entry->data_addr, skb->data, skb->len);
-	rt2x00lib_write_tx_desc(rt2x00dev, entry, entry->priv,
+	rt2x00lib_write_tx_desc(rt2x00dev, entry->priv,
 				(struct ieee80211_hdr *)skb->data,
 				skb->len, control);
 
@@ -103,7 +103,7 @@ int rt2x00pci_write_tx_data(struct rt2x00_dev *rt2x00dev,
 	entry->skb = skb;
 	memcpy(&entry->tx_status.control, control, sizeof(*control));
 	memcpy(entry->data_addr, skb->data, skb->len);
-	rt2x00lib_write_tx_desc(rt2x00dev, entry, txd, ieee80211hdr,
+	rt2x00lib_write_tx_desc(rt2x00dev, txd, ieee80211hdr,
 				skb->len, control);
 
 	rt2x00_ring_index_inc(ring);
diff --git a/drivers/net/wireless/rt2x00/rt2x00ring.h b/drivers/net/wireless/rt2x00/rt2x00ring.h
index 143ad6d..78e128a 100644
--- a/drivers/net/wireless/rt2x00/rt2x00ring.h
+++ b/drivers/net/wireless/rt2x00/rt2x00ring.h
@@ -46,6 +46,16 @@ struct data_desc {
  * descriptor for sending a TX frame.
  */
 struct data_entry_desc {
+	unsigned long flags;
+#define ENTRY_TXDONE		1
+#define ENTRY_TXD_RTS_FRAME	2
+#define ENTRY_TXD_OFDM_RATE	3
+#define ENTRY_TXD_MORE_FRAG	4
+#define ENTRY_TXD_REQ_TIMESTAMP	5
+#define ENTRY_TXD_BURST		6
+
+	int queue;
+
 	/*
 	 * PLCP values.
 	 */
@@ -54,8 +64,13 @@ struct data_entry_desc {
 	u16 signal;
 	u16 service;
 
-	int queue;
+	/*
+	 * Timing information
+	 */
+	int aifs;
 	int ifs;
+	int cw_min;
+	int cw_max;
 };
 
 /*
@@ -71,12 +86,6 @@ struct data_entry {
 	 */
 	unsigned long flags;
 #define ENTRY_OWNER_NIC		1
-#define ENTRY_TXDONE		2
-#define ENTRY_TXD_RTS_FRAME	3
-#define ENTRY_TXD_OFDM_RATE	4
-#define ENTRY_TXD_MORE_FRAG	5
-#define ENTRY_TXD_REQ_TIMESTAMP	6
-#define ENTRY_TXD_BURST		7
 
 	/*
 	 * Ring we belong to.
diff --git a/drivers/net/wireless/rt2x00/rt2x00usb.c b/drivers/net/wireless/rt2x00/rt2x00usb.c
index 246ba93..ede3766 100644
--- a/drivers/net/wireless/rt2x00/rt2x00usb.c
+++ b/drivers/net/wireless/rt2x00/rt2x00usb.c
@@ -183,9 +183,8 @@ int rt2x00usb_write_tx_data(struct rt2x00_dev *rt2x00dev,
 	skb_push(skb, rt2x00dev->hw->extra_tx_headroom);
 	memset(skb->data, 0x00, rt2x00dev->hw->extra_tx_headroom);
 
-	rt2x00lib_write_tx_desc(rt2x00dev, entry,
-				(struct data_desc *)skb->data, ieee80211hdr,
-				length, control);
+	rt2x00lib_write_tx_desc(rt2x00dev, (struct data_desc *)skb->data,
+				ieee80211hdr, length, control);
 	memcpy(&entry->tx_status.control, control, sizeof(*control));
 	entry->skb = skb;
 
diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index fe9edb9..b94f005 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -1089,7 +1089,6 @@ static int rt61pci_init_rings(struct rt2x00_dev *rt2x00dev)
 	rt61pci_init_txring(rt2x00dev, IEEE80211_TX_QUEUE_DATA2);
 	rt61pci_init_txring(rt2x00dev, IEEE80211_TX_QUEUE_DATA3);
 	rt61pci_init_txring(rt2x00dev, IEEE80211_TX_QUEUE_DATA4);
-	rt61pci_init_txring(rt2x00dev, IEEE80211_TX_QUEUE_BEACON);
 
 	/*
 	 * Initialize registers.
@@ -1489,7 +1488,6 @@ static int rt61pci_set_device_state(struct rt2x00_dev *rt2x00dev,
  * TX descriptor initialization
  */
 static void rt61pci_write_tx_desc(struct rt2x00_dev *rt2x00dev,
-				  struct data_entry *entry,
 				  struct data_desc *txd,
 				  struct data_entry_desc *desc,
 				  struct ieee80211_hdr *ieee80211hdr,
@@ -1503,9 +1501,9 @@ static void rt61pci_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 	 */
 	rt2x00_desc_read(txd, 1, &word);
 	rt2x00_set_field32(&word, TXD_W1_HOST_Q_ID, desc->queue);
-	rt2x00_set_field32(&word, TXD_W1_AIFSN, entry->ring->tx_params.aifs);
-	rt2x00_set_field32(&word, TXD_W1_CWMIN, entry->ring->tx_params.cw_min);
-	rt2x00_set_field32(&word, TXD_W1_CWMAX, entry->ring->tx_params.cw_max);
+	rt2x00_set_field32(&word, TXD_W1_AIFSN, desc->aifs);
+	rt2x00_set_field32(&word, TXD_W1_CWMIN, desc->cw_min);
+	rt2x00_set_field32(&word, TXD_W1_CWMAX, desc->cw_max);
 	rt2x00_set_field32(&word, TXD_W1_IV_OFFSET, IEEE80211_HEADER);
 	rt2x00_set_field32(&word, TXD_W1_HW_SEQUENCE, 1);
 	rt2x00_desc_write(txd, 1, word);
@@ -1531,13 +1529,13 @@ static void rt61pci_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 	rt2x00_set_field32(&word, TXD_W0_OWNER_NIC, 1);
 	rt2x00_set_field32(&word, TXD_W0_VALID, 1);
 	rt2x00_set_field32(&word, TXD_W0_MORE_FRAG,
-			   test_bit(ENTRY_TXD_MORE_FRAG, &entry->flags));
+			   test_bit(ENTRY_TXD_MORE_FRAG, &desc->flags));
 	rt2x00_set_field32(&word, TXD_W0_ACK,
 			   !(control->flags & IEEE80211_TXCTL_NO_ACK));
 	rt2x00_set_field32(&word, TXD_W0_TIMESTAMP,
-			   test_bit(ENTRY_TXD_REQ_TIMESTAMP, &entry->flags));
+			   test_bit(ENTRY_TXD_REQ_TIMESTAMP, &desc->flags));
 	rt2x00_set_field32(&word, TXD_W0_OFDM,
-			   test_bit(ENTRY_TXD_OFDM_RATE, &entry->flags));
+			   test_bit(ENTRY_TXD_OFDM_RATE, &desc->flags));
 	rt2x00_set_field32(&word, TXD_W0_IFS, desc->ifs);
 	rt2x00_set_field32(&word, TXD_W0_RETRY_MODE,
 			   !!(control->flags &
@@ -1545,7 +1543,7 @@ static void rt61pci_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 	rt2x00_set_field32(&word, TXD_W0_TKIP_MIC, 0);
 	rt2x00_set_field32(&word, TXD_W0_DATABYTE_COUNT, length);
 	rt2x00_set_field32(&word, TXD_W0_BURST,
-			   test_bit(ENTRY_TXD_BURST, &entry->flags));
+			   test_bit(ENTRY_TXD_BURST, &desc->flags));
 	rt2x00_set_field32(&word, TXD_W0_CIPHER_ALG, CIPHER_NONE);
 	rt2x00_desc_write(txd, 0, word);
 }
@@ -2255,8 +2253,6 @@ int rt61pci_beacon_update(struct ieee80211_hw *hw, struct sk_buff *skb,
 			  struct ieee80211_tx_control *control)
 {
 	struct rt2x00_dev *rt2x00dev = hw->priv;
-	struct data_ring *ring =
-	    rt2x00lib_get_ring(rt2x00dev, IEEE80211_TX_QUEUE_BEACON);
 
 	/*
 	 * Just in case the ieee80211 doesn't set this,
@@ -2269,8 +2265,8 @@ int rt61pci_beacon_update(struct ieee80211_hw *hw, struct sk_buff *skb,
 	 * We need to append the descriptor in front of the
 	 * beacon frame.
 	 */
-	if (skb_headroom(skb) < ring->desc_size) {
-		if (pskb_expand_head(skb, ring->desc_size, 0, GFP_ATOMIC)) {
+	if (skb_headroom(skb) < TXD_DESC_SIZE) {
+		if (pskb_expand_head(skb, TXD_DESC_SIZE, 0, GFP_ATOMIC)) {
 			dev_kfree_skb(skb);
 			return -ENOMEM;
 		}
@@ -2279,12 +2275,11 @@ int rt61pci_beacon_update(struct ieee80211_hw *hw, struct sk_buff *skb,
 	/*
 	 * First we create the beacon.
 	 */
-	skb_push(skb, ring->desc_size);
-	rt2x00lib_write_tx_desc(rt2x00dev, ring->entry,
-				(struct data_desc *)skb->data,
+	skb_push(skb, TXD_DESC_SIZE);
+	rt2x00lib_write_tx_desc(rt2x00dev, (struct data_desc *)skb->data,
 				(struct ieee80211_hdr *)(skb->data +
-							 ring->desc_size),
-				skb->len - ring->desc_size, control);
+							 TXD_DESC_SIZE),
+				skb->len - TXD_DESC_SIZE, control);
 
 	/*
 	 * Write entire beacon with descriptor to register,
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index 78c15f4..feb211d 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -1230,7 +1230,6 @@ static int rt73usb_set_device_state(struct rt2x00_dev *rt2x00dev,
  * TX descriptor initialization
  */
 static void rt73usb_write_tx_desc(struct rt2x00_dev *rt2x00dev,
-				  struct data_entry *entry,
 				  struct data_desc *txd,
 				  struct data_entry_desc *desc,
 				  struct ieee80211_hdr *ieee80211hdr,
@@ -1244,9 +1243,9 @@ static void rt73usb_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 	 */
 	rt2x00_desc_read(txd, 1, &word);
 	rt2x00_set_field32(&word, TXD_W1_HOST_Q_ID, desc->queue);
-	rt2x00_set_field32(&word, TXD_W1_AIFSN, entry->ring->tx_params.aifs);
-	rt2x00_set_field32(&word, TXD_W1_CWMIN, entry->ring->tx_params.cw_min);
-	rt2x00_set_field32(&word, TXD_W1_CWMAX, entry->ring->tx_params.cw_max);
+	rt2x00_set_field32(&word, TXD_W1_AIFSN, desc->aifs);
+	rt2x00_set_field32(&word, TXD_W1_CWMIN, desc->cw_min);
+	rt2x00_set_field32(&word, TXD_W1_CWMAX, desc->cw_max);
 	rt2x00_set_field32(&word, TXD_W1_IV_OFFSET, IEEE80211_HEADER);
 	rt2x00_set_field32(&word, TXD_W1_HW_SEQUENCE, 1);
 	rt2x00_desc_write(txd, 1, word);
@@ -1266,16 +1265,16 @@ static void rt73usb_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 
 	rt2x00_desc_read(txd, 0, &word);
 	rt2x00_set_field32(&word, TXD_W0_BURST,
-			   test_bit(ENTRY_TXD_BURST, &entry->flags));
+			   test_bit(ENTRY_TXD_BURST, &desc->flags));
 	rt2x00_set_field32(&word, TXD_W0_VALID, 1);
 	rt2x00_set_field32(&word, TXD_W0_MORE_FRAG,
-			   test_bit(ENTRY_TXD_MORE_FRAG, &entry->flags));
+			   test_bit(ENTRY_TXD_MORE_FRAG, &desc->flags));
 	rt2x00_set_field32(&word, TXD_W0_ACK,
 			   !(control->flags & IEEE80211_TXCTL_NO_ACK));
 	rt2x00_set_field32(&word, TXD_W0_TIMESTAMP,
-			   test_bit(ENTRY_TXD_REQ_TIMESTAMP, &entry->flags));
+			   test_bit(ENTRY_TXD_REQ_TIMESTAMP, &desc->flags));
 	rt2x00_set_field32(&word, TXD_W0_OFDM,
-			   test_bit(ENTRY_TXD_OFDM_RATE, &entry->flags));
+			   test_bit(ENTRY_TXD_OFDM_RATE, &desc->flags));
 	rt2x00_set_field32(&word, TXD_W0_IFS, desc->ifs);
 	rt2x00_set_field32(&word, TXD_W0_RETRY_MODE,
 			   !!(control->flags &
@@ -1283,7 +1282,7 @@ static void rt73usb_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 	rt2x00_set_field32(&word, TXD_W0_TKIP_MIC, 0);
 	rt2x00_set_field32(&word, TXD_W0_DATABYTE_COUNT, length);
 	rt2x00_set_field32(&word, TXD_W0_BURST2,
-			   test_bit(ENTRY_TXD_BURST, &entry->flags));
+			   test_bit(ENTRY_TXD_BURST, &desc->flags));
 	rt2x00_set_field32(&word, TXD_W0_CIPHER_ALG, CIPHER_NONE);
 	rt2x00_desc_write(txd, 0, word);
 }
@@ -1870,8 +1869,6 @@ int rt73usb_beacon_update(struct ieee80211_hw *hw, struct sk_buff *skb,
 			  struct ieee80211_tx_control *control)
 {
 	struct rt2x00_dev *rt2x00dev = hw->priv;
-	struct data_ring *ring =
-	    rt2x00lib_get_ring(rt2x00dev, IEEE80211_TX_QUEUE_BEACON);
 	int timeout;
 
 	/*
@@ -1884,12 +1881,11 @@ int rt73usb_beacon_update(struct ieee80211_hw *hw, struct sk_buff *skb,
 	/*
 	 * First we create the beacon.
 	 */
-	skb_push(skb, ring->desc_size);
-	rt2x00lib_write_tx_desc(rt2x00dev, ring->entry,
-				(struct data_desc *)skb->data,
+	skb_push(skb, TXD_DESC_SIZE);
+	rt2x00lib_write_tx_desc(rt2x00dev, (struct data_desc *)skb->data,
 				(struct ieee80211_hdr *)(skb->data +
-							 ring->desc_size),
-				skb->len - ring->desc_size, control);
+							 TXD_DESC_SIZE),
+				skb->len - TXD_DESC_SIZE, control);
 
 	/*
 	 * Write entire beacon with descriptor to register,
-- 
1.5.3
