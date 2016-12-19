Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42362 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1758345AbcLSKzL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Dec 2016 05:55:11 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 08/11] rt2x00: merge agc and vco works with link tuner
Date: Mon, 19 Dec 2016 11:52:54 +0100
Message-Id: <1482144777-16760-9-git-send-email-sgruszka@redhat.com> (sfid-20161219_120124_488300_E6E4BF39)
In-Reply-To: <1482144777-16760-1-git-send-email-sgruszka@redhat.com>
References: <1482144777-16760-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We need to perform different actions (AGC and VCO calibrations and VGC
tuning) periodically at different intervals. We don't need separate
works for those, we can use link tuner work and just check for proper
interval on it.

This fixes performing AGC and VCO calibration when scanning on STA
mode. We need to be on-channel to perform those calibrations.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/ralink/rt2x00/rt2x00dev.c  |    6 -
 drivers/net/wireless/ralink/rt2x00/rt2x00lib.h  |   31 +-----
 drivers/net/wireless/ralink/rt2x00/rt2x00link.c |  127 ++++++-----------------
 3 files changed, 36 insertions(+), 128 deletions(-)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c b/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c
index 4e0c565..550eaf1 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c
@@ -85,9 +85,6 @@ int rt2x00lib_enable_radio(struct rt2x00_dev *rt2x00dev)
 	 */
 	rt2x00queue_start_queues(rt2x00dev);
 	rt2x00link_start_tuner(rt2x00dev);
-	rt2x00link_start_agc(rt2x00dev);
-	if (rt2x00_has_cap_vco_recalibration(rt2x00dev))
-		rt2x00link_start_vcocal(rt2x00dev);
 
 	/*
 	 * Start watchdog monitoring.
@@ -110,9 +107,6 @@ void rt2x00lib_disable_radio(struct rt2x00_dev *rt2x00dev)
 	/*
 	 * Stop all queues
 	 */
-	rt2x00link_stop_agc(rt2x00dev);
-	if (rt2x00_has_cap_vco_recalibration(rt2x00dev))
-		rt2x00link_stop_vcocal(rt2x00dev);
 	rt2x00link_stop_tuner(rt2x00dev);
 	rt2x00queue_stop_queues(rt2x00dev);
 	rt2x00queue_flush_queues(rt2x00dev, true);
diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00lib.h b/drivers/net/wireless/ralink/rt2x00/rt2x00lib.h
index fb7c349..9ddc168 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2x00lib.h
+++ b/drivers/net/wireless/ralink/rt2x00/rt2x00lib.h
@@ -29,9 +29,10 @@
  * Interval defines
  */
 #define WATCHDOG_INTERVAL	round_jiffies_relative(HZ)
-#define LINK_TUNE_INTERVAL	round_jiffies_relative(HZ)
-#define AGC_INTERVAL		round_jiffies_relative(4 * HZ)
-#define VCO_INTERVAL		round_jiffies_relative(10 * HZ) /* 10 sec */
+#define LINK_TUNE_SECONDS	1
+#define LINK_TUNE_INTERVAL	round_jiffies_relative(LINK_TUNE_SECONDS * HZ)
+#define AGC_SECONDS		4
+#define VCO_SECONDS		10
 
 /*
  * rt2x00_rate: Per rate device information
@@ -271,30 +272,6 @@ void rt2x00link_update_stats(struct rt2x00_dev *rt2x00dev,
 void rt2x00link_stop_watchdog(struct rt2x00_dev *rt2x00dev);
 
 /**
- * rt2x00link_start_agc - Start periodic gain calibration
- * @rt2x00dev: Pointer to &struct rt2x00_dev.
- */
-void rt2x00link_start_agc(struct rt2x00_dev *rt2x00dev);
-
-/**
- * rt2x00link_start_vcocal - Start periodic VCO calibration
- * @rt2x00dev: Pointer to &struct rt2x00_dev.
- */
-void rt2x00link_start_vcocal(struct rt2x00_dev *rt2x00dev);
-
-/**
- * rt2x00link_stop_agc - Stop periodic gain calibration
- * @rt2x00dev: Pointer to &struct rt2x00_dev.
- */
-void rt2x00link_stop_agc(struct rt2x00_dev *rt2x00dev);
-
-/**
- * rt2x00link_stop_vcocal - Stop periodic VCO calibration
- * @rt2x00dev: Pointer to &struct rt2x00_dev.
- */
-void rt2x00link_stop_vcocal(struct rt2x00_dev *rt2x00dev);
-
-/**
  * rt2x00link_register - Initialize link tuning & watchdog functionality
  * @rt2x00dev: Pointer to &struct rt2x00_dev.
  *
diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00link.c b/drivers/net/wireless/ralink/rt2x00/rt2x00link.c
index 017188e..73cbf23 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2x00link.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2x00link.c
@@ -233,15 +233,13 @@ void rt2x00link_start_tuner(struct rt2x00_dev *rt2x00dev)
 	struct link *link = &rt2x00dev->link;
 
 	/*
-	 * Link tuning should only be performed when
-	 * an active sta interface exists. AP interfaces
-	 * don't need link tuning and monitor mode interfaces
-	 * should never have to work with link tuners.
+	 * Single monitor mode interfaces should never have
+	 * work with link tuners.
 	 */
