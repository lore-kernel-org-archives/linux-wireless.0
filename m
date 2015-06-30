Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:38697 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753143AbbF3Igb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Jun 2015 04:36:31 -0400
From: Dean Lee <dean.lee@atmel.com>
To: <gregkh@linuxfoundation.org>, <devel@driverdev.osuosl.org>,
	<linux-wireless@vger.kernel.org>
CC: <johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <dean.lee@atmel.com>,
	<nicolas.ferre@atmel.com>
Subject: [PATCH 6/6] staging: wilc1000: delete unused value.
Date: Tue, 30 Jun 2015 17:34:38 +0900
Message-ID: <1435653278-5168-6-git-send-email-dean.lee@atmel.com> (sfid-20150630_103640_447856_6DCDD604)
In-Reply-To: <1435653278-5168-1-git-send-email-dean.lee@atmel.com>
References: <1435653278-5168-1-git-send-email-dean.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Dean Lee <dean.lee@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 52 -------------------------------
 drivers/staging/wilc1000/linux_wlan.c     |  2 +-
 2 files changed, 1 insertion(+), 53 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index a2e9b6d..1a4e037 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -609,7 +609,6 @@ static s32 Handle_SetChannel(void *drvHandler, tstrHostIFSetChan *pstrHostIFSetC
 
 	s32 s32Error = WILC_SUCCESS;
 	tstrWID	strWID;
-	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)drvHandler;
 
 	/*prepare configuration packet*/
 	strWID.u16WIDid = (u16)WID_CURRENT_CHANNEL;
@@ -735,7 +734,6 @@ s32 Handle_set_IPAddress(void *drvHandler, u8 *pu8IPAddr, u8 idx)
 	s32 s32Error = WILC_SUCCESS;
 	tstrWID strWID;
 	char firmwareIPAddress[4] = {0};
-	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)drvHandler;
 
 	if (pu8IPAddr[0] < 192)
 		pu8IPAddr[0] = 0;
@@ -839,7 +837,6 @@ static s32 Handle_SetMacAddress(void *drvHandler, tstrHostIfSetMacAddress *pstrH
 
 	s32 s32Error = WILC_SUCCESS;
 	tstrWID	strWID;
-	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)drvHandler;
 	u8 *mac_buf = (u8 *)WILC_MALLOC(ETH_ALEN);
 	if (mac_buf == NULL) {
 		PRINT_ER("No buffer to send mac address\n");
@@ -3178,7 +3175,6 @@ static s32 Switch_Log_Terminal(void *drvHandler)
 	s32 s32Error = WILC_SUCCESS;
 	tstrWID strWID;
 	static char dummy = 9;
-	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)drvHandler;
 
 	strWID.u16WIDid = (u16)WID_LOGTerminal_Switch;
 	strWID.enuWIDtype = WID_CHAR;
@@ -3220,7 +3216,6 @@ static s32 Handle_GetChnl(void *drvHandler)
 
 	s32 s32Error = WILC_SUCCESS;
 	tstrWID	strWID;
-	/* tstrWILC_WFIDrv * pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv; */
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)drvHandler;
 	strWID.u16WIDid = (u16)WID_CURRENT_CHANNEL;
 	strWID.enuWIDtype = WID_CHAR;
@@ -3454,7 +3449,6 @@ static void Handle_AddBeacon(void *drvHandler, tstrHostIFSetBeacon *pstrSetBeaco
 	s32 s32Error = WILC_SUCCESS;
 	tstrWID strWID;
 	u8 *pu8CurrByte;
-	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)drvHandler;
 	PRINT_D(HOSTINF_DBG, "Adding BEACON\n");
 
 	strWID.u16WIDid = (u16)WID_ADD_BEACON;
@@ -3526,7 +3520,6 @@ static void Handle_DelBeacon(void *drvHandler, tstrHostIFDelBeacon *pstrDelBeaco
 	s32 s32Error = WILC_SUCCESS;
 	tstrWID strWID;
 	u8 *pu8CurrByte;
-	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)drvHandler;
 	strWID.u16WIDid = (u16)WID_DEL_BEACON;
 	strWID.enuWIDtype = WID_CHAR;
 	strWID.s32ValueSize = sizeof(char);
