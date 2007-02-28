Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.190]:49045 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932487AbXB1OHc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Feb 2007 09:07:32 -0500
Received: by nf-out-0910.google.com with SMTP id o25so562557nfa
        for <linux-wireless@vger.kernel.org>; Wed, 28 Feb 2007 06:07:32 -0800 (PST)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 10/28] rt2x00: Create write_tx_data and kick_tx_queue functions
Date: Wed, 28 Feb 2007 15:07:16 +0100
Cc: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200702281507.16414.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Create write_tx_data and kick_tx_queue functions. This will make
the tx() function itself more generic which is something we need
when we are going to add the rt2x00lib module.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>

---

diff --git a/drivers/net/wireless/mac80211/rt2x00/rt2400pci.c b/drivers/net/wireless/mac80211/rt2x00/rt2400pci.c
index afdaa9a..e9ff871 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt2400pci.c
+++ b/drivers/net/wireless/mac80211/rt2x00/rt2400pci.c
@@ -1557,6 +1557,67 @@ static void rt2400pci_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 }
 
 /*
+ * TX data initialization
+ */
+static int rt2400pci_write_tx_data(struct rt2x00_dev *rt2x00dev,
+	struct data_ring *ring, struct sk_buff *skb,
+	struct ieee80211_tx_control *control)
+{
+	struct ieee80211_hdr *ieee80211hdr = (struct ieee80211_hdr*)skb->data;
+	struct data_entry *entry = rt2x00_get_data_entry(ring);
+	struct data_desc *txd = entry->priv;
+	u32 word;
+	u16 fc;
+
+	if (rt2x00_ring_full(ring)) {
+		ieee80211_stop_queue(rt2x00dev->hw, control->queue);
+		return -EINVAL;
+	}
+
+	rt2x00_desc_read(txd, 0, &word);
+
+	if (rt2x00_get_field32(word, TXD_W0_OWNER_NIC) ||
+	    rt2x00_get_field32(word, TXD_W0_VALID)) {
+		ERROR("Arrived at non-free entry in the non-full queue %d.\n"
+		      "Please file bug report to %s.\n",
+		      control->queue, DRV_PROJECT);
+		ieee80211_stop_queue(rt2x00dev->hw, control->queue);
+		return -EINVAL;
+	}
+
+	memcpy(entry->data_addr, skb->data, skb->len);
+	rt2400pci_write_tx_desc(rt2x00dev, txd, ieee80211hdr,
+		skb->len, control);
+	memcpy(&entry->tx_status.control, control, sizeof(*control));
+	entry->skb = skb;
+
+	fc = le16_to_cpu(ieee80211hdr->frame_control);
+	if (is_cts_frame(fc) || is_rts_frame(fc))
+		SET_FLAG(entry, ENTRY_RTS_CTS_FRAME);
+
+	rt2x00_ring_index_inc(ring);
+
+	if (rt2x00_ring_full(ring))
+		ieee80211_stop_queue(rt2x00dev->hw, control->queue);
+
+	return 0;
+}
+
+static void rt2400pci_kick_tx_queue(struct rt2x00_dev *rt2x00dev, int queue)
+{
+	u32 reg;
+
+	rt2x00_register_read(rt2x00dev, TXCSR0, &reg);
+	if (queue == IEEE80211_TX_QUEUE_DATA0)
+		rt2x00_set_field32(&reg, TXCSR0_KICK_PRIO, 1);
+	else if (queue == IEEE80211_TX_QUEUE_DATA1)
+		rt2x00_set_field32(&reg, TXCSR0_KICK_TX, 1);
+	else if (queue == IEEE80211_TX_QUEUE_AFTER_BEACON)
+		rt2x00_set_field32(&reg, TXCSR0_KICK_ATIM, 1);
+	rt2x00_register_write(rt2x00dev, TXCSR0, reg);
+}
+
+/*
  * Interrupt functions.
  */
 static void rt2400pci_beacondone(struct work_struct *work)
@@ -1670,7 +1731,7 @@ static void rt2400pci_txdone(struct work_struct *work)
 		 * was succesfull.
 		 */
 		ack = rt2x00_get_field32(word, TXD_W0_ACK);
-		rts = GET_FLAG(entry, ENTRY_RTS_FRAME);
+		rts = GET_FLAG(entry, ENTRY_RTS_CTS_FRAME);
 		tx_status = rt2x00_get_field32(word, TXD_W0_RESULT);
 		rt2x00_update_tx_stats(rt2x00dev, &entry->tx_status, tx_status,
 			ack, rts);
@@ -1694,7 +1755,7 @@ static void rt2400pci_txdone(struct work_struct *work)
 
 		rt2x00_set_field32(&word, TXD_W0_VALID, 0);
 		rt2x00_desc_write(txd, 0, word);
