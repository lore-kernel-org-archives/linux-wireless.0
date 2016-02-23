Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f170.google.com ([209.85.192.170]:35495 "EHLO
	mail-pf0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757054AbcBWGiP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Feb 2016 01:38:15 -0500
Received: by mail-pf0-f170.google.com with SMTP id c10so110309220pfc.2
        for <linux-wireless@vger.kernel.org>; Mon, 22 Feb 2016 22:38:15 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 2/7] staging: wilc1000: handle_cfg_param: remove wrapper struct cfg_param_attr
Date: Tue, 23 Feb 2016 15:37:58 +0900
Message-Id: <1456209483-20345-2-git-send-email-chaehyun.lim@gmail.com> (sfid-20160223_073819_125170_FCB1EE4C)
In-Reply-To: <1456209483-20345-1-git-send-email-chaehyun.lim@gmail.com>
References: <1456209483-20345-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This struct just wrap struct cfg_param_val. There is no other member
except struct cfg_param_val.
This patch remove struct cfg_param_attr, then struct cfg_param_val is
renamed to struct cfg_param_attr.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c         | 172 +++++++++++-----------
 drivers/staging/wilc1000/host_interface.h         |   6 +-
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c |   2 +-
 3 files changed, 88 insertions(+), 92 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index e442d81..c97df27 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -62,10 +62,6 @@
 #define TCP_ACK_FILTER_LINK_SPEED_THRESH	54
 #define DEFAULT_LINK_SPEED			72
 
