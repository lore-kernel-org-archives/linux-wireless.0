Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:4610 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756178AbbJ2C4k (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Oct 2015 22:56:40 -0400
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH V2 03/64] staging: wilc1000: rename strCfgValues of struct host_if_drv
Date: Thu, 29 Oct 2015 11:58:26 +0900
Message-ID: <1446087567-16728-3-git-send-email-glen.lee@atmel.com> (sfid-20151029_035643_835219_5194983B)
In-Reply-To: <1446087567-16728-1-git-send-email-glen.lee@atmel.com>
References: <1446087567-16728-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames strCfgValues of struct host_if_drv to cfg_values
to avoid CamelCase naming convention.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 91 ++++++++++++++++---------------
 drivers/staging/wilc1000/host_interface.h |  2 +-
 2 files changed, 47 insertions(+), 46 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 7216d83..135d4b3 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -535,7 +535,7 @@ static s32 Handle_CfgParam(struct host_if_drv *hif_drv,
 			strWIDList[u8WidCnt].val = (s8 *)&strHostIFCfgParamAttr->cfg_attr_info.bss_type;
 			strWIDList[u8WidCnt].type = WID_CHAR;
 			strWIDList[u8WidCnt].size = sizeof(char);
-			hif_drv->strCfgValues.bss_type = (u8)strHostIFCfgParamAttr->cfg_attr_info.bss_type;
+			hif_drv->cfg_values.bss_type = (u8)strHostIFCfgParamAttr->cfg_attr_info.bss_type;
 		} else {
 			PRINT_ER("check value 6 over\n");
 			result = -EINVAL;
@@ -549,7 +549,7 @@ static s32 Handle_CfgParam(struct host_if_drv *hif_drv,
 			strWIDList[u8WidCnt].val = (s8 *)&strHostIFCfgParamAttr->cfg_attr_info.auth_type;
 			strWIDList[u8WidCnt].type = WID_CHAR;
 			strWIDList[u8WidCnt].size = sizeof(char);
-			hif_drv->strCfgValues.auth_type = (u8)strHostIFCfgParamAttr->cfg_attr_info.auth_type;
+			hif_drv->cfg_values.auth_type = (u8)strHostIFCfgParamAttr->cfg_attr_info.auth_type;
 		} else {
 			PRINT_ER("Impossible value \n");
 			result = -EINVAL;
@@ -563,7 +563,7 @@ static s32 Handle_CfgParam(struct host_if_drv *hif_drv,
 			strWIDList[u8WidCnt].val = (s8 *)&strHostIFCfgParamAttr->cfg_attr_info.auth_timeout;
 			strWIDList[u8WidCnt].type = WID_SHORT;
 			strWIDList[u8WidCnt].size = sizeof(u16);
-			hif_drv->strCfgValues.auth_timeout = strHostIFCfgParamAttr->cfg_attr_info.auth_timeout;
+			hif_drv->cfg_values.auth_timeout = strHostIFCfgParamAttr->cfg_attr_info.auth_timeout;
 		} else {
 			PRINT_ER("Range(1 ~ 65535) over\n");
 			result = -EINVAL;
@@ -577,7 +577,7 @@ static s32 Handle_CfgParam(struct host_if_drv *hif_drv,
 			strWIDList[u8WidCnt].val = (s8 *)&strHostIFCfgParamAttr->cfg_attr_info.power_mgmt_mode;
 			strWIDList[u8WidCnt].type = WID_CHAR;
 			strWIDList[u8WidCnt].size = sizeof(char);
-			hif_drv->strCfgValues.power_mgmt_mode = (u8)strHostIFCfgParamAttr->cfg_attr_info.power_mgmt_mode;
+			hif_drv->cfg_values.power_mgmt_mode = (u8)strHostIFCfgParamAttr->cfg_attr_info.power_mgmt_mode;
 		} else {
 			PRINT_ER("Invalide power mode\n");
 			result = -EINVAL;
@@ -591,7 +591,7 @@ static s32 Handle_CfgParam(struct host_if_drv *hif_drv,
 			strWIDList[u8WidCnt].val = (s8 *)&strHostIFCfgParamAttr->cfg_attr_info.short_retry_limit;
 			strWIDList[u8WidCnt].type = WID_SHORT;
 			strWIDList[u8WidCnt].size = sizeof(u16);
-			hif_drv->strCfgValues.short_retry_limit = strHostIFCfgParamAttr->cfg_attr_info.short_retry_limit;
+			hif_drv->cfg_values.short_retry_limit = strHostIFCfgParamAttr->cfg_attr_info.short_retry_limit;
 		} else {
 			PRINT_ER("Range(1~256) over\n");
 			result = -EINVAL;
@@ -606,7 +606,7 @@ static s32 Handle_CfgParam(struct host_if_drv *hif_drv,
 
 			strWIDList[u8WidCnt].type = WID_SHORT;
 			strWIDList[u8WidCnt].size = sizeof(u16);
-			hif_drv->strCfgValues.long_retry_limit = strHostIFCfgParamAttr->cfg_attr_info.long_retry_limit;
+			hif_drv->cfg_values.long_retry_limit = strHostIFCfgParamAttr->cfg_attr_info.long_retry_limit;
 		} else {
 			PRINT_ER("Range(1~256) over\n");
 			result = -EINVAL;
@@ -620,7 +620,7 @@ static s32 Handle_CfgParam(struct host_if_drv *hif_drv,
 			strWIDList[u8WidCnt].val = (s8 *)&strHostIFCfgParamAttr->cfg_attr_info.frag_threshold;
 			strWIDList[u8WidCnt].type = WID_SHORT;
 			strWIDList[u8WidCnt].size = sizeof(u16);
-			hif_drv->strCfgValues.frag_threshold = strHostIFCfgParamAttr->cfg_attr_info.frag_threshold;
+			hif_drv->cfg_values.frag_threshold = strHostIFCfgParamAttr->cfg_attr_info.frag_threshold;
 		} else {
 			PRINT_ER("Threshold Range fail\n");
 			result = -EINVAL;
@@ -634,7 +634,7 @@ static s32 Handle_CfgParam(struct host_if_drv *hif_drv,
 			strWIDList[u8WidCnt].val = (s8 *)&strHostIFCfgParamAttr->cfg_attr_info.rts_threshold;
 			strWIDList[u8WidCnt].type = WID_SHORT;
 			strWIDList[u8WidCnt].size = sizeof(u16);
-			hif_drv->strCfgValues.rts_threshold = strHostIFCfgParamAttr->cfg_attr_info.rts_threshold;
+			hif_drv->cfg_values.rts_threshold = strHostIFCfgParamAttr->cfg_attr_info.rts_threshold;
 		} else {
 			PRINT_ER("Threshold Range fail\n");
 			result = -EINVAL;
@@ -648,7 +648,7 @@ static s32 Handle_CfgParam(struct host_if_drv *hif_drv,
 			strWIDList[u8WidCnt].val = (s8 *)&strHostIFCfgParamAttr->cfg_attr_info.preamble_type;
 			strWIDList[u8WidCnt].type = WID_CHAR;
 			strWIDList[u8WidCnt].size = sizeof(char);
-			hif_drv->strCfgValues.preamble_type = strHostIFCfgParamAttr->cfg_attr_info.preamble_type;
+			hif_drv->cfg_values.preamble_type = strHostIFCfgParamAttr->cfg_attr_info.preamble_type;
 		} else {
 			PRINT_ER("Preamle Range(0~2) over\n");
 			result = -EINVAL;
@@ -662,7 +662,7 @@ static s32 Handle_CfgParam(struct host_if_drv *hif_drv,
 			strWIDList[u8WidCnt].val = (s8 *)&strHostIFCfgParamAttr->cfg_attr_info.short_slot_allowed;
 			strWIDList[u8WidCnt].type = WID_CHAR;
 			strWIDList[u8WidCnt].size = sizeof(char);
-			hif_drv->strCfgValues.short_slot_allowed = (u8)strHostIFCfgParamAttr->cfg_attr_info.short_slot_allowed;
+			hif_drv->cfg_values.short_slot_allowed = (u8)strHostIFCfgParamAttr->cfg_attr_info.short_slot_allowed;
 		} else {
 			PRINT_ER("Short slot(2) over\n");
 			result = -EINVAL;
@@ -676,7 +676,7 @@ static s32 Handle_CfgParam(struct host_if_drv *hif_drv,
 			strWIDList[u8WidCnt].val = (s8 *)&strHostIFCfgParamAttr->cfg_attr_info.txop_prot_disabled;
 			strWIDList[u8WidCnt].type = WID_CHAR;
 			strWIDList[u8WidCnt].size = sizeof(char);
-			hif_drv->strCfgValues.txop_prot_disabled = (u8)strHostIFCfgParamAttr->cfg_attr_info.txop_prot_disabled;
+			hif_drv->cfg_values.txop_prot_disabled = (u8)strHostIFCfgParamAttr->cfg_attr_info.txop_prot_disabled;
 		} else {
 			PRINT_ER("TXOP prot disable\n");
 			result = -EINVAL;
@@ -690,7 +690,7 @@ static s32 Handle_CfgParam(struct host_if_drv *hif_drv,
 			strWIDList[u8WidCnt].val = (s8 *)&strHostIFCfgParamAttr->cfg_attr_info.beacon_interval;
 			strWIDList[u8WidCnt].type = WID_SHORT;
 			strWIDList[u8WidCnt].size = sizeof(u16);
-			hif_drv->strCfgValues.beacon_interval = strHostIFCfgParamAttr->cfg_attr_info.beacon_interval;
+			hif_drv->cfg_values.beacon_interval = strHostIFCfgParamAttr->cfg_attr_info.beacon_interval;
 		} else {
 			PRINT_ER("Beacon interval(1~65535) fail\n");
 			result = -EINVAL;
@@ -704,7 +704,7 @@ static s32 Handle_CfgParam(struct host_if_drv *hif_drv,
 			strWIDList[u8WidCnt].val = (s8 *)&strHostIFCfgParamAttr->cfg_attr_info.dtim_period;
 			strWIDList[u8WidCnt].type = WID_CHAR;
 			strWIDList[u8WidCnt].size = sizeof(char);
-			hif_drv->strCfgValues.dtim_period = strHostIFCfgParamAttr->cfg_attr_info.dtim_period;
+			hif_drv->cfg_values.dtim_period = strHostIFCfgParamAttr->cfg_attr_info.dtim_period;
 		} else {
 			PRINT_ER("DTIM range(1~255) fail\n");
 			result = -EINVAL;
@@ -718,7 +718,7 @@ static s32 Handle_CfgParam(struct host_if_drv *hif_drv,
 			strWIDList[u8WidCnt].val = (s8 *)&strHostIFCfgParamAttr->cfg_attr_info.site_survey_enabled;
 			strWIDList[u8WidCnt].type = WID_CHAR;
 			strWIDList[u8WidCnt].size = sizeof(char);
-			hif_drv->strCfgValues.site_survey_enabled = (u8)strHostIFCfgParamAttr->cfg_attr_info.site_survey_enabled;
+			hif_drv->cfg_values.site_survey_enabled = (u8)strHostIFCfgParamAttr->cfg_attr_info.site_survey_enabled;
 		} else {
 			PRINT_ER("Site survey disable\n");
 			result = -EINVAL;
@@ -732,7 +732,7 @@ static s32 Handle_CfgParam(struct host_if_drv *hif_drv,
 			strWIDList[u8WidCnt].val = (s8 *)&strHostIFCfgParamAttr->cfg_attr_info.site_survey_scan_time;
 			strWIDList[u8WidCnt].type = WID_SHORT;
 			strWIDList[u8WidCnt].size = sizeof(u16);
-			hif_drv->strCfgValues.site_survey_scan_time = strHostIFCfgParamAttr->cfg_attr_info.site_survey_scan_time;
+			hif_drv->cfg_values.site_survey_scan_time = strHostIFCfgParamAttr->cfg_attr_info.site_survey_scan_time;
 		} else {
 			PRINT_ER("Site survey scan time(1~65535) over\n");
 			result = -EINVAL;
@@ -746,7 +746,7 @@ static s32 Handle_CfgParam(struct host_if_drv *hif_drv,
 			strWIDList[u8WidCnt].val = (s8 *)&strHostIFCfgParamAttr->cfg_attr_info.active_scan_time;
 			strWIDList[u8WidCnt].type = WID_SHORT;
 			strWIDList[u8WidCnt].size = sizeof(u16);
-			hif_drv->strCfgValues.active_scan_time = strHostIFCfgParamAttr->cfg_attr_info.active_scan_time;
+			hif_drv->cfg_values.active_scan_time = strHostIFCfgParamAttr->cfg_attr_info.active_scan_time;
 		} else {
 			PRINT_ER("Active scan time(1~65535) over\n");
 			result = -EINVAL;
@@ -760,7 +760,7 @@ static s32 Handle_CfgParam(struct host_if_drv *hif_drv,
 			strWIDList[u8WidCnt].val = (s8 *)&strHostIFCfgParamAttr->cfg_attr_info.passive_scan_time;
 			strWIDList[u8WidCnt].type = WID_SHORT;
 			strWIDList[u8WidCnt].size = sizeof(u16);
-			hif_drv->strCfgValues.passive_scan_time = strHostIFCfgParamAttr->cfg_attr_info.passive_scan_time;
+			hif_drv->cfg_values.passive_scan_time = strHostIFCfgParamAttr->cfg_attr_info.passive_scan_time;
 		} else {
 			PRINT_ER("Passive scan time(1~65535) over\n");
 			result = -EINVAL;
@@ -781,7 +781,7 @@ static s32 Handle_CfgParam(struct host_if_drv *hif_drv,
 			strWIDList[u8WidCnt].val = (s8 *)&curr_tx_rate;
 			strWIDList[u8WidCnt].type = WID_SHORT;
 			strWIDList[u8WidCnt].size = sizeof(u16);
-			hif_drv->strCfgValues.curr_tx_rate = (u8)curr_tx_rate;
+			hif_drv->cfg_values.curr_tx_rate = (u8)curr_tx_rate;
 		} else {
 			PRINT_ER("out of TX rate\n");
 			result = -EINVAL;
@@ -3961,75 +3961,75 @@ s32 hif_get_cfg(struct host_if_drv *hif_drv, u16 u16WID, u16 *pu16WID_Value)
 	PRINT_D(HOSTINF_DBG, "Getting configuration parameters\n");
 	switch (u16WID)	{
 	case WID_BSS_TYPE:
-		*pu16WID_Value = (u16)hif_drv->strCfgValues.bss_type;
+		*pu16WID_Value = (u16)hif_drv->cfg_values.bss_type;
 		break;
 
 	case WID_AUTH_TYPE:
-		*pu16WID_Value = (u16)hif_drv->strCfgValues.auth_type;
+		*pu16WID_Value = (u16)hif_drv->cfg_values.auth_type;
 		break;
 
 	case WID_AUTH_TIMEOUT:
-		*pu16WID_Value = hif_drv->strCfgValues.auth_timeout;
+		*pu16WID_Value = hif_drv->cfg_values.auth_timeout;
 		break;
 
 	case WID_POWER_MANAGEMENT:
-		*pu16WID_Value = (u16)hif_drv->strCfgValues.power_mgmt_mode;
+		*pu16WID_Value = (u16)hif_drv->cfg_values.power_mgmt_mode;
 		break;
 
 	case WID_SHORT_RETRY_LIMIT:
-		*pu16WID_Value =       hif_drv->strCfgValues.short_retry_limit;
+		*pu16WID_Value = hif_drv->cfg_values.short_retry_limit;
 		break;
 
 	case WID_LONG_RETRY_LIMIT:
-		*pu16WID_Value = hif_drv->strCfgValues.long_retry_limit;
+		*pu16WID_Value = hif_drv->cfg_values.long_retry_limit;
 		break;
 
 	case WID_FRAG_THRESHOLD:
-		*pu16WID_Value = hif_drv->strCfgValues.frag_threshold;
+		*pu16WID_Value = hif_drv->cfg_values.frag_threshold;
 		break;
 
 	case WID_RTS_THRESHOLD:
-		*pu16WID_Value = hif_drv->strCfgValues.rts_threshold;
+		*pu16WID_Value = hif_drv->cfg_values.rts_threshold;
 		break;
 
 	case WID_PREAMBLE:
-		*pu16WID_Value = (u16)hif_drv->strCfgValues.preamble_type;
+		*pu16WID_Value = (u16)hif_drv->cfg_values.preamble_type;
 		break;
 
 	case WID_SHORT_SLOT_ALLOWED:
-		*pu16WID_Value = (u16) hif_drv->strCfgValues.short_slot_allowed;
+		*pu16WID_Value = (u16)hif_drv->cfg_values.short_slot_allowed;
 		break;
 
 	case WID_11N_TXOP_PROT_DISABLE:
-		*pu16WID_Value = (u16)hif_drv->strCfgValues.txop_prot_disabled;
+		*pu16WID_Value = (u16)hif_drv->cfg_values.txop_prot_disabled;
 		break;
 
 	case WID_BEACON_INTERVAL:
-		*pu16WID_Value = hif_drv->strCfgValues.beacon_interval;
+		*pu16WID_Value = hif_drv->cfg_values.beacon_interval;
 		break;
 
 	case WID_DTIM_PERIOD:
-		*pu16WID_Value = (u16)hif_drv->strCfgValues.dtim_period;
+		*pu16WID_Value = (u16)hif_drv->cfg_values.dtim_period;
 		break;
 
 	case WID_SITE_SURVEY:
-		*pu16WID_Value = (u16)hif_drv->strCfgValues.site_survey_enabled;
+		*pu16WID_Value = (u16)hif_drv->cfg_values.site_survey_enabled;
 		break;
 
 	case WID_SITE_SURVEY_SCAN_TIME:
-		*pu16WID_Value = hif_drv->strCfgValues.site_survey_scan_time;
+		*pu16WID_Value = hif_drv->cfg_values.site_survey_scan_time;
 		break;
 
 	case WID_ACTIVE_SCAN_TIME:
-		*pu16WID_Value = hif_drv->strCfgValues.active_scan_time;
+		*pu16WID_Value = hif_drv->cfg_values.active_scan_time;
 		break;
 
 	case WID_PASSIVE_SCAN_TIME:
-		*pu16WID_Value = hif_drv->strCfgValues.passive_scan_time;
+		*pu16WID_Value = hif_drv->cfg_values.passive_scan_time;
 		break;
 
 	case WID_CURRENT_TX_RATE:
-		*pu16WID_Value = hif_drv->strCfgValues.curr_tx_rate;
+		*pu16WID_Value = hif_drv->cfg_values.curr_tx_rate;
 		break;
 
 	default:
@@ -4147,19 +4147,20 @@ s32 host_int_init(struct net_device *dev, struct host_if_drv **hif_drv_handler)
 	down(&hif_drv->gtOsCfgValuesSem);
 
 	hif_drv->hif_state = HOST_IF_IDLE;
-	hif_drv->strCfgValues.site_survey_enabled = SITE_SURVEY_OFF;
-	hif_drv->strCfgValues.scan_source = DEFAULT_SCAN;
-	hif_drv->strCfgValues.active_scan_time = ACTIVE_SCAN_TIME;
-	hif_drv->strCfgValues.passive_scan_time = PASSIVE_SCAN_TIME;
-	hif_drv->strCfgValues.curr_tx_rate = AUTORATE;
+	hif_drv->cfg_values.site_survey_enabled = SITE_SURVEY_OFF;
+	hif_drv->cfg_values.scan_source = DEFAULT_SCAN;
+	hif_drv->cfg_values.active_scan_time = ACTIVE_SCAN_TIME;
+	hif_drv->cfg_values.passive_scan_time = PASSIVE_SCAN_TIME;
+	hif_drv->cfg_values.curr_tx_rate = AUTORATE;
 
 	hif_drv->u64P2p_MgmtTimeout = 0;
 
 	PRINT_INFO(HOSTINF_DBG, "Initialization values, Site survey value: %d\n Scan source: %d\n Active scan time: %d\n Passive scan time: %d\nCurrent tx Rate = %d\n",
-
-		   hif_drv->strCfgValues.site_survey_enabled, hif_drv->strCfgValues.scan_source,
-		   hif_drv->strCfgValues.active_scan_time, hif_drv->strCfgValues.passive_scan_time,
-		   hif_drv->strCfgValues.curr_tx_rate);
+		   hif_drv->cfg_values.site_survey_enabled,
+		   hif_drv->cfg_values.scan_source,
+		   hif_drv->cfg_values.active_scan_time,
+		   hif_drv->cfg_values.passive_scan_time,
+		   hif_drv->cfg_values.curr_tx_rate);
 
 	up(&hif_drv->gtOsCfgValuesSem);
 
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index fcfdd21..90e2946 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -302,7 +302,7 @@ struct host_if_drv {
 	enum host_if_state hif_state;
 
 	u8 assoc_bssid[ETH_ALEN];
-	struct cfg_param_val strCfgValues;
+	struct cfg_param_val cfg_values;
 /* semaphores */
 	struct semaphore gtOsCfgValuesSem;
 	struct semaphore hSemTestKeyBlock;
-- 
1.9.1

