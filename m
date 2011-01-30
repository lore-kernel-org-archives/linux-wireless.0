Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:41674 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754061Ab1A3MY7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 30 Jan 2011 07:24:59 -0500
Received: by mail-ey0-f174.google.com with SMTP id 27so2146783eye.19
        for <linux-wireless@vger.kernel.org>; Sun, 30 Jan 2011 04:24:59 -0800 (PST)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 21/21] rt2x00: Move TX/RX work into dedicated workqueue
Date: Sun, 30 Jan 2011 13:24:05 +0100
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
References: <201101301316.04044.IvDoorn@gmail.com> <201101301323.23477.IvDoorn@gmail.com> <201101301323.43235.IvDoorn@gmail.com>
In-Reply-To: <201101301323.43235.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201101301324.06619.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ivo van Doorn <IvDoorn@gmail.com>

The TX/RX work structures must be able to run independently
of other workqueues. This is because mac80211 might use
the flush() callback function from various context, which depends
on the TX/RX work to complete while the main thread is blocked
(until the the TX queues are empty).

This should reduce the number of  'Queue %d failed to flush' warnings.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00.h     |    7 +++++++
 drivers/net/wireless/rt2x00/rt2x00dev.c  |   10 +++++++++-
 drivers/net/wireless/rt2x00/rt2x00link.c |    7 +++++--
 drivers/net/wireless/rt2x00/rt2x00usb.c  |    8 ++++----
 4 files changed, 25 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index 7661e4f..39bc2fa 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -860,6 +860,13 @@ struct rt2x00_dev {
 	 */
 	struct ieee80211_low_level_stats low_level_stats;
 
+	/**
+	 * Work queue for all work which should not be placed
+	 * on the mac80211 workqueue (because of dependencies
+	 * between various work structures).
+	 */
+	struct workqueue_struct *workqueue;
+
 	/*
 	 * Scheduled work.
 	 * NOTE: intf_work will use ieee80211_iterate_active_interfaces()
diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index e716285..9de9dbe 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -997,8 +997,15 @@ int rt2x00lib_probe_dev(struct rt2x00_dev *rt2x00dev)
 		    BIT(NL80211_IFTYPE_WDS);
 
 	/*
-	 * Initialize configuration work.
+	 * Initialize work.
 	 */
+	rt2x00dev->workqueue =
+	    alloc_ordered_workqueue(wiphy_name(rt2x00dev->hw->wiphy), 0);
+	if (!rt2x00dev->workqueue) {
+		retval = -ENOMEM;
+		goto exit;
+	}
+
 	INIT_WORK(&rt2x00dev->intf_work, rt2x00lib_intf_scheduled);
 
 	/*
@@ -1057,6 +1064,7 @@ void rt2x00lib_remove_dev(struct rt2x00_dev *rt2x00dev)
 	cancel_work_sync(&rt2x00dev->intf_work);
 	cancel_work_sync(&rt2x00dev->rxdone_work);
 	cancel_work_sync(&rt2x00dev->txdone_work);
+	destroy_workqueue(rt2x00dev->workqueue);
 
 	/*
 	 * Free the tx status fifo.
diff --git a/drivers/net/wireless/rt2x00/rt2x00link.c b/drivers/net/wireless/rt2x00/rt2x00link.c
index bfda60e..c975b0a 100644
--- a/drivers/net/wireless/rt2x00/rt2x00link.c
+++ b/drivers/net/wireless/rt2x00/rt2x00link.c
@@ -417,7 +417,8 @@ void rt2x00link_start_watchdog(struct rt2x00_dev *rt2x00dev)
 	    !test_bit(DRIVER_SUPPORT_WATCHDOG, &rt2x00dev->flags))
 		return;
 
-	schedule_delayed_work(&link->watchdog_work, WATCHDOG_INTERVAL);
+	ieee80211_queue_delayed_work(rt2x00dev->hw,
+				     &link->watchdog_work, WATCHDOG_INTERVAL);
 }
 
 void rt2x00link_stop_watchdog(struct rt2x00_dev *rt2x00dev)
@@ -441,7 +442,9 @@ static void rt2x00link_watchdog(struct work_struct *work)
 	rt2x00dev->ops->lib->watchdog(rt2x00dev);
 
 	if (test_bit(DEVICE_STATE_PRESENT, &rt2x00dev->flags))
-		schedule_delayed_work(&link->watchdog_work, WATCHDOG_INTERVAL);
+		ieee80211_queue_delayed_work(rt2x00dev->hw,
+					     &link->watchdog_work,
+					     WATCHDOG_INTERVAL);
 }
 
 void rt2x00link_register(struct rt2x00_dev *rt2x00dev)
diff --git a/drivers/net/wireless/rt2x00/rt2x00usb.c b/drivers/net/wireless/rt2x00/rt2x00usb.c
index 1a9937d..fbe735f 100644
--- a/drivers/net/wireless/rt2x00/rt2x00usb.c
+++ b/drivers/net/wireless/rt2x00/rt2x00usb.c
@@ -227,7 +227,7 @@ static void rt2x00usb_interrupt_txdone(struct urb *urb)
 	 * Schedule the delayed work for reading the TX status
 	 * from the device.
 	 */
-	ieee80211_queue_work(rt2x00dev->hw, &rt2x00dev->txdone_work);
+	queue_work(rt2x00dev->workqueue, &rt2x00dev->txdone_work);
 }
 
 static void rt2x00usb_kick_tx_entry(struct queue_entry *entry)
@@ -320,7 +320,7 @@ static void rt2x00usb_interrupt_rxdone(struct urb *urb)
 	 * Schedule the delayed work for reading the RX status
 	 * from the device.
 	 */
-	ieee80211_queue_work(rt2x00dev->hw, &rt2x00dev->rxdone_work);
+	queue_work(rt2x00dev->workqueue, &rt2x00dev->rxdone_work);
 }
 
 static void rt2x00usb_kick_rx_entry(struct queue_entry *entry)
@@ -429,7 +429,7 @@ void rt2x00usb_flush_queue(struct data_queue *queue)
 		 * Schedule the completion handler manually, when this
 		 * worker function runs, it should cleanup the queue.
 		 */
-		ieee80211_queue_work(queue->rt2x00dev->hw, completion);
+		queue_work(queue->rt2x00dev->workqueue, completion);
 
 		/*
 		 * Wait for a little while to give the driver
@@ -453,7 +453,7 @@ static void rt2x00usb_watchdog_tx_status(struct data_queue *queue)
 	WARNING(queue->rt2x00dev, "TX queue %d status timed out,"
 		" invoke forced tx handler\n", queue->qid);
 
-	ieee80211_queue_work(queue->rt2x00dev->hw, &queue->rt2x00dev->txdone_work);
+	queue_work(queue->rt2x00dev->workqueue, &queue->rt2x00dev->txdone_work);
 }
 
 void rt2x00usb_watchdog(struct rt2x00_dev *rt2x00dev)
-- 
1.7.2.3