-struct cfg_param_attr {
-	struct cfg_param_val cfg_attr_info;
-};
-
 struct host_if_wpa_attr {
 	u8 *key;
 	const u8 *mac_addr;
@@ -481,13 +477,13 @@ static s32 handle_cfg_param(struct wilc_vif *vif,
 
 	down(&hif_drv->sem_cfg_values);
 
-	if (cfg_param_attr->cfg_attr_info.flag & BSS_TYPE) {
-		if (cfg_param_attr->cfg_attr_info.bss_type < 6) {
+	if (cfg_param_attr->flag & BSS_TYPE) {
+		if (cfg_param_attr->bss_type < 6) {
 			wid_list[wid_cnt].id = WID_BSS_TYPE;
-			wid_list[wid_cnt].val = (s8 *)&cfg_param_attr->cfg_attr_info.bss_type;
+			wid_list[wid_cnt].val = (s8 *)&cfg_param_attr->bss_type;
 			wid_list[wid_cnt].type = WID_CHAR;
 			wid_list[wid_cnt].size = sizeof(char);
-			hif_drv->cfg_values.bss_type = (u8)cfg_param_attr->cfg_attr_info.bss_type;
+			hif_drv->cfg_values.bss_type = (u8)cfg_param_attr->bss_type;
 		} else {
 			netdev_err(vif->ndev, "check value 6 over\n");
 			result = -EINVAL;
@@ -495,15 +491,15 @@ static s32 handle_cfg_param(struct wilc_vif *vif,
 		}
 		wid_cnt++;
 	}
-	if (cfg_param_attr->cfg_attr_info.flag & AUTH_TYPE) {
-		if (cfg_param_attr->cfg_attr_info.auth_type == 1 ||
-		    cfg_param_attr->cfg_attr_info.auth_type == 2 ||
-		    cfg_param_attr->cfg_attr_info.auth_type == 5) {
+	if (cfg_param_attr->flag & AUTH_TYPE) {
+		if (cfg_param_attr->auth_type == 1 ||
+		    cfg_param_attr->auth_type == 2 ||
+		    cfg_param_attr->auth_type == 5) {
 			wid_list[wid_cnt].id = WID_AUTH_TYPE;
-			wid_list[wid_cnt].val = (s8 *)&cfg_param_attr->cfg_attr_info.auth_type;
+			wid_list[wid_cnt].val = (s8 *)&cfg_param_attr->auth_type;
 			wid_list[wid_cnt].type = WID_CHAR;
 			wid_list[wid_cnt].size = sizeof(char);
-			hif_drv->cfg_values.auth_type = (u8)cfg_param_attr->cfg_attr_info.auth_type;
+			hif_drv->cfg_values.auth_type = (u8)cfg_param_attr->auth_type;
 		} else {
 			netdev_err(vif->ndev, "Impossible value \n");
 			result = -EINVAL;
@@ -511,14 +507,14 @@ static s32 handle_cfg_param(struct wilc_vif *vif,
 		}
 		wid_cnt++;
 	}
-	if (cfg_param_attr->cfg_attr_info.flag & AUTHEN_TIMEOUT) {
-		if (cfg_param_attr->cfg_attr_info.auth_timeout > 0 &&
-		    cfg_param_attr->cfg_attr_info.auth_timeout < 65536) {
+	if (cfg_param_attr->flag & AUTHEN_TIMEOUT) {
+		if (cfg_param_attr->auth_timeout > 0 &&
+		    cfg_param_attr->auth_timeout < 65536) {
 			wid_list[wid_cnt].id = WID_AUTH_TIMEOUT;
-			wid_list[wid_cnt].val = (s8 *)&cfg_param_attr->cfg_attr_info.auth_timeout;
+			wid_list[wid_cnt].val = (s8 *)&cfg_param_attr->auth_timeout;
 			wid_list[wid_cnt].type = WID_SHORT;
 			wid_list[wid_cnt].size = sizeof(u16);
-			hif_drv->cfg_values.auth_timeout = cfg_param_attr->cfg_attr_info.auth_timeout;
+			hif_drv->cfg_values.auth_timeout = cfg_param_attr->auth_timeout;
 		} else {
 			netdev_err(vif->ndev, "Range(1 ~ 65535) over\n");
 			result = -EINVAL;
@@ -526,13 +522,13 @@ static s32 handle_cfg_param(struct wilc_vif *vif,
 		}
 		wid_cnt++;
 	}
-	if (cfg_param_attr->cfg_attr_info.flag & POWER_MANAGEMENT) {
-		if (cfg_param_attr->cfg_attr_info.power_mgmt_mode < 5) {
+	if (cfg_param_attr->flag & POWER_MANAGEMENT) {
+		if (cfg_param_attr->power_mgmt_mode < 5) {
 			wid_list[wid_cnt].id = WID_POWER_MANAGEMENT;
-			wid_list[wid_cnt].val = (s8 *)&cfg_param_attr->cfg_attr_info.power_mgmt_mode;
+			wid_list[wid_cnt].val = (s8 *)&cfg_param_attr->power_mgmt_mode;
 			wid_list[wid_cnt].type = WID_CHAR;
 			wid_list[wid_cnt].size = sizeof(char);
-			hif_drv->cfg_values.power_mgmt_mode = (u8)cfg_param_attr->cfg_attr_info.power_mgmt_mode;
+			hif_drv->cfg_values.power_mgmt_mode = (u8)cfg_param_attr->power_mgmt_mode;
 		} else {
 			netdev_err(vif->ndev, "Invalid power mode\n");
 			result = -EINVAL;
@@ -540,14 +536,14 @@ static s32 handle_cfg_param(struct wilc_vif *vif,
 		}
 		wid_cnt++;
 	}
-	if (cfg_param_attr->cfg_attr_info.flag & RETRY_SHORT) {
-		if (cfg_param_attr->cfg_attr_info.short_retry_limit > 0 &&
-		    cfg_param_attr->cfg_attr_info.short_retry_limit < 256) {
+	if (cfg_param_attr->flag & RETRY_SHORT) {
+		if (cfg_param_attr->short_retry_limit > 0 &&
+		    cfg_param_attr->short_retry_limit < 256) {
 			wid_list[wid_cnt].id = WID_SHORT_RETRY_LIMIT;
-			wid_list[wid_cnt].val = (s8 *)&cfg_param_attr->cfg_attr_info.short_retry_limit;
+			wid_list[wid_cnt].val = (s8 *)&cfg_param_attr->short_retry_limit;
 			wid_list[wid_cnt].type = WID_SHORT;
 			wid_list[wid_cnt].size = sizeof(u16);
-			hif_drv->cfg_values.short_retry_limit = cfg_param_attr->cfg_attr_info.short_retry_limit;
+			hif_drv->cfg_values.short_retry_limit = cfg_param_attr->short_retry_limit;
 		} else {
 			netdev_err(vif->ndev, "Range(1~256) over\n");
 			result = -EINVAL;
@@ -555,14 +551,14 @@ static s32 handle_cfg_param(struct wilc_vif *vif,
 		}
 		wid_cnt++;
 	}
-	if (cfg_param_attr->cfg_attr_info.flag & RETRY_LONG) {
-		if (cfg_param_attr->cfg_attr_info.long_retry_limit > 0 &&
-		    cfg_param_attr->cfg_attr_info.long_retry_limit < 256) {
+	if (cfg_param_attr->flag & RETRY_LONG) {
+		if (cfg_param_attr->long_retry_limit > 0 &&
+		    cfg_param_attr->long_retry_limit < 256) {
 			wid_list[wid_cnt].id = WID_LONG_RETRY_LIMIT;
-			wid_list[wid_cnt].val = (s8 *)&cfg_param_attr->cfg_attr_info.long_retry_limit;
+			wid_list[wid_cnt].val = (s8 *)&cfg_param_attr->long_retry_limit;
 			wid_list[wid_cnt].type = WID_SHORT;
 			wid_list[wid_cnt].size = sizeof(u16);
-			hif_drv->cfg_values.long_retry_limit = cfg_param_attr->cfg_attr_info.long_retry_limit;
+			hif_drv->cfg_values.long_retry_limit = cfg_param_attr->long_retry_limit;
 		} else {
 			netdev_err(vif->ndev, "Range(1~256) over\n");
 			result = -EINVAL;
@@ -570,14 +566,14 @@ static s32 handle_cfg_param(struct wilc_vif *vif,
 		}
 		wid_cnt++;
 	}
-	if (cfg_param_attr->cfg_attr_info.flag & FRAG_THRESHOLD) {
-		if (cfg_param_attr->cfg_attr_info.frag_threshold > 255 &&
-		    cfg_param_attr->cfg_attr_info.frag_threshold < 7937) {
+	if (cfg_param_attr->flag & FRAG_THRESHOLD) {
+		if (cfg_param_attr->frag_threshold > 255 &&
+		    cfg_param_attr->frag_threshold < 7937) {
 			wid_list[wid_cnt].id = WID_FRAG_THRESHOLD;
-			wid_list[wid_cnt].val = (s8 *)&cfg_param_attr->cfg_attr_info.frag_threshold;
+			wid_list[wid_cnt].val = (s8 *)&cfg_param_attr->frag_threshold;
 			wid_list[wid_cnt].type = WID_SHORT;
 			wid_list[wid_cnt].size = sizeof(u16);
-			hif_drv->cfg_values.frag_threshold = cfg_param_attr->cfg_attr_info.frag_threshold;
+			hif_drv->cfg_values.frag_threshold = cfg_param_attr->frag_threshold;
 		} else {
 			netdev_err(vif->ndev, "Threshold Range fail\n");
 			result = -EINVAL;
@@ -585,14 +581,14 @@ static s32 handle_cfg_param(struct wilc_vif *vif,
 		}
 		wid_cnt++;
 	}
-	if (cfg_param_attr->cfg_attr_info.flag & RTS_THRESHOLD) {
-		if (cfg_param_attr->cfg_attr_info.rts_threshold > 255 &&
-		    cfg_param_attr->cfg_attr_info.rts_threshold < 65536) {
+	if (cfg_param_attr->flag & RTS_THRESHOLD) {
+		if (cfg_param_attr->rts_threshold > 255 &&
+		    cfg_param_attr->rts_threshold < 65536) {
 			wid_list[wid_cnt].id = WID_RTS_THRESHOLD;
-			wid_list[wid_cnt].val = (s8 *)&cfg_param_attr->cfg_attr_info.rts_threshold;
+			wid_list[wid_cnt].val = (s8 *)&cfg_param_attr->rts_threshold;
 			wid_list[wid_cnt].type = WID_SHORT;
 			wid_list[wid_cnt].size = sizeof(u16);
-			hif_drv->cfg_values.rts_threshold = cfg_param_attr->cfg_attr_info.rts_threshold;
+			hif_drv->cfg_values.rts_threshold = cfg_param_attr->rts_threshold;
 		} else {
 			netdev_err(vif->ndev, "Threshold Range fail\n");
 			result = -EINVAL;
@@ -600,13 +596,13 @@ static s32 handle_cfg_param(struct wilc_vif *vif,
 		}
 		wid_cnt++;
 	}
-	if (cfg_param_attr->cfg_attr_info.flag & PREAMBLE) {
-		if (cfg_param_attr->cfg_attr_info.preamble_type < 3) {
+	if (cfg_param_attr->flag & PREAMBLE) {
+		if (cfg_param_attr->preamble_type < 3) {
 			wid_list[wid_cnt].id = WID_PREAMBLE;
-			wid_list[wid_cnt].val = (s8 *)&cfg_param_attr->cfg_attr_info.preamble_type;
+			wid_list[wid_cnt].val = (s8 *)&cfg_param_attr->preamble_type;
 			wid_list[wid_cnt].type = WID_CHAR;
 			wid_list[wid_cnt].size = sizeof(char);
-			hif_drv->cfg_values.preamble_type = cfg_param_attr->cfg_attr_info.preamble_type;
+			hif_drv->cfg_values.preamble_type = cfg_param_attr->preamble_type;
 		} else {
 			netdev_err(vif->ndev, "Preamle Range(0~2) over\n");
 			result = -EINVAL;
@@ -614,13 +610,13 @@ static s32 handle_cfg_param(struct wilc_vif *vif,
 		}
 		wid_cnt++;
 	}
-	if (cfg_param_attr->cfg_attr_info.flag & SHORT_SLOT_ALLOWED) {
-		if (cfg_param_attr->cfg_attr_info.short_slot_allowed < 2) {
+	if (cfg_param_attr->flag & SHORT_SLOT_ALLOWED) {
+		if (cfg_param_attr->short_slot_allowed < 2) {
 			wid_list[wid_cnt].id = WID_SHORT_SLOT_ALLOWED;
-			wid_list[wid_cnt].val = (s8 *)&cfg_param_attr->cfg_attr_info.short_slot_allowed;
+			wid_list[wid_cnt].val = (s8 *)&cfg_param_attr->short_slot_allowed;
 			wid_list[wid_cnt].type = WID_CHAR;
 			wid_list[wid_cnt].size = sizeof(char);
-			hif_drv->cfg_values.short_slot_allowed = (u8)cfg_param_attr->cfg_attr_info.short_slot_allowed;
+			hif_drv->cfg_values.short_slot_allowed = (u8)cfg_param_attr->short_slot_allowed;
 		} else {
 			netdev_err(vif->ndev, "Short slot(2) over\n");
 			result = -EINVAL;
@@ -628,13 +624,13 @@ static s32 handle_cfg_param(struct wilc_vif *vif,
 		}
 		wid_cnt++;
 	}
-	if (cfg_param_attr->cfg_attr_info.flag & TXOP_PROT_DISABLE) {
-		if (cfg_param_attr->cfg_attr_info.txop_prot_disabled < 2) {
+	if (cfg_param_attr->flag & TXOP_PROT_DISABLE) {
+		if (cfg_param_attr->txop_prot_disabled < 2) {
 			wid_list[wid_cnt].id = WID_11N_TXOP_PROT_DISABLE;
-			wid_list[wid_cnt].val = (s8 *)&cfg_param_attr->cfg_attr_info.txop_prot_disabled;
+			wid_list[wid_cnt].val = (s8 *)&cfg_param_attr->txop_prot_disabled;
 			wid_list[wid_cnt].type = WID_CHAR;
 			wid_list[wid_cnt].size = sizeof(char);
-			hif_drv->cfg_values.txop_prot_disabled = (u8)cfg_param_attr->cfg_attr_info.txop_prot_disabled;
+			hif_drv->cfg_values.txop_prot_disabled = (u8)cfg_param_attr->txop_prot_disabled;
 		} else {
 			netdev_err(vif->ndev, "TXOP prot disable\n");
 			result = -EINVAL;
@@ -642,14 +638,14 @@ static s32 handle_cfg_param(struct wilc_vif *vif,
 		}
 		wid_cnt++;
 	}
-	if (cfg_param_attr->cfg_attr_info.flag & BEACON_INTERVAL) {
-		if (cfg_param_attr->cfg_attr_info.beacon_interval > 0 &&
-		    cfg_param_attr->cfg_attr_info.beacon_interval < 65536) {
+	if (cfg_param_attr->flag & BEACON_INTERVAL) {
+		if (cfg_param_attr->beacon_interval > 0 &&
+		    cfg_param_attr->beacon_interval < 65536) {
 			wid_list[wid_cnt].id = WID_BEACON_INTERVAL;
-			wid_list[wid_cnt].val = (s8 *)&cfg_param_attr->cfg_attr_info.beacon_interval;
+			wid_list[wid_cnt].val = (s8 *)&cfg_param_attr->beacon_interval;
 			wid_list[wid_cnt].type = WID_SHORT;
 			wid_list[wid_cnt].size = sizeof(u16);
-			hif_drv->cfg_values.beacon_interval = cfg_param_attr->cfg_attr_info.beacon_interval;
+			hif_drv->cfg_values.beacon_interval = cfg_param_attr->beacon_interval;
 		} else {
 			netdev_err(vif->ndev, "Beacon interval(1~65535)fail\n");
 			result = -EINVAL;
@@ -657,14 +653,14 @@ static s32 handle_cfg_param(struct wilc_vif *vif,
 		}
 		wid_cnt++;
 	}
-	if (cfg_param_attr->cfg_attr_info.flag & DTIM_PERIOD) {
-		if (cfg_param_attr->cfg_attr_info.dtim_period > 0 &&
-		    cfg_param_attr->cfg_attr_info.dtim_period < 256) {
+	if (cfg_param_attr->flag & DTIM_PERIOD) {
+		if (cfg_param_attr->dtim_period > 0 &&
+		    cfg_param_attr->dtim_period < 256) {
 			wid_list[wid_cnt].id = WID_DTIM_PERIOD;
-			wid_list[wid_cnt].val = (s8 *)&cfg_param_attr->cfg_attr_info.dtim_period;
+			wid_list[wid_cnt].val = (s8 *)&cfg_param_attr->dtim_period;
 			wid_list[wid_cnt].type = WID_CHAR;
 			wid_list[wid_cnt].size = sizeof(char);
-			hif_drv->cfg_values.dtim_period = cfg_param_attr->cfg_attr_info.dtim_period;
+			hif_drv->cfg_values.dtim_period = cfg_param_attr->dtim_period;
 		} else {
 			netdev_err(vif->ndev, "DTIM range(1~255) fail\n");
 			result = -EINVAL;
@@ -672,13 +668,13 @@ static s32 handle_cfg_param(struct wilc_vif *vif,
 		}
 		wid_cnt++;
 	}
-	if (cfg_param_attr->cfg_attr_info.flag & SITE_SURVEY) {
-		if (cfg_param_attr->cfg_attr_info.site_survey_enabled < 3) {
+	if (cfg_param_attr->flag & SITE_SURVEY) {
+		if (cfg_param_attr->site_survey_enabled < 3) {
 			wid_list[wid_cnt].id = WID_SITE_SURVEY;
-			wid_list[wid_cnt].val = (s8 *)&cfg_param_attr->cfg_attr_info.site_survey_enabled;
+			wid_list[wid_cnt].val = (s8 *)&cfg_param_attr->site_survey_enabled;
 			wid_list[wid_cnt].type = WID_CHAR;
 			wid_list[wid_cnt].size = sizeof(char);
-			hif_drv->cfg_values.site_survey_enabled = (u8)cfg_param_attr->cfg_attr_info.site_survey_enabled;
+			hif_drv->cfg_values.site_survey_enabled = (u8)cfg_param_attr->site_survey_enabled;
 		} else {
 			netdev_err(vif->ndev, "Site survey disable\n");
 			result = -EINVAL;
@@ -686,14 +682,14 @@ static s32 handle_cfg_param(struct wilc_vif *vif,
 		}
 		wid_cnt++;
 	}
-	if (cfg_param_attr->cfg_attr_info.flag & SITE_SURVEY_SCAN_TIME) {
-		if (cfg_param_attr->cfg_attr_info.site_survey_scan_time > 0 &&
-		    cfg_param_attr->cfg_attr_info.site_survey_scan_time < 65536) {
+	if (cfg_param_attr->flag & SITE_SURVEY_SCAN_TIME) {
+		if (cfg_param_attr->site_survey_scan_time > 0 &&
+		    cfg_param_attr->site_survey_scan_time < 65536) {
 			wid_list[wid_cnt].id = WID_SITE_SURVEY_SCAN_TIME;
-			wid_list[wid_cnt].val = (s8 *)&cfg_param_attr->cfg_attr_info.site_survey_scan_time;
+			wid_list[wid_cnt].val = (s8 *)&cfg_param_attr->site_survey_scan_time;
 			wid_list[wid_cnt].type = WID_SHORT;
 			wid_list[wid_cnt].size = sizeof(u16);
-			hif_drv->cfg_values.site_survey_scan_time = cfg_param_attr->cfg_attr_info.site_survey_scan_time;
+			hif_drv->cfg_values.site_survey_scan_time = cfg_param_attr->site_survey_scan_time;
 		} else {
 			netdev_err(vif->ndev, "Site scan time(1~65535) over\n");
 			result = -EINVAL;
@@ -701,14 +697,14 @@ static s32 handle_cfg_param(struct wilc_vif *vif,
 		}
 		wid_cnt++;
 	}
-	if (cfg_param_attr->cfg_attr_info.flag & ACTIVE_SCANTIME) {
-		if (cfg_param_attr->cfg_attr_info.active_scan_time > 0 &&
-		    cfg_param_attr->cfg_attr_info.active_scan_time < 65536) {
+	if (cfg_param_attr->flag & ACTIVE_SCANTIME) {
+		if (cfg_param_attr->active_scan_time > 0 &&
+		    cfg_param_attr->active_scan_time < 65536) {
 			wid_list[wid_cnt].id = WID_ACTIVE_SCAN_TIME;
-			wid_list[wid_cnt].val = (s8 *)&cfg_param_attr->cfg_attr_info.active_scan_time;
+			wid_list[wid_cnt].val = (s8 *)&cfg_param_attr->active_scan_time;
 			wid_list[wid_cnt].type = WID_SHORT;
 			wid_list[wid_cnt].size = sizeof(u16);
-			hif_drv->cfg_values.active_scan_time = cfg_param_attr->cfg_attr_info.active_scan_time;
+			hif_drv->cfg_values.active_scan_time = cfg_param_attr->active_scan_time;
 		} else {
 			netdev_err(vif->ndev, "Active time(1~65535) over\n");
 			result = -EINVAL;
@@ -716,14 +712,14 @@ static s32 handle_cfg_param(struct wilc_vif *vif,
 		}
 		wid_cnt++;
 	}
-	if (cfg_param_attr->cfg_attr_info.flag & PASSIVE_SCANTIME) {
-		if (cfg_param_attr->cfg_attr_info.passive_scan_time > 0 &&
-		    cfg_param_attr->cfg_attr_info.passive_scan_time < 65536) {
+	if (cfg_param_attr->flag & PASSIVE_SCANTIME) {
+		if (cfg_param_attr->passive_scan_time > 0 &&
+		    cfg_param_attr->passive_scan_time < 65536) {
 			wid_list[wid_cnt].id = WID_PASSIVE_SCAN_TIME;
-			wid_list[wid_cnt].val = (s8 *)&cfg_param_attr->cfg_attr_info.passive_scan_time;
+			wid_list[wid_cnt].val = (s8 *)&cfg_param_attr->passive_scan_time;
 			wid_list[wid_cnt].type = WID_SHORT;
 			wid_list[wid_cnt].size = sizeof(u16);
-			hif_drv->cfg_values.passive_scan_time = cfg_param_attr->cfg_attr_info.passive_scan_time;
+			hif_drv->cfg_values.passive_scan_time = cfg_param_attr->passive_scan_time;
 		} else {
 			netdev_err(vif->ndev, "Passive time(1~65535) over\n");
 			result = -EINVAL;
@@ -731,8 +727,8 @@ static s32 handle_cfg_param(struct wilc_vif *vif,
 		}
 		wid_cnt++;
 	}
-	if (cfg_param_attr->cfg_attr_info.flag & CURRENT_TX_RATE) {
-		enum CURRENT_TXRATE curr_tx_rate = cfg_param_attr->cfg_attr_info.curr_tx_rate;
+	if (cfg_param_attr->flag & CURRENT_TX_RATE) {
+		enum CURRENT_TXRATE curr_tx_rate = cfg_param_attr->curr_tx_rate;
 
 		if (curr_tx_rate == AUTORATE || curr_tx_rate == MBPS_1
 		    || curr_tx_rate == MBPS_2 || curr_tx_rate == MBPS_5_5
@@ -3518,7 +3514,7 @@ int wilc_scan(struct wilc_vif *vif, u8 scan_source, u8 scan_type,
 }
 
 int wilc_hif_set_cfg(struct wilc_vif *vif,
-		     struct cfg_param_val *cfg_param)
+		     struct cfg_param_attr *cfg_param)
 {
 	int result = 0;
 	struct host_if_msg msg;
@@ -3531,7 +3527,7 @@ int wilc_hif_set_cfg(struct wilc_vif *vif,
 
 	memset(&msg, 0, sizeof(struct host_if_msg));
 	msg.id = HOST_IF_MSG_CFG_PARAMS;
-	msg.body.cfg_info.cfg_attr_info = *cfg_param;
+	msg.body.cfg_info = *cfg_param;
 	msg.vif = vif;
 
 	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 6135024..f70ad7a 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -96,7 +96,7 @@ enum CURRENT_TXRATE {
 	MBPS_54		= 54
 };
 
-struct cfg_param_val {
+struct cfg_param_attr {
 	u32 flag;
 	u8 ht_enable;
 	u8 bss_type;
@@ -272,7 +272,7 @@ struct host_if_drv {
 	enum host_if_state hif_state;
 
 	u8 assoc_bssid[ETH_ALEN];
-	struct cfg_param_val cfg_values;
+	struct cfg_param_attr cfg_values;
 
 	struct semaphore sem_cfg_values;
 	struct semaphore sem_test_key_block;
@@ -336,7 +336,7 @@ int wilc_scan(struct wilc_vif *vif, u8 scan_source, u8 scan_type,
 	      size_t ies_len, wilc_scan_result scan_result, void *user_arg,
 	      struct hidden_network *hidden_network);
 int wilc_hif_set_cfg(struct wilc_vif *vif,
-		     struct cfg_param_val *cfg_param);
+		     struct cfg_param_attr *cfg_param);
 int wilc_init(struct net_device *dev, struct host_if_drv **hif_drv_handler);
 int wilc_deinit(struct wilc_vif *vif);
 int wilc_add_beacon(struct wilc_vif *vif, u32 interval, u32 dtim_period,
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index a7aa3d2..21f0f18 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -1251,7 +1251,7 @@ static int change_bss(struct wiphy *wiphy, struct net_device *dev,
 static int set_wiphy_params(struct wiphy *wiphy, u32 changed)
 {
 	s32 s32Error = 0;
-	struct cfg_param_val pstrCfgParamVal;
+	struct cfg_param_attr pstrCfgParamVal;
 	struct wilc_priv *priv;
 	struct wilc_vif *vif;
 
-- 
2.7.1

