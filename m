Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.25]:47646 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752402AbZHHV4L (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 8 Aug 2009 17:56:11 -0400
Received: by ey-out-2122.google.com with SMTP id 9so695183eyd.37
        for <linux-wireless@vger.kernel.org>; Sat, 08 Aug 2009 14:56:12 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH 5/7] rt2x00: Fix rounding errors in RSSI average calculation
Date: Sat, 8 Aug 2009 23:54:51 +0200
Cc: users@rt2x00.serialmonkey.com,
	"linux-wireless" <linux-wireless@vger.kernel.org>,
	Lars Ericsson <Lars_Ericsson@telia.com>
References: <200908082353.04274.IvDoorn@gmail.com> <200908082353.47835.IvDoorn@gmail.com> <200908082354.24733.IvDoorn@gmail.com>
In-Reply-To: <200908082354.24733.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200908082354.51745.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Lars Ericsson <Lars_Ericsson@telia.com>

Small changes in signal level was not detected up by the
MOVING_AVERAGE() due to a rounding error, using 'int' type.

rt2x00lib_antenna_diversity_eval:
rssi:	  -62 -62 -62 -62 -62 -62 -62 -62 -62 -62 -62 -62 -62 -62 -62
rssi_avg: -57 -57 -57 -57 -57 -57 -57 -57 -57 -57 -57 -57 -57 -57 -57

The signal level reported back could be significantly (5dBm)
different from the actual value. A level +3dBm is the same as
double the AP output power.

Signed-off-by: Lars Ericsson <Lars_Ericsson@telia.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00.h     |   15 ++++++-
 drivers/net/wireless/rt2x00/rt2x00link.c |   65 ++++++++++++++++++------------
 2 files changed, 52 insertions(+), 28 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index aa3ff0a..19ca146 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -134,6 +134,17 @@
 				  GET_DURATION(IEEE80211_HEADER + ACK_SIZE, 10) )
 
 /*
+ * Structure for average calculation
+ * The avg field contains the actual average value,
+ * but avg_weight is internally used during calculations
+ * to prevent rounding errors.
+ */
+struct avg_val {
+	int avg;
+	int avg_weight;
+};
+
+/*
  * Chipset identification
  * The chipset on the device is composed of a RT and RF chip.
  * The chipset combination is important for determining device capabilities.
@@ -256,7 +267,7 @@ struct link_ant {
 	 * Similar to the avg_rssi in the link_qual structure
 	 * this value is updated by using the walking average.
 	 */
-	int rssi_ant;
+	struct avg_val rssi_ant;
 };
 
 /*
@@ -285,7 +296,7 @@ struct link {
 	/*
 	 * Currently active average RSSI value
 	 */
-	int avg_rssi;
+	struct avg_val avg_rssi;
 
 	/*
 	 * Currently precalculated percentages of successful
diff --git a/drivers/net/wireless/rt2x00/rt2x00link.c b/drivers/net/wireless/rt2x00/rt2x00link.c
index dd68f3a..c64db0b 100644
--- a/drivers/net/wireless/rt2x00/rt2x00link.c
+++ b/drivers/net/wireless/rt2x00/rt2x00link.c
@@ -46,7 +46,15 @@
 #define DEFAULT_PERCENTAGE	50
 
 /*
- * Small helper macro to work with moving/walking averages.
+ * Small helper macro for percentage calculation
+ * This is a very simple macro with the only catch that it will
+ * produce a default value in case no total value was provided.
+ */
+#define PERCENTAGE(__value, __total) \
+	( (__total) ? (((__value) * 100) / (__total)) : (DEFAULT_PERCENTAGE) )
+
+/*
+ * Helper struct and macro to work with moving/walking averages.
  * When adding a value to the average value the following calculation
  * is needed:
  *
@@ -60,18 +68,28 @@
  * for a few minutes but when the device is moved away from the AP
  * the average will not decrease fast enough to compensate.
  * The walking average compensates this and will move towards
- * the new values correctly allowing a effective link tuning.
+ * the new values correctly allowing a effective link tuning,
+ * the speed of the average moving towards other values depends
+ * on the value for the number of samples. The higher the number
+ * of samples, the slower the average will move.
+ * We use two variables to keep track of the average value to
+ * compensate for the rounding errors. This can be a significant
+ * error (>5dBm) if the factor is too low.
  */
