Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:18817 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752163AbbJFJnO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Oct 2015 05:43:14 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 06/10] staging: wilc1000: rename the member variable, ps8WidVal of wid
Date: Tue, 6 Oct 2015 18:42:17 +0900
Message-ID: <1444124541-5663-6-git-send-email-tony.cho@atmel.com> (sfid-20151006_114318_744136_4AA5C906)
In-Reply-To: <1444124541-5663-1-git-send-email-tony.cho@atmel.com>
References: <1444124541-5663-1-git-send-email-tony.cho@atmel.com>
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
 drivers/staging/wilc1000/host_interface.c   | 278 ++++++++++++++--------------
 3 files changed, 142 insertions(+), 142 deletions(-)

diff --git a/drivers/staging/wilc1000/coreconfigurator.c b/drivers/staging/wilc1000/coreconfigurator.c
index c7cef57..7af3be2 100644
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
index 7f529cc..61728da 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -577,7 +577,7 @@ static s32 Handle_SetChannel(struct host_if_drv *drvHandler,
 	/*prepare configuration packet*/
 	strWID.id = (u16)WID_CURRENT_CHANNEL;
 	strWID.type = WID_CHAR;
-	strWID.ps8WidVal = (char *)&(pstrHostIFSetChan->u8SetChan);
+	strWID.val = (char *)&(pstrHostIFSetChan->u8SetChan);
 	strWID.size = sizeof(char);
 
 	PRINT_D(HOSTINF_DBG, "Setting channel\n");
@@ -613,7 +613,7 @@ static s32 Handle_SetWfiDrvHandler(struct host_if_drv *drvHandler,
 	/*prepare configuration packet*/
 	strWID.id = (u16)WID_SET_DRV_HANDLER;
 	strWID.type = WID_INT;
-	strWID.ps8WidVal = (s8 *)&(pstrHostIfSetDrvHandler->u32Address);
+	strWID.val = (s8 *)&(pstrHostIfSetDrvHandler->u32Address);
 	strWID.size = sizeof(u32);
 
 	/*Sending Cfg*/
@@ -654,7 +654,7 @@ static s32 Handle_SetOperationMode(struct host_if_drv *drvHandler,
 	/*prepare configuration packet*/
 	strWID.id = (u16)WID_SET_OPERATION_MODE;
 	strWID.type = WID_INT;
-	strWID.ps8WidVal = (s8 *)&(pstrHostIfSetOperationMode->u32Mode);
+	strWID.val = (s8 *)&(pstrHostIfSetOperationMode->u32Mode);
 	strWID.size = sizeof(u32);
 
 	/*Sending Cfg*/
@@ -703,7 +703,7 @@ s32 Handle_set_IPAddress(struct host_if_drv *drvHandler, u8 *pu8IPAddr, u8 idx)
 	/*prepare configuration packet*/
 	strWID.id = (u16)WID_IP_ADDRESS;
 	strWID.type = WID_STR;
-	strWID.ps8WidVal = (u8 *)pu8IPAddr;
+	strWID.val = (u8 *)pu8IPAddr;
 	strWID.size = IP_ALEN;
 
 	s32Error = send_config_pkt(SET_CFG, &strWID, 1,
@@ -742,18 +742,18 @@ s32 Handle_get_IPAddress(struct host_if_drv *drvHandler, u8 *pu8IPAddr, u8 idx)
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
@@ -798,9 +798,9 @@ static s32 Handle_SetMacAddress(struct host_if_drv *drvHandler,
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
@@ -833,7 +833,7 @@ static s32 Handle_GetMacAddress(struct host_if_drv *drvHandler,
 	/*prepare configuration packet*/
 	strWID.id = (u16)WID_MAC_ADDR;
 	strWID.type = WID_STR;
-	strWID.ps8WidVal = pstrHostIfGetMacAddress->u8MacAddress;
+	strWID.val = pstrHostIfGetMacAddress->u8MacAddress;
 	strWID.size = ETH_ALEN;
 
 	/*Sending Cfg*/
@@ -881,7 +881,7 @@ static s32 Handle_CfgParam(struct host_if_drv *drvHandler,
 		/* validate input then copy>> need to check value 4 and 5 */
 		if (strHostIFCfgParamAttr->pstrCfgParamVal.bss_type < 6) {
 			strWIDList[u8WidCnt].id = WID_BSS_TYPE;
-			strWIDList[u8WidCnt].ps8WidVal = (s8 *)&strHostIFCfgParamAttr->pstrCfgParamVal.bss_type;
+			strWIDList[u8WidCnt].val = (s8 *)&strHostIFCfgParamAttr->pstrCfgParamVal.bss_type;
 			strWIDList[u8WidCnt].type = WID_CHAR;
 			strWIDList[u8WidCnt].size = sizeof(char);
 			pstrWFIDrv->strCfgValues.bss_type = (u8)strHostIFCfgParamAttr->pstrCfgParamVal.bss_type;
@@ -901,7 +901,7 @@ static s32 Handle_CfgParam(struct host_if_drv *drvHandler,
 		/*validate Possible values*/
 		if ((strHostIFCfgParamAttr->pstrCfgParamVal.auth_type) == 1 || (strHostIFCfgParamAttr->pstrCfgParamVal.auth_type) == 2 || (strHostIFCfgParamAttr->pstrCfgParamVal.auth_type) == 5) {
 			strWIDList[u8WidCnt].id = WID_AUTH_TYPE;
-			strWIDList[u8WidCnt].ps8WidVal = (s8 *)&strHostIFCfgParamAttr->pstrCfgParamVal.auth_type;
+			strWIDList[u8WidCnt].val = (s8 *)&strHostIFCfgParamAttr->pstrCfgParamVal.auth_type;
 			strWIDList[u8WidCnt].type = WID_CHAR;
 			strWIDList[u8WidCnt].size = sizeof(char);
 			pstrWFIDrv->strCfgValues.auth_type = (u8)strHostIFCfgParamAttr->pstrCfgParamVal.auth_type;
@@ -916,7 +916,7 @@ static s32 Handle_CfgParam(struct host_if_drv *drvHandler,
 		/* range is 1 to 65535. */
 		if (strHostIFCfgParamAttr->pstrCfgParamVal.auth_timeout > 0 && strHostIFCfgParamAttr->pstrCfgParamVal.auth_timeout < 65536) {
 			strWIDList[u8WidCnt].id = WID_AUTH_TIMEOUT;
-			strWIDList[u8WidCnt].ps8WidVal = (s8 *)&strHostIFCfgParamAttr->pstrCfgParamVal.auth_timeout;
+			strWIDList[u8WidCnt].val = (s8 *)&strHostIFCfgParamAttr->pstrCfgParamVal.auth_timeout;
 			strWIDList[u8WidCnt].type = WID_SHORT;
 			strWIDList[u8WidCnt].size = sizeof(u16);
 			pstrWFIDrv->strCfgValues.auth_timeout = strHostIFCfgParamAttr->pstrCfgParamVal.auth_timeout;
@@ -937,7 +937,7 @@ static s32 Handle_CfgParam(struct host_if_drv *drvHandler,
 		/*----------------------------------------------------------*/
 		if (strHostIFCfgParamAttr->pstrCfgParamVal.power_mgmt_mode < 5) {
 			strWIDList[u8WidCnt].id = WID_POWER_MANAGEMENT;
-			strWIDList[u8WidCnt].ps8WidVal = (s8 *)&strHostIFCfgParamAttr->pstrCfgParamVal.power_mgmt_mode;
+			strWIDList[u8WidCnt].val = (s8 *)&strHostIFCfgParamAttr->pstrCfgParamVal.power_mgmt_mode;
 			strWIDList[u8WidCnt].type = WID_CHAR;
 			strWIDList[u8WidCnt].size = sizeof(char);
 			pstrWFIDrv->strCfgValues.power_mgmt_mode = (u8)strHostIFCfgParamAttr->pstrCfgParamVal.power_mgmt_mode;
@@ -952,7 +952,7 @@ static s32 Handle_CfgParam(struct host_if_drv *drvHandler,
 		/* range from 1 to 256 */
 		if ((strHostIFCfgParamAttr->pstrCfgParamVal.short_retry_limit > 0) && (strHostIFCfgParamAttr->pstrCfgParamVal.short_retry_limit < 256))	{
 			strWIDList[u8WidCnt].id = WID_SHORT_RETRY_LIMIT;
-			strWIDList[u8WidCnt].ps8WidVal = (s8 *)&strHostIFCfgParamAttr->pstrCfgParamVal.short_retry_limit;
+			strWIDList[u8WidCnt].val = (s8 *)&strHostIFCfgParamAttr->pstrCfgParamVal.short_retry_limit;
 			strWIDList[u8WidCnt].type = WID_SHORT;
 			strWIDList[u8WidCnt].size = sizeof(u16);
 			pstrWFIDrv->strCfgValues.short_retry_limit = strHostIFCfgParamAttr->pstrCfgParamVal.short_retry_limit;
@@ -967,7 +967,7 @@ static s32 Handle_CfgParam(struct host_if_drv *drvHandler,
 		/* range from 1 to 256 */
 		if ((strHostIFCfgParamAttr->pstrCfgParamVal.long_retry_limit > 0) && (strHostIFCfgParamAttr->pstrCfgParamVal.long_retry_limit < 256)) {
 			strWIDList[u8WidCnt].id = WID_LONG_RETRY_LIMIT;
-			strWIDList[u8WidCnt].ps8WidVal = (s8 *)&strHostIFCfgParamAttr->pstrCfgParamVal.long_retry_limit;
+			strWIDList[u8WidCnt].val = (s8 *)&strHostIFCfgParamAttr->pstrCfgParamVal.long_retry_limit;
 
 			strWIDList[u8WidCnt].type = WID_SHORT;
 			strWIDList[u8WidCnt].size = sizeof(u16);
@@ -983,7 +983,7 @@ static s32 Handle_CfgParam(struct host_if_drv *drvHandler,
 
 		if (strHostIFCfgParamAttr->pstrCfgParamVal.frag_threshold > 255 && strHostIFCfgParamAttr->pstrCfgParamVal.frag_threshold < 7937) {
 			strWIDList[u8WidCnt].id = WID_FRAG_THRESHOLD;
-			strWIDList[u8WidCnt].ps8WidVal = (s8 *)&strHostIFCfgParamAttr->pstrCfgParamVal.frag_threshold;
+			strWIDList[u8WidCnt].val = (s8 *)&strHostIFCfgParamAttr->pstrCfgParamVal.frag_threshold;
 			strWIDList[u8WidCnt].type = WID_SHORT;
 			strWIDList[u8WidCnt].size = sizeof(u16);
 			pstrWFIDrv->strCfgValues.frag_threshold = strHostIFCfgParamAttr->pstrCfgParamVal.frag_threshold;
@@ -998,7 +998,7 @@ static s32 Handle_CfgParam(struct host_if_drv *drvHandler,
 		/* range 256 to 65535 */
 		if (strHostIFCfgParamAttr->pstrCfgParamVal.rts_threshold > 255 && strHostIFCfgParamAttr->pstrCfgParamVal.rts_threshold < 65536)	{
 			strWIDList[u8WidCnt].id = WID_RTS_THRESHOLD;
-			strWIDList[u8WidCnt].ps8WidVal = (s8 *)&strHostIFCfgParamAttr->pstrCfgParamVal.rts_threshold;
+			strWIDList[u8WidCnt].val = (s8 *)&strHostIFCfgParamAttr->pstrCfgParamVal.rts_threshold;
 			strWIDList[u8WidCnt].type = WID_SHORT;
 			strWIDList[u8WidCnt].size = sizeof(u16);
 			pstrWFIDrv->strCfgValues.rts_threshold = strHostIFCfgParamAttr->pstrCfgParamVal.rts_threshold;
@@ -1017,7 +1017,7 @@ static s32 Handle_CfgParam(struct host_if_drv *drvHandler,
 		/*------------------------------------------------------*/
 		if (strHostIFCfgParamAttr->pstrCfgParamVal.preamble_type < 3) {
 			strWIDList[u8WidCnt].id = WID_PREAMBLE;
-			strWIDList[u8WidCnt].ps8WidVal = (s8 *)&strHostIFCfgParamAttr->pstrCfgParamVal.preamble_type;
+			strWIDList[u8WidCnt].val = (s8 *)&strHostIFCfgParamAttr->pstrCfgParamVal.preamble_type;
 			strWIDList[u8WidCnt].type = WID_CHAR;
 			strWIDList[u8WidCnt].size = sizeof(char);
 			pstrWFIDrv->strCfgValues.preamble_type = strHostIFCfgParamAttr->pstrCfgParamVal.preamble_type;
@@ -1031,7 +1031,7 @@ static s32 Handle_CfgParam(struct host_if_drv *drvHandler,
 	if (strHostIFCfgParamAttr->pstrCfgParamVal.u32SetCfgFlag & SHORT_SLOT_ALLOWED) {
 		if (strHostIFCfgParamAttr->pstrCfgParamVal.short_slot_allowed < 2) {
 			strWIDList[u8WidCnt].id = WID_SHORT_SLOT_ALLOWED;
-			strWIDList[u8WidCnt].ps8WidVal = (s8 *)&strHostIFCfgParamAttr->pstrCfgParamVal.short_slot_allowed;
+			strWIDList[u8WidCnt].val = (s8 *)&strHostIFCfgParamAttr->pstrCfgParamVal.short_slot_allowed;
 			strWIDList[u8WidCnt].type = WID_CHAR;
 			strWIDList[u8WidCnt].size = sizeof(char);
 			pstrWFIDrv->strCfgValues.short_slot_allowed = (u8)strHostIFCfgParamAttr->pstrCfgParamVal.short_slot_allowed;
@@ -1049,7 +1049,7 @@ static s32 Handle_CfgParam(struct host_if_drv *drvHandler,
 		/*Input Values: 1 for enable and 0 for disable.							*/
 		if (strHostIFCfgParamAttr->pstrCfgParamVal.txop_prot_disabled < 2) {
 			strWIDList[u8WidCnt].id = WID_11N_TXOP_PROT_DISABLE;
-			strWIDList[u8WidCnt].ps8WidVal = (s8 *)&strHostIFCfgParamAttr->pstrCfgParamVal.txop_prot_disabled;
+			strWIDList[u8WidCnt].val = (s8 *)&strHostIFCfgParamAttr->pstrCfgParamVal.txop_prot_disabled;
 			strWIDList[u8WidCnt].type = WID_CHAR;
 			strWIDList[u8WidCnt].size = sizeof(char);
 			pstrWFIDrv->strCfgValues.txop_prot_disabled = (u8)strHostIFCfgParamAttr->pstrCfgParamVal.txop_prot_disabled;
@@ -1064,7 +1064,7 @@ static s32 Handle_CfgParam(struct host_if_drv *drvHandler,
 		/* range is 1 to 65535. */
 		if (strHostIFCfgParamAttr->pstrCfgParamVal.beacon_interval > 0 && strHostIFCfgParamAttr->pstrCfgParamVal.beacon_interval < 65536) {
 			strWIDList[u8WidCnt].id = WID_BEACON_INTERVAL;
-			strWIDList[u8WidCnt].ps8WidVal = (s8 *)&strHostIFCfgParamAttr->pstrCfgParamVal.beacon_interval;
+			strWIDList[u8WidCnt].val = (s8 *)&strHostIFCfgParamAttr->pstrCfgParamVal.beacon_interval;
 			strWIDList[u8WidCnt].type = WID_SHORT;
 			strWIDList[u8WidCnt].size = sizeof(u16);
 			pstrWFIDrv->strCfgValues.beacon_interval = strHostIFCfgParamAttr->pstrCfgParamVal.beacon_interval;
@@ -1079,7 +1079,7 @@ static s32 Handle_CfgParam(struct host_if_drv *drvHandler,
 		/* range is 1 to 255. */
 		if (strHostIFCfgParamAttr->pstrCfgParamVal.dtim_period > 0 && strHostIFCfgParamAttr->pstrCfgParamVal.dtim_period < 256) {
 			strWIDList[u8WidCnt].id = WID_DTIM_PERIOD;
-			strWIDList[u8WidCnt].ps8WidVal = (s8 *)&strHostIFCfgParamAttr->pstrCfgParamVal.dtim_period;
+			strWIDList[u8WidCnt].val = (s8 *)&strHostIFCfgParamAttr->pstrCfgParamVal.dtim_period;
 			strWIDList[u8WidCnt].type = WID_CHAR;
 			strWIDList[u8WidCnt].size = sizeof(char);
 			pstrWFIDrv->strCfgValues.dtim_period = strHostIFCfgParamAttr->pstrCfgParamVal.dtim_period;
@@ -1098,7 +1098,7 @@ static s32 Handle_CfgParam(struct host_if_drv *drvHandler,
 		/*----------------------------------------------------------------------*/
 		if (strHostIFCfgParamAttr->pstrCfgParamVal.site_survey_enabled < 3) {
 			strWIDList[u8WidCnt].id = WID_SITE_SURVEY;
-			strWIDList[u8WidCnt].ps8WidVal = (s8 *)&strHostIFCfgParamAttr->pstrCfgParamVal.site_survey_enabled;
+			strWIDList[u8WidCnt].val = (s8 *)&strHostIFCfgParamAttr->pstrCfgParamVal.site_survey_enabled;
 			strWIDList[u8WidCnt].type = WID_CHAR;
 			strWIDList[u8WidCnt].size = sizeof(char);
 			pstrWFIDrv->strCfgValues.site_survey_enabled = (u8)strHostIFCfgParamAttr->pstrCfgParamVal.site_survey_enabled;
@@ -1113,7 +1113,7 @@ static s32 Handle_CfgParam(struct host_if_drv *drvHandler,
 		/* range is 1 to 65535. */
 		if (strHostIFCfgParamAttr->pstrCfgParamVal.site_survey_scan_time > 0 && strHostIFCfgParamAttr->pstrCfgParamVal.site_survey_scan_time < 65536) {
 			strWIDList[u8WidCnt].id = WID_SITE_SURVEY_SCAN_TIME;
-			strWIDList[u8WidCnt].ps8WidVal = (s8 *)&strHostIFCfgParamAttr->pstrCfgParamVal.site_survey_scan_time;
+			strWIDList[u8WidCnt].val = (s8 *)&strHostIFCfgParamAttr->pstrCfgParamVal.site_survey_scan_time;
 			strWIDList[u8WidCnt].type = WID_SHORT;
 			strWIDList[u8WidCnt].size = sizeof(u16);
 			pstrWFIDrv->strCfgValues.site_survey_scan_time = strHostIFCfgParamAttr->pstrCfgParamVal.site_survey_scan_time;
@@ -1128,7 +1128,7 @@ static s32 Handle_CfgParam(struct host_if_drv *drvHandler,
 		/* range is 1 to 65535. */
 		if (strHostIFCfgParamAttr->pstrCfgParamVal.active_scan_time > 0 && strHostIFCfgParamAttr->pstrCfgParamVal.active_scan_time < 65536) {
 			strWIDList[u8WidCnt].id = WID_ACTIVE_SCAN_TIME;
-			strWIDList[u8WidCnt].ps8WidVal = (s8 *)&strHostIFCfgParamAttr->pstrCfgParamVal.active_scan_time;
+			strWIDList[u8WidCnt].val = (s8 *)&strHostIFCfgParamAttr->pstrCfgParamVal.active_scan_time;
 			strWIDList[u8WidCnt].type = WID_SHORT;
 			strWIDList[u8WidCnt].size = sizeof(u16);
 			pstrWFIDrv->strCfgValues.active_scan_time = strHostIFCfgParamAttr->pstrCfgParamVal.active_scan_time;
@@ -1143,7 +1143,7 @@ static s32 Handle_CfgParam(struct host_if_drv *drvHandler,
 		/* range is 1 to 65535. */
 		if (strHostIFCfgParamAttr->pstrCfgParamVal.passive_scan_time > 0 && strHostIFCfgParamAttr->pstrCfgParamVal.passive_scan_time < 65536) {
 			strWIDList[u8WidCnt].id = WID_PASSIVE_SCAN_TIME;
-			strWIDList[u8WidCnt].ps8WidVal = (s8 *)&strHostIFCfgParamAttr->pstrCfgParamVal.passive_scan_time;
+			strWIDList[u8WidCnt].val = (s8 *)&strHostIFCfgParamAttr->pstrCfgParamVal.passive_scan_time;
 			strWIDList[u8WidCnt].type = WID_SHORT;
 			strWIDList[u8WidCnt].size = sizeof(u16);
 			pstrWFIDrv->strCfgValues.passive_scan_time = strHostIFCfgParamAttr->pstrCfgParamVal.passive_scan_time;
@@ -1168,7 +1168,7 @@ static s32 Handle_CfgParam(struct host_if_drv *drvHandler,
 		    || curr_tx_rate == MBPS_18 || curr_tx_rate == MBPS_24
 		    || curr_tx_rate == MBPS_36 || curr_tx_rate == MBPS_48 || curr_tx_rate == MBPS_54) {
 			strWIDList[u8WidCnt].id = WID_CURRENT_TX_RATE;
-			strWIDList[u8WidCnt].ps8WidVal = (s8 *)&curr_tx_rate;
+			strWIDList[u8WidCnt].val = (s8 *)&curr_tx_rate;
 			strWIDList[u8WidCnt].type = WID_SHORT;
 			strWIDList[u8WidCnt].size = sizeof(u16);
 			pstrWFIDrv->strCfgValues.curr_tx_rate = (u8)curr_tx_rate;
@@ -1260,9 +1260,9 @@ static s32 Handle_Scan(struct host_if_drv *drvHandler,
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
 
@@ -1287,7 +1287,7 @@ static s32 Handle_Scan(struct host_if_drv *drvHandler,
 		/* IEs to be inserted in Probe Request */
 		strWIDList[u32WidsCount].id = WID_INFO_ELEMENT_PROBE;
 		strWIDList[u32WidsCount].type = WID_BIN_DATA;
-		strWIDList[u32WidsCount].ps8WidVal = pstrHostIFscanAttr->pu8IEs;
+		strWIDList[u32WidsCount].val = pstrHostIFscanAttr->pu8IEs;
 		strWIDList[u32WidsCount].size = pstrHostIFscanAttr->IEsLen;
 		u32WidsCount++;
 	}
@@ -1296,7 +1296,7 @@ static s32 Handle_Scan(struct host_if_drv *drvHandler,
 	strWIDList[u32WidsCount].id = WID_SCAN_TYPE;
 	strWIDList[u32WidsCount].type = WID_CHAR;
 	strWIDList[u32WidsCount].size = sizeof(char);
-	strWIDList[u32WidsCount].ps8WidVal = (s8 *)(&(pstrHostIFscanAttr->u8ScanType));
+	strWIDList[u32WidsCount].val = (s8 *)(&(pstrHostIFscanAttr->u8ScanType));
 	u32WidsCount++;
 
 	/*list of channels to be scanned*/
@@ -1312,7 +1312,7 @@ static s32 Handle_Scan(struct host_if_drv *drvHandler,
 		}
 	}
 
-	strWIDList[u32WidsCount].ps8WidVal = pstrHostIFscanAttr->pu8ChnlFreqList;
+	strWIDList[u32WidsCount].val = pstrHostIFscanAttr->pu8ChnlFreqList;
 	strWIDList[u32WidsCount].size = pstrHostIFscanAttr->u8ChnlListLen;
 	u32WidsCount++;
 
@@ -1320,7 +1320,7 @@ static s32 Handle_Scan(struct host_if_drv *drvHandler,
 	strWIDList[u32WidsCount].id = WID_START_SCAN_REQ;
 	strWIDList[u32WidsCount].type = WID_CHAR;
 	strWIDList[u32WidsCount].size = sizeof(char);
-	strWIDList[u32WidsCount].ps8WidVal = (s8 *)(&(pstrHostIFscanAttr->u8ScanSource));
+	strWIDList[u32WidsCount].val = (s8 *)(&(pstrHostIFscanAttr->u8ScanSource));
 	u32WidsCount++;
 
 	/*keep the state as is , no need to change it*/
@@ -1402,7 +1402,7 @@ static s32 Handle_ScanDone(struct host_if_drv *drvHandler, tenuScanEvent enuEven
 		u8abort_running_scan = 1;
 		strWID.id = (u16)WID_ABORT_RUNNING_SCAN;
 		strWID.type = WID_CHAR;
-		strWID.ps8WidVal = (s8 *)&u8abort_running_scan;
+		strWID.val = (s8 *)&u8abort_running_scan;
 		strWID.size = sizeof(char);
 
 		/*Sending Cfg*/
@@ -1499,19 +1499,19 @@ static s32 Handle_Connect(struct host_if_drv *drvHandler,
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
@@ -1520,7 +1520,7 @@ static s32 Handle_Connect(struct host_if_drv *drvHandler,
 		/* IEs to be inserted in Association Request */
 		strWIDList[u32WidsCount].id = WID_INFO_ELEMENT_ASSOCIATE;
 		strWIDList[u32WidsCount].type = WID_BIN_DATA;
-		strWIDList[u32WidsCount].ps8WidVal = pstrWFIDrv->strWILC_UsrConnReq.pu8ConnReqIEs;
+		strWIDList[u32WidsCount].val = pstrWFIDrv->strWILC_UsrConnReq.pu8ConnReqIEs;
 		strWIDList[u32WidsCount].size = pstrWFIDrv->strWILC_UsrConnReq.ConnReqIEsLen;
 		u32WidsCount++;
 
@@ -1535,7 +1535,7 @@ static s32 Handle_Connect(struct host_if_drv *drvHandler,
 	strWIDList[u32WidsCount].id = (u16)WID_11I_MODE;
 	strWIDList[u32WidsCount].type = WID_CHAR;
 	strWIDList[u32WidsCount].size = sizeof(char);
-	strWIDList[u32WidsCount].ps8WidVal = (s8 *)(&(pstrWFIDrv->strWILC_UsrConnReq.u8security));
+	strWIDList[u32WidsCount].val = (s8 *)(&(pstrWFIDrv->strWILC_UsrConnReq.u8security));
 	u32WidsCount++;
 
 	if (memcmp("DIRECT-", pstrHostIFconnectAttr->pu8ssid, 7))
@@ -1547,7 +1547,7 @@ static s32 Handle_Connect(struct host_if_drv *drvHandler,
 	strWIDList[u32WidsCount].id = (u16)WID_AUTH_TYPE;
 	strWIDList[u32WidsCount].type = WID_CHAR;
 	strWIDList[u32WidsCount].size = sizeof(char);
-	strWIDList[u32WidsCount].ps8WidVal = (s8 *)(&pstrWFIDrv->strWILC_UsrConnReq.tenuAuth_type);
+	strWIDList[u32WidsCount].val = (s8 *)(&pstrWFIDrv->strWILC_UsrConnReq.tenuAuth_type);
 	u32WidsCount++;
 
 	if (memcmp("DIRECT-", pstrHostIFconnectAttr->pu8ssid, 7))
@@ -1570,18 +1570,18 @@ static s32 Handle_Connect(struct host_if_drv *drvHandler,
 
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
@@ -1693,7 +1693,7 @@ static s32 Handle_Connect(struct host_if_drv *drvHandler,
 		PRINT_D(HOSTINF_DBG, "NOA not present\n");
 
 	/* keep the buffer at the start of the allocated pointer to use it with the free*/
-	pu8CurrByte = strWIDList[u32WidsCount].ps8WidVal;
+	pu8CurrByte = strWIDList[u32WidsCount].val;
 	u32WidsCount++;
 
 	/* A temporary workaround to avoid handling the misleading MAC_DISCONNECTED raised from the
@@ -1814,14 +1814,14 @@ static s32 Handle_FlushConnect(struct host_if_drv *drvHandler)
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
 
 
@@ -1829,14 +1829,14 @@ static s32 Handle_FlushConnect(struct host_if_drv *drvHandler)
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
@@ -1919,7 +1919,7 @@ static s32 Handle_ConnectTimeout(struct host_if_drv *drvHandler)
 	 *   WID_DISCONNECT} */
 	strWID.id = (u16)WID_DISCONNECT;
 	strWID.type = WID_CHAR;
-	strWID.ps8WidVal = (s8 *)&u16DummyReasonCode;
+	strWID.val = (s8 *)&u16DummyReasonCode;
 	strWID.size = sizeof(char);
 
 	PRINT_D(HOSTINF_DBG, "Sending disconnect request\n");
@@ -2427,17 +2427,17 @@ static int Handle_Key(struct host_if_drv *drvHandler,
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
 
 
@@ -2458,7 +2458,7 @@ static int Handle_Key(struct host_if_drv *drvHandler,
 			strWIDList[3].id = (u16)WID_WEP_KEY_VALUE;
 			strWIDList[3].type = WID_STR;
 			strWIDList[3].size = pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFwepAttr.u8WepKeylen;
-			strWIDList[3].ps8WidVal = (s8 *)pu8keybuf;
+			strWIDList[3].val = (s8 *)pu8keybuf;
 
 
 			s32Error = send_config_pkt(SET_CFG, strWIDList, 4,
@@ -2486,7 +2486,7 @@ static int Handle_Key(struct host_if_drv *drvHandler,
 
 			strWID.id = (u16)WID_ADD_WEP_KEY;
 			strWID.type = WID_STR;
-			strWID.ps8WidVal	= (s8 *)pu8keybuf;
+			strWID.val = (s8 *)pu8keybuf;
 			strWID.size = pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFwepAttr.u8WepKeylen + 2;
 
 			s32Error = send_config_pkt(SET_CFG, &strWID, 1,
@@ -2499,7 +2499,7 @@ static int Handle_Key(struct host_if_drv *drvHandler,
 			strWID.type = WID_STR;
 
 			s8idxarray[0] = (s8)pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFwepAttr.u8Wepidx;
-			strWID.ps8WidVal = s8idxarray;
+			strWID.val = s8idxarray;
 			strWID.size = 1;
 
 			s32Error = send_config_pkt(SET_CFG, &strWID, 1,
@@ -2507,7 +2507,7 @@ static int Handle_Key(struct host_if_drv *drvHandler,
 		} else {
 			strWID.id = (u16)WID_KEY_ID;
 			strWID.type = WID_CHAR;
-			strWID.ps8WidVal	= (s8 *)(&(pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFwepAttr.u8Wepidx));
+			strWID.val = (s8 *)(&(pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFwepAttr.u8Wepidx));
 			strWID.size = sizeof(char);
 
 			PRINT_D(HOSTINF_DBG, "Setting default key index\n");
@@ -2551,11 +2551,11 @@ static int Handle_Key(struct host_if_drv *drvHandler,
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
@@ -2601,7 +2601,7 @@ static int Handle_Key(struct host_if_drv *drvHandler,
 
 			strWID.id = (u16)WID_ADD_RX_GTK;
 			strWID.type = WID_STR;
-			strWID.ps8WidVal	= (s8 *)pu8keybuf;
+			strWID.val = (s8 *)pu8keybuf;
 			strWID.size = RX_MIC_KEY_MSG_LEN;
 
 			s32Error = send_config_pkt(SET_CFG, &strWID, 1,
@@ -2654,11 +2654,11 @@ _WPARxGtk_end_case_:
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
@@ -2699,7 +2699,7 @@ _WPARxGtk_end_case_:
 
 			strWID.id = (u16)WID_ADD_PTK;
 			strWID.type = WID_STR;
-			strWID.ps8WidVal	= (s8 *)pu8keybuf;
+			strWID.val = (s8 *)pu8keybuf;
 			strWID.size = PTK_KEY_MSG_LEN;
 
 			s32Error = send_config_pkt(SET_CFG, &strWID, 1,
@@ -2739,7 +2739,7 @@ _WPAPtk_end_case_:
 
 		strWID.id = (u16)WID_PMKID_INFO;
 		strWID.type = WID_STR;
-		strWID.ps8WidVal = (s8 *)pu8keybuf;
+		strWID.val = (s8 *)pu8keybuf;
 		strWID.size = (pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFpmkidAttr.numpmkid * PMKSA_KEY_LEN) + 1;
 
 		s32Error = send_config_pkt(SET_CFG, &strWID, 1,
@@ -2777,7 +2777,7 @@ static void Handle_Disconnect(struct host_if_drv *drvHandler)
 
 	strWID.id = (u16)WID_DISCONNECT;
 	strWID.type = WID_CHAR;
-	strWID.ps8WidVal = (s8 *)&u16DummyReasonCode;
+	strWID.val = (s8 *)&u16DummyReasonCode;
 	strWID.size = sizeof(char);
 
 
@@ -2901,7 +2901,7 @@ static s32 Handle_GetChnl(struct host_if_drv *drvHandler)
 
 	strWID.id = (u16)WID_CURRENT_CHANNEL;
 	strWID.type = WID_CHAR;
-	strWID.ps8WidVal = (s8 *)&gu8Chnl;
+	strWID.val = (s8 *)&gu8Chnl;
 	strWID.size = sizeof(char);
 
 	PRINT_D(HOSTINF_DBG, "Getting channel value\n");
@@ -2940,7 +2940,7 @@ static void Handle_GetRssi(struct host_if_drv *drvHandler)
 
 	strWID.id = (u16)WID_RSSI;
 	strWID.type = WID_CHAR;
-	strWID.ps8WidVal = &gs8Rssi;
+	strWID.val = &gs8Rssi;
 	strWID.size = sizeof(char);
 
 	/*Sending Cfg*/
@@ -2969,7 +2969,7 @@ static void Handle_GetLinkspeed(struct host_if_drv *drvHandler)
 
 	strWID.id = (u16)WID_LINKSPEED;
 	strWID.type = WID_CHAR;
-	strWID.ps8WidVal = &gs8lnkspd;
+	strWID.val = &gs8lnkspd;
 	strWID.size = sizeof(char);
 	/*Sending Cfg*/
 	PRINT_D(HOSTINF_DBG, "Getting LINKSPEED value\n");
@@ -2994,31 +2994,31 @@ s32 Handle_GetStatistics(struct host_if_drv *drvHandler, tstrStatistics *pstrSta
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
@@ -3056,10 +3056,10 @@ static s32 Handle_Get_InActiveTime(struct host_if_drv *drvHandler,
 	strWID.id = (u16)WID_SET_STA_MAC_INACTIVE_TIME;
 	strWID.type = WID_STR;
 	strWID.size = ETH_ALEN;
-	strWID.ps8WidVal = kmalloc(strWID.size, GFP_KERNEL);
+	strWID.val = kmalloc(strWID.size, GFP_KERNEL);
 
 
-	stamac = strWID.ps8WidVal;
+	stamac = strWID.val;
 	memcpy(stamac, strHostIfStaInactiveT->mac, ETH_ALEN);
 
 
@@ -3077,7 +3077,7 @@ static s32 Handle_Get_InActiveTime(struct host_if_drv *drvHandler,
 
 	strWID.id = (u16)WID_GET_INACTIVE_TIME;
 	strWID.type = WID_INT;
-	strWID.ps8WidVal = (s8 *)&gu32InactiveTime;
+	strWID.val = (s8 *)&gu32InactiveTime;
 	strWID.size = sizeof(u32);
 
 
@@ -3123,11 +3123,11 @@ static void Handle_AddBeacon(struct host_if_drv *drvHandler,
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
@@ -3164,7 +3164,7 @@ static void Handle_AddBeacon(struct host_if_drv *drvHandler,
 		PRINT_ER("Failed to send add beacon config packet\n");
 
 ERRORHANDLER:
-	kfree(strWID.ps8WidVal);
+	kfree(strWID.val);
 	kfree(pstrSetBeaconParam->pu8Head);
 	kfree(pstrSetBeaconParam->pu8Tail);
 }
@@ -3189,12 +3189,12 @@ static void Handle_DelBeacon(struct host_if_drv *drvHandler)
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
@@ -3284,11 +3284,11 @@ static void Handle_AddStation(struct host_if_drv *drvHandler,
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
@@ -3299,7 +3299,7 @@ static void Handle_AddStation(struct host_if_drv *drvHandler,
 
 ERRORHANDLER:
 	kfree(pstrStationParam->pu8Rates);
-	kfree(strWID.ps8WidVal);
+	kfree(strWID.val);
 }
 
 /**
@@ -3328,11 +3328,11 @@ static void Handle_DelAllSta(struct host_if_drv *drvHandler,
 
 	PRINT_D(HOSTINF_DBG, "Handling delete station\n");
 
-	strWID.ps8WidVal = kmalloc((pstrDelAllStaParam->u8Num_AssocSta * ETH_ALEN) + 1, GFP_KERNEL);
-	if (strWID.ps8WidVal == NULL)
+	strWID.val = kmalloc((pstrDelAllStaParam->u8Num_AssocSta * ETH_ALEN) + 1, GFP_KERNEL);
+	if (strWID.val == NULL)
 		goto ERRORHANDLER;
 
-	pu8CurrByte = strWID.ps8WidVal;
+	pu8CurrByte = strWID.val;
 
 	*(pu8CurrByte++) = pstrDelAllStaParam->u8Num_AssocSta;
 
@@ -3352,7 +3352,7 @@ static void Handle_DelAllSta(struct host_if_drv *drvHandler,
 		PRINT_ER("Failed to send add station config packet\n");
 
 ERRORHANDLER:
-	kfree(strWID.ps8WidVal);
+	kfree(strWID.val);
 
 	up(&hWaitResponse);
 }
@@ -3381,11 +3381,11 @@ static void Handle_DelStation(struct host_if_drv *drvHandler,
 
 	PRINT_D(HOSTINF_DBG, "Handling delete station\n");
 
-	strWID.ps8WidVal = kmalloc(strWID.size, GFP_KERNEL);
-	if (strWID.ps8WidVal == NULL)
+	strWID.val = kmalloc(strWID.size, GFP_KERNEL);
+	if (strWID.val == NULL)
 		goto ERRORHANDLER;
 
-	pu8CurrByte = strWID.ps8WidVal;
+	pu8CurrByte = strWID.val;
 
 	memcpy(pu8CurrByte, pstrDelStaParam->au8MacAddr, ETH_ALEN);
 
@@ -3396,7 +3396,7 @@ static void Handle_DelStation(struct host_if_drv *drvHandler,
 		PRINT_ER("Failed to send add station config packet\n");
 
 ERRORHANDLER:
-	kfree(strWID.ps8WidVal);
+	kfree(strWID.val);
 }
 
 
@@ -3422,11 +3422,11 @@ static void Handle_EditStation(struct host_if_drv *drvHandler,
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
@@ -3437,7 +3437,7 @@ static void Handle_EditStation(struct host_if_drv *drvHandler,
 
 ERRORHANDLER:
 	kfree(pstrStationParam->pu8Rates);
-	kfree(strWID.ps8WidVal);
+	kfree(strWID.val);
 }
 
 /**
@@ -3493,15 +3493,15 @@ static int Handle_RemainOnChan(struct host_if_drv *drvHandler,
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
@@ -3549,11 +3549,11 @@ static int Handle_RegisterFrame(struct host_if_drv *drvHandler,
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
@@ -3602,13 +3602,13 @@ static u32 Handle_ListenStateExpired(struct host_if_drv *drvHandler,
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
@@ -3686,7 +3686,7 @@ static void Handle_PowerManagement(struct host_if_drv *drvHandler,
 	else
 		s8PowerMode = NO_POWERSAVE;
 	PRINT_D(HOSTINF_DBG, "Handling power mgmt to %d\n", s8PowerMode);
-	strWID.ps8WidVal = &s8PowerMode;
+	strWID.val = &s8PowerMode;
 	strWID.size = sizeof(char);
 
 	PRINT_D(HOSTINF_DBG, "Handling Power Management\n");
@@ -3719,11 +3719,11 @@ static void Handle_SetMulticastFilter(struct host_if_drv *drvHandler,
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
@@ -3744,7 +3744,7 @@ static void Handle_SetMulticastFilter(struct host_if_drv *drvHandler,
 		PRINT_ER("Failed to send setup multicast config packet\n");
 
 ERRORHANDLER:
-	kfree(strWID.ps8WidVal);
+	kfree(strWID.val);
 
 }
 
@@ -3777,9 +3777,9 @@ static s32 Handle_AddBASession(struct host_if_drv *drvHandler,
 
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
@@ -3812,7 +3812,7 @@ static s32 Handle_AddBASession(struct host_if_drv *drvHandler,
 	strWID.id = (u16)WID_11E_P_ACTION_REQ;
 	strWID.type = WID_STR;
 	strWID.size = 15;
-	ptr = strWID.ps8WidVal;
+	ptr = strWID.val;
 	/* *ptr++ = 0x14; */
 	*ptr++ = 15;
 	*ptr++ = 7;
@@ -3831,8 +3831,8 @@ static s32 Handle_AddBASession(struct host_if_drv *drvHandler,
 	s32Error = send_config_pkt(SET_CFG, &strWID, 1,
 				   get_id_from_handler(pstrWFIDrv));
 
-	if (strWID.ps8WidVal != NULL)
-		kfree(strWID.ps8WidVal);
+	if (strWID.val != NULL)
+		kfree(strWID.val);
 
 	return s32Error;
 
@@ -3863,9 +3863,9 @@ static s32 Handle_DelAllRxBASessions(struct host_if_drv *drvHandler,
 
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
@@ -3883,8 +3883,8 @@ static s32 Handle_DelAllRxBASessions(struct host_if_drv *drvHandler,
 		PRINT_D(HOSTINF_DBG, "Couldn't delete BA Session\n");
 
 
-	if (strWID.ps8WidVal != NULL)
-		kfree(strWID.ps8WidVal);
+	if (strWID.val != NULL)
+		kfree(strWID.val);
 
 	up(&hWaitResponse);
 
@@ -4162,7 +4162,7 @@ s32 host_int_remove_key(struct host_if_drv *hWFIDrv, const u8 *pu8StaAddress)
 
 	strWID.id = (u16)WID_REMOVE_KEY;
 	strWID.type = WID_STR;
-	strWID.ps8WidVal	= (s8 *)pu8StaAddress;
+	strWID.val = (s8 *)pu8StaAddress;
 	strWID.size = 6;
 
 	return 0;
@@ -4685,7 +4685,7 @@ s32 host_int_get_pmkid_info(struct host_if_drv *hWFIDrv, u8 *pu8PmkidInfoArray,
 	strWID.id = (u16)WID_PMKID_INFO;
 	strWID.type = WID_STR;
 	strWID.size = u32PmkidInfoLen;
-	strWID.ps8WidVal = pu8PmkidInfoArray;
+	strWID.val = pu8PmkidInfoArray;
 
 	return 0;
 }
@@ -4713,7 +4713,7 @@ s32 host_int_set_RSNAConfigPSKPassPhrase(struct host_if_drv *hWFIDrv, u8 *pu8Pas
 	if ((u8Psklength > 7) && (u8Psklength < 65)) {
 		strWID.id = (u16)WID_11I_PSK;
 		strWID.type = WID_STR;
-		strWID.ps8WidVal	= pu8PassPhrase;
+		strWID.val = pu8PassPhrase;
 		strWID.size = u8Psklength;
 	}
 
@@ -4807,7 +4807,7 @@ s32 host_int_get_RSNAConfigPSKPassPhrase(struct host_if_drv *hWFIDrv,
 	strWID.id = (u16)WID_11I_PSK;
 	strWID.type = WID_STR;
 	strWID.size = u8Psklength;
-	strWID.ps8WidVal	= pu8PassPhrase;
+	strWID.val = pu8PassPhrase;
 
 	return 0;
 }
@@ -4833,7 +4833,7 @@ s32 host_int_set_start_scan_req(struct host_if_drv *hWFIDrv, u8 scanSource)
 
 	strWID.id = (u16)WID_START_SCAN_REQ;
 	strWID.type = WID_CHAR;
-	strWID.ps8WidVal = (s8 *)&scanSource;
+	strWID.val = (s8 *)&scanSource;
 	strWID.size = sizeof(char);
 
 	return 0;
@@ -4861,7 +4861,7 @@ s32 host_int_get_start_scan_req(struct host_if_drv *hWFIDrv, u8 *pu8ScanSource)
 
 	strWID.id = (u16)WID_START_SCAN_REQ;
 	strWID.type = WID_CHAR;
-	strWID.ps8WidVal = (s8 *)pu8ScanSource;
+	strWID.val = (s8 *)pu8ScanSource;
 	strWID.size = sizeof(char);
 
 	return 0;
@@ -5058,7 +5058,7 @@ s32 host_int_disconnect_station(struct host_if_drv *hWFIDrv, u8 assoc_id)
 
 	strWID.id = (u16)WID_DISCONNECT;
 	strWID.type = WID_CHAR;
-	strWID.ps8WidVal = (s8 *)&assoc_id;
+	strWID.val = (s8 *)&assoc_id;
 	strWID.size = sizeof(char);
 
 	return 0;
@@ -5097,7 +5097,7 @@ s32 host_int_get_assoc_req_info(struct host_if_drv *hWFIDrv, u8 *pu8AssocReqInfo
 
 	strWID.id = (u16)WID_ASSOC_REQ_INFO;
 	strWID.type = WID_STR;
-	strWID.ps8WidVal = pu8AssocReqInfo;
+	strWID.val = pu8AssocReqInfo;
 	strWID.size = u32AssocReqInfoLen;
 
 	return 0;
@@ -5128,7 +5128,7 @@ s32 host_int_get_assoc_res_info(struct host_if_drv *hWFIDrv, u8 *pu8AssocRespInf
 
 	strWID.id = (u16)WID_ASSOC_RES_INFO;
 	strWID.type = WID_STR;
-	strWID.ps8WidVal = pu8AssocRespInfo;
+	strWID.val = pu8AssocRespInfo;
 	strWID.size = u32MaxAssocRespInfoLen;
 
 
@@ -5168,7 +5168,7 @@ s32 host_int_get_rx_power_level(struct host_if_drv *hWFIDrv, u8 *pu8RxPowerLevel
 
 	strWID.id = (u16)WID_RX_POWER_LEVEL;
 	strWID.type = WID_STR;
-	strWID.ps8WidVal = pu8RxPowerLevel;
+	strWID.val = pu8RxPowerLevel;
 	strWID.size = u32RxPowerLevelLen;
 
 	return 0;
@@ -5358,7 +5358,7 @@ s32 host_int_test_set_int_wid(struct host_if_drv *hWFIDrv, u32 u32TestMemAddr)
 	/*prepare configuration packet*/
 	strWID.id = (u16)WID_MEMORY_ADDRESS;
 	strWID.type = WID_INT;
-	strWID.ps8WidVal = (char *)&u32TestMemAddr;
+	strWID.val = (char *)&u32TestMemAddr;
 	strWID.size = sizeof(u32);
 
 	/*Sending Cfg*/
@@ -5443,7 +5443,7 @@ s32 host_int_test_get_int_wid(struct host_if_drv *hWFIDrv, u32 *pu32TestMemAddr)
 
 	strWID.id = (u16)WID_MEMORY_ADDRESS;
 	strWID.type = WID_INT;
-	strWID.ps8WidVal = (s8 *)pu32TestMemAddr;
+	strWID.val = (s8 *)pu32TestMemAddr;
 	strWID.size = sizeof(u32);
 
 	s32Error = send_config_pkt(GET_CFG, &strWID, 1,
-- 
1.9.1