@@ -3624,7 +3617,6 @@ static void Handle_AddStation(void *drvHandler, tstrWILC_AddStaParam *pstrStatio
 	s32 s32Error = WILC_SUCCESS;
 	tstrWID strWID;
 	u8 *pu8CurrByte;
-	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)drvHandler;
 	PRINT_D(HOSTINF_DBG, "Handling add station\n");
 	strWID.u16WIDid = (u16)WID_ADD_STA;
 	strWID.enuWIDtype = WID_BIN;
@@ -3667,7 +3659,6 @@ static void Handle_DelAllSta(void *drvHandler, tstrHostIFDelAllSta *pstrDelAllSt
 	s32 s32Error = WILC_SUCCESS;
 	tstrWID strWID;
 	u8 *pu8CurrByte;
-	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)drvHandler;
 	u8 i;
 	u8 au8Zero_Buff[6] = {0};
 	strWID.u16WIDid = (u16)WID_DEL_ALL_STA;
@@ -3725,7 +3716,6 @@ static void Handle_DelStation(void *drvHandler, tstrHostIFDelSta *pstrDelStaPara
 	s32 s32Error = WILC_SUCCESS;
 	tstrWID strWID;
 	u8 *pu8CurrByte;
-	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)drvHandler;
 
 	strWID.u16WIDid = (u16)WID_REMOVE_STA;
 	strWID.enuWIDtype = WID_BIN;
@@ -3771,7 +3761,6 @@ static void Handle_EditStation(void *drvHandler, tstrWILC_AddStaParam *pstrStati
 	s32 s32Error = WILC_SUCCESS;
 	tstrWID strWID;
 	u8 *pu8CurrByte;
-	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)drvHandler;
 
 	strWID.u16WIDid = (u16)WID_EDIT_STA;
 	strWID.enuWIDtype = WID_BIN;
@@ -3899,7 +3888,6 @@ static int Handle_RegisterFrame(void *drvHandler, tstrHostIfRegisterFrame *pstrH
 	s32 s32Error = WILC_SUCCESS;
 	tstrWID strWID;
 	u8 *pu8CurrByte;
-	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)drvHandler;
 
 	PRINT_D(HOSTINF_DBG, "Handling frame register Flag : %d FrameType: %d\n", pstrHostIfRegisterFrame->bReg, pstrHostIfRegisterFrame->u16FrameType);
 
