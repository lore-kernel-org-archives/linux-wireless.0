Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:16935 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932861Ab0I0Iid (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Sep 2010 04:38:33 -0400
Received: from esebh105.NOE.Nokia.com (esebh105.ntc.nokia.com [172.21.138.211])
	by mgw-mx09.nokia.com (Switch-3.3.3/Switch-3.3.3) with ESMTP id o8R8cJPc025709
	for <linux-wireless@vger.kernel.org>; Mon, 27 Sep 2010 03:38:32 -0500
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linux-wireless@vger.kernel.org
Cc: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Subject: [PATCH 14/25] wl1271: Reduce rate used for last PSM entry attempt
Date: Mon, 27 Sep 2010 11:37:38 +0300
Message-Id: <1285576669-8070-15-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1285576669-8070-1-git-send-email-luciano.coelho@nokia.com>
References: <1285576669-8070-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Juuso Oikarinen <juuso.oikarinen@nokia.com>

This patch reduces the rate of the null-func used to enter PSM on the last
retry as precaution.

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Reviewed-by: Luciano Coelho <luciano.coelho@nokia.com>
Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271_cmd.c   |    4 ++--
 drivers/net/wireless/wl12xx/wl1271_cmd.h   |    4 +++-
 drivers/net/wireless/wl12xx/wl1271_event.c |   17 ++++++++++++-----
 drivers/net/wireless/wl12xx/wl1271_main.c  |    8 +++++---
 drivers/net/wireless/wl12xx/wl1271_ps.c    |    8 +++++---
 drivers/net/wireless/wl12xx/wl1271_ps.h    |    2 +-
 6 files changed, 28 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_cmd.c b/drivers/net/wireless/wl12xx/wl1271_cmd.c
index 42e7d2f..06b14f2 100644
--- a/drivers/net/wireless/wl12xx/wl1271_cmd.c
+++ b/drivers/net/wireless/wl12xx/wl1271_cmd.c
@@ -390,7 +390,7 @@ out:
 	return ret;
 }
 
