Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:63694 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758387Ab2CMSE0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Mar 2012 14:04:26 -0400
Received: by wejx9 with SMTP id x9so810246wej.19
        for <linux-wireless@vger.kernel.org>; Tue, 13 Mar 2012 11:04:25 -0700 (PDT)
From: Eyal Shapira <eyal@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH] wl12xx: fix race between suspend/resume and recovery
Date: Tue, 13 Mar 2012 20:03:21 +0200
Message-Id: <1331661801-17000-1-git-send-email-eyal@wizery.com> (sfid-20120313_190430_125938_641829F6)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The iteration on the wlvif list in wl1271_op_resume/suspend was
perfomed before locking wl->mutex which would lead to a kernel
panic in case a recovery was queued at the same time
and would delete the wlvifs from the list.

Signed-off-by: Eyal Shapira <eyal@wizery.com>
---
 drivers/net/wireless/wl12xx/main.c |   29 ++++++++++++-----------------
 1 files changed, 12 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 3900236..791cdcc 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -1652,14 +1652,12 @@ static int wl1271_configure_suspend_sta(struct wl1271 *wl,
 {
 	int ret = 0;
 
-	mutex_lock(&wl->mutex);
-
 	if (!test_bit(WLVIF_FLAG_STA_ASSOCIATED, &wlvif->flags))
-		goto out_unlock;
+		goto out;
 
 	ret = wl1271_ps_elp_wakeup(wl);
 	if (ret < 0)
-		goto out_unlock;
+		goto out;
 
 	ret = wl1271_acx_wake_up_conditions(wl, wlvif,
 				    wl->conf.conn.suspend_wake_up_event,
@@ -1668,11 +1666,9 @@ static int wl1271_configure_suspend_sta(struct wl1271 *wl,
 	if (ret < 0)
 		wl1271_error("suspend: set wake up conditions failed: %d", ret);
 
-
 	wl1271_ps_elp_sleep(wl);
 
-out_unlock:
-	mutex_unlock(&wl->mutex);
+out:
 	return ret;
 
 }
@@ -1682,20 +1678,17 @@ static int wl1271_configure_suspend_ap(struct wl1271 *wl,
 {
 	int ret = 0;
 
-	mutex_lock(&wl->mutex);
-
 	if (!test_bit(WLVIF_FLAG_AP_STARTED, &wlvif->flags))
-		goto out_unlock;
+		goto out;
 
 	ret = wl1271_ps_elp_wakeup(wl);
 	if (ret < 0)
-		goto out_unlock;
+		goto out;
 
 	ret = wl1271_acx_beacon_filter_opt(wl, wlvif, true);
 
 	wl1271_ps_elp_sleep(wl);
-out_unlock:
-	mutex_unlock(&wl->mutex);
+out:
 	return ret;
 
 }
@@ -1720,10 +1713,9 @@ static void wl1271_configure_resume(struct wl1271 *wl,
 	if ((!is_ap) && (!is_sta))
 		return;
 
-	mutex_lock(&wl->mutex);
 	ret = wl1271_ps_elp_wakeup(wl);
 	if (ret < 0)
-		goto out;
+		return;
 
 	if (is_sta) {
 		ret = wl1271_acx_wake_up_conditions(wl, wlvif,
@@ -1739,8 +1731,6 @@ static void wl1271_configure_resume(struct wl1271 *wl,
 	}
 
 	wl1271_ps_elp_sleep(wl);
-out:
-	mutex_unlock(&wl->mutex);
 }
 
 static int wl1271_op_suspend(struct ieee80211_hw *hw,
@@ -1755,6 +1745,7 @@ static int wl1271_op_suspend(struct ieee80211_hw *hw,
 
 	wl1271_tx_flush(wl);
 
+	mutex_lock(&wl->mutex);
 	wl->wow_enabled = true;
 	wl12xx_for_each_wlvif(wl, wlvif) {
 		ret = wl1271_configure_suspend(wl, wlvif);
@@ -1763,6 +1754,7 @@ static int wl1271_op_suspend(struct ieee80211_hw *hw,
 			return ret;
 		}
 	}
+	mutex_unlock(&wl->mutex);
 	/* flush any remaining work */
 	wl1271_debug(DEBUG_MAC80211, "flushing remaining works");
 
@@ -1812,10 +1804,13 @@ static int wl1271_op_resume(struct ieee80211_hw *hw)
 		wl1271_irq(0, wl);
 		wl1271_enable_interrupts(wl);
 	}
+
+	mutex_lock(&wl->mutex);
 	wl12xx_for_each_wlvif(wl, wlvif) {
 		wl1271_configure_resume(wl, wlvif);
 	}
 	wl->wow_enabled = false;
+	mutex_unlock(&wl->mutex);
 
 	return 0;
 }
-- 
1.7.4.1