-	if (!rt2x00dev->intf_sta_count)
+	if (!rt2x00dev->intf_ap_count && !rt2x00dev->intf_sta_count)
 		return;
 
-	/**
+	/*
 	 * While scanning, link tuning is disabled. By default
 	 * the most sensitive settings will be used to make sure
 	 * that all beacons and probe responses will be received
@@ -308,22 +306,11 @@ static void rt2x00link_reset_qual(struct rt2x00_dev *rt2x00dev)
 	qual->tx_failed = 0;
 }
 
-static void rt2x00link_tuner(struct work_struct *work)
+static void rt2x00link_tuner_sta(struct rt2x00_dev *rt2x00dev, struct link *link)
 {
-	struct rt2x00_dev *rt2x00dev =
-	    container_of(work, struct rt2x00_dev, link.work.work);
-	struct link *link = &rt2x00dev->link;
 	struct link_qual *qual = &rt2x00dev->link.qual;
 
 	/*
-	 * When the radio is shutting down we should
-	 * immediately cease all link tuning.
-	 */
-	if (!test_bit(DEVICE_STATE_ENABLED_RADIO, &rt2x00dev->flags) ||
-	    test_bit(DEVICE_STATE_SCANNING, &rt2x00dev->flags))
-		return;
-
-	/*
 	 * Update statistics.
 	 */
 	rt2x00dev->ops->lib->link_stats(rt2x00dev, qual);
@@ -360,6 +347,33 @@ static void rt2x00link_tuner(struct work_struct *work)
 	 */
 	if (rt2x00lib_antenna_diversity(rt2x00dev))
 		rt2x00link_reset_qual(rt2x00dev);
