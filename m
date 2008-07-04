Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.185]:9851 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752445AbYGDLiK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Jul 2008 07:38:10 -0400
Received: by nf-out-0910.google.com with SMTP id d3so359466nfc.21
        for <linux-wireless@vger.kernel.org>; Fri, 04 Jul 2008 04:38:09 -0700 (PDT)
To: linville@tuxdriver.com
Subject: [PATCH 3/4] rt2x00: Use ieee80211_hw->workqueue again
Date: Fri, 4 Jul 2008 13:41:31 +0200
Cc: "linux-wireless" <linux-wireless@vger.kernel.org>,
	rt2400-devel@lists.sourceforge.net
References: <200807041340.28103.IvDoorn@gmail.com> <200807041340.53147.IvDoorn@gmail.com>
In-Reply-To: <200807041340.53147.IvDoorn@gmail.com>
MIME-Version: 1.0
Message-Id: <200807041341.31830.IvDoorn@gmail.com> (sfid-20080704_133813_818794_21731065)
Content-Type: text/plain;
  charset="utf-8"
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove the rt2x00 singlethreaded workqueue and move
the link tuner and packet filter scheduled work to
the ieee80211_hw->workqueue again.
The only exception is the interface scheduled work
handler which uses the mac80211 interface iterator
under the RTNL lock. This work needs to be handled
on the kernel workqueue to prevent lockdep issues.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index 1b28dad..c07d9ef 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -787,8 +787,10 @@ struct rt2x00_dev {
 
 	/*
 	 * Scheduled work.
+	 * NOTE: intf_work will use ieee80211_iterate_active_interfaces()
+	 * which means it cannot be placed on the hw->workqueue
+	 * due to RTNL locking requirements.
 	 */
-	struct workqueue_struct *workqueue;
 	struct work_struct intf_work;
 	struct work_struct filter_work;
 
diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index 41b3289..8086263 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -74,7 +74,7 @@ static void rt2x00lib_start_link_tuner(struct rt2x00_dev *rt2x00dev)
 
 	rt2x00lib_reset_link_tuner(rt2x00dev);
 
-	queue_delayed_work(rt2x00dev->workqueue,
+	queue_delayed_work(rt2x00dev->hw->workqueue,
 			   &rt2x00dev->link.work, LINK_TUNE_INTERVAL);
 }
 
@@ -392,7 +392,7 @@ static void rt2x00lib_link_tuner(struct work_struct *work)
 	 * Increase tuner counter, and reschedule the next link tuner run.
 	 */
 	rt2x00dev->link.count++;
-	queue_delayed_work(rt2x00dev->workqueue,
+	queue_delayed_work(rt2x00dev->hw->workqueue,
 			   &rt2x00dev->link.work, LINK_TUNE_INTERVAL);
 }
 
@@ -496,7 +496,7 @@ void rt2x00lib_beacondone(struct rt2x00_dev *rt2x00dev)
 						   rt2x00lib_beacondone_iter,
 						   rt2x00dev);
 
-	queue_work(rt2x00dev->workqueue, &rt2x00dev->intf_work);
+	schedule_work(&rt2x00dev->intf_work);
 }
 EXPORT_SYMBOL_GPL(rt2x00lib_beacondone);
 
@@ -1064,10 +1064,6 @@ int rt2x00lib_probe_dev(struct rt2x00_dev *rt2x00dev)
 	/*
 	 * Initialize configuration work.
 	 */
-	rt2x00dev->workqueue = create_singlethread_workqueue("rt2x00lib");
-	if (!rt2x00dev->workqueue)
-		goto exit;
-
 	INIT_WORK(&rt2x00dev->intf_work, rt2x00lib_intf_scheduled);
 	INIT_WORK(&rt2x00dev->filter_work, rt2x00lib_packetfilter_scheduled);
 	INIT_DELAYED_WORK(&rt2x00dev->link.work, rt2x00lib_link_tuner);
@@ -1128,13 +1124,6 @@ void rt2x00lib_remove_dev(struct rt2x00_dev *rt2x00dev)
 	rt2x00leds_unregister(rt2x00dev);
 
 	/*
-	 * Stop all queued work. Note that most tasks will already be halted
-	 * during rt2x00lib_disable_radio() and rt2x00lib_uninitialize().
-	 */
-	flush_workqueue(rt2x00dev->workqueue);
-	destroy_workqueue(rt2x00dev->workqueue);
-
-	/*
 	 * Free ieee80211_hw memory.
 	 */
 	rt2x00lib_remove_hw(rt2x00dev);
diff --git a/drivers/net/wireless/rt2x00/rt2x00mac.c b/drivers/net/wireless/rt2x00/rt2x00mac.c
index 1253da8..3a1fb6d 100644
--- a/drivers/net/wireless/rt2x00/rt2x00mac.c
+++ b/drivers/net/wireless/rt2x00/rt2x00mac.c
@@ -431,7 +431,7 @@ void rt2x00mac_configure_filter(struct ieee80211_hw *hw,
 	if (!test_bit(DRIVER_REQUIRE_SCHEDULED, &rt2x00dev->flags))
 		rt2x00dev->ops->lib->config_filter(rt2x00dev, *total_flags);
 	else
-		queue_work(rt2x00dev->workqueue, &rt2x00dev->filter_work);
+		queue_work(rt2x00dev->hw->workqueue, &rt2x00dev->filter_work);
 }
 EXPORT_SYMBOL_GPL(rt2x00mac_configure_filter);
 
@@ -512,7 +512,7 @@ void rt2x00mac_bss_info_changed(struct ieee80211_hw *hw,
 	memcpy(&intf->conf, bss_conf, sizeof(*bss_conf));
 	if (delayed) {
 		intf->delayed_flags |= delayed;
-		queue_work(rt2x00dev->workqueue, &rt2x00dev->intf_work);
+		schedule_work(&rt2x00dev->intf_work);
 	}
 	spin_unlock(&intf->lock);
 }
