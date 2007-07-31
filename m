Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.173]:48192 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932810AbXGaSe2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Jul 2007 14:34:28 -0400
Received: by ug-out-1314.google.com with SMTP id j3so121179ugf
        for <linux-wireless@vger.kernel.org>; Tue, 31 Jul 2007 11:34:26 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 20/24] rt2x00: Periodically read statistics
Date: Tue, 31 Jul 2007 20:37:36 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200707312037.37041.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From ae4ebe1eadb9e5d8a4ea63aa6e2e260fb107eadf Mon Sep 17 00:00:00 2001
From: Ivo van Doorn <IvDoorn@gmail.com>
Date: Tue, 31 Jul 2007 14:09:45 +0200
Subject: [PATCH 20/24] rt2x00: Periodically read statistics

Split the link tuner up into 2 actions,
first reading of statistics. Where the CCA count
and the FCS error count can be read.
second part where the link tuner is handled.

This has 2 benefits, statistics are read on a single
location and we can use this location to determine the
signal quality later on.
And we can move the get_stats callback function into
rt2x00mac.c since no device specific things are inside.

For rt2400pci this also changes the link tuner,
previously it only degraded the sensitivity but now it uses
the same values as the other drivers to either increase
but also decrease the AGC VGC value.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2400pci.c |   71 +++++++++++++++----------------------
 drivers/net/wireless/rt2500pci.c |   45 +++++++++++-------------
 drivers/net/wireless/rt2500usb.c |   48 ++++++++++++-------------
 drivers/net/wireless/rt2500usb.h |   29 ++++++++++++---
 drivers/net/wireless/rt2x00.h    |    3 ++
 drivers/net/wireless/rt2x00dev.c |   12 ++++--
 drivers/net/wireless/rt2x00mac.c |   16 ++++++++
 drivers/net/wireless/rt61pci.c   |   47 +++++++++++--------------
 drivers/net/wireless/rt73usb.c   |   49 ++++++++++++--------------
 9 files changed, 165 insertions(+), 155 deletions(-)

diff --git a/drivers/net/wireless/rt2400pci.c b/drivers/net/wireless/rt2400pci.c
index 4ea2217..2c60c3e 100644
--- a/drivers/net/wireless/rt2400pci.c
+++ b/drivers/net/wireless/rt2400pci.c
@@ -624,6 +624,25 @@ static void rt2400pci_disable_led(struct rt2x00_dev *rt2x00dev)
 /*
  * Link tuning
  */
