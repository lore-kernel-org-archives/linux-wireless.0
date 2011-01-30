Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:48218 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753338Ab1A3MYW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 30 Jan 2011 07:24:22 -0500
Received: by ewy5 with SMTP id 5so2118506ewy.19
        for <linux-wireless@vger.kernel.org>; Sun, 30 Jan 2011 04:24:20 -0800 (PST)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 01/21] rt2x00: Refactor beacon code to make use of start- and stop_queue
Date: Sun, 30 Jan 2011 13:16:03 +0100
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201101301316.04044.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Helmut Schaa <helmut.schaa@googlemail.com>

This patch allows to dynamically remove beaconing interfaces without
shutting beaconing down on all interfaces.

The only place to start and stop beaconing are now the start- and
stop_queue callbacks. Hence, we can remove some register writes during
interface bring up (config_intf) and only write the correct sync mode
to the register there.

When multiple beaconing interfaces are present we should enable
beaconing as soon as mac80211 enables beaconing on at least one of
them. The beacon queue gets stopped when the last beaconing
interface was stopped by mac80211. Therefore, introduce another
interface counter to keep track ot the number of enabled beaconing
interfaces and start or stop the beacon queue accordingly.

To allow single interfaces to stop beaconing, add a new driver
callback clear_beacon to clear a single interface's beacon without
affecting the other interfaces. Don't overload the clear_entry callback
for clearing beacons as that would introduce additional overhead
(check for each TX queue) into the clear_entry callback which is used
on the drivers TX/RX hotpaths.

Furthermore, the write beacon callback doesn't need to enable beaconing
anymore but since beaconing should be disabled while a new beacon is
written or cleared we still disable beacon generation and enable it
afterwards again in the driver specific callbacks. However, beacon
related interrupts should not be disabled/enabled here, that's solely
done from the start- and stop queue callbacks. It would be nice to stop
the beacon queue just before the beacon update and enable it afterwards
in rt2x00queue itself instead of the current implementation that relies
on the driver doing the right thing. However, since start- and
stop_queue are mutex protected we cannot use them for atomic beacon
updates.

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2400pci.c   |    4 --
 drivers/net/wireless/rt2x00/rt2500pci.c   |    4 --
 drivers/net/wireless/rt2x00/rt2500usb.c   |    2 -
 drivers/net/wireless/rt2x00/rt2800lib.c   |   67 ++++++++++++++++-------------
 drivers/net/wireless/rt2x00/rt2800lib.h   |    1 +
 drivers/net/wireless/rt2x00/rt2800pci.c   |    9 ++++
 drivers/net/wireless/rt2x00/rt2800usb.c   |    1 +
 drivers/net/wireless/rt2x00/rt2x00.h      |    4 ++
 drivers/net/wireless/rt2x00/rt2x00dev.c   |    4 +-
 drivers/net/wireless/rt2x00/rt2x00lib.h   |   12 ++++-
 drivers/net/wireless/rt2x00/rt2x00mac.c   |   41 ++++++++++++++++-
 drivers/net/wireless/rt2x00/rt2x00queue.c |   38 ++++++++++++----
 drivers/net/wireless/rt2x00/rt61pci.c     |   41 ++++++++++++------
 drivers/net/wireless/rt2x00/rt73usb.c     |   42 ++++++++++++------
 14 files changed, 185 insertions(+), 85 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2400pci.c b/drivers/net/wireless/rt2x00/rt2400pci.c
index 54ca49a..cb28e1b 100644
--- a/drivers/net/wireless/rt2x00/rt2400pci.c
+++ b/drivers/net/wireless/rt2x00/rt2400pci.c
@@ -305,9 +305,7 @@ static void rt2400pci_config_intf(struct rt2x00_dev *rt2x00dev,
 		 * Enable synchronisation.
 		 */
 		rt2x00pci_register_read(rt2x00dev, CSR14, &reg);
-		rt2x00_set_field32(&reg, CSR14_TSF_COUNT, 1);
 		rt2x00_set_field32(&reg, CSR14_TSF_SYNC, conf->sync);
-		rt2x00_set_field32(&reg, CSR14_TBCN, 1);
 		rt2x00pci_register_write(rt2x00dev, CSR14, reg);
 	}
 
