Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:48460 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753491Ab3JIJBO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Oct 2013 05:01:14 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH] rt2x00: use generic EWMA functions for average RSSI calculations
Date: Wed,  9 Oct 2013 11:00:38 +0200
Message-Id: <1381309238-9975-1-git-send-email-juhosg@openwrt.org> (sfid-20131009_110119_016510_97AA57B6)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove the local MOVING_AVERAGE implementation, and use
the generic EWMA functions instead.

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 drivers/net/wireless/rt2x00/Kconfig      |    1 +
 drivers/net/wireless/rt2x00/rt2x00.h     |   16 ++-----
 drivers/net/wireless/rt2x00/rt2x00link.c |   70 +++++++++++-------------------
 3 files changed, 29 insertions(+), 58 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/Kconfig b/drivers/net/wireless/rt2x00/Kconfig
index 68dbbb9..a18b005 100644
--- a/drivers/net/wireless/rt2x00/Kconfig
+++ b/drivers/net/wireless/rt2x00/Kconfig
@@ -219,6 +219,7 @@ config RT2X00_LIB_USB
 
 config RT2X00_LIB
 	tristate
+	select AVERAGE
 
 config RT2X00_LIB_FIRMWARE
 	boolean
diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index fe4c572..30ed92a 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -39,6 +39,7 @@
 #include <linux/input-polldev.h>
 #include <linux/kfifo.h>
 #include <linux/hrtimer.h>
+#include <linux/average.h>
 
 #include <net/mac80211.h>
 
@@ -138,17 +139,6 @@
 #define SHORT_EIFS		( SIFS + SHORT_DIFS + \
 				  GET_DURATION(IEEE80211_HEADER + ACK_SIZE, 10) )
 
