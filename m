Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f21.google.com ([209.85.219.21]:39955 "EHLO
	mail-ew0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751515AbZA0XeI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Jan 2009 18:34:08 -0500
Received: by ewy14 with SMTP id 14so2476770ewy.13
        for <linux-wireless@vger.kernel.org>; Tue, 27 Jan 2009 15:34:06 -0800 (PST)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH 2/3] rt2x00: Add kill_tx_queue callback function
Date: Wed, 28 Jan 2009 00:32:33 +0100
Cc: rt2400-devel@lists.sourceforge.net,
	"linux-wireless" <linux-wireless@vger.kernel.org>
References: <200901280032.13646.IvDoorn@gmail.com>
In-Reply-To: <200901280032.13646.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200901280032.33474.IvDoorn@gmail.com> (sfid-20090128_003414_045386_6EA505A7)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

provide rt2x00lib the possibility to kill a particular TX queue.
This can be useful when disabling the radio, but more importantly
will allow beaconing to be disabled when mac80211 requests this
(during scanning for example)

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2400pci.c   |   30 ++++++++------
 drivers/net/wireless/rt2x00/rt2500pci.c   |   30 ++++++++------
 drivers/net/wireless/rt2x00/rt2500usb.c   |    1 +
 drivers/net/wireless/rt2x00/rt2x00.h      |    2 +
 drivers/net/wireless/rt2x00/rt2x00dev.c   |    5 +-
 drivers/net/wireless/rt2x00/rt2x00lib.h   |   13 ++++++-
 drivers/net/wireless/rt2x00/rt2x00mac.c   |    6 ++-
 drivers/net/wireless/rt2x00/rt2x00queue.c |   19 ++++++++-
 drivers/net/wireless/rt2x00/rt2x00usb.c   |   62 +++++++++++++++++-----------
 drivers/net/wireless/rt2x00/rt2x00usb.h   |   11 +++++
 drivers/net/wireless/rt2x00/rt61pci.c     |   37 ++++++++++-------
 drivers/net/wireless/rt2x00/rt73usb.c     |    1 +
 12 files changed, 145 insertions(+), 72 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2400pci.c b/drivers/net/wireless/rt2x00/rt2400pci.c
