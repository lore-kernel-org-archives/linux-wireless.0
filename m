Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.173]:48192 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933461AbXGaSec convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Jul 2007 14:34:32 -0400
Received: by ug-out-1314.google.com with SMTP id j3so121179ugf
        for <linux-wireless@vger.kernel.org>; Tue, 31 Jul 2007 11:34:31 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 23/24] rt2x00: Add Signal reporting
Date: Tue, 31 Jul 2007 20:37:42 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200707312037.42319.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From d758fee7beeab36775c33c111228d68035653796 Mon Sep 17 00:00:00 2001
From: Ivo van Doorn <IvDoorn@gmail.com>
Date: Tue, 31 Jul 2007 19:59:20 +0200
Subject: [PATCH 23/24] rt2x00: Add Signal reporting

This will add Signal reporting to rt2x00.
The calculation is based on the legacy drivers ChannelQuality
value which was used for Roaming support but itself was
never exported to userspace.

Some minor modifications were made against the legacy driver version,
so is the weight of the RSSI reduced and the weight of TX increased.
Some minor optimizations to the calculation have also been made.

The signal value is build up as follows:
 20% avg_rssi (Converted into a percentage against the maximum value)
 40% TX success percentage
 40% RX success percentage

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2400pci.c |   15 +++++----
 drivers/net/wireless/rt2400pci.h |    1 +
 drivers/net/wireless/rt2500pci.c |   15 +++++----
 drivers/net/wireless/rt2500pci.h |    1 +
 drivers/net/wireless/rt2500usb.c |   15 +++++----
 drivers/net/wireless/rt2500usb.h |    1 +
 drivers/net/wireless/rt2x00.h    |   38 ++++++++++++++++++-----
 drivers/net/wireless/rt2x00dev.c |   62 ++++++++++++++++++++++++++++++++++++-
 drivers/net/wireless/rt61pci.c   |   15 +++++----
 drivers/net/wireless/rt61pci.h   |    1 +
 drivers/net/wireless/rt73usb.c   |   15 +++++----
 drivers/net/wireless/rt73usb.h   |    1 +
 12 files changed, 135 insertions(+), 45 deletions(-)

diff --git a/drivers/net/wireless/rt2400pci.c b/drivers/net/wireless/rt2400pci.c
index 2c60c3e..757d749 100644
--- a/drivers/net/wireless/rt2400pci.c
+++ b/drivers/net/wireless/rt2400pci.c
@@ -626,6 +626,7 @@ static void rt2400pci_disable_led(struct rt2x00_dev *rt2x00dev)
  */
 static void rt2400pci_link_stats(struct rt2x00_dev *rt2x00dev)
 {
+	int fcs;
 	u32 reg;
 	u8 bbp;
 
@@ -633,8 +634,9 @@ static void rt2400pci_link_stats(struct rt2x00_dev *rt2x00dev)
 	 * Update FCS error count from register.
 	 */
 	rt2x00pci_register_read(rt2x00dev, CNT0, &reg);
-	rt2x00dev->low_level_stats.dot11FCSErrorCount +=
-	    rt2x00_get_field32(reg, CNT0_FCS_ERROR);
+	fcs = rt2x00_get_field32(reg, CNT0_FCS_ERROR);
+	rt2x00dev->link.rx_failed += fcs;
+	rt2x00dev->low_level_stats.dot11FCSErrorCount += fcs;
 
 	/*
 	 * Update False CCA count from register.
@@ -1203,13 +1205,11 @@ static int rt2400pci_fill_rxdone(struct data_entry *entry,
 	rt2x00_desc_read(rxd, 0, &word0);
 	rt2x00_desc_read(rxd, 2, &word2);
 
-	/*
-	 * TODO: Don't we need to keep statistics
-	 * updated about these errors?
-	 */
 	if (rt2x00_get_field32(word0, RXD_W0_CRC_ERROR) ||
-	    rt2x00_get_field32(word0, RXD_W0_PHYSICAL_ERROR))
+	    rt2x00_get_field32(word0, RXD_W0_PHYSICAL_ERROR)) {
+		entry->ring->rt2x00dev->link.rx_failed++;
 		return -EINVAL;
+	}
 
 	/*
 	 * Obtain the status about this packet.
@@ -1452,6 +1452,7 @@ static void rt2400pci_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 	    IEEE80211_HW_MONITOR_DURING_OPER |
 	    IEEE80211_HW_NO_PROBE_FILTERING;
 	rt2x00dev->hw->extra_tx_headroom = 0;
+	rt2x00dev->hw->max_signal = MAX_SIGNAL;
 	rt2x00dev->hw->max_rssi = MAX_RX_SSI;
 	rt2x00dev->hw->queues = 2;
 
diff --git a/drivers/net/wireless/rt2400pci.h b/drivers/net/wireless/rt2400pci.h
index 4796e8b..ae22501 100644
--- a/drivers/net/wireless/rt2400pci.h
+++ b/drivers/net/wireless/rt2400pci.h
@@ -37,6 +37,7 @@
  * Signal information.
  * Defaul offset is required for RSSI <-> dBm conversion.
  */
