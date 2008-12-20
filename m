Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f17.google.com ([209.85.219.17]:43317 "EHLO
	mail-ew0-f17.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751290AbYLTKB5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 20 Dec 2008 05:01:57 -0500
Received: by mail-ew0-f17.google.com with SMTP id 10so1457082ewy.13
        for <linux-wireless@vger.kernel.org>; Sat, 20 Dec 2008 02:01:56 -0800 (PST)
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH 4/15] rt2x00: Restrict interface between rt2x00link and drivers
Date: Sat, 20 Dec 2008 10:54:54 +0100
Cc: "linux-wireless" <linux-wireless@vger.kernel.org>,
	rt2400-devel@lists.sourceforge.net
References: <200812201052.00655.IvDoorn@gmail.com> <200812201053.29348.IvDoorn@gmail.com> <200812201054.22904.IvDoorn@gmail.com>
In-Reply-To: <200812201054.22904.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200812201054.54391.IvDoorn@gmail.com> (sfid-20081220_110208_757703_7E6BA96B)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Restrict drivers to only access link_qual structure during
link tuning. The contents of these fields are for the drivers
and all fields are allowed to be changed to values the driver
considers correct.

This means that some fields need to be moved outside of this
structure to restrict access only to rt2x00link itself.
This allows some code to be moved outside of the rt2x00.h header
and into rt2x00link.c.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2400pci.c  |   27 +++---
 drivers/net/wireless/rt2x00/rt2500pci.c  |   50 +++++-----
 drivers/net/wireless/rt2x00/rt2500usb.c  |    5 +-
 drivers/net/wireless/rt2x00/rt2x00.h     |   99 +++++++-------------
 drivers/net/wireless/rt2x00/rt2x00link.c |  145 +++++++++++++++++++++---------
 drivers/net/wireless/rt2x00/rt61pci.c    |   49 +++++-----
 drivers/net/wireless/rt2x00/rt73usb.c    |   57 ++++++------
 7 files changed, 233 insertions(+), 199 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2400pci.c b/drivers/net/wireless/rt2x00/rt2400pci.c
index a186e4b..9c02231 100644
--- a/drivers/net/wireless/rt2x00/rt2400pci.c
+++ b/drivers/net/wireless/rt2x00/rt2400pci.c
@@ -600,36 +600,37 @@ static void rt2400pci_link_stats(struct rt2x00_dev *rt2x00dev,
 	qual->false_cca = bbp;
 }
 
-static inline void rt2400pci_set_vgc(struct rt2x00_dev *rt2x00dev, u8 vgc_level)
+static inline void rt2400pci_set_vgc(struct rt2x00_dev *rt2x00dev,
+				     struct link_qual *qual, u8 vgc_level)
 {
 	rt2400pci_bbp_write(rt2x00dev, 13, vgc_level);
-	rt2x00dev->link.vgc_level = vgc_level;
-	rt2x00dev->link.vgc_level_reg = vgc_level;
+	qual->vgc_level = vgc_level;
+	qual->vgc_level_reg = vgc_level;
 }
 
-static void rt2400pci_reset_tuner(struct rt2x00_dev *rt2x00dev)
+static void rt2400pci_reset_tuner(struct rt2x00_dev *rt2x00dev,
+				  struct link_qual *qual)
 {
-	rt2400pci_set_vgc(rt2x00dev, 0x08);
+	rt2400pci_set_vgc(rt2x00dev, qual, 0x08);
 }
 