@@ -1183,8 +1181,6 @@ static void rt2400pci_write_beacon(struct queue_entry *entry,
 	/*
 	 * Enable beaconing again.
 	 */
-	rt2x00_set_field32(&reg, CSR14_TSF_COUNT, 1);
-	rt2x00_set_field32(&reg, CSR14_TBCN, 1);
 	rt2x00_set_field32(&reg, CSR14_BEACON_GEN, 1);
 	rt2x00pci_register_write(rt2x00dev, CSR14, reg);
 }
diff --git a/drivers/net/wireless/rt2x00/rt2500pci.c b/drivers/net/wireless/rt2x00/rt2500pci.c
index a9ff26a..5225ae1 100644
--- a/drivers/net/wireless/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/rt2x00/rt2500pci.c
@@ -311,9 +311,7 @@ static void rt2500pci_config_intf(struct rt2x00_dev *rt2x00dev,
 		 * Enable synchronisation.
 		 */
 		rt2x00pci_register_read(rt2x00dev, CSR14, &reg);
-		rt2x00_set_field32(&reg, CSR14_TSF_COUNT, 1);
 		rt2x00_set_field32(&reg, CSR14_TSF_SYNC, conf->sync);
-		rt2x00_set_field32(&reg, CSR14_TBCN, 1);
 		rt2x00pci_register_write(rt2x00dev, CSR14, reg);
 	}
 
@@ -1337,8 +1335,6 @@ static void rt2500pci_write_beacon(struct queue_entry *entry,
 	/*
 	 * Enable beaconing again.
 	 */
-	rt2x00_set_field32(&reg, CSR14_TSF_COUNT, 1);
-	rt2x00_set_field32(&reg, CSR14_TBCN, 1);
 	rt2x00_set_field32(&reg, CSR14_BEACON_GEN, 1);
 	rt2x00pci_register_write(rt2x00dev, CSR14, reg);
 }
diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
index 6b3b1de4..157516e 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/rt2x00/rt2500usb.c
@@ -478,9 +478,7 @@ static void rt2500usb_config_intf(struct rt2x00_dev *rt2x00dev,
 		rt2500usb_register_write(rt2x00dev, TXRX_CSR18, reg);
 
 		rt2500usb_register_read(rt2x00dev, TXRX_CSR19, &reg);
-		rt2x00_set_field16(&reg, TXRX_CSR19_TSF_COUNT, 1);
 		rt2x00_set_field16(&reg, TXRX_CSR19_TSF_SYNC, conf->sync);
-		rt2x00_set_field16(&reg, TXRX_CSR19_TBCN, 1);
 		rt2500usb_register_write(rt2x00dev, TXRX_CSR19, reg);
 	}
 
diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index f8ba01c..4753fb1 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -818,8 +818,6 @@ void rt2800_write_beacon(struct queue_entry *entry, struct txentry_desc *txdesc)
 	/*
 	 * Enable beaconing again.
 	 */
-	rt2x00_set_field32(&reg, BCN_TIME_CFG_TSF_TICKING, 1);
-	rt2x00_set_field32(&reg, BCN_TIME_CFG_TBTT_ENABLE, 1);
 	rt2x00_set_field32(&reg, BCN_TIME_CFG_BEACON_GEN, 1);
 	rt2800_register_write(rt2x00dev, BCN_TIME_CFG, reg);
 
@@ -831,8 +829,8 @@ void rt2800_write_beacon(struct queue_entry *entry, struct txentry_desc *txdesc)
 }
 EXPORT_SYMBOL_GPL(rt2800_write_beacon);
 
