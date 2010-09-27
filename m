Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:37687 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932861Ab0I0IjA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Sep 2010 04:39:00 -0400
Received: from esebh105.NOE.Nokia.com (esebh105.ntc.nokia.com [172.21.138.211])
	by mgw-mx06.nokia.com (Switch-3.3.3/Switch-3.3.3) with ESMTP id o8R8clY6013190
	for <linux-wireless@vger.kernel.org>; Mon, 27 Sep 2010 11:38:57 +0300
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linux-wireless@vger.kernel.org
Cc: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Subject: [PATCH 25/25] wl1271: Increase connection reliability
Date: Mon, 27 Sep 2010 11:37:49 +0300
Message-Id: <1285576669-8070-26-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1285576669-8070-1-git-send-email-luciano.coelho@nokia.com>
References: <1285576669-8070-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Juuso Oikarinen <juuso.oikarinen@nokia.com>

This patch improves connection reliability by choosing the lowest basic
rate for null-func frames (which increases their range, as the firmware does
not do rate fall-back for null-func frames.) Also, increase the PSM entry
retry-counter.

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Reviewed-by: Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>
Tested-by: Tuomas Katila <ext-tuomas.2.katila@nokia.com>
Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271_cmd.c   |   10 +++++-----
 drivers/net/wireless/wl12xx/wl1271_conf.h  |   16 ++++++++++++++++
 drivers/net/wireless/wl12xx/wl1271_event.c |    7 +------
 drivers/net/wireless/wl12xx/wl1271_main.c  |   10 ++++++----
 4 files changed, 28 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_cmd.c b/drivers/net/wireless/wl12xx/wl1271_cmd.c
index 170b5a8..4a56ab0 100644
--- a/drivers/net/wireless/wl12xx/wl1271_cmd.c
+++ b/drivers/net/wireless/wl12xx/wl1271_cmd.c
@@ -408,8 +408,8 @@ int wl1271_cmd_ps_mode(struct wl1271 *wl, u8 ps_mode, u32 rates, bool send)
 
 	ps_params->ps_mode = ps_mode;
 	ps_params->send_null_data = send;
-	ps_params->retries = 5;
-	ps_params->hang_over_period = 1;
+	ps_params->retries = wl->conf.conn.psm_entry_nullfunc_retries;
+	ps_params->hang_over_period = wl->conf.conn.psm_entry_hangover_period;
 	ps_params->null_data_rate = cpu_to_le32(rates);
 
 	ret = wl1271_cmd_send(wl, CMD_SET_PS_MODE, ps_params,
@@ -484,7 +484,7 @@ int wl1271_cmd_build_null_data(struct wl1271 *wl)
 	}
 
 	ret = wl1271_cmd_template_set(wl, CMD_TEMPL_NULL_DATA, ptr, size, 0,
-				      WL1271_RATE_AUTOMATIC);
+				      wl->basic_rate);
 
 out:
 	dev_kfree_skb(skb);
@@ -507,7 +507,7 @@ int wl1271_cmd_build_klv_null_data(struct wl1271 *wl)
 	ret = wl1271_cmd_template_set(wl, CMD_TEMPL_KLV,
 				      skb->data, skb->len,
 				      CMD_TEMPL_KLV_IDX_NULL_DATA,
-				      WL1271_RATE_AUTOMATIC);
+				      wl->basic_rate);
 
 out:
 	dev_kfree_skb(skb);
@@ -584,7 +584,7 @@ int wl1271_build_qos_null_data(struct wl1271 *wl)
 
 	return wl1271_cmd_template_set(wl, CMD_TEMPL_QOS_NULL_DATA, &template,
 				       sizeof(template), 0,
-				       WL1271_RATE_AUTOMATIC);
+				       wl->basic_rate);
 }
 
 int wl1271_cmd_set_default_wep_key(struct wl1271 *wl, u8 id)