-/*
- * Structure for average calculation
- * The avg field contains the actual average value,
- * but avg_weight is internally used during calculations
- * to prevent rounding errors.
- */
-struct avg_val {
-	int avg;
-	int avg_weight;
-};
-
 enum rt2x00_chip_intf {
 	RT2X00_CHIP_INTF_PCI,
 	RT2X00_CHIP_INTF_PCIE,
@@ -297,7 +287,7 @@ struct link_ant {
 	 * Similar to the avg_rssi in the link_qual structure
 	 * this value is updated by using the walking average.
 	 */
-	struct avg_val rssi_ant;
+	struct ewma rssi_ant;
 };
 
 /*
@@ -326,7 +316,7 @@ struct link {
 	/*
 	 * Currently active average RSSI value
 	 */
-	struct avg_val avg_rssi;
+	struct ewma avg_rssi;
 
 	/*
 	 * Work structure for scheduling periodic link tuning.
diff --git a/drivers/net/wireless/rt2x00/rt2x00link.c b/drivers/net/wireless/rt2x00/rt2x00link.c
index 8368aab..a0e3c02 100644
--- a/drivers/net/wireless/rt2x00/rt2x00link.c
+++ b/drivers/net/wireless/rt2x00/rt2x00link.c
@@ -35,50 +35,28 @@
  */
 #define DEFAULT_RSSI		-128
 
-/*
- * Helper struct and macro to work with moving/walking averages.
- * When adding a value to the average value the following calculation
- * is needed:
- *
- *        avg_rssi = ((avg_rssi * 7) + rssi) / 8;
- *
- * The advantage of this approach is that we only need 1 variable
- * to store the average in (No need for a count and a total).
- * But more importantly, normal average values will over time
- * move less and less towards newly added values this results
- * that with link tuning, the device can have a very good RSSI
- * for a few minutes but when the device is moved away from the AP
- * the average will not decrease fast enough to compensate.
- * The walking average compensates this and will move towards
- * the new values correctly allowing a effective link tuning,
- * the speed of the average moving towards other values depends
- * on the value for the number of samples. The higher the number
- * of samples, the slower the average will move.
- * We use two variables to keep track of the average value to
- * compensate for the rounding errors. This can be a significant
- * error (>5dBm) if the factor is too low.
- */
-#define AVG_SAMPLES	8
-#define AVG_FACTOR	1000
-#define MOVING_AVERAGE(__avg, __val) \
-({ \
-	struct avg_val __new; \
-	__new.avg_weight = \
-	    (__avg).avg_weight  ? \
-		((((__avg).avg_weight * ((AVG_SAMPLES) - 1)) + \
-		  ((__val) * (AVG_FACTOR))) / \
-		 (AVG_SAMPLES)) : \
-		((__val) * (AVG_FACTOR)); \
-	__new.avg = __new.avg_weight / (AVG_FACTOR); \
-	__new; \
-})
+/* Constants for EWMA calculations. */
+#define RT2X00_EWMA_FACTOR	1024
+#define RT2X00_EWMA_WEIGHT	8
+
+static inline int rt2x00link_get_avg_rssi(struct ewma *ewma)
+{
+	unsigned long avg;
+
+	avg = ewma_read(ewma);
+	if (avg)
+		return -avg;
+
+	return DEFAULT_RSSI;
+}
 
 static int rt2x00link_antenna_get_link_rssi(struct rt2x00_dev *rt2x00dev)
 {
 	struct link_ant *ant = &rt2x00dev->link.ant;
 
-	if (ant->rssi_ant.avg && rt2x00dev->link.qual.rx_success)
-		return ant->rssi_ant.avg;
+	if (rt2x00dev->link.qual.rx_success)
+		return rt2x00link_get_avg_rssi(&ant->rssi_ant);
+
 	return DEFAULT_RSSI;
 }
 
@@ -100,8 +78,8 @@ static void rt2x00link_antenna_update_rssi_history(struct rt2x00_dev *rt2x00dev,
 
 static void rt2x00link_antenna_reset(struct rt2x00_dev *rt2x00dev)
 {
-	rt2x00dev->link.ant.rssi_ant.avg = 0;
-	rt2x00dev->link.ant.rssi_ant.avg_weight = 0;
+	ewma_init(&rt2x00dev->link.ant.rssi_ant, RT2X00_EWMA_FACTOR,
+		  RT2X00_EWMA_WEIGHT);
 }
 
 static void rt2x00lib_antenna_diversity_sample(struct rt2x00_dev *rt2x00dev)
@@ -249,12 +227,12 @@ void rt2x00link_update_stats(struct rt2x00_dev *rt2x00dev,
 	/*
 	 * Update global RSSI
 	 */
-	link->avg_rssi = MOVING_AVERAGE(link->avg_rssi, rxdesc->rssi);
+	ewma_add(&link->avg_rssi, -rxdesc->rssi);
 
 	/*
 	 * Update antenna RSSI
 	 */
-	ant->rssi_ant = MOVING_AVERAGE(ant->rssi_ant, rxdesc->rssi);
+	ewma_add(&ant->rssi_ant, -rxdesc->rssi);
 }
 
 void rt2x00link_start_tuner(struct rt2x00_dev *rt2x00dev)
@@ -309,6 +287,8 @@ void rt2x00link_reset_tuner(struct rt2x00_dev *rt2x00dev, bool antenna)
 	 */
 	rt2x00dev->link.count = 0;
 	memset(qual, 0, sizeof(*qual));
+	ewma_init(&rt2x00dev->link.avg_rssi, RT2X00_EWMA_FACTOR,
+		  RT2X00_EWMA_WEIGHT);
 
 	/*
 	 * Restore the VGC level as stored in the registers,
@@ -363,10 +343,10 @@ static void rt2x00link_tuner(struct work_struct *work)
 	 * collect the RSSI data we could use this. Otherwise we
 	 * must fallback to the default RSSI value.
 	 */
-	if (!link->avg_rssi.avg || !qual->rx_success)
+	if (!qual->rx_success)
 		qual->rssi = DEFAULT_RSSI;
 	else
-		qual->rssi = link->avg_rssi.avg;
+		qual->rssi = rt2x00link_get_avg_rssi(&link->avg_rssi);
 
 	/*
 	 * Check if link tuning is supported by the hardware, some hardware
-- 
1.7.10