+#define MAX_SIGNAL			100
 #define MAX_RX_SSI			-1
 #define DEFAULT_RSSI_OFFSET		100
 
diff --git a/drivers/net/wireless/rt2500pci.c b/drivers/net/wireless/rt2500pci.c
index 7317c10..dd98aa4 100644
--- a/drivers/net/wireless/rt2500pci.c
+++ b/drivers/net/wireless/rt2500pci.c
@@ -727,14 +727,16 @@ static void rt2500pci_disable_led(struct rt2x00_dev *rt2x00dev)
  */
 static void rt2500pci_link_stats(struct rt2x00_dev *rt2x00dev)
 {
+	int fcs;
 	u32 reg;
 
 	/*
 	 * Update FCS error count from register.
 	 */
 	rt2x00pci_register_read(rt2x00dev, CNT0, &reg);
-	rt2x00dev->low_level_stats.dot11FCSErrorCount +=
-	    rt2x00_get_field32(reg, CNT0_FCS_ERROR);
+	fcs = rt2x00_get_field32(reg, CNT0_FCS_ERROR);
+	rt2x00dev->link.rx_failed += fcs;
+	rt2x00dev->low_level_stats.dot11FCSErrorCount += fcs;
 
 	/*
 	 * Update False CCA count from register.
@@ -1381,14 +1383,12 @@ static int rt2500pci_fill_rxdone(struct data_entry *entry,
 	rt2x00_desc_read(rxd, 0, &word0);
 	rt2x00_desc_read(rxd, 2, &word2);
 
-	/*
-	 * TODO: Don't we need to keep statistics
-	 * updated about these errors?
-	 */
 	if (rt2x00_get_field32(word0, RXD_W0_CRC_ERROR) ||
 	    rt2x00_get_field32(word0, RXD_W0_PHYSICAL_ERROR) ||
-	    rt2x00_get_field32(word0, RXD_W0_ICV_ERROR))
+	    rt2x00_get_field32(word0, RXD_W0_ICV_ERROR)) {
+		entry->ring->rt2x00dev->link.rx_failed++;
 		return -EINVAL;
+	}
 
 	*signal = rt2x00_get_field32(word2, RXD_W2_SIGNAL);
 	*rssi = rt2x00_get_field32(word2, RXD_W2_RSSI) -
@@ -1697,6 +1697,7 @@ static void rt2500pci_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 	    IEEE80211_HW_MONITOR_DURING_OPER |
 	    IEEE80211_HW_NO_PROBE_FILTERING;
 	rt2x00dev->hw->extra_tx_headroom = 0;
+	rt2x00dev->hw->max_signal = MAX_SIGNAL;
 	rt2x00dev->hw->max_rssi = MAX_RX_SSI;
 	rt2x00dev->hw->queues = 2;
 
diff --git a/drivers/net/wireless/rt2500pci.h b/drivers/net/wireless/rt2500pci.h
index d95a4e8..5db6cde 100644
--- a/drivers/net/wireless/rt2500pci.h
+++ b/drivers/net/wireless/rt2500pci.h
@@ -48,6 +48,7 @@
  * Signal information.
  * Defaul offset is required for RSSI <-> dBm conversion.
  */