-		CLEAR_FLAG(entry, ENTRY_RTS_FRAME);
+		CLEAR_FLAG(entry, ENTRY_RTS_CTS_FRAME);
 		entry->skb = NULL;
 
 		rt2x00_ring_index_done_inc(ring);
@@ -1795,12 +1856,8 @@ static int rt2400pci_tx(struct ieee80211_hw *hw, struct sk_buff *skb,
 	struct rt2x00_dev *rt2x00dev = hw->priv;
 	struct ieee80211_hdr *ieee80211hdr = (struct ieee80211_hdr*)skb->data;
 	struct data_ring *ring;
-	struct data_entry *entry;
-	struct data_desc *txd;
 	struct sk_buff *skb_rts;
 	u16 frame_control;
-	u32 word;
-	u32 reg;
 	int res;
 
 	/*
@@ -1840,45 +1897,10 @@ static int rt2400pci_tx(struct ieee80211_hw *hw, struct sk_buff *skb,
 		}
 	}
 
-	entry = rt2x00_get_data_entry(ring);
-	txd = rt2x00_desc_addr(entry);
-	rt2x00_desc_read(txd, 0, &word);
-
-	if (rt2x00_get_field32(word, TXD_W0_OWNER_NIC) ||
-	    rt2x00_get_field32(word, TXD_W0_VALID)) {
-		ERROR("Arrived at non-free entry in the non-full queue %d.\n"
-			"Please file bug report to %s.\n",
-			control->queue, DRV_PROJECT);
-		ieee80211_stop_queue(hw, control->queue);
+	if (rt2400pci_write_tx_data(rt2x00dev, ring, skb, control))
 		return NETDEV_TX_BUSY;
-	}
-
-	/*
-	 * Set the software sequence number.
-	 */
-	rt2x00_set_sequence(skb, &rt2x00dev->interface.sequence);
-
-	memcpy(rt2x00_data_addr(entry), skb->data, skb->len);
-	rt2400pci_write_tx_desc(rt2x00dev, txd, ieee80211hdr,
-		skb->len, control);
-	memcpy(&entry->tx_status.control, control, sizeof(*control));
-	if (is_rts_frame(frame_control))
-		SET_FLAG(entry, ENTRY_RTS_FRAME);
-	entry->skb = skb;
 
-	rt2x00_ring_index_inc(ring);
-
-	if (rt2x00_ring_full(ring))
-		ieee80211_stop_queue(hw, control->queue);
-
-	rt2x00_register_read(rt2x00dev, TXCSR0, &reg);
-	if (control->queue == IEEE80211_TX_QUEUE_DATA0)
-		rt2x00_set_field32(&reg, TXCSR0_KICK_PRIO, 1);
-	else if (control->queue == IEEE80211_TX_QUEUE_DATA1)
-		rt2x00_set_field32(&reg, TXCSR0_KICK_TX, 1);
-	else if (control->queue == IEEE80211_TX_QUEUE_AFTER_BEACON)
-		rt2x00_set_field32(&reg, TXCSR0_KICK_ATIM, 1);
-	rt2x00_register_write(rt2x00dev, TXCSR0, reg);
+	rt2400pci_kick_tx_queue(rt2x00dev, control->queue);
 
 	return NETDEV_TX_OK;
 }
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt2500pci.c b/drivers/net/wireless/mac80211/rt2x00/rt2500pci.c
index 1793040..73551b3 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/mac80211/rt2x00/rt2500pci.c
@@ -1716,6 +1716,67 @@ static void rt2500pci_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 }
 
 /*
+ * TX data initialization
+ */
+static int rt2500pci_write_tx_data(struct rt2x00_dev *rt2x00dev,
+	struct data_ring *ring, struct sk_buff *skb,
+	struct ieee80211_tx_control *control)
+{
+	struct ieee80211_hdr *ieee80211hdr = (struct ieee80211_hdr*)skb->data;
+	struct data_entry *entry = rt2x00_get_data_entry(ring);
+	struct data_desc *txd = entry->priv;
+	u32 word;
+	u16 fc;
+
+	if (rt2x00_ring_full(ring)) {
+		ieee80211_stop_queue(rt2x00dev->hw, control->queue);
+		return -EINVAL;
+	}
+
+	rt2x00_desc_read(txd, 0, &word);
+
+	if (rt2x00_get_field32(word, TXD_W0_OWNER_NIC) ||
+	    rt2x00_get_field32(word, TXD_W0_VALID)) {
+		ERROR("Arrived at non-free entry in the non-full queue %d.\n"
+		      "Please file bug report to %s.\n",
+		      control->queue, DRV_PROJECT);
+		ieee80211_stop_queue(rt2x00dev->hw, control->queue);
+		return -EINVAL;
+	}
+
+	memcpy(entry->data_addr, skb->data, skb->len);
+	rt2500pci_write_tx_desc(rt2x00dev, txd, ieee80211hdr,
+		skb->len, control);
+	memcpy(&entry->tx_status.control, control, sizeof(*control));
+	entry->skb = skb;
+
+	fc = le16_to_cpu(ieee80211hdr->frame_control);
+	if (is_cts_frame(fc) || is_rts_frame(fc))
+		SET_FLAG(entry, ENTRY_RTS_CTS_FRAME);
+
+	rt2x00_ring_index_inc(ring);
+
+	if (rt2x00_ring_full(ring))
+		ieee80211_stop_queue(rt2x00dev->hw, control->queue);
+
+	return 0;
+}
+
+static void rt2500pci_kick_tx_queue(struct rt2x00_dev *rt2x00dev, int queue)
+{
+	u32 reg;
+
+	rt2x00_register_read(rt2x00dev, TXCSR0, &reg);
+	if (queue == IEEE80211_TX_QUEUE_DATA0)
+		rt2x00_set_field32(&reg, TXCSR0_KICK_PRIO, 1);
+	else if (queue == IEEE80211_TX_QUEUE_DATA1)
+		rt2x00_set_field32(&reg, TXCSR0_KICK_TX, 1);
+	else if (queue == IEEE80211_TX_QUEUE_AFTER_BEACON)
+		rt2x00_set_field32(&reg, TXCSR0_KICK_ATIM, 1);
+	rt2x00_register_write(rt2x00dev, TXCSR0, reg);
+}
+
+/*
  * Interrupt functions.
  */
 static void rt2500pci_beacondone(struct work_struct *work)
