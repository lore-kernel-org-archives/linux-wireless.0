Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.152]:54673 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753430AbYEJMK0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 May 2008 08:10:26 -0400
Received: by fg-out-1718.google.com with SMTP id 19so1148254fgg.17
        for <linux-wireless@vger.kernel.org>; Sat, 10 May 2008 05:10:25 -0700 (PDT)
To: linville@tuxdriver.com
Subject: [PATCH 12/16] rt2x00: Split rt2x00lib_write_tx_desc()
Date: Sat, 10 May 2008 13:46:13 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200805101337.14536.IvDoorn@gmail.com>
In-Reply-To: <200805101337.14536.IvDoorn@gmail.com>
MIME-Version: 1.0
Message-Id: <200805101346.13913.IvDoorn@gmail.com> (sfid-20080510_141040_513768_C5E0AEAF)
Content-Type: text/plain;
  charset="utf-8"
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Split rt2x00lib_write_tx_desc() up into a TX descriptor initializor
and TX descriptor writer.

This split is required to properly allow mac80211 to move its
tx_control structure into the skb->cb array.
The rt2x00queue_create_tx_descriptor() function will read all tx control
information and convert it into a rt2x00 TX descriptor information structure.
After that function is complete, we have all information we needed from the
tx control structure and are free to start writing into the skb->cb array
for our own purposes.
rt2x00queue_write_tx_descriptor() will be in charge of really sending
the TX descriptor to the hardware and kicking the TX queue.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2400pci.c   |   11 ++-
 drivers/net/wireless/rt2x00/rt2500pci.c   |   11 ++-
 drivers/net/wireless/rt2x00/rt2500usb.c   |   11 ++-
 drivers/net/wireless/rt2x00/rt2x00.h      |   42 +++++++--
 drivers/net/wireless/rt2x00/rt2x00dev.c   |  148 ---------------------------
 drivers/net/wireless/rt2x00/rt2x00pci.c   |   11 ++-
 drivers/net/wireless/rt2x00/rt2x00queue.c |  157 +++++++++++++++++++++++++++++
 drivers/net/wireless/rt2x00/rt2x00queue.h |    2 +
 drivers/net/wireless/rt2x00/rt2x00usb.c   |   11 ++-
 drivers/net/wireless/rt2x00/rt61pci.c     |   13 ++-
 drivers/net/wireless/rt2x00/rt73usb.c     |   11 ++-
 11 files changed, 265 insertions(+), 163 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2400pci.c b/drivers/net/wireless/rt2x00/rt2400pci.c
