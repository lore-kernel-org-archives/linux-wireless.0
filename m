Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:39255 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932384Ab0JZLYr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Oct 2010 07:24:47 -0400
Received: from vaebh106.NOE.Nokia.com (vaebh106.europe.nokia.com [10.160.244.32])
	by mgw-mx03.nokia.com (Switch-3.3.3/Switch-3.3.3) with ESMTP id o9QBOcbn012445
	for <linux-wireless@vger.kernel.org>; Tue, 26 Oct 2010 14:24:44 +0300
From: juuso.oikarinen@nokia.com
To: luciano.coelho@nokia.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 1/2] wl1271: Fix scan failure detection
Date: Tue, 26 Oct 2010 14:24:38 +0300
Message-Id: <1288092279-31272-1-git-send-email-juuso.oikarinen@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Juuso Oikarinen <juuso.oikarinen@nokia.com>

In scan_complete_work, because the mutex is released before accessing the
scan->failed flag, it is possible for unfounded hardware recovery rounds
to be executed.

Fix this.

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271_main.c |   17 ++++++++++++++---
 drivers/net/wireless/wl12xx/wl1271_scan.c |    5 +++--
 2 files changed, 17 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
index 63036b5..20027f4 100644
--- a/drivers/net/wireless/wl12xx/wl1271_main.c
+++ b/drivers/net/wireless/wl12xx/wl1271_main.c
@@ -1056,6 +1056,7 @@ static void __wl1271_op_remove_interface(struct wl1271 *wl)
 		wl->scan.state = WL1271_SCAN_STATE_IDLE;
 		kfree(wl->scan.scanned_ch);
 		wl->scan.scanned_ch = NULL;
+		wl->scan.req = NULL;
 		ieee80211_scan_completed(wl->hw, true);
 	}
 
@@ -1676,6 +1677,16 @@ static int wl1271_op_hw_scan(struct ieee80211_hw *hw,
 
 	mutex_lock(&wl->mutex);
 
+	if (wl->state == WL1271_STATE_OFF) {
+		/*
+		 * We cannot return -EBUSY here because mac80211 will expect
+		 * a call to ieee80211_scan_completed if we do - in this case
+		 * there won't be any call.
+		 */
+		ret = -EAGAIN;
+		goto out;
+	}
+
 	ret = wl1271_ps_elp_wakeup(wl, false);
 	if (ret < 0)
 		goto out;
@@ -2093,14 +2104,14 @@ static int wl1271_op_get_survey(struct ieee80211_hw *hw, int idx,
 {
 	struct wl1271 *wl = hw->priv;
 	struct ieee80211_conf *conf = &hw->conf;
- 
+
 	if (idx != 0)
 		return -ENOENT;
- 
+
 	survey->channel = conf->channel;
 	survey->filled = SURVEY_INFO_NOISE_DBM;
 	survey->noise = wl->noise;
- 
+
 	return 0;
 }
 
diff --git a/drivers/net/wireless/wl12xx/wl1271_scan.c b/drivers/net/wireless/wl12xx/wl1271_scan.c
index 909bb47..e0661a5 100644
--- a/drivers/net/wireless/wl12xx/wl1271_scan.c
+++ b/drivers/net/wireless/wl12xx/wl1271_scan.c
@@ -48,14 +48,15 @@ void wl1271_scan_complete_work(struct work_struct *work)
 	wl->scan.state = WL1271_SCAN_STATE_IDLE;
 	kfree(wl->scan.scanned_ch);
 	wl->scan.scanned_ch = NULL;
-	mutex_unlock(&wl->mutex);
-
+	wl->scan.req = NULL;
 	ieee80211_scan_completed(wl->hw, false);
 
 	if (wl->scan.failed) {
 		wl1271_info("Scan completed due to error.");
 		ieee80211_queue_work(wl->hw, &wl->recovery_work);
 	}
+	mutex_unlock(&wl->mutex);
+
 }
 
 
-- 
1.7.0.4