@@ -1836,7 +1897,7 @@ static void rt2500pci_txdone(struct work_struct *work)
 		 * was succesfull.
 		 */
 		ack = rt2x00_get_field32(word, TXD_W0_ACK);
-		rts = GET_FLAG(entry, ENTRY_RTS_FRAME);
+		rts = GET_FLAG(entry, ENTRY_RTS_CTS_FRAME);
 		tx_status = rt2x00_get_field32(word, TXD_W0_RESULT);
 		rt2x00_update_tx_stats(rt2x00dev, &entry->tx_status, tx_status,
 			ack, rts);
@@ -1860,7 +1921,7 @@ static void rt2500pci_txdone(struct work_struct *work)
 
 		rt2x00_set_field32(&word, TXD_W0_VALID, 0);
 		rt2x00_desc_write(txd, 0, word);
-		CLEAR_FLAG(entry, ENTRY_RTS_FRAME);
+		CLEAR_FLAG(entry, ENTRY_RTS_CTS_FRAME);
 		entry->skb = NULL;
 
 		rt2x00_ring_index_done_inc(ring);
@@ -1961,12 +2022,8 @@ static int rt2500pci_tx(struct ieee80211_hw *hw, struct sk_buff *skb,
 	struct rt2x00_dev *rt2x00dev = hw->priv;
 	struct ieee80211_hdr *ieee80211hdr = (struct ieee80211_hdr*)skb->data;
 	struct data_ring *ring;
-	struct data_entry *entry;
-	struct data_desc *txd;
 	struct sk_buff *skb_rts;
 	u16 frame_control;
-	u32 word;
-	u32 reg;
 	int res;
 
 	/*
@@ -2006,45 +2063,10 @@ static int rt2500pci_tx(struct ieee80211_hw *hw, struct sk_buff *skb,
 		}
 	}
 
-	entry = rt2x00_get_data_entry(ring);
-	txd = rt2x00_desc_addr(entry);
-	rt2x00_desc_read(txd, 0, &word);
-
-	if (rt2x00_get_field32(word, TXD_W0_OWNER_NIC) ||
-	    rt2x00_get_field32(word, TXD_W0_VALID)) {
-		ERROR("Arrived at non-free entry in the non-full queue %d.\n"
-			"Please file bug report to %s.\n",
-			control->queue, DRV_PROJECT);
-		ieee80211_stop_queue(hw, control->queue);
+	if (rt2500pci_write_tx_data(rt2x00dev, ring, skb, control))
 		return NETDEV_TX_BUSY;
-	}
-
-	/*
-	 * Set the software sequence number.
-	 */
-	rt2x00_set_sequence(skb, &rt2x00dev->interface.sequence);
-
-	memcpy(rt2x00_data_addr(entry), skb->data, skb->len);
-	rt2500pci_write_tx_desc(rt2x00dev, txd, ieee80211hdr,
-		skb->len, control);
-	memcpy(&entry->tx_status.control, control, sizeof(*control));
-	if (is_rts_frame(frame_control))
-		SET_FLAG(entry, ENTRY_RTS_FRAME);
-	entry->skb = skb;
 
-	rt2x00_ring_index_inc(ring);
-
-	if (rt2x00_ring_full(ring))
-		ieee80211_stop_queue(hw, control->queue);
-
-	rt2x00_register_read(rt2x00dev, TXCSR0, &reg);
-	if (control->queue == IEEE80211_TX_QUEUE_DATA0)
-		rt2x00_set_field32(&reg, TXCSR0_KICK_PRIO, 1);
-	else if (control->queue == IEEE80211_TX_QUEUE_DATA1)
-		rt2x00_set_field32(&reg, TXCSR0_KICK_TX, 1);
-	else if (control->queue == IEEE80211_TX_QUEUE_AFTER_BEACON)
-		rt2x00_set_field32(&reg, TXCSR0_KICK_ATIM, 1);
-	rt2x00_register_write(rt2x00dev, TXCSR0, reg);
+	rt2500pci_kick_tx_queue(rt2x00dev, control->queue);
 
 	return NETDEV_TX_OK;
 }
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt2500usb.c b/drivers/net/wireless/mac80211/rt2x00/rt2500usb.c
index a4b410a..49e70ca 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/mac80211/rt2x00/rt2500usb.c
@@ -1679,6 +1679,72 @@ static void rt2500usb_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 }
 
 /*
+ * TX data initialization
+ */
+static int rt2500usb_write_tx_data(struct rt2x00_dev *rt2x00dev,
+	struct data_ring *ring, struct sk_buff *skb,
+	struct ieee80211_tx_control *control)
+{
+	struct usb_device *usb_dev =
+		interface_to_usbdev(rt2x00dev_usb(rt2x00dev));
+	struct ieee80211_hdr *ieee80211hdr = (struct ieee80211_hdr*)skb->data;
+	struct data_entry *entry = rt2x00_get_data_entry(ring);
+	struct data_desc *txd;
+	u32 length = skb->len;
+	u16 fc;
+
+	if (rt2x00_ring_full(ring)) {
+		ieee80211_stop_queue(rt2x00dev->hw, control->queue);
+		return -EINVAL;
+	}
+
+	if (GET_FLAG(entry, ENTRY_OWNER_NIC)) {
+		ERROR("Arrived at non-free entry in the non-full queue %d.\n"
+			"Please file bug report to %s.\n",
+			control->queue, DRV_PROJECT);
+		ieee80211_stop_queue( rt2x00dev->hw, control->queue);
+		return -EINVAL;
+	}
+
+	skb_push(skb, rt2x00dev->hw->extra_tx_headroom);
+	txd = (struct data_desc*)skb->data;
+	rt2500usb_write_tx_desc(rt2x00dev, txd, ieee80211hdr,
+		skb->len, control);
+	memcpy(&entry->tx_status.control, control, sizeof(*control));
+	entry->skb = skb;
+
+	fc = le16_to_cpu(ieee80211hdr->frame_control);
+	if (is_cts_frame(fc) || is_rts_frame(fc))
+		SET_FLAG(entry, ENTRY_RTS_CTS_FRAME);
+
+	/*
+	 * Length passed to usb_fill_urb cannot be an odd number,
+	 * so add 1 byte to make it even.
+	 */
+	length += rt2x00dev->hw->extra_tx_headroom;
+	if (length % 2)
+		length++;
+
+	SET_FLAG(entry, ENTRY_OWNER_NIC);
+	usb_fill_bulk_urb(
+		entry->priv,
+		usb_dev,
+		usb_sndbulkpipe(usb_dev, 1),
+		skb->data,
+		length,
+		rt2500usb_interrupt,
+		entry);
+	usb_submit_urb(entry->priv, GFP_ATOMIC);
+
+	rt2x00_ring_index_inc(ring);
+
+	if (rt2x00_ring_full(ring))
+		ieee80211_stop_queue( rt2x00dev->hw, control->queue);
+
+	return 0;
+}
+
+/*
  * Interrupt functions.
  */
 static void rt2500usb_beacondone(struct work_struct *work)
