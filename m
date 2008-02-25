Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.173]:21799 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757231AbYBYWRJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Feb 2008 17:17:09 -0500
Received: by ug-out-1314.google.com with SMTP id z38so996346ugc.16
        for <linux-wireless@vger.kernel.org>; Mon, 25 Feb 2008 14:17:08 -0800 (PST)
To: linville@tuxdriver.com
Subject: [PATCH 4/4] rt2x00: Fix rt2x00lib_reset_link_tuner()
Date: Mon, 25 Feb 2008 23:15:13 +0100
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200802252315.13433.IvDoorn@gmail.com> (sfid-20080225_221713_472157_605EDBB7)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

rt2x00lib_reset_link_tuner() can be called from within
the link tuner itself. This means that it should
_not_ call rt2x00lib_stop_link_tuner() since that will
cause the thread to hang.

Reorder the things that should be done during a
link tuner reset and during a link tuner start.

Also make antenna tuning the last step of the link
tuner since it could possibly reset some statistical
information which we need for average calculation.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00dev.c |   49 +++++++++++++++++++------------
 1 files changed, 30 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index 7294c75..0d51f47 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -61,11 +61,33 @@ EXPORT_SYMBOL_GPL(rt2x00lib_get_ring);
 /*
  * Link tuning handlers
  */
-static void rt2x00lib_start_link_tuner(struct rt2x00_dev *rt2x00dev)
+void rt2x00lib_reset_link_tuner(struct rt2x00_dev *rt2x00dev)
 {
+	if (!test_bit(DEVICE_ENABLED_RADIO, &rt2x00dev->flags))
+		return;
+
+	/*
+	 * Reset link information.
+	 * Both the currently active vgc level as well as
+	 * the link tuner counter should be reset. Resetting
+	 * the counter is important for devices where the
+	 * device should only perform link tuning during the
+	 * first minute after being enabled.
+	 */
 	rt2x00dev->link.count = 0;
 	rt2x00dev->link.vgc_level = 0;
 
+	/*
+	 * Reset the link tuner.
+	 */
+	rt2x00dev->ops->lib->reset_tuner(rt2x00dev);
+}
+
+static void rt2x00lib_start_link_tuner(struct rt2x00_dev *rt2x00dev)
+{
+	/*
+	 * Clear all (possibly) pre-existing quality statistics.
+	 */
 	memset(&rt2x00dev->link.qual, 0, sizeof(rt2x00dev->link.qual));
 
 	/*
@@ -79,10 +101,7 @@ static void rt2x00lib_start_link_tuner(struct rt2x00_dev *rt2x00dev)
 	rt2x00dev->link.qual.rx_percentage = 50;
 	rt2x00dev->link.qual.tx_percentage = 50;
 
-	/*
-	 * Reset the link tuner.
-	 */
-	rt2x00dev->ops->lib->reset_tuner(rt2x00dev);
+	rt2x00lib_reset_link_tuner(rt2x00dev);
 
 	queue_delayed_work(rt2x00dev->hw->workqueue,
 			   &rt2x00dev->link.work, LINK_TUNE_INTERVAL);
@@ -93,15 +112,6 @@ static void rt2x00lib_stop_link_tuner(struct rt2x00_dev *rt2x00dev)
 	cancel_delayed_work_sync(&rt2x00dev->link.work);
 }
 
-void rt2x00lib_reset_link_tuner(struct rt2x00_dev *rt2x00dev)
-{
-	if (!test_bit(DEVICE_ENABLED_RADIO, &rt2x00dev->flags))
-		return;
-
-	rt2x00lib_stop_link_tuner(rt2x00dev);
-	rt2x00lib_start_link_tuner(rt2x00dev);
-}
-
 /*
  * Ring initialization
  */
@@ -433,17 +443,18 @@ static void rt2x00lib_link_tuner(struct work_struct *work)
 		rt2x00dev->ops->lib->link_tuner(rt2x00dev);
 
 	/*
-	 * Evaluate antenna setup.
-	 */
-	rt2x00lib_evaluate_antenna(rt2x00dev);
-
-	/*
 	 * Precalculate a portion of the link signal which is
 	 * in based on the tx/rx success/failure counters.
 	 */
 	rt2x00lib_precalculate_link_signal(&rt2x00dev->link.qual);
 
 	/*
+	 * Evaluate antenna setup, make this the last step since this could
+	 * possibly reset some statistics.
+	 */
+	rt2x00lib_evaluate_antenna(rt2x00dev);
+
+	/*
 	 * Increase tuner counter, and reschedule the next link tuner run.
 	 */
 	rt2x00dev->link.count++;
-- 
1.5.3.2

