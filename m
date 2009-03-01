Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f177.google.com ([209.85.219.177]:49194 "EHLO
	mail-ew0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752966AbZCAQmF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Mar 2009 11:42:05 -0500
Received: by ewy25 with SMTP id 25so1829731ewy.37
        for <linux-wireless@vger.kernel.org>; Sun, 01 Mar 2009 08:42:02 -0800 (PST)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: rt2x00: Fix SW antenna diversity
Date: Sun, 1 Mar 2009 17:42:00 +0100
Cc: rt2400-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200903011742.00468.IvDoorn@gmail.com> (sfid-20090301_174219_091790_C09682E5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Software antenna tuning is broken because of an function
ordering problem during rt2x00link_tuner().

rt2x00link_precalculate_signal()
rt2x00leds_led_quality()
rt2x00lib_antenna_diversity()

rt2x00link_precalculate_signal() will reset the quality TX/RX counters,
however rt2x00lib_antenna_diversity() requires the RX counter to
see what RSSI value must be used for a particular antenna.
We can't change the ordering since rt2x00lib_antenna_diversity() might
reset other statistics which are needed by the function called earlier.

Move the reset of the quality TX/RX counters into a seperate function
and move the call to after rt2x00lib_antenna_diversity().

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
diff --git a/drivers/net/wireless/rt2x00/rt2x00link.c b/drivers/net/wireless/rt2x00/rt2x00link.c
index 9223a6d..7eb5cd7 100644
--- a/drivers/net/wireless/rt2x00/rt2x00link.c
+++ b/drivers/net/wireless/rt2x00/rt2x00link.c
@@ -302,11 +302,6 @@ static void rt2x00link_precalculate_signal(struct rt2x00_dev *rt2x00dev)
 	    PERCENTAGE(qual->rx_success, qual->rx_failed + qual->rx_success);
 	link->tx_percentage =
 	    PERCENTAGE(qual->tx_success, qual->tx_failed + qual->tx_success);
-
-	qual->rx_success = 0;
-	qual->rx_failed = 0;
-	qual->tx_success = 0;
-	qual->tx_failed = 0;
 }
 
 int rt2x00link_calculate_signal(struct rt2x00_dev *rt2x00dev, int rssi)
@@ -392,6 +387,16 @@ void rt2x00link_reset_tuner(struct rt2x00_dev *rt2x00dev, bool antenna)
 		rt2x00link_antenna_reset(rt2x00dev);
 }
 
+void rt2x00link_reset_qual(struct rt2x00_dev *rt2x00dev)
+{
+	struct link_qual *qual = &rt2x00dev->link.qual;
+
+	qual->rx_success = 0;
+	qual->rx_failed = 0;
+	qual->tx_success = 0;
+	qual->tx_failed = 0;
+}
+
 static void rt2x00link_tuner(struct work_struct *work)
 {
 	struct rt2x00_dev *rt2x00dev =
@@ -448,6 +453,11 @@ static void rt2x00link_tuner(struct work_struct *work)
 	rt2x00lib_antenna_diversity(rt2x00dev);
 
 	/*
+	 * Reset the quality counters which recounted during each period.
+	 */
+	rt2x00link_reset_qual(rt2x00dev);
+
+	/*
 	 * Increase tuner counter, and reschedule the next link tuner run.
 	 */
 	link->count++;