+#define MAX_SIGNAL			100
 #define MAX_RX_SSI			-1
 #define DEFAULT_RSSI_OFFSET		121
 
diff --git a/drivers/net/wireless/rt2500usb.c b/drivers/net/wireless/rt2500usb.c
index a68650c..e09fb9f 100644
--- a/drivers/net/wireless/rt2500usb.c
+++ b/drivers/net/wireless/rt2500usb.c
@@ -682,14 +682,16 @@ static void rt2500usb_disable_led(struct rt2x00_dev *rt2x00dev)
  */
 static void rt2500usb_link_stats(struct rt2x00_dev *rt2x00dev)
 {
+	int fcs;
 	u16 reg;
 
 	/*
 	 * Update FCS error count from register.
 	 */
 	rt2500usb_register_read(rt2x00dev, STA_CSR0, &reg);
-	rt2x00dev->low_level_stats.dot11FCSErrorCount +=
-	    rt2x00_get_field16(reg, STA_CSR0_FCS_ERROR);
+	fcs = rt2x00_get_field16(reg, STA_CSR0_FCS_ERROR);
+	rt2x00dev->link.rx_failed += fcs;
+	rt2x00dev->low_level_stats.dot11FCSErrorCount += fcs;
 
 	/*
 	 * Update False CCA count from register.
@@ -1181,14 +1183,12 @@ static int rt2500usb_fill_rxdone(struct data_entry *entry,
 	rt2x00_desc_read(rxd, 0, &word0);
 	rt2x00_desc_read(rxd, 1, &word1);
 
-	/*
-	 * TODO: Don't we need to keep statistics
-	 * updated about these errors?
-	 */
 	if (rt2x00_get_field32(word0, RXD_W0_CRC_ERROR) ||
 	    rt2x00_get_field32(word0, RXD_W0_PHYSICAL_ERROR) ||
-	    rt2x00_get_field32(word0, RXD_W0_CIPHER_ERROR))
+	    rt2x00_get_field32(word0, RXD_W0_CIPHER_ERROR)) {
+		entry->ring->rt2x00dev->link.rx_failed++;
 		return -EINVAL;
+	}
 
 	/*
 	 * Obtain the status about this packet.
@@ -1427,6 +1427,7 @@ static void rt2500usb_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 	    IEEE80211_HW_MONITOR_DURING_OPER |
 	    IEEE80211_HW_NO_PROBE_FILTERING;
 	rt2x00dev->hw->extra_tx_headroom = TXD_DESC_SIZE;
+	rt2x00dev->hw->max_signal = MAX_SIGNAL;
 	rt2x00dev->hw->max_rssi = MAX_RX_SSI;
 	rt2x00dev->hw->queues = 2;
 
diff --git a/drivers/net/wireless/rt2500usb.h b/drivers/net/wireless/rt2500usb.h
index f0eaead..b5033da 100644
--- a/drivers/net/wireless/rt2500usb.h
+++ b/drivers/net/wireless/rt2500usb.h
@@ -48,6 +48,7 @@
  * Signal information.
  * Defaul offset is required for RSSI <-> dBm conversion.
  */
+#define MAX_SIGNAL			100
 #define MAX_RX_SSI			-1
 #define DEFAULT_RSSI_OFFSET		120
 
