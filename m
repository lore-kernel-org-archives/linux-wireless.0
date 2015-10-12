Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:12263 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751872AbbJLH5a (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Oct 2015 03:57:30 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH V2 09/41] staging: wilc1000: rename the member variable, enuWIDtype of wid
Date: Mon, 12 Oct 2015 16:55:43 +0900
Message-ID: <1444636575-2486-9-git-send-email-tony.cho@atmel.com> (sfid-20151012_095735_796042_B6BFC25B)
In-Reply-To: <1444636575-2486-1-git-send-email-tony.cho@atmel.com>
References: <1444636575-2486-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames enuWIDtype of struct wid to type.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/coreconfigurator.h |   2 +-
 drivers/staging/wilc1000/host_interface.c   | 184 ++++++++++++++--------------
 2 files changed, 93 insertions(+), 93 deletions(-)

diff --git a/drivers/staging/wilc1000/coreconfigurator.h b/drivers/staging/wilc1000/coreconfigurator.h
index 02faf58..27c1a86 100644
--- a/drivers/staging/wilc1000/coreconfigurator.h
+++ b/drivers/staging/wilc1000/coreconfigurator.h
@@ -72,7 +72,7 @@ typedef enum {
 
 struct wid {
 	u16 u16WIDid;
-	enum WID_TYPE enuWIDtype;
+	enum WID_TYPE type;
 	s32 s32ValueSize;
 	s8      *ps8WidVal;
 };
diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 25834cd..1e18d50 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -577,7 +577,7 @@ static s32 Handle_SetChannel(struct host_if_drv *drvHandler,
 
 	/*prepare configuration packet*/
 	strWID.u16WIDid = (u16)WID_CURRENT_CHANNEL;
-	strWID.enuWIDtype = WID_CHAR;
+	strWID.type = WID_CHAR;
 	strWID.ps8WidVal = (char *)&(pstrHostIFSetChan->u8SetChan);
 	strWID.s32ValueSize = sizeof(char);
 
@@ -613,7 +613,7 @@ static s32 Handle_SetWfiDrvHandler(struct host_if_drv *drvHandler,
 
 	/*prepare configuration packet*/
 	strWID.u16WIDid = (u16)WID_SET_DRV_HANDLER;
-	strWID.enuWIDtype = WID_INT;
+	strWID.type = WID_INT;
 	strWID.ps8WidVal = (s8 *)&(pstrHostIfSetDrvHandler->u32Address);
 	strWID.s32ValueSize = sizeof(u32);
 
@@ -654,7 +654,7 @@ static s32 Handle_SetOperationMode(struct host_if_drv *drvHandler,
 
 	/*prepare configuration packet*/
 	strWID.u16WIDid = (u16)WID_SET_OPERATION_MODE;
-	strWID.enuWIDtype = WID_INT;
+	strWID.type = WID_INT;
 	strWID.ps8WidVal = (s8 *)&(pstrHostIfSetOperationMode->u32Mode);
 	strWID.s32ValueSize = sizeof(u32);
 
@@ -703,7 +703,7 @@ s32 Handle_set_IPAddress(struct host_if_drv *drvHandler, u8 *pu8IPAddr, u8 idx)
 
 	/*prepare configuration packet*/
 	strWID.u16WIDid = (u16)WID_IP_ADDRESS;
-	strWID.enuWIDtype = WID_STR;
+	strWID.type = WID_STR;
 	strWID.ps8WidVal = (u8 *)pu8IPAddr;
 	strWID.s32ValueSize = IP_ALEN;
 
@@ -742,7 +742,7 @@ s32 Handle_get_IPAddress(struct host_if_drv *drvHandler, u8 *pu8IPAddr, u8 idx)
 
 	/*prepare configuration packet*/
 	strWID.u16WIDid = (u16)WID_IP_ADDRESS;
-	strWID.enuWIDtype = WID_STR;
+	strWID.type = WID_STR;
 	strWID.ps8WidVal = kmalloc(IP_ALEN, GFP_KERNEL);
 	strWID.s32ValueSize = IP_ALEN;
 
@@ -798,7 +798,7 @@ static s32 Handle_SetMacAddress(struct host_if_drv *drvHandler,
 
 	/*prepare configuration packet*/
 	strWID.u16WIDid = (u16)WID_MAC_ADDR;
-	strWID.enuWIDtype = WID_STR;
+	strWID.type = WID_STR;
 	strWID.ps8WidVal = mac_buf;
 	strWID.s32ValueSize = ETH_ALEN;
 	PRINT_D(GENERIC_DBG, "mac addr = :%pM\n", strWID.ps8WidVal);
@@ -833,7 +833,7 @@ static s32 Handle_GetMacAddress(struct host_if_drv *drvHandler,
 
 	/*prepare configuration packet*/
 	strWID.u16WIDid = (u16)WID_MAC_ADDR;
-	strWID.enuWIDtype = WID_STR;
+	strWID.type = WID_STR;
 	strWID.ps8WidVal = pstrHostIfGetMacAddress->u8MacAddress;
 	strWID.s32ValueSize = ETH_ALEN;
 
@@ -883,7 +883,7 @@ static s32 Handle_CfgParam(struct host_if_drv *drvHandler,
 		if (strHostIFCfgParamAttr->pstrCfgParamVal.bss_type < 6) {
 			strWIDList[u8WidCnt].u16WIDid = WID_BSS_TYPE;
 			strWIDList[u8WidCnt].ps8WidVal = (s8 *)&strHostIFCfgParamAttr->pstrCfgParamVal.bss_type;
-			strWIDList[u8WidCnt].enuWIDtype = WID_CHAR;
+			strWIDList[u8WidCnt].type = WID_CHAR;
 			strWIDList[u8WidCnt].s32ValueSize = sizeof(char);
 			pstrWFIDrv->strCfgValues.bss_type = (u8)strHostIFCfgParamAttr->pstrCfgParamVal.bss_type;
 		} else {
@@ -903,7 +903,7 @@ static s32 Handle_CfgParam(struct host_if_drv *drvHandler,
 		if ((strHostIFCfgParamAttr->pstrCfgParamVal.auth_type) == 1 || (strHostIFCfgParamAttr->pstrCfgParamVal.auth_type) == 2 || (strHostIFCfgParamAttr->pstrCfgParamVal.auth_type) == 5) {
 			strWIDList[u8WidCnt].u16WIDid = WID_AUTH_TYPE;
 			strWIDList[u8WidCnt].ps8WidVal = (s8 *)&strHostIFCfgParamAttr->pstrCfgParamVal.auth_type;
-			strWIDList[u8WidCnt].enuWIDtype = WID_CHAR;
+			strWIDList[u8WidCnt].type = WID_CHAR;
 			strWIDList[u8WidCnt].s32ValueSize = sizeof(char);
 			pstrWFIDrv->strCfgValues.auth_type = (u8)strHostIFCfgParamAttr->pstrCfgParamVal.auth_type;
 		} else {
@@ -918,7 +918,7 @@ static s32 Handle_CfgParam(struct host_if_drv *drvHandler,
 		if (strHostIFCfgParamAttr->pstrCfgParamVal.auth_timeout > 0 && strHostIFCfgParamAttr->pstrCfgParamVal.auth_timeout < 65536) {
 			strWIDList[u8WidCnt].u16WIDid = WID_AUTH_TIMEOUT;
 			strWIDList[u8WidCnt].ps8WidVal = (s8 *)&strHostIFCfgParamAttr->pstrCfgParamVal.auth_timeout;
-			strWIDList[u8WidCnt].enuWIDtype = WID_SHORT;
+			strWIDList[u8WidCnt].type = WID_SHORT;
 			strWIDList[u8WidCnt].s32ValueSize = sizeof(u16);
 			pstrWFIDrv->strCfgValues.auth_timeout = strHostIFCfgParamAttr->pstrCfgParamVal.auth_timeout;
 		} else {
@@ -939,7 +939,7 @@ static s32 Handle_CfgParam(struct host_if_drv *drvHandler,
 		if (strHostIFCfgParamAttr->pstrCfgParamVal.power_mgmt_mode < 5) {
 			strWIDList[u8WidCnt].u16WIDid = WID_POWER_MANAGEMENT;
 			strWIDList[u8WidCnt].ps8WidVal = (s8 *)&strHostIFCfgParamAttr->pstrCfgParamVal.power_mgmt_mode;
-			strWIDList[u8WidCnt].enuWIDtype = WID_CHAR;
+			strWIDList[u8WidCnt].type = WID_CHAR;
 			strWIDList[u8WidCnt].s32ValueSize = sizeof(char);
 			pstrWFIDrv->strCfgValues.power_mgmt_mode = (u8)strHostIFCfgParamAttr->pstrCfgParamVal.power_mgmt_mode;
 		} else {
@@ -954,7 +954,7 @@ static s32 Handle_CfgParam(struct host_if_drv *drvHandler,
 		if ((strHostIFCfgParamAttr->pstrCfgParamVal.short_retry_limit > 0) && (strHostIFCfgParamAttr->pstrCfgParamVal.short_retry_limit < 256))	{
 			strWIDList[u8WidCnt].u16WIDid = WID_SHORT_RETRY_LIMIT;
 			strWIDList[u8WidCnt].ps8WidVal = (s8 *)&strHostIFCfgParamAttr->pstrCfgParamVal.short_retry_limit;
-			strWIDList[u8WidCnt].enuWIDtype = WID_SHORT;
+			strWIDList[u8WidCnt].type = WID_SHORT;
 			strWIDList[u8WidCnt].s32ValueSize = sizeof(u16);
 			pstrWFIDrv->strCfgValues.short_retry_limit = strHostIFCfgParamAttr->pstrCfgParamVal.short_retry_limit;
 		} else {
@@ -970,7 +970,7 @@ static s32 Handle_CfgParam(struct host_if_drv *drvHandler,
 			strWIDList[u8WidCnt].u16WIDid = WID_LONG_RETRY_LIMIT;
 			strWIDList[u8WidCnt].ps8WidVal = (s8 *)&strHostIFCfgParamAttr->pstrCfgParamVal.long_retry_limit;
 
-			strWIDList[u8WidCnt].enuWIDtype = WID_SHORT;
+			strWIDList[u8WidCnt].type = WID_SHORT;
 			strWIDList[u8WidCnt].s32ValueSize = sizeof(u16);
 			pstrWFIDrv->strCfgValues.long_retry_limit = strHostIFCfgParamAttr->pstrCfgParamVal.long_retry_limit;
 		} else {
@@ -985,7 +985,7 @@ static s32 Handle_CfgParam(struct host_if_drv *drvHandler,
 		if (strHostIFCfgParamAttr->pstrCfgParamVal.frag_threshold > 255 && strHostIFCfgParamAttr->pstrCfgParamVal.frag_threshold < 7937) {
 			strWIDList[u8WidCnt].u16WIDid = WID_FRAG_THRESHOLD;
 			strWIDList[u8WidCnt].ps8WidVal = (s8 *)&strHostIFCfgParamAttr->pstrCfgParamVal.frag_threshold;
-			strWIDList[u8WidCnt].enuWIDtype = WID_SHORT;
+			strWIDList[u8WidCnt].type = WID_SHORT;
 			strWIDList[u8WidCnt].s32ValueSize = sizeof(u16);
 			pstrWFIDrv->strCfgValues.frag_threshold = strHostIFCfgParamAttr->pstrCfgParamVal.frag_threshold;
 		} else {
@@ -1000,7 +1000,7 @@ static s32 Handle_CfgParam(struct host_if_drv *drvHandler,
 		if (strHostIFCfgParamAttr->pstrCfgParamVal.rts_threshold > 255 && strHostIFCfgParamAttr->pstrCfgParamVal.rts_threshold < 65536)	{
 			strWIDList[u8WidCnt].u16WIDid = WID_RTS_THRESHOLD;
 			strWIDList[u8WidCnt].ps8WidVal = (s8 *)&strHostIFCfgParamAttr->pstrCfgParamVal.rts_threshold;
-			strWIDList[u8WidCnt].enuWIDtype = WID_SHORT;
+			strWIDList[u8WidCnt].type = WID_SHORT;
 			strWIDList[u8WidCnt].s32ValueSize = sizeof(u16);
 			pstrWFIDrv->strCfgValues.rts_threshold = strHostIFCfgParamAttr->pstrCfgParamVal.rts_threshold;
 		} else {
@@ -1019,7 +1019,7 @@ static s32 Handle_CfgParam(struct host_if_drv *drvHandler,
 		if (strHostIFCfgParamAttr->pstrCfgParamVal.preamble_type < 3) {
 			strWIDList[u8WidCnt].u16WIDid = WID_PREAMBLE;
 			strWIDList[u8WidCnt].ps8WidVal = (s8 *)&strHostIFCfgParamAttr->pstrCfgParamVal.preamble_type;
-			strWIDList[u8WidCnt].enuWIDtype = WID_CHAR;
+			strWIDList[u8WidCnt].type = WID_CHAR;
 			strWIDList[u8WidCnt].s32ValueSize = sizeof(char);
 			pstrWFIDrv->strCfgValues.preamble_type = strHostIFCfgParamAttr->pstrCfgParamVal.preamble_type;
 		} else {
@@ -1033,7 +1033,7 @@ static s32 Handle_CfgParam(struct host_if_drv *drvHandler,
 		if (strHostIFCfgParamAttr->pstrCfgParamVal.short_slot_allowed < 2) {
 			strWIDList[u8WidCnt].u16WIDid = WID_SHORT_SLOT_ALLOWED;
 			strWIDList[u8WidCnt].ps8WidVal = (s8 *)&strHostIFCfgParamAttr->pstrCfgParamVal.short_slot_allowed;
-			strWIDList[u8WidCnt].enuWIDtype = WID_CHAR;
+			strWIDList[u8WidCnt].type = WID_CHAR;
 			strWIDList[u8WidCnt].s32ValueSize = sizeof(char);
 			pstrWFIDrv->strCfgValues.short_slot_allowed = (u8)strHostIFCfgParamAttr->pstrCfgParamVal.short_slot_allowed;
 		} else {
@@ -1051,7 +1051,7 @@ static s32 Handle_CfgParam(struct host_if_drv *drvHandler,
 		if (strHostIFCfgParamAttr->pstrCfgParamVal.txop_prot_disabled < 2) {
 			strWIDList[u8WidCnt].u16WIDid = WID_11N_TXOP_PROT_DISABLE;
 			strWIDList[u8WidCnt].ps8WidVal = (s8 *)&strHostIFCfgParamAttr->pstrCfgParamVal.txop_prot_disabled;
-			strWIDList[u8WidCnt].enuWIDtype = WID_CHAR;
+			strWIDList[u8WidCnt].type = WID_CHAR;
 			strWIDList[u8WidCnt].s32ValueSize = sizeof(char);
 			pstrWFIDrv->strCfgValues.txop_prot_disabled = (u8)strHostIFCfgParamAttr->pstrCfgParamVal.txop_prot_disabled;
 		} else {
@@ -1066,7 +1066,7 @@ static s32 Handle_CfgParam(struct host_if_drv *drvHandler,
 		if (strHostIFCfgParamAttr->pstrCfgParamVal.beacon_interval > 0 && strHostIFCfgParamAttr->pstrCfgParamVal.beacon_interval < 65536) {
 			strWIDList[u8WidCnt].u16WIDid = WID_BEACON_INTERVAL;
 			strWIDList[u8WidCnt].ps8WidVal = (s8 *)&strHostIFCfgParamAttr->pstrCfgParamVal.beacon_interval;
-			strWIDList[u8WidCnt].enuWIDtype = WID_SHORT;
+			strWIDList[u8WidCnt].type = WID_SHORT;
 			strWIDList[u8WidCnt].s32ValueSize = sizeof(u16);
 			pstrWFIDrv->strCfgValues.beacon_interval = strHostIFCfgParamAttr->pstrCfgParamVal.beacon_interval;
 		} else {
@@ -1081,7 +1081,7 @@ static s32 Handle_CfgParam(struct host_if_drv *drvHandler,
 		if (strHostIFCfgParamAttr->pstrCfgParamVal.dtim_period > 0 && strHostIFCfgParamAttr->pstrCfgParamVal.dtim_period < 256) {
 			strWIDList[u8WidCnt].u16WIDid = WID_DTIM_PERIOD;
 			strWIDList[u8WidCnt].ps8WidVal = (s8 *)&strHostIFCfgParamAttr->pstrCfgParamVal.dtim_period;
-			strWIDList[u8WidCnt].enuWIDtype = WID_CHAR;
+			strWIDList[u8WidCnt].type = WID_CHAR;
 			strWIDList[u8WidCnt].s32ValueSize = sizeof(char);
 			pstrWFIDrv->strCfgValues.dtim_period = strHostIFCfgParamAttr->pstrCfgParamVal.dtim_period;
 		} else {
@@ -1100,7 +1100,7 @@ static s32 Handle_CfgParam(struct host_if_drv *drvHandler,
 		if (strHostIFCfgParamAttr->pstrCfgParamVal.site_survey_enabled < 3) {
 			strWIDList[u8WidCnt].u16WIDid = WID_SITE_SURVEY;
 			strWIDList[u8WidCnt].ps8WidVal = (s8 *)&strHostIFCfgParamAttr->pstrCfgParamVal.site_survey_enabled;
-			strWIDList[u8WidCnt].enuWIDtype = WID_CHAR;
+			strWIDList[u8WidCnt].type = WID_CHAR;
 			strWIDList[u8WidCnt].s32ValueSize = sizeof(char);
 			pstrWFIDrv->strCfgValues.site_survey_enabled = (u8)strHostIFCfgParamAttr->pstrCfgParamVal.site_survey_enabled;
 		} else {
@@ -1115,7 +1115,7 @@ static s32 Handle_CfgParam(struct host_if_drv *drvHandler,
 		if (strHostIFCfgParamAttr->pstrCfgParamVal.site_survey_scan_time > 0 && strHostIFCfgParamAttr->pstrCfgParamVal.site_survey_scan_time < 65536) {
 			strWIDList[u8WidCnt].u16WIDid = WID_SITE_SURVEY_SCAN_TIME;
 			strWIDList[u8WidCnt].ps8WidVal = (s8 *)&strHostIFCfgParamAttr->pstrCfgParamVal.site_survey_scan_time;
-			strWIDList[u8WidCnt].enuWIDtype = WID_SHORT;
+			strWIDList[u8WidCnt].type = WID_SHORT;
 			strWIDList[u8WidCnt].s32ValueSize = sizeof(u16);
 			pstrWFIDrv->strCfgValues.site_survey_scan_time = strHostIFCfgParamAttr->pstrCfgParamVal.site_survey_scan_time;
 		} else {
@@ -1130,7 +1130,7 @@ static s32 Handle_CfgParam(struct host_if_drv *drvHandler,
 		if (strHostIFCfgParamAttr->pstrCfgParamVal.active_scan_time > 0 && strHostIFCfgParamAttr->pstrCfgParamVal.active_scan_time < 65536) {
 			strWIDList[u8WidCnt].u16WIDid = WID_ACTIVE_SCAN_TIME;
 			strWIDList[u8WidCnt].ps8WidVal = (s8 *)&strHostIFCfgParamAttr->pstrCfgParamVal.active_scan_time;
-			strWIDList[u8WidCnt].enuWIDtype = WID_SHORT;
+			strWIDList[u8WidCnt].type = WID_SHORT;
 			strWIDList[u8WidCnt].s32ValueSize = sizeof(u16);
 			pstrWFIDrv->strCfgValues.active_scan_time = strHostIFCfgParamAttr->pstrCfgParamVal.active_scan_time;
 		} else {
@@ -1145,7 +1145,7 @@ static s32 Handle_CfgParam(struct host_if_drv *drvHandler,
 		if (strHostIFCfgParamAttr->pstrCfgParamVal.passive_scan_time > 0 && strHostIFCfgParamAttr->pstrCfgParamVal.passive_scan_time < 65536) {
 			strWIDList[u8WidCnt].u16WIDid = WID_PASSIVE_SCAN_TIME;
 			strWIDList[u8WidCnt].ps8WidVal = (s8 *)&strHostIFCfgParamAttr->pstrCfgParamVal.passive_scan_time;
-			strWIDList[u8WidCnt].enuWIDtype = WID_SHORT;
+			strWIDList[u8WidCnt].type = WID_SHORT;
 			strWIDList[u8WidCnt].s32ValueSize = sizeof(u16);
 			pstrWFIDrv->strCfgValues.passive_scan_time = strHostIFCfgParamAttr->pstrCfgParamVal.passive_scan_time;
 		} else {
@@ -1170,7 +1170,7 @@ static s32 Handle_CfgParam(struct host_if_drv *drvHandler,
 		    || curr_tx_rate == MBPS_36 || curr_tx_rate == MBPS_48 || curr_tx_rate == MBPS_54) {
 			strWIDList[u8WidCnt].u16WIDid = WID_CURRENT_TX_RATE;
 			strWIDList[u8WidCnt].ps8WidVal = (s8 *)&curr_tx_rate;
-			strWIDList[u8WidCnt].enuWIDtype = WID_SHORT;
+			strWIDList[u8WidCnt].type = WID_SHORT;
 			strWIDList[u8WidCnt].s32ValueSize = sizeof(u16);
 			pstrWFIDrv->strCfgValues.curr_tx_rate = (u8)curr_tx_rate;
 		} else {
@@ -1256,7 +1256,7 @@ static s32 Handle_Scan(struct host_if_drv *drvHandler,
 	pstrWFIDrv->strWILC_UsrScanReq.u32RcvdChCount = 0;
 
 	strWIDList[u32WidsCount].u16WIDid = (u16)WID_SSID_PROBE_REQ;
-	strWIDList[u32WidsCount].enuWIDtype = WID_STR;
+	strWIDList[u32WidsCount].type = WID_STR;
 
 	for (i = 0; i < pstrHostIFscanAttr->strHiddenNetwork.u8ssidnum; i++)
 		valuesize += ((pstrHostIFscanAttr->strHiddenNetwork.pstrHiddenNetworkInfo[i].u8ssidlen) + 1);
@@ -1287,7 +1287,7 @@ static s32 Handle_Scan(struct host_if_drv *drvHandler,
 	{
 		/* IEs to be inserted in Probe Request */
 		strWIDList[u32WidsCount].u16WIDid = WID_INFO_ELEMENT_PROBE;
-		strWIDList[u32WidsCount].enuWIDtype = WID_BIN_DATA;
+		strWIDList[u32WidsCount].type = WID_BIN_DATA;
 		strWIDList[u32WidsCount].ps8WidVal = pstrHostIFscanAttr->pu8IEs;
 		strWIDList[u32WidsCount].s32ValueSize = pstrHostIFscanAttr->IEsLen;
 		u32WidsCount++;
@@ -1295,14 +1295,14 @@ static s32 Handle_Scan(struct host_if_drv *drvHandler,
 
 	/*Scan Type*/
 	strWIDList[u32WidsCount].u16WIDid = WID_SCAN_TYPE;
-	strWIDList[u32WidsCount].enuWIDtype = WID_CHAR;
+	strWIDList[u32WidsCount].type = WID_CHAR;
 	strWIDList[u32WidsCount].s32ValueSize = sizeof(char);
 	strWIDList[u32WidsCount].ps8WidVal = (s8 *)(&(pstrHostIFscanAttr->u8ScanType));
 	u32WidsCount++;
 
 	/*list of channels to be scanned*/
 	strWIDList[u32WidsCount].u16WIDid = WID_SCAN_CHANNEL_LIST;
-	strWIDList[u32WidsCount].enuWIDtype = WID_BIN_DATA;
+	strWIDList[u32WidsCount].type = WID_BIN_DATA;
 
 	if (pstrHostIFscanAttr->pu8ChnlFreqList != NULL && pstrHostIFscanAttr->u8ChnlListLen > 0) {
 		int i;
@@ -1319,7 +1319,7 @@ static s32 Handle_Scan(struct host_if_drv *drvHandler,
 
 	/*Scan Request*/
 	strWIDList[u32WidsCount].u16WIDid = WID_START_SCAN_REQ;
-	strWIDList[u32WidsCount].enuWIDtype = WID_CHAR;
+	strWIDList[u32WidsCount].type = WID_CHAR;
 	strWIDList[u32WidsCount].s32ValueSize = sizeof(char);
 	strWIDList[u32WidsCount].ps8WidVal = (s8 *)(&(pstrHostIFscanAttr->u8ScanSource));
 	u32WidsCount++;
@@ -1402,7 +1402,7 @@ static s32 Handle_ScanDone(struct host_if_drv *drvHandler, tenuScanEvent enuEven
 		PRINT_D(GENERIC_DBG, "Abort running scan\n");
 		u8abort_running_scan = 1;
 		strWID.u16WIDid	= (u16)WID_ABORT_RUNNING_SCAN;
-		strWID.enuWIDtype	= WID_CHAR;
+		strWID.type = WID_CHAR;
 		strWID.ps8WidVal = (s8 *)&u8abort_running_scan;
 		strWID.s32ValueSize = sizeof(char);
 
@@ -1498,19 +1498,19 @@ static s32 Handle_Connect(struct host_if_drv *drvHandler,
 	pstrWFIDrv->strWILC_UsrConnReq.u32UserConnectPvoid = pstrHostIFconnectAttr->pvUserArg;
 
 	strWIDList[u32WidsCount].u16WIDid = WID_SUCCESS_FRAME_COUNT;
-	strWIDList[u32WidsCount].enuWIDtype = WID_INT;
+	strWIDList[u32WidsCount].type = WID_INT;
 	strWIDList[u32WidsCount].s32ValueSize = sizeof(u32);
 	strWIDList[u32WidsCount].ps8WidVal = (s8 *)(&(dummyval));
 	u32WidsCount++;
 
 	strWIDList[u32WidsCount].u16WIDid = WID_RECEIVED_FRAGMENT_COUNT;
-	strWIDList[u32WidsCount].enuWIDtype = WID_INT;
+	strWIDList[u32WidsCount].type = WID_INT;
 	strWIDList[u32WidsCount].s32ValueSize = sizeof(u32);
 	strWIDList[u32WidsCount].ps8WidVal = (s8 *)(&(dummyval));
 	u32WidsCount++;
 
 	strWIDList[u32WidsCount].u16WIDid = WID_FAILED_COUNT;
-	strWIDList[u32WidsCount].enuWIDtype = WID_INT;
+	strWIDList[u32WidsCount].type = WID_INT;
 	strWIDList[u32WidsCount].s32ValueSize = sizeof(u32);
 	strWIDList[u32WidsCount].ps8WidVal = (s8 *)(&(dummyval));
 	u32WidsCount++;
@@ -1520,7 +1520,7 @@ static s32 Handle_Connect(struct host_if_drv *drvHandler,
 	{
 		/* IEs to be inserted in Association Request */
 		strWIDList[u32WidsCount].u16WIDid = WID_INFO_ELEMENT_ASSOCIATE;
-		strWIDList[u32WidsCount].enuWIDtype = WID_BIN_DATA;
+		strWIDList[u32WidsCount].type = WID_BIN_DATA;
 		strWIDList[u32WidsCount].ps8WidVal = pstrWFIDrv->strWILC_UsrConnReq.pu8ConnReqIEs;
 		strWIDList[u32WidsCount].s32ValueSize = pstrWFIDrv->strWILC_UsrConnReq.ConnReqIEsLen;
 		u32WidsCount++;
@@ -1534,7 +1534,7 @@ static s32 Handle_Connect(struct host_if_drv *drvHandler,
 		}
 	}
 	strWIDList[u32WidsCount].u16WIDid = (u16)WID_11I_MODE;
-	strWIDList[u32WidsCount].enuWIDtype = WID_CHAR;
+	strWIDList[u32WidsCount].type = WID_CHAR;
 	strWIDList[u32WidsCount].s32ValueSize = sizeof(char);
 	strWIDList[u32WidsCount].ps8WidVal = (s8 *)(&(pstrWFIDrv->strWILC_UsrConnReq.u8security));
 	u32WidsCount++;
@@ -1546,7 +1546,7 @@ static s32 Handle_Connect(struct host_if_drv *drvHandler,
 
 
 	strWIDList[u32WidsCount].u16WIDid = (u16)WID_AUTH_TYPE;
-	strWIDList[u32WidsCount].enuWIDtype = WID_CHAR;
+	strWIDList[u32WidsCount].type = WID_CHAR;
 	strWIDList[u32WidsCount].s32ValueSize = sizeof(char);
 	strWIDList[u32WidsCount].ps8WidVal = (s8 *)(&pstrWFIDrv->strWILC_UsrConnReq.tenuAuth_type);
 	u32WidsCount++;
@@ -1567,7 +1567,7 @@ static s32 Handle_Connect(struct host_if_drv *drvHandler,
 		pstrWFIDrv->strWILC_UsrConnReq.pu8ssid, pstrHostIFconnectAttr->u8channel);
 
 	strWIDList[u32WidsCount].u16WIDid = (u16)WID_JOIN_REQ_EXTENDED;
-	strWIDList[u32WidsCount].enuWIDtype = WID_STR;
+	strWIDList[u32WidsCount].type = WID_STR;
 
 	/*Sending NoA attributes during connection*/
 	strWIDList[u32WidsCount].s32ValueSize = 112; /* 79; */
@@ -1814,13 +1814,13 @@ static s32 Handle_FlushConnect(struct host_if_drv *drvHandler)
 
 	/* IEs to be inserted in Association Request */
 	strWIDList[u32WidsCount].u16WIDid = WID_INFO_ELEMENT_ASSOCIATE;
-	strWIDList[u32WidsCount].enuWIDtype = WID_BIN_DATA;
+	strWIDList[u32WidsCount].type = WID_BIN_DATA;
 	strWIDList[u32WidsCount].ps8WidVal = gu8FlushedInfoElemAsoc;
 	strWIDList[u32WidsCount].s32ValueSize = gu32FlushedInfoElemAsocSize;
 	u32WidsCount++;
 
 	strWIDList[u32WidsCount].u16WIDid = (u16)WID_11I_MODE;
-	strWIDList[u32WidsCount].enuWIDtype = WID_CHAR;
+	strWIDList[u32WidsCount].type = WID_CHAR;
 	strWIDList[u32WidsCount].s32ValueSize = sizeof(char);
 	strWIDList[u32WidsCount].ps8WidVal = (s8 *)(&(gu8Flushed11iMode));
 	u32WidsCount++;
@@ -1828,13 +1828,13 @@ static s32 Handle_FlushConnect(struct host_if_drv *drvHandler)
 
 
 	strWIDList[u32WidsCount].u16WIDid = (u16)WID_AUTH_TYPE;
-	strWIDList[u32WidsCount].enuWIDtype = WID_CHAR;
+	strWIDList[u32WidsCount].type = WID_CHAR;
 	strWIDList[u32WidsCount].s32ValueSize = sizeof(char);
 	strWIDList[u32WidsCount].ps8WidVal = (s8 *)(&gu8FlushedAuthType);
 	u32WidsCount++;
 
 	strWIDList[u32WidsCount].u16WIDid = (u16)WID_JOIN_REQ_EXTENDED;
-	strWIDList[u32WidsCount].enuWIDtype = WID_STR;
+	strWIDList[u32WidsCount].type = WID_STR;
 	strWIDList[u32WidsCount].s32ValueSize = gu32FlushedJoinReqSize;
 	strWIDList[u32WidsCount].ps8WidVal = (s8 *)gu8FlushedJoinReq;
 	pu8CurrByte = strWIDList[u32WidsCount].ps8WidVal;
@@ -1919,7 +1919,7 @@ static s32 Handle_ConnectTimeout(struct host_if_drv *drvHandler)
 	/* Here we will notify our firmware also with the Connection failure {through sending to it Cfg packet carrying
 	 *   WID_DISCONNECT} */
 	strWID.u16WIDid = (u16)WID_DISCONNECT;
-	strWID.enuWIDtype = WID_CHAR;
+	strWID.type = WID_CHAR;
 	strWID.ps8WidVal = (s8 *)&u16DummyReasonCode;
 	strWID.s32ValueSize = sizeof(char);
 
@@ -2426,17 +2426,17 @@ static int Handle_Key(struct host_if_drv *drvHandler,
 			PRINT_D(HOSTINF_DBG, "Handling WEP key\n");
 			PRINT_D(GENERIC_DBG, "ID Hostint is %d\n", (pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFwepAttr.u8Wepidx));
 			strWIDList[0].u16WIDid = (u16)WID_11I_MODE;
-			strWIDList[0].enuWIDtype = WID_CHAR;
+			strWIDList[0].type = WID_CHAR;
 			strWIDList[0].s32ValueSize = sizeof(char);
 			strWIDList[0].ps8WidVal = (s8 *)(&(pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFwepAttr.u8mode));
 
 			strWIDList[1].u16WIDid     = WID_AUTH_TYPE;
-			strWIDList[1].enuWIDtype  = WID_CHAR;
+			strWIDList[1].type = WID_CHAR;
 			strWIDList[1].s32ValueSize = sizeof(char);
 			strWIDList[1].ps8WidVal = (s8 *)(&(pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFwepAttr.tenuAuth_type));
 
 			strWIDList[2].u16WIDid	= (u16)WID_KEY_ID;
-			strWIDList[2].enuWIDtype	= WID_CHAR;
+			strWIDList[2].type = WID_CHAR;
 
 			strWIDList[2].ps8WidVal	= (s8 *)(&(pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFwepAttr.u8Wepidx));
 			strWIDList[2].s32ValueSize = sizeof(char);
@@ -2457,7 +2457,7 @@ static int Handle_Key(struct host_if_drv *drvHandler,
 			kfree(pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFwepAttr.pu8WepKey);
 
 			strWIDList[3].u16WIDid = (u16)WID_WEP_KEY_VALUE;
-			strWIDList[3].enuWIDtype = WID_STR;
+			strWIDList[3].type = WID_STR;
 			strWIDList[3].s32ValueSize = pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFwepAttr.u8WepKeylen;
 			strWIDList[3].ps8WidVal = (s8 *)pu8keybuf;
 
@@ -2486,7 +2486,7 @@ static int Handle_Key(struct host_if_drv *drvHandler,
 			kfree(pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFwepAttr.pu8WepKey);
 
 			strWID.u16WIDid	= (u16)WID_ADD_WEP_KEY;
-			strWID.enuWIDtype	= WID_STR;
+			strWID.type = WID_STR;
 			strWID.ps8WidVal	= (s8 *)pu8keybuf;
 			strWID.s32ValueSize = pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFwepAttr.u8WepKeylen + 2;
 
@@ -2497,7 +2497,7 @@ static int Handle_Key(struct host_if_drv *drvHandler,
 
 			PRINT_D(HOSTINF_DBG, "Removing key\n");
 			strWID.u16WIDid	= (u16)WID_REMOVE_WEP_KEY;
-			strWID.enuWIDtype	= WID_STR;
+			strWID.type = WID_STR;
 
 			s8idxarray[0] = (s8)pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFwepAttr.u8Wepidx;
 			strWID.ps8WidVal = s8idxarray;
@@ -2507,7 +2507,7 @@ static int Handle_Key(struct host_if_drv *drvHandler,
 						   get_id_from_handler(pstrWFIDrv));
 		} else {
 			strWID.u16WIDid	= (u16)WID_KEY_ID;
-			strWID.enuWIDtype	= WID_CHAR;
+			strWID.type = WID_CHAR;
 			strWID.ps8WidVal	= (s8 *)(&(pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFwepAttr.u8Wepidx));
 			strWID.s32ValueSize = sizeof(char);
 
@@ -2550,12 +2550,12 @@ static int Handle_Key(struct host_if_drv *drvHandler,
 				    pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFwpaAttr.u8Keylen);
 			/* pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFwpaAttr.u8Ciphermode =  0X51; */
 			strWIDList[0].u16WIDid = (u16)WID_11I_MODE;
-			strWIDList[0].enuWIDtype = WID_CHAR;
+			strWIDList[0].type = WID_CHAR;
 			strWIDList[0].s32ValueSize = sizeof(char);
 			strWIDList[0].ps8WidVal = (s8 *)(&(pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFwpaAttr.u8Ciphermode));
 
 			strWIDList[1].u16WIDid	= (u16)WID_ADD_RX_GTK;
-			strWIDList[1].enuWIDtype	= WID_STR;
+			strWIDList[1].type = WID_STR;
 			strWIDList[1].ps8WidVal	= (s8 *)pu8keybuf;
 			strWIDList[1].s32ValueSize = RX_MIC_KEY_MSG_LEN;
 
@@ -2601,7 +2601,7 @@ static int Handle_Key(struct host_if_drv *drvHandler,
 				    pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFwpaAttr.u8Keylen);
 
 			strWID.u16WIDid	= (u16)WID_ADD_RX_GTK;
-			strWID.enuWIDtype	= WID_STR;
+			strWID.type = WID_STR;
 			strWID.ps8WidVal	= (s8 *)pu8keybuf;
 			strWID.s32ValueSize = RX_MIC_KEY_MSG_LEN;
 
@@ -2653,12 +2653,12 @@ _WPARxGtk_end_case_:
 
 
 			strWIDList[0].u16WIDid = (u16)WID_11I_MODE;
-			strWIDList[0].enuWIDtype = WID_CHAR;
+			strWIDList[0].type = WID_CHAR;
 			strWIDList[0].s32ValueSize = sizeof(char);
 			strWIDList[0].ps8WidVal = (s8 *)(&(pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFwpaAttr.u8Ciphermode));
 
 			strWIDList[1].u16WIDid	= (u16)WID_ADD_PTK;
-			strWIDList[1].enuWIDtype	= WID_STR;
+			strWIDList[1].type = WID_STR;
 			strWIDList[1].ps8WidVal	= (s8 *)pu8keybuf;
 			strWIDList[1].s32ValueSize = PTK_KEY_MSG_LEN + 1;
 
@@ -2699,7 +2699,7 @@ _WPARxGtk_end_case_:
 
 
 			strWID.u16WIDid	= (u16)WID_ADD_PTK;
-			strWID.enuWIDtype	= WID_STR;
+			strWID.type = WID_STR;
 			strWID.ps8WidVal	= (s8 *)pu8keybuf;
 			strWID.s32ValueSize = PTK_KEY_MSG_LEN;
 
@@ -2739,7 +2739,7 @@ _WPAPtk_end_case_:
 		}
 
 		strWID.u16WIDid	= (u16)WID_PMKID_INFO;
-		strWID.enuWIDtype = WID_STR;
+		strWID.type = WID_STR;
 		strWID.ps8WidVal = (s8 *)pu8keybuf;
 		strWID.s32ValueSize = (pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFpmkidAttr.numpmkid * PMKSA_KEY_LEN) + 1;
 
@@ -2777,7 +2777,7 @@ static void Handle_Disconnect(struct host_if_drv *drvHandler)
 
 
 	strWID.u16WIDid = (u16)WID_DISCONNECT;
-	strWID.enuWIDtype = WID_CHAR;
+	strWID.type = WID_CHAR;
 	strWID.ps8WidVal = (s8 *)&u16DummyReasonCode;
 	strWID.s32ValueSize = sizeof(char);
 
@@ -2901,7 +2901,7 @@ static s32 Handle_GetChnl(struct host_if_drv *drvHandler)
 	struct host_if_drv *pstrWFIDrv = (struct host_if_drv *)drvHandler;
 
 	strWID.u16WIDid = (u16)WID_CURRENT_CHANNEL;
-	strWID.enuWIDtype = WID_CHAR;
+	strWID.type = WID_CHAR;
 	strWID.ps8WidVal = (s8 *)&gu8Chnl;
 	strWID.s32ValueSize = sizeof(char);
 
@@ -2940,7 +2940,7 @@ static void Handle_GetRssi(struct host_if_drv *drvHandler)
 	struct host_if_drv *pstrWFIDrv = (struct host_if_drv *)drvHandler;
 
 	strWID.u16WIDid = (u16)WID_RSSI;
-	strWID.enuWIDtype = WID_CHAR;
+	strWID.type = WID_CHAR;
 	strWID.ps8WidVal = &gs8Rssi;
 	strWID.s32ValueSize = sizeof(char);
 
@@ -2969,7 +2969,7 @@ static void Handle_GetLinkspeed(struct host_if_drv *drvHandler)
 	gs8lnkspd = 0;
 
 	strWID.u16WIDid = (u16)WID_LINKSPEED;
-	strWID.enuWIDtype = WID_CHAR;
+	strWID.type = WID_CHAR;
 	strWID.ps8WidVal = &gs8lnkspd;
 	strWID.s32ValueSize = sizeof(char);
 	/*Sending Cfg*/
@@ -2993,31 +2993,31 @@ s32 Handle_GetStatistics(struct host_if_drv *drvHandler, tstrStatistics *pstrSta
 	u32 u32WidsCount = 0, s32Error = 0;
 
 	strWIDList[u32WidsCount].u16WIDid = WID_LINKSPEED;
-	strWIDList[u32WidsCount].enuWIDtype = WID_CHAR;
+	strWIDList[u32WidsCount].type = WID_CHAR;
 	strWIDList[u32WidsCount].s32ValueSize = sizeof(char);
 	strWIDList[u32WidsCount].ps8WidVal = (s8 *)(&(pstrStatistics->u8LinkSpeed));
 	u32WidsCount++;
 
 	strWIDList[u32WidsCount].u16WIDid = WID_RSSI;
-	strWIDList[u32WidsCount].enuWIDtype = WID_CHAR;
+	strWIDList[u32WidsCount].type = WID_CHAR;
 	strWIDList[u32WidsCount].s32ValueSize = sizeof(char);
 	strWIDList[u32WidsCount].ps8WidVal = (s8 *)(&(pstrStatistics->s8RSSI));
 	u32WidsCount++;
 
 	strWIDList[u32WidsCount].u16WIDid = WID_SUCCESS_FRAME_COUNT;
-	strWIDList[u32WidsCount].enuWIDtype = WID_INT;
+	strWIDList[u32WidsCount].type = WID_INT;
 	strWIDList[u32WidsCount].s32ValueSize = sizeof(u32);
 	strWIDList[u32WidsCount].ps8WidVal = (s8 *)(&(pstrStatistics->u32TxCount));
 	u32WidsCount++;
 
 	strWIDList[u32WidsCount].u16WIDid = WID_RECEIVED_FRAGMENT_COUNT;
-	strWIDList[u32WidsCount].enuWIDtype = WID_INT;
+	strWIDList[u32WidsCount].type = WID_INT;
 	strWIDList[u32WidsCount].s32ValueSize = sizeof(u32);
 	strWIDList[u32WidsCount].ps8WidVal = (s8 *)(&(pstrStatistics->u32RxCount));
 	u32WidsCount++;
 
 	strWIDList[u32WidsCount].u16WIDid = WID_FAILED_COUNT;
-	strWIDList[u32WidsCount].enuWIDtype = WID_INT;
+	strWIDList[u32WidsCount].type = WID_INT;
 	strWIDList[u32WidsCount].s32ValueSize = sizeof(u32);
 	strWIDList[u32WidsCount].ps8WidVal = (s8 *)(&(pstrStatistics->u32TxFailureCount));
 	u32WidsCount++;
@@ -3055,7 +3055,7 @@ static s32 Handle_Get_InActiveTime(struct host_if_drv *drvHandler,
 
 
 	strWID.u16WIDid = (u16)WID_SET_STA_MAC_INACTIVE_TIME;
-	strWID.enuWIDtype = WID_STR;
+	strWID.type = WID_STR;
 	strWID.s32ValueSize = ETH_ALEN;
 	strWID.ps8WidVal = kmalloc(strWID.s32ValueSize, GFP_KERNEL);
 
@@ -3077,7 +3077,7 @@ static s32 Handle_Get_InActiveTime(struct host_if_drv *drvHandler,
 
 
 	strWID.u16WIDid = (u16)WID_GET_INACTIVE_TIME;
-	strWID.enuWIDtype = WID_INT;
+	strWID.type = WID_INT;
 	strWID.ps8WidVal = (s8 *)&gu32InactiveTime;
 	strWID.s32ValueSize = sizeof(u32);
 
@@ -3122,7 +3122,7 @@ static void Handle_AddBeacon(struct host_if_drv *drvHandler,
 	PRINT_D(HOSTINF_DBG, "Adding BEACON\n");
 
 	strWID.u16WIDid = (u16)WID_ADD_BEACON;
-	strWID.enuWIDtype = WID_BIN;
+	strWID.type = WID_BIN;
 	strWID.s32ValueSize = pstrSetBeaconParam->u32HeadLen + pstrSetBeaconParam->u32TailLen + 16;
 	strWID.ps8WidVal = kmalloc(strWID.s32ValueSize, GFP_KERNEL);
 	if (strWID.ps8WidVal == NULL)
@@ -3188,7 +3188,7 @@ static void Handle_DelBeacon(struct host_if_drv *drvHandler)
 	struct host_if_drv *pstrWFIDrv = (struct host_if_drv *)drvHandler;
 
 	strWID.u16WIDid = (u16)WID_DEL_BEACON;
-	strWID.enuWIDtype = WID_CHAR;
+	strWID.type = WID_CHAR;
 	strWID.s32ValueSize = sizeof(char);
 	strWID.ps8WidVal = &gu8DelBcn;
 
@@ -3282,7 +3282,7 @@ static void Handle_AddStation(struct host_if_drv *drvHandler,
 
 	PRINT_D(HOSTINF_DBG, "Handling add station\n");
 	strWID.u16WIDid = (u16)WID_ADD_STA;
-	strWID.enuWIDtype = WID_BIN;
+	strWID.type = WID_BIN;
 	strWID.s32ValueSize = WILC_ADD_STA_LENGTH + pstrStationParam->u8NumRates;
 
 	strWID.ps8WidVal = kmalloc(strWID.s32ValueSize, GFP_KERNEL);
@@ -3324,7 +3324,7 @@ static void Handle_DelAllSta(struct host_if_drv *drvHandler,
 	u8 au8Zero_Buff[6] = {0};
 
 	strWID.u16WIDid = (u16)WID_DEL_ALL_STA;
-	strWID.enuWIDtype = WID_STR;
+	strWID.type = WID_STR;
 	strWID.s32ValueSize = (pstrDelAllStaParam->u8Num_AssocSta * ETH_ALEN) + 1;
 
 	PRINT_D(HOSTINF_DBG, "Handling delete station\n");
@@ -3377,7 +3377,7 @@ static void Handle_DelStation(struct host_if_drv *drvHandler,
 	struct host_if_drv *pstrWFIDrv = (struct host_if_drv *)drvHandler;
 
 	strWID.u16WIDid = (u16)WID_REMOVE_STA;
-	strWID.enuWIDtype = WID_BIN;
+	strWID.type = WID_BIN;
 	strWID.s32ValueSize = ETH_ALEN;
 
 	PRINT_D(HOSTINF_DBG, "Handling delete station\n");
@@ -3419,7 +3419,7 @@ static void Handle_EditStation(struct host_if_drv *drvHandler,
 	struct host_if_drv *pstrWFIDrv = (struct host_if_drv *)drvHandler;
 
 	strWID.u16WIDid = (u16)WID_EDIT_STA;
-	strWID.enuWIDtype = WID_BIN;
+	strWID.type = WID_BIN;
 	strWID.s32ValueSize = WILC_ADD_STA_LENGTH + pstrStationParam->u8NumRates;
 
 	PRINT_D(HOSTINF_DBG, "Handling edit station\n");
@@ -3492,7 +3492,7 @@ static int Handle_RemainOnChan(struct host_if_drv *drvHandler,
 
 	u8remain_on_chan_flag = true;
 	strWID.u16WIDid	= (u16)WID_REMAIN_ON_CHAN;
-	strWID.enuWIDtype	= WID_STR;
+	strWID.type = WID_STR;
 	strWID.s32ValueSize = 2;
 	strWID.ps8WidVal = kmalloc(strWID.s32ValueSize, GFP_KERNEL);
 
@@ -3549,7 +3549,7 @@ static int Handle_RegisterFrame(struct host_if_drv *drvHandler,
 
 	/*prepare configuration packet*/
 	strWID.u16WIDid = (u16)WID_REGISTER_FRAME;
-	strWID.enuWIDtype = WID_STR;
+	strWID.type = WID_STR;
 	strWID.ps8WidVal = kmalloc(sizeof(u16) + 2, GFP_KERNEL);
 	if (strWID.ps8WidVal == NULL)
 		return -ENOMEM;
@@ -3601,7 +3601,7 @@ static u32 Handle_ListenStateExpired(struct host_if_drv *drvHandler,
 	if (P2P_LISTEN_STATE) {
 		u8remain_on_chan_flag = false;
 		strWID.u16WIDid	= (u16)WID_REMAIN_ON_CHAN;
-		strWID.enuWIDtype	= WID_STR;
+		strWID.type = WID_STR;
 		strWID.s32ValueSize = 2;
 		strWID.ps8WidVal = kmalloc(strWID.s32ValueSize, GFP_KERNEL);
 
@@ -3718,7 +3718,7 @@ static void Handle_SetMulticastFilter(struct host_if_drv *drvHandler,
 	PRINT_D(HOSTINF_DBG, "Setup Multicast Filter\n");
 
 	strWID.u16WIDid = (u16)WID_SETUP_MULTICAST_FILTER;
-	strWID.enuWIDtype = WID_BIN;
+	strWID.type = WID_BIN;
 	strWID.s32ValueSize = sizeof(struct set_multicast) + ((strHostIfSetMulti->u32count) * ETH_ALEN);
 	strWID.ps8WidVal = kmalloc(strWID.s32ValueSize, GFP_KERNEL);
 	if (strWID.ps8WidVal == NULL)
@@ -3777,7 +3777,7 @@ static s32 Handle_AddBASession(struct host_if_drv *drvHandler,
 		strHostIfBASessionInfo->u8Ted);
 
 	strWID.u16WIDid = (u16)WID_11E_P_ACTION_REQ;
-	strWID.enuWIDtype = WID_STR;
+	strWID.type = WID_STR;
 	strWID.ps8WidVal = kmalloc(BLOCK_ACK_REQ_SIZE, GFP_KERNEL);
 	strWID.s32ValueSize = BLOCK_ACK_REQ_SIZE;
 	ptr = strWID.ps8WidVal;
@@ -3811,7 +3811,7 @@ static s32 Handle_AddBASession(struct host_if_drv *drvHandler,
 
 
 	strWID.u16WIDid = (u16)WID_11E_P_ACTION_REQ;
-	strWID.enuWIDtype = WID_STR;
+	strWID.type = WID_STR;
 	strWID.s32ValueSize = 15;
 	ptr = strWID.ps8WidVal;
 	/* *ptr++ = 0x14; */
@@ -3863,7 +3863,7 @@ static s32 Handle_DelAllRxBASessions(struct host_if_drv *drvHandler,
 		strHostIfBASessionInfo->u8Ted);
 
 	strWID.u16WIDid = (u16)WID_DEL_ALL_RX_BA;
-	strWID.enuWIDtype = WID_STR;
+	strWID.type = WID_STR;
 	strWID.ps8WidVal = kmalloc(BLOCK_ACK_REQ_SIZE, GFP_KERNEL);
 	strWID.s32ValueSize = BLOCK_ACK_REQ_SIZE;
 	ptr = strWID.ps8WidVal;
@@ -4162,7 +4162,7 @@ s32 host_int_remove_key(struct host_if_drv *hWFIDrv, const u8 *pu8StaAddress)
 	struct wid strWID;
 
 	strWID.u16WIDid	= (u16)WID_REMOVE_KEY;
-	strWID.enuWIDtype	= WID_STR;
+	strWID.type = WID_STR;
 	strWID.ps8WidVal	= (s8 *)pu8StaAddress;
 	strWID.s32ValueSize = 6;
 
@@ -4679,7 +4679,7 @@ s32 host_int_get_pmkid_info(struct host_if_drv *hWFIDrv, u8 *pu8PmkidInfoArray,
 	struct wid strWID;
 
 	strWID.u16WIDid	= (u16)WID_PMKID_INFO;
-	strWID.enuWIDtype	= WID_STR;
+	strWID.type = WID_STR;
 	strWID.s32ValueSize = u32PmkidInfoLen;
 	strWID.ps8WidVal = pu8PmkidInfoArray;
 
@@ -4708,7 +4708,7 @@ s32 host_int_set_RSNAConfigPSKPassPhrase(struct host_if_drv *hWFIDrv, u8 *pu8Pas
 	/*validating psk length*/
 	if ((u8Psklength > 7) && (u8Psklength < 65)) {
 		strWID.u16WIDid	= (u16)WID_11I_PSK;
-		strWID.enuWIDtype	= WID_STR;
+		strWID.type = WID_STR;
 		strWID.ps8WidVal	= pu8PassPhrase;
 		strWID.s32ValueSize = u8Psklength;
 	}
@@ -4801,7 +4801,7 @@ s32 host_int_get_RSNAConfigPSKPassPhrase(struct host_if_drv *hWFIDrv,
 	struct wid strWID;
 
 	strWID.u16WIDid	= (u16)WID_11I_PSK;
-	strWID.enuWIDtype	= WID_STR;
+	strWID.type = WID_STR;
 	strWID.s32ValueSize = u8Psklength;
 	strWID.ps8WidVal	= pu8PassPhrase;
 
@@ -4828,7 +4828,7 @@ s32 host_int_set_start_scan_req(struct host_if_drv *hWFIDrv, u8 scanSource)
 	struct wid strWID;
 
 	strWID.u16WIDid = (u16)WID_START_SCAN_REQ;
-	strWID.enuWIDtype = WID_CHAR;
+	strWID.type = WID_CHAR;
 	strWID.ps8WidVal = (s8 *)&scanSource;
 	strWID.s32ValueSize = sizeof(char);
 
@@ -4856,7 +4856,7 @@ s32 host_int_get_start_scan_req(struct host_if_drv *hWFIDrv, u8 *pu8ScanSource)
 	struct wid strWID;
 
 	strWID.u16WIDid = (u16)WID_START_SCAN_REQ;
-	strWID.enuWIDtype = WID_CHAR;
+	strWID.type = WID_CHAR;
 	strWID.ps8WidVal = (s8 *)pu8ScanSource;
 	strWID.s32ValueSize = sizeof(char);
 
@@ -5053,7 +5053,7 @@ s32 host_int_disconnect_station(struct host_if_drv *hWFIDrv, u8 assoc_id)
 	struct wid strWID;
 
 	strWID.u16WIDid = (u16)WID_DISCONNECT;
-	strWID.enuWIDtype = WID_CHAR;
+	strWID.type = WID_CHAR;
 	strWID.ps8WidVal = (s8 *)&assoc_id;
 	strWID.s32ValueSize = sizeof(char);
 
@@ -5092,7 +5092,7 @@ s32 host_int_get_assoc_req_info(struct host_if_drv *hWFIDrv, u8 *pu8AssocReqInfo
 	struct wid strWID;
 
 	strWID.u16WIDid = (u16)WID_ASSOC_REQ_INFO;
-	strWID.enuWIDtype = WID_STR;
+	strWID.type = WID_STR;
 	strWID.ps8WidVal = pu8AssocReqInfo;
 	strWID.s32ValueSize = u32AssocReqInfoLen;
 
@@ -5123,7 +5123,7 @@ s32 host_int_get_assoc_res_info(struct host_if_drv *hWFIDrv, u8 *pu8AssocRespInf
 	}
 
 	strWID.u16WIDid = (u16)WID_ASSOC_RES_INFO;
-	strWID.enuWIDtype = WID_STR;
+	strWID.type = WID_STR;
 	strWID.ps8WidVal = pu8AssocRespInfo;
 	strWID.s32ValueSize = u32MaxAssocRespInfoLen;
 
@@ -5163,7 +5163,7 @@ s32 host_int_get_rx_power_level(struct host_if_drv *hWFIDrv, u8 *pu8RxPowerLevel
 	struct wid strWID;
 
 	strWID.u16WIDid = (u16)WID_RX_POWER_LEVEL;
-	strWID.enuWIDtype = WID_STR;
+	strWID.type = WID_STR;
 	strWID.ps8WidVal = pu8RxPowerLevel;
 	strWID.s32ValueSize = u32RxPowerLevelLen;
 
@@ -5389,7 +5389,7 @@ s32 host_int_test_get_int_wid(struct host_if_drv *hWFIDrv, u32 *pu32TestMemAddr)
 	}
 
 	strWID.u16WIDid = (u16)WID_MEMORY_ADDRESS;
-	strWID.enuWIDtype = WID_INT;
+	strWID.type = WID_INT;
 	strWID.ps8WidVal = (s8 *)pu32TestMemAddr;
 	strWID.s32ValueSize = sizeof(u32);
 
-- 
1.9.1

