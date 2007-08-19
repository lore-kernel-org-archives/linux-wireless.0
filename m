Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.184]:46211 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754632AbXHSScT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Aug 2007 14:32:19 -0400
Received: by nf-out-0910.google.com with SMTP id g13so508965nfb
        for <linux-wireless@vger.kernel.org>; Sun, 19 Aug 2007 11:32:18 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 27/30] rt2x00: Add rt2x00lib_reset_link_tuner()
Date: Sun, 19 Aug 2007 20:36:20 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200708192018.30624.IvDoorn@gmail.com>
In-Reply-To: <200708192018.30624.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200708192036.20985.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From d6188297893be7023e0cec4b0132e64ec96de884 Mon Sep 17 00:00:00 2001
From: Ivo van Doorn <IvDoorn@gmail.com>
Date: Sat, 18 Aug 2007 16:41:58 +0200
Subject: [PATCH 27/30] rt2x00: Add rt2x00lib_reset_link_tuner()

When rt2x00config needs the link tuner to be reset,
this means that also all statistics need to be reset
_and_ that the link tuner timer is being reset.
In short: when resetting the link tuner, the link
tuner should be stopped and restarted.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00config.c |    2 +-
 drivers/net/wireless/rt2x00/rt2x00dev.c    |   14 ++++++++++----
 drivers/net/wireless/rt2x00/rt2x00lib.h    |    1 +
 3 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00config.c b/drivers/net/wireless/rt2x00/rt2x00config.c
index 4fec0af..b5075b5 100644
--- a/drivers/net/wireless/rt2x00/rt2x00config.c
+++ b/drivers/net/wireless/rt2x00/rt2x00config.c
@@ -155,7 +155,7 @@ config:
 	 * which means we need to reset the link tuner.
 	 */
 	if (flags & (CONFIG_UPDATE_CHANNEL | CONFIG_UPDATE_ANTENNA))
-		rt2x00dev->ops->lib->reset_tuner(rt2x00dev);
+		rt2x00lib_reset_link_tuner(rt2x00dev);
 
 	rt2x00dev->rx_status.phymode = conf->phymode;
 	rt2x00dev->rx_status.freq = conf->freq;
diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index 8e7fc2a..14968ef 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -67,7 +67,7 @@ EXPORT_SYMBOL_GPL(rt2x00lib_get_ring);
 /*
  * Link tuning handlers
  */
-static void rt2x00_start_link_tune(struct rt2x00_dev *rt2x00dev)
+static void rt2x00lib_start_link_tuner(struct rt2x00_dev *rt2x00dev)
 {
 	rt2x00dev->link.count = 0;
 	rt2x00dev->link.avg_rssi = 0;
@@ -87,12 +87,18 @@ static void rt2x00_start_link_tune(struct rt2x00_dev *rt2x00dev)
 			   &rt2x00dev->link.work, LINK_TUNE_INTERVAL);
 }
 
-static void rt2x00_stop_link_tune(struct rt2x00_dev *rt2x00dev)
+static void rt2x00lib_stop_link_tuner(struct rt2x00_dev *rt2x00dev)
 {
 	if (delayed_work_pending(&rt2x00dev->link.work))
 		cancel_rearming_delayed_work(&rt2x00dev->link.work);
 }
 
+void rt2x00lib_reset_link_tuner(struct rt2x00_dev *rt2x00dev)
+{
+	rt2x00lib_stop_link_tuner(rt2x00dev);
+	rt2x00lib_start_link_tuner(rt2x00dev);
+}
+
 /*
  * Radio control handlers.
  */
@@ -167,7 +173,7 @@ void rt2x00lib_toggle_rx(struct rt2x00_dev *rt2x00dev, int enable)
 	 * When we are disabling the RX, we should also stop the link tuner.
 	 */
 	if (!enable)
-		rt2x00_stop_link_tune(rt2x00dev);
+		rt2x00lib_stop_link_tuner(rt2x00dev);
 
 	rt2x00dev->ops->lib->set_device_state(rt2x00dev, state);
 
@@ -175,7 +181,7 @@ void rt2x00lib_toggle_rx(struct rt2x00_dev *rt2x00dev, int enable)
 	 * When we are enabling the RX, we should also start the link tuner.
 	 */
 	if (enable && is_interface_present(&rt2x00dev->interface))
-		rt2x00_start_link_tune(rt2x00dev);
+		rt2x00lib_start_link_tuner(rt2x00dev);
 }
 
 static int rt2x00lib_calculate_link_signal(struct rt2x00_dev *rt2x00dev)
diff --git a/drivers/net/wireless/rt2x00/rt2x00lib.h b/drivers/net/wireless/rt2x00/rt2x00lib.h
index 1560f73..454e022 100644
--- a/drivers/net/wireless/rt2x00/rt2x00lib.h
+++ b/drivers/net/wireless/rt2x00/rt2x00lib.h
@@ -38,6 +38,7 @@
 int rt2x00lib_enable_radio(struct rt2x00_dev *rt2x00dev);
 void rt2x00lib_disable_radio(struct rt2x00_dev *rt2x00dev);
 void rt2x00lib_toggle_rx(struct rt2x00_dev *rt2x00dev, int enable);
+void rt2x00lib_reset_link_tuner(struct rt2x00_dev *rt2x00dev);
 
 /*
  * Initialization handlers.
-- 
1.5.3.rc5

