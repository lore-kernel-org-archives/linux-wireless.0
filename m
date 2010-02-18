Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:24675 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753580Ab0BRL2J (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Feb 2010 06:28:09 -0500
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 01/22] wl1271: Fix PSM entry
Date: Thu, 18 Feb 2010 13:25:36 +0200
Message-Id: <1266492357-462-2-git-send-email-juuso.oikarinen@nokia.com>
In-Reply-To: <1266492357-462-1-git-send-email-juuso.oikarinen@nokia.com>
References: <1266492357-462-1-git-send-email-juuso.oikarinen@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Currently the PSM entry function assumes successful operation, and enables
ELP, BET and beacon filtering right away. This is bad, because the PSM
entry may fail due to environmental issues, which will cause the ELP, BET and
beacon filtering to be illegally enabled (because FW remains in active state.)

Fix this by enabling ELP, BET and beacon filtering only after successful entry,
and by ensuring the firmware is in active mode after the failure.

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Reviewed-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271_cmd.c   |    4 +-
 drivers/net/wireless/wl12xx/wl1271_cmd.h   |    2 +-
 drivers/net/wireless/wl12xx/wl1271_event.c |   35 ++++++++++++++++++++++++++-
 drivers/net/wireless/wl12xx/wl1271_main.c  |    8 ++++--
 drivers/net/wireless/wl12xx/wl1271_ps.c    |   21 +++-------------
 drivers/net/wireless/wl12xx/wl1271_ps.h    |    3 +-
 6 files changed, 47 insertions(+), 26 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_cmd.c b/drivers/net/wireless/wl12xx/wl1271_cmd.c
index a74259b..dd2b5f0 100644
--- a/drivers/net/wireless/wl12xx/wl1271_cmd.c
+++ b/drivers/net/wireless/wl12xx/wl1271_cmd.c
@@ -555,7 +555,7 @@ out:
 	return ret;
 }
 
-int wl1271_cmd_ps_mode(struct wl1271 *wl, u8 ps_mode)
+int wl1271_cmd_ps_mode(struct wl1271 *wl, u8 ps_mode, bool send)
 {
 	struct wl1271_cmd_ps_params *ps_params = NULL;
 	int ret = 0;
@@ -576,7 +576,7 @@ int wl1271_cmd_ps_mode(struct wl1271 *wl, u8 ps_mode)
 	}
 
 	ps_params->ps_mode = ps_mode;
-	ps_params->send_null_data = 1;
+	ps_params->send_null_data = send;
 	ps_params->retries = 5;
 	ps_params->hang_over_period = 128;
 	ps_params->null_data_rate = cpu_to_le32(1); /* 1 Mbps */
diff --git a/drivers/net/wireless/wl12xx/wl1271_cmd.h b/drivers/net/wireless/wl12xx/wl1271_cmd.h
index 09fe912..ba433f4 100644
--- a/drivers/net/wireless/wl12xx/wl1271_cmd.h
+++ b/drivers/net/wireless/wl12xx/wl1271_cmd.h
@@ -38,7 +38,7 @@ int wl1271_cmd_test(struct wl1271 *wl, void *buf, size_t buf_len, u8 answer);
 int wl1271_cmd_interrogate(struct wl1271 *wl, u16 id, void *buf, size_t len);
 int wl1271_cmd_configure(struct wl1271 *wl, u16 id, void *buf, size_t len);
 int wl1271_cmd_data_path(struct wl1271 *wl, bool enable);