+}
+
+static void rt2x00link_tuner(struct work_struct *work)
+{
+	struct rt2x00_dev *rt2x00dev =
+	    container_of(work, struct rt2x00_dev, link.work.work);
+	struct link *link = &rt2x00dev->link;
+
+	/*
+	 * When the radio is shutting down we should
+	 * immediately cease all link tuning.
+	 */
+	if (!test_bit(DEVICE_STATE_ENABLED_RADIO, &rt2x00dev->flags) ||
+	    test_bit(DEVICE_STATE_SCANNING, &rt2x00dev->flags))
+		return;
+
+	if (rt2x00dev->intf_sta_count)
+		rt2x00link_tuner_sta(rt2x00dev, link);
+
+	if (rt2x00dev->ops->lib->gain_calibration &&
+	    (link->count % (AGC_SECONDS / LINK_TUNE_SECONDS)) == 0)
+		rt2x00dev->ops->lib->gain_calibration(rt2x00dev);
+
+	if (rt2x00dev->ops->lib->vco_calibration &&
+	    rt2x00_has_cap_vco_recalibration(rt2x00dev) &&
+	    (link->count % (VCO_SECONDS / LINK_TUNE_SECONDS)) == 0)
+		rt2x00dev->ops->lib->vco_calibration(rt2x00dev);
 
 	/*
 	 * Increase tuner counter, and reschedule the next link tuner run.
@@ -408,85 +422,8 @@ static void rt2x00link_watchdog(struct work_struct *work)
 					     WATCHDOG_INTERVAL);
 }
 
-void rt2x00link_start_agc(struct rt2x00_dev *rt2x00dev)
-{
-	struct link *link = &rt2x00dev->link;
-
-	if (test_bit(DEVICE_STATE_PRESENT, &rt2x00dev->flags) &&
-	    rt2x00dev->ops->lib->gain_calibration)
-		ieee80211_queue_delayed_work(rt2x00dev->hw,
-					     &link->agc_work,
-					     AGC_INTERVAL);
-}
-
-void rt2x00link_start_vcocal(struct rt2x00_dev *rt2x00dev)
-{
-	struct link *link = &rt2x00dev->link;
-
-	if (test_bit(DEVICE_STATE_PRESENT, &rt2x00dev->flags) &&
-	    rt2x00dev->ops->lib->vco_calibration)
-		ieee80211_queue_delayed_work(rt2x00dev->hw,
-					     &link->vco_work,
-					     VCO_INTERVAL);
-}
-
-void rt2x00link_stop_agc(struct rt2x00_dev *rt2x00dev)
-{
-	cancel_delayed_work_sync(&rt2x00dev->link.agc_work);
-}
-
-void rt2x00link_stop_vcocal(struct rt2x00_dev *rt2x00dev)
-{
-	cancel_delayed_work_sync(&rt2x00dev->link.vco_work);
-}
-
-static void rt2x00link_agc(struct work_struct *work)
-{
-	struct rt2x00_dev *rt2x00dev =
-	    container_of(work, struct rt2x00_dev, link.agc_work.work);
-	struct link *link = &rt2x00dev->link;
-
-	/*
-	 * When the radio is shutting down we should
-	 * immediately cease the watchdog monitoring.
-	 */
-	if (!test_bit(DEVICE_STATE_ENABLED_RADIO, &rt2x00dev->flags))
-		return;
-
-	rt2x00dev->ops->lib->gain_calibration(rt2x00dev);
-
-	if (test_bit(DEVICE_STATE_PRESENT, &rt2x00dev->flags))
-		ieee80211_queue_delayed_work(rt2x00dev->hw,
-					     &link->agc_work,
-					     AGC_INTERVAL);
-}
-
-static void rt2x00link_vcocal(struct work_struct *work)
-{
-	struct rt2x00_dev *rt2x00dev =
-	    container_of(work, struct rt2x00_dev, link.vco_work.work);
-	struct link *link = &rt2x00dev->link;
-
-	/*
-	 * When the radio is shutting down we should
-	 * immediately cease the VCO calibration.
-	 */
-	if (!test_bit(DEVICE_STATE_ENABLED_RADIO, &rt2x00dev->flags))
-		return;
-
-	rt2x00dev->ops->lib->vco_calibration(rt2x00dev);
-
-	if (test_bit(DEVICE_STATE_PRESENT, &rt2x00dev->flags))
-		ieee80211_queue_delayed_work(rt2x00dev->hw,
-					     &link->vco_work,
-					     VCO_INTERVAL);
-}
-
 void rt2x00link_register(struct rt2x00_dev *rt2x00dev)
 {
-	INIT_DELAYED_WORK(&rt2x00dev->link.agc_work, rt2x00link_agc);
-	if (rt2x00_has_cap_vco_recalibration(rt2x00dev))
-		INIT_DELAYED_WORK(&rt2x00dev->link.vco_work, rt2x00link_vcocal);
 	INIT_DELAYED_WORK(&rt2x00dev->link.watchdog_work, rt2x00link_watchdog);
 	INIT_DELAYED_WORK(&rt2x00dev->link.work, rt2x00link_tuner);
 }
-- 
1.7.1
