Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh01.mail.saunalahti.fi ([62.142.5.107]:37732 "EHLO
	emh01.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756711Ab2I0Kin (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Sep 2012 06:38:43 -0400
From: Luciano Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: coelho@ti.com, Eliad Peller <eliad@wizery.com>
Subject: [PATCH 16/31] wlcore: always use wlvif->role_id for scans
Date: Thu, 27 Sep 2012 13:37:54 +0300
Message-Id: <1348742289-6587-17-git-send-email-luca@coelho.fi> (sfid-20120927_123934_971898_E25988DF)
In-Reply-To: <1348742289-6587-1-git-send-email-luca@coelho.fi>
References: <1348742289-6587-1-git-send-email-luca@coelho.fi>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eliad Peller <eliad@wizery.com>

enabled (but not-started) sta role should be good enough
for scanning (both normal and scheduled), so use it
instead of the device_role.

Signed-off-by: Eliad Peller <eliad@wizery.com>
Signed-off-by: Luciano Coelho <luca@coelho.fi>
---
 drivers/net/wireless/ti/wlcore/scan.c |   18 +++++++-----------
 1 file changed, 7 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/scan.c b/drivers/net/wireless/ti/wlcore/scan.c
index bc92487..d005014 100644
--- a/drivers/net/wireless/ti/wlcore/scan.c
+++ b/drivers/net/wireless/ti/wlcore/scan.c
@@ -184,11 +184,7 @@ static int wl1271_scan_send(struct wl1271 *wl, struct ieee80211_vif *vif,
 	if (passive)
 		scan_options |= WL1271_SCAN_OPT_PASSIVE;
 
-	if (wlvif->bss_type == BSS_TYPE_AP_BSS ||
-	    test_bit(WLVIF_FLAG_STA_ASSOCIATED, &wlvif->flags))
-		cmd->params.role_id = wlvif->role_id;
-	else
-		cmd->params.role_id = wlvif->dev_role_id;
+	cmd->params.role_id = wlvif->role_id;
 
 	if (WARN_ON(cmd->params.role_id == WL12XX_INVALID_ROLE_ID)) {
 		ret = -EINVAL;
@@ -593,7 +589,7 @@ wl12xx_scan_sched_scan_ssid_list(struct wl1271 *wl,
 		goto out;
 	}
 
-	cmd->role_id = wlvif->dev_role_id;
+	cmd->role_id = wlvif->role_id;
 	if (!n_match_ssids) {
 		/* No filter, with ssids */
 		type = SCAN_SSID_FILTER_DISABLED;
@@ -683,7 +679,7 @@ int wl1271_scan_sched_scan_config(struct wl1271 *wl,
 	if (!cfg)
 		return -ENOMEM;
 
-	cfg->role_id = wlvif->dev_role_id;
+	cfg->role_id = wlvif->role_id;
 	cfg->rssi_threshold = c->rssi_threshold;
 	cfg->snr_threshold  = c->snr_threshold;
 	cfg->n_probe_reqs = c->num_probe_reqs;
@@ -718,7 +714,7 @@ int wl1271_scan_sched_scan_config(struct wl1271 *wl,
 	if (!force_passive && cfg->active[0]) {
 		u8 band = IEEE80211_BAND_2GHZ;
 		ret = wl12xx_cmd_build_probe_req(wl, wlvif,
-						 wlvif->dev_role_id, band,
+						 wlvif->role_id, band,
 						 req->ssids[0].ssid,
 						 req->ssids[0].ssid_len,
 						 ies->ie[band],
@@ -732,7 +728,7 @@ int wl1271_scan_sched_scan_config(struct wl1271 *wl,
 	if (!force_passive && cfg->active[1]) {
 		u8 band = IEEE80211_BAND_5GHZ;
 		ret = wl12xx_cmd_build_probe_req(wl, wlvif,
-						 wlvif->dev_role_id, band,
+						 wlvif->role_id, band,
 						 req->ssids[0].ssid,
 						 req->ssids[0].ssid_len,
 						 ies->ie[band],
@@ -774,7 +770,7 @@ int wl1271_scan_sched_scan_start(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 	if (!start)
 		return -ENOMEM;
 
-	start->role_id = wlvif->dev_role_id;
+	start->role_id = wlvif->role_id;
 	start->tag = WL1271_SCAN_DEFAULT_TAG;
 
 	ret = wl1271_cmd_send(wl, CMD_START_PERIODIC_SCAN, start,
@@ -810,7 +806,7 @@ void wl1271_scan_sched_scan_stop(struct wl1271 *wl,  struct wl12xx_vif *wlvif)
 		return;
 	}
 
-	stop->role_id = wlvif->dev_role_id;
+	stop->role_id = wlvif->role_id;
 	stop->tag = WL1271_SCAN_DEFAULT_TAG;
 
 	ret = wl1271_cmd_send(wl, CMD_STOP_PERIODIC_SCAN, stop,
-- 
1.7.10.4

