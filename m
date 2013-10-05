Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx4.wp.pl ([212.77.101.8]:20877 "EHLO mx4.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752084Ab3JEQOK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 5 Oct 2013 12:14:10 -0400
Received: from ip-78-102-117-145.net.upcbroadband.cz (HELO localhost) (stf_xl@wp.pl@[78.102.117.145])
          (envelope-sender <stf_xl@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with AES128-SHA encrypted SMTP
          for <linux-wireless@vger.kernel.org>; 5 Oct 2013 18:14:06 +0200
Date: Sat, 5 Oct 2013 18:15:33 +0200
From: Stanislaw Gruszka <stf_xl@wp.pl>
To: linux-wireless@vger.kernel.org
Cc: users@rt2x00.serialmonkey.com
Subject: [PATCH] rt2x00: do not pause queue on flush
Message-ID: <20131005161533.GA3696@localhost.localdomain> (sfid-20131005_181414_936458_D2B5A3CA)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Pausing queue on flush make no sense since txdone procedure un-pause
queue. Before flush procedure we have to assure queue is stopped,
i.e. on receive path h/w RX is disabled, on transmit path queue is
disabled in mac80211. That conditions are true except one function:
rt2x00usb_watchdog_tx_dma(), so add stop/start queue there.

Note stop/start queue can be racy if we do this from multiple paths,
but currently we stop TX queues only on rt2x00lib_disable_radio(),
which also stop/sync watchdog, hance we have no race condition.

Signed-off-by: Stanislaw Gruszka <stf_xl@wp.pl>
---
 drivers/net/wireless/rt2x00/rt2x00queue.c |   37 ++++------------------------
 drivers/net/wireless/rt2x00/rt2x00usb.c   |    2 +
 2 files changed, 8 insertions(+), 31 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.c b/drivers/net/wireless/rt2x00/rt2x00queue.c
index 6c8a33b..218e320 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.c
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.c
@@ -1033,38 +1033,21 @@ EXPORT_SYMBOL_GPL(rt2x00queue_stop_queue);
 
 void rt2x00queue_flush_queue(struct data_queue *queue, bool drop)
 {
-	bool started;
 	bool tx_queue =
 		(queue->qid == QID_AC_VO) ||
 		(queue->qid == QID_AC_VI) ||
 		(queue->qid == QID_AC_BE) ||
 		(queue->qid == QID_AC_BK);
 
-	mutex_lock(&queue->status_lock);
 
 	/*
-	 * If the queue has been started, we must stop it temporarily
-	 * to prevent any new frames to be queued on the device. If
-	 * we are not dropping the pending frames, the queue must
-	 * only be stopped in the software and not the hardware,
-	 * otherwise the queue will never become empty on its own.
+	 * If we are not supposed to drop any pending
+	 * frames, this means we must force a start (=kick)
+	 * to the queue to make sure the hardware will
+	 * start transmitting.
 	 */
-	started = test_bit(QUEUE_STARTED, &queue->flags);
-	if (started) {
-		/*
-		 * Pause the queue
-		 */
-		rt2x00queue_pause_queue(queue);
-
-		/*
-		 * If we are not supposed to drop any pending
-		 * frames, this means we must force a start (=kick)
-		 * to the queue to make sure the hardware will
-		 * start transmitting.
-		 */
-		if (!drop && tx_queue)
-			queue->rt2x00dev->ops->lib->kick_queue(queue);
-	}
+	if (!drop && tx_queue)
+		queue->rt2x00dev->ops->lib->kick_queue(queue);
 
 	/*
 	 * Check if driver supports flushing, if that is the case we can
@@ -1080,14 +1063,6 @@ void rt2x00queue_flush_queue(struct data_queue *queue, bool drop)
 	if (unlikely(!rt2x00queue_empty(queue)))
 		rt2x00_warn(queue->rt2x00dev, "Queue %d failed to flush\n",
 			    queue->qid);
-
-	/*
-	 * Restore the queue to the previous status
-	 */
-	if (started)
-		rt2x00queue_unpause_queue(queue);
-
-	mutex_unlock(&queue->status_lock);
 }
 EXPORT_SYMBOL_GPL(rt2x00queue_flush_queue);
 
diff --git a/drivers/net/wireless/rt2x00/rt2x00usb.c b/drivers/net/wireless/rt2x00/rt2x00usb.c
index 8828987..4e12162 100644
--- a/drivers/net/wireless/rt2x00/rt2x00usb.c
+++ b/drivers/net/wireless/rt2x00/rt2x00usb.c
@@ -523,7 +523,9 @@ static void rt2x00usb_watchdog_tx_dma(struct data_queue *queue)
 	rt2x00_warn(queue->rt2x00dev, "TX queue %d DMA timed out, invoke forced forced reset\n",
 		    queue->qid);
 
+	rt2x00queue_stop_queue(queue);
 	rt2x00queue_flush_queue(queue, true);
+	rt2x00queue_start_queue(queue);
 }
 
 static int rt2x00usb_dma_timeout(struct data_queue *queue)
-- 
1.7.4.4