-int wl1271_cmd_ps_mode(struct wl1271 *wl, u8 ps_mode, bool send)
+int wl1271_cmd_ps_mode(struct wl1271 *wl, u8 ps_mode, u32 rates, bool send)
 {
 	struct wl1271_cmd_ps_params *ps_params = NULL;
 	int ret = 0;
@@ -407,7 +407,7 @@ int wl1271_cmd_ps_mode(struct wl1271 *wl, u8 ps_mode, bool send)
 	ps_params->send_null_data = send;
 	ps_params->retries = 5;
 	ps_params->hang_over_period = 1;
-	ps_params->null_data_rate = cpu_to_le32(wl->basic_rate_set);
+	ps_params->null_data_rate = cpu_to_le32(rates);
 
 	ret = wl1271_cmd_send(wl, CMD_SET_PS_MODE, ps_params,
 			      sizeof(*ps_params), 0);
diff --git a/drivers/net/wireless/wl12xx/wl1271_cmd.h b/drivers/net/wireless/wl12xx/wl1271_cmd.h
index 92747ce..ff8e35e 100644
--- a/drivers/net/wireless/wl12xx/wl1271_cmd.h
+++ b/drivers/net/wireless/wl12xx/wl1271_cmd.h
@@ -38,7 +38,9 @@ int wl1271_cmd_test(struct wl1271 *wl, void *buf, size_t buf_len, u8 answer);
 int wl1271_cmd_interrogate(struct wl1271 *wl, u16 id, void *buf, size_t len);
 int wl1271_cmd_configure(struct wl1271 *wl, u16 id, void *buf, size_t len);
 int wl1271_cmd_data_path(struct wl1271 *wl, bool enable);
-int wl1271_cmd_ps_mode(struct wl1271 *wl, u8 ps_mode, bool send);
+int wl1271_cmd_ps_mode(struct wl1271 *wl, u8 ps_mode, u32 rates, bool send);
+int wl1271_cmd_read_memory(struct wl1271 *wl, u32 addr, void *answer,
+			   size_t len);
 int wl1271_cmd_template_set(struct wl1271 *wl, u16 template_id,
 			    void *buf, size_t buf_len, int index, u32 rates);
 int wl1271_cmd_build_null_data(struct wl1271 *wl);
diff --git a/drivers/net/wireless/wl12xx/wl1271_event.c b/drivers/net/wireless/wl12xx/wl1271_event.c
index 25ce2cd..bced829 100644
--- a/drivers/net/wireless/wl12xx/wl1271_event.c
+++ b/drivers/net/wireless/wl12xx/wl1271_event.c
@@ -52,7 +52,7 @@ void wl1271_pspoll_work(struct work_struct *work)
 	 * delivery failure occurred, and no-one changed state since, so
 	 * we should go back to powersave.
 	 */
-	wl1271_ps_set_mode(wl, STATION_POWER_SAVE_MODE, true);
+	wl1271_ps_set_mode(wl, STATION_POWER_SAVE_MODE, wl->basic_rate, true);
 
 out:
 	mutex_unlock(&wl->mutex);
@@ -70,7 +70,8 @@ static void wl1271_event_pspoll_delivery_fail(struct wl1271 *wl)
 
 	/* force active mode receive data from the AP */
 	if (test_bit(WL1271_FLAG_PSM, &wl->flags)) {
-		ret = wl1271_ps_set_mode(wl, STATION_ACTIVE_MODE, true);
+		ret = wl1271_ps_set_mode(wl, STATION_ACTIVE_MODE,
+					 wl->basic_rate, true);
 		if (ret < 0)
 			return;
 		set_bit(WL1271_FLAG_PSPOLL_FAILURE, &wl->flags);
@@ -91,6 +92,8 @@ static int wl1271_event_ps_report(struct wl1271 *wl,
 				  bool *beacon_loss)
 {
 	int ret = 0;
+	u32 total_retries = wl->conf.conn.psm_entry_retries;
+	u32 rates;
 
 	wl1271_debug(DEBUG_EVENT, "ps_status: 0x%x", mbox->ps_status);
 
@@ -104,10 +107,14 @@ static int wl1271_event_ps_report(struct wl1271 *wl,
 			break;
 		}
 
-		if (wl->psm_entry_retry < wl->conf.conn.psm_entry_retries) {
+		if (wl->psm_entry_retry < total_retries) {
 			wl->psm_entry_retry++;
+			if (wl->psm_entry_retry == total_retries)
+				rates = wl->basic_rate;
+			else
+				rates = wl->basic_rate_set;
 			ret = wl1271_ps_set_mode(wl, STATION_POWER_SAVE_MODE,
-						 true);
+						 rates, true);
 		} else {
 			wl1271_info("No ack to nullfunc from AP.");
 			wl->psm_entry_retry = 0;
@@ -143,7 +150,7 @@ static int wl1271_event_ps_report(struct wl1271 *wl,
 		/* make sure the firmware goes to active mode - the frame to
 		   be sent next will indicate to the AP, that we are active. */
 		ret = wl1271_ps_set_mode(wl, STATION_ACTIVE_MODE,
-					 false);
+					 wl->basic_rate, false);
 		break;
 	case EVENT_EXIT_POWER_SAVE_SUCCESS:
 	default:
diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
index 11e112f..81f92a0 100644
--- a/drivers/net/wireless/wl12xx/wl1271_main.c
+++ b/drivers/net/wireless/wl12xx/wl1271_main.c
@@ -1341,7 +1341,7 @@ static int wl1271_op_config(struct ieee80211_hw *hw, u32 changed)
 		if (test_bit(WL1271_FLAG_STA_ASSOCIATED, &wl->flags)) {
 			wl1271_debug(DEBUG_PSM, "psm enabled");
 			ret = wl1271_ps_set_mode(wl, STATION_POWER_SAVE_MODE,
-						 true);
+						 wl->basic_rate_set, true);
 		}
 	} else if (!(conf->flags & IEEE80211_CONF_PS) &&
 		   test_bit(WL1271_FLAG_PSM_REQUESTED, &wl->flags)) {
@@ -1351,7 +1351,7 @@ static int wl1271_op_config(struct ieee80211_hw *hw, u32 changed)
 
 		if (test_bit(WL1271_FLAG_PSM, &wl->flags))
 			ret = wl1271_ps_set_mode(wl, STATION_ACTIVE_MODE,
-						 true);
+						 wl->basic_rate_set, true);
 	}
 
 	if (conf->power_level != wl->power_level) {
@@ -1826,7 +1826,9 @@ static void wl1271_op_bss_info_changed(struct ieee80211_hw *hw,
 			if (test_bit(WL1271_FLAG_PSM_REQUESTED, &wl->flags) &&
 			    !test_bit(WL1271_FLAG_PSM, &wl->flags)) {
 				mode = STATION_POWER_SAVE_MODE;
-				ret = wl1271_ps_set_mode(wl, mode, true);
+				ret = wl1271_ps_set_mode(wl, mode,
+							 wl->basic_rate_set,
+							 true);
 				if (ret < 0)
 					goto out_sleep;
 			}
diff --git a/drivers/net/wireless/wl12xx/wl1271_ps.c b/drivers/net/wireless/wl12xx/wl1271_ps.c
index 52a6095..f75668e 100644
--- a/drivers/net/wireless/wl12xx/wl1271_ps.c
+++ b/drivers/net/wireless/wl12xx/wl1271_ps.c
@@ -121,7 +121,7 @@ out:
 }
 
 int wl1271_ps_set_mode(struct wl1271 *wl, enum wl1271_cmd_ps_mode mode,
-		       bool send)
+		       u32 rates, bool send)
 {
 	int ret;
 
@@ -135,7 +135,8 @@ int wl1271_ps_set_mode(struct wl1271 *wl, enum wl1271_cmd_ps_mode mode,
 			return ret;
 		}
 
-		ret = wl1271_cmd_ps_mode(wl, STATION_POWER_SAVE_MODE, send);
+		ret = wl1271_cmd_ps_mode(wl, STATION_POWER_SAVE_MODE,
+					 rates, send);
 		if (ret < 0)
 			return ret;
 
@@ -158,7 +159,8 @@ int wl1271_ps_set_mode(struct wl1271 *wl, enum wl1271_cmd_ps_mode mode,
 		if (ret < 0)
 			return ret;
 
-		ret = wl1271_cmd_ps_mode(wl, STATION_ACTIVE_MODE, send);
+		ret = wl1271_cmd_ps_mode(wl, STATION_ACTIVE_MODE,
+					 rates, send);
 		if (ret < 0)
 			return ret;
 
diff --git a/drivers/net/wireless/wl12xx/wl1271_ps.h b/drivers/net/wireless/wl12xx/wl1271_ps.h
index 940276f..6ba7b03 100644
--- a/drivers/net/wireless/wl12xx/wl1271_ps.h
+++ b/drivers/net/wireless/wl12xx/wl1271_ps.h
@@ -28,7 +28,7 @@
 #include "wl1271_acx.h"
 
 int wl1271_ps_set_mode(struct wl1271 *wl, enum wl1271_cmd_ps_mode mode,
-		       bool send);
+		       u32 rates, bool send);
 void wl1271_ps_elp_sleep(struct wl1271 *wl);
 int wl1271_ps_elp_wakeup(struct wl1271 *wl, bool chip_awake);
 void wl1271_elp_work(struct work_struct *work);
-- 
1.6.3.3