diff --git a/drivers/net/wireless/rt2x00.h b/drivers/net/wireless/rt2x00.h
index b7e2578..777cd4a 100644
--- a/drivers/net/wireless/rt2x00.h
+++ b/drivers/net/wireless/rt2x00.h
@@ -192,7 +192,7 @@ struct link {
 	u32 count;
 
 	/*
-	 * Misc statistics.
+	 * Statistics required for Link tuning.
 	 * For the average RSSI value we use the "Walking average" approach.
 	 * When adding RSSI to the average value the following calculation
 	 * is needed:
@@ -214,6 +214,31 @@ struct link {
 	int false_cca;
 
 	/*
+	 * Statistics required for Signal quality calculation.
+	 * For calculating the Signal quality we have to determine
+	 * the total number of success and failed RX and TX frames.
+	 * After that we also use the average RSSI value to help
+	 * determining the signal quality.
+	 * For the calculation we will use the following algorithm:
+	 *
+	 *         rssi_percentage = (avg_rssi * 100) / rssi_offset
+	 *         rx_percentage = (rx_success * 100) / rx_total
+	 *         tx_percentage = (tx_success * 100) / tx_total
+	 *         avg_signal = ((WEIGHT_RSSI * avg_rssi) +
+	 *                       (WEIGHT_TX * tx_percentage) +
+	 *                       (WEIGHT_RX * rx_percentage)) / 100
+	 *
+	 * This value should then be checked to not be greated then 100.
+	 */
+	int rx_success;
+	int rx_failed;
+	int tx_success;
+	int tx_failed;
+#define WEIGHT_RSSI	20
+#define WEIGHT_RX	40
+#define WEIGHT_TX	40
+
+	/*
 	 * Work structure for scheduling periodic link tuning.
 	 */
 	struct delayed_work work;
@@ -231,16 +256,13 @@ static inline void rt2x00_update_link_rssi(struct link *link, int rssi)
 }
 
 /*
- * When the avg_rssi is unset (which means no frames
- * have been received), we need to return the default
- * value which needs to be less than -80 so the device
- * will select the maximum sensitivity.
+ * When the avg_rssi is unset or no frames  have been received),
+ * we need to return the default value which needs to be less
+ * than -80 so the device will select the maximum sensitivity.
  */
 static inline int rt2x00_get_link_rssi(struct link *link)
 {
-	int rssi = link->avg_rssi;
-	link->avg_rssi = 0;
-	return rssi ? rssi : -128;
+	return (link->avg_rssi && link->rx_success) ? link->avg_rssi : -128;
 }
 
 /*
diff --git a/drivers/net/wireless/rt2x00dev.c b/drivers/net/wireless/rt2x00dev.c
index 8e860a8..a584fbe 100644
--- a/drivers/net/wireless/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00dev.c
@@ -169,6 +169,47 @@ void rt2x00lib_toggle_rx(struct rt2x00_dev *rt2x00dev, int enable)
 		rt2x00_start_link_tune(rt2x00dev);
 }
 
+static int rt2x00lib_calculate_link_signal(struct rt2x00_dev *rt2x00dev)
+{
+	struct link *link = &rt2x00dev->link;
+	int rssi_percentage = 0;
+	int rx_percentage = 0;
+	int tx_percentage = 0;
+	int rssi = rt2x00_get_link_rssi(link);
+	int signal;
+
+	/*
+	 * We need a positive value for the RSSI.
+	 */
+	if (rssi < 0)
+		rssi += rt2x00dev->rssi_offset;
+
+	/*
+	 * Calculate the different percentages,
+	 * which will be used for the signal.
+	 */
+	if (rt2x00dev->rssi_offset)
+		rssi_percentage = (rssi * 100) / rt2x00dev->rssi_offset;
+	if (link->rx_failed || link->rx_success)
+		rx_percentage =
+		    (link->rx_success * 100) /
+		    (link->rx_failed + link->rx_success);
+	if (link->tx_failed || link->tx_success)
+		tx_percentage =
+		    (link->tx_success * 100) /
+		    (link->tx_failed + link->tx_success);
+
+	/*
+	 * Add the individual percentages and use the WEIGHT
+	 * defines to calculate the current link signal.
+	 */
+	signal = ((WEIGHT_RSSI * rssi_percentage) +
+		  (WEIGHT_TX * tx_percentage) +
+		  (WEIGHT_RX * rx_percentage)) / 100;
+
+	return (signal > 100) ? 100 :  signal;
+}
+
 static void rt2x00lib_link_tuner(struct work_struct *work)
 {
 	struct rt2x00_dev *rt2x00dev =
@@ -187,6 +228,16 @@ static void rt2x00lib_link_tuner(struct work_struct *work)
 		rt2x00dev->ops->lib->link_tuner(rt2x00dev);
 
 	/*
+	 * Reset statistics.
+	 * This will cause the signal value to be
+	 * based on the statistics of the last second.
+	 */
+	rt2x00dev->link.rx_success = 0;
+	rt2x00dev->link.rx_failed = 0;
+	rt2x00dev->link.tx_success = 0;
+	rt2x00dev->link.tx_failed = 0;
+
+	/*
 	 * Increase tuner counter, and reschedule the next link tuner run.
 	 */
 	rt2x00dev->link.count++;
@@ -222,6 +273,9 @@ void rt2x00lib_txdone(struct data_entry *entry,
 	struct rt2x00_dev *rt2x00dev = entry->ring->rt2x00dev;
 	struct ieee80211_tx_status *tx_status = &entry->tx_status;
 	struct ieee80211_low_level_stats *stats = &rt2x00dev->low_level_stats;
+	int success = !!(status == TX_SUCCESS || status == TX_SUCCESS_RETRY);
+	int fail = !!(status == TX_FAIL_RETRY || status == TX_FAIL_INVALID ||
+		      status == TX_FAIL_OTHER);
 
 	/*
 	 * Update TX statistics.
@@ -230,9 +284,11 @@ void rt2x00lib_txdone(struct data_entry *entry,
 	tx_status->ack_signal = 0;
 	tx_status->excessive_retries = (status == TX_FAIL_RETRY);
 	tx_status->retry_count = retry;
+	rt2x00dev->link.tx_success += success;
+	rt2x00dev->link.tx_failed += retry + fail;
 
 	if (!(tx_status->control.flags & IEEE80211_TXCTL_NO_ACK)) {
-		if (status == TX_SUCCESS || status == TX_SUCCESS_RETRY)
+		if (success)
 			tx_status->flags |= IEEE80211_TX_STATUS_ACK;
 		else
 			stats->dot11ACKFailureCount++;
@@ -242,7 +298,7 @@ void rt2x00lib_txdone(struct data_entry *entry,
 	tx_status->queue_number = tx_status->control.queue;
 
 	if (tx_status->control.flags & IEEE80211_TXCTL_USE_RTS_CTS) {
-		if (status == TX_SUCCESS || status == TX_SUCCESS_RETRY)
+		if (success)
 			stats->dot11RTSSuccessCount++;
 		else
 			stats->dot11RTSFailureCount++;
@@ -293,7 +349,9 @@ void rt2x00lib_rxdone(struct data_entry *entry, char *data,
 		}
 	}
 
+	rt2x00dev->link.rx_success++;
 	rx_status->rate = val;
+	rx_status->signal = rt2x00lib_calculate_link_signal(rt2x00dev);
 	rx_status->ssi = rssi;
 	rt2x00_update_link_rssi(&rt2x00dev->link, rssi);
 
diff --git a/drivers/net/wireless/rt61pci.c b/drivers/net/wireless/rt61pci.c
index 774f5de..00f66e0 100644
--- a/drivers/net/wireless/rt61pci.c
+++ b/drivers/net/wireless/rt61pci.c
@@ -939,14 +939,16 @@ static void rt61pci_activity_led(struct rt2x00_dev *rt2x00dev, int rssi)
  */
 static void rt61pci_link_stats(struct rt2x00_dev *rt2x00dev)
 {
+	int fcs;
 	u32 reg;
 
 	/*
 	 * Update FCS error count from register.
 	 */
 	rt2x00pci_register_read(rt2x00dev, STA_CSR0, &reg);
-	rt2x00dev->low_level_stats.dot11FCSErrorCount +=
-	    rt2x00_get_field32(reg, STA_CSR0_FCS_ERROR);
+	fcs = rt2x00_get_field32(reg, STA_CSR0_FCS_ERROR);
+	rt2x00dev->link.rx_failed += fcs;
+	rt2x00dev->low_level_stats.dot11FCSErrorCount += fcs;
 
 	/*
 	 * Update False CCA count from register.
@@ -1797,13 +1799,11 @@ static int rt61pci_fill_rxdone(struct data_entry *entry,
 	rt2x00_desc_read(rxd, 0, &word0);
 	rt2x00_desc_read(rxd, 1, &word1);
 
-	/*
-	 * TODO: Don't we need to keep statistics
-	 * updated about these errors?
-	 */
 	if (rt2x00_get_field32(word0, RXD_W0_CRC_ERROR) ||
-	    rt2x00_get_field32(word0, RXD_W0_CIPHER_ERROR))
+	    rt2x00_get_field32(word0, RXD_W0_CIPHER_ERROR)) {
+		entry->ring->rt2x00dev->link.rx_failed++;
 		return -EINVAL;
+	}
 
 	/*
 	 * Obtain the status about this packet.
@@ -2221,6 +2221,7 @@ static void rt61pci_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 	    IEEE80211_HW_MONITOR_DURING_OPER |
 	    IEEE80211_HW_NO_PROBE_FILTERING;
 	rt2x00dev->hw->extra_tx_headroom = 0;
+	rt2x00dev->hw->max_signal = MAX_SIGNAL;
 	rt2x00dev->hw->max_rssi = MAX_RX_SSI;
 	rt2x00dev->hw->queues = 5;
 
diff --git a/drivers/net/wireless/rt61pci.h b/drivers/net/wireless/rt61pci.h
index e9562e4..c47dd15 100644
--- a/drivers/net/wireless/rt61pci.h
+++ b/drivers/net/wireless/rt61pci.h
@@ -39,6 +39,7 @@
  * Signal information.
  * Defaul offset is required for RSSI <-> dBm conversion.
  */
+#define MAX_SIGNAL			100
 #define MAX_RX_SSI			-1
 #define DEFAULT_RSSI_OFFSET		120
 
diff --git a/drivers/net/wireless/rt73usb.c b/drivers/net/wireless/rt73usb.c
index 28bc165..48fb38e 100644
--- a/drivers/net/wireless/rt73usb.c
+++ b/drivers/net/wireless/rt73usb.c
@@ -828,14 +828,16 @@ static void rt73usb_activity_led(struct rt2x00_dev *rt2x00dev, int rssi)
  */
 static void rt73usb_link_stats(struct rt2x00_dev *rt2x00dev)
 {
+	int fcs;
 	u32 reg;
 
 	/*
 	 * Update FCS error count from register.
 	 */
 	rt73usb_register_read(rt2x00dev, STA_CSR0, &reg);
-	rt2x00dev->low_level_stats.dot11FCSErrorCount +=
-	    rt2x00_get_field32(reg, STA_CSR0_FCS_ERROR);
+	fcs = rt2x00_get_field32(reg, STA_CSR0_FCS_ERROR);
+	rt2x00dev->link.rx_failed += fcs;
+	rt2x00dev->low_level_stats.dot11FCSErrorCount += fcs;
 
 	/*
 	 * Update False CCA count from register.
@@ -1432,13 +1434,11 @@ static int rt73usb_fill_rxdone(struct data_entry *entry,
 	rt2x00_desc_read(rxd, 0, &word0);
 	rt2x00_desc_read(rxd, 1, &word1);
 
-	/*
-	 * TODO: Don't we need to keep statistics
-	 * updated about these errors?
-	 */
 	if (rt2x00_get_field32(word0, RXD_W0_CRC_ERROR) ||
-	    rt2x00_get_field32(word0, RXD_W0_CIPHER_ERROR))
+	    rt2x00_get_field32(word0, RXD_W0_CIPHER_ERROR)) {
+		entry->ring->rt2x00dev->link.rx_failed++;
 		return -EINVAL;
+	}
 
 	/*
 	 * Obtain the status about this packet.
@@ -1687,6 +1687,7 @@ static void rt73usb_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 	    IEEE80211_HW_MONITOR_DURING_OPER |
 	    IEEE80211_HW_NO_PROBE_FILTERING;
 	rt2x00dev->hw->extra_tx_headroom = TXD_DESC_SIZE;
+	rt2x00dev->hw->max_signal = MAX_SIGNAL;
 	rt2x00dev->hw->max_rssi = MAX_RX_SSI;
 	rt2x00dev->hw->queues = 5;
 
diff --git a/drivers/net/wireless/rt73usb.h b/drivers/net/wireless/rt73usb.h
index 45352e6..ec2632f 100644
--- a/drivers/net/wireless/rt73usb.h
+++ b/drivers/net/wireless/rt73usb.h
@@ -39,6 +39,7 @@
  * Signal information.
  * Defaul offset is required for RSSI <-> dBm conversion.
  */
+#define MAX_SIGNAL			100
 #define MAX_RX_SSI			-1
 #define DEFAULT_RSSI_OFFSET		120
 
-- 
1.5.2.4