index 4a2c0b9..b084825 100644
--- a/drivers/net/wireless/rt2x00/rt2400pci.c
+++ b/drivers/net/wireless/rt2x00/rt2400pci.c
@@ -934,21 +934,10 @@ static int rt2400pci_enable_radio(struct rt2x00_dev *rt2x00dev)
 
 static void rt2400pci_disable_radio(struct rt2x00_dev *rt2x00dev)
 {
-	u32 reg;
-
-	rt2x00pci_register_write(rt2x00dev, PWRCSR0, 0);
-
 	/*
-	 * Disable synchronisation.
+	 * Disable power
 	 */
-	rt2x00pci_register_write(rt2x00dev, CSR14, 0);
-
-	/*
-	 * Cancel RX and TX.
-	 */
-	rt2x00pci_register_read(rt2x00dev, TXCSR0, &reg);
-	rt2x00_set_field32(&reg, TXCSR0_ABORT, 1);
-	rt2x00pci_register_write(rt2x00dev, TXCSR0, reg);
+	rt2x00pci_register_write(rt2x00dev, PWRCSR0, 0);
 }
 
 static int rt2400pci_set_state(struct rt2x00_dev *rt2x00dev,
@@ -1145,6 +1134,20 @@ static void rt2400pci_kick_tx_queue(struct rt2x00_dev *rt2x00dev,
 	rt2x00pci_register_write(rt2x00dev, TXCSR0, reg);
 }
 
+static void rt2400pci_kill_tx_queue(struct rt2x00_dev *rt2x00dev,
+				    const enum data_queue_qid qid)
+{
+	u32 reg;
+
+	if (qid == QID_BEACON) {
+		rt2x00pci_register_write(rt2x00dev, CSR14, 0);
+	} else {
+		rt2x00pci_register_read(rt2x00dev, TXCSR0, &reg);
+		rt2x00_set_field32(&reg, TXCSR0_ABORT, 1);
+		rt2x00pci_register_write(rt2x00dev, TXCSR0, reg);
+	}
+}
+
 /*
  * RX control handlers
  */
@@ -1606,6 +1609,7 @@ static const struct rt2x00lib_ops rt2400pci_rt2x00_ops = {
 	.write_tx_data		= rt2x00pci_write_tx_data,
 	.write_beacon		= rt2400pci_write_beacon,
 	.kick_tx_queue		= rt2400pci_kick_tx_queue,
+	.kill_tx_queue		= rt2400pci_kill_tx_queue,
 	.fill_rxdone		= rt2400pci_fill_rxdone,
 	.config_filter		= rt2400pci_config_filter,
 	.config_intf		= rt2400pci_config_intf,
diff --git a/drivers/net/wireless/rt2x00/rt2500pci.c b/drivers/net/wireless/rt2x00/rt2500pci.c
index b9104e2..eb82860 100644
--- a/drivers/net/wireless/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/rt2x00/rt2500pci.c
@@ -1093,21 +1093,10 @@ static int rt2500pci_enable_radio(struct rt2x00_dev *rt2x00dev)
 
 static void rt2500pci_disable_radio(struct rt2x00_dev *rt2x00dev)
 {
-	u32 reg;
-
-	rt2x00pci_register_write(rt2x00dev, PWRCSR0, 0);
-
 	/*
-	 * Disable synchronisation.
+	 * Disable power
 	 */
-	rt2x00pci_register_write(rt2x00dev, CSR14, 0);
-
-	/*
-	 * Cancel RX and TX.
-	 */
-	rt2x00pci_register_read(rt2x00dev, TXCSR0, &reg);
-	rt2x00_set_field32(&reg, TXCSR0_ABORT, 1);
-	rt2x00pci_register_write(rt2x00dev, TXCSR0, reg);
+	rt2x00pci_register_write(rt2x00dev, PWRCSR0, 0);
 }
 
 static int rt2500pci_set_state(struct rt2x00_dev *rt2x00dev,
@@ -1303,6 +1292,20 @@ static void rt2500pci_kick_tx_queue(struct rt2x00_dev *rt2x00dev,
 	rt2x00pci_register_write(rt2x00dev, TXCSR0, reg);
 }
 
+static void rt2500pci_kill_tx_queue(struct rt2x00_dev *rt2x00dev,
+				    const enum data_queue_qid qid)
+{
+	u32 reg;
+
+	if (qid == QID_BEACON) {
+		rt2x00pci_register_write(rt2x00dev, CSR14, 0);
+	} else {
+		rt2x00pci_register_read(rt2x00dev, TXCSR0, &reg);
+		rt2x00_set_field32(&reg, TXCSR0_ABORT, 1);
+		rt2x00pci_register_write(rt2x00dev, TXCSR0, reg);
+	}
+}
+
 /*
  * RX control handlers
  */
@@ -1905,6 +1908,7 @@ static const struct rt2x00lib_ops rt2500pci_rt2x00_ops = {
 	.write_tx_data		= rt2x00pci_write_tx_data,
 	.write_beacon		= rt2500pci_write_beacon,
 	.kick_tx_queue		= rt2500pci_kick_tx_queue,
+	.kill_tx_queue		= rt2500pci_kill_tx_queue,
 	.fill_rxdone		= rt2500pci_fill_rxdone,
 	.config_filter		= rt2500pci_config_filter,
 	.config_intf		= rt2500pci_config_intf,
diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
index c526e73..270691a 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/rt2x00/rt2500usb.c
@@ -1935,6 +1935,7 @@ static const struct rt2x00lib_ops rt2500usb_rt2x00_ops = {
 	.write_beacon		= rt2500usb_write_beacon,
 	.get_tx_data_len	= rt2500usb_get_tx_data_len,
 	.kick_tx_queue		= rt2500usb_kick_tx_queue,
+	.kill_tx_queue		= rt2x00usb_kill_tx_queue,
 	.fill_rxdone		= rt2500usb_fill_rxdone,
 	.config_shared_key	= rt2500usb_config_key,
 	.config_pairwise_key	= rt2500usb_config_key,
diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index d0a8256..94fb571 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -508,6 +508,8 @@ struct rt2x00lib_ops {
 	int (*get_tx_data_len) (struct queue_entry *entry);
 	void (*kick_tx_queue) (struct rt2x00_dev *rt2x00dev,
 			       const enum data_queue_qid queue);
+	void (*kill_tx_queue) (struct rt2x00_dev *rt2x00dev,
+			       const enum data_queue_qid queue);
 
 	/*
 	 * RX control handlers
diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index e681d23..05f94e2 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -83,9 +83,10 @@ void rt2x00lib_disable_radio(struct rt2x00_dev *rt2x00dev)
 		return;
 
 	/*
-	 * Stop the TX queues.
+	 * Stop the TX queues in mac80211.
 	 */
 	ieee80211_stop_queues(rt2x00dev->hw);
+	rt2x00queue_stop_queues(rt2x00dev);
 
 	/*
 	 * Disable RX.
@@ -157,7 +158,7 @@ static void rt2x00lib_intf_scheduled_iter(void *data, u8 *mac,
 		return;
 
 	if (delayed_flags & DELAYED_UPDATE_BEACON)
-		rt2x00queue_update_beacon(rt2x00dev, vif);
+		rt2x00queue_update_beacon(rt2x00dev, vif, true);
 
 	if (delayed_flags & DELAYED_CONFIG_ERP)
 		rt2x00lib_config_erp(rt2x00dev, intf, &conf);
diff --git a/drivers/net/wireless/rt2x00/rt2x00lib.h b/drivers/net/wireless/rt2x00/rt2x00lib.h
index 34efe46..a631613 100644
--- a/drivers/net/wireless/rt2x00/rt2x00lib.h
+++ b/drivers/net/wireless/rt2x00/rt2x00lib.h
@@ -123,9 +123,11 @@ int rt2x00queue_write_tx_frame(struct data_queue *queue, struct sk_buff *skb);
  * rt2x00queue_update_beacon - Send new beacon from mac80211 to hardware
  * @rt2x00dev: Pointer to &struct rt2x00_dev.
  * @vif: Interface for which the beacon should be updated.
+ * @enable_beacon: Enable beaconing
  */
 int rt2x00queue_update_beacon(struct rt2x00_dev *rt2x00dev,
-			      struct ieee80211_vif *vif);
+			      struct ieee80211_vif *vif,
+			      const bool enable_beacon);
 
 /**
  * rt2x00queue_index_inc - Index incrementation function
@@ -139,6 +141,15 @@ int rt2x00queue_update_beacon(struct rt2x00_dev *rt2x00dev,
 void rt2x00queue_index_inc(struct data_queue *queue, enum queue_index index);
 
 /**
+ * rt2x00queue_stop_queues - Halt all data queues
+ * @rt2x00dev: Pointer to &struct rt2x00_dev.
+ *
+ * This function will loop through all available queues to stop
+ * any pending outgoing frames.
+ */
+void rt2x00queue_stop_queues(struct rt2x00_dev *rt2x00dev);
+
+/**
  * rt2x00queue_init_queues - Initialize all data queues
  * @rt2x00dev: Pointer to &struct rt2x00_dev.
  *
diff --git a/drivers/net/wireless/rt2x00/rt2x00mac.c b/drivers/net/wireless/rt2x00/rt2x00mac.c
index 71de8a7..c41a0b9 100644
--- a/drivers/net/wireless/rt2x00/rt2x00mac.c
+++ b/drivers/net/wireless/rt2x00/rt2x00mac.c
@@ -431,8 +431,10 @@ int rt2x00mac_config_interface(struct ieee80211_hw *hw,
 	/*
 	 * Update the beacon.
 	 */
-	if (conf->changed & IEEE80211_IFCC_BEACON)
-		status = rt2x00queue_update_beacon(rt2x00dev, vif);
+	if (conf->changed & (IEEE80211_IFCC_BEACON |
+			     IEEE80211_IFCC_BEACON_ENABLED))
+		status = rt2x00queue_update_beacon(rt2x00dev, vif,
+						   conf->enable_beacon);
 
 	return status;
 }
diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.c b/drivers/net/wireless/rt2x00/rt2x00queue.c
index c86fb64..a5664bd 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.c
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.c
@@ -443,7 +443,8 @@ int rt2x00queue_write_tx_frame(struct data_queue *queue, struct sk_buff *skb)
 }
 
 int rt2x00queue_update_beacon(struct rt2x00_dev *rt2x00dev,
-			      struct ieee80211_vif *vif)
+			      struct ieee80211_vif *vif,
+			      const bool enable_beacon)
 {
 	struct rt2x00_intf *intf = vif_to_intf(vif);
 	struct skb_frame_desc *skbdesc;
@@ -453,6 +454,11 @@ int rt2x00queue_update_beacon(struct rt2x00_dev *rt2x00dev,
 	if (unlikely(!intf->beacon))
 		return -ENOBUFS;
 
+	if (!enable_beacon) {
+		rt2x00dev->ops->lib->kill_tx_queue(rt2x00dev, QID_BEACON);
+		return 0;
+	}
+
 	intf->beacon->skb = ieee80211_beacon_get(rt2x00dev->hw, vif);
 	if (!intf->beacon->skb)
 		return -ENOMEM;
@@ -501,6 +507,9 @@ struct data_queue *rt2x00queue_get_queue(struct rt2x00_dev *rt2x00dev,
 {
 	int atim = test_bit(DRIVER_REQUIRE_ATIM_QUEUE, &rt2x00dev->flags);
 
+	if (queue == QID_RX)
+		return rt2x00dev->rx;
+
 	if (queue < rt2x00dev->ops->tx_queues && rt2x00dev->tx)
 		return &rt2x00dev->tx[queue];
 
@@ -577,6 +586,14 @@ static void rt2x00queue_reset(struct data_queue *queue)
 	spin_unlock_irqrestore(&queue->lock, irqflags);
 }
 
+void rt2x00queue_stop_queues(struct rt2x00_dev *rt2x00dev)
+{
+	struct data_queue *queue;
+
+	txall_queue_for_each(rt2x00dev, queue)
+		rt2x00dev->ops->lib->kill_tx_queue(rt2x00dev, queue->qid);
+}
+
 void rt2x00queue_init_queues(struct rt2x00_dev *rt2x00dev)
 {
 	struct data_queue *queue;
diff --git a/drivers/net/wireless/rt2x00/rt2x00usb.c b/drivers/net/wireless/rt2x00/rt2x00usb.c
index c89d152..7d50ca8 100644
--- a/drivers/net/wireless/rt2x00/rt2x00usb.c
+++ b/drivers/net/wireless/rt2x00/rt2x00usb.c
@@ -296,6 +296,41 @@ void rt2x00usb_kick_tx_queue(struct rt2x00_dev *rt2x00dev,
 }
 EXPORT_SYMBOL_GPL(rt2x00usb_kick_tx_queue);
 
+void rt2x00usb_kill_tx_queue(struct rt2x00_dev *rt2x00dev,
+			     const enum data_queue_qid qid)
+{
+	struct data_queue *queue = rt2x00queue_get_queue(rt2x00dev, qid);
+	struct queue_entry_priv_usb *entry_priv;
+	struct queue_entry_priv_usb_bcn *bcn_priv;
+	unsigned int i;
+	bool kill_guard;
+
+	/*
+	 * When killing the beacon queue, we must also kill
+	 * the beacon guard byte.
+	 */
+	kill_guard =
+	    (qid == QID_BEACON) &&
+	    (test_bit(DRIVER_REQUIRE_BEACON_GUARD, &rt2x00dev->flags));
+
+	/*
+	 * Cancel all entries.
+	 */
+	for (i = 0; i < queue->limit; i++) {
+		entry_priv = queue->entries[i].priv_data;
+		usb_kill_urb(entry_priv->urb);
+
+		/*
+		 * Kill guardian urb (if required by driver).
+		 */
+		if (kill_guard) {
+			bcn_priv = queue->entries[i].priv_data;
+			usb_kill_urb(bcn_priv->guardian_urb);
+		}
+	}
+}
+EXPORT_SYMBOL_GPL(rt2x00usb_kill_tx_queue);
+
 /*
  * RX data handlers.
  */
@@ -338,35 +373,14 @@ static void rt2x00usb_interrupt_rxdone(struct urb *urb)
  */
 void rt2x00usb_disable_radio(struct rt2x00_dev *rt2x00dev)
 {
-	struct queue_entry_priv_usb *entry_priv;
-	struct queue_entry_priv_usb_bcn *bcn_priv;
-	struct data_queue *queue;
-	unsigned int i;
-
 	rt2x00usb_vendor_request_sw(rt2x00dev, USB_RX_CONTROL, 0, 0,
 				    REGISTER_TIMEOUT);
 
 	/*
-	 * Cancel all queues.
+	 * The USB version of kill_tx_queue also works
+	 * on the RX queue.
 	 */
-	queue_for_each(rt2x00dev, queue) {
-		for (i = 0; i < queue->limit; i++) {
-			entry_priv = queue->entries[i].priv_data;
-			usb_kill_urb(entry_priv->urb);
-		}
-	}
-
-	/*
-	 * Kill guardian urb (if required by driver).
-	 */
-	if (!test_bit(DRIVER_REQUIRE_BEACON_GUARD, &rt2x00dev->flags))
-		return;
-
-	for (i = 0; i < rt2x00dev->bcn->limit; i++) {
-		bcn_priv = rt2x00dev->bcn->entries[i].priv_data;
-		if (bcn_priv->guardian_urb)
-			usb_kill_urb(bcn_priv->guardian_urb);
-	}
+	rt2x00dev->ops->lib->kill_tx_queue(rt2x00dev, QID_RX);
 }
 EXPORT_SYMBOL_GPL(rt2x00usb_disable_radio);
 
diff --git a/drivers/net/wireless/rt2x00/rt2x00usb.h b/drivers/net/wireless/rt2x00/rt2x00usb.h
index fe45238..bd2d59c 100644
--- a/drivers/net/wireless/rt2x00/rt2x00usb.h
+++ b/drivers/net/wireless/rt2x00/rt2x00usb.h
@@ -419,6 +419,17 @@ struct queue_entry_priv_usb_bcn {
 void rt2x00usb_kick_tx_queue(struct rt2x00_dev *rt2x00dev,
 			     const enum data_queue_qid qid);
 
+/**
+ * rt2x00usb_kill_tx_queue - Kill data queue
+ * @rt2x00dev: Pointer to &struct rt2x00_dev
+ * @qid: Data queue to kill
+ *
+ * This will walk through all entries of the queue and kill all
+ * previously kicked frames before they can be send.
+ */
+void rt2x00usb_kill_tx_queue(struct rt2x00_dev *rt2x00dev,
+			      const enum data_queue_qid qid);
+
 /*
  * Device initialization handlers.
  */
diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index d81a8de..c7ad1b3 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -1696,24 +1696,10 @@ static int rt61pci_enable_radio(struct rt2x00_dev *rt2x00dev)
 
 static void rt61pci_disable_radio(struct rt2x00_dev *rt2x00dev)
 {
-	u32 reg;
-
-	rt2x00pci_register_write(rt2x00dev, MAC_CSR10, 0x00001818);
-
-	/*
-	 * Disable synchronisation.
-	 */
-	rt2x00pci_register_write(rt2x00dev, TXRX_CSR9, 0);
-
 	/*
-	 * Cancel RX and TX.
+	 * Disable power
 	 */
-	rt2x00pci_register_read(rt2x00dev, TX_CNTL_CSR, &reg);
-	rt2x00_set_field32(&reg, TX_CNTL_CSR_ABORT_TX_AC0, 1);
-	rt2x00_set_field32(&reg, TX_CNTL_CSR_ABORT_TX_AC1, 1);
-	rt2x00_set_field32(&reg, TX_CNTL_CSR_ABORT_TX_AC2, 1);
-	rt2x00_set_field32(&reg, TX_CNTL_CSR_ABORT_TX_AC3, 1);
-	rt2x00pci_register_write(rt2x00dev, TX_CNTL_CSR, reg);
+	rt2x00pci_register_write(rt2x00dev, MAC_CSR10, 0x00001818);
 }
 
 static int rt61pci_set_state(struct rt2x00_dev *rt2x00dev, enum dev_state state)
@@ -1936,6 +1922,24 @@ static void rt61pci_kick_tx_queue(struct rt2x00_dev *rt2x00dev,
 	rt2x00pci_register_write(rt2x00dev, TX_CNTL_CSR, reg);
 }
 
+static void rt61pci_kill_tx_queue(struct rt2x00_dev *rt2x00dev,
+				  const enum data_queue_qid qid)
+{
+	u32 reg;
+
+	if (qid == QID_BEACON) {
+		rt2x00pci_register_write(rt2x00dev, TXRX_CSR9, 0);
+		return;
+	}
+
+	rt2x00pci_register_read(rt2x00dev, TX_CNTL_CSR, &reg);
+	rt2x00_set_field32(&reg, TX_CNTL_CSR_ABORT_TX_AC0, (qid == QID_AC_BE));
+	rt2x00_set_field32(&reg, TX_CNTL_CSR_ABORT_TX_AC1, (qid == QID_AC_BK));
+	rt2x00_set_field32(&reg, TX_CNTL_CSR_ABORT_TX_AC2, (qid == QID_AC_VI));
+	rt2x00_set_field32(&reg, TX_CNTL_CSR_ABORT_TX_AC3, (qid == QID_AC_VO));
+	rt2x00pci_register_write(rt2x00dev, TX_CNTL_CSR, reg);
+}
+
 /*
  * RX control handlers
  */
@@ -2761,6 +2765,7 @@ static const struct rt2x00lib_ops rt61pci_rt2x00_ops = {
 	.write_tx_data		= rt2x00pci_write_tx_data,
 	.write_beacon		= rt61pci_write_beacon,
 	.kick_tx_queue		= rt61pci_kick_tx_queue,
+	.kill_tx_queue		= rt61pci_kill_tx_queue,
 	.fill_rxdone		= rt61pci_fill_rxdone,
 	.config_shared_key	= rt61pci_config_shared_key,
 	.config_pairwise_key	= rt61pci_config_pairwise_key,
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index f854551..24e97b3 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -2293,6 +2293,7 @@ static const struct rt2x00lib_ops rt73usb_rt2x00_ops = {
 	.write_beacon		= rt73usb_write_beacon,
 	.get_tx_data_len	= rt73usb_get_tx_data_len,
 	.kick_tx_queue		= rt73usb_kick_tx_queue,
+	.kill_tx_queue		= rt2x00usb_kill_tx_queue,
 	.fill_rxdone		= rt73usb_fill_rxdone,
 	.config_shared_key	= rt73usb_config_shared_key,
 	.config_pairwise_key	= rt73usb_config_pairwise_key,
-- 
1.5.6.1


