Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:51856 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755179Ab2EREqy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 May 2012 00:46:54 -0400
Received: by weyu7 with SMTP id u7so1565076wey.19
        for <linux-wireless@vger.kernel.org>; Thu, 17 May 2012 21:46:53 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 4/5] wlcore: stop queues on Tx flush
Date: Fri, 18 May 2012 07:46:39 +0300
Message-Id: <1337316400-23875-5-git-send-email-arik@wizery.com> (sfid-20120518_064658_308616_E8076E7A)
In-Reply-To: <1337316400-23875-1-git-send-email-arik@wizery.com>
References: <1337316400-23875-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Stop network queues during Tx flush, and also drop other internal
mac80211 packets (mgmt) that may arrive when the queues are stopped.

When flush is done all driver queues are clear, forcefully if needed.

Protect the Tx flush operation with a new mutex, to prevent concurrency
that can mess us queue state.

Based on a patch by Eliad Peller <eliad@wizery.com>

Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/ti/wlcore/main.c   |    1 +
 drivers/net/wireless/ti/wlcore/tx.c     |   11 ++++++++++-
 drivers/net/wireless/ti/wlcore/tx.h     |    1 +
 drivers/net/wireless/ti/wlcore/wlcore.h |    3 +++
 4 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index 6e6926b..1daaf1d 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -5151,6 +5151,7 @@ struct ieee80211_hw *wlcore_alloc_hw(size_t priv_size)
 	wl->state = WL1271_STATE_OFF;
 	wl->fw_type = WL12XX_FW_TYPE_NONE;
 	mutex_init(&wl->mutex);
+	mutex_init(&wl->flush_mutex);
 
 	order = get_order(WL1271_AGGR_BUFFER_SIZE);
 	wl->aggr_buf = (u8 *)__get_free_pages(GFP_KERNEL, order);
diff --git a/drivers/net/wireless/ti/wlcore/tx.c b/drivers/net/wireless/ti/wlcore/tx.c
index f68567b..78bf1b9 100644
--- a/drivers/net/wireless/ti/wlcore/tx.c
+++ b/drivers/net/wireless/ti/wlcore/tx.c
@@ -1024,6 +1024,11 @@ void wl1271_tx_flush(struct wl1271 *wl)
 	int i;
 	timeout = jiffies + usecs_to_jiffies(WL1271_TX_FLUSH_TIMEOUT);
 
+	/* only one flush should be in progress, for consistent queue state */
+	mutex_lock(&wl->flush_mutex);
+
+	wlcore_stop_queues(wl, WLCORE_QUEUE_STOP_REASON_FLUSH);
+
 	while (!time_after(jiffies, timeout)) {
 		mutex_lock(&wl->mutex);
 		wl1271_debug(DEBUG_TX, "flushing tx buffer: %d %d",
@@ -1032,7 +1037,7 @@ void wl1271_tx_flush(struct wl1271 *wl)
 		if ((wl->tx_frames_cnt == 0) &&
 		    (wl1271_tx_total_queue_count(wl) == 0)) {
 			mutex_unlock(&wl->mutex);
-			return;
+			goto out;
 		}
 		mutex_unlock(&wl->mutex);
 		msleep(1);
@@ -1045,6 +1050,10 @@ void wl1271_tx_flush(struct wl1271 *wl)
 	for (i = 0; i < WL12XX_MAX_LINKS; i++)
 		wl1271_tx_reset_link_queues(wl, i);
 	mutex_unlock(&wl->mutex);
+
+out:
+	wlcore_wake_queues(wl, WLCORE_QUEUE_STOP_REASON_FLUSH);
+	mutex_unlock(&wl->flush_mutex);
 }
 
 u32 wl1271_tx_min_rate_get(struct wl1271 *wl, u32 rate_set)
diff --git a/drivers/net/wireless/ti/wlcore/tx.h b/drivers/net/wireless/ti/wlcore/tx.h
index 6bf6956..e058a55 100644
--- a/drivers/net/wireless/ti/wlcore/tx.h
+++ b/drivers/net/wireless/ti/wlcore/tx.h
@@ -187,6 +187,7 @@ struct wl1271_tx_hw_res_if {
 enum wlcore_queue_stop_reason {
 	WLCORE_QUEUE_STOP_REASON_WATERMARK,
 	WLCORE_QUEUE_STOP_REASON_FW_RESTART,
+	WLCORE_QUEUE_STOP_REASON_FLUSH,
 };
 
 static inline int wl1271_tx_get_queue(int queue)
diff --git a/drivers/net/wireless/ti/wlcore/wlcore.h b/drivers/net/wireless/ti/wlcore/wlcore.h
index 94b79d5..c065ea6 100644
--- a/drivers/net/wireless/ti/wlcore/wlcore.h
+++ b/drivers/net/wireless/ti/wlcore/wlcore.h
@@ -379,6 +379,9 @@ struct wl1271 {
 
 	/* the current channel type */
 	enum nl80211_channel_type channel_type;
+
+	/* mutex for protecting the tx_flush function */
+	struct mutex flush_mutex;
 };
 
 int __devinit wlcore_probe(struct wl1271 *wl, struct platform_device *pdev);
-- 
1.7.9.5