@@ -1817,7 +1883,7 @@ static void rt2500usb_txdone(struct work_struct *work)
 		 * was succesfull.
 		 */
 		ack = rt2x00_get_field32(word, TXD_W0_ACK);
-		rts = GET_FLAG(entry, ENTRY_RTS_FRAME);
+		rts = GET_FLAG(entry, ENTRY_RTS_CTS_FRAME);
 		tx_status = !urb->status ? TX_SUCCESS : TX_FAIL_RETRY;
 		rt2x00_update_tx_stats(rt2x00dev, &entry->tx_status, tx_status,
 			ack, rts);
@@ -1836,7 +1902,7 @@ static void rt2500usb_txdone(struct work_struct *work)
 		else
 			dev_kfree_skb(entry->skb);
 
-		CLEAR_FLAG(entry, ENTRY_RTS_FRAME);
+		CLEAR_FLAG(entry, ENTRY_RTS_CTS_FRAME);
 		entry->skb = NULL;
 
 		rt2x00_ring_index_done_inc(entry->ring);
@@ -1890,15 +1956,10 @@ static int rt2500usb_tx(struct ieee80211_hw *hw,
 {
 	struct rt2x00_dev *rt2x00dev = hw->priv;
 	struct ieee80211_hdr *ieee80211hdr = (struct ieee80211_hdr*)skb->data;
-	struct usb_device *usb_dev =
-		interface_to_usbdev(rt2x00dev_usb(rt2x00dev));
 	struct data_ring *ring;
-	struct data_entry *entry;
-	struct data_desc *txd;
 	struct sk_buff *skb_rts;
 	u16 frame_control;
 	int res;
-	int length;
 
 	/*
 	 * Determine which ring to put packet on.
@@ -1937,48 +1998,8 @@ static int rt2500usb_tx(struct ieee80211_hw *hw,
 		}
 	}
 
-	entry = rt2x00_get_data_entry(ring);
-	txd = rt2x00_txdesc_addr(entry);
-
-	if (GET_FLAG(entry, ENTRY_OWNER_NIC)) {
-		ERROR("Arrived at non-free entry in the non-full queue %d.\n"
-			"Please file bug report to %s.\n",
-			control->queue, DRV_PROJECT);
-		ieee80211_stop_queue(hw, control->queue);
+	if (rt2500usb_write_tx_data(rt2x00dev, ring, skb, control))
 		return NETDEV_TX_BUSY;
-	}
-
-	memcpy(rt2x00_txdata_addr(entry), skb->data, skb->len);
-	rt2500usb_write_tx_desc(rt2x00dev, txd, ieee80211hdr,
-		skb->len, control);
-	memcpy(&entry->tx_status.control, control, sizeof(*control));
-	if (is_rts_frame(frame_control))
-		SET_FLAG(entry, ENTRY_RTS_FRAME);
-	entry->skb = skb;
-
-	/*
-	 * Length passed to usb_fill_urb cannot be an odd number,
-	 * so add 1 byte to make it even.
-	 */
-	length = skb->len + ring->desc_size;
-	if (length % 2)
-		length++;
-
-	SET_FLAG(entry, ENTRY_OWNER_NIC);
-	usb_fill_bulk_urb(
-		rt2x00_urb(entry),
-		usb_dev,
-		usb_sndbulkpipe(usb_dev, 1),
-		entry->data_addr,
-		length,
-		rt2500usb_interrupt,
-		entry);
-	usb_submit_urb(rt2x00_urb(entry), GFP_ATOMIC);
-
-	rt2x00_ring_index_inc(ring);
-
-	if (rt2x00_ring_full(ring))
-		ieee80211_stop_queue(hw, control->queue);
 
 	return NETDEV_TX_OK;
 }
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt2x00.h b/drivers/net/wireless/mac80211/rt2x00/rt2x00.h
index fe9ac7d..d6e968c 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/mac80211/rt2x00/rt2x00.h
@@ -135,6 +135,9 @@ static int rt2x00_debug_level = 0;
 #define is_rts_frame(__fc) \
 	( !!((((__fc) &  IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_CTL) && \
 	     (((__fc) &  IEEE80211_FCTL_STYPE) == IEEE80211_STYPE_RTS)) )
+#define is_cts_frame(__fc) \
+	( !!((((__fc) &  IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_CTL) && \
+	     (((__fc) &  IEEE80211_FCTL_STYPE) == IEEE80211_STYPE_CTS)) )
 #define is_probe_resp(__fc) \
 	( !!((((__fc) & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_MGMT) && \
 	     (((__fc) & IEEE80211_FCTL_STYPE) == IEEE80211_STYPE_PROBE_RESP)) )
@@ -518,8 +521,8 @@ struct data_entry {
 	 * Status flags
 	 */
 	unsigned int flags;
-#define ENTRY_OWNER_NIC	0x00000001
-#define ENTRY_RTS_FRAME	0x00000002
+#define ENTRY_OWNER_NIC		0x00000001
+#define ENTRY_RTS_CTS_FRAME	0x00000002
 
 	/*
 	 * Ring we belong to.
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt61pci.c b/drivers/net/wireless/mac80211/rt2x00/rt61pci.c
index 58b90cd..5685871 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/mac80211/rt2x00/rt61pci.c
@@ -2180,6 +2180,70 @@ static void rt61pci_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 }
 
 /*
+ * TX data initialization
+ */
+static int rt61pci_write_tx_data(struct rt2x00_dev *rt2x00dev,
+	struct data_ring *ring, struct sk_buff *skb,
+	struct ieee80211_tx_control *control)
+{
+	struct ieee80211_hdr *ieee80211hdr = (struct ieee80211_hdr*)skb->data;
+	struct data_entry *entry = rt2x00_get_data_entry(ring);
+	struct data_desc *txd = entry->priv;
+	u32 word;
+	u16 fc;
+
+	if (rt2x00_ring_full(ring)) {
+		ieee80211_stop_queue(rt2x00dev->hw, control->queue);
+		return -EINVAL;
+	}
+
+	rt2x00_desc_read(txd, 0, &word);
+
+	if (rt2x00_get_field32(word, TXD_W0_OWNER_NIC) ||
+	    rt2x00_get_field32(word, TXD_W0_VALID)) {
+		ERROR("Arrived at non-free entry in the non-full queue %d.\n"
+		      "Please file bug report to %s.\n",
+		      control->queue, DRV_PROJECT);
+		ieee80211_stop_queue(rt2x00dev->hw, control->queue);
+		return -EINVAL;
+	}
+
+	memcpy(entry->data_addr, skb->data, skb->len);
+	rt61pci_write_tx_desc(rt2x00dev, txd, ieee80211hdr, skb->len, control);
+	memcpy(&entry->tx_status.control, control, sizeof(*control));
+	entry->skb = skb;
+
+	fc = le16_to_cpu(ieee80211hdr->frame_control);
+	if (is_cts_frame(fc) || is_rts_frame(fc))
+		SET_FLAG(entry, ENTRY_RTS_CTS_FRAME);
+
+	rt2x00_ring_index_inc(ring);
+
+	if (rt2x00_ring_full(ring))
+		ieee80211_stop_queue(rt2x00dev->hw, control->queue);
+
+	return 0;
+}
+
+static void rt61pci_kick_tx_queue(struct rt2x00_dev *rt2x00dev, int queue)
+{
+	u32 reg;
+
+	rt2x00_register_read(rt2x00dev, TX_CNTL_CSR, &reg);
+	if (queue == IEEE80211_TX_QUEUE_DATA0)
+		rt2x00_set_field32(&reg, TX_CNTL_CSR_KICK_TX_AC0, 1);
+	else if (queue == IEEE80211_TX_QUEUE_DATA1)
+		rt2x00_set_field32(&reg, TX_CNTL_CSR_KICK_TX_AC1, 1);
+	else if (queue == IEEE80211_TX_QUEUE_DATA2)
+		rt2x00_set_field32(&reg, TX_CNTL_CSR_KICK_TX_AC2, 1);
+	else if (queue == IEEE80211_TX_QUEUE_DATA3)
+		rt2x00_set_field32(&reg, TX_CNTL_CSR_KICK_TX_AC3, 1);
+	else if (queue == IEEE80211_TX_QUEUE_DATA4)
+		rt2x00_set_field32(&reg, TX_CNTL_CSR_KICK_TX_MGMT, 1);
+	rt2x00_register_write(rt2x00dev, TX_CNTL_CSR, reg);
+}
+
+/*
  * Interrupt functions.
  */
 static void rt61pci_beacondone(struct work_struct *work)
@@ -2289,7 +2353,7 @@ static void rt61pci_txdone_entry(struct data_entry *entry, u32 sta_csr4)
 	 * was succesfull.
 	 */
 	ack = rt2x00_get_field32(word, TXD_W0_ACK);
-	rts = GET_FLAG(entry, ENTRY_RTS_FRAME);
+	rts = GET_FLAG(entry, ENTRY_RTS_CTS_FRAME);
 	tx_status = rt2x00_get_field32(sta_csr4, STA_CSR4_TX_RESULT);
 	rt2x00_update_tx_stats(rt2x00dev, &entry->tx_status, tx_status,
 		ack, rts);
@@ -2313,7 +2377,7 @@ static void rt61pci_txdone_entry(struct data_entry *entry, u32 sta_csr4)
 
 	rt2x00_set_field32(&word, TXD_W0_VALID, 0);
 	rt2x00_desc_write(txd, 0, word);
-	CLEAR_FLAG(entry, ENTRY_RTS_FRAME);
+	CLEAR_FLAG(entry, ENTRY_RTS_CTS_FRAME);
 	entry->skb = NULL;
 
 	rt2x00_ring_index_done_inc(entry->ring);
@@ -2450,12 +2514,8 @@ static int rt61pci_tx(struct ieee80211_hw *hw, struct sk_buff *skb,
 	struct rt2x00_dev *rt2x00dev = hw->priv;
 	struct ieee80211_hdr *ieee80211hdr = (struct ieee80211_hdr*)skb->data;
 	struct data_ring *ring;
-	struct data_entry *entry;
-	struct data_desc *txd;
 	struct sk_buff *skb_rts;
 	u16 frame_control;
-	u32 word;
-	u32 reg;
 	int res;
 
 	/*
@@ -2495,44 +2555,10 @@ static int rt61pci_tx(struct ieee80211_hw *hw, struct sk_buff *skb,
 		}
 	}
 
-	entry = rt2x00_get_data_entry(ring);
-	txd = rt2x00_desc_addr(entry);
-	rt2x00_desc_read(txd, 0, &word);
-
-	if (rt2x00_get_field32(word, TXD_W0_OWNER_NIC) ||
-	    rt2x00_get_field32(word, TXD_W0_VALID)) {
-		ERROR("Arrived at non-free entry in the non-full queue %d.\n"
-			"Please file bug report to %s.\n",
-			control->queue, DRV_PROJECT);
-		ieee80211_stop_queue(hw, control->queue);
+	if (rt61pci_write_tx_data(rt2x00dev, ring, skb, control))
 		return NETDEV_TX_BUSY;
-	}
-
-	memcpy(rt2x00_data_addr(entry), skb->data, skb->len);
-	rt61pci_write_tx_desc(rt2x00dev, txd, ieee80211hdr,
-		skb->len, control);
-	memcpy(&entry->tx_status.control, control, sizeof(*control));
-	if (is_rts_frame(frame_control))
-		SET_FLAG(entry, ENTRY_RTS_FRAME);
-	entry->skb = skb;
-
-	rt2x00_ring_index_inc(ring);
-
-	if (rt2x00_ring_full(ring))
-		ieee80211_stop_queue(hw, control->queue);
 
-	rt2x00_register_read(rt2x00dev, TX_CNTL_CSR, &reg);
-	if (control->queue == IEEE80211_TX_QUEUE_DATA0)
-		rt2x00_set_field32(&reg, TX_CNTL_CSR_KICK_TX_AC0, 1);
-	else if (control->queue == IEEE80211_TX_QUEUE_DATA1)
-		rt2x00_set_field32(&reg, TX_CNTL_CSR_KICK_TX_AC1, 1);
-	else if (control->queue == IEEE80211_TX_QUEUE_DATA2)
-		rt2x00_set_field32(&reg, TX_CNTL_CSR_KICK_TX_AC2, 1);
-	else if (control->queue == IEEE80211_TX_QUEUE_DATA3)
-		rt2x00_set_field32(&reg, TX_CNTL_CSR_KICK_TX_AC3, 1);
-	else if (control->queue == IEEE80211_TX_QUEUE_DATA4)
-		rt2x00_set_field32(&reg, TX_CNTL_CSR_KICK_TX_MGMT, 1);
-	rt2x00_register_write(rt2x00dev, TX_CNTL_CSR, reg);
+	rt61pci_kick_tx_queue(rt2x00dev, control->queue);
 
 	return NETDEV_TX_OK;
 }
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt73usb.c b/drivers/net/wireless/mac80211/rt2x00/rt73usb.c
index e43404c..43a07dc 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/mac80211/rt2x00/rt73usb.c
@@ -1952,6 +1952,71 @@ static void rt73usb_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 }
 
 /*
+ * TX data initialization
+ */
+static int rt73usb_write_tx_data(struct rt2x00_dev *rt2x00dev,
+	struct data_ring *ring, struct sk_buff *skb,
+	struct ieee80211_tx_control *control)
+{
+	struct usb_device *usb_dev =
+		interface_to_usbdev(rt2x00dev_usb(rt2x00dev));
+	struct ieee80211_hdr *ieee80211hdr = (struct ieee80211_hdr*)skb->data;
+	struct data_entry *entry = rt2x00_get_data_entry(ring);
+	struct data_desc *txd;
+	u32 length = skb->len;
+	u16 fc;
+
+	if (rt2x00_ring_full(ring)) {
+		ieee80211_stop_queue(rt2x00dev->hw, control->queue);
+		return -EINVAL;
+	}
+
+	if (GET_FLAG(entry, ENTRY_OWNER_NIC)) {
+		ERROR("Arrived at non-free entry in the non-full queue %d.\n"
+			"Please file bug report to %s.\n",
+			control->queue, DRV_PROJECT);
+		ieee80211_stop_queue( rt2x00dev->hw, control->queue);
+		return -EINVAL;
+	}
+
+	skb_push(skb, rt2x00dev->hw->extra_tx_headroom);
+	txd = (struct data_desc*)skb->data;
+	rt73usb_write_tx_desc(rt2x00dev, txd, ieee80211hdr, skb->len, control);
+	memcpy(&entry->tx_status.control, control, sizeof(*control));
+	entry->skb = skb;
+
+	fc = le16_to_cpu(ieee80211hdr->frame_control);
+	if (is_cts_frame(fc) || is_rts_frame(fc))
+		SET_FLAG(entry, ENTRY_RTS_CTS_FRAME);
+
+	/*
+	 * Length passed to usb_fill_urb cannot be an odd number,
+	 * so add 1 byte to make it even.
+	 */
+	length += rt2x00dev->hw->extra_tx_headroom;
+	if (length % 2)
+		length++;
+
+	SET_FLAG(entry, ENTRY_OWNER_NIC);
+	usb_fill_bulk_urb(
+		entry->priv,
+		usb_dev,
+		usb_sndbulkpipe(usb_dev, 1),
+		skb->data,
+		length,
+		rt73usb_interrupt,
+		entry);
+	usb_submit_urb(entry->priv, GFP_ATOMIC);
+
+	rt2x00_ring_index_inc(ring);
+
+	if (rt2x00_ring_full(ring))
+		ieee80211_stop_queue(rt2x00dev->hw, control->queue);
+
+	return 0;
+}
+
+/*
  * Interrupt functions.
  */
 static void rt73usb_beacondone(struct work_struct *work)
@@ -2082,7 +2147,7 @@ static void rt73usb_txdone(struct work_struct *work)
 		 * was succesfull.
 		 */
 		ack = rt2x00_get_field32(word, TXD_W0_ACK);
-		rts = GET_FLAG(entry, ENTRY_RTS_FRAME);
+		rts = GET_FLAG(entry, ENTRY_RTS_CTS_FRAME);
 		tx_status = !urb->status ? TX_SUCCESS : TX_FAIL_RETRY;
 		rt2x00_update_tx_stats(rt2x00dev, &entry->tx_status, tx_status,
 			ack, rts);
@@ -2101,7 +2166,7 @@ static void rt73usb_txdone(struct work_struct *work)
 		else
 			dev_kfree_skb(entry->skb);
 
-		CLEAR_FLAG(entry, ENTRY_RTS_FRAME);
+		CLEAR_FLAG(entry, ENTRY_RTS_CTS_FRAME);
 		entry->skb = NULL;
 
 		rt2x00_ring_index_done_inc(entry->ring);
@@ -2154,15 +2219,10 @@ static int rt73usb_tx(struct ieee80211_hw *hw,
 {
 	struct rt2x00_dev *rt2x00dev = hw->priv;
 	struct ieee80211_hdr *ieee80211hdr = (struct ieee80211_hdr*)skb->data;
-	struct usb_device *usb_dev =
-		interface_to_usbdev(rt2x00dev_usb(rt2x00dev));
 	struct data_ring *ring;
-	struct data_entry *entry;
-	struct data_desc *txd;
 	struct sk_buff *skb_rts;
 	u16 frame_control;
 	int res;
-	int length;
 
 	/*
 	 * Determine which ring to put packet on.
@@ -2201,48 +2261,8 @@ static int rt73usb_tx(struct ieee80211_hw *hw,
 		}
 	}
 
-	entry = rt2x00_get_data_entry(ring);
-	txd = rt2x00_desc_addr(entry);
-
-	if (GET_FLAG(entry, ENTRY_OWNER_NIC)) {
-		ERROR("Arrived at non-free entry in the non-full queue %d.\n"
-			"Please file bug report to %s.\n",
-			control->queue, DRV_PROJECT);
-		ieee80211_stop_queue(hw, control->queue);
+	if (rt73usb_write_tx_data(rt2x00dev, ring, skb, control))
 		return NETDEV_TX_BUSY;
-	}
-
-	memcpy(rt2x00_data_addr(entry), skb->data, skb->len);
-	rt73usb_write_tx_desc(rt2x00dev, txd, ieee80211hdr,
-		skb->len, control);
-	memcpy(&entry->tx_status.control, control, sizeof(*control));
-	if (is_rts_frame(frame_control))
-		SET_FLAG(entry, ENTRY_RTS_FRAME);
-	entry->skb = skb;
-
-	/*
-	 * Length passed to usb_fill_urb cannot be an odd number,
-	 * so add 1 byte to make it even.
-	 */
-	length = skb->len + ring->desc_size;
-	if (length % 2)
-		length++;
-
-	SET_FLAG(entry, ENTRY_OWNER_NIC);
-	usb_fill_bulk_urb(
-		rt2x00_urb(entry),
-		usb_dev,
-		usb_sndbulkpipe(usb_dev, 1),
-		entry->data_addr,
-		length,
-		rt73usb_interrupt,
-		entry);
-	usb_submit_urb(rt2x00_urb(entry), GFP_ATOMIC);
-
-	rt2x00_ring_index_inc(ring);
-
-	if (rt2x00_ring_full(ring))
-		ieee80211_stop_queue(hw, control->queue);
 
 	return NETDEV_TX_OK;
 }
