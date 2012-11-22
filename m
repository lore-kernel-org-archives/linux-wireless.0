Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:54251 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757178Ab2KVTfx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Nov 2012 14:35:53 -0500
Received: by mail-ee0-f46.google.com with SMTP id e53so3059964eek.19
        for <linux-wireless@vger.kernel.org>; Thu, 22 Nov 2012 11:35:52 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 12/13] wlcore: call ieee80211_sched_scan_stopped on interface removal
Date: Thu, 22 Nov 2012 14:05:27 +0200
Message-Id: <1353585928-28666-13-git-send-email-eliad@wizery.com> (sfid-20121122_203605_092367_82867C85)
In-Reply-To: <1353585928-28666-1-git-send-email-eliad@wizery.com>
References: <1353585928-28666-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The interface might go down before we got the SCHED_STOPPED
event, so make sure to call ieee80211_sched_scan_stopped()
if the scanned interface is removed.

Replace sched_scanning with sched_vif in order to save
the scanned interface.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/ti/wlcore/debugfs.c |    1 -
 drivers/net/wireless/ti/wlcore/event.c   |    4 ++--
 drivers/net/wireless/ti/wlcore/main.c    |   16 +++++++---------
 drivers/net/wireless/ti/wlcore/wlcore.h  |    2 +-
 4 files changed, 10 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/debugfs.c b/drivers/net/wireless/ti/wlcore/debugfs.c
index f0f88e6..43ecb3a 100644
--- a/drivers/net/wireless/ti/wlcore/debugfs.c
+++ b/drivers/net/wireless/ti/wlcore/debugfs.c
@@ -490,7 +490,6 @@ static ssize_t driver_state_read(struct file *file, char __user *user_buf,
 	DRIVER_STATE_PRINT_HEX(chip.id);
 	DRIVER_STATE_PRINT_STR(chip.fw_ver_str);
 	DRIVER_STATE_PRINT_STR(chip.phy_fw_ver_str);
-	DRIVER_STATE_PRINT_INT(sched_scanning);
 
 #undef DRIVER_STATE_PRINT_INT
 #undef DRIVER_STATE_PRINT_LONG
diff --git a/drivers/net/wireless/ti/wlcore/event.c b/drivers/net/wireless/ti/wlcore/event.c
index 3c20393..cb32c02 100644
--- a/drivers/net/wireless/ti/wlcore/event.c
+++ b/drivers/net/wireless/ti/wlcore/event.c
@@ -109,9 +109,9 @@ void wlcore_event_sched_scan_completed(struct wl1271 *wl,
 	wl1271_debug(DEBUG_EVENT, "PERIODIC_SCAN_COMPLETE_EVENT (status 0x%0x)",
 		     status);
 
-	if (wl->sched_scanning) {
+	if (wl->sched_vif) {
 		ieee80211_sched_scan_stopped(wl->hw);
-		wl->sched_scanning = false;
+		wl->sched_vif = NULL;
 	}
 }
 EXPORT_SYMBOL_GPL(wlcore_event_sched_scan_completed);
diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index 221762b..75de758 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -923,11 +923,6 @@ static void wl1271_recovery_work(struct work_struct *work)
 	/* Prevent spurious TX during FW restart */
 	wlcore_stop_queues(wl, WLCORE_QUEUE_STOP_REASON_FW_RESTART);
 
-	if (wl->sched_scanning) {
-		ieee80211_sched_scan_stopped(wl->hw);
-		wl->sched_scanning = false;
-	}
-
 	/* reboot the chipset */
 	while (!list_empty(&wl->wlvif_list)) {
 		wlvif = list_first_entry(&wl->wlvif_list,
@@ -1871,7 +1866,6 @@ static void wlcore_op_stop_locked(struct wl1271 *wl)
 	wl->time_offset = 0;
 	wl->ap_fw_ps_map = 0;
 	wl->ap_ps_map = 0;
-	wl->sched_scanning = false;
 	wl->sleep_auth = WL1271_PSM_ILLEGAL;
 	memset(wl->roles_map, 0, sizeof(wl->roles_map));
 	memset(wl->links_map, 0, sizeof(wl->links_map));
@@ -2405,6 +2399,11 @@ static void __wl1271_op_remove_interface(struct wl1271 *wl,
 		ieee80211_scan_completed(wl->hw, true);
 	}
 
+	if (wl->sched_vif == wlvif) {
+		ieee80211_sched_scan_stopped(wl->hw);
+		wl->sched_vif = NULL;
+	}
+
 	if (!test_bit(WL1271_FLAG_RECOVERY_IN_PROGRESS, &wl->flags)) {
 		/* disable active roles */
 		ret = wl1271_ps_elp_wakeup(wl);
@@ -3439,7 +3438,7 @@ static int wl1271_op_sched_scan_start(struct ieee80211_hw *hw,
 	if (ret < 0)
 		goto out_sleep;
 
-	wl->sched_scanning = true;
+	wl->sched_vif = wlvif;
 
 out_sleep:
 	wl1271_ps_elp_sleep(wl);
@@ -3928,7 +3927,7 @@ static int wlcore_set_bssid(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 						wlvif->band);
 
 	/* we only support sched_scan while not connected */
-	if (wl->sched_scanning)
+	if (wl->sched_vif == wlvif)
 		wl->ops->sched_scan_stop(wl, wlvif);
 
 	ret = wl1271_acx_sta_rate_policies(wl, wlvif);
@@ -5638,7 +5637,6 @@ struct ieee80211_hw *wlcore_alloc_hw(size_t priv_size, u32 aggr_buf_size,
 	wl->ap_fw_ps_map = 0;
 	wl->quirks = 0;
 	wl->platform_quirks = 0;
-	wl->sched_scanning = false;
 	wl->system_hlid = WL12XX_SYSTEM_HLID;
 	wl->active_sta_count = 0;
 	wl->fwlog_size = 0;
diff --git a/drivers/net/wireless/ti/wlcore/wlcore.h b/drivers/net/wireless/ti/wlcore/wlcore.h
index eacace0..6614b59 100644
--- a/drivers/net/wireless/ti/wlcore/wlcore.h
+++ b/drivers/net/wireless/ti/wlcore/wlcore.h
@@ -309,7 +309,7 @@ struct wl1271 {
 	struct ieee80211_vif *roc_vif;
 	struct delayed_work roc_complete_work;
 
-	bool sched_scanning;
+	struct wl12xx_vif *sched_vif;
 
 	/* The current band */
 	enum ieee80211_band band;
-- 
1.7.6.401.g6a319

