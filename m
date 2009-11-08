Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.25]:46807 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752408AbZKHNhq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Nov 2009 08:37:46 -0500
Received: by ey-out-2122.google.com with SMTP id 25so3696eya.19
        for <linux-wireless@vger.kernel.org>; Sun, 08 Nov 2009 05:37:51 -0800 (PST)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] rt2x00: Remove deprecated ieee80211_rx_status->qual usage
Date: Sun, 8 Nov 2009 14:37:48 +0100
Cc: linux-wireless@vger.kernel.org,
	rt2x00 Core Developers List <coredev@rt2x00.serialmonkey.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200911081437.49121.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ieee80211_rx_status->qual has been marked deprecated.
This allows us to remove several functions and fields which
were used to calculate a reasonable value for it.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00.h     |    7 ---
 drivers/net/wireless/rt2x00/rt2x00dev.c  |    1 -
 drivers/net/wireless/rt2x00/rt2x00lib.h  |   13 -----
 drivers/net/wireless/rt2x00/rt2x00link.c |   88 ------------------------------
 4 files changed, 0 insertions(+), 109 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index c83dbae..1a84574 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -313,13 +313,6 @@ struct link {
 	struct avg_val avg_rssi;
 
 	/*
-	 * Currently precalculated percentages of successful
-	 * TX and RX frames.
-	 */
-	int rx_percentage;
-	int tx_percentage;
-
-	/*
 	 * Work structure for scheduling periodic link tuning.
 	 */
 	struct delayed_work work;
diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index 73bbec5..00bfb22 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -430,7 +430,6 @@ void rt2x00lib_rxdone(struct rt2x00_dev *rt2x00dev,
 
 	rx_status->mactime = rxdesc.timestamp;
 	rx_status->rate_idx = rate_idx;
-	rx_status->qual = rt2x00link_calculate_signal(rt2x00dev, rxdesc.rssi);
 	rx_status->signal = rxdesc.rssi;
 	rx_status->noise = rxdesc.noise;
 	rx_status->flag = rxdesc.flags;
diff --git a/drivers/net/wireless/rt2x00/rt2x00lib.h b/drivers/net/wireless/rt2x00/rt2x00lib.h
index 567f029..e170165 100644
--- a/drivers/net/wireless/rt2x00/rt2x00lib.h
+++ b/drivers/net/wireless/rt2x00/rt2x00lib.h
@@ -223,19 +223,6 @@ void rt2x00link_update_stats(struct rt2x00_dev *rt2x00dev,
 			     struct rxdone_entry_desc *rxdesc);
 
 /**
- * rt2x00link_calculate_signal - Calculate signal quality
- * @rt2x00dev: Pointer to &struct rt2x00_dev.
- * @rssi: RX Frame RSSI
- *
- * Calculate the signal quality of a frame based on the rssi
- * measured during the receiving of the frame and the global
- * link quality statistics measured since the start of the
- * link tuning. The result is a value between 0 and 100 which
- * is an indication of the signal quality.
- */
-int rt2x00link_calculate_signal(struct rt2x00_dev *rt2x00dev, int rssi);
-
-/**
  * rt2x00link_start_tuner - Start periodic link tuner work
  * @rt2x00dev: Pointer to &struct rt2x00_dev.
  *
diff --git a/drivers/net/wireless/rt2x00/rt2x00link.c b/drivers/net/wireless/rt2x00/rt2x00link.c
index c708d0b..f918f29 100644
--- a/drivers/net/wireless/rt2x00/rt2x00link.c
+++ b/drivers/net/wireless/rt2x00/rt2x00link.c
@@ -36,24 +36,6 @@
 #define DEFAULT_RSSI		-128
 
 /*
- * When no TX/RX percentage could be calculated due to lack of
- * frames on the air, we fallback to a percentage of 50%.
- * This will assure we will get at least get some decent value
- * when the link tuner starts.
- * The value will be dropped and overwritten with the correct (measured)
- * value anyway during the first run of the link tuner.
- */
-#define DEFAULT_PERCENTAGE	50
-
-/*
- * Small helper macro for percentage calculation
- * This is a very simple macro with the only catch that it will
- * produce a default value in case no total value was provided.
- */
-#define PERCENTAGE(__value, __total) \
-	( (__total) ? (((__value) * 100) / (__total)) : (DEFAULT_PERCENTAGE) )
-
-/*
  * Helper struct and macro to work with moving/walking averages.
  * When adding a value to the average value the following calculation
  * is needed:
@@ -91,27 +73,6 @@
 	__new; \
 })
 
-/*
- * For calculating the Signal quality we have determined
- * the total number of success and failed RX and TX frames.
- * With the addition of the average RSSI value we can determine
- * the link quality using the following algorithm:
- *
- *         rssi_percentage = (avg_rssi * 100) / rssi_offset
- *         rx_percentage = (rx_success * 100) / rx_total
- *         tx_percentage = (tx_success * 100) / tx_total
- *         avg_signal = ((WEIGHT_RSSI * avg_rssi) +
- *                       (WEIGHT_TX * tx_percentage) +
- *                       (WEIGHT_RX * rx_percentage)) / 100
- *
- * This value should then be checked to not be greater then 100.
- * This means the values of WEIGHT_RSSI, WEIGHT_RX, WEIGHT_TX must
- * sum up to 100 as well.
- */
-#define WEIGHT_RSSI	20
-#define WEIGHT_RX	40
-#define WEIGHT_TX	40
-
 static int rt2x00link_antenna_get_link_rssi(struct rt2x00_dev *rt2x00dev)
 {
 	struct link_ant *ant = &rt2x00dev->link.ant;
@@ -304,46 +265,6 @@ void rt2x00link_update_stats(struct rt2x00_dev *rt2x00dev,
 	ant->rssi_ant = MOVING_AVERAGE(ant->rssi_ant, rxdesc->rssi);
 }
 
-static void rt2x00link_precalculate_signal(struct rt2x00_dev *rt2x00dev)
-{
-	struct link *link = &rt2x00dev->link;
-	struct link_qual *qual = &rt2x00dev->link.qual;
-
-	link->rx_percentage =
-	    PERCENTAGE(qual->rx_success, qual->rx_failed + qual->rx_success);
-	link->tx_percentage =
-	    PERCENTAGE(qual->tx_success, qual->tx_failed + qual->tx_success);
-}
-
-int rt2x00link_calculate_signal(struct rt2x00_dev *rt2x00dev, int rssi)
-{
-	struct link *link = &rt2x00dev->link;
-	int rssi_percentage = 0;
-	int signal;
-
-	/*
-	 * We need a positive value for the RSSI.
-	 */
-	if (rssi < 0)
-		rssi += rt2x00dev->rssi_offset;
-
-	/*
-	 * Calculate the different percentages,
-	 * which will be used for the signal.
-	 */
-	rssi_percentage = PERCENTAGE(rssi, rt2x00dev->rssi_offset);
-
-	/*
-	 * Add the individual percentages and use the WEIGHT
-	 * defines to calculate the current link signal.
-	 */
-	signal = ((WEIGHT_RSSI * rssi_percentage) +
-		  (WEIGHT_TX * link->tx_percentage) +
-		  (WEIGHT_RX * link->rx_percentage)) / 100;
-
-	return max_t(int, signal, 100);
-}
-
 void rt2x00link_start_tuner(struct rt2x00_dev *rt2x00dev)
 {
 	struct link *link = &rt2x00dev->link;
@@ -357,9 +278,6 @@ void rt2x00link_start_tuner(struct rt2x00_dev *rt2x00dev)
 	if (!rt2x00dev->intf_ap_count && !rt2x00dev->intf_sta_count)
 		return;
 
-	link->rx_percentage = DEFAULT_PERCENTAGE;
-	link->tx_percentage = DEFAULT_PERCENTAGE;
-
 	rt2x00link_reset_tuner(rt2x00dev, false);
 
 	if (test_bit(DEVICE_STATE_PRESENT, &rt2x00dev->flags))
@@ -448,12 +366,6 @@ static void rt2x00link_tuner(struct work_struct *work)
 		rt2x00dev->ops->lib->link_tuner(rt2x00dev, qual, link->count);
 
 	/*
-	 * Precalculate a portion of the link signal which is
-	 * in based on the tx/rx success/failure counters.
-	 */
-	rt2x00link_precalculate_signal(rt2x00dev);
-
-	/*
 	 * Send a signal to the led to update the led signal strength.
 	 */
 	rt2x00leds_led_quality(rt2x00dev, qual->rssi);
-- 
1.6.4.1

