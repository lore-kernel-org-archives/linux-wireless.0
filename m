Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:13404 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751668AbbJLIAF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Oct 2015 04:00:05 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH V2 32/41] staging: wilc1000: rename pstrCfgParamVal in struct cfg_param_attr
Date: Mon, 12 Oct 2015 16:56:06 +0900
Message-ID: <1444636575-2486-32-git-send-email-tony.cho@atmel.com> (sfid-20151012_101655_581435_448814ED)
In-Reply-To: <1444636575-2486-1-git-send-email-tony.cho@atmel.com>
References: <1444636575-2486-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch renames a variable of struct cfg_param_val in struct
cfg_param_attr, pstrCfgParamVal to cfg_attr_info to avoid CamelCase
naming convention.

Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 144 +++++++++++++++---------------
 1 file changed, 72 insertions(+), 72 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 9309678..4bf10eb 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -73,7 +73,7 @@ extern u8 g_wilc_initialized;
  *  @version		1.0
  */
 struct cfg_param_attr {
-	struct cfg_param_val pstrCfgParamVal;
+	struct cfg_param_val cfg_attr_info;
 };
 
 /*!
@@ -847,19 +847,19 @@ static s32 Handle_CfgParam(struct host_if_drv *hif_drv,
 
 	PRINT_D(HOSTINF_DBG, "Setting CFG params\n");
 
-	if (strHostIFCfgParamAttr->pstrCfgParamVal.u32SetCfgFlag & BSS_TYPE) {
+	if (strHostIFCfgParamAttr->cfg_attr_info.u32SetCfgFlag & BSS_TYPE) {
 		/*----------------------------------------------------------*/
 		/*Input Value:	INFRASTRUCTURE = 1,							*/
 		/*				INDEPENDENT= 2,								*/
 		/*				ANY_BSS= 3									*/
 		/*----------------------------------------------------------*/
 		/* validate input then copy>> need to check value 4 and 5 */
