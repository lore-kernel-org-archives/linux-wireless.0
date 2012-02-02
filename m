Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:59063 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751778Ab2BBKAQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Feb 2012 05:00:16 -0500
Received: by mail-we0-f174.google.com with SMTP id b13so1662686wer.19
        for <linux-wireless@vger.kernel.org>; Thu, 02 Feb 2012 02:00:15 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>, Eliad Peller <eliad@wizery.com>
Subject: [PATCH v3 3/4] wl12xx: add forced_ps mode
Date: Thu,  2 Feb 2012 12:03:41 +0200
Message-Id: <1328177022-26646-4-git-send-email-eliad@wizery.com> (sfid-20120202_110021_393525_7AAC68CD)
In-Reply-To: <1328177022-26646-1-git-send-email-eliad@wizery.com>
References: <1328177022-26646-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eyal Shapira <eyal@wizery.com>

For certain WiFi certification tests forcing PS
is necessary. Since DPS is now enabled in the FW
and this can't be achieved by using netlatency
this required a new config option.

Signed-off-by: Eyal Shapira <eyal@wizery.com>
Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/conf.h    |    6 ++++++
 drivers/net/wireless/wl12xx/debugfs.c |    2 +-
 drivers/net/wireless/wl12xx/main.c    |   25 +++++++++++++++++++------
 drivers/net/wireless/wl12xx/ps.c      |    8 ++++----
 drivers/net/wireless/wl12xx/wl12xx.h  |    2 +-
 5 files changed, 31 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/conf.h b/drivers/net/wireless/wl12xx/conf.h
index d97aad6..f29fbfd 100644
--- a/drivers/net/wireless/wl12xx/conf.h
+++ b/drivers/net/wireless/wl12xx/conf.h
@@ -934,6 +934,12 @@ struct conf_conn_settings {
 	u16 dynamic_ps_timeout;
 
 	/*
+	 * Specifies whether dynamic PS should be disabled and PSM forced.
+	 * This is required for certain WiFi certification tests.
+	 */
+	u8 forced_ps;
+
+	/*
 	 *
 	 * Specifies the interval of the connection keep-alive null-func
 	 * frame in ms.
diff --git a/drivers/net/wireless/wl12xx/debugfs.c b/drivers/net/wireless/wl12xx/debugfs.c
index 15353fa..02da445 100644
--- a/drivers/net/wireless/wl12xx/debugfs.c
+++ b/drivers/net/wireless/wl12xx/debugfs.c
@@ -358,7 +358,7 @@ static ssize_t dynamic_ps_timeout_write(struct file *file,
 	 */
 
 	wl12xx_for_each_wlvif_sta(wl, wlvif) {
-		if (test_bit(WLVIF_FLAG_IN_AUTO_PS, &wlvif->flags))
+		if (test_bit(WLVIF_FLAG_IN_PS, &wlvif->flags))
 			wl1271_ps_set_mode(wl, wlvif, STATION_AUTO_PS_MODE);
 	}
 
diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 29a00fc..f2960df 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -244,6 +244,7 @@ static struct conf_drv_settings default_conf = {
 		.psm_exit_retries            = 16,
 		.psm_entry_nullfunc_retries  = 3,
 		.dynamic_ps_timeout          = 100,
+		.forced_ps                   = false,
 		.keep_alive_interval         = 55000,
 		.max_listen_interval         = 20,
 	},
@@ -2481,17 +2482,29 @@ static int wl12xx_config_vif(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 
 		if ((conf->flags & IEEE80211_CONF_PS) &&
 		    test_bit(WLVIF_FLAG_STA_ASSOCIATED, &wlvif->flags) &&
-		    !test_bit(WLVIF_FLAG_IN_AUTO_PS, &wlvif->flags)) {
+		    !test_bit(WLVIF_FLAG_IN_PS, &wlvif->flags)) {
 
-			wl1271_debug(DEBUG_PSM, "auto ps enabled");
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
 
-			ret = wl1271_ps_set_mode(wl, wlvif,
-						 STATION_AUTO_PS_MODE);
 			if (ret < 0)
-				wl1271_warning("enter auto ps failed %d", ret);
+				wl1271_warning("enter %s ps failed %d",
+					       ps_mode_str, ret);
 
 		} else if (!(conf->flags & IEEE80211_CONF_PS) &&
-			   test_bit(WLVIF_FLAG_IN_AUTO_PS, &wlvif->flags)) {
+			   test_bit(WLVIF_FLAG_IN_PS, &wlvif->flags)) {
 
 			wl1271_debug(DEBUG_PSM, "auto ps disabled");
 
diff --git a/drivers/net/wireless/wl12xx/ps.c b/drivers/net/wireless/wl12xx/ps.c
index d197922..fa993c2 100644
--- a/drivers/net/wireless/wl12xx/ps.c
+++ b/drivers/net/wireless/wl12xx/ps.c
@@ -56,7 +56,7 @@ void wl1271_elp_work(struct work_struct *work)
 		if (wlvif->bss_type == BSS_TYPE_AP_BSS)
 			goto out;
 
-		if (!test_bit(WLVIF_FLAG_IN_AUTO_PS, &wlvif->flags) &&
+		if (!test_bit(WLVIF_FLAG_IN_PS, &wlvif->flags) &&
 		    test_bit(WLVIF_FLAG_IN_USE, &wlvif->flags))
 			goto out;
 	}
@@ -84,7 +84,7 @@ void wl1271_ps_elp_sleep(struct wl1271 *wl)
 		if (wlvif->bss_type == BSS_TYPE_AP_BSS)
 			return;
 
-		if (!test_bit(WLVIF_FLAG_IN_AUTO_PS, &wlvif->flags) &&
+		if (!test_bit(WLVIF_FLAG_IN_PS, &wlvif->flags) &&
 		    test_bit(WLVIF_FLAG_IN_USE, &wlvif->flags))
 			return;
 	}
@@ -182,7 +182,7 @@ int wl1271_ps_set_mode(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 		if (ret < 0)
 			return ret;
 
-		set_bit(WLVIF_FLAG_IN_AUTO_PS, &wlvif->flags);
+		set_bit(WLVIF_FLAG_IN_PS, &wlvif->flags);
 
 		/* enable beacon early termination. Not relevant for 5GHz */
 		if (wlvif->band == IEEE80211_BAND_2GHZ) {
@@ -205,7 +205,7 @@ int wl1271_ps_set_mode(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 		if (ret < 0)
 			return ret;
 
-		clear_bit(WLVIF_FLAG_IN_AUTO_PS, &wlvif->flags);
+		clear_bit(WLVIF_FLAG_IN_PS, &wlvif->flags);
 		break;
 	case STATION_POWER_SAVE_MODE:
 	default:
diff --git a/drivers/net/wireless/wl12xx/wl12xx.h b/drivers/net/wireless/wl12xx/wl12xx.h
index 9cc7051..1463341 100644
--- a/drivers/net/wireless/wl12xx/wl12xx.h
+++ b/drivers/net/wireless/wl12xx/wl12xx.h
@@ -254,7 +254,7 @@ enum wl12xx_vif_flags {
 	WLVIF_FLAG_STA_ASSOCIATED,
 	WLVIF_FLAG_IBSS_JOINED,
 	WLVIF_FLAG_AP_STARTED,
-	WLVIF_FLAG_IN_AUTO_PS,
+	WLVIF_FLAG_IN_PS,
 	WLVIF_FLAG_STA_STATE_SENT,
 	WLVIF_FLAG_RX_STREAMING_STARTED,
 	WLVIF_FLAG_PSPOLL_FAILURE,
-- 
1.7.6.401.g6a319

