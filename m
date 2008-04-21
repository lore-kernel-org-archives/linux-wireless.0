Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.185]:52877 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762295AbYDURAE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Apr 2008 13:00:04 -0400
Received: by fk-out-0910.google.com with SMTP id 19so2556605fkr.5
        for <linux-wireless@vger.kernel.org>; Mon, 21 Apr 2008 10:00:03 -0700 (PDT)
To: linville@tuxdriver.com
Subject: [PATCH 4/9] rt2x00: Use rt2x00 queue numbering
Date: Mon, 21 Apr 2008 19:00:47 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200804211858.46659.IvDoorn@gmail.com>
In-Reply-To: <200804211858.46659.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200804211900.47216.IvDoorn@gmail.com> (sfid-20080421_190104_533995_4AAFC473)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use the rt2x00 queue enumeration as much as possible,
removing the usage of the mac80211 queue numbering
wherever it is possible.

This makes it easier for mac80211 to change it queue
identification scheme without having to deal with
big changes in the rt2x00 code.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2400pci.c   |   32 ++++++++---------------
 drivers/net/wireless/rt2x00/rt2500pci.c   |   35 ++++++++----------------
 drivers/net/wireless/rt2x00/rt2500usb.c   |   12 ++------
 drivers/net/wireless/rt2x00/rt2x00.h      |    9 +++---
 drivers/net/wireless/rt2x00/rt2x00dev.c   |    3 +-
 drivers/net/wireless/rt2x00/rt2x00mac.c   |   13 ++++-----
 drivers/net/wireless/rt2x00/rt2x00pci.c   |    2 +-
 drivers/net/wireless/rt2x00/rt2x00queue.c |    6 ++--
 drivers/net/wireless/rt2x00/rt2x00queue.h |   40 ++++++++++++++++++----------
 drivers/net/wireless/rt2x00/rt2x00usb.c   |    2 +-
 drivers/net/wireless/rt2x00/rt61pci.c     |   27 ++++++-------------
 drivers/net/wireless/rt2x00/rt73usb.c     |   15 +++--------
 12 files changed, 80 insertions(+), 116 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2400pci.c b/drivers/net/wireless/rt2x00/rt2400pci.c