-int wl1271_cmd_ps_mode(struct wl1271 *wl, u8 ps_mode);
+int wl1271_cmd_ps_mode(struct wl1271 *wl, u8 ps_mode, bool send);
 int wl1271_cmd_read_memory(struct wl1271 *wl, u32 addr, void *answer,
 			   size_t len);
 int wl1271_cmd_scan(struct wl1271 *wl, u8 *ssid, size_t len,
diff --git a/drivers/net/wireless/wl12xx/wl1271_event.c b/drivers/net/wireless/wl12xx/wl1271_event.c
index 0a145af..cecbae2 100644
--- a/drivers/net/wireless/wl12xx/wl1271_event.c
+++ b/drivers/net/wireless/wl12xx/wl1271_event.c
@@ -78,24 +78,55 @@ static int wl1271_event_ps_report(struct wl1271 *wl,
 
 	switch (mbox->ps_status) {
 	case EVENT_ENTER_POWER_SAVE_FAIL:
+		wl1271_debug(DEBUG_PSM, "PSM entry failed");
+
 		if (!test_bit(WL1271_FLAG_PSM, &wl->flags)) {
+			/* remain in active mode */
 			wl->psm_entry_retry = 0;
 			break;
 		}
 
 		if (wl->psm_entry_retry < wl->conf.conn.psm_entry_retries) {
 			wl->psm_entry_retry++;
-			ret = wl1271_ps_set_mode(wl, STATION_POWER_SAVE_MODE);
+			ret = wl1271_ps_set_mode(wl, STATION_POWER_SAVE_MODE,
+						 true);
 		} else {
 			wl1271_error("PSM entry failed, giving up.\n");
+			/* make sure the firmware goes into active mode */
+			ret = wl1271_ps_set_mode(wl, STATION_ACTIVE_MODE,
+						 false);
 			wl->psm_entry_retry = 0;
 		}
 		break;
 	case EVENT_ENTER_POWER_SAVE_SUCCESS:
 		wl->psm_entry_retry = 0;
+
+		/* enable beacon filtering */
+		ret = wl1271_acx_beacon_filter_opt(wl, true);
+		if (ret < 0)
+			break;
+
+		/* enable beacon early termination */
+		ret = wl1271_acx_bet_enable(wl, true);
+		if (ret < 0)
+			break;
+
+		/* go to extremely low power mode */
+		wl1271_ps_elp_sleep(wl);
+		if (ret < 0)
+			break;
 		break;
 	case EVENT_EXIT_POWER_SAVE_FAIL:
-		wl1271_info("PSM exit failed");
+		wl1271_debug(DEBUG_PSM, "PSM exit failed");
+
+		if (test_bit(WL1271_FLAG_PSM, &wl->flags)) {
+			wl->psm_entry_retry = 0;
+			break;
+		}
+
+		/* make sure the firmware goes to active mode */
+		ret = wl1271_ps_set_mode(wl, STATION_ACTIVE_MODE,
+					 false);
 		break;
 	case EVENT_EXIT_POWER_SAVE_SUCCESS:
 	default:
diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
index e4867b8..6f026fe 100644
--- a/drivers/net/wireless/wl12xx/wl1271_main.c
+++ b/drivers/net/wireless/wl12xx/wl1271_main.c
@@ -1248,7 +1248,8 @@ static int wl1271_op_config(struct ieee80211_hw *hw, u32 changed)
 		 */
 		if (test_bit(WL1271_FLAG_STA_ASSOCIATED, &wl->flags)) {
 			wl1271_info("psm enabled");
-			ret = wl1271_ps_set_mode(wl, STATION_POWER_SAVE_MODE);
+			ret = wl1271_ps_set_mode(wl, STATION_POWER_SAVE_MODE,
+						 true);
 		}
 	} else if (!(conf->flags & IEEE80211_CONF_PS) &&
 		   test_bit(WL1271_FLAG_PSM_REQUESTED, &wl->flags)) {
@@ -1257,7 +1258,8 @@ static int wl1271_op_config(struct ieee80211_hw *hw, u32 changed)
 		clear_bit(WL1271_FLAG_PSM_REQUESTED, &wl->flags);
 
 		if (test_bit(WL1271_FLAG_PSM, &wl->flags))
-			ret = wl1271_ps_set_mode(wl, STATION_ACTIVE_MODE);
+			ret = wl1271_ps_set_mode(wl, STATION_ACTIVE_MODE,
+						 true);
 	}
 
 	if (conf->power_level != wl->power_level) {
@@ -1637,7 +1639,7 @@ static void wl1271_op_bss_info_changed(struct ieee80211_hw *hw,
 			if (test_bit(WL1271_FLAG_PSM_REQUESTED, &wl->flags) &&
 			    !test_bit(WL1271_FLAG_PSM, &wl->flags)) {
 				mode = STATION_POWER_SAVE_MODE;
-				ret = wl1271_ps_set_mode(wl, mode);
+				ret = wl1271_ps_set_mode(wl, mode, true);
 				if (ret < 0)
 					goto out_sleep;
 			}
diff --git a/drivers/net/wireless/wl12xx/wl1271_ps.c b/drivers/net/wireless/wl12xx/wl1271_ps.c
index e407790..29f6700 100644
--- a/drivers/net/wireless/wl12xx/wl1271_ps.c
+++ b/drivers/net/wireless/wl12xx/wl1271_ps.c
@@ -118,7 +118,8 @@ out:
 	return 0;
 }
 
-int wl1271_ps_set_mode(struct wl1271 *wl, enum wl1271_cmd_ps_mode mode)
+int wl1271_ps_set_mode(struct wl1271 *wl, enum wl1271_cmd_ps_mode mode,
+		       bool send)
 {
 	int ret;
 
@@ -126,21 +127,7 @@ int wl1271_ps_set_mode(struct wl1271 *wl, enum wl1271_cmd_ps_mode mode)
 	case STATION_POWER_SAVE_MODE:
 		wl1271_debug(DEBUG_PSM, "entering psm");
 
-		/* enable beacon filtering */
-		ret = wl1271_acx_beacon_filter_opt(wl, true);
-		if (ret < 0)
-			return ret;
-
-		/* enable beacon early termination */
-		ret = wl1271_acx_bet_enable(wl, true);
-		if (ret < 0)
-			return ret;
-
-		ret = wl1271_cmd_ps_mode(wl, STATION_POWER_SAVE_MODE);
-		if (ret < 0)
-			return ret;
-
-		wl1271_ps_elp_sleep(wl);
+		ret = wl1271_cmd_ps_mode(wl, STATION_POWER_SAVE_MODE, send);
 		if (ret < 0)
 			return ret;
 
@@ -163,7 +150,7 @@ int wl1271_ps_set_mode(struct wl1271 *wl, enum wl1271_cmd_ps_mode mode)
 		if (ret < 0)
 			return ret;
 
-		ret = wl1271_cmd_ps_mode(wl, STATION_ACTIVE_MODE);
+		ret = wl1271_cmd_ps_mode(wl, STATION_ACTIVE_MODE, send);
 		if (ret < 0)
 			return ret;
 
diff --git a/drivers/net/wireless/wl12xx/wl1271_ps.h b/drivers/net/wireless/wl12xx/wl1271_ps.h
index 779653d..940276f 100644
--- a/drivers/net/wireless/wl12xx/wl1271_ps.h
+++ b/drivers/net/wireless/wl12xx/wl1271_ps.h
@@ -27,7 +27,8 @@
 #include "wl1271.h"
 #include "wl1271_acx.h"
 
-int wl1271_ps_set_mode(struct wl1271 *wl, enum wl1271_cmd_ps_mode mode);
+int wl1271_ps_set_mode(struct wl1271 *wl, enum wl1271_cmd_ps_mode mode,
+		       bool send);
 void wl1271_ps_elp_sleep(struct wl1271 *wl);
 int wl1271_ps_elp_wakeup(struct wl1271 *wl, bool chip_awake);
 void wl1271_elp_work(struct work_struct *work);
-- 
1.6.3.3