+static void rt2400pci_link_stats(struct rt2x00_dev *rt2x00dev)
+{
+	u32 reg;
+	u8 bbp;
+
+	/*
+	 * Update FCS error count from register.
+	 */
+	rt2x00pci_register_read(rt2x00dev, CNT0, &reg);
+	rt2x00dev->low_level_stats.dot11FCSErrorCount +=
+	    rt2x00_get_field32(reg, CNT0_FCS_ERROR);
+
+	/*
+	 * Update False CCA count from register.
+	 */
+	rt2400pci_bbp_read(rt2x00dev, 39, &bbp);
+	rt2x00dev->link.false_cca = bbp;
+}
+
 static void rt2400pci_reset_tuner(struct rt2x00_dev *rt2x00dev)
 {
 	rt2400pci_bbp_write(rt2x00dev, 13, 0x08);
@@ -632,7 +651,6 @@ static void rt2400pci_reset_tuner(struct rt2x00_dev *rt2x00dev)
 static void rt2400pci_link_tuner(struct rt2x00_dev *rt2x00dev)
 {
 	u8 reg;
-	char false_cca_delta;
 
 	/*
 	 * The link tuner should not run longer then 60 seconds,
@@ -642,28 +660,16 @@ static void rt2400pci_link_tuner(struct rt2x00_dev *rt2x00dev)
 		return;
 
 	/*
-	 * Read false CCA counter.
+	 * Base r13 link tuning on the false cca count.
 	 */
-	rt2400pci_bbp_read(rt2x00dev, 39, &reg);
+	rt2400pci_bbp_read(rt2x00dev, 13, &reg);
 
-	/*
-	 * Determine difference with previous CCA counter.
-	 */
-	false_cca_delta = reg - rt2x00dev->link.false_cca;
-	rt2x00dev->link.false_cca = reg;
-
-	/*
-	 * Check if the difference is higher than the
-	 * threshold and if so, tune the link.
-	 */
-	if (false_cca_delta >= 8) {
-		/*
-		 * Read and update RX AGC VGC.
-		 */
-		rt2400pci_bbp_read(rt2x00dev, 13, &reg);
-		reg += 2;
-		if (reg < 0x20)
-			rt2400pci_bbp_write(rt2x00dev, 13, reg);
+	if (rt2x00dev->link.false_cca > 512 && reg < 0x20) {
+		rt2400pci_bbp_write(rt2x00dev, 13, ++reg);
+		rt2x00dev->link.vgc_level = reg;
+	} else if (rt2x00dev->link.false_cca < 100 && reg > 0x08) {
+		rt2400pci_bbp_write(rt2x00dev, 13, --reg);
+		rt2x00dev->link.vgc_level = reg;
 	}
 }
 
@@ -1510,26 +1516,6 @@ static int rt2400pci_probe_hw(struct rt2x00_dev *rt2x00dev)
 /*
  * IEEE80211 stack callback functions.
  */
-static int rt2400pci_get_stats(struct ieee80211_hw *hw,
-			       struct ieee80211_low_level_stats *stats)
-{
-	struct rt2x00_dev *rt2x00dev = hw->priv;
-	u32 reg;
-
-	/*
-	 * Update FCS error count from register.
-	 * The dot11ACKFailureCount, dot11RTSFailureCount and
-	 * dot11RTSSuccessCount are updated in interrupt time.
-	 */
-	rt2x00pci_register_read(rt2x00dev, CNT0, &reg);
-	rt2x00dev->low_level_stats.dot11FCSErrorCount +=
-	    rt2x00_get_field32(reg, CNT0_FCS_ERROR);
-
-	memcpy(stats, &rt2x00dev->low_level_stats, sizeof(*stats));
-
-	return 0;
-}
-
 static int rt2400pci_set_retry_limit(struct ieee80211_hw *hw,
 				     u32 short_retry, u32 long_retry)
 {
@@ -1608,7 +1594,7 @@ static const struct ieee80211_ops rt2400pci_mac80211_ops = {
 	.config			= rt2x00mac_config,
 	.config_interface	= rt2x00mac_config_interface,
 	.set_multicast_list	= rt2x00mac_set_multicast_list,
-	.get_stats		= rt2400pci_get_stats,
+	.get_stats		= rt2x00mac_get_stats,
 	.set_retry_limit	= rt2400pci_set_retry_limit,
 	.conf_tx		= rt2400pci_conf_tx,
 	.get_tx_stats		= rt2x00mac_get_tx_stats,
@@ -1627,6 +1613,7 @@ static const struct rt2x00lib_ops rt2400pci_rt2x00_ops = {
 #ifdef CONFIG_RT2400PCI_RFKILL
 	.rfkill_poll		= rt2400pci_rfkill_poll,
 #endif /* CONFIG_RT2400PCI_RFKILL */
+	.link_stats		= rt2400pci_link_stats,
 	.reset_tuner		= rt2400pci_reset_tuner,
 	.link_tuner		= rt2400pci_link_tuner,
 	.write_tx_desc		= rt2400pci_write_tx_desc,
diff --git a/drivers/net/wireless/rt2500pci.c b/drivers/net/wireless/rt2500pci.c
index 6e9d3ad..7317c10 100644
--- a/drivers/net/wireless/rt2500pci.c
+++ b/drivers/net/wireless/rt2500pci.c
@@ -725,6 +725,24 @@ static void rt2500pci_disable_led(struct rt2x00_dev *rt2x00dev)
 /*
  * Link tuning
  */
+static void rt2500pci_link_stats(struct rt2x00_dev *rt2x00dev)
+{
+	u32 reg;
+
+	/*
+	 * Update FCS error count from register.
+	 */
+	rt2x00pci_register_read(rt2x00dev, CNT0, &reg);
+	rt2x00dev->low_level_stats.dot11FCSErrorCount +=
+	    rt2x00_get_field32(reg, CNT0_FCS_ERROR);
+
+	/*
+	 * Update False CCA count from register.
+	 */
+	rt2x00pci_register_read(rt2x00dev, CNT3, &reg);
+	rt2x00dev->link.false_cca = rt2x00_get_field32(reg, CNT3_FALSE_CCA);
+}
+
 static void rt2500pci_reset_tuner(struct rt2x00_dev *rt2x00dev)
 {
 	rt2500pci_bbp_write(rt2x00dev, 17, 0x48);
@@ -733,7 +751,6 @@ static void rt2500pci_reset_tuner(struct rt2x00_dev *rt2x00dev)
 static void rt2500pci_link_tuner(struct rt2x00_dev *rt2x00dev)
 {
 	int rssi = rt2x00_get_link_rssi(&rt2x00dev->link);
-	u32 reg;
 	u8 r17;
 
 	/*
@@ -800,9 +817,6 @@ dynamic_cca_tune:
 	 * R17 is inside the dynamic tuning range,
 	 * start tuning the link based on the false cca counter.
 	 */
-	rt2x00pci_register_read(rt2x00dev, CNT3, &reg);
-	rt2x00dev->link.false_cca = rt2x00_get_field32(reg, CNT3_FALSE_CCA);
-
 	if (rt2x00dev->link.false_cca > 512 && r17 < 0x40) {
 		rt2500pci_bbp_write(rt2x00dev, 17, ++r17);
 		rt2x00dev->link.vgc_level = r17;
@@ -1762,26 +1776,6 @@ static int rt2500pci_probe_hw(struct rt2x00_dev *rt2x00dev)
 /*
  * IEEE80211 stack callback functions.
  */
-static int rt2500pci_get_stats(struct ieee80211_hw *hw,
-			       struct ieee80211_low_level_stats *stats)
-{
-	struct rt2x00_dev *rt2x00dev = hw->priv;
-	u32 reg;
-
-	/*
-	 * Update FCS error count from register.
-	 * The dot11ACKFailureCount, dot11RTSFailureCount and
-	 * dot11RTSSuccessCount are updated in interrupt time.
-	 */
-	rt2x00pci_register_read(rt2x00dev, CNT0, &reg);
-	rt2x00dev->low_level_stats.dot11FCSErrorCount +=
-	    rt2x00_get_field32(reg, CNT0_FCS_ERROR);
-
-	memcpy(stats, &rt2x00dev->low_level_stats, sizeof(*stats));
-
-	return 0;
-}
-
 static int rt2500pci_set_retry_limit(struct ieee80211_hw *hw,
 				     u32 short_retry, u32 long_retry)
 {
@@ -1835,7 +1829,7 @@ static const struct ieee80211_ops rt2500pci_mac80211_ops = {
 	.config			= rt2x00mac_config,
 	.config_interface	= rt2x00mac_config_interface,
 	.set_multicast_list	= rt2x00mac_set_multicast_list,
-	.get_stats		= rt2500pci_get_stats,
+	.get_stats		= rt2x00mac_get_stats,
 	.set_retry_limit	= rt2500pci_set_retry_limit,
 	.conf_tx		= rt2x00mac_conf_tx,
 	.get_tx_stats		= rt2x00mac_get_tx_stats,
@@ -1854,6 +1848,7 @@ static const struct rt2x00lib_ops rt2500pci_rt2x00_ops = {
 #ifdef CONFIG_RT2500PCI_RFKILL
 	.rfkill_poll		= rt2500pci_rfkill_poll,
 #endif /* CONFIG_RT2500PCI_RFKILL */
+	.link_stats		= rt2500pci_link_stats,
 	.reset_tuner		= rt2500pci_reset_tuner,
 	.link_tuner		= rt2500pci_link_tuner,
 	.write_tx_desc		= rt2500pci_write_tx_desc,
diff --git a/drivers/net/wireless/rt2500usb.c b/drivers/net/wireless/rt2500usb.c
index 753ee36..a68650c 100644
--- a/drivers/net/wireless/rt2500usb.c
+++ b/drivers/net/wireless/rt2500usb.c
@@ -680,6 +680,25 @@ static void rt2500usb_disable_led(struct rt2x00_dev *rt2x00dev)
 /*
  * Link tuning
  */
+static void rt2500usb_link_stats(struct rt2x00_dev *rt2x00dev)
+{
+	u16 reg;
+
+	/*
+	 * Update FCS error count from register.
+	 */
+	rt2500usb_register_read(rt2x00dev, STA_CSR0, &reg);
+	rt2x00dev->low_level_stats.dot11FCSErrorCount +=
+	    rt2x00_get_field16(reg, STA_CSR0_FCS_ERROR);
+
+	/*
+	 * Update False CCA count from register.
+	 */
+	rt2500usb_register_read(rt2x00dev, STA_CSR3, &reg);
+	rt2x00dev->link.false_cca =
+	    rt2x00_get_field16(reg, STA_CSR3_FALSE_CCA_ERROR);
+}
+
 static void rt2500usb_reset_tuner(struct rt2x00_dev *rt2x00dev)
 {
 	u16 eeprom;
@@ -706,7 +725,6 @@ static void rt2500usb_link_tuner(struct rt2x00_dev *rt2x00dev)
 {
 	int rssi = rt2x00_get_link_rssi(&rt2x00dev->link);
 	u16 bbp_thresh;
-	u16 cca_alarm;
 	u16 vgc_bound;
 	u16 sens;
 	u16 r24;
@@ -784,7 +802,6 @@ static void rt2500usb_link_tuner(struct rt2x00_dev *rt2x00dev)
 	 * Leave short or middle distance condition, restore r17
 	 * to the dynamic tuning range.
 	 */
-	rt2500usb_register_read(rt2x00dev, STA_CSR3, &cca_alarm);
 	rt2x00_eeprom_read(rt2x00dev, EEPROM_BBPTUNE_VGC, &vgc_bound);
 	vgc_bound = rt2x00_get_field16(vgc_bound, EEPROM_BBPTUNE_VGCUPPER);
 
@@ -800,10 +817,10 @@ static void rt2500usb_link_tuner(struct rt2x00_dev *rt2x00dev)
 	if (r17 > up_bound) {
 		rt2500usb_bbp_write(rt2x00dev, 17, up_bound);
 		rt2x00dev->link.vgc_level = up_bound;
-	} else if (cca_alarm > 512 && r17 < up_bound) {
+	} else if (rt2x00dev->link.false_cca > 512 && r17 < up_bound) {
 		rt2500usb_bbp_write(rt2x00dev, 17, ++r17);
 		rt2x00dev->link.vgc_level = r17;
-	} else if (cca_alarm < 100 && r17 > low_bound) {
+	} else if (rt2x00dev->link.false_cca < 100 && r17 > low_bound) {
 		rt2500usb_bbp_write(rt2x00dev, 17, --r17);
 		rt2x00dev->link.vgc_level = r17;
 	}
@@ -1492,26 +1509,6 @@ static int rt2500usb_probe_hw(struct rt2x00_dev *rt2x00dev)
 /*
  * IEEE80211 stack callback functions.
  */
-static int rt2500usb_get_stats(struct ieee80211_hw *hw,
-			       struct ieee80211_low_level_stats *stats)
-{
-	struct rt2x00_dev *rt2x00dev = hw->priv;
-	u16 reg;
-
-	/*
-	 * Update FCS error count from register.
-	 * The dot11ACKFailureCount, dot11RTSFailureCount and
-	 * dot11RTSSuccessCount are updated in interrupt time.
-	 */
-	rt2500usb_register_read(rt2x00dev, STA_CSR0, &reg);
-	rt2x00dev->low_level_stats.dot11FCSErrorCount +=
-	    rt2x00_get_field16(reg, STA_CSR0_FCS_ERROR);
-
-	memcpy(stats, &rt2x00dev->low_level_stats, sizeof(*stats));
-
-	return 0;
-}
-
 static const struct ieee80211_ops rt2500usb_mac80211_ops = {
 	.tx			= rt2x00mac_tx,
 	.reset			= rt2x00mac_reset,
@@ -1520,7 +1517,7 @@ static const struct ieee80211_ops rt2500usb_mac80211_ops = {
 	.config			= rt2x00mac_config,
 	.config_interface	= rt2x00mac_config_interface,
 	.set_multicast_list	= rt2x00mac_set_multicast_list,
-	.get_stats		= rt2500usb_get_stats,
+	.get_stats		= rt2x00mac_get_stats,
 	.conf_tx		= rt2x00mac_conf_tx,
 	.get_tx_stats		= rt2x00mac_get_tx_stats,
 	.beacon_update		= rt2x00usb_beacon_update,
@@ -1531,6 +1528,7 @@ static const struct rt2x00lib_ops rt2500usb_rt2x00_ops = {
 	.initialize		= rt2x00usb_initialize,
 	.uninitialize		= rt2x00usb_uninitialize,
 	.set_device_state	= rt2500usb_set_device_state,
+	.link_stats		= rt2500usb_link_stats,
 	.reset_tuner		= rt2500usb_reset_tuner,
 	.link_tuner		= rt2500usb_link_tuner,
 	.write_tx_desc		= rt2500usb_write_tx_desc,
diff --git a/drivers/net/wireless/rt2500usb.h b/drivers/net/wireless/rt2500usb.h
index 9df67fb..f0eaead 100644
--- a/drivers/net/wireless/rt2500usb.h
+++ b/drivers/net/wireless/rt2500usb.h
@@ -474,18 +474,35 @@
 #define STA_CSR0_FCS_ERROR		FIELD16(0xffff)
 
 /*
- * Statistic Register.
- * STA_CSR1: PLCP error.
- * STA_CSR2: LONG error.
- * STA_CSR3: CCA false alarm.
- * STA_CSR4: RX FIFO overflow.
- * STA_CSR5: Beacon sent counter.
+ * STA_CSR1: PLCP error count.
  */
 #define STA_CSR1			0x04e2
+
+/*
+ * STA_CSR2: LONG error count.
+ */
 #define STA_CSR2			0x04e4
+
+/*
+ * STA_CSR3: CCA false alarm.
+ * FALSE_CCA_ERROR: False CCA error count, cleared when read.
+ */
 #define STA_CSR3			0x04e6
+#define STA_CSR3_FALSE_CCA_ERROR	FIELD16(0xffff)
+
+/*
+ * STA_CSR4: RX FIFO overflow.
+ */
 #define STA_CSR4			0x04e8
+
+/*
+ * STA_CSR5: Beacon sent counter.
+ */
 #define STA_CSR5			0x04ea
+
+/*
+ *  Statistics registers
+ */
 #define STA_CSR6			0x04ec
 #define STA_CSR7			0x04ee
 #define STA_CSR8			0x04f0
diff --git a/drivers/net/wireless/rt2x00.h b/drivers/net/wireless/rt2x00.h
index 9a52251..b7e2578 100644
--- a/drivers/net/wireless/rt2x00.h
+++ b/drivers/net/wireless/rt2x00.h
@@ -357,6 +357,7 @@ struct rt2x00lib_ops {
 	int (*set_device_state) (struct rt2x00_dev *rt2x00dev,
 				 enum dev_state state);
 	int (*rfkill_poll) (struct rt2x00_dev *rt2x00dev);
+	void (*link_stats) (struct rt2x00_dev *rt2x00dev);
 	void (*reset_tuner) (struct rt2x00_dev *rt2x00dev);
 	void (*link_tuner) (struct rt2x00_dev *rt2x00dev);
 
@@ -733,6 +734,8 @@ int rt2x00mac_config_interface(struct ieee80211_hw *hw, int if_id,
 			       struct ieee80211_if_conf *conf);
 void rt2x00mac_set_multicast_list(struct ieee80211_hw *hw,
 				  unsigned short flags, int mc_count);
+int rt2x00mac_get_stats(struct ieee80211_hw *hw,
+			struct ieee80211_low_level_stats *stats);
 int rt2x00mac_get_tx_stats(struct ieee80211_hw *hw,
 			   struct ieee80211_tx_queue_stats *stats);
 int rt2x00mac_conf_tx(struct ieee80211_hw *hw, int queue,
diff --git a/drivers/net/wireless/rt2x00dev.c b/drivers/net/wireless/rt2x00dev.c
index f0c00d7..42308ed 100644
--- a/drivers/net/wireless/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00dev.c
@@ -175,12 +175,16 @@ static void rt2x00lib_link_tuner(struct work_struct *work)
 	    container_of(work, struct rt2x00_dev, link.work.work);
 
 	/*
-	 * Check if the Link tuning has been disabled.
+	 * Update statistics.
 	 */
-	if (test_bit(CONFIG_DISABLE_LINK_TUNING, &rt2x00dev->flags))
-		return;
+	rt2x00dev->ops->lib->link_stats(rt2x00dev);
 
-	rt2x00dev->ops->lib->link_tuner(rt2x00dev);
+	/*
+	 * Only perform the link tuning when Link tuning
+	 * has been enabled (This could have been disabled from the EEPROM).
+	 */
+	if (!test_bit(CONFIG_DISABLE_LINK_TUNING, &rt2x00dev->flags))
+		rt2x00dev->ops->lib->link_tuner(rt2x00dev);
 
 	/*
 	 * Increase tuner counter, and reschedule the next link tuner run.
diff --git a/drivers/net/wireless/rt2x00mac.c b/drivers/net/wireless/rt2x00mac.c
index c36ac4a..9c6d043 100644
--- a/drivers/net/wireless/rt2x00mac.c
+++ b/drivers/net/wireless/rt2x00mac.c
@@ -350,6 +350,22 @@ void rt2x00mac_set_multicast_list(struct ieee80211_hw *hw,
 }
 EXPORT_SYMBOL_GPL(rt2x00mac_set_multicast_list);
 
+int rt2x00mac_get_stats(struct ieee80211_hw *hw,
+			struct ieee80211_low_level_stats *stats)
+{
+	struct rt2x00_dev *rt2x00dev = hw->priv;
+
+	/*
+	 * The dot11ACKFailureCount, dot11RTSFailureCount and
+	 * dot11RTSSuccessCount are updated in interrupt time.
+	 * dot11FCSErrorCount is updated in the link tuner.
+	 */
+	memcpy(stats, &rt2x00dev->low_level_stats, sizeof(*stats));
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(rt2x00mac_get_stats);
+
 int rt2x00mac_get_tx_stats(struct ieee80211_hw *hw,
 			   struct ieee80211_tx_queue_stats *stats)
 {
diff --git a/drivers/net/wireless/rt61pci.c b/drivers/net/wireless/rt61pci.c
index b280d7b..774f5de 100644
--- a/drivers/net/wireless/rt61pci.c
+++ b/drivers/net/wireless/rt61pci.c
@@ -937,6 +937,25 @@ static void rt61pci_activity_led(struct rt2x00_dev *rt2x00dev, int rssi)
 /*
  * Link tuning
  */
+static void rt61pci_link_stats(struct rt2x00_dev *rt2x00dev)
+{
+	u32 reg;
+
+	/*
+	 * Update FCS error count from register.
+	 */
+	rt2x00pci_register_read(rt2x00dev, STA_CSR0, &reg);
+	rt2x00dev->low_level_stats.dot11FCSErrorCount +=
+	    rt2x00_get_field32(reg, STA_CSR0_FCS_ERROR);
+
+	/*
+	 * Update False CCA count from register.
+	 */
+	rt2x00pci_register_read(rt2x00dev, STA_CSR1, &reg);
+	rt2x00dev->link.false_cca =
+	    rt2x00_get_field32(reg, STA_CSR1_FALSE_CCA_ERROR);
+}
+
 static void rt61pci_reset_tuner(struct rt2x00_dev *rt2x00dev)
 {
 	rt61pci_bbp_write(rt2x00dev, 17, 0x20);
@@ -945,7 +964,6 @@ static void rt61pci_reset_tuner(struct rt2x00_dev *rt2x00dev)
 static void rt61pci_link_tuner(struct rt2x00_dev *rt2x00dev)
 {
 	int rssi = rt2x00_get_link_rssi(&rt2x00dev->link);
-	u32 reg;
 	u8 r17;
 	u8 up_bound;
 	u8 low_bound;
@@ -1031,10 +1049,6 @@ static void rt61pci_link_tuner(struct rt2x00_dev *rt2x00dev)
 	 * r17 does not yet exceed upper limit, continue and base
 	 * the r17 tuning on the false CCA count.
 	 */
-	rt2x00pci_register_read(rt2x00dev, STA_CSR1, &reg);
-	rt2x00dev->link.false_cca =
-	    rt2x00_get_field32(reg, STA_CSR1_FALSE_CCA_ERROR);
-
 	if (rt2x00dev->link.false_cca > 512 && r17 < up_bound) {
 		if (++r17 > up_bound)
 			r17 = up_bound;
@@ -2287,26 +2301,6 @@ static int rt61pci_probe_hw(struct rt2x00_dev *rt2x00dev)
 /*
  * IEEE80211 stack callback functions.
  */
-static int rt61pci_get_stats(struct ieee80211_hw *hw,
-			     struct ieee80211_low_level_stats *stats)
-{
-	struct rt2x00_dev *rt2x00dev = hw->priv;
-	u32 reg;
-
-	/*
-	 * Update FCS error count from register.
-	 * The dot11ACKFailureCount, dot11RTSFailureCount and
-	 * dot11RTSSuccessCount are updated in interrupt time.
-	 */
-	rt2x00pci_register_read(rt2x00dev, STA_CSR0, &reg);
-	rt2x00dev->low_level_stats.dot11FCSErrorCount +=
-	    rt2x00_get_field32(reg, STA_CSR0_FCS_ERROR);
-
-	memcpy(stats, &rt2x00dev->low_level_stats, sizeof(*stats));
-
-	return 0;
-}
-
 static int rt61pci_set_retry_limit(struct ieee80211_hw *hw,
 				   u32 short_retry, u32 long_retry)
 {
@@ -2351,7 +2345,7 @@ static const struct ieee80211_ops rt61pci_mac80211_ops = {
 	.config			= rt2x00mac_config,
 	.config_interface	= rt2x00mac_config_interface,
 	.set_multicast_list	= rt2x00mac_set_multicast_list,
-	.get_stats		= rt61pci_get_stats,
+	.get_stats		= rt2x00mac_get_stats,
 	.set_retry_limit	= rt61pci_set_retry_limit,
 	.conf_tx		= rt2x00mac_conf_tx,
 	.get_tx_stats		= rt2x00mac_get_tx_stats,
@@ -2371,6 +2365,7 @@ static const struct rt2x00lib_ops rt61pci_rt2x00_ops = {
 #ifdef CONFIG_RT61PCI_RFKILL
 	.rfkill_poll		= rt61pci_rfkill_poll,
 #endif /* CONFIG_RT61PCI_RFKILL */
+	.link_stats		= rt61pci_link_stats,
 	.reset_tuner		= rt61pci_reset_tuner,
 	.link_tuner		= rt61pci_link_tuner,
 	.write_tx_desc		= rt61pci_write_tx_desc,
diff --git a/drivers/net/wireless/rt73usb.c b/drivers/net/wireless/rt73usb.c
index a076e28..28bc165 100644
--- a/drivers/net/wireless/rt73usb.c
+++ b/drivers/net/wireless/rt73usb.c
@@ -826,6 +826,26 @@ static void rt73usb_activity_led(struct rt2x00_dev *rt2x00dev, int rssi)
 /*
  * Link tuning
  */
+static void rt73usb_link_stats(struct rt2x00_dev *rt2x00dev)
+{
+	u32 reg;
+
+	/*
+	 * Update FCS error count from register.
+	 */
+	rt73usb_register_read(rt2x00dev, STA_CSR0, &reg);
+	rt2x00dev->low_level_stats.dot11FCSErrorCount +=
+	    rt2x00_get_field32(reg, STA_CSR0_FCS_ERROR);
+
+	/*
+	 * Update False CCA count from register.
+	 */
+	rt73usb_register_read(rt2x00dev, STA_CSR1, &reg);
+	reg = rt2x00_get_field32(reg, STA_CSR1_FALSE_CCA_ERROR);
+	rt2x00dev->link.false_cca =
+	    rt2x00_get_field32(reg, STA_CSR1_FALSE_CCA_ERROR);
+}
+
 static void rt73usb_reset_tuner(struct rt2x00_dev *rt2x00dev)
 {
 	rt73usb_bbp_write(rt2x00dev, 17, 0x20);
@@ -834,7 +854,6 @@ static void rt73usb_reset_tuner(struct rt2x00_dev *rt2x00dev)
 static void rt73usb_link_tuner(struct rt2x00_dev *rt2x00dev)
 {
 	int rssi = rt2x00_get_link_rssi(&rt2x00dev->link);
-	u32 reg;
 	u8 r17;
 	u8 up_bound;
 	u8 low_bound;
@@ -929,11 +948,6 @@ static void rt73usb_link_tuner(struct rt2x00_dev *rt2x00dev)
 	 * r17 does not yet exceed upper limit, continue and base
 	 * the r17 tuning on the false CCA count.
 	 */
-	rt73usb_register_read(rt2x00dev, STA_CSR1, &reg);
-	reg = rt2x00_get_field32(reg, STA_CSR1_FALSE_CCA_ERROR);
-	rt2x00dev->link.false_cca =
-	    rt2x00_get_field32(reg, STA_CSR1_FALSE_CCA_ERROR);
-
 	if (rt2x00dev->link.false_cca > 512 && r17 < up_bound) {
 		r17 += 4;
 		if (r17 > up_bound)
@@ -1752,26 +1766,6 @@ static int rt73usb_probe_hw(struct rt2x00_dev *rt2x00dev)
 /*
  * IEEE80211 stack callback functions.
  */
-static int rt73usb_get_stats(struct ieee80211_hw *hw,
-			     struct ieee80211_low_level_stats *stats)
-{
-	struct rt2x00_dev *rt2x00dev = hw->priv;
-	u32 reg;
-
-	/*
-	 * Update FCS error count from register.
-	 * The dot11ACKFailureCount, dot11RTSFailureCount and
-	 * dot11RTSSuccessCount are updated in interrupt time.
-	 */
-	rt73usb_register_read(rt2x00dev, STA_CSR0, &reg);
-	rt2x00dev->low_level_stats.dot11FCSErrorCount +=
-	    rt2x00_get_field32(reg, STA_CSR0_FCS_ERROR);
-
-	memcpy(stats, &rt2x00dev->low_level_stats, sizeof(*stats));
-
-	return 0;
-}
-
 static int rt73usb_set_retry_limit(struct ieee80211_hw *hw,
 				   u32 short_retry, u32 long_retry)
 {
@@ -1824,7 +1818,7 @@ static const struct ieee80211_ops rt73usb_mac80211_ops = {
 	.config			= rt2x00mac_config,
 	.config_interface	= rt2x00mac_config_interface,
 	.set_multicast_list	= rt2x00mac_set_multicast_list,
-	.get_stats		= rt73usb_get_stats,
+	.get_stats		= rt2x00mac_get_stats,
 	.set_retry_limit	= rt73usb_set_retry_limit,
 	.conf_tx		= rt2x00mac_conf_tx,
 	.get_tx_stats		= rt2x00mac_get_tx_stats,
@@ -1845,6 +1839,7 @@ static const struct rt2x00lib_ops rt73usb_rt2x00_ops = {
 	.initialize		= rt2x00usb_initialize,
 	.uninitialize		= rt2x00usb_uninitialize,
 	.set_device_state	= rt73usb_set_device_state,
+	.link_stats		= rt73usb_link_stats,
 	.reset_tuner		= rt73usb_reset_tuner,
 	.link_tuner		= rt73usb_link_tuner,
 	.write_tx_desc		= rt73usb_write_tx_desc,
-- 
1.5.2.4

