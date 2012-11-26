Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:35127 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754149Ab2KZQGM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Nov 2012 11:06:12 -0500
Received: by mail-we0-f174.google.com with SMTP id d7so3507268wer.19
        for <linux-wireless@vger.kernel.org>; Mon, 26 Nov 2012 08:06:12 -0800 (PST)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Eliad Peller <eliad@wizery.com>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 08/11] wlcore: move ps change handling to .bss_info_changed()
Date: Mon, 26 Nov 2012 18:05:47 +0200
Message-Id: <1353945950-3899-9-git-send-email-arik@wizery.com> (sfid-20121126_170620_467250_F0109375)
In-Reply-To: <1353945950-3899-1-git-send-email-arik@wizery.com>
References: <1353945950-3899-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eliad Peller <eliad@wizery.com>

Adapt the new mac80211 BSS_CHANGED_PS notification,
and do the ps handling in mac80211's per-vif
callback (.bss_info_changed), rather than in
the per-device (.config) callback.

Make sure to configure it only after association.

Signed-off-by: Eliad Peller <eliad@wizery.com>
Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/ti/wlcore/main.c |   70 +++++++++++++++------------------
 1 file changed, 32 insertions(+), 38 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index 45008fa..a6283df 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -2781,46 +2781,8 @@ static void wl1271_set_band_rate(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 static int wl12xx_config_vif(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 			     struct ieee80211_conf *conf, u32 changed)
 {
-	bool is_ap = (wlvif->bss_type == BSS_TYPE_AP_BSS);
 	int ret;
 
-	if ((changed & IEEE80211_CONF_CHANGE_PS) && !is_ap) {
-
-		if ((conf->flags & IEEE80211_CONF_PS) &&
-		    test_bit(WLVIF_FLAG_STA_ASSOCIATED, &wlvif->flags) &&
-		    !test_bit(WLVIF_FLAG_IN_PS, &wlvif->flags)) {
-
-			int ps_mode;
-			char *ps_mode_str;
-
-			if (wl->conf.conn.forced_ps) {
-				ps_mode = STATION_POWER_SAVE_MODE;
-				ps_mode_str = "forced";
-			} else {
-				ps_mode = STATION_AUTO_PS_MODE;
-				ps_mode_str = "auto";
-			}
-
-			wl1271_debug(DEBUG_PSM, "%s ps enabled", ps_mode_str);
-
-			ret = wl1271_ps_set_mode(wl, wlvif, ps_mode);
-
-			if (ret < 0)
-				wl1271_warning("enter %s ps failed %d",
-					       ps_mode_str, ret);
-
-		} else if (!(conf->flags & IEEE80211_CONF_PS) &&
-			   test_bit(WLVIF_FLAG_IN_PS, &wlvif->flags)) {
-
-			wl1271_debug(DEBUG_PSM, "auto ps disabled");
-
-			ret = wl1271_ps_set_mode(wl, wlvif,
-						 STATION_ACTIVE_MODE);
-			if (ret < 0)
-				wl1271_warning("exit auto ps failed %d", ret);
-		}
-	}
-
 	if (conf->power_level != wlvif->power_level) {
 		ret = wl1271_acx_tx_power(wl, wlvif, conf->power_level);
 		if (ret < 0)
@@ -4115,6 +4077,38 @@ sta_not_found:
 		}
 	}
 
+	if (changed & BSS_CHANGED_PS) {
+		if ((bss_conf->ps) &&
+		    test_bit(WLVIF_FLAG_STA_ASSOCIATED, &wlvif->flags) &&
+		    !test_bit(WLVIF_FLAG_IN_PS, &wlvif->flags)) {
+			int ps_mode;
+			char *ps_mode_str;
+
+			if (wl->conf.conn.forced_ps) {
+				ps_mode = STATION_POWER_SAVE_MODE;
+				ps_mode_str = "forced";
+			} else {
+				ps_mode = STATION_AUTO_PS_MODE;
+				ps_mode_str = "auto";
+			}
+
+			wl1271_debug(DEBUG_PSM, "%s ps enabled", ps_mode_str);
+
+			ret = wl1271_ps_set_mode(wl, wlvif, ps_mode);
+			if (ret < 0)
+				wl1271_warning("enter %s ps failed %d",
+					       ps_mode_str, ret);
+		} else if (!bss_conf->ps &&
+			   test_bit(WLVIF_FLAG_IN_PS, &wlvif->flags)) {
+			wl1271_debug(DEBUG_PSM, "auto ps disabled");
+
+			ret = wl1271_ps_set_mode(wl, wlvif,
+						 STATION_ACTIVE_MODE);
+			if (ret < 0)
+				wl1271_warning("exit auto ps failed %d", ret);
+		}
+	}
+
 	/* Handle new association with HT. Do this after join. */
 	if (sta_exists &&
 	    (changed & BSS_CHANGED_HT)) {
-- 
1.7.9.5