-static void rt2400pci_link_tuner(struct rt2x00_dev *rt2x00dev)
+static void rt2400pci_link_tuner(struct rt2x00_dev *rt2x00dev,
+				 struct link_qual *qual, const u32 count)
 {
-	struct link *link = &rt2x00dev->link;
-
 	/*
 	 * The link tuner should not run longer then 60 seconds,
 	 * and should run once every 2 seconds.
 	 */
-	if (link->count > 60 || !(link->count & 1))
+	if (count > 60 || !(count & 1))
 		return;
 
 	/*
 	 * Base r13 link tuning on the false cca count.
 	 */
-	if ((link->qual.false_cca > 512) && (link->vgc_level < 0x20))
-		rt2400pci_set_vgc(rt2x00dev, ++link->vgc_level);
-	else if ((link->qual.false_cca < 100) && (link->vgc_level > 0x08))
-		rt2400pci_set_vgc(rt2x00dev, --link->vgc_level);
+	if ((qual->false_cca > 512) && (qual->vgc_level < 0x20))
+		rt2400pci_set_vgc(rt2x00dev, qual, ++qual->vgc_level);
+	else if ((qual->false_cca < 100) && (qual->vgc_level > 0x08))
+		rt2400pci_set_vgc(rt2x00dev, qual, --qual->vgc_level);
 }
 
 /*
diff --git a/drivers/net/wireless/rt2x00/rt2500pci.c b/drivers/net/wireless/rt2x00/rt2500pci.c
index dd1f2c0..90333ee 100644
--- a/drivers/net/wireless/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/rt2x00/rt2500pci.c
@@ -639,31 +639,31 @@ static void rt2500pci_link_stats(struct rt2x00_dev *rt2x00dev,
 	qual->false_cca = rt2x00_get_field32(reg, CNT3_FALSE_CCA);
 }
 
-static inline void rt2500pci_set_vgc(struct rt2x00_dev *rt2x00dev, u8 vgc_level)
+static inline void rt2500pci_set_vgc(struct rt2x00_dev *rt2x00dev,
+				     struct link_qual *qual, u8 vgc_level)
 {
-	if (rt2x00dev->link.vgc_level_reg != vgc_level) {
+	if (qual->vgc_level_reg != vgc_level) {
 		rt2500pci_bbp_write(rt2x00dev, 17, vgc_level);
-		rt2x00dev->link.vgc_level_reg = vgc_level;
+		qual->vgc_level_reg = vgc_level;
 	}
 }
 
-static void rt2500pci_reset_tuner(struct rt2x00_dev *rt2x00dev)
+static void rt2500pci_reset_tuner(struct rt2x00_dev *rt2x00dev,
+				  struct link_qual *qual)
 {
-	rt2500pci_set_vgc(rt2x00dev, 0x48);
+	rt2500pci_set_vgc(rt2x00dev, qual, 0x48);
 }
 
-static void rt2500pci_link_tuner(struct rt2x00_dev *rt2x00dev)
+static void rt2500pci_link_tuner(struct rt2x00_dev *rt2x00dev,
+				 struct link_qual *qual, const u32 count)
 {
-	struct link *link = &rt2x00dev->link;
-	int rssi = rt2x00_get_link_rssi(link);
-
 	/*
 	 * To prevent collisions with MAC ASIC on chipsets
 	 * up to version C the link tuning should halt after 20
 	 * seconds while being associated.
 	 */
 	if (rt2x00_rev(&rt2x00dev->chip) < RT2560_VERSION_D &&
-	    rt2x00dev->intf_associated && link->count > 20)
+	    rt2x00dev->intf_associated && count > 20)
 		return;
 
 	/*
@@ -681,25 +681,25 @@ static void rt2500pci_link_tuner(struct rt2x00_dev *rt2x00dev)
 	 * then corrupt the R17 tuning. To remidy this the tuning should
 	 * be stopped (While making sure the R17 value will not exceed limits)
 	 */
