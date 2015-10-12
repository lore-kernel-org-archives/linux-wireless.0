Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:12467 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751819AbbJLH5x (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Oct 2015 03:57:53 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH V2 12/41] staging: wilc1000: rename the member variable, ps8WidVal of wid
Date: Mon, 12 Oct 2015 16:55:46 +0900
Message-ID: <1444636575-2486-12-git-send-email-tony.cho@atmel.com> (sfid-20151012_095758_760756_BF8D3BCB)
In-Reply-To: <1444636575-2486-1-git-send-email-tony.cho@atmel.com>
References: <1444636575-2486-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames ps8WidVal of struct wid to val.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/coreconfigurator.c |   4 +-
 drivers/staging/wilc1000/coreconfigurator.h |   2 +-
 drivers/staging/wilc1000/host_interface.c   | 276 ++++++++++++++--------------
 3 files changed, 141 insertions(+), 141 deletions(-)

diff --git a/drivers/staging/wilc1000/coreconfigurator.c b/drivers/staging/wilc1000/coreconfigurator.c
index e51ae3a..39e463c 100644
--- a/drivers/staging/wilc1000/coreconfigurator.c
+++ b/drivers/staging/wilc1000/coreconfigurator.c
@@ -616,7 +616,7 @@ s32 send_config_pkt(u8 mode, struct wid *wids, u32 count, u32 drv)
 		for (counter = 0; counter < count; counter++) {
 			wids[counter].size = wilc_wlan_cfg_get_val(
 					wids[counter].id,
-					wids[counter].ps8WidVal,
+					wids[counter].val,
 					wids[counter].size);
 
 		}
