Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:12329 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751538AbbJLH5i (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Oct 2015 03:57:38 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH V2 10/41] staging: wilc1000: rename the member variable, u16WIDid of wid
Date: Mon, 12 Oct 2015 16:55:44 +0900
Message-ID: <1444636575-2486-10-git-send-email-tony.cho@atmel.com> (sfid-20151012_095800_127263_EBA8176E)
In-Reply-To: <1444636575-2486-1-git-send-email-tony.cho@atmel.com>
References: <1444636575-2486-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames u16WIDid of struct wid to id.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/coreconfigurator.c |   8 +-
 drivers/staging/wilc1000/coreconfigurator.h |   2 +-
 drivers/staging/wilc1000/host_interface.c   | 186 ++++++++++++++--------------
 3 files changed, 98 insertions(+), 98 deletions(-)

diff --git a/drivers/staging/wilc1000/coreconfigurator.c b/drivers/staging/wilc1000/coreconfigurator.c
index 2e063f6..05a0c16 100644
--- a/drivers/staging/wilc1000/coreconfigurator.c
+++ b/drivers/staging/wilc1000/coreconfigurator.c
@@ -604,7 +604,7 @@ s32 send_config_pkt(u8 mode, struct wid *wids, u32 count, u32 drv)
 			PRINT_INFO(CORECONFIG_DBG, "Sending CFG packet [%d][%d]\n", !counter,
 				   (counter == count - 1));
 			if (!wilc_wlan_cfg_get(!counter,
-					       wids[counter].u16WIDid,
+					       wids[counter].id,
 					       (counter == count - 1),
 					       drv)) {
 				ret = -1;
@@ -615,16 +615,16 @@ s32 send_config_pkt(u8 mode, struct wid *wids, u32 count, u32 drv)
 		counter = 0;
 		for (counter = 0; counter < count; counter++) {
 			wids[counter].s32ValueSize = wilc_wlan_cfg_get_val(
-					wids[counter].u16WIDid,
+					wids[counter].id,
 					wids[counter].ps8WidVal,
 					wids[counter].s32ValueSize);
 
 		}
 	} else if (mode == SET_CFG) {
 		for (counter = 0; counter < count; counter++) {
-			PRINT_D(CORECONFIG_DBG, "Sending config SET PACKET WID:%x\n", wids[counter].u16WIDid);
+			PRINT_D(CORECONFIG_DBG, "Sending config SET PACKET WID:%x\n", wids[counter].id);
 			if (!wilc_wlan_cfg_set(!counter,
-					       wids[counter].u16WIDid,
+					       wids[counter].id,
 					       wids[counter].ps8WidVal,
 					       wids[counter].s32ValueSize,
 					       (counter == count - 1),
diff --git a/drivers/staging/wilc1000/coreconfigurator.h b/drivers/staging/wilc1000/coreconfigurator.h
index 27c1a86..0d3bff7 100644
--- a/drivers/staging/wilc1000/coreconfigurator.h
+++ b/drivers/staging/wilc1000/coreconfigurator.h
@@ -71,7 +71,7 @@ typedef enum {
 } tenuConnectSts;
 
 struct wid {
-	u16 u16WIDid;
+	u16 id;
 	enum WID_TYPE type;
 	s32 s32ValueSize;
 	s8      *ps8WidVal;
diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 1e18d50..443e783 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -576,7 +576,7 @@ static s32 Handle_SetChannel(struct host_if_drv *drvHandler,
 	struct host_if_drv *pstrWFIDrv = (struct host_if_drv *)drvHandler;
 
 	/*prepare configuration packet*/
-	strWID.u16WIDid = (u16)WID_CURRENT_CHANNEL;
+	strWID.id = (u16)WID_CURRENT_CHANNEL;
 	strWID.type = WID_CHAR;
 	strWID.ps8WidVal = (char *)&(pstrHostIFSetChan->u8SetChan);
 	strWID.s32ValueSize = sizeof(char);
@@ -612,7 +612,7 @@ static s32 Handle_SetWfiDrvHandler(struct host_if_drv *drvHandler,
 
 
 	/*prepare configuration packet*/
-	strWID.u16WIDid = (u16)WID_SET_DRV_HANDLER;
+	strWID.id = (u16)WID_SET_DRV_HANDLER;
 	strWID.type = WID_INT;
 	strWID.ps8WidVal = (s8 *)&(pstrHostIfSetDrvHandler->u32Address);
 	strWID.s32ValueSize = sizeof(u32);
@@ -653,7 +653,7 @@ static s32 Handle_SetOperationMode(struct host_if_drv *drvHandler,
 
 
 	/*prepare configuration packet*/
-	strWID.u16WIDid = (u16)WID_SET_OPERATION_MODE;
+	strWID.id = (u16)WID_SET_OPERATION_MODE;
 	strWID.type = WID_INT;
 	strWID.ps8WidVal = (s8 *)&(pstrHostIfSetOperationMode->u32Mode);
 	strWID.s32ValueSize = sizeof(u32);
@@ -702,7 +702,7 @@ s32 Handle_set_IPAddress(struct host_if_drv *drvHandler, u8 *pu8IPAddr, u8 idx)
 	memcpy(gs8SetIP[idx], pu8IPAddr, IP_ALEN);
 
 	/*prepare configuration packet*/
-	strWID.u16WIDid = (u16)WID_IP_ADDRESS;
+	strWID.id = (u16)WID_IP_ADDRESS;
 	strWID.type = WID_STR;
 	strWID.ps8WidVal = (u8 *)pu8IPAddr;
 	strWID.s32ValueSize = IP_ALEN;
@@ -741,7 +741,7 @@ s32 Handle_get_IPAddress(struct host_if_drv *drvHandler, u8 *pu8IPAddr, u8 idx)
 	struct host_if_drv *pstrWFIDrv = (struct host_if_drv *)drvHandler;
 
 	/*prepare configuration packet*/
-	strWID.u16WIDid = (u16)WID_IP_ADDRESS;
+	strWID.id = (u16)WID_IP_ADDRESS;
 	strWID.type = WID_STR;
 	strWID.ps8WidVal = kmalloc(IP_ALEN, GFP_KERNEL);
 	strWID.s32ValueSize = IP_ALEN;
@@ -797,7 +797,7 @@ static s32 Handle_SetMacAddress(struct host_if_drv *drvHandler,
 	memcpy(mac_buf, pstrHostIfSetMacAddress->u8MacAddress, ETH_ALEN);
 
 	/*prepare configuration packet*/
-	strWID.u16WIDid = (u16)WID_MAC_ADDR;
+	strWID.id = (u16)WID_MAC_ADDR;
 	strWID.type = WID_STR;
 	strWID.ps8WidVal = mac_buf;
 	strWID.s32ValueSize = ETH_ALEN;
@@ -832,7 +832,7 @@ static s32 Handle_GetMacAddress(struct host_if_drv *drvHandler,
 	struct wid strWID;
 
 	/*prepare configuration packet*/
-	strWID.u16WIDid = (u16)WID_MAC_ADDR;
+	strWID.id = (u16)WID_MAC_ADDR;
 	strWID.type = WID_STR;
 	strWID.ps8WidVal = pstrHostIfGetMacAddress->u8MacAddress;
 	strWID.s32ValueSize = ETH_ALEN;
@@ -881,7 +881,7 @@ static s32 Handle_CfgParam(struct host_if_drv *drvHandler,
 		/*----------------------------------------------------------*/
 		/* validate input then copy>> need to check value 4 and 5 */
 		if (strHostIFCfgParamAttr->pstrCfgParamVal.bss_type < 6) {
-			strWIDList[u8WidCnt].u16WIDid = WID_BSS_TYPE;
+			strWIDList[u8WidCnt].id = WID_BSS_TYPE;
 			strWIDList[u8WidCnt].ps8WidVal = (s8 *)&strHostIFCfgParamAttr->pstrCfgParamVal.bss_type;
 			strWIDList[u8WidCnt].type = WID_CHAR;
 			strWIDList[u8WidCnt].s32ValueSize = sizeof(char);
@@ -901,7 +901,7 @@ static s32 Handle_CfgParam(struct host_if_drv *drvHandler,
 		/*------------------------------------------------------*/
 		/*validate Possible values*/
 		if ((strHostIFCfgParamAttr->pstrCfgParamVal.auth_type) == 1 || (strHostIFCfgParamAttr->pstrCfgParamVal.auth_type) == 2 || (strHostIFCfgParamAttr->pstrCfgParamVal.auth_type) == 5) {
-			strWIDList[u8WidCnt].u16WIDid = WID_AUTH_TYPE;
+			strWIDList[u8WidCnt].id = WID_AUTH_TYPE;
 			strWIDList[u8WidCnt].ps8WidVal = (s8 *)&strHostIFCfgParamAttr->pstrCfgParamVal.auth_type;
 			strWIDList[u8WidCnt].type = WID_CHAR;
 			strWIDList[u8WidCnt].s32ValueSize = sizeof(char);
@@ -916,7 +916,7 @@ static s32 Handle_CfgParam(struct host_if_drv *drvHandler,
 	if (strHostIFCfgParamAttr->pstrCfgParamVal.u32SetCfgFlag & AUTHEN_TIMEOUT) {
 		/* range is 1 to 65535. */
 		if (strHostIFCfgParamAttr->pstrCfgParamVal.auth_timeout > 0 && strHostIFCfgParamAttr->pstrCfgParamVal.auth_timeout < 65536) {
-			strWIDList[u8WidCnt].u16WIDid = WID_AUTH_TIMEOUT;
+			strWIDList[u8WidCnt].id = WID_AUTH_TIMEOUT;
 			strWIDList[u8WidCnt].ps8WidVal = (s8 *)&strHostIFCfgParamAttr->pstrCfgParamVal.auth_timeout;
 			strWIDList[u8WidCnt].type = WID_SHORT;
 			strWIDList[u8WidCnt].s32ValueSize = sizeof(u16);
@@ -937,7 +937,7 @@ static s32 Handle_CfgParam(struct host_if_drv *drvHandler,
 		/*				MAX_PSPOLL_PS    = 4						*/
 		/*----------------------------------------------------------*/
 		if (strHostIFCfgParamAttr->pstrCfgParamVal.power_mgmt_mode < 5) {
-			strWIDList[u8WidCnt].u16WIDid = WID_POWER_MANAGEMENT;
+			strWIDList[u8WidCnt].id = WID_POWER_MANAGEMENT;
 			strWIDList[u8WidCnt].ps8WidVal = (s8 *)&strHostIFCfgParamAttr->pstrCfgParamVal.power_mgmt_mode;
 			strWIDList[u8WidCnt].type = WID_CHAR;
 			strWIDList[u8WidCnt].s32ValueSize = sizeof(char);
@@ -952,7 +952,7 @@ static s32 Handle_CfgParam(struct host_if_drv *drvHandler,
 	if (strHostIFCfgParamAttr->pstrCfgParamVal.u32SetCfgFlag & RETRY_SHORT) {
 		/* range from 1 to 256 */
 		if ((strHostIFCfgParamAttr->pstrCfgParamVal.short_retry_limit > 0) && (strHostIFCfgParamAttr->pstrCfgParamVal.short_retry_limit < 256))	{
-			strWIDList[u8WidCnt].u16WIDid = WID_SHORT_RETRY_LIMIT;
+			strWIDList[u8WidCnt].id = WID_SHORT_RETRY_LIMIT;
 			strWIDList[u8WidCnt].ps8WidVal = (s8 *)&strHostIFCfgParamAttr->pstrCfgParamVal.short_retry_limit;
 			strWIDList[u8WidCnt].type = WID_SHORT;
 			strWIDList[u8WidCnt].s32ValueSize = sizeof(u16);
@@ -967,7 +967,7 @@ static s32 Handle_CfgParam(struct host_if_drv *drvHandler,
 	if (strHostIFCfgParamAttr->pstrCfgParamVal.u32SetCfgFlag & RETRY_LONG) {
 		/* range from 1 to 256 */
 		if ((strHostIFCfgParamAttr->pstrCfgParamVal.long_retry_limit > 0) && (strHostIFCfgParamAttr->pstrCfgParamVal.long_retry_limit < 256)) {
-			strWIDList[u8WidCnt].u16WIDid = WID_LONG_RETRY_LIMIT;
+			strWIDList[u8WidCnt].id = WID_LONG_RETRY_LIMIT;
 			strWIDList[u8WidCnt].ps8WidVal = (s8 *)&strHostIFCfgParamAttr->pstrCfgParamVal.long_retry_limit;
 
 			strWIDList[u8WidCnt].type = WID_SHORT;
@@ -983,7 +983,7 @@ static s32 Handle_CfgParam(struct host_if_drv *drvHandler,
 	if (strHostIFCfgParamAttr->pstrCfgParamVal.u32SetCfgFlag & FRAG_THRESHOLD) {
 
 		if (strHostIFCfgParamAttr->pstrCfgParamVal.frag_threshold > 255 && strHostIFCfgParamAttr->pstrCfgParamVal.frag_threshold < 7937) {
-			strWIDList[u8WidCnt].u16WIDid = WID_FRAG_THRESHOLD;
+			strWIDList[u8WidCnt].id = WID_FRAG_THRESHOLD;
 			strWIDList[u8WidCnt].ps8WidVal = (s8 *)&strHostIFCfgParamAttr->pstrCfgParamVal.frag_threshold;
 			strWIDList[u8WidCnt].type = WID_SHORT;
 			strWIDList[u8WidCnt].s32ValueSize = sizeof(u16);
@@ -998,7 +998,7 @@ static s32 Handle_CfgParam(struct host_if_drv *drvHandler,
 	if (strHostIFCfgParamAttr->pstrCfgParamVal.u32SetCfgFlag & RTS_THRESHOLD) {
 		/* range 256 to 65535 */
 		if (strHostIFCfgParamAttr->pstrCfgParamVal.rts_threshold > 255 && strHostIFCfgParamAttr->pstrCfgParamVal.rts_threshold < 65536)	{
-			strWIDList[u8WidCnt].u16WIDid = WID_RTS_THRESHOLD;
+			strWIDList[u8WidCnt].id = WID_RTS_THRESHOLD;
 			strWIDList[u8WidCnt].ps8WidVal = (s8 *)&strHostIFCfgParamAttr->pstrCfgParamVal.rts_threshold;
 			strWIDList[u8WidCnt].type = WID_SHORT;
 			strWIDList[u8WidCnt].s32ValueSize = sizeof(u16);
@@ -1017,7 +1017,7 @@ static s32 Handle_CfgParam(struct host_if_drv *drvHandler,
 		/*				Auto= 2									*/
 		/*------------------------------------------------------*/
 		if (strHostIFCfgParamAttr->pstrCfgParamVal.preamble_type < 3) {
-			strWIDList[u8WidCnt].u16WIDid = WID_PREAMBLE;
+			strWIDList[u8WidCnt].id = WID_PREAMBLE;
 			strWIDList[u8WidCnt].ps8WidVal = (s8 *)&strHostIFCfgParamAttr->pstrCfgParamVal.preamble_type;
 			strWIDList[u8WidCnt].type = WID_CHAR;
 			strWIDList[u8WidCnt].s32ValueSize = sizeof(char);
@@ -1031,7 +1031,7 @@ static s32 Handle_CfgParam(struct host_if_drv *drvHandler,
 	}
 	if (strHostIFCfgParamAttr->pstrCfgParamVal.u32SetCfgFlag & SHORT_SLOT_ALLOWED) {
 		if (strHostIFCfgParamAttr->pstrCfgParamVal.short_slot_allowed < 2) {
-			strWIDList[u8WidCnt].u16WIDid = WID_SHORT_SLOT_ALLOWED;
+			strWIDList[u8WidCnt].id = WID_SHORT_SLOT_ALLOWED;
 			strWIDList[u8WidCnt].ps8WidVal = (s8 *)&strHostIFCfgParamAttr->pstrCfgParamVal.short_slot_allowed;
 			strWIDList[u8WidCnt].type = WID_CHAR;
 			strWIDList[u8WidCnt].s32ValueSize = sizeof(char);
@@ -1049,7 +1049,7 @@ static s32 Handle_CfgParam(struct host_if_drv *drvHandler,
 		/* this information is useful for external supplicant                                   */
 		/*Input Values: 1 for enable and 0 for disable.							*/
 		if (strHostIFCfgParamAttr->pstrCfgParamVal.txop_prot_disabled < 2) {
-			strWIDList[u8WidCnt].u16WIDid = WID_11N_TXOP_PROT_DISABLE;
+			strWIDList[u8WidCnt].id = WID_11N_TXOP_PROT_DISABLE;
 			strWIDList[u8WidCnt].ps8WidVal = (s8 *)&strHostIFCfgParamAttr->pstrCfgParamVal.txop_prot_disabled;
 			strWIDList[u8WidCnt].type = WID_CHAR;
 			strWIDList[u8WidCnt].s32ValueSize = sizeof(char);
@@ -1064,7 +1064,7 @@ static s32 Handle_CfgParam(struct host_if_drv *drvHandler,
 	if (strHostIFCfgParamAttr->pstrCfgParamVal.u32SetCfgFlag & BEACON_INTERVAL) {
 		/* range is 1 to 65535. */
 		if (strHostIFCfgParamAttr->pstrCfgParamVal.beacon_interval > 0 && strHostIFCfgParamAttr->pstrCfgParamVal.beacon_interval < 65536) {
-			strWIDList[u8WidCnt].u16WIDid = WID_BEACON_INTERVAL;
+			strWIDList[u8WidCnt].id = WID_BEACON_INTERVAL;
 			strWIDList[u8WidCnt].ps8WidVal = (s8 *)&strHostIFCfgParamAttr->pstrCfgParamVal.beacon_interval;
 			strWIDList[u8WidCnt].type = WID_SHORT;
 			strWIDList[u8WidCnt].s32ValueSize = sizeof(u16);
@@ -1079,7 +1079,7 @@ static s32 Handle_CfgParam(struct host_if_drv *drvHandler,
 	if (strHostIFCfgParamAttr->pstrCfgParamVal.u32SetCfgFlag & DTIM_PERIOD) {
 		/* range is 1 to 255. */
 		if (strHostIFCfgParamAttr->pstrCfgParamVal.dtim_period > 0 && strHostIFCfgParamAttr->pstrCfgParamVal.dtim_period < 256) {
-			strWIDList[u8WidCnt].u16WIDid = WID_DTIM_PERIOD;
+			strWIDList[u8WidCnt].id = WID_DTIM_PERIOD;
 			strWIDList[u8WidCnt].ps8WidVal = (s8 *)&strHostIFCfgParamAttr->pstrCfgParamVal.dtim_period;
 			strWIDList[u8WidCnt].type = WID_CHAR;
 			strWIDList[u8WidCnt].s32ValueSize = sizeof(char);
@@ -1098,7 +1098,7 @@ static s32 Handle_CfgParam(struct host_if_drv *drvHandler,
 		/*				SITE_SURVEY_OFF    = 2									*/
 		/*----------------------------------------------------------------------*/
 		if (strHostIFCfgParamAttr->pstrCfgParamVal.site_survey_enabled < 3) {
-			strWIDList[u8WidCnt].u16WIDid = WID_SITE_SURVEY;
+			strWIDList[u8WidCnt].id = WID_SITE_SURVEY;
 			strWIDList[u8WidCnt].ps8WidVal = (s8 *)&strHostIFCfgParamAttr->pstrCfgParamVal.site_survey_enabled;
 			strWIDList[u8WidCnt].type = WID_CHAR;
 			strWIDList[u8WidCnt].s32ValueSize = sizeof(char);
@@ -1113,7 +1113,7 @@ static s32 Handle_CfgParam(struct host_if_drv *drvHandler,
 	if (strHostIFCfgParamAttr->pstrCfgParamVal.u32SetCfgFlag & SITE_SURVEY_SCAN_TIME) {
 		/* range is 1 to 65535. */
 		if (strHostIFCfgParamAttr->pstrCfgParamVal.site_survey_scan_time > 0 && strHostIFCfgParamAttr->pstrCfgParamVal.site_survey_scan_time < 65536) {
-			strWIDList[u8WidCnt].u16WIDid = WID_SITE_SURVEY_SCAN_TIME;
+			strWIDList[u8WidCnt].id = WID_SITE_SURVEY_SCAN_TIME;
 			strWIDList[u8WidCnt].ps8WidVal = (s8 *)&strHostIFCfgParamAttr->pstrCfgParamVal.site_survey_scan_time;
 			strWIDList[u8WidCnt].type = WID_SHORT;
 			strWIDList[u8WidCnt].s32ValueSize = sizeof(u16);
@@ -1128,7 +1128,7 @@ static s32 Handle_CfgParam(struct host_if_drv *drvHandler,
 	if (strHostIFCfgParamAttr->pstrCfgParamVal.u32SetCfgFlag & ACTIVE_SCANTIME) {
 		/* range is 1 to 65535. */
 		if (strHostIFCfgParamAttr->pstrCfgParamVal.active_scan_time > 0 && strHostIFCfgParamAttr->pstrCfgParamVal.active_scan_time < 65536) {
-			strWIDList[u8WidCnt].u16WIDid = WID_ACTIVE_SCAN_TIME;
+			strWIDList[u8WidCnt].id = WID_ACTIVE_SCAN_TIME;
 			strWIDList[u8WidCnt].ps8WidVal = (s8 *)&strHostIFCfgParamAttr->pstrCfgParamVal.active_scan_time;
 			strWIDList[u8WidCnt].type = WID_SHORT;
 			strWIDList[u8WidCnt].s32ValueSize = sizeof(u16);
@@ -1143,7 +1143,7 @@ static s32 Handle_CfgParam(struct host_if_drv *drvHandler,
 	if (strHostIFCfgParamAttr->pstrCfgParamVal.u32SetCfgFlag & PASSIVE_SCANTIME) {
 		/* range is 1 to 65535. */
 		if (strHostIFCfgParamAttr->pstrCfgParamVal.passive_scan_time > 0 && strHostIFCfgParamAttr->pstrCfgParamVal.passive_scan_time < 65536) {
-			strWIDList[u8WidCnt].u16WIDid = WID_PASSIVE_SCAN_TIME;
+			strWIDList[u8WidCnt].id = WID_PASSIVE_SCAN_TIME;
 			strWIDList[u8WidCnt].ps8WidVal = (s8 *)&strHostIFCfgParamAttr->pstrCfgParamVal.passive_scan_time;
 			strWIDList[u8WidCnt].type = WID_SHORT;
 			strWIDList[u8WidCnt].s32ValueSize = sizeof(u16);
@@ -1168,7 +1168,7 @@ static s32 Handle_CfgParam(struct host_if_drv *drvHandler,
 		    || curr_tx_rate == MBPS_9 || curr_tx_rate == MBPS_12
 		    || curr_tx_rate == MBPS_18 || curr_tx_rate == MBPS_24
 		    || curr_tx_rate == MBPS_36 || curr_tx_rate == MBPS_48 || curr_tx_rate == MBPS_54) {
-			strWIDList[u8WidCnt].u16WIDid = WID_CURRENT_TX_RATE;
+			strWIDList[u8WidCnt].id = WID_CURRENT_TX_RATE;
 			strWIDList[u8WidCnt].ps8WidVal = (s8 *)&curr_tx_rate;
 			strWIDList[u8WidCnt].type = WID_SHORT;
 			strWIDList[u8WidCnt].s32ValueSize = sizeof(u16);
@@ -1255,7 +1255,7 @@ static s32 Handle_Scan(struct host_if_drv *drvHandler,
 
 	pstrWFIDrv->strWILC_UsrScanReq.u32RcvdChCount = 0;
 
-	strWIDList[u32WidsCount].u16WIDid = (u16)WID_SSID_PROBE_REQ;
+	strWIDList[u32WidsCount].id = (u16)WID_SSID_PROBE_REQ;
 	strWIDList[u32WidsCount].type = WID_STR;
 
 	for (i = 0; i < pstrHostIFscanAttr->strHiddenNetwork.u8ssidnum; i++)
@@ -1286,7 +1286,7 @@ static s32 Handle_Scan(struct host_if_drv *drvHandler,
 	/* if((pstrHostIFscanAttr->pu8IEs != NULL) && (pstrHostIFscanAttr->IEsLen != 0)) */
 	{
 		/* IEs to be inserted in Probe Request */
-		strWIDList[u32WidsCount].u16WIDid = WID_INFO_ELEMENT_PROBE;
+		strWIDList[u32WidsCount].id = WID_INFO_ELEMENT_PROBE;
 		strWIDList[u32WidsCount].type = WID_BIN_DATA;
 		strWIDList[u32WidsCount].ps8WidVal = pstrHostIFscanAttr->pu8IEs;
 		strWIDList[u32WidsCount].s32ValueSize = pstrHostIFscanAttr->IEsLen;
@@ -1294,14 +1294,14 @@ static s32 Handle_Scan(struct host_if_drv *drvHandler,
 	}
 
 	/*Scan Type*/
-	strWIDList[u32WidsCount].u16WIDid = WID_SCAN_TYPE;
+	strWIDList[u32WidsCount].id = WID_SCAN_TYPE;
 	strWIDList[u32WidsCount].type = WID_CHAR;
 	strWIDList[u32WidsCount].s32ValueSize = sizeof(char);
 	strWIDList[u32WidsCount].ps8WidVal = (s8 *)(&(pstrHostIFscanAttr->u8ScanType));
 	u32WidsCount++;
 
 	/*list of channels to be scanned*/
-	strWIDList[u32WidsCount].u16WIDid = WID_SCAN_CHANNEL_LIST;
+	strWIDList[u32WidsCount].id = WID_SCAN_CHANNEL_LIST;
 	strWIDList[u32WidsCount].type = WID_BIN_DATA;
 
 	if (pstrHostIFscanAttr->pu8ChnlFreqList != NULL && pstrHostIFscanAttr->u8ChnlListLen > 0) {
@@ -1318,7 +1318,7 @@ static s32 Handle_Scan(struct host_if_drv *drvHandler,
 	u32WidsCount++;
 
 	/*Scan Request*/
-	strWIDList[u32WidsCount].u16WIDid = WID_START_SCAN_REQ;
+	strWIDList[u32WidsCount].id = WID_START_SCAN_REQ;
 	strWIDList[u32WidsCount].type = WID_CHAR;
 	strWIDList[u32WidsCount].s32ValueSize = sizeof(char);
 	strWIDList[u32WidsCount].ps8WidVal = (s8 *)(&(pstrHostIFscanAttr->u8ScanSource));
@@ -1401,7 +1401,7 @@ static s32 Handle_ScanDone(struct host_if_drv *drvHandler, tenuScanEvent enuEven
 	if (enuEvent == SCAN_EVENT_ABORTED) {
 		PRINT_D(GENERIC_DBG, "Abort running scan\n");
 		u8abort_running_scan = 1;
-		strWID.u16WIDid	= (u16)WID_ABORT_RUNNING_SCAN;
+		strWID.id = (u16)WID_ABORT_RUNNING_SCAN;
 		strWID.type = WID_CHAR;
 		strWID.ps8WidVal = (s8 *)&u8abort_running_scan;
 		strWID.s32ValueSize = sizeof(char);
@@ -1497,19 +1497,19 @@ static s32 Handle_Connect(struct host_if_drv *drvHandler,
 	pstrWFIDrv->strWILC_UsrConnReq.pfUserConnectResult = pstrHostIFconnectAttr->pfConnectResult;
 	pstrWFIDrv->strWILC_UsrConnReq.u32UserConnectPvoid = pstrHostIFconnectAttr->pvUserArg;
 
-	strWIDList[u32WidsCount].u16WIDid = WID_SUCCESS_FRAME_COUNT;
+	strWIDList[u32WidsCount].id = WID_SUCCESS_FRAME_COUNT;
 	strWIDList[u32WidsCount].type = WID_INT;
 	strWIDList[u32WidsCount].s32ValueSize = sizeof(u32);
 	strWIDList[u32WidsCount].ps8WidVal = (s8 *)(&(dummyval));
 	u32WidsCount++;
 
-	strWIDList[u32WidsCount].u16WIDid = WID_RECEIVED_FRAGMENT_COUNT;
+	strWIDList[u32WidsCount].id = WID_RECEIVED_FRAGMENT_COUNT;
 	strWIDList[u32WidsCount].type = WID_INT;
 	strWIDList[u32WidsCount].s32ValueSize = sizeof(u32);
 	strWIDList[u32WidsCount].ps8WidVal = (s8 *)(&(dummyval));
 	u32WidsCount++;
 
-	strWIDList[u32WidsCount].u16WIDid = WID_FAILED_COUNT;
+	strWIDList[u32WidsCount].id = WID_FAILED_COUNT;
 	strWIDList[u32WidsCount].type = WID_INT;
 	strWIDList[u32WidsCount].s32ValueSize = sizeof(u32);
 	strWIDList[u32WidsCount].ps8WidVal = (s8 *)(&(dummyval));
@@ -1519,7 +1519,7 @@ static s32 Handle_Connect(struct host_if_drv *drvHandler,
 	/* (gWFiDrvHandle->strWILC_UsrConnReq.ConnReqIEsLen != 0)) */
 	{
 		/* IEs to be inserted in Association Request */
-		strWIDList[u32WidsCount].u16WIDid = WID_INFO_ELEMENT_ASSOCIATE;
+		strWIDList[u32WidsCount].id = WID_INFO_ELEMENT_ASSOCIATE;
 		strWIDList[u32WidsCount].type = WID_BIN_DATA;
 		strWIDList[u32WidsCount].ps8WidVal = pstrWFIDrv->strWILC_UsrConnReq.pu8ConnReqIEs;
 		strWIDList[u32WidsCount].s32ValueSize = pstrWFIDrv->strWILC_UsrConnReq.ConnReqIEsLen;
@@ -1533,7 +1533,7 @@ static s32 Handle_Connect(struct host_if_drv *drvHandler,
 			       gu32FlushedInfoElemAsocSize);
 		}
 	}
-	strWIDList[u32WidsCount].u16WIDid = (u16)WID_11I_MODE;
+	strWIDList[u32WidsCount].id = (u16)WID_11I_MODE;
 	strWIDList[u32WidsCount].type = WID_CHAR;
 	strWIDList[u32WidsCount].s32ValueSize = sizeof(char);
 	strWIDList[u32WidsCount].ps8WidVal = (s8 *)(&(pstrWFIDrv->strWILC_UsrConnReq.u8security));
@@ -1545,7 +1545,7 @@ static s32 Handle_Connect(struct host_if_drv *drvHandler,
 	PRINT_INFO(HOSTINF_DBG, "Encrypt Mode = %x\n", pstrWFIDrv->strWILC_UsrConnReq.u8security);
 
 
-	strWIDList[u32WidsCount].u16WIDid = (u16)WID_AUTH_TYPE;
+	strWIDList[u32WidsCount].id = (u16)WID_AUTH_TYPE;
 	strWIDList[u32WidsCount].type = WID_CHAR;
 	strWIDList[u32WidsCount].s32ValueSize = sizeof(char);
 	strWIDList[u32WidsCount].ps8WidVal = (s8 *)(&pstrWFIDrv->strWILC_UsrConnReq.tenuAuth_type);
@@ -1566,7 +1566,7 @@ static s32 Handle_Connect(struct host_if_drv *drvHandler,
 	PRINT_D(HOSTINF_DBG, "Connecting to network of SSID %s on channel %d\n",
 		pstrWFIDrv->strWILC_UsrConnReq.pu8ssid, pstrHostIFconnectAttr->u8channel);
 
-	strWIDList[u32WidsCount].u16WIDid = (u16)WID_JOIN_REQ_EXTENDED;
+	strWIDList[u32WidsCount].id = (u16)WID_JOIN_REQ_EXTENDED;
 	strWIDList[u32WidsCount].type = WID_STR;
 
 	/*Sending NoA attributes during connection*/
@@ -1813,13 +1813,13 @@ static s32 Handle_FlushConnect(struct host_if_drv *drvHandler)
 
 
 	/* IEs to be inserted in Association Request */
-	strWIDList[u32WidsCount].u16WIDid = WID_INFO_ELEMENT_ASSOCIATE;
+	strWIDList[u32WidsCount].id = WID_INFO_ELEMENT_ASSOCIATE;
 	strWIDList[u32WidsCount].type = WID_BIN_DATA;
 	strWIDList[u32WidsCount].ps8WidVal = gu8FlushedInfoElemAsoc;
 	strWIDList[u32WidsCount].s32ValueSize = gu32FlushedInfoElemAsocSize;
 	u32WidsCount++;
 
-	strWIDList[u32WidsCount].u16WIDid = (u16)WID_11I_MODE;
+	strWIDList[u32WidsCount].id = (u16)WID_11I_MODE;
 	strWIDList[u32WidsCount].type = WID_CHAR;
 	strWIDList[u32WidsCount].s32ValueSize = sizeof(char);
 	strWIDList[u32WidsCount].ps8WidVal = (s8 *)(&(gu8Flushed11iMode));
@@ -1827,13 +1827,13 @@ static s32 Handle_FlushConnect(struct host_if_drv *drvHandler)
 
 
 
-	strWIDList[u32WidsCount].u16WIDid = (u16)WID_AUTH_TYPE;
+	strWIDList[u32WidsCount].id = (u16)WID_AUTH_TYPE;
 	strWIDList[u32WidsCount].type = WID_CHAR;
 	strWIDList[u32WidsCount].s32ValueSize = sizeof(char);
 	strWIDList[u32WidsCount].ps8WidVal = (s8 *)(&gu8FlushedAuthType);
 	u32WidsCount++;
 
-	strWIDList[u32WidsCount].u16WIDid = (u16)WID_JOIN_REQ_EXTENDED;
+	strWIDList[u32WidsCount].id = (u16)WID_JOIN_REQ_EXTENDED;
 	strWIDList[u32WidsCount].type = WID_STR;
 	strWIDList[u32WidsCount].s32ValueSize = gu32FlushedJoinReqSize;
 	strWIDList[u32WidsCount].ps8WidVal = (s8 *)gu8FlushedJoinReq;
@@ -1918,7 +1918,7 @@ static s32 Handle_ConnectTimeout(struct host_if_drv *drvHandler)
 
 	/* Here we will notify our firmware also with the Connection failure {through sending to it Cfg packet carrying
 	 *   WID_DISCONNECT} */
-	strWID.u16WIDid = (u16)WID_DISCONNECT;
+	strWID.id = (u16)WID_DISCONNECT;
 	strWID.type = WID_CHAR;
 	strWID.ps8WidVal = (s8 *)&u16DummyReasonCode;
 	strWID.s32ValueSize = sizeof(char);
@@ -2425,17 +2425,17 @@ static int Handle_Key(struct host_if_drv *drvHandler,
 
 			PRINT_D(HOSTINF_DBG, "Handling WEP key\n");
 			PRINT_D(GENERIC_DBG, "ID Hostint is %d\n", (pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFwepAttr.u8Wepidx));
-			strWIDList[0].u16WIDid = (u16)WID_11I_MODE;
+			strWIDList[0].id = (u16)WID_11I_MODE;
 			strWIDList[0].type = WID_CHAR;
 			strWIDList[0].s32ValueSize = sizeof(char);
 			strWIDList[0].ps8WidVal = (s8 *)(&(pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFwepAttr.u8mode));
 
-			strWIDList[1].u16WIDid     = WID_AUTH_TYPE;
+			strWIDList[1].id = WID_AUTH_TYPE;
 			strWIDList[1].type = WID_CHAR;
 			strWIDList[1].s32ValueSize = sizeof(char);
 			strWIDList[1].ps8WidVal = (s8 *)(&(pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFwepAttr.tenuAuth_type));
 
-			strWIDList[2].u16WIDid	= (u16)WID_KEY_ID;
+			strWIDList[2].id = (u16)WID_KEY_ID;
 			strWIDList[2].type = WID_CHAR;
 
 			strWIDList[2].ps8WidVal	= (s8 *)(&(pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFwepAttr.u8Wepidx));
@@ -2456,7 +2456,7 @@ static int Handle_Key(struct host_if_drv *drvHandler,
 
 			kfree(pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFwepAttr.pu8WepKey);
 
-			strWIDList[3].u16WIDid = (u16)WID_WEP_KEY_VALUE;
+			strWIDList[3].id = (u16)WID_WEP_KEY_VALUE;
 			strWIDList[3].type = WID_STR;
 			strWIDList[3].s32ValueSize = pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFwepAttr.u8WepKeylen;
 			strWIDList[3].ps8WidVal = (s8 *)pu8keybuf;
@@ -2485,7 +2485,7 @@ static int Handle_Key(struct host_if_drv *drvHandler,
 
 			kfree(pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFwepAttr.pu8WepKey);
 
-			strWID.u16WIDid	= (u16)WID_ADD_WEP_KEY;
+			strWID.id = (u16)WID_ADD_WEP_KEY;
 			strWID.type = WID_STR;
 			strWID.ps8WidVal	= (s8 *)pu8keybuf;
 			strWID.s32ValueSize = pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFwepAttr.u8WepKeylen + 2;
@@ -2496,7 +2496,7 @@ static int Handle_Key(struct host_if_drv *drvHandler,
 		} else if (pstrHostIFkeyAttr->u8KeyAction & REMOVEKEY)	  {
 
 			PRINT_D(HOSTINF_DBG, "Removing key\n");
-			strWID.u16WIDid	= (u16)WID_REMOVE_WEP_KEY;
+			strWID.id = (u16)WID_REMOVE_WEP_KEY;
 			strWID.type = WID_STR;
 
 			s8idxarray[0] = (s8)pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFwepAttr.u8Wepidx;
@@ -2506,7 +2506,7 @@ static int Handle_Key(struct host_if_drv *drvHandler,
 			s32Error = send_config_pkt(SET_CFG, &strWID, 1,
 						   get_id_from_handler(pstrWFIDrv));
 		} else {
-			strWID.u16WIDid	= (u16)WID_KEY_ID;
+			strWID.id = (u16)WID_KEY_ID;
 			strWID.type = WID_CHAR;
 			strWID.ps8WidVal	= (s8 *)(&(pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFwepAttr.u8Wepidx));
 			strWID.s32ValueSize = sizeof(char);
@@ -2549,12 +2549,12 @@ static int Handle_Key(struct host_if_drv *drvHandler,
 			memcpy(pu8keybuf + 16, pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFwpaAttr.pu8key,
 				    pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFwpaAttr.u8Keylen);
 			/* pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFwpaAttr.u8Ciphermode =  0X51; */
-			strWIDList[0].u16WIDid = (u16)WID_11I_MODE;
+			strWIDList[0].id = (u16)WID_11I_MODE;
 			strWIDList[0].type = WID_CHAR;
 			strWIDList[0].s32ValueSize = sizeof(char);
 			strWIDList[0].ps8WidVal = (s8 *)(&(pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFwpaAttr.u8Ciphermode));
 
-			strWIDList[1].u16WIDid	= (u16)WID_ADD_RX_GTK;
+			strWIDList[1].id = (u16)WID_ADD_RX_GTK;
 			strWIDList[1].type = WID_STR;
 			strWIDList[1].ps8WidVal	= (s8 *)pu8keybuf;
 			strWIDList[1].s32ValueSize = RX_MIC_KEY_MSG_LEN;
@@ -2600,7 +2600,7 @@ static int Handle_Key(struct host_if_drv *drvHandler,
 			memcpy(pu8keybuf + 16, pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFwpaAttr.pu8key,
 				    pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFwpaAttr.u8Keylen);
 
-			strWID.u16WIDid	= (u16)WID_ADD_RX_GTK;
+			strWID.id = (u16)WID_ADD_RX_GTK;
 			strWID.type = WID_STR;
 			strWID.ps8WidVal	= (s8 *)pu8keybuf;
 			strWID.s32ValueSize = RX_MIC_KEY_MSG_LEN;
@@ -2652,12 +2652,12 @@ _WPARxGtk_end_case_:
 				    pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFwpaAttr.u8Keylen);
 
 
-			strWIDList[0].u16WIDid = (u16)WID_11I_MODE;
+			strWIDList[0].id = (u16)WID_11I_MODE;
 			strWIDList[0].type = WID_CHAR;
 			strWIDList[0].s32ValueSize = sizeof(char);
 			strWIDList[0].ps8WidVal = (s8 *)(&(pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFwpaAttr.u8Ciphermode));
 
-			strWIDList[1].u16WIDid	= (u16)WID_ADD_PTK;
+			strWIDList[1].id = (u16)WID_ADD_PTK;
 			strWIDList[1].type = WID_STR;
 			strWIDList[1].ps8WidVal	= (s8 *)pu8keybuf;
 			strWIDList[1].s32ValueSize = PTK_KEY_MSG_LEN + 1;
@@ -2698,7 +2698,7 @@ _WPARxGtk_end_case_:
 				    pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFwpaAttr.u8Keylen);
 
 
-			strWID.u16WIDid	= (u16)WID_ADD_PTK;
+			strWID.id = (u16)WID_ADD_PTK;
 			strWID.type = WID_STR;
 			strWID.ps8WidVal	= (s8 *)pu8keybuf;
 			strWID.s32ValueSize = PTK_KEY_MSG_LEN;
@@ -2738,7 +2738,7 @@ _WPAPtk_end_case_:
 			memcpy(pu8keybuf + ((PMKSA_KEY_LEN * i) + ETH_ALEN + 1), pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFpmkidAttr.pmkidlist[i].pmkid, PMKID_LEN);
 		}
 
-		strWID.u16WIDid	= (u16)WID_PMKID_INFO;
+		strWID.id = (u16)WID_PMKID_INFO;
 		strWID.type = WID_STR;
 		strWID.ps8WidVal = (s8 *)pu8keybuf;
 		strWID.s32ValueSize = (pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFpmkidAttr.numpmkid * PMKSA_KEY_LEN) + 1;
@@ -2776,7 +2776,7 @@ static void Handle_Disconnect(struct host_if_drv *drvHandler)
 	struct host_if_drv *pstrWFIDrv = (struct host_if_drv *)drvHandler;
 
 
-	strWID.u16WIDid = (u16)WID_DISCONNECT;
+	strWID.id = (u16)WID_DISCONNECT;
 	strWID.type = WID_CHAR;
 	strWID.ps8WidVal = (s8 *)&u16DummyReasonCode;
 	strWID.s32ValueSize = sizeof(char);
@@ -2900,7 +2900,7 @@ static s32 Handle_GetChnl(struct host_if_drv *drvHandler)
 	struct wid strWID;
 	struct host_if_drv *pstrWFIDrv = (struct host_if_drv *)drvHandler;
 
-	strWID.u16WIDid = (u16)WID_CURRENT_CHANNEL;
+	strWID.id = (u16)WID_CURRENT_CHANNEL;
 	strWID.type = WID_CHAR;
 	strWID.ps8WidVal = (s8 *)&gu8Chnl;
 	strWID.s32ValueSize = sizeof(char);
@@ -2939,7 +2939,7 @@ static void Handle_GetRssi(struct host_if_drv *drvHandler)
 	struct wid strWID;
 	struct host_if_drv *pstrWFIDrv = (struct host_if_drv *)drvHandler;
 
-	strWID.u16WIDid = (u16)WID_RSSI;
+	strWID.id = (u16)WID_RSSI;
 	strWID.type = WID_CHAR;
 	strWID.ps8WidVal = &gs8Rssi;
 	strWID.s32ValueSize = sizeof(char);
@@ -2968,7 +2968,7 @@ static void Handle_GetLinkspeed(struct host_if_drv *drvHandler)
 
 	gs8lnkspd = 0;
 
-	strWID.u16WIDid = (u16)WID_LINKSPEED;
+	strWID.id = (u16)WID_LINKSPEED;
 	strWID.type = WID_CHAR;
 	strWID.ps8WidVal = &gs8lnkspd;
 	strWID.s32ValueSize = sizeof(char);
@@ -2992,31 +2992,31 @@ s32 Handle_GetStatistics(struct host_if_drv *drvHandler, tstrStatistics *pstrSta
 	struct wid strWIDList[5];
 	u32 u32WidsCount = 0, s32Error = 0;
 
-	strWIDList[u32WidsCount].u16WIDid = WID_LINKSPEED;
+	strWIDList[u32WidsCount].id = WID_LINKSPEED;
 	strWIDList[u32WidsCount].type = WID_CHAR;
 	strWIDList[u32WidsCount].s32ValueSize = sizeof(char);
 	strWIDList[u32WidsCount].ps8WidVal = (s8 *)(&(pstrStatistics->u8LinkSpeed));
 	u32WidsCount++;
 
-	strWIDList[u32WidsCount].u16WIDid = WID_RSSI;
+	strWIDList[u32WidsCount].id = WID_RSSI;
 	strWIDList[u32WidsCount].type = WID_CHAR;
 	strWIDList[u32WidsCount].s32ValueSize = sizeof(char);
 	strWIDList[u32WidsCount].ps8WidVal = (s8 *)(&(pstrStatistics->s8RSSI));
 	u32WidsCount++;
 
-	strWIDList[u32WidsCount].u16WIDid = WID_SUCCESS_FRAME_COUNT;
+	strWIDList[u32WidsCount].id = WID_SUCCESS_FRAME_COUNT;
 	strWIDList[u32WidsCount].type = WID_INT;
 	strWIDList[u32WidsCount].s32ValueSize = sizeof(u32);
 	strWIDList[u32WidsCount].ps8WidVal = (s8 *)(&(pstrStatistics->u32TxCount));
 	u32WidsCount++;
 
-	strWIDList[u32WidsCount].u16WIDid = WID_RECEIVED_FRAGMENT_COUNT;
+	strWIDList[u32WidsCount].id = WID_RECEIVED_FRAGMENT_COUNT;
 	strWIDList[u32WidsCount].type = WID_INT;
 	strWIDList[u32WidsCount].s32ValueSize = sizeof(u32);
 	strWIDList[u32WidsCount].ps8WidVal = (s8 *)(&(pstrStatistics->u32RxCount));
 	u32WidsCount++;
 
-	strWIDList[u32WidsCount].u16WIDid = WID_FAILED_COUNT;
+	strWIDList[u32WidsCount].id = WID_FAILED_COUNT;
 	strWIDList[u32WidsCount].type = WID_INT;
 	strWIDList[u32WidsCount].s32ValueSize = sizeof(u32);
 	strWIDList[u32WidsCount].ps8WidVal = (s8 *)(&(pstrStatistics->u32TxFailureCount));
@@ -3054,7 +3054,7 @@ static s32 Handle_Get_InActiveTime(struct host_if_drv *drvHandler,
 	struct host_if_drv *pstrWFIDrv = (struct host_if_drv *)drvHandler;
 
 
-	strWID.u16WIDid = (u16)WID_SET_STA_MAC_INACTIVE_TIME;
+	strWID.id = (u16)WID_SET_STA_MAC_INACTIVE_TIME;
 	strWID.type = WID_STR;
 	strWID.s32ValueSize = ETH_ALEN;
 	strWID.ps8WidVal = kmalloc(strWID.s32ValueSize, GFP_KERNEL);
@@ -3076,7 +3076,7 @@ static s32 Handle_Get_InActiveTime(struct host_if_drv *drvHandler,
 	}
 
 
-	strWID.u16WIDid = (u16)WID_GET_INACTIVE_TIME;
+	strWID.id = (u16)WID_GET_INACTIVE_TIME;
 	strWID.type = WID_INT;
 	strWID.ps8WidVal = (s8 *)&gu32InactiveTime;
 	strWID.s32ValueSize = sizeof(u32);
@@ -3121,7 +3121,7 @@ static void Handle_AddBeacon(struct host_if_drv *drvHandler,
 
 	PRINT_D(HOSTINF_DBG, "Adding BEACON\n");
 
-	strWID.u16WIDid = (u16)WID_ADD_BEACON;
+	strWID.id = (u16)WID_ADD_BEACON;
 	strWID.type = WID_BIN;
 	strWID.s32ValueSize = pstrSetBeaconParam->u32HeadLen + pstrSetBeaconParam->u32TailLen + 16;
 	strWID.ps8WidVal = kmalloc(strWID.s32ValueSize, GFP_KERNEL);
@@ -3187,7 +3187,7 @@ static void Handle_DelBeacon(struct host_if_drv *drvHandler)
 	u8 *pu8CurrByte;
 	struct host_if_drv *pstrWFIDrv = (struct host_if_drv *)drvHandler;
 
-	strWID.u16WIDid = (u16)WID_DEL_BEACON;
+	strWID.id = (u16)WID_DEL_BEACON;
 	strWID.type = WID_CHAR;
 	strWID.s32ValueSize = sizeof(char);
 	strWID.ps8WidVal = &gu8DelBcn;
@@ -3281,7 +3281,7 @@ static void Handle_AddStation(struct host_if_drv *drvHandler,
 	struct host_if_drv *pstrWFIDrv = (struct host_if_drv *)drvHandler;
 
 	PRINT_D(HOSTINF_DBG, "Handling add station\n");
-	strWID.u16WIDid = (u16)WID_ADD_STA;
+	strWID.id = (u16)WID_ADD_STA;
 	strWID.type = WID_BIN;
 	strWID.s32ValueSize = WILC_ADD_STA_LENGTH + pstrStationParam->u8NumRates;
 
@@ -3323,7 +3323,7 @@ static void Handle_DelAllSta(struct host_if_drv *drvHandler,
 	u8 i;
 	u8 au8Zero_Buff[6] = {0};
 
-	strWID.u16WIDid = (u16)WID_DEL_ALL_STA;
+	strWID.id = (u16)WID_DEL_ALL_STA;
 	strWID.type = WID_STR;
 	strWID.s32ValueSize = (pstrDelAllStaParam->u8Num_AssocSta * ETH_ALEN) + 1;
 
@@ -3376,7 +3376,7 @@ static void Handle_DelStation(struct host_if_drv *drvHandler,
 	u8 *pu8CurrByte;
 	struct host_if_drv *pstrWFIDrv = (struct host_if_drv *)drvHandler;
 
-	strWID.u16WIDid = (u16)WID_REMOVE_STA;
+	strWID.id = (u16)WID_REMOVE_STA;
 	strWID.type = WID_BIN;
 	strWID.s32ValueSize = ETH_ALEN;
 
@@ -3418,7 +3418,7 @@ static void Handle_EditStation(struct host_if_drv *drvHandler,
 	u8 *pu8CurrByte;
 	struct host_if_drv *pstrWFIDrv = (struct host_if_drv *)drvHandler;
 
-	strWID.u16WIDid = (u16)WID_EDIT_STA;
+	strWID.id = (u16)WID_EDIT_STA;
 	strWID.type = WID_BIN;
 	strWID.s32ValueSize = WILC_ADD_STA_LENGTH + pstrStationParam->u8NumRates;
 
@@ -3491,7 +3491,7 @@ static int Handle_RemainOnChan(struct host_if_drv *drvHandler,
 	PRINT_D(HOSTINF_DBG, "Setting channel :%d\n", pstrHostIfRemainOnChan->u16Channel);
 
 	u8remain_on_chan_flag = true;
-	strWID.u16WIDid	= (u16)WID_REMAIN_ON_CHAN;
+	strWID.id = (u16)WID_REMAIN_ON_CHAN;
 	strWID.type = WID_STR;
 	strWID.s32ValueSize = 2;
 	strWID.ps8WidVal = kmalloc(strWID.s32ValueSize, GFP_KERNEL);
@@ -3548,7 +3548,7 @@ static int Handle_RegisterFrame(struct host_if_drv *drvHandler,
 	PRINT_D(HOSTINF_DBG, "Handling frame register Flag : %d FrameType: %d\n", pstrHostIfRegisterFrame->bReg, pstrHostIfRegisterFrame->u16FrameType);
 
 	/*prepare configuration packet*/
-	strWID.u16WIDid = (u16)WID_REGISTER_FRAME;
+	strWID.id = (u16)WID_REGISTER_FRAME;
 	strWID.type = WID_STR;
 	strWID.ps8WidVal = kmalloc(sizeof(u16) + 2, GFP_KERNEL);
 	if (strWID.ps8WidVal == NULL)
@@ -3600,7 +3600,7 @@ static u32 Handle_ListenStateExpired(struct host_if_drv *drvHandler,
 	/*This is to handle duplicate expiry messages (listen timer fired and supplicant called cancel_remain_on_channel())*/
 	if (P2P_LISTEN_STATE) {
 		u8remain_on_chan_flag = false;
-		strWID.u16WIDid	= (u16)WID_REMAIN_ON_CHAN;
+		strWID.id = (u16)WID_REMAIN_ON_CHAN;
 		strWID.type = WID_STR;
 		strWID.s32ValueSize = 2;
 		strWID.ps8WidVal = kmalloc(strWID.s32ValueSize, GFP_KERNEL);
@@ -3680,7 +3680,7 @@ static void Handle_PowerManagement(struct host_if_drv *drvHandler,
 	s8 s8PowerMode;
 	struct host_if_drv *pstrWFIDrv = (struct host_if_drv *)drvHandler;
 
-	strWID.u16WIDid = (u16)WID_POWER_MANAGEMENT;
+	strWID.id = (u16)WID_POWER_MANAGEMENT;
 
 	if (strPowerMgmtParam->bIsEnabled == true)
 		s8PowerMode = MIN_FAST_PS;
@@ -3717,7 +3717,7 @@ static void Handle_SetMulticastFilter(struct host_if_drv *drvHandler,
 
 	PRINT_D(HOSTINF_DBG, "Setup Multicast Filter\n");
 
-	strWID.u16WIDid = (u16)WID_SETUP_MULTICAST_FILTER;
+	strWID.id = (u16)WID_SETUP_MULTICAST_FILTER;
 	strWID.type = WID_BIN;
 	strWID.s32ValueSize = sizeof(struct set_multicast) + ((strHostIfSetMulti->u32count) * ETH_ALEN);
 	strWID.ps8WidVal = kmalloc(strWID.s32ValueSize, GFP_KERNEL);
@@ -3776,7 +3776,7 @@ static s32 Handle_AddBASession(struct host_if_drv *drvHandler,
 		strHostIfBASessionInfo->u16SessionTimeout,
 		strHostIfBASessionInfo->u8Ted);
 
-	strWID.u16WIDid = (u16)WID_11E_P_ACTION_REQ;
+	strWID.id = (u16)WID_11E_P_ACTION_REQ;
 	strWID.type = WID_STR;
 	strWID.ps8WidVal = kmalloc(BLOCK_ACK_REQ_SIZE, GFP_KERNEL);
 	strWID.s32ValueSize = BLOCK_ACK_REQ_SIZE;
@@ -3810,7 +3810,7 @@ static s32 Handle_AddBASession(struct host_if_drv *drvHandler,
 		PRINT_D(HOSTINF_DBG, "Couldn't open BA Session\n");
 
 
-	strWID.u16WIDid = (u16)WID_11E_P_ACTION_REQ;
+	strWID.id = (u16)WID_11E_P_ACTION_REQ;
 	strWID.type = WID_STR;
 	strWID.s32ValueSize = 15;
 	ptr = strWID.ps8WidVal;
@@ -3862,7 +3862,7 @@ static s32 Handle_DelAllRxBASessions(struct host_if_drv *drvHandler,
 		strHostIfBASessionInfo->au8Bssid[2],
 		strHostIfBASessionInfo->u8Ted);
 
-	strWID.u16WIDid = (u16)WID_DEL_ALL_RX_BA;
+	strWID.id = (u16)WID_DEL_ALL_RX_BA;
 	strWID.type = WID_STR;
 	strWID.ps8WidVal = kmalloc(BLOCK_ACK_REQ_SIZE, GFP_KERNEL);
 	strWID.s32ValueSize = BLOCK_ACK_REQ_SIZE;
@@ -4161,7 +4161,7 @@ s32 host_int_remove_key(struct host_if_drv *hWFIDrv, const u8 *pu8StaAddress)
 {
 	struct wid strWID;
 
-	strWID.u16WIDid	= (u16)WID_REMOVE_KEY;
+	strWID.id = (u16)WID_REMOVE_KEY;
 	strWID.type = WID_STR;
 	strWID.ps8WidVal	= (s8 *)pu8StaAddress;
 	strWID.s32ValueSize = 6;
@@ -4678,7 +4678,7 @@ s32 host_int_get_pmkid_info(struct host_if_drv *hWFIDrv, u8 *pu8PmkidInfoArray,
 {
 	struct wid strWID;
 
-	strWID.u16WIDid	= (u16)WID_PMKID_INFO;
+	strWID.id = (u16)WID_PMKID_INFO;
 	strWID.type = WID_STR;
 	strWID.s32ValueSize = u32PmkidInfoLen;
 	strWID.ps8WidVal = pu8PmkidInfoArray;
@@ -4707,7 +4707,7 @@ s32 host_int_set_RSNAConfigPSKPassPhrase(struct host_if_drv *hWFIDrv, u8 *pu8Pas
 
 	/*validating psk length*/
 	if ((u8Psklength > 7) && (u8Psklength < 65)) {
-		strWID.u16WIDid	= (u16)WID_11I_PSK;
+		strWID.id = (u16)WID_11I_PSK;
 		strWID.type = WID_STR;
 		strWID.ps8WidVal	= pu8PassPhrase;
 		strWID.s32ValueSize = u8Psklength;
@@ -4800,7 +4800,7 @@ s32 host_int_get_RSNAConfigPSKPassPhrase(struct host_if_drv *hWFIDrv,
 {
 	struct wid strWID;
 
-	strWID.u16WIDid	= (u16)WID_11I_PSK;
+	strWID.id = (u16)WID_11I_PSK;
 	strWID.type = WID_STR;
 	strWID.s32ValueSize = u8Psklength;
 	strWID.ps8WidVal	= pu8PassPhrase;
@@ -4827,7 +4827,7 @@ s32 host_int_set_start_scan_req(struct host_if_drv *hWFIDrv, u8 scanSource)
 {
 	struct wid strWID;
 
-	strWID.u16WIDid = (u16)WID_START_SCAN_REQ;
+	strWID.id = (u16)WID_START_SCAN_REQ;
 	strWID.type = WID_CHAR;
 	strWID.ps8WidVal = (s8 *)&scanSource;
 	strWID.s32ValueSize = sizeof(char);
@@ -4855,7 +4855,7 @@ s32 host_int_get_start_scan_req(struct host_if_drv *hWFIDrv, u8 *pu8ScanSource)
 {
 	struct wid strWID;
 
-	strWID.u16WIDid = (u16)WID_START_SCAN_REQ;
+	strWID.id = (u16)WID_START_SCAN_REQ;
 	strWID.type = WID_CHAR;
 	strWID.ps8WidVal = (s8 *)pu8ScanSource;
 	strWID.s32ValueSize = sizeof(char);
@@ -5052,7 +5052,7 @@ s32 host_int_disconnect_station(struct host_if_drv *hWFIDrv, u8 assoc_id)
 {
 	struct wid strWID;
 
-	strWID.u16WIDid = (u16)WID_DISCONNECT;
+	strWID.id = (u16)WID_DISCONNECT;
 	strWID.type = WID_CHAR;
 	strWID.ps8WidVal = (s8 *)&assoc_id;
 	strWID.s32ValueSize = sizeof(char);
@@ -5091,7 +5091,7 @@ s32 host_int_get_assoc_req_info(struct host_if_drv *hWFIDrv, u8 *pu8AssocReqInfo
 {
 	struct wid strWID;
 
-	strWID.u16WIDid = (u16)WID_ASSOC_REQ_INFO;
+	strWID.id = (u16)WID_ASSOC_REQ_INFO;
 	strWID.type = WID_STR;
 	strWID.ps8WidVal = pu8AssocReqInfo;
 	strWID.s32ValueSize = u32AssocReqInfoLen;
@@ -5122,7 +5122,7 @@ s32 host_int_get_assoc_res_info(struct host_if_drv *hWFIDrv, u8 *pu8AssocRespInf
 		return -EFAULT;
 	}
 
-	strWID.u16WIDid = (u16)WID_ASSOC_RES_INFO;
+	strWID.id = (u16)WID_ASSOC_RES_INFO;
 	strWID.type = WID_STR;
 	strWID.ps8WidVal = pu8AssocRespInfo;
 	strWID.s32ValueSize = u32MaxAssocRespInfoLen;
@@ -5162,7 +5162,7 @@ s32 host_int_get_rx_power_level(struct host_if_drv *hWFIDrv, u8 *pu8RxPowerLevel
 {
 	struct wid strWID;
 
-	strWID.u16WIDid = (u16)WID_RX_POWER_LEVEL;
+	strWID.id = (u16)WID_RX_POWER_LEVEL;
 	strWID.type = WID_STR;
 	strWID.ps8WidVal = pu8RxPowerLevel;
 	strWID.s32ValueSize = u32RxPowerLevelLen;
@@ -5388,7 +5388,7 @@ s32 host_int_test_get_int_wid(struct host_if_drv *hWFIDrv, u32 *pu32TestMemAddr)
 		return -EFAULT;
 	}
 
-	strWID.u16WIDid = (u16)WID_MEMORY_ADDRESS;
+	strWID.id = (u16)WID_MEMORY_ADDRESS;
 	strWID.type = WID_INT;
 	strWID.ps8WidVal = (s8 *)pu32TestMemAddr;
 	strWID.s32ValueSize = sizeof(u32);
-- 
1.9.1

