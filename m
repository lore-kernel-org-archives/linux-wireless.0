Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:12409 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751819AbbJLH5p (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Oct 2015 03:57:45 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH V2 11/41] staging: wilc1000: rename the member variable, s32ValueSize of wid
Date: Mon, 12 Oct 2015 16:55:45 +0900
Message-ID: <1444636575-2486-11-git-send-email-tony.cho@atmel.com> (sfid-20151012_095753_064742_337F4BCA)
In-Reply-To: <1444636575-2486-1-git-send-email-tony.cho@atmel.com>
References: <1444636575-2486-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames s32ValueSize of struct wid to size.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/coreconfigurator.c |   6 +-
 drivers/staging/wilc1000/coreconfigurator.h |   2 +-
 drivers/staging/wilc1000/host_interface.c   | 208 ++++++++++++++--------------
 3 files changed, 108 insertions(+), 108 deletions(-)

diff --git a/drivers/staging/wilc1000/coreconfigurator.c b/drivers/staging/wilc1000/coreconfigurator.c
index 05a0c16..e51ae3a 100644
--- a/drivers/staging/wilc1000/coreconfigurator.c
+++ b/drivers/staging/wilc1000/coreconfigurator.c
@@ -614,10 +614,10 @@ s32 send_config_pkt(u8 mode, struct wid *wids, u32 count, u32 drv)
 		}
 		counter = 0;
 		for (counter = 0; counter < count; counter++) {
-			wids[counter].s32ValueSize = wilc_wlan_cfg_get_val(
+			wids[counter].size = wilc_wlan_cfg_get_val(
 					wids[counter].id,
 					wids[counter].ps8WidVal,
-					wids[counter].s32ValueSize);
+					wids[counter].size);
 
 		}
 	} else if (mode == SET_CFG) {
@@ -626,7 +626,7 @@ s32 send_config_pkt(u8 mode, struct wid *wids, u32 count, u32 drv)
 			if (!wilc_wlan_cfg_set(!counter,
 					       wids[counter].id,
 					       wids[counter].ps8WidVal,
-					       wids[counter].s32ValueSize,
+					       wids[counter].size,
 					       (counter == count - 1),
 					       drv)) {
 				ret = -1;
diff --git a/drivers/staging/wilc1000/coreconfigurator.h b/drivers/staging/wilc1000/coreconfigurator.h
index 0d3bff7..3595a0a 100644
--- a/drivers/staging/wilc1000/coreconfigurator.h
+++ b/drivers/staging/wilc1000/coreconfigurator.h
@@ -73,7 +73,7 @@ typedef enum {
 struct wid {
 	u16 id;
 	enum WID_TYPE type;
-	s32 s32ValueSize;
+	s32 size;
 	s8      *ps8WidVal;
 };
 
diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 443e783..fae96fc 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -579,7 +579,7 @@ static s32 Handle_SetChannel(struct host_if_drv *drvHandler,
 	strWID.id = (u16)WID_CURRENT_CHANNEL;
 	strWID.type = WID_CHAR;
 	strWID.ps8WidVal = (char *)&(pstrHostIFSetChan->u8SetChan);
-	strWID.s32ValueSize = sizeof(char);
+	strWID.size = sizeof(char);
 
 	PRINT_D(HOSTINF_DBG, "Setting channel\n");
 	/*Sending Cfg*/
@@ -615,7 +615,7 @@ static s32 Handle_SetWfiDrvHandler(struct host_if_drv *drvHandler,
 	strWID.id = (u16)WID_SET_DRV_HANDLER;
 	strWID.type = WID_INT;
 	strWID.ps8WidVal = (s8 *)&(pstrHostIfSetDrvHandler->u32Address);
-	strWID.s32ValueSize = sizeof(u32);
+	strWID.size = sizeof(u32);
 
 	/*Sending Cfg*/
 
@@ -656,7 +656,7 @@ static s32 Handle_SetOperationMode(struct host_if_drv *drvHandler,
 	strWID.id = (u16)WID_SET_OPERATION_MODE;
 	strWID.type = WID_INT;
 	strWID.ps8WidVal = (s8 *)&(pstrHostIfSetOperationMode->u32Mode);
-	strWID.s32ValueSize = sizeof(u32);
+	strWID.size = sizeof(u32);
 
 	/*Sending Cfg*/
 	PRINT_INFO(HOSTINF_DBG, "pstrWFIDrv= %p\n", pstrWFIDrv);
@@ -705,7 +705,7 @@ s32 Handle_set_IPAddress(struct host_if_drv *drvHandler, u8 *pu8IPAddr, u8 idx)
 	strWID.id = (u16)WID_IP_ADDRESS;
 	strWID.type = WID_STR;
 	strWID.ps8WidVal = (u8 *)pu8IPAddr;
-	strWID.s32ValueSize = IP_ALEN;
+	strWID.size = IP_ALEN;
 
 	s32Error = send_config_pkt(SET_CFG, &strWID, 1,
 				   get_id_from_handler(pstrWFIDrv));
@@ -744,7 +744,7 @@ s32 Handle_get_IPAddress(struct host_if_drv *drvHandler, u8 *pu8IPAddr, u8 idx)
 	strWID.id = (u16)WID_IP_ADDRESS;
 	strWID.type = WID_STR;
 	strWID.ps8WidVal = kmalloc(IP_ALEN, GFP_KERNEL);
-	strWID.s32ValueSize = IP_ALEN;
+	strWID.size = IP_ALEN;
 
 	s32Error = send_config_pkt(GET_CFG, &strWID, 1,
 				   get_id_from_handler(pstrWFIDrv));
@@ -800,7 +800,7 @@ static s32 Handle_SetMacAddress(struct host_if_drv *drvHandler,
 	strWID.id = (u16)WID_MAC_ADDR;
 	strWID.type = WID_STR;
 	strWID.ps8WidVal = mac_buf;
-	strWID.s32ValueSize = ETH_ALEN;
+	strWID.size = ETH_ALEN;
 	PRINT_D(GENERIC_DBG, "mac addr = :%pM\n", strWID.ps8WidVal);
 	/*Sending Cfg*/
 	s32Error = send_config_pkt(SET_CFG, &strWID, 1,
@@ -835,7 +835,7 @@ static s32 Handle_GetMacAddress(struct host_if_drv *drvHandler,
 	strWID.id = (u16)WID_MAC_ADDR;
 	strWID.type = WID_STR;
 	strWID.ps8WidVal = pstrHostIfGetMacAddress->u8MacAddress;
-	strWID.s32ValueSize = ETH_ALEN;
+	strWID.size = ETH_ALEN;
 
 	/*Sending Cfg*/
 	s32Error = send_config_pkt(GET_CFG, &strWID, 1,
@@ -884,7 +884,7 @@ static s32 Handle_CfgParam(struct host_if_drv *drvHandler,
 			strWIDList[u8WidCnt].id = WID_BSS_TYPE;
 			strWIDList[u8WidCnt].ps8WidVal = (s8 *)&strHostIFCfgParamAttr->pstrCfgParamVal.bss_type;
 			strWIDList[u8WidCnt].type = WID_CHAR;
-			strWIDList[u8WidCnt].s32ValueSize = sizeof(char);
+			strWIDList[u8WidCnt].size = sizeof(char);
 			pstrWFIDrv->strCfgValues.bss_type = (u8)strHostIFCfgParamAttr->pstrCfgParamVal.bss_type;
 		} else {
 			PRINT_ER("check value 6 over\n");
@@ -904,7 +904,7 @@ static s32 Handle_CfgParam(struct host_if_drv *drvHandler,
 			strWIDList[u8WidCnt].id = WID_AUTH_TYPE;
 			strWIDList[u8WidCnt].ps8WidVal = (s8 *)&strHostIFCfgParamAttr->pstrCfgParamVal.auth_type;
 			strWIDList[u8WidCnt].type = WID_CHAR;
-			strWIDList[u8WidCnt].s32ValueSize = sizeof(char);
+			strWIDList[u8WidCnt].size = sizeof(char);
 			pstrWFIDrv->strCfgValues.auth_type = (u8)strHostIFCfgParamAttr->pstrCfgParamVal.auth_type;
 		} else {
 			PRINT_ER("Impossible value \n");
@@ -919,7 +919,7 @@ static s32 Handle_CfgParam(struct host_if_drv *drvHandler,
 			strWIDList[u8WidCnt].id = WID_AUTH_TIMEOUT;
 			strWIDList[u8WidCnt].ps8WidVal = (s8 *)&strHostIFCfgParamAttr->pstrCfgParamVal.auth_timeout;
 			strWIDList[u8WidCnt].type = WID_SHORT;
-			strWIDList[u8WidCnt].s32ValueSize = sizeof(u16);
+			strWIDList[u8WidCnt].size = sizeof(u16);
 			pstrWFIDrv->strCfgValues.auth_timeout = strHostIFCfgParamAttr->pstrCfgParamVal.auth_timeout;
 		} else {
 			PRINT_ER("Range(1 ~ 65535) over\n");
@@ -940,7 +940,7 @@ static s32 Handle_CfgParam(struct host_if_drv *drvHandler,
 			strWIDList[u8WidCnt].id = WID_POWER_MANAGEMENT;
 			strWIDList[u8WidCnt].ps8WidVal = (s8 *)&strHostIFCfgParamAttr->pstrCfgParamVal.power_mgmt_mode;
 			strWIDList[u8WidCnt].type = WID_CHAR;
-			strWIDList[u8WidCnt].s32ValueSize = sizeof(char);
+			strWIDList[u8WidCnt].size = sizeof(char);
 			pstrWFIDrv->strCfgValues.power_mgmt_mode = (u8)strHostIFCfgParamAttr->pstrCfgParamVal.power_mgmt_mode;
 		} else {
 			PRINT_ER("Invalide power mode\n");
@@ -955,7 +955,7 @@ static s32 Handle_CfgParam(struct host_if_drv *drvHandler,
 			strWIDList[u8WidCnt].id = WID_SHORT_RETRY_LIMIT;
 			strWIDList[u8WidCnt].ps8WidVal = (s8 *)&strHostIFCfgParamAttr->pstrCfgParamVal.short_retry_limit;
 			strWIDList[u8WidCnt].type = WID_SHORT;
-			strWIDList[u8WidCnt].s32ValueSize = sizeof(u16);
+			strWIDList[u8WidCnt].size = sizeof(u16);
 			pstrWFIDrv->strCfgValues.short_retry_limit = strHostIFCfgParamAttr->pstrCfgParamVal.short_retry_limit;
 		} else {
 			PRINT_ER("Range(1~256) over\n");
@@ -971,7 +971,7 @@ static s32 Handle_CfgParam(struct host_if_drv *drvHandler,
 			strWIDList[u8WidCnt].ps8WidVal = (s8 *)&strHostIFCfgParamAttr->pstrCfgParamVal.long_retry_limit;
 
 			strWIDList[u8WidCnt].type = WID_SHORT;
-			strWIDList[u8WidCnt].s32ValueSize = sizeof(u16);
+			strWIDList[u8WidCnt].size = sizeof(u16);
 			pstrWFIDrv->strCfgValues.long_retry_limit = strHostIFCfgParamAttr->pstrCfgParamVal.long_retry_limit;
 		} else {
 			PRINT_ER("Range(1~256) over\n");
@@ -986,7 +986,7 @@ static s32 Handle_CfgParam(struct host_if_drv *drvHandler,
 			strWIDList[u8WidCnt].id = WID_FRAG_THRESHOLD;
 			strWIDList[u8WidCnt].ps8WidVal = (s8 *)&strHostIFCfgParamAttr->pstrCfgParamVal.frag_threshold;
 			strWIDList[u8WidCnt].type = WID_SHORT;
-			strWIDList[u8WidCnt].s32ValueSize = sizeof(u16);
+			strWIDList[u8WidCnt].size = sizeof(u16);
 			pstrWFIDrv->strCfgValues.frag_threshold = strHostIFCfgParamAttr->pstrCfgParamVal.frag_threshold;
 		} else {
 			PRINT_ER("Threshold Range fail\n");
@@ -1001,7 +1001,7 @@ static s32 Handle_CfgParam(struct host_if_drv *drvHandler,
 			strWIDList[u8WidCnt].id = WID_RTS_THRESHOLD;
 			strWIDList[u8WidCnt].ps8WidVal = (s8 *)&strHostIFCfgParamAttr->pstrCfgParamVal.rts_threshold;
 			strWIDList[u8WidCnt].type = WID_SHORT;
-			strWIDList[u8WidCnt].s32ValueSize = sizeof(u16);
+			strWIDList[u8WidCnt].size = sizeof(u16);
 			pstrWFIDrv->strCfgValues.rts_threshold = strHostIFCfgParamAttr->pstrCfgParamVal.rts_threshold;
 		} else {
 			PRINT_ER("Threshold Range fail\n");
@@ -1020,7 +1020,7 @@ static s32 Handle_CfgParam(struct host_if_drv *drvHandler,
 			strWIDList[u8WidCnt].id = WID_PREAMBLE;
 			strWIDList[u8WidCnt].ps8WidVal = (s8 *)&strHostIFCfgParamAttr->pstrCfgParamVal.preamble_type;
 			strWIDList[u8WidCnt].type = WID_CHAR;
-			strWIDList[u8WidCnt].s32ValueSize = sizeof(char);
+			strWIDList[u8WidCnt].size = sizeof(char);
 			pstrWFIDrv->strCfgValues.preamble_type = strHostIFCfgParamAttr->pstrCfgParamVal.preamble_type;
 		} else {
 			PRINT_ER("Preamle Range(0~2) over\n");
@@ -1034,7 +1034,7 @@ static s32 Handle_CfgParam(struct host_if_drv *drvHandler,
 			strWIDList[u8WidCnt].id = WID_SHORT_SLOT_ALLOWED;
 			strWIDList[u8WidCnt].ps8WidVal = (s8 *)&strHostIFCfgParamAttr->pstrCfgParamVal.short_slot_allowed;
 			strWIDList[u8WidCnt].type = WID_CHAR;
-			strWIDList[u8WidCnt].s32ValueSize = sizeof(char);
+			strWIDList[u8WidCnt].size = sizeof(char);
 			pstrWFIDrv->strCfgValues.short_slot_allowed = (u8)strHostIFCfgParamAttr->pstrCfgParamVal.short_slot_allowed;
 		} else {
 			PRINT_ER("Short slot(2) over\n");
@@ -1052,7 +1052,7 @@ static s32 Handle_CfgParam(struct host_if_drv *drvHandler,
 			strWIDList[u8WidCnt].id = WID_11N_TXOP_PROT_DISABLE;
 			strWIDList[u8WidCnt].ps8WidVal = (s8 *)&strHostIFCfgParamAttr->pstrCfgParamVal.txop_prot_disabled;
 			strWIDList[u8WidCnt].type = WID_CHAR;
-			strWIDList[u8WidCnt].s32ValueSize = sizeof(char);
+			strWIDList[u8WidCnt].size = sizeof(char);
 			pstrWFIDrv->strCfgValues.txop_prot_disabled = (u8)strHostIFCfgParamAttr->pstrCfgParamVal.txop_prot_disabled;
 		} else {
 			PRINT_ER("TXOP prot disable\n");
@@ -1067,7 +1067,7 @@ static s32 Handle_CfgParam(struct host_if_drv *drvHandler,
 			strWIDList[u8WidCnt].id = WID_BEACON_INTERVAL;
 			strWIDList[u8WidCnt].ps8WidVal = (s8 *)&strHostIFCfgParamAttr->pstrCfgParamVal.beacon_interval;
 			strWIDList[u8WidCnt].type = WID_SHORT;
-			strWIDList[u8WidCnt].s32ValueSize = sizeof(u16);
+			strWIDList[u8WidCnt].size = sizeof(u16);
 			pstrWFIDrv->strCfgValues.beacon_interval = strHostIFCfgParamAttr->pstrCfgParamVal.beacon_interval;
 		} else {
 			PRINT_ER("Beacon interval(1~65535) fail\n");
@@ -1082,7 +1082,7 @@ static s32 Handle_CfgParam(struct host_if_drv *drvHandler,
 			strWIDList[u8WidCnt].id = WID_DTIM_PERIOD;
 			strWIDList[u8WidCnt].ps8WidVal = (s8 *)&strHostIFCfgParamAttr->pstrCfgParamVal.dtim_period;
 			strWIDList[u8WidCnt].type = WID_CHAR;
-			strWIDList[u8WidCnt].s32ValueSize = sizeof(char);
+			strWIDList[u8WidCnt].size = sizeof(char);
 			pstrWFIDrv->strCfgValues.dtim_period = strHostIFCfgParamAttr->pstrCfgParamVal.dtim_period;
 		} else {
 			PRINT_ER("DTIM range(1~255) fail\n");
@@ -1101,7 +1101,7 @@ static s32 Handle_CfgParam(struct host_if_drv *drvHandler,
 			strWIDList[u8WidCnt].id = WID_SITE_SURVEY;
 			strWIDList[u8WidCnt].ps8WidVal = (s8 *)&strHostIFCfgParamAttr->pstrCfgParamVal.site_survey_enabled;
 			strWIDList[u8WidCnt].type = WID_CHAR;
-			strWIDList[u8WidCnt].s32ValueSize = sizeof(char);
+			strWIDList[u8WidCnt].size = sizeof(char);
 			pstrWFIDrv->strCfgValues.site_survey_enabled = (u8)strHostIFCfgParamAttr->pstrCfgParamVal.site_survey_enabled;
 		} else {
 			PRINT_ER("Site survey disable\n");
@@ -1116,7 +1116,7 @@ static s32 Handle_CfgParam(struct host_if_drv *drvHandler,
 			strWIDList[u8WidCnt].id = WID_SITE_SURVEY_SCAN_TIME;
 			strWIDList[u8WidCnt].ps8WidVal = (s8 *)&strHostIFCfgParamAttr->pstrCfgParamVal.site_survey_scan_time;
 			strWIDList[u8WidCnt].type = WID_SHORT;
-			strWIDList[u8WidCnt].s32ValueSize = sizeof(u16);
+			strWIDList[u8WidCnt].size = sizeof(u16);
 			pstrWFIDrv->strCfgValues.site_survey_scan_time = strHostIFCfgParamAttr->pstrCfgParamVal.site_survey_scan_time;
 		} else {
 			PRINT_ER("Site survey scan time(1~65535) over\n");
@@ -1131,7 +1131,7 @@ static s32 Handle_CfgParam(struct host_if_drv *drvHandler,
 			strWIDList[u8WidCnt].id = WID_ACTIVE_SCAN_TIME;
 			strWIDList[u8WidCnt].ps8WidVal = (s8 *)&strHostIFCfgParamAttr->pstrCfgParamVal.active_scan_time;
 			strWIDList[u8WidCnt].type = WID_SHORT;
-			strWIDList[u8WidCnt].s32ValueSize = sizeof(u16);
+			strWIDList[u8WidCnt].size = sizeof(u16);
 			pstrWFIDrv->strCfgValues.active_scan_time = strHostIFCfgParamAttr->pstrCfgParamVal.active_scan_time;
 		} else {
 			PRINT_ER("Active scan time(1~65535) over\n");
@@ -1146,7 +1146,7 @@ static s32 Handle_CfgParam(struct host_if_drv *drvHandler,
 			strWIDList[u8WidCnt].id = WID_PASSIVE_SCAN_TIME;
 			strWIDList[u8WidCnt].ps8WidVal = (s8 *)&strHostIFCfgParamAttr->pstrCfgParamVal.passive_scan_time;
 			strWIDList[u8WidCnt].type = WID_SHORT;
-			strWIDList[u8WidCnt].s32ValueSize = sizeof(u16);
+			strWIDList[u8WidCnt].size = sizeof(u16);
 			pstrWFIDrv->strCfgValues.passive_scan_time = strHostIFCfgParamAttr->pstrCfgParamVal.passive_scan_time;
 		} else {
 			PRINT_ER("Passive scan time(1~65535) over\n");
@@ -1171,7 +1171,7 @@ static s32 Handle_CfgParam(struct host_if_drv *drvHandler,
 			strWIDList[u8WidCnt].id = WID_CURRENT_TX_RATE;
 			strWIDList[u8WidCnt].ps8WidVal = (s8 *)&curr_tx_rate;
 			strWIDList[u8WidCnt].type = WID_SHORT;
-			strWIDList[u8WidCnt].s32ValueSize = sizeof(u16);
+			strWIDList[u8WidCnt].size = sizeof(u16);
 			pstrWFIDrv->strCfgValues.curr_tx_rate = (u8)curr_tx_rate;
 		} else {
 			PRINT_ER("out of TX rate\n");
@@ -1277,7 +1277,7 @@ static s32 Handle_Scan(struct host_if_drv *drvHandler,
 
 
 
-		strWIDList[u32WidsCount].s32ValueSize =  (s32)(valuesize + 1);
+		strWIDList[u32WidsCount].size = (s32)(valuesize + 1);
 		u32WidsCount++;
 	}
 
@@ -1289,14 +1289,14 @@ static s32 Handle_Scan(struct host_if_drv *drvHandler,
 		strWIDList[u32WidsCount].id = WID_INFO_ELEMENT_PROBE;
 		strWIDList[u32WidsCount].type = WID_BIN_DATA;
 		strWIDList[u32WidsCount].ps8WidVal = pstrHostIFscanAttr->pu8IEs;
-		strWIDList[u32WidsCount].s32ValueSize = pstrHostIFscanAttr->IEsLen;
+		strWIDList[u32WidsCount].size = pstrHostIFscanAttr->IEsLen;
 		u32WidsCount++;
 	}
 
 	/*Scan Type*/
 	strWIDList[u32WidsCount].id = WID_SCAN_TYPE;
 	strWIDList[u32WidsCount].type = WID_CHAR;
-	strWIDList[u32WidsCount].s32ValueSize = sizeof(char);
+	strWIDList[u32WidsCount].size = sizeof(char);
 	strWIDList[u32WidsCount].ps8WidVal = (s8 *)(&(pstrHostIFscanAttr->u8ScanType));
 	u32WidsCount++;
 
@@ -1314,13 +1314,13 @@ static s32 Handle_Scan(struct host_if_drv *drvHandler,
 	}
 
 	strWIDList[u32WidsCount].ps8WidVal = pstrHostIFscanAttr->pu8ChnlFreqList;
-	strWIDList[u32WidsCount].s32ValueSize = pstrHostIFscanAttr->u8ChnlListLen;
+	strWIDList[u32WidsCount].size = pstrHostIFscanAttr->u8ChnlListLen;
 	u32WidsCount++;
 
 	/*Scan Request*/
 	strWIDList[u32WidsCount].id = WID_START_SCAN_REQ;
 	strWIDList[u32WidsCount].type = WID_CHAR;
-	strWIDList[u32WidsCount].s32ValueSize = sizeof(char);
+	strWIDList[u32WidsCount].size = sizeof(char);
 	strWIDList[u32WidsCount].ps8WidVal = (s8 *)(&(pstrHostIFscanAttr->u8ScanSource));
 	u32WidsCount++;
 
@@ -1404,7 +1404,7 @@ static s32 Handle_ScanDone(struct host_if_drv *drvHandler, tenuScanEvent enuEven
 		strWID.id = (u16)WID_ABORT_RUNNING_SCAN;
 		strWID.type = WID_CHAR;
 		strWID.ps8WidVal = (s8 *)&u8abort_running_scan;
-		strWID.s32ValueSize = sizeof(char);
+		strWID.size = sizeof(char);
 
 		/*Sending Cfg*/
 		s32Error = send_config_pkt(SET_CFG, &strWID, 1,
@@ -1499,19 +1499,19 @@ static s32 Handle_Connect(struct host_if_drv *drvHandler,
 
 	strWIDList[u32WidsCount].id = WID_SUCCESS_FRAME_COUNT;
 	strWIDList[u32WidsCount].type = WID_INT;
-	strWIDList[u32WidsCount].s32ValueSize = sizeof(u32);
+	strWIDList[u32WidsCount].size = sizeof(u32);
 	strWIDList[u32WidsCount].ps8WidVal = (s8 *)(&(dummyval));
 	u32WidsCount++;
 
 	strWIDList[u32WidsCount].id = WID_RECEIVED_FRAGMENT_COUNT;
 	strWIDList[u32WidsCount].type = WID_INT;
-	strWIDList[u32WidsCount].s32ValueSize = sizeof(u32);
+	strWIDList[u32WidsCount].size = sizeof(u32);
 	strWIDList[u32WidsCount].ps8WidVal = (s8 *)(&(dummyval));
 	u32WidsCount++;
 
 	strWIDList[u32WidsCount].id = WID_FAILED_COUNT;
 	strWIDList[u32WidsCount].type = WID_INT;
-	strWIDList[u32WidsCount].s32ValueSize = sizeof(u32);
+	strWIDList[u32WidsCount].size = sizeof(u32);
 	strWIDList[u32WidsCount].ps8WidVal = (s8 *)(&(dummyval));
 	u32WidsCount++;
 
@@ -1522,7 +1522,7 @@ static s32 Handle_Connect(struct host_if_drv *drvHandler,
 		strWIDList[u32WidsCount].id = WID_INFO_ELEMENT_ASSOCIATE;
 		strWIDList[u32WidsCount].type = WID_BIN_DATA;
 		strWIDList[u32WidsCount].ps8WidVal = pstrWFIDrv->strWILC_UsrConnReq.pu8ConnReqIEs;
-		strWIDList[u32WidsCount].s32ValueSize = pstrWFIDrv->strWILC_UsrConnReq.ConnReqIEsLen;
+		strWIDList[u32WidsCount].size = pstrWFIDrv->strWILC_UsrConnReq.ConnReqIEsLen;
 		u32WidsCount++;
 
 		if (memcmp("DIRECT-", pstrHostIFconnectAttr->pu8ssid, 7)) {
@@ -1535,7 +1535,7 @@ static s32 Handle_Connect(struct host_if_drv *drvHandler,
 	}
 	strWIDList[u32WidsCount].id = (u16)WID_11I_MODE;
 	strWIDList[u32WidsCount].type = WID_CHAR;
-	strWIDList[u32WidsCount].s32ValueSize = sizeof(char);
+	strWIDList[u32WidsCount].size = sizeof(char);
 	strWIDList[u32WidsCount].ps8WidVal = (s8 *)(&(pstrWFIDrv->strWILC_UsrConnReq.u8security));
 	u32WidsCount++;
 
@@ -1547,7 +1547,7 @@ static s32 Handle_Connect(struct host_if_drv *drvHandler,
 
 	strWIDList[u32WidsCount].id = (u16)WID_AUTH_TYPE;
 	strWIDList[u32WidsCount].type = WID_CHAR;
-	strWIDList[u32WidsCount].s32ValueSize = sizeof(char);
+	strWIDList[u32WidsCount].size = sizeof(char);
 	strWIDList[u32WidsCount].ps8WidVal = (s8 *)(&pstrWFIDrv->strWILC_UsrConnReq.tenuAuth_type);
 	u32WidsCount++;
 
@@ -1570,11 +1570,11 @@ static s32 Handle_Connect(struct host_if_drv *drvHandler,
 	strWIDList[u32WidsCount].type = WID_STR;
 
 	/*Sending NoA attributes during connection*/
-	strWIDList[u32WidsCount].s32ValueSize = 112; /* 79; */
-	strWIDList[u32WidsCount].ps8WidVal = kmalloc(strWIDList[u32WidsCount].s32ValueSize, GFP_KERNEL);
+	strWIDList[u32WidsCount].size = 112; /* 79; */
+	strWIDList[u32WidsCount].ps8WidVal = kmalloc(strWIDList[u32WidsCount].size, GFP_KERNEL);
 
 	if (memcmp("DIRECT-", pstrHostIFconnectAttr->pu8ssid, 7)) {
-		gu32FlushedJoinReqSize = strWIDList[u32WidsCount].s32ValueSize;
+		gu32FlushedJoinReqSize = strWIDList[u32WidsCount].size;
 		gu8FlushedJoinReq = kmalloc(gu32FlushedJoinReqSize, GFP_KERNEL);
 	}
 	if (strWIDList[u32WidsCount].ps8WidVal == NULL) {
@@ -1816,12 +1816,12 @@ static s32 Handle_FlushConnect(struct host_if_drv *drvHandler)
 	strWIDList[u32WidsCount].id = WID_INFO_ELEMENT_ASSOCIATE;
 	strWIDList[u32WidsCount].type = WID_BIN_DATA;
 	strWIDList[u32WidsCount].ps8WidVal = gu8FlushedInfoElemAsoc;
-	strWIDList[u32WidsCount].s32ValueSize = gu32FlushedInfoElemAsocSize;
+	strWIDList[u32WidsCount].size = gu32FlushedInfoElemAsocSize;
 	u32WidsCount++;
 
 	strWIDList[u32WidsCount].id = (u16)WID_11I_MODE;
 	strWIDList[u32WidsCount].type = WID_CHAR;
-	strWIDList[u32WidsCount].s32ValueSize = sizeof(char);
+	strWIDList[u32WidsCount].size = sizeof(char);
 	strWIDList[u32WidsCount].ps8WidVal = (s8 *)(&(gu8Flushed11iMode));
 	u32WidsCount++;
 
@@ -1829,13 +1829,13 @@ static s32 Handle_FlushConnect(struct host_if_drv *drvHandler)
 
 	strWIDList[u32WidsCount].id = (u16)WID_AUTH_TYPE;
 	strWIDList[u32WidsCount].type = WID_CHAR;
-	strWIDList[u32WidsCount].s32ValueSize = sizeof(char);
+	strWIDList[u32WidsCount].size = sizeof(char);
 	strWIDList[u32WidsCount].ps8WidVal = (s8 *)(&gu8FlushedAuthType);
 	u32WidsCount++;
 
 	strWIDList[u32WidsCount].id = (u16)WID_JOIN_REQ_EXTENDED;
 	strWIDList[u32WidsCount].type = WID_STR;
-	strWIDList[u32WidsCount].s32ValueSize = gu32FlushedJoinReqSize;
+	strWIDList[u32WidsCount].size = gu32FlushedJoinReqSize;
 	strWIDList[u32WidsCount].ps8WidVal = (s8 *)gu8FlushedJoinReq;
 	pu8CurrByte = strWIDList[u32WidsCount].ps8WidVal;
 
@@ -1921,7 +1921,7 @@ static s32 Handle_ConnectTimeout(struct host_if_drv *drvHandler)
 	strWID.id = (u16)WID_DISCONNECT;
 	strWID.type = WID_CHAR;
 	strWID.ps8WidVal = (s8 *)&u16DummyReasonCode;
-	strWID.s32ValueSize = sizeof(char);
+	strWID.size = sizeof(char);
 
 	PRINT_D(HOSTINF_DBG, "Sending disconnect request\n");
 
@@ -2427,19 +2427,19 @@ static int Handle_Key(struct host_if_drv *drvHandler,
 			PRINT_D(GENERIC_DBG, "ID Hostint is %d\n", (pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFwepAttr.u8Wepidx));
 			strWIDList[0].id = (u16)WID_11I_MODE;
 			strWIDList[0].type = WID_CHAR;
-			strWIDList[0].s32ValueSize = sizeof(char);
+			strWIDList[0].size = sizeof(char);
 			strWIDList[0].ps8WidVal = (s8 *)(&(pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFwepAttr.u8mode));
 
 			strWIDList[1].id = WID_AUTH_TYPE;
 			strWIDList[1].type = WID_CHAR;
-			strWIDList[1].s32ValueSize = sizeof(char);
+			strWIDList[1].size = sizeof(char);
 			strWIDList[1].ps8WidVal = (s8 *)(&(pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFwepAttr.tenuAuth_type));
 
 			strWIDList[2].id = (u16)WID_KEY_ID;
 			strWIDList[2].type = WID_CHAR;
 
 			strWIDList[2].ps8WidVal	= (s8 *)(&(pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFwepAttr.u8Wepidx));
-			strWIDList[2].s32ValueSize = sizeof(char);
+			strWIDList[2].size = sizeof(char);
 
 
 			pu8keybuf = kmalloc(pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFwepAttr.u8WepKeylen, GFP_KERNEL);
@@ -2458,7 +2458,7 @@ static int Handle_Key(struct host_if_drv *drvHandler,
 
 			strWIDList[3].id = (u16)WID_WEP_KEY_VALUE;
 			strWIDList[3].type = WID_STR;
-			strWIDList[3].s32ValueSize = pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFwepAttr.u8WepKeylen;
+			strWIDList[3].size = pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFwepAttr.u8WepKeylen;
 			strWIDList[3].ps8WidVal = (s8 *)pu8keybuf;
 
 
@@ -2488,7 +2488,7 @@ static int Handle_Key(struct host_if_drv *drvHandler,
 			strWID.id = (u16)WID_ADD_WEP_KEY;
 			strWID.type = WID_STR;
 			strWID.ps8WidVal	= (s8 *)pu8keybuf;
-			strWID.s32ValueSize = pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFwepAttr.u8WepKeylen + 2;
+			strWID.size = pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFwepAttr.u8WepKeylen + 2;
 
 			s32Error = send_config_pkt(SET_CFG, &strWID, 1,
 						   get_id_from_handler(pstrWFIDrv));
@@ -2501,7 +2501,7 @@ static int Handle_Key(struct host_if_drv *drvHandler,
 
 			s8idxarray[0] = (s8)pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFwepAttr.u8Wepidx;
 			strWID.ps8WidVal = s8idxarray;
-			strWID.s32ValueSize = 1;
+			strWID.size = 1;
 
 			s32Error = send_config_pkt(SET_CFG, &strWID, 1,
 						   get_id_from_handler(pstrWFIDrv));
@@ -2509,7 +2509,7 @@ static int Handle_Key(struct host_if_drv *drvHandler,
 			strWID.id = (u16)WID_KEY_ID;
 			strWID.type = WID_CHAR;
 			strWID.ps8WidVal	= (s8 *)(&(pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFwepAttr.u8Wepidx));
-			strWID.s32ValueSize = sizeof(char);
+			strWID.size = sizeof(char);
 
 			PRINT_D(HOSTINF_DBG, "Setting default key index\n");
 
@@ -2551,13 +2551,13 @@ static int Handle_Key(struct host_if_drv *drvHandler,
 			/* pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFwpaAttr.u8Ciphermode =  0X51; */
 			strWIDList[0].id = (u16)WID_11I_MODE;
 			strWIDList[0].type = WID_CHAR;
-			strWIDList[0].s32ValueSize = sizeof(char);
+			strWIDList[0].size = sizeof(char);
 			strWIDList[0].ps8WidVal = (s8 *)(&(pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFwpaAttr.u8Ciphermode));
 
 			strWIDList[1].id = (u16)WID_ADD_RX_GTK;
 			strWIDList[1].type = WID_STR;
 			strWIDList[1].ps8WidVal	= (s8 *)pu8keybuf;
-			strWIDList[1].s32ValueSize = RX_MIC_KEY_MSG_LEN;
+			strWIDList[1].size = RX_MIC_KEY_MSG_LEN;
 
 			s32Error = send_config_pkt(SET_CFG, strWIDList, 2,
 						   get_id_from_handler(pstrWFIDrv));
@@ -2603,7 +2603,7 @@ static int Handle_Key(struct host_if_drv *drvHandler,
 			strWID.id = (u16)WID_ADD_RX_GTK;
 			strWID.type = WID_STR;
 			strWID.ps8WidVal	= (s8 *)pu8keybuf;
-			strWID.s32ValueSize = RX_MIC_KEY_MSG_LEN;
+			strWID.size = RX_MIC_KEY_MSG_LEN;
 
 			s32Error = send_config_pkt(SET_CFG, &strWID, 1,
 						   get_id_from_handler(pstrWFIDrv));
@@ -2654,13 +2654,13 @@ _WPARxGtk_end_case_:
 
 			strWIDList[0].id = (u16)WID_11I_MODE;
 			strWIDList[0].type = WID_CHAR;
-			strWIDList[0].s32ValueSize = sizeof(char);
+			strWIDList[0].size = sizeof(char);
 			strWIDList[0].ps8WidVal = (s8 *)(&(pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFwpaAttr.u8Ciphermode));
 
 			strWIDList[1].id = (u16)WID_ADD_PTK;
 			strWIDList[1].type = WID_STR;
 			strWIDList[1].ps8WidVal	= (s8 *)pu8keybuf;
-			strWIDList[1].s32ValueSize = PTK_KEY_MSG_LEN + 1;
+			strWIDList[1].size = PTK_KEY_MSG_LEN + 1;
 
 			s32Error = send_config_pkt(SET_CFG, strWIDList, 2,
 						   get_id_from_handler(pstrWFIDrv));
@@ -2701,7 +2701,7 @@ _WPARxGtk_end_case_:
 			strWID.id = (u16)WID_ADD_PTK;
 			strWID.type = WID_STR;
 			strWID.ps8WidVal	= (s8 *)pu8keybuf;
-			strWID.s32ValueSize = PTK_KEY_MSG_LEN;
+			strWID.size = PTK_KEY_MSG_LEN;
 
 			s32Error = send_config_pkt(SET_CFG, &strWID, 1,
 						   get_id_from_handler(pstrWFIDrv));
@@ -2741,7 +2741,7 @@ _WPAPtk_end_case_:
 		strWID.id = (u16)WID_PMKID_INFO;
 		strWID.type = WID_STR;
 		strWID.ps8WidVal = (s8 *)pu8keybuf;
-		strWID.s32ValueSize = (pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFpmkidAttr.numpmkid * PMKSA_KEY_LEN) + 1;
+		strWID.size = (pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFpmkidAttr.numpmkid * PMKSA_KEY_LEN) + 1;
 
 		s32Error = send_config_pkt(SET_CFG, &strWID, 1,
 					   get_id_from_handler(pstrWFIDrv));
@@ -2779,7 +2779,7 @@ static void Handle_Disconnect(struct host_if_drv *drvHandler)
 	strWID.id = (u16)WID_DISCONNECT;
 	strWID.type = WID_CHAR;
 	strWID.ps8WidVal = (s8 *)&u16DummyReasonCode;
-	strWID.s32ValueSize = sizeof(char);
+	strWID.size = sizeof(char);
 
 
 
@@ -2903,7 +2903,7 @@ static s32 Handle_GetChnl(struct host_if_drv *drvHandler)
 	strWID.id = (u16)WID_CURRENT_CHANNEL;
 	strWID.type = WID_CHAR;
 	strWID.ps8WidVal = (s8 *)&gu8Chnl;
-	strWID.s32ValueSize = sizeof(char);
+	strWID.size = sizeof(char);
 
 	PRINT_D(HOSTINF_DBG, "Getting channel value\n");
 
@@ -2942,7 +2942,7 @@ static void Handle_GetRssi(struct host_if_drv *drvHandler)
 	strWID.id = (u16)WID_RSSI;
 	strWID.type = WID_CHAR;
 	strWID.ps8WidVal = &gs8Rssi;
-	strWID.s32ValueSize = sizeof(char);
+	strWID.size = sizeof(char);
 
 	/*Sending Cfg*/
 	PRINT_D(HOSTINF_DBG, "Getting RSSI value\n");
@@ -2971,7 +2971,7 @@ static void Handle_GetLinkspeed(struct host_if_drv *drvHandler)
 	strWID.id = (u16)WID_LINKSPEED;
 	strWID.type = WID_CHAR;
 	strWID.ps8WidVal = &gs8lnkspd;
-	strWID.s32ValueSize = sizeof(char);
+	strWID.size = sizeof(char);
 	/*Sending Cfg*/
 	PRINT_D(HOSTINF_DBG, "Getting LINKSPEED value\n");
 
@@ -2994,31 +2994,31 @@ s32 Handle_GetStatistics(struct host_if_drv *drvHandler, tstrStatistics *pstrSta
 
 	strWIDList[u32WidsCount].id = WID_LINKSPEED;
 	strWIDList[u32WidsCount].type = WID_CHAR;
-	strWIDList[u32WidsCount].s32ValueSize = sizeof(char);
+	strWIDList[u32WidsCount].size = sizeof(char);
 	strWIDList[u32WidsCount].ps8WidVal = (s8 *)(&(pstrStatistics->u8LinkSpeed));
 	u32WidsCount++;
 
 	strWIDList[u32WidsCount].id = WID_RSSI;
 	strWIDList[u32WidsCount].type = WID_CHAR;
-	strWIDList[u32WidsCount].s32ValueSize = sizeof(char);
+	strWIDList[u32WidsCount].size = sizeof(char);
 	strWIDList[u32WidsCount].ps8WidVal = (s8 *)(&(pstrStatistics->s8RSSI));
 	u32WidsCount++;
 
 	strWIDList[u32WidsCount].id = WID_SUCCESS_FRAME_COUNT;
 	strWIDList[u32WidsCount].type = WID_INT;
-	strWIDList[u32WidsCount].s32ValueSize = sizeof(u32);
+	strWIDList[u32WidsCount].size = sizeof(u32);
 	strWIDList[u32WidsCount].ps8WidVal = (s8 *)(&(pstrStatistics->u32TxCount));
 	u32WidsCount++;
 
 	strWIDList[u32WidsCount].id = WID_RECEIVED_FRAGMENT_COUNT;
 	strWIDList[u32WidsCount].type = WID_INT;
-	strWIDList[u32WidsCount].s32ValueSize = sizeof(u32);
+	strWIDList[u32WidsCount].size = sizeof(u32);
 	strWIDList[u32WidsCount].ps8WidVal = (s8 *)(&(pstrStatistics->u32RxCount));
 	u32WidsCount++;
 
 	strWIDList[u32WidsCount].id = WID_FAILED_COUNT;
 	strWIDList[u32WidsCount].type = WID_INT;
-	strWIDList[u32WidsCount].s32ValueSize = sizeof(u32);
+	strWIDList[u32WidsCount].size = sizeof(u32);
 	strWIDList[u32WidsCount].ps8WidVal = (s8 *)(&(pstrStatistics->u32TxFailureCount));
 	u32WidsCount++;
 
@@ -3056,8 +3056,8 @@ static s32 Handle_Get_InActiveTime(struct host_if_drv *drvHandler,
 
 	strWID.id = (u16)WID_SET_STA_MAC_INACTIVE_TIME;
 	strWID.type = WID_STR;
-	strWID.s32ValueSize = ETH_ALEN;
-	strWID.ps8WidVal = kmalloc(strWID.s32ValueSize, GFP_KERNEL);
+	strWID.size = ETH_ALEN;
+	strWID.ps8WidVal = kmalloc(strWID.size, GFP_KERNEL);
 
 
 	stamac = strWID.ps8WidVal;
@@ -3079,7 +3079,7 @@ static s32 Handle_Get_InActiveTime(struct host_if_drv *drvHandler,
 	strWID.id = (u16)WID_GET_INACTIVE_TIME;
 	strWID.type = WID_INT;
 	strWID.ps8WidVal = (s8 *)&gu32InactiveTime;
-	strWID.s32ValueSize = sizeof(u32);
+	strWID.size = sizeof(u32);
 
 
 	s32Error = send_config_pkt(GET_CFG, &strWID, 1,
@@ -3123,8 +3123,8 @@ static void Handle_AddBeacon(struct host_if_drv *drvHandler,
 
 	strWID.id = (u16)WID_ADD_BEACON;
 	strWID.type = WID_BIN;
-	strWID.s32ValueSize = pstrSetBeaconParam->u32HeadLen + pstrSetBeaconParam->u32TailLen + 16;
-	strWID.ps8WidVal = kmalloc(strWID.s32ValueSize, GFP_KERNEL);
+	strWID.size = pstrSetBeaconParam->u32HeadLen + pstrSetBeaconParam->u32TailLen + 16;
+	strWID.ps8WidVal = kmalloc(strWID.size, GFP_KERNEL);
 	if (strWID.ps8WidVal == NULL)
 		goto ERRORHANDLER;
 
@@ -3189,7 +3189,7 @@ static void Handle_DelBeacon(struct host_if_drv *drvHandler)
 
 	strWID.id = (u16)WID_DEL_BEACON;
 	strWID.type = WID_CHAR;
-	strWID.s32ValueSize = sizeof(char);
+	strWID.size = sizeof(char);
 	strWID.ps8WidVal = &gu8DelBcn;
 
 	if (strWID.ps8WidVal == NULL)
@@ -3283,9 +3283,9 @@ static void Handle_AddStation(struct host_if_drv *drvHandler,
 	PRINT_D(HOSTINF_DBG, "Handling add station\n");
 	strWID.id = (u16)WID_ADD_STA;
 	strWID.type = WID_BIN;
-	strWID.s32ValueSize = WILC_ADD_STA_LENGTH + pstrStationParam->u8NumRates;
+	strWID.size = WILC_ADD_STA_LENGTH + pstrStationParam->u8NumRates;
 
-	strWID.ps8WidVal = kmalloc(strWID.s32ValueSize, GFP_KERNEL);
+	strWID.ps8WidVal = kmalloc(strWID.size, GFP_KERNEL);
 	if (strWID.ps8WidVal == NULL)
 		goto ERRORHANDLER;
 
@@ -3325,7 +3325,7 @@ static void Handle_DelAllSta(struct host_if_drv *drvHandler,
 
 	strWID.id = (u16)WID_DEL_ALL_STA;
 	strWID.type = WID_STR;
-	strWID.s32ValueSize = (pstrDelAllStaParam->u8Num_AssocSta * ETH_ALEN) + 1;
+	strWID.size = (pstrDelAllStaParam->u8Num_AssocSta * ETH_ALEN) + 1;
 
 	PRINT_D(HOSTINF_DBG, "Handling delete station\n");
 
@@ -3378,11 +3378,11 @@ static void Handle_DelStation(struct host_if_drv *drvHandler,
 
 	strWID.id = (u16)WID_REMOVE_STA;
 	strWID.type = WID_BIN;
-	strWID.s32ValueSize = ETH_ALEN;
+	strWID.size = ETH_ALEN;
 
 	PRINT_D(HOSTINF_DBG, "Handling delete station\n");
 
-	strWID.ps8WidVal = kmalloc(strWID.s32ValueSize, GFP_KERNEL);
+	strWID.ps8WidVal = kmalloc(strWID.size, GFP_KERNEL);
 	if (strWID.ps8WidVal == NULL)
 		goto ERRORHANDLER;
 
@@ -3420,10 +3420,10 @@ static void Handle_EditStation(struct host_if_drv *drvHandler,
 
 	strWID.id = (u16)WID_EDIT_STA;
 	strWID.type = WID_BIN;
-	strWID.s32ValueSize = WILC_ADD_STA_LENGTH + pstrStationParam->u8NumRates;
+	strWID.size = WILC_ADD_STA_LENGTH + pstrStationParam->u8NumRates;
 
 	PRINT_D(HOSTINF_DBG, "Handling edit station\n");
-	strWID.ps8WidVal = kmalloc(strWID.s32ValueSize, GFP_KERNEL);
+	strWID.ps8WidVal = kmalloc(strWID.size, GFP_KERNEL);
 	if (strWID.ps8WidVal == NULL)
 		goto ERRORHANDLER;
 
@@ -3493,8 +3493,8 @@ static int Handle_RemainOnChan(struct host_if_drv *drvHandler,
 	u8remain_on_chan_flag = true;
 	strWID.id = (u16)WID_REMAIN_ON_CHAN;
 	strWID.type = WID_STR;
-	strWID.s32ValueSize = 2;
-	strWID.ps8WidVal = kmalloc(strWID.s32ValueSize, GFP_KERNEL);
+	strWID.size = 2;
+	strWID.ps8WidVal = kmalloc(strWID.size, GFP_KERNEL);
 
 	if (strWID.ps8WidVal == NULL) {
 		s32Error = -ENOMEM;
@@ -3561,7 +3561,7 @@ static int Handle_RegisterFrame(struct host_if_drv *drvHandler,
 	memcpy(pu8CurrByte, &(pstrHostIfRegisterFrame->u16FrameType), sizeof(u16));
 
 
-	strWID.s32ValueSize = sizeof(u16) + 2;
+	strWID.size = sizeof(u16) + 2;
 
 
 	/*Sending Cfg*/
@@ -3602,8 +3602,8 @@ static u32 Handle_ListenStateExpired(struct host_if_drv *drvHandler,
 		u8remain_on_chan_flag = false;
 		strWID.id = (u16)WID_REMAIN_ON_CHAN;
 		strWID.type = WID_STR;
-		strWID.s32ValueSize = 2;
-		strWID.ps8WidVal = kmalloc(strWID.s32ValueSize, GFP_KERNEL);
+		strWID.size = 2;
+		strWID.ps8WidVal = kmalloc(strWID.size, GFP_KERNEL);
 
 		if (strWID.ps8WidVal == NULL)
 			PRINT_ER("Failed to allocate memory\n");
@@ -3688,7 +3688,7 @@ static void Handle_PowerManagement(struct host_if_drv *drvHandler,
 		s8PowerMode = NO_POWERSAVE;
 	PRINT_D(HOSTINF_DBG, "Handling power mgmt to %d\n", s8PowerMode);
 	strWID.ps8WidVal = &s8PowerMode;
-	strWID.s32ValueSize = sizeof(char);
+	strWID.size = sizeof(char);
 
 	PRINT_D(HOSTINF_DBG, "Handling Power Management\n");
 
@@ -3719,8 +3719,8 @@ static void Handle_SetMulticastFilter(struct host_if_drv *drvHandler,
 
 	strWID.id = (u16)WID_SETUP_MULTICAST_FILTER;
 	strWID.type = WID_BIN;
-	strWID.s32ValueSize = sizeof(struct set_multicast) + ((strHostIfSetMulti->u32count) * ETH_ALEN);
-	strWID.ps8WidVal = kmalloc(strWID.s32ValueSize, GFP_KERNEL);
+	strWID.size = sizeof(struct set_multicast) + ((strHostIfSetMulti->u32count) * ETH_ALEN);
+	strWID.ps8WidVal = kmalloc(strWID.size, GFP_KERNEL);
 	if (strWID.ps8WidVal == NULL)
 		goto ERRORHANDLER;
 
@@ -3779,7 +3779,7 @@ static s32 Handle_AddBASession(struct host_if_drv *drvHandler,
 	strWID.id = (u16)WID_11E_P_ACTION_REQ;
 	strWID.type = WID_STR;
 	strWID.ps8WidVal = kmalloc(BLOCK_ACK_REQ_SIZE, GFP_KERNEL);
-	strWID.s32ValueSize = BLOCK_ACK_REQ_SIZE;
+	strWID.size = BLOCK_ACK_REQ_SIZE;
 	ptr = strWID.ps8WidVal;
 	/* *ptr++ = 0x14; */
 	*ptr++ = 0x14;
@@ -3812,7 +3812,7 @@ static s32 Handle_AddBASession(struct host_if_drv *drvHandler,
 
 	strWID.id = (u16)WID_11E_P_ACTION_REQ;
 	strWID.type = WID_STR;
-	strWID.s32ValueSize = 15;
+	strWID.size = 15;
 	ptr = strWID.ps8WidVal;
 	/* *ptr++ = 0x14; */
 	*ptr++ = 15;
@@ -3865,7 +3865,7 @@ static s32 Handle_DelAllRxBASessions(struct host_if_drv *drvHandler,
 	strWID.id = (u16)WID_DEL_ALL_RX_BA;
 	strWID.type = WID_STR;
 	strWID.ps8WidVal = kmalloc(BLOCK_ACK_REQ_SIZE, GFP_KERNEL);
-	strWID.s32ValueSize = BLOCK_ACK_REQ_SIZE;
+	strWID.size = BLOCK_ACK_REQ_SIZE;
 	ptr = strWID.ps8WidVal;
 	*ptr++ = 0x14;
 	*ptr++ = 0x3;
@@ -4164,7 +4164,7 @@ s32 host_int_remove_key(struct host_if_drv *hWFIDrv, const u8 *pu8StaAddress)
 	strWID.id = (u16)WID_REMOVE_KEY;
 	strWID.type = WID_STR;
 	strWID.ps8WidVal	= (s8 *)pu8StaAddress;
-	strWID.s32ValueSize = 6;
+	strWID.size = 6;
 
 	return 0;
 }
@@ -4680,7 +4680,7 @@ s32 host_int_get_pmkid_info(struct host_if_drv *hWFIDrv, u8 *pu8PmkidInfoArray,
 
 	strWID.id = (u16)WID_PMKID_INFO;
 	strWID.type = WID_STR;
-	strWID.s32ValueSize = u32PmkidInfoLen;
+	strWID.size = u32PmkidInfoLen;
 	strWID.ps8WidVal = pu8PmkidInfoArray;
 
 	return 0;
@@ -4710,7 +4710,7 @@ s32 host_int_set_RSNAConfigPSKPassPhrase(struct host_if_drv *hWFIDrv, u8 *pu8Pas
 		strWID.id = (u16)WID_11I_PSK;
 		strWID.type = WID_STR;
 		strWID.ps8WidVal	= pu8PassPhrase;
-		strWID.s32ValueSize = u8Psklength;
+		strWID.size = u8Psklength;
 	}
 
 	return 0;
@@ -4802,7 +4802,7 @@ s32 host_int_get_RSNAConfigPSKPassPhrase(struct host_if_drv *hWFIDrv,
 
 	strWID.id = (u16)WID_11I_PSK;
 	strWID.type = WID_STR;
-	strWID.s32ValueSize = u8Psklength;
+	strWID.size = u8Psklength;
 	strWID.ps8WidVal	= pu8PassPhrase;
 
 	return 0;
@@ -4830,7 +4830,7 @@ s32 host_int_set_start_scan_req(struct host_if_drv *hWFIDrv, u8 scanSource)
 	strWID.id = (u16)WID_START_SCAN_REQ;
 	strWID.type = WID_CHAR;
 	strWID.ps8WidVal = (s8 *)&scanSource;
-	strWID.s32ValueSize = sizeof(char);
+	strWID.size = sizeof(char);
 
 	return 0;
 }
@@ -4858,7 +4858,7 @@ s32 host_int_get_start_scan_req(struct host_if_drv *hWFIDrv, u8 *pu8ScanSource)
 	strWID.id = (u16)WID_START_SCAN_REQ;
 	strWID.type = WID_CHAR;
 	strWID.ps8WidVal = (s8 *)pu8ScanSource;
-	strWID.s32ValueSize = sizeof(char);
+	strWID.size = sizeof(char);
 
 	return 0;
 }
@@ -5055,7 +5055,7 @@ s32 host_int_disconnect_station(struct host_if_drv *hWFIDrv, u8 assoc_id)
 	strWID.id = (u16)WID_DISCONNECT;
 	strWID.type = WID_CHAR;
 	strWID.ps8WidVal = (s8 *)&assoc_id;
-	strWID.s32ValueSize = sizeof(char);
+	strWID.size = sizeof(char);
 
 	return 0;
 }
@@ -5094,7 +5094,7 @@ s32 host_int_get_assoc_req_info(struct host_if_drv *hWFIDrv, u8 *pu8AssocReqInfo
 	strWID.id = (u16)WID_ASSOC_REQ_INFO;
 	strWID.type = WID_STR;
 	strWID.ps8WidVal = pu8AssocReqInfo;
-	strWID.s32ValueSize = u32AssocReqInfoLen;
+	strWID.size = u32AssocReqInfoLen;
 
 	return 0;
 }
@@ -5125,7 +5125,7 @@ s32 host_int_get_assoc_res_info(struct host_if_drv *hWFIDrv, u8 *pu8AssocRespInf
 	strWID.id = (u16)WID_ASSOC_RES_INFO;
 	strWID.type = WID_STR;
 	strWID.ps8WidVal = pu8AssocRespInfo;
-	strWID.s32ValueSize = u32MaxAssocRespInfoLen;
+	strWID.size = u32MaxAssocRespInfoLen;
 
 
 	/* Sending Configuration packet */
@@ -5136,7 +5136,7 @@ s32 host_int_get_assoc_res_info(struct host_if_drv *hWFIDrv, u8 *pu8AssocRespInf
 		PRINT_ER("Failed to send association response config packet\n");
 		return -EINVAL;
 	} else {
-		*pu32RcvdAssocRespInfoLen = strWID.s32ValueSize;
+		*pu32RcvdAssocRespInfoLen = strWID.size;
 	}
 
 	return s32Error;
@@ -5165,7 +5165,7 @@ s32 host_int_get_rx_power_level(struct host_if_drv *hWFIDrv, u8 *pu8RxPowerLevel
 	strWID.id = (u16)WID_RX_POWER_LEVEL;
 	strWID.type = WID_STR;
 	strWID.ps8WidVal = pu8RxPowerLevel;
-	strWID.s32ValueSize = u32RxPowerLevelLen;
+	strWID.size = u32RxPowerLevelLen;
 
 	return 0;
 }
@@ -5391,7 +5391,7 @@ s32 host_int_test_get_int_wid(struct host_if_drv *hWFIDrv, u32 *pu32TestMemAddr)
 	strWID.id = (u16)WID_MEMORY_ADDRESS;
 	strWID.type = WID_INT;
 	strWID.ps8WidVal = (s8 *)pu32TestMemAddr;
-	strWID.s32ValueSize = sizeof(u32);
+	strWID.size = sizeof(u32);
 
 	s32Error = send_config_pkt(GET_CFG, &strWID, 1,
 				   get_id_from_handler(pstrWFIDrv));
-- 
1.9.1