index 18e599e..1a860d2 100644
--- a/drivers/net/wireless/rt2x00/rt2400pci.c
+++ b/drivers/net/wireless/rt2x00/rt2400pci.c
@@ -1055,11 +1055,11 @@ static void rt2400pci_write_tx_desc(struct rt2x00_dev *rt2x00dev,
  * TX data initialization
  */
 static void rt2400pci_kick_tx_queue(struct rt2x00_dev *rt2x00dev,
-				    const unsigned int queue)
+				    const enum data_queue_qid queue)
 {
 	u32 reg;
 
-	if (queue == RT2X00_BCN_QUEUE_BEACON) {
+	if (queue == QID_BEACON) {
 		rt2x00pci_register_read(rt2x00dev, CSR14, &reg);
 		if (!rt2x00_get_field32(reg, CSR14_BEACON_GEN)) {
 			rt2x00_set_field32(&reg, CSR14_TSF_COUNT, 1);
@@ -1071,12 +1071,9 @@ static void rt2400pci_kick_tx_queue(struct rt2x00_dev *rt2x00dev,
 	}
 
 	rt2x00pci_register_read(rt2x00dev, TXCSR0, &reg);
-	rt2x00_set_field32(&reg, TXCSR0_KICK_PRIO,
-			   (queue == IEEE80211_TX_QUEUE_DATA0));
-	rt2x00_set_field32(&reg, TXCSR0_KICK_TX,
-			   (queue == IEEE80211_TX_QUEUE_DATA1));
-	rt2x00_set_field32(&reg, TXCSR0_KICK_ATIM,
-			   (queue == RT2X00_BCN_QUEUE_ATIM));
+	rt2x00_set_field32(&reg, TXCSR0_KICK_PRIO, (queue == QID_AC_BE));
+	rt2x00_set_field32(&reg, TXCSR0_KICK_TX, (queue == QID_AC_BK));
+	rt2x00_set_field32(&reg, TXCSR0_KICK_ATIM, (queue == QID_ATIM));
 	rt2x00pci_register_write(rt2x00dev, TXCSR0, reg);
 }
 
@@ -1120,7 +1117,7 @@ static void rt2400pci_fill_rxdone(struct queue_entry *entry,
  * Interrupt functions.
  */
 static void rt2400pci_txdone(struct rt2x00_dev *rt2x00dev,
-			     const enum ieee80211_tx_queue queue_idx)
+			     const enum data_queue_qid queue_idx)
 {
 	struct data_queue *queue = rt2x00queue_get_queue(rt2x00dev, queue_idx);
 	struct queue_entry_priv_pci_tx *priv_tx;
@@ -1187,19 +1184,19 @@ static irqreturn_t rt2400pci_interrupt(int irq, void *dev_instance)
 	 * 3 - Atim ring transmit done interrupt.
 	 */
 	if (rt2x00_get_field32(reg, CSR7_TXDONE_ATIMRING))
-		rt2400pci_txdone(rt2x00dev, RT2X00_BCN_QUEUE_ATIM);
+		rt2400pci_txdone(rt2x00dev, QID_ATIM);
 
 	/*
 	 * 4 - Priority ring transmit done interrupt.
 	 */
 	if (rt2x00_get_field32(reg, CSR7_TXDONE_PRIORING))
-		rt2400pci_txdone(rt2x00dev, IEEE80211_TX_QUEUE_DATA0);
+		rt2400pci_txdone(rt2x00dev, QID_AC_BE);
 
 	/*
 	 * 5 - Tx ring transmit done interrupt.
 	 */
 	if (rt2x00_get_field32(reg, CSR7_TXDONE_TXRING))
-		rt2400pci_txdone(rt2x00dev, IEEE80211_TX_QUEUE_DATA1);
+		rt2400pci_txdone(rt2x00dev, QID_AC_BK);
 
 	return IRQ_HANDLED;
 }
@@ -1521,20 +1518,13 @@ static int rt2400pci_beacon_update(struct ieee80211_hw *hw, struct sk_buff *skb,
 	rt2x00pci_register_write(rt2x00dev, CSR14, reg);
 
 	/*
-	 * mac80211 doesn't provide the control->queue variable
-	 * for beacons. Set our own queue identification so
-	 * it can be used during descriptor initialization.
-	 */
-	control->queue = RT2X00_BCN_QUEUE_BEACON;
-	rt2x00lib_write_tx_desc(rt2x00dev, skb, control);
-
-	/*
 	 * Enable beacon generation.
 	 * Write entire beacon with descriptor to register,
 	 * and kick the beacon generator.
 	 */
+	rt2x00lib_write_tx_desc(rt2x00dev, skb, control);
 	memcpy(priv_tx->data, skb->data, skb->len);
-	rt2x00dev->ops->lib->kick_tx_queue(rt2x00dev, control->queue);
+	rt2x00dev->ops->lib->kick_tx_queue(rt2x00dev, QID_BEACON);
 
 	return 0;
 }
diff --git a/drivers/net/wireless/rt2x00/rt2500pci.c b/drivers/net/wireless/rt2x00/rt2500pci.c
index c54ea5a..34f6e3d 100644
--- a/drivers/net/wireless/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/rt2x00/rt2500pci.c
@@ -317,8 +317,7 @@ static void rt2500pci_config_intf(struct rt2x00_dev *rt2x00dev,
 				  struct rt2x00intf_conf *conf,
 				  const unsigned int flags)
 {
-	struct data_queue *queue =
-	    rt2x00queue_get_queue(rt2x00dev, RT2X00_BCN_QUEUE_BEACON);
+	struct data_queue *queue = rt2x00queue_get_queue(rt2x00dev, QID_BEACON);
 	unsigned int bcn_preload;
 	u32 reg;
 
@@ -1210,11 +1209,11 @@ static void rt2500pci_write_tx_desc(struct rt2x00_dev *rt2x00dev,
  * TX data initialization
  */
 static void rt2500pci_kick_tx_queue(struct rt2x00_dev *rt2x00dev,
-				    const unsigned int queue)
+				    const enum data_queue_qid queue)
 {
 	u32 reg;
 
-	if (queue == RT2X00_BCN_QUEUE_BEACON) {
+	if (queue == QID_BEACON) {
 		rt2x00pci_register_read(rt2x00dev, CSR14, &reg);
 		if (!rt2x00_get_field32(reg, CSR14_BEACON_GEN)) {
 			rt2x00_set_field32(&reg, CSR14_TSF_COUNT, 1);
@@ -1226,12 +1225,9 @@ static void rt2500pci_kick_tx_queue(struct rt2x00_dev *rt2x00dev,
 	}
 
 	rt2x00pci_register_read(rt2x00dev, TXCSR0, &reg);
-	rt2x00_set_field32(&reg, TXCSR0_KICK_PRIO,
-			   (queue == IEEE80211_TX_QUEUE_DATA0));
-	rt2x00_set_field32(&reg, TXCSR0_KICK_TX,
-			   (queue == IEEE80211_TX_QUEUE_DATA1));
-	rt2x00_set_field32(&reg, TXCSR0_KICK_ATIM,
-			   (queue == RT2X00_BCN_QUEUE_ATIM));
+	rt2x00_set_field32(&reg, TXCSR0_KICK_PRIO, (queue == QID_AC_BE));
+	rt2x00_set_field32(&reg, TXCSR0_KICK_TX, (queue == QID_AC_BK));
+	rt2x00_set_field32(&reg, TXCSR0_KICK_ATIM, (queue == QID_ATIM));
 	rt2x00pci_register_write(rt2x00dev, TXCSR0, reg);
 }
 
@@ -1276,7 +1272,7 @@ static void rt2500pci_fill_rxdone(struct queue_entry *entry,
  * Interrupt functions.
  */
 static void rt2500pci_txdone(struct rt2x00_dev *rt2x00dev,
-			     const enum ieee80211_tx_queue queue_idx)
+			     const enum data_queue_qid queue_idx)
 {
 	struct data_queue *queue = rt2x00queue_get_queue(rt2x00dev, queue_idx);
 	struct queue_entry_priv_pci_tx *priv_tx;
@@ -1343,19 +1339,19 @@ static irqreturn_t rt2500pci_interrupt(int irq, void *dev_instance)
 	 * 3 - Atim ring transmit done interrupt.
 	 */
 	if (rt2x00_get_field32(reg, CSR7_TXDONE_ATIMRING))
-		rt2500pci_txdone(rt2x00dev, RT2X00_BCN_QUEUE_ATIM);
+		rt2500pci_txdone(rt2x00dev, QID_ATIM);
 
 	/*
 	 * 4 - Priority ring transmit done interrupt.
 	 */
 	if (rt2x00_get_field32(reg, CSR7_TXDONE_PRIORING))
-		rt2500pci_txdone(rt2x00dev, IEEE80211_TX_QUEUE_DATA0);
+		rt2500pci_txdone(rt2x00dev, QID_AC_BE);
 
 	/*
 	 * 5 - Tx ring transmit done interrupt.
 	 */
 	if (rt2x00_get_field32(reg, CSR7_TXDONE_TXRING))
-		rt2500pci_txdone(rt2x00dev, IEEE80211_TX_QUEUE_DATA1);
+		rt2500pci_txdone(rt2x00dev, QID_AC_BK);
 
 	return IRQ_HANDLED;
 }
@@ -1834,20 +1830,13 @@ static int rt2500pci_beacon_update(struct ieee80211_hw *hw, struct sk_buff *skb,
 	rt2x00pci_register_write(rt2x00dev, CSR14, reg);
 
 	/*
-	 * mac80211 doesn't provide the control->queue variable
-	 * for beacons. Set our own queue identification so
-	 * it can be used during descriptor initialization.
-	 */
-	control->queue = RT2X00_BCN_QUEUE_BEACON;
-	rt2x00lib_write_tx_desc(rt2x00dev, skb, control);
-
-	/*
 	 * Enable beacon generation.
 	 * Write entire beacon with descriptor to register,
 	 * and kick the beacon generator.
 	 */
+	rt2x00lib_write_tx_desc(rt2x00dev, skb, control);
 	memcpy(priv_tx->data, skb->data, skb->len);
-	rt2x00dev->ops->lib->kick_tx_queue(rt2x00dev, control->queue);
+	rt2x00dev->ops->lib->kick_tx_queue(rt2x00dev, QID_BEACON);
 
 	return 0;
 }
diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
index 6bb07b3..2782ef4 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/rt2x00/rt2500usb.c
@@ -1094,11 +1094,11 @@ static int rt2500usb_get_tx_data_len(struct rt2x00_dev *rt2x00dev,
  * TX data initialization
  */
 static void rt2500usb_kick_tx_queue(struct rt2x00_dev *rt2x00dev,
-				    const unsigned int queue)
+				    const enum data_queue_qid queue)
 {
 	u16 reg;
 
-	if (queue != RT2X00_BCN_QUEUE_BEACON)
+	if (queue != QID_BEACON)
 		return;
 
 	rt2500usb_register_read(rt2x00dev, TXRX_CSR19, &reg);
@@ -1720,12 +1720,6 @@ static int rt2500usb_beacon_update(struct ieee80211_hw *hw,
 	rt2x00_set_field16(&reg, TXRX_CSR19_BEACON_GEN, 0);
 	rt2500usb_register_write(rt2x00dev, TXRX_CSR19, reg);
 
-	/*
-	 * mac80211 doesn't provide the control->queue variable
-	 * for beacons. Set our own queue identification so
-	 * it can be used during descriptor initialization.
-	 */
-	control->queue = RT2X00_BCN_QUEUE_BEACON;
 	rt2x00lib_write_tx_desc(rt2x00dev, skb, control);
 
 	/*
@@ -1757,7 +1751,7 @@ static int rt2500usb_beacon_update(struct ieee80211_hw *hw,
 	/*
 	 * Enable beacon generation.
 	 */
-	rt2500usb_kick_tx_queue(rt2x00dev, control->queue);
+	rt2500usb_kick_tx_queue(rt2x00dev, QID_BEACON);
 
 	return 0;
 }
diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index 7a23b00..d85553f 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -548,7 +548,7 @@ struct rt2x00lib_ops {
 	int (*get_tx_data_len) (struct rt2x00_dev *rt2x00dev,
 				struct sk_buff *skb);
 	void (*kick_tx_queue) (struct rt2x00_dev *rt2x00dev,
-			       const unsigned int queue);
+			       const enum data_queue_qid queue);
 
 	/*
 	 * RX control handlers
@@ -927,13 +927,12 @@ static inline u16 get_duration_res(const unsigned int size, const u8 rate)
 }
 
 /**
- * rt2x00queue_get_queue - Convert mac80211 queue index to rt2x00 queue
+ * rt2x00queue_get_queue - Convert queue index to queue pointer
  * @rt2x00dev: Pointer to &struct rt2x00_dev.
- * @queue: mac80211/rt2x00 queue index
- *	(see &enum ieee80211_tx_queue and &enum rt2x00_bcn_queue).
+ * @queue: rt2x00 queue index (see &enum data_queue_qid).
  */
 struct data_queue *rt2x00queue_get_queue(struct rt2x00_dev *rt2x00dev,
-					 const unsigned int queue);
+					 const enum data_queue_qid queue);
 
 /**
  * rt2x00queue_get_entry - Get queue entry where the given index points to.
diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index f8fe7a1..0a398da 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -685,8 +685,7 @@ void rt2x00lib_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 	 * Beacons and probe responses require the tsf timestamp
 	 * to be inserted into the frame.
 	 */
-	if (control->queue == RT2X00_BCN_QUEUE_BEACON ||
-	    is_probe_resp(frame_control))
+	if (txdesc.queue == QID_BEACON || is_probe_resp(frame_control))
 		__set_bit(ENTRY_TXD_REQ_TIMESTAMP, &txdesc.flags);
 
 	/*
diff --git a/drivers/net/wireless/rt2x00/rt2x00mac.c b/drivers/net/wireless/rt2x00/rt2x00mac.c
index e078e0a..d4ceab7 100644
--- a/drivers/net/wireless/rt2x00/rt2x00mac.c
+++ b/drivers/net/wireless/rt2x00/rt2x00mac.c
@@ -81,6 +81,7 @@ int rt2x00mac_tx(struct ieee80211_hw *hw, struct sk_buff *skb,
 {
 	struct rt2x00_dev *rt2x00dev = hw->priv;
 	struct ieee80211_hdr *ieee80211hdr = (struct ieee80211_hdr *)skb->data;
+	enum data_queue_qid qid = mac80211_queue_to_qid(control->queue);
 	struct data_queue *queue;
 	struct skb_frame_desc *skbdesc;
 	u16 frame_control;
@@ -101,14 +102,13 @@ int rt2x00mac_tx(struct ieee80211_hw *hw, struct sk_buff *skb,
 	 */
 	if (control->flags & IEEE80211_TXCTL_SEND_AFTER_DTIM &&
 	    test_bit(DRIVER_REQUIRE_ATIM_QUEUE, &rt2x00dev->flags))
-		queue = rt2x00queue_get_queue(rt2x00dev, RT2X00_BCN_QUEUE_ATIM);
+		queue = rt2x00queue_get_queue(rt2x00dev, QID_ATIM);
 	else
-		queue = rt2x00queue_get_queue(rt2x00dev, control->queue);
+		queue = rt2x00queue_get_queue(rt2x00dev, qid);
 	if (unlikely(!queue)) {
 		ERROR(rt2x00dev,
 		      "Attempt to send packet over invalid queue %d.\n"
-		      "Please file bug report to %s.\n",
-		      control->queue, DRV_PROJECT);
+		      "Please file bug report to %s.\n", qid, DRV_PROJECT);
 		dev_kfree_skb_any(skb);
 		return NETDEV_TX_OK;
 	}
@@ -154,7 +154,7 @@ int rt2x00mac_tx(struct ieee80211_hw *hw, struct sk_buff *skb,
 		ieee80211_stop_queue(rt2x00dev->hw, control->queue);
 
 	if (rt2x00dev->ops->lib->kick_tx_queue)
-		rt2x00dev->ops->lib->kick_tx_queue(rt2x00dev, control->queue);
+		rt2x00dev->ops->lib->kick_tx_queue(rt2x00dev, qid);
 
 	return NETDEV_TX_OK;
 }
@@ -187,8 +187,7 @@ int rt2x00mac_add_interface(struct ieee80211_hw *hw,
 {
 	struct rt2x00_dev *rt2x00dev = hw->priv;
 	struct rt2x00_intf *intf = vif_to_intf(conf->vif);
-	struct data_queue *queue =
-	    rt2x00queue_get_queue(rt2x00dev, RT2X00_BCN_QUEUE_BEACON);
+	struct data_queue *queue = rt2x00queue_get_queue(rt2x00dev, QID_BEACON);
 	struct queue_entry *entry = NULL;
 	unsigned int i;
 
diff --git a/drivers/net/wireless/rt2x00/rt2x00pci.c b/drivers/net/wireless/rt2x00/rt2x00pci.c
index 7867ec6..9e5d94e 100644
--- a/drivers/net/wireless/rt2x00/rt2x00pci.c
+++ b/drivers/net/wireless/rt2x00/rt2x00pci.c
@@ -53,7 +53,7 @@ int rt2x00pci_write_tx_data(struct rt2x00_dev *rt2x00dev,
 		ERROR(rt2x00dev,
 		      "Arrived at non-free entry in the non-full queue %d.\n"
 		      "Please file bug report to %s.\n",
-		      control->queue, DRV_PROJECT);
+		      entry->queue->qid, DRV_PROJECT);
 		return -EINVAL;
 	}
 
diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.c b/drivers/net/wireless/rt2x00/rt2x00queue.c
index 659e9f4..e5b861f 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.c
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.c
@@ -30,7 +30,7 @@
 #include "rt2x00lib.h"
 
 struct data_queue *rt2x00queue_get_queue(struct rt2x00_dev *rt2x00dev,
-					 const unsigned int queue)
+					 const enum data_queue_qid queue)
 {
 	int atim = test_bit(DRIVER_REQUIRE_ATIM_QUEUE, &rt2x00dev->flags);
 
@@ -40,9 +40,9 @@ struct data_queue *rt2x00queue_get_queue(struct rt2x00_dev *rt2x00dev,
 	if (!rt2x00dev->bcn)
 		return NULL;
 
-	if (queue == RT2X00_BCN_QUEUE_BEACON)
+	if (queue == QID_BEACON)
 		return &rt2x00dev->bcn[0];
-	else if (queue == RT2X00_BCN_QUEUE_ATIM && atim)
+	else if (queue == QID_ATIM && atim)
 		return &rt2x00dev->bcn[1];
 
 	return NULL;
diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.h b/drivers/net/wireless/rt2x00/rt2x00queue.h
index 7027c9f..29fe265 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.h
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.h
@@ -54,6 +54,17 @@
 
 /**
  * enum data_queue_qid: Queue identification
+ *
+ * @QID_AC_BE: AC BE queue
+ * @QID_AC_BK: AC BK queue
+ * @QID_AC_VI: AC VI queue
+ * @QID_AC_VO: AC VO queue
+ * @QID_HCCA: HCCA queue
+ * @QID_MGMT: MGMT queue (prio queue)
+ * @QID_RX: RX queue
+ * @QID_OTHER: None of the above (don't use, only present for completeness)
+ * @QID_BEACON: Beacon queue (value unspecified, don't send it to device)
+ * @QID_ATIM: Atim queue (value unspeficied, don't send it to device)
  */
 enum data_queue_qid {
 	QID_AC_BE = 0,
@@ -64,22 +75,25 @@ enum data_queue_qid {
 	QID_MGMT = 13,
 	QID_RX = 14,
 	QID_OTHER = 15,
+	QID_BEACON,
+	QID_ATIM,
 };
 
 /**
- * enum rt2x00_bcn_queue: Beacon queue index
- *
- * Start counting with a high offset, this because this enumeration
- * supplements &enum ieee80211_tx_queue and we should prevent value
- * conflicts.
- *
- * @RT2X00_BCN_QUEUE_BEACON: Beacon queue
- * @RT2X00_BCN_QUEUE_ATIM: Atim queue (sends frame after beacon)
+ * mac80211_queue_to_qid - Convert mac80211 queue to rt2x00 qid
+ * @queue: mac80211 queue.
  */
-enum rt2x00_bcn_queue {
-	RT2X00_BCN_QUEUE_BEACON = 100,
-	RT2X00_BCN_QUEUE_ATIM = 101,
-};
+static inline enum data_queue_qid mac80211_queue_to_qid(unsigned int queue)
+{
+	/* Regular TX queues are mapped directly */
+	if (queue < NUM_TX_DATA_QUEUES)
+		return queue;
+	else if (queue == IEEE80211_TX_QUEUE_BEACON)
+		return QID_BEACON;
+	else if (queue == IEEE80211_TX_QUEUE_AFTER_BEACON)
+		return QID_ATIM;
+	return QID_OTHER;
+}
 
 /**
  * enum skb_frame_desc_flags: Flags for &struct skb_frame_desc
@@ -105,7 +119,6 @@ enum skb_frame_desc_flags {
  *	of the scope of the skb->data pointer.
  * @data_len: Length of the frame data.
  * @desc_len: Length of the frame descriptor.
-
  * @entry: The entry to which this sk buffer belongs.
  */
 struct skb_frame_desc {
@@ -240,7 +253,6 @@ struct txentry_desc {
  *	encryption or decryption. The entry should only be touched after
  *	the device has signaled it is done with it.
  */
-
 enum queue_entry_flags {
 	ENTRY_BCN_ASSIGNED,
 	ENTRY_OWNER_DEVICE_DATA,
diff --git a/drivers/net/wireless/rt2x00/rt2x00usb.c b/drivers/net/wireless/rt2x00/rt2x00usb.c
index 5a33167..47f96b3 100644
--- a/drivers/net/wireless/rt2x00/rt2x00usb.c
+++ b/drivers/net/wireless/rt2x00/rt2x00usb.c
@@ -186,7 +186,7 @@ int rt2x00usb_write_tx_data(struct rt2x00_dev *rt2x00dev,
 		ERROR(rt2x00dev,
 		      "Arrived at non-free entry in the non-full queue %d.\n"
 		      "Please file bug report to %s.\n",
-		      control->queue, DRV_PROJECT);
+		      entry->queue->qid, DRV_PROJECT);
 		return -EINVAL;
 	}
 
diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index 468a31c..d173a03 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -1591,11 +1591,11 @@ static void rt61pci_write_tx_desc(struct rt2x00_dev *rt2x00dev,
  * TX data initialization
  */
 static void rt61pci_kick_tx_queue(struct rt2x00_dev *rt2x00dev,
-				  const unsigned int queue)
+				  const enum data_queue_qid queue)
 {
 	u32 reg;
 
-	if (queue == RT2X00_BCN_QUEUE_BEACON) {
+	if (queue == QID_BEACON) {
 		/*
 		 * For Wi-Fi faily generated beacons between participating
 		 * stations. Set TBTT phase adaptive adjustment step to 8us.
@@ -1613,14 +1613,10 @@ static void rt61pci_kick_tx_queue(struct rt2x00_dev *rt2x00dev,
 	}
 
 	rt2x00pci_register_read(rt2x00dev, TX_CNTL_CSR, &reg);
-	rt2x00_set_field32(&reg, TX_CNTL_CSR_KICK_TX_AC0,
-			   (queue == IEEE80211_TX_QUEUE_DATA0));
-	rt2x00_set_field32(&reg, TX_CNTL_CSR_KICK_TX_AC1,
-			   (queue == IEEE80211_TX_QUEUE_DATA1));
-	rt2x00_set_field32(&reg, TX_CNTL_CSR_KICK_TX_AC2,
-			   (queue == IEEE80211_TX_QUEUE_DATA2));
-	rt2x00_set_field32(&reg, TX_CNTL_CSR_KICK_TX_AC3,
-			   (queue == IEEE80211_TX_QUEUE_DATA3));
+	rt2x00_set_field32(&reg, TX_CNTL_CSR_KICK_TX_AC0, (queue == QID_AC_BE));
+	rt2x00_set_field32(&reg, TX_CNTL_CSR_KICK_TX_AC1, (queue == QID_AC_BK));
+	rt2x00_set_field32(&reg, TX_CNTL_CSR_KICK_TX_AC2, (queue == QID_AC_VI));
+	rt2x00_set_field32(&reg, TX_CNTL_CSR_KICK_TX_AC3, (queue == QID_AC_VO));
 	rt2x00pci_register_write(rt2x00dev, TX_CNTL_CSR, reg);
 }
 
@@ -2412,21 +2408,14 @@ static int rt61pci_beacon_update(struct ieee80211_hw *hw, struct sk_buff *skb,
 	rt2x00pci_register_write(rt2x00dev, TXRX_CSR9, reg);
 
 	/*
-	 * mac80211 doesn't provide the control->queue variable
-	 * for beacons. Set our own queue identification so
-	 * it can be used during descriptor initialization.
-	 */
-	control->queue = RT2X00_BCN_QUEUE_BEACON;
-	rt2x00lib_write_tx_desc(rt2x00dev, skb, control);
-
-	/*
 	 * Write entire beacon with descriptor to register,
 	 * and kick the beacon generator.
 	 */
+	rt2x00lib_write_tx_desc(rt2x00dev, skb, control);
 	beacon_base = HW_BEACON_OFFSET(intf->beacon->entry_idx);
 	rt2x00pci_register_multiwrite(rt2x00dev, beacon_base,
 				      skb->data, skb->len);
-	rt61pci_kick_tx_queue(rt2x00dev, control->queue);
+	rt61pci_kick_tx_queue(rt2x00dev, QID_BEACON);
 
 	return 0;
 }
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index a9efe25..d7028c5 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -1331,11 +1331,11 @@ static int rt73usb_get_tx_data_len(struct rt2x00_dev *rt2x00dev,
  * TX data initialization
  */
 static void rt73usb_kick_tx_queue(struct rt2x00_dev *rt2x00dev,
-				  const unsigned int queue)
+				  const enum data_queue_qid queue)
 {
 	u32 reg;
 
-	if (queue != RT2X00_BCN_QUEUE_BEACON)
+	if (queue != QID_BEACON)
 		return;
 
 	/*
@@ -2001,23 +2001,16 @@ static int rt73usb_beacon_update(struct ieee80211_hw *hw, struct sk_buff *skb,
 	rt73usb_register_write(rt2x00dev, TXRX_CSR9, reg);
 
 	/*
-	 * mac80211 doesn't provide the control->queue variable
-	 * for beacons. Set our own queue identification so
-	 * it can be used during descriptor initialization.
-	 */
-	control->queue = RT2X00_BCN_QUEUE_BEACON;
-	rt2x00lib_write_tx_desc(rt2x00dev, skb, control);
-
-	/*
 	 * Write entire beacon with descriptor to register,
 	 * and kick the beacon generator.
 	 */
+	rt2x00lib_write_tx_desc(rt2x00dev, skb, control);
 	beacon_base = HW_BEACON_OFFSET(intf->beacon->entry_idx);
 	timeout = REGISTER_TIMEOUT * (skb->len / sizeof(u32));
 	rt2x00usb_vendor_request(rt2x00dev, USB_MULTI_WRITE,
 				 USB_VENDOR_REQUEST_OUT, beacon_base, 0,
 				 skb->data, skb->len, timeout);
-	rt73usb_kick_tx_queue(rt2x00dev, control->queue);
+	rt73usb_kick_tx_queue(rt2x00dev, QID_BEACON);
 
 	return 0;
 }
-- 
1.5.4.5

