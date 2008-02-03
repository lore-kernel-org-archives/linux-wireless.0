Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hs-out-0708.google.com ([64.233.178.243]:17530 "EHLO
	hs-out-2122.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751398AbYBCO4x (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 Feb 2008 09:56:53 -0500
Received: by hs-out-2122.google.com with SMTP id 54so1608907hsz.5
        for <linux-wireless@vger.kernel.org>; Sun, 03 Feb 2008 06:56:52 -0800 (PST)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 17/19] rt2x00: Move beacon and atim queue defines into rt2x00
Date: Sun, 3 Feb 2008 15:54:57 +0100
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200802031541.52167.IvDoorn@gmail.com>
In-Reply-To: <200802031541.52167.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200802031554.58009.IvDoorn@gmail.com> (sfid-20080203_145658_817451_9377900E)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

As Johannes Berg indicated the BEACON and AFTER_BEACON
queue indeces in mac80211 should be removed because they
are too hardware specific. This patch adds the queue index
defines into rt2x00queue.h and removes the dependency of
the defines inside mac80211.h.

Also move rt2x00pci_beacon_update() into rt2400pci and
rt2500pci individually since it is no longer a generic
function since rt61 and rt2800 no longer use that.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2400pci.c   |   53 +++++++++++++++++++++++++---
 drivers/net/wireless/rt2x00/rt2500pci.c   |   55 +++++++++++++++++++++++++---
 drivers/net/wireless/rt2x00/rt2500usb.c   |   12 +++---
 drivers/net/wireless/rt2x00/rt2x00.h      |    7 ++--
 drivers/net/wireless/rt2x00/rt2x00dev.c   |    2 +-
 drivers/net/wireless/rt2x00/rt2x00mac.c   |    2 +-
 drivers/net/wireless/rt2x00/rt2x00pci.c   |   47 ------------------------
 drivers/net/wireless/rt2x00/rt2x00pci.h   |    6 ---
 drivers/net/wireless/rt2x00/rt2x00queue.c |    6 ++--
 drivers/net/wireless/rt2x00/rt2x00queue.h |   15 ++++++++
 drivers/net/wireless/rt2x00/rt61pci.c     |   12 +++---
 drivers/net/wireless/rt2x00/rt73usb.c     |   12 +++---
 12 files changed, 139 insertions(+), 90 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2400pci.c b/drivers/net/wireless/rt2x00/rt2400pci.c
index 0975f55..693f3d3 100644
--- a/drivers/net/wireless/rt2x00/rt2400pci.c
+++ b/drivers/net/wireless/rt2x00/rt2400pci.c
@@ -1028,11 +1028,11 @@ static void rt2400pci_write_tx_desc(struct rt2x00_dev *rt2x00dev,
  * TX data initialization
  */
 static void rt2400pci_kick_tx_queue(struct rt2x00_dev *rt2x00dev,
-				    unsigned int queue)
+				    const unsigned int queue)
 {
 	u32 reg;
 
-	if (queue == IEEE80211_TX_QUEUE_BEACON) {
+	if (queue == RT2X00_BCN_QUEUE_BEACON) {
 		rt2x00pci_register_read(rt2x00dev, CSR14, &reg);
 		if (!rt2x00_get_field32(reg, CSR14_BEACON_GEN)) {
 			rt2x00_set_field32(&reg, CSR14_BEACON_GEN, 1);
@@ -1047,7 +1047,7 @@ static void rt2400pci_kick_tx_queue(struct rt2x00_dev *rt2x00dev,
 	rt2x00_set_field32(&reg, TXCSR0_KICK_TX,
 			   (queue == IEEE80211_TX_QUEUE_DATA1));
 	rt2x00_set_field32(&reg, TXCSR0_KICK_ATIM,
-			   (queue == IEEE80211_TX_QUEUE_AFTER_BEACON));
+			   (queue == RT2X00_BCN_QUEUE_ATIM));
 	rt2x00pci_register_write(rt2x00dev, TXCSR0, reg);
 }
 
@@ -1152,7 +1152,7 @@ static irqreturn_t rt2400pci_interrupt(int irq, void *dev_instance)
 	 * 3 - Atim ring transmit done interrupt.
 	 */
 	if (rt2x00_get_field32(reg, CSR7_TXDONE_ATIMRING))
-		rt2400pci_txdone(rt2x00dev, IEEE80211_TX_QUEUE_AFTER_BEACON);
+		rt2400pci_txdone(rt2x00dev, RT2X00_BCN_QUEUE_ATIM);
 
 	/*
 	 * 4 - Priority ring transmit done interrupt.
@@ -1513,6 +1513,49 @@ static void rt2400pci_reset_tsf(struct ieee80211_hw *hw)
 	rt2x00pci_register_write(rt2x00dev, CSR17, 0);
 }
 
+static int rt2400pci_beacon_update(struct ieee80211_hw *hw, struct sk_buff *skb,
+				   struct ieee80211_tx_control *control)
+{
+	struct rt2x00_dev *rt2x00dev = hw->priv;
+	struct rt2x00_intf *intf = vif_to_intf(control->vif);
+	struct queue_entry_priv_pci_tx *priv_tx;
+	struct skb_frame_desc *skbdesc;
+
+	if (unlikely(!intf->beacon))
+		return -ENOBUFS;
+
+	priv_tx = intf->beacon->priv_data;
+
+	/*
+	 * Fill in skb descriptor
+	 */
+	skbdesc = get_skb_frame_desc(skb);
+	memset(skbdesc, 0, sizeof(*skbdesc));
+	skbdesc->data = skb->data;
+	skbdesc->data_len = skb->len;
+	skbdesc->desc = priv_tx->desc;
+	skbdesc->desc_len = intf->beacon->queue->desc_size;
+	skbdesc->entry = intf->beacon;
+
+	/*
+	 * mac80211 doesn't provide the control->queue variable
+	 * for beacons. Set our own queue identification so
+	 * it can be used during descriptor initialization.
+	 */
+	control->queue = RT2X00_BCN_QUEUE_BEACON;
+	rt2x00lib_write_tx_desc(rt2x00dev, skb, control);
+
+	/*
+	 * Enable beacon generation.
+	 * Write entire beacon with descriptor to register,
+	 * and kick the beacon generator.
+	 */
+	memcpy(priv_tx->data, skb->data, skb->len);
+	rt2x00dev->ops->lib->kick_tx_queue(rt2x00dev, control->queue);
+
+	return 0;
+}
+
 static int rt2400pci_tx_last_beacon(struct ieee80211_hw *hw)
 {
 	struct rt2x00_dev *rt2x00dev = hw->priv;
@@ -1538,7 +1581,7 @@ static const struct ieee80211_ops rt2400pci_mac80211_ops = {
 	.get_tx_stats		= rt2x00mac_get_tx_stats,
 	.get_tsf		= rt2400pci_get_tsf,
 	.reset_tsf		= rt2400pci_reset_tsf,
-	.beacon_update		= rt2x00pci_beacon_update,
+	.beacon_update		= rt2400pci_beacon_update,
 	.tx_last_beacon		= rt2400pci_tx_last_beacon,
 };
 
diff --git a/drivers/net/wireless/rt2x00/rt2500pci.c b/drivers/net/wireless/rt2x00/rt2500pci.c
index 2a902eb..7ad8967 100644
--- a/drivers/net/wireless/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/rt2x00/rt2500pci.c
@@ -276,7 +276,7 @@ static void rt2500pci_config_intf(struct rt2x00_dev *rt2x00dev,
 				  const unsigned int flags)
 {
 	struct data_queue *queue =
-	    rt2x00queue_get_queue(rt2x00dev, IEEE80211_TX_QUEUE_BEACON);
+	    rt2x00queue_get_queue(rt2x00dev, RT2X00_BCN_QUEUE_BEACON);
 	unsigned int bcn_preload;
 	u32 reg;
 
@@ -1182,11 +1182,11 @@ static void rt2500pci_write_tx_desc(struct rt2x00_dev *rt2x00dev,
  * TX data initialization
  */
 static void rt2500pci_kick_tx_queue(struct rt2x00_dev *rt2x00dev,
-				    unsigned int queue)
+				    const unsigned int queue)
 {
 	u32 reg;
 
-	if (queue == IEEE80211_TX_QUEUE_BEACON) {
+	if (queue == RT2X00_BCN_QUEUE_BEACON) {
 		rt2x00pci_register_read(rt2x00dev, CSR14, &reg);
 		if (!rt2x00_get_field32(reg, CSR14_BEACON_GEN)) {
 			rt2x00_set_field32(&reg, CSR14_BEACON_GEN, 1);
@@ -1201,7 +1201,7 @@ static void rt2500pci_kick_tx_queue(struct rt2x00_dev *rt2x00dev,
 	rt2x00_set_field32(&reg, TXCSR0_KICK_TX,
 			   (queue == IEEE80211_TX_QUEUE_DATA1));
 	rt2x00_set_field32(&reg, TXCSR0_KICK_ATIM,
-			   (queue == IEEE80211_TX_QUEUE_AFTER_BEACON));
+			   (queue == RT2X00_BCN_QUEUE_ATIM));
 	rt2x00pci_register_write(rt2x00dev, TXCSR0, reg);
 }
 
@@ -1303,7 +1303,7 @@ static irqreturn_t rt2500pci_interrupt(int irq, void *dev_instance)
 	 * 3 - Atim ring transmit done interrupt.
 	 */
 	if (rt2x00_get_field32(reg, CSR7_TXDONE_ATIMRING))
-		rt2500pci_txdone(rt2x00dev, IEEE80211_TX_QUEUE_AFTER_BEACON);
+		rt2500pci_txdone(rt2x00dev, RT2X00_BCN_QUEUE_ATIM);
 
 	/*
 	 * 4 - Priority ring transmit done interrupt.
@@ -1825,6 +1825,49 @@ static void rt2500pci_reset_tsf(struct ieee80211_hw *hw)
 	rt2x00pci_register_write(rt2x00dev, CSR17, 0);
 }
 
+static int rt2500pci_beacon_update(struct ieee80211_hw *hw, struct sk_buff *skb,
+				   struct ieee80211_tx_control *control)
+{
+	struct rt2x00_dev *rt2x00dev = hw->priv;
+	struct rt2x00_intf *intf = vif_to_intf(control->vif);
+	struct queue_entry_priv_pci_tx *priv_tx;
+	struct skb_frame_desc *skbdesc;
+
+	if (unlikely(!intf->beacon))
+		return -ENOBUFS;
+
+	priv_tx = intf->beacon->priv_data;
+
+	/*
+	 * Fill in skb descriptor
+	 */
+	skbdesc = get_skb_frame_desc(skb);
+	memset(skbdesc, 0, sizeof(*skbdesc));
+	skbdesc->data = skb->data;
+	skbdesc->data_len = skb->len;
+	skbdesc->desc = priv_tx->desc;
+	skbdesc->desc_len = intf->beacon->queue->desc_size;
+	skbdesc->entry = intf->beacon;
+
+	/*
+	 * mac80211 doesn't provide the control->queue variable
+	 * for beacons. Set our own queue identification so
+	 * it can be used during descriptor initialization.
+	 */
+	control->queue = RT2X00_BCN_QUEUE_BEACON;
+	rt2x00lib_write_tx_desc(rt2x00dev, skb, control);
+
+	/*
+	 * Enable beacon generation.
+	 * Write entire beacon with descriptor to register,
+	 * and kick the beacon generator.
+	 */
+	memcpy(priv_tx->data, skb->data, skb->len);
+	rt2x00dev->ops->lib->kick_tx_queue(rt2x00dev, control->queue);
+
+	return 0;
+}
+
 static int rt2500pci_tx_last_beacon(struct ieee80211_hw *hw)
 {
 	struct rt2x00_dev *rt2x00dev = hw->priv;
@@ -1850,7 +1893,7 @@ static const struct ieee80211_ops rt2500pci_mac80211_ops = {
 	.get_tx_stats		= rt2x00mac_get_tx_stats,
 	.get_tsf		= rt2500pci_get_tsf,
 	.reset_tsf		= rt2500pci_reset_tsf,
-	.beacon_update		= rt2x00pci_beacon_update,
+	.beacon_update		= rt2500pci_beacon_update,
 	.tx_last_beacon		= rt2500pci_tx_last_beacon,
 };
 
diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
index 7c48c10..eb98d28 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/rt2x00/rt2500usb.c
@@ -1077,11 +1077,11 @@ static int rt2500usb_get_tx_data_len(struct rt2x00_dev *rt2x00dev,
  * TX data initialization
  */
 static void rt2500usb_kick_tx_queue(struct rt2x00_dev *rt2x00dev,
-				    unsigned int queue)
+				    const unsigned int queue)
 {
 	u16 reg;
 
-	if (queue != IEEE80211_TX_QUEUE_BEACON)
+	if (queue != RT2X00_BCN_QUEUE_BEACON)
 		return;
 
 	rt2500usb_register_read(rt2x00dev, TXRX_CSR19, &reg);
@@ -1758,11 +1758,11 @@ static int rt2500usb_beacon_update(struct ieee80211_hw *hw,
 	skbdesc->entry = intf->beacon;
 
 	/*
-	 * Just in case mac80211 doesn't set this correctly,
-	 * but we need this queue set for the descriptor
-	 * initialization.
+	 * mac80211 doesn't provide the control->queue variable
+	 * for beacons. Set our own queue identification so
+	 * it can be used during descriptor initialization.
 	 */
-	control->queue = IEEE80211_TX_QUEUE_BEACON;
+	control->queue = RT2X00_BCN_QUEUE_BEACON;
 	rt2x00lib_write_tx_desc(rt2x00dev, skb, control);
 
 	/*
diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index 123fe2f..76270e9 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -530,7 +530,7 @@ struct rt2x00lib_ops {
 	int (*get_tx_data_len) (struct rt2x00_dev *rt2x00dev,
 				struct sk_buff *skb);
 	void (*kick_tx_queue) (struct rt2x00_dev *rt2x00dev,
-			       unsigned int queue);
+			       const unsigned int queue);
 
 	/*
 	 * RX control handlers
@@ -910,10 +910,11 @@ static inline u16 get_duration_res(const unsigned int size, const u8 rate)
 /**
  * rt2x00queue_get_queue - Convert mac80211 queue index to rt2x00 queue
  * @rt2x00dev: Pointer to &struct rt2x00_dev.
- * @queue: mac80211 queue index (see &enum ieee80211_tx_queue).
+ * @queue: mac80211/rt2x00 queue index
+ *	(see &enum ieee80211_tx_queue and &enum rt2x00_bcn_queue).
  */
 struct data_queue *rt2x00queue_get_queue(struct rt2x00_dev *rt2x00dev,
-					 const enum ieee80211_tx_queue queue);
+					 const unsigned int queue);
 
 /**
  * rt2x00queue_get_entry - Get queue entry where the given index points to.
diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index 84f0441..c714c4c 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -673,7 +673,7 @@ void rt2x00lib_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 	 * Beacons and probe responses require the tsf timestamp
 	 * to be inserted into the frame.
 	 */
-	if (control->queue == IEEE80211_TX_QUEUE_BEACON ||
+	if (control->queue == RT2X00_BCN_QUEUE_BEACON ||
 	    is_probe_resp(frame_control))
 		__set_bit(ENTRY_TXD_REQ_TIMESTAMP, &txdesc.flags);
 
diff --git a/drivers/net/wireless/rt2x00/rt2x00mac.c b/drivers/net/wireless/rt2x00/rt2x00mac.c
index 65a2bcd..8c24d3b 100644
--- a/drivers/net/wireless/rt2x00/rt2x00mac.c
+++ b/drivers/net/wireless/rt2x00/rt2x00mac.c
@@ -164,7 +164,7 @@ int rt2x00mac_add_interface(struct ieee80211_hw *hw,
 	struct rt2x00_dev *rt2x00dev = hw->priv;
 	struct rt2x00_intf *intf = vif_to_intf(conf->vif);
 	struct data_queue *queue =
-	    rt2x00queue_get_queue(rt2x00dev, IEEE80211_TX_QUEUE_BEACON);
+	    rt2x00queue_get_queue(rt2x00dev, RT2X00_BCN_QUEUE_BEACON);
 	struct queue_entry *entry = NULL;
 	unsigned int i;
 
diff --git a/drivers/net/wireless/rt2x00/rt2x00pci.c b/drivers/net/wireless/rt2x00/rt2x00pci.c
index 764147d..275c8a1 100644
--- a/drivers/net/wireless/rt2x00/rt2x00pci.c
+++ b/drivers/net/wireless/rt2x00/rt2x00pci.c
@@ -32,53 +32,6 @@
 #include "rt2x00pci.h"
 
 /*
- * Beacon handlers.
- */
-int rt2x00pci_beacon_update(struct ieee80211_hw *hw, struct sk_buff *skb,
-			    struct ieee80211_tx_control *control)
-{
-	struct rt2x00_dev *rt2x00dev = hw->priv;
-	struct rt2x00_intf *intf = vif_to_intf(control->vif);
-	struct queue_entry_priv_pci_tx *priv_tx;
-	struct skb_frame_desc *skbdesc;
-
-	if (unlikely(!intf->beacon))
-		return -ENOBUFS;
-
-	priv_tx = intf->beacon->priv_data;
-
-	/*
-	 * Fill in skb descriptor
-	 */
-	skbdesc = get_skb_frame_desc(skb);
-	memset(skbdesc, 0, sizeof(*skbdesc));
-	skbdesc->data = skb->data;
-	skbdesc->data_len = skb->len;
-	skbdesc->desc = priv_tx->desc;
-	skbdesc->desc_len = intf->beacon->queue->desc_size;
-	skbdesc->entry = intf->beacon;
-
-	/*
-	 * Just in case mac80211 doesn't set this correctly,
-	 * but we need this queue set for the descriptor
-	 * initialization.
-	 */
-	control->queue = IEEE80211_TX_QUEUE_BEACON;
-	rt2x00lib_write_tx_desc(rt2x00dev, skb, control);
-
-	/*
-	 * Enable beacon generation.
-	 * Write entire beacon with descriptor to register,
-	 * and kick the beacon generator.
-	 */
-	memcpy(priv_tx->data, skb->data, skb->len);
-	rt2x00dev->ops->lib->kick_tx_queue(rt2x00dev, control->queue);
-
-	return 0;
-}
-EXPORT_SYMBOL_GPL(rt2x00pci_beacon_update);
-
-/*
  * TX data handlers.
  */
 int rt2x00pci_write_tx_data(struct rt2x00_dev *rt2x00dev,
diff --git a/drivers/net/wireless/rt2x00/rt2x00pci.h b/drivers/net/wireless/rt2x00/rt2x00pci.h
index 3b1597f..71335e1 100644
--- a/drivers/net/wireless/rt2x00/rt2x00pci.h
+++ b/drivers/net/wireless/rt2x00/rt2x00pci.h
@@ -88,12 +88,6 @@ rt2x00pci_register_multiwrite(struct rt2x00_dev *rt2x00dev,
 }
 
 /*
- * Beacon handlers.
- */
-int rt2x00pci_beacon_update(struct ieee80211_hw *hw, struct sk_buff *skb,
-			    struct ieee80211_tx_control *control);
-
-/*
  * TX data handlers.
  */
 int rt2x00pci_write_tx_data(struct rt2x00_dev *rt2x00dev,
diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.c b/drivers/net/wireless/rt2x00/rt2x00queue.c
index 921eca3..52bb57d 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.c
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.c
@@ -30,7 +30,7 @@
 #include "rt2x00lib.h"
 
 struct data_queue *rt2x00queue_get_queue(struct rt2x00_dev *rt2x00dev,
-					 const enum ieee80211_tx_queue queue)
+					 const unsigned int queue)
 {
 	int atim = test_bit(DRIVER_REQUIRE_ATIM_QUEUE, &rt2x00dev->flags);
 
@@ -40,9 +40,9 @@ struct data_queue *rt2x00queue_get_queue(struct rt2x00_dev *rt2x00dev,
 	if (!rt2x00dev->bcn)
 		return NULL;
 
-	if (queue == IEEE80211_TX_QUEUE_BEACON)
+	if (queue == RT2X00_BCN_QUEUE_BEACON)
 		return &rt2x00dev->bcn[0];
-	else if (queue == IEEE80211_TX_QUEUE_AFTER_BEACON && atim)
+	else if (queue == RT2X00_BCN_QUEUE_ATIM && atim)
 		return &rt2x00dev->bcn[1];
 
 	return NULL;
diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.h b/drivers/net/wireless/rt2x00/rt2x00queue.h
index 75af48e..956e0be 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.h
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.h
@@ -67,6 +67,21 @@ enum data_queue_qid {
 };
 
 /**
+ * enum rt2x00_bcn_queue: Beacon queue index
+ *
+ * Start counting with a high offset, this because this enumeration
+ * supplements &enum ieee80211_tx_queue and we should prevent value
+ * conflicts.
+ *
+ * @RT2X00_BCN_QUEUE_BEACON: Beacon queue
+ * @RT2X00_BCN_QUEUE_ATIM: Atim queue (sends frame after beacon)
+ */
+enum rt2x00_bcn_queue {
+	RT2X00_BCN_QUEUE_BEACON = 100,
+	RT2X00_BCN_QUEUE_ATIM = 101,
+};
+
+/**
  * struct skb_frame_desc: Descriptor information for the skb buffer
  *
  * This structure is placed over the skb->cb array, this means that
diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index 199c5b7..9fd2dd8 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -1546,11 +1546,11 @@ static void rt61pci_write_tx_desc(struct rt2x00_dev *rt2x00dev,
  * TX data initialization
  */
 static void rt61pci_kick_tx_queue(struct rt2x00_dev *rt2x00dev,
-				  unsigned int queue)
+				  const unsigned int queue)
 {
 	u32 reg;
 
-	if (queue == IEEE80211_TX_QUEUE_BEACON) {
+	if (queue == RT2X00_BCN_QUEUE_BEACON) {
 		/*
 		 * For Wi-Fi faily generated beacons between participating
 		 * stations. Set TBTT phase adaptive adjustment step to 8us.
@@ -2411,11 +2411,11 @@ static int rt61pci_beacon_update(struct ieee80211_hw *hw, struct sk_buff *skb,
 	skbdesc->entry = intf->beacon;
 
 	/*
-	 * Just in case the ieee80211 doesn't set this,
-	 * but we need this queue set for the descriptor
-	 * initialization.
+	 * mac80211 doesn't provide the control->queue variable
+	 * for beacons. Set our own queue identification so
+	 * it can be used during descriptor initialization.
 	 */
-	control->queue = IEEE80211_TX_QUEUE_BEACON;
+	control->queue = RT2X00_BCN_QUEUE_BEACON;
 	rt2x00lib_write_tx_desc(rt2x00dev, skb, control);
 
 	/*
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index e970e32..146135f 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -1290,11 +1290,11 @@ static int rt73usb_get_tx_data_len(struct rt2x00_dev *rt2x00dev,
  * TX data initialization
  */
 static void rt73usb_kick_tx_queue(struct rt2x00_dev *rt2x00dev,
-				  unsigned int queue)
+				  const unsigned int queue)
 {
 	u32 reg;
 
-	if (queue != IEEE80211_TX_QUEUE_BEACON)
+	if (queue != RT2X00_BCN_QUEUE_BEACON)
 		return;
 
 	/*
@@ -2011,11 +2011,11 @@ static int rt73usb_beacon_update(struct ieee80211_hw *hw, struct sk_buff *skb,
 	skbdesc->entry = intf->beacon;
 
 	/*
-	 * Just in case the ieee80211 doesn't set this,
-	 * but we need this queue set for the descriptor
-	 * initialization.
+	 * mac80211 doesn't provide the control->queue variable
+	 * for beacons. Set our own queue identification so
+	 * it can be used during descriptor initialization.
 	 */
-	control->queue = IEEE80211_TX_QUEUE_BEACON;
+	control->queue = RT2X00_BCN_QUEUE_BEACON;
 	rt2x00lib_write_tx_desc(rt2x00dev, skb, control);
 
 	/*
-- 
1.5.3.8

