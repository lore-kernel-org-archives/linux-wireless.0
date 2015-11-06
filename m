Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:37957 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031709AbbKFCTN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Nov 2015 21:19:13 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 72/73] staging: wilc1000: rename strWIDList of handle_cfg_param function
Date: Fri, 6 Nov 2015 11:20:11 +0900
Message-ID: <1446776412-30670-23-git-send-email-glen.lee@atmel.com> (sfid-20151106_031925_007942_D2E95A6C)
In-Reply-To: <1446776412-30670-1-git-send-email-glen.lee@atmel.com>
References: <1446776412-30670-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames strWIDList variable of handle_cfg_param function to wid_list
to avoid camelcase.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 149 +++++++++++++++---------------
 1 file changed, 74 insertions(+), 75 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 4c91ae2..588a027 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -521,7 +521,7 @@ static s32 handle_cfg_param(struct host_if_drv *hif_drv,
 			    struct cfg_param_attr *cfg_param_attr)
 {
 	s32 result = 0;
-	struct wid strWIDList[32];
+	struct wid wid_list[32];
 	u8 u8WidCnt = 0;
 
 	down(&hif_drv->sem_cfg_values);
@@ -530,10 +530,10 @@ static s32 handle_cfg_param(struct host_if_drv *hif_drv,
 
 	if (cfg_param_attr->cfg_attr_info.flag & BSS_TYPE) {
 		if (cfg_param_attr->cfg_attr_info.bss_type < 6) {
-			strWIDList[u8WidCnt].id = WID_BSS_TYPE;
-			strWIDList[u8WidCnt].val = (s8 *)&cfg_param_attr->cfg_attr_info.bss_type;
-			strWIDList[u8WidCnt].type = WID_CHAR;
-			strWIDList[u8WidCnt].size = sizeof(char);
+			wid_list[u8WidCnt].id = WID_BSS_TYPE;
+			wid_list[u8WidCnt].val = (s8 *)&cfg_param_attr->cfg_attr_info.bss_type;
+			wid_list[u8WidCnt].type = WID_CHAR;
+			wid_list[u8WidCnt].size = sizeof(char);
 			hif_drv->cfg_values.bss_type = (u8)cfg_param_attr->cfg_attr_info.bss_type;
 		} else {
 			PRINT_ER("check value 6 over\n");
@@ -546,10 +546,10 @@ static s32 handle_cfg_param(struct host_if_drv *hif_drv,
 		if (cfg_param_attr->cfg_attr_info.auth_type == 1 ||
 		    cfg_param_attr->cfg_attr_info.auth_type == 2 ||
 		    cfg_param_attr->cfg_attr_info.auth_type == 5) {
-			strWIDList[u8WidCnt].id = WID_AUTH_TYPE;
-			strWIDList[u8WidCnt].val = (s8 *)&cfg_param_attr->cfg_attr_info.auth_type;
-			strWIDList[u8WidCnt].type = WID_CHAR;
-			strWIDList[u8WidCnt].size = sizeof(char);
+			wid_list[u8WidCnt].id = WID_AUTH_TYPE;
+			wid_list[u8WidCnt].val = (s8 *)&cfg_param_attr->cfg_attr_info.auth_type;
+			wid_list[u8WidCnt].type = WID_CHAR;
+			wid_list[u8WidCnt].size = sizeof(char);
 			hif_drv->cfg_values.auth_type = (u8)cfg_param_attr->cfg_attr_info.auth_type;
 		} else {
 			PRINT_ER("Impossible value \n");
@@ -561,10 +561,10 @@ static s32 handle_cfg_param(struct host_if_drv *hif_drv,
 	if (cfg_param_attr->cfg_attr_info.flag & AUTHEN_TIMEOUT) {
 		if (cfg_param_attr->cfg_attr_info.auth_timeout > 0 &&
 		    cfg_param_attr->cfg_attr_info.auth_timeout < 65536) {
-			strWIDList[u8WidCnt].id = WID_AUTH_TIMEOUT;
-			strWIDList[u8WidCnt].val = (s8 *)&cfg_param_attr->cfg_attr_info.auth_timeout;
-			strWIDList[u8WidCnt].type = WID_SHORT;
-			strWIDList[u8WidCnt].size = sizeof(u16);
+			wid_list[u8WidCnt].id = WID_AUTH_TIMEOUT;
+			wid_list[u8WidCnt].val = (s8 *)&cfg_param_attr->cfg_attr_info.auth_timeout;
+			wid_list[u8WidCnt].type = WID_SHORT;
+			wid_list[u8WidCnt].size = sizeof(u16);
 			hif_drv->cfg_values.auth_timeout = cfg_param_attr->cfg_attr_info.auth_timeout;
 		} else {
 			PRINT_ER("Range(1 ~ 65535) over\n");
@@ -575,10 +575,10 @@ static s32 handle_cfg_param(struct host_if_drv *hif_drv,
 	}
 	if (cfg_param_attr->cfg_attr_info.flag & POWER_MANAGEMENT) {
 		if (cfg_param_attr->cfg_attr_info.power_mgmt_mode < 5) {
-			strWIDList[u8WidCnt].id = WID_POWER_MANAGEMENT;
-			strWIDList[u8WidCnt].val = (s8 *)&cfg_param_attr->cfg_attr_info.power_mgmt_mode;
-			strWIDList[u8WidCnt].type = WID_CHAR;
-			strWIDList[u8WidCnt].size = sizeof(char);
+			wid_list[u8WidCnt].id = WID_POWER_MANAGEMENT;
+			wid_list[u8WidCnt].val = (s8 *)&cfg_param_attr->cfg_attr_info.power_mgmt_mode;
+			wid_list[u8WidCnt].type = WID_CHAR;
+			wid_list[u8WidCnt].size = sizeof(char);
 			hif_drv->cfg_values.power_mgmt_mode = (u8)cfg_param_attr->cfg_attr_info.power_mgmt_mode;
 		} else {
 			PRINT_ER("Invalide power mode\n");
@@ -590,10 +590,10 @@ static s32 handle_cfg_param(struct host_if_drv *hif_drv,
 	if (cfg_param_attr->cfg_attr_info.flag & RETRY_SHORT) {
 		if (cfg_param_attr->cfg_attr_info.short_retry_limit > 0 &&
 		    cfg_param_attr->cfg_attr_info.short_retry_limit < 256) {
-			strWIDList[u8WidCnt].id = WID_SHORT_RETRY_LIMIT;
-			strWIDList[u8WidCnt].val = (s8 *)&cfg_param_attr->cfg_attr_info.short_retry_limit;
-			strWIDList[u8WidCnt].type = WID_SHORT;
-			strWIDList[u8WidCnt].size = sizeof(u16);
+			wid_list[u8WidCnt].id = WID_SHORT_RETRY_LIMIT;
+			wid_list[u8WidCnt].val = (s8 *)&cfg_param_attr->cfg_attr_info.short_retry_limit;
+			wid_list[u8WidCnt].type = WID_SHORT;
+			wid_list[u8WidCnt].size = sizeof(u16);
 			hif_drv->cfg_values.short_retry_limit = cfg_param_attr->cfg_attr_info.short_retry_limit;
 		} else {
 			PRINT_ER("Range(1~256) over\n");
@@ -605,11 +605,10 @@ static s32 handle_cfg_param(struct host_if_drv *hif_drv,
 	if (cfg_param_attr->cfg_attr_info.flag & RETRY_LONG) {
 		if (cfg_param_attr->cfg_attr_info.long_retry_limit > 0 &&
 		    cfg_param_attr->cfg_attr_info.long_retry_limit < 256) {
-			strWIDList[u8WidCnt].id = WID_LONG_RETRY_LIMIT;
-			strWIDList[u8WidCnt].val = (s8 *)&cfg_param_attr->cfg_attr_info.long_retry_limit;
-
-			strWIDList[u8WidCnt].type = WID_SHORT;
-			strWIDList[u8WidCnt].size = sizeof(u16);
+			wid_list[u8WidCnt].id = WID_LONG_RETRY_LIMIT;
+			wid_list[u8WidCnt].val = (s8 *)&cfg_param_attr->cfg_attr_info.long_retry_limit;
+			wid_list[u8WidCnt].type = WID_SHORT;
+			wid_list[u8WidCnt].size = sizeof(u16);
 			hif_drv->cfg_values.long_retry_limit = cfg_param_attr->cfg_attr_info.long_retry_limit;
 		} else {
 			PRINT_ER("Range(1~256) over\n");
@@ -621,10 +620,10 @@ static s32 handle_cfg_param(struct host_if_drv *hif_drv,
 	if (cfg_param_attr->cfg_attr_info.flag & FRAG_THRESHOLD) {
 		if (cfg_param_attr->cfg_attr_info.frag_threshold > 255 &&
 		    cfg_param_attr->cfg_attr_info.frag_threshold < 7937) {
-			strWIDList[u8WidCnt].id = WID_FRAG_THRESHOLD;
-			strWIDList[u8WidCnt].val = (s8 *)&cfg_param_attr->cfg_attr_info.frag_threshold;
-			strWIDList[u8WidCnt].type = WID_SHORT;
-			strWIDList[u8WidCnt].size = sizeof(u16);
+			wid_list[u8WidCnt].id = WID_FRAG_THRESHOLD;
+			wid_list[u8WidCnt].val = (s8 *)&cfg_param_attr->cfg_attr_info.frag_threshold;
+			wid_list[u8WidCnt].type = WID_SHORT;
+			wid_list[u8WidCnt].size = sizeof(u16);
 			hif_drv->cfg_values.frag_threshold = cfg_param_attr->cfg_attr_info.frag_threshold;
 		} else {
 			PRINT_ER("Threshold Range fail\n");
@@ -636,10 +635,10 @@ static s32 handle_cfg_param(struct host_if_drv *hif_drv,
 	if (cfg_param_attr->cfg_attr_info.flag & RTS_THRESHOLD) {
 		if (cfg_param_attr->cfg_attr_info.rts_threshold > 255 &&
 		    cfg_param_attr->cfg_attr_info.rts_threshold < 65536) {
-			strWIDList[u8WidCnt].id = WID_RTS_THRESHOLD;
-			strWIDList[u8WidCnt].val = (s8 *)&cfg_param_attr->cfg_attr_info.rts_threshold;
-			strWIDList[u8WidCnt].type = WID_SHORT;
-			strWIDList[u8WidCnt].size = sizeof(u16);
+			wid_list[u8WidCnt].id = WID_RTS_THRESHOLD;
+			wid_list[u8WidCnt].val = (s8 *)&cfg_param_attr->cfg_attr_info.rts_threshold;
+			wid_list[u8WidCnt].type = WID_SHORT;
+			wid_list[u8WidCnt].size = sizeof(u16);
 			hif_drv->cfg_values.rts_threshold = cfg_param_attr->cfg_attr_info.rts_threshold;
 		} else {
 			PRINT_ER("Threshold Range fail\n");
@@ -650,10 +649,10 @@ static s32 handle_cfg_param(struct host_if_drv *hif_drv,
 	}
 	if (cfg_param_attr->cfg_attr_info.flag & PREAMBLE) {
 		if (cfg_param_attr->cfg_attr_info.preamble_type < 3) {
-			strWIDList[u8WidCnt].id = WID_PREAMBLE;
-			strWIDList[u8WidCnt].val = (s8 *)&cfg_param_attr->cfg_attr_info.preamble_type;
-			strWIDList[u8WidCnt].type = WID_CHAR;
-			strWIDList[u8WidCnt].size = sizeof(char);
+			wid_list[u8WidCnt].id = WID_PREAMBLE;
+			wid_list[u8WidCnt].val = (s8 *)&cfg_param_attr->cfg_attr_info.preamble_type;
+			wid_list[u8WidCnt].type = WID_CHAR;
+			wid_list[u8WidCnt].size = sizeof(char);
 			hif_drv->cfg_values.preamble_type = cfg_param_attr->cfg_attr_info.preamble_type;
 		} else {
 			PRINT_ER("Preamle Range(0~2) over\n");
@@ -664,10 +663,10 @@ static s32 handle_cfg_param(struct host_if_drv *hif_drv,
 	}
 	if (cfg_param_attr->cfg_attr_info.flag & SHORT_SLOT_ALLOWED) {
 		if (cfg_param_attr->cfg_attr_info.short_slot_allowed < 2) {
-			strWIDList[u8WidCnt].id = WID_SHORT_SLOT_ALLOWED;
-			strWIDList[u8WidCnt].val = (s8 *)&cfg_param_attr->cfg_attr_info.short_slot_allowed;
-			strWIDList[u8WidCnt].type = WID_CHAR;
-			strWIDList[u8WidCnt].size = sizeof(char);
+			wid_list[u8WidCnt].id = WID_SHORT_SLOT_ALLOWED;
+			wid_list[u8WidCnt].val = (s8 *)&cfg_param_attr->cfg_attr_info.short_slot_allowed;
+			wid_list[u8WidCnt].type = WID_CHAR;
+			wid_list[u8WidCnt].size = sizeof(char);
 			hif_drv->cfg_values.short_slot_allowed = (u8)cfg_param_attr->cfg_attr_info.short_slot_allowed;
 		} else {
 			PRINT_ER("Short slot(2) over\n");
@@ -678,10 +677,10 @@ static s32 handle_cfg_param(struct host_if_drv *hif_drv,
 	}
 	if (cfg_param_attr->cfg_attr_info.flag & TXOP_PROT_DISABLE) {
 		if (cfg_param_attr->cfg_attr_info.txop_prot_disabled < 2) {
-			strWIDList[u8WidCnt].id = WID_11N_TXOP_PROT_DISABLE;
-			strWIDList[u8WidCnt].val = (s8 *)&cfg_param_attr->cfg_attr_info.txop_prot_disabled;
-			strWIDList[u8WidCnt].type = WID_CHAR;
-			strWIDList[u8WidCnt].size = sizeof(char);
+			wid_list[u8WidCnt].id = WID_11N_TXOP_PROT_DISABLE;
+			wid_list[u8WidCnt].val = (s8 *)&cfg_param_attr->cfg_attr_info.txop_prot_disabled;
+			wid_list[u8WidCnt].type = WID_CHAR;
+			wid_list[u8WidCnt].size = sizeof(char);
 			hif_drv->cfg_values.txop_prot_disabled = (u8)cfg_param_attr->cfg_attr_info.txop_prot_disabled;
 		} else {
 			PRINT_ER("TXOP prot disable\n");
@@ -693,10 +692,10 @@ static s32 handle_cfg_param(struct host_if_drv *hif_drv,
 	if (cfg_param_attr->cfg_attr_info.flag & BEACON_INTERVAL) {
 		if (cfg_param_attr->cfg_attr_info.beacon_interval > 0 &&
 		    cfg_param_attr->cfg_attr_info.beacon_interval < 65536) {
-			strWIDList[u8WidCnt].id = WID_BEACON_INTERVAL;
-			strWIDList[u8WidCnt].val = (s8 *)&cfg_param_attr->cfg_attr_info.beacon_interval;
-			strWIDList[u8WidCnt].type = WID_SHORT;
-			strWIDList[u8WidCnt].size = sizeof(u16);
+			wid_list[u8WidCnt].id = WID_BEACON_INTERVAL;
+			wid_list[u8WidCnt].val = (s8 *)&cfg_param_attr->cfg_attr_info.beacon_interval;
+			wid_list[u8WidCnt].type = WID_SHORT;
+			wid_list[u8WidCnt].size = sizeof(u16);
 			hif_drv->cfg_values.beacon_interval = cfg_param_attr->cfg_attr_info.beacon_interval;
 		} else {
 			PRINT_ER("Beacon interval(1~65535) fail\n");
@@ -708,10 +707,10 @@ static s32 handle_cfg_param(struct host_if_drv *hif_drv,
 	if (cfg_param_attr->cfg_attr_info.flag & DTIM_PERIOD) {
 		if (cfg_param_attr->cfg_attr_info.dtim_period > 0 &&
 		    cfg_param_attr->cfg_attr_info.dtim_period < 256) {
-			strWIDList[u8WidCnt].id = WID_DTIM_PERIOD;
-			strWIDList[u8WidCnt].val = (s8 *)&cfg_param_attr->cfg_attr_info.dtim_period;
-			strWIDList[u8WidCnt].type = WID_CHAR;
-			strWIDList[u8WidCnt].size = sizeof(char);
+			wid_list[u8WidCnt].id = WID_DTIM_PERIOD;
+			wid_list[u8WidCnt].val = (s8 *)&cfg_param_attr->cfg_attr_info.dtim_period;
+			wid_list[u8WidCnt].type = WID_CHAR;
+			wid_list[u8WidCnt].size = sizeof(char);
 			hif_drv->cfg_values.dtim_period = cfg_param_attr->cfg_attr_info.dtim_period;
 		} else {
 			PRINT_ER("DTIM range(1~255) fail\n");
@@ -722,10 +721,10 @@ static s32 handle_cfg_param(struct host_if_drv *hif_drv,
 	}
 	if (cfg_param_attr->cfg_attr_info.flag & SITE_SURVEY) {
 		if (cfg_param_attr->cfg_attr_info.site_survey_enabled < 3) {
-			strWIDList[u8WidCnt].id = WID_SITE_SURVEY;
-			strWIDList[u8WidCnt].val = (s8 *)&cfg_param_attr->cfg_attr_info.site_survey_enabled;
-			strWIDList[u8WidCnt].type = WID_CHAR;
-			strWIDList[u8WidCnt].size = sizeof(char);
+			wid_list[u8WidCnt].id = WID_SITE_SURVEY;
+			wid_list[u8WidCnt].val = (s8 *)&cfg_param_attr->cfg_attr_info.site_survey_enabled;
+			wid_list[u8WidCnt].type = WID_CHAR;
+			wid_list[u8WidCnt].size = sizeof(char);
 			hif_drv->cfg_values.site_survey_enabled = (u8)cfg_param_attr->cfg_attr_info.site_survey_enabled;
 		} else {
 			PRINT_ER("Site survey disable\n");
@@ -737,10 +736,10 @@ static s32 handle_cfg_param(struct host_if_drv *hif_drv,
 	if (cfg_param_attr->cfg_attr_info.flag & SITE_SURVEY_SCAN_TIME) {
 		if (cfg_param_attr->cfg_attr_info.site_survey_scan_time > 0 &&
 		    cfg_param_attr->cfg_attr_info.site_survey_scan_time < 65536) {
-			strWIDList[u8WidCnt].id = WID_SITE_SURVEY_SCAN_TIME;
-			strWIDList[u8WidCnt].val = (s8 *)&cfg_param_attr->cfg_attr_info.site_survey_scan_time;
-			strWIDList[u8WidCnt].type = WID_SHORT;
-			strWIDList[u8WidCnt].size = sizeof(u16);
+			wid_list[u8WidCnt].id = WID_SITE_SURVEY_SCAN_TIME;
+			wid_list[u8WidCnt].val = (s8 *)&cfg_param_attr->cfg_attr_info.site_survey_scan_time;
+			wid_list[u8WidCnt].type = WID_SHORT;
+			wid_list[u8WidCnt].size = sizeof(u16);
 			hif_drv->cfg_values.site_survey_scan_time = cfg_param_attr->cfg_attr_info.site_survey_scan_time;
 		} else {
 			PRINT_ER("Site survey scan time(1~65535) over\n");
@@ -752,10 +751,10 @@ static s32 handle_cfg_param(struct host_if_drv *hif_drv,
 	if (cfg_param_attr->cfg_attr_info.flag & ACTIVE_SCANTIME) {
 		if (cfg_param_attr->cfg_attr_info.active_scan_time > 0 &&
 		    cfg_param_attr->cfg_attr_info.active_scan_time < 65536) {
-			strWIDList[u8WidCnt].id = WID_ACTIVE_SCAN_TIME;
-			strWIDList[u8WidCnt].val = (s8 *)&cfg_param_attr->cfg_attr_info.active_scan_time;
-			strWIDList[u8WidCnt].type = WID_SHORT;
-			strWIDList[u8WidCnt].size = sizeof(u16);
+			wid_list[u8WidCnt].id = WID_ACTIVE_SCAN_TIME;
+			wid_list[u8WidCnt].val = (s8 *)&cfg_param_attr->cfg_attr_info.active_scan_time;
+			wid_list[u8WidCnt].type = WID_SHORT;
+			wid_list[u8WidCnt].size = sizeof(u16);
 			hif_drv->cfg_values.active_scan_time = cfg_param_attr->cfg_attr_info.active_scan_time;
 		} else {
 			PRINT_ER("Active scan time(1~65535) over\n");
@@ -767,10 +766,10 @@ static s32 handle_cfg_param(struct host_if_drv *hif_drv,
 	if (cfg_param_attr->cfg_attr_info.flag & PASSIVE_SCANTIME) {
 		if (cfg_param_attr->cfg_attr_info.passive_scan_time > 0 &&
 		    cfg_param_attr->cfg_attr_info.passive_scan_time < 65536) {
-			strWIDList[u8WidCnt].id = WID_PASSIVE_SCAN_TIME;
-			strWIDList[u8WidCnt].val = (s8 *)&cfg_param_attr->cfg_attr_info.passive_scan_time;
-			strWIDList[u8WidCnt].type = WID_SHORT;
-			strWIDList[u8WidCnt].size = sizeof(u16);
+			wid_list[u8WidCnt].id = WID_PASSIVE_SCAN_TIME;
+			wid_list[u8WidCnt].val = (s8 *)&cfg_param_attr->cfg_attr_info.passive_scan_time;
+			wid_list[u8WidCnt].type = WID_SHORT;
+			wid_list[u8WidCnt].size = sizeof(u16);
 			hif_drv->cfg_values.passive_scan_time = cfg_param_attr->cfg_attr_info.passive_scan_time;
 		} else {
 			PRINT_ER("Passive scan time(1~65535) over\n");
@@ -788,10 +787,10 @@ static s32 handle_cfg_param(struct host_if_drv *hif_drv,
 		    || curr_tx_rate == MBPS_9 || curr_tx_rate == MBPS_12
 		    || curr_tx_rate == MBPS_18 || curr_tx_rate == MBPS_24
 		    || curr_tx_rate == MBPS_36 || curr_tx_rate == MBPS_48 || curr_tx_rate == MBPS_54) {
-			strWIDList[u8WidCnt].id = WID_CURRENT_TX_RATE;
-			strWIDList[u8WidCnt].val = (s8 *)&curr_tx_rate;
-			strWIDList[u8WidCnt].type = WID_SHORT;
-			strWIDList[u8WidCnt].size = sizeof(u16);
+			wid_list[u8WidCnt].id = WID_CURRENT_TX_RATE;
+			wid_list[u8WidCnt].val = (s8 *)&curr_tx_rate;
+			wid_list[u8WidCnt].type = WID_SHORT;
+			wid_list[u8WidCnt].size = sizeof(u16);
 			hif_drv->cfg_values.curr_tx_rate = (u8)curr_tx_rate;
 		} else {
 			PRINT_ER("out of TX rate\n");
@@ -801,7 +800,7 @@ static s32 handle_cfg_param(struct host_if_drv *hif_drv,
 		u8WidCnt++;
 	}
 
-	result = send_config_pkt(SET_CFG, strWIDList, u8WidCnt,
+	result = send_config_pkt(SET_CFG, wid_list, u8WidCnt,
 				 get_id_from_handler(hif_drv));
 
 	if (result)
-- 
1.9.1

