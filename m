Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.247]:1604 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752591AbYFYTZ4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Jun 2008 15:25:56 -0400
Received: by an-out-0708.google.com with SMTP id d40so844767and.103
        for <linux-wireless@vger.kernel.org>; Wed, 25 Jun 2008 12:25:55 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] rt2x00: Fix lock dependency errror
Date: Wed, 25 Jun 2008 21:27:00 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200806252127.00971.IvDoorn@gmail.com> (sfid-20080625_212601_184149_3694A8DA)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This fixes a circular locking dependency in the workqueue handling.
The interface work task uses the mac80211 function
ieee80211_iterate_active_interfaces() which grabs the RTNL lock.

However when the interface is brough down, this happens under the RTNL
lock as well, this causes problems because mac80211 will flush the workqueue
during the ifdown event. This causes mac80211 to wait until the driver has
completed all work which can't finish because it is waiting on the RTNL lock.

This is fixed by moving rt2x00 workqueue tasks on a different workqueue,
this workqueue can be flushed when the ieee80211_hw structure is removed
by the driver (when the driver is unloaded) which does not happen under the
RTNL lock.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
John, please queue for 2.6.26 this fixes the locking dependency as mentioned
in Kernel bug report: http://bugzilla.kernel.org/show_bug.cgi?id=10821

diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index 611d983..73dacbb 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -821,6 +822,7 @@ struct rt2x00_dev {
 	/*
 	 * Scheduled work.
 	 */
+	struct workqueue_struct *workqueue;
 	struct work_struct intf_work;
 	struct work_struct filter_work;
 
diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index 2673d56..f836de1 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -75,7 +75,7 @@ static void rt2x00lib_start_link_tuner(struct rt2x00_dev *rt2x00dev)
 
 	rt2x00lib_reset_link_tuner(rt2x00dev);
 
-	queue_delayed_work(rt2x00dev->hw->workqueue,
+	queue_delayed_work(rt2x00dev->workqueue,
 			   &rt2x00dev->link.work, LINK_TUNE_INTERVAL);
 }
 
@@ -137,14 +137,6 @@ void rt2x00lib_disable_radio(struct rt2x00_dev *rt2x00dev)
 		return;
 
 	/*
-	 * Stop all scheduled work.
-	 */
-	if (work_pending(&rt2x00dev->intf_work))
-		cancel_work_sync(&rt2x00dev->intf_work);
-	if (work_pending(&rt2x00dev->filter_work))
-		cancel_work_sync(&rt2x00dev->filter_work);
-
-	/*
 	 * Stop the TX queues.
 	 */
 	ieee80211_stop_queues(rt2x00dev->hw);
@@ -398,8 +390,8 @@ static void rt2x00lib_link_tuner(struct work_struct *work)
 	 * Increase tuner counter, and reschedule the next link tuner run.
 	 */
 	rt2x00dev->link.count++;
-	queue_delayed_work(rt2x00dev->hw->workqueue, &rt2x00dev->link.work,
-			   LINK_TUNE_INTERVAL);
+	queue_delayed_work(rt2x00dev->workqueue,
+			   &rt2x00dev->link.work, LINK_TUNE_INTERVAL);
 }
 
 static void rt2x00lib_packetfilter_scheduled(struct work_struct *work)
