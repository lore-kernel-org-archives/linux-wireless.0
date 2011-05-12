Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog114.obsmtp.com ([74.125.149.211]:44038 "EHLO
	na3sys009aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757476Ab1ELOP4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 May 2011 10:15:56 -0400
Received: by mail-ew0-f53.google.com with SMTP id 8so477220ewy.26
        for <linux-wireless@vger.kernel.org>; Thu, 12 May 2011 07:15:55 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 4/7] wl12xx: implement scheduled scan driver operations and reporting
Date: Thu, 12 May 2011 17:15:37 +0300
Message-Id: <1305209740-30287-5-git-send-email-coelho@ti.com> (sfid-20110512_161559_247551_BFA1E829)
In-Reply-To: <1305209740-30287-1-git-send-email-coelho@ti.com>
References: <1305209740-30287-1-git-send-email-coelho@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds the mac80211 operations for scheduled scan and the
scheduled scan results reporting.

Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/wl12xx/event.c  |    6 +++
 drivers/net/wireless/wl12xx/main.c   |   70 ++++++++++++++++++++++++++++++++++
 drivers/net/wireless/wl12xx/scan.c   |    6 ++-
 drivers/net/wireless/wl12xx/wl12xx.h |    2 +
 4 files changed, 83 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/event.c b/drivers/net/wireless/wl12xx/event.c
index dc110e8..1e4bd6a 100644
--- a/drivers/net/wireless/wl12xx/event.c
+++ b/drivers/net/wireless/wl12xx/event.c
@@ -191,11 +191,17 @@ static int wl1271_event_process(struct wl1271 *wl, struct event_mailbox *mbox)
 	if (vector & PERIODIC_SCAN_REPORT_EVENT_ID) {
 		wl1271_debug(DEBUG_EVENT, "PERIODIC_SCAN_REPORT_EVENT "
 			     "(status 0x%0x)", mbox->scheduled_scan_status);
+
+		wl1271_scan_sched_scan_results(wl);
 	}
 
 	if (vector & PERIODIC_SCAN_COMPLETE_EVENT_ID) {
 		wl1271_debug(DEBUG_EVENT, "PERIODIC_SCAN_COMPLETE_EVENT "
 			     "(status 0x%0x)", mbox->scheduled_scan_status);
+		if (wl->sched_scanning) {
+			wl1271_scan_sched_scan_stop(wl);
+			ieee80211_sched_scan_stopped(wl->hw);
+		}
 	}
 
 	/* disable dynamic PS when requested by the firmware */
diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index cb4ed90..b169dae 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -984,6 +984,11 @@ static void wl1271_recovery_work(struct work_struct *work)
 	/* Prevent spurious TX during FW restart */
 	ieee80211_stop_queues(wl->hw);
 
+	if (wl->sched_scanning) {
+		ieee80211_sched_scan_stopped(wl->hw);
+		wl->sched_scanning = false;
+	}
+
 	/* reboot the chipset */
 	__wl1271_op_remove_interface(wl, false);
 	ieee80211_restart_hw(wl->hw);
@@ -1572,6 +1577,7 @@ static void __wl1271_op_remove_interface(struct wl1271 *wl,
 	memset(wl->ap_hlid_map, 0, sizeof(wl->ap_hlid_map));
 	wl->ap_fw_ps_map = 0;
 	wl->ap_ps_map = 0;
+	wl->sched_scanning = false;
 
 	/*
 	 * this is performed after the cancel_work calls and the associated
@@ -1774,6 +1780,13 @@ static int wl1271_sta_handle_idle(struct wl1271 *wl, bool idle)
 		wl->session_counter++;
 		if (wl->session_counter >= SESSION_COUNTER_MAX)
 			wl->session_counter = 0;
+
+		/* The current firmware only supports sched_scan in idle */
+		if (wl->sched_scanning) {
+			wl1271_scan_sched_scan_stop(wl);
+			ieee80211_sched_scan_stopped(wl->hw);
+		}
+
 		ret = wl1271_dummy_join(wl);
 		if (ret < 0)
 			goto out;
@@ -2326,6 +2339,60 @@ out:
 	return ret;
 }
 
