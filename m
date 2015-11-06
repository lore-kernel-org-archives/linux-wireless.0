Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:37976 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031265AbbKFCTT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Nov 2015 21:19:19 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 73/73] staging: wilc1000: rename u8WidCnt of handle_cfg_param function
Date: Fri, 6 Nov 2015 11:20:12 +0900
Message-ID: <1446776412-30670-24-git-send-email-glen.lee@atmel.com> (sfid-20151106_031925_612594_C66F4FF8)
In-Reply-To: <1446776412-30670-1-git-send-email-glen.lee@atmel.com>
References: <1446776412-30670-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames u8WidCnt variable of handle_cfg_param function to wid_cnt
to avoid camelcase.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 184 +++++++++++++++---------------
 1 file changed, 92 insertions(+), 92 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 588a027..1a334ae 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -522,7 +522,7 @@ static s32 handle_cfg_param(struct host_if_drv *hif_drv,
 {
 	s32 result = 0;
 	struct wid wid_list[32];
-	u8 u8WidCnt = 0;
+	u8 wid_cnt = 0;
 
 	down(&hif_drv->sem_cfg_values);
 
@@ -530,253 +530,253 @@ static s32 handle_cfg_param(struct host_if_drv *hif_drv,
 
 	if (cfg_param_attr->cfg_attr_info.flag & BSS_TYPE) {
 		if (cfg_param_attr->cfg_attr_info.bss_type < 6) {
-			wid_list[u8WidCnt].id = WID_BSS_TYPE;
-			wid_list[u8WidCnt].val = (s8 *)&cfg_param_attr->cfg_attr_info.bss_type;
-			wid_list[u8WidCnt].type = WID_CHAR;
-			wid_list[u8WidCnt].size = sizeof(char);
+			wid_list[wid_cnt].id = WID_BSS_TYPE;
+			wid_list[wid_cnt].val = (s8 *)&cfg_param_attr->cfg_attr_info.bss_type;
+			wid_list[wid_cnt].type = WID_CHAR;
+			wid_list[wid_cnt].size = sizeof(char);
 			hif_drv->cfg_values.bss_type = (u8)cfg_param_attr->cfg_attr_info.bss_type;
 		} else {
 			PRINT_ER("check value 6 over\n");
 			result = -EINVAL;
 			goto ERRORHANDLER;
 		}
-		u8WidCnt++;
+		wid_cnt++;
 	}
 	if (cfg_param_attr->cfg_attr_info.flag & AUTH_TYPE) {
 		if (cfg_param_attr->cfg_attr_info.auth_type == 1 ||
 		    cfg_param_attr->cfg_attr_info.auth_type == 2 ||
 		    cfg_param_attr->cfg_attr_info.auth_type == 5) {
-			wid_list[u8WidCnt].id = WID_AUTH_TYPE;
-			wid_list[u8WidCnt].val = (s8 *)&cfg_param_attr->cfg_attr_info.auth_type;
-			wid_list[u8WidCnt].type = WID_CHAR;
-			wid_list[u8WidCnt].size = sizeof(char);
+			wid_list[wid_cnt].id = WID_AUTH_TYPE;
+			wid_list[wid_cnt].val = (s8 *)&cfg_param_attr->cfg_attr_info.auth_type;
+			wid_list[wid_cnt].type = WID_CHAR;
+			wid_list[wid_cnt].size = sizeof(char);
 			hif_drv->cfg_values.auth_type = (u8)cfg_param_attr->cfg_attr_info.auth_type;
 		} else {
 			PRINT_ER("Impossible value \n");
 			result = -EINVAL;
 			goto ERRORHANDLER;
 		}
-		u8WidCnt++;
+		wid_cnt++;
 	}
 	if (cfg_param_attr->cfg_attr_info.flag & AUTHEN_TIMEOUT) {
 		if (cfg_param_attr->cfg_attr_info.auth_timeout > 0 &&
 		    cfg_param_attr->cfg_attr_info.auth_timeout < 65536) {
-			wid_list[u8WidCnt].id = WID_AUTH_TIMEOUT;
-			wid_list[u8WidCnt].val = (s8 *)&cfg_param_attr->cfg_attr_info.auth_timeout;
-			wid_list[u8WidCnt].type = WID_SHORT;
-			wid_list[u8WidCnt].size = sizeof(u16);
+			wid_list[wid_cnt].id = WID_AUTH_TIMEOUT;
+			wid_list[wid_cnt].val = (s8 *)&cfg_param_attr->cfg_attr_info.auth_timeout;
+			wid_list[wid_cnt].type = WID_SHORT;
+			wid_list[wid_cnt].size = sizeof(u16);
 			hif_drv->cfg_values.auth_timeout = cfg_param_attr->cfg_attr_info.auth_timeout;
 		} else {
 			PRINT_ER("Range(1 ~ 65535) over\n");
 			result = -EINVAL;
 			goto ERRORHANDLER;
 		}
-		u8WidCnt++;
+		wid_cnt++;
 	}
 	if (cfg_param_attr->cfg_attr_info.flag & POWER_MANAGEMENT) {
 		if (cfg_param_attr->cfg_attr_info.power_mgmt_mode < 5) {
-			wid_list[u8WidCnt].id = WID_POWER_MANAGEMENT;
-			wid_list[u8WidCnt].val = (s8 *)&cfg_param_attr->cfg_attr_info.power_mgmt_mode;
-			wid_list[u8WidCnt].type = WID_CHAR;
-			wid_list[u8WidCnt].size = sizeof(char);
+			wid_list[wid_cnt].id = WID_POWER_MANAGEMENT;
+			wid_list[wid_cnt].val = (s8 *)&cfg_param_attr->cfg_attr_info.power_mgmt_mode;
+			wid_list[wid_cnt].type = WID_CHAR;
+			wid_list[wid_cnt].size = sizeof(char);
 			hif_drv->cfg_values.power_mgmt_mode = (u8)cfg_param_attr->cfg_attr_info.power_mgmt_mode;
 		} else {
 			PRINT_ER("Invalide power mode\n");
 			result = -EINVAL;
 			goto ERRORHANDLER;
 		}
-		u8WidCnt++;
+		wid_cnt++;
 	}
 	if (cfg_param_attr->cfg_attr_info.flag & RETRY_SHORT) {
 		if (cfg_param_attr->cfg_attr_info.short_retry_limit > 0 &&
 		    cfg_param_attr->cfg_attr_info.short_retry_limit < 256) {
-			wid_list[u8WidCnt].id = WID_SHORT_RETRY_LIMIT;
-			wid_list[u8WidCnt].val = (s8 *)&cfg_param_attr->cfg_attr_info.short_retry_limit;
-			wid_list[u8WidCnt].type = WID_SHORT;
-			wid_list[u8WidCnt].size = sizeof(u16);
+			wid_list[wid_cnt].id = WID_SHORT_RETRY_LIMIT;
+			wid_list[wid_cnt].val = (s8 *)&cfg_param_attr->cfg_attr_info.short_retry_limit;
+			wid_list[wid_cnt].type = WID_SHORT;
+			wid_list[wid_cnt].size = sizeof(u16);
 			hif_drv->cfg_values.short_retry_limit = cfg_param_attr->cfg_attr_info.short_retry_limit;
 		} else {
 			PRINT_ER("Range(1~256) over\n");
 			result = -EINVAL;
 			goto ERRORHANDLER;
 		}
-		u8WidCnt++;
+		wid_cnt++;
 	}
 	if (cfg_param_attr->cfg_attr_info.flag & RETRY_LONG) {
 		if (cfg_param_attr->cfg_attr_info.long_retry_limit > 0 &&
 		    cfg_param_attr->cfg_attr_info.long_retry_limit < 256) {
-			wid_list[u8WidCnt].id = WID_LONG_RETRY_LIMIT;
-			wid_list[u8WidCnt].val = (s8 *)&cfg_param_attr->cfg_attr_info.long_retry_limit;
-			wid_list[u8WidCnt].type = WID_SHORT;
-			wid_list[u8WidCnt].size = sizeof(u16);
+			wid_list[wid_cnt].id = WID_LONG_RETRY_LIMIT;
+			wid_list[wid_cnt].val = (s8 *)&cfg_param_attr->cfg_attr_info.long_retry_limit;
+			wid_list[wid_cnt].type = WID_SHORT;
+			wid_list[wid_cnt].size = sizeof(u16);
 			hif_drv->cfg_values.long_retry_limit = cfg_param_attr->cfg_attr_info.long_retry_limit;
 		} else {
 			PRINT_ER("Range(1~256) over\n");
 			result = -EINVAL;
 			goto ERRORHANDLER;
 		}
-		u8WidCnt++;
+		wid_cnt++;
 	}
 	if (cfg_param_attr->cfg_attr_info.flag & FRAG_THRESHOLD) {
 		if (cfg_param_attr->cfg_attr_info.frag_threshold > 255 &&
 		    cfg_param_attr->cfg_attr_info.frag_threshold < 7937) {
-			wid_list[u8WidCnt].id = WID_FRAG_THRESHOLD;
-			wid_list[u8WidCnt].val = (s8 *)&cfg_param_attr->cfg_attr_info.frag_threshold;
-			wid_list[u8WidCnt].type = WID_SHORT;
-			wid_list[u8WidCnt].size = sizeof(u16);
+			wid_list[wid_cnt].id = WID_FRAG_THRESHOLD;
+			wid_list[wid_cnt].val = (s8 *)&cfg_param_attr->cfg_attr_info.frag_threshold;
+			wid_list[wid_cnt].type = WID_SHORT;
+			wid_list[wid_cnt].size = sizeof(u16);
 			hif_drv->cfg_values.frag_threshold = cfg_param_attr->cfg_attr_info.frag_threshold;
 		} else {
 			PRINT_ER("Threshold Range fail\n");
 			result = -EINVAL;
 			goto ERRORHANDLER;
 		}
-		u8WidCnt++;
+		wid_cnt++;
 	}
 	if (cfg_param_attr->cfg_attr_info.flag & RTS_THRESHOLD) {
 		if (cfg_param_attr->cfg_attr_info.rts_threshold > 255 &&
 		    cfg_param_attr->cfg_attr_info.rts_threshold < 65536) {
-			wid_list[u8WidCnt].id = WID_RTS_THRESHOLD;
-			wid_list[u8WidCnt].val = (s8 *)&cfg_param_attr->cfg_attr_info.rts_threshold;
-			wid_list[u8WidCnt].type = WID_SHORT;
-			wid_list[u8WidCnt].size = sizeof(u16);
+			wid_list[wid_cnt].id = WID_RTS_THRESHOLD;
+			wid_list[wid_cnt].val = (s8 *)&cfg_param_attr->cfg_attr_info.rts_threshold;
+			wid_list[wid_cnt].type = WID_SHORT;
+			wid_list[wid_cnt].size = sizeof(u16);
 			hif_drv->cfg_values.rts_threshold = cfg_param_attr->cfg_attr_info.rts_threshold;
 		} else {
 			PRINT_ER("Threshold Range fail\n");
 			result = -EINVAL;
 			goto ERRORHANDLER;
 		}
-		u8WidCnt++;
+		wid_cnt++;
 	}
 	if (cfg_param_attr->cfg_attr_info.flag & PREAMBLE) {
 		if (cfg_param_attr->cfg_attr_info.preamble_type < 3) {
-			wid_list[u8WidCnt].id = WID_PREAMBLE;
-			wid_list[u8WidCnt].val = (s8 *)&cfg_param_attr->cfg_attr_info.preamble_type;
-			wid_list[u8WidCnt].type = WID_CHAR;
-			wid_list[u8WidCnt].size = sizeof(char);
+			wid_list[wid_cnt].id = WID_PREAMBLE;
+			wid_list[wid_cnt].val = (s8 *)&cfg_param_attr->cfg_attr_info.preamble_type;
+			wid_list[wid_cnt].type = WID_CHAR;
+			wid_list[wid_cnt].size = sizeof(char);
 			hif_drv->cfg_values.preamble_type = cfg_param_attr->cfg_attr_info.preamble_type;
 		} else {
 			PRINT_ER("Preamle Range(0~2) over\n");
 			result = -EINVAL;
 			goto ERRORHANDLER;
 		}
-		u8WidCnt++;
+		wid_cnt++;
 	}
 	if (cfg_param_attr->cfg_attr_info.flag & SHORT_SLOT_ALLOWED) {
 		if (cfg_param_attr->cfg_attr_info.short_slot_allowed < 2) {
-			wid_list[u8WidCnt].id = WID_SHORT_SLOT_ALLOWED;
-			wid_list[u8WidCnt].val = (s8 *)&cfg_param_attr->cfg_attr_info.short_slot_allowed;
-			wid_list[u8WidCnt].type = WID_CHAR;
-			wid_list[u8WidCnt].size = sizeof(char);
+			wid_list[wid_cnt].id = WID_SHORT_SLOT_ALLOWED;
+			wid_list[wid_cnt].val = (s8 *)&cfg_param_attr->cfg_attr_info.short_slot_allowed;
+			wid_list[wid_cnt].type = WID_CHAR;
+			wid_list[wid_cnt].size = sizeof(char);
 			hif_drv->cfg_values.short_slot_allowed = (u8)cfg_param_attr->cfg_attr_info.short_slot_allowed;
 		} else {
 			PRINT_ER("Short slot(2) over\n");
 			result = -EINVAL;
 			goto ERRORHANDLER;
 		}
-		u8WidCnt++;
+		wid_cnt++;
 	}
 	if (cfg_param_attr->cfg_attr_info.flag & TXOP_PROT_DISABLE) {
 		if (cfg_param_attr->cfg_attr_info.txop_prot_disabled < 2) {
-			wid_list[u8WidCnt].id = WID_11N_TXOP_PROT_DISABLE;
-			wid_list[u8WidCnt].val = (s8 *)&cfg_param_attr->cfg_attr_info.txop_prot_disabled;
-			wid_list[u8WidCnt].type = WID_CHAR;
-			wid_list[u8WidCnt].size = sizeof(char);
+			wid_list[wid_cnt].id = WID_11N_TXOP_PROT_DISABLE;
+			wid_list[wid_cnt].val = (s8 *)&cfg_param_attr->cfg_attr_info.txop_prot_disabled;
+			wid_list[wid_cnt].type = WID_CHAR;
+			wid_list[wid_cnt].size = sizeof(char);
 			hif_drv->cfg_values.txop_prot_disabled = (u8)cfg_param_attr->cfg_attr_info.txop_prot_disabled;
 		} else {
 			PRINT_ER("TXOP prot disable\n");
 			result = -EINVAL;
 			goto ERRORHANDLER;
 		}
-		u8WidCnt++;
+		wid_cnt++;
 	}
 	if (cfg_param_attr->cfg_attr_info.flag & BEACON_INTERVAL) {
 		if (cfg_param_attr->cfg_attr_info.beacon_interval > 0 &&
 		    cfg_param_attr->cfg_attr_info.beacon_interval < 65536) {
-			wid_list[u8WidCnt].id = WID_BEACON_INTERVAL;
-			wid_list[u8WidCnt].val = (s8 *)&cfg_param_attr->cfg_attr_info.beacon_interval;
-			wid_list[u8WidCnt].type = WID_SHORT;
-			wid_list[u8WidCnt].size = sizeof(u16);
+			wid_list[wid_cnt].id = WID_BEACON_INTERVAL;
+			wid_list[wid_cnt].val = (s8 *)&cfg_param_attr->cfg_attr_info.beacon_interval;
+			wid_list[wid_cnt].type = WID_SHORT;
+			wid_list[wid_cnt].size = sizeof(u16);
 			hif_drv->cfg_values.beacon_interval = cfg_param_attr->cfg_attr_info.beacon_interval;
 		} else {
 			PRINT_ER("Beacon interval(1~65535) fail\n");
 			result = -EINVAL;
 			goto ERRORHANDLER;
 		}
-		u8WidCnt++;
+		wid_cnt++;
 	}
 	if (cfg_param_attr->cfg_attr_info.flag & DTIM_PERIOD) {
 		if (cfg_param_attr->cfg_attr_info.dtim_period > 0 &&
 		    cfg_param_attr->cfg_attr_info.dtim_period < 256) {
-			wid_list[u8WidCnt].id = WID_DTIM_PERIOD;
-			wid_list[u8WidCnt].val = (s8 *)&cfg_param_attr->cfg_attr_info.dtim_period;
-			wid_list[u8WidCnt].type = WID_CHAR;
-			wid_list[u8WidCnt].size = sizeof(char);
+			wid_list[wid_cnt].id = WID_DTIM_PERIOD;
+			wid_list[wid_cnt].val = (s8 *)&cfg_param_attr->cfg_attr_info.dtim_period;
+			wid_list[wid_cnt].type = WID_CHAR;
+			wid_list[wid_cnt].size = sizeof(char);
 			hif_drv->cfg_values.dtim_period = cfg_param_attr->cfg_attr_info.dtim_period;
 		} else {
 			PRINT_ER("DTIM range(1~255) fail\n");
 			result = -EINVAL;
 			goto ERRORHANDLER;
 		}
-		u8WidCnt++;
+		wid_cnt++;
 	}
 	if (cfg_param_attr->cfg_attr_info.flag & SITE_SURVEY) {
 		if (cfg_param_attr->cfg_attr_info.site_survey_enabled < 3) {
-			wid_list[u8WidCnt].id = WID_SITE_SURVEY;
-			wid_list[u8WidCnt].val = (s8 *)&cfg_param_attr->cfg_attr_info.site_survey_enabled;
-			wid_list[u8WidCnt].type = WID_CHAR;
-			wid_list[u8WidCnt].size = sizeof(char);
+			wid_list[wid_cnt].id = WID_SITE_SURVEY;
+			wid_list[wid_cnt].val = (s8 *)&cfg_param_attr->cfg_attr_info.site_survey_enabled;
+			wid_list[wid_cnt].type = WID_CHAR;
+			wid_list[wid_cnt].size = sizeof(char);
 			hif_drv->cfg_values.site_survey_enabled = (u8)cfg_param_attr->cfg_attr_info.site_survey_enabled;
 		} else {
 			PRINT_ER("Site survey disable\n");
 			result = -EINVAL;
 			goto ERRORHANDLER;
 		}
-		u8WidCnt++;
+		wid_cnt++;
 	}
 	if (cfg_param_attr->cfg_attr_info.flag & SITE_SURVEY_SCAN_TIME) {
 		if (cfg_param_attr->cfg_attr_info.site_survey_scan_time > 0 &&
 		    cfg_param_attr->cfg_attr_info.site_survey_scan_time < 65536) {
-			wid_list[u8WidCnt].id = WID_SITE_SURVEY_SCAN_TIME;
-			wid_list[u8WidCnt].val = (s8 *)&cfg_param_attr->cfg_attr_info.site_survey_scan_time;
-			wid_list[u8WidCnt].type = WID_SHORT;
-			wid_list[u8WidCnt].size = sizeof(u16);
+			wid_list[wid_cnt].id = WID_SITE_SURVEY_SCAN_TIME;
+			wid_list[wid_cnt].val = (s8 *)&cfg_param_attr->cfg_attr_info.site_survey_scan_time;
+			wid_list[wid_cnt].type = WID_SHORT;
+			wid_list[wid_cnt].size = sizeof(u16);
 			hif_drv->cfg_values.site_survey_scan_time = cfg_param_attr->cfg_attr_info.site_survey_scan_time;
 		} else {
 			PRINT_ER("Site survey scan time(1~65535) over\n");
 			result = -EINVAL;
 			goto ERRORHANDLER;
 		}
-		u8WidCnt++;
+		wid_cnt++;
 	}
 	if (cfg_param_attr->cfg_attr_info.flag & ACTIVE_SCANTIME) {
 		if (cfg_param_attr->cfg_attr_info.active_scan_time > 0 &&
 		    cfg_param_attr->cfg_attr_info.active_scan_time < 65536) {
-			wid_list[u8WidCnt].id = WID_ACTIVE_SCAN_TIME;
-			wid_list[u8WidCnt].val = (s8 *)&cfg_param_attr->cfg_attr_info.active_scan_time;
-			wid_list[u8WidCnt].type = WID_SHORT;
-			wid_list[u8WidCnt].size = sizeof(u16);
+			wid_list[wid_cnt].id = WID_ACTIVE_SCAN_TIME;
+			wid_list[wid_cnt].val = (s8 *)&cfg_param_attr->cfg_attr_info.active_scan_time;
+			wid_list[wid_cnt].type = WID_SHORT;
+			wid_list[wid_cnt].size = sizeof(u16);
 			hif_drv->cfg_values.active_scan_time = cfg_param_attr->cfg_attr_info.active_scan_time;
 		} else {
 			PRINT_ER("Active scan time(1~65535) over\n");
 			result = -EINVAL;
 			goto ERRORHANDLER;
 		}
-		u8WidCnt++;
+		wid_cnt++;
 	}
 	if (cfg_param_attr->cfg_attr_info.flag & PASSIVE_SCANTIME) {
 		if (cfg_param_attr->cfg_attr_info.passive_scan_time > 0 &&
 		    cfg_param_attr->cfg_attr_info.passive_scan_time < 65536) {
-			wid_list[u8WidCnt].id = WID_PASSIVE_SCAN_TIME;
-			wid_list[u8WidCnt].val = (s8 *)&cfg_param_attr->cfg_attr_info.passive_scan_time;
-			wid_list[u8WidCnt].type = WID_SHORT;
-			wid_list[u8WidCnt].size = sizeof(u16);
+			wid_list[wid_cnt].id = WID_PASSIVE_SCAN_TIME;
+			wid_list[wid_cnt].val = (s8 *)&cfg_param_attr->cfg_attr_info.passive_scan_time;
+			wid_list[wid_cnt].type = WID_SHORT;
+			wid_list[wid_cnt].size = sizeof(u16);
 			hif_drv->cfg_values.passive_scan_time = cfg_param_attr->cfg_attr_info.passive_scan_time;
 		} else {
 			PRINT_ER("Passive scan time(1~65535) over\n");
 			result = -EINVAL;
 			goto ERRORHANDLER;
 		}
-		u8WidCnt++;
+		wid_cnt++;
 	}
 	if (cfg_param_attr->cfg_attr_info.flag & CURRENT_TX_RATE) {
 		enum CURRENT_TXRATE curr_tx_rate = cfg_param_attr->cfg_attr_info.curr_tx_rate;
@@ -787,20 +787,20 @@ static s32 handle_cfg_param(struct host_if_drv *hif_drv,
 		    || curr_tx_rate == MBPS_9 || curr_tx_rate == MBPS_12
 		    || curr_tx_rate == MBPS_18 || curr_tx_rate == MBPS_24
 		    || curr_tx_rate == MBPS_36 || curr_tx_rate == MBPS_48 || curr_tx_rate == MBPS_54) {
-			wid_list[u8WidCnt].id = WID_CURRENT_TX_RATE;
-			wid_list[u8WidCnt].val = (s8 *)&curr_tx_rate;
-			wid_list[u8WidCnt].type = WID_SHORT;
-			wid_list[u8WidCnt].size = sizeof(u16);
+			wid_list[wid_cnt].id = WID_CURRENT_TX_RATE;
+			wid_list[wid_cnt].val = (s8 *)&curr_tx_rate;
+			wid_list[wid_cnt].type = WID_SHORT;
+			wid_list[wid_cnt].size = sizeof(u16);
 			hif_drv->cfg_values.curr_tx_rate = (u8)curr_tx_rate;
 		} else {
 			PRINT_ER("out of TX rate\n");
 			result = -EINVAL;
 			goto ERRORHANDLER;
 		}
-		u8WidCnt++;
+		wid_cnt++;
 	}
 
-	result = send_config_pkt(SET_CFG, wid_list, u8WidCnt,
+	result = send_config_pkt(SET_CFG, wid_list, wid_cnt,
 				 get_id_from_handler(hif_drv));
 
 	if (result)
-- 
1.9.1