-	if (rssi < -80 && link->count > 20) {
-		if (link->vgc_level_reg >= 0x41)
-			rt2500pci_set_vgc(rt2x00dev, link->vgc_level);
+	if (qual->rssi < -80 && count > 20) {
+		if (qual->vgc_level_reg >= 0x41)
+			rt2500pci_set_vgc(rt2x00dev, qual, qual->vgc_level);
 		return;
 	}
 
 	/*
 	 * Special big-R17 for short distance
 	 */
-	if (rssi >= -58) {
-		rt2500pci_set_vgc(rt2x00dev, 0x50);
+	if (qual->rssi >= -58) {
+		rt2500pci_set_vgc(rt2x00dev, qual, 0x50);
 		return;
 	}
 
 	/*
 	 * Special mid-R17 for middle distance
 	 */
-	if (rssi >= -74) {
-		rt2500pci_set_vgc(rt2x00dev, 0x41);
+	if (qual->rssi >= -74) {
+		rt2500pci_set_vgc(rt2x00dev, qual, 0x41);
 		return;
 	}
 
@@ -707,8 +707,8 @@ static void rt2500pci_link_tuner(struct rt2x00_dev *rt2x00dev)
 	 * Leave short or middle distance condition, restore r17
 	 * to the dynamic tuning range.
 	 */
-	if (link->vgc_level_reg >= 0x41) {
-		rt2500pci_set_vgc(rt2x00dev, link->vgc_level);
+	if (qual->vgc_level_reg >= 0x41) {
+		rt2500pci_set_vgc(rt2x00dev, qual, qual->vgc_level);
 		return;
 	}
 
@@ -718,12 +718,12 @@ dynamic_cca_tune:
 	 * R17 is inside the dynamic tuning range,
 	 * start tuning the link based on the false cca counter.
 	 */
-	if (link->qual.false_cca > 512 && link->vgc_level_reg < 0x40) {
-		rt2500pci_set_vgc(rt2x00dev, ++link->vgc_level_reg);
-		link->vgc_level = link->vgc_level_reg;
-	} else if (link->qual.false_cca < 100 && link->vgc_level_reg > 0x32) {
-		rt2500pci_set_vgc(rt2x00dev, --link->vgc_level_reg);
-		link->vgc_level = link->vgc_level_reg;
+	if (qual->false_cca > 512 && qual->vgc_level_reg < 0x40) {
+		rt2500pci_set_vgc(rt2x00dev, qual, ++qual->vgc_level_reg);
+		qual->vgc_level = qual->vgc_level_reg;
+	} else if (qual->false_cca < 100 && qual->vgc_level_reg > 0x32) {
+		rt2500pci_set_vgc(rt2x00dev, qual, --qual->vgc_level_reg);
+		qual->vgc_level = qual->vgc_level_reg;
 	}
 }
 
diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
index 4de1bc1..79f0771 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/rt2x00/rt2500usb.c
@@ -698,7 +698,8 @@ static void rt2500usb_link_stats(struct rt2x00_dev *rt2x00dev,
 	qual->false_cca = rt2x00_get_field16(reg, STA_CSR3_FALSE_CCA_ERROR);
 }
 
-static void rt2500usb_reset_tuner(struct rt2x00_dev *rt2x00dev)
+static void rt2500usb_reset_tuner(struct rt2x00_dev *rt2x00dev,
+				  struct link_qual *qual)
 {
 	u16 eeprom;
 	u16 value;
@@ -719,7 +720,7 @@ static void rt2500usb_reset_tuner(struct rt2x00_dev *rt2x00dev)
 	value = rt2x00_get_field16(eeprom, EEPROM_BBPTUNE_VGCUPPER);
 	rt2500usb_bbp_write(rt2x00dev, 17, value);
 
-	rt2x00dev->link.vgc_level = value;
+	qual->vgc_level = value;
 }
 
 /*
diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index 8935f2c..dea5022 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -177,52 +177,41 @@ struct antenna_setup {
  */
 struct link_qual {
 	/*
-	 * Statistics required for Link tuning.
-	 * For the average RSSI value we use the "Walking average" approach.
-	 * When adding RSSI to the average value the following calculation
-	 * is needed:
-	 *
-	 *        avg_rssi = ((avg_rssi * 7) + rssi) / 8;
+	 * Statistics required for Link tuning by driver
+	 * The rssi value is provided by rt2x00lib during the
+	 * link_tuner() callback function.
+	 * The false_cca field is filled during the link_stats()
+	 * callback function and could be used during the
+	 * link_tuner() callback function.
+	 */
+	int rssi;
+	int false_cca;
+
+	/*
+	 * VGC levels
+	 * Hardware driver will tune the VGC level during each call
+	 * to the link_tuner() callback function. This vgc_level is
+	 * is determined based on the link quality statistics like
+	 * average RSSI and the false CCA count.
 	 *
-	 * The advantage of this approach is that we only need 1 variable
-	 * to store the average in (No need for a count and a total).
-	 * But more importantly, normal average values will over time
-	 * move less and less towards newly added values this results
-	 * that with link tuning, the device can have a very good RSSI
-	 * for a few minutes but when the device is moved away from the AP
-	 * the average will not decrease fast enough to compensate.
-	 * The walking average compensates this and will move towards
-	 * the new values correctly allowing a effective link tuning.
+	 * In some cases the drivers need to differentiate between
+	 * the currently "desired" VGC level and the level configured
+	 * in the hardware. The latter is important to reduce the
+	 * number of BBP register reads to reduce register access
+	 * overhead. For this reason we store both values here.
 	 */
-	int avg_rssi;
-	int false_cca;
+	u8 vgc_level;
+	u8 vgc_level_reg;
 
 	/*
 	 * Statistics required for Signal quality calculation.
-	 * For calculating the Signal quality we have to determine
-	 * the total number of success and failed RX and TX frames.
-	 * After that we also use the average RSSI value to help
-	 * determining the signal quality.
-	 * For the calculation we will use the following algorithm:
-	 *
-	 *         rssi_percentage = (avg_rssi * 100) / rssi_offset
-	 *         rx_percentage = (rx_success * 100) / rx_total
-	 *         tx_percentage = (tx_success * 100) / tx_total
-	 *         avg_signal = ((WEIGHT_RSSI * avg_rssi) +
-	 *                       (WEIGHT_TX * tx_percentage) +
-	 *                       (WEIGHT_RX * rx_percentage)) / 100
-	 *
-	 * This value should then be checked to not be greater then 100.
+	 * These fields might be changed during the link_stats()
+	 * callback function.
 	 */
-	int rx_percentage;
 	int rx_success;
 	int rx_failed;
-	int tx_percentage;
 	int tx_success;
 	int tx_failed;
-#define WEIGHT_RSSI	20
-#define WEIGHT_RX	40
-#define WEIGHT_TX	40
 };
 
 /*
@@ -286,14 +275,16 @@ struct link {
 	struct link_ant ant;
 
 	/*
-	 * Active VGC level (for false cca tuning)
+	 * Currently active average RSSI value
 	 */
-	u8 vgc_level;
+	int avg_rssi;
 
 	/*
-	 * VGC level as configured in register
+	 * Currently precalculated percentages of successful
+	 * TX and RX frames.
 	 */
-	u8 vgc_level_reg;
+	int rx_percentage;
+	int tx_percentage;
 
 	/*
 	 * Work structure for scheduling periodic link tuning.
@@ -302,28 +293,6 @@ struct link {
 };
 
 /*
- * Small helper macro to work with moving/walking averages.
- */
-#define MOVING_AVERAGE(__avg, __val, __samples) \
-	( (((__avg) * ((__samples) - 1)) + (__val)) / (__samples) )
-
-/*
- * When we lack RSSI information return something less then -80 to
- * tell the driver to tune the device to maximum sensitivity.
- */
-#define DEFAULT_RSSI	( -128 )
-
-/*
- * Link quality access functions.
- */
-static inline int rt2x00_get_link_rssi(struct link *link)
-{
-	if (link->qual.avg_rssi && link->qual.rx_success)
-		return link->qual.avg_rssi;
-	return DEFAULT_RSSI;
-}
-
-/*
  * Interface structure
  * Per interface configuration details, this structure
  * is allocated as the private data for ieee80211_vif.
@@ -522,8 +491,10 @@ struct rt2x00lib_ops {
 	int (*rfkill_poll) (struct rt2x00_dev *rt2x00dev);
 	void (*link_stats) (struct rt2x00_dev *rt2x00dev,
 			    struct link_qual *qual);
-	void (*reset_tuner) (struct rt2x00_dev *rt2x00dev);
-	void (*link_tuner) (struct rt2x00_dev *rt2x00dev);
+	void (*reset_tuner) (struct rt2x00_dev *rt2x00dev,
+			     struct link_qual *qual);
+	void (*link_tuner) (struct rt2x00_dev *rt2x00dev,
+			    struct link_qual *qual, const u32 count);
 
 	/*
 	 * TX control handlers
diff --git a/drivers/net/wireless/rt2x00/rt2x00link.c b/drivers/net/wireless/rt2x00/rt2x00link.c
index 0462d5a..ee08f11 100644
--- a/drivers/net/wireless/rt2x00/rt2x00link.c
+++ b/drivers/net/wireless/rt2x00/rt2x00link.c
@@ -29,6 +29,71 @@
 #include "rt2x00.h"
 #include "rt2x00lib.h"
 
+/*
+ * When we lack RSSI information return something less then -80 to
+ * tell the driver to tune the device to maximum sensitivity.
+ */
+#define DEFAULT_RSSI		-128
+
+/*
+ * When no TX/RX percentage could be calculated due to lack of
+ * frames on the air, we fallback to a percentage of 50%.
+ * This will assure we will get at least get some decent value
+ * when the link tuner starts.
+ * The value will be dropped and overwritten with the correct (measured)
+ * value anyway during the first run of the link tuner.
+ */
+#define DEFAULT_PERCENTAGE	50
+
+/*
+ * Small helper macro to work with moving/walking averages.
+ * When adding a value to the average value the following calculation
+ * is needed:
+ *
+ *        avg_rssi = ((avg_rssi * 7) + rssi) / 8;
+ *
+ * The advantage of this approach is that we only need 1 variable
+ * to store the average in (No need for a count and a total).
+ * But more importantly, normal average values will over time
+ * move less and less towards newly added values this results
+ * that with link tuning, the device can have a very good RSSI
+ * for a few minutes but when the device is moved away from the AP
+ * the average will not decrease fast enough to compensate.
+ * The walking average compensates this and will move towards
+ * the new values correctly allowing a effective link tuning.
+ */
+#define MOVING_AVERAGE(__avg, __val, __samples) \
+	( (((__avg) * ((__samples) - 1)) + (__val)) / (__samples) )
+
+/*
+ * Small helper macro for percentage calculation
+ * This is a very simple macro with the only catch that it will
+ * produce a default value in case no total value was provided.
+ */
+#define PERCENTAGE(__value, __total) \
+	( (__total) ? (((__value) * 100) / (__total)) : (DEFAULT_PERCENTAGE) )
+
+/*
+ * For calculating the Signal quality we have determined
+ * the total number of success and failed RX and TX frames.
+ * With the addition of the average RSSI value we can determine
+ * the link quality using the following algorithm:
+ *
+ *         rssi_percentage = (avg_rssi * 100) / rssi_offset
+ *         rx_percentage = (rx_success * 100) / rx_total
+ *         tx_percentage = (tx_success * 100) / tx_total
+ *         avg_signal = ((WEIGHT_RSSI * avg_rssi) +
+ *                       (WEIGHT_TX * tx_percentage) +
+ *                       (WEIGHT_RX * rx_percentage)) / 100
+ *
+ * This value should then be checked to not be greater then 100.
+ * This means the values of WEIGHT_RSSI, WEIGHT_RX, WEIGHT_TX must
+ * sum up to 100 as well.
+ */
+#define WEIGHT_RSSI	20
+#define WEIGHT_RX	40
+#define WEIGHT_TX	40
+
 static int rt2x00link_antenna_get_link_rssi(struct rt2x00_dev *rt2x00dev)
 {
 	struct link_ant *ant = &rt2x00dev->link.ant;
@@ -191,6 +256,7 @@ void rt2x00link_update_stats(struct rt2x00_dev *rt2x00dev,
 			     struct sk_buff *skb,
 			     struct rxdone_entry_desc *rxdesc)
 {
+	struct link *link = &rt2x00dev->link;
 	struct link_qual *qual = &rt2x00dev->link.qual;
 	struct link_ant *ant = &rt2x00dev->link.ant;
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
@@ -215,9 +281,9 @@ void rt2x00link_update_stats(struct rt2x00_dev *rt2x00dev,
 	/*
 	 * Update global RSSI
 	 */
-	if (qual->avg_rssi)
-		avg_rssi = MOVING_AVERAGE(qual->avg_rssi, rxdesc->rssi, 8);
-	qual->avg_rssi = avg_rssi;
+	if (link->avg_rssi)
+		avg_rssi = MOVING_AVERAGE(link->avg_rssi, rxdesc->rssi, 8);
+	link->avg_rssi = avg_rssi;
 
 	/*
 	 * Update antenna RSSI
@@ -229,21 +295,13 @@ void rt2x00link_update_stats(struct rt2x00_dev *rt2x00dev,
 
 static void rt2x00link_precalculate_signal(struct rt2x00_dev *rt2x00dev)
 {
+	struct link *link = &rt2x00dev->link;
 	struct link_qual *qual = &rt2x00dev->link.qual;
 
-	if (qual->rx_failed || qual->rx_success)
-		qual->rx_percentage =
-		    (qual->rx_success * 100) /
-		    (qual->rx_failed + qual->rx_success);
-	else
-		qual->rx_percentage = 50;
-
-	if (qual->tx_failed || qual->tx_success)
-		qual->tx_percentage =
-		    (qual->tx_success * 100) /
-		    (qual->tx_failed + qual->tx_success);
-	else
-		qual->tx_percentage = 50;
+	link->rx_percentage =
+	    PERCENTAGE(qual->rx_success, qual->rx_failed + qual->rx_success);
+	link->tx_percentage =
+	    PERCENTAGE(qual->tx_success, qual->tx_failed + qual->tx_success);
 
 	qual->rx_success = 0;
 	qual->rx_failed = 0;
@@ -253,7 +311,7 @@ static void rt2x00link_precalculate_signal(struct rt2x00_dev *rt2x00dev)
 
 int rt2x00link_calculate_signal(struct rt2x00_dev *rt2x00dev, int rssi)
 {
-	struct link_qual *qual = &rt2x00dev->link.qual;
+	struct link *link = &rt2x00dev->link;
 	int rssi_percentage = 0;
 	int signal;
 
@@ -267,22 +325,22 @@ int rt2x00link_calculate_signal(struct rt2x00_dev *rt2x00dev, int rssi)
 	 * Calculate the different percentages,
 	 * which will be used for the signal.
 	 */
-	rssi_percentage = (rssi * 100) / rt2x00dev->rssi_offset;
+	rssi_percentage = PERCENTAGE(rssi, rt2x00dev->rssi_offset);
 
 	/*
 	 * Add the individual percentages and use the WEIGHT
 	 * defines to calculate the current link signal.
 	 */
 	signal = ((WEIGHT_RSSI * rssi_percentage) +
-		  (WEIGHT_TX * qual->tx_percentage) +
-		  (WEIGHT_RX * qual->rx_percentage)) / 100;
+		  (WEIGHT_TX * link->tx_percentage) +
+		  (WEIGHT_RX * link->rx_percentage)) / 100;
 
 	return max_t(int, signal, 100);
 }
 
 void rt2x00link_start_tuner(struct rt2x00_dev *rt2x00dev)
 {
-	struct link_qual *qual = &rt2x00dev->link.qual;
+	struct link *link = &rt2x00dev->link;
 
 	/*
 	 * Link tuning should only be performed when
@@ -293,26 +351,13 @@ void rt2x00link_start_tuner(struct rt2x00_dev *rt2x00dev)
 	if (!rt2x00dev->intf_ap_count && !rt2x00dev->intf_sta_count)
 		return;
 
-	/*
-	 * Clear all (possibly) pre-existing quality statistics.
-	 */
-	memset(qual, 0, sizeof(*qual));
-
-	/*
-	 * The RX and TX percentage should start at 50%
-	 * this will assure we will get at least get some
-	 * decent value when the link tuner starts.
-	 * The value will be dropped and overwritten with
-	 * the correct (measured) value anyway during the
-	 * first run of the link tuner.
-	 */
-	qual->rx_percentage = 50;
-	qual->tx_percentage = 50;
+	link->rx_percentage = DEFAULT_PERCENTAGE;
+	link->tx_percentage = DEFAULT_PERCENTAGE;
 
 	rt2x00link_reset_tuner(rt2x00dev, false);
 
 	queue_delayed_work(rt2x00dev->hw->workqueue,
-			   &rt2x00dev->link.work, LINK_TUNE_INTERVAL);
+			   &link->work, LINK_TUNE_INTERVAL);
 }
 
 void rt2x00link_stop_tuner(struct rt2x00_dev *rt2x00dev)
@@ -322,6 +367,8 @@ void rt2x00link_stop_tuner(struct rt2x00_dev *rt2x00dev)
 
 void rt2x00link_reset_tuner(struct rt2x00_dev *rt2x00dev, bool antenna)
 {
+	struct link_qual *qual = &rt2x00dev->link.qual;
+
 	if (!test_bit(DEVICE_STATE_ENABLED_RADIO, &rt2x00dev->flags))
 		return;
 
@@ -334,12 +381,12 @@ void rt2x00link_reset_tuner(struct rt2x00_dev *rt2x00dev, bool antenna)
 	 * first minute after being enabled.
 	 */
 	rt2x00dev->link.count = 0;
-	rt2x00dev->link.vgc_level = 0;
+	memset(qual, 0, sizeof(*qual));
 
 	/*
 	 * Reset the link tuner.
 	 */
-	rt2x00dev->ops->lib->reset_tuner(rt2x00dev);
+	rt2x00dev->ops->lib->reset_tuner(rt2x00dev, qual);
 
 	if (antenna)
 		rt2x00link_antenna_reset(rt2x00dev);
@@ -349,6 +396,7 @@ static void rt2x00link_tuner(struct work_struct *work)
 {
 	struct rt2x00_dev *rt2x00dev =
 	    container_of(work, struct rt2x00_dev, link.work.work);
+	struct link *link = &rt2x00dev->link;
 	struct link_qual *qual = &rt2x00dev->link.qual;
 
 	/*
@@ -365,11 +413,22 @@ static void rt2x00link_tuner(struct work_struct *work)
 	rt2x00dev->low_level_stats.dot11FCSErrorCount += qual->rx_failed;
 
 	/*
+	 * Update quality RSSI for link tuning,
+	 * when we have received some frames and we managed to
+	 * collect the RSSI data we could use this. Otherwise we
+	 * must fallback to the default RSSI value.
+	 */
+	if (!link->avg_rssi || !qual->rx_success)
+		qual->rssi = DEFAULT_RSSI;
+	else
+		qual->rssi = link->avg_rssi;
+
+	/*
 	 * Only perform the link tuning when Link tuning
 	 * has been enabled (This could have been disabled from the EEPROM).
 	 */
 	if (!test_bit(CONFIG_DISABLE_LINK_TUNING, &rt2x00dev->flags))
-		rt2x00dev->ops->lib->link_tuner(rt2x00dev);
+		rt2x00dev->ops->lib->link_tuner(rt2x00dev, qual, link->count);
 
 	/*
 	 * Precalculate a portion of the link signal which is
@@ -380,7 +439,7 @@ static void rt2x00link_tuner(struct work_struct *work)
 	/*
 	 * Send a signal to the led to update the led signal strength.
 	 */
-	rt2x00leds_led_quality(rt2x00dev, qual->avg_rssi);
+	rt2x00leds_led_quality(rt2x00dev, link->avg_rssi);
 
 	/*
 	 * Evaluate antenna setup, make this the last step since this could
@@ -391,9 +450,9 @@ static void rt2x00link_tuner(struct work_struct *work)
 	/*
 	 * Increase tuner counter, and reschedule the next link tuner run.
 	 */
-	rt2x00dev->link.count++;
+	link->count++;
 	queue_delayed_work(rt2x00dev->hw->workqueue,
-			   &rt2x00dev->link.work, LINK_TUNE_INTERVAL);
+			   &link->work, LINK_TUNE_INTERVAL);
 }
 
 void rt2x00link_register(struct rt2x00_dev *rt2x00dev)
diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index abd7b43..2b72010 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -1046,24 +1046,25 @@ static void rt61pci_link_stats(struct rt2x00_dev *rt2x00dev,
 	qual->false_cca = rt2x00_get_field32(reg, STA_CSR1_FALSE_CCA_ERROR);
 }
 
-static inline void rt61pci_set_vgc(struct rt2x00_dev *rt2x00dev, u8 vgc_level)
+static inline void rt61pci_set_vgc(struct rt2x00_dev *rt2x00dev,
+				   struct link_qual *qual, u8 vgc_level)
 {
-	if (rt2x00dev->link.vgc_level != vgc_level) {
+	if (qual->vgc_level != vgc_level) {
 		rt61pci_bbp_write(rt2x00dev, 17, vgc_level);
-		rt2x00dev->link.vgc_level = vgc_level;
-		rt2x00dev->link.vgc_level_reg = vgc_level;
+		qual->vgc_level = vgc_level;
+		qual->vgc_level_reg = vgc_level;
 	}
 }
 
-static void rt61pci_reset_tuner(struct rt2x00_dev *rt2x00dev)
+static void rt61pci_reset_tuner(struct rt2x00_dev *rt2x00dev,
+				struct link_qual *qual)
 {
-	rt61pci_set_vgc(rt2x00dev, 0x20);
+	rt61pci_set_vgc(rt2x00dev, qual, 0x20);
 }
 
-static void rt61pci_link_tuner(struct rt2x00_dev *rt2x00dev)
+static void rt61pci_link_tuner(struct rt2x00_dev *rt2x00dev,
+			       struct link_qual *qual, const u32 count)
 {
-	struct link *link = &rt2x00dev->link;
-	int rssi = rt2x00_get_link_rssi(link);
 	u8 up_bound;
 	u8 low_bound;
 
@@ -1096,32 +1097,32 @@ static void rt61pci_link_tuner(struct rt2x00_dev *rt2x00dev)
 	/*
 	 * Special big-R17 for very short distance
 	 */
-	if (rssi >= -35) {
-		rt61pci_set_vgc(rt2x00dev, 0x60);
+	if (qual->rssi >= -35) {
+		rt61pci_set_vgc(rt2x00dev, qual, 0x60);
 		return;
 	}
 
 	/*
 	 * Special big-R17 for short distance
 	 */
-	if (rssi >= -58) {
-		rt61pci_set_vgc(rt2x00dev, up_bound);
+	if (qual->rssi >= -58) {
+		rt61pci_set_vgc(rt2x00dev, qual, up_bound);
 		return;
 	}
 
 	/*
 	 * Special big-R17 for middle-short distance
 	 */
-	if (rssi >= -66) {
-		rt61pci_set_vgc(rt2x00dev, low_bound + 0x10);
+	if (qual->rssi >= -66) {
+		rt61pci_set_vgc(rt2x00dev, qual, low_bound + 0x10);
 		return;
 	}
 
 	/*
 	 * Special mid-R17 for middle distance
 	 */
-	if (rssi >= -74) {
-		rt61pci_set_vgc(rt2x00dev, low_bound + 0x08);
+	if (qual->rssi >= -74) {
+		rt61pci_set_vgc(rt2x00dev, qual, low_bound + 0x08);
 		return;
 	}
 
@@ -1129,12 +1130,12 @@ static void rt61pci_link_tuner(struct rt2x00_dev *rt2x00dev)
 	 * Special case: Change up_bound based on the rssi.
 	 * Lower up_bound when rssi is weaker then -74 dBm.
 	 */
-	up_bound -= 2 * (-74 - rssi);
+	up_bound -= 2 * (-74 - qual->rssi);
 	if (low_bound > up_bound)
 		up_bound = low_bound;
 
-	if (link->vgc_level > up_bound) {
-		rt61pci_set_vgc(rt2x00dev, up_bound);
+	if (qual->vgc_level > up_bound) {
+		rt61pci_set_vgc(rt2x00dev, qual, up_bound);
 		return;
 	}
 
@@ -1144,10 +1145,10 @@ dynamic_cca_tune:
 	 * r17 does not yet exceed upper limit, continue and base
 	 * the r17 tuning on the false CCA count.
 	 */
-	if ((link->qual.false_cca > 512) && (link->vgc_level < up_bound))
-		rt61pci_set_vgc(rt2x00dev, ++link->vgc_level);
-	else if ((link->qual.false_cca < 100) && (link->vgc_level > low_bound))
-		rt61pci_set_vgc(rt2x00dev, --link->vgc_level);
+	if ((qual->false_cca > 512) && (qual->vgc_level < up_bound))
+		rt61pci_set_vgc(rt2x00dev, qual, ++qual->vgc_level);
+	else if ((qual->false_cca < 100) && (qual->vgc_level > low_bound))
+		rt61pci_set_vgc(rt2x00dev, qual, --qual->vgc_level);
 }
 
 /*
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index 49fd42a..5992c8f 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -924,24 +924,25 @@ static void rt73usb_link_stats(struct rt2x00_dev *rt2x00dev,
 	qual->false_cca = rt2x00_get_field32(reg, STA_CSR1_FALSE_CCA_ERROR);
 }
 
-static inline void rt73usb_set_vgc(struct rt2x00_dev *rt2x00dev, u8 vgc_level)
+static inline void rt73usb_set_vgc(struct rt2x00_dev *rt2x00dev,
+				   struct link_qual *qual, u8 vgc_level)
 {
-	if (rt2x00dev->link.vgc_level != vgc_level) {
+	if (qual->vgc_level != vgc_level) {
 		rt73usb_bbp_write(rt2x00dev, 17, vgc_level);
-		rt2x00dev->link.vgc_level = vgc_level;
-		rt2x00dev->link.vgc_level_reg = vgc_level;
+		qual->vgc_level = vgc_level;
+		qual->vgc_level_reg = vgc_level;
 	}
 }
 
-static void rt73usb_reset_tuner(struct rt2x00_dev *rt2x00dev)
+static void rt73usb_reset_tuner(struct rt2x00_dev *rt2x00dev,
+				struct link_qual *qual)
 {
-	rt73usb_set_vgc(rt2x00dev, 0x20);
+	rt73usb_set_vgc(rt2x00dev, qual, 0x20);
 }
 
-static void rt73usb_link_tuner(struct rt2x00_dev *rt2x00dev)
+static void rt73usb_link_tuner(struct rt2x00_dev *rt2x00dev,
+			       struct link_qual *qual, const u32 count)
 {
-	struct link *link = &rt2x00dev->link;
-	int rssi = rt2x00_get_link_rssi(link);
 	u8 up_bound;
 	u8 low_bound;
 
@@ -957,10 +958,10 @@ static void rt73usb_link_tuner(struct rt2x00_dev *rt2x00dev)
 			up_bound += 0x10;
 		}
 	} else {
-		if (rssi > -82) {
+		if (qual->rssi > -82) {
 			low_bound = 0x1c;
 			up_bound = 0x40;
-		} else if (rssi > -84) {
+		} else if (qual->rssi > -84) {
 			low_bound = 0x1c;
 			up_bound = 0x20;
 		} else {
@@ -984,32 +985,32 @@ static void rt73usb_link_tuner(struct rt2x00_dev *rt2x00dev)
 	/*
 	 * Special big-R17 for very short distance
 	 */
-	if (rssi > -35) {
-		rt73usb_set_vgc(rt2x00dev, 0x60);
+	if (qual->rssi > -35) {
+		rt73usb_set_vgc(rt2x00dev, qual, 0x60);
 		return;
 	}
 
 	/*
 	 * Special big-R17 for short distance
 	 */
-	if (rssi >= -58) {
-		rt73usb_set_vgc(rt2x00dev, up_bound);
+	if (qual->rssi >= -58) {
+		rt73usb_set_vgc(rt2x00dev, qual, up_bound);
 		return;
 	}
 
 	/*
 	 * Special big-R17 for middle-short distance
 	 */
-	if (rssi >= -66) {
-		rt73usb_set_vgc(rt2x00dev, low_bound + 0x10);
+	if (qual->rssi >= -66) {
+		rt73usb_set_vgc(rt2x00dev, qual, low_bound + 0x10);
 		return;
 	}
 
 	/*
 	 * Special mid-R17 for middle distance
 	 */
-	if (rssi >= -74) {
-		rt73usb_set_vgc(rt2x00dev, low_bound + 0x08);
+	if (qual->rssi >= -74) {
+		rt73usb_set_vgc(rt2x00dev, qual, low_bound + 0x08);
 		return;
 	}
 
@@ -1017,12 +1018,12 @@ static void rt73usb_link_tuner(struct rt2x00_dev *rt2x00dev)
 	 * Special case: Change up_bound based on the rssi.
 	 * Lower up_bound when rssi is weaker then -74 dBm.
 	 */
-	up_bound -= 2 * (-74 - rssi);
+	up_bound -= 2 * (-74 - qual->rssi);
 	if (low_bound > up_bound)
 		up_bound = low_bound;
 
-	if (link->vgc_level > up_bound) {
-		rt73usb_set_vgc(rt2x00dev, up_bound);
+	if (qual->vgc_level > up_bound) {
+		rt73usb_set_vgc(rt2x00dev, qual, up_bound);
 		return;
 	}
 
@@ -1032,12 +1033,12 @@ dynamic_cca_tune:
 	 * r17 does not yet exceed upper limit, continue and base
 	 * the r17 tuning on the false CCA count.
 	 */
-	if ((link->qual.false_cca > 512) && (link->vgc_level < up_bound))
-		rt73usb_set_vgc(rt2x00dev,
-				min_t(u8, link->vgc_level + 4, up_bound));
-	else if ((link->qual.false_cca < 100) && (link->vgc_level > low_bound))
-		rt73usb_set_vgc(rt2x00dev,
-				max_t(u8, link->vgc_level - 4, low_bound));
+	if ((qual->false_cca > 512) && (qual->vgc_level < up_bound))
+		rt73usb_set_vgc(rt2x00dev, qual,
+				min_t(u8, qual->vgc_level + 4, up_bound));
+	else if ((qual->false_cca < 100) && (qual->vgc_level > low_bound))
+		rt73usb_set_vgc(rt2x00dev, qual,
+				max_t(u8, qual->vgc_level - 4, low_bound));
 }
 
 /*
-- 
1.5.6.1

