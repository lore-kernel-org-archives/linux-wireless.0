Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpb-ews03.kpnxchange.com ([213.75.39.6]:4099 "EHLO
	cpsmtpb-ews03.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753882Ab0EHVkd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 8 May 2010 17:40:33 -0400
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Ivo van Doorn <IvDoorn@gmail.com>,
	<linux-wireless@vger.kernel.org>, <users@rt2x00.serialmonkey.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>
Subject: [PATCH 7/9] rt2x00: Clean up all driver's kick_tx_queue callback functions.
Date: Sat,  8 May 2010 23:40:24 +0200
Message-Id: <1273354826-4335-8-git-send-email-gwingerde@gmail.com>
In-Reply-To: <1273354826-4335-1-git-send-email-gwingerde@gmail.com>
References: <1273354826-4335-1-git-send-email-gwingerde@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

All of the driver's kick_tx_queue callback functions treat the TX queue
for beacons in a special manner.
Clean this up by integrating the kicking of the beacon queue into the
write_beacon callback function, and let the generic code no longer call
the kick_tx_queue callback function when updating the beacon.

Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2400pci.c   |   19 ++++------
 drivers/net/wireless/rt2x00/rt2500pci.c   |   19 ++++------
 drivers/net/wireless/rt2x00/rt2500usb.c   |   55 +++++++++++-----------------
 drivers/net/wireless/rt2x00/rt2800pci.c   |   20 ++++------
 drivers/net/wireless/rt2x00/rt2800usb.c   |   29 +++++----------
 drivers/net/wireless/rt2x00/rt2x00queue.c |    5 +--
 drivers/net/wireless/rt2x00/rt61pci.c     |   30 +++++++---------
 drivers/net/wireless/rt2x00/rt73usb.c     |   40 +++++++-------------
 8 files changed, 83 insertions(+), 134 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2400pci.c b/drivers/net/wireless/rt2x00/rt2400pci.c
index 6f89891..9c13a4e 100644
--- a/drivers/net/wireless/rt2x00/rt2400pci.c
+++ b/drivers/net/wireless/rt2x00/rt2400pci.c
@@ -1089,6 +1089,14 @@ static void rt2400pci_write_beacon(struct queue_entry *entry)
 	rt2x00_desc_read(entry_priv->desc, 1, &word);
 	rt2x00_set_field32(&word, TXD_W1_BUFFER_ADDRESS, skbdesc->skb_dma);
 	rt2x00_desc_write(entry_priv->desc, 1, word);
+
+	/*
+	 * Enable beaconing again.
+	 */
+	rt2x00_set_field32(&reg, CSR14_TSF_COUNT, 1);
+	rt2x00_set_field32(&reg, CSR14_TBCN, 1);
+	rt2x00_set_field32(&reg, CSR14_BEACON_GEN, 1);
+	rt2x00pci_register_write(rt2x00dev, CSR14, reg);
 }
 
 static void rt2400pci_kick_tx_queue(struct rt2x00_dev *rt2x00dev,
@@ -1096,17 +1104,6 @@ static void rt2400pci_kick_tx_queue(struct rt2x00_dev *rt2x00dev,
 {
 	u32 reg;
 
-	if (queue == QID_BEACON) {
-		rt2x00pci_register_read(rt2x00dev, CSR14, &reg);
-		if (!rt2x00_get_field32(reg, CSR14_BEACON_GEN)) {
-			rt2x00_set_field32(&reg, CSR14_TSF_COUNT, 1);
-			rt2x00_set_field32(&reg, CSR14_TBCN, 1);
-			rt2x00_set_field32(&reg, CSR14_BEACON_GEN, 1);
-			rt2x00pci_register_write(rt2x00dev, CSR14, reg);
-		}
-		return;
-	}
-
 	rt2x00pci_register_read(rt2x00dev, TXCSR0, &reg);
 	rt2x00_set_field32(&reg, TXCSR0_KICK_PRIO, (queue == QID_AC_BE));
 	rt2x00_set_field32(&reg, TXCSR0_KICK_TX, (queue == QID_AC_BK));
diff --git a/drivers/net/wireless/rt2x00/rt2500pci.c b/drivers/net/wireless/rt2x00/rt2500pci.c
index d9b6304..84ab56e 100644
--- a/drivers/net/wireless/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/rt2x00/rt2500pci.c
@@ -1246,6 +1246,14 @@ static void rt2500pci_write_beacon(struct queue_entry *entry)
 	rt2x00_desc_read(entry_priv->desc, 1, &word);
 	rt2x00_set_field32(&word, TXD_W1_BUFFER_ADDRESS, skbdesc->skb_dma);
 	rt2x00_desc_write(entry_priv->desc, 1, word);
+
+	/*
+	 * Enable beaconing again.
+	 */
+	rt2x00_set_field32(&reg, CSR14_TSF_COUNT, 1);
+	rt2x00_set_field32(&reg, CSR14_TBCN, 1);
+	rt2x00_set_field32(&reg, CSR14_BEACON_GEN, 1);
+	rt2x00pci_register_write(rt2x00dev, CSR14, reg);
 }
 
 static void rt2500pci_kick_tx_queue(struct rt2x00_dev *rt2x00dev,
@@ -1253,17 +1261,6 @@ static void rt2500pci_kick_tx_queue(struct rt2x00_dev *rt2x00dev,
 {
 	u32 reg;
 
-	if (queue == QID_BEACON) {
-		rt2x00pci_register_read(rt2x00dev, CSR14, &reg);
-		if (!rt2x00_get_field32(reg, CSR14_BEACON_GEN)) {
-			rt2x00_set_field32(&reg, CSR14_TSF_COUNT, 1);
-			rt2x00_set_field32(&reg, CSR14_TBCN, 1);
-			rt2x00_set_field32(&reg, CSR14_BEACON_GEN, 1);
-			rt2x00pci_register_write(rt2x00dev, CSR14, reg);
-		}
-		return;
-	}
-
 	rt2x00pci_register_read(rt2x00dev, TXCSR0, &reg);
 	rt2x00_set_field32(&reg, TXCSR0_KICK_PRIO, (queue == QID_AC_BE));
 	rt2x00_set_field32(&reg, TXCSR0_KICK_TX, (queue == QID_AC_BK));
diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
index f90b308..5ee9b9f 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/rt2x00/rt2500usb.c
@@ -1090,7 +1090,7 @@ static void rt2500usb_write_beacon(struct queue_entry *entry)
 	struct skb_frame_desc *skbdesc = get_skb_frame_desc(entry->skb);
 	int pipe = usb_sndbulkpipe(usb_dev, entry->queue->usb_endpoint);
 	int length;
-	u16 reg;
+	u16 reg, reg0;
 
 	/*
 	 * Add the descriptor in front of the skb.
@@ -1132,6 +1132,26 @@ static void rt2500usb_write_beacon(struct queue_entry *entry)
 	 * Send out the guardian byte.
 	 */
 	usb_submit_urb(bcn_priv->guardian_urb, GFP_ATOMIC);
+
+	/*
+	 * Enable beaconing again.
+	 */
+	rt2x00_set_field16(&reg, TXRX_CSR19_TSF_COUNT, 1);
+	rt2x00_set_field16(&reg, TXRX_CSR19_TBCN, 1);
+	reg0 = reg;
+	rt2x00_set_field16(&reg, TXRX_CSR19_BEACON_GEN, 1);
+	/*
+	 * Beacon generation will fail initially.
+	 * To prevent this we need to change the TXRX_CSR19
+	 * register several times (reg0 is the same as reg
+	 * except for TXRX_CSR19_BEACON_GEN, which is 0 in reg0
+	 * and 1 in reg).
+	 */
+	rt2500usb_register_write(rt2x00dev, TXRX_CSR19, reg);
+	rt2500usb_register_write(rt2x00dev, TXRX_CSR19, reg0);
+	rt2500usb_register_write(rt2x00dev, TXRX_CSR19, reg);
+	rt2500usb_register_write(rt2x00dev, TXRX_CSR19, reg0);
+	rt2500usb_register_write(rt2x00dev, TXRX_CSR19, reg);
 }
 
 static int rt2500usb_get_tx_data_len(struct queue_entry *entry)
@@ -1148,37 +1168,6 @@ static int rt2500usb_get_tx_data_len(struct queue_entry *entry)
 	return length;
 }
 
-static void rt2500usb_kick_tx_queue(struct rt2x00_dev *rt2x00dev,
-				    const enum data_queue_qid queue)
-{
-	u16 reg, reg0;
-
-	if (queue != QID_BEACON) {
-		rt2x00usb_kick_tx_queue(rt2x00dev, queue);
-		return;
-	}
-
-	rt2500usb_register_read(rt2x00dev, TXRX_CSR19, &reg);
-	if (!rt2x00_get_field16(reg, TXRX_CSR19_BEACON_GEN)) {
-		rt2x00_set_field16(&reg, TXRX_CSR19_TSF_COUNT, 1);
-		rt2x00_set_field16(&reg, TXRX_CSR19_TBCN, 1);
-		reg0 = reg;
-		rt2x00_set_field16(&reg, TXRX_CSR19_BEACON_GEN, 1);
-		/*
-		 * Beacon generation will fail initially.
-		 * To prevent this we need to change the TXRX_CSR19
-		 * register several times (reg0 is the same as reg
-		 * except for TXRX_CSR19_BEACON_GEN, which is 0 in reg0
-		 * and 1 in reg).
-		 */
-		rt2500usb_register_write(rt2x00dev, TXRX_CSR19, reg);
-		rt2500usb_register_write(rt2x00dev, TXRX_CSR19, reg0);
-		rt2500usb_register_write(rt2x00dev, TXRX_CSR19, reg);
-		rt2500usb_register_write(rt2x00dev, TXRX_CSR19, reg0);
-		rt2500usb_register_write(rt2x00dev, TXRX_CSR19, reg);
-	}
-}
-
 /*
  * RX control handlers
  */
@@ -1777,7 +1766,7 @@ static const struct rt2x00lib_ops rt2500usb_rt2x00_ops = {
 	.write_tx_data		= rt2x00usb_write_tx_data,
 	.write_beacon		= rt2500usb_write_beacon,
 	.get_tx_data_len	= rt2500usb_get_tx_data_len,
-	.kick_tx_queue		= rt2500usb_kick_tx_queue,
+	.kick_tx_queue		= rt2x00usb_kick_tx_queue,
 	.kill_tx_queue		= rt2x00usb_kill_tx_queue,
 	.fill_rxdone		= rt2500usb_fill_rxdone,
 	.config_shared_key	= rt2500usb_config_key,
diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
index 308842a..6d56460 100644
--- a/drivers/net/wireless/rt2x00/rt2800pci.c
+++ b/drivers/net/wireless/rt2x00/rt2800pci.c
@@ -705,6 +705,14 @@ static void rt2800pci_write_beacon(struct queue_entry *entry)
 				      entry->skb->data, entry->skb->len);
 
 	/*
+	 * Enable beaconing again.
+	 */
+	rt2x00_set_field32(&reg, BCN_TIME_CFG_TSF_TICKING, 1);
+	rt2x00_set_field32(&reg, BCN_TIME_CFG_TBTT_ENABLE, 1);
+	rt2x00_set_field32(&reg, BCN_TIME_CFG_BEACON_GEN, 1);
+	rt2800_register_write(rt2x00dev, BCN_TIME_CFG, reg);
+
+	/*
 	 * Clean up beacon skb.
 	 */
 	dev_kfree_skb_any(entry->skb);
@@ -716,18 +724,6 @@ static void rt2800pci_kick_tx_queue(struct rt2x00_dev *rt2x00dev,
 {
 	struct data_queue *queue;
 	unsigned int idx, qidx = 0;
-	u32 reg;
-
-	if (queue_idx == QID_BEACON) {
-		rt2800_register_read(rt2x00dev, BCN_TIME_CFG, &reg);
-		if (!rt2x00_get_field32(reg, BCN_TIME_CFG_BEACON_GEN)) {
-			rt2x00_set_field32(&reg, BCN_TIME_CFG_TSF_TICKING, 1);
-			rt2x00_set_field32(&reg, BCN_TIME_CFG_TBTT_ENABLE, 1);
-			rt2x00_set_field32(&reg, BCN_TIME_CFG_BEACON_GEN, 1);
-			rt2800_register_write(rt2x00dev, BCN_TIME_CFG, reg);
-		}
-		return;
-	}
 
 	if (queue_idx > QID_HCCA && queue_idx != QID_MGMT)
 		return;
diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
index db37119..dbec718 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -459,6 +459,14 @@ static void rt2800usb_write_beacon(struct queue_entry *entry)
 					    REGISTER_TIMEOUT32(entry->skb->len));
 
 	/*
+	 * Enable beaconing again.
+	 */
+	rt2x00_set_field32(&reg, BCN_TIME_CFG_TSF_TICKING, 1);
+	rt2x00_set_field32(&reg, BCN_TIME_CFG_TBTT_ENABLE, 1);
+	rt2x00_set_field32(&reg, BCN_TIME_CFG_BEACON_GEN, 1);
+	rt2800_register_write(rt2x00dev, BCN_TIME_CFG, reg);
+
+	/*
 	 * Clean up the beacon skb.
 	 */
 	dev_kfree_skb(entry->skb);
@@ -480,25 +488,6 @@ static int rt2800usb_get_tx_data_len(struct queue_entry *entry)
 	return length;
 }
 
-static void rt2800usb_kick_tx_queue(struct rt2x00_dev *rt2x00dev,
-				    const enum data_queue_qid queue)
-{
-	u32 reg;
-
-	if (queue != QID_BEACON) {
-		rt2x00usb_kick_tx_queue(rt2x00dev, queue);
-		return;
-	}
-
-	rt2800_register_read(rt2x00dev, BCN_TIME_CFG, &reg);
-	if (!rt2x00_get_field32(reg, BCN_TIME_CFG_BEACON_GEN)) {
-		rt2x00_set_field32(&reg, BCN_TIME_CFG_TSF_TICKING, 1);
-		rt2x00_set_field32(&reg, BCN_TIME_CFG_TBTT_ENABLE, 1);
-		rt2x00_set_field32(&reg, BCN_TIME_CFG_BEACON_GEN, 1);
-		rt2800_register_write(rt2x00dev, BCN_TIME_CFG, reg);
-	}
-}
-
 /*
  * RX control handlers
  */
@@ -667,7 +656,7 @@ static const struct rt2x00lib_ops rt2800usb_rt2x00_ops = {
 	.write_tx_data		= rt2x00usb_write_tx_data,
 	.write_beacon		= rt2800usb_write_beacon,
 	.get_tx_data_len	= rt2800usb_get_tx_data_len,
-	.kick_tx_queue		= rt2800usb_kick_tx_queue,
+	.kick_tx_queue		= rt2x00usb_kick_tx_queue,
 	.kill_tx_queue		= rt2x00usb_kill_tx_queue,
 	.fill_rxdone		= rt2800usb_fill_rxdone,
 	.config_shared_key	= rt2800_config_shared_key,
diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.c b/drivers/net/wireless/rt2x00/rt2x00queue.c
index 8768c6f..7ab4fbb 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.c
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.c
@@ -606,12 +606,9 @@ int rt2x00queue_update_beacon(struct rt2x00_dev *rt2x00dev,
 	rt2x00queue_write_tx_descriptor(intf->beacon, &txdesc);
 
 	/*
-	 * Send beacon to hardware.
-	 * Also enable beacon generation, which might have been disabled
-	 * by the driver during the config_beacon() callback function.
+	 * Send beacon to hardware and enable beacon genaration..
 	 */
 	rt2x00dev->ops->lib->write_beacon(intf->beacon);
-	rt2x00dev->ops->lib->kick_tx_queue(rt2x00dev, QID_BEACON);
 
 	mutex_unlock(&intf->beacon_skb_mutex);
 
diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index 1b0c70d..9e3a1ee 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -1869,6 +1869,19 @@ static void rt61pci_write_beacon(struct queue_entry *entry)
 				      entry->skb->data, entry->skb->len);
 
 	/*
+	 * Enable beaconing again.
+	 *
+	 * For Wi-Fi faily generated beacons between participating
+	 * stations. Set TBTT phase adaptive adjustment step to 8us.
+	 */
+	rt2x00pci_register_write(rt2x00dev, TXRX_CSR10, 0x00001008);
+
+	rt2x00_set_field32(&reg, TXRX_CSR9_TSF_TICKING, 1);
+	rt2x00_set_field32(&reg, TXRX_CSR9_TBTT_ENABLE, 1);
+	rt2x00_set_field32(&reg, TXRX_CSR9_BEACON_GEN, 1);
+	rt2x00pci_register_write(rt2x00dev, TXRX_CSR9, reg);
+
+	/*
 	 * Clean up beacon skb.
 	 */
 	dev_kfree_skb_any(entry->skb);
@@ -1880,23 +1893,6 @@ static void rt61pci_kick_tx_queue(struct rt2x00_dev *rt2x00dev,
 {
 	u32 reg;
 
-	if (queue == QID_BEACON) {
-		/*
-		 * For Wi-Fi faily generated beacons between participating
-		 * stations. Set TBTT phase adaptive adjustment step to 8us.
-		 */
-		rt2x00pci_register_write(rt2x00dev, TXRX_CSR10, 0x00001008);
-
-		rt2x00pci_register_read(rt2x00dev, TXRX_CSR9, &reg);
-		if (!rt2x00_get_field32(reg, TXRX_CSR9_BEACON_GEN)) {
-			rt2x00_set_field32(&reg, TXRX_CSR9_TSF_TICKING, 1);
-			rt2x00_set_field32(&reg, TXRX_CSR9_TBTT_ENABLE, 1);
-			rt2x00_set_field32(&reg, TXRX_CSR9_BEACON_GEN, 1);
-			rt2x00pci_register_write(rt2x00dev, TXRX_CSR9, reg);
-		}
-		return;
-	}
-
 	rt2x00pci_register_read(rt2x00dev, TX_CNTL_CSR, &reg);
 	rt2x00_set_field32(&reg, TX_CNTL_CSR_KICK_TX_AC0, (queue == QID_AC_BE));
 	rt2x00_set_field32(&reg, TX_CNTL_CSR_KICK_TX_AC1, (queue == QID_AC_BK));
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index 6acba62..ca3707a 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -1536,6 +1536,19 @@ static void rt73usb_write_beacon(struct queue_entry *entry)
 					    REGISTER_TIMEOUT32(entry->skb->len));
 
 	/*
+	 * Enable beaconing again.
+	 *
+	 * For Wi-Fi faily generated beacons between participating stations.
+	 * Set TBTT phase adaptive adjustment step to 8us (default 16us)
+	 */
+	rt2x00usb_register_write(rt2x00dev, TXRX_CSR10, 0x00001008);
+
+	rt2x00_set_field32(&reg, TXRX_CSR9_TSF_TICKING, 1);
+	rt2x00_set_field32(&reg, TXRX_CSR9_TBTT_ENABLE, 1);
+	rt2x00_set_field32(&reg, TXRX_CSR9_BEACON_GEN, 1);
+	rt2x00usb_register_write(rt2x00dev, TXRX_CSR9, reg);
+
+	/*
 	 * Clean up the beacon skb.
 	 */
 	dev_kfree_skb(entry->skb);
@@ -1556,31 +1569,6 @@ static int rt73usb_get_tx_data_len(struct queue_entry *entry)
 	return length;
 }
 
-static void rt73usb_kick_tx_queue(struct rt2x00_dev *rt2x00dev,
-				  const enum data_queue_qid queue)
-{
-	u32 reg;
-
-	if (queue != QID_BEACON) {
-		rt2x00usb_kick_tx_queue(rt2x00dev, queue);
-		return;
-	}
-
-	/*
-	 * For Wi-Fi faily generated beacons between participating stations.
-	 * Set TBTT phase adaptive adjustment step to 8us (default 16us)
-	 */
-	rt2x00usb_register_write(rt2x00dev, TXRX_CSR10, 0x00001008);
-
-	rt2x00usb_register_read(rt2x00dev, TXRX_CSR9, &reg);
-	if (!rt2x00_get_field32(reg, TXRX_CSR9_BEACON_GEN)) {
-		rt2x00_set_field32(&reg, TXRX_CSR9_TSF_TICKING, 1);
-		rt2x00_set_field32(&reg, TXRX_CSR9_TBTT_ENABLE, 1);
-		rt2x00_set_field32(&reg, TXRX_CSR9_BEACON_GEN, 1);
-		rt2x00usb_register_write(rt2x00dev, TXRX_CSR9, reg);
-	}
-}
-
 /*
  * RX control handlers
  */
@@ -2261,7 +2249,7 @@ static const struct rt2x00lib_ops rt73usb_rt2x00_ops = {
 	.write_tx_data		= rt2x00usb_write_tx_data,
 	.write_beacon		= rt73usb_write_beacon,
 	.get_tx_data_len	= rt73usb_get_tx_data_len,
-	.kick_tx_queue		= rt73usb_kick_tx_queue,
+	.kick_tx_queue		= rt2x00usb_kick_tx_queue,
 	.kill_tx_queue		= rt2x00usb_kill_tx_queue,
 	.fill_rxdone		= rt73usb_fill_rxdone,
 	.config_shared_key	= rt73usb_config_shared_key,
-- 
1.7.1

