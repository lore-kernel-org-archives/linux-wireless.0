Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f53.google.com ([209.85.220.53]:33244 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932438AbcBWGiV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Feb 2016 01:38:21 -0500
Received: by mail-pa0-f53.google.com with SMTP id fl4so105056015pad.0
        for <linux-wireless@vger.kernel.org>; Mon, 22 Feb 2016 22:38:21 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 4/7] staging: wilc1000: handle_cfg_param: rename wid_cnt
Date: Tue, 23 Feb 2016 15:38:00 +0900
Message-Id: <1456209483-20345-4-git-send-email-chaehyun.lim@gmail.com> (sfid-20160223_073824_810451_8F7AE057)
In-Reply-To: <1456209483-20345-1-git-send-email-chaehyun.lim@gmail.com>
References: <1456209483-20345-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

wid_cnt variable is used as indicating array index of struct wid_list.
This patch renames wid_cnt to i that makes more readability.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 184 +++++++++++++++---------------
 1 file changed, 92 insertions(+), 92 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 382f946..d207c5c 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -473,259 +473,259 @@ static s32 handle_cfg_param(struct wilc_vif *vif,
 	s32 result = 0;
 	struct wid wid_list[32];
 	struct host_if_drv *hif_drv = vif->hif_drv;
-	int wid_cnt = 0;
+	int i = 0;
 
 	down(&hif_drv->sem_cfg_values);
 
 	if (cfg_param_attr->flag & BSS_TYPE) {
 		if (cfg_param_attr->bss_type < 6) {
-			wid_list[wid_cnt].id = WID_BSS_TYPE;
-			wid_list[wid_cnt].val = (s8 *)&cfg_param_attr->bss_type;
-			wid_list[wid_cnt].type = WID_CHAR;
-			wid_list[wid_cnt].size = sizeof(char);
+			wid_list[i].id = WID_BSS_TYPE;
+			wid_list[i].val = (s8 *)&cfg_param_attr->bss_type;
+			wid_list[i].type = WID_CHAR;
+			wid_list[i].size = sizeof(char);
 			hif_drv->cfg_values.bss_type = (u8)cfg_param_attr->bss_type;
 		} else {
 			netdev_err(vif->ndev, "check value 6 over\n");
 			result = -EINVAL;
 			goto ERRORHANDLER;
 		}
-		wid_cnt++;
+		i++;
 	}
 	if (cfg_param_attr->flag & AUTH_TYPE) {
 		if (cfg_param_attr->auth_type == 1 ||
 		    cfg_param_attr->auth_type == 2 ||
 		    cfg_param_attr->auth_type == 5) {
-			wid_list[wid_cnt].id = WID_AUTH_TYPE;
-			wid_list[wid_cnt].val = (s8 *)&cfg_param_attr->auth_type;
-			wid_list[wid_cnt].type = WID_CHAR;
-			wid_list[wid_cnt].size = sizeof(char);
+			wid_list[i].id = WID_AUTH_TYPE;
+			wid_list[i].val = (s8 *)&cfg_param_attr->auth_type;
+			wid_list[i].type = WID_CHAR;
+			wid_list[i].size = sizeof(char);
 			hif_drv->cfg_values.auth_type = (u8)cfg_param_attr->auth_type;
 		} else {
 			netdev_err(vif->ndev, "Impossible value \n");
 			result = -EINVAL;
 			goto ERRORHANDLER;
 		}
-		wid_cnt++;
+		i++;
 	}
 	if (cfg_param_attr->flag & AUTHEN_TIMEOUT) {
 		if (cfg_param_attr->auth_timeout > 0 &&
 		    cfg_param_attr->auth_timeout < 65536) {
-			wid_list[wid_cnt].id = WID_AUTH_TIMEOUT;
-			wid_list[wid_cnt].val = (s8 *)&cfg_param_attr->auth_timeout;
-			wid_list[wid_cnt].type = WID_SHORT;
-			wid_list[wid_cnt].size = sizeof(u16);
+			wid_list[i].id = WID_AUTH_TIMEOUT;
+			wid_list[i].val = (s8 *)&cfg_param_attr->auth_timeout;
+			wid_list[i].type = WID_SHORT;
+			wid_list[i].size = sizeof(u16);
 			hif_drv->cfg_values.auth_timeout = cfg_param_attr->auth_timeout;
 		} else {
 			netdev_err(vif->ndev, "Range(1 ~ 65535) over\n");
 			result = -EINVAL;
 			goto ERRORHANDLER;
 		}
-		wid_cnt++;
+		i++;
 	}
 	if (cfg_param_attr->flag & POWER_MANAGEMENT) {
 		if (cfg_param_attr->power_mgmt_mode < 5) {
-			wid_list[wid_cnt].id = WID_POWER_MANAGEMENT;
-			wid_list[wid_cnt].val = (s8 *)&cfg_param_attr->power_mgmt_mode;
-			wid_list[wid_cnt].type = WID_CHAR;
-			wid_list[wid_cnt].size = sizeof(char);
+			wid_list[i].id = WID_POWER_MANAGEMENT;
+			wid_list[i].val = (s8 *)&cfg_param_attr->power_mgmt_mode;
+			wid_list[i].type = WID_CHAR;
+			wid_list[i].size = sizeof(char);
 			hif_drv->cfg_values.power_mgmt_mode = (u8)cfg_param_attr->power_mgmt_mode;
 		} else {
 			netdev_err(vif->ndev, "Invalid power mode\n");
 			result = -EINVAL;
 			goto ERRORHANDLER;
 		}
-		wid_cnt++;
+		i++;
 	}
 	if (cfg_param_attr->flag & RETRY_SHORT) {
 		if (cfg_param_attr->short_retry_limit > 0 &&
 		    cfg_param_attr->short_retry_limit < 256) {
-			wid_list[wid_cnt].id = WID_SHORT_RETRY_LIMIT;
-			wid_list[wid_cnt].val = (s8 *)&cfg_param_attr->short_retry_limit;
-			wid_list[wid_cnt].type = WID_SHORT;
-			wid_list[wid_cnt].size = sizeof(u16);
+			wid_list[i].id = WID_SHORT_RETRY_LIMIT;
+			wid_list[i].val = (s8 *)&cfg_param_attr->short_retry_limit;
+			wid_list[i].type = WID_SHORT;
+			wid_list[i].size = sizeof(u16);
 			hif_drv->cfg_values.short_retry_limit = cfg_param_attr->short_retry_limit;
 		} else {
 			netdev_err(vif->ndev, "Range(1~256) over\n");
 			result = -EINVAL;
 			goto ERRORHANDLER;
 		}
-		wid_cnt++;
+		i++;
 	}
 	if (cfg_param_attr->flag & RETRY_LONG) {
 		if (cfg_param_attr->long_retry_limit > 0 &&
 		    cfg_param_attr->long_retry_limit < 256) {
-			wid_list[wid_cnt].id = WID_LONG_RETRY_LIMIT;
-			wid_list[wid_cnt].val = (s8 *)&cfg_param_attr->long_retry_limit;
-			wid_list[wid_cnt].type = WID_SHORT;
-			wid_list[wid_cnt].size = sizeof(u16);
+			wid_list[i].id = WID_LONG_RETRY_LIMIT;
+			wid_list[i].val = (s8 *)&cfg_param_attr->long_retry_limit;
+			wid_list[i].type = WID_SHORT;
+			wid_list[i].size = sizeof(u16);
 			hif_drv->cfg_values.long_retry_limit = cfg_param_attr->long_retry_limit;
 		} else {
 			netdev_err(vif->ndev, "Range(1~256) over\n");
 			result = -EINVAL;
 			goto ERRORHANDLER;
 		}
-		wid_cnt++;
+		i++;
 	}
 	if (cfg_param_attr->flag & FRAG_THRESHOLD) {
 		if (cfg_param_attr->frag_threshold > 255 &&
 		    cfg_param_attr->frag_threshold < 7937) {
-			wid_list[wid_cnt].id = WID_FRAG_THRESHOLD;
-			wid_list[wid_cnt].val = (s8 *)&cfg_param_attr->frag_threshold;
-			wid_list[wid_cnt].type = WID_SHORT;
-			wid_list[wid_cnt].size = sizeof(u16);
+			wid_list[i].id = WID_FRAG_THRESHOLD;
+			wid_list[i].val = (s8 *)&cfg_param_attr->frag_threshold;
+			wid_list[i].type = WID_SHORT;
+			wid_list[i].size = sizeof(u16);
 			hif_drv->cfg_values.frag_threshold = cfg_param_attr->frag_threshold;
 		} else {
 			netdev_err(vif->ndev, "Threshold Range fail\n");
 			result = -EINVAL;
 			goto ERRORHANDLER;
 		}
-		wid_cnt++;
+		i++;
 	}
 	if (cfg_param_attr->flag & RTS_THRESHOLD) {
 		if (cfg_param_attr->rts_threshold > 255 &&
 		    cfg_param_attr->rts_threshold < 65536) {
-			wid_list[wid_cnt].id = WID_RTS_THRESHOLD;
-			wid_list[wid_cnt].val = (s8 *)&cfg_param_attr->rts_threshold;
-			wid_list[wid_cnt].type = WID_SHORT;
-			wid_list[wid_cnt].size = sizeof(u16);
+			wid_list[i].id = WID_RTS_THRESHOLD;
+			wid_list[i].val = (s8 *)&cfg_param_attr->rts_threshold;
+			wid_list[i].type = WID_SHORT;
+			wid_list[i].size = sizeof(u16);
 			hif_drv->cfg_values.rts_threshold = cfg_param_attr->rts_threshold;
 		} else {
 			netdev_err(vif->ndev, "Threshold Range fail\n");
 			result = -EINVAL;
 			goto ERRORHANDLER;
 		}
-		wid_cnt++;
+		i++;
 	}
 	if (cfg_param_attr->flag & PREAMBLE) {
 		if (cfg_param_attr->preamble_type < 3) {
-			wid_list[wid_cnt].id = WID_PREAMBLE;
-			wid_list[wid_cnt].val = (s8 *)&cfg_param_attr->preamble_type;
-			wid_list[wid_cnt].type = WID_CHAR;
-			wid_list[wid_cnt].size = sizeof(char);
+			wid_list[i].id = WID_PREAMBLE;
+			wid_list[i].val = (s8 *)&cfg_param_attr->preamble_type;
+			wid_list[i].type = WID_CHAR;
+			wid_list[i].size = sizeof(char);
 			hif_drv->cfg_values.preamble_type = cfg_param_attr->preamble_type;
 		} else {
 			netdev_err(vif->ndev, "Preamle Range(0~2) over\n");
 			result = -EINVAL;
 			goto ERRORHANDLER;
 		}
-		wid_cnt++;
+		i++;
 	}
 	if (cfg_param_attr->flag & SHORT_SLOT_ALLOWED) {
 		if (cfg_param_attr->short_slot_allowed < 2) {
-			wid_list[wid_cnt].id = WID_SHORT_SLOT_ALLOWED;
-			wid_list[wid_cnt].val = (s8 *)&cfg_param_attr->short_slot_allowed;
-			wid_list[wid_cnt].type = WID_CHAR;
-			wid_list[wid_cnt].size = sizeof(char);
+			wid_list[i].id = WID_SHORT_SLOT_ALLOWED;
+			wid_list[i].val = (s8 *)&cfg_param_attr->short_slot_allowed;
+			wid_list[i].type = WID_CHAR;
+			wid_list[i].size = sizeof(char);
 			hif_drv->cfg_values.short_slot_allowed = (u8)cfg_param_attr->short_slot_allowed;
 		} else {
 			netdev_err(vif->ndev, "Short slot(2) over\n");
 			result = -EINVAL;
 			goto ERRORHANDLER;
 		}
-		wid_cnt++;
+		i++;
 	}
 	if (cfg_param_attr->flag & TXOP_PROT_DISABLE) {
 		if (cfg_param_attr->txop_prot_disabled < 2) {
-			wid_list[wid_cnt].id = WID_11N_TXOP_PROT_DISABLE;
-			wid_list[wid_cnt].val = (s8 *)&cfg_param_attr->txop_prot_disabled;
-			wid_list[wid_cnt].type = WID_CHAR;
-			wid_list[wid_cnt].size = sizeof(char);
+			wid_list[i].id = WID_11N_TXOP_PROT_DISABLE;
+			wid_list[i].val = (s8 *)&cfg_param_attr->txop_prot_disabled;
+			wid_list[i].type = WID_CHAR;
+			wid_list[i].size = sizeof(char);
 			hif_drv->cfg_values.txop_prot_disabled = (u8)cfg_param_attr->txop_prot_disabled;
 		} else {
 			netdev_err(vif->ndev, "TXOP prot disable\n");
 			result = -EINVAL;
 			goto ERRORHANDLER;
 		}
-		wid_cnt++;
+		i++;
 	}
 	if (cfg_param_attr->flag & BEACON_INTERVAL) {
 		if (cfg_param_attr->beacon_interval > 0 &&
 		    cfg_param_attr->beacon_interval < 65536) {
-			wid_list[wid_cnt].id = WID_BEACON_INTERVAL;
-			wid_list[wid_cnt].val = (s8 *)&cfg_param_attr->beacon_interval;
-			wid_list[wid_cnt].type = WID_SHORT;
-			wid_list[wid_cnt].size = sizeof(u16);
+			wid_list[i].id = WID_BEACON_INTERVAL;
+			wid_list[i].val = (s8 *)&cfg_param_attr->beacon_interval;
+			wid_list[i].type = WID_SHORT;
+			wid_list[i].size = sizeof(u16);
 			hif_drv->cfg_values.beacon_interval = cfg_param_attr->beacon_interval;
 		} else {
 			netdev_err(vif->ndev, "Beacon interval(1~65535)fail\n");
 			result = -EINVAL;
 			goto ERRORHANDLER;
 		}
-		wid_cnt++;
+		i++;
 	}
 	if (cfg_param_attr->flag & DTIM_PERIOD) {
 		if (cfg_param_attr->dtim_period > 0 &&
 		    cfg_param_attr->dtim_period < 256) {
-			wid_list[wid_cnt].id = WID_DTIM_PERIOD;
-			wid_list[wid_cnt].val = (s8 *)&cfg_param_attr->dtim_period;
-			wid_list[wid_cnt].type = WID_CHAR;
-			wid_list[wid_cnt].size = sizeof(char);
+			wid_list[i].id = WID_DTIM_PERIOD;
+			wid_list[i].val = (s8 *)&cfg_param_attr->dtim_period;
+			wid_list[i].type = WID_CHAR;
+			wid_list[i].size = sizeof(char);
 			hif_drv->cfg_values.dtim_period = cfg_param_attr->dtim_period;
 		} else {
 			netdev_err(vif->ndev, "DTIM range(1~255) fail\n");
 			result = -EINVAL;
 			goto ERRORHANDLER;
 		}
-		wid_cnt++;
+		i++;
 	}
 	if (cfg_param_attr->flag & SITE_SURVEY) {
 		if (cfg_param_attr->site_survey_enabled < 3) {
-			wid_list[wid_cnt].id = WID_SITE_SURVEY;
-			wid_list[wid_cnt].val = (s8 *)&cfg_param_attr->site_survey_enabled;
-			wid_list[wid_cnt].type = WID_CHAR;
-			wid_list[wid_cnt].size = sizeof(char);
+			wid_list[i].id = WID_SITE_SURVEY;
+			wid_list[i].val = (s8 *)&cfg_param_attr->site_survey_enabled;
+			wid_list[i].type = WID_CHAR;
+			wid_list[i].size = sizeof(char);
 			hif_drv->cfg_values.site_survey_enabled = (u8)cfg_param_attr->site_survey_enabled;
 		} else {
 			netdev_err(vif->ndev, "Site survey disable\n");
 			result = -EINVAL;
 			goto ERRORHANDLER;
 		}
-		wid_cnt++;
+		i++;
 	}
 	if (cfg_param_attr->flag & SITE_SURVEY_SCAN_TIME) {
 		if (cfg_param_attr->site_survey_scan_time > 0 &&
 		    cfg_param_attr->site_survey_scan_time < 65536) {
-			wid_list[wid_cnt].id = WID_SITE_SURVEY_SCAN_TIME;
-			wid_list[wid_cnt].val = (s8 *)&cfg_param_attr->site_survey_scan_time;
-			wid_list[wid_cnt].type = WID_SHORT;
-			wid_list[wid_cnt].size = sizeof(u16);
+			wid_list[i].id = WID_SITE_SURVEY_SCAN_TIME;
+			wid_list[i].val = (s8 *)&cfg_param_attr->site_survey_scan_time;
+			wid_list[i].type = WID_SHORT;
+			wid_list[i].size = sizeof(u16);
 			hif_drv->cfg_values.site_survey_scan_time = cfg_param_attr->site_survey_scan_time;
 		} else {
 			netdev_err(vif->ndev, "Site scan time(1~65535) over\n");
 			result = -EINVAL;
 			goto ERRORHANDLER;
 		}
-		wid_cnt++;
+		i++;
 	}
 	if (cfg_param_attr->flag & ACTIVE_SCANTIME) {
 		if (cfg_param_attr->active_scan_time > 0 &&
 		    cfg_param_attr->active_scan_time < 65536) {
-			wid_list[wid_cnt].id = WID_ACTIVE_SCAN_TIME;
-			wid_list[wid_cnt].val = (s8 *)&cfg_param_attr->active_scan_time;
-			wid_list[wid_cnt].type = WID_SHORT;
-			wid_list[wid_cnt].size = sizeof(u16);
+			wid_list[i].id = WID_ACTIVE_SCAN_TIME;
+			wid_list[i].val = (s8 *)&cfg_param_attr->active_scan_time;
+			wid_list[i].type = WID_SHORT;
+			wid_list[i].size = sizeof(u16);
 			hif_drv->cfg_values.active_scan_time = cfg_param_attr->active_scan_time;
 		} else {
 			netdev_err(vif->ndev, "Active time(1~65535) over\n");
 			result = -EINVAL;
 			goto ERRORHANDLER;
 		}
-		wid_cnt++;
+		i++;
 	}
 	if (cfg_param_attr->flag & PASSIVE_SCANTIME) {
 		if (cfg_param_attr->passive_scan_time > 0 &&
 		    cfg_param_attr->passive_scan_time < 65536) {
-			wid_list[wid_cnt].id = WID_PASSIVE_SCAN_TIME;
-			wid_list[wid_cnt].val = (s8 *)&cfg_param_attr->passive_scan_time;
-			wid_list[wid_cnt].type = WID_SHORT;
-			wid_list[wid_cnt].size = sizeof(u16);
+			wid_list[i].id = WID_PASSIVE_SCAN_TIME;
+			wid_list[i].val = (s8 *)&cfg_param_attr->passive_scan_time;
+			wid_list[i].type = WID_SHORT;
+			wid_list[i].size = sizeof(u16);
 			hif_drv->cfg_values.passive_scan_time = cfg_param_attr->passive_scan_time;
 		} else {
 			netdev_err(vif->ndev, "Passive time(1~65535) over\n");
 			result = -EINVAL;
 			goto ERRORHANDLER;
 		}
-		wid_cnt++;
+		i++;
 	}
 	if (cfg_param_attr->flag & CURRENT_TX_RATE) {
 		enum CURRENT_TXRATE curr_tx_rate = cfg_param_attr->curr_tx_rate;
@@ -736,21 +736,21 @@ static s32 handle_cfg_param(struct wilc_vif *vif,
 		    || curr_tx_rate == MBPS_9 || curr_tx_rate == MBPS_12
 		    || curr_tx_rate == MBPS_18 || curr_tx_rate == MBPS_24
 		    || curr_tx_rate == MBPS_36 || curr_tx_rate == MBPS_48 || curr_tx_rate == MBPS_54) {
-			wid_list[wid_cnt].id = WID_CURRENT_TX_RATE;
-			wid_list[wid_cnt].val = (s8 *)&curr_tx_rate;
-			wid_list[wid_cnt].type = WID_SHORT;
-			wid_list[wid_cnt].size = sizeof(u16);
+			wid_list[i].id = WID_CURRENT_TX_RATE;
+			wid_list[i].val = (s8 *)&curr_tx_rate;
+			wid_list[i].type = WID_SHORT;
+			wid_list[i].size = sizeof(u16);
 			hif_drv->cfg_values.curr_tx_rate = (u8)curr_tx_rate;
 		} else {
 			netdev_err(vif->ndev, "out of TX rate\n");
 			result = -EINVAL;
 			goto ERRORHANDLER;
 		}
-		wid_cnt++;
+		i++;
 	}
 
 	result = wilc_send_config_pkt(vif, SET_CFG, wid_list,
-				      wid_cnt, wilc_get_vif_idx(vif));
+				      i, wilc_get_vif_idx(vif));
 
 	if (result)
 		netdev_err(vif->ndev, "Error in setting CFG params\n");
-- 
2.7.1

