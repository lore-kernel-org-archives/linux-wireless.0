Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:7232 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753101AbbKBIsx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Nov 2015 03:48:53 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 06/38] staging: wilc1000: rename strHostIFCfgParamAttr of fuction Handle_CfgParam
Date: Mon, 2 Nov 2015 17:50:49 +0900
Message-ID: <1446454281-22484-6-git-send-email-glen.lee@atmel.com> (sfid-20151102_094859_230808_6A063B63)
In-Reply-To: <1446454281-22484-1-git-send-email-glen.lee@atmel.com>
References: <1446454281-22484-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames strHostIFCfgParamAttr of fuction Handle_CfgParam
to cfg_param_attr to avoid CamelCase naming convention.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 154 ++++++++++++++++--------------
 1 file changed, 83 insertions(+), 71 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 69ec7eb..6abba23 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -538,7 +538,7 @@ static s32 Handle_GetMacAddress(struct host_if_drv *hif_drv,
 }
 
 static s32 Handle_CfgParam(struct host_if_drv *hif_drv,
-			   struct cfg_param_attr *strHostIFCfgParamAttr)
+			   struct cfg_param_attr *cfg_param_attr)
 {
 	s32 result = 0;
 	struct wid strWIDList[32];
@@ -551,13 +551,13 @@ static s32 Handle_CfgParam(struct host_if_drv *hif_drv,
 
 	PRINT_D(HOSTINF_DBG, "Setting CFG params\n");
 
-	if (strHostIFCfgParamAttr->cfg_attr_info.flag & BSS_TYPE) {
-		if (strHostIFCfgParamAttr->cfg_attr_info.bss_type < 6) {
+	if (cfg_param_attr->cfg_attr_info.flag & BSS_TYPE) {
+		if (cfg_param_attr->cfg_attr_info.bss_type < 6) {
 			strWIDList[u8WidCnt].id = WID_BSS_TYPE;
-			strWIDList[u8WidCnt].val = (s8 *)&strHostIFCfgParamAttr->cfg_attr_info.bss_type;
+			strWIDList[u8WidCnt].val = (s8 *)&cfg_param_attr->cfg_attr_info.bss_type;
 			strWIDList[u8WidCnt].type = WID_CHAR;
 			strWIDList[u8WidCnt].size = sizeof(char);
-			hif_drv->cfg_values.bss_type = (u8)strHostIFCfgParamAttr->cfg_attr_info.bss_type;
+			hif_drv->cfg_values.bss_type = (u8)cfg_param_attr->cfg_attr_info.bss_type;
 		} else {
 			PRINT_ER("check value 6 over\n");
 			result = -EINVAL;
@@ -565,13 +565,15 @@ static s32 Handle_CfgParam(struct host_if_drv *hif_drv,
 		}
 		u8WidCnt++;
 	}
-	if (strHostIFCfgParamAttr->cfg_attr_info.flag & AUTH_TYPE) {
-		if ((strHostIFCfgParamAttr->cfg_attr_info.auth_type) == 1 || (strHostIFCfgParamAttr->cfg_attr_info.auth_type) == 2 || (strHostIFCfgParamAttr->cfg_attr_info.auth_type) == 5) {
+	if (cfg_param_attr->cfg_attr_info.flag & AUTH_TYPE) {
+		if (cfg_param_attr->cfg_attr_info.auth_type == 1 ||
+		    cfg_param_attr->cfg_attr_info.auth_type == 2 ||
+		    cfg_param_attr->cfg_attr_info.auth_type == 5) {
 			strWIDList[u8WidCnt].id = WID_AUTH_TYPE;
-			strWIDList[u8WidCnt].val = (s8 *)&strHostIFCfgParamAttr->cfg_attr_info.auth_type;
+			strWIDList[u8WidCnt].val = (s8 *)&cfg_param_attr->cfg_attr_info.auth_type;
 			strWIDList[u8WidCnt].type = WID_CHAR;
 			strWIDList[u8WidCnt].size = sizeof(char);
-			hif_drv->cfg_values.auth_type = (u8)strHostIFCfgParamAttr->cfg_attr_info.auth_type;
+			hif_drv->cfg_values.auth_type = (u8)cfg_param_attr->cfg_attr_info.auth_type;
 		} else {
 			PRINT_ER("Impossible value \n");
 			result = -EINVAL;
@@ -579,13 +581,14 @@ static s32 Handle_CfgParam(struct host_if_drv *hif_drv,
 		}
 		u8WidCnt++;
 	}
-	if (strHostIFCfgParamAttr->cfg_attr_info.flag & AUTHEN_TIMEOUT) {
-		if (strHostIFCfgParamAttr->cfg_attr_info.auth_timeout > 0 && strHostIFCfgParamAttr->cfg_attr_info.auth_timeout < 65536) {
+	if (cfg_param_attr->cfg_attr_info.flag & AUTHEN_TIMEOUT) {
+		if (cfg_param_attr->cfg_attr_info.auth_timeout > 0 &&
+		    cfg_param_attr->cfg_attr_info.auth_timeout < 65536) {
 			strWIDList[u8WidCnt].id = WID_AUTH_TIMEOUT;
-			strWIDList[u8WidCnt].val = (s8 *)&strHostIFCfgParamAttr->cfg_attr_info.auth_timeout;
+			strWIDList[u8WidCnt].val = (s8 *)&cfg_param_attr->cfg_attr_info.auth_timeout;
 			strWIDList[u8WidCnt].type = WID_SHORT;
 			strWIDList[u8WidCnt].size = sizeof(u16);
-			hif_drv->cfg_values.auth_timeout = strHostIFCfgParamAttr->cfg_attr_info.auth_timeout;
+			hif_drv->cfg_values.auth_timeout = cfg_param_attr->cfg_attr_info.auth_timeout;
 		} else {
 			PRINT_ER("Range(1 ~ 65535) over\n");
 			result = -EINVAL;
@@ -593,13 +596,13 @@ static s32 Handle_CfgParam(struct host_if_drv *hif_drv,
 		}
 		u8WidCnt++;
 	}
-	if (strHostIFCfgParamAttr->cfg_attr_info.flag & POWER_MANAGEMENT) {
-		if (strHostIFCfgParamAttr->cfg_attr_info.power_mgmt_mode < 5) {
+	if (cfg_param_attr->cfg_attr_info.flag & POWER_MANAGEMENT) {
+		if (cfg_param_attr->cfg_attr_info.power_mgmt_mode < 5) {
 			strWIDList[u8WidCnt].id = WID_POWER_MANAGEMENT;
-			strWIDList[u8WidCnt].val = (s8 *)&strHostIFCfgParamAttr->cfg_attr_info.power_mgmt_mode;
+			strWIDList[u8WidCnt].val = (s8 *)&cfg_param_attr->cfg_attr_info.power_mgmt_mode;
 			strWIDList[u8WidCnt].type = WID_CHAR;
 			strWIDList[u8WidCnt].size = sizeof(char);
-			hif_drv->cfg_values.power_mgmt_mode = (u8)strHostIFCfgParamAttr->cfg_attr_info.power_mgmt_mode;
+			hif_drv->cfg_values.power_mgmt_mode = (u8)cfg_param_attr->cfg_attr_info.power_mgmt_mode;
 		} else {
 			PRINT_ER("Invalide power mode\n");
 			result = -EINVAL;
@@ -607,13 +610,14 @@ static s32 Handle_CfgParam(struct host_if_drv *hif_drv,
 		}
 		u8WidCnt++;
 	}
-	if (strHostIFCfgParamAttr->cfg_attr_info.flag & RETRY_SHORT) {
-		if ((strHostIFCfgParamAttr->cfg_attr_info.short_retry_limit > 0) && (strHostIFCfgParamAttr->cfg_attr_info.short_retry_limit < 256))	{
+	if (cfg_param_attr->cfg_attr_info.flag & RETRY_SHORT) {
+		if (cfg_param_attr->cfg_attr_info.short_retry_limit > 0 &&
+		    cfg_param_attr->cfg_attr_info.short_retry_limit < 256) {
 			strWIDList[u8WidCnt].id = WID_SHORT_RETRY_LIMIT;
-			strWIDList[u8WidCnt].val = (s8 *)&strHostIFCfgParamAttr->cfg_attr_info.short_retry_limit;
+			strWIDList[u8WidCnt].val = (s8 *)&cfg_param_attr->cfg_attr_info.short_retry_limit;
 			strWIDList[u8WidCnt].type = WID_SHORT;
 			strWIDList[u8WidCnt].size = sizeof(u16);
-			hif_drv->cfg_values.short_retry_limit = strHostIFCfgParamAttr->cfg_attr_info.short_retry_limit;
+			hif_drv->cfg_values.short_retry_limit = cfg_param_attr->cfg_attr_info.short_retry_limit;
 		} else {
 			PRINT_ER("Range(1~256) over\n");
 			result = -EINVAL;
@@ -621,14 +625,15 @@ static s32 Handle_CfgParam(struct host_if_drv *hif_drv,
 		}
 		u8WidCnt++;
 	}
-	if (strHostIFCfgParamAttr->cfg_attr_info.flag & RETRY_LONG) {
-		if ((strHostIFCfgParamAttr->cfg_attr_info.long_retry_limit > 0) && (strHostIFCfgParamAttr->cfg_attr_info.long_retry_limit < 256)) {
+	if (cfg_param_attr->cfg_attr_info.flag & RETRY_LONG) {
+		if (cfg_param_attr->cfg_attr_info.long_retry_limit > 0 &&
+		    cfg_param_attr->cfg_attr_info.long_retry_limit < 256) {
 			strWIDList[u8WidCnt].id = WID_LONG_RETRY_LIMIT;
-			strWIDList[u8WidCnt].val = (s8 *)&strHostIFCfgParamAttr->cfg_attr_info.long_retry_limit;
+			strWIDList[u8WidCnt].val = (s8 *)&cfg_param_attr->cfg_attr_info.long_retry_limit;
 
 			strWIDList[u8WidCnt].type = WID_SHORT;
 			strWIDList[u8WidCnt].size = sizeof(u16);
-			hif_drv->cfg_values.long_retry_limit = strHostIFCfgParamAttr->cfg_attr_info.long_retry_limit;
+			hif_drv->cfg_values.long_retry_limit = cfg_param_attr->cfg_attr_info.long_retry_limit;
 		} else {
 			PRINT_ER("Range(1~256) over\n");
 			result = -EINVAL;
@@ -636,13 +641,14 @@ static s32 Handle_CfgParam(struct host_if_drv *hif_drv,
 		}
 		u8WidCnt++;
 	}
-	if (strHostIFCfgParamAttr->cfg_attr_info.flag & FRAG_THRESHOLD) {
-		if (strHostIFCfgParamAttr->cfg_attr_info.frag_threshold > 255 && strHostIFCfgParamAttr->cfg_attr_info.frag_threshold < 7937) {
+	if (cfg_param_attr->cfg_attr_info.flag & FRAG_THRESHOLD) {
+		if (cfg_param_attr->cfg_attr_info.frag_threshold > 255 &&
+		    cfg_param_attr->cfg_attr_info.frag_threshold < 7937) {
 			strWIDList[u8WidCnt].id = WID_FRAG_THRESHOLD;
-			strWIDList[u8WidCnt].val = (s8 *)&strHostIFCfgParamAttr->cfg_attr_info.frag_threshold;
+			strWIDList[u8WidCnt].val = (s8 *)&cfg_param_attr->cfg_attr_info.frag_threshold;
 			strWIDList[u8WidCnt].type = WID_SHORT;
 			strWIDList[u8WidCnt].size = sizeof(u16);
-			hif_drv->cfg_values.frag_threshold = strHostIFCfgParamAttr->cfg_attr_info.frag_threshold;
+			hif_drv->cfg_values.frag_threshold = cfg_param_attr->cfg_attr_info.frag_threshold;
 		} else {
 			PRINT_ER("Threshold Range fail\n");
 			result = -EINVAL;
@@ -650,13 +656,14 @@ static s32 Handle_CfgParam(struct host_if_drv *hif_drv,
 		}
 		u8WidCnt++;
 	}
-	if (strHostIFCfgParamAttr->cfg_attr_info.flag & RTS_THRESHOLD) {
-		if (strHostIFCfgParamAttr->cfg_attr_info.rts_threshold > 255 && strHostIFCfgParamAttr->cfg_attr_info.rts_threshold < 65536)	{
+	if (cfg_param_attr->cfg_attr_info.flag & RTS_THRESHOLD) {
+		if (cfg_param_attr->cfg_attr_info.rts_threshold > 255 &&
+		    cfg_param_attr->cfg_attr_info.rts_threshold < 65536) {
 			strWIDList[u8WidCnt].id = WID_RTS_THRESHOLD;
-			strWIDList[u8WidCnt].val = (s8 *)&strHostIFCfgParamAttr->cfg_attr_info.rts_threshold;
+			strWIDList[u8WidCnt].val = (s8 *)&cfg_param_attr->cfg_attr_info.rts_threshold;
 			strWIDList[u8WidCnt].type = WID_SHORT;
 			strWIDList[u8WidCnt].size = sizeof(u16);
-			hif_drv->cfg_values.rts_threshold = strHostIFCfgParamAttr->cfg_attr_info.rts_threshold;
+			hif_drv->cfg_values.rts_threshold = cfg_param_attr->cfg_attr_info.rts_threshold;
 		} else {
 			PRINT_ER("Threshold Range fail\n");
 			result = -EINVAL;
@@ -664,13 +671,13 @@ static s32 Handle_CfgParam(struct host_if_drv *hif_drv,
 		}
 		u8WidCnt++;
 	}
-	if (strHostIFCfgParamAttr->cfg_attr_info.flag & PREAMBLE) {
-		if (strHostIFCfgParamAttr->cfg_attr_info.preamble_type < 3) {
+	if (cfg_param_attr->cfg_attr_info.flag & PREAMBLE) {
+		if (cfg_param_attr->cfg_attr_info.preamble_type < 3) {
 			strWIDList[u8WidCnt].id = WID_PREAMBLE;
-			strWIDList[u8WidCnt].val = (s8 *)&strHostIFCfgParamAttr->cfg_attr_info.preamble_type;
+			strWIDList[u8WidCnt].val = (s8 *)&cfg_param_attr->cfg_attr_info.preamble_type;
 			strWIDList[u8WidCnt].type = WID_CHAR;
 			strWIDList[u8WidCnt].size = sizeof(char);
-			hif_drv->cfg_values.preamble_type = strHostIFCfgParamAttr->cfg_attr_info.preamble_type;
+			hif_drv->cfg_values.preamble_type = cfg_param_attr->cfg_attr_info.preamble_type;
 		} else {
 			PRINT_ER("Preamle Range(0~2) over\n");
 			result = -EINVAL;
@@ -678,13 +685,13 @@ static s32 Handle_CfgParam(struct host_if_drv *hif_drv,
 		}
 		u8WidCnt++;
 	}
-	if (strHostIFCfgParamAttr->cfg_attr_info.flag & SHORT_SLOT_ALLOWED) {
-		if (strHostIFCfgParamAttr->cfg_attr_info.short_slot_allowed < 2) {
+	if (cfg_param_attr->cfg_attr_info.flag & SHORT_SLOT_ALLOWED) {
+		if (cfg_param_attr->cfg_attr_info.short_slot_allowed < 2) {
 			strWIDList[u8WidCnt].id = WID_SHORT_SLOT_ALLOWED;
-			strWIDList[u8WidCnt].val = (s8 *)&strHostIFCfgParamAttr->cfg_attr_info.short_slot_allowed;
+			strWIDList[u8WidCnt].val = (s8 *)&cfg_param_attr->cfg_attr_info.short_slot_allowed;
 			strWIDList[u8WidCnt].type = WID_CHAR;
 			strWIDList[u8WidCnt].size = sizeof(char);
-			hif_drv->cfg_values.short_slot_allowed = (u8)strHostIFCfgParamAttr->cfg_attr_info.short_slot_allowed;
+			hif_drv->cfg_values.short_slot_allowed = (u8)cfg_param_attr->cfg_attr_info.short_slot_allowed;
 		} else {
 			PRINT_ER("Short slot(2) over\n");
 			result = -EINVAL;
@@ -692,13 +699,13 @@ static s32 Handle_CfgParam(struct host_if_drv *hif_drv,
 		}
 		u8WidCnt++;
 	}
-	if (strHostIFCfgParamAttr->cfg_attr_info.flag & TXOP_PROT_DISABLE) {
-		if (strHostIFCfgParamAttr->cfg_attr_info.txop_prot_disabled < 2) {
+	if (cfg_param_attr->cfg_attr_info.flag & TXOP_PROT_DISABLE) {
+		if (cfg_param_attr->cfg_attr_info.txop_prot_disabled < 2) {
 			strWIDList[u8WidCnt].id = WID_11N_TXOP_PROT_DISABLE;
-			strWIDList[u8WidCnt].val = (s8 *)&strHostIFCfgParamAttr->cfg_attr_info.txop_prot_disabled;
+			strWIDList[u8WidCnt].val = (s8 *)&cfg_param_attr->cfg_attr_info.txop_prot_disabled;
 			strWIDList[u8WidCnt].type = WID_CHAR;
 			strWIDList[u8WidCnt].size = sizeof(char);
-			hif_drv->cfg_values.txop_prot_disabled = (u8)strHostIFCfgParamAttr->cfg_attr_info.txop_prot_disabled;
+			hif_drv->cfg_values.txop_prot_disabled = (u8)cfg_param_attr->cfg_attr_info.txop_prot_disabled;
 		} else {
 			PRINT_ER("TXOP prot disable\n");
 			result = -EINVAL;
@@ -706,13 +713,14 @@ static s32 Handle_CfgParam(struct host_if_drv *hif_drv,
 		}
 		u8WidCnt++;
 	}
-	if (strHostIFCfgParamAttr->cfg_attr_info.flag & BEACON_INTERVAL) {
-		if (strHostIFCfgParamAttr->cfg_attr_info.beacon_interval > 0 && strHostIFCfgParamAttr->cfg_attr_info.beacon_interval < 65536) {
+	if (cfg_param_attr->cfg_attr_info.flag & BEACON_INTERVAL) {
+		if (cfg_param_attr->cfg_attr_info.beacon_interval > 0 &&
+		    cfg_param_attr->cfg_attr_info.beacon_interval < 65536) {
 			strWIDList[u8WidCnt].id = WID_BEACON_INTERVAL;
-			strWIDList[u8WidCnt].val = (s8 *)&strHostIFCfgParamAttr->cfg_attr_info.beacon_interval;
+			strWIDList[u8WidCnt].val = (s8 *)&cfg_param_attr->cfg_attr_info.beacon_interval;
 			strWIDList[u8WidCnt].type = WID_SHORT;
 			strWIDList[u8WidCnt].size = sizeof(u16);
-			hif_drv->cfg_values.beacon_interval = strHostIFCfgParamAttr->cfg_attr_info.beacon_interval;
+			hif_drv->cfg_values.beacon_interval = cfg_param_attr->cfg_attr_info.beacon_interval;
 		} else {
 			PRINT_ER("Beacon interval(1~65535) fail\n");
 			result = -EINVAL;
@@ -720,13 +728,14 @@ static s32 Handle_CfgParam(struct host_if_drv *hif_drv,
 		}
 		u8WidCnt++;
 	}
-	if (strHostIFCfgParamAttr->cfg_attr_info.flag & DTIM_PERIOD) {
-		if (strHostIFCfgParamAttr->cfg_attr_info.dtim_period > 0 && strHostIFCfgParamAttr->cfg_attr_info.dtim_period < 256) {
+	if (cfg_param_attr->cfg_attr_info.flag & DTIM_PERIOD) {
+		if (cfg_param_attr->cfg_attr_info.dtim_period > 0 &&
+		    cfg_param_attr->cfg_attr_info.dtim_period < 256) {
 			strWIDList[u8WidCnt].id = WID_DTIM_PERIOD;
-			strWIDList[u8WidCnt].val = (s8 *)&strHostIFCfgParamAttr->cfg_attr_info.dtim_period;
+			strWIDList[u8WidCnt].val = (s8 *)&cfg_param_attr->cfg_attr_info.dtim_period;
 			strWIDList[u8WidCnt].type = WID_CHAR;
 			strWIDList[u8WidCnt].size = sizeof(char);
-			hif_drv->cfg_values.dtim_period = strHostIFCfgParamAttr->cfg_attr_info.dtim_period;
+			hif_drv->cfg_values.dtim_period = cfg_param_attr->cfg_attr_info.dtim_period;
 		} else {
 			PRINT_ER("DTIM range(1~255) fail\n");
 			result = -EINVAL;
@@ -734,13 +743,13 @@ static s32 Handle_CfgParam(struct host_if_drv *hif_drv,
 		}
 		u8WidCnt++;
 	}
-	if (strHostIFCfgParamAttr->cfg_attr_info.flag & SITE_SURVEY) {
-		if (strHostIFCfgParamAttr->cfg_attr_info.site_survey_enabled < 3) {
+	if (cfg_param_attr->cfg_attr_info.flag & SITE_SURVEY) {
+		if (cfg_param_attr->cfg_attr_info.site_survey_enabled < 3) {
 			strWIDList[u8WidCnt].id = WID_SITE_SURVEY;
-			strWIDList[u8WidCnt].val = (s8 *)&strHostIFCfgParamAttr->cfg_attr_info.site_survey_enabled;
+			strWIDList[u8WidCnt].val = (s8 *)&cfg_param_attr->cfg_attr_info.site_survey_enabled;
 			strWIDList[u8WidCnt].type = WID_CHAR;
 			strWIDList[u8WidCnt].size = sizeof(char);
-			hif_drv->cfg_values.site_survey_enabled = (u8)strHostIFCfgParamAttr->cfg_attr_info.site_survey_enabled;
+			hif_drv->cfg_values.site_survey_enabled = (u8)cfg_param_attr->cfg_attr_info.site_survey_enabled;
 		} else {
 			PRINT_ER("Site survey disable\n");
 			result = -EINVAL;
@@ -748,13 +757,14 @@ static s32 Handle_CfgParam(struct host_if_drv *hif_drv,
 		}
 		u8WidCnt++;
 	}
-	if (strHostIFCfgParamAttr->cfg_attr_info.flag & SITE_SURVEY_SCAN_TIME) {
-		if (strHostIFCfgParamAttr->cfg_attr_info.site_survey_scan_time > 0 && strHostIFCfgParamAttr->cfg_attr_info.site_survey_scan_time < 65536) {
+	if (cfg_param_attr->cfg_attr_info.flag & SITE_SURVEY_SCAN_TIME) {
+		if (cfg_param_attr->cfg_attr_info.site_survey_scan_time > 0 &&
+		    cfg_param_attr->cfg_attr_info.site_survey_scan_time < 65536) {
 			strWIDList[u8WidCnt].id = WID_SITE_SURVEY_SCAN_TIME;
-			strWIDList[u8WidCnt].val = (s8 *)&strHostIFCfgParamAttr->cfg_attr_info.site_survey_scan_time;
+			strWIDList[u8WidCnt].val = (s8 *)&cfg_param_attr->cfg_attr_info.site_survey_scan_time;
 			strWIDList[u8WidCnt].type = WID_SHORT;
 			strWIDList[u8WidCnt].size = sizeof(u16);
-			hif_drv->cfg_values.site_survey_scan_time = strHostIFCfgParamAttr->cfg_attr_info.site_survey_scan_time;
+			hif_drv->cfg_values.site_survey_scan_time = cfg_param_attr->cfg_attr_info.site_survey_scan_time;
 		} else {
 			PRINT_ER("Site survey scan time(1~65535) over\n");
 			result = -EINVAL;
@@ -762,13 +772,14 @@ static s32 Handle_CfgParam(struct host_if_drv *hif_drv,
 		}
 		u8WidCnt++;
 	}
-	if (strHostIFCfgParamAttr->cfg_attr_info.flag & ACTIVE_SCANTIME) {
-		if (strHostIFCfgParamAttr->cfg_attr_info.active_scan_time > 0 && strHostIFCfgParamAttr->cfg_attr_info.active_scan_time < 65536) {
+	if (cfg_param_attr->cfg_attr_info.flag & ACTIVE_SCANTIME) {
+		if (cfg_param_attr->cfg_attr_info.active_scan_time > 0 &&
+		    cfg_param_attr->cfg_attr_info.active_scan_time < 65536) {
 			strWIDList[u8WidCnt].id = WID_ACTIVE_SCAN_TIME;
-			strWIDList[u8WidCnt].val = (s8 *)&strHostIFCfgParamAttr->cfg_attr_info.active_scan_time;
+			strWIDList[u8WidCnt].val = (s8 *)&cfg_param_attr->cfg_attr_info.active_scan_time;
 			strWIDList[u8WidCnt].type = WID_SHORT;
 			strWIDList[u8WidCnt].size = sizeof(u16);
-			hif_drv->cfg_values.active_scan_time = strHostIFCfgParamAttr->cfg_attr_info.active_scan_time;
+			hif_drv->cfg_values.active_scan_time = cfg_param_attr->cfg_attr_info.active_scan_time;
 		} else {
 			PRINT_ER("Active scan time(1~65535) over\n");
 			result = -EINVAL;
@@ -776,13 +787,14 @@ static s32 Handle_CfgParam(struct host_if_drv *hif_drv,
 		}
 		u8WidCnt++;
 	}
-	if (strHostIFCfgParamAttr->cfg_attr_info.flag & PASSIVE_SCANTIME) {
-		if (strHostIFCfgParamAttr->cfg_attr_info.passive_scan_time > 0 && strHostIFCfgParamAttr->cfg_attr_info.passive_scan_time < 65536) {
+	if (cfg_param_attr->cfg_attr_info.flag & PASSIVE_SCANTIME) {
+		if (cfg_param_attr->cfg_attr_info.passive_scan_time > 0 &&
+		    cfg_param_attr->cfg_attr_info.passive_scan_time < 65536) {
 			strWIDList[u8WidCnt].id = WID_PASSIVE_SCAN_TIME;
-			strWIDList[u8WidCnt].val = (s8 *)&strHostIFCfgParamAttr->cfg_attr_info.passive_scan_time;
+			strWIDList[u8WidCnt].val = (s8 *)&cfg_param_attr->cfg_attr_info.passive_scan_time;
 			strWIDList[u8WidCnt].type = WID_SHORT;
 			strWIDList[u8WidCnt].size = sizeof(u16);
-			hif_drv->cfg_values.passive_scan_time = strHostIFCfgParamAttr->cfg_attr_info.passive_scan_time;
+			hif_drv->cfg_values.passive_scan_time = cfg_param_attr->cfg_attr_info.passive_scan_time;
 		} else {
 			PRINT_ER("Passive scan time(1~65535) over\n");
 			result = -EINVAL;
@@ -790,8 +802,8 @@ static s32 Handle_CfgParam(struct host_if_drv *hif_drv,
 		}
 		u8WidCnt++;
 	}
-	if (strHostIFCfgParamAttr->cfg_attr_info.flag & CURRENT_TX_RATE) {
-		enum CURRENT_TXRATE curr_tx_rate = strHostIFCfgParamAttr->cfg_attr_info.curr_tx_rate;
+	if (cfg_param_attr->cfg_attr_info.flag & CURRENT_TX_RATE) {
+		enum CURRENT_TXRATE curr_tx_rate = cfg_param_attr->cfg_attr_info.curr_tx_rate;
 
 		if (curr_tx_rate == AUTORATE || curr_tx_rate == MBPS_1
 		    || curr_tx_rate == MBPS_2 || curr_tx_rate == MBPS_5_5
-- 
1.9.1