@@ -625,7 +625,7 @@ s32 send_config_pkt(u8 mode, struct wid *wids, u32 count, u32 drv)
 			PRINT_D(CORECONFIG_DBG, "Sending config SET PACKET WID:%x\n", wids[counter].id);
 			if (!wilc_wlan_cfg_set(!counter,
 					       wids[counter].id,
-					       wids[counter].ps8WidVal,
+					       wids[counter].val,
 					       wids[counter].size,
 					       (counter == count - 1),
 					       drv)) {
diff --git a/drivers/staging/wilc1000/coreconfigurator.h b/drivers/staging/wilc1000/coreconfigurator.h
index 3595a0a..6294d92 100644
--- a/drivers/staging/wilc1000/coreconfigurator.h
+++ b/drivers/staging/wilc1000/coreconfigurator.h
@@ -74,7 +74,7 @@ struct wid {
 	u16 id;
 	enum WID_TYPE type;
 	s32 size;
-	s8      *ps8WidVal;
+	s8 *val;
 };
 
 typedef struct {
diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index fae96fc..5ee8c3a 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -578,7 +578,7 @@ static s32 Handle_SetChannel(struct host_if_drv *drvHandler,
 	/*prepare configuration packet*/
 	strWID.id = (u16)WID_CURRENT_CHANNEL;
 	strWID.type = WID_CHAR;
-	strWID.ps8WidVal = (char *)&(pstrHostIFSetChan->u8SetChan);
+	strWID.val = (char *)&(pstrHostIFSetChan->u8SetChan);
 	strWID.size = sizeof(char);
 
 	PRINT_D(HOSTINF_DBG, "Setting channel\n");
@@ -614,7 +614,7 @@ static s32 Handle_SetWfiDrvHandler(struct host_if_drv *drvHandler,
 	/*prepare configuration packet*/
 	strWID.id = (u16)WID_SET_DRV_HANDLER;
 	strWID.type = WID_INT;
-	strWID.ps8WidVal = (s8 *)&(pstrHostIfSetDrvHandler->u32Address);
+	strWID.val = (s8 *)&(pstrHostIfSetDrvHandler->u32Address);
 	strWID.size = sizeof(u32);
 
 	/*Sending Cfg*/
@@ -655,7 +655,7 @@ static s32 Handle_SetOperationMode(struct host_if_drv *drvHandler,
 	/*prepare configuration packet*/
 	strWID.id = (u16)WID_SET_OPERATION_MODE;
 	strWID.type = WID_INT;
-	strWID.ps8WidVal = (s8 *)&(pstrHostIfSetOperationMode->u32Mode);
+	strWID.val = (s8 *)&(pstrHostIfSetOperationMode->u32Mode);
 	strWID.size = sizeof(u32);
 
 	/*Sending Cfg*/
@@ -704,7 +704,7 @@ s32 Handle_set_IPAddress(struct host_if_drv *drvHandler, u8 *pu8IPAddr, u8 idx)
 	/*prepare configuration packet*/
 	strWID.id = (u16)WID_IP_ADDRESS;
 	strWID.type = WID_STR;
-	strWID.ps8WidVal = (u8 *)pu8IPAddr;
+	strWID.val = (u8 *)pu8IPAddr;
 	strWID.size = IP_ALEN;
 
 	s32Error = send_config_pkt(SET_CFG, &strWID, 1,
@@ -743,18 +743,18 @@ s32 Handle_get_IPAddress(struct host_if_drv *drvHandler, u8 *pu8IPAddr, u8 idx)
 	/*prepare configuration packet*/
 	strWID.id = (u16)WID_IP_ADDRESS;
 	strWID.type = WID_STR;
-	strWID.ps8WidVal = kmalloc(IP_ALEN, GFP_KERNEL);
+	strWID.val = kmalloc(IP_ALEN, GFP_KERNEL);
 	strWID.size = IP_ALEN;
 
 	s32Error = send_config_pkt(GET_CFG, &strWID, 1,
 				   get_id_from_handler(pstrWFIDrv));
 
-	PRINT_INFO(HOSTINF_DBG, "%pI4\n", strWID.ps8WidVal);
+	PRINT_INFO(HOSTINF_DBG, "%pI4\n", strWID.val);
 
-	memcpy(gs8GetIP[idx], strWID.ps8WidVal, IP_ALEN);
+	memcpy(gs8GetIP[idx], strWID.val, IP_ALEN);
 
 	/*get the value by searching the local copy*/
-	kfree(strWID.ps8WidVal);
+	kfree(strWID.val);
 
 	if (memcmp(gs8GetIP[idx], gs8SetIP[idx], IP_ALEN) != 0)
 		host_int_setup_ipaddress(pstrWFIDrv, gs8SetIP[idx], idx);
@@ -799,9 +799,9 @@ static s32 Handle_SetMacAddress(struct host_if_drv *drvHandler,
 	/*prepare configuration packet*/
 	strWID.id = (u16)WID_MAC_ADDR;
 	strWID.type = WID_STR;
-	strWID.ps8WidVal = mac_buf;
+	strWID.val = mac_buf;
 	strWID.size = ETH_ALEN;
-	PRINT_D(GENERIC_DBG, "mac addr = :%pM\n", strWID.ps8WidVal);
+	PRINT_D(GENERIC_DBG, "mac addr = :%pM\n", strWID.val);
 	/*Sending Cfg*/
 	s32Error = send_config_pkt(SET_CFG, &strWID, 1,
 				   get_id_from_handler(pstrWFIDrv));
@@ -834,7 +834,7 @@ static s32 Handle_GetMacAddress(struct host_if_drv *drvHandler,
 	/*prepare configuration packet*/
 	strWID.id = (u16)WID_MAC_ADDR;
 	strWID.type = WID_STR;
-	strWID.ps8WidVal = pstrHostIfGetMacAddress->u8MacAddress;
+	strWID.val = pstrHostIfGetMacAddress->u8MacAddress;
 	strWID.size = ETH_ALEN;
 
 	/*Sending Cfg*/
@@ -882,7 +882,7 @@ static s32 Handle_CfgParam(struct host_if_drv *drvHandler,
 		/* validate input then copy>> need to check value 4 and 5 */
 		if (strHostIFCfgParamAttr->pstrCfgParamVal.bss_type < 6) {
 			strWIDList[u8WidCnt].id = WID_BSS_TYPE;
-			strWIDList[u8WidCnt].ps8WidVal = (s8 *)&strHostIFCfgParamAttr->pstrCfgParamVal.bss_type;
+			strWIDList[u8WidCnt].val = (s8 *)&strHostIFCfgParamAttr->pstrCfgParamVal.bss_type;
 			strWIDList[u8WidCnt].type = WID_CHAR;
 			strWIDList[u8WidCnt].size = sizeof(char);
 			pstrWFIDrv->strCfgValues.bss_type = (u8)strHostIFCfgParamAttr->pstrCfgParamVal.bss_type;
@@ -902,7 +902,7 @@ static s32 Handle_CfgParam(struct host_if_drv *drvHandler,
 		/*validate Possible values*/
 		if ((strHostIFCfgParamAttr->pstrCfgParamVal.auth_type) == 1 || (strHostIFCfgParamAttr->pstrCfgParamVal.auth_type) == 2 || (strHostIFCfgParamAttr->pstrCfgParamVal.auth_type) == 5) {
 			strWIDList[u8WidCnt].id = WID_AUTH_TYPE;
-			strWIDList[u8WidCnt].ps8WidVal = (s8 *)&strHostIFCfgParamAttr->pstrCfgParamVal.auth_type;
+			strWIDList[u8WidCnt].val = (s8 *)&strHostIFCfgParamAttr->pstrCfgParamVal.auth_type;
 			strWIDList[u8WidCnt].type = WID_CHAR;
 			strWIDList[u8WidCnt].size = sizeof(char);
 			pstrWFIDrv->strCfgValues.auth_type = (u8)strHostIFCfgParamAttr->pstrCfgParamVal.auth_type;
@@ -917,7 +917,7 @@ static s32 Handle_CfgParam(struct host_if_drv *drvHandler,
 		/* range is 1 to 65535. */
 		if (strHostIFCfgParamAttr->pstrCfgParamVal.auth_timeout > 0 && strHostIFCfgParamAttr->pstrCfgParamVal.auth_timeout < 65536) {
 			strWIDList[u8WidCnt].id = WID_AUTH_TIMEOUT;
-			strWIDList[u8WidCnt].ps8WidVal = (s8 *)&strHostIFCfgParamAttr->pstrCfgParamVal.auth_timeout;
+			strWIDList[u8WidCnt].val = (s8 *)&strHostIFCfgParamAttr->pstrCfgParamVal.auth_timeout;
 			strWIDList[u8WidCnt].type = WID_SHORT;
 			strWIDList[u8WidCnt].size = sizeof(u16);
 			pstrWFIDrv->strCfgValues.auth_timeout = strHostIFCfgParamAttr->pstrCfgParamVal.auth_timeout;
@@ -938,7 +938,7 @@ static s32 Handle_CfgParam(struct host_if_drv *drvHandler,
 		/*----------------------------------------------------------*/
 		if (strHostIFCfgParamAttr->pstrCfgParamVal.power_mgmt_mode < 5) {
 			strWIDList[u8WidCnt].id = WID_POWER_MANAGEMENT;
-			strWIDList[u8WidCnt].ps8WidVal = (s8 *)&strHostIFCfgParamAttr->pstrCfgParamVal.power_mgmt_mode;
+			strWIDList[u8WidCnt].val = (s8 *)&strHostIFCfgParamAttr->pstrCfgParamVal.power_mgmt_mode;
 			strWIDList[u8WidCnt].type = WID_CHAR;
 			strWIDList[u8WidCnt].size = sizeof(char);
 			pstrWFIDrv->strCfgValues.power_mgmt_mode = (u8)strHostIFCfgParamAttr->pstrCfgParamVal.power_mgmt_mode;
@@ -953,7 +953,7 @@ static s32 Handle_CfgParam(struct host_if_drv *drvHandler,
 		/* range from 1 to 256 */
 		if ((strHostIFCfgParamAttr->pstrCfgParamVal.short_retry_limit > 0) && (strHostIFCfgParamAttr->pstrCfgParamVal.short_retry_limit < 256))	{
 			strWIDList[u8WidCnt].id = WID_SHORT_RETRY_LIMIT;
-			strWIDList[u8WidCnt].ps8WidVal = (s8 *)&strHostIFCfgParamAttr->pstrCfgParamVal.short_retry_limit;
+			strWIDList[u8WidCnt].val = (s8 *)&strHostIFCfgParamAttr->pstrCfgParamVal.short_retry_limit;
 			strWIDList[u8WidCnt].type = WID_SHORT;
 			strWIDList[u8WidCnt].size = sizeof(u16);
 			pstrWFIDrv->strCfgValues.short_retry_limit = strHostIFCfgParamAttr->pstrCfgParamVal.short_retry_limit;
@@ -968,7 +968,7 @@ static s32 Handle_CfgParam(struct host_if_drv *drvHandler,
 		/* range from 1 to 256 */
 		if ((strHostIFCfgParamAttr->pstrCfgParamVal.long_retry_limit > 0) && (strHostIFCfgParamAttr->pstrCfgParamVal.long_retry_limit < 256)) {
 			strWIDList[u8WidCnt].id = WID_LONG_RETRY_LIMIT;
-			strWIDList[u8WidCnt].ps8WidVal = (s8 *)&strHostIFCfgParamAttr->pstrCfgParamVal.long_retry_limit;
+			strWIDList[u8WidCnt].val = (s8 *)&strHostIFCfgParamAttr->pstrCfgParamVal.long_retry_limit;
 
 			strWIDList[u8WidCnt].type = WID_SHORT;
 			strWIDList[u8WidCnt].size = sizeof(u16);
@@ -984,7 +984,7 @@ static s32 Handle_CfgParam(struct host_if_drv *drvHandler,
 
 		if (strHostIFCfgParamAttr->pstrCfgParamVal.frag_threshold > 255 && strHostIFCfgParamAttr->pstrCfgParamVal.frag_threshold < 7937) {
 			strWIDList[u8WidCnt].id = WID_FRAG_THRESHOLD;
-			strWIDList[u8WidCnt].ps8WidVal = (s8 *)&strHostIFCfgParamAttr->pstrCfgParamVal.frag_threshold;
+			strWIDList[u8WidCnt].val = (s8 *)&strHostIFCfgParamAttr->pstrCfgParamVal.frag_threshold;
 			strWIDList[u8WidCnt].type = WID_SHORT;
 			strWIDList[u8WidCnt].size = sizeof(u16);
 			pstrWFIDrv->strCfgValues.frag_threshold = strHostIFCfgParamAttr->pstrCfgParamVal.frag_threshold;
@@ -999,7 +999,7 @@ static s32 Handle_CfgParam(struct host_if_drv *drvHandler,
 		/* range 256 to 65535 */
 		if (strHostIFCfgParamAttr->pstrCfgParamVal.rts_threshold > 255 && strHostIFCfgParamAttr->pstrCfgParamVal.rts_threshold < 65536)	{
 			strWIDList[u8WidCnt].id = WID_RTS_THRESHOLD;
-			strWIDList[u8WidCnt].ps8WidVal = (s8 *)&strHostIFCfgParamAttr->pstrCfgParamVal.rts_threshold;
+			strWIDList[u8WidCnt].val = (s8 *)&strHostIFCfgParamAttr->pstrCfgParamVal.rts_threshold;
 			strWIDList[u8WidCnt].type = WID_SHORT;
 			strWIDList[u8WidCnt].size = sizeof(u16);
 			pstrWFIDrv->strCfgValues.rts_threshold = strHostIFCfgParamAttr->pstrCfgParamVal.rts_threshold;
@@ -1018,7 +1018,7 @@ static s32 Handle_CfgParam(struct host_if_drv *drvHandler,
 		/*------------------------------------------------------*/
 		if (strHostIFCfgParamAttr->pstrCfgParamVal.preamble_type < 3) {
 			strWIDList[u8WidCnt].id = WID_PREAMBLE;
-			strWIDList[u8WidCnt].ps8WidVal = (s8 *)&strHostIFCfgParamAttr->pstrCfgParamVal.preamble_type;
+			strWIDList[u8WidCnt].val = (s8 *)&strHostIFCfgParamAttr->pstrCfgParamVal.preamble_type;
 			strWIDList[u8WidCnt].type = WID_CHAR;
 			strWIDList[u8WidCnt].size = sizeof(char);
 			pstrWFIDrv->strCfgValues.preamble_type = strHostIFCfgParamAttr->pstrCfgParamVal.preamble_type;
@@ -1032,7 +1032,7 @@ static s32 Handle_CfgParam(struct host_if_drv *drvHandler,
 	if (strHostIFCfgParamAttr->pstrCfgParamVal.u32SetCfgFlag & SHORT_SLOT_ALLOWED) {
 		if (strHostIFCfgParamAttr->pstrCfgParamVal.short_slot_allowed < 2) {
 			strWIDList[u8WidCnt].id = WID_SHORT_SLOT_ALLOWED;
-			strWIDList[u8WidCnt].ps8WidVal = (s8 *)&strHostIFCfgParamAttr->pstrCfgParamVal.short_slot_allowed;
+			strWIDList[u8WidCnt].val = (s8 *)&strHostIFCfgParamAttr->pstrCfgParamVal.short_slot_allowed;
 			strWIDList[u8WidCnt].type = WID_CHAR;
 			strWIDList[u8WidCnt].size = sizeof(char);
 			pstrWFIDrv->strCfgValues.short_slot_allowed = (u8)strHostIFCfgParamAttr->pstrCfgParamVal.short_slot_allowed;
@@ -1050,7 +1050,7 @@ static s32 Handle_CfgParam(struct host_if_drv *drvHandler,
 		/*Input Values: 1 for enable and 0 for disable.							*/
 		if (strHostIFCfgParamAttr->pstrCfgParamVal.txop_prot_disabled < 2) {
 			strWIDList[u8WidCnt].id = WID_11N_TXOP_PROT_DISABLE;
-			strWIDList[u8WidCnt].ps8WidVal = (s8 *)&strHostIFCfgParamAttr->pstrCfgParamVal.txop_prot_disabled;
+			strWIDList[u8WidCnt].val = (s8 *)&strHostIFCfgParamAttr->pstrCfgParamVal.txop_prot_disabled;
 			strWIDList[u8WidCnt].type = WID_CHAR;
 			strWIDList[u8WidCnt].size = sizeof(char);
 			pstrWFIDrv->strCfgValues.txop_prot_disabled = (u8)strHostIFCfgParamAttr->pstrCfgParamVal.txop_prot_disabled;
@@ -1065,7 +1065,7 @@ static s32 Handle_CfgParam(struct host_if_drv *drvHandler,
 		/* range is 1 to 65535. */
 		if (strHostIFCfgParamAttr->pstrCfgParamVal.beacon_interval > 0 && strHostIFCfgParamAttr->pstrCfgParamVal.beacon_interval < 65536) {
 			strWIDList[u8WidCnt].id = WID_BEACON_INTERVAL;
-			strWIDList[u8WidCnt].ps8WidVal = (s8 *)&strHostIFCfgParamAttr->pstrCfgParamVal.beacon_interval;
+			strWIDList[u8WidCnt].val = (s8 *)&strHostIFCfgParamAttr->pstrCfgParamVal.beacon_interval;
 			strWIDList[u8WidCnt].type = WID_SHORT;
 			strWIDList[u8WidCnt].size = sizeof(u16);
 			pstrWFIDrv->strCfgValues.beacon_interval = strHostIFCfgParamAttr->pstrCfgParamVal.beacon_interval;
@@ -1080,7 +1080,7 @@ static s32 Handle_CfgParam(struct host_if_drv *drvHandler,
 		/* range is 1 to 255. */
 		if (strHostIFCfgParamAttr->pstrCfgParamVal.dtim_period > 0 && strHostIFCfgParamAttr->pstrCfgParamVal.dtim_period < 256) {
 			strWIDList[u8WidCnt].id = WID_DTIM_PERIOD;
-			strWIDList[u8WidCnt].ps8WidVal = (s8 *)&strHostIFCfgParamAttr->pstrCfgParamVal.dtim_period;
+			strWIDList[u8WidCnt].val = (s8 *)&strHostIFCfgParamAttr->pstrCfgParamVal.dtim_period;
 			strWIDList[u8WidCnt].type = WID_CHAR;
 			strWIDList[u8WidCnt].size = sizeof(char);
 			pstrWFIDrv->strCfgValues.dtim_period = strHostIFCfgParamAttr->pstrCfgParamVal.dtim_period;
@@ -1099,7 +1099,7 @@ static s32 Handle_CfgParam(struct host_if_drv *drvHandler,
 		/*----------------------------------------------------------------------*/
 		if (strHostIFCfgParamAttr->pstrCfgParamVal.site_survey_enabled < 3) {
 			strWIDList[u8WidCnt].id = WID_SITE_SURVEY;
-			strWIDList[u8WidCnt].ps8WidVal = (s8 *)&strHostIFCfgParamAttr->pstrCfgParamVal.site_survey_enabled;
+			strWIDList[u8WidCnt].val = (s8 *)&strHostIFCfgParamAttr->pstrCfgParamVal.site_survey_enabled;
 			strWIDList[u8WidCnt].type = WID_CHAR;
 			strWIDList[u8WidCnt].size = sizeof(char);
 			pstrWFIDrv->strCfgValues.site_survey_enabled = (u8)strHostIFCfgParamAttr->pstrCfgParamVal.site_survey_enabled;
@@ -1114,7 +1114,7 @@ static s32 Handle_CfgParam(struct host_if_drv *drvHandler,
 		/* range is 1 to 65535. */
 		if (strHostIFCfgParamAttr->pstrCfgParamVal.site_survey_scan_time > 0 && strHostIFCfgParamAttr->pstrCfgParamVal.site_survey_scan_time < 65536) {
 			strWIDList[u8WidCnt].id = WID_SITE_SURVEY_SCAN_TIME;
-			strWIDList[u8WidCnt].ps8WidVal = (s8 *)&strHostIFCfgParamAttr->pstrCfgParamVal.site_survey_scan_time;
+			strWIDList[u8WidCnt].val = (s8 *)&strHostIFCfgParamAttr->pstrCfgParamVal.site_survey_scan_time;
 			strWIDList[u8WidCnt].type = WID_SHORT;
 			strWIDList[u8WidCnt].size = sizeof(u16);
 			pstrWFIDrv->strCfgValues.site_survey_scan_time = strHostIFCfgParamAttr->pstrCfgParamVal.site_survey_scan_time;
@@ -1129,7 +1129,7 @@ static s32 Handle_CfgParam(struct host_if_drv *drvHandler,
 		/* range is 1 to 65535. */
 		if (strHostIFCfgParamAttr->pstrCfgParamVal.active_scan_time > 0 && strHostIFCfgParamAttr->pstrCfgParamVal.active_scan_time < 65536) {
 			strWIDList[u8WidCnt].id = WID_ACTIVE_SCAN_TIME;
-			strWIDList[u8WidCnt].ps8WidVal = (s8 *)&strHostIFCfgParamAttr->pstrCfgParamVal.active_scan_time;
+			strWIDList[u8WidCnt].val = (s8 *)&strHostIFCfgParamAttr->pstrCfgParamVal.active_scan_time;
 			strWIDList[u8WidCnt].type = WID_SHORT;
 			strWIDList[u8WidCnt].size = sizeof(u16);
 			pstrWFIDrv->strCfgValues.active_scan_time = strHostIFCfgParamAttr->pstrCfgParamVal.active_scan_time;
@@ -1144,7 +1144,7 @@ static s32 Handle_CfgParam(struct host_if_drv *drvHandler,
 		/* range is 1 to 65535. */
 		if (strHostIFCfgParamAttr->pstrCfgParamVal.passive_scan_time > 0 && strHostIFCfgParamAttr->pstrCfgParamVal.passive_scan_time < 65536) {
 			strWIDList[u8WidCnt].id = WID_PASSIVE_SCAN_TIME;
-			strWIDList[u8WidCnt].ps8WidVal = (s8 *)&strHostIFCfgParamAttr->pstrCfgParamVal.passive_scan_time;
+			strWIDList[u8WidCnt].val = (s8 *)&strHostIFCfgParamAttr->pstrCfgParamVal.passive_scan_time;
 			strWIDList[u8WidCnt].type = WID_SHORT;
 			strWIDList[u8WidCnt].size = sizeof(u16);
 			pstrWFIDrv->strCfgValues.passive_scan_time = strHostIFCfgParamAttr->pstrCfgParamVal.passive_scan_time;
@@ -1169,7 +1169,7 @@ static s32 Handle_CfgParam(struct host_if_drv *drvHandler,
 		    || curr_tx_rate == MBPS_18 || curr_tx_rate == MBPS_24
 		    || curr_tx_rate == MBPS_36 || curr_tx_rate == MBPS_48 || curr_tx_rate == MBPS_54) {
 			strWIDList[u8WidCnt].id = WID_CURRENT_TX_RATE;
-			strWIDList[u8WidCnt].ps8WidVal = (s8 *)&curr_tx_rate;
+			strWIDList[u8WidCnt].val = (s8 *)&curr_tx_rate;
 			strWIDList[u8WidCnt].type = WID_SHORT;
 			strWIDList[u8WidCnt].size = sizeof(u16);
 			pstrWFIDrv->strCfgValues.curr_tx_rate = (u8)curr_tx_rate;
@@ -1261,9 +1261,9 @@ static s32 Handle_Scan(struct host_if_drv *drvHandler,
 	for (i = 0; i < pstrHostIFscanAttr->strHiddenNetwork.u8ssidnum; i++)
 		valuesize += ((pstrHostIFscanAttr->strHiddenNetwork.pstrHiddenNetworkInfo[i].u8ssidlen) + 1);
 	pu8HdnNtwrksWidVal = kmalloc(valuesize + 1, GFP_KERNEL);
-	strWIDList[u32WidsCount].ps8WidVal = pu8HdnNtwrksWidVal;
-	if (strWIDList[u32WidsCount].ps8WidVal != NULL) {
-		pu8Buffer = strWIDList[u32WidsCount].ps8WidVal;
+	strWIDList[u32WidsCount].val = pu8HdnNtwrksWidVal;
+	if (strWIDList[u32WidsCount].val != NULL) {
+		pu8Buffer = strWIDList[u32WidsCount].val;
 
 		*pu8Buffer++ = pstrHostIFscanAttr->strHiddenNetwork.u8ssidnum;
 
@@ -1288,7 +1288,7 @@ static s32 Handle_Scan(struct host_if_drv *drvHandler,
 		/* IEs to be inserted in Probe Request */
 		strWIDList[u32WidsCount].id = WID_INFO_ELEMENT_PROBE;
 		strWIDList[u32WidsCount].type = WID_BIN_DATA;
-		strWIDList[u32WidsCount].ps8WidVal = pstrHostIFscanAttr->pu8IEs;
+		strWIDList[u32WidsCount].val = pstrHostIFscanAttr->pu8IEs;
 		strWIDList[u32WidsCount].size = pstrHostIFscanAttr->IEsLen;
 		u32WidsCount++;
 	}
@@ -1297,7 +1297,7 @@ static s32 Handle_Scan(struct host_if_drv *drvHandler,
 	strWIDList[u32WidsCount].id = WID_SCAN_TYPE;
 	strWIDList[u32WidsCount].type = WID_CHAR;
 	strWIDList[u32WidsCount].size = sizeof(char);
-	strWIDList[u32WidsCount].ps8WidVal = (s8 *)(&(pstrHostIFscanAttr->u8ScanType));
+	strWIDList[u32WidsCount].val = (s8 *)(&(pstrHostIFscanAttr->u8ScanType));
 	u32WidsCount++;
 
 	/*list of channels to be scanned*/
@@ -1313,7 +1313,7 @@ static s32 Handle_Scan(struct host_if_drv *drvHandler,
 		}
 	}
 
-	strWIDList[u32WidsCount].ps8WidVal = pstrHostIFscanAttr->pu8ChnlFreqList;
+	strWIDList[u32WidsCount].val = pstrHostIFscanAttr->pu8ChnlFreqList;
 	strWIDList[u32WidsCount].size = pstrHostIFscanAttr->u8ChnlListLen;
 	u32WidsCount++;
 
@@ -1321,7 +1321,7 @@ static s32 Handle_Scan(struct host_if_drv *drvHandler,
 	strWIDList[u32WidsCount].id = WID_START_SCAN_REQ;
 	strWIDList[u32WidsCount].type = WID_CHAR;
 	strWIDList[u32WidsCount].size = sizeof(char);
-	strWIDList[u32WidsCount].ps8WidVal = (s8 *)(&(pstrHostIFscanAttr->u8ScanSource));
+	strWIDList[u32WidsCount].val = (s8 *)(&(pstrHostIFscanAttr->u8ScanSource));
 	u32WidsCount++;
 
 	/*keep the state as is , no need to change it*/
@@ -1403,7 +1403,7 @@ static s32 Handle_ScanDone(struct host_if_drv *drvHandler, tenuScanEvent enuEven
 		u8abort_running_scan = 1;
 		strWID.id = (u16)WID_ABORT_RUNNING_SCAN;
 		strWID.type = WID_CHAR;
-		strWID.ps8WidVal = (s8 *)&u8abort_running_scan;
+		strWID.val = (s8 *)&u8abort_running_scan;
 		strWID.size = sizeof(char);
 
 		/*Sending Cfg*/
@@ -1500,19 +1500,19 @@ static s32 Handle_Connect(struct host_if_drv *drvHandler,
 	strWIDList[u32WidsCount].id = WID_SUCCESS_FRAME_COUNT;
 	strWIDList[u32WidsCount].type = WID_INT;
 	strWIDList[u32WidsCount].size = sizeof(u32);
-	strWIDList[u32WidsCount].ps8WidVal = (s8 *)(&(dummyval));
+	strWIDList[u32WidsCount].val = (s8 *)(&(dummyval));
 	u32WidsCount++;
 
 	strWIDList[u32WidsCount].id = WID_RECEIVED_FRAGMENT_COUNT;
 	strWIDList[u32WidsCount].type = WID_INT;
 	strWIDList[u32WidsCount].size = sizeof(u32);
-	strWIDList[u32WidsCount].ps8WidVal = (s8 *)(&(dummyval));
+	strWIDList[u32WidsCount].val = (s8 *)(&(dummyval));
 	u32WidsCount++;
 
 	strWIDList[u32WidsCount].id = WID_FAILED_COUNT;
 	strWIDList[u32WidsCount].type = WID_INT;
 	strWIDList[u32WidsCount].size = sizeof(u32);
-	strWIDList[u32WidsCount].ps8WidVal = (s8 *)(&(dummyval));
+	strWIDList[u32WidsCount].val = (s8 *)(&(dummyval));
 	u32WidsCount++;
 
 	/* if((gWFiDrvHandle->strWILC_UsrConnReq.pu8ConnReqIEs != NULL) && */
@@ -1521,7 +1521,7 @@ static s32 Handle_Connect(struct host_if_drv *drvHandler,
 		/* IEs to be inserted in Association Request */
 		strWIDList[u32WidsCount].id = WID_INFO_ELEMENT_ASSOCIATE;
 		strWIDList[u32WidsCount].type = WID_BIN_DATA;
-		strWIDList[u32WidsCount].ps8WidVal = pstrWFIDrv->strWILC_UsrConnReq.pu8ConnReqIEs;
+		strWIDList[u32WidsCount].val = pstrWFIDrv->strWILC_UsrConnReq.pu8ConnReqIEs;
 		strWIDList[u32WidsCount].size = pstrWFIDrv->strWILC_UsrConnReq.ConnReqIEsLen;
 		u32WidsCount++;
 
@@ -1536,7 +1536,7 @@ static s32 Handle_Connect(struct host_if_drv *drvHandler,
 	strWIDList[u32WidsCount].id = (u16)WID_11I_MODE;
 	strWIDList[u32WidsCount].type = WID_CHAR;
 	strWIDList[u32WidsCount].size = sizeof(char);
-	strWIDList[u32WidsCount].ps8WidVal = (s8 *)(&(pstrWFIDrv->strWILC_UsrConnReq.u8security));
+	strWIDList[u32WidsCount].val = (s8 *)(&(pstrWFIDrv->strWILC_UsrConnReq.u8security));
 	u32WidsCount++;
 
 	if (memcmp("DIRECT-", pstrHostIFconnectAttr->pu8ssid, 7))
@@ -1548,7 +1548,7 @@ static s32 Handle_Connect(struct host_if_drv *drvHandler,
 	strWIDList[u32WidsCount].id = (u16)WID_AUTH_TYPE;
 	strWIDList[u32WidsCount].type = WID_CHAR;
 	strWIDList[u32WidsCount].size = sizeof(char);
-	strWIDList[u32WidsCount].ps8WidVal = (s8 *)(&pstrWFIDrv->strWILC_UsrConnReq.tenuAuth_type);
+	strWIDList[u32WidsCount].val = (s8 *)(&pstrWFIDrv->strWILC_UsrConnReq.tenuAuth_type);
 	u32WidsCount++;
 
 	if (memcmp("DIRECT-", pstrHostIFconnectAttr->pu8ssid, 7))
@@ -1571,18 +1571,18 @@ static s32 Handle_Connect(struct host_if_drv *drvHandler,
 
 	/*Sending NoA attributes during connection*/
 	strWIDList[u32WidsCount].size = 112; /* 79; */
-	strWIDList[u32WidsCount].ps8WidVal = kmalloc(strWIDList[u32WidsCount].size, GFP_KERNEL);
+	strWIDList[u32WidsCount].val = kmalloc(strWIDList[u32WidsCount].size, GFP_KERNEL);
 
 	if (memcmp("DIRECT-", pstrHostIFconnectAttr->pu8ssid, 7)) {
 		gu32FlushedJoinReqSize = strWIDList[u32WidsCount].size;
 		gu8FlushedJoinReq = kmalloc(gu32FlushedJoinReqSize, GFP_KERNEL);
 	}
-	if (strWIDList[u32WidsCount].ps8WidVal == NULL) {
+	if (strWIDList[u32WidsCount].val == NULL) {
 		s32Error = -EFAULT;
 		goto ERRORHANDLER;
 	}
 
-	pu8CurrByte = strWIDList[u32WidsCount].ps8WidVal;
+	pu8CurrByte = strWIDList[u32WidsCount].val;
 
 
 	if (pstrHostIFconnectAttr->pu8ssid != NULL) {
@@ -1694,7 +1694,7 @@ static s32 Handle_Connect(struct host_if_drv *drvHandler,
 		PRINT_D(HOSTINF_DBG, "NOA not present\n");
 
 	/* keep the buffer at the start of the allocated pointer to use it with the free*/
-	pu8CurrByte = strWIDList[u32WidsCount].ps8WidVal;
+	pu8CurrByte = strWIDList[u32WidsCount].val;
 	u32WidsCount++;
 
 	/* A temporary workaround to avoid handling the misleading MAC_DISCONNECTED raised from the
@@ -1815,14 +1815,14 @@ static s32 Handle_FlushConnect(struct host_if_drv *drvHandler)
 	/* IEs to be inserted in Association Request */
 	strWIDList[u32WidsCount].id = WID_INFO_ELEMENT_ASSOCIATE;
 	strWIDList[u32WidsCount].type = WID_BIN_DATA;
-	strWIDList[u32WidsCount].ps8WidVal = gu8FlushedInfoElemAsoc;
+	strWIDList[u32WidsCount].val = gu8FlushedInfoElemAsoc;
 	strWIDList[u32WidsCount].size = gu32FlushedInfoElemAsocSize;
 	u32WidsCount++;
 
 	strWIDList[u32WidsCount].id = (u16)WID_11I_MODE;
 	strWIDList[u32WidsCount].type = WID_CHAR;
 	strWIDList[u32WidsCount].size = sizeof(char);
-	strWIDList[u32WidsCount].ps8WidVal = (s8 *)(&(gu8Flushed11iMode));
+	strWIDList[u32WidsCount].val = (s8 *)(&(gu8Flushed11iMode));
 	u32WidsCount++;
 
 
@@ -1830,14 +1830,14 @@ static s32 Handle_FlushConnect(struct host_if_drv *drvHandler)
 	strWIDList[u32WidsCount].id = (u16)WID_AUTH_TYPE;
 	strWIDList[u32WidsCount].type = WID_CHAR;
 	strWIDList[u32WidsCount].size = sizeof(char);
-	strWIDList[u32WidsCount].ps8WidVal = (s8 *)(&gu8FlushedAuthType);
+	strWIDList[u32WidsCount].val = (s8 *)(&gu8FlushedAuthType);
 	u32WidsCount++;
 
 	strWIDList[u32WidsCount].id = (u16)WID_JOIN_REQ_EXTENDED;
 	strWIDList[u32WidsCount].type = WID_STR;
 	strWIDList[u32WidsCount].size = gu32FlushedJoinReqSize;
-	strWIDList[u32WidsCount].ps8WidVal = (s8 *)gu8FlushedJoinReq;
-	pu8CurrByte = strWIDList[u32WidsCount].ps8WidVal;
+	strWIDList[u32WidsCount].val = (s8 *)gu8FlushedJoinReq;
+	pu8CurrByte = strWIDList[u32WidsCount].val;
 
 	pu8CurrByte += FLUSHED_BYTE_POS;
 	*(pu8CurrByte) = FLUSHED_JOIN_REQ;
@@ -1920,7 +1920,7 @@ static s32 Handle_ConnectTimeout(struct host_if_drv *drvHandler)
 	 *   WID_DISCONNECT} */
 	strWID.id = (u16)WID_DISCONNECT;
 	strWID.type = WID_CHAR;
-	strWID.ps8WidVal = (s8 *)&u16DummyReasonCode;
+	strWID.val = (s8 *)&u16DummyReasonCode;
 	strWID.size = sizeof(char);
 
 	PRINT_D(HOSTINF_DBG, "Sending disconnect request\n");
@@ -2428,17 +2428,17 @@ static int Handle_Key(struct host_if_drv *drvHandler,
 			strWIDList[0].id = (u16)WID_11I_MODE;
 			strWIDList[0].type = WID_CHAR;
 			strWIDList[0].size = sizeof(char);
-			strWIDList[0].ps8WidVal = (s8 *)(&(pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFwepAttr.u8mode));
+			strWIDList[0].val = (s8 *)(&(pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFwepAttr.u8mode));
 
 			strWIDList[1].id = WID_AUTH_TYPE;
 			strWIDList[1].type = WID_CHAR;
 			strWIDList[1].size = sizeof(char);
-			strWIDList[1].ps8WidVal = (s8 *)(&(pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFwepAttr.tenuAuth_type));
+			strWIDList[1].val = (s8 *)(&(pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFwepAttr.tenuAuth_type));
 
 			strWIDList[2].id = (u16)WID_KEY_ID;
 			strWIDList[2].type = WID_CHAR;
 
-			strWIDList[2].ps8WidVal	= (s8 *)(&(pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFwepAttr.u8Wepidx));
+			strWIDList[2].val = (s8 *)(&(pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFwepAttr.u8Wepidx));
 			strWIDList[2].size = sizeof(char);
 
 
@@ -2459,7 +2459,7 @@ static int Handle_Key(struct host_if_drv *drvHandler,
 			strWIDList[3].id = (u16)WID_WEP_KEY_VALUE;
 			strWIDList[3].type = WID_STR;
 			strWIDList[3].size = pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFwepAttr.u8WepKeylen;
-			strWIDList[3].ps8WidVal = (s8 *)pu8keybuf;
+			strWIDList[3].val = (s8 *)pu8keybuf;
 
 
 			s32Error = send_config_pkt(SET_CFG, strWIDList, 4,
@@ -2487,7 +2487,7 @@ static int Handle_Key(struct host_if_drv *drvHandler,
 
 			strWID.id = (u16)WID_ADD_WEP_KEY;
 			strWID.type = WID_STR;
-			strWID.ps8WidVal	= (s8 *)pu8keybuf;
+			strWID.val = (s8 *)pu8keybuf;
 			strWID.size = pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFwepAttr.u8WepKeylen + 2;
 
 			s32Error = send_config_pkt(SET_CFG, &strWID, 1,
@@ -2500,7 +2500,7 @@ static int Handle_Key(struct host_if_drv *drvHandler,
 			strWID.type = WID_STR;
 
 			s8idxarray[0] = (s8)pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFwepAttr.u8Wepidx;
-			strWID.ps8WidVal = s8idxarray;
+			strWID.val = s8idxarray;
 			strWID.size = 1;
 
 			s32Error = send_config_pkt(SET_CFG, &strWID, 1,
@@ -2508,7 +2508,7 @@ static int Handle_Key(struct host_if_drv *drvHandler,
 		} else {
 			strWID.id = (u16)WID_KEY_ID;
 			strWID.type = WID_CHAR;
-			strWID.ps8WidVal	= (s8 *)(&(pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFwepAttr.u8Wepidx));
+			strWID.val = (s8 *)(&(pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFwepAttr.u8Wepidx));
 			strWID.size = sizeof(char);
 
 			PRINT_D(HOSTINF_DBG, "Setting default key index\n");
@@ -2552,11 +2552,11 @@ static int Handle_Key(struct host_if_drv *drvHandler,
 			strWIDList[0].id = (u16)WID_11I_MODE;
 			strWIDList[0].type = WID_CHAR;
 			strWIDList[0].size = sizeof(char);
-			strWIDList[0].ps8WidVal = (s8 *)(&(pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFwpaAttr.u8Ciphermode));
+			strWIDList[0].val = (s8 *)(&(pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFwpaAttr.u8Ciphermode));
 
 			strWIDList[1].id = (u16)WID_ADD_RX_GTK;
 			strWIDList[1].type = WID_STR;
-			strWIDList[1].ps8WidVal	= (s8 *)pu8keybuf;
+			strWIDList[1].val = (s8 *)pu8keybuf;
 			strWIDList[1].size = RX_MIC_KEY_MSG_LEN;
 
 			s32Error = send_config_pkt(SET_CFG, strWIDList, 2,
@@ -2602,7 +2602,7 @@ static int Handle_Key(struct host_if_drv *drvHandler,
 
 			strWID.id = (u16)WID_ADD_RX_GTK;
 			strWID.type = WID_STR;
-			strWID.ps8WidVal	= (s8 *)pu8keybuf;
+			strWID.val = (s8 *)pu8keybuf;
 			strWID.size = RX_MIC_KEY_MSG_LEN;
 
 			s32Error = send_config_pkt(SET_CFG, &strWID, 1,
@@ -2655,11 +2655,11 @@ _WPARxGtk_end_case_:
 			strWIDList[0].id = (u16)WID_11I_MODE;
 			strWIDList[0].type = WID_CHAR;
 			strWIDList[0].size = sizeof(char);
-			strWIDList[0].ps8WidVal = (s8 *)(&(pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFwpaAttr.u8Ciphermode));
+			strWIDList[0].val = (s8 *)(&(pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFwpaAttr.u8Ciphermode));
 
 			strWIDList[1].id = (u16)WID_ADD_PTK;
 			strWIDList[1].type = WID_STR;
-			strWIDList[1].ps8WidVal	= (s8 *)pu8keybuf;
+			strWIDList[1].val = (s8 *)pu8keybuf;
 			strWIDList[1].size = PTK_KEY_MSG_LEN + 1;
 
 			s32Error = send_config_pkt(SET_CFG, strWIDList, 2,
@@ -2700,7 +2700,7 @@ _WPARxGtk_end_case_:
 
 			strWID.id = (u16)WID_ADD_PTK;
 			strWID.type = WID_STR;
-			strWID.ps8WidVal	= (s8 *)pu8keybuf;
+			strWID.val = (s8 *)pu8keybuf;
 			strWID.size = PTK_KEY_MSG_LEN;
 
 			s32Error = send_config_pkt(SET_CFG, &strWID, 1,
@@ -2740,7 +2740,7 @@ _WPAPtk_end_case_:
 
 		strWID.id = (u16)WID_PMKID_INFO;
 		strWID.type = WID_STR;
-		strWID.ps8WidVal = (s8 *)pu8keybuf;
+		strWID.val = (s8 *)pu8keybuf;
 		strWID.size = (pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFpmkidAttr.numpmkid * PMKSA_KEY_LEN) + 1;
 
 		s32Error = send_config_pkt(SET_CFG, &strWID, 1,
@@ -2778,7 +2778,7 @@ static void Handle_Disconnect(struct host_if_drv *drvHandler)
 
 	strWID.id = (u16)WID_DISCONNECT;
 	strWID.type = WID_CHAR;
-	strWID.ps8WidVal = (s8 *)&u16DummyReasonCode;
+	strWID.val = (s8 *)&u16DummyReasonCode;
 	strWID.size = sizeof(char);
 
 
@@ -2902,7 +2902,7 @@ static s32 Handle_GetChnl(struct host_if_drv *drvHandler)
 
 	strWID.id = (u16)WID_CURRENT_CHANNEL;
 	strWID.type = WID_CHAR;
-	strWID.ps8WidVal = (s8 *)&gu8Chnl;
+	strWID.val = (s8 *)&gu8Chnl;
 	strWID.size = sizeof(char);
 
 	PRINT_D(HOSTINF_DBG, "Getting channel value\n");
@@ -2941,7 +2941,7 @@ static void Handle_GetRssi(struct host_if_drv *drvHandler)
 
 	strWID.id = (u16)WID_RSSI;
 	strWID.type = WID_CHAR;
-	strWID.ps8WidVal = &gs8Rssi;
+	strWID.val = &gs8Rssi;
 	strWID.size = sizeof(char);
 
 	/*Sending Cfg*/
@@ -2970,7 +2970,7 @@ static void Handle_GetLinkspeed(struct host_if_drv *drvHandler)
 
 	strWID.id = (u16)WID_LINKSPEED;
 	strWID.type = WID_CHAR;
-	strWID.ps8WidVal = &gs8lnkspd;
+	strWID.val = &gs8lnkspd;
 	strWID.size = sizeof(char);
 	/*Sending Cfg*/
 	PRINT_D(HOSTINF_DBG, "Getting LINKSPEED value\n");
@@ -2995,31 +2995,31 @@ s32 Handle_GetStatistics(struct host_if_drv *drvHandler, tstrStatistics *pstrSta
 	strWIDList[u32WidsCount].id = WID_LINKSPEED;
 	strWIDList[u32WidsCount].type = WID_CHAR;
 	strWIDList[u32WidsCount].size = sizeof(char);
-	strWIDList[u32WidsCount].ps8WidVal = (s8 *)(&(pstrStatistics->u8LinkSpeed));
+	strWIDList[u32WidsCount].val = (s8 *)(&(pstrStatistics->u8LinkSpeed));
 	u32WidsCount++;
 
 	strWIDList[u32WidsCount].id = WID_RSSI;
 	strWIDList[u32WidsCount].type = WID_CHAR;
 	strWIDList[u32WidsCount].size = sizeof(char);
-	strWIDList[u32WidsCount].ps8WidVal = (s8 *)(&(pstrStatistics->s8RSSI));
+	strWIDList[u32WidsCount].val = (s8 *)(&(pstrStatistics->s8RSSI));
 	u32WidsCount++;
 
 	strWIDList[u32WidsCount].id = WID_SUCCESS_FRAME_COUNT;
 	strWIDList[u32WidsCount].type = WID_INT;
 	strWIDList[u32WidsCount].size = sizeof(u32);
-	strWIDList[u32WidsCount].ps8WidVal = (s8 *)(&(pstrStatistics->u32TxCount));
+	strWIDList[u32WidsCount].val = (s8 *)(&(pstrStatistics->u32TxCount));
 	u32WidsCount++;
 
 	strWIDList[u32WidsCount].id = WID_RECEIVED_FRAGMENT_COUNT;
 	strWIDList[u32WidsCount].type = WID_INT;
 	strWIDList[u32WidsCount].size = sizeof(u32);
-	strWIDList[u32WidsCount].ps8WidVal = (s8 *)(&(pstrStatistics->u32RxCount));
+	strWIDList[u32WidsCount].val = (s8 *)(&(pstrStatistics->u32RxCount));
 	u32WidsCount++;
 
 	strWIDList[u32WidsCount].id = WID_FAILED_COUNT;
 	strWIDList[u32WidsCount].type = WID_INT;
 	strWIDList[u32WidsCount].size = sizeof(u32);
-	strWIDList[u32WidsCount].ps8WidVal = (s8 *)(&(pstrStatistics->u32TxFailureCount));
+	strWIDList[u32WidsCount].val = (s8 *)(&(pstrStatistics->u32TxFailureCount));
 	u32WidsCount++;
 
 	s32Error = send_config_pkt(GET_CFG, strWIDList, u32WidsCount,
@@ -3057,10 +3057,10 @@ static s32 Handle_Get_InActiveTime(struct host_if_drv *drvHandler,
 	strWID.id = (u16)WID_SET_STA_MAC_INACTIVE_TIME;
 	strWID.type = WID_STR;
 	strWID.size = ETH_ALEN;
-	strWID.ps8WidVal = kmalloc(strWID.size, GFP_KERNEL);
+	strWID.val = kmalloc(strWID.size, GFP_KERNEL);
 
 
-	stamac = strWID.ps8WidVal;
+	stamac = strWID.val;
 	memcpy(stamac, strHostIfStaInactiveT->mac, ETH_ALEN);
 
 
@@ -3078,7 +3078,7 @@ static s32 Handle_Get_InActiveTime(struct host_if_drv *drvHandler,
 
 	strWID.id = (u16)WID_GET_INACTIVE_TIME;
 	strWID.type = WID_INT;
-	strWID.ps8WidVal = (s8 *)&gu32InactiveTime;
+	strWID.val = (s8 *)&gu32InactiveTime;
 	strWID.size = sizeof(u32);
 
 
@@ -3124,11 +3124,11 @@ static void Handle_AddBeacon(struct host_if_drv *drvHandler,
 	strWID.id = (u16)WID_ADD_BEACON;
 	strWID.type = WID_BIN;
 	strWID.size = pstrSetBeaconParam->u32HeadLen + pstrSetBeaconParam->u32TailLen + 16;
-	strWID.ps8WidVal = kmalloc(strWID.size, GFP_KERNEL);
-	if (strWID.ps8WidVal == NULL)
+	strWID.val = kmalloc(strWID.size, GFP_KERNEL);
+	if (strWID.val == NULL)
 		goto ERRORHANDLER;
 
-	pu8CurrByte = strWID.ps8WidVal;
+	pu8CurrByte = strWID.val;
 	*pu8CurrByte++ = (pstrSetBeaconParam->u32Interval & 0xFF);
 	*pu8CurrByte++ = ((pstrSetBeaconParam->u32Interval >> 8) & 0xFF);
 	*pu8CurrByte++ = ((pstrSetBeaconParam->u32Interval >> 16) & 0xFF);
@@ -3165,7 +3165,7 @@ static void Handle_AddBeacon(struct host_if_drv *drvHandler,
 		PRINT_ER("Failed to send add beacon config packet\n");
 
 ERRORHANDLER:
-	kfree(strWID.ps8WidVal);
+	kfree(strWID.val);
 	kfree(pstrSetBeaconParam->pu8Head);
 	kfree(pstrSetBeaconParam->pu8Tail);
 }
@@ -3190,12 +3190,12 @@ static void Handle_DelBeacon(struct host_if_drv *drvHandler)
 	strWID.id = (u16)WID_DEL_BEACON;
 	strWID.type = WID_CHAR;
 	strWID.size = sizeof(char);
-	strWID.ps8WidVal = &gu8DelBcn;
+	strWID.val = &gu8DelBcn;
 
-	if (strWID.ps8WidVal == NULL)
+	if (strWID.val == NULL)
 		return;
 
-	pu8CurrByte = strWID.ps8WidVal;
+	pu8CurrByte = strWID.val;
 
 	PRINT_D(HOSTINF_DBG, "Deleting BEACON\n");
 	/* TODO: build del beacon message*/
@@ -3285,11 +3285,11 @@ static void Handle_AddStation(struct host_if_drv *drvHandler,
 	strWID.type = WID_BIN;
 	strWID.size = WILC_ADD_STA_LENGTH + pstrStationParam->u8NumRates;
 
-	strWID.ps8WidVal = kmalloc(strWID.size, GFP_KERNEL);
-	if (strWID.ps8WidVal == NULL)
+	strWID.val = kmalloc(strWID.size, GFP_KERNEL);
+	if (strWID.val == NULL)
 		goto ERRORHANDLER;
 
-	pu8CurrByte = strWID.ps8WidVal;
+	pu8CurrByte = strWID.val;
 	pu8CurrByte += WILC_HostIf_PackStaParam(pu8CurrByte, pstrStationParam);
 
 	/*Sending Cfg*/
@@ -3300,7 +3300,7 @@ static void Handle_AddStation(struct host_if_drv *drvHandler,
 
 ERRORHANDLER:
 	kfree(pstrStationParam->pu8Rates);
-	kfree(strWID.ps8WidVal);
+	kfree(strWID.val);
 }
 
 /**
@@ -3329,11 +3329,11 @@ static void Handle_DelAllSta(struct host_if_drv *drvHandler,
 
 	PRINT_D(HOSTINF_DBG, "Handling delete station\n");
 
-	strWID.ps8WidVal = kmalloc((pstrDelAllStaParam->u8Num_AssocSta * ETH_ALEN) + 1, GFP_KERNEL);
-	if (strWID.ps8WidVal == NULL)
+	strWID.val = kmalloc((pstrDelAllStaParam->u8Num_AssocSta * ETH_ALEN) + 1, GFP_KERNEL);
+	if (strWID.val == NULL)
 		goto ERRORHANDLER;
 
-	pu8CurrByte = strWID.ps8WidVal;
+	pu8CurrByte = strWID.val;
 
 	*(pu8CurrByte++) = pstrDelAllStaParam->u8Num_AssocSta;
 
@@ -3353,7 +3353,7 @@ static void Handle_DelAllSta(struct host_if_drv *drvHandler,
 		PRINT_ER("Failed to send add station config packet\n");
 
 ERRORHANDLER:
-	kfree(strWID.ps8WidVal);
+	kfree(strWID.val);
 
 	up(&hWaitResponse);
 }
@@ -3382,11 +3382,11 @@ static void Handle_DelStation(struct host_if_drv *drvHandler,
 
 	PRINT_D(HOSTINF_DBG, "Handling delete station\n");
 
-	strWID.ps8WidVal = kmalloc(strWID.size, GFP_KERNEL);
-	if (strWID.ps8WidVal == NULL)
+	strWID.val = kmalloc(strWID.size, GFP_KERNEL);
+	if (strWID.val == NULL)
 		goto ERRORHANDLER;
 
-	pu8CurrByte = strWID.ps8WidVal;
+	pu8CurrByte = strWID.val;
 
 	memcpy(pu8CurrByte, pstrDelStaParam->au8MacAddr, ETH_ALEN);
 
@@ -3397,7 +3397,7 @@ static void Handle_DelStation(struct host_if_drv *drvHandler,
 		PRINT_ER("Failed to send add station config packet\n");
 
 ERRORHANDLER:
-	kfree(strWID.ps8WidVal);
+	kfree(strWID.val);
 }
 
 
@@ -3423,11 +3423,11 @@ static void Handle_EditStation(struct host_if_drv *drvHandler,
 	strWID.size = WILC_ADD_STA_LENGTH + pstrStationParam->u8NumRates;
 
 	PRINT_D(HOSTINF_DBG, "Handling edit station\n");
-	strWID.ps8WidVal = kmalloc(strWID.size, GFP_KERNEL);
-	if (strWID.ps8WidVal == NULL)
+	strWID.val = kmalloc(strWID.size, GFP_KERNEL);
+	if (strWID.val == NULL)
 		goto ERRORHANDLER;
 
-	pu8CurrByte = strWID.ps8WidVal;
+	pu8CurrByte = strWID.val;
 	pu8CurrByte += WILC_HostIf_PackStaParam(pu8CurrByte, pstrStationParam);
 
 	/*Sending Cfg*/
@@ -3438,7 +3438,7 @@ static void Handle_EditStation(struct host_if_drv *drvHandler,
 
 ERRORHANDLER:
 	kfree(pstrStationParam->pu8Rates);
-	kfree(strWID.ps8WidVal);
+	kfree(strWID.val);
 }
 
 /**
@@ -3494,15 +3494,15 @@ static int Handle_RemainOnChan(struct host_if_drv *drvHandler,
 	strWID.id = (u16)WID_REMAIN_ON_CHAN;
 	strWID.type = WID_STR;
 	strWID.size = 2;
-	strWID.ps8WidVal = kmalloc(strWID.size, GFP_KERNEL);
+	strWID.val = kmalloc(strWID.size, GFP_KERNEL);
 
-	if (strWID.ps8WidVal == NULL) {
+	if (strWID.val == NULL) {
 		s32Error = -ENOMEM;
 		goto ERRORHANDLER;
 	}
 
-	strWID.ps8WidVal[0] = u8remain_on_chan_flag;
-	strWID.ps8WidVal[1] = (s8)pstrHostIfRemainOnChan->u16Channel;
+	strWID.val[0] = u8remain_on_chan_flag;
+	strWID.val[1] = (s8)pstrHostIfRemainOnChan->u16Channel;
 
 	/*Sending Cfg*/
 	s32Error = send_config_pkt(SET_CFG, &strWID, 1,
@@ -3550,11 +3550,11 @@ static int Handle_RegisterFrame(struct host_if_drv *drvHandler,
 	/*prepare configuration packet*/
 	strWID.id = (u16)WID_REGISTER_FRAME;
 	strWID.type = WID_STR;
-	strWID.ps8WidVal = kmalloc(sizeof(u16) + 2, GFP_KERNEL);
-	if (strWID.ps8WidVal == NULL)
+	strWID.val = kmalloc(sizeof(u16) + 2, GFP_KERNEL);
+	if (strWID.val == NULL)
 		return -ENOMEM;
 
-	pu8CurrByte = strWID.ps8WidVal;
+	pu8CurrByte = strWID.val;
 
 	*pu8CurrByte++ = pstrHostIfRegisterFrame->bReg;
 	*pu8CurrByte++ = pstrHostIfRegisterFrame->u8Regid;
@@ -3603,13 +3603,13 @@ static u32 Handle_ListenStateExpired(struct host_if_drv *drvHandler,
 		strWID.id = (u16)WID_REMAIN_ON_CHAN;
 		strWID.type = WID_STR;
 		strWID.size = 2;
-		strWID.ps8WidVal = kmalloc(strWID.size, GFP_KERNEL);
+		strWID.val = kmalloc(strWID.size, GFP_KERNEL);
 
-		if (strWID.ps8WidVal == NULL)
+		if (strWID.val == NULL)
 			PRINT_ER("Failed to allocate memory\n");
 
-		strWID.ps8WidVal[0] = u8remain_on_chan_flag;
-		strWID.ps8WidVal[1] = FALSE_FRMWR_CHANNEL;
+		strWID.val[0] = u8remain_on_chan_flag;
+		strWID.val[1] = FALSE_FRMWR_CHANNEL;
 
 		/*Sending Cfg*/
 		s32Error = send_config_pkt(SET_CFG, &strWID, 1,
@@ -3687,7 +3687,7 @@ static void Handle_PowerManagement(struct host_if_drv *drvHandler,
 	else
 		s8PowerMode = NO_POWERSAVE;
 	PRINT_D(HOSTINF_DBG, "Handling power mgmt to %d\n", s8PowerMode);
-	strWID.ps8WidVal = &s8PowerMode;
+	strWID.val = &s8PowerMode;
 	strWID.size = sizeof(char);
 
 	PRINT_D(HOSTINF_DBG, "Handling Power Management\n");
@@ -3720,11 +3720,11 @@ static void Handle_SetMulticastFilter(struct host_if_drv *drvHandler,
 	strWID.id = (u16)WID_SETUP_MULTICAST_FILTER;
 	strWID.type = WID_BIN;
 	strWID.size = sizeof(struct set_multicast) + ((strHostIfSetMulti->u32count) * ETH_ALEN);
-	strWID.ps8WidVal = kmalloc(strWID.size, GFP_KERNEL);
-	if (strWID.ps8WidVal == NULL)
+	strWID.val = kmalloc(strWID.size, GFP_KERNEL);
+	if (strWID.val == NULL)
 		goto ERRORHANDLER;
 
-	pu8CurrByte = strWID.ps8WidVal;
+	pu8CurrByte = strWID.val;
 	*pu8CurrByte++ = (strHostIfSetMulti->bIsEnabled & 0xFF);
 	*pu8CurrByte++ = ((strHostIfSetMulti->bIsEnabled >> 8) & 0xFF);
 	*pu8CurrByte++ = ((strHostIfSetMulti->bIsEnabled >> 16) & 0xFF);
@@ -3745,7 +3745,7 @@ static void Handle_SetMulticastFilter(struct host_if_drv *drvHandler,
 		PRINT_ER("Failed to send setup multicast config packet\n");
 
 ERRORHANDLER:
-	kfree(strWID.ps8WidVal);
+	kfree(strWID.val);
 
 }
 
@@ -3778,9 +3778,9 @@ static s32 Handle_AddBASession(struct host_if_drv *drvHandler,
 
 	strWID.id = (u16)WID_11E_P_ACTION_REQ;
 	strWID.type = WID_STR;
-	strWID.ps8WidVal = kmalloc(BLOCK_ACK_REQ_SIZE, GFP_KERNEL);
+	strWID.val = kmalloc(BLOCK_ACK_REQ_SIZE, GFP_KERNEL);
 	strWID.size = BLOCK_ACK_REQ_SIZE;
-	ptr = strWID.ps8WidVal;
+	ptr = strWID.val;
 	/* *ptr++ = 0x14; */
 	*ptr++ = 0x14;
 	*ptr++ = 0x3;
@@ -3813,7 +3813,7 @@ static s32 Handle_AddBASession(struct host_if_drv *drvHandler,
 	strWID.id = (u16)WID_11E_P_ACTION_REQ;
 	strWID.type = WID_STR;
 	strWID.size = 15;
-	ptr = strWID.ps8WidVal;
+	ptr = strWID.val;
 	/* *ptr++ = 0x14; */
 	*ptr++ = 15;
 	*ptr++ = 7;
@@ -3832,8 +3832,8 @@ static s32 Handle_AddBASession(struct host_if_drv *drvHandler,
 	s32Error = send_config_pkt(SET_CFG, &strWID, 1,
 				   get_id_from_handler(pstrWFIDrv));
 
-	if (strWID.ps8WidVal != NULL)
-		kfree(strWID.ps8WidVal);
+	if (strWID.val != NULL)
+		kfree(strWID.val);
 
 	return s32Error;
 
@@ -3864,9 +3864,9 @@ static s32 Handle_DelAllRxBASessions(struct host_if_drv *drvHandler,
 
 	strWID.id = (u16)WID_DEL_ALL_RX_BA;
 	strWID.type = WID_STR;
-	strWID.ps8WidVal = kmalloc(BLOCK_ACK_REQ_SIZE, GFP_KERNEL);
+	strWID.val = kmalloc(BLOCK_ACK_REQ_SIZE, GFP_KERNEL);
 	strWID.size = BLOCK_ACK_REQ_SIZE;
-	ptr = strWID.ps8WidVal;
+	ptr = strWID.val;
 	*ptr++ = 0x14;
 	*ptr++ = 0x3;
 	*ptr++ = 0x2;
@@ -3884,8 +3884,8 @@ static s32 Handle_DelAllRxBASessions(struct host_if_drv *drvHandler,
 		PRINT_D(HOSTINF_DBG, "Couldn't delete BA Session\n");
 
 
-	if (strWID.ps8WidVal != NULL)
-		kfree(strWID.ps8WidVal);
+	if (strWID.val != NULL)
+		kfree(strWID.val);
 
 	up(&hWaitResponse);
 
@@ -4163,7 +4163,7 @@ s32 host_int_remove_key(struct host_if_drv *hWFIDrv, const u8 *pu8StaAddress)
 
 	strWID.id = (u16)WID_REMOVE_KEY;
 	strWID.type = WID_STR;
-	strWID.ps8WidVal	= (s8 *)pu8StaAddress;
+	strWID.val = (s8 *)pu8StaAddress;
 	strWID.size = 6;
 
 	return 0;
@@ -4681,7 +4681,7 @@ s32 host_int_get_pmkid_info(struct host_if_drv *hWFIDrv, u8 *pu8PmkidInfoArray,
 	strWID.id = (u16)WID_PMKID_INFO;
 	strWID.type = WID_STR;
 	strWID.size = u32PmkidInfoLen;
-	strWID.ps8WidVal = pu8PmkidInfoArray;
+	strWID.val = pu8PmkidInfoArray;
 
 	return 0;
 }
@@ -4709,7 +4709,7 @@ s32 host_int_set_RSNAConfigPSKPassPhrase(struct host_if_drv *hWFIDrv, u8 *pu8Pas
 	if ((u8Psklength > 7) && (u8Psklength < 65)) {
 		strWID.id = (u16)WID_11I_PSK;
 		strWID.type = WID_STR;
-		strWID.ps8WidVal	= pu8PassPhrase;
+		strWID.val = pu8PassPhrase;
 		strWID.size = u8Psklength;
 	}
 
@@ -4803,7 +4803,7 @@ s32 host_int_get_RSNAConfigPSKPassPhrase(struct host_if_drv *hWFIDrv,
 	strWID.id = (u16)WID_11I_PSK;
 	strWID.type = WID_STR;
 	strWID.size = u8Psklength;
-	strWID.ps8WidVal	= pu8PassPhrase;
+	strWID.val = pu8PassPhrase;
 
 	return 0;
 }
@@ -4829,7 +4829,7 @@ s32 host_int_set_start_scan_req(struct host_if_drv *hWFIDrv, u8 scanSource)
 
 	strWID.id = (u16)WID_START_SCAN_REQ;
 	strWID.type = WID_CHAR;
-	strWID.ps8WidVal = (s8 *)&scanSource;
+	strWID.val = (s8 *)&scanSource;
 	strWID.size = sizeof(char);
 
 	return 0;
@@ -4857,7 +4857,7 @@ s32 host_int_get_start_scan_req(struct host_if_drv *hWFIDrv, u8 *pu8ScanSource)
 
 	strWID.id = (u16)WID_START_SCAN_REQ;
 	strWID.type = WID_CHAR;
-	strWID.ps8WidVal = (s8 *)pu8ScanSource;
+	strWID.val = (s8 *)pu8ScanSource;
 	strWID.size = sizeof(char);
 
 	return 0;
@@ -5054,7 +5054,7 @@ s32 host_int_disconnect_station(struct host_if_drv *hWFIDrv, u8 assoc_id)
 
 	strWID.id = (u16)WID_DISCONNECT;
 	strWID.type = WID_CHAR;
-	strWID.ps8WidVal = (s8 *)&assoc_id;
+	strWID.val = (s8 *)&assoc_id;
 	strWID.size = sizeof(char);
 
 	return 0;
@@ -5093,7 +5093,7 @@ s32 host_int_get_assoc_req_info(struct host_if_drv *hWFIDrv, u8 *pu8AssocReqInfo
 
 	strWID.id = (u16)WID_ASSOC_REQ_INFO;
 	strWID.type = WID_STR;
-	strWID.ps8WidVal = pu8AssocReqInfo;
+	strWID.val = pu8AssocReqInfo;
 	strWID.size = u32AssocReqInfoLen;
 
 	return 0;
@@ -5124,7 +5124,7 @@ s32 host_int_get_assoc_res_info(struct host_if_drv *hWFIDrv, u8 *pu8AssocRespInf
 
 	strWID.id = (u16)WID_ASSOC_RES_INFO;
 	strWID.type = WID_STR;
-	strWID.ps8WidVal = pu8AssocRespInfo;
+	strWID.val = pu8AssocRespInfo;
 	strWID.size = u32MaxAssocRespInfoLen;
 
 
@@ -5164,7 +5164,7 @@ s32 host_int_get_rx_power_level(struct host_if_drv *hWFIDrv, u8 *pu8RxPowerLevel
 
 	strWID.id = (u16)WID_RX_POWER_LEVEL;
 	strWID.type = WID_STR;
-	strWID.ps8WidVal = pu8RxPowerLevel;
+	strWID.val = pu8RxPowerLevel;
 	strWID.size = u32RxPowerLevelLen;
 
 	return 0;
@@ -5390,7 +5390,7 @@ s32 host_int_test_get_int_wid(struct host_if_drv *hWFIDrv, u32 *pu32TestMemAddr)
 
 	strWID.id = (u16)WID_MEMORY_ADDRESS;
 	strWID.type = WID_INT;
-	strWID.ps8WidVal = (s8 *)pu32TestMemAddr;
+	strWID.val = (s8 *)pu32TestMemAddr;
 	strWID.size = sizeof(u32);
 
 	s32Error = send_config_pkt(GET_CFG, &strWID, 1,
-- 
1.9.1

