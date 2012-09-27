Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh03.mail.saunalahti.fi ([62.142.5.109]:41111 "EHLO
	emh03.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756677Ab2I0Kim (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Sep 2012 06:38:42 -0400
From: Luciano Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: coelho@ti.com, Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 09/31] wlcore: tx_flush - optimize flow and force Tx during the flush
Date: Thu, 27 Sep 2012 13:37:47 +0300
Message-Id: <1348742289-6587-10-git-send-email-luca@coelho.fi> (sfid-20120927_123857_808078_07596A57)
In-Reply-To: <1348742289-6587-1-git-send-email-luca@coelho.fi>
References: <1348742289-6587-1-git-send-email-luca@coelho.fi>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arik Nemtsov <arik@wizery.com>

Force Tx during the flush if there are packets pending in the driver.
This actually solves a bug where we would get called from the mac80211
wq context, which would prevent tx_work from getting queued, even when
the mutex is unlocked.

Don't stop the queues needlessly if there's nothing to flush. Use a
larger delay when sleeping to give the driver a chance to flush and
avoid cpu busy looping. Re-arrange the loop so the last iteration is
not wasted.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
Signed-off-by: Luciano Coelho <luca@coelho.fi>
---
 drivers/net/wireless/ti/wlcore/tx.c |   26 ++++++++++++++++++--------
 1 file changed, 18 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/tx.c b/drivers/net/wireless/ti/wlcore/tx.c
index d89e0db..f9c26b1 100644
--- a/drivers/net/wireless/ti/wlcore/tx.c
+++ b/drivers/net/wireless/ti/wlcore/tx.c
@@ -1084,22 +1084,32 @@ void wl1271_tx_flush(struct wl1271 *wl)
 	/* only one flush should be in progress, for consistent queue state */
 	mutex_lock(&wl->flush_mutex);
 
+	mutex_lock(&wl->mutex);
+	if (wl->tx_frames_cnt == 0 && wl1271_tx_total_queue_count(wl) == 0) {
+		mutex_unlock(&wl->mutex);
+		goto out;
+	}
+
 	wlcore_stop_queues(wl, WLCORE_QUEUE_STOP_REASON_FLUSH);
 
 	while (!time_after(jiffies, timeout)) {
-		mutex_lock(&wl->mutex);
 		wl1271_debug(DEBUG_MAC80211, "flushing tx buffer: %d %d",
 			     wl->tx_frames_cnt,
 			     wl1271_tx_total_queue_count(wl));
+
+		/* force Tx and give the driver some time to flush data */
+		mutex_unlock(&wl->mutex);
+		if (wl1271_tx_total_queue_count(wl))
+			wl1271_tx_work(&wl->tx_work);
+		msleep(20);
+		mutex_lock(&wl->mutex);
+
 		if ((wl->tx_frames_cnt == 0) &&
 		    (wl1271_tx_total_queue_count(wl) == 0)) {
-			mutex_unlock(&wl->mutex);
 			wl1271_debug(DEBUG_MAC80211, "tx flush took %d ms",
 				     jiffies_to_msecs(jiffies - start_time));
-			goto out;
+			goto out_wake;
 		}
-		mutex_unlock(&wl->mutex);
-		msleep(1);
 	}
 
 	wl1271_warning("Unable to flush all TX buffers, "
@@ -1107,13 +1117,13 @@ void wl1271_tx_flush(struct wl1271 *wl)
 		       WL1271_TX_FLUSH_TIMEOUT / 1000);
 
 	/* forcibly flush all Tx buffers on our queues */
-	mutex_lock(&wl->mutex);
 	for (i = 0; i < WL12XX_MAX_LINKS; i++)
 		wl1271_tx_reset_link_queues(wl, i);
-	mutex_unlock(&wl->mutex);
 
-out:
+out_wake:
 	wlcore_wake_queues(wl, WLCORE_QUEUE_STOP_REASON_FLUSH);
+	mutex_unlock(&wl->mutex);
+out:
 	mutex_unlock(&wl->flush_mutex);
 }
 EXPORT_SYMBOL_GPL(wl1271_tx_flush);
-- 
1.7.10.4

