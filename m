Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.250]:52973 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751405AbXIPMH7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 16 Sep 2007 08:07:59 -0400
Received: by an-out-0708.google.com with SMTP id d31so189208and
        for <linux-wireless@vger.kernel.org>; Sun, 16 Sep 2007 05:07:59 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 6/24] rt2x00: Recalculate link quality
Date: Sun, 16 Sep 2007 14:18:16 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200709161403.11332.IvDoorn@gmail.com>
In-Reply-To: <200709161403.11332.IvDoorn@gmail.com>
MIME-Version: 1.0
Message-Id: <200709161418.18491.IvDoorn@gmail.com>
Content-Type: text/plain;
  charset="utf-8"
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Split link quality calculation up into 2 parts:
 - calculate once per second the TX and RX success percentage
 - calculate per frame the total quality based on the TX and RX
   success percentage and the RSSI of the current frame.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00.h    |   14 +++++++
 drivers/net/wireless/rt2x00/rt2x00dev.c |   65 +++++++++++++++----------------
 2 files changed, 45 insertions(+), 34 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index a7527cd..1f5b3cb 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -231,8 +231,10 @@ struct link {
 	 *
 	 * This value should then be checked to not be greated then 100.
 	 */
+	int rx_percentage;
 	int rx_success;
 	int rx_failed;
+	int tx_percentage;
 	int tx_success;
 	int tx_failed;
 #define WEIGHT_RSSI	20
@@ -246,6 +248,18 @@ struct link {
 };
 
 /*
+ * Clear all counters inside the link structure.
+ * This can be easiest achieved by memsetting everything
+ * except for the work structure at the end.
+ */
+static inline void rt2x00_clear_link(struct link *link)
+{
+	memset(link, 0x00, sizeof(*link) - sizeof(link->work));
+	link->rx_percentage = 50;
+	link->tx_percentage = 50;
+}
+
+/*
  * Update the rssi using the walking average approach.
  */
 static inline void rt2x00_update_link_rssi(struct link *link, int rssi)
diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index f2adaf5..09c31e3 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -69,14 +69,7 @@ EXPORT_SYMBOL_GPL(rt2x00lib_get_ring);
  */
 static void rt2x00lib_start_link_tuner(struct rt2x00_dev *rt2x00dev)
 {
-	rt2x00dev->link.count = 0;
-	rt2x00dev->link.avg_rssi = 0;
-	rt2x00dev->link.vgc_level = 0;
-	rt2x00dev->link.false_cca = 0;
-	rt2x00dev->link.rx_success = 0;
-	rt2x00dev->link.rx_failed = 0;
-	rt2x00dev->link.tx_success = 0;
-	rt2x00dev->link.tx_failed = 0;
+	rt2x00_clear_link(&rt2x00dev->link);
 
 	/*
 	 * Reset the link tuner.
@@ -184,13 +177,32 @@ void rt2x00lib_toggle_rx(struct rt2x00_dev *rt2x00dev, int enable)
 		rt2x00lib_start_link_tuner(rt2x00dev);
 }
 
-static int rt2x00lib_calculate_link_signal(struct rt2x00_dev *rt2x00dev)
+static void rt2x00lib_precalculate_link_signal(struct link *link)
+{
+	if (link->rx_failed || link->rx_success)
+		link->rx_percentage =
+		    (link->rx_success * 100) /
+		    (link->rx_failed + link->rx_success);
+	else
+		link->rx_percentage = 50;
+
+	if (link->tx_failed || link->tx_success)
+		link->tx_percentage =
+		    (link->tx_success * 100) /
+		    (link->tx_failed + link->tx_success);
+	else
+		link->tx_percentage = 50;
+
+	link->rx_success = 0;
+	link->rx_failed = 0;
+	link->tx_success = 0;
+	link->tx_failed = 0;
+}
+
+static int rt2x00lib_calculate_link_signal(struct rt2x00_dev *rt2x00dev,
+					   int rssi)
 {
-	struct link *link = &rt2x00dev->link;
 	int rssi_percentage = 0;
-	int rx_percentage = 0;
-	int tx_percentage = 0;
-	int rssi = rt2x00_get_link_rssi(link);
 	int signal;
 
 	/*
@@ -205,22 +217,14 @@ static int rt2x00lib_calculate_link_signal(struct rt2x00_dev *rt2x00dev)
 	 */
 	if (rt2x00dev->rssi_offset)
 		rssi_percentage = (rssi * 100) / rt2x00dev->rssi_offset;
-	if (link->rx_failed || link->rx_success)
-		rx_percentage =
-		    (link->rx_success * 100) /
-		    (link->rx_failed + link->rx_success);
-	if (link->tx_failed || link->tx_success)
-		tx_percentage =
-		    (link->tx_success * 100) /
-		    (link->tx_failed + link->tx_success);
 
 	/*
 	 * Add the individual percentages and use the WEIGHT
 	 * defines to calculate the current link signal.
 	 */
 	signal = ((WEIGHT_RSSI * rssi_percentage) +
-		  (WEIGHT_TX * tx_percentage) +
-		  (WEIGHT_RX * rx_percentage)) / 100;
+		  (WEIGHT_TX * rt2x00dev->link.tx_percentage) +
+		  (WEIGHT_RX * rt2x00dev->link.rx_percentage)) / 100;
 
 	return (signal > 100) ? 100 : signal;
 }
@@ -231,22 +235,15 @@ static void rt2x00lib_link_tuner(struct work_struct *work)
 	    container_of(work, struct rt2x00_dev, link.work.work);
 
 	/*
-	 * Reset statistics.
-	 * This will cause the signal value to be
-	 * based on the statistics of the last second.
-	 */
-	rt2x00dev->link.rx_success = 0;
-	rt2x00dev->link.rx_failed = 0;
-	rt2x00dev->link.tx_success = 0;
-	rt2x00dev->link.tx_failed = 0;
-
-	/*
 	 * Update statistics.
 	 */
 	rt2x00dev->ops->lib->link_stats(rt2x00dev);
+
 	rt2x00dev->low_level_stats.dot11FCSErrorCount +=
 	    rt2x00dev->link.rx_failed;
 
+	rt2x00lib_precalculate_link_signal(&rt2x00dev->link);
+
 	/*
 	 * Only perform the link tuning when Link tuning
 	 * has been enabled (This could have been disabled from the EEPROM).
@@ -377,7 +374,7 @@ void rt2x00lib_rxdone(struct data_entry *entry, struct sk_buff *skb,
 	rt2x00_update_link_rssi(&rt2x00dev->link, rssi);
 	rt2x00dev->link.rx_success++;
 	rx_status->rate = val;
-	rx_status->signal = rt2x00lib_calculate_link_signal(rt2x00dev);
+	rx_status->signal = rt2x00lib_calculate_link_signal(rt2x00dev, rssi);
 	rx_status->ssi = rssi;
 
 	/*
-- 
1.5.3