@@ -433,6 +425,15 @@ static void rt2x00lib_intf_scheduled_iter(void *data, u8 *mac,
 
 	spin_unlock(&intf->lock);
 
+	/*
+	 * It is possible the radio was disabled while the work had been
+	 * scheduled. If that happens we should return here immediately,
+	 * note that in the spinlock protected area above the delayed_flags
+	 * have been cleared correctly.
+	 */
+	if (!test_bit(DEVICE_ENABLED_RADIO, &rt2x00dev->flags))
+		return;
+
 	if (delayed_flags & DELAYED_UPDATE_BEACON) {
 		skb = ieee80211_beacon_get(rt2x00dev->hw, vif, &control);
 		if (skb && rt2x00dev->ops->hw->beacon_update(rt2x00dev->hw,
@@ -441,7 +442,7 @@ static void rt2x00lib_intf_scheduled_iter(void *data, u8 *mac,
 	}
 
 	if (delayed_flags & DELAYED_CONFIG_ERP)
-		rt2x00lib_config_erp(rt2x00dev, intf, &intf->conf);
+		rt2x00lib_config_erp(rt2x00dev, intf, &conf);
 
 	if (delayed_flags & DELAYED_LED_ASSOC)
 		rt2x00leds_led_assoc(rt2x00dev, !!rt2x00dev->intf_associated);
@@ -487,7 +488,7 @@ void rt2x00lib_beacondone(struct rt2x00_dev *rt2x00dev)
 						   rt2x00lib_beacondone_iter,
 						   rt2x00dev);
 
-	queue_work(rt2x00dev->hw->workqueue, &rt2x00dev->intf_work);
+	queue_work(rt2x00dev->workqueue, &rt2x00dev->intf_work);
 }
 EXPORT_SYMBOL_GPL(rt2x00lib_beacondone);
 
@@ -1130,6 +1136,10 @@ int rt2x00lib_probe_dev(struct rt2x00_dev *rt2x00dev)
 	/*
 	 * Initialize configuration work.
 	 */
+	rt2x00dev->workqueue = create_singlethread_workqueue("rt2x00lib");
+	if (!rt2x00dev->workqueue)
+		goto exit;
+
 	INIT_WORK(&rt2x00dev->intf_work, rt2x00lib_intf_scheduled);
 	INIT_WORK(&rt2x00dev->filter_work, rt2x00lib_packetfilter_scheduled);
 	INIT_DELAYED_WORK(&rt2x00dev->link.work, rt2x00lib_link_tuner);
@@ -1190,6 +1200,13 @@ void rt2x00lib_remove_dev(struct rt2x00_dev *rt2x00dev)
 	rt2x00leds_unregister(rt2x00dev);
 
 	/*
+	 * Stop all queued work. Note that most tasks will already be halted
+	 * during rt2x00lib_disable_radio() and rt2x00lib_uninitialize().
+	 */
+	flush_workqueue(rt2x00dev->workqueue);
+	destroy_workqueue(rt2x00dev->workqueue);
+
+	/*
 	 * Free ieee80211_hw memory.
 	 */
 	rt2x00lib_remove_hw(rt2x00dev);
diff --git a/drivers/net/wireless/rt2x00/rt2x00mac.c b/drivers/net/wireless/rt2x00/rt2x00mac.c
index 87e280a..48c7ce3 100644
--- a/drivers/net/wireless/rt2x00/rt2x00mac.c
+++ b/drivers/net/wireless/rt2x00/rt2x00mac.c
@@ -428,7 +428,7 @@ void rt2x00mac_configure_filter(struct ieee80211_hw *hw,
 	if (!test_bit(DRIVER_REQUIRE_SCHEDULED, &rt2x00dev->flags))
 		rt2x00dev->ops->lib->config_filter(rt2x00dev, *total_flags);
 	else
-		queue_work(rt2x00dev->hw->workqueue, &rt2x00dev->filter_work);
+		queue_work(rt2x00dev->workqueue, &rt2x00dev->filter_work);
 }
 EXPORT_SYMBOL_GPL(rt2x00mac_configure_filter);
 
@@ -509,7 +509,7 @@ void rt2x00mac_bss_info_changed(struct ieee80211_hw *hw,
 	memcpy(&intf->conf, bss_conf, sizeof(*bss_conf));
 	if (delayed) {
 		intf->delayed_flags |= delayed;
-		queue_work(rt2x00dev->hw->workqueue, &rt2x00dev->intf_work);
+		queue_work(rt2x00dev->workqueue, &rt2x00dev->intf_work);
 	}
 	spin_unlock(&intf->lock);
 }