-		if (strHostIFCfgParamAttr->pstrCfgParamVal.bss_type < 6) {
+		if (strHostIFCfgParamAttr->cfg_attr_info.bss_type < 6) {
 			strWIDList[u8WidCnt].id = WID_BSS_TYPE;
-			strWIDList[u8WidCnt].val = (s8 *)&strHostIFCfgParamAttr->pstrCfgParamVal.bss_type;
+			strWIDList[u8WidCnt].val = (s8 *)&strHostIFCfgParamAttr->cfg_attr_info.bss_type;
 			strWIDList[u8WidCnt].type = WID_CHAR;
 			strWIDList[u8WidCnt].size = sizeof(char);
-			hif_drv->strCfgValues.bss_type = (u8)strHostIFCfgParamAttr->pstrCfgParamVal.bss_type;
+			hif_drv->strCfgValues.bss_type = (u8)strHostIFCfgParamAttr->cfg_attr_info.bss_type;
 		} else {
 			PRINT_ER("check value 6 over\n");
 			s32Error = -EINVAL;
@@ -867,19 +867,19 @@ static s32 Handle_CfgParam(struct host_if_drv *hif_drv,
 		}
 		u8WidCnt++;
 	}
-	if (strHostIFCfgParamAttr->pstrCfgParamVal.u32SetCfgFlag & AUTH_TYPE) {
+	if (strHostIFCfgParamAttr->cfg_attr_info.u32SetCfgFlag & AUTH_TYPE) {
 		/*------------------------------------------------------*/
 		/*Input Values: OPEN_SYSTEM     = 0,					*/
 		/*				SHARED_KEY      = 1,					*/
 		/*				ANY             = 2						*/
 		/*------------------------------------------------------*/
 		/*validate Possible values*/
-		if ((strHostIFCfgParamAttr->pstrCfgParamVal.auth_type) == 1 || (strHostIFCfgParamAttr->pstrCfgParamVal.auth_type) == 2 || (strHostIFCfgParamAttr->pstrCfgParamVal.auth_type) == 5) {
+		if ((strHostIFCfgParamAttr->cfg_attr_info.auth_type) == 1 || (strHostIFCfgParamAttr->cfg_attr_info.auth_type) == 2 || (strHostIFCfgParamAttr->cfg_attr_info.auth_type) == 5) {
 			strWIDList[u8WidCnt].id = WID_AUTH_TYPE;
-			strWIDList[u8WidCnt].val = (s8 *)&strHostIFCfgParamAttr->pstrCfgParamVal.auth_type;
+			strWIDList[u8WidCnt].val = (s8 *)&strHostIFCfgParamAttr->cfg_attr_info.auth_type;
 			strWIDList[u8WidCnt].type = WID_CHAR;
 			strWIDList[u8WidCnt].size = sizeof(char);
-			hif_drv->strCfgValues.auth_type = (u8)strHostIFCfgParamAttr->pstrCfgParamVal.auth_type;
+			hif_drv->strCfgValues.auth_type = (u8)strHostIFCfgParamAttr->cfg_attr_info.auth_type;
 		} else {
 			PRINT_ER("Impossible value \n");
 			s32Error = -EINVAL;
@@ -887,14 +887,14 @@ static s32 Handle_CfgParam(struct host_if_drv *hif_drv,
 		}
 		u8WidCnt++;
 	}
-	if (strHostIFCfgParamAttr->pstrCfgParamVal.u32SetCfgFlag & AUTHEN_TIMEOUT) {
+	if (strHostIFCfgParamAttr->cfg_attr_info.u32SetCfgFlag & AUTHEN_TIMEOUT) {
 		/* range is 1 to 65535. */
-		if (strHostIFCfgParamAttr->pstrCfgParamVal.auth_timeout > 0 && strHostIFCfgParamAttr->pstrCfgParamVal.auth_timeout < 65536) {
+		if (strHostIFCfgParamAttr->cfg_attr_info.auth_timeout > 0 && strHostIFCfgParamAttr->cfg_attr_info.auth_timeout < 65536) {
 			strWIDList[u8WidCnt].id = WID_AUTH_TIMEOUT;
-			strWIDList[u8WidCnt].val = (s8 *)&strHostIFCfgParamAttr->pstrCfgParamVal.auth_timeout;
+			strWIDList[u8WidCnt].val = (s8 *)&strHostIFCfgParamAttr->cfg_attr_info.auth_timeout;
 			strWIDList[u8WidCnt].type = WID_SHORT;
 			strWIDList[u8WidCnt].size = sizeof(u16);
-			hif_drv->strCfgValues.auth_timeout = strHostIFCfgParamAttr->pstrCfgParamVal.auth_timeout;
+			hif_drv->strCfgValues.auth_timeout = strHostIFCfgParamAttr->cfg_attr_info.auth_timeout;
 		} else {
 			PRINT_ER("Range(1 ~ 65535) over\n");
 			s32Error = -EINVAL;
@@ -902,7 +902,7 @@ static s32 Handle_CfgParam(struct host_if_drv *hif_drv,
 		}
 		u8WidCnt++;
 	}
-	if (strHostIFCfgParamAttr->pstrCfgParamVal.u32SetCfgFlag & POWER_MANAGEMENT) {
+	if (strHostIFCfgParamAttr->cfg_attr_info.u32SetCfgFlag & POWER_MANAGEMENT) {
 		/*-----------------------------------------------------------*/
 		/*Input Values:	NO_POWERSAVE     = 0,						*/
 		/*				MIN_FAST_PS      = 1,						*/
@@ -910,12 +910,12 @@ static s32 Handle_CfgParam(struct host_if_drv *hif_drv,
 		/*				MIN_PSPOLL_PS    = 3,						*/
 		/*				MAX_PSPOLL_PS    = 4						*/
 		/*----------------------------------------------------------*/
-		if (strHostIFCfgParamAttr->pstrCfgParamVal.power_mgmt_mode < 5) {
+		if (strHostIFCfgParamAttr->cfg_attr_info.power_mgmt_mode < 5) {
 			strWIDList[u8WidCnt].id = WID_POWER_MANAGEMENT;
-			strWIDList[u8WidCnt].val = (s8 *)&strHostIFCfgParamAttr->pstrCfgParamVal.power_mgmt_mode;
+			strWIDList[u8WidCnt].val = (s8 *)&strHostIFCfgParamAttr->cfg_attr_info.power_mgmt_mode;
 			strWIDList[u8WidCnt].type = WID_CHAR;
 			strWIDList[u8WidCnt].size = sizeof(char);
-			hif_drv->strCfgValues.power_mgmt_mode = (u8)strHostIFCfgParamAttr->pstrCfgParamVal.power_mgmt_mode;
+			hif_drv->strCfgValues.power_mgmt_mode = (u8)strHostIFCfgParamAttr->cfg_attr_info.power_mgmt_mode;
 		} else {
 			PRINT_ER("Invalide power mode\n");
 			s32Error = -EINVAL;
@@ -923,14 +923,14 @@ static s32 Handle_CfgParam(struct host_if_drv *hif_drv,
 		}
 		u8WidCnt++;
 	}
-	if (strHostIFCfgParamAttr->pstrCfgParamVal.u32SetCfgFlag & RETRY_SHORT) {
+	if (strHostIFCfgParamAttr->cfg_attr_info.u32SetCfgFlag & RETRY_SHORT) {
 		/* range from 1 to 256 */
-		if ((strHostIFCfgParamAttr->pstrCfgParamVal.short_retry_limit > 0) && (strHostIFCfgParamAttr->pstrCfgParamVal.short_retry_limit < 256))	{
+		if ((strHostIFCfgParamAttr->cfg_attr_info.short_retry_limit > 0) && (strHostIFCfgParamAttr->cfg_attr_info.short_retry_limit < 256))	{
 			strWIDList[u8WidCnt].id = WID_SHORT_RETRY_LIMIT;
-			strWIDList[u8WidCnt].val = (s8 *)&strHostIFCfgParamAttr->pstrCfgParamVal.short_retry_limit;
+			strWIDList[u8WidCnt].val = (s8 *)&strHostIFCfgParamAttr->cfg_attr_info.short_retry_limit;
 			strWIDList[u8WidCnt].type = WID_SHORT;
 			strWIDList[u8WidCnt].size = sizeof(u16);
-			hif_drv->strCfgValues.short_retry_limit = strHostIFCfgParamAttr->pstrCfgParamVal.short_retry_limit;
+			hif_drv->strCfgValues.short_retry_limit = strHostIFCfgParamAttr->cfg_attr_info.short_retry_limit;
 		} else {
 			PRINT_ER("Range(1~256) over\n");
 			s32Error = -EINVAL;
@@ -938,15 +938,15 @@ static s32 Handle_CfgParam(struct host_if_drv *hif_drv,
 		}
 		u8WidCnt++;
 	}
-	if (strHostIFCfgParamAttr->pstrCfgParamVal.u32SetCfgFlag & RETRY_LONG) {
+	if (strHostIFCfgParamAttr->cfg_attr_info.u32SetCfgFlag & RETRY_LONG) {
 		/* range from 1 to 256 */
-		if ((strHostIFCfgParamAttr->pstrCfgParamVal.long_retry_limit > 0) && (strHostIFCfgParamAttr->pstrCfgParamVal.long_retry_limit < 256)) {
+		if ((strHostIFCfgParamAttr->cfg_attr_info.long_retry_limit > 0) && (strHostIFCfgParamAttr->cfg_attr_info.long_retry_limit < 256)) {
 			strWIDList[u8WidCnt].id = WID_LONG_RETRY_LIMIT;
-			strWIDList[u8WidCnt].val = (s8 *)&strHostIFCfgParamAttr->pstrCfgParamVal.long_retry_limit;
+			strWIDList[u8WidCnt].val = (s8 *)&strHostIFCfgParamAttr->cfg_attr_info.long_retry_limit;
 
 			strWIDList[u8WidCnt].type = WID_SHORT;
 			strWIDList[u8WidCnt].size = sizeof(u16);
-			hif_drv->strCfgValues.long_retry_limit = strHostIFCfgParamAttr->pstrCfgParamVal.long_retry_limit;
+			hif_drv->strCfgValues.long_retry_limit = strHostIFCfgParamAttr->cfg_attr_info.long_retry_limit;
 		} else {
 			PRINT_ER("Range(1~256) over\n");
 			s32Error = -EINVAL;
@@ -954,14 +954,14 @@ static s32 Handle_CfgParam(struct host_if_drv *hif_drv,
 		}
 		u8WidCnt++;
 	}
-	if (strHostIFCfgParamAttr->pstrCfgParamVal.u32SetCfgFlag & FRAG_THRESHOLD) {
+	if (strHostIFCfgParamAttr->cfg_attr_info.u32SetCfgFlag & FRAG_THRESHOLD) {
 
-		if (strHostIFCfgParamAttr->pstrCfgParamVal.frag_threshold > 255 && strHostIFCfgParamAttr->pstrCfgParamVal.frag_threshold < 7937) {
+		if (strHostIFCfgParamAttr->cfg_attr_info.frag_threshold > 255 && strHostIFCfgParamAttr->cfg_attr_info.frag_threshold < 7937) {
 			strWIDList[u8WidCnt].id = WID_FRAG_THRESHOLD;
-			strWIDList[u8WidCnt].val = (s8 *)&strHostIFCfgParamAttr->pstrCfgParamVal.frag_threshold;
+			strWIDList[u8WidCnt].val = (s8 *)&strHostIFCfgParamAttr->cfg_attr_info.frag_threshold;
 			strWIDList[u8WidCnt].type = WID_SHORT;
 			strWIDList[u8WidCnt].size = sizeof(u16);
-			hif_drv->strCfgValues.frag_threshold = strHostIFCfgParamAttr->pstrCfgParamVal.frag_threshold;
+			hif_drv->strCfgValues.frag_threshold = strHostIFCfgParamAttr->cfg_attr_info.frag_threshold;
 		} else {
 			PRINT_ER("Threshold Range fail\n");
 			s32Error = -EINVAL;
@@ -969,14 +969,14 @@ static s32 Handle_CfgParam(struct host_if_drv *hif_drv,
 		}
 		u8WidCnt++;
 	}
-	if (strHostIFCfgParamAttr->pstrCfgParamVal.u32SetCfgFlag & RTS_THRESHOLD) {
+	if (strHostIFCfgParamAttr->cfg_attr_info.u32SetCfgFlag & RTS_THRESHOLD) {
 		/* range 256 to 65535 */
-		if (strHostIFCfgParamAttr->pstrCfgParamVal.rts_threshold > 255 && strHostIFCfgParamAttr->pstrCfgParamVal.rts_threshold < 65536)	{
+		if (strHostIFCfgParamAttr->cfg_attr_info.rts_threshold > 255 && strHostIFCfgParamAttr->cfg_attr_info.rts_threshold < 65536)	{
 			strWIDList[u8WidCnt].id = WID_RTS_THRESHOLD;
-			strWIDList[u8WidCnt].val = (s8 *)&strHostIFCfgParamAttr->pstrCfgParamVal.rts_threshold;
+			strWIDList[u8WidCnt].val = (s8 *)&strHostIFCfgParamAttr->cfg_attr_info.rts_threshold;
 			strWIDList[u8WidCnt].type = WID_SHORT;
 			strWIDList[u8WidCnt].size = sizeof(u16);
-			hif_drv->strCfgValues.rts_threshold = strHostIFCfgParamAttr->pstrCfgParamVal.rts_threshold;
+			hif_drv->strCfgValues.rts_threshold = strHostIFCfgParamAttr->cfg_attr_info.rts_threshold;
 		} else {
 			PRINT_ER("Threshold Range fail\n");
 			s32Error = -EINVAL;
@@ -984,18 +984,18 @@ static s32 Handle_CfgParam(struct host_if_drv *hif_drv,
 		}
 		u8WidCnt++;
 	}
-	if (strHostIFCfgParamAttr->pstrCfgParamVal.u32SetCfgFlag & PREAMBLE) {
+	if (strHostIFCfgParamAttr->cfg_attr_info.u32SetCfgFlag & PREAMBLE) {
 		/*-----------------------------------------------------*/
 		/*Input Values: Short= 0,								*/
 		/*				Long= 1,                                */
 		/*				Auto= 2									*/
 		/*------------------------------------------------------*/
-		if (strHostIFCfgParamAttr->pstrCfgParamVal.preamble_type < 3) {
+		if (strHostIFCfgParamAttr->cfg_attr_info.preamble_type < 3) {
 			strWIDList[u8WidCnt].id = WID_PREAMBLE;
-			strWIDList[u8WidCnt].val = (s8 *)&strHostIFCfgParamAttr->pstrCfgParamVal.preamble_type;
+			strWIDList[u8WidCnt].val = (s8 *)&strHostIFCfgParamAttr->cfg_attr_info.preamble_type;
 			strWIDList[u8WidCnt].type = WID_CHAR;
 			strWIDList[u8WidCnt].size = sizeof(char);
-			hif_drv->strCfgValues.preamble_type = strHostIFCfgParamAttr->pstrCfgParamVal.preamble_type;
+			hif_drv->strCfgValues.preamble_type = strHostIFCfgParamAttr->cfg_attr_info.preamble_type;
 		} else {
 			PRINT_ER("Preamle Range(0~2) over\n");
 			s32Error = -EINVAL;
@@ -1003,13 +1003,13 @@ static s32 Handle_CfgParam(struct host_if_drv *hif_drv,
 		}
 		u8WidCnt++;
 	}
-	if (strHostIFCfgParamAttr->pstrCfgParamVal.u32SetCfgFlag & SHORT_SLOT_ALLOWED) {
-		if (strHostIFCfgParamAttr->pstrCfgParamVal.short_slot_allowed < 2) {
+	if (strHostIFCfgParamAttr->cfg_attr_info.u32SetCfgFlag & SHORT_SLOT_ALLOWED) {
+		if (strHostIFCfgParamAttr->cfg_attr_info.short_slot_allowed < 2) {
 			strWIDList[u8WidCnt].id = WID_SHORT_SLOT_ALLOWED;
-			strWIDList[u8WidCnt].val = (s8 *)&strHostIFCfgParamAttr->pstrCfgParamVal.short_slot_allowed;
+			strWIDList[u8WidCnt].val = (s8 *)&strHostIFCfgParamAttr->cfg_attr_info.short_slot_allowed;
 			strWIDList[u8WidCnt].type = WID_CHAR;
 			strWIDList[u8WidCnt].size = sizeof(char);
-			hif_drv->strCfgValues.short_slot_allowed = (u8)strHostIFCfgParamAttr->pstrCfgParamVal.short_slot_allowed;
+			hif_drv->strCfgValues.short_slot_allowed = (u8)strHostIFCfgParamAttr->cfg_attr_info.short_slot_allowed;
 		} else {
 			PRINT_ER("Short slot(2) over\n");
 			s32Error = -EINVAL;
@@ -1017,17 +1017,17 @@ static s32 Handle_CfgParam(struct host_if_drv *hif_drv,
 		}
 		u8WidCnt++;
 	}
-	if (strHostIFCfgParamAttr->pstrCfgParamVal.u32SetCfgFlag & TXOP_PROT_DISABLE) {
+	if (strHostIFCfgParamAttr->cfg_attr_info.u32SetCfgFlag & TXOP_PROT_DISABLE) {
 		/*Description:	used to Disable RTS-CTS protection for TXOP burst*/
 		/*transmission when the acknowledgement policy is No-Ack or Block-Ack	*/
 		/* this information is useful for external supplicant                                   */
 		/*Input Values: 1 for enable and 0 for disable.							*/
-		if (strHostIFCfgParamAttr->pstrCfgParamVal.txop_prot_disabled < 2) {
+		if (strHostIFCfgParamAttr->cfg_attr_info.txop_prot_disabled < 2) {
 			strWIDList[u8WidCnt].id = WID_11N_TXOP_PROT_DISABLE;
-			strWIDList[u8WidCnt].val = (s8 *)&strHostIFCfgParamAttr->pstrCfgParamVal.txop_prot_disabled;
+			strWIDList[u8WidCnt].val = (s8 *)&strHostIFCfgParamAttr->cfg_attr_info.txop_prot_disabled;
 			strWIDList[u8WidCnt].type = WID_CHAR;
 			strWIDList[u8WidCnt].size = sizeof(char);
-			hif_drv->strCfgValues.txop_prot_disabled = (u8)strHostIFCfgParamAttr->pstrCfgParamVal.txop_prot_disabled;
+			hif_drv->strCfgValues.txop_prot_disabled = (u8)strHostIFCfgParamAttr->cfg_attr_info.txop_prot_disabled;
 		} else {
 			PRINT_ER("TXOP prot disable\n");
 			s32Error = -EINVAL;
@@ -1035,14 +1035,14 @@ static s32 Handle_CfgParam(struct host_if_drv *hif_drv,
 		}
 		u8WidCnt++;
 	}
-	if (strHostIFCfgParamAttr->pstrCfgParamVal.u32SetCfgFlag & BEACON_INTERVAL) {
+	if (strHostIFCfgParamAttr->cfg_attr_info.u32SetCfgFlag & BEACON_INTERVAL) {
 		/* range is 1 to 65535. */
-		if (strHostIFCfgParamAttr->pstrCfgParamVal.beacon_interval > 0 && strHostIFCfgParamAttr->pstrCfgParamVal.beacon_interval < 65536) {
+		if (strHostIFCfgParamAttr->cfg_attr_info.beacon_interval > 0 && strHostIFCfgParamAttr->cfg_attr_info.beacon_interval < 65536) {
 			strWIDList[u8WidCnt].id = WID_BEACON_INTERVAL;
-			strWIDList[u8WidCnt].val = (s8 *)&strHostIFCfgParamAttr->pstrCfgParamVal.beacon_interval;
+			strWIDList[u8WidCnt].val = (s8 *)&strHostIFCfgParamAttr->cfg_attr_info.beacon_interval;
 			strWIDList[u8WidCnt].type = WID_SHORT;
 			strWIDList[u8WidCnt].size = sizeof(u16);
-			hif_drv->strCfgValues.beacon_interval = strHostIFCfgParamAttr->pstrCfgParamVal.beacon_interval;
+			hif_drv->strCfgValues.beacon_interval = strHostIFCfgParamAttr->cfg_attr_info.beacon_interval;
 		} else {
 			PRINT_ER("Beacon interval(1~65535) fail\n");
 			s32Error = -EINVAL;
@@ -1050,14 +1050,14 @@ static s32 Handle_CfgParam(struct host_if_drv *hif_drv,
 		}
 		u8WidCnt++;
 	}
-	if (strHostIFCfgParamAttr->pstrCfgParamVal.u32SetCfgFlag & DTIM_PERIOD) {
+	if (strHostIFCfgParamAttr->cfg_attr_info.u32SetCfgFlag & DTIM_PERIOD) {
 		/* range is 1 to 255. */
-		if (strHostIFCfgParamAttr->pstrCfgParamVal.dtim_period > 0 && strHostIFCfgParamAttr->pstrCfgParamVal.dtim_period < 256) {
+		if (strHostIFCfgParamAttr->cfg_attr_info.dtim_period > 0 && strHostIFCfgParamAttr->cfg_attr_info.dtim_period < 256) {
 			strWIDList[u8WidCnt].id = WID_DTIM_PERIOD;
-			strWIDList[u8WidCnt].val = (s8 *)&strHostIFCfgParamAttr->pstrCfgParamVal.dtim_period;
+			strWIDList[u8WidCnt].val = (s8 *)&strHostIFCfgParamAttr->cfg_attr_info.dtim_period;
 			strWIDList[u8WidCnt].type = WID_CHAR;
 			strWIDList[u8WidCnt].size = sizeof(char);
-			hif_drv->strCfgValues.dtim_period = strHostIFCfgParamAttr->pstrCfgParamVal.dtim_period;
+			hif_drv->strCfgValues.dtim_period = strHostIFCfgParamAttr->cfg_attr_info.dtim_period;
 		} else {
 			PRINT_ER("DTIM range(1~255) fail\n");
 			s32Error = -EINVAL;
@@ -1065,18 +1065,18 @@ static s32 Handle_CfgParam(struct host_if_drv *hif_drv,
 		}
 		u8WidCnt++;
 	}
-	if (strHostIFCfgParamAttr->pstrCfgParamVal.u32SetCfgFlag & SITE_SURVEY) {
+	if (strHostIFCfgParamAttr->cfg_attr_info.u32SetCfgFlag & SITE_SURVEY) {
 		/*----------------------------------------------------------------------*/
 		/*Input Values: SITE_SURVEY_1CH    = 0, i.e.: currently set channel		*/
 		/*				SITE_SURVEY_ALL_CH = 1,									*/
 		/*				SITE_SURVEY_OFF    = 2									*/
 		/*----------------------------------------------------------------------*/
-		if (strHostIFCfgParamAttr->pstrCfgParamVal.site_survey_enabled < 3) {
+		if (strHostIFCfgParamAttr->cfg_attr_info.site_survey_enabled < 3) {
 			strWIDList[u8WidCnt].id = WID_SITE_SURVEY;
-			strWIDList[u8WidCnt].val = (s8 *)&strHostIFCfgParamAttr->pstrCfgParamVal.site_survey_enabled;
+			strWIDList[u8WidCnt].val = (s8 *)&strHostIFCfgParamAttr->cfg_attr_info.site_survey_enabled;
 			strWIDList[u8WidCnt].type = WID_CHAR;
 			strWIDList[u8WidCnt].size = sizeof(char);
-			hif_drv->strCfgValues.site_survey_enabled = (u8)strHostIFCfgParamAttr->pstrCfgParamVal.site_survey_enabled;
+			hif_drv->strCfgValues.site_survey_enabled = (u8)strHostIFCfgParamAttr->cfg_attr_info.site_survey_enabled;
 		} else {
 			PRINT_ER("Site survey disable\n");
 			s32Error = -EINVAL;
@@ -1084,14 +1084,14 @@ static s32 Handle_CfgParam(struct host_if_drv *hif_drv,
 		}
 		u8WidCnt++;
 	}
-	if (strHostIFCfgParamAttr->pstrCfgParamVal.u32SetCfgFlag & SITE_SURVEY_SCAN_TIME) {
+	if (strHostIFCfgParamAttr->cfg_attr_info.u32SetCfgFlag & SITE_SURVEY_SCAN_TIME) {
 		/* range is 1 to 65535. */
-		if (strHostIFCfgParamAttr->pstrCfgParamVal.site_survey_scan_time > 0 && strHostIFCfgParamAttr->pstrCfgParamVal.site_survey_scan_time < 65536) {
+		if (strHostIFCfgParamAttr->cfg_attr_info.site_survey_scan_time > 0 && strHostIFCfgParamAttr->cfg_attr_info.site_survey_scan_time < 65536) {
 			strWIDList[u8WidCnt].id = WID_SITE_SURVEY_SCAN_TIME;
-			strWIDList[u8WidCnt].val = (s8 *)&strHostIFCfgParamAttr->pstrCfgParamVal.site_survey_scan_time;
+			strWIDList[u8WidCnt].val = (s8 *)&strHostIFCfgParamAttr->cfg_attr_info.site_survey_scan_time;
 			strWIDList[u8WidCnt].type = WID_SHORT;
 			strWIDList[u8WidCnt].size = sizeof(u16);
-			hif_drv->strCfgValues.site_survey_scan_time = strHostIFCfgParamAttr->pstrCfgParamVal.site_survey_scan_time;
+			hif_drv->strCfgValues.site_survey_scan_time = strHostIFCfgParamAttr->cfg_attr_info.site_survey_scan_time;
 		} else {
 			PRINT_ER("Site survey scan time(1~65535) over\n");
 			s32Error = -EINVAL;
@@ -1099,14 +1099,14 @@ static s32 Handle_CfgParam(struct host_if_drv *hif_drv,
 		}
 		u8WidCnt++;
 	}
-	if (strHostIFCfgParamAttr->pstrCfgParamVal.u32SetCfgFlag & ACTIVE_SCANTIME) {
+	if (strHostIFCfgParamAttr->cfg_attr_info.u32SetCfgFlag & ACTIVE_SCANTIME) {
 		/* range is 1 to 65535. */
-		if (strHostIFCfgParamAttr->pstrCfgParamVal.active_scan_time > 0 && strHostIFCfgParamAttr->pstrCfgParamVal.active_scan_time < 65536) {
+		if (strHostIFCfgParamAttr->cfg_attr_info.active_scan_time > 0 && strHostIFCfgParamAttr->cfg_attr_info.active_scan_time < 65536) {
 			strWIDList[u8WidCnt].id = WID_ACTIVE_SCAN_TIME;
-			strWIDList[u8WidCnt].val = (s8 *)&strHostIFCfgParamAttr->pstrCfgParamVal.active_scan_time;
+			strWIDList[u8WidCnt].val = (s8 *)&strHostIFCfgParamAttr->cfg_attr_info.active_scan_time;
 			strWIDList[u8WidCnt].type = WID_SHORT;
 			strWIDList[u8WidCnt].size = sizeof(u16);
-			hif_drv->strCfgValues.active_scan_time = strHostIFCfgParamAttr->pstrCfgParamVal.active_scan_time;
+			hif_drv->strCfgValues.active_scan_time = strHostIFCfgParamAttr->cfg_attr_info.active_scan_time;
 		} else {
 			PRINT_ER("Active scan time(1~65535) over\n");
 			s32Error = -EINVAL;
@@ -1114,14 +1114,14 @@ static s32 Handle_CfgParam(struct host_if_drv *hif_drv,
 		}
 		u8WidCnt++;
 	}
-	if (strHostIFCfgParamAttr->pstrCfgParamVal.u32SetCfgFlag & PASSIVE_SCANTIME) {
+	if (strHostIFCfgParamAttr->cfg_attr_info.u32SetCfgFlag & PASSIVE_SCANTIME) {
 		/* range is 1 to 65535. */
-		if (strHostIFCfgParamAttr->pstrCfgParamVal.passive_scan_time > 0 && strHostIFCfgParamAttr->pstrCfgParamVal.passive_scan_time < 65536) {
+		if (strHostIFCfgParamAttr->cfg_attr_info.passive_scan_time > 0 && strHostIFCfgParamAttr->cfg_attr_info.passive_scan_time < 65536) {
 			strWIDList[u8WidCnt].id = WID_PASSIVE_SCAN_TIME;
-			strWIDList[u8WidCnt].val = (s8 *)&strHostIFCfgParamAttr->pstrCfgParamVal.passive_scan_time;
+			strWIDList[u8WidCnt].val = (s8 *)&strHostIFCfgParamAttr->cfg_attr_info.passive_scan_time;
 			strWIDList[u8WidCnt].type = WID_SHORT;
 			strWIDList[u8WidCnt].size = sizeof(u16);
-			hif_drv->strCfgValues.passive_scan_time = strHostIFCfgParamAttr->pstrCfgParamVal.passive_scan_time;
+			hif_drv->strCfgValues.passive_scan_time = strHostIFCfgParamAttr->cfg_attr_info.passive_scan_time;
 		} else {
 			PRINT_ER("Passive scan time(1~65535) over\n");
 			s32Error = -EINVAL;
@@ -1129,8 +1129,8 @@ static s32 Handle_CfgParam(struct host_if_drv *hif_drv,
 		}
 		u8WidCnt++;
 	}
-	if (strHostIFCfgParamAttr->pstrCfgParamVal.u32SetCfgFlag & CURRENT_TX_RATE) {
-		enum CURRENT_TXRATE curr_tx_rate = strHostIFCfgParamAttr->pstrCfgParamVal.curr_tx_rate;
+	if (strHostIFCfgParamAttr->cfg_attr_info.u32SetCfgFlag & CURRENT_TX_RATE) {
+		enum CURRENT_TXRATE curr_tx_rate = strHostIFCfgParamAttr->cfg_attr_info.curr_tx_rate;
 		/*----------------------------------------------------------------------*/
 		/*Rates:		1   2   5.5   11   6  9  12  18  24  36  48   54  Auto	*/
 		/*InputValues:	1   2     3    4   5  6   7   8   9  10  11   12  0		*/
@@ -5504,7 +5504,7 @@ s32 hif_set_cfg(struct host_if_drv *hif_drv,
 	/* prepare the WiphyParams Message */
 	memset(&msg, 0, sizeof(struct host_if_msg));
 	msg.id = HOST_IF_MSG_CFG_PARAMS;
-	msg.body.cfg_info.pstrCfgParamVal = *pstrCfgParamVal;
+	msg.body.cfg_info.cfg_attr_info = *pstrCfgParamVal;
 	msg.drv = hif_drv;
 
 	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
-- 
1.9.1

