Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f207.google.com ([209.85.219.207]:43317 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753104AbZHRRyY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Aug 2009 13:54:24 -0400
Received: by mail-ew0-f207.google.com with SMTP id 3so1798730ewy.18
        for <linux-wireless@vger.kernel.org>; Tue, 18 Aug 2009 10:54:25 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] rt2x00: configure_filter() callback is allowed to sleep
Date: Tue, 18 Aug 2009 19:54:23 +0200
Cc: "linux-wireless" <linux-wireless@vger.kernel.org>,
	users@rt2x00.serialmonkey.com
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200908181954.23419.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The configure_filter() callback function no longer needs
to be atomic. Remove the scheduled work structure and
call into the driver configure_filter() directly.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00.h    |    1 -
 drivers/net/wireless/rt2x00/rt2x00dev.c |   10 ----------
 drivers/net/wireless/rt2x00/rt2x00mac.c |    5 +----
 3 files changed, 1 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index 39d7d9b..ad70946 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -826,7 +826,6 @@ struct rt2x00_dev {
 	 * due to RTNL locking requirements.
 	 */
 	struct work_struct intf_work;
-	struct work_struct filter_work;
 
 	/*
 	 * Data queue arrays for RX, TX and Beacon.
diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index 9ab70e4..16b560a 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -118,14 +118,6 @@ void rt2x00lib_toggle_rx(struct rt2x00_dev *rt2x00dev, enum dev_state state)
 		rt2x00link_start_tuner(rt2x00dev);
 }
 
-static void rt2x00lib_packetfilter_scheduled(struct work_struct *work)
-{
-	struct rt2x00_dev *rt2x00dev =
-	    container_of(work, struct rt2x00_dev, filter_work);
-
-	rt2x00dev->ops->lib->config_filter(rt2x00dev, rt2x00dev->packet_filter);
-}
-
 static void rt2x00lib_intf_scheduled_iter(void *data, u8 *mac,
 					  struct ieee80211_vif *vif)
 {
@@ -859,7 +851,6 @@ int rt2x00lib_probe_dev(struct rt2x00_dev *rt2x00dev)
 	 * Initialize configuration work.
 	 */
 	INIT_WORK(&rt2x00dev->intf_work, rt2x00lib_intf_scheduled);
-	INIT_WORK(&rt2x00dev->filter_work, rt2x00lib_packetfilter_scheduled);
 
 	/*
 	 * Allocate queue array.
@@ -907,7 +898,6 @@ void rt2x00lib_remove_dev(struct rt2x00_dev *rt2x00dev)
 	/*
 	 * Stop all work.
 	 */
-	cancel_work_sync(&rt2x00dev->filter_work);
 	cancel_work_sync(&rt2x00dev->intf_work);
 
 	/*
diff --git a/drivers/net/wireless/rt2x00/rt2x00mac.c b/drivers/net/wireless/rt2x00/rt2x00mac.c
index 3011aea..967d3b5 100644
--- a/drivers/net/wireless/rt2x00/rt2x00mac.c
+++ b/drivers/net/wireless/rt2x00/rt2x00mac.c
@@ -430,10 +430,7 @@ void rt2x00mac_configure_filter(struct ieee80211_hw *hw,
 		return;
 	rt2x00dev->packet_filter = *total_flags;
 
-	if (!test_bit(DRIVER_REQUIRE_SCHEDULED, &rt2x00dev->flags))
-		rt2x00dev->ops->lib->config_filter(rt2x00dev, *total_flags);
-	else
-		ieee80211_queue_work(rt2x00dev->hw, &rt2x00dev->filter_work);
+	rt2x00dev->ops->lib->config_filter(rt2x00dev, *total_flags);
 }
 EXPORT_SYMBOL_GPL(rt2x00mac_configure_filter);
 
-- 
1.6.4

