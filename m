Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.189]:21986 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753484AbXJMOKX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Oct 2007 10:10:23 -0400
Received: by nf-out-0910.google.com with SMTP id g13so956439nfb
        for <linux-wireless@vger.kernel.org>; Sat, 13 Oct 2007 07:10:22 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 01/11] rt2x00: Move quality statistics into seperate structure
Date: Sat, 13 Oct 2007 16:26:12 +0200
Cc: rt2400-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org
References: <200710131621.05173.IvDoorn@gmail.com>
In-Reply-To: <200710131621.05173.IvDoorn@gmail.com>
MIME-Version: 1.0
Message-Id: <200710131626.13303.IvDoorn@gmail.com> (sfid-20071013_151031_885206_877BB254)
Content-Type: text/plain;
  charset="utf-8"
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Move all link quality statistics variables into
the link_qual structure. This cleans up the link
structure and allows us to use it for more then
just statistics.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2400pci.c |   11 +++---
 drivers/net/wireless/rt2x00/rt2500pci.c |   11 +++---
 drivers/net/wireless/rt2x00/rt2500usb.c |   12 +++---
 drivers/net/wireless/rt2x00/rt2x00.h    |   61 ++++++++++++++++++++-----------
 drivers/net/wireless/rt2x00/rt2x00dev.c |   46 ++++++++++++------------
 drivers/net/wireless/rt2x00/rt61pci.c   |   12 +++---
 drivers/net/wireless/rt2x00/rt73usb.c   |   13 +++----
 7 files changed, 92 insertions(+), 74 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2400pci.c b/drivers/net/wireless/rt2x00/rt2400pci.c
index 882d049..31b4f4e 100644
--- a/drivers/net/wireless/rt2x00/rt2400pci.c
+++ b/drivers/net/wireless/rt2x00/rt2400pci.c
@@ -542,7 +542,8 @@ static void rt2400pci_disable_led(struct rt2x00_dev *rt2x00dev)
 /*
  * Link tuning
  */
-static void rt2400pci_link_stats(struct rt2x00_dev *rt2x00dev)
+static void rt2400pci_link_stats(struct rt2x00_dev *rt2x00dev,
+				 struct link_qual *qual)
 {
 	u32 reg;
 	u8 bbp;
@@ -551,13 +552,13 @@ static void rt2400pci_link_stats(struct rt2x00_dev *rt2x00dev)
 	 * Update FCS error count from register.
 	 */
 	rt2x00pci_register_read(rt2x00dev, CNT0, &reg);
-	rt2x00dev->link.rx_failed = rt2x00_get_field32(reg, CNT0_FCS_ERROR);
+	qual->rx_failed = rt2x00_get_field32(reg, CNT0_FCS_ERROR);
 
 	/*
 	 * Update False CCA count from register.
 	 */
 	rt2400pci_bbp_read(rt2x00dev, 39, &bbp);
-	rt2x00dev->link.false_cca = bbp;
+	qual->false_cca = bbp;
 }
 
 static void rt2400pci_reset_tuner(struct rt2x00_dev *rt2x00dev)
@@ -582,10 +583,10 @@ static void rt2400pci_link_tuner(struct rt2x00_dev *rt2x00dev)
 	 */
 	rt2400pci_bbp_read(rt2x00dev, 13, &reg);
 