diff --git a/drivers/net/wireless/wl12xx/wl1271_conf.h b/drivers/net/wireless/wl12xx/wl1271_conf.h
index ab716f5..60c50d1 100644
--- a/drivers/net/wireless/wl12xx/wl1271_conf.h
+++ b/drivers/net/wireless/wl12xx/wl1271_conf.h
@@ -912,6 +912,22 @@ struct conf_conn_settings {
 	u8 psm_entry_retries;
 
 	/*
+	 * Specifies the maximum number of times to try transmit the PSM entry
+	 * null-func frame for each PSM entry attempt
+	 *
+	 * Range 0 - 255
+	 */
+	u8 psm_entry_nullfunc_retries;
+
+	/*
+	 * Specifies the time to linger in active mode after successfully
+	 * transmitting the PSM entry null-func frame.
+	 *
+	 * Range 0 - 255 TU's
+	 */
+	u8 psm_entry_hangover_period;
+
+	/*
 	 *
 	 * Specifies the interval of the connection keep-alive null-func
 	 * frame in ms.
diff --git a/drivers/net/wireless/wl12xx/wl1271_event.c b/drivers/net/wireless/wl12xx/wl1271_event.c
index e6c839a..7b3f503 100644
--- a/drivers/net/wireless/wl12xx/wl1271_event.c
+++ b/drivers/net/wireless/wl12xx/wl1271_event.c
@@ -96,7 +96,6 @@ static int wl1271_event_ps_report(struct wl1271 *wl,
 {
 	int ret = 0;
 	u32 total_retries = wl->conf.conn.psm_entry_retries;
-	u32 rates;
 
 	wl1271_debug(DEBUG_EVENT, "ps_status: 0x%x", mbox->ps_status);
 
@@ -112,12 +111,8 @@ static int wl1271_event_ps_report(struct wl1271 *wl,
 
 		if (wl->psm_entry_retry < total_retries) {
 			wl->psm_entry_retry++;
-			if (wl->psm_entry_retry == total_retries)
-				rates = wl->basic_rate;
-			else
-				rates = wl->basic_rate_set;
 			ret = wl1271_ps_set_mode(wl, STATION_POWER_SAVE_MODE,
-						 rates, true);
+						 wl->basic_rate, true);
 		} else {
 			wl1271_info("No ack to nullfunc from AP.");
 			wl->psm_entry_retry = 0;
diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
index dcbd6f5..cb18f22 100644
--- a/drivers/net/wireless/wl12xx/wl1271_main.c
+++ b/drivers/net/wireless/wl12xx/wl1271_main.c
@@ -214,7 +214,9 @@ static struct conf_drv_settings default_conf = {
 		.ps_poll_recovery_period     = 700,
 		.bet_enable                  = CONF_BET_MODE_ENABLE,
 		.bet_max_consecutive         = 10,
-		.psm_entry_retries           = 3,
+		.psm_entry_retries           = 5,
+		.psm_entry_nullfunc_retries  = 3,
+		.psm_entry_hangover_period   = 1,
 		.keep_alive_interval         = 55000,
 		.max_listen_interval         = 20,
 	},
@@ -1360,7 +1362,7 @@ static int wl1271_op_config(struct ieee80211_hw *hw, u32 changed)
 		if (test_bit(WL1271_FLAG_STA_ASSOCIATED, &wl->flags)) {
 			wl1271_debug(DEBUG_PSM, "psm enabled");
 			ret = wl1271_ps_set_mode(wl, STATION_POWER_SAVE_MODE,
-						 wl->basic_rate_set, true);
+						 wl->basic_rate, true);
 		}
 	} else if (!(conf->flags & IEEE80211_CONF_PS) &&
 		   test_bit(WL1271_FLAG_PSM_REQUESTED, &wl->flags)) {
@@ -1370,7 +1372,7 @@ static int wl1271_op_config(struct ieee80211_hw *hw, u32 changed)
 
 		if (test_bit(WL1271_FLAG_PSM, &wl->flags))
 			ret = wl1271_ps_set_mode(wl, STATION_ACTIVE_MODE,
-						 wl->basic_rate_set, true);
+						 wl->basic_rate, true);
 	}
 
 	if (conf->power_level != wl->power_level) {
@@ -1851,7 +1853,7 @@ static void wl1271_op_bss_info_changed(struct ieee80211_hw *hw,
 			    !test_bit(WL1271_FLAG_PSM, &wl->flags)) {
 				mode = STATION_POWER_SAVE_MODE;
 				ret = wl1271_ps_set_mode(wl, mode,
-							 wl->basic_rate_set,
+							 wl->basic_rate,
 							 true);
 				if (ret < 0)
 					goto out_sleep;
-- 
1.6.3.3