-#define MOVING_AVERAGE(__avg, __val, __samples) \
-	( (((__avg) * ((__samples) - 1)) + (__val)) / (__samples) )
-
-/*
- * Small helper macro for percentage calculation
- * This is a very simple macro with the only catch that it will
- * produce a default value in case no total value was provided.
- */
-#define PERCENTAGE(__value, __total) \
-	( (__total) ? (((__value) * 100) / (__total)) : (DEFAULT_PERCENTAGE) )
+#define AVG_SAMPLES	8
+#define AVG_FACTOR	1000
+#define MOVING_AVERAGE(__avg, __val) \
+({ \
+	struct avg_val __new; \
+	__new.avg_weight = \
+	    (__avg).avg_weight  ? \
+		((((__avg).avg_weight * ((AVG_SAMPLES) - 1)) + \
+		  ((__val) * (AVG_FACTOR))) / \
+		 (AVG_SAMPLES) ) : \
+		((__val) * (AVG_FACTOR)); \
+	__new.avg = __new.avg_weight / (AVG_FACTOR); \
+	__new; \
+})
 
 /*
  * For calculating the Signal quality we have determined
@@ -98,8 +116,8 @@ static int rt2x00link_antenna_get_link_rssi(struct rt2x00_dev *rt2x00dev)
 {
 	struct link_ant *ant = &rt2x00dev->link.ant;
 
-	if (ant->rssi_ant && rt2x00dev->link.qual.rx_success)
-		return ant->rssi_ant;
+	if (ant->rssi_ant.avg && rt2x00dev->link.qual.rx_success)
+		return ant->rssi_ant.avg;
 	return DEFAULT_RSSI;
 }
 
@@ -121,7 +139,8 @@ static void rt2x00link_antenna_update_rssi_history(struct rt2x00_dev *rt2x00dev,
 
 static void rt2x00link_antenna_reset(struct rt2x00_dev *rt2x00dev)
 {
-	rt2x00dev->link.ant.rssi_ant = 0;
+	rt2x00dev->link.ant.rssi_ant.avg = 0;
+	rt2x00dev->link.ant.rssi_ant.avg_weight = 0;
 }
 
 static void rt2x00lib_antenna_diversity_sample(struct rt2x00_dev *rt2x00dev)
@@ -258,8 +277,6 @@ void rt2x00link_update_stats(struct rt2x00_dev *rt2x00dev,
 	struct link_qual *qual = &rt2x00dev->link.qual;
 	struct link_ant *ant = &rt2x00dev->link.ant;
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
-	int avg_rssi = rxdesc->rssi;
-	int ant_rssi = rxdesc->rssi;
 
 	/*
 	 * Frame was received successfully since non-succesfull
@@ -279,16 +296,12 @@ void rt2x00link_update_stats(struct rt2x00_dev *rt2x00dev,
 	/*
 	 * Update global RSSI
 	 */
-	if (link->avg_rssi)
-		avg_rssi = MOVING_AVERAGE(link->avg_rssi, rxdesc->rssi, 8);
-	link->avg_rssi = avg_rssi;
+	link->avg_rssi = MOVING_AVERAGE(link->avg_rssi, rxdesc->rssi);
 
 	/*
 	 * Update antenna RSSI
 	 */
-	if (ant->rssi_ant)
-		ant_rssi = MOVING_AVERAGE(ant->rssi_ant, rxdesc->rssi, 8);
-	ant->rssi_ant = ant_rssi;
+	ant->rssi_ant = MOVING_AVERAGE(ant->rssi_ant, rxdesc->rssi);
 }
 
 static void rt2x00link_precalculate_signal(struct rt2x00_dev *rt2x00dev)
@@ -421,10 +434,10 @@ static void rt2x00link_tuner(struct work_struct *work)
 	 * collect the RSSI data we could use this. Otherwise we
 	 * must fallback to the default RSSI value.
 	 */
-	if (!link->avg_rssi || !qual->rx_success)
+	if (!link->avg_rssi.avg || !qual->rx_success)
 		qual->rssi = DEFAULT_RSSI;
 	else
-		qual->rssi = link->avg_rssi;
+		qual->rssi = link->avg_rssi.avg;
 
 	/*
 	 * Only perform the link tuning when Link tuning
@@ -442,7 +455,7 @@ static void rt2x00link_tuner(struct work_struct *work)
 	/*
 	 * Send a signal to the led to update the led signal strength.
 	 */
-	rt2x00leds_led_quality(rt2x00dev, link->avg_rssi);
+	rt2x00leds_led_quality(rt2x00dev, qual->rssi);
 
 	/*
 	 * Evaluate antenna setup, make this the last step when
-- 
1.6.3.3

