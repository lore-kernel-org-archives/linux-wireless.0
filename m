Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:50133 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753361Ab2AaJyM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Jan 2012 04:54:12 -0500
Received: by wgbdt10 with SMTP id dt10so63169wgb.1
        for <linux-wireless@vger.kernel.org>; Tue, 31 Jan 2012 01:54:11 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH v2 06/10] wl12xx: add support for HW dynamic PS
Date: Tue, 31 Jan 2012 11:57:21 +0200
Message-Id: <1328003845-3926-7-git-send-email-eliad@wizery.com> (sfid-20120131_105419_552487_8D622919)
In-Reply-To: <1328003845-3926-1-git-send-email-eliad@wizery.com>
References: <1328003845-3926-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eyal Shapira <eyal@wizery.com>

FW now supports dynamic PS so we don't need to use mac80211 support.
FW will go to PSM after a specified timeout with no Rx/Tx traffic.
- Changed FW API to include new PS mode (AUTO_MODE) and including timeout parameter
- The default PS mode would be dynamic PS
- Default timeout is 100ms (same as it used to be in mac80211)
- Avoid using mac80211 APIs to disable/enable dynamic PS as we're not
using mac80211 PS control anymore.
- COEX is handled by the FW while in dynamic PS so removed
handling of SOFT_GEMINI

Signed-off-by: Eyal Shapira <eyal@wizery.com>
Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/cmd.c   |    3 ++-
 drivers/net/wireless/wl12xx/cmd.h   |    5 +++--
 drivers/net/wireless/wl12xx/conf.h  |    6 ++++++
 drivers/net/wireless/wl12xx/event.c |    8 --------
 drivers/net/wireless/wl12xx/main.c  |   15 +++++----------
 drivers/net/wireless/wl12xx/ps.c    |   15 ++++++++++-----
 6 files changed, 26 insertions(+), 26 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/cmd.c b/drivers/net/wireless/wl12xx/cmd.c