index 15d3e41..63ef3e0 100644
--- a/drivers/net/wireless/rt2x00/rt2400pci.c
+++ b/drivers/net/wireless/rt2x00/rt2400pci.c
@@ -1493,6 +1493,7 @@ static int rt2400pci_beacon_update(struct ieee80211_hw *hw, struct sk_buff *skb,
 	struct rt2x00_intf *intf = vif_to_intf(control->vif);
 	struct queue_entry_priv_pci_tx *priv_tx;
 	struct skb_frame_desc *skbdesc;
+	struct txentry_desc txdesc;
 	u32 reg;
 
 	if (unlikely(!intf->beacon))
@@ -1500,6 +1501,14 @@ static int rt2400pci_beacon_update(struct ieee80211_hw *hw, struct sk_buff *skb,
 	priv_tx = intf->beacon->priv_data;
 
 	/*
+	 * Copy all TX descriptor information into txdesc,
+	 * after that we are free to use the skb->cb array
+	 * for our information.
+	 */
+	intf->beacon->skb = skb;
+	rt2x00queue_create_tx_descriptor(intf->beacon, &txdesc, control);
+
+	/*
 	 * Fill in skb descriptor
 	 */
 	skbdesc = get_skb_frame_desc(skb);
@@ -1526,8 +1535,8 @@ static int rt2400pci_beacon_update(struct ieee80211_hw *hw, struct sk_buff *skb,
 	 * Write entire beacon with descriptor to register,
 	 * and kick the beacon generator.
 	 */
-	rt2x00lib_write_tx_desc(rt2x00dev, skb, control);
 	memcpy(priv_tx->data, skb->data, skb->len);
+	rt2x00queue_write_tx_descriptor(intf->beacon, &txdesc);
 	rt2x00dev->ops->lib->kick_tx_queue(rt2x00dev, QID_BEACON);
 
 	return 0;
diff --git a/drivers/net/wireless/rt2x00/rt2500pci.c b/drivers/net/wireless/rt2x00/rt2500pci.c
index 480ed47..24057bc 100644
--- a/drivers/net/wireless/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/rt2x00/rt2500pci.c
@@ -1808,6 +1808,7 @@ static int rt2500pci_beacon_update(struct ieee80211_hw *hw, struct sk_buff *skb,
 	struct rt2x00_intf *intf = vif_to_intf(control->vif);
 	struct queue_entry_priv_pci_tx *priv_tx;
 	struct skb_frame_desc *skbdesc;
+	struct txentry_desc txdesc;
 	u32 reg;
 
 	if (unlikely(!intf->beacon))
@@ -1816,6 +1817,14 @@ static int rt2500pci_beacon_update(struct ieee80211_hw *hw, struct sk_buff *skb,
 	priv_tx = intf->beacon->priv_data;
 
 	/*
+	 * Copy all TX descriptor information into txdesc,
+	 * after that we are free to use the skb->cb array
+	 * for our information.
+	 */
+	intf->beacon->skb = skb;
+	rt2x00queue_create_tx_descriptor(intf->beacon, &txdesc, control);
+
+	/*
 	 * Fill in skb descriptor
 	 */
 	skbdesc = get_skb_frame_desc(skb);
@@ -1842,8 +1851,8 @@ static int rt2500pci_beacon_update(struct ieee80211_hw *hw, struct sk_buff *skb,
 	 * Write entire beacon with descriptor to register,
 	 * and kick the beacon generator.
 	 */
-	rt2x00lib_write_tx_desc(rt2x00dev, skb, control);
 	memcpy(priv_tx->data, skb->data, skb->len);
+	rt2x00queue_write_tx_descriptor(intf->beacon, &txdesc);
 	rt2x00dev->ops->lib->kick_tx_queue(rt2x00dev, QID_BEACON);
 
 	return 0;
diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
index 0a0727a..266a89d 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/rt2x00/rt2500usb.c
@@ -1676,6 +1676,7 @@ static int rt2500usb_beacon_update(struct ieee80211_hw *hw,
 	struct rt2x00_intf *intf = vif_to_intf(control->vif);
 	struct queue_entry_priv_usb_bcn *priv_bcn;
 	struct skb_frame_desc *skbdesc;
+	struct txentry_desc txdesc;
 	int pipe = usb_sndbulkpipe(usb_dev, 1);
 	int length;
 	u16 reg;
@@ -1686,6 +1687,14 @@ static int rt2500usb_beacon_update(struct ieee80211_hw *hw,
 	priv_bcn = intf->beacon->priv_data;
 
 	/*
+	 * Copy all TX descriptor information into txdesc,
+	 * after that we are free to use the skb->cb array
+	 * for our information.
+	 */
+	intf->beacon->skb = skb;
+	rt2x00queue_create_tx_descriptor(intf->beacon, &txdesc, control);
+
+	/*
 	 * Add the descriptor in front of the skb.
 	 */
 	skb_push(skb, intf->beacon->queue->desc_size);
@@ -1713,7 +1722,7 @@ static int rt2500usb_beacon_update(struct ieee80211_hw *hw,
 	rt2x00_set_field16(&reg, TXRX_CSR19_BEACON_GEN, 0);
 	rt2500usb_register_write(rt2x00dev, TXRX_CSR19, reg);
 
-	rt2x00lib_write_tx_desc(rt2x00dev, skb, control);
+	rt2x00queue_write_tx_descriptor(intf->beacon, &txdesc);
 
 	/*
 	 * USB devices cannot blindly pass the skb->len as the
diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index 6f7b34f..9c186d7 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -927,6 +927,41 @@ static inline u16 get_duration_res(const unsigned int size, const u8 rate)
 }
 
 /**
+ * rt2x00queue_create_tx_descriptor - Create TX descriptor from mac80211 input
+ * @entry: The entry which will be used to transfer the TX frame.
+ * @txdesc: rt2x00 TX descriptor which will be initialized by this function.
+ * @control: mac80211 TX control structure from where we read the information.
+ *
+ * This function will initialize the &struct txentry_desc based on information
+ * from mac80211. This descriptor can then be used by rt2x00lib and the drivers
+ * to correctly initialize the hardware descriptor.
+ * Note that before calling this function the skb->cb array must be untouched
+ * by rt2x00lib. Only after this function completes will it be save to
+ * overwrite the skb->cb information.
+ * The reason for this is that mac80211 writes its own tx information into
+ * the skb->cb array, and this function will use that information to initialize
+ * the &struct txentry_desc structure.
+ */
+void rt2x00queue_create_tx_descriptor(struct queue_entry *entry,
+				      struct txentry_desc *txdesc,
+				      struct ieee80211_tx_control *control);
+
+/**
+ * rt2x00queue_write_tx_descriptor - Write TX descriptor to hardware
+ * @entry: The entry which will be used to transfer the TX frame.
+ * @txdesc: TX descriptor which will be used to write hardware descriptor
+ *
+ * This function will write a TX descriptor initialized by
+ * &rt2x00queue_create_tx_descriptor to the hardware. After this call
+ * has completed the frame is now owned by the hardware, the hardware
+ * queue will have automatically be kicked unless this frame was generated
+ * by rt2x00lib, in which case the frame is "special" and must be kicked
+ * by the caller.
+ */
+void rt2x00queue_write_tx_descriptor(struct queue_entry *entry,
+				     struct txentry_desc *txdesc);
+
+/**
  * rt2x00queue_get_queue - Convert queue index to queue pointer
  * @rt2x00dev: Pointer to &struct rt2x00_dev.
  * @queue: rt2x00 queue index (see &enum data_queue_qid).
@@ -964,13 +999,6 @@ void rt2x00lib_rxdone(struct queue_entry *entry,
 		      struct rxdone_entry_desc *rxdesc);
 
 /*
- * TX descriptor initializer
- */
-void rt2x00lib_write_tx_desc(struct rt2x00_dev *rt2x00dev,
-			     struct sk_buff *skb,
-			     struct ieee80211_tx_control *control);
-
-/*
  * mac80211 handlers.
  */
 int rt2x00mac_tx(struct ieee80211_hw *hw, struct sk_buff *skb,
diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index c8255c9..5d48592 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -612,154 +612,6 @@ void rt2x00lib_rxdone(struct queue_entry *entry,
 EXPORT_SYMBOL_GPL(rt2x00lib_rxdone);
 
 /*
- * TX descriptor initializer
- */
-void rt2x00lib_write_tx_desc(struct rt2x00_dev *rt2x00dev,
-			     struct sk_buff *skb,
-			     struct ieee80211_tx_control *control)
-{
-	struct txentry_desc txdesc;
-	struct skb_frame_desc *skbdesc = get_skb_frame_desc(skb);
-	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skbdesc->data;
-	const struct rt2x00_rate *rate;
-	int tx_rate;
-	int length;
-	int duration;
-	int residual;
-	u16 frame_control;
-	u16 seq_ctrl;
-
-	memset(&txdesc, 0, sizeof(txdesc));
-
-	txdesc.queue = skbdesc->entry->queue->qid;
-	txdesc.cw_min = skbdesc->entry->queue->cw_min;
-	txdesc.cw_max = skbdesc->entry->queue->cw_max;
-	txdesc.aifs = skbdesc->entry->queue->aifs;
-
-	/*
-	 * Read required fields from ieee80211 header.
-	 */
-	frame_control = le16_to_cpu(hdr->frame_control);
-	seq_ctrl = le16_to_cpu(hdr->seq_ctrl);
-
-	tx_rate = control->tx_rate->hw_value;
-
-	/*
-	 * Check whether this frame is to be acked
-	 */
-	if (!(control->flags & IEEE80211_TXCTL_NO_ACK))
-		__set_bit(ENTRY_TXD_ACK, &txdesc.flags);
-
-	/*
-	 * Check if this is a RTS/CTS frame
-	 */
-	if (is_rts_frame(frame_control) || is_cts_frame(frame_control)) {
-		__set_bit(ENTRY_TXD_BURST, &txdesc.flags);
-		if (is_rts_frame(frame_control)) {
-			__set_bit(ENTRY_TXD_RTS_FRAME, &txdesc.flags);
-			__set_bit(ENTRY_TXD_ACK, &txdesc.flags);
-		} else
-			__clear_bit(ENTRY_TXD_ACK, &txdesc.flags);
-		if (control->rts_cts_rate)
-			tx_rate = control->rts_cts_rate->hw_value;
-	}
-
-	/*
-	 * Determine retry information.
-	 */
-	txdesc.retry_limit = control->retry_limit;
-	if (control->flags & IEEE80211_TXCTL_LONG_RETRY_LIMIT)
-		__set_bit(ENTRY_TXD_RETRY_MODE, &txdesc.flags);
-
-	/*
-	 * Check if more fragments are pending
-	 */
-	if (ieee80211_get_morefrag(hdr)) {
-		__set_bit(ENTRY_TXD_BURST, &txdesc.flags);
-		__set_bit(ENTRY_TXD_MORE_FRAG, &txdesc.flags);
-	}
-
-	/*
-	 * Beacons and probe responses require the tsf timestamp
-	 * to be inserted into the frame.
-	 */
-	if (txdesc.queue == QID_BEACON || is_probe_resp(frame_control))
-		__set_bit(ENTRY_TXD_REQ_TIMESTAMP, &txdesc.flags);
-
-	/*
-	 * Determine with what IFS priority this frame should be send.
-	 * Set ifs to IFS_SIFS when the this is not the first fragment,
-	 * or this fragment came after RTS/CTS.
-	 */
-	if (test_bit(ENTRY_TXD_RTS_FRAME, &txdesc.flags)) {
-		txdesc.ifs = IFS_SIFS;
-	} else if (control->flags & IEEE80211_TXCTL_FIRST_FRAGMENT) {
-		__set_bit(ENTRY_TXD_FIRST_FRAGMENT, &txdesc.flags);
-		txdesc.ifs = IFS_BACKOFF;
-	} else {
-		txdesc.ifs = IFS_SIFS;
-	}
-
-	/*
-	 * PLCP setup
-	 * Length calculation depends on OFDM/CCK rate.
-	 */
-	rate = rt2x00_get_rate(tx_rate);
-	txdesc.signal = rate->plcp;
-	txdesc.service = 0x04;
-
-	length = skbdesc->data_len + FCS_LEN;
-	if (rate->flags & DEV_RATE_OFDM) {
-		__set_bit(ENTRY_TXD_OFDM_RATE, &txdesc.flags);
-
-		txdesc.length_high = (length >> 6) & 0x3f;
-		txdesc.length_low = length & 0x3f;
-	} else {
-		/*
-		 * Convert length to microseconds.
-		 */
-		residual = get_duration_res(length, rate->bitrate);
-		duration = get_duration(length, rate->bitrate);
-
-		if (residual != 0) {
-			duration++;
-
-			/*
-			 * Check if we need to set the Length Extension
-			 */
-			if (rate->bitrate == 110 && residual <= 30)
-				txdesc.service |= 0x80;
-		}
-
-		txdesc.length_high = (duration >> 8) & 0xff;
-		txdesc.length_low = duration & 0xff;
-
-		/*
-		 * When preamble is enabled we should set the
-		 * preamble bit for the signal.
-		 */
-		if (rt2x00_get_rate_preamble(tx_rate))
-			txdesc.signal |= 0x08;
-	}
-
-	rt2x00dev->ops->lib->write_tx_desc(rt2x00dev, skb, &txdesc);
-
-	/*
-	 * Update queue entry.
-	 */
-	skbdesc->entry->skb = skb;
-
-	/*
-	 * The frame has been completely initialized and ready
-	 * for sending to the device. The caller will push the
-	 * frame to the device, but we are going to push the
-	 * frame to debugfs here.
-	 */
-	rt2x00debug_dump_frame(rt2x00dev, DUMP_FRAME_TX, skb);
-}
-EXPORT_SYMBOL_GPL(rt2x00lib_write_tx_desc);
-
-/*
  * Driver initialization handlers.
  */
 const struct rt2x00_rate rt2x00_supported_rates[12] = {
diff --git a/drivers/net/wireless/rt2x00/rt2x00pci.c b/drivers/net/wireless/rt2x00/rt2x00pci.c
index c17078e..a056b12 100644
--- a/drivers/net/wireless/rt2x00/rt2x00pci.c
+++ b/drivers/net/wireless/rt2x00/rt2x00pci.c
@@ -41,6 +41,7 @@ int rt2x00pci_write_tx_data(struct rt2x00_dev *rt2x00dev,
 	struct queue_entry *entry = rt2x00queue_get_entry(queue, Q_INDEX);
 	struct queue_entry_priv_pci_tx *priv_tx = entry->priv_data;
 	struct skb_frame_desc *skbdesc;
+	struct txentry_desc txdesc;
 	u32 word;
 
 	if (rt2x00queue_full(queue))
@@ -58,6 +59,14 @@ int rt2x00pci_write_tx_data(struct rt2x00_dev *rt2x00dev,
 	}
 
 	/*
+	 * Copy all TX descriptor information into txdesc,
+	 * after that we are free to use the skb->cb array
+	 * for our information.
+	 */
+	entry->skb = skb;
+	rt2x00queue_create_tx_descriptor(entry, &txdesc, control);
+
+	/*
 	 * Fill in skb descriptor
 	 */
 	skbdesc = get_skb_frame_desc(skb);
@@ -69,8 +78,8 @@ int rt2x00pci_write_tx_data(struct rt2x00_dev *rt2x00dev,
 
 	memcpy(&priv_tx->control, control, sizeof(priv_tx->control));
 	memcpy(priv_tx->data, skb->data, skb->len);
-	rt2x00lib_write_tx_desc(rt2x00dev, skb, control);
 
+	rt2x00queue_write_tx_descriptor(entry, &txdesc);
 	rt2x00queue_index_inc(queue, Q_INDEX);
 
 	return 0;
diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.c b/drivers/net/wireless/rt2x00/rt2x00queue.c
index 95f8dd3..19c1062 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.c
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.c
@@ -29,6 +29,163 @@
 #include "rt2x00.h"
 #include "rt2x00lib.h"
 
+void rt2x00queue_create_tx_descriptor(struct queue_entry *entry,
+				      struct txentry_desc *txdesc,
+				      struct ieee80211_tx_control *control)
+{
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)entry->skb->data;
+	struct ieee80211_rate *rate = control->tx_rate;
+	const struct rt2x00_rate *hwrate;
+	unsigned int data_length;
+	unsigned int duration;
+	unsigned int residual;
+	u16 frame_control;
+
+	memset(txdesc, 0, sizeof(*txdesc));
+
+	/*
+	 * Initialize information from queue
+	 */
+	txdesc->queue = entry->queue->qid;
+	txdesc->cw_min = entry->queue->cw_min;
+	txdesc->cw_max = entry->queue->cw_max;
+	txdesc->aifs = entry->queue->aifs;
+
+	/* Data length should be extended with 4 bytes for CRC */
+	data_length = entry->skb->len + 4;
+
+	/*
+	 * Read required fields from ieee80211 header.
+	 */
+	frame_control = le16_to_cpu(hdr->frame_control);
+
+	/*
+	 * Check whether this frame is to be acked.
+	 */
+	if (!(control->flags & IEEE80211_TXCTL_NO_ACK))
+		__set_bit(ENTRY_TXD_ACK, &txdesc->flags);
+
+	/*
+	 * Check if this is a RTS/CTS frame
+	 */
+	if (is_rts_frame(frame_control) || is_cts_frame(frame_control)) {
+		__set_bit(ENTRY_TXD_BURST, &txdesc->flags);
+		if (is_rts_frame(frame_control)) {
+			__set_bit(ENTRY_TXD_RTS_FRAME, &txdesc->flags);
+			__set_bit(ENTRY_TXD_ACK, &txdesc->flags);
+		} else {
+			__set_bit(ENTRY_TXD_CTS_FRAME, &txdesc->flags);
+			__clear_bit(ENTRY_TXD_ACK, &txdesc->flags);
+		}
+		if (control->rts_cts_rate)
+			rate = control->rts_cts_rate;
+	}
+
+	/*
+	 * Determine retry information.
+	 */
+	txdesc->retry_limit = control->retry_limit;
+	if (control->flags & IEEE80211_TXCTL_LONG_RETRY_LIMIT)
+		__set_bit(ENTRY_TXD_RETRY_MODE, &txdesc->flags);
+
+	/*
+	 * Check if more fragments are pending
+	 */
+	if (ieee80211_get_morefrag(hdr)) {
+		__set_bit(ENTRY_TXD_BURST, &txdesc->flags);
+		__set_bit(ENTRY_TXD_MORE_FRAG, &txdesc->flags);
+	}
+
+	/*
+	 * Beacons and probe responses require the tsf timestamp
+	 * to be inserted into the frame.
+	 */
+	if (txdesc->queue == QID_BEACON || is_probe_resp(frame_control))
+		__set_bit(ENTRY_TXD_REQ_TIMESTAMP, &txdesc->flags);
+
+	/*
+	 * Determine with what IFS priority this frame should be send.
+	 * Set ifs to IFS_SIFS when the this is not the first fragment,
+	 * or this fragment came after RTS/CTS.
+	 */
+	if (test_bit(ENTRY_TXD_RTS_FRAME, &txdesc->flags)) {
+		txdesc->ifs = IFS_SIFS;
+	} else if (control->flags & IEEE80211_TXCTL_FIRST_FRAGMENT) {
+		__set_bit(ENTRY_TXD_FIRST_FRAGMENT, &txdesc->flags);
+		txdesc->ifs = IFS_BACKOFF;
+	} else {
+		txdesc->ifs = IFS_SIFS;
+	}
+
+	/*
+	 * PLCP setup
+	 * Length calculation depends on OFDM/CCK rate.
+	 */
+	hwrate = rt2x00_get_rate(rate->hw_value);
+	txdesc->signal = hwrate->plcp;
+	txdesc->service = 0x04;
+
+	if (hwrate->flags & DEV_RATE_OFDM) {
+		__set_bit(ENTRY_TXD_OFDM_RATE, &txdesc->flags);
+
+		txdesc->length_high = (data_length >> 6) & 0x3f;
+		txdesc->length_low = data_length & 0x3f;
+	} else {
+		/*
+		 * Convert length to microseconds.
+		 */
+		residual = get_duration_res(data_length, hwrate->bitrate);
+		duration = get_duration(data_length, hwrate->bitrate);
+
+		if (residual != 0) {
+			duration++;
+
+			/*
+			 * Check if we need to set the Length Extension
+			 */
+			if (hwrate->bitrate == 110 && residual <= 30)
+				txdesc->service |= 0x80;
+		}
+
+		txdesc->length_high = (duration >> 8) & 0xff;
+		txdesc->length_low = duration & 0xff;
+
+		/*
+		 * When preamble is enabled we should set the
+		 * preamble bit for the signal.
+		 */
+		if (rt2x00_get_rate_preamble(rate->hw_value))
+			txdesc->signal |= 0x08;
+	}
+}
+EXPORT_SYMBOL_GPL(rt2x00queue_create_tx_descriptor);
+
+void rt2x00queue_write_tx_descriptor(struct queue_entry *entry,
+				     struct txentry_desc *txdesc)
+{
+	struct rt2x00_dev *rt2x00dev = entry->queue->rt2x00dev;
+	struct skb_frame_desc *skbdesc = get_skb_frame_desc(entry->skb);
+
+	rt2x00dev->ops->lib->write_tx_desc(rt2x00dev, entry->skb, txdesc);
+
+	/*
+	 * All processing on the frame has been completed, this means
+	 * it is now ready to be dumped to userspace through debugfs.
+	 */
+	rt2x00debug_dump_frame(rt2x00dev, DUMP_FRAME_TX, entry->skb);
+
+	/*
+	 * We are done writing the frame to the queue entry,
+	 * if this entry is a RTS of CTS-to-self frame we are done,
+	 * otherwise we need to kick the queue.
+	 */
+	if (rt2x00dev->ops->lib->kick_tx_queue &&
+	    !(skbdesc->flags & FRAME_DESC_DRIVER_GENERATED))
+		rt2x00dev->ops->lib->kick_tx_queue(rt2x00dev,
+						   entry->queue->qid);
+}
+EXPORT_SYMBOL_GPL(rt2x00queue_write_tx_descriptor);
+
 struct data_queue *rt2x00queue_get_queue(struct rt2x00_dev *rt2x00dev,
 					 const enum data_queue_qid queue)
 {
diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.h b/drivers/net/wireless/rt2x00/rt2x00queue.h
index 4bde98b..c6edc52 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.h
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.h
@@ -203,6 +203,7 @@ struct txdone_entry_desc {
  * enum txentry_desc_flags: Status flags for TX entry descriptor
  *
  * @ENTRY_TXD_RTS_FRAME: This frame is a RTS frame.
+ * @ENTRY_TXD_CTS_FRAME: This frame is a CTS-to-self frame.
  * @ENTRY_TXD_OFDM_RATE: This frame is send out with an OFDM rate.
  * @ENTRY_TXD_FIRST_FRAGMENT: This is the first frame.
  * @ENTRY_TXD_MORE_FRAG: This frame is followed by another fragment.
@@ -213,6 +214,7 @@ struct txdone_entry_desc {
  */
 enum txentry_desc_flags {
 	ENTRY_TXD_RTS_FRAME,
+	ENTRY_TXD_CTS_FRAME,
 	ENTRY_TXD_OFDM_RATE,
 	ENTRY_TXD_FIRST_FRAGMENT,
 	ENTRY_TXD_MORE_FRAG,
diff --git a/drivers/net/wireless/rt2x00/rt2x00usb.c b/drivers/net/wireless/rt2x00/rt2x00usb.c
index 955f7d9..e85372d 100644
--- a/drivers/net/wireless/rt2x00/rt2x00usb.c
+++ b/drivers/net/wireless/rt2x00/rt2x00usb.c
@@ -186,6 +186,7 @@ int rt2x00usb_write_tx_data(struct rt2x00_dev *rt2x00dev,
 	struct queue_entry *entry = rt2x00queue_get_entry(queue, Q_INDEX);
 	struct queue_entry_priv_usb_tx *priv_tx = entry->priv_data;
 	struct skb_frame_desc *skbdesc;
+	struct txentry_desc txdesc;
 	u32 length;
 
 	if (rt2x00queue_full(queue))
@@ -200,6 +201,14 @@ int rt2x00usb_write_tx_data(struct rt2x00_dev *rt2x00dev,
 	}
 
 	/*
+	 * Copy all TX descriptor information into txdesc,
+	 * after that we are free to use the skb->cb array
+	 * for our information.
+	 */
+	entry->skb = skb;
+	rt2x00queue_create_tx_descriptor(entry, &txdesc, control);
+
+	/*
 	 * Add the descriptor in front of the skb.
 	 */
 	skb_push(skb, queue->desc_size);
@@ -216,7 +225,7 @@ int rt2x00usb_write_tx_data(struct rt2x00_dev *rt2x00dev,
 	skbdesc->entry = entry;
 
 	memcpy(&priv_tx->control, control, sizeof(priv_tx->control));
-	rt2x00lib_write_tx_desc(rt2x00dev, skb, control);
+	rt2x00queue_write_tx_descriptor(entry, &txdesc);
 
 	/*
 	 * USB devices cannot blindly pass the skb->len as the
diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index ced8ae6..807bc52 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -2362,18 +2362,27 @@ static u64 rt61pci_get_tsf(struct ieee80211_hw *hw)
 }
 
 static int rt61pci_beacon_update(struct ieee80211_hw *hw, struct sk_buff *skb,
-			  struct ieee80211_tx_control *control)
+				 struct ieee80211_tx_control *control)
 {
 	struct rt2x00_dev *rt2x00dev = hw->priv;
 	struct rt2x00_intf *intf = vif_to_intf(control->vif);
 	struct queue_entry_priv_pci_tx *priv_tx;
 	struct skb_frame_desc *skbdesc;
+	struct txentry_desc txdesc;
 	unsigned int beacon_base;
 	u32 reg;
 
 	if (unlikely(!intf->beacon))
 		return -ENOBUFS;
 
+	/*
+	 * Copy all TX descriptor information into txdesc,
+	 * after that we are free to use the skb->cb array
+	 * for our information.
+	 */
+	intf->beacon->skb = skb;
+	rt2x00queue_create_tx_descriptor(intf->beacon, &txdesc, control);
+
 	priv_tx = intf->beacon->priv_data;
 	memset(priv_tx->desc, 0, intf->beacon->queue->desc_size);
 
@@ -2403,7 +2412,7 @@ static int rt61pci_beacon_update(struct ieee80211_hw *hw, struct sk_buff *skb,
 	 * Write entire beacon with descriptor to register,
 	 * and kick the beacon generator.
 	 */
-	rt2x00lib_write_tx_desc(rt2x00dev, skb, control);
+	rt2x00queue_write_tx_descriptor(intf->beacon, &txdesc);
 	beacon_base = HW_BEACON_OFFSET(intf->beacon->entry_idx);
 	rt2x00pci_register_multiwrite(rt2x00dev, beacon_base,
 				      skbdesc->desc, skbdesc->desc_len);
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index 6857d14..2949af3 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -1957,6 +1957,7 @@ static int rt73usb_beacon_update(struct ieee80211_hw *hw, struct sk_buff *skb,
 	struct rt2x00_dev *rt2x00dev = hw->priv;
 	struct rt2x00_intf *intf = vif_to_intf(control->vif);
 	struct skb_frame_desc *skbdesc;
+	struct txentry_desc txdesc;
 	unsigned int beacon_base;
 	u32 reg;
 
@@ -1964,6 +1965,14 @@ static int rt73usb_beacon_update(struct ieee80211_hw *hw, struct sk_buff *skb,
 		return -ENOBUFS;
 
 	/*
+	 * Copy all TX descriptor information into txdesc,
+	 * after that we are free to use the skb->cb array
+	 * for our information.
+	 */
+	intf->beacon->skb = skb;
+	rt2x00queue_create_tx_descriptor(intf->beacon, &txdesc, control);
+
+	/*
 	 * Add the descriptor in front of the skb.
 	 */
 	skb_push(skb, intf->beacon->queue->desc_size);
@@ -1995,7 +2004,7 @@ static int rt73usb_beacon_update(struct ieee80211_hw *hw, struct sk_buff *skb,
 	 * Write entire beacon with descriptor to register,
 	 * and kick the beacon generator.
 	 */
-	rt2x00lib_write_tx_desc(rt2x00dev, skb, control);
+	rt2x00queue_write_tx_descriptor(intf->beacon, &txdesc);
 	beacon_base = HW_BEACON_OFFSET(intf->beacon->entry_idx);
 	rt2x00usb_vendor_request(rt2x00dev, USB_MULTI_WRITE,
 				 USB_VENDOR_REQUEST_OUT, beacon_base, 0,
-- 
1.5.5.1