+static int wl1271_op_sched_scan_start(struct ieee80211_hw *hw,
+				      struct ieee80211_vif *vif,
+				      struct cfg80211_sched_scan_request *req,
+				      struct ieee80211_sched_scan_ies *ies)
+{
+	struct wl1271 *wl = hw->priv;
+	int ret;
+
+	wl1271_debug(DEBUG_MAC80211, "wl1271_op_sched_scan_start");
+
+	mutex_lock(&wl->mutex);
+
+	ret = wl1271_ps_elp_wakeup(wl);
+	if (ret < 0)
+		goto out;
+
+	ret = wl1271_scan_sched_scan_config(wl, req, ies);
+	if (ret < 0)
+		goto out_sleep;
+
+	ret = wl1271_scan_sched_scan_start(wl);
+	if (ret < 0)
+		goto out_sleep;
+
+	wl->sched_scanning = true;
+
+out_sleep:
+	wl1271_ps_elp_sleep(wl);
+out:
+	mutex_unlock(&wl->mutex);
+	return ret;
+}
+
+static void wl1271_op_sched_scan_stop(struct ieee80211_hw *hw,
+				      struct ieee80211_vif *vif)
+{
+	struct wl1271 *wl = hw->priv;
+	int ret;
+
+	wl1271_debug(DEBUG_MAC80211, "wl1271_op_sched_scan_stop");
+
+	mutex_lock(&wl->mutex);
+
+	ret = wl1271_ps_elp_wakeup(wl);
+	if (ret < 0)
+		goto out;
+
+	wl1271_scan_sched_scan_stop(wl);
+
+	wl1271_ps_elp_sleep(wl);
+out:
+	mutex_unlock(&wl->mutex);
+}
+
 static int wl1271_op_set_frag_threshold(struct ieee80211_hw *hw, u32 value)
 {
 	struct wl1271 *wl = hw->priv;
@@ -3441,6 +3508,8 @@ static const struct ieee80211_ops wl1271_ops = {
 	.tx = wl1271_op_tx,
 	.set_key = wl1271_op_set_key,
 	.hw_scan = wl1271_op_hw_scan,
+	.sched_scan_start = wl1271_op_sched_scan_start,
+	.sched_scan_stop = wl1271_op_sched_scan_stop,
 	.bss_info_changed = wl1271_op_bss_info_changed,
 	.set_frag_threshold = wl1271_op_set_frag_threshold,
 	.set_rts_threshold = wl1271_op_set_rts_threshold,
@@ -3760,6 +3829,7 @@ struct ieee80211_hw *wl1271_alloc_hw(void)
 	wl->ap_fw_ps_map = 0;
 	wl->quirks = 0;
 	wl->platform_quirks = 0;
+	wl->sched_scanning = false;
 
 	memset(wl->tx_frames_map, 0, sizeof(wl->tx_frames_map));
 	for (i = 0; i < ACX_TX_DESCRIPTORS; i++)
diff --git a/drivers/net/wireless/wl12xx/scan.c b/drivers/net/wireless/wl12xx/scan.c
index d78044f..668ff46 100644
--- a/drivers/net/wireless/wl12xx/scan.c
+++ b/drivers/net/wireless/wl12xx/scan.c
@@ -548,8 +548,12 @@ void wl1271_scan_sched_scan_stop(struct wl1271 *wl)
 
 	ret = wl1271_cmd_send(wl, CMD_STOP_PERIODIC_SCAN, stop,
 			      sizeof(*stop), 0);
-	if (ret < 0)
+	if (ret < 0) {
 		wl1271_error("failed to send sched scan stop command");
+		goto out_free;
+	}
+	wl->sched_scanning = false;
 
+out_free:
 	kfree(stop);
 }
diff --git a/drivers/net/wireless/wl12xx/wl12xx.h b/drivers/net/wireless/wl12xx/wl12xx.h
index b760143..10f0767 100644
--- a/drivers/net/wireless/wl12xx/wl12xx.h
+++ b/drivers/net/wireless/wl12xx/wl12xx.h
@@ -480,6 +480,8 @@ struct wl1271 {
 	struct wl1271_scan scan;
 	struct delayed_work scan_complete_work;
 
+	bool sched_scanning;
+
 	/* probe-req template for the current AP */
 	struct sk_buff *probereq;
 
-- 
1.7.1