@@ -4045,7 +4033,6 @@ static void Handle_PowerManagement(void *drvHandler, tstrHostIfPowerMgmtParam *s
 	s32 s32Error = WILC_SUCCESS;
 	tstrWID strWID;
 	s8 s8PowerMode;
-	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)drvHandler;
 	strWID.u16WIDid = (u16)WID_POWER_MANAGEMENT;
 
 	if (strPowerMgmtParam->bIsEnabled == true)	{
@@ -4142,7 +4129,6 @@ static s32 Handle_AddBASession(void *drvHandler, tstrHostIfBASessionInfo *strHos
 	tstrWID strWID;
 	int AddbaTimeout = 100;
 	char *ptr = NULL;
-	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)drvHandler;
 
 	PRINT_D(HOSTINF_DBG, "Opening Block Ack session with\nBSSID = %.2x:%.2x:%.2x \nTID=%d \nBufferSize == %d \nSessionTimeOut = %d\n",
 		strHostIfBASessionInfo->au8Bssid[0],
@@ -4229,7 +4215,6 @@ static s32 Handle_DelBASession(void *drvHandler, tstrHostIfBASessionInfo *strHos
 	s32 s32Error = WILC_SUCCESS;
 	tstrWID strWID;
 	char *ptr = NULL;
-	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)drvHandler;
 
 	PRINT_D(GENERIC_DBG, "Delete Block Ack session with\nBSSID = %.2x:%.2x:%.2x \nTID=%d\n",
 		strHostIfBASessionInfo->au8Bssid[0],
@@ -4299,7 +4284,6 @@ static s32 Handle_DelAllRxBASessions(void *drvHandler, tstrHostIfBASessionInfo *
 	s32 s32Error = WILC_SUCCESS;
 	tstrWID strWID;
 	char *ptr = NULL;
-	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)drvHandler;
 
 	PRINT_D(GENERIC_DBG, "Delete Block Ack session with\nBSSID = %.2x:%.2x:%.2x \nTID=%d\n",
 		strHostIfBASessionInfo->au8Bssid[0],
@@ -4615,7 +4599,6 @@ s32 host_int_remove_key(void *hWFIDrv, const u8 *pu8StaAddress)
 {
 	s32 s32Error = WILC_SUCCESS;
 	tstrWID strWID;
-	/* tstrWILC_WFIDrv * pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv; */
 
 	strWID.u16WIDid	= (u16)WID_REMOVE_KEY;
 	strWID.enuWIDtype	= WID_STR;
@@ -5104,7 +5087,6 @@ s32 host_int_add_rx_gtk(void *hWFIDrv, const u8 *pu8RxGtk, u8 u8GtkKeylen,
 s32 host_int_set_pmkid_info(void *hWFIDrv, tstrHostIFpmkidAttr *pu8PmkidInfoArray)
 {
 	s32 s32Error = WILC_SUCCESS;
-	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
 	tstrHostIFmsg strHostIFmsg;
 	u32 i;
 
@@ -5169,7 +5151,6 @@ s32 host_int_get_pmkid_info(void *hWFIDrv, u8 *pu8PmkidInfoArray,
 {
 	s32 s32Error = WILC_SUCCESS;
 	tstrWID strWID;
-	/* tstrWILC_WFIDrv * pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv; */
 
 	strWID.u16WIDid	= (u16)WID_PMKID_INFO;
 	strWID.enuWIDtype	= WID_STR;
@@ -5198,7 +5179,6 @@ s32 host_int_set_RSNAConfigPSKPassPhrase(void *hWFIDrv, u8 *pu8PassPhrase,
 {
 	s32 s32Error = WILC_SUCCESS;
 	tstrWID strWID;
-	/* tstrWILC_WFIDrv * pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv; */
 
 	/* u8 u8Psklength = WILC_strlen(pu8PassPhrase); */
 	/*validating psk length*/
@@ -5301,7 +5281,6 @@ s32 host_int_get_RSNAConfigPSKPassPhrase(void *hWFIDrv, u8 *pu8PassPhrase, u8 u8
 {
 	s32 s32Error = WILC_SUCCESS;
 	tstrWID strWID;
-	/* tstrWILC_WFIDrv * pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv; */
 
 	strWID.u16WIDid	= (u16)WID_11I_PSK;
 	strWID.enuWIDtype	= WID_STR;
@@ -5349,7 +5328,6 @@ s32 host_int_get_site_survey_results(void *hWFIDrv,
 {
 	s32 s32Error = WILC_SUCCESS;
 	tstrWID astrWIDList[2];
-	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
 
 	astrWIDList[0].u16WIDid = (u16)WID_SITE_SURVEY_RESULTS;
 	astrWIDList[0].enuWIDtype = WID_STR;
@@ -5397,7 +5375,6 @@ s32 host_int_set_start_scan_req(void *hWFIDrv, u8 scanSource)
 {
 	s32 s32Error = WILC_SUCCESS;
 	tstrWID strWID;
-	/* tstrWILC_WFIDrv * pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv; */
 
 	strWID.u16WIDid = (u16)WID_START_SCAN_REQ;
 	strWID.enuWIDtype = WID_CHAR;
@@ -5427,7 +5404,6 @@ s32 host_int_get_start_scan_req(void *hWFIDrv, u8 *pu8ScanSource)
 {
 	s32 s32Error = WILC_SUCCESS;
 	tstrWID strWID;
-	/* tstrWILC_WFIDrv * pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv; */
 
 	strWID.u16WIDid = (u16)WID_START_SCAN_REQ;
 	strWID.enuWIDtype = WID_CHAR;
@@ -5605,11 +5581,6 @@ s32 host_int_disconnect(void *hWFIDrv, u16 u16ReasonCode)
 		WILC_ERRORREPORT(s32Error, WILC_INVALID_ARGUMENT);
 	}
 
-	if (pstrWFIDrv == NULL)	{
-		PRINT_ER("gWFiDrvHandle = NULL\n");
-		WILC_ERRORREPORT(s32Error, WILC_FAIL);
-	}
-
 	/* prepare the Disconnect Message */
 	WILC_memset(&strHostIFmsg, 0, sizeof(tstrHostIFmsg));
 
@@ -5647,7 +5618,6 @@ s32 host_int_disconnect_station(void *hWFIDrv, u8 assoc_id)
 {
 	s32 s32Error = WILC_SUCCESS;
 	tstrWID strWID;
-	/* tstrWILC_WFIDrv * pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv; */
 
 	strWID.u16WIDid = (u16)WID_DISCONNECT;
 	strWID.enuWIDtype = WID_CHAR;
@@ -5688,7 +5658,6 @@ s32 host_int_get_assoc_req_info(void *hWFIDrv, u8 *pu8AssocReqInfo,
 {
 	s32 s32Error = WILC_SUCCESS;
 	tstrWID strWID;
-	/* tstrWILC_WFIDrv * pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv; */
 
 	strWID.u16WIDid = (u16)WID_ASSOC_REQ_INFO;
 	strWID.enuWIDtype = WID_STR;
@@ -5715,7 +5684,6 @@ s32 host_int_get_assoc_res_info(void *hWFIDrv, u8 *pu8AssocRespInfo,
 {
 	s32 s32Error = WILC_SUCCESS;
 	tstrWID strWID;
-	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
 
 	if (hWFIDrv == NULL) {
 		PRINT_ER("Driver not initialized: hWFIDrv = NULL \n");
@@ -5765,7 +5733,6 @@ s32 host_int_get_rx_power_level(void *hWFIDrv, u8 *pu8RxPowerLevel,
 {
 	s32 s32Error = WILC_SUCCESS;
 	tstrWID strWID;
-	/* tstrWILC_WFIDrv * pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv; */
 
 	strWID.u16WIDid = (u16)WID_RX_POWER_LEVEL;
 	strWID.enuWIDtype = WID_STR;
@@ -5794,7 +5761,6 @@ s32 host_int_get_rx_power_level(void *hWFIDrv, u8 *pu8RxPowerLevel,
 s32 host_int_set_mac_chnl_num(void *hWFIDrv, u8 u8ChNum)
 {
 	s32 s32Error = WILC_SUCCESS;
-	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
 	tstrHostIFmsg strHostIFmsg;
 
 	if (hWFIDrv == NULL) {
@@ -5965,7 +5931,6 @@ s32 host_int_test_set_int_wid(void *hWFIDrv, u32 u32TestMemAddr)
 {
 	s32 s32Error = WILC_SUCCESS;
 	tstrWID	strWID;
-	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
 
 
 	if (hWFIDrv == NULL) {
@@ -6059,7 +6024,6 @@ s32 host_int_test_get_int_wid(void *hWFIDrv, u32 *pu32TestMemAddr)
 
 	s32 s32Error = WILC_SUCCESS;
 	tstrWID	strWID;
-	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
 
 
 	if (hWFIDrv == NULL) {
@@ -6293,7 +6257,6 @@ s32 hif_set_cfg(void *hWFIDrv, tstrCfgParamVal *pstrCfgParamVal)
 {
 
 	s32 s32Error = WILC_SUCCESS;
-	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
 
 	tstrHostIFmsg strHostIFmsg;
 
@@ -7010,7 +6973,6 @@ void host_int_ScanCompleteReceived(u8 *pu8Buffer, u32 u32Length)
 s32 host_int_remain_on_channel(void *hWFIDrv, u32 u32SessionID, u32 u32duration, u16 chan, tWILCpfRemainOnChanExpired RemainOnChanExpired, tWILCpfRemainOnChanReady RemainOnChanReady, void *pvUserArg)
 {
 	s32 s32Error = WILC_SUCCESS;
-	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
 	tstrHostIFmsg strHostIFmsg;
 
 	if (hWFIDrv == NULL) {
@@ -7097,7 +7059,6 @@ s32 host_int_ListenStateExpired(void *hWFIDrv, u32 u32SessionID)
 s32 host_int_frame_register(void *hWFIDrv, u16 u16FrameType, bool bReg)
 {
 	s32 s32Error = WILC_SUCCESS;
-	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
 	tstrHostIFmsg strHostIFmsg;
 
 	if (hWFIDrv == NULL) {
@@ -7160,7 +7121,6 @@ s32 host_int_add_beacon(void *hWFIDrv, u32 u32Interval,
 				u32 u32TailLen, u8 *pu8Tail)
 {
 	s32 s32Error = WILC_SUCCESS;
-	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
 	tstrHostIFmsg strHostIFmsg;
 	tstrHostIFSetBeacon *pstrSetBeaconParam = NULL;
 
@@ -7231,7 +7191,6 @@ s32 host_int_add_beacon(void *hWFIDrv, u32 u32Interval,
 s32 host_int_del_beacon(void *hWFIDrv)
 {
 	s32 s32Error = WILC_SUCCESS;
-	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
 	tstrHostIFmsg strHostIFmsg;
 
 	if (hWFIDrv == NULL) {
@@ -7265,7 +7224,6 @@ s32 host_int_del_beacon(void *hWFIDrv)
 s32 host_int_add_station(void *hWFIDrv, tstrWILC_AddStaParam *pstrStaParams)
 {
 	s32 s32Error = WILC_SUCCESS;
-	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
 	tstrHostIFmsg strHostIFmsg;
 	tstrWILC_AddStaParam *pstrAddStationMsg = &strHostIFmsg.uniHostIFmsgBody.strAddStaParam;
 
@@ -7316,7 +7274,6 @@ s32 host_int_add_station(void *hWFIDrv, tstrWILC_AddStaParam *pstrStaParams)
 s32 host_int_del_station(void *hWFIDrv, const u8 *pu8MacAddr)
 {
 	s32 s32Error = WILC_SUCCESS;
-	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
 	tstrHostIFmsg strHostIFmsg;
 	tstrHostIFDelSta *pstrDelStationMsg = &strHostIFmsg.uniHostIFmsgBody.strDelStaParam;
 
@@ -7362,7 +7319,6 @@ s32 host_int_del_station(void *hWFIDrv, const u8 *pu8MacAddr)
 s32 host_int_del_allstation(void *hWFIDrv, u8 pu8MacAddr[][ETH_ALEN])
 {
 	s32 s32Error = WILC_SUCCESS;
-	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
 	tstrHostIFmsg strHostIFmsg;
 	tstrHostIFDelAllSta *pstrDelAllStationMsg = &strHostIFmsg.uniHostIFmsgBody.strHostIFDelAllSta;
 	u8 au8Zero_Buff[ETH_ALEN] = {0};
@@ -7426,7 +7382,6 @@ s32 host_int_del_allstation(void *hWFIDrv, u8 pu8MacAddr[][ETH_ALEN])
 s32 host_int_edit_station(void *hWFIDrv, tstrWILC_AddStaParam *pstrStaParams)
 {
 	s32 s32Error = WILC_SUCCESS;
-	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
 	tstrHostIFmsg strHostIFmsg;
 	tstrWILC_AddStaParam *pstrAddStationMsg = &strHostIFmsg.uniHostIFmsgBody.strAddStaParam;
 
@@ -7466,7 +7421,6 @@ uint32_t wilc_get_chipid(uint8_t);
 s32 host_int_set_power_mgmt(void *hWFIDrv, bool bIsEnabled, u32 u32Timeout)
 {
 	s32 s32Error = WILC_SUCCESS;
-	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
 	tstrHostIFmsg strHostIFmsg;
 	tstrHostIfPowerMgmtParam *pstrPowerMgmtParam = &strHostIFmsg.uniHostIFmsgBody.strPowerMgmtparam;
 
@@ -7503,7 +7457,6 @@ s32 host_int_setup_multicast_filter(void *hWFIDrv, bool bIsEnabled, u32 u32count
 {
 	s32 s32Error = WILC_SUCCESS;
 
-	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
 	tstrHostIFmsg strHostIFmsg;
 	tstrHostIFSetMulti *pstrMulticastFilterParam = &strHostIFmsg.uniHostIFmsgBody.strHostIfSetMulti;
 
@@ -7775,7 +7728,6 @@ static int host_int_addBASession(void *hWFIDrv, char *pBSSID, char TID, short in
 				 short int SessionTimeout, void *drvHandler)
 {
 	s32 s32Error = WILC_SUCCESS;
-	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
 	tstrHostIFmsg strHostIFmsg;
 	tstrHostIfBASessionInfo *pBASessionInfo = &strHostIFmsg.uniHostIFmsgBody.strHostIfBASessionInfo;
 
@@ -7810,7 +7762,6 @@ static int host_int_addBASession(void *hWFIDrv, char *pBSSID, char TID, short in
 s32 host_int_delBASession(void *hWFIDrv, char *pBSSID, char TID)
 {
 	s32 s32Error = WILC_SUCCESS;
-	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
 	tstrHostIFmsg strHostIFmsg;
 	tstrHostIfBASessionInfo *pBASessionInfo = &strHostIFmsg.uniHostIFmsgBody.strHostIfBASessionInfo;
 
@@ -7845,7 +7796,6 @@ s32 host_int_delBASession(void *hWFIDrv, char *pBSSID, char TID)
 s32 host_int_del_All_Rx_BASession(void *hWFIDrv, char *pBSSID, char TID)
 {
 	s32 s32Error = WILC_SUCCESS;
-	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
 	tstrHostIFmsg strHostIFmsg;
 	tstrHostIfBASessionInfo *pBASessionInfo = &strHostIFmsg.uniHostIFmsgBody.strHostIfBASessionInfo;
 
@@ -7888,7 +7838,6 @@ s32 host_int_del_All_Rx_BASession(void *hWFIDrv, char *pBSSID, char TID)
 s32 host_int_setup_ipaddress(void *hWFIDrv, u8 *u16ipadd, u8 idx)
 {
 	s32 s32Error = WILC_SUCCESS;
-	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
 	tstrHostIFmsg strHostIFmsg;
 
 	/* TODO: Enable This feature on softap firmware */
@@ -7932,7 +7881,6 @@ s32 host_int_setup_ipaddress(void *hWFIDrv, u8 *u16ipadd, u8 idx)
 s32 host_int_get_ipaddress(void *hWFIDrv, u8 *u16ipadd, u8 idx)
 {
 	s32 s32Error = WILC_SUCCESS;
-	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
 	tstrHostIFmsg strHostIFmsg;
 
 	if (hWFIDrv == NULL) {
diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 1b8991a..0772292 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -1946,7 +1946,7 @@ int wilc1000_wlan_init(struct net_device *dev, perInterface_wlan_t *p_nic)
 
 		wilc_bus_set_max_speed();
 
-		if (g_linux_wlan->oup.wlan_cfg_get(1, WID_FIRMWARE_VERSION, 1, 0)) {
+		if (g_linux_wlan->oup.wlan_cfg_get(1, WID_FIRMWARE_VERSION, 1, NULL)) {
 			int size;
 			char Firmware_ver[20];
 			size = g_linux_wlan->oup.wlan_cfg_get_value(
-- 
2.4.4

