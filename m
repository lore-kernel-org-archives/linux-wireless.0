Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog121.obsmtp.com ([74.125.149.145]:50209 "EHLO
	na3sys009aog121.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759863Ab2EPIoQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 May 2012 04:44:16 -0400
Received: by obbwd18 with SMTP id wd18so946589obb.0
        for <linux-wireless@vger.kernel.org>; Wed, 16 May 2012 01:44:15 -0700 (PDT)
From: Yoni Divinsky <yoni.divinsky@ti.com>
To: <linux-wireless@vger.kernel.org>
Cc: <arik@wizery.com>, <coelho@ti.com>
Subject: [PATCH] wlcore: add role_id to all the sched_scan commands
Date: Wed, 16 May 2012 11:34:17 +0300
Message-Id: <1337157258-15163-1-git-send-email-yoni.divinsky@ti.com> (sfid-20120516_104425_853648_CE84A019)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Due to a need by the firmware when working in multirole
the role id needs to be added to the structs of the
following commands:
CMD_CONNECTION_SCAN_CFG, CMD_CONNECTION_SCAN_SSID_CFG,
CMD_START_PERIODIC_SCAN, CMD_STOP_PERIODIC_SCAN

Signed-off-by: Yoni Divinsky <yoni.divinsky@ti.com>
Signed-off-by: Igal Chernobelsky <igalc@ti.com>
---
 drivers/net/wireless/ti/wlcore/main.c |    5 +++--
 drivers/net/wireless/ti/wlcore/scan.c |    9 +++++++--
 drivers/net/wireless/ti/wlcore/scan.h |   15 +++++++++------
 3 files changed, 19 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index b6718e0..2d3f8f7 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -2448,7 +2448,7 @@ static int wl1271_sta_handle_idle(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 	} else {
 		/* The current firmware only supports sched_scan in idle */
 		if (wl->sched_scanning) {
-			wl1271_scan_sched_scan_stop(wl);
+			wl1271_scan_sched_scan_stop(wl, wlvif);
 			ieee80211_sched_scan_stopped(wl->hw);
 		}
 
@@ -3198,6 +3198,7 @@ static void wl1271_op_sched_scan_stop(struct ieee80211_hw *hw,
 				      struct ieee80211_vif *vif)
 {
 	struct wl1271 *wl = hw->priv;
+	struct wl12xx_vif *wlvif = wl12xx_vif_to_data(vif);
 	int ret;
 
 	wl1271_debug(DEBUG_MAC80211, "wl1271_op_sched_scan_stop");
@@ -3211,7 +3212,7 @@ static void wl1271_op_sched_scan_stop(struct ieee80211_hw *hw,
 	if (ret < 0)
 		goto out;
 
-	wl1271_scan_sched_scan_stop(wl);
+	wl1271_scan_sched_scan_stop(wl, wlvif);
 
 	wl1271_ps_elp_sleep(wl);
 out:
diff --git a/drivers/net/wireless/ti/wlcore/scan.c b/drivers/net/wireless/ti/wlcore/scan.c
index 97022f4..30bedd8 100644
--- a/drivers/net/wireless/ti/wlcore/scan.c
+++ b/drivers/net/wireless/ti/wlcore/scan.c
@@ -564,6 +564,7 @@ wl1271_scan_sched_scan_channels(struct wl1271 *wl,
 /* Returns the scan type to be used or a negative value on error */
 static int
 wl12xx_scan_sched_scan_ssid_list(struct wl1271 *wl,
+				 struct wl12xx_vif *wlvif,
 				 struct cfg80211_sched_scan_request *req)
 {
 	struct wl1271_cmd_sched_scan_ssid_list *cmd = NULL;
@@ -592,6 +593,7 @@ wl12xx_scan_sched_scan_ssid_list(struct wl1271 *wl,
 		goto out;
 	}
 
+	cmd->role_id = wlvif->dev_role_id;
 	if (!n_match_ssids) {
 		/* No filter, with ssids */
 		type = SCAN_SSID_FILTER_DISABLED;
@@ -679,6 +681,7 @@ int wl1271_scan_sched_scan_config(struct wl1271 *wl,
 	if (!cfg)
 		return -ENOMEM;
 
+	cfg->role_id = wlvif->dev_role_id;
 	cfg->rssi_threshold = c->rssi_threshold;
 	cfg->snr_threshold  = c->snr_threshold;
 	cfg->n_probe_reqs = c->num_probe_reqs;
@@ -696,7 +699,7 @@ int wl1271_scan_sched_scan_config(struct wl1271 *wl,
 		cfg->intervals[i] = cpu_to_le32(req->interval);
 
 	cfg->ssid_len = 0;
-	ret = wl12xx_scan_sched_scan_ssid_list(wl, req);
+	ret = wl12xx_scan_sched_scan_ssid_list(wl, wlvif, req);
 	if (ret < 0)
 		goto out;
 
@@ -768,6 +771,7 @@ int wl1271_scan_sched_scan_start(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 	if (!start)
 		return -ENOMEM;
 
+	start->role_id = wlvif->dev_role_id;
 	start->tag = WL1271_SCAN_DEFAULT_TAG;
 
 	ret = wl1271_cmd_send(wl, CMD_START_PERIODIC_SCAN, start,
@@ -789,7 +793,7 @@ void wl1271_scan_sched_scan_results(struct wl1271 *wl)
 	ieee80211_sched_scan_results(wl->hw);
 }
 
-void wl1271_scan_sched_scan_stop(struct wl1271 *wl)
+void wl1271_scan_sched_scan_stop(struct wl1271 *wl,  struct wl12xx_vif *wlvif)
 {
 	struct wl1271_cmd_sched_scan_stop *stop;
 	int ret = 0;
@@ -803,6 +807,7 @@ void wl1271_scan_sched_scan_stop(struct wl1271 *wl)
 		return;
 	}
 
+	stop->role_id = wlvif->dev_role_id;
 	stop->tag = WL1271_SCAN_DEFAULT_TAG;
 
 	ret = wl1271_cmd_send(wl, CMD_STOP_PERIODIC_SCAN, stop,
diff --git a/drivers/net/wireless/ti/wlcore/scan.h b/drivers/net/wireless/ti/wlcore/scan.h
index ea53223..29f3c8d 100644
--- a/drivers/net/wireless/ti/wlcore/scan.h
+++ b/drivers/net/wireless/ti/wlcore/scan.h
@@ -40,7 +40,7 @@ int wl1271_scan_sched_scan_config(struct wl1271 *wl,
 				     struct cfg80211_sched_scan_request *req,
 				     struct ieee80211_sched_scan_ies *ies);
 int wl1271_scan_sched_scan_start(struct wl1271 *wl, struct wl12xx_vif *wlvif);
-void wl1271_scan_sched_scan_stop(struct wl1271 *wl);
+void wl1271_scan_sched_scan_stop(struct wl1271 *wl,  struct wl12xx_vif *wlvif);
 void wl1271_scan_sched_scan_results(struct wl1271 *wl);
 
 #define WL1271_SCAN_MAX_CHANNELS       24
@@ -188,8 +188,8 @@ struct wl1271_cmd_sched_scan_config {
 
 	u8 n_pactive_ch; /* number of pactive (passive until fw detects energy)
 			    channels in BG band */
-
-	u8 padding[2];
+	u8 role_id;
+	u8 padding[1];
 
 	struct conn_scan_ch_params channels_2[MAX_CHANNELS_2GHZ];
 	struct conn_scan_ch_params channels_5[MAX_CHANNELS_5GHZ];
@@ -216,21 +216,24 @@ struct wl1271_cmd_sched_scan_ssid_list {
 
 	u8 n_ssids;
 	struct wl1271_ssid ssids[SCHED_SCAN_MAX_SSIDS];
-	u8 padding[3];
+	u8 role_id;
+	u8 padding[2];
 } __packed;
 
 struct wl1271_cmd_sched_scan_start {
 	struct wl1271_cmd_header header;
 
 	u8 tag;
-	u8 padding[3];
+	u8 role_id;
+	u8 padding[2];
 } __packed;
 
 struct wl1271_cmd_sched_scan_stop {
 	struct wl1271_cmd_header header;
 
 	u8 tag;
-	u8 padding[3];
+	u8 role_id;
+	u8 padding[2];
 } __packed;
 
 
-- 
1.7.0.4

