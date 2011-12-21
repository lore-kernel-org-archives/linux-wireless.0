Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:64408 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753057Ab1LUMGf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Dec 2011 07:06:35 -0500
Received: by wibhm6 with SMTP id hm6so1893772wib.19
        for <linux-wireless@vger.kernel.org>; Wed, 21 Dec 2011 04:06:34 -0800 (PST)
From: Eyal Shapira <eyal@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH] wl12xx: trigger recovery for failures in sched scan stop
Date: Wed, 21 Dec 2011 14:06:26 +0200
Message-Id: <1324469186-18507-1-git-send-email-eyal@wizery.com> (sfid-20111221_130639_870619_1F960185)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

mac80211 requires that drv_sched_scan_stop
will always succeed. We have a few possible errors
such as OOM, failure to ELP wakeup, fail in the FW command.
Instead of no-op , trigger a recovery which would
mark sched scan as stopped and clear up any bad FW state.

Signed-off-by: Eyal Shapira <eyal@wizery.com>
---
 drivers/net/wireless/wl12xx/main.c |    4 +++-
 drivers/net/wireless/wl12xx/scan.c |   14 +++++++++-----
 2 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index d5f55a1..0d3de3e 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -3137,8 +3137,10 @@ static void wl1271_op_sched_scan_stop(struct ieee80211_hw *hw,
 	mutex_lock(&wl->mutex);
 
 	ret = wl1271_ps_elp_wakeup(wl);
-	if (ret < 0)
+	if (ret < 0) {
+		wl12xx_queue_recovery_work(wl);
 		goto out;
+	}
 
 	wl1271_scan_sched_scan_stop(wl);
 
diff --git a/drivers/net/wireless/wl12xx/scan.c b/drivers/net/wireless/wl12xx/scan.c
index e24111e..108bed4 100644
--- a/drivers/net/wireless/wl12xx/scan.c
+++ b/drivers/net/wireless/wl12xx/scan.c
@@ -739,22 +739,26 @@ void wl1271_scan_sched_scan_stop(struct wl1271 *wl)
 
 	wl1271_debug(DEBUG_CMD, "cmd periodic scan stop");
 
-	/* FIXME: what to do if alloc'ing to stop fails? */
 	stop = kzalloc(sizeof(*stop), GFP_KERNEL);
 	if (!stop) {
 		wl1271_error("failed to alloc memory to send sched scan stop");
-		return;
+		goto recovery;
 	}
 
 	stop->tag = WL1271_SCAN_DEFAULT_TAG;
 
 	ret = wl1271_cmd_send(wl, CMD_STOP_PERIODIC_SCAN, stop,
 			      sizeof(*stop), 0);
+
+	kfree(stop);
+
 	if (ret < 0) {
 		wl1271_error("failed to send sched scan stop command");
-		goto out_free;
+		goto recovery;
 	}
 
-out_free:
-	kfree(stop);
+	return;
+
+recovery:
+	wl12xx_queue_recovery_work(wl);
 }
-- 
1.7.4.1

