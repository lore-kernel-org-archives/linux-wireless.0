Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh04.mail.saunalahti.fi ([62.142.5.110]:53710 "EHLO
	emh04.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756501Ab2I0Kik (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Sep 2012 06:38:40 -0400
From: Luciano Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: coelho@ti.com, Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 08/31] wlcore: make Tx flush timings more verbose
Date: Thu, 27 Sep 2012 13:37:46 +0300
Message-Id: <1348742289-6587-9-git-send-email-luca@coelho.fi> (sfid-20120927_124031_666895_48AE4B80)
In-Reply-To: <1348742289-6587-1-git-send-email-luca@coelho.fi>
References: <1348742289-6587-1-git-send-email-luca@coelho.fi>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arik Nemtsov <arik@wizery.com>

Print how much time a flush took. This will help debug the time it takes
to switch between channels.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
Signed-off-by: Luciano Coelho <luca@coelho.fi>
---
 drivers/net/wireless/ti/wlcore/tx.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/tx.c b/drivers/net/wireless/ti/wlcore/tx.c
index 24ac8ec..d89e0db 100644
--- a/drivers/net/wireless/ti/wlcore/tx.c
+++ b/drivers/net/wireless/ti/wlcore/tx.c
@@ -1076,9 +1076,10 @@ void wl12xx_tx_reset(struct wl1271 *wl)
 /* caller must *NOT* hold wl->mutex */
 void wl1271_tx_flush(struct wl1271 *wl)
 {
-	unsigned long timeout;
+	unsigned long timeout, start_time;
 	int i;
-	timeout = jiffies + usecs_to_jiffies(WL1271_TX_FLUSH_TIMEOUT);
+	start_time = jiffies;
+	timeout = start_time + usecs_to_jiffies(WL1271_TX_FLUSH_TIMEOUT);
 
 	/* only one flush should be in progress, for consistent queue state */
 	mutex_lock(&wl->flush_mutex);
@@ -1087,19 +1088,23 @@ void wl1271_tx_flush(struct wl1271 *wl)
 
 	while (!time_after(jiffies, timeout)) {
 		mutex_lock(&wl->mutex);
-		wl1271_debug(DEBUG_TX, "flushing tx buffer: %d %d",
+		wl1271_debug(DEBUG_MAC80211, "flushing tx buffer: %d %d",
 			     wl->tx_frames_cnt,
 			     wl1271_tx_total_queue_count(wl));
 		if ((wl->tx_frames_cnt == 0) &&
 		    (wl1271_tx_total_queue_count(wl) == 0)) {
 			mutex_unlock(&wl->mutex);
+			wl1271_debug(DEBUG_MAC80211, "tx flush took %d ms",
+				     jiffies_to_msecs(jiffies - start_time));
 			goto out;
 		}
 		mutex_unlock(&wl->mutex);
 		msleep(1);
 	}
 
-	wl1271_warning("Unable to flush all TX buffers, timed out.");
+	wl1271_warning("Unable to flush all TX buffers, "
+		       "timed out (timeout %d ms",
+		       WL1271_TX_FLUSH_TIMEOUT / 1000);
 
 	/* forcibly flush all Tx buffers on our queues */
 	mutex_lock(&wl->mutex);
-- 
1.7.10.4

