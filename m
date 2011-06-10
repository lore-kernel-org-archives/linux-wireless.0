Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:41063 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753578Ab1FJHsp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Jun 2011 03:48:45 -0400
Received: by mail-ww0-f44.google.com with SMTP id 36so2492123wwa.1
        for <linux-wireless@vger.kernel.org>; Fri, 10 Jun 2011 00:48:45 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 3/3] wl12xx: implement cancel_hw_scan() callback
Date: Fri, 10 Jun 2011 10:49:19 +0300
Message-Id: <1307692159-11055-3-git-send-email-eliad@wizery.com> (sfid-20110610_094850_739855_013F6ECB)
In-Reply-To: <1307692159-11055-1-git-send-email-eliad@wizery.com>
References: <1307692159-11055-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

After implementing cancel_hw_scan(), there is no more need to
flush scan_complete_work on suspend.

scan_complete_work enqueues a new scan_work, that might lead
to the following warning (if the device was already suspended):

WARNING: at drivers/mmc/core/core.c:169 mmc_wait_for_req+0x1ac/0x2c8()
Backtrace:
[<c004b50c>] (dump_backtrace+0x0/0x110)
[<c04fda50>] (dump_stack+0x0/0x1c)
[<c008f700>] (warn_slowpath_common+0x0/0x6c)
[<c008f76c>] (warn_slowpath_null+0x0/0x2c)
[<c034b058>] (mmc_wait_for_req+0x0/0x2c8)
[<c034f804>] (mmc_io_rw_extended+0x0/0x1e4)
[<c0350b5c>] (sdio_io_rw_ext_helper+0x0/0x1ac)
[<c0350e00>] (sdio_memcpy_fromio+0x0/0x2c)
[<bf194464>] (wl1271_sdio_raw_read+0x0/0x1bc [wl12xx_sdio])
[<bf15ac14>] (wl1271_cmd_wait_for_event_or_timeout+0x0/0x19c [wl12xx])
[<bf15adb0>] (wl1271_cmd_wait_for_event+0x0/0x30 [wl12xx])
[<bf15b7dc>] (wl1271_cmd_disconnect+0x0/0x14c [wl12xx])
[<bf158fd0>] (wl1271_unjoin+0x0/0x48 [wl12xx])
[<bf159070>] (wl1271_op_config+0x0/0x490 [wl12xx])
[<bf105084>] (ieee80211_hw_config+0x0/0x14c [mac80211])
[<bf113120>] (ieee80211_recalc_idle+0x0/0x4c [mac80211])
[<bf109a70>] (__ieee80211_scan_completed+0x0/0x1ac [mac80211])
[<bf109fd4>] (ieee80211_scan_work+0x0/0x484 [mac80211])
[<c00a197c>] (worker_thread+0x0/0x1e8)
[<c00a5874>] (kthread+0x0/0x90)

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/main.c |   44 +++++++++++++++++++++++++++++++++++-
 1 files changed, 43 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 7017c23..4e0c92a 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -1594,7 +1594,6 @@ static int wl1271_op_suspend(struct ieee80211_hw *hw,
 	}
 	/* flush any remaining work */
 	wl1271_debug(DEBUG_MAC80211, "flushing remaining works");
-	flush_delayed_work(&wl->scan_complete_work);
 
 	/*
 	 * disable and re-enable interrupts in order to flush
@@ -2644,6 +2643,48 @@ out:
 	return ret;
 }
 
+static int wl1271_op_cancel_hw_scan(struct ieee80211_hw *hw,
+				    struct ieee80211_vif *vif)
+{
+	struct wl1271 *wl = hw->priv;
+	int ret = 0;
+
+	wl1271_debug(DEBUG_MAC80211, "mac80211 cancel hw scan");
+
+	mutex_lock(&wl->mutex);
+
+	if (wl->state == WL1271_STATE_OFF) {
+		ret = -EAGAIN;
+		goto out;
+	}
+
+	if (wl->scan.state == WL1271_SCAN_STATE_IDLE)
+		goto out;
+
+	ret = wl1271_ps_elp_wakeup(wl);
+	if (ret < 0)
+		goto out;
+
+	if (wl->scan.state != WL1271_SCAN_STATE_DONE) {
+		ret = wl1271_scan_stop(wl);
+		if (ret < 0)
+			goto out_sleep;
+	}
+	wl->scan.state = WL1271_SCAN_STATE_IDLE;
+	memset(wl->scan.scanned_ch, 0, sizeof(wl->scan.scanned_ch));
+	wl->scan.req = NULL;
+	ieee80211_scan_completed(wl->hw, true);
+
+out_sleep:
+	wl1271_ps_elp_sleep(wl);
+out:
+	mutex_unlock(&wl->mutex);
+
+	cancel_delayed_work_sync(&wl->scan_complete_work);
+
+	return ret;
+}
+
 static int wl1271_op_sched_scan_start(struct ieee80211_hw *hw,
 				      struct ieee80211_vif *vif,
 				      struct cfg80211_sched_scan_request *req,
@@ -3815,6 +3856,7 @@ static const struct ieee80211_ops wl1271_ops = {
 	.tx = wl1271_op_tx,
 	.set_key = wl1271_op_set_key,
 	.hw_scan = wl1271_op_hw_scan,
+	.cancel_hw_scan = wl1271_op_cancel_hw_scan,
 	.sched_scan_start = wl1271_op_sched_scan_start,
 	.sched_scan_stop = wl1271_op_sched_scan_stop,
 	.bss_info_changed = wl1271_op_bss_info_changed,
-- 
1.7.0.4

