Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:13307 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751782AbbJLH76 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Oct 2015 03:59:58 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH V2 31/41] staging: wilc1000: replace drvHandler and hWFIDrv with hif_drv
Date: Mon, 12 Oct 2015 16:56:05 +0900
Message-ID: <1444636575-2486-31-git-send-email-tony.cho@atmel.com> (sfid-20151012_100002_257549_1457F016)
In-Reply-To: <1444636575-2486-1-git-send-email-tony.cho@atmel.com>
References: <1444636575-2486-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch replaces the variable names of struct host_if_drv used as the
functions' input parameter, drvHandler and hWFIDrv with hif_drv. In
addition, the local variable declared in many functions, pstrWFIDrv is
removed and hif_drv is directly used. A debug message printing pstrWFIDrv is
deleted while removing the local variable because it is not useful as well.

Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 1255 +++++++++++++----------------
 1 file changed, 569 insertions(+), 686 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 6826298..9309678 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -554,13 +554,12 @@ static struct host_if_drv *get_handler_from_id(int id)
  *  @date
  *  @version	1.0
  */
-static s32 Handle_SetChannel(struct host_if_drv *drvHandler,
+static s32 Handle_SetChannel(struct host_if_drv *hif_drv,
 			     struct channel_attr *pstrHostIFSetChan)
 {
 
 	s32 s32Error = 0;
 	struct wid strWID;
-	struct host_if_drv *pstrWFIDrv = (struct host_if_drv *)drvHandler;
 
 	/*prepare configuration packet*/
 	strWID.id = (u16)WID_CURRENT_CHANNEL;
@@ -571,7 +570,7 @@ static s32 Handle_SetChannel(struct host_if_drv *drvHandler,
 	PRINT_D(HOSTINF_DBG, "Setting channel\n");
 	/*Sending Cfg*/
 	s32Error = send_config_pkt(SET_CFG, &strWID, 1,
-				   get_id_from_handler(pstrWFIDrv));
+				   get_id_from_handler(hif_drv));
 	if (s32Error) {
 		PRINT_ER("Failed to set channel\n");
 		return -EINVAL;
@@ -589,14 +588,12 @@ static s32 Handle_SetChannel(struct host_if_drv *drvHandler,
  *  @date
  *  @version	1.0
  */
-static s32 Handle_SetWfiDrvHandler(struct host_if_drv *drvHandler,
+static s32 Handle_SetWfiDrvHandler(struct host_if_drv *hif_drv,
 				   struct drv_handler *pstrHostIfSetDrvHandler)
 {
 
 	s32 s32Error = 0;
 	struct wid strWID;
-	struct host_if_drv *pstrWFIDrv = drvHandler;
-
 
 	/*prepare configuration packet*/
 	strWID.id = (u16)WID_SET_DRV_HANDLER;
@@ -609,7 +606,7 @@ static s32 Handle_SetWfiDrvHandler(struct host_if_drv *drvHandler,
 	s32Error = send_config_pkt(SET_CFG, &strWID, 1,
 				   pstrHostIfSetDrvHandler->u32Address);
 
-	if (pstrWFIDrv == NULL)
+	if (!hif_drv)
 		up(&hSemDeinitDrvHandle);
 
 
@@ -630,14 +627,12 @@ static s32 Handle_SetWfiDrvHandler(struct host_if_drv *drvHandler,
  *  @date
  *  @version	1.0
  */
-static s32 Handle_SetOperationMode(struct host_if_drv *drvHandler,
+static s32 Handle_SetOperationMode(struct host_if_drv *hif_drv,
 				   struct op_mode *pstrHostIfSetOperationMode)
 {
 
 	s32 s32Error = 0;
 	struct wid strWID;
-	struct host_if_drv *pstrWFIDrv = (struct host_if_drv *)drvHandler;
-
 
 	/*prepare configuration packet*/
 	strWID.id = (u16)WID_SET_OPERATION_MODE;
@@ -645,11 +640,8 @@ static s32 Handle_SetOperationMode(struct host_if_drv *drvHandler,
 	strWID.val = (s8 *)&(pstrHostIfSetOperationMode->u32Mode);
 	strWID.size = sizeof(u32);
 
-	/*Sending Cfg*/
-	PRINT_INFO(HOSTINF_DBG, "pstrWFIDrv= %p\n", pstrWFIDrv);
-
 	s32Error = send_config_pkt(SET_CFG, &strWID, 1,
-				   get_id_from_handler(pstrWFIDrv));
+				   get_id_from_handler(hif_drv));
 
 
 	if ((pstrHostIfSetOperationMode->u32Mode) == IDLE_MODE)
@@ -673,13 +665,12 @@ static s32 Handle_SetOperationMode(struct host_if_drv *drvHandler,
  *  @date
  *  @version	1.0
  */
-s32 Handle_set_IPAddress(struct host_if_drv *drvHandler, u8 *pu8IPAddr, u8 idx)
+s32 Handle_set_IPAddress(struct host_if_drv *hif_drv, u8 *pu8IPAddr, u8 idx)
 {
 
 	s32 s32Error = 0;
 	struct wid strWID;
 	char firmwareIPAddress[4] = {0};
-	struct host_if_drv *pstrWFIDrv = (struct host_if_drv *)drvHandler;
 
 	if (pu8IPAddr[0] < 192)
 		pu8IPAddr[0] = 0;
@@ -695,10 +686,10 @@ s32 Handle_set_IPAddress(struct host_if_drv *drvHandler, u8 *pu8IPAddr, u8 idx)
 	strWID.size = IP_ALEN;
 
 	s32Error = send_config_pkt(SET_CFG, &strWID, 1,
-				   get_id_from_handler(pstrWFIDrv));
+				   get_id_from_handler(hif_drv));
 
 
-	host_int_get_ipaddress(drvHandler, firmwareIPAddress, idx);
+	host_int_get_ipaddress(hif_drv, firmwareIPAddress, idx);
 
 	if (s32Error) {
 		PRINT_ER("Failed to set IP address\n");
@@ -720,12 +711,11 @@ s32 Handle_set_IPAddress(struct host_if_drv *drvHandler, u8 *pu8IPAddr, u8 idx)
  *  @date
  *  @version	1.0
  */
-s32 Handle_get_IPAddress(struct host_if_drv *drvHandler, u8 *pu8IPAddr, u8 idx)
+s32 Handle_get_IPAddress(struct host_if_drv *hif_drv, u8 *pu8IPAddr, u8 idx)
 {
 
 	s32 s32Error = 0;
 	struct wid strWID;
-	struct host_if_drv *pstrWFIDrv = (struct host_if_drv *)drvHandler;
 
 	/*prepare configuration packet*/
 	strWID.id = (u16)WID_IP_ADDRESS;
@@ -734,7 +724,7 @@ s32 Handle_get_IPAddress(struct host_if_drv *drvHandler, u8 *pu8IPAddr, u8 idx)
 	strWID.size = IP_ALEN;
 
 	s32Error = send_config_pkt(GET_CFG, &strWID, 1,
-				   get_id_from_handler(pstrWFIDrv));
+				   get_id_from_handler(hif_drv));
 
 	PRINT_INFO(HOSTINF_DBG, "%pI4\n", strWID.val);
 
@@ -744,7 +734,7 @@ s32 Handle_get_IPAddress(struct host_if_drv *drvHandler, u8 *pu8IPAddr, u8 idx)
 	kfree(strWID.val);
 
 	if (memcmp(gs8GetIP[idx], gs8SetIP[idx], IP_ALEN) != 0)
-		host_int_setup_ipaddress(pstrWFIDrv, gs8SetIP[idx], idx);
+		host_int_setup_ipaddress(hif_drv, gs8SetIP[idx], idx);
 
 	if (s32Error != 0) {
 		PRINT_ER("Failed to get IP address\n");
@@ -768,13 +758,12 @@ s32 Handle_get_IPAddress(struct host_if_drv *drvHandler, u8 *pu8IPAddr, u8 idx)
  *  @date		November 2013
  *  @version	7.0
  */
-static s32 Handle_SetMacAddress(struct host_if_drv *drvHandler,
+static s32 Handle_SetMacAddress(struct host_if_drv *hif_drv,
 				struct set_mac_addr *pstrHostIfSetMacAddress)
 {
 
 	s32 s32Error = 0;
 	struct wid strWID;
-	struct host_if_drv *pstrWFIDrv = (struct host_if_drv *)drvHandler;
 	u8 *mac_buf = kmalloc(ETH_ALEN, GFP_KERNEL);
 
 	if (mac_buf == NULL) {
@@ -791,7 +780,7 @@ static s32 Handle_SetMacAddress(struct host_if_drv *drvHandler,
 	PRINT_D(GENERIC_DBG, "mac addr = :%pM\n", strWID.val);
 	/*Sending Cfg*/
 	s32Error = send_config_pkt(SET_CFG, &strWID, 1,
-				   get_id_from_handler(pstrWFIDrv));
+				   get_id_from_handler(hif_drv));
 	if (s32Error) {
 		PRINT_ER("Failed to set mac address\n");
 		s32Error = -EFAULT;
@@ -811,7 +800,7 @@ static s32 Handle_SetMacAddress(struct host_if_drv *drvHandler,
  *  @date		JAN 2013
  *  @version	8.0
  */
-static s32 Handle_GetMacAddress(struct host_if_drv *drvHandler,
+static s32 Handle_GetMacAddress(struct host_if_drv *hif_drv,
 				struct get_mac_addr *pstrHostIfGetMacAddress)
 {
 
@@ -826,7 +815,7 @@ static s32 Handle_GetMacAddress(struct host_if_drv *drvHandler,
 
 	/*Sending Cfg*/
 	s32Error = send_config_pkt(GET_CFG, &strWID, 1,
-				   get_id_from_handler(drvHandler));
+				   get_id_from_handler(hif_drv));
 	if (s32Error) {
 		PRINT_ER("Failed to get mac address\n");
 		s32Error = -EFAULT;
@@ -846,16 +835,14 @@ static s32 Handle_GetMacAddress(struct host_if_drv *drvHandler,
  *  @date
  *  @version	1.0
  */
-static s32 Handle_CfgParam(struct host_if_drv *drvHandler,
+static s32 Handle_CfgParam(struct host_if_drv *hif_drv,
 			   struct cfg_param_attr *strHostIFCfgParamAttr)
 {
 	s32 s32Error = 0;
 	struct wid strWIDList[32];
 	u8 u8WidCnt = 0;
-	struct host_if_drv *pstrWFIDrv = (struct host_if_drv *)drvHandler;
-
 
-	down(&(pstrWFIDrv->gtOsCfgValuesSem));
+	down(&hif_drv->gtOsCfgValuesSem);
 
 
 	PRINT_D(HOSTINF_DBG, "Setting CFG params\n");
@@ -872,7 +859,7 @@ static s32 Handle_CfgParam(struct host_if_drv *drvHandler,
 			strWIDList[u8WidCnt].val = (s8 *)&strHostIFCfgParamAttr->pstrCfgParamVal.bss_type;
 			strWIDList[u8WidCnt].type = WID_CHAR;
 			strWIDList[u8WidCnt].size = sizeof(char);
-			pstrWFIDrv->strCfgValues.bss_type = (u8)strHostIFCfgParamAttr->pstrCfgParamVal.bss_type;
+			hif_drv->strCfgValues.bss_type = (u8)strHostIFCfgParamAttr->pstrCfgParamVal.bss_type;
 		} else {
 			PRINT_ER("check value 6 over\n");
 			s32Error = -EINVAL;
@@ -892,7 +879,7 @@ static s32 Handle_CfgParam(struct host_if_drv *drvHandler,
 			strWIDList[u8WidCnt].val = (s8 *)&strHostIFCfgParamAttr->pstrCfgParamVal.auth_type;
 			strWIDList[u8WidCnt].type = WID_CHAR;
 			strWIDList[u8WidCnt].size = sizeof(char);
-			pstrWFIDrv->strCfgValues.auth_type = (u8)strHostIFCfgParamAttr->pstrCfgParamVal.auth_type;
+			hif_drv->strCfgValues.auth_type = (u8)strHostIFCfgParamAttr->pstrCfgParamVal.auth_type;
 		} else {
 			PRINT_ER("Impossible value \n");
 			s32Error = -EINVAL;
@@ -907,7 +894,7 @@ static s32 Handle_CfgParam(struct host_if_drv *drvHandler,
 			strWIDList[u8WidCnt].val = (s8 *)&strHostIFCfgParamAttr->pstrCfgParamVal.auth_timeout;
 			strWIDList[u8WidCnt].type = WID_SHORT;
 			strWIDList[u8WidCnt].size = sizeof(u16);
-			pstrWFIDrv->strCfgValues.auth_timeout = strHostIFCfgParamAttr->pstrCfgParamVal.auth_timeout;
+			hif_drv->strCfgValues.auth_timeout = strHostIFCfgParamAttr->pstrCfgParamVal.auth_timeout;
 		} else {
 			PRINT_ER("Range(1 ~ 65535) over\n");
 			s32Error = -EINVAL;
@@ -928,7 +915,7 @@ static s32 Handle_CfgParam(struct host_if_drv *drvHandler,
 			strWIDList[u8WidCnt].val = (s8 *)&strHostIFCfgParamAttr->pstrCfgParamVal.power_mgmt_mode;
 			strWIDList[u8WidCnt].type = WID_CHAR;
 			strWIDList[u8WidCnt].size = sizeof(char);
-			pstrWFIDrv->strCfgValues.power_mgmt_mode = (u8)strHostIFCfgParamAttr->pstrCfgParamVal.power_mgmt_mode;
+			hif_drv->strCfgValues.power_mgmt_mode = (u8)strHostIFCfgParamAttr->pstrCfgParamVal.power_mgmt_mode;
 		} else {
 			PRINT_ER("Invalide power mode\n");
 			s32Error = -EINVAL;
@@ -943,7 +930,7 @@ static s32 Handle_CfgParam(struct host_if_drv *drvHandler,
 			strWIDList[u8WidCnt].val = (s8 *)&strHostIFCfgParamAttr->pstrCfgParamVal.short_retry_limit;
 			strWIDList[u8WidCnt].type = WID_SHORT;
 			strWIDList[u8WidCnt].size = sizeof(u16);
-			pstrWFIDrv->strCfgValues.short_retry_limit = strHostIFCfgParamAttr->pstrCfgParamVal.short_retry_limit;
+			hif_drv->strCfgValues.short_retry_limit = strHostIFCfgParamAttr->pstrCfgParamVal.short_retry_limit;
 		} else {
 			PRINT_ER("Range(1~256) over\n");
 			s32Error = -EINVAL;
@@ -959,7 +946,7 @@ static s32 Handle_CfgParam(struct host_if_drv *drvHandler,
 
 			strWIDList[u8WidCnt].type = WID_SHORT;
 			strWIDList[u8WidCnt].size = sizeof(u16);
-			pstrWFIDrv->strCfgValues.long_retry_limit = strHostIFCfgParamAttr->pstrCfgParamVal.long_retry_limit;
+			hif_drv->strCfgValues.long_retry_limit = strHostIFCfgParamAttr->pstrCfgParamVal.long_retry_limit;
 		} else {
 			PRINT_ER("Range(1~256) over\n");
 			s32Error = -EINVAL;
@@ -974,7 +961,7 @@ static s32 Handle_CfgParam(struct host_if_drv *drvHandler,
 			strWIDList[u8WidCnt].val = (s8 *)&strHostIFCfgParamAttr->pstrCfgParamVal.frag_threshold;
 			strWIDList[u8WidCnt].type = WID_SHORT;
 			strWIDList[u8WidCnt].size = sizeof(u16);
-			pstrWFIDrv->strCfgValues.frag_threshold = strHostIFCfgParamAttr->pstrCfgParamVal.frag_threshold;
+			hif_drv->strCfgValues.frag_threshold = strHostIFCfgParamAttr->pstrCfgParamVal.frag_threshold;
 		} else {
 			PRINT_ER("Threshold Range fail\n");
 			s32Error = -EINVAL;
@@ -989,7 +976,7 @@ static s32 Handle_CfgParam(struct host_if_drv *drvHandler,
 			strWIDList[u8WidCnt].val = (s8 *)&strHostIFCfgParamAttr->pstrCfgParamVal.rts_threshold;
 			strWIDList[u8WidCnt].type = WID_SHORT;
 			strWIDList[u8WidCnt].size = sizeof(u16);
-			pstrWFIDrv->strCfgValues.rts_threshold = strHostIFCfgParamAttr->pstrCfgParamVal.rts_threshold;
+			hif_drv->strCfgValues.rts_threshold = strHostIFCfgParamAttr->pstrCfgParamVal.rts_threshold;
 		} else {
 			PRINT_ER("Threshold Range fail\n");
 			s32Error = -EINVAL;
@@ -1008,7 +995,7 @@ static s32 Handle_CfgParam(struct host_if_drv *drvHandler,
 			strWIDList[u8WidCnt].val = (s8 *)&strHostIFCfgParamAttr->pstrCfgParamVal.preamble_type;
 			strWIDList[u8WidCnt].type = WID_CHAR;
 			strWIDList[u8WidCnt].size = sizeof(char);
-			pstrWFIDrv->strCfgValues.preamble_type = strHostIFCfgParamAttr->pstrCfgParamVal.preamble_type;
+			hif_drv->strCfgValues.preamble_type = strHostIFCfgParamAttr->pstrCfgParamVal.preamble_type;
 		} else {
 			PRINT_ER("Preamle Range(0~2) over\n");
 			s32Error = -EINVAL;
@@ -1022,7 +1009,7 @@ static s32 Handle_CfgParam(struct host_if_drv *drvHandler,
 			strWIDList[u8WidCnt].val = (s8 *)&strHostIFCfgParamAttr->pstrCfgParamVal.short_slot_allowed;
 			strWIDList[u8WidCnt].type = WID_CHAR;
 			strWIDList[u8WidCnt].size = sizeof(char);
-			pstrWFIDrv->strCfgValues.short_slot_allowed = (u8)strHostIFCfgParamAttr->pstrCfgParamVal.short_slot_allowed;
+			hif_drv->strCfgValues.short_slot_allowed = (u8)strHostIFCfgParamAttr->pstrCfgParamVal.short_slot_allowed;
 		} else {
 			PRINT_ER("Short slot(2) over\n");
 			s32Error = -EINVAL;
@@ -1040,7 +1027,7 @@ static s32 Handle_CfgParam(struct host_if_drv *drvHandler,
 			strWIDList[u8WidCnt].val = (s8 *)&strHostIFCfgParamAttr->pstrCfgParamVal.txop_prot_disabled;
 			strWIDList[u8WidCnt].type = WID_CHAR;
 			strWIDList[u8WidCnt].size = sizeof(char);
-			pstrWFIDrv->strCfgValues.txop_prot_disabled = (u8)strHostIFCfgParamAttr->pstrCfgParamVal.txop_prot_disabled;
+			hif_drv->strCfgValues.txop_prot_disabled = (u8)strHostIFCfgParamAttr->pstrCfgParamVal.txop_prot_disabled;
 		} else {
 			PRINT_ER("TXOP prot disable\n");
 			s32Error = -EINVAL;
@@ -1055,7 +1042,7 @@ static s32 Handle_CfgParam(struct host_if_drv *drvHandler,
 			strWIDList[u8WidCnt].val = (s8 *)&strHostIFCfgParamAttr->pstrCfgParamVal.beacon_interval;
 			strWIDList[u8WidCnt].type = WID_SHORT;
 			strWIDList[u8WidCnt].size = sizeof(u16);
-			pstrWFIDrv->strCfgValues.beacon_interval = strHostIFCfgParamAttr->pstrCfgParamVal.beacon_interval;
+			hif_drv->strCfgValues.beacon_interval = strHostIFCfgParamAttr->pstrCfgParamVal.beacon_interval;
 		} else {
 			PRINT_ER("Beacon interval(1~65535) fail\n");
 			s32Error = -EINVAL;
@@ -1070,7 +1057,7 @@ static s32 Handle_CfgParam(struct host_if_drv *drvHandler,
 			strWIDList[u8WidCnt].val = (s8 *)&strHostIFCfgParamAttr->pstrCfgParamVal.dtim_period;
 			strWIDList[u8WidCnt].type = WID_CHAR;
 			strWIDList[u8WidCnt].size = sizeof(char);
-			pstrWFIDrv->strCfgValues.dtim_period = strHostIFCfgParamAttr->pstrCfgParamVal.dtim_period;
+			hif_drv->strCfgValues.dtim_period = strHostIFCfgParamAttr->pstrCfgParamVal.dtim_period;
 		} else {
 			PRINT_ER("DTIM range(1~255) fail\n");
 			s32Error = -EINVAL;
@@ -1089,7 +1076,7 @@ static s32 Handle_CfgParam(struct host_if_drv *drvHandler,
 			strWIDList[u8WidCnt].val = (s8 *)&strHostIFCfgParamAttr->pstrCfgParamVal.site_survey_enabled;
 			strWIDList[u8WidCnt].type = WID_CHAR;
 			strWIDList[u8WidCnt].size = sizeof(char);
-			pstrWFIDrv->strCfgValues.site_survey_enabled = (u8)strHostIFCfgParamAttr->pstrCfgParamVal.site_survey_enabled;
+			hif_drv->strCfgValues.site_survey_enabled = (u8)strHostIFCfgParamAttr->pstrCfgParamVal.site_survey_enabled;
 		} else {
 			PRINT_ER("Site survey disable\n");
 			s32Error = -EINVAL;
@@ -1104,7 +1091,7 @@ static s32 Handle_CfgParam(struct host_if_drv *drvHandler,
 			strWIDList[u8WidCnt].val = (s8 *)&strHostIFCfgParamAttr->pstrCfgParamVal.site_survey_scan_time;
 			strWIDList[u8WidCnt].type = WID_SHORT;
 			strWIDList[u8WidCnt].size = sizeof(u16);
-			pstrWFIDrv->strCfgValues.site_survey_scan_time = strHostIFCfgParamAttr->pstrCfgParamVal.site_survey_scan_time;
+			hif_drv->strCfgValues.site_survey_scan_time = strHostIFCfgParamAttr->pstrCfgParamVal.site_survey_scan_time;
 		} else {
 			PRINT_ER("Site survey scan time(1~65535) over\n");
 			s32Error = -EINVAL;
@@ -1119,7 +1106,7 @@ static s32 Handle_CfgParam(struct host_if_drv *drvHandler,
 			strWIDList[u8WidCnt].val = (s8 *)&strHostIFCfgParamAttr->pstrCfgParamVal.active_scan_time;
 			strWIDList[u8WidCnt].type = WID_SHORT;
 			strWIDList[u8WidCnt].size = sizeof(u16);
-			pstrWFIDrv->strCfgValues.active_scan_time = strHostIFCfgParamAttr->pstrCfgParamVal.active_scan_time;
+			hif_drv->strCfgValues.active_scan_time = strHostIFCfgParamAttr->pstrCfgParamVal.active_scan_time;
 		} else {
 			PRINT_ER("Active scan time(1~65535) over\n");
 			s32Error = -EINVAL;
@@ -1134,7 +1121,7 @@ static s32 Handle_CfgParam(struct host_if_drv *drvHandler,
 			strWIDList[u8WidCnt].val = (s8 *)&strHostIFCfgParamAttr->pstrCfgParamVal.passive_scan_time;
 			strWIDList[u8WidCnt].type = WID_SHORT;
 			strWIDList[u8WidCnt].size = sizeof(u16);
-			pstrWFIDrv->strCfgValues.passive_scan_time = strHostIFCfgParamAttr->pstrCfgParamVal.passive_scan_time;
+			hif_drv->strCfgValues.passive_scan_time = strHostIFCfgParamAttr->pstrCfgParamVal.passive_scan_time;
 		} else {
 			PRINT_ER("Passive scan time(1~65535) over\n");
 			s32Error = -EINVAL;
@@ -1159,7 +1146,7 @@ static s32 Handle_CfgParam(struct host_if_drv *drvHandler,
 			strWIDList[u8WidCnt].val = (s8 *)&curr_tx_rate;
 			strWIDList[u8WidCnt].type = WID_SHORT;
 			strWIDList[u8WidCnt].size = sizeof(u16);
-			pstrWFIDrv->strCfgValues.curr_tx_rate = (u8)curr_tx_rate;
+			hif_drv->strCfgValues.curr_tx_rate = (u8)curr_tx_rate;
 		} else {
 			PRINT_ER("out of TX rate\n");
 			s32Error = -EINVAL;
@@ -1168,13 +1155,13 @@ static s32 Handle_CfgParam(struct host_if_drv *drvHandler,
 		u8WidCnt++;
 	}
 	s32Error = send_config_pkt(SET_CFG, strWIDList, u8WidCnt,
-				   get_id_from_handler(pstrWFIDrv));
+				   get_id_from_handler(hif_drv));
 
 	if (s32Error)
 		PRINT_ER("Error in setting CFG params\n");
 
 ERRORHANDLER:
-	up(&(pstrWFIDrv->gtOsCfgValuesSem));
+	up(&hif_drv->gtOsCfgValuesSem);
 	return s32Error;
 }
 
@@ -1204,7 +1191,7 @@ static s32 Handle_wait_msg_q_empty(void)
  *  @date
  *  @version	1.0
  */
-static s32 Handle_Scan(struct host_if_drv *drvHandler,
+static s32 Handle_Scan(struct host_if_drv *hif_drv,
 		       struct scan_attr *pstrHostIFscanAttr)
 {
 	s32 s32Error = 0;
@@ -1214,17 +1201,16 @@ static s32 Handle_Scan(struct host_if_drv *drvHandler,
 	u8 *pu8Buffer;
 	u8 valuesize = 0;
 	u8 *pu8HdnNtwrksWidVal = NULL;
-	struct host_if_drv *pstrWFIDrv = (struct host_if_drv *) drvHandler;
 
 	PRINT_D(HOSTINF_DBG, "Setting SCAN params\n");
-	PRINT_D(HOSTINF_DBG, "Scanning: In [%d] state\n", pstrWFIDrv->enuHostIFstate);
+	PRINT_D(HOSTINF_DBG, "Scanning: In [%d] state\n", hif_drv->enuHostIFstate);
 
-	pstrWFIDrv->strWILC_UsrScanReq.pfUserScanResult = pstrHostIFscanAttr->pfScanResult;
-	pstrWFIDrv->strWILC_UsrScanReq.u32UserScanPvoid = pstrHostIFscanAttr->pvUserArg;
+	hif_drv->strWILC_UsrScanReq.pfUserScanResult = pstrHostIFscanAttr->pfScanResult;
+	hif_drv->strWILC_UsrScanReq.u32UserScanPvoid = pstrHostIFscanAttr->pvUserArg;
 
-	if ((pstrWFIDrv->enuHostIFstate >= HOST_IF_SCANNING) && (pstrWFIDrv->enuHostIFstate < HOST_IF_CONNECTED)) {
+	if ((hif_drv->enuHostIFstate >= HOST_IF_SCANNING) && (hif_drv->enuHostIFstate < HOST_IF_CONNECTED)) {
 		/* here we either in HOST_IF_SCANNING, HOST_IF_WAITING_CONN_REQ or HOST_IF_WAITING_CONN_RESP */
-		PRINT_D(GENERIC_DBG, "Don't scan we are already in [%d] state\n", pstrWFIDrv->enuHostIFstate);
+		PRINT_D(GENERIC_DBG, "Don't scan we are already in [%d] state\n", hif_drv->enuHostIFstate);
 		PRINT_ER("Already scan\n");
 		s32Error = -EBUSY;
 		goto ERRORHANDLER;
@@ -1240,7 +1226,7 @@ static s32 Handle_Scan(struct host_if_drv *drvHandler,
 	PRINT_D(HOSTINF_DBG, "Setting SCAN params\n");
 
 
-	pstrWFIDrv->strWILC_UsrScanReq.u32RcvdChCount = 0;
+	hif_drv->strWILC_UsrScanReq.u32RcvdChCount = 0;
 
 	strWIDList[u32WidsCount].id = (u16)WID_SSID_PROBE_REQ;
 	strWIDList[u32WidsCount].type = WID_STR;
@@ -1314,13 +1300,13 @@ static s32 Handle_Scan(struct host_if_drv *drvHandler,
 	/*keep the state as is , no need to change it*/
 	/* gWFiDrvHandle->enuHostIFstate = HOST_IF_SCANNING; */
 
-	if (pstrWFIDrv->enuHostIFstate == HOST_IF_CONNECTED)
+	if (hif_drv->enuHostIFstate == HOST_IF_CONNECTED)
 		gbScanWhileConnected = true;
-	else if (pstrWFIDrv->enuHostIFstate == HOST_IF_IDLE)
+	else if (hif_drv->enuHostIFstate == HOST_IF_IDLE)
 		gbScanWhileConnected = false;
 
 	s32Error = send_config_pkt(SET_CFG, strWIDList, u32WidsCount,
-				   get_id_from_handler(pstrWFIDrv));
+				   get_id_from_handler(hif_drv));
 
 	if (s32Error)
 		PRINT_ER("Failed to send scan paramters config packet\n");
@@ -1329,9 +1315,9 @@ static s32 Handle_Scan(struct host_if_drv *drvHandler,
 
 ERRORHANDLER:
 	if (s32Error) {
-		del_timer(&pstrWFIDrv->hScanTimer);
+		del_timer(&hif_drv->hScanTimer);
 		/*if there is an ongoing scan request*/
-		Handle_ScanDone(drvHandler, SCAN_EVENT_ABORTED);
+		Handle_ScanDone(hif_drv, SCAN_EVENT_ABORTED);
 	}
 
 	/* Deallocate pstrHostIFscanAttr->u8ChnlListLen which was prevoisuly allocated by the sending thread */
@@ -1371,13 +1357,10 @@ ERRORHANDLER:
  *  @date
  *  @version	1.0
  */
-static s32 Handle_ScanDone(struct host_if_drv *drvHandler, enum scan_event enuEvent)
+static s32 Handle_ScanDone(struct host_if_drv *hif_drv,
+			   enum scan_event enuEvent)
 {
 	s32 s32Error = 0;
-
-	struct host_if_drv *pstrWFIDrv = (struct host_if_drv *)drvHandler;
-
-
 	u8 u8abort_running_scan;
 	struct wid strWID;
 
@@ -1395,24 +1378,24 @@ static s32 Handle_ScanDone(struct host_if_drv *drvHandler, enum scan_event enuEv
 
 		/*Sending Cfg*/
 		s32Error = send_config_pkt(SET_CFG, &strWID, 1,
-					   get_id_from_handler(pstrWFIDrv));
+					   get_id_from_handler(hif_drv));
 		if (s32Error) {
 			PRINT_ER("Failed to set abort running scan\n");
 			s32Error = -EFAULT;
 		}
 	}
 
-	if (pstrWFIDrv == NULL)	{
+	if (!hif_drv) {
 		PRINT_ER("Driver handler is NULL\n");
 		return s32Error;
 	}
 
 	/*if there is an ongoing scan request*/
-	if (pstrWFIDrv->strWILC_UsrScanReq.pfUserScanResult) {
-		pstrWFIDrv->strWILC_UsrScanReq.pfUserScanResult(enuEvent, NULL,
-								pstrWFIDrv->strWILC_UsrScanReq.u32UserScanPvoid, NULL);
+	if (hif_drv->strWILC_UsrScanReq.pfUserScanResult) {
+		hif_drv->strWILC_UsrScanReq.pfUserScanResult(enuEvent, NULL,
+								hif_drv->strWILC_UsrScanReq.u32UserScanPvoid, NULL);
 		/*delete current scan request*/
-		pstrWFIDrv->strWILC_UsrScanReq.pfUserScanResult = NULL;
+		hif_drv->strWILC_UsrScanReq.pfUserScanResult = NULL;
 	}
 
 	return s32Error;
@@ -1428,10 +1411,9 @@ static s32 Handle_ScanDone(struct host_if_drv *drvHandler, enum scan_event enuEv
  *  @version	1.0
  */
 u8 u8ConnectedSSID[6] = {0};
-static s32 Handle_Connect(struct host_if_drv *drvHandler,
+static s32 Handle_Connect(struct host_if_drv *hif_drv,
 			  struct connect_attr *pstrHostIFconnectAttr)
 {
-	struct host_if_drv *pstrWFIDrv = (struct host_if_drv *) drvHandler;
 	s32 s32Error = 0;
 	struct wid strWIDList[8];
 	u32 u32WidsCount = 0, dummyval = 0;
@@ -1460,29 +1442,29 @@ static s32 Handle_Connect(struct host_if_drv *drvHandler,
 	}
 
 	if (pstrHostIFconnectAttr->pu8bssid != NULL) {
-		pstrWFIDrv->strWILC_UsrConnReq.pu8bssid = kmalloc(6, GFP_KERNEL);
-		memcpy(pstrWFIDrv->strWILC_UsrConnReq.pu8bssid, pstrHostIFconnectAttr->pu8bssid, 6);
+		hif_drv->strWILC_UsrConnReq.pu8bssid = kmalloc(6, GFP_KERNEL);
+		memcpy(hif_drv->strWILC_UsrConnReq.pu8bssid, pstrHostIFconnectAttr->pu8bssid, 6);
 	}
 
-	pstrWFIDrv->strWILC_UsrConnReq.ssidLen = pstrHostIFconnectAttr->ssidLen;
+	hif_drv->strWILC_UsrConnReq.ssidLen = pstrHostIFconnectAttr->ssidLen;
 	if (pstrHostIFconnectAttr->pu8ssid != NULL) {
-		pstrWFIDrv->strWILC_UsrConnReq.pu8ssid = kmalloc(pstrHostIFconnectAttr->ssidLen + 1, GFP_KERNEL);
-		memcpy(pstrWFIDrv->strWILC_UsrConnReq.pu8ssid, pstrHostIFconnectAttr->pu8ssid,
+		hif_drv->strWILC_UsrConnReq.pu8ssid = kmalloc(pstrHostIFconnectAttr->ssidLen + 1, GFP_KERNEL);
+		memcpy(hif_drv->strWILC_UsrConnReq.pu8ssid, pstrHostIFconnectAttr->pu8ssid,
 			    pstrHostIFconnectAttr->ssidLen);
-		pstrWFIDrv->strWILC_UsrConnReq.pu8ssid[pstrHostIFconnectAttr->ssidLen] = '\0';
+		hif_drv->strWILC_UsrConnReq.pu8ssid[pstrHostIFconnectAttr->ssidLen] = '\0';
 	}
 
-	pstrWFIDrv->strWILC_UsrConnReq.ConnReqIEsLen = pstrHostIFconnectAttr->IEsLen;
+	hif_drv->strWILC_UsrConnReq.ConnReqIEsLen = pstrHostIFconnectAttr->IEsLen;
 	if (pstrHostIFconnectAttr->pu8IEs != NULL) {
-		pstrWFIDrv->strWILC_UsrConnReq.pu8ConnReqIEs = kmalloc(pstrHostIFconnectAttr->IEsLen, GFP_KERNEL);
-		memcpy(pstrWFIDrv->strWILC_UsrConnReq.pu8ConnReqIEs, pstrHostIFconnectAttr->pu8IEs,
+		hif_drv->strWILC_UsrConnReq.pu8ConnReqIEs = kmalloc(pstrHostIFconnectAttr->IEsLen, GFP_KERNEL);
+		memcpy(hif_drv->strWILC_UsrConnReq.pu8ConnReqIEs, pstrHostIFconnectAttr->pu8IEs,
 			    pstrHostIFconnectAttr->IEsLen);
 	}
 
-	pstrWFIDrv->strWILC_UsrConnReq.u8security = pstrHostIFconnectAttr->u8security;
-	pstrWFIDrv->strWILC_UsrConnReq.tenuAuth_type = pstrHostIFconnectAttr->tenuAuth_type;
-	pstrWFIDrv->strWILC_UsrConnReq.pfUserConnectResult = pstrHostIFconnectAttr->pfConnectResult;
-	pstrWFIDrv->strWILC_UsrConnReq.u32UserConnectPvoid = pstrHostIFconnectAttr->pvUserArg;
+	hif_drv->strWILC_UsrConnReq.u8security = pstrHostIFconnectAttr->u8security;
+	hif_drv->strWILC_UsrConnReq.tenuAuth_type = pstrHostIFconnectAttr->tenuAuth_type;
+	hif_drv->strWILC_UsrConnReq.pfUserConnectResult = pstrHostIFconnectAttr->pfConnectResult;
+	hif_drv->strWILC_UsrConnReq.u32UserConnectPvoid = pstrHostIFconnectAttr->pvUserArg;
 
 	strWIDList[u32WidsCount].id = WID_SUCCESS_FRAME_COUNT;
 	strWIDList[u32WidsCount].type = WID_INT;
@@ -1508,40 +1490,40 @@ static s32 Handle_Connect(struct host_if_drv *drvHandler,
 		/* IEs to be inserted in Association Request */
 		strWIDList[u32WidsCount].id = WID_INFO_ELEMENT_ASSOCIATE;
 		strWIDList[u32WidsCount].type = WID_BIN_DATA;
-		strWIDList[u32WidsCount].val = pstrWFIDrv->strWILC_UsrConnReq.pu8ConnReqIEs;
-		strWIDList[u32WidsCount].size = pstrWFIDrv->strWILC_UsrConnReq.ConnReqIEsLen;
+		strWIDList[u32WidsCount].val = hif_drv->strWILC_UsrConnReq.pu8ConnReqIEs;
+		strWIDList[u32WidsCount].size = hif_drv->strWILC_UsrConnReq.ConnReqIEsLen;
 		u32WidsCount++;
 
 		if (memcmp("DIRECT-", pstrHostIFconnectAttr->pu8ssid, 7)) {
 
-			gu32FlushedInfoElemAsocSize = pstrWFIDrv->strWILC_UsrConnReq.ConnReqIEsLen;
+			gu32FlushedInfoElemAsocSize = hif_drv->strWILC_UsrConnReq.ConnReqIEsLen;
 			gu8FlushedInfoElemAsoc =  kmalloc(gu32FlushedInfoElemAsocSize, GFP_KERNEL);
-			memcpy(gu8FlushedInfoElemAsoc, pstrWFIDrv->strWILC_UsrConnReq.pu8ConnReqIEs,
+			memcpy(gu8FlushedInfoElemAsoc, hif_drv->strWILC_UsrConnReq.pu8ConnReqIEs,
 			       gu32FlushedInfoElemAsocSize);
 		}
 	}
 	strWIDList[u32WidsCount].id = (u16)WID_11I_MODE;
 	strWIDList[u32WidsCount].type = WID_CHAR;
 	strWIDList[u32WidsCount].size = sizeof(char);
-	strWIDList[u32WidsCount].val = (s8 *)(&(pstrWFIDrv->strWILC_UsrConnReq.u8security));
+	strWIDList[u32WidsCount].val = (s8 *)(&(hif_drv->strWILC_UsrConnReq.u8security));
 	u32WidsCount++;
 
 	if (memcmp("DIRECT-", pstrHostIFconnectAttr->pu8ssid, 7))
-		gu8Flushed11iMode = pstrWFIDrv->strWILC_UsrConnReq.u8security;
+		gu8Flushed11iMode = hif_drv->strWILC_UsrConnReq.u8security;
 
-	PRINT_INFO(HOSTINF_DBG, "Encrypt Mode = %x\n", pstrWFIDrv->strWILC_UsrConnReq.u8security);
+	PRINT_INFO(HOSTINF_DBG, "Encrypt Mode = %x\n", hif_drv->strWILC_UsrConnReq.u8security);
 
 
 	strWIDList[u32WidsCount].id = (u16)WID_AUTH_TYPE;
 	strWIDList[u32WidsCount].type = WID_CHAR;
 	strWIDList[u32WidsCount].size = sizeof(char);
-	strWIDList[u32WidsCount].val = (s8 *)(&pstrWFIDrv->strWILC_UsrConnReq.tenuAuth_type);
+	strWIDList[u32WidsCount].val = (s8 *)(&hif_drv->strWILC_UsrConnReq.tenuAuth_type);
 	u32WidsCount++;
 
 	if (memcmp("DIRECT-", pstrHostIFconnectAttr->pu8ssid, 7))
-		gu8FlushedAuthType = (u8)pstrWFIDrv->strWILC_UsrConnReq.tenuAuth_type;
+		gu8FlushedAuthType = (u8)hif_drv->strWILC_UsrConnReq.tenuAuth_type;
 
-	PRINT_INFO(HOSTINF_DBG, "Authentication Type = %x\n", pstrWFIDrv->strWILC_UsrConnReq.tenuAuth_type);
+	PRINT_INFO(HOSTINF_DBG, "Authentication Type = %x\n", hif_drv->strWILC_UsrConnReq.tenuAuth_type);
 	/*
 	 * strWIDList[u32WidsCount].u16WIDid = (u16)WID_11I_PSK;
 	 * strWIDList[u32WidsCount].enuWIDtype = WID_STR;
@@ -1551,7 +1533,7 @@ static s32 Handle_Connect(struct host_if_drv *drvHandler,
 	 */
 
 	PRINT_D(HOSTINF_DBG, "Connecting to network of SSID %s on channel %d\n",
-		pstrWFIDrv->strWILC_UsrConnReq.pu8ssid, pstrHostIFconnectAttr->u8channel);
+		hif_drv->strWILC_UsrConnReq.pu8ssid, pstrHostIFconnectAttr->u8channel);
 
 	strWIDList[u32WidsCount].id = (u16)WID_JOIN_REQ_EXTENDED;
 	strWIDList[u32WidsCount].type = WID_STR;
@@ -1622,7 +1604,7 @@ static s32 Handle_Connect(struct host_if_drv *drvHandler,
 	/* ht cap*/
 	*(pu8CurrByte++)  = ptstrJoinBssParam->ht_capable;
 	/* copy this information to the user request */
-	pstrWFIDrv->strWILC_UsrConnReq.IsHTCapable = ptstrJoinBssParam->ht_capable;
+	hif_drv->strWILC_UsrConnReq.IsHTCapable = ptstrJoinBssParam->ht_capable;
 
 	/* rsn found*/
 	*(pu8CurrByte++)  =  ptstrJoinBssParam->rsn_found;
@@ -1693,7 +1675,7 @@ static s32 Handle_Connect(struct host_if_drv *drvHandler,
 
 	if (memcmp("DIRECT-", pstrHostIFconnectAttr->pu8ssid, 7)) {
 		memcpy(gu8FlushedJoinReq, pu8CurrByte, gu32FlushedJoinReqSize);
-		gu8FlushedJoinReqDrvHandler = pstrWFIDrv;
+		gu8FlushedJoinReqDrvHandler = hif_drv;
 	}
 
 	PRINT_D(GENERIC_DBG, "send HOST_IF_WAITING_CONN_RESP\n");
@@ -1706,21 +1688,21 @@ static s32 Handle_Connect(struct host_if_drv *drvHandler,
 	}
 
 	s32Error = send_config_pkt(SET_CFG, strWIDList, u32WidsCount,
-				   get_id_from_handler(pstrWFIDrv));
+				   get_id_from_handler(hif_drv));
 	if (s32Error) {
 		PRINT_ER("failed to send config packet\n");
 		s32Error = -EFAULT;
 		goto ERRORHANDLER;
 	} else {
 		PRINT_D(GENERIC_DBG, "set HOST_IF_WAITING_CONN_RESP\n");
-		pstrWFIDrv->enuHostIFstate = HOST_IF_WAITING_CONN_RESP;
+		hif_drv->enuHostIFstate = HOST_IF_WAITING_CONN_RESP;
 	}
 
 ERRORHANDLER:
 	if (s32Error) {
 		tstrConnectInfo strConnectInfo;
 
-		del_timer(&pstrWFIDrv->hConnectTimer);
+		del_timer(&hif_drv->hConnectTimer);
 
 		PRINT_D(HOSTINF_DBG, "could not start connecting to the required network\n");
 
@@ -1744,7 +1726,7 @@ ERRORHANDLER:
 							       NULL,
 							       pstrHostIFconnectAttr->pvUserArg);
 			/*Change state to idle*/
-			pstrWFIDrv->enuHostIFstate = HOST_IF_IDLE;
+			hif_drv->enuHostIFstate = HOST_IF_IDLE;
 			/* Deallocation */
 			if (strConnectInfo.pu8ReqIEs != NULL) {
 				kfree(strConnectInfo.pu8ReqIEs);
@@ -1791,7 +1773,7 @@ ERRORHANDLER:
  *  @version		8.0
  */
 
-static s32 Handle_FlushConnect(struct host_if_drv *drvHandler)
+static s32 Handle_FlushConnect(struct host_if_drv *hif_drv)
 {
 	s32 s32Error = 0;
 	struct wid strWIDList[5];
@@ -1850,20 +1832,19 @@ static s32 Handle_FlushConnect(struct host_if_drv *drvHandler)
  *  @date
  *  @version	1.0
  */
-static s32 Handle_ConnectTimeout(struct host_if_drv *drvHandler)
+static s32 Handle_ConnectTimeout(struct host_if_drv *hif_drv)
 {
 	s32 s32Error = 0;
 	tstrConnectInfo strConnectInfo;
 	struct wid strWID;
 	u16 u16DummyReasonCode = 0;
-	struct host_if_drv *pstrWFIDrv = (struct host_if_drv *) drvHandler;
 
-	if (pstrWFIDrv == NULL)	{
+	if (!hif_drv) {
 		PRINT_ER("Driver handler is NULL\n");
 		return s32Error;
 	}
 
-	pstrWFIDrv->enuHostIFstate = HOST_IF_IDLE;
+	hif_drv->enuHostIFstate = HOST_IF_IDLE;
 
 	gbScanWhileConnected = false;
 
@@ -1874,25 +1855,25 @@ static s32 Handle_ConnectTimeout(struct host_if_drv *drvHandler)
 	/* First, we will notify the upper layer with the Connection failure {through the Connect Callback function},
 	 *   then we will notify our firmware also with the Connection failure {through sending to it Cfg packet carrying
 	 *   WID_DISCONNECT} */
-	if (pstrWFIDrv->strWILC_UsrConnReq.pfUserConnectResult != NULL)	{
-		if (pstrWFIDrv->strWILC_UsrConnReq.pu8bssid != NULL) {
+	if (hif_drv->strWILC_UsrConnReq.pfUserConnectResult != NULL)	{
+		if (hif_drv->strWILC_UsrConnReq.pu8bssid != NULL) {
 			memcpy(strConnectInfo.au8bssid,
-				    pstrWFIDrv->strWILC_UsrConnReq.pu8bssid, 6);
+				    hif_drv->strWILC_UsrConnReq.pu8bssid, 6);
 		}
 
-		if (pstrWFIDrv->strWILC_UsrConnReq.pu8ConnReqIEs != NULL) {
-			strConnectInfo.ReqIEsLen = pstrWFIDrv->strWILC_UsrConnReq.ConnReqIEsLen;
-			strConnectInfo.pu8ReqIEs = kmalloc(pstrWFIDrv->strWILC_UsrConnReq.ConnReqIEsLen, GFP_KERNEL);
+		if (hif_drv->strWILC_UsrConnReq.pu8ConnReqIEs != NULL) {
+			strConnectInfo.ReqIEsLen = hif_drv->strWILC_UsrConnReq.ConnReqIEsLen;
+			strConnectInfo.pu8ReqIEs = kmalloc(hif_drv->strWILC_UsrConnReq.ConnReqIEsLen, GFP_KERNEL);
 			memcpy(strConnectInfo.pu8ReqIEs,
-				    pstrWFIDrv->strWILC_UsrConnReq.pu8ConnReqIEs,
-				    pstrWFIDrv->strWILC_UsrConnReq.ConnReqIEsLen);
+				    hif_drv->strWILC_UsrConnReq.pu8ConnReqIEs,
+				    hif_drv->strWILC_UsrConnReq.ConnReqIEsLen);
 		}
 
-		pstrWFIDrv->strWILC_UsrConnReq.pfUserConnectResult(CONN_DISCONN_EVENT_CONN_RESP,
+		hif_drv->strWILC_UsrConnReq.pfUserConnectResult(CONN_DISCONN_EVENT_CONN_RESP,
 								   &strConnectInfo,
 								   MAC_DISCONNECTED,
 								   NULL,
-								   pstrWFIDrv->strWILC_UsrConnReq.u32UserConnectPvoid);
+								   hif_drv->strWILC_UsrConnReq.u32UserConnectPvoid);
 
 		/* Deallocation of strConnectInfo.pu8ReqIEs */
 		if (strConnectInfo.pu8ReqIEs != NULL) {
@@ -1913,35 +1894,24 @@ static s32 Handle_ConnectTimeout(struct host_if_drv *drvHandler)
 	PRINT_D(HOSTINF_DBG, "Sending disconnect request\n");
 
 	s32Error = send_config_pkt(SET_CFG, &strWID, 1,
-				   get_id_from_handler(pstrWFIDrv));
+				   get_id_from_handler(hif_drv));
 	if (s32Error)
 		PRINT_ER("Failed to send dissconect config packet\n");
 
 	/* Deallocation of the Saved Connect Request in the global Handle */
-	pstrWFIDrv->strWILC_UsrConnReq.ssidLen = 0;
-	if (pstrWFIDrv->strWILC_UsrConnReq.pu8ssid != NULL) {
-		kfree(pstrWFIDrv->strWILC_UsrConnReq.pu8ssid);
-		pstrWFIDrv->strWILC_UsrConnReq.pu8ssid = NULL;
-	}
-
-	if (pstrWFIDrv->strWILC_UsrConnReq.pu8bssid != NULL) {
-		kfree(pstrWFIDrv->strWILC_UsrConnReq.pu8bssid);
-		pstrWFIDrv->strWILC_UsrConnReq.pu8bssid = NULL;
-	}
-
-	pstrWFIDrv->strWILC_UsrConnReq.ConnReqIEsLen = 0;
-	if (pstrWFIDrv->strWILC_UsrConnReq.pu8ConnReqIEs != NULL) {
-		kfree(pstrWFIDrv->strWILC_UsrConnReq.pu8ConnReqIEs);
-		pstrWFIDrv->strWILC_UsrConnReq.pu8ConnReqIEs = NULL;
-	}
+	hif_drv->strWILC_UsrConnReq.ssidLen = 0;
+	kfree(hif_drv->strWILC_UsrConnReq.pu8ssid);
+	kfree(hif_drv->strWILC_UsrConnReq.pu8bssid);
+	hif_drv->strWILC_UsrConnReq.ConnReqIEsLen = 0;
+	kfree(hif_drv->strWILC_UsrConnReq.pu8ConnReqIEs);
 
 	eth_zero_addr(u8ConnectedSSID);
 	/*Freeing flushed join request params on connect timeout*/
-	if (gu8FlushedJoinReq != NULL && gu8FlushedJoinReqDrvHandler == drvHandler) {
+	if (gu8FlushedJoinReq != NULL && gu8FlushedJoinReqDrvHandler == hif_drv) {
 		kfree(gu8FlushedJoinReq);
 		gu8FlushedJoinReq = NULL;
 	}
-	if (gu8FlushedInfoElemAsoc != NULL && gu8FlushedJoinReqDrvHandler == drvHandler) {
+	if (gu8FlushedInfoElemAsoc != NULL && gu8FlushedJoinReqDrvHandler == hif_drv) {
 		kfree(gu8FlushedInfoElemAsoc);
 		gu8FlushedInfoElemAsoc = NULL;
 	}
@@ -1958,7 +1928,7 @@ static s32 Handle_ConnectTimeout(struct host_if_drv *drvHandler)
  *  @date
  *  @version	1.0
  */
-static s32 Handle_RcvdNtwrkInfo(struct host_if_drv *drvHandler,
+static s32 Handle_RcvdNtwrkInfo(struct host_if_drv *hif_drv,
 				struct rcvd_net_info *pstrRcvdNetworkInfo)
 {
 	u32 i;
@@ -1970,32 +1940,28 @@ static s32 Handle_RcvdNtwrkInfo(struct host_if_drv *drvHandler,
 	tstrNetworkInfo *pstrNetworkInfo = NULL;
 	void *pJoinParams = NULL;
 
-	struct host_if_drv *pstrWFIDrv  = (struct host_if_drv *)drvHandler;
-
-
-
 	bNewNtwrkFound = true;
 	PRINT_INFO(HOSTINF_DBG, "Handling received network info\n");
 
 	/*if there is a an ongoing scan request*/
-	if (pstrWFIDrv->strWILC_UsrScanReq.pfUserScanResult) {
+	if (hif_drv->strWILC_UsrScanReq.pfUserScanResult) {
 		PRINT_D(HOSTINF_DBG, "State: Scanning, parsing network information received\n");
 		parse_network_info(pstrRcvdNetworkInfo->pu8Buffer, &pstrNetworkInfo);
 		if ((pstrNetworkInfo == NULL)
-		    || (pstrWFIDrv->strWILC_UsrScanReq.pfUserScanResult == NULL)) {
+		    || (hif_drv->strWILC_UsrScanReq.pfUserScanResult == NULL)) {
 			PRINT_ER("driver is null\n");
 			s32Error = -EINVAL;
 			goto done;
 		}
 
 		/* check whether this network is discovered before */
-		for (i = 0; i < pstrWFIDrv->strWILC_UsrScanReq.u32RcvdChCount; i++) {
+		for (i = 0; i < hif_drv->strWILC_UsrScanReq.u32RcvdChCount; i++) {
 
-			if ((pstrWFIDrv->strWILC_UsrScanReq.astrFoundNetworkInfo[i].au8bssid != NULL) &&
+			if ((hif_drv->strWILC_UsrScanReq.astrFoundNetworkInfo[i].au8bssid != NULL) &&
 			    (pstrNetworkInfo->au8bssid != NULL)) {
-				if (memcmp(pstrWFIDrv->strWILC_UsrScanReq.astrFoundNetworkInfo[i].au8bssid,
+				if (memcmp(hif_drv->strWILC_UsrScanReq.astrFoundNetworkInfo[i].au8bssid,
 						pstrNetworkInfo->au8bssid, 6) == 0) {
-					if (pstrNetworkInfo->s8rssi <= pstrWFIDrv->strWILC_UsrScanReq.astrFoundNetworkInfo[i].s8rssi) {
+					if (pstrNetworkInfo->s8rssi <= hif_drv->strWILC_UsrScanReq.astrFoundNetworkInfo[i].s8rssi) {
 						/*we have already found this network with better rssi, so keep the old cached one and don't
 						 *  send anything to the upper layer */
 						PRINT_D(HOSTINF_DBG, "Network previously discovered\n");
@@ -2004,7 +1970,7 @@ static s32 Handle_RcvdNtwrkInfo(struct host_if_drv *drvHandler,
 						/* here the same already found network is found again but with a better rssi, so just update
 						 *   the rssi for this cached network and send this updated network to the upper layer but
 						 *   don't add a new record for it */
-						pstrWFIDrv->strWILC_UsrScanReq.astrFoundNetworkInfo[i].s8rssi = pstrNetworkInfo->s8rssi;
+						hif_drv->strWILC_UsrScanReq.astrFoundNetworkInfo[i].s8rssi = pstrNetworkInfo->s8rssi;
 						bNewNtwrkFound = false;
 						break;
 					}
@@ -2018,22 +1984,22 @@ static s32 Handle_RcvdNtwrkInfo(struct host_if_drv *drvHandler,
 
 			PRINT_D(HOSTINF_DBG, "New network found\n");
 
-			if (pstrWFIDrv->strWILC_UsrScanReq.u32RcvdChCount < MAX_NUM_SCANNED_NETWORKS) {
-				pstrWFIDrv->strWILC_UsrScanReq.astrFoundNetworkInfo[pstrWFIDrv->strWILC_UsrScanReq.u32RcvdChCount].s8rssi = pstrNetworkInfo->s8rssi;
+			if (hif_drv->strWILC_UsrScanReq.u32RcvdChCount < MAX_NUM_SCANNED_NETWORKS) {
+				hif_drv->strWILC_UsrScanReq.astrFoundNetworkInfo[hif_drv->strWILC_UsrScanReq.u32RcvdChCount].s8rssi = pstrNetworkInfo->s8rssi;
 
-				if ((pstrWFIDrv->strWILC_UsrScanReq.astrFoundNetworkInfo[pstrWFIDrv->strWILC_UsrScanReq.u32RcvdChCount].au8bssid != NULL)
+				if ((hif_drv->strWILC_UsrScanReq.astrFoundNetworkInfo[hif_drv->strWILC_UsrScanReq.u32RcvdChCount].au8bssid != NULL)
 				    && (pstrNetworkInfo->au8bssid != NULL)) {
-					memcpy(pstrWFIDrv->strWILC_UsrScanReq.astrFoundNetworkInfo[pstrWFIDrv->strWILC_UsrScanReq.u32RcvdChCount].au8bssid,
+					memcpy(hif_drv->strWILC_UsrScanReq.astrFoundNetworkInfo[hif_drv->strWILC_UsrScanReq.u32RcvdChCount].au8bssid,
 						    pstrNetworkInfo->au8bssid, 6);
 
-					pstrWFIDrv->strWILC_UsrScanReq.u32RcvdChCount++;
+					hif_drv->strWILC_UsrScanReq.u32RcvdChCount++;
 
 					pstrNetworkInfo->bNewNetwork = true;
 					/* add new BSS to JoinBssTable */
 					pJoinParams = host_int_ParseJoinBssParam(pstrNetworkInfo);
 
-					pstrWFIDrv->strWILC_UsrScanReq.pfUserScanResult(SCAN_EVENT_NETWORK_FOUND, pstrNetworkInfo,
-											pstrWFIDrv->strWILC_UsrScanReq.u32UserScanPvoid,
+					hif_drv->strWILC_UsrScanReq.pfUserScanResult(SCAN_EVENT_NETWORK_FOUND, pstrNetworkInfo,
+											hif_drv->strWILC_UsrScanReq.u32UserScanPvoid,
 											pJoinParams);
 
 
@@ -2044,8 +2010,8 @@ static s32 Handle_RcvdNtwrkInfo(struct host_if_drv *drvHandler,
 		} else {
 			pstrNetworkInfo->bNewNetwork = false;
 			/* just call the User CallBack function to send the same discovered network with its updated RSSI */
-			pstrWFIDrv->strWILC_UsrScanReq.pfUserScanResult(SCAN_EVENT_NETWORK_FOUND, pstrNetworkInfo,
-									pstrWFIDrv->strWILC_UsrScanReq.u32UserScanPvoid, NULL);
+			hif_drv->strWILC_UsrScanReq.pfUserScanResult(SCAN_EVENT_NETWORK_FOUND, pstrNetworkInfo,
+									hif_drv->strWILC_UsrScanReq.u32UserScanPvoid, NULL);
 		}
 	}
 
@@ -2074,7 +2040,7 @@ done:
  *  @date
  *  @version	1.0
  */
-static s32 Handle_RcvdGnrlAsyncInfo(struct host_if_drv *drvHandler,
+static s32 Handle_RcvdGnrlAsyncInfo(struct host_if_drv *hif_drv,
 				    struct rcvd_async_info *pstrRcvdGnrlAsyncInfo)
 {
 	/* TODO: mostafa: till now, this function just handles only the received mac status msg, */
@@ -2091,20 +2057,19 @@ static s32 Handle_RcvdGnrlAsyncInfo(struct host_if_drv *drvHandler,
 	tstrConnectInfo strConnectInfo;
 	tstrDisconnectNotifInfo strDisconnectNotifInfo;
 	s32 s32Err = 0;
-	struct host_if_drv *pstrWFIDrv = (struct host_if_drv *) drvHandler;
 
-	if (!pstrWFIDrv) {
+	if (!hif_drv) {
 		PRINT_ER("Driver handler is NULL\n");
 		return -ENODEV;
 	}
-	PRINT_D(GENERIC_DBG, "Current State = %d,Received state = %d\n", pstrWFIDrv->enuHostIFstate,
+	PRINT_D(GENERIC_DBG, "Current State = %d,Received state = %d\n", hif_drv->enuHostIFstate,
 		pstrRcvdGnrlAsyncInfo->pu8Buffer[7]);
 
-	if ((pstrWFIDrv->enuHostIFstate == HOST_IF_WAITING_CONN_RESP) ||
-	    (pstrWFIDrv->enuHostIFstate == HOST_IF_CONNECTED) ||
-	    pstrWFIDrv->strWILC_UsrScanReq.pfUserScanResult) {
+	if ((hif_drv->enuHostIFstate == HOST_IF_WAITING_CONN_RESP) ||
+	    (hif_drv->enuHostIFstate == HOST_IF_CONNECTED) ||
+	    hif_drv->strWILC_UsrScanReq.pfUserScanResult) {
 		if ((pstrRcvdGnrlAsyncInfo->pu8Buffer == NULL) ||
-		    (pstrWFIDrv->strWILC_UsrConnReq.pfUserConnectResult == NULL)) {
+		    (hif_drv->strWILC_UsrConnReq.pfUserConnectResult == NULL)) {
 			PRINT_ER("driver is null\n");
 			return -EINVAL;
 		}
@@ -2134,7 +2099,7 @@ static s32 Handle_RcvdGnrlAsyncInfo(struct host_if_drv *drvHandler,
 		u8MacStatusReasonCode = pstrRcvdGnrlAsyncInfo->pu8Buffer[8];
 		u8MacStatusAdditionalInfo = pstrRcvdGnrlAsyncInfo->pu8Buffer[9];
 		PRINT_INFO(HOSTINF_DBG, "Recieved MAC status = %d with Reason = %d , Info = %d\n", u8MacStatus, u8MacStatusReasonCode, u8MacStatusAdditionalInfo);
-		if (pstrWFIDrv->enuHostIFstate == HOST_IF_WAITING_CONN_RESP) {
+		if (hif_drv->enuHostIFstate == HOST_IF_WAITING_CONN_RESP) {
 			/* our station had sent Association Request frame, so here it will get the Association Response frame then parse it */
 			u32 u32RcvdAssocRespInfoLen;
 			tstrConnectRespInfo *pstrConnectRespInfo = NULL;
@@ -2146,7 +2111,7 @@ static s32 Handle_RcvdGnrlAsyncInfo(struct host_if_drv *drvHandler,
 			if (u8MacStatus == MAC_CONNECTED) {
 				memset(gapu8RcvdAssocResp, 0, MAX_ASSOC_RESP_FRAME_SIZE);
 
-				host_int_get_assoc_res_info(pstrWFIDrv,
+				host_int_get_assoc_res_info(hif_drv,
 							    gapu8RcvdAssocResp,
 							    MAX_ASSOC_RESP_FRAME_SIZE,
 							    &u32RcvdAssocRespInfoLen);
@@ -2200,33 +2165,33 @@ static s32 Handle_RcvdGnrlAsyncInfo(struct host_if_drv *drvHandler,
 
 			/* TODO: mostafa: correct BSSID should be retrieved from actual BSSID received from AP */
 			/*               through a structure of type tstrConnectRespInfo */
-			if (pstrWFIDrv->strWILC_UsrConnReq.pu8bssid != NULL) {
+			if (hif_drv->strWILC_UsrConnReq.pu8bssid != NULL) {
 				PRINT_D(HOSTINF_DBG, "Retrieving actual BSSID from AP\n");
-				memcpy(strConnectInfo.au8bssid, pstrWFIDrv->strWILC_UsrConnReq.pu8bssid, 6);
+				memcpy(strConnectInfo.au8bssid, hif_drv->strWILC_UsrConnReq.pu8bssid, 6);
 
 				if ((u8MacStatus == MAC_CONNECTED) &&
 				    (strConnectInfo.u16ConnectStatus == SUCCESSFUL_STATUSCODE))	{
-					memcpy(pstrWFIDrv->au8AssociatedBSSID,
-						    pstrWFIDrv->strWILC_UsrConnReq.pu8bssid, ETH_ALEN);
+					memcpy(hif_drv->au8AssociatedBSSID,
+						    hif_drv->strWILC_UsrConnReq.pu8bssid, ETH_ALEN);
 				}
 			}
 
 
-			if (pstrWFIDrv->strWILC_UsrConnReq.pu8ConnReqIEs != NULL) {
-				strConnectInfo.ReqIEsLen = pstrWFIDrv->strWILC_UsrConnReq.ConnReqIEsLen;
-				strConnectInfo.pu8ReqIEs = kmalloc(pstrWFIDrv->strWILC_UsrConnReq.ConnReqIEsLen, GFP_KERNEL);
+			if (hif_drv->strWILC_UsrConnReq.pu8ConnReqIEs != NULL) {
+				strConnectInfo.ReqIEsLen = hif_drv->strWILC_UsrConnReq.ConnReqIEsLen;
+				strConnectInfo.pu8ReqIEs = kmalloc(hif_drv->strWILC_UsrConnReq.ConnReqIEsLen, GFP_KERNEL);
 				memcpy(strConnectInfo.pu8ReqIEs,
-					    pstrWFIDrv->strWILC_UsrConnReq.pu8ConnReqIEs,
-					    pstrWFIDrv->strWILC_UsrConnReq.ConnReqIEsLen);
+					    hif_drv->strWILC_UsrConnReq.pu8ConnReqIEs,
+					    hif_drv->strWILC_UsrConnReq.ConnReqIEsLen);
 			}
 
 
-			del_timer(&pstrWFIDrv->hConnectTimer);
-			pstrWFIDrv->strWILC_UsrConnReq.pfUserConnectResult(CONN_DISCONN_EVENT_CONN_RESP,
+			del_timer(&hif_drv->hConnectTimer);
+			hif_drv->strWILC_UsrConnReq.pfUserConnectResult(CONN_DISCONN_EVENT_CONN_RESP,
 									   &strConnectInfo,
 									   u8MacStatus,
 									   NULL,
-									   pstrWFIDrv->strWILC_UsrConnReq.u32UserConnectPvoid);
+									   hif_drv->strWILC_UsrConnReq.u32UserConnectPvoid);
 
 
 			/* if received mac status is MAC_CONNECTED and
@@ -2234,10 +2199,10 @@ static s32 Handle_RcvdGnrlAsyncInfo(struct host_if_drv *drvHandler,
 			 *  else change state to IDLE */
 			if ((u8MacStatus == MAC_CONNECTED) &&
 			    (strConnectInfo.u16ConnectStatus == SUCCESSFUL_STATUSCODE))	{
-				host_int_set_power_mgmt(pstrWFIDrv, 0, 0);
+				host_int_set_power_mgmt(hif_drv, 0, 0);
 
 				PRINT_D(HOSTINF_DBG, "MAC status : CONNECTED and Connect Status : Successful\n");
-				pstrWFIDrv->enuHostIFstate = HOST_IF_CONNECTED;
+				hif_drv->enuHostIFstate = HOST_IF_CONNECTED;
 
 				PRINT_D(GENERIC_DBG, "Obtaining an IP, Disable Scan\n");
 				g_obtainingIP = true;
@@ -2249,7 +2214,7 @@ static s32 Handle_RcvdGnrlAsyncInfo(struct host_if_drv *drvHandler,
 				/* BA_SESSION_DEFAULT_BUFFER_SIZE,BA_SESSION_DEFAULT_TIMEOUT); */
 			} else {
 				PRINT_D(HOSTINF_DBG, "MAC status : %d and Connect Status : %d\n", u8MacStatus, strConnectInfo.u16ConnectStatus);
-				pstrWFIDrv->enuHostIFstate = HOST_IF_IDLE;
+				hif_drv->enuHostIFstate = HOST_IF_IDLE;
 				gbScanWhileConnected = false;
 			}
 
@@ -2263,57 +2228,43 @@ static s32 Handle_RcvdGnrlAsyncInfo(struct host_if_drv *drvHandler,
 				kfree(strConnectInfo.pu8ReqIEs);
 				strConnectInfo.pu8ReqIEs = NULL;
 			}
-
-
-			pstrWFIDrv->strWILC_UsrConnReq.ssidLen = 0;
-			if (pstrWFIDrv->strWILC_UsrConnReq.pu8ssid != NULL) {
-				kfree(pstrWFIDrv->strWILC_UsrConnReq.pu8ssid);
-				pstrWFIDrv->strWILC_UsrConnReq.pu8ssid = NULL;
-			}
-
-			if (pstrWFIDrv->strWILC_UsrConnReq.pu8bssid != NULL) {
-				kfree(pstrWFIDrv->strWILC_UsrConnReq.pu8bssid);
-				pstrWFIDrv->strWILC_UsrConnReq.pu8bssid = NULL;
-			}
-
-			pstrWFIDrv->strWILC_UsrConnReq.ConnReqIEsLen = 0;
-			if (pstrWFIDrv->strWILC_UsrConnReq.pu8ConnReqIEs != NULL) {
-				kfree(pstrWFIDrv->strWILC_UsrConnReq.pu8ConnReqIEs);
-				pstrWFIDrv->strWILC_UsrConnReq.pu8ConnReqIEs = NULL;
-			}
-
+			hif_drv->strWILC_UsrConnReq.ssidLen = 0;
+			kfree(hif_drv->strWILC_UsrConnReq.pu8ssid);
+			kfree(hif_drv->strWILC_UsrConnReq.pu8bssid);
+			hif_drv->strWILC_UsrConnReq.ConnReqIEsLen = 0;
+			kfree(hif_drv->strWILC_UsrConnReq.pu8ConnReqIEs);
 		} else if ((u8MacStatus == MAC_DISCONNECTED) &&
-			   (pstrWFIDrv->enuHostIFstate == HOST_IF_CONNECTED)) {
+			   (hif_drv->enuHostIFstate == HOST_IF_CONNECTED)) {
 			/* Disassociation or Deauthentication frame has been received */
 			PRINT_D(HOSTINF_DBG, "Received MAC_DISCONNECTED from the FW\n");
 
 			memset(&strDisconnectNotifInfo, 0, sizeof(tstrDisconnectNotifInfo));
 
-			if (pstrWFIDrv->strWILC_UsrScanReq.pfUserScanResult) {
+			if (hif_drv->strWILC_UsrScanReq.pfUserScanResult) {
 				PRINT_D(HOSTINF_DBG, "\n\n<< Abort the running OBSS Scan >>\n\n");
-				del_timer(&pstrWFIDrv->hScanTimer);
-				Handle_ScanDone((void *)pstrWFIDrv, SCAN_EVENT_ABORTED);
+				del_timer(&hif_drv->hScanTimer);
+				Handle_ScanDone((void *)hif_drv, SCAN_EVENT_ABORTED);
 			}
 
 			strDisconnectNotifInfo.u16reason = 0;
 			strDisconnectNotifInfo.ie = NULL;
 			strDisconnectNotifInfo.ie_len = 0;
 
-			if (pstrWFIDrv->strWILC_UsrConnReq.pfUserConnectResult != NULL)	{
+			if (hif_drv->strWILC_UsrConnReq.pfUserConnectResult != NULL)	{
 				g_obtainingIP = false;
-				host_int_set_power_mgmt(pstrWFIDrv, 0, 0);
+				host_int_set_power_mgmt(hif_drv, 0, 0);
 
-				pstrWFIDrv->strWILC_UsrConnReq.pfUserConnectResult(CONN_DISCONN_EVENT_DISCONN_NOTIF,
+				hif_drv->strWILC_UsrConnReq.pfUserConnectResult(CONN_DISCONN_EVENT_DISCONN_NOTIF,
 										   NULL,
 										   0,
 										   &strDisconnectNotifInfo,
-										   pstrWFIDrv->strWILC_UsrConnReq.u32UserConnectPvoid);
+										   hif_drv->strWILC_UsrConnReq.u32UserConnectPvoid);
 
 			} else {
 				PRINT_ER("Connect result callback function is NULL\n");
 			}
 
-			eth_zero_addr(pstrWFIDrv->au8AssociatedBSSID);
+			eth_zero_addr(hif_drv->au8AssociatedBSSID);
 
 
 			/* Deallocation */
@@ -2328,45 +2279,34 @@ static s32 Handle_RcvdGnrlAsyncInfo(struct host_if_drv *drvHandler,
 			 * }
 			 */
 
-			pstrWFIDrv->strWILC_UsrConnReq.ssidLen = 0;
-			if (pstrWFIDrv->strWILC_UsrConnReq.pu8ssid != NULL) {
-				kfree(pstrWFIDrv->strWILC_UsrConnReq.pu8ssid);
-				pstrWFIDrv->strWILC_UsrConnReq.pu8ssid = NULL;
-			}
-
-			if (pstrWFIDrv->strWILC_UsrConnReq.pu8bssid != NULL) {
-				kfree(pstrWFIDrv->strWILC_UsrConnReq.pu8bssid);
-				pstrWFIDrv->strWILC_UsrConnReq.pu8bssid = NULL;
-			}
-
-			pstrWFIDrv->strWILC_UsrConnReq.ConnReqIEsLen = 0;
-			if (pstrWFIDrv->strWILC_UsrConnReq.pu8ConnReqIEs != NULL) {
-				kfree(pstrWFIDrv->strWILC_UsrConnReq.pu8ConnReqIEs);
-				pstrWFIDrv->strWILC_UsrConnReq.pu8ConnReqIEs = NULL;
-			}
+			hif_drv->strWILC_UsrConnReq.ssidLen = 0;
+			kfree(hif_drv->strWILC_UsrConnReq.pu8ssid);
+			kfree(hif_drv->strWILC_UsrConnReq.pu8bssid);
+			hif_drv->strWILC_UsrConnReq.ConnReqIEsLen = 0;
+			kfree(hif_drv->strWILC_UsrConnReq.pu8ConnReqIEs);
 
 			/*Freeing flushed join request params on receiving*/
 			/*MAC_DISCONNECTED while connected*/
-			if (gu8FlushedJoinReq != NULL && gu8FlushedJoinReqDrvHandler == drvHandler) {
+			if (gu8FlushedJoinReq != NULL && gu8FlushedJoinReqDrvHandler == hif_drv) {
 				kfree(gu8FlushedJoinReq);
 				gu8FlushedJoinReq = NULL;
 			}
-			if (gu8FlushedInfoElemAsoc != NULL && gu8FlushedJoinReqDrvHandler == drvHandler) {
+			if (gu8FlushedInfoElemAsoc != NULL && gu8FlushedJoinReqDrvHandler == hif_drv) {
 				kfree(gu8FlushedInfoElemAsoc);
 				gu8FlushedInfoElemAsoc = NULL;
 			}
 
-			pstrWFIDrv->enuHostIFstate = HOST_IF_IDLE;
+			hif_drv->enuHostIFstate = HOST_IF_IDLE;
 			gbScanWhileConnected = false;
 
 		} else if ((u8MacStatus == MAC_DISCONNECTED) &&
-			   (pstrWFIDrv->strWILC_UsrScanReq.pfUserScanResult != NULL)) {
+			   (hif_drv->strWILC_UsrScanReq.pfUserScanResult != NULL)) {
 			PRINT_D(HOSTINF_DBG, "Received MAC_DISCONNECTED from the FW while scanning\n");
 			PRINT_D(HOSTINF_DBG, "\n\n<< Abort the running Scan >>\n\n");
 			/*Abort the running scan*/
-			del_timer(&pstrWFIDrv->hScanTimer);
-			if (pstrWFIDrv->strWILC_UsrScanReq.pfUserScanResult)
-				Handle_ScanDone(pstrWFIDrv, SCAN_EVENT_ABORTED);
+			del_timer(&hif_drv->hScanTimer);
+			if (hif_drv->strWILC_UsrScanReq.pfUserScanResult)
+				Handle_ScanDone(hif_drv, SCAN_EVENT_ABORTED);
 
 		}
 
@@ -2390,7 +2330,7 @@ static s32 Handle_RcvdGnrlAsyncInfo(struct host_if_drv *drvHandler,
  *  @date
  *  @version	1.0
  */
-static int Handle_Key(struct host_if_drv *drvHandler,
+static int Handle_Key(struct host_if_drv *hif_drv,
 		      struct key_attr *pstrHostIFkeyAttr)
 {
 	s32 s32Error = 0;
@@ -2400,8 +2340,6 @@ static int Handle_Key(struct host_if_drv *drvHandler,
 	u8 *pu8keybuf;
 	s8 s8idxarray[1];
 	s8 ret = 0;
-	struct host_if_drv *pstrWFIDrv = (struct host_if_drv *)drvHandler;
-
 
 	switch (pstrHostIFkeyAttr->enuKeyType) {
 
@@ -2450,7 +2388,7 @@ static int Handle_Key(struct host_if_drv *drvHandler,
 
 
 			s32Error = send_config_pkt(SET_CFG, strWIDList, 4,
-						   get_id_from_handler(pstrWFIDrv));
+						   get_id_from_handler(hif_drv));
 			kfree(pu8keybuf);
 
 
@@ -2478,7 +2416,7 @@ static int Handle_Key(struct host_if_drv *drvHandler,
 			strWID.size = pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFwepAttr.u8WepKeylen + 2;
 
 			s32Error = send_config_pkt(SET_CFG, &strWID, 1,
-						   get_id_from_handler(pstrWFIDrv));
+						   get_id_from_handler(hif_drv));
 			kfree(pu8keybuf);
 		} else if (pstrHostIFkeyAttr->u8KeyAction & REMOVEKEY)	  {
 
@@ -2491,7 +2429,7 @@ static int Handle_Key(struct host_if_drv *drvHandler,
 			strWID.size = 1;
 
 			s32Error = send_config_pkt(SET_CFG, &strWID, 1,
-						   get_id_from_handler(pstrWFIDrv));
+						   get_id_from_handler(hif_drv));
 		} else {
 			strWID.id = (u16)WID_KEY_ID;
 			strWID.type = WID_CHAR;
@@ -2501,9 +2439,9 @@ static int Handle_Key(struct host_if_drv *drvHandler,
 			PRINT_D(HOSTINF_DBG, "Setting default key index\n");
 
 			s32Error = send_config_pkt(SET_CFG, &strWID, 1,
-						   get_id_from_handler(pstrWFIDrv));
+						   get_id_from_handler(hif_drv));
 		}
-		up(&(pstrWFIDrv->hSemTestKeyBlock));
+		up(&hif_drv->hSemTestKeyBlock);
 		break;
 
 	case WPARxGtk:
@@ -2547,12 +2485,12 @@ static int Handle_Key(struct host_if_drv *drvHandler,
 			strWIDList[1].size = RX_MIC_KEY_MSG_LEN;
 
 			s32Error = send_config_pkt(SET_CFG, strWIDList, 2,
-						   get_id_from_handler(pstrWFIDrv));
+						   get_id_from_handler(hif_drv));
 
 			kfree(pu8keybuf);
 
 			/* ////////////////////////// */
-			up(&(pstrWFIDrv->hSemTestKeyBlock));
+			up(&hif_drv->hSemTestKeyBlock);
 			/* ///////////////////////// */
 		}
 
@@ -2574,8 +2512,8 @@ static int Handle_Key(struct host_if_drv *drvHandler,
 			 * |------------|---------|-------|------------|---------------|----------------|
 			 |	6 bytes	 | 8 byte  |1 byte |  1 byte	|   16 bytes	|	  8 bytes	 |*/
 
-			if (pstrWFIDrv->enuHostIFstate == HOST_IF_CONNECTED)
-				memcpy(pu8keybuf, pstrWFIDrv->au8AssociatedBSSID, ETH_ALEN);
+			if (hif_drv->enuHostIFstate == HOST_IF_CONNECTED)
+				memcpy(pu8keybuf, hif_drv->au8AssociatedBSSID, ETH_ALEN);
 			else
 				PRINT_ER("Couldn't handle WPARxGtk while enuHostIFstate is not HOST_IF_CONNECTED\n");
 
@@ -2593,12 +2531,12 @@ static int Handle_Key(struct host_if_drv *drvHandler,
 			strWID.size = RX_MIC_KEY_MSG_LEN;
 
 			s32Error = send_config_pkt(SET_CFG, &strWID, 1,
-						   get_id_from_handler(pstrWFIDrv));
+						   get_id_from_handler(hif_drv));
 
 			kfree(pu8keybuf);
 
 			/* ////////////////////////// */
-			up(&(pstrWFIDrv->hSemTestKeyBlock));
+			up(&hif_drv->hSemTestKeyBlock);
 			/* ///////////////////////// */
 		}
 _WPARxGtk_end_case_:
@@ -2650,11 +2588,11 @@ _WPARxGtk_end_case_:
 			strWIDList[1].size = PTK_KEY_MSG_LEN + 1;
 
 			s32Error = send_config_pkt(SET_CFG, strWIDList, 2,
-						   get_id_from_handler(pstrWFIDrv));
+						   get_id_from_handler(hif_drv));
 			kfree(pu8keybuf);
 
 			/* ////////////////////////// */
-			up(&(pstrWFIDrv->hSemTestKeyBlock));
+			up(&hif_drv->hSemTestKeyBlock);
 			/* ///////////////////////// */
 		}
 		if (pstrHostIFkeyAttr->u8KeyAction & ADDKEY) {
@@ -2691,11 +2629,11 @@ _WPARxGtk_end_case_:
 			strWID.size = PTK_KEY_MSG_LEN;
 
 			s32Error = send_config_pkt(SET_CFG, &strWID, 1,
-						   get_id_from_handler(pstrWFIDrv));
+						   get_id_from_handler(hif_drv));
 			kfree(pu8keybuf);
 
 			/* ////////////////////////// */
-			up(&(pstrWFIDrv->hSemTestKeyBlock));
+			up(&hif_drv->hSemTestKeyBlock);
 			/* ///////////////////////// */
 		}
 
@@ -2731,7 +2669,7 @@ _WPAPtk_end_case_:
 		strWID.size = (pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFpmkidAttr.numpmkid * PMKSA_KEY_LEN) + 1;
 
 		s32Error = send_config_pkt(SET_CFG, &strWID, 1,
-					   get_id_from_handler(pstrWFIDrv));
+					   get_id_from_handler(hif_drv));
 
 		kfree(pu8keybuf);
 		break;
@@ -2754,14 +2692,12 @@ _WPAPtk_end_case_:
  *  @date
  *  @version	1.0
  */
-static void Handle_Disconnect(struct host_if_drv *drvHandler)
+static void Handle_Disconnect(struct host_if_drv *hif_drv)
 {
 	struct wid strWID;
 
 	s32 s32Error = 0;
 	u16 u16DummyReasonCode = 0;
-	struct host_if_drv *pstrWFIDrv = (struct host_if_drv *)drvHandler;
-
 
 	strWID.id = (u16)WID_DISCONNECT;
 	strWID.type = WID_CHAR;
@@ -2773,12 +2709,12 @@ static void Handle_Disconnect(struct host_if_drv *drvHandler)
 	PRINT_D(HOSTINF_DBG, "Sending disconnect request\n");
 
 	g_obtainingIP = false;
-	host_int_set_power_mgmt(pstrWFIDrv, 0, 0);
+	host_int_set_power_mgmt(hif_drv, 0, 0);
 
 	eth_zero_addr(u8ConnectedSSID);
 
 	s32Error = send_config_pkt(SET_CFG, &strWID, 1,
-				   get_id_from_handler(pstrWFIDrv));
+				   get_id_from_handler(hif_drv));
 
 	if (s32Error) {
 		PRINT_ER("Failed to send dissconect config packet\n");
@@ -2791,59 +2727,47 @@ static void Handle_Disconnect(struct host_if_drv *drvHandler)
 		strDisconnectNotifInfo.ie = NULL;
 		strDisconnectNotifInfo.ie_len = 0;
 
-		if (pstrWFIDrv->strWILC_UsrScanReq.pfUserScanResult) {
-			del_timer(&pstrWFIDrv->hScanTimer);
-			pstrWFIDrv->strWILC_UsrScanReq.pfUserScanResult(SCAN_EVENT_ABORTED, NULL,
-									pstrWFIDrv->strWILC_UsrScanReq.u32UserScanPvoid, NULL);
+		if (hif_drv->strWILC_UsrScanReq.pfUserScanResult) {
+			del_timer(&hif_drv->hScanTimer);
+			hif_drv->strWILC_UsrScanReq.pfUserScanResult(SCAN_EVENT_ABORTED, NULL,
+									hif_drv->strWILC_UsrScanReq.u32UserScanPvoid, NULL);
 
-			pstrWFIDrv->strWILC_UsrScanReq.pfUserScanResult = NULL;
+			hif_drv->strWILC_UsrScanReq.pfUserScanResult = NULL;
 		}
 
-		if (pstrWFIDrv->strWILC_UsrConnReq.pfUserConnectResult != NULL)	{
+		if (hif_drv->strWILC_UsrConnReq.pfUserConnectResult != NULL)	{
 
 			/*Stop connect timer, if connection in progress*/
-			if (pstrWFIDrv->enuHostIFstate == HOST_IF_WAITING_CONN_RESP) {
+			if (hif_drv->enuHostIFstate == HOST_IF_WAITING_CONN_RESP) {
 				PRINT_D(HOSTINF_DBG, "Upper layer requested termination of connection\n");
-				del_timer(&pstrWFIDrv->hConnectTimer);
+				del_timer(&hif_drv->hConnectTimer);
 			}
 
-			pstrWFIDrv->strWILC_UsrConnReq.pfUserConnectResult(CONN_DISCONN_EVENT_DISCONN_NOTIF, NULL,
-									   0, &strDisconnectNotifInfo, pstrWFIDrv->strWILC_UsrConnReq.u32UserConnectPvoid);
+			hif_drv->strWILC_UsrConnReq.pfUserConnectResult(CONN_DISCONN_EVENT_DISCONN_NOTIF, NULL,
+									   0, &strDisconnectNotifInfo, hif_drv->strWILC_UsrConnReq.u32UserConnectPvoid);
 		} else {
 			PRINT_ER("strWILC_UsrConnReq.pfUserConnectResult = NULL\n");
 		}
 
 		gbScanWhileConnected = false;
 
-		pstrWFIDrv->enuHostIFstate = HOST_IF_IDLE;
+		hif_drv->enuHostIFstate = HOST_IF_IDLE;
 
-		eth_zero_addr(pstrWFIDrv->au8AssociatedBSSID);
+		eth_zero_addr(hif_drv->au8AssociatedBSSID);
 
 
 		/* Deallocation */
-		pstrWFIDrv->strWILC_UsrConnReq.ssidLen = 0;
-		if (pstrWFIDrv->strWILC_UsrConnReq.pu8ssid != NULL) {
-			kfree(pstrWFIDrv->strWILC_UsrConnReq.pu8ssid);
-			pstrWFIDrv->strWILC_UsrConnReq.pu8ssid = NULL;
-		}
-
-		if (pstrWFIDrv->strWILC_UsrConnReq.pu8bssid != NULL) {
-			kfree(pstrWFIDrv->strWILC_UsrConnReq.pu8bssid);
-			pstrWFIDrv->strWILC_UsrConnReq.pu8bssid = NULL;
-		}
-
-		pstrWFIDrv->strWILC_UsrConnReq.ConnReqIEsLen = 0;
-		if (pstrWFIDrv->strWILC_UsrConnReq.pu8ConnReqIEs != NULL) {
-			kfree(pstrWFIDrv->strWILC_UsrConnReq.pu8ConnReqIEs);
-			pstrWFIDrv->strWILC_UsrConnReq.pu8ConnReqIEs = NULL;
-		}
+		hif_drv->strWILC_UsrConnReq.ssidLen = 0;
+		kfree(hif_drv->strWILC_UsrConnReq.pu8ssid);
+		kfree(hif_drv->strWILC_UsrConnReq.pu8bssid);
+		hif_drv->strWILC_UsrConnReq.ConnReqIEsLen = 0;
+		kfree(hif_drv->strWILC_UsrConnReq.pu8ConnReqIEs);
 
-
-		if (gu8FlushedJoinReq != NULL && gu8FlushedJoinReqDrvHandler == drvHandler) {
+		if (gu8FlushedJoinReq != NULL && gu8FlushedJoinReqDrvHandler == hif_drv) {
 			kfree(gu8FlushedJoinReq);
 			gu8FlushedJoinReq = NULL;
 		}
-		if (gu8FlushedInfoElemAsoc != NULL && gu8FlushedJoinReqDrvHandler == drvHandler) {
+		if (gu8FlushedInfoElemAsoc != NULL && gu8FlushedJoinReqDrvHandler == hif_drv) {
 			kfree(gu8FlushedInfoElemAsoc);
 			gu8FlushedInfoElemAsoc = NULL;
 		}
@@ -2851,22 +2775,19 @@ static void Handle_Disconnect(struct host_if_drv *drvHandler)
 	}
 
 	/* ////////////////////////// */
-	up(&(pstrWFIDrv->hSemTestDisconnectBlock));
+	up(&hif_drv->hSemTestDisconnectBlock);
 	/* ///////////////////////// */
 
 }
 
 
-void resolve_disconnect_aberration(struct host_if_drv *drvHandler)
+void resolve_disconnect_aberration(struct host_if_drv *hif_drv)
 {
-	struct host_if_drv *pstrWFIDrv;
-
-	pstrWFIDrv = (struct host_if_drv *)drvHandler;
-	if (pstrWFIDrv  == NULL)
+	if (!hif_drv)
 		return;
-	if ((pstrWFIDrv->enuHostIFstate == HOST_IF_WAITING_CONN_RESP) || (pstrWFIDrv->enuHostIFstate == HOST_IF_CONNECTING)) {
+	if ((hif_drv->enuHostIFstate == HOST_IF_WAITING_CONN_RESP) || (hif_drv->enuHostIFstate == HOST_IF_CONNECTING)) {
 		PRINT_D(HOSTINF_DBG, "\n\n<< correcting Supplicant state machine >>\n\n");
-		host_int_disconnect(pstrWFIDrv, 1);
+		host_int_disconnect(hif_drv, 1);
 	}
 }
 
@@ -2880,12 +2801,11 @@ void resolve_disconnect_aberration(struct host_if_drv *drvHandler)
  *  @date
  *  @version	1.0
  */
-static s32 Handle_GetChnl(struct host_if_drv *drvHandler)
+static s32 Handle_GetChnl(struct host_if_drv *hif_drv)
 {
 
 	s32 s32Error = 0;
 	struct wid strWID;
-	struct host_if_drv *pstrWFIDrv = (struct host_if_drv *)drvHandler;
 
 	strWID.id = (u16)WID_CURRENT_CHANNEL;
 	strWID.type = WID_CHAR;
@@ -2895,14 +2815,14 @@ static s32 Handle_GetChnl(struct host_if_drv *drvHandler)
 	PRINT_D(HOSTINF_DBG, "Getting channel value\n");
 
 	s32Error = send_config_pkt(GET_CFG, &strWID, 1,
-				   get_id_from_handler(pstrWFIDrv));
+				   get_id_from_handler(hif_drv));
 	/*get the value by searching the local copy*/
 	if (s32Error) {
 		PRINT_ER("Failed to get channel number\n");
 		s32Error = -EFAULT;
 	}
 
-	up(&(pstrWFIDrv->hSemGetCHNL));
+	up(&hif_drv->hSemGetCHNL);
 
 	return s32Error;
 
@@ -2920,11 +2840,10 @@ static s32 Handle_GetChnl(struct host_if_drv *drvHandler)
  *  @date
  *  @version	1.0
  */
-static void Handle_GetRssi(struct host_if_drv *drvHandler)
+static void Handle_GetRssi(struct host_if_drv *hif_drv)
 {
 	s32 s32Error = 0;
 	struct wid strWID;
-	struct host_if_drv *pstrWFIDrv = (struct host_if_drv *)drvHandler;
 
 	strWID.id = (u16)WID_RSSI;
 	strWID.type = WID_CHAR;
@@ -2935,23 +2854,22 @@ static void Handle_GetRssi(struct host_if_drv *drvHandler)
 	PRINT_D(HOSTINF_DBG, "Getting RSSI value\n");
 
 	s32Error = send_config_pkt(GET_CFG, &strWID, 1,
-				   get_id_from_handler(pstrWFIDrv));
+				   get_id_from_handler(hif_drv));
 	if (s32Error) {
 		PRINT_ER("Failed to get RSSI value\n");
 		s32Error = -EFAULT;
 	}
 
-	up(&(pstrWFIDrv->hSemGetRSSI));
+	up(&hif_drv->hSemGetRSSI);
 
 
 }
 
 
-static void Handle_GetLinkspeed(struct host_if_drv *drvHandler)
+static void Handle_GetLinkspeed(struct host_if_drv *hif_drv)
 {
 	s32 s32Error = 0;
 	struct wid strWID;
-	struct host_if_drv *pstrWFIDrv = (struct host_if_drv *)drvHandler;
 
 	gs8lnkspd = 0;
 
@@ -2963,18 +2881,18 @@ static void Handle_GetLinkspeed(struct host_if_drv *drvHandler)
 	PRINT_D(HOSTINF_DBG, "Getting LINKSPEED value\n");
 
 	s32Error = send_config_pkt(GET_CFG, &strWID, 1,
-				   get_id_from_handler(pstrWFIDrv));
+				   get_id_from_handler(hif_drv));
 	if (s32Error) {
 		PRINT_ER("Failed to get LINKSPEED value\n");
 		s32Error = -EFAULT;
 	}
 
-	up(&(pstrWFIDrv->hSemGetLINKSPEED));
+	up(&(hif_drv->hSemGetLINKSPEED));
 
 
 }
 
-s32 Handle_GetStatistics(struct host_if_drv *drvHandler, struct rf_info *pstrStatistics)
+s32 Handle_GetStatistics(struct host_if_drv *hif_drv, struct rf_info *pstrStatistics)
 {
 	struct wid strWIDList[5];
 	u32 u32WidsCount = 0, s32Error = 0;
@@ -3010,7 +2928,7 @@ s32 Handle_GetStatistics(struct host_if_drv *drvHandler, struct rf_info *pstrSta
 	u32WidsCount++;
 
 	s32Error = send_config_pkt(GET_CFG, strWIDList, u32WidsCount,
-				   get_id_from_handler(drvHandler));
+				   get_id_from_handler(hif_drv));
 
 	if (s32Error)
 		PRINT_ER("Failed to send scan paramters config packet\n");
@@ -3031,15 +2949,13 @@ s32 Handle_GetStatistics(struct host_if_drv *drvHandler, struct rf_info *pstrSta
  *  @date
  *  @version	1.0
  */
-static s32 Handle_Get_InActiveTime(struct host_if_drv *drvHandler,
+static s32 Handle_Get_InActiveTime(struct host_if_drv *hif_drv,
 				   struct sta_inactive_t *strHostIfStaInactiveT)
 {
 
 	s32 s32Error = 0;
 	u8 *stamac;
 	struct wid strWID;
-	struct host_if_drv *pstrWFIDrv = (struct host_if_drv *)drvHandler;
-
 
 	strWID.id = (u16)WID_SET_STA_MAC_INACTIVE_TIME;
 	strWID.type = WID_STR;
@@ -3055,7 +2971,7 @@ static s32 Handle_Get_InActiveTime(struct host_if_drv *drvHandler,
 
 
 	s32Error = send_config_pkt(SET_CFG, &strWID, 1,
-				   get_id_from_handler(pstrWFIDrv));
+				   get_id_from_handler(hif_drv));
 	/*get the value by searching the local copy*/
 	if (s32Error) {
 		PRINT_ER("Failed to SET incative time\n");
@@ -3070,7 +2986,7 @@ static s32 Handle_Get_InActiveTime(struct host_if_drv *drvHandler,
 
 
 	s32Error = send_config_pkt(GET_CFG, &strWID, 1,
-				   get_id_from_handler(pstrWFIDrv));
+				   get_id_from_handler(hif_drv));
 	/*get the value by searching the local copy*/
 	if (s32Error) {
 		PRINT_ER("Failed to get incative time\n");
@@ -3080,7 +2996,7 @@ static s32 Handle_Get_InActiveTime(struct host_if_drv *drvHandler,
 
 	PRINT_D(CFG80211_DBG, "Getting inactive time : %d\n", gu32InactiveTime);
 
-	up(&(pstrWFIDrv->hSemInactiveTime));
+	up(&hif_drv->hSemInactiveTime);
 
 	return s32Error;
 
@@ -3098,13 +3014,12 @@ static s32 Handle_Get_InActiveTime(struct host_if_drv *drvHandler,
  *  @date
  *  @version	1.0
  */
-static void Handle_AddBeacon(struct host_if_drv *drvHandler,
+static void Handle_AddBeacon(struct host_if_drv *hif_drv,
 			     struct beacon_attr *pstrSetBeaconParam)
 {
 	s32 s32Error = 0;
 	struct wid strWID;
 	u8 *pu8CurrByte;
-	struct host_if_drv *pstrWFIDrv = (struct host_if_drv *)drvHandler;
 
 	PRINT_D(HOSTINF_DBG, "Adding BEACON\n");
 
@@ -3147,7 +3062,7 @@ static void Handle_AddBeacon(struct host_if_drv *drvHandler,
 
 	/*Sending Cfg*/
 	s32Error = send_config_pkt(SET_CFG, &strWID, 1,
-				   get_id_from_handler(pstrWFIDrv));
+				   get_id_from_handler(hif_drv));
 	if (s32Error)
 		PRINT_ER("Failed to send add beacon config packet\n");
 
@@ -3167,12 +3082,11 @@ ERRORHANDLER:
  *  @date
  *  @version	1.0
  */
-static void Handle_DelBeacon(struct host_if_drv *drvHandler)
+static void Handle_DelBeacon(struct host_if_drv *hif_drv)
 {
 	s32 s32Error = 0;
 	struct wid strWID;
 	u8 *pu8CurrByte;
-	struct host_if_drv *pstrWFIDrv = (struct host_if_drv *)drvHandler;
 
 	strWID.id = (u16)WID_DEL_BEACON;
 	strWID.type = WID_CHAR;
@@ -3189,7 +3103,7 @@ static void Handle_DelBeacon(struct host_if_drv *drvHandler)
 
 	/*Sending Cfg*/
 	s32Error = send_config_pkt(SET_CFG, &strWID, 1,
-				   get_id_from_handler(pstrWFIDrv));
+				   get_id_from_handler(hif_drv));
 	if (s32Error)
 		PRINT_ER("Failed to send delete beacon config packet\n");
 }
@@ -3259,13 +3173,12 @@ static u32 WILC_HostIf_PackStaParam(u8 *pu8Buffer,
  *  @date
  *  @version	1.0
  */
-static void Handle_AddStation(struct host_if_drv *drvHandler,
+static void Handle_AddStation(struct host_if_drv *hif_drv,
 			      struct add_sta_param *pstrStationParam)
 {
 	s32 s32Error = 0;
 	struct wid strWID;
 	u8 *pu8CurrByte;
-	struct host_if_drv *pstrWFIDrv = (struct host_if_drv *)drvHandler;
 
 	PRINT_D(HOSTINF_DBG, "Handling add station\n");
 	strWID.id = (u16)WID_ADD_STA;
@@ -3281,7 +3194,7 @@ static void Handle_AddStation(struct host_if_drv *drvHandler,
 
 	/*Sending Cfg*/
 	s32Error = send_config_pkt(SET_CFG, &strWID, 1,
-				   get_id_from_handler(pstrWFIDrv));
+				   get_id_from_handler(hif_drv));
 	if (s32Error != 0)
 		PRINT_ER("Failed to send add station config packet\n");
 
@@ -3299,14 +3212,13 @@ ERRORHANDLER:
  *  @date
  *  @version	1.0
  */
-static void Handle_DelAllSta(struct host_if_drv *drvHandler,
+static void Handle_DelAllSta(struct host_if_drv *hif_drv,
 			     struct del_all_sta *pstrDelAllStaParam)
 {
 	s32 s32Error = 0;
 
 	struct wid strWID;
 	u8 *pu8CurrByte;
-	struct host_if_drv *pstrWFIDrv = (struct host_if_drv *)drvHandler;
 	u8 i;
 	u8 au8Zero_Buff[6] = {0};
 
@@ -3335,7 +3247,7 @@ static void Handle_DelAllSta(struct host_if_drv *drvHandler,
 
 	/*Sending Cfg*/
 	s32Error = send_config_pkt(SET_CFG, &strWID, 1,
-				   get_id_from_handler(pstrWFIDrv));
+				   get_id_from_handler(hif_drv));
 	if (s32Error)
 		PRINT_ER("Failed to send add station config packet\n");
 
@@ -3355,13 +3267,12 @@ ERRORHANDLER:
  *  @date
  *  @version	1.0
  */
-static void Handle_DelStation(struct host_if_drv *drvHandler,
+static void Handle_DelStation(struct host_if_drv *hif_drv,
 			      struct del_sta *pstrDelStaParam)
 {
 	s32 s32Error = 0;
 	struct wid strWID;
 	u8 *pu8CurrByte;
-	struct host_if_drv *pstrWFIDrv = (struct host_if_drv *)drvHandler;
 
 	strWID.id = (u16)WID_REMOVE_STA;
 	strWID.type = WID_BIN;
@@ -3379,7 +3290,7 @@ static void Handle_DelStation(struct host_if_drv *drvHandler,
 
 	/*Sending Cfg*/
 	s32Error = send_config_pkt(SET_CFG, &strWID, 1,
-				   get_id_from_handler(pstrWFIDrv));
+				   get_id_from_handler(hif_drv));
 	if (s32Error)
 		PRINT_ER("Failed to send add station config packet\n");
 
@@ -3397,13 +3308,12 @@ ERRORHANDLER:
  *  @date
  *  @version	1.0
  */
-static void Handle_EditStation(struct host_if_drv *drvHandler,
+static void Handle_EditStation(struct host_if_drv *hif_drv,
 			       struct add_sta_param *pstrStationParam)
 {
 	s32 s32Error = 0;
 	struct wid strWID;
 	u8 *pu8CurrByte;
-	struct host_if_drv *pstrWFIDrv = (struct host_if_drv *)drvHandler;
 
 	strWID.id = (u16)WID_EDIT_STA;
 	strWID.type = WID_BIN;
@@ -3419,7 +3329,7 @@ static void Handle_EditStation(struct host_if_drv *drvHandler,
 
 	/*Sending Cfg*/
 	s32Error = send_config_pkt(SET_CFG, &strWID, 1,
-				   get_id_from_handler(pstrWFIDrv));
+				   get_id_from_handler(hif_drv));
 	if (s32Error)
 		PRINT_ER("Failed to send edit station config packet\n");
 
@@ -3437,33 +3347,32 @@ ERRORHANDLER:
  *  @date
  *  @version	1.0
  */
-static int Handle_RemainOnChan(struct host_if_drv *drvHandler,
+static int Handle_RemainOnChan(struct host_if_drv *hif_drv,
 			       struct remain_ch *pstrHostIfRemainOnChan)
 {
 	s32 s32Error = 0;
 	u8 u8remain_on_chan_flag;
 	struct wid strWID;
-	struct host_if_drv *pstrWFIDrv = (struct host_if_drv *) drvHandler;
 
 	/*If it's a pendig remain-on-channel, don't overwrite gWFiDrvHandle values (since incoming msg is garbbage)*/
-	if (!pstrWFIDrv->u8RemainOnChan_pendingreq) {
-		pstrWFIDrv->strHostIfRemainOnChan.pVoid = pstrHostIfRemainOnChan->pVoid;
-		pstrWFIDrv->strHostIfRemainOnChan.pRemainOnChanExpired = pstrHostIfRemainOnChan->pRemainOnChanExpired;
-		pstrWFIDrv->strHostIfRemainOnChan.pRemainOnChanReady = pstrHostIfRemainOnChan->pRemainOnChanReady;
-		pstrWFIDrv->strHostIfRemainOnChan.u16Channel = pstrHostIfRemainOnChan->u16Channel;
-		pstrWFIDrv->strHostIfRemainOnChan.u32ListenSessionID = pstrHostIfRemainOnChan->u32ListenSessionID;
+	if (!hif_drv->u8RemainOnChan_pendingreq) {
+		hif_drv->strHostIfRemainOnChan.pVoid = pstrHostIfRemainOnChan->pVoid;
+		hif_drv->strHostIfRemainOnChan.pRemainOnChanExpired = pstrHostIfRemainOnChan->pRemainOnChanExpired;
+		hif_drv->strHostIfRemainOnChan.pRemainOnChanReady = pstrHostIfRemainOnChan->pRemainOnChanReady;
+		hif_drv->strHostIfRemainOnChan.u16Channel = pstrHostIfRemainOnChan->u16Channel;
+		hif_drv->strHostIfRemainOnChan.u32ListenSessionID = pstrHostIfRemainOnChan->u32ListenSessionID;
 	} else {
 		/*Set the channel to use it as a wid val*/
-		pstrHostIfRemainOnChan->u16Channel = pstrWFIDrv->strHostIfRemainOnChan.u16Channel;
+		pstrHostIfRemainOnChan->u16Channel = hif_drv->strHostIfRemainOnChan.u16Channel;
 	}
 
-	if (pstrWFIDrv->strWILC_UsrScanReq.pfUserScanResult != NULL) {
+	if (hif_drv->strWILC_UsrScanReq.pfUserScanResult != NULL) {
 		PRINT_INFO(GENERIC_DBG, "Required to remain on chan while scanning return\n");
-		pstrWFIDrv->u8RemainOnChan_pendingreq = 1;
+		hif_drv->u8RemainOnChan_pendingreq = 1;
 		s32Error = -EBUSY;
 		goto ERRORHANDLER;
 	}
-	if (pstrWFIDrv->enuHostIFstate == HOST_IF_WAITING_CONN_RESP) {
+	if (hif_drv->enuHostIFstate == HOST_IF_WAITING_CONN_RESP) {
 		PRINT_INFO(GENERIC_DBG, "Required to remain on chan while connecting return\n");
 		s32Error = -EBUSY;
 		goto ERRORHANDLER;
@@ -3493,24 +3402,24 @@ static int Handle_RemainOnChan(struct host_if_drv *drvHandler,
 
 	/*Sending Cfg*/
 	s32Error = send_config_pkt(SET_CFG, &strWID, 1,
-				   get_id_from_handler(pstrWFIDrv));
+				   get_id_from_handler(hif_drv));
 	if (s32Error != 0)
 		PRINT_ER("Failed to set remain on channel\n");
 
 ERRORHANDLER:
 	{
 		P2P_LISTEN_STATE = 1;
-		pstrWFIDrv->hRemainOnChannel.data = (unsigned long)pstrWFIDrv;
-		mod_timer(&pstrWFIDrv->hRemainOnChannel,
+		hif_drv->hRemainOnChannel.data = (unsigned long)hif_drv;
+		mod_timer(&hif_drv->hRemainOnChannel,
 			  jiffies +
 			  msecs_to_jiffies(pstrHostIfRemainOnChan->u32duration));
 
 		/*Calling CFG ready_on_channel*/
-		if (pstrWFIDrv->strHostIfRemainOnChan.pRemainOnChanReady)
-			pstrWFIDrv->strHostIfRemainOnChan.pRemainOnChanReady(pstrWFIDrv->strHostIfRemainOnChan.pVoid);
+		if (hif_drv->strHostIfRemainOnChan.pRemainOnChanReady)
+			hif_drv->strHostIfRemainOnChan.pRemainOnChanReady(hif_drv->strHostIfRemainOnChan.pVoid);
 
-		if (pstrWFIDrv->u8RemainOnChan_pendingreq)
-			pstrWFIDrv->u8RemainOnChan_pendingreq = 0;
+		if (hif_drv->u8RemainOnChan_pendingreq)
+			hif_drv->u8RemainOnChan_pendingreq = 0;
 	}
 	return s32Error;
 }
@@ -3524,13 +3433,12 @@ ERRORHANDLER:
  *  @date
  *  @version	1.0
  */
-static int Handle_RegisterFrame(struct host_if_drv *drvHandler,
+static int Handle_RegisterFrame(struct host_if_drv *hif_drv,
 				struct reg_frame *pstrHostIfRegisterFrame)
 {
 	s32 s32Error = 0;
 	struct wid strWID;
 	u8 *pu8CurrByte;
-	struct host_if_drv *pstrWFIDrv = (struct host_if_drv *)drvHandler;
 
 	PRINT_D(HOSTINF_DBG, "Handling frame register Flag : %d FrameType: %d\n", pstrHostIfRegisterFrame->bReg, pstrHostIfRegisterFrame->u16FrameType);
 
@@ -3553,7 +3461,7 @@ static int Handle_RegisterFrame(struct host_if_drv *drvHandler,
 
 	/*Sending Cfg*/
 	s32Error = send_config_pkt(SET_CFG, &strWID, 1,
-				   get_id_from_handler(pstrWFIDrv));
+				   get_id_from_handler(hif_drv));
 	if (s32Error) {
 		PRINT_ER("Failed to frame register config packet\n");
 		s32Error = -EINVAL;
@@ -3573,13 +3481,12 @@ static int Handle_RegisterFrame(struct host_if_drv *drvHandler,
  *  @version		1.0
  */
 #define FALSE_FRMWR_CHANNEL 100
-static u32 Handle_ListenStateExpired(struct host_if_drv *drvHandler,
+static u32 Handle_ListenStateExpired(struct host_if_drv *hif_drv,
 				     struct remain_ch *pstrHostIfRemainOnChan)
 {
 	u8 u8remain_on_chan_flag;
 	struct wid strWID;
 	s32 s32Error = 0;
-	struct host_if_drv *pstrWFIDrv = (struct host_if_drv *) drvHandler;
 
 	PRINT_D(HOSTINF_DBG, "CANCEL REMAIN ON CHAN\n");
 
@@ -3600,14 +3507,14 @@ static u32 Handle_ListenStateExpired(struct host_if_drv *drvHandler,
 
 		/*Sending Cfg*/
 		s32Error = send_config_pkt(SET_CFG, &strWID, 1,
-					   get_id_from_handler(pstrWFIDrv));
+					   get_id_from_handler(hif_drv));
 		if (s32Error != 0) {
 			PRINT_ER("Failed to set remain on channel\n");
 			goto _done_;
 		}
 
-		if (pstrWFIDrv->strHostIfRemainOnChan.pRemainOnChanExpired) {
-			pstrWFIDrv->strHostIfRemainOnChan.pRemainOnChanExpired(pstrWFIDrv->strHostIfRemainOnChan.pVoid
+		if (hif_drv->strHostIfRemainOnChan.pRemainOnChanExpired) {
+			hif_drv->strHostIfRemainOnChan.pRemainOnChanExpired(hif_drv->strHostIfRemainOnChan.pVoid
 									       , pstrHostIfRemainOnChan->u32ListenSessionID);
 		}
 		P2P_LISTEN_STATE = 0;
@@ -3634,15 +3541,15 @@ static void ListenTimerCB(unsigned long arg)
 {
 	s32 s32Error = 0;
 	struct host_if_msg msg;
-	struct host_if_drv *pstrWFIDrv = (struct host_if_drv *)arg;
+	struct host_if_drv *hif_drv = (struct host_if_drv *)arg;
 	/*Stopping remain-on-channel timer*/
-	del_timer(&pstrWFIDrv->hRemainOnChannel);
+	del_timer(&hif_drv->hRemainOnChannel);
 
 	/* prepare the Timer Callback message */
 	memset(&msg, 0, sizeof(struct host_if_msg));
 	msg.id = HOST_IF_MSG_LISTEN_TIMER_FIRED;
-	msg.drv = pstrWFIDrv;
-	msg.body.remain_on_ch.u32ListenSessionID = pstrWFIDrv->strHostIfRemainOnChan.u32ListenSessionID;
+	msg.drv = hif_drv;
+	msg.body.remain_on_ch.u32ListenSessionID = hif_drv->strHostIfRemainOnChan.u32ListenSessionID;
 
 	/* send the message */
 	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
@@ -3659,13 +3566,12 @@ static void ListenTimerCB(unsigned long arg)
  *  @date
  *  @version	1.0
  */
-static void Handle_PowerManagement(struct host_if_drv *drvHandler,
+static void Handle_PowerManagement(struct host_if_drv *hif_drv,
 				   struct power_mgmt_param *strPowerMgmtParam)
 {
 	s32 s32Error = 0;
 	struct wid strWID;
 	s8 s8PowerMode;
-	struct host_if_drv *pstrWFIDrv = (struct host_if_drv *)drvHandler;
 
 	strWID.id = (u16)WID_POWER_MANAGEMENT;
 
@@ -3681,7 +3587,7 @@ static void Handle_PowerManagement(struct host_if_drv *drvHandler,
 
 	/*Sending Cfg*/
 	s32Error = send_config_pkt(SET_CFG, &strWID, 1,
-				   get_id_from_handler(pstrWFIDrv));
+				   get_id_from_handler(hif_drv));
 	if (s32Error)
 		PRINT_ER("Failed to send power management config packet\n");
 }
@@ -3695,7 +3601,7 @@ static void Handle_PowerManagement(struct host_if_drv *drvHandler,
  *  @date
  *  @version	1.0
  */
-static void Handle_SetMulticastFilter(struct host_if_drv *drvHandler,
+static void Handle_SetMulticastFilter(struct host_if_drv *hif_drv,
 				      struct set_multicast *strHostIfSetMulti)
 {
 	s32 s32Error = 0;
@@ -3727,7 +3633,7 @@ static void Handle_SetMulticastFilter(struct host_if_drv *drvHandler,
 
 	/*Sending Cfg*/
 	s32Error = send_config_pkt(SET_CFG, &strWID, 1,
-				   get_id_from_handler(drvHandler));
+				   get_id_from_handler(hif_drv));
 	if (s32Error)
 		PRINT_ER("Failed to send setup multicast config packet\n");
 
@@ -3746,14 +3652,13 @@ ERRORHANDLER:
  *  @date			Feb. 2014
  *  @version		9.0
  */
-static s32 Handle_AddBASession(struct host_if_drv *drvHandler,
+static s32 Handle_AddBASession(struct host_if_drv *hif_drv,
 			       struct ba_session_info *strHostIfBASessionInfo)
 {
 	s32 s32Error = 0;
 	struct wid strWID;
 	int AddbaTimeout = 100;
 	char *ptr = NULL;
-	struct host_if_drv *pstrWFIDrv = (struct host_if_drv *)drvHandler;
 
 	PRINT_D(HOSTINF_DBG, "Opening Block Ack session with\nBSSID = %.2x:%.2x:%.2x\nTID=%d\nBufferSize == %d\nSessionTimeOut = %d\n",
 		strHostIfBASessionInfo->au8Bssid[0],
@@ -3792,7 +3697,7 @@ static s32 Handle_AddBASession(struct host_if_drv *drvHandler,
 	*ptr++ = 0;
 
 	s32Error = send_config_pkt(SET_CFG, &strWID, 1,
-				   get_id_from_handler(pstrWFIDrv));
+				   get_id_from_handler(hif_drv));
 	if (s32Error)
 		PRINT_D(HOSTINF_DBG, "Couldn't open BA Session\n");
 
@@ -3817,7 +3722,7 @@ static s32 Handle_AddBASession(struct host_if_drv *drvHandler,
 	/*Ack-Policy */
 	*ptr++ = 3;
 	s32Error = send_config_pkt(SET_CFG, &strWID, 1,
-				   get_id_from_handler(pstrWFIDrv));
+				   get_id_from_handler(hif_drv));
 
 	if (strWID.val != NULL)
 		kfree(strWID.val);
@@ -3835,13 +3740,12 @@ static s32 Handle_AddBASession(struct host_if_drv *drvHandler,
  *  @date			Feb. 2013
  *  @version		9.0
  */
-static s32 Handle_DelAllRxBASessions(struct host_if_drv *drvHandler,
+static s32 Handle_DelAllRxBASessions(struct host_if_drv *hif_drv,
 				     struct ba_session_info *strHostIfBASessionInfo)
 {
 	s32 s32Error = 0;
 	struct wid strWID;
 	char *ptr = NULL;
-	struct host_if_drv *pstrWFIDrv = (struct host_if_drv *)drvHandler;
 
 	PRINT_D(GENERIC_DBG, "Delete Block Ack session with\nBSSID = %.2x:%.2x:%.2x\nTID=%d\n",
 		strHostIfBASessionInfo->au8Bssid[0],
@@ -3866,7 +3770,7 @@ static s32 Handle_DelAllRxBASessions(struct host_if_drv *drvHandler,
 	*ptr++ = 32; /* Unspecific QOS reason */
 
 	s32Error = send_config_pkt(SET_CFG, &strWID, 1,
-				   get_id_from_handler(pstrWFIDrv));
+				   get_id_from_handler(hif_drv));
 	if (s32Error)
 		PRINT_D(HOSTINF_DBG, "Couldn't delete BA Session\n");
 
@@ -3893,13 +3797,13 @@ static int hostIFthread(void *pvArg)
 {
 	u32 u32Ret;
 	struct host_if_msg msg;
-	struct host_if_drv *pstrWFIDrv;
+	struct host_if_drv *hif_drv;
 
 	memset(&msg, 0, sizeof(struct host_if_msg));
 
 	while (1) {
 		wilc_mq_recv(&gMsgQHostIF, &msg, sizeof(struct host_if_msg), &u32Ret);
-		pstrWFIDrv = (struct host_if_drv *)msg.drv;
+		hif_drv = (struct host_if_drv *)msg.drv;
 		if (msg.id == HOST_IF_MSG_EXIT) {
 			PRINT_D(GENERIC_DBG, "THREAD: Exiting HostIfThread\n");
 			break;
@@ -3914,7 +3818,7 @@ static int hostIFthread(void *pvArg)
 			continue;
 		}
 
-		if (msg.id == HOST_IF_MSG_CONNECT && pstrWFIDrv->strWILC_UsrScanReq.pfUserScanResult != NULL) {
+		if (msg.id == HOST_IF_MSG_CONNECT && hif_drv->strWILC_UsrScanReq.pfUserScanResult != NULL) {
 			PRINT_D(HOSTINF_DBG, "Requeue connect request till scan done received\n");
 			wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
 			usleep_range(2 * 1000, 2 * 1000);
@@ -3964,7 +3868,7 @@ static int hostIFthread(void *pvArg)
 			break;
 
 		case HOST_IF_MSG_RCVD_SCAN_COMPLETE:
-			del_timer(&pstrWFIDrv->hScanTimer);
+			del_timer(&hif_drv->hScanTimer);
 			PRINT_D(HOSTINF_DBG, "scan completed successfully\n");
 
 			/*Allow chip sleep, only if both interfaces are not connected*/
@@ -3973,7 +3877,7 @@ static int hostIFthread(void *pvArg)
 
 			Handle_ScanDone(msg.drv, SCAN_EVENT_DONE);
 
-			if (pstrWFIDrv->u8RemainOnChan_pendingreq)
+			if (hif_drv->u8RemainOnChan_pendingreq)
 				Handle_RemainOnChan(msg.drv, &msg.body.remain_on_ch);
 
 			break;
@@ -4144,7 +4048,7 @@ static void TimerCB_Connect(unsigned long arg)
  *  @version		1.0
  */
 /* Check implementation in core adding 9 bytes to the input! */
-s32 host_int_remove_key(struct host_if_drv *hWFIDrv, const u8 *pu8StaAddress)
+s32 host_int_remove_key(struct host_if_drv *hif_drv, const u8 *pu8StaAddress)
 {
 	struct wid strWID;
 
@@ -4170,12 +4074,12 @@ s32 host_int_remove_key(struct host_if_drv *hWFIDrv, const u8 *pu8StaAddress)
  *  @date		8 March 2012
  *  @version		1.0
  */
-int host_int_remove_wep_key(struct host_if_drv *wfi_drv, u8 index)
+int host_int_remove_wep_key(struct host_if_drv *hif_drv, u8 index)
 {
 	int result = 0;
 	struct host_if_msg msg;
 
-	if (!wfi_drv) {
+	if (!hif_drv) {
 		result = -EFAULT;
 		PRINT_ER("Failed to send setup multicast config packet\n");
 		return result;
@@ -4187,7 +4091,7 @@ int host_int_remove_wep_key(struct host_if_drv *wfi_drv, u8 index)
 	msg.id = HOST_IF_MSG_KEY;
 	msg.body.key_info.enuKeyType = WEP;
 	msg.body.key_info.u8KeyAction = REMOVEKEY;
-	msg.drv = wfi_drv;
+	msg.drv = hif_drv;
 
 	msg.body.key_info.
 	uniHostIFkeyAttr.strHostIFwepAttr.u8Wepidx = index;
@@ -4196,7 +4100,7 @@ int host_int_remove_wep_key(struct host_if_drv *wfi_drv, u8 index)
 	result = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
 	if (result)
 		PRINT_ER("Error in sending message queue : Request to remove WEP key\n");
-	down(&wfi_drv->hSemTestKeyBlock);
+	down(&hif_drv->hSemTestKeyBlock);
 
 	return result;
 }
@@ -4213,14 +4117,13 @@ int host_int_remove_wep_key(struct host_if_drv *wfi_drv, u8 index)
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 host_int_set_WEPDefaultKeyID(struct host_if_drv *hWFIDrv, u8 u8Index)
+s32 host_int_set_WEPDefaultKeyID(struct host_if_drv *hif_drv, u8 u8Index)
 {
 	s32 s32Error = 0;
-	struct host_if_drv *pstrWFIDrv = (struct host_if_drv *)hWFIDrv;
 	struct host_if_msg msg;
 
 
-	if (pstrWFIDrv == NULL) {
+	if (!hif_drv) {
 		s32Error = -EFAULT;
 		PRINT_ER("driver is null\n");
 		return s32Error;
@@ -4233,7 +4136,7 @@ s32 host_int_set_WEPDefaultKeyID(struct host_if_drv *hWFIDrv, u8 u8Index)
 	msg.id = HOST_IF_MSG_KEY;
 	msg.body.key_info.enuKeyType = WEP;
 	msg.body.key_info.u8KeyAction = DEFAULTKEY;
-	msg.drv = hWFIDrv;
+	msg.drv = hif_drv;
 
 
 	msg.body.key_info.
@@ -4243,7 +4146,7 @@ s32 host_int_set_WEPDefaultKeyID(struct host_if_drv *hWFIDrv, u8 u8Index)
 	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
 	if (s32Error)
 		PRINT_ER("Error in sending message queue : Default key index\n");
-	down(&(pstrWFIDrv->hSemTestKeyBlock));
+	down(&hif_drv->hSemTestKeyBlock);
 
 	return s32Error;
 }
@@ -4267,14 +4170,16 @@ s32 host_int_set_WEPDefaultKeyID(struct host_if_drv *hWFIDrv, u8 u8Index)
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 host_int_add_wep_key_bss_sta(struct host_if_drv *hWFIDrv, const u8 *pu8WepKey, u8 u8WepKeylen, u8 u8Keyidx)
+s32 host_int_add_wep_key_bss_sta(struct host_if_drv *hif_drv,
+				 const u8 *pu8WepKey,
+				 u8 u8WepKeylen,
+				 u8 u8Keyidx)
 {
 
 	s32 s32Error = 0;
-	struct host_if_drv *pstrWFIDrv = (struct host_if_drv *)hWFIDrv;
 	struct host_if_msg msg;
 
-	if (pstrWFIDrv == NULL) {
+	if (!hif_drv) {
 		s32Error = -EFAULT;
 		PRINT_ER("driver is null\n");
 		return s32Error;
@@ -4287,7 +4192,7 @@ s32 host_int_add_wep_key_bss_sta(struct host_if_drv *hWFIDrv, const u8 *pu8WepKe
 	msg.id = HOST_IF_MSG_KEY;
 	msg.body.key_info.enuKeyType = WEP;
 	msg.body.key_info.u8KeyAction = ADDKEY;
-	msg.drv = hWFIDrv;
+	msg.drv = hif_drv;
 
 
 	msg.body.key_info.
@@ -4307,7 +4212,7 @@ s32 host_int_add_wep_key_bss_sta(struct host_if_drv *hWFIDrv, const u8 *pu8WepKe
 	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
 	if (s32Error)
 		PRINT_ER("Error in sending message queue :WEP Key\n");
-	down(&(pstrWFIDrv->hSemTestKeyBlock));
+	down(&hif_drv->hSemTestKeyBlock);
 
 	return s32Error;
 
@@ -4329,15 +4234,19 @@ s32 host_int_add_wep_key_bss_sta(struct host_if_drv *hWFIDrv, const u8 *pu8WepKe
  *  @date		28 FEB 2013
  *  @version		1.0
  */
-s32 host_int_add_wep_key_bss_ap(struct host_if_drv *hWFIDrv, const u8 *pu8WepKey, u8 u8WepKeylen, u8 u8Keyidx, u8 u8mode, enum AUTHTYPE tenuAuth_type)
+s32 host_int_add_wep_key_bss_ap(struct host_if_drv *hif_drv,
+				const u8 *pu8WepKey,
+				u8 u8WepKeylen,
+				u8 u8Keyidx,
+				u8 u8mode,
+				enum AUTHTYPE tenuAuth_type)
 {
 
 	s32 s32Error = 0;
-	struct host_if_drv *pstrWFIDrv = (struct host_if_drv *)hWFIDrv;
 	struct host_if_msg msg;
 	u8 i;
 
-	if (pstrWFIDrv == NULL) {
+	if (!hif_drv) {
 		s32Error = -EFAULT;
 		PRINT_ER("driver is null\n");
 		return s32Error;
@@ -4353,7 +4262,7 @@ s32 host_int_add_wep_key_bss_ap(struct host_if_drv *hWFIDrv, const u8 *pu8WepKey
 	msg.id = HOST_IF_MSG_KEY;
 	msg.body.key_info.enuKeyType = WEP;
 	msg.body.key_info.u8KeyAction = ADDKEY_AP;
-	msg.drv = hWFIDrv;
+	msg.drv = hif_drv;
 
 
 	msg.body.key_info.
@@ -4380,7 +4289,7 @@ s32 host_int_add_wep_key_bss_ap(struct host_if_drv *hWFIDrv, const u8 *pu8WepKey
 
 	if (s32Error)
 		PRINT_ER("Error in sending message queue :WEP Key\n");
-	down(&(pstrWFIDrv->hSemTestKeyBlock));
+	down(&hif_drv->hSemTestKeyBlock);
 
 	return s32Error;
 
@@ -4402,16 +4311,17 @@ s32 host_int_add_wep_key_bss_ap(struct host_if_drv *hWFIDrv, const u8 *pu8WepKey
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 host_int_add_ptk(struct host_if_drv *hWFIDrv, const u8 *pu8Ptk, u8 u8PtkKeylen,
-			     const u8 *mac_addr, const u8 *pu8RxMic, const u8 *pu8TxMic, u8 mode, u8 u8Ciphermode, u8 u8Idx)
+s32 host_int_add_ptk(struct host_if_drv *hif_drv, const u8 *pu8Ptk,
+		     u8 u8PtkKeylen, const u8 *mac_addr,
+		     const u8 *pu8RxMic, const u8 *pu8TxMic,
+		     u8 mode, u8 u8Ciphermode, u8 u8Idx)
 {
 	s32 s32Error = 0;
-	struct host_if_drv *pstrWFIDrv = (struct host_if_drv *)hWFIDrv;
 	struct host_if_msg msg;
 	u8 u8KeyLen = u8PtkKeylen;
 	u32 i;
 
-	if (pstrWFIDrv == NULL) {
+	if (!hif_drv) {
 		s32Error = -EFAULT;
 		PRINT_ER("driver is null\n");
 		return s32Error;
@@ -4469,7 +4379,7 @@ s32 host_int_add_ptk(struct host_if_drv *hWFIDrv, const u8 *pu8Ptk, u8 u8PtkKeyl
 	uniHostIFkeyAttr.strHostIFwpaAttr.u8Ciphermode = u8Ciphermode;
 	msg.body.key_info.
 	uniHostIFkeyAttr.strHostIFwpaAttr.pu8macaddr = mac_addr;
-	msg.drv = hWFIDrv;
+	msg.drv = hif_drv;
 
 	/* send the message */
 	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
@@ -4478,7 +4388,7 @@ s32 host_int_add_ptk(struct host_if_drv *hWFIDrv, const u8 *pu8Ptk, u8 u8PtkKeyl
 		PRINT_ER("Error in sending message queue:  PTK Key\n");
 
 	/* ////////////// */
-	down(&(pstrWFIDrv->hSemTestKeyBlock));
+	down(&hif_drv->hSemTestKeyBlock);
 	/* /////// */
 
 	return s32Error;
@@ -4497,16 +4407,17 @@ s32 host_int_add_ptk(struct host_if_drv *hWFIDrv, const u8 *pu8Ptk, u8 u8PtkKeyl
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 host_int_add_rx_gtk(struct host_if_drv *hWFIDrv, const u8 *pu8RxGtk, u8 u8GtkKeylen,
-				u8 u8KeyIdx, u32 u32KeyRSClen, const u8 *KeyRSC,
-				const u8 *pu8RxMic, const u8 *pu8TxMic, u8 mode, u8 u8Ciphermode)
+s32 host_int_add_rx_gtk(struct host_if_drv *hif_drv, const u8 *pu8RxGtk,
+			u8 u8GtkKeylen,	u8 u8KeyIdx,
+			u32 u32KeyRSClen, const u8 *KeyRSC,
+			const u8 *pu8RxMic, const u8 *pu8TxMic,
+			u8 mode, u8 u8Ciphermode)
 {
 	s32 s32Error = 0;
-	struct host_if_drv *pstrWFIDrv = (struct host_if_drv *)hWFIDrv;
 	struct host_if_msg msg;
 	u8 u8KeyLen = u8GtkKeylen;
 
-	if (pstrWFIDrv == NULL) {
+	if (!hif_drv) {
 		s32Error = -EFAULT;
 		PRINT_ER("driver is null\n");
 		return s32Error;
@@ -4530,7 +4441,7 @@ s32 host_int_add_rx_gtk(struct host_if_drv *hWFIDrv, const u8 *pu8RxGtk, u8 u8Gt
 
 	msg.id = HOST_IF_MSG_KEY;
 	msg.body.key_info.enuKeyType = WPARxGtk;
-	msg.drv = hWFIDrv;
+	msg.drv = hif_drv;
 
 	if (mode == AP_MODE) {
 		msg.body.key_info.u8KeyAction = ADDKEY_AP;
@@ -4574,7 +4485,7 @@ s32 host_int_add_rx_gtk(struct host_if_drv *hWFIDrv, const u8 *pu8RxGtk, u8 u8Gt
 	if (s32Error)
 		PRINT_ER("Error in sending message queue:  RX GTK\n");
 	/* ////////////// */
-	down(&(pstrWFIDrv->hSemTestKeyBlock));
+	down(&hif_drv->hSemTestKeyBlock);
 	/* /////// */
 
 	return s32Error;
@@ -4600,15 +4511,14 @@ s32 host_int_add_rx_gtk(struct host_if_drv *hWFIDrv, const u8 *pu8RxGtk, u8 u8Gt
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 host_int_set_pmkid_info(struct host_if_drv *hWFIDrv, struct host_if_pmkid_attr *pu8PmkidInfoArray)
+s32 host_int_set_pmkid_info(struct host_if_drv *hif_drv, struct host_if_pmkid_attr *pu8PmkidInfoArray)
 {
 	s32 s32Error = 0;
-	struct host_if_drv *pstrWFIDrv = (struct host_if_drv *)hWFIDrv;
 	struct host_if_msg msg;
 	u32 i;
 
 
-	if (pstrWFIDrv == NULL) {
+	if (!hif_drv) {
 		s32Error = -EFAULT;
 		PRINT_ER("driver is null\n");
 		return s32Error;
@@ -4620,7 +4530,7 @@ s32 host_int_set_pmkid_info(struct host_if_drv *hWFIDrv, struct host_if_pmkid_at
 	msg.id = HOST_IF_MSG_KEY;
 	msg.body.key_info.enuKeyType = PMKSA;
 	msg.body.key_info.u8KeyAction = ADDKEY;
-	msg.drv = hWFIDrv;
+	msg.drv = hif_drv;
 
 	for (i = 0; i < pu8PmkidInfoArray->numpmkid; i++) {
 
@@ -4660,8 +4570,9 @@ s32 host_int_set_pmkid_info(struct host_if_drv *hWFIDrv, struct host_if_pmkid_at
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 host_int_get_pmkid_info(struct host_if_drv *hWFIDrv, u8 *pu8PmkidInfoArray,
-				    u32 u32PmkidInfoLen)
+s32 host_int_get_pmkid_info(struct host_if_drv *hif_drv,
+			    u8 *pu8PmkidInfoArray,
+			    u32 u32PmkidInfoLen)
 {
 	struct wid strWID;
 
@@ -4687,8 +4598,9 @@ s32 host_int_get_pmkid_info(struct host_if_drv *hWFIDrv, u8 *pu8PmkidInfoArray,
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 host_int_set_RSNAConfigPSKPassPhrase(struct host_if_drv *hWFIDrv, u8 *pu8PassPhrase,
-						 u8 u8Psklength)
+s32 host_int_set_RSNAConfigPSKPassPhrase(struct host_if_drv *hif_drv,
+					 u8 *pu8PassPhrase,
+					 u8 u8Psklength)
 {
 	struct wid strWID;
 
@@ -4713,7 +4625,7 @@ s32 host_int_set_RSNAConfigPSKPassPhrase(struct host_if_drv *hWFIDrv, u8 *pu8Pas
  *  @date		19 April 2012
  *  @version		1.0
  */
-s32 host_int_get_MacAddress(struct host_if_drv *hWFIDrv, u8 *pu8MacAddress)
+s32 host_int_get_MacAddress(struct host_if_drv *hif_drv, u8 *pu8MacAddress)
 {
 	s32 s32Error = 0;
 	struct host_if_msg msg;
@@ -4724,7 +4636,7 @@ s32 host_int_get_MacAddress(struct host_if_drv *hWFIDrv, u8 *pu8MacAddress)
 
 	msg.id = HOST_IF_MSG_GET_MAC_ADDRESS;
 	msg.body.get_mac_info.u8MacAddress = pu8MacAddress;
-	msg.drv = hWFIDrv;
+	msg.drv = hif_drv;
 	/* send the message */
 	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
 	if (s32Error) {
@@ -4747,7 +4659,7 @@ s32 host_int_get_MacAddress(struct host_if_drv *hWFIDrv, u8 *pu8MacAddress)
  *  @date		16 July 2012
  *  @version		1.0
  */
-s32 host_int_set_MacAddress(struct host_if_drv *hWFIDrv, u8 *pu8MacAddress)
+s32 host_int_set_MacAddress(struct host_if_drv *hif_drv, u8 *pu8MacAddress)
 {
 	s32 s32Error = 0;
 	struct host_if_msg msg;
@@ -4758,7 +4670,7 @@ s32 host_int_set_MacAddress(struct host_if_drv *hWFIDrv, u8 *pu8MacAddress)
 	memset(&msg, 0, sizeof(struct host_if_msg));
 	msg.id = HOST_IF_MSG_SET_MAC_ADDRESS;
 	memcpy(msg.body.set_mac_info.u8MacAddress, pu8MacAddress, ETH_ALEN);
-	msg.drv = hWFIDrv;
+	msg.drv = hif_drv;
 
 	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
 	if (s32Error)
@@ -4782,8 +4694,8 @@ s32 host_int_set_MacAddress(struct host_if_drv *hWFIDrv, u8 *pu8MacAddress)
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 host_int_get_RSNAConfigPSKPassPhrase(struct host_if_drv *hWFIDrv,
-						 u8 *pu8PassPhrase, u8 u8Psklength)
+s32 host_int_get_RSNAConfigPSKPassPhrase(struct host_if_drv *hif_drv,
+					 u8 *pu8PassPhrase, u8 u8Psklength)
 {
 	struct wid strWID;
 
@@ -4810,7 +4722,7 @@ s32 host_int_get_RSNAConfigPSKPassPhrase(struct host_if_drv *hWFIDrv,
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 host_int_set_start_scan_req(struct host_if_drv *hWFIDrv, u8 scanSource)
+s32 host_int_set_start_scan_req(struct host_if_drv *hif_drv, u8 scanSource)
 {
 	struct wid strWID;
 
@@ -4838,7 +4750,7 @@ s32 host_int_set_start_scan_req(struct host_if_drv *hWFIDrv, u8 scanSource)
  *  @version		1.0
  */
 
-s32 host_int_get_start_scan_req(struct host_if_drv *hWFIDrv, u8 *pu8ScanSource)
+s32 host_int_get_start_scan_req(struct host_if_drv *hif_drv, u8 *pu8ScanSource)
 {
 	struct wid strWID;
 
@@ -4861,26 +4773,24 @@ s32 host_int_get_start_scan_req(struct host_if_drv *hWFIDrv, u8 *pu8ScanSource)
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 host_int_set_join_req(struct host_if_drv *hWFIDrv, u8 *pu8bssid,
-				  const u8 *pu8ssid, size_t ssidLen,
-				  const u8 *pu8IEs, size_t IEsLen,
-				  wilc_connect_result pfConnectResult, void *pvUserArg,
-				  u8 u8security, enum AUTHTYPE tenuAuth_type,
-				  u8 u8channel,
-				  void *pJoinParams)
+s32 host_int_set_join_req(struct host_if_drv *hif_drv, u8 *pu8bssid,
+			  const u8 *pu8ssid, size_t ssidLen,
+			  const u8 *pu8IEs, size_t IEsLen,
+			  wilc_connect_result pfConnectResult, void *pvUserArg,
+			  u8 u8security, enum AUTHTYPE tenuAuth_type,
+			  u8 u8channel, void *pJoinParams)
 {
 	s32 s32Error = 0;
-	struct host_if_drv *pstrWFIDrv = (struct host_if_drv *)hWFIDrv;
 	struct host_if_msg msg;
 	enum scan_conn_timer enuScanConnTimer;
 
-	if (pstrWFIDrv == NULL || pfConnectResult == NULL) {
+	if (!hif_drv || pfConnectResult == NULL) {
 		s32Error = -EFAULT;
 		PRINT_ER("Driver is null\n");
 		return s32Error;
 	}
 
-	if (hWFIDrv == NULL) {
+	if (!hif_drv) {
 		PRINT_ER("Driver is null\n");
 		return -EFAULT;
 	}
@@ -4901,7 +4811,7 @@ s32 host_int_set_join_req(struct host_if_drv *hWFIDrv, u8 *pu8bssid,
 	msg.body.con_info.pfConnectResult = pfConnectResult;
 	msg.body.con_info.pvUserArg = pvUserArg;
 	msg.body.con_info.pJoinParams = pJoinParams;
-	msg.drv = hWFIDrv;
+	msg.drv = hif_drv ;
 
 	if (pu8bssid != NULL) {
 		msg.body.con_info.pu8bssid = kmalloc(6, GFP_KERNEL); /* will be deallocated by the receiving thread */
@@ -4923,10 +4833,10 @@ s32 host_int_set_join_req(struct host_if_drv *hWFIDrv, u8 *pu8bssid,
 		memcpy(msg.body.con_info.pu8IEs,
 			    pu8IEs, IEsLen);
 	}
-	if (pstrWFIDrv->enuHostIFstate < HOST_IF_CONNECTING)
-		pstrWFIDrv->enuHostIFstate = HOST_IF_CONNECTING;
+	if (hif_drv->enuHostIFstate < HOST_IF_CONNECTING)
+		hif_drv->enuHostIFstate = HOST_IF_CONNECTING;
 	else
-		PRINT_D(GENERIC_DBG, "Don't set state to 'connecting' as state is %d\n", pstrWFIDrv->enuHostIFstate);
+		PRINT_D(GENERIC_DBG, "Don't set state to 'connecting' as state is %d\n", hif_drv->enuHostIFstate);
 
 	/* send the message */
 	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
@@ -4936,8 +4846,8 @@ s32 host_int_set_join_req(struct host_if_drv *hWFIDrv, u8 *pu8bssid,
 	}
 
 	enuScanConnTimer = CONNECT_TIMER;
-	pstrWFIDrv->hConnectTimer.data = (unsigned long)hWFIDrv;
-	mod_timer(&pstrWFIDrv->hConnectTimer,
+	hif_drv->hConnectTimer.data = (unsigned long)hif_drv;
+	mod_timer(&hif_drv->hConnectTimer,
 		  jiffies + msecs_to_jiffies(HOST_IF_CONNECT_TIMEOUT));
 
 	return s32Error;
@@ -4955,7 +4865,7 @@ s32 host_int_set_join_req(struct host_if_drv *hWFIDrv, u8 *pu8bssid,
  *  @version	8.0
  */
 
-s32 host_int_flush_join_req(struct host_if_drv *hWFIDrv)
+s32 host_int_flush_join_req(struct host_if_drv *hif_drv)
 {
 	s32 s32Error = 0;
 	struct host_if_msg msg;
@@ -4966,14 +4876,14 @@ s32 host_int_flush_join_req(struct host_if_drv *hWFIDrv)
 	}
 
 
-	if (hWFIDrv  == NULL) {
+	if (!hif_drv) {
 		s32Error = -EFAULT;
 		PRINT_ER("Driver is null\n");
 		return s32Error;
 	}
 
 	msg.id = HOST_IF_MSG_FLUSH_CONNECT;
-	msg.drv = hWFIDrv;
+	msg.drv = hif_drv;
 
 	/* send the message */
 	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
@@ -4996,13 +4906,12 @@ s32 host_int_flush_join_req(struct host_if_drv *hWFIDrv)
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 host_int_disconnect(struct host_if_drv *hWFIDrv, u16 u16ReasonCode)
+s32 host_int_disconnect(struct host_if_drv *hif_drv, u16 u16ReasonCode)
 {
 	s32 s32Error = 0;
 	struct host_if_msg msg;
-	struct host_if_drv *pstrWFIDrv = (struct host_if_drv *)hWFIDrv;
 
-	if (pstrWFIDrv == NULL) {
+	if (!hif_drv) {
 		PRINT_ER("Driver is null\n");
 		return -EFAULT;
 	}
@@ -5011,14 +4920,14 @@ s32 host_int_disconnect(struct host_if_drv *hWFIDrv, u16 u16ReasonCode)
 	memset(&msg, 0, sizeof(struct host_if_msg));
 
 	msg.id = HOST_IF_MSG_DISCONNECT;
-	msg.drv = hWFIDrv;
+	msg.drv = hif_drv;
 
 	/* send the message */
 	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
 	if (s32Error)
 		PRINT_ER("Failed to send message queue: disconnect\n");
 	/* ////////////// */
-	down(&(pstrWFIDrv->hSemTestDisconnectBlock));
+	down(&hif_drv->hSemTestDisconnectBlock);
 	/* /////// */
 
 	return s32Error;
@@ -5035,7 +4944,7 @@ s32 host_int_disconnect(struct host_if_drv *hWFIDrv, u16 u16ReasonCode)
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 host_int_disconnect_station(struct host_if_drv *hWFIDrv, u8 assoc_id)
+s32 host_int_disconnect_station(struct host_if_drv *hif_drv, u8 assoc_id)
 {
 	struct wid strWID;
 
@@ -5073,7 +4982,7 @@ s32 host_int_disconnect_station(struct host_if_drv *hWFIDrv, u8 assoc_id)
  *  @version		1.0
  */
 
-s32 host_int_get_assoc_req_info(struct host_if_drv *hWFIDrv, u8 *pu8AssocReqInfo,
+s32 host_int_get_assoc_req_info(struct host_if_drv *hif_drv, u8 *pu8AssocReqInfo,
 					u32 u32AssocReqInfoLen)
 {
 	struct wid strWID;
@@ -5097,14 +5006,13 @@ s32 host_int_get_assoc_req_info(struct host_if_drv *hWFIDrv, u8 *pu8AssocReqInfo
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 host_int_get_assoc_res_info(struct host_if_drv *hWFIDrv, u8 *pu8AssocRespInfo,
+s32 host_int_get_assoc_res_info(struct host_if_drv *hif_drv, u8 *pu8AssocRespInfo,
 					u32 u32MaxAssocRespInfoLen, u32 *pu32RcvdAssocRespInfoLen)
 {
 	s32 s32Error = 0;
 	struct wid strWID;
-	struct host_if_drv *pstrWFIDrv = (struct host_if_drv *)hWFIDrv;
 
-	if (pstrWFIDrv == NULL) {
+	if (!hif_drv) {
 		PRINT_ER("Driver is null\n");
 		return -EFAULT;
 	}
@@ -5117,7 +5025,7 @@ s32 host_int_get_assoc_res_info(struct host_if_drv *hWFIDrv, u8 *pu8AssocRespInf
 
 	/* Sending Configuration packet */
 	s32Error = send_config_pkt(GET_CFG, &strWID, 1,
-				   get_id_from_handler(pstrWFIDrv));
+				   get_id_from_handler(hif_drv));
 	if (s32Error) {
 		*pu32RcvdAssocRespInfoLen = 0;
 		PRINT_ER("Failed to send association response config packet\n");
@@ -5144,7 +5052,7 @@ s32 host_int_get_assoc_res_info(struct host_if_drv *hWFIDrv, u8 *pu8AssocRespInf
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 host_int_get_rx_power_level(struct host_if_drv *hWFIDrv, u8 *pu8RxPowerLevel,
+s32 host_int_get_rx_power_level(struct host_if_drv *hif_drv, u8 *pu8RxPowerLevel,
 					u32 u32RxPowerLevelLen)
 {
 	struct wid strWID;
@@ -5172,12 +5080,12 @@ s32 host_int_get_rx_power_level(struct host_if_drv *hWFIDrv, u8 *pu8RxPowerLevel
  *  @date		8 March 2012
  *  @version		1.0
  */
-int host_int_set_mac_chnl_num(struct host_if_drv *wfi_drv, u8 channel)
+int host_int_set_mac_chnl_num(struct host_if_drv *hif_drv, u8 channel)
 {
 	int result;
 	struct host_if_msg msg;
 
-	if (!wfi_drv) {
+	if (!hif_drv) {
 		PRINT_ER("driver is null\n");
 		return -EFAULT;
 	}
@@ -5186,7 +5094,7 @@ int host_int_set_mac_chnl_num(struct host_if_drv *wfi_drv, u8 channel)
 	memset(&msg, 0, sizeof(struct host_if_msg));
 	msg.id = HOST_IF_MSG_SET_CHANNEL;
 	msg.body.channel_info.u8SetChan = channel;
-	msg.drv = wfi_drv;
+	msg.drv = hif_drv;
 
 	result = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
 	if (result) {
@@ -5219,7 +5127,7 @@ int host_int_wait_msg_queue_idle(void)
 	return result;
 }
 
-int host_int_set_wfi_drv_handler(struct host_if_drv *address)
+int host_int_set_wfi_drv_handler(struct host_if_drv *hif_drv)
 {
 	int result = 0;
 
@@ -5229,8 +5137,8 @@ int host_int_set_wfi_drv_handler(struct host_if_drv *address)
 
 	memset(&msg, 0, sizeof(struct host_if_msg));
 	msg.id = HOST_IF_MSG_SET_WFIDRV_HANDLER;
-	msg.body.drv.u32Address = get_id_from_handler(address);
-	msg.drv = address;
+	msg.body.drv.u32Address = get_id_from_handler(hif_drv);
+	msg.drv = hif_drv;
 
 	result = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
 	if (result) {
@@ -5241,7 +5149,7 @@ int host_int_set_wfi_drv_handler(struct host_if_drv *address)
 	return result;
 }
 
-int host_int_set_operation_mode(struct host_if_drv *wfi_drv, u32 mode)
+int host_int_set_operation_mode(struct host_if_drv *hif_drv, u32 mode)
 {
 	int result = 0;
 
@@ -5252,7 +5160,7 @@ int host_int_set_operation_mode(struct host_if_drv *wfi_drv, u32 mode)
 	memset(&msg, 0, sizeof(struct host_if_msg));
 	msg.id = HOST_IF_MSG_SET_OPERATION_MODE;
 	msg.body.mode.u32Mode = mode;
-	msg.drv = wfi_drv;
+	msg.drv = hif_drv;
 
 	result = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
 	if (result) {
@@ -5278,13 +5186,12 @@ int host_int_set_operation_mode(struct host_if_drv *wfi_drv, u32 mode)
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 host_int_get_host_chnl_num(struct host_if_drv *hWFIDrv, u8 *pu8ChNo)
+s32 host_int_get_host_chnl_num(struct host_if_drv *hif_drv, u8 *pu8ChNo)
 {
 	s32 s32Error = 0;
-	struct host_if_drv *pstrWFIDrv = (struct host_if_drv *)hWFIDrv;
 	struct host_if_msg msg;
 
-	if (pstrWFIDrv == NULL) {
+	if (!hif_drv) {
 		PRINT_ER("driver is null\n");
 		return -EFAULT;
 	}
@@ -5293,13 +5200,13 @@ s32 host_int_get_host_chnl_num(struct host_if_drv *hWFIDrv, u8 *pu8ChNo)
 	memset(&msg, 0, sizeof(struct host_if_msg));
 
 	msg.id = HOST_IF_MSG_GET_CHNL;
-	msg.drv = hWFIDrv;
+	msg.drv = hif_drv;
 
 	/* send the message */
 	s32Error =	wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
 	if (s32Error)
 		PRINT_ER("wilc mq send fail\n");
-	down(&(pstrWFIDrv->hSemGetCHNL));
+	down(&hif_drv->hSemGetCHNL);
 	/* gu8Chnl = 11; */
 
 	*pu8ChNo = gu8Chnl;
@@ -5320,13 +5227,13 @@ s32 host_int_get_host_chnl_num(struct host_if_drv *hWFIDrv, u8 *pu8ChNo)
  *  @date
  *  @version		1.0
  */
-s32 host_int_get_inactive_time(struct host_if_drv *hWFIDrv, const u8 *mac, u32 *pu32InactiveTime)
+s32 host_int_get_inactive_time(struct host_if_drv *hif_drv,
+			       const u8 *mac, u32 *pu32InactiveTime)
 {
 	s32 s32Error = 0;
-	struct host_if_drv *pstrWFIDrv = (struct host_if_drv *)hWFIDrv;
 	struct host_if_msg msg;
 
-	if (pstrWFIDrv == NULL) {
+	if (!hif_drv) {
 		PRINT_ER("driver is null\n");
 		return -EFAULT;
 	}
@@ -5338,14 +5245,14 @@ s32 host_int_get_inactive_time(struct host_if_drv *hWFIDrv, const u8 *mac, u32 *
 		    mac, ETH_ALEN);
 
 	msg.id = HOST_IF_MSG_GET_INACTIVETIME;
-	msg.drv = hWFIDrv;
+	msg.drv = hif_drv;
 
 	/* send the message */
 	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
 	if (s32Error)
 		PRINT_ER("Failed to send get host channel param's message queue ");
 
-	down(&(pstrWFIDrv->hSemInactiveTime));
+	down(&hif_drv->hSemInactiveTime);
 
 	*pu32InactiveTime = gu32InactiveTime;
 
@@ -5362,15 +5269,13 @@ s32 host_int_get_inactive_time(struct host_if_drv *hWFIDrv, const u8 *mac, u32 *
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 host_int_test_get_int_wid(struct host_if_drv *hWFIDrv, u32 *pu32TestMemAddr)
+s32 host_int_test_get_int_wid(struct host_if_drv *hif_drv, u32 *pu32TestMemAddr)
 {
 
 	s32 s32Error = 0;
 	struct wid strWID;
-	struct host_if_drv *pstrWFIDrv = (struct host_if_drv *)hWFIDrv;
 
-
-	if (pstrWFIDrv == NULL) {
+	if (!hif_drv) {
 		PRINT_ER("driver is null\n");
 		return -EFAULT;
 	}
@@ -5381,7 +5286,7 @@ s32 host_int_test_get_int_wid(struct host_if_drv *hWFIDrv, u32 *pu32TestMemAddr)
 	strWID.size = sizeof(u32);
 
 	s32Error = send_config_pkt(GET_CFG, &strWID, 1,
-				   get_id_from_handler(pstrWFIDrv));
+				   get_id_from_handler(hif_drv));
 	/*get the value by searching the local copy*/
 	if (s32Error) {
 		PRINT_ER("Failed to get wid value\n");
@@ -5408,18 +5313,16 @@ s32 host_int_test_get_int_wid(struct host_if_drv *hWFIDrv, u32 *pu32TestMemAddr)
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 host_int_get_rssi(struct host_if_drv *hWFIDrv, s8 *ps8Rssi)
+s32 host_int_get_rssi(struct host_if_drv *hif_drv, s8 *ps8Rssi)
 {
 	s32 s32Error = 0;
 	struct host_if_msg msg;
-	struct host_if_drv *pstrWFIDrv = (struct host_if_drv *)hWFIDrv;
-
 
 	/* prepare the Get RSSI Message */
 	memset(&msg, 0, sizeof(struct host_if_msg));
 
 	msg.id = HOST_IF_MSG_GET_RSSI;
-	msg.drv = hWFIDrv;
+	msg.drv = hif_drv;
 
 	/* send the message */
 	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
@@ -5428,7 +5331,7 @@ s32 host_int_get_rssi(struct host_if_drv *hWFIDrv, s8 *ps8Rssi)
 		return -EFAULT;
 	}
 
-	down(&(pstrWFIDrv->hSemGetRSSI));
+	down(&hif_drv->hSemGetRSSI);
 
 
 	if (ps8Rssi == NULL) {
@@ -5443,20 +5346,16 @@ s32 host_int_get_rssi(struct host_if_drv *hWFIDrv, s8 *ps8Rssi)
 	return s32Error;
 }
 
-s32 host_int_get_link_speed(struct host_if_drv *hWFIDrv, s8 *ps8lnkspd)
+s32 host_int_get_link_speed(struct host_if_drv *hif_drv, s8 *ps8lnkspd)
 {
 	struct host_if_msg msg;
 	s32 s32Error = 0;
 
-	struct host_if_drv *pstrWFIDrv = (struct host_if_drv *)hWFIDrv;
-
-
-
 	/* prepare the Get LINKSPEED Message */
 	memset(&msg, 0, sizeof(struct host_if_msg));
 
 	msg.id = HOST_IF_MSG_GET_LINKSPEED;
-	msg.drv = hWFIDrv;
+	msg.drv = hif_drv;
 
 	/* send the message */
 	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
@@ -5465,7 +5364,7 @@ s32 host_int_get_link_speed(struct host_if_drv *hWFIDrv, s8 *ps8lnkspd)
 		return -EFAULT;
 	}
 
-	down(&(pstrWFIDrv->hSemGetLINKSPEED));
+	down(&hif_drv->hSemGetLINKSPEED);
 
 
 	if (ps8lnkspd == NULL) {
@@ -5480,7 +5379,7 @@ s32 host_int_get_link_speed(struct host_if_drv *hWFIDrv, s8 *ps8lnkspd)
 	return s32Error;
 }
 
-s32 host_int_get_statistics(struct host_if_drv *hWFIDrv, struct rf_info *pstrStatistics)
+s32 host_int_get_statistics(struct host_if_drv *hif_drv, struct rf_info *pstrStatistics)
 {
 	s32 s32Error = 0;
 	struct host_if_msg msg;
@@ -5491,7 +5390,7 @@ s32 host_int_get_statistics(struct host_if_drv *hWFIDrv, struct rf_info *pstrSta
 
 	msg.id = HOST_IF_MSG_GET_STATISTICS;
 	msg.body.data = (char *)pstrStatistics;
-	msg.drv = hWFIDrv;
+	msg.drv = hif_drv;
 	/* send the message */
 	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
 	if (s32Error) {
@@ -5520,20 +5419,18 @@ s32 host_int_get_statistics(struct host_if_drv *hWFIDrv, struct rf_info *pstrSta
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 host_int_scan(struct host_if_drv *hWFIDrv, u8 u8ScanSource,
-			  u8 u8ScanType, u8 *pu8ChnlFreqList,
-			  u8 u8ChnlListLen, const u8 *pu8IEs,
-			  size_t IEsLen, wilc_scan_result ScanResult,
-			  void *pvUserArg,
-			  struct hidden_network *pstrHiddenNetwork)
+s32 host_int_scan(struct host_if_drv *hif_drv, u8 u8ScanSource,
+		  u8 u8ScanType, u8 *pu8ChnlFreqList,
+		  u8 u8ChnlListLen, const u8 *pu8IEs,
+		  size_t IEsLen, wilc_scan_result ScanResult,
+		  void *pvUserArg, struct hidden_network *pstrHiddenNetwork)
 {
 	s32 s32Error = 0;
-	struct host_if_drv *pstrWFIDrv = (struct host_if_drv *)hWFIDrv;
 	struct host_if_msg msg;
 	enum scan_conn_timer enuScanConnTimer;
 
-	if (pstrWFIDrv == NULL || ScanResult == NULL) {
-		PRINT_ER("pstrWFIDrv or ScanResult = NULL\n");
+	if (!hif_drv || ScanResult == NULL) {
+		PRINT_ER("hif_drv or ScanResult = NULL\n");
 		return -EFAULT;
 	}
 
@@ -5549,7 +5446,7 @@ s32 host_int_scan(struct host_if_drv *hWFIDrv, u8 u8ScanSource,
 	} else
 		PRINT_D(HOSTINF_DBG, "pstrHiddenNetwork IS EQUAL TO NULL\n");
 
-	msg.drv = hWFIDrv;
+	msg.drv = hif_drv;
 	msg.body.scan_info.u8ScanSource = u8ScanSource;
 	msg.body.scan_info.u8ScanType = u8ScanType;
 	msg.body.scan_info.pfScanResult = ScanResult;
@@ -5574,8 +5471,8 @@ s32 host_int_scan(struct host_if_drv *hWFIDrv, u8 u8ScanSource,
 
 	enuScanConnTimer = SCAN_TIMER;
 	PRINT_D(HOSTINF_DBG, ">> Starting the SCAN timer\n");
-	pstrWFIDrv->hScanTimer.data = (unsigned long)hWFIDrv;
-	mod_timer(&pstrWFIDrv->hScanTimer,
+	hif_drv->hScanTimer.data = (unsigned long)hif_drv;
+	mod_timer(&hif_drv->hScanTimer,
 		  jiffies + msecs_to_jiffies(HOST_IF_SCAN_TIMEOUT));
 
 	return s32Error;
@@ -5592,24 +5489,23 @@ s32 host_int_scan(struct host_if_drv *hWFIDrv, u8 u8ScanSource,
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 hif_set_cfg(struct host_if_drv *hWFIDrv, struct cfg_param_val *pstrCfgParamVal)
+s32 hif_set_cfg(struct host_if_drv *hif_drv,
+		struct cfg_param_val *pstrCfgParamVal)
 {
 
 	s32 s32Error = 0;
-	struct host_if_drv *pstrWFIDrv = (struct host_if_drv *)hWFIDrv;
-
 	struct host_if_msg msg;
 
 
-	if (pstrWFIDrv == NULL) {
-		PRINT_ER("pstrWFIDrv NULL\n");
+	if (!hif_drv) {
+		PRINT_ER("hif_drv NULL\n");
 		return -EFAULT;
 	}
 	/* prepare the WiphyParams Message */
 	memset(&msg, 0, sizeof(struct host_if_msg));
 	msg.id = HOST_IF_MSG_CFG_PARAMS;
 	msg.body.cfg_info.pstrCfgParamVal = *pstrCfgParamVal;
-	msg.drv = hWFIDrv;
+	msg.drv = hif_drv;
 
 	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
 
@@ -5631,97 +5527,96 @@ s32 hif_set_cfg(struct host_if_drv *hWFIDrv, struct cfg_param_val *pstrCfgParamV
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 hif_get_cfg(struct host_if_drv *hWFIDrv, u16 u16WID, u16 *pu16WID_Value)
+s32 hif_get_cfg(struct host_if_drv *hif_drv, u16 u16WID, u16 *pu16WID_Value)
 {
 	s32 s32Error = 0;
-	struct host_if_drv *pstrWFIDrv = (struct host_if_drv *)hWFIDrv;
 
-	down(&(pstrWFIDrv->gtOsCfgValuesSem));
+	down(&hif_drv->gtOsCfgValuesSem);
 
-	if (pstrWFIDrv == NULL) {
-		PRINT_ER("pstrWFIDrv NULL\n");
+	if (!hif_drv) {
+		PRINT_ER("hif_drv NULL\n");
 		return -EFAULT;
 	}
 	PRINT_D(HOSTINF_DBG, "Getting configuration parameters\n");
 	switch (u16WID)	{
 
 	case WID_BSS_TYPE:
-		*pu16WID_Value = (u16)pstrWFIDrv->strCfgValues.bss_type;
+		*pu16WID_Value = (u16)hif_drv->strCfgValues.bss_type;
 		break;
 
 	case WID_AUTH_TYPE:
-		*pu16WID_Value = (u16)pstrWFIDrv->strCfgValues.auth_type;
+		*pu16WID_Value = (u16)hif_drv->strCfgValues.auth_type;
 		break;
 
 	case WID_AUTH_TIMEOUT:
-		*pu16WID_Value = pstrWFIDrv->strCfgValues.auth_timeout;
+		*pu16WID_Value = hif_drv->strCfgValues.auth_timeout;
 		break;
 
 	case WID_POWER_MANAGEMENT:
-		*pu16WID_Value = (u16)pstrWFIDrv->strCfgValues.power_mgmt_mode;
+		*pu16WID_Value = (u16)hif_drv->strCfgValues.power_mgmt_mode;
 		break;
 
 	case WID_SHORT_RETRY_LIMIT:
-		*pu16WID_Value =       pstrWFIDrv->strCfgValues.short_retry_limit;
+		*pu16WID_Value =       hif_drv->strCfgValues.short_retry_limit;
 		break;
 
 	case WID_LONG_RETRY_LIMIT:
-		*pu16WID_Value = pstrWFIDrv->strCfgValues.long_retry_limit;
+		*pu16WID_Value = hif_drv->strCfgValues.long_retry_limit;
 		break;
 
 	case WID_FRAG_THRESHOLD:
-		*pu16WID_Value = pstrWFIDrv->strCfgValues.frag_threshold;
+		*pu16WID_Value = hif_drv->strCfgValues.frag_threshold;
 		break;
 
 	case WID_RTS_THRESHOLD:
-		*pu16WID_Value = pstrWFIDrv->strCfgValues.rts_threshold;
+		*pu16WID_Value = hif_drv->strCfgValues.rts_threshold;
 		break;
 
 	case WID_PREAMBLE:
-		*pu16WID_Value = (u16)pstrWFIDrv->strCfgValues.preamble_type;
+		*pu16WID_Value = (u16)hif_drv->strCfgValues.preamble_type;
 		break;
 
 	case WID_SHORT_SLOT_ALLOWED:
-		*pu16WID_Value = (u16) pstrWFIDrv->strCfgValues.short_slot_allowed;
+		*pu16WID_Value = (u16) hif_drv->strCfgValues.short_slot_allowed;
 		break;
 
 	case WID_11N_TXOP_PROT_DISABLE:
-		*pu16WID_Value = (u16)pstrWFIDrv->strCfgValues.txop_prot_disabled;
+		*pu16WID_Value = (u16)hif_drv->strCfgValues.txop_prot_disabled;
 		break;
 
 	case WID_BEACON_INTERVAL:
-		*pu16WID_Value = pstrWFIDrv->strCfgValues.beacon_interval;
+		*pu16WID_Value = hif_drv->strCfgValues.beacon_interval;
 		break;
 
 	case WID_DTIM_PERIOD:
-		*pu16WID_Value = (u16)pstrWFIDrv->strCfgValues.dtim_period;
+		*pu16WID_Value = (u16)hif_drv->strCfgValues.dtim_period;
 		break;
 
 	case WID_SITE_SURVEY:
-		*pu16WID_Value = (u16)pstrWFIDrv->strCfgValues.site_survey_enabled;
+		*pu16WID_Value = (u16)hif_drv->strCfgValues.site_survey_enabled;
 		break;
 
 	case WID_SITE_SURVEY_SCAN_TIME:
-		*pu16WID_Value = pstrWFIDrv->strCfgValues.site_survey_scan_time;
+		*pu16WID_Value = hif_drv->strCfgValues.site_survey_scan_time;
 		break;
 
 	case WID_ACTIVE_SCAN_TIME:
-		*pu16WID_Value = pstrWFIDrv->strCfgValues.active_scan_time;
+		*pu16WID_Value = hif_drv->strCfgValues.active_scan_time;
 		break;
 
 	case WID_PASSIVE_SCAN_TIME:
-		*pu16WID_Value = pstrWFIDrv->strCfgValues.passive_scan_time;
+		*pu16WID_Value = hif_drv->strCfgValues.passive_scan_time;
 		break;
 
 	case WID_CURRENT_TX_RATE:
-		*pu16WID_Value = pstrWFIDrv->strCfgValues.curr_tx_rate;
+		*pu16WID_Value = hif_drv->strCfgValues.curr_tx_rate;
 		break;
 
 	default:
 		break;
 	}
 
-	up(&(pstrWFIDrv->gtOsCfgValuesSem));
+	up(&hif_drv->gtOsCfgValuesSem);
 
 	return s32Error;
 
@@ -5765,14 +5660,14 @@ void host_int_send_join_leave_info_to_host
 
 static void GetPeriodicRSSI(unsigned long arg)
 {
-	struct host_if_drv *pstrWFIDrv = (struct host_if_drv *)arg;
+	struct host_if_drv *hif_drv = (struct host_if_drv *)arg;
 
-	if (pstrWFIDrv == NULL)	{
+	if (!hif_drv)	{
 		PRINT_ER("Driver handler is NULL\n");
 		return;
 	}
 
-	if (pstrWFIDrv->enuHostIFstate == HOST_IF_CONNECTED) {
+	if (hif_drv->enuHostIFstate == HOST_IF_CONNECTED) {
 		s32 s32Error = 0;
 		struct host_if_msg msg;
 
@@ -5780,7 +5675,7 @@ static void GetPeriodicRSSI(unsigned long arg)
 		memset(&msg, 0, sizeof(struct host_if_msg));
 
 		msg.id = HOST_IF_MSG_GET_RSSI;
-		msg.drv = pstrWFIDrv;
+		msg.drv = hif_drv;
 
 		/* send the message */
 		s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
@@ -5789,7 +5684,7 @@ static void GetPeriodicRSSI(unsigned long arg)
 			return;
 		}
 	}
-	g_hPeriodicRSSI.data = (unsigned long)pstrWFIDrv;
+	g_hPeriodicRSSI.data = (unsigned long)hif_drv;
 	mod_timer(&g_hPeriodicRSSI, jiffies + msecs_to_jiffies(5000));
 }
 
@@ -5809,10 +5704,10 @@ void host_int_send_network_info_to_host
  */
 static u32 clients_count;
 
-s32 host_int_init(struct host_if_drv **phWFIDrv)
+s32 host_int_init(struct host_if_drv **hif_drv_handler)
 {
 	s32 result = 0;
-	struct host_if_drv *pstrWFIDrv;
+	struct host_if_drv *hif_drv;
 	int err;
 
 	PRINT_D(HOSTINF_DBG, "Initializing host interface for client %d\n", clients_count + 1);
@@ -5822,13 +5717,13 @@ s32 host_int_init(struct host_if_drv **phWFIDrv)
 	sema_init(&hWaitResponse, 0);
 
 	/*Allocate host interface private structure*/
-	pstrWFIDrv  = kzalloc(sizeof(struct host_if_drv), GFP_KERNEL);
-	if (!pstrWFIDrv) {
+	hif_drv  = kzalloc(sizeof(struct host_if_drv), GFP_KERNEL);
+	if (!hif_drv) {
 		result = -ENOMEM;
 		goto _fail_;
 	}
-	*phWFIDrv = pstrWFIDrv;
-	err = add_handler_in_list(pstrWFIDrv);
+	*hif_drv_handler = hif_drv;
+	err = add_handler_in_list(hif_drv);
 	if (err) {
 		result = -EFAULT;
 		goto _fail_timer_2;
@@ -5836,19 +5731,19 @@ s32 host_int_init(struct host_if_drv **phWFIDrv)
 
 	g_obtainingIP = false;
 
-	PRINT_D(HOSTINF_DBG, "Global handle pointer value=%p\n", pstrWFIDrv);
+	PRINT_D(HOSTINF_DBG, "Global handle pointer value=%p\n", hif_drv);
 	if (clients_count == 0)	{
 		sema_init(&hSemHostIFthrdEnd, 0);
 		sema_init(&hSemDeinitDrvHandle, 0);
 		sema_init(&hSemHostIntDeinit, 1);
 	}
 
-	sema_init(&pstrWFIDrv->hSemTestKeyBlock, 0);
-	sema_init(&pstrWFIDrv->hSemTestDisconnectBlock, 0);
-	sema_init(&pstrWFIDrv->hSemGetRSSI, 0);
-	sema_init(&pstrWFIDrv->hSemGetLINKSPEED, 0);
-	sema_init(&pstrWFIDrv->hSemGetCHNL, 0);
-	sema_init(&pstrWFIDrv->hSemInactiveTime, 0);
+	sema_init(&hif_drv->hSemTestKeyBlock, 0);
+	sema_init(&hif_drv->hSemTestDisconnectBlock, 0);
+	sema_init(&hif_drv->hSemGetRSSI, 0);
+	sema_init(&hif_drv->hSemGetLINKSPEED, 0);
+	sema_init(&hif_drv->hSemGetCHNL, 0);
+	sema_init(&hif_drv->hSemInactiveTime, 0);
 
 	PRINT_D(HOSTINF_DBG, "INIT: CLIENT COUNT %d\n", clients_count);
 
@@ -5866,48 +5761,48 @@ s32 host_int_init(struct host_if_drv **phWFIDrv)
 			goto _fail_mq_;
 		}
 		setup_timer(&g_hPeriodicRSSI, GetPeriodicRSSI,
-			    (unsigned long)pstrWFIDrv);
+			    (unsigned long)hif_drv);
 		mod_timer(&g_hPeriodicRSSI, jiffies + msecs_to_jiffies(5000));
 	}
 
-	setup_timer(&pstrWFIDrv->hScanTimer, TimerCB_Scan, 0);
+	setup_timer(&hif_drv->hScanTimer, TimerCB_Scan, 0);
 
-	setup_timer(&pstrWFIDrv->hConnectTimer, TimerCB_Connect, 0);
+	setup_timer(&hif_drv->hConnectTimer, TimerCB_Connect, 0);
 
 	/*Remain on channel timer*/
-	setup_timer(&pstrWFIDrv->hRemainOnChannel, ListenTimerCB, 0);
+	setup_timer(&hif_drv->hRemainOnChannel, ListenTimerCB, 0);
 
-	sema_init(&(pstrWFIDrv->gtOsCfgValuesSem), 1);
-	down(&pstrWFIDrv->gtOsCfgValuesSem);
+	sema_init(&(hif_drv->gtOsCfgValuesSem), 1);
+	down(&hif_drv->gtOsCfgValuesSem);
 
-	pstrWFIDrv->enuHostIFstate = HOST_IF_IDLE;
+	hif_drv->enuHostIFstate = HOST_IF_IDLE;
 
 	/*Initialize CFG WIDS Defualt Values*/
 
-	pstrWFIDrv->strCfgValues.site_survey_enabled = SITE_SURVEY_OFF;
-	pstrWFIDrv->strCfgValues.scan_source = DEFAULT_SCAN;
-	pstrWFIDrv->strCfgValues.active_scan_time = ACTIVE_SCAN_TIME;
-	pstrWFIDrv->strCfgValues.passive_scan_time = PASSIVE_SCAN_TIME;
-	pstrWFIDrv->strCfgValues.curr_tx_rate = AUTORATE;
+	hif_drv->strCfgValues.site_survey_enabled = SITE_SURVEY_OFF;
+	hif_drv->strCfgValues.scan_source = DEFAULT_SCAN;
+	hif_drv->strCfgValues.active_scan_time = ACTIVE_SCAN_TIME;
+	hif_drv->strCfgValues.passive_scan_time = PASSIVE_SCAN_TIME;
+	hif_drv->strCfgValues.curr_tx_rate = AUTORATE;
 
-	pstrWFIDrv->u64P2p_MgmtTimeout = 0;
+	hif_drv->u64P2p_MgmtTimeout = 0;
 
 	PRINT_INFO(HOSTINF_DBG, "Initialization values, Site survey value: %d\n Scan source: %d\n Active scan time: %d\n Passive scan time: %d\nCurrent tx Rate = %d\n",
 
-		   pstrWFIDrv->strCfgValues.site_survey_enabled, pstrWFIDrv->strCfgValues.scan_source,
-		   pstrWFIDrv->strCfgValues.active_scan_time, pstrWFIDrv->strCfgValues.passive_scan_time,
-		   pstrWFIDrv->strCfgValues.curr_tx_rate);
+		   hif_drv->strCfgValues.site_survey_enabled, hif_drv->strCfgValues.scan_source,
+		   hif_drv->strCfgValues.active_scan_time, hif_drv->strCfgValues.passive_scan_time,
+		   hif_drv->strCfgValues.curr_tx_rate);
 
-	up(&pstrWFIDrv->gtOsCfgValuesSem);
+	up(&hif_drv->gtOsCfgValuesSem);
 
 	clients_count++; /* increase number of created entities */
 
 	return result;
 
 _fail_timer_2:
-	up(&pstrWFIDrv->gtOsCfgValuesSem);
-	del_timer_sync(&pstrWFIDrv->hConnectTimer);
-	del_timer_sync(&pstrWFIDrv->hScanTimer);
+	up(&hif_drv->gtOsCfgValuesSem);
+	del_timer_sync(&hif_drv->hConnectTimer);
+	del_timer_sync(&hif_drv->hScanTimer);
 	kthread_stop(HostIFthreadHandler);
 _fail_mq_:
 	wilc_mq_destroy(&gMsgQHostIF);
@@ -5924,33 +5819,32 @@ _fail_:
  *  @version		1.0
  */
 
-s32 host_int_deinit(struct host_if_drv *hWFIDrv)
+s32 host_int_deinit(struct host_if_drv *hif_drv)
 {
 	s32 s32Error = 0;
 	struct host_if_msg msg;
 	int ret;
 
 	/*obtain driver handle*/
-	struct host_if_drv *pstrWFIDrv = (struct host_if_drv *)hWFIDrv;
 
-	if (pstrWFIDrv == NULL)	{
-		PRINT_ER("pstrWFIDrv = NULL\n");
+	if (!hif_drv)	{
+		PRINT_ER("hif_drv = NULL\n");
 		return 0;
 	}
 
 	down(&hSemHostIntDeinit);
 
-	terminated_handle = pstrWFIDrv;
+	terminated_handle = hif_drv;
 	PRINT_D(HOSTINF_DBG, "De-initializing host interface for client %d\n", clients_count);
 
 	/*Destroy all timers before acquiring hSemDeinitDrvHandle*/
 	/*to guarantee handling all messages befor proceeding*/
-	if (del_timer_sync(&pstrWFIDrv->hScanTimer)) {
+	if (del_timer_sync(&hif_drv->hScanTimer)) {
 		PRINT_D(HOSTINF_DBG, ">> Scan timer is active\n");
 		/* msleep(HOST_IF_SCAN_TIMEOUT+1000); */
 	}
 
-	if (del_timer_sync(&pstrWFIDrv->hConnectTimer)) {
+	if (del_timer_sync(&hif_drv->hConnectTimer)) {
 		PRINT_D(HOSTINF_DBG, ">> Connect timer is active\n");
 		/* msleep(HOST_IF_CONNECT_TIMEOUT+1000); */
 	}
@@ -5962,21 +5856,21 @@ s32 host_int_deinit(struct host_if_drv *hWFIDrv)
 	}
 
 	/*Destroy Remain-onchannel Timer*/
-	del_timer_sync(&pstrWFIDrv->hRemainOnChannel);
+	del_timer_sync(&hif_drv->hRemainOnChannel);
 
 	host_int_set_wfi_drv_handler(NULL);
 	down(&hSemDeinitDrvHandle);
 
 
 	/*Calling the CFG80211 scan done function with the abort flag set to true*/
-	if (pstrWFIDrv->strWILC_UsrScanReq.pfUserScanResult) {
-		pstrWFIDrv->strWILC_UsrScanReq.pfUserScanResult(SCAN_EVENT_ABORTED, NULL,
-								pstrWFIDrv->strWILC_UsrScanReq.u32UserScanPvoid, NULL);
+	if (hif_drv->strWILC_UsrScanReq.pfUserScanResult) {
+		hif_drv->strWILC_UsrScanReq.pfUserScanResult(SCAN_EVENT_ABORTED, NULL,
+								hif_drv->strWILC_UsrScanReq.u32UserScanPvoid, NULL);
 
-		pstrWFIDrv->strWILC_UsrScanReq.pfUserScanResult = NULL;
+		hif_drv->strWILC_UsrScanReq.pfUserScanResult = NULL;
 	}
 
-	pstrWFIDrv->enuHostIFstate = HOST_IF_IDLE;
+	hif_drv->enuHostIFstate = HOST_IF_IDLE;
 
 	gbScanWhileConnected = false;
 
@@ -5988,7 +5882,7 @@ s32 host_int_deinit(struct host_if_drv *hWFIDrv)
 			/* msleep(HOST_IF_CONNECT_TIMEOUT+1000); */
 		}
 		msg.id = HOST_IF_MSG_EXIT;
-		msg.drv = hWFIDrv;
+		msg.drv = hif_drv;
 
 
 		s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
@@ -6000,19 +5894,15 @@ s32 host_int_deinit(struct host_if_drv *hWFIDrv)
 		wilc_mq_destroy(&gMsgQHostIF);
 	}
 
-	down(&(pstrWFIDrv->gtOsCfgValuesSem));
+	down(&(hif_drv->gtOsCfgValuesSem));
 
 	/*Setting the gloabl driver handler with NULL*/
 	/* gWFiDrvHandle = NULL; */
-	ret = remove_handler_in_list(pstrWFIDrv);
+	ret = remove_handler_in_list(hif_drv);
 	if (ret)
 		s32Error = -ENOENT;
 
-	if (pstrWFIDrv != NULL) {
-		kfree(pstrWFIDrv);
-		/* pstrWFIDrv=NULL; */
-
-	}
+	kfree(hif_drv);
 
 	clients_count--; /* Decrease number of created entities */
 	terminated_handle = NULL;
@@ -6037,16 +5927,16 @@ void NetworkInfoReceived(u8 *pu8Buffer, u32 u32Length)
 	s32 s32Error = 0;
 	struct host_if_msg msg;
 	int id;
-	struct host_if_drv *pstrWFIDrv = NULL;
+	struct host_if_drv *hif_drv = NULL;
 
 	id = ((pu8Buffer[u32Length - 4]) | (pu8Buffer[u32Length - 3] << 8) | (pu8Buffer[u32Length - 2] << 16) | (pu8Buffer[u32Length - 1] << 24));
-	pstrWFIDrv = get_handler_from_id(id);
+	hif_drv = get_handler_from_id(id);
 
 
 
 
-	if (pstrWFIDrv == NULL || pstrWFIDrv == terminated_handle)	{
-		PRINT_ER("NetworkInfo received but driver not init[%p]\n", pstrWFIDrv);
+	if (!hif_drv || hif_drv == terminated_handle)	{
+		PRINT_ER("NetworkInfo received but driver not init[%p]\n", hif_drv);
 		return;
 	}
 
@@ -6054,7 +5944,7 @@ void NetworkInfoReceived(u8 *pu8Buffer, u32 u32Length)
 	memset(&msg, 0, sizeof(struct host_if_msg));
 
 	msg.id = HOST_IF_MSG_RCVD_NTWRK_INFO;
-	msg.drv = pstrWFIDrv;
+	msg.drv = hif_drv;
 
 	msg.body.net_info.u32Length = u32Length;
 	msg.body.net_info.pu8Buffer = kmalloc(u32Length, GFP_KERNEL); /* will be deallocated by the receiving thread */
@@ -6083,22 +5973,22 @@ void GnrlAsyncInfoReceived(u8 *pu8Buffer, u32 u32Length)
 	s32 s32Error = 0;
 	struct host_if_msg msg;
 	int id;
-	struct host_if_drv *pstrWFIDrv = NULL;
+	struct host_if_drv *hif_drv = NULL;
 
 	down(&hSemHostIntDeinit);
 
 	id = ((pu8Buffer[u32Length - 4]) | (pu8Buffer[u32Length - 3] << 8) | (pu8Buffer[u32Length - 2] << 16) | (pu8Buffer[u32Length - 1] << 24));
-	pstrWFIDrv = get_handler_from_id(id);
+	hif_drv = get_handler_from_id(id);
 	PRINT_D(HOSTINF_DBG, "General asynchronous info packet received\n");
 
 
-	if (pstrWFIDrv == NULL || pstrWFIDrv == terminated_handle) {
+	if (!hif_drv || hif_drv == terminated_handle) {
 		PRINT_D(HOSTINF_DBG, "Wifi driver handler is equal to NULL\n");
 		up(&hSemHostIntDeinit);
 		return;
 	}
 
-	if (pstrWFIDrv->strWILC_UsrConnReq.pfUserConnectResult == NULL) {
+	if (!hif_drv->strWILC_UsrConnReq.pfUserConnectResult) {
 		/* received mac status is not needed when there is no current Connect Request */
 		PRINT_ER("Received mac status is not needed when there is no current Connect Reques\n");
 		up(&hSemHostIntDeinit);
@@ -6110,7 +6000,7 @@ void GnrlAsyncInfoReceived(u8 *pu8Buffer, u32 u32Length)
 
 
 	msg.id = HOST_IF_MSG_RCVD_GNRL_ASYNC_INFO;
-	msg.drv = pstrWFIDrv;
+	msg.drv = hif_drv;
 
 
 	msg.body.async_info.u32Length = u32Length;
@@ -6140,24 +6030,24 @@ void host_int_ScanCompleteReceived(u8 *pu8Buffer, u32 u32Length)
 	s32 s32Error = 0;
 	struct host_if_msg msg;
 	int id;
-	struct host_if_drv *pstrWFIDrv = NULL;
+	struct host_if_drv *hif_drv = NULL;
 
 	id = ((pu8Buffer[u32Length - 4]) | (pu8Buffer[u32Length - 3] << 8) | (pu8Buffer[u32Length - 2] << 16) | (pu8Buffer[u32Length - 1] << 24));
-	pstrWFIDrv = get_handler_from_id(id);
+	hif_drv = get_handler_from_id(id);
 
 
-	PRINT_D(GENERIC_DBG, "Scan notification received %p\n", pstrWFIDrv);
+	PRINT_D(GENERIC_DBG, "Scan notification received %p\n", hif_drv);
 
-	if (pstrWFIDrv == NULL || pstrWFIDrv == terminated_handle)
+	if (!hif_drv || hif_drv == terminated_handle)
 		return;
 
 	/*if there is an ongoing scan request*/
-	if (pstrWFIDrv->strWILC_UsrScanReq.pfUserScanResult) {
+	if (hif_drv->strWILC_UsrScanReq.pfUserScanResult) {
 		/* prepare theScan Done message */
 		memset(&msg, 0, sizeof(struct host_if_msg));
 
 		msg.id = HOST_IF_MSG_RCVD_SCAN_COMPLETE;
-		msg.drv = pstrWFIDrv;
+		msg.drv = hif_drv;
 
 
 		/* will be deallocated by the receiving thread */
@@ -6193,13 +6083,16 @@ void host_int_ScanCompleteReceived(u8 *pu8Buffer, u32 u32Length)
  *  @date
  *  @version		1.0
  */
-s32 host_int_remain_on_channel(struct host_if_drv *hWFIDrv, u32 u32SessionID, u32 u32duration, u16 chan, wilc_remain_on_chan_expired RemainOnChanExpired, wilc_remain_on_chan_ready RemainOnChanReady, void *pvUserArg)
+s32 host_int_remain_on_channel(struct host_if_drv *hif_drv, u32 u32SessionID,
+			       u32 u32duration, u16 chan,
+			       wilc_remain_on_chan_expired RemainOnChanExpired,
+			       wilc_remain_on_chan_ready RemainOnChanReady,
+			       void *pvUserArg)
 {
 	s32 s32Error = 0;
-	struct host_if_drv *pstrWFIDrv = (struct host_if_drv *)hWFIDrv;
 	struct host_if_msg msg;
 
-	if (pstrWFIDrv == NULL) {
+	if (!hif_drv) {
 		PRINT_ER("driver is null\n");
 		return -EFAULT;
 	}
@@ -6215,7 +6108,7 @@ s32 host_int_remain_on_channel(struct host_if_drv *hWFIDrv, u32 u32SessionID, u3
 	msg.body.remain_on_ch.pVoid = pvUserArg;
 	msg.body.remain_on_ch.u32duration = u32duration;
 	msg.body.remain_on_ch.u32ListenSessionID = u32SessionID;
-	msg.drv = hWFIDrv;
+	msg.drv = hif_drv;
 
 	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
 	if (s32Error)
@@ -6238,24 +6131,23 @@ s32 host_int_remain_on_channel(struct host_if_drv *hWFIDrv, u32 u32SessionID, u3
  *  @date
  *  @version		1.0
  */
-s32 host_int_ListenStateExpired(struct host_if_drv *hWFIDrv, u32 u32SessionID)
+s32 host_int_ListenStateExpired(struct host_if_drv *hif_drv, u32 u32SessionID)
 {
 	s32 s32Error = 0;
-	struct host_if_drv *pstrWFIDrv = (struct host_if_drv *)hWFIDrv;
 	struct host_if_msg msg;
 
-	if (pstrWFIDrv == NULL) {
+	if (!hif_drv) {
 		PRINT_ER("driver is null\n");
 		return -EFAULT;
 	}
 
 	/*Stopping remain-on-channel timer*/
-	del_timer(&pstrWFIDrv->hRemainOnChannel);
+	del_timer(&hif_drv->hRemainOnChannel);
 
 	/* prepare the timer fire Message */
 	memset(&msg, 0, sizeof(struct host_if_msg));
 	msg.id = HOST_IF_MSG_LISTEN_TIMER_FIRED;
-	msg.drv = hWFIDrv;
+	msg.drv = hif_drv;
 	msg.body.remain_on_ch.u32ListenSessionID = u32SessionID;
 
 	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
@@ -6273,13 +6165,12 @@ s32 host_int_ListenStateExpired(struct host_if_drv *hWFIDrv, u32 u32SessionID)
  *  @author
  *  @date
  *  @version		1.0*/
-s32 host_int_frame_register(struct host_if_drv *hWFIDrv, u16 u16FrameType, bool bReg)
+s32 host_int_frame_register(struct host_if_drv *hif_drv, u16 u16FrameType, bool bReg)
 {
 	s32 s32Error = 0;
-	struct host_if_drv *pstrWFIDrv = (struct host_if_drv *)hWFIDrv;
 	struct host_if_msg msg;
 
-	if (pstrWFIDrv == NULL) {
+	if (!hif_drv) {
 		PRINT_ER("driver is null\n");
 		return -EFAULT;
 	}
@@ -6305,7 +6196,7 @@ s32 host_int_frame_register(struct host_if_drv *hWFIDrv, u16 u16FrameType, bool
 	}
 	msg.body.reg_frame.u16FrameType = u16FrameType;
 	msg.body.reg_frame.bReg = bReg;
-	msg.drv = hWFIDrv;
+	msg.drv = hif_drv;
 
 	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
 	if (s32Error)
@@ -6327,17 +6218,15 @@ s32 host_int_frame_register(struct host_if_drv *hWFIDrv, u16 u16FrameType, bool
  *  @date
  *  @version	1.0
  */
-s32 host_int_add_beacon(struct host_if_drv *hWFIDrv, u32 u32Interval,
-				u32 u32DTIMPeriod,
-				u32 u32HeadLen, u8 *pu8Head,
-				u32 u32TailLen, u8 *pu8Tail)
+s32 host_int_add_beacon(struct host_if_drv *hif_drv, u32 u32Interval,
+			u32 u32DTIMPeriod, u32 u32HeadLen, u8 *pu8Head,
+			u32 u32TailLen, u8 *pu8Tail)
 {
 	s32 s32Error = 0;
-	struct host_if_drv *pstrWFIDrv = (struct host_if_drv *)hWFIDrv;
 	struct host_if_msg msg;
 	struct beacon_attr *pstrSetBeaconParam = &msg.body.beacon_info;
 
-	if (pstrWFIDrv == NULL) {
+	if (!hif_drv) {
 		PRINT_ER("driver is null\n");
 		return -EFAULT;
 	}
@@ -6349,7 +6238,7 @@ s32 host_int_add_beacon(struct host_if_drv *hWFIDrv, u32 u32Interval,
 
 	/* prepare the WiphyParams Message */
 	msg.id = HOST_IF_MSG_ADD_BEACON;
-	msg.drv = hWFIDrv;
+	msg.drv = hif_drv;
 	pstrSetBeaconParam->u32Interval = u32Interval;
 	pstrSetBeaconParam->u32DTIMPeriod = u32DTIMPeriod;
 	pstrSetBeaconParam->u32HeadLen = u32HeadLen;
@@ -6399,20 +6288,19 @@ ERRORHANDLER:
  *  @date
  *  @version	1.0
  */
-s32 host_int_del_beacon(struct host_if_drv *hWFIDrv)
+s32 host_int_del_beacon(struct host_if_drv *hif_drv)
 {
 	s32 s32Error = 0;
-	struct host_if_drv *pstrWFIDrv = (struct host_if_drv *)hWFIDrv;
 	struct host_if_msg msg;
 
-	if (pstrWFIDrv == NULL) {
+	if (!hif_drv) {
 		PRINT_ER("driver is null\n");
 		return -EFAULT;
 	}
 
 	/* prepare the WiphyParams Message */
 	msg.id = HOST_IF_MSG_DEL_BEACON;
-	msg.drv = hWFIDrv;
+	msg.drv = hif_drv;
 	PRINT_D(HOSTINF_DBG, "Setting deleting beacon message queue params\n");
 
 	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
@@ -6432,16 +6320,15 @@ s32 host_int_del_beacon(struct host_if_drv *hWFIDrv)
  *  @date
  *  @version	1.0
  */
-s32 host_int_add_station(struct host_if_drv *hWFIDrv,
+s32 host_int_add_station(struct host_if_drv *hif_drv,
 			 struct add_sta_param *pstrStaParams)
 {
 	s32 s32Error = 0;
-	struct host_if_drv *pstrWFIDrv = (struct host_if_drv *)hWFIDrv;
 	struct host_if_msg msg;
 	struct add_sta_param *pstrAddStationMsg = &msg.body.add_sta_info;
 
 
-	if (pstrWFIDrv == NULL) {
+	if (!hif_drv) {
 		PRINT_ER("driver is null\n");
 		return -EFAULT;
 	}
@@ -6453,7 +6340,7 @@ s32 host_int_add_station(struct host_if_drv *hWFIDrv,
 
 	/* prepare the WiphyParams Message */
 	msg.id = HOST_IF_MSG_ADD_STATION;
-	msg.drv = hWFIDrv;
+	msg.drv = hif_drv;
 
 	memcpy(pstrAddStationMsg, pstrStaParams, sizeof(struct add_sta_param));
 	if (pstrAddStationMsg->u8NumRates > 0) {
@@ -6482,14 +6369,13 @@ s32 host_int_add_station(struct host_if_drv *hWFIDrv,
  *  @date
  *  @version	1.0
  */
-s32 host_int_del_station(struct host_if_drv *hWFIDrv, const u8 *pu8MacAddr)
+s32 host_int_del_station(struct host_if_drv *hif_drv, const u8 *pu8MacAddr)
 {
 	s32 s32Error = 0;
-	struct host_if_drv *pstrWFIDrv = (struct host_if_drv *)hWFIDrv;
 	struct host_if_msg msg;
 	struct del_sta *pstrDelStationMsg = &msg.body.del_sta_info;
 
-	if (pstrWFIDrv == NULL) {
+	if (!hif_drv) {
 		PRINT_ER("driver is null\n");
 		return -EFAULT;
 	}
@@ -6502,7 +6388,7 @@ s32 host_int_del_station(struct host_if_drv *hWFIDrv, const u8 *pu8MacAddr)
 
 	/* prepare the WiphyParams Message */
 	msg.id = HOST_IF_MSG_DEL_STATION;
-	msg.drv = hWFIDrv;
+	msg.drv = hif_drv;
 
 	if (pu8MacAddr == NULL)
 		memset(pstrDelStationMsg->au8MacAddr, 255, ETH_ALEN);
@@ -6523,11 +6409,10 @@ s32 host_int_del_station(struct host_if_drv *hWFIDrv, const u8 *pu8MacAddr)
  *  @date
  *  @version	1.0
  */
-s32 host_int_del_allstation(struct host_if_drv *hWFIDrv,
+s32 host_int_del_allstation(struct host_if_drv *hif_drv,
 			    u8 pu8MacAddr[][ETH_ALEN])
 {
 	s32 s32Error = 0;
-	struct host_if_drv *pstrWFIDrv = (struct host_if_drv *)hWFIDrv;
 	struct host_if_msg msg;
 	struct del_all_sta *pstrDelAllStationMsg = &msg.body.del_all_sta_info;
 	u8 au8Zero_Buff[ETH_ALEN] = {0};
@@ -6535,7 +6420,7 @@ s32 host_int_del_allstation(struct host_if_drv *hWFIDrv,
 	u8 u8AssocNumb = 0;
 
 
-	if (pstrWFIDrv == NULL) {
+	if (!hif_drv) {
 		PRINT_ER("driver is null\n");
 		return -EFAULT;
 	}
@@ -6546,7 +6431,7 @@ s32 host_int_del_allstation(struct host_if_drv *hWFIDrv,
 
 	/* prepare the WiphyParams Message */
 	msg.id = HOST_IF_MSG_DEL_ALL_STA;
-	msg.drv = hWFIDrv;
+	msg.drv = hif_drv;
 
 	/* Handling situation of deauthenticing all associated stations*/
 	for (i = 0; i < MAX_NUM_STA; i++) {
@@ -6584,15 +6469,14 @@ s32 host_int_del_allstation(struct host_if_drv *hWFIDrv,
  *  @date
  *  @version	1.0
  */
-s32 host_int_edit_station(struct host_if_drv *hWFIDrv,
+s32 host_int_edit_station(struct host_if_drv *hif_drv,
 			  struct add_sta_param *pstrStaParams)
 {
 	s32 s32Error = 0;
-	struct host_if_drv *pstrWFIDrv = (struct host_if_drv *)hWFIDrv;
 	struct host_if_msg msg;
 	struct add_sta_param *pstrAddStationMsg = &msg.body.add_sta_info;
 
-	if (pstrWFIDrv == NULL) {
+	if (!hif_drv) {
 		PRINT_ER("driver is null\n");
 		return -EFAULT;
 	}
@@ -6604,7 +6488,7 @@ s32 host_int_edit_station(struct host_if_drv *hWFIDrv,
 
 	/* prepare the WiphyParams Message */
 	msg.id = HOST_IF_MSG_EDIT_STATION;
-	msg.drv = hWFIDrv;
+	msg.drv = hif_drv;
 
 	memcpy(pstrAddStationMsg, pstrStaParams, sizeof(struct add_sta_param));
 	if (pstrAddStationMsg->u8NumRates > 0) {
@@ -6624,16 +6508,17 @@ s32 host_int_edit_station(struct host_if_drv *hWFIDrv,
 	return s32Error;
 }
 
-s32 host_int_set_power_mgmt(struct host_if_drv *hWFIDrv, bool bIsEnabled, u32 u32Timeout)
+s32 host_int_set_power_mgmt(struct host_if_drv *hif_drv,
+			    bool bIsEnabled,
+			    u32 u32Timeout)
 {
 	s32 s32Error = 0;
-	struct host_if_drv *pstrWFIDrv = (struct host_if_drv *)hWFIDrv;
 	struct host_if_msg msg;
 	struct power_mgmt_param *pstrPowerMgmtParam = &msg.body.pwr_mgmt_info;
 
 	PRINT_INFO(HOSTINF_DBG, "\n\n>> Setting PS to %d <<\n\n", bIsEnabled);
 
-	if (pstrWFIDrv == NULL) {
+	if (!hif_drv) {
 		PRINT_ER("driver is null\n");
 		return -EFAULT;
 	}
@@ -6645,7 +6530,7 @@ s32 host_int_set_power_mgmt(struct host_if_drv *hWFIDrv, bool bIsEnabled, u32 u3
 
 	/* prepare the WiphyParams Message */
 	msg.id = HOST_IF_MSG_POWER_MGMT;
-	msg.drv = hWFIDrv;
+	msg.drv = hif_drv;
 
 	pstrPowerMgmtParam->bIsEnabled = bIsEnabled;
 	pstrPowerMgmtParam->u32Timeout = u32Timeout;
@@ -6657,16 +6542,16 @@ s32 host_int_set_power_mgmt(struct host_if_drv *hWFIDrv, bool bIsEnabled, u32 u3
 	return s32Error;
 }
 
-s32 host_int_setup_multicast_filter(struct host_if_drv *hWFIDrv, bool bIsEnabled, u32 u32count)
+s32 host_int_setup_multicast_filter(struct host_if_drv *hif_drv,
+				    bool bIsEnabled,
+				    u32 u32count)
 {
 	s32 s32Error = 0;
-
-	struct host_if_drv *pstrWFIDrv = (struct host_if_drv *)hWFIDrv;
 	struct host_if_msg msg;
 	struct set_multicast *pstrMulticastFilterParam = &msg.body.multicast_info;
 
 
-	if (pstrWFIDrv == NULL) {
+	if (!hif_drv) {
 		PRINT_ER("driver is null\n");
 		return -EFAULT;
 	}
@@ -6678,7 +6563,7 @@ s32 host_int_setup_multicast_filter(struct host_if_drv *hWFIDrv, bool bIsEnabled
 
 	/* prepare the WiphyParams Message */
 	msg.id = HOST_IF_MSG_SET_MULTICAST_FILTER;
-	msg.drv = hWFIDrv;
+	msg.drv = hif_drv;
 
 	pstrMulticastFilterParam->bIsEnabled = bIsEnabled;
 	pstrMulticastFilterParam->u32count = u32count;
@@ -6907,14 +6792,13 @@ void host_int_freeJoinParams(void *pJoinParams)
 		PRINT_ER("Unable to FREE null pointer\n");
 }
 
-s32 host_int_delBASession(struct host_if_drv *hWFIDrv, char *pBSSID, char TID)
+s32 host_int_delBASession(struct host_if_drv *hif_drv, char *pBSSID, char TID)
 {
 	s32 s32Error = 0;
-	struct host_if_drv *pstrWFIDrv = (struct host_if_drv *)hWFIDrv;
 	struct host_if_msg msg;
 	struct ba_session_info *pBASessionInfo = &msg.body.session_info;
 
-	if (pstrWFIDrv == NULL) {
+	if (!hif_drv) {
 		PRINT_ER("driver is null\n");
 		return -EFAULT;
 	}
@@ -6926,7 +6810,7 @@ s32 host_int_delBASession(struct host_if_drv *hWFIDrv, char *pBSSID, char TID)
 
 	memcpy(pBASessionInfo->au8Bssid, pBSSID, ETH_ALEN);
 	pBASessionInfo->u8Ted = TID;
-	msg.drv = hWFIDrv;
+	msg.drv = hif_drv;
 
 	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
 	if (s32Error)
@@ -6937,14 +6821,15 @@ s32 host_int_delBASession(struct host_if_drv *hWFIDrv, char *pBSSID, char TID)
 	return s32Error;
 }
 
-s32 host_int_del_All_Rx_BASession(struct host_if_drv *hWFIDrv, char *pBSSID, char TID)
+s32 host_int_del_All_Rx_BASession(struct host_if_drv *hif_drv,
+				  char *pBSSID,
+				  char TID)
 {
 	s32 s32Error = 0;
-	struct host_if_drv *pstrWFIDrv = (struct host_if_drv *)hWFIDrv;
 	struct host_if_msg msg;
 	struct ba_session_info *pBASessionInfo = &msg.body.session_info;
 
-	if (pstrWFIDrv == NULL) {
+	if (!hif_drv) {
 		PRINT_ER("driver is null\n");
 		return -EFAULT;
 	}
@@ -6956,7 +6841,7 @@ s32 host_int_del_All_Rx_BASession(struct host_if_drv *hWFIDrv, char *pBSSID, cha
 
 	memcpy(pBASessionInfo->au8Bssid, pBSSID, ETH_ALEN);
 	pBASessionInfo->u8Ted = TID;
-	msg.drv = hWFIDrv;
+	msg.drv = hif_drv;
 
 	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
 	if (s32Error)
@@ -6975,16 +6860,15 @@ s32 host_int_del_All_Rx_BASession(struct host_if_drv *hWFIDrv, char *pBSSID, cha
  *  @author		Abdelrahman Sobhy
  *  @date
  *  @version		1.0*/
-s32 host_int_setup_ipaddress(struct host_if_drv *hWFIDrv, u8 *u16ipadd, u8 idx)
+s32 host_int_setup_ipaddress(struct host_if_drv *hif_drv, u8 *u16ipadd, u8 idx)
 {
 	s32 s32Error = 0;
-	struct host_if_drv *pstrWFIDrv = (struct host_if_drv *)hWFIDrv;
 	struct host_if_msg msg;
 
 	/* TODO: Enable This feature on softap firmware */
 	return 0;
 
-	if (pstrWFIDrv == NULL) {
+	if (!hif_drv) {
 		PRINT_ER("driver is null\n");
 		return -EFAULT;
 	}
@@ -6995,7 +6879,7 @@ s32 host_int_setup_ipaddress(struct host_if_drv *hWFIDrv, u8 *u16ipadd, u8 idx)
 	msg.id = HOST_IF_MSG_SET_IPADDRESS;
 
 	msg.body.ip_info.au8IPAddr = u16ipadd;
-	msg.drv = hWFIDrv;
+	msg.drv = hif_drv;
 	msg.body.ip_info.idx = idx;
 
 	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
@@ -7015,13 +6899,12 @@ s32 host_int_setup_ipaddress(struct host_if_drv *hWFIDrv, u8 *u16ipadd, u8 idx)
  *  @author		Abdelrahman Sobhy
  *  @date
  *  @version		1.0*/
-s32 host_int_get_ipaddress(struct host_if_drv *hWFIDrv, u8 *u16ipadd, u8 idx)
+s32 host_int_get_ipaddress(struct host_if_drv *hif_drv, u8 *u16ipadd, u8 idx)
 {
 	s32 s32Error = 0;
-	struct host_if_drv *pstrWFIDrv = (struct host_if_drv *)hWFIDrv;
 	struct host_if_msg msg;
 
-	if (pstrWFIDrv == NULL) {
+	if (!hif_drv) {
 		PRINT_ER("driver is null\n");
 		return -EFAULT;
 	}
@@ -7032,7 +6915,7 @@ s32 host_int_get_ipaddress(struct host_if_drv *hWFIDrv, u8 *u16ipadd, u8 idx)
 	msg.id = HOST_IF_MSG_GET_IPADDRESS;
 
 	msg.body.ip_info.au8IPAddr = u16ipadd;
-	msg.drv = hWFIDrv;
+	msg.drv = hif_drv;
 	msg.body.ip_info.idx = idx;
 
 	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
-- 
1.9.1

