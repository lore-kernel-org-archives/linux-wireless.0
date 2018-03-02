Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:14194 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1425508AbeCBOX2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 2 Mar 2018 09:23:28 -0500
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@Microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 03/13] staging: wilc1000: fix line over 80 char in handle_cfg_param()
Date: Fri, 2 Mar 2018 19:52:39 +0530
Message-ID: <1520000569-27738-4-git-send-email-ajay.kathat@microchip.com> (sfid-20180302_152333_056784_156DAEA3)
In-Reply-To: <1520000569-27738-1-git-send-email-ajay.kathat@microchip.com>
References: <1520000569-27738-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix 'line over 80 char' issues found by checkpatch.pl script in
handle_cfg_param(). Rename variables and used temporary variables
to fix the line over 80 characters issue.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/host_interface.c | 175 +++++++++++++++++-------------
 1 file changed, 98 insertions(+), 77 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index f992e5d..cabee47 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -469,8 +469,7 @@ static void handle_get_mac_address(struct wilc_vif *vif,
 	complete(&hif_wait_response);
 }
 
-static void handle_cfg_param(struct wilc_vif *vif,
-			     struct cfg_param_attr *cfg_param_attr)
+static void handle_cfg_param(struct wilc_vif *vif, struct cfg_param_attr *param)
 {
 	int ret = 0;
 	struct wid wid_list[32];
@@ -479,12 +478,12 @@ static void handle_cfg_param(struct wilc_vif *vif,
 
 	mutex_lock(&hif_drv->cfg_values_lock);
 
-	if (cfg_param_attr->flag & BSS_TYPE) {
-		u8 bss_type = cfg_param_attr->bss_type;
+	if (param->flag & BSS_TYPE) {
+		u8 bss_type = param->bss_type;
 
 		if (bss_type < 6) {
 			wid_list[i].id = WID_BSS_TYPE;
-			wid_list[i].val = (s8 *)&bss_type;
+			wid_list[i].val = (s8 *)&param->bss_type;
 			wid_list[i].type = WID_CHAR;
 			wid_list[i].size = sizeof(char);
 			hif_drv->cfg_values.bss_type = bss_type;
@@ -494,222 +493,244 @@ static void handle_cfg_param(struct wilc_vif *vif,
 		}
 		i++;
 	}
-	if (cfg_param_attr->flag & AUTH_TYPE) {
-		if (cfg_param_attr->auth_type == 1 ||
-		    cfg_param_attr->auth_type == 2 ||
-		    cfg_param_attr->auth_type == 5) {
+	if (param->flag & AUTH_TYPE) {
+		u8 auth_type = param->auth_type;
+
+		if (auth_type == 1 || auth_type == 2 || auth_type == 5) {
 			wid_list[i].id = WID_AUTH_TYPE;
-			wid_list[i].val = (s8 *)&cfg_param_attr->auth_type;
+			wid_list[i].val = (s8 *)&param->auth_type;
 			wid_list[i].type = WID_CHAR;
 			wid_list[i].size = sizeof(char);
-			hif_drv->cfg_values.auth_type = (u8)cfg_param_attr->auth_type;
+			hif_drv->cfg_values.auth_type = auth_type;
 		} else {
 			netdev_err(vif->ndev, "Impossible value\n");
 			goto unlock;
 		}
 		i++;
 	}
-	if (cfg_param_attr->flag & AUTHEN_TIMEOUT) {
-		if (cfg_param_attr->auth_timeout > 0) {
+	if (param->flag & AUTHEN_TIMEOUT) {
+		if (param->auth_timeout > 0) {
 			wid_list[i].id = WID_AUTH_TIMEOUT;
-			wid_list[i].val = (s8 *)&cfg_param_attr->auth_timeout;
+			wid_list[i].val = (s8 *)&param->auth_timeout;
 			wid_list[i].type = WID_SHORT;
 			wid_list[i].size = sizeof(u16);
-			hif_drv->cfg_values.auth_timeout = cfg_param_attr->auth_timeout;
+			hif_drv->cfg_values.auth_timeout = param->auth_timeout;
 		} else {
 			netdev_err(vif->ndev, "Range(1 ~ 65535) over\n");
 			goto unlock;
 		}
 		i++;
 	}
-	if (cfg_param_attr->flag & POWER_MANAGEMENT) {
-		if (cfg_param_attr->power_mgmt_mode < 5) {
+	if (param->flag & POWER_MANAGEMENT) {
+		u8 pm_mode = param->power_mgmt_mode;
+
+		if (pm_mode < 5) {
 			wid_list[i].id = WID_POWER_MANAGEMENT;
-			wid_list[i].val = (s8 *)&cfg_param_attr->power_mgmt_mode;
+			wid_list[i].val = (s8 *)&param->power_mgmt_mode;
 			wid_list[i].type = WID_CHAR;
 			wid_list[i].size = sizeof(char);
-			hif_drv->cfg_values.power_mgmt_mode = (u8)cfg_param_attr->power_mgmt_mode;
+			hif_drv->cfg_values.power_mgmt_mode = pm_mode;
 		} else {
 			netdev_err(vif->ndev, "Invalid power mode\n");
 			goto unlock;
 		}
 		i++;
 	}
-	if (cfg_param_attr->flag & RETRY_SHORT) {
-		if (cfg_param_attr->short_retry_limit > 0 &&
-		    cfg_param_attr->short_retry_limit < 256) {
+	if (param->flag & RETRY_SHORT) {
+		u16 retry_limit = param->short_retry_limit;
+
+		if (retry_limit > 0 && retry_limit < 256) {
 			wid_list[i].id = WID_SHORT_RETRY_LIMIT;
-			wid_list[i].val = (s8 *)&cfg_param_attr->short_retry_limit;
+			wid_list[i].val = (s8 *)&param->short_retry_limit;
 			wid_list[i].type = WID_SHORT;
 			wid_list[i].size = sizeof(u16);
-			hif_drv->cfg_values.short_retry_limit = cfg_param_attr->short_retry_limit;
+			hif_drv->cfg_values.short_retry_limit = retry_limit;
 		} else {
 			netdev_err(vif->ndev, "Range(1~256) over\n");
 			goto unlock;
 		}
 		i++;
 	}
-	if (cfg_param_attr->flag & RETRY_LONG) {
-		if (cfg_param_attr->long_retry_limit > 0 &&
-		    cfg_param_attr->long_retry_limit < 256) {
+	if (param->flag & RETRY_LONG) {
+		u16 limit = param->long_retry_limit;
+
+		if (limit > 0 && limit < 256) {
 			wid_list[i].id = WID_LONG_RETRY_LIMIT;
-			wid_list[i].val = (s8 *)&cfg_param_attr->long_retry_limit;
+			wid_list[i].val = (s8 *)&param->long_retry_limit;
 			wid_list[i].type = WID_SHORT;
 			wid_list[i].size = sizeof(u16);
-			hif_drv->cfg_values.long_retry_limit = cfg_param_attr->long_retry_limit;
+			hif_drv->cfg_values.long_retry_limit = limit;
 		} else {
 			netdev_err(vif->ndev, "Range(1~256) over\n");
 			goto unlock;
 		}
 		i++;
 	}
-	if (cfg_param_attr->flag & FRAG_THRESHOLD) {
-		if (cfg_param_attr->frag_threshold > 255 &&
-		    cfg_param_attr->frag_threshold < 7937) {
+	if (param->flag & FRAG_THRESHOLD) {
+		u16 frag_th = param->frag_threshold;
+
+		if (frag_th > 255 && frag_th < 7937) {
 			wid_list[i].id = WID_FRAG_THRESHOLD;
-			wid_list[i].val = (s8 *)&cfg_param_attr->frag_threshold;
+			wid_list[i].val = (s8 *)&param->frag_threshold;
 			wid_list[i].type = WID_SHORT;
 			wid_list[i].size = sizeof(u16);
-			hif_drv->cfg_values.frag_threshold = cfg_param_attr->frag_threshold;
+			hif_drv->cfg_values.frag_threshold = frag_th;
 		} else {
 			netdev_err(vif->ndev, "Threshold Range fail\n");
 			goto unlock;
 		}
 		i++;
 	}
-	if (cfg_param_attr->flag & RTS_THRESHOLD) {
-		if (cfg_param_attr->rts_threshold > 255) {
+	if (param->flag & RTS_THRESHOLD) {
+		u16 rts_th = param->rts_threshold;
+
+		if (rts_th > 255) {
 			wid_list[i].id = WID_RTS_THRESHOLD;
-			wid_list[i].val = (s8 *)&cfg_param_attr->rts_threshold;
+			wid_list[i].val = (s8 *)&param->rts_threshold;
 			wid_list[i].type = WID_SHORT;
 			wid_list[i].size = sizeof(u16);
-			hif_drv->cfg_values.rts_threshold = cfg_param_attr->rts_threshold;
+			hif_drv->cfg_values.rts_threshold = rts_th;
 		} else {
 			netdev_err(vif->ndev, "Threshold Range fail\n");
 			goto unlock;
 		}
 		i++;
 	}
-	if (cfg_param_attr->flag & PREAMBLE) {
-		if (cfg_param_attr->preamble_type < 3) {
+	if (param->flag & PREAMBLE) {
+		u16 preamble_type = param->preamble_type;
+
+		if (param->preamble_type < 3) {
 			wid_list[i].id = WID_PREAMBLE;
-			wid_list[i].val = (s8 *)&cfg_param_attr->preamble_type;
+			wid_list[i].val = (s8 *)&param->preamble_type;
 			wid_list[i].type = WID_CHAR;
 			wid_list[i].size = sizeof(char);
-			hif_drv->cfg_values.preamble_type = cfg_param_attr->preamble_type;
+			hif_drv->cfg_values.preamble_type = preamble_type;
 		} else {
 			netdev_err(vif->ndev, "Preamle Range(0~2) over\n");
 			goto unlock;
 		}
 		i++;
 	}
-	if (cfg_param_attr->flag & SHORT_SLOT_ALLOWED) {
-		if (cfg_param_attr->short_slot_allowed < 2) {
+	if (param->flag & SHORT_SLOT_ALLOWED) {
+		u8 slot_allowed = param->short_slot_allowed;
+
+		if (slot_allowed < 2) {
 			wid_list[i].id = WID_SHORT_SLOT_ALLOWED;
-			wid_list[i].val = (s8 *)&cfg_param_attr->short_slot_allowed;
+			wid_list[i].val = (s8 *)&param->short_slot_allowed;
 			wid_list[i].type = WID_CHAR;
 			wid_list[i].size = sizeof(char);
-			hif_drv->cfg_values.short_slot_allowed = (u8)cfg_param_attr->short_slot_allowed;
+			hif_drv->cfg_values.short_slot_allowed = slot_allowed;
 		} else {
 			netdev_err(vif->ndev, "Short slot(2) over\n");
 			goto unlock;
 		}
 		i++;
 	}
-	if (cfg_param_attr->flag & TXOP_PROT_DISABLE) {
-		if (cfg_param_attr->txop_prot_disabled < 2) {
+	if (param->flag & TXOP_PROT_DISABLE) {
+		u8 prot_disabled = param->txop_prot_disabled;
+
+		if (param->txop_prot_disabled < 2) {
 			wid_list[i].id = WID_11N_TXOP_PROT_DISABLE;
-			wid_list[i].val = (s8 *)&cfg_param_attr->txop_prot_disabled;
+			wid_list[i].val = (s8 *)&param->txop_prot_disabled;
 			wid_list[i].type = WID_CHAR;
 			wid_list[i].size = sizeof(char);
-			hif_drv->cfg_values.txop_prot_disabled = (u8)cfg_param_attr->txop_prot_disabled;
+			hif_drv->cfg_values.txop_prot_disabled = prot_disabled;
 		} else {
 			netdev_err(vif->ndev, "TXOP prot disable\n");
 			goto unlock;
 		}
 		i++;
 	}
-	if (cfg_param_attr->flag & BEACON_INTERVAL) {
-		if (cfg_param_attr->beacon_interval > 0) {
+	if (param->flag & BEACON_INTERVAL) {
+		u16 beacon_interval = param->beacon_interval;
+
+		if (beacon_interval > 0) {
 			wid_list[i].id = WID_BEACON_INTERVAL;
-			wid_list[i].val = (s8 *)&cfg_param_attr->beacon_interval;
+			wid_list[i].val = (s8 *)&param->beacon_interval;
 			wid_list[i].type = WID_SHORT;
 			wid_list[i].size = sizeof(u16);
-			hif_drv->cfg_values.beacon_interval = cfg_param_attr->beacon_interval;
+			hif_drv->cfg_values.beacon_interval = beacon_interval;
 		} else {
 			netdev_err(vif->ndev, "Beacon interval(1~65535)fail\n");
 			goto unlock;
 		}
 		i++;
 	}
-	if (cfg_param_attr->flag & DTIM_PERIOD) {
-		if (cfg_param_attr->dtim_period > 0 &&
-		    cfg_param_attr->dtim_period < 256) {
+	if (param->flag & DTIM_PERIOD) {
+		if (param->dtim_period > 0 && param->dtim_period < 256) {
 			wid_list[i].id = WID_DTIM_PERIOD;
-			wid_list[i].val = (s8 *)&cfg_param_attr->dtim_period;
+			wid_list[i].val = (s8 *)&param->dtim_period;
 			wid_list[i].type = WID_CHAR;
 			wid_list[i].size = sizeof(char);
-			hif_drv->cfg_values.dtim_period = cfg_param_attr->dtim_period;
+			hif_drv->cfg_values.dtim_period = param->dtim_period;
 		} else {
 			netdev_err(vif->ndev, "DTIM range(1~255) fail\n");
 			goto unlock;
 		}
 		i++;
 	}
-	if (cfg_param_attr->flag & SITE_SURVEY) {
-		if (cfg_param_attr->site_survey_enabled < 3) {
+	if (param->flag & SITE_SURVEY) {
+		enum SITESURVEY enabled = param->site_survey_enabled;
+
+		if (enabled < 3) {
 			wid_list[i].id = WID_SITE_SURVEY;
-			wid_list[i].val = (s8 *)&cfg_param_attr->site_survey_enabled;
+			wid_list[i].val = (s8 *)&param->site_survey_enabled;
 			wid_list[i].type = WID_CHAR;
 			wid_list[i].size = sizeof(char);
-			hif_drv->cfg_values.site_survey_enabled = (u8)cfg_param_attr->site_survey_enabled;
+			hif_drv->cfg_values.site_survey_enabled = enabled;
 		} else {
 			netdev_err(vif->ndev, "Site survey disable\n");
 			goto unlock;
 		}
 		i++;
 	}
-	if (cfg_param_attr->flag & SITE_SURVEY_SCAN_TIME) {
-		if (cfg_param_attr->site_survey_scan_time > 0) {
+	if (param->flag & SITE_SURVEY_SCAN_TIME) {
+		u16 scan_time = param->site_survey_scan_time;
+
+		if (scan_time > 0) {
 			wid_list[i].id = WID_SITE_SURVEY_SCAN_TIME;
-			wid_list[i].val = (s8 *)&cfg_param_attr->site_survey_scan_time;
+			wid_list[i].val = (s8 *)&param->site_survey_scan_time;
 			wid_list[i].type = WID_SHORT;
 			wid_list[i].size = sizeof(u16);
-			hif_drv->cfg_values.site_survey_scan_time = cfg_param_attr->site_survey_scan_time;
+			hif_drv->cfg_values.site_survey_scan_time = scan_time;
 		} else {
 			netdev_err(vif->ndev, "Site scan time(1~65535) over\n");
 			goto unlock;
 		}
 		i++;
 	}
-	if (cfg_param_attr->flag & ACTIVE_SCANTIME) {
-		if (cfg_param_attr->active_scan_time > 0) {
+	if (param->flag & ACTIVE_SCANTIME) {
+		u16 active_scan_time = param->active_scan_time;
+
+		if (active_scan_time > 0) {
 			wid_list[i].id = WID_ACTIVE_SCAN_TIME;
-			wid_list[i].val = (s8 *)&cfg_param_attr->active_scan_time;
+			wid_list[i].val = (s8 *)&param->active_scan_time;
 			wid_list[i].type = WID_SHORT;
 			wid_list[i].size = sizeof(u16);
-			hif_drv->cfg_values.active_scan_time = cfg_param_attr->active_scan_time;
+			hif_drv->cfg_values.active_scan_time = active_scan_time;
 		} else {
 			netdev_err(vif->ndev, "Active time(1~65535) over\n");
 			goto unlock;
 		}
 		i++;
 	}
-	if (cfg_param_attr->flag & PASSIVE_SCANTIME) {
-		if (cfg_param_attr->passive_scan_time > 0) {
+	if (param->flag & PASSIVE_SCANTIME) {
+		u16 time = param->passive_scan_time;
+
+		if (time > 0) {
 			wid_list[i].id = WID_PASSIVE_SCAN_TIME;
-			wid_list[i].val = (s8 *)&cfg_param_attr->passive_scan_time;
+			wid_list[i].val = (s8 *)&param->passive_scan_time;
 			wid_list[i].type = WID_SHORT;
 			wid_list[i].size = sizeof(u16);
-			hif_drv->cfg_values.passive_scan_time = cfg_param_attr->passive_scan_time;
+			hif_drv->cfg_values.passive_scan_time = time;
 		} else {
 			netdev_err(vif->ndev, "Passive time(1~65535) over\n");
 			goto unlock;
 		}
 		i++;
 	}
-	if (cfg_param_attr->flag & CURRENT_TX_RATE) {
-		enum CURRENT_TXRATE curr_tx_rate = cfg_param_attr->curr_tx_rate;
+	if (param->flag & CURRENT_TX_RATE) {
+		enum CURRENT_TXRATE curr_tx_rate = param->curr_tx_rate;
 
 		if (curr_tx_rate == AUTORATE || curr_tx_rate == MBPS_1 ||
 		    curr_tx_rate == MBPS_2 || curr_tx_rate == MBPS_5_5 ||
-- 
2.7.4