index 88e94c5..bf3c37b 100644
--- a/drivers/net/wireless/wl12xx/cmd.c
+++ b/drivers/net/wireless/wl12xx/cmd.c
@@ -996,7 +996,7 @@ out:
 }
 
 int wl1271_cmd_ps_mode(struct wl1271 *wl, struct wl12xx_vif *wlvif,
-		       u8 ps_mode)
+		       u8 ps_mode, u16 auto_ps_timeout)
 {
 	struct wl1271_cmd_ps_params *ps_params = NULL;
 	int ret = 0;
@@ -1011,6 +1011,7 @@ int wl1271_cmd_ps_mode(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 
 	ps_params->role_id = wlvif->role_id;
 	ps_params->ps_mode = ps_mode;
+	ps_params->auto_ps_timeout = auto_ps_timeout;
 
 	ret = wl1271_cmd_send(wl, CMD_SET_PS_MODE, ps_params,
 			      sizeof(*ps_params), 0);
diff --git a/drivers/net/wireless/wl12xx/cmd.h b/drivers/net/wireless/wl12xx/cmd.h
index edd240d..83a2a2e 100644
--- a/drivers/net/wireless/wl12xx/cmd.h
+++ b/drivers/net/wireless/wl12xx/cmd.h
@@ -51,7 +51,7 @@ int wl1271_cmd_interrogate(struct wl1271 *wl, u16 id, void *buf, size_t len);
 int wl1271_cmd_configure(struct wl1271 *wl, u16 id, void *buf, size_t len);
 int wl1271_cmd_data_path(struct wl1271 *wl, bool enable);
 int wl1271_cmd_ps_mode(struct wl1271 *wl, struct wl12xx_vif *wlvif,
-		       u8 ps_mode);
+		       u8 ps_mode, u16 auto_ps_timeout);
 int wl1271_cmd_read_memory(struct wl1271 *wl, u32 addr, void *answer,
 			   size_t len);
 int wl1271_cmd_template_set(struct wl1271 *wl, u8 role_id,
@@ -400,6 +400,7 @@ struct wl1271_tim {
 } __packed;
 
 enum wl1271_cmd_ps_mode {
+	STATION_AUTO_PS_MODE,   /* Dynamic Power Save */
 	STATION_ACTIVE_MODE,
 	STATION_POWER_SAVE_MODE
 };
@@ -409,7 +410,7 @@ struct wl1271_cmd_ps_params {
 
 	u8 role_id;
 	u8 ps_mode; /* STATION_* */
-	u8 padding[2];
+	u16 auto_ps_timeout;
 } __packed;
 
 /* HW encryption keys */
diff --git a/drivers/net/wireless/wl12xx/conf.h b/drivers/net/wireless/wl12xx/conf.h
index 47cf80f..10e5e3d 100644
--- a/drivers/net/wireless/wl12xx/conf.h
+++ b/drivers/net/wireless/wl12xx/conf.h
@@ -915,6 +915,12 @@ struct conf_conn_settings {
 	u8 psm_entry_nullfunc_retries;
 
 	/*
+	 * Specifies the dynamic PS timeout in ms that will be used
+	 * by the FW when in AUTO_PS mode
+	 */
+	u16 dynamic_ps_timeout;
+
+	/*
 	 *
 	 * Specifies the interval of the connection keep-alive null-func
 	 * frame in ms.
diff --git a/drivers/net/wireless/wl12xx/event.c b/drivers/net/wireless/wl12xx/event.c
index 2ec5d21..71a02b6 100644
--- a/drivers/net/wireless/wl12xx/event.c
+++ b/drivers/net/wireless/wl12xx/event.c
@@ -78,21 +78,13 @@ static void wl1271_stop_ba_event(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 static void wl12xx_event_soft_gemini_sense(struct wl1271 *wl,
 					       u8 enable)
 {
-	struct ieee80211_vif *vif;
 	struct wl12xx_vif *wlvif;
 
 	if (enable) {
-		/* disable dynamic PS when requested by the firmware */
-		wl12xx_for_each_wlvif_sta(wl, wlvif) {
-			vif = wl12xx_wlvif_to_vif(wlvif);
-			ieee80211_disable_dyn_ps(vif);
-		}
 		set_bit(WL1271_FLAG_SOFT_GEMINI, &wl->flags);
 	} else {
 		clear_bit(WL1271_FLAG_SOFT_GEMINI, &wl->flags);
 		wl12xx_for_each_wlvif_sta(wl, wlvif) {
-			vif = wl12xx_wlvif_to_vif(wlvif);
-			ieee80211_enable_dyn_ps(vif);
 			wl1271_recalc_rx_streaming(wl, wlvif);
 		}
 	}
diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index cb0d7b7..247e32d 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -1,3 +1,4 @@
+
 /*
  * This file is part of wl1271
  *
@@ -240,6 +241,7 @@ static struct conf_drv_settings default_conf = {
 		.psm_entry_retries           = 8,
 		.psm_exit_retries            = 16,
 		.psm_entry_nullfunc_retries  = 3,
+		.dynamic_ps_timeout          = 100,
 		.keep_alive_interval         = 55000,
 		.max_listen_interval         = 20,
 	},
@@ -2116,10 +2118,6 @@ static void __wl1271_op_remove_interface(struct wl1271 *wl,
 
 	wl1271_info("down");
 
-	/* enable dyn ps just in case (if left on due to fw crash etc) */
-	if (wlvif->bss_type == BSS_TYPE_STA_BSS)
-		ieee80211_enable_dyn_ps(vif);
-
 	if (wl->scan.state != WL1271_SCAN_STATE_IDLE &&
 	    wl->scan_vif == vif) {
 		wl->scan.state = WL1271_SCAN_STATE_IDLE;
@@ -3668,9 +3666,6 @@ sta_not_found:
 			dev_kfree_skb(wlvif->probereq);
 			wlvif->probereq = NULL;
 
-			/* re-enable dynamic ps - just in case */
-			ieee80211_enable_dyn_ps(vif);
-
 			/* revert back to minimum rates for the current band */
 			wl1271_set_band_rate(wl, wlvif);
 			wlvif->basic_rate =
@@ -3801,10 +3796,9 @@ sta_not_found:
 		/* If we want to go in PSM but we're not there yet */
 		if (test_bit(WLVIF_FLAG_PSM_REQUESTED, &wlvif->flags) &&
 		    !test_bit(WLVIF_FLAG_PSM, &wlvif->flags)) {
-			enum wl1271_cmd_ps_mode mode;
 
-			mode = STATION_POWER_SAVE_MODE;
-			ret = wl1271_ps_set_mode(wl, wlvif, mode,
+			ret = wl1271_ps_set_mode(wl, wlvif,
+						 STATION_AUTO_PS_MODE,
 						 wlvif->basic_rate,
 						 true);
 			if (ret < 0)
@@ -4838,6 +4832,7 @@ static int wl1271_init_ieee80211(struct wl1271 *wl)
 	wl->hw->flags = IEEE80211_HW_SIGNAL_DBM |
 		IEEE80211_HW_BEACON_FILTER |
 		IEEE80211_HW_SUPPORTS_PS |
+		IEEE80211_HW_SUPPORTS_DYNAMIC_PS |
 		IEEE80211_HW_SUPPORTS_UAPSD |
 		IEEE80211_HW_HAS_RATE_CONTROL |
 		IEEE80211_HW_CONNECTION_MONITOR |
diff --git a/drivers/net/wireless/wl12xx/ps.c b/drivers/net/wireless/wl12xx/ps.c
index a2bdacd..60f03c4 100644
--- a/drivers/net/wireless/wl12xx/ps.c
+++ b/drivers/net/wireless/wl12xx/ps.c
@@ -163,10 +163,12 @@ int wl1271_ps_set_mode(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 		       enum wl1271_cmd_ps_mode mode, u32 rates, bool send)
 {
 	int ret;
+	u16 timeout = wl->conf.conn.dynamic_ps_timeout;
 
 	switch (mode) {
-	case STATION_POWER_SAVE_MODE:
-		wl1271_debug(DEBUG_PSM, "entering psm");
+	case STATION_AUTO_PS_MODE:
+		wl1271_debug(DEBUG_PSM, "entering psm (mode=%d,timeout=%u)",
+			     mode, timeout);
 
 		ret = wl1271_acx_wake_up_conditions(wl, wlvif);
 		if (ret < 0) {
@@ -174,14 +176,13 @@ int wl1271_ps_set_mode(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 			return ret;
 		}
 
-		ret = wl1271_cmd_ps_mode(wl, wlvif, STATION_POWER_SAVE_MODE);
+		ret = wl1271_cmd_ps_mode(wl, wlvif, mode, timeout);
 		if (ret < 0)
 			return ret;
 
 		set_bit(WLVIF_FLAG_PSM, &wlvif->flags);
 		break;
 	case STATION_ACTIVE_MODE:
-	default:
 		wl1271_debug(DEBUG_PSM, "leaving psm");
 
 		/* disable beacon early termination */
@@ -191,12 +192,16 @@ int wl1271_ps_set_mode(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 				return ret;
 		}
 
-		ret = wl1271_cmd_ps_mode(wl, wlvif, STATION_ACTIVE_MODE);
+		ret = wl1271_cmd_ps_mode(wl, wlvif, mode, 0);
 		if (ret < 0)
 			return ret;
 
 		clear_bit(WLVIF_FLAG_PSM, &wlvif->flags);
 		break;
+	case STATION_POWER_SAVE_MODE:
+	default:
+		wl1271_warning("trying to set ps to unsupported mode %d", mode);
+		ret = -EINVAL;
 	}
 
 	return ret;
-- 
1.7.6.401.g6a319

