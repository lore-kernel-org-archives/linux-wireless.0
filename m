Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f211.google.com ([209.85.219.211]:57183 "EHLO
	mail-ew0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752412AbZHHV4L (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 8 Aug 2009 17:56:11 -0400
Received: by ewy7 with SMTP id 7so1937884ewy.18
        for <linux-wireless@vger.kernel.org>; Sat, 08 Aug 2009 14:56:11 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH 4/7] rt2x00: Fix quality houskeeping for software diversity
Date: Sat, 8 Aug 2009 23:54:24 +0200
Cc: users@rt2x00.serialmonkey.com,
	"linux-wireless" <linux-wireless@vger.kernel.org>,
	Lars Ericsson <Lars_Ericsson@telia.com>
References: <200908082353.04274.IvDoorn@gmail.com> <200908082353.26986.IvDoorn@gmail.com> <200908082353.47835.IvDoorn@gmail.com>
In-Reply-To: <200908082353.47835.IvDoorn@gmail.com>
MIME-Version: 1.0
Message-Id: <200908082354.24733.IvDoorn@gmail.com>
Content-Type: text/plain;
  charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Lars Ericsson <Lars_Ericsson@telia.com>

Antanna quality statistics is not handled correctly, which leads to
software diversity being shutdown completly.

The main problem is that during antenna diversity statistics can
be reset resulting in loosing the signal strength just before
evaluation.

rssi history is not updated correctly leading to incorrect comparison
material for basing antenna switching on.

Signed-off-by: Lars Ericsson <Lars_Ericsson@telia.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00.h     |   11 ++---
 drivers/net/wireless/rt2x00/rt2x00link.c |   77 +++++++++++++-----------------
 2 files changed, 38 insertions(+), 50 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index ee9afab..aa3ff0a 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -245,14 +245,11 @@ struct link_ant {
 	struct antenna_setup active;
 
 	/*
-	 * RSSI information for the different antennas.
-	 * These statistics are used to determine when
-	 * to switch antenna when using software diversity.
-	 *
-	 *        rssi[0] -> Antenna A RSSI
-	 *        rssi[1] -> Antenna B RSSI
+	 * RSSI history information for the antenna.
+	 * Used to determine when to switch antenna
+	 * when using software diversity.
 	 */
-	int rssi_history[2];
+	int rssi_history;
 
 	/*
 	 * Current RSSI average of the currently active antenna.
diff --git a/drivers/net/wireless/rt2x00/rt2x00link.c b/drivers/net/wireless/rt2x00/rt2x00link.c
index fe951dc..dd68f3a 100644
--- a/drivers/net/wireless/rt2x00/rt2x00link.c
+++ b/drivers/net/wireless/rt2x00/rt2x00link.c
@@ -103,39 +103,21 @@ static int rt2x00link_antenna_get_link_rssi(struct rt2x00_dev *rt2x00dev)
 	return DEFAULT_RSSI;
 }
 
-static int rt2x00link_antenna_get_rssi_history(struct rt2x00_dev *rt2x00dev,
-					       enum antenna antenna)
+static int rt2x00link_antenna_get_rssi_history(struct rt2x00_dev *rt2x00dev)
 {
 	struct link_ant *ant = &rt2x00dev->link.ant;
 
-	if (ant->rssi_history[antenna - ANTENNA_A])
-		return ant->rssi_history[antenna - ANTENNA_A];
+	if (ant->rssi_history)
+		return ant->rssi_history;
 	return DEFAULT_RSSI;
 }
-/* Small wrapper for rt2x00link_antenna_get_rssi_history() */
-#define rt2x00link_antenna_get_rssi_rx_history(__dev) \
-	rt2x00link_antenna_get_rssi_history((__dev), \
-					    (__dev)->link.ant.active.rx)
-#define rt2x00link_antenna_get_rssi_tx_history(__dev) \
-	rt2x00link_antenna_get_rssi_history((__dev), \
-					    (__dev)->link.ant.active.tx)
 
 static void rt2x00link_antenna_update_rssi_history(struct rt2x00_dev *rt2x00dev,
-						   enum antenna antenna,
 						   int rssi)
 {
 	struct link_ant *ant = &rt2x00dev->link.ant;
-	ant->rssi_history[ant->active.rx - ANTENNA_A] = rssi;
+	ant->rssi_history = rssi;
 }
-/* Small wrapper for rt2x00link_antenna_get_rssi_history() */
-#define rt2x00link_antenna_update_rssi_rx_history(__dev, __rssi) \
-	rt2x00link_antenna_update_rssi_history((__dev), \
-					       (__dev)->link.ant.active.rx, \
-					       (__rssi))
-#define rt2x00link_antenna_update_rssi_tx_history(__dev, __rssi) \
-	rt2x00link_antenna_update_rssi_history((__dev), \
-					       (__dev)->link.ant.active.tx, \
-					       (__rssi))
 
 static void rt2x00link_antenna_reset(struct rt2x00_dev *rt2x00dev)
 {
@@ -146,8 +128,10 @@ static void rt2x00lib_antenna_diversity_sample(struct rt2x00_dev *rt2x00dev)
 {
 	struct link_ant *ant = &rt2x00dev->link.ant;
 	struct antenna_setup new_ant;
-	int sample_a = rt2x00link_antenna_get_rssi_history(rt2x00dev, ANTENNA_A);
-	int sample_b = rt2x00link_antenna_get_rssi_history(rt2x00dev, ANTENNA_B);
+	int other_antenna;
+
+	int sample_current = rt2x00link_antenna_get_link_rssi(rt2x00dev);
+	int sample_other = rt2x00link_antenna_get_rssi_history(rt2x00dev);
 
 	memcpy(&new_ant, &ant->active, sizeof(new_ant));
 
@@ -161,17 +145,22 @@ static void rt2x00lib_antenna_diversity_sample(struct rt2x00_dev *rt2x00dev)
 	 * from both antennas. It now is time to determine
 	 * which antenna demonstrated the best performance.
 	 * When we are already on the antenna with the best
-	 * performance, then there really is nothing for us
-	 * left to do.
+	 * performance, just create a good starting point
+	 * for the history and we are done.
 	 */
-	if (sample_a == sample_b)
+	if (sample_current >= sample_other) {
+		rt2x00link_antenna_update_rssi_history(rt2x00dev,
+			sample_current);
 		return;
+	}
+
+	other_antenna = (ant->active.rx == ANTENNA_A) ? ANTENNA_B : ANTENNA_A;
 
 	if (ant->flags & ANTENNA_RX_DIVERSITY)
-		new_ant.rx = (sample_a > sample_b) ? ANTENNA_A : ANTENNA_B;
+		new_ant.rx = other_antenna;
 
 	if (ant->flags & ANTENNA_TX_DIVERSITY)
-		new_ant.tx = (sample_a > sample_b) ? ANTENNA_A : ANTENNA_B;
+		new_ant.tx = other_antenna;
 
 	rt2x00lib_config_antenna(rt2x00dev, new_ant);
 }
@@ -190,8 +179,8 @@ static void rt2x00lib_antenna_diversity_eval(struct rt2x00_dev *rt2x00dev)
 	 * after that update the history with the current value.
 	 */
 	rssi_curr = rt2x00link_antenna_get_link_rssi(rt2x00dev);
-	rssi_old = rt2x00link_antenna_get_rssi_rx_history(rt2x00dev);
-	rt2x00link_antenna_update_rssi_rx_history(rt2x00dev, rssi_curr);
+	rssi_old = rt2x00link_antenna_get_rssi_history(rt2x00dev);
+	rt2x00link_antenna_update_rssi_history(rt2x00dev, rssi_curr);
 
 	/*
 	 * Legacy driver indicates that we should swap antenna's
@@ -216,7 +205,7 @@ static void rt2x00lib_antenna_diversity_eval(struct rt2x00_dev *rt2x00dev)
 	rt2x00lib_config_antenna(rt2x00dev, new_ant);
 }
 
-static void rt2x00lib_antenna_diversity(struct rt2x00_dev *rt2x00dev)
+static bool rt2x00lib_antenna_diversity(struct rt2x00_dev *rt2x00dev)
 {
 	struct link_ant *ant = &rt2x00dev->link.ant;
 	unsigned int flags = ant->flags;
@@ -238,7 +227,7 @@ static void rt2x00lib_antenna_diversity(struct rt2x00_dev *rt2x00dev)
 	if (!(ant->flags & ANTENNA_RX_DIVERSITY) &&
 	    !(ant->flags & ANTENNA_TX_DIVERSITY)) {
 		ant->flags = 0;
-		return;
+		return true;
 	}
 
 	/* Update flags */
@@ -250,10 +239,15 @@ static void rt2x00lib_antenna_diversity(struct rt2x00_dev *rt2x00dev)
 	 * the data. The latter should only be performed once
 	 * every 2 seconds.
 	 */
-	if (ant->flags & ANTENNA_MODE_SAMPLE)
+	if (ant->flags & ANTENNA_MODE_SAMPLE) {
 		rt2x00lib_antenna_diversity_sample(rt2x00dev);
-	else if (rt2x00dev->link.count & 1)
+		return true;
+	} else if (rt2x00dev->link.count & 1) {
 		rt2x00lib_antenna_diversity_eval(rt2x00dev);
+		return true;
+	}
+
+	return false;
 }
 
 void rt2x00link_update_stats(struct rt2x00_dev *rt2x00dev,
@@ -451,15 +445,12 @@ static void rt2x00link_tuner(struct work_struct *work)
 	rt2x00leds_led_quality(rt2x00dev, link->avg_rssi);
 
 	/*
-	 * Evaluate antenna setup, make this the last step since this could
-	 * possibly reset some statistics.
-	 */
-	rt2x00lib_antenna_diversity(rt2x00dev);
-
-	/*
-	 * Reset the quality counters which recounted during each period.
+	 * Evaluate antenna setup, make this the last step when
+	 * rt2x00lib_antenna_diversity made changes the quality
+	 * statistics will be reset.
 	 */
-	rt2x00link_reset_qual(rt2x00dev);
+	if (rt2x00lib_antenna_diversity(rt2x00dev))
+		rt2x00link_reset_qual(rt2x00dev);
 
 	/*
 	 * Increase tuner counter, and reschedule the next link tuner run.
-- 
1.6.3.3