-	if (rt2x00dev->link.false_cca > 512 && reg < 0x20) {
+	if (rt2x00dev->link.qual.false_cca > 512 && reg < 0x20) {
 		rt2400pci_bbp_write(rt2x00dev, 13, ++reg);
 		rt2x00dev->link.vgc_level = reg;
-	} else if (rt2x00dev->link.false_cca < 100 && reg > 0x08) {
+	} else if (rt2x00dev->link.qual.false_cca < 100 && reg > 0x08) {
 		rt2400pci_bbp_write(rt2x00dev, 13, --reg);
 		rt2x00dev->link.vgc_level = reg;
 	}
diff --git a/drivers/net/wireless/rt2x00/rt2500pci.c b/drivers/net/wireless/rt2x00/rt2500pci.c
index c97b00c..a59590c 100644
--- a/drivers/net/wireless/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/rt2x00/rt2500pci.c
@@ -587,7 +587,8 @@ static void rt2500pci_disable_led(struct rt2x00_dev *rt2x00dev)
 /*
  * Link tuning
  */
-static void rt2500pci_link_stats(struct rt2x00_dev *rt2x00dev)
+static void rt2500pci_link_stats(struct rt2x00_dev *rt2x00dev,
+				 struct link_qual *qual)
 {
 	u32 reg;
 
@@ -595,13 +596,13 @@ static void rt2500pci_link_stats(struct rt2x00_dev *rt2x00dev)
 	 * Update FCS error count from register.
 	 */
 	rt2x00pci_register_read(rt2x00dev, CNT0, &reg);
-	rt2x00dev->link.rx_failed = rt2x00_get_field32(reg, CNT0_FCS_ERROR);
+	qual->rx_failed = rt2x00_get_field32(reg, CNT0_FCS_ERROR);
 
 	/*
 	 * Update False CCA count from register.
 	 */
 	rt2x00pci_register_read(rt2x00dev, CNT3, &reg);
-	rt2x00dev->link.false_cca = rt2x00_get_field32(reg, CNT3_FALSE_CCA);
+	qual->false_cca = rt2x00_get_field32(reg, CNT3_FALSE_CCA);
 }
 
 static void rt2500pci_reset_tuner(struct rt2x00_dev *rt2x00dev)
@@ -679,10 +680,10 @@ dynamic_cca_tune:
 	 * R17 is inside the dynamic tuning range,
 	 * start tuning the link based on the false cca counter.
 	 */
-	if (rt2x00dev->link.false_cca > 512 && r17 < 0x40) {
+	if (rt2x00dev->link.qual.false_cca > 512 && r17 < 0x40) {
 		rt2500pci_bbp_write(rt2x00dev, 17, ++r17);
 		rt2x00dev->link.vgc_level = r17;
-	} else if (rt2x00dev->link.false_cca < 100 && r17 > 0x32) {
+	} else if (rt2x00dev->link.qual.false_cca < 100 && r17 > 0x32) {
 		rt2500pci_bbp_write(rt2x00dev, 17, --r17);
 		rt2x00dev->link.vgc_level = r17;
 	}
diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
index fc1c60a..625c409 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/rt2x00/rt2500usb.c
@@ -535,7 +535,8 @@ static void rt2500usb_disable_led(struct rt2x00_dev *rt2x00dev)
 /*
  * Link tuning
  */
-static void rt2500usb_link_stats(struct rt2x00_dev *rt2x00dev)
+static void rt2500usb_link_stats(struct rt2x00_dev *rt2x00dev,
+				 struct link_qual *qual)
 {
 	u16 reg;
 
@@ -543,14 +544,13 @@ static void rt2500usb_link_stats(struct rt2x00_dev *rt2x00dev)
 	 * Update FCS error count from register.
 	 */
 	rt2500usb_register_read(rt2x00dev, STA_CSR0, &reg);
-	rt2x00dev->link.rx_failed = rt2x00_get_field16(reg, STA_CSR0_FCS_ERROR);
+	qual->rx_failed = rt2x00_get_field16(reg, STA_CSR0_FCS_ERROR);
 
 	/*
 	 * Update False CCA count from register.
 	 */
 	rt2500usb_register_read(rt2x00dev, STA_CSR3, &reg);
-	rt2x00dev->link.false_cca =
-	    rt2x00_get_field16(reg, STA_CSR3_FALSE_CCA_ERROR);
+	qual->false_cca = rt2x00_get_field16(reg, STA_CSR3_FALSE_CCA_ERROR);
 }
 
 static void rt2500usb_reset_tuner(struct rt2x00_dev *rt2x00dev)
@@ -673,10 +673,10 @@ static void rt2500usb_link_tuner(struct rt2x00_dev *rt2x00dev)
 	if (r17 > up_bound) {
 		rt2500usb_bbp_write(rt2x00dev, 17, up_bound);
 		rt2x00dev->link.vgc_level = up_bound;
-	} else if (rt2x00dev->link.false_cca > 512 && r17 < up_bound) {
+	} else if (rt2x00dev->link.qual.false_cca > 512 && r17 < up_bound) {
 		rt2500usb_bbp_write(rt2x00dev, 17, ++r17);
 		rt2x00dev->link.vgc_level = r17;
-	} else if (rt2x00dev->link.false_cca < 100 && r17 > low_bound) {
+	} else if (rt2x00dev->link.qual.false_cca < 100 && r17 > low_bound) {
 		rt2500usb_bbp_write(rt2x00dev, 17, --r17);
 		rt2x00dev->link.vgc_level = r17;
 	}
diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index 9845e58..046c95e 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -180,18 +180,9 @@ struct rf_channel {
 };
 
 /*
- * To optimize the quality of the link we need to store
- * the quality of received frames and periodically
- * optimize the link.
+ * Quality statistics about the currently active link.
  */
-struct link {
-	/*
-	 * Link tuner counter
-	 * The number of times the link has been tuned
-	 * since the radio has been switched on.
-	 */
-	u32 count;
-
+struct link_qual {
 	/*
 	 * Statistics required for Link tuning.
 	 * For the average RSSI value we use the "Walking average" approach.
@@ -211,7 +202,6 @@ struct link {
 	 * the new values correctly allowing a effective link tuning.
 	 */
 	int avg_rssi;
-	int vgc_level;
 	int false_cca;
 
 	/*
@@ -240,6 +230,30 @@ struct link {
 #define WEIGHT_RSSI	20
 #define WEIGHT_RX	40
 #define WEIGHT_TX	40
+};
+
+/*
+ * To optimize the quality of the link we need to store
+ * the quality of received frames and periodically
+ * optimize the link.
+ */
+struct link {
+	/*
+	 * Link tuner counter
+	 * The number of times the link has been tuned
+	 * since the radio has been switched on.
+	 */
+	u32 count;
+
+	/*
+	 * Quality measurement values.
+	 */
+	struct link_qual qual;
+
+	/*
+	 * Active VGC level
+	 */
+	int vgc_level;
 
 	/*
 	 * Work structure for scheduling periodic link tuning.
@@ -249,25 +263,25 @@ struct link {
 
 /*
  * Clear all counters inside the link structure.
- * This can be easiest achieved by memsetting everything
- * except for the work structure at the end.
  */
 static inline void rt2x00_clear_link(struct link *link)
 {
-	memset(link, 0x00, sizeof(*link) - sizeof(link->work));
-	link->rx_percentage = 50;
-	link->tx_percentage = 50;
+	link->count = 0;
+	memset(&link->qual, 0, sizeof(link->qual));
+	link->qual.rx_percentage = 50;
+	link->qual.tx_percentage = 50;
 }
 
+
 /*
  * Update the rssi using the walking average approach.
  */
 static inline void rt2x00_update_link_rssi(struct link *link, int rssi)
 {
-	if (!link->avg_rssi)
-		link->avg_rssi = rssi;
+	if (!link->qual.avg_rssi)
+		link->qual.avg_rssi = rssi;
 	else
-		link->avg_rssi = ((link->avg_rssi * 7) + rssi) / 8;
+		link->qual.avg_rssi = ((link->qual.avg_rssi * 7) + rssi) / 8;
 }
 
 /*
@@ -277,7 +291,9 @@ static inline void rt2x00_update_link_rssi(struct link *link, int rssi)
  */
 static inline int rt2x00_get_link_rssi(struct link *link)
 {
-	return (link->avg_rssi && link->rx_success) ? link->avg_rssi : -128;
+	if (link->qual.avg_rssi && link->qual.rx_success)
+		return link->qual.avg_rssi;
+	return -128;
 }
 
 /*
@@ -402,7 +418,8 @@ struct rt2x00lib_ops {
 	int (*set_device_state) (struct rt2x00_dev *rt2x00dev,
 				 enum dev_state state);
 	int (*rfkill_poll) (struct rt2x00_dev *rt2x00dev);
-	void (*link_stats) (struct rt2x00_dev *rt2x00dev);
+	void (*link_stats) (struct rt2x00_dev *rt2x00dev,
+			    struct link_qual *qual);
 	void (*reset_tuner) (struct rt2x00_dev *rt2x00dev);
 	void (*link_tuner) (struct rt2x00_dev *rt2x00dev);
 
diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index bb6f46c..604d627 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -179,26 +179,26 @@ void rt2x00lib_toggle_rx(struct rt2x00_dev *rt2x00dev, enum dev_state state)
 		rt2x00lib_start_link_tuner(rt2x00dev);
 }
 
-static void rt2x00lib_precalculate_link_signal(struct link *link)
+static void rt2x00lib_precalculate_link_signal(struct link_qual *qual)
 {
-	if (link->rx_failed || link->rx_success)
-		link->rx_percentage =
-		    (link->rx_success * 100) /
-		    (link->rx_failed + link->rx_success);
+	if (qual->rx_failed || qual->rx_success)
+		qual->rx_percentage =
+		    (qual->rx_success * 100) /
+		    (qual->rx_failed + qual->rx_success);
 	else
-		link->rx_percentage = 50;
+		qual->rx_percentage = 50;
 
-	if (link->tx_failed || link->tx_success)
-		link->tx_percentage =
-		    (link->tx_success * 100) /
-		    (link->tx_failed + link->tx_success);
+	if (qual->tx_failed || qual->tx_success)
+		qual->tx_percentage =
+		    (qual->tx_success * 100) /
+		    (qual->tx_failed + qual->tx_success);
 	else
-		link->tx_percentage = 50;
+		qual->tx_percentage = 50;
 
-	link->rx_success = 0;
-	link->rx_failed = 0;
-	link->tx_success = 0;
-	link->tx_failed = 0;
+	qual->rx_success = 0;
+	qual->rx_failed = 0;
+	qual->tx_success = 0;
+	qual->tx_failed = 0;
 }
 
 static int rt2x00lib_calculate_link_signal(struct rt2x00_dev *rt2x00dev,
@@ -225,8 +225,8 @@ static int rt2x00lib_calculate_link_signal(struct rt2x00_dev *rt2x00dev,
 	 * defines to calculate the current link signal.
 	 */
 	signal = ((WEIGHT_RSSI * rssi_percentage) +
-		  (WEIGHT_TX * rt2x00dev->link.tx_percentage) +
-		  (WEIGHT_RX * rt2x00dev->link.rx_percentage)) / 100;
+		  (WEIGHT_TX * rt2x00dev->link.qual.tx_percentage) +
+		  (WEIGHT_RX * rt2x00dev->link.qual.rx_percentage)) / 100;
 
 	return (signal > 100) ? 100 : signal;
 }
@@ -246,10 +246,10 @@ static void rt2x00lib_link_tuner(struct work_struct *work)
 	/*
 	 * Update statistics.
 	 */
-	rt2x00dev->ops->lib->link_stats(rt2x00dev);
+	rt2x00dev->ops->lib->link_stats(rt2x00dev, &rt2x00dev->link.qual);
 
 	rt2x00dev->low_level_stats.dot11FCSErrorCount +=
-	    rt2x00dev->link.rx_failed;
+	    rt2x00dev->link.qual.rx_failed;
 
 	/*
 	 * Only perform the link tuning when Link tuning
@@ -262,7 +262,7 @@ static void rt2x00lib_link_tuner(struct work_struct *work)
 	 * Precalculate a portion of the link signal which is
 	 * in based on the tx/rx success/failure counters.
 	 */
-	rt2x00lib_precalculate_link_signal(&rt2x00dev->link);
+	rt2x00lib_precalculate_link_signal(&rt2x00dev->link.qual);
 
 	/*
 	 * Increase tuner counter, and reschedule the next link tuner run.
@@ -350,8 +350,8 @@ void rt2x00lib_txdone(struct data_entry *entry,
 	tx_status->ack_signal = 0;
 	tx_status->excessive_retries = (status == TX_FAIL_RETRY);
 	tx_status->retry_count = retry;
-	rt2x00dev->link.tx_success += success;
-	rt2x00dev->link.tx_failed += retry + fail;
+	rt2x00dev->link.qual.tx_success += success;
+	rt2x00dev->link.qual.tx_failed += retry + fail;
 
 	if (!(tx_status->control.flags & IEEE80211_TXCTL_NO_ACK)) {
 		if (success)
@@ -413,7 +413,7 @@ void rt2x00lib_rxdone(struct data_entry *entry, struct sk_buff *skb,
 	}
 
 	rt2x00_update_link_rssi(&rt2x00dev->link, desc->rssi);
-	rt2x00dev->link.rx_success++;
+	rt2x00dev->link.qual.rx_success++;
 	rx_status->rate = val;
 	rx_status->signal =
 	    rt2x00lib_calculate_link_signal(rt2x00dev, desc->rssi);
diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index b6fb1ce..d3ef2fc 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -792,7 +792,8 @@ static void rt61pci_activity_led(struct rt2x00_dev *rt2x00dev, int rssi)
 /*
  * Link tuning
  */
-static void rt61pci_link_stats(struct rt2x00_dev *rt2x00dev)
+static void rt61pci_link_stats(struct rt2x00_dev *rt2x00dev,
+			       struct link_qual *qual)
 {
 	u32 reg;
 
@@ -800,14 +801,13 @@ static void rt61pci_link_stats(struct rt2x00_dev *rt2x00dev)
 	 * Update FCS error count from register.
 	 */
 	rt2x00pci_register_read(rt2x00dev, STA_CSR0, &reg);
-	rt2x00dev->link.rx_failed = rt2x00_get_field32(reg, STA_CSR0_FCS_ERROR);
+	qual->rx_failed = rt2x00_get_field32(reg, STA_CSR0_FCS_ERROR);
 
 	/*
 	 * Update False CCA count from register.
 	 */
 	rt2x00pci_register_read(rt2x00dev, STA_CSR1, &reg);
-	rt2x00dev->link.false_cca =
-	    rt2x00_get_field32(reg, STA_CSR1_FALSE_CCA_ERROR);
+	qual->false_cca = rt2x00_get_field32(reg, STA_CSR1_FALSE_CCA_ERROR);
 }
 
 static void rt61pci_reset_tuner(struct rt2x00_dev *rt2x00dev)
@@ -904,11 +904,11 @@ static void rt61pci_link_tuner(struct rt2x00_dev *rt2x00dev)
 	 * r17 does not yet exceed upper limit, continue and base
 	 * the r17 tuning on the false CCA count.
 	 */
-	if (rt2x00dev->link.false_cca > 512 && r17 < up_bound) {
+	if (rt2x00dev->link.qual.false_cca > 512 && r17 < up_bound) {
 		if (++r17 > up_bound)
 			r17 = up_bound;
 		rt61pci_bbp_write(rt2x00dev, 17, r17);
-	} else if (rt2x00dev->link.false_cca < 100 && r17 > low_bound) {
+	} else if (rt2x00dev->link.qual.false_cca < 100 && r17 > low_bound) {
 		if (--r17 < low_bound)
 			r17 = low_bound;
 		rt61pci_bbp_write(rt2x00dev, 17, r17);
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index 091a37f..f5af999 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -659,7 +659,8 @@ static void rt73usb_activity_led(struct rt2x00_dev *rt2x00dev, int rssi)
 /*
  * Link tuning
  */
-static void rt73usb_link_stats(struct rt2x00_dev *rt2x00dev)
+static void rt73usb_link_stats(struct rt2x00_dev *rt2x00dev,
+			       struct link_qual *qual)
 {
 	u32 reg;
 
@@ -667,15 +668,13 @@ static void rt73usb_link_stats(struct rt2x00_dev *rt2x00dev)
 	 * Update FCS error count from register.
 	 */
 	rt73usb_register_read(rt2x00dev, STA_CSR0, &reg);
-	rt2x00dev->link.rx_failed = rt2x00_get_field32(reg, STA_CSR0_FCS_ERROR);
+	qual->rx_failed = rt2x00_get_field32(reg, STA_CSR0_FCS_ERROR);
 
 	/*
 	 * Update False CCA count from register.
 	 */
 	rt73usb_register_read(rt2x00dev, STA_CSR1, &reg);
-	reg = rt2x00_get_field32(reg, STA_CSR1_FALSE_CCA_ERROR);
-	rt2x00dev->link.false_cca =
-	    rt2x00_get_field32(reg, STA_CSR1_FALSE_CCA_ERROR);
+	qual->false_cca = rt2x00_get_field32(reg, STA_CSR1_FALSE_CCA_ERROR);
 }
 
 static void rt73usb_reset_tuner(struct rt2x00_dev *rt2x00dev)
@@ -781,12 +780,12 @@ static void rt73usb_link_tuner(struct rt2x00_dev *rt2x00dev)
 	 * r17 does not yet exceed upper limit, continue and base
 	 * the r17 tuning on the false CCA count.
 	 */
-	if (rt2x00dev->link.false_cca > 512 && r17 < up_bound) {
+	if (rt2x00dev->link.qual.false_cca > 512 && r17 < up_bound) {
 		r17 += 4;
 		if (r17 > up_bound)
 			r17 = up_bound;
 		rt73usb_bbp_write(rt2x00dev, 17, r17);
-	} else if (rt2x00dev->link.false_cca < 100 && r17 > low_bound) {
+	} else if (rt2x00dev->link.qual.false_cca < 100 && r17 > low_bound) {
 		r17 -= 4;
 		if (r17 < low_bound)
 			r17 = low_bound;
-- 
1.5.3.4

