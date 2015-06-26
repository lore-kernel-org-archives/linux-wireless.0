Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f46.google.com ([74.125.82.46]:36469 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752442AbbFZOjK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Jun 2015 10:39:10 -0400
Date: Fri, 26 Jun 2015 16:45:14 +0200
From: Luis de Bethencourt <luis@debethencourt.com>
To: linux-kernel@vger.kernel.org
Cc: Johnny Kim <johnny.kim@atmel.com>,
	Rachel Kim <rachel.kim@atmel.com>,
	Dean Lee <dean.lee@atmel.com>,
	Chris Park <chris.park@atmel.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org
Subject: [PATCH 2/4] staging: wilc1000: add blank lines after declarations
Message-ID: <20150626144512.GA29980@goodgumbo.baconseed.org> (sfid-20150626_163913_574333_0C0D58B1)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix all checkpatch.pl warnings:
WARNING: Missing a blank line after declarations

Signed-off-by: Luis de Bethencourt <luis@debethencourt.com>
---
 drivers/staging/wilc1000/host_interface.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index bf183b2..e13074f 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -841,6 +841,7 @@ static s32 Handle_SetMacAddress(void *drvHandler, tstrHostIfSetMacAddress *pstrH
 	tstrWID	strWID;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)drvHandler;
 	u8 *mac_buf = (u8 *)WILC_MALLOC(ETH_ALEN);
+
 	if (mac_buf == NULL) {
 		PRINT_ER("No buffer to send mac address\n");
 		return WILC_FAIL;
@@ -1225,6 +1226,7 @@ static s32 Handle_CfgParam(void *drvHandler, tstrHostIFCfgParamAttr *strHostIFCf
 static s32 Handle_wait_msg_q_empty(void)
 {
 	s32 s32Error = WILC_SUCCESS;
+
 	g_wilc_initialized = 0;
 	up(&hWaitResponse);
 	return s32Error;
@@ -2357,6 +2359,7 @@ static s32 Handle_RcvdGnrlAsyncInfo(void *drvHandler, tstrRcvdGnrlAsyncInfo *pst
 	tstrDisconnectNotifInfo strDisconnectNotifInfo;
 	s32 s32Err = WILC_SUCCESS;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *) drvHandler;
+
 	if (pstrWFIDrv == NULL)
 		PRINT_ER("Driver handler is NULL\n");
 	PRINT_D(GENERIC_DBG, "Current State = %d,Received state = %d\n", pstrWFIDrv->enuHostIFstate,
@@ -3208,6 +3211,7 @@ static s32 Handle_GetChnl(void *drvHandler)
 	tstrWID	strWID;
 	/* tstrWILC_WFIDrv * pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv; */
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)drvHandler;
+
 	strWID.u16WIDid = (u16)WID_CURRENT_CHANNEL;
 	strWID.enuWIDtype = WID_CHAR;
 	strWID.ps8WidVal = (s8 *)&gu8Chnl;
@@ -3441,6 +3445,7 @@ static void Handle_AddBeacon(void *drvHandler, tstrHostIFSetBeacon *pstrSetBeaco
 	tstrWID strWID;
 	u8 *pu8CurrByte;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)drvHandler;
+
 	PRINT_D(HOSTINF_DBG, "Adding BEACON\n");
 
 	strWID.u16WIDid = (u16)WID_ADD_BEACON;
@@ -3512,6 +3517,7 @@ static void Handle_DelBeacon(void *drvHandler, tstrHostIFDelBeacon *pstrDelBeaco
 	tstrWID strWID;
 	u8 *pu8CurrByte;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)drvHandler;
+
 	strWID.u16WIDid = (u16)WID_DEL_BEACON;
 	strWID.enuWIDtype = WID_CHAR;
 	strWID.s32ValueSize = sizeof(char);
@@ -3608,6 +3614,7 @@ static void Handle_AddStation(void *drvHandler, tstrWILC_AddStaParam *pstrStatio
 	tstrWID strWID;
 	u8 *pu8CurrByte;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)drvHandler;
+
 	PRINT_D(HOSTINF_DBG, "Handling add station\n");
 	strWID.u16WIDid = (u16)WID_ADD_STA;
 	strWID.enuWIDtype = WID_BIN;
@@ -3647,11 +3654,13 @@ static void Handle_AddStation(void *drvHandler, tstrWILC_AddStaParam *pstrStatio
 static void Handle_DelAllSta(void *drvHandler, tstrHostIFDelAllSta *pstrDelAllStaParam)
 {
 	s32 s32Error = WILC_SUCCESS;
+
 	tstrWID strWID;
 	u8 *pu8CurrByte;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)drvHandler;
 	u8 i;
 	u8 au8Zero_Buff[6] = {0};
+
 	strWID.u16WIDid = (u16)WID_DEL_ALL_STA;
 	strWID.enuWIDtype = WID_STR;
 	strWID.s32ValueSize = (pstrDelAllStaParam->u8Num_AssocSta * ETH_ALEN) + 1;
@@ -4019,6 +4028,7 @@ static void Handle_PowerManagement(void *drvHandler, tstrHostIfPowerMgmtParam *s
 	tstrWID strWID;
 	s8 s8PowerMode;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)drvHandler;
+
 	strWID.u16WIDid = (u16)WID_POWER_MANAGEMENT;
 
 	if (strPowerMgmtParam->bIsEnabled == true)	{
@@ -4864,6 +4874,7 @@ s32 host_int_add_ptk(WILC_WFIDrvHandle hWFIDrv, const u8 *pu8Ptk, u8 u8PtkKeylen
 	tstrHostIFmsg strHostIFmsg;
 	u8 u8KeyLen = u8PtkKeylen;
 	u32 i;
+
 	if (pstrWFIDrv == NULL)
 		WILC_ERRORREPORT(s32Error, WILC_INVALID_ARGUMENT);
 	if (pu8RxMic != NULL)
@@ -6421,6 +6432,7 @@ void host_int_send_join_leave_info_to_host
 void GetPeriodicRSSI(void *pvArg)
 {
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)pvArg;
+
 	if (pstrWFIDrv == NULL)	{
 		PRINT_ER("Driver handler is NULL\n");
 		return;
@@ -6900,6 +6912,7 @@ void host_int_ScanCompleteReceived(u8 *pu8Buffer, u32 u32Length)
 	tstrHostIFmsg strHostIFmsg;
 	u32 drvHandler;
 	tstrWILC_WFIDrv *pstrWFIDrv = NULL;
+
 	drvHandler = ((pu8Buffer[u32Length - 4]) | (pu8Buffer[u32Length - 3] << 8) | (pu8Buffer[u32Length - 2] << 16) | (pu8Buffer[u32Length - 1] << 24));
 	pstrWFIDrv = (tstrWILC_WFIDrv *)drvHandler;
 
@@ -7216,6 +7229,7 @@ s32 host_int_add_station(WILC_WFIDrvHandle hWFIDrv, tstrWILC_AddStaParam *pstrSt
 	WILC_memcpy(pstrAddStationMsg, pstrStaParams, sizeof(tstrWILC_AddStaParam));
 	if (pstrAddStationMsg->u8NumRates > 0) {
 		u8 *rates = WILC_MALLOC(pstrAddStationMsg->u8NumRates);
+
 		WILC_NULLCHECK(s32Error, rates);
 
 		WILC_memcpy(rates, pstrStaParams->pu8Rates, pstrAddStationMsg->u8NumRates);
@@ -7370,6 +7384,7 @@ s32 host_int_edit_station(WILC_WFIDrvHandle hWFIDrv, tstrWILC_AddStaParam *pstrS
 	WILC_memcpy(pstrAddStationMsg, pstrStaParams, sizeof(tstrWILC_AddStaParam));
 	if (pstrAddStationMsg->u8NumRates > 0) {
 		u8 *rates = WILC_MALLOC(pstrAddStationMsg->u8NumRates);
+
 		WILC_NULLCHECK(s32Error, rates);
 		WILC_memcpy(rates, pstrStaParams->pu8Rates, pstrAddStationMsg->u8NumRates);
 		pstrAddStationMsg->pu8Rates = rates;
@@ -7563,6 +7578,7 @@ static void *host_int_ParseJoinBssParam(tstrNetworkInfo *ptstrNetworkInfo)
 				 (pu8IEs[index + 4] == 0x9a) && /* OUI */
 				 (pu8IEs[index + 5] == 0x09) && (pu8IEs[index + 6] == 0x0c)) { /* OUI Type     */
 				u16 u16P2P_count;
+
 				pNewJoinBssParam->tsf = ptstrNetworkInfo->u32Tsf;
 				pNewJoinBssParam->u8NoaEnbaled = 1;
 				pNewJoinBssParam->u8Index = pu8IEs[index + 9];
-- 
2.1.4