-static inline void rt2800_clear_beacon(struct rt2x00_dev *rt2x00dev,
-				       unsigned int beacon_base)
+static inline void rt2800_clear_beacon_register(struct rt2x00_dev *rt2x00dev,
+						unsigned int beacon_base)
 {
 	int i;
 
@@ -845,6 +843,33 @@ static inline void rt2800_clear_beacon(struct rt2x00_dev *rt2x00dev,
 		rt2800_register_write(rt2x00dev, beacon_base + i, 0);
 }
 
+void rt2800_clear_beacon(struct queue_entry *entry)
+{
+	struct rt2x00_dev *rt2x00dev = entry->queue->rt2x00dev;
+	u32 reg;
+
+	/*
+	 * Disable beaconing while we are reloading the beacon data,
+	 * otherwise we might be sending out invalid data.
+	 */
+	rt2800_register_read(rt2x00dev, BCN_TIME_CFG, &reg);
+	rt2x00_set_field32(&reg, BCN_TIME_CFG_BEACON_GEN, 0);
+	rt2800_register_write(rt2x00dev, BCN_TIME_CFG, reg);
+
+	/*
+	 * Clear beacon.
+	 */
+	rt2800_clear_beacon_register(rt2x00dev,
+				     HW_BEACON_OFFSET(entry->entry_idx));
+
+	/*
+	 * Enabled beaconing again.
+	 */
+	rt2x00_set_field32(&reg, BCN_TIME_CFG_BEACON_GEN, 1);
+	rt2800_register_write(rt2x00dev, BCN_TIME_CFG, reg);
+}
+EXPORT_SYMBOL_GPL(rt2800_clear_beacon);
+
 #ifdef CONFIG_RT2X00_LIB_DEBUGFS
 const struct rt2x00debug rt2800_rt2x00debug = {
 	.owner	= THIS_MODULE,
@@ -1155,29 +1180,11 @@ void rt2800_config_intf(struct rt2x00_dev *rt2x00dev, struct rt2x00_intf *intf,
 
 	if (flags & CONFIG_UPDATE_TYPE) {
 		/*
-		 * Clear current synchronisation setup.
-		 */
-		rt2800_clear_beacon(rt2x00dev,
-				    HW_BEACON_OFFSET(intf->beacon->entry_idx));
-		/*
 		 * Enable synchronisation.
 		 */
 		rt2800_register_read(rt2x00dev, BCN_TIME_CFG, &reg);
-		rt2x00_set_field32(&reg, BCN_TIME_CFG_TSF_TICKING, 1);
 		rt2x00_set_field32(&reg, BCN_TIME_CFG_TSF_SYNC, conf->sync);
-		rt2x00_set_field32(&reg, BCN_TIME_CFG_TBTT_ENABLE,
-				   (conf->sync == TSF_SYNC_ADHOC ||
-				    conf->sync == TSF_SYNC_AP_NONE));
 		rt2800_register_write(rt2x00dev, BCN_TIME_CFG, reg);
-
-		/*
-		 * Enable pre tbtt interrupt for beaconing modes
-		 */
-		rt2800_register_read(rt2x00dev, INT_TIMER_EN, &reg);
-		rt2x00_set_field32(&reg, INT_TIMER_EN_PRE_TBTT_TIMER,
-				   (conf->sync == TSF_SYNC_AP_NONE));
-		rt2800_register_write(rt2x00dev, INT_TIMER_EN, reg);
-
 	}
 
 	if (flags & CONFIG_UPDATE_MAC) {
@@ -2187,14 +2194,14 @@ static int rt2800_init_registers(struct rt2x00_dev *rt2x00dev)
 	/*
 	 * Clear all beacons
 	 */
-	rt2800_clear_beacon(rt2x00dev, HW_BEACON_BASE0);
-	rt2800_clear_beacon(rt2x00dev, HW_BEACON_BASE1);
-	rt2800_clear_beacon(rt2x00dev, HW_BEACON_BASE2);
-	rt2800_clear_beacon(rt2x00dev, HW_BEACON_BASE3);
-	rt2800_clear_beacon(rt2x00dev, HW_BEACON_BASE4);
-	rt2800_clear_beacon(rt2x00dev, HW_BEACON_BASE5);
-	rt2800_clear_beacon(rt2x00dev, HW_BEACON_BASE6);
-	rt2800_clear_beacon(rt2x00dev, HW_BEACON_BASE7);
+	rt2800_clear_beacon_register(rt2x00dev, HW_BEACON_BASE0);
+	rt2800_clear_beacon_register(rt2x00dev, HW_BEACON_BASE1);
+	rt2800_clear_beacon_register(rt2x00dev, HW_BEACON_BASE2);
+	rt2800_clear_beacon_register(rt2x00dev, HW_BEACON_BASE3);
+	rt2800_clear_beacon_register(rt2x00dev, HW_BEACON_BASE4);
+	rt2800_clear_beacon_register(rt2x00dev, HW_BEACON_BASE5);
+	rt2800_clear_beacon_register(rt2x00dev, HW_BEACON_BASE6);
+	rt2800_clear_beacon_register(rt2x00dev, HW_BEACON_BASE7);
 
 	if (rt2x00_is_usb(rt2x00dev)) {
 		rt2800_register_read(rt2x00dev, US_CYC_CNT, &reg);
diff --git a/drivers/net/wireless/rt2x00/rt2800lib.h b/drivers/net/wireless/rt2x00/rt2800lib.h
index 3efafb7..0c92d86 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.h
+++ b/drivers/net/wireless/rt2x00/rt2800lib.h
@@ -156,6 +156,7 @@ void rt2800_txdone(struct rt2x00_dev *rt2x00dev);
 void rt2800_txdone_entry(struct queue_entry *entry, u32 status);
 
 void rt2800_write_beacon(struct queue_entry *entry, struct txentry_desc *txdesc);
+void rt2800_clear_beacon(struct queue_entry *entry);
 
 extern const struct rt2x00debug rt2800_rt2x00debug;
 
diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
index bfc2fc5..54e37e0 100644
--- a/drivers/net/wireless/rt2x00/rt2800pci.c
+++ b/drivers/net/wireless/rt2x00/rt2800pci.c
@@ -205,6 +205,10 @@ static void rt2800pci_start_queue(struct data_queue *queue)
 		rt2x00_set_field32(&reg, BCN_TIME_CFG_TBTT_ENABLE, 1);
 		rt2x00_set_field32(&reg, BCN_TIME_CFG_BEACON_GEN, 1);
 		rt2800_register_write(rt2x00dev, BCN_TIME_CFG, reg);
+
+		rt2800_register_read(rt2x00dev, INT_TIMER_EN, &reg);
+		rt2x00_set_field32(&reg, INT_TIMER_EN_PRE_TBTT_TIMER, 1);
+		rt2800_register_write(rt2x00dev, INT_TIMER_EN, reg);
 		break;
 	default:
 		break;
@@ -250,6 +254,10 @@ static void rt2800pci_stop_queue(struct data_queue *queue)
 		rt2x00_set_field32(&reg, BCN_TIME_CFG_TBTT_ENABLE, 0);
 		rt2x00_set_field32(&reg, BCN_TIME_CFG_BEACON_GEN, 0);
 		rt2800_register_write(rt2x00dev, BCN_TIME_CFG, reg);
+
+		rt2800_register_read(rt2x00dev, INT_TIMER_EN, &reg);
+		rt2x00_set_field32(&reg, INT_TIMER_EN_PRE_TBTT_TIMER, 0);
+		rt2800_register_write(rt2x00dev, INT_TIMER_EN, reg);
 		break;
 	default:
 		break;
@@ -974,6 +982,7 @@ static const struct rt2x00lib_ops rt2800pci_rt2x00_ops = {
 	.write_tx_desc		= rt2800pci_write_tx_desc,
 	.write_tx_data		= rt2800_write_tx_data,
 	.write_beacon		= rt2800_write_beacon,
+	.clear_beacon		= rt2800_clear_beacon,
 	.fill_rxdone		= rt2800pci_fill_rxdone,
 	.config_shared_key	= rt2800_config_shared_key,
 	.config_pairwise_key	= rt2800_config_pairwise_key,
diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
index b97a4a5..3ebe473 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -633,6 +633,7 @@ static const struct rt2x00lib_ops rt2800usb_rt2x00_ops = {
 	.write_tx_desc		= rt2800usb_write_tx_desc,
 	.write_tx_data		= rt2800usb_write_tx_data,
 	.write_beacon		= rt2800_write_beacon,
+	.clear_beacon		= rt2800_clear_beacon,
 	.get_tx_data_len	= rt2800usb_get_tx_data_len,
 	.fill_rxdone		= rt2800usb_fill_rxdone,
 	.config_shared_key	= rt2800_config_shared_key,
diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index 84aaf39..985982b 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -368,6 +368,7 @@ struct rt2x00_intf {
 	 * dedicated beacon entry.
 	 */
 	struct queue_entry *beacon;
+	bool enable_beacon;
 
 	/*
 	 * Actions that needed rescheduling.
@@ -573,6 +574,7 @@ struct rt2x00lib_ops {
 			       struct txentry_desc *txdesc);
 	void (*write_beacon) (struct queue_entry *entry,
 			      struct txentry_desc *txdesc);
+	void (*clear_beacon) (struct queue_entry *entry);
 	int (*get_tx_data_len) (struct queue_entry *entry);
 
 	/*
@@ -788,10 +790,12 @@ struct rt2x00_dev {
 	 *  - Open ap interface count.
 	 *  - Open sta interface count.
 	 *  - Association count.
+	 *  - Beaconing enabled count.
 	 */
 	unsigned int intf_ap_count;
 	unsigned int intf_sta_count;
 	unsigned int intf_associated;
+	unsigned int intf_beaconing;
 
 	/*
 	 * Link quality
diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index 31b7db0..2c65038 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -121,7 +121,7 @@ static void rt2x00lib_intf_scheduled_iter(void *data, u8 *mac,
 		return;
 
 	if (test_and_clear_bit(DELAYED_UPDATE_BEACON, &intf->delayed_flags))
-		rt2x00queue_update_beacon(rt2x00dev, vif, true);
+		rt2x00queue_update_beacon(rt2x00dev, vif);
 }
 
 static void rt2x00lib_intf_scheduled(struct work_struct *work)
@@ -174,7 +174,7 @@ static void rt2x00lib_beaconupdate_iter(void *data, u8 *mac,
 	    vif->type != NL80211_IFTYPE_WDS)
 		return;
 
-	rt2x00queue_update_beacon(rt2x00dev, vif, true);
+	rt2x00queue_update_beacon(rt2x00dev, vif);
 }
 
 void rt2x00lib_beacondone(struct rt2x00_dev *rt2x00dev)
diff --git a/drivers/net/wireless/rt2x00/rt2x00lib.h b/drivers/net/wireless/rt2x00/rt2x00lib.h
index a105c50..6c6a8f1 100644
--- a/drivers/net/wireless/rt2x00/rt2x00lib.h
+++ b/drivers/net/wireless/rt2x00/rt2x00lib.h
@@ -160,11 +160,17 @@ int rt2x00queue_write_tx_frame(struct data_queue *queue, struct sk_buff *skb,
  * rt2x00queue_update_beacon - Send new beacon from mac80211 to hardware
  * @rt2x00dev: Pointer to &struct rt2x00_dev.
  * @vif: Interface for which the beacon should be updated.
- * @enable_beacon: Enable beaconing
  */
 int rt2x00queue_update_beacon(struct rt2x00_dev *rt2x00dev,
-			      struct ieee80211_vif *vif,
-			      const bool enable_beacon);
+			      struct ieee80211_vif *vif);
+
+/**
+ * rt2x00queue_clear_beacon - Clear beacon in hardware
+ * @rt2x00dev: Pointer to &struct rt2x00_dev.
+ * @vif: Interface for which the beacon should be updated.
+ */
+int rt2x00queue_clear_beacon(struct rt2x00_dev *rt2x00dev,
+			     struct ieee80211_vif *vif);
 
 /**
  * rt2x00queue_index_inc - Index incrementation function
diff --git a/drivers/net/wireless/rt2x00/rt2x00mac.c b/drivers/net/wireless/rt2x00/rt2x00mac.c
index f3da051..7d33167 100644
--- a/drivers/net/wireless/rt2x00/rt2x00mac.c
+++ b/drivers/net/wireless/rt2x00/rt2x00mac.c
@@ -619,9 +619,44 @@ void rt2x00mac_bss_info_changed(struct ieee80211_hw *hw,
 	/*
 	 * Update the beacon.
 	 */
-	if (changes & (BSS_CHANGED_BEACON | BSS_CHANGED_BEACON_ENABLED))
-		rt2x00queue_update_beacon(rt2x00dev, vif,
-					  bss_conf->enable_beacon);
+	if (changes & BSS_CHANGED_BEACON)
+		rt2x00queue_update_beacon(rt2x00dev, vif);
+
+	/*
+	 * Start/stop beaconing.
+	 */
+	if (changes & BSS_CHANGED_BEACON_ENABLED) {
+		if (!bss_conf->enable_beacon && intf->enable_beacon) {
+			rt2x00queue_clear_beacon(rt2x00dev, vif);
+			rt2x00dev->intf_beaconing--;
+			intf->enable_beacon = false;
+
+			if (rt2x00dev->intf_beaconing == 0) {
+				/*
+				 * Last beaconing interface disabled
+				 * -> stop beacon queue.
+				 */
+				mutex_lock(&intf->beacon_skb_mutex);
+				rt2x00queue_stop_queue(rt2x00dev->bcn);
+				mutex_unlock(&intf->beacon_skb_mutex);
+			}
+
+
+		} else if (bss_conf->enable_beacon && !intf->enable_beacon) {
+			rt2x00dev->intf_beaconing++;
+			intf->enable_beacon = true;
+
+			if (rt2x00dev->intf_beaconing == 1) {
+				/*
+				 * First beaconing interface enabled
+				 * -> start beacon queue.
+				 */
+				mutex_lock(&intf->beacon_skb_mutex);
+				rt2x00queue_start_queue(rt2x00dev->bcn);
+				mutex_unlock(&intf->beacon_skb_mutex);
+			}
+		}
+	}
 
 	/*
 	 * When the association status has changed we must reset the link
diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.c b/drivers/net/wireless/rt2x00/rt2x00queue.c
index ca82b3a..24bcdb4 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.c
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.c
@@ -566,9 +566,35 @@ int rt2x00queue_write_tx_frame(struct data_queue *queue, struct sk_buff *skb,
 	return 0;
 }
 
+int rt2x00queue_clear_beacon(struct rt2x00_dev *rt2x00dev,
+			     struct ieee80211_vif *vif)
+{
+	struct rt2x00_intf *intf = vif_to_intf(vif);
+
+	if (unlikely(!intf->beacon))
+		return -ENOBUFS;
+
+	mutex_lock(&intf->beacon_skb_mutex);
+
+	/*
+	 * Clean up the beacon skb.
+	 */
+	rt2x00queue_free_skb(intf->beacon);
+
+	/*
+	 * Clear beacon (single bssid devices don't need to clear the beacon
+	 * since the beacon queue will get stopped anyway).
+	 */
+	if (rt2x00dev->ops->lib->clear_beacon)
+		rt2x00dev->ops->lib->clear_beacon(intf->beacon);
+
+	mutex_unlock(&intf->beacon_skb_mutex);
+
+	return 0;
+}
+
 int rt2x00queue_update_beacon(struct rt2x00_dev *rt2x00dev,
-			      struct ieee80211_vif *vif,
-			      const bool enable_beacon)
+			      struct ieee80211_vif *vif)
 {
 	struct rt2x00_intf *intf = vif_to_intf(vif);
 	struct skb_frame_desc *skbdesc;
@@ -584,12 +610,6 @@ int rt2x00queue_update_beacon(struct rt2x00_dev *rt2x00dev,
 	 */
 	rt2x00queue_free_skb(intf->beacon);
 
-	if (!enable_beacon) {
-		rt2x00queue_stop_queue(intf->beacon->queue);
-		mutex_unlock(&intf->beacon_skb_mutex);
-		return 0;
-	}
-
 	intf->beacon->skb = ieee80211_beacon_get(rt2x00dev->hw, vif);
 	if (!intf->beacon->skb) {
 		mutex_unlock(&intf->beacon_skb_mutex);
@@ -611,7 +631,7 @@ int rt2x00queue_update_beacon(struct rt2x00_dev *rt2x00dev,
 	skbdesc->entry = intf->beacon;
 
 	/*
-	 * Send beacon to hardware and enable beacon genaration..
+	 * Send beacon to hardware.
 	 */
 	rt2x00dev->ops->lib->write_beacon(intf->beacon, &txdesc);
 
diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index 8de44dd..f14cc45 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -551,26 +551,14 @@ static void rt61pci_config_intf(struct rt2x00_dev *rt2x00dev,
 				struct rt2x00intf_conf *conf,
 				const unsigned int flags)
 {
-	unsigned int beacon_base;
 	u32 reg;
 
 	if (flags & CONFIG_UPDATE_TYPE) {
 		/*
-		 * Clear current synchronisation setup.
-		 * For the Beacon base registers, we only need to clear
-		 * the first byte since that byte contains the VALID and OWNER
-		 * bits which (when set to 0) will invalidate the entire beacon.
-		 */
-		beacon_base = HW_BEACON_OFFSET(intf->beacon->entry_idx);
-		rt2x00pci_register_write(rt2x00dev, beacon_base, 0);
-
-		/*
 		 * Enable synchronisation.
 		 */
 		rt2x00pci_register_read(rt2x00dev, TXRX_CSR9, &reg);
-		rt2x00_set_field32(&reg, TXRX_CSR9_TSF_TICKING, 1);
 		rt2x00_set_field32(&reg, TXRX_CSR9_TSF_SYNC, conf->sync);
-		rt2x00_set_field32(&reg, TXRX_CSR9_TBTT_ENABLE, 1);
 		rt2x00pci_register_write(rt2x00dev, TXRX_CSR9, reg);
 	}
 
@@ -2002,8 +1990,6 @@ static void rt61pci_write_beacon(struct queue_entry *entry,
 	 */
 	rt2x00pci_register_write(rt2x00dev, TXRX_CSR10, 0x00001008);
 
-	rt2x00_set_field32(&reg, TXRX_CSR9_TSF_TICKING, 1);
-	rt2x00_set_field32(&reg, TXRX_CSR9_TBTT_ENABLE, 1);
 	rt2x00_set_field32(&reg, TXRX_CSR9_BEACON_GEN, 1);
 	rt2x00pci_register_write(rt2x00dev, TXRX_CSR9, reg);
 
@@ -2014,6 +2000,32 @@ static void rt61pci_write_beacon(struct queue_entry *entry,
 	entry->skb = NULL;
 }
 
+static void rt61pci_clear_beacon(struct queue_entry *entry)
+{
+	struct rt2x00_dev *rt2x00dev = entry->queue->rt2x00dev;
+	u32 reg;
+
+	/*
+	 * Disable beaconing while we are reloading the beacon data,
+	 * otherwise we might be sending out invalid data.
+	 */
+	rt2x00pci_register_read(rt2x00dev, TXRX_CSR9, &reg);
+	rt2x00_set_field32(&reg, TXRX_CSR9_BEACON_GEN, 0);
+	rt2x00pci_register_write(rt2x00dev, TXRX_CSR9, reg);
+
+	/*
+	 * Clear beacon.
+	 */
+	rt2x00pci_register_write(rt2x00dev,
+				 HW_BEACON_OFFSET(entry->entry_idx), 0);
+
+	/*
+	 * Enable beaconing again.
+	 */
+	rt2x00_set_field32(&reg, TXRX_CSR9_BEACON_GEN, 1);
+	rt2x00pci_register_write(rt2x00dev, TXRX_CSR9, reg);
+}
+
 /*
  * RX control handlers
  */
@@ -2903,6 +2915,7 @@ static const struct rt2x00lib_ops rt61pci_rt2x00_ops = {
 	.stop_queue		= rt61pci_stop_queue,
 	.write_tx_desc		= rt61pci_write_tx_desc,
 	.write_beacon		= rt61pci_write_beacon,
+	.clear_beacon		= rt61pci_clear_beacon,
 	.fill_rxdone		= rt61pci_fill_rxdone,
 	.config_shared_key	= rt61pci_config_shared_key,
 	.config_pairwise_key	= rt61pci_config_pairwise_key,
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index 029be3c..330353e 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -502,26 +502,14 @@ static void rt73usb_config_intf(struct rt2x00_dev *rt2x00dev,
 				struct rt2x00intf_conf *conf,
 				const unsigned int flags)
 {
-	unsigned int beacon_base;
 	u32 reg;
 
 	if (flags & CONFIG_UPDATE_TYPE) {
 		/*
-		 * Clear current synchronisation setup.
-		 * For the Beacon base registers we only need to clear
-		 * the first byte since that byte contains the VALID and OWNER
-		 * bits which (when set to 0) will invalidate the entire beacon.
-		 */
-		beacon_base = HW_BEACON_OFFSET(intf->beacon->entry_idx);
-		rt2x00usb_register_write(rt2x00dev, beacon_base, 0);
-
-		/*
 		 * Enable synchronisation.
 		 */
 		rt2x00usb_register_read(rt2x00dev, TXRX_CSR9, &reg);
-		rt2x00_set_field32(&reg, TXRX_CSR9_TSF_TICKING, 1);
 		rt2x00_set_field32(&reg, TXRX_CSR9_TSF_SYNC, conf->sync);
-		rt2x00_set_field32(&reg, TXRX_CSR9_TBTT_ENABLE, 1);
 		rt2x00usb_register_write(rt2x00dev, TXRX_CSR9, reg);
 	}
 
@@ -1590,8 +1578,6 @@ static void rt73usb_write_beacon(struct queue_entry *entry,
 	 */
 	rt2x00usb_register_write(rt2x00dev, TXRX_CSR10, 0x00001008);
 
-	rt2x00_set_field32(&reg, TXRX_CSR9_TSF_TICKING, 1);
-	rt2x00_set_field32(&reg, TXRX_CSR9_TBTT_ENABLE, 1);
 	rt2x00_set_field32(&reg, TXRX_CSR9_BEACON_GEN, 1);
 	rt2x00usb_register_write(rt2x00dev, TXRX_CSR9, reg);
 
@@ -1602,6 +1588,33 @@ static void rt73usb_write_beacon(struct queue_entry *entry,
 	entry->skb = NULL;
 }
 
+static void rt73usb_clear_beacon(struct queue_entry *entry)
+{
+	struct rt2x00_dev *rt2x00dev = entry->queue->rt2x00dev;
+	unsigned int beacon_base;
+	u32 reg;
+
+	/*
+	 * Disable beaconing while we are reloading the beacon data,
+	 * otherwise we might be sending out invalid data.
+	 */
+	rt2x00usb_register_read(rt2x00dev, TXRX_CSR9, &reg);
+	rt2x00_set_field32(&reg, TXRX_CSR9_BEACON_GEN, 0);
+	rt2x00usb_register_write(rt2x00dev, TXRX_CSR9, reg);
+
+	/*
+	 * Clear beacon.
+	 */
+	beacon_base = HW_BEACON_OFFSET(entry->entry_idx);
+	rt2x00usb_register_write(rt2x00dev, beacon_base, 0);
+
+	/*
+	 * Enable beaconing again.
+	 */
+	rt2x00_set_field32(&reg, TXRX_CSR9_BEACON_GEN, 1);
+	rt2x00usb_register_write(rt2x00dev, TXRX_CSR9, reg);
+}
+
 static int rt73usb_get_tx_data_len(struct queue_entry *entry)
 {
 	int length;
@@ -2313,6 +2326,7 @@ static const struct rt2x00lib_ops rt73usb_rt2x00_ops = {
 	.flush_queue		= rt2x00usb_flush_queue,
 	.write_tx_desc		= rt73usb_write_tx_desc,
 	.write_beacon		= rt73usb_write_beacon,
+	.clear_beacon		= rt73usb_clear_beacon,
 	.get_tx_data_len	= rt73usb_get_tx_data_len,
 	.fill_rxdone		= rt73usb_fill_rxdone,
 	.config_shared_key	= rt73usb_config_shared_key,
-- 
1.7.2.3

