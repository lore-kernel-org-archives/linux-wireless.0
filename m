Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:49614 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753299Ab2AaJyE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Jan 2012 04:54:04 -0500
Received: by mail-wi0-f174.google.com with SMTP id s10so4215776wic.19
        for <linux-wireless@vger.kernel.org>; Tue, 31 Jan 2012 01:54:03 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH v2 02/10] wl12xx: use dev_role_id for scans
Date: Tue, 31 Jan 2012 11:57:17 +0200
Message-Id: <1328003845-3926-3-git-send-email-eliad@wizery.com> (sfid-20120131_105409_265843_C42BDD62)
In-Reply-To: <1328003845-3926-1-git-send-email-eliad@wizery.com>
References: <1328003845-3926-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use device role for scans when the sta is not
associated.

sched_scan is used only when the sta is
not associated, and thus should use
the dev role (instead of sta role).

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
v2: squash

 drivers/net/wireless/wl12xx/cmd.c  |    3 ++-
 drivers/net/wireless/wl12xx/main.c |    2 +-
 drivers/net/wireless/wl12xx/scan.c |   20 ++++++++++++++------
 3 files changed, 17 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/cmd.c b/drivers/net/wireless/wl12xx/cmd.c
index 28e0a56..10dba19 100644
--- a/drivers/net/wireless/wl12xx/cmd.c
+++ b/drivers/net/wireless/wl12xx/cmd.c
@@ -1029,7 +1029,8 @@ int wl1271_cmd_template_set(struct wl1271 *wl, u8 role_id,
 	struct wl1271_cmd_template_set *cmd;
 	int ret = 0;
 
-	wl1271_debug(DEBUG_CMD, "cmd template_set %d", template_id);
+	wl1271_debug(DEBUG_CMD, "cmd template_set %d (role %d)",
+		     template_id, role_id);
 
 	WARN_ON(buf_len > WL1271_CMD_TEMPL_MAX_SIZE);
 	buf_len = min_t(size_t, buf_len, WL1271_CMD_TEMPL_MAX_SIZE);
diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 81e24da..d209184 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -3044,7 +3044,7 @@ static int wl1271_op_hw_scan(struct ieee80211_hw *hw,
 
 	/* cancel ROC before scanning */
 	if (wl12xx_dev_role_started(wlvif))
-		wl12xx_stop_dev(wl, wlvif);
+		wl12xx_croc(wl, wlvif->dev_role_id);
 
 	ret = wl1271_scan(hw->priv, vif, ssid, len, req);
 out_sleep:
diff --git a/drivers/net/wireless/wl12xx/scan.c b/drivers/net/wireless/wl12xx/scan.c
index 416ae91..6adc733 100644
--- a/drivers/net/wireless/wl12xx/scan.c
+++ b/drivers/net/wireless/wl12xx/scan.c
@@ -77,7 +77,10 @@ void wl1271_scan_complete_work(struct work_struct *work)
 	     (is_ibss && !test_bit(WLVIF_FLAG_IBSS_JOINED, &wlvif->flags))) &&
 	    !test_bit(wlvif->dev_role_id, wl->roc_map)) {
 		/* restore remain on channel */
-		wl12xx_start_dev(wl, wlvif);
+		if (wlvif->dev_hlid == WL12XX_INVALID_LINK_ID)
+			wl12xx_start_dev(wl, wlvif);
+		else
+			wl12xx_roc(wl, wlvif, wlvif->dev_role_id);
 	}
 	wl1271_ps_elp_sleep(wl);
 
@@ -185,11 +188,16 @@ static int wl1271_scan_send(struct wl1271 *wl, struct ieee80211_vif *vif,
 	if (passive)
 		scan_options |= WL1271_SCAN_OPT_PASSIVE;
 
-	if (WARN_ON(wlvif->role_id == WL12XX_INVALID_ROLE_ID)) {
+	if (WARN_ON(wlvif->role_id == WL12XX_INVALID_ROLE_ID ||
+		    wlvif->dev_role_id == WL12XX_INVALID_ROLE_ID)) {
 		ret = -EINVAL;
 		goto out;
 	}
-	cmd->params.role_id = wlvif->role_id;
+	if (test_bit(WLVIF_FLAG_STA_ASSOCIATED, &wlvif->flags))
+		cmd->params.role_id = wlvif->role_id;
+	else
+		cmd->params.role_id = wlvif->dev_role_id;
+
 	cmd->params.scan_options = cpu_to_le16(scan_options);
 
 	cmd->params.n_ch = wl1271_get_scan_channels(wl, wl->scan.req,
@@ -218,7 +226,7 @@ static int wl1271_scan_send(struct wl1271 *wl, struct ieee80211_vif *vif,
 	memcpy(cmd->addr, vif->addr, ETH_ALEN);
 
 	ret = wl12xx_cmd_build_probe_req(wl, wlvif,
-					 wlvif->role_id, band,
+					 cmd->params.role_id, band,
 					 wl->scan.ssid, wl->scan.ssid_len,
 					 wl->scan.req->ie,
 					 wl->scan.req->ie_len);
@@ -662,7 +670,7 @@ int wl1271_scan_sched_scan_config(struct wl1271 *wl,
 	if (!force_passive && cfg->active[0]) {
 		u8 band = IEEE80211_BAND_2GHZ;
 		ret = wl12xx_cmd_build_probe_req(wl, wlvif,
-						 wlvif->role_id, band,
+						 wlvif->dev_role_id, band,
 						 req->ssids[0].ssid,
 						 req->ssids[0].ssid_len,
 						 ies->ie[band],
@@ -676,7 +684,7 @@ int wl1271_scan_sched_scan_config(struct wl1271 *wl,
 	if (!force_passive && cfg->active[1]) {
 		u8 band = IEEE80211_BAND_5GHZ;
 		ret = wl12xx_cmd_build_probe_req(wl, wlvif,
-						 wlvif->role_id, band,
+						 wlvif->dev_role_id, band,
 						 req->ssids[0].ssid,
 						 req->ssids[0].ssid_len,
 						 ies->ie[band],
-- 
1.7.6.401.g6a319

