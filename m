Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:18638 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751137AbbJFJmi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Oct 2015 05:42:38 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 01/10] staging: wilc1000: remove typedef from tstrWID
Date: Tue, 6 Oct 2015 18:42:12 +0900
Message-ID: <1444124541-5663-1-git-send-email-tony.cho@atmel.com> (sfid-20151006_114242_130818_B33F691B)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch removes typedef from the struct tstrWID and
rename it to wid.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/coreconfigurator.c |  2 +-
 drivers/staging/wilc1000/coreconfigurator.h |  7 +--
 drivers/staging/wilc1000/host_interface.c   | 92 ++++++++++++++---------------
 3 files changed, 50 insertions(+), 51 deletions(-)

diff --git a/drivers/staging/wilc1000/coreconfigurator.c b/drivers/staging/wilc1000/coreconfigurator.c
index 189be4a..f5913377 100644
--- a/drivers/staging/wilc1000/coreconfigurator.c
+++ b/drivers/staging/wilc1000/coreconfigurator.c
@@ -595,7 +595,7 @@ s32 DeallocateAssocRespInfo(tstrConnectRespInfo *pstrConnectRespInfo)
  *  @date		1 Mar 2012
  *  @version	1.0
  */
-s32 send_config_pkt(u8 mode, tstrWID *wids, u32 count, u32 drv)
+s32 send_config_pkt(u8 mode, struct wid *wids, u32 count, u32 drv)
 {
 	s32 counter = 0, ret = 0;
 
diff --git a/drivers/staging/wilc1000/coreconfigurator.h b/drivers/staging/wilc1000/coreconfigurator.h
index 8ba30dc..306efc9 100644
--- a/drivers/staging/wilc1000/coreconfigurator.h
+++ b/drivers/staging/wilc1000/coreconfigurator.h
@@ -70,13 +70,12 @@ typedef enum {
 	CONNECT_STS_FORCE_16_BIT = 0xFFFF
 } tenuConnectSts;
 
-typedef struct {
+struct wid {
 	u16 u16WIDid;
 	tenuWIDtype enuWIDtype;
 	s32 s32ValueSize;
 	s8      *ps8WidVal;
-
-} tstrWID;
+};
 
 typedef struct {
 	u8 u8Full;
@@ -128,7 +127,7 @@ typedef struct {
 	size_t ie_len;
 } tstrDisconnectNotifInfo;
 
-s32 send_config_pkt(u8 mode, tstrWID *wids, u32 count, u32 drv);
+s32 send_config_pkt(u8 mode, struct wid *wids, u32 count, u32 drv);
 s32 parse_network_info(u8 *pu8MsgBuffer, tstrNetworkInfo **ppstrNetworkInfo);
 s32 DeallocateNetworkInfo(tstrNetworkInfo *pstrNetworkInfo);
 
diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 982bb4c..f5feef9 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -571,7 +571,7 @@ static s32 Handle_SetChannel(struct host_if_drv *drvHandler,
 {
 
 	s32 s32Error = 0;
-	tstrWID	strWID;
+	struct wid strWID;
 	struct host_if_drv *pstrWFIDrv = (struct host_if_drv *)drvHandler;
 
 	/*prepare configuration packet*/
@@ -606,7 +606,7 @@ static s32 Handle_SetWfiDrvHandler(struct host_if_drv *drvHandler,
 {
 
 	s32 s32Error = 0;
-	tstrWID	strWID;
+	struct wid strWID;
 	struct host_if_drv *pstrWFIDrv = drvHandler;
 
 
@@ -647,7 +647,7 @@ static s32 Handle_SetOperationMode(struct host_if_drv *drvHandler,
 {
 
 	s32 s32Error = 0;
-	tstrWID	strWID;
+	struct wid strWID;
 	struct host_if_drv *pstrWFIDrv = (struct host_if_drv *)drvHandler;
 
 
@@ -689,7 +689,7 @@ s32 Handle_set_IPAddress(struct host_if_drv *drvHandler, u8 *pu8IPAddr, u8 idx)
 {
 
 	s32 s32Error = 0;
-	tstrWID strWID;
+	struct wid strWID;
 	char firmwareIPAddress[4] = {0};
 	struct host_if_drv *pstrWFIDrv = (struct host_if_drv *)drvHandler;
 
@@ -736,7 +736,7 @@ s32 Handle_get_IPAddress(struct host_if_drv *drvHandler, u8 *pu8IPAddr, u8 idx)
 {
 
 	s32 s32Error = 0;
-	tstrWID strWID;
+	struct wid strWID;
 	struct host_if_drv *pstrWFIDrv = (struct host_if_drv *)drvHandler;
 
 	/*prepare configuration packet*/
@@ -785,7 +785,7 @@ static s32 Handle_SetMacAddress(struct host_if_drv *drvHandler,
 {
 
 	s32 s32Error = 0;
-	tstrWID	strWID;
+	struct wid strWID;
 	struct host_if_drv *pstrWFIDrv = (struct host_if_drv *)drvHandler;
 	u8 *mac_buf = kmalloc(ETH_ALEN, GFP_KERNEL);
 
@@ -828,7 +828,7 @@ static s32 Handle_GetMacAddress(struct host_if_drv *drvHandler,
 {
 
 	s32 s32Error = 0;
-	tstrWID	strWID;
+	struct wid strWID;
 
 	/*prepare configuration packet*/
 	strWID.u16WIDid = (u16)WID_MAC_ADDR;
@@ -862,7 +862,7 @@ static s32 Handle_CfgParam(struct host_if_drv *drvHandler,
 			   struct cfg_param_attr *strHostIFCfgParamAttr)
 {
 	s32 s32Error = 0;
-	tstrWID strWIDList[32];
+	struct wid strWIDList[32];
 	u8 u8WidCnt = 0;
 	struct host_if_drv *pstrWFIDrv = (struct host_if_drv *)drvHandler;
 
@@ -1220,7 +1220,7 @@ static s32 Handle_Scan(struct host_if_drv *drvHandler,
 		       struct scan_attr *pstrHostIFscanAttr)
 {
 	s32 s32Error = 0;
-	tstrWID strWIDList[5];
+	struct wid strWIDList[5];
 	u32 u32WidsCount = 0;
 	u32 i;
 	u8 *pu8Buffer;
@@ -1391,7 +1391,7 @@ static s32 Handle_ScanDone(struct host_if_drv *drvHandler, tenuScanEvent enuEven
 
 
 	u8 u8abort_running_scan;
-	tstrWID strWID;
+	struct wid strWID;
 
 
 	PRINT_D(HOSTINF_DBG, "in Handle_ScanDone()\n");
@@ -1445,7 +1445,7 @@ static s32 Handle_Connect(struct host_if_drv *drvHandler,
 {
 	struct host_if_drv *pstrWFIDrv = (struct host_if_drv *) drvHandler;
 	s32 s32Error = 0;
-	tstrWID strWIDList[8];
+	struct wid strWIDList[8];
 	u32 u32WidsCount = 0, dummyval = 0;
 	/* char passphrase[] = "12345678"; */
 	u8 *pu8CurrByte = NULL;
@@ -1806,7 +1806,7 @@ ERRORHANDLER:
 static s32 Handle_FlushConnect(struct host_if_drv *drvHandler)
 {
 	s32 s32Error = 0;
-	tstrWID strWIDList[5];
+	struct wid strWIDList[5];
 	u32 u32WidsCount = 0;
 	u8 *pu8CurrByte = NULL;
 
@@ -1866,7 +1866,7 @@ static s32 Handle_ConnectTimeout(struct host_if_drv *drvHandler)
 {
 	s32 s32Error = 0;
 	tstrConnectInfo strConnectInfo;
-	tstrWID strWID;
+	struct wid strWID;
 	u16 u16DummyReasonCode = 0;
 	struct host_if_drv *pstrWFIDrv = (struct host_if_drv *) drvHandler;
 
@@ -2406,8 +2406,8 @@ static int Handle_Key(struct host_if_drv *drvHandler,
 		      struct key_attr *pstrHostIFkeyAttr)
 {
 	s32 s32Error = 0;
-	tstrWID strWID;
-	tstrWID strWIDList[5];
+	struct wid strWID;
+	struct wid strWIDList[5];
 	u8 i;
 	u8 *pu8keybuf;
 	s8 s8idxarray[1];
@@ -2768,7 +2768,7 @@ _WPAPtk_end_case_:
  */
 static void Handle_Disconnect(struct host_if_drv *drvHandler)
 {
-	tstrWID strWID;
+	struct wid strWID;
 
 	s32 s32Error = 0;
 	u16 u16DummyReasonCode = 0;
@@ -2896,7 +2896,7 @@ static s32 Handle_GetChnl(struct host_if_drv *drvHandler)
 {
 
 	s32 s32Error = 0;
-	tstrWID	strWID;
+	struct wid strWID;
 	struct host_if_drv *pstrWFIDrv = (struct host_if_drv *)drvHandler;
 
 	strWID.u16WIDid = (u16)WID_CURRENT_CHANNEL;
@@ -2935,7 +2935,7 @@ static s32 Handle_GetChnl(struct host_if_drv *drvHandler)
 static void Handle_GetRssi(struct host_if_drv *drvHandler)
 {
 	s32 s32Error = 0;
-	tstrWID strWID;
+	struct wid strWID;
 	struct host_if_drv *pstrWFIDrv = (struct host_if_drv *)drvHandler;
 
 	strWID.u16WIDid = (u16)WID_RSSI;
@@ -2962,7 +2962,7 @@ static void Handle_GetRssi(struct host_if_drv *drvHandler)
 static void Handle_GetLinkspeed(struct host_if_drv *drvHandler)
 {
 	s32 s32Error = 0;
-	tstrWID strWID;
+	struct wid strWID;
 	struct host_if_drv *pstrWFIDrv = (struct host_if_drv *)drvHandler;
 
 	gs8lnkspd = 0;
@@ -2988,7 +2988,7 @@ static void Handle_GetLinkspeed(struct host_if_drv *drvHandler)
 
 s32 Handle_GetStatistics(struct host_if_drv *drvHandler, tstrStatistics *pstrStatistics)
 {
-	tstrWID strWIDList[5];
+	struct wid strWIDList[5];
 	u32 u32WidsCount = 0, s32Error = 0;
 
 	strWIDList[u32WidsCount].u16WIDid = WID_LINKSPEED;
@@ -3049,7 +3049,7 @@ static s32 Handle_Get_InActiveTime(struct host_if_drv *drvHandler,
 
 	s32 s32Error = 0;
 	u8 *stamac;
-	tstrWID	strWID;
+	struct wid strWID;
 	struct host_if_drv *pstrWFIDrv = (struct host_if_drv *)drvHandler;
 
 
@@ -3114,7 +3114,7 @@ static void Handle_AddBeacon(struct host_if_drv *drvHandler,
 			     struct beacon_attr *pstrSetBeaconParam)
 {
 	s32 s32Error = 0;
-	tstrWID strWID;
+	struct wid strWID;
 	u8 *pu8CurrByte;
 	struct host_if_drv *pstrWFIDrv = (struct host_if_drv *)drvHandler;
 
@@ -3182,7 +3182,7 @@ ERRORHANDLER:
 static void Handle_DelBeacon(struct host_if_drv *drvHandler)
 {
 	s32 s32Error = 0;
-	tstrWID strWID;
+	struct wid strWID;
 	u8 *pu8CurrByte;
 	struct host_if_drv *pstrWFIDrv = (struct host_if_drv *)drvHandler;
 
@@ -3275,7 +3275,7 @@ static void Handle_AddStation(struct host_if_drv *drvHandler,
 			      struct add_sta_param *pstrStationParam)
 {
 	s32 s32Error = 0;
-	tstrWID strWID;
+	struct wid strWID;
 	u8 *pu8CurrByte;
 	struct host_if_drv *pstrWFIDrv = (struct host_if_drv *)drvHandler;
 
@@ -3316,7 +3316,7 @@ static void Handle_DelAllSta(struct host_if_drv *drvHandler,
 {
 	s32 s32Error = 0;
 
-	tstrWID strWID;
+	struct wid strWID;
 	u8 *pu8CurrByte;
 	struct host_if_drv *pstrWFIDrv = (struct host_if_drv *)drvHandler;
 	u8 i;
@@ -3371,7 +3371,7 @@ static void Handle_DelStation(struct host_if_drv *drvHandler,
 			      struct del_sta *pstrDelStaParam)
 {
 	s32 s32Error = 0;
-	tstrWID strWID;
+	struct wid strWID;
 	u8 *pu8CurrByte;
 	struct host_if_drv *pstrWFIDrv = (struct host_if_drv *)drvHandler;
 
@@ -3413,7 +3413,7 @@ static void Handle_EditStation(struct host_if_drv *drvHandler,
 			       struct add_sta_param *pstrStationParam)
 {
 	s32 s32Error = 0;
-	tstrWID strWID;
+	struct wid strWID;
 	u8 *pu8CurrByte;
 	struct host_if_drv *pstrWFIDrv = (struct host_if_drv *)drvHandler;
 
@@ -3454,7 +3454,7 @@ static int Handle_RemainOnChan(struct host_if_drv *drvHandler,
 {
 	s32 s32Error = 0;
 	u8 u8remain_on_chan_flag;
-	tstrWID strWID;
+	struct wid strWID;
 	struct host_if_drv *pstrWFIDrv = (struct host_if_drv *) drvHandler;
 
 	/*If it's a pendig remain-on-channel, don't overwrite gWFiDrvHandle values (since incoming msg is garbbage)*/
@@ -3540,7 +3540,7 @@ static int Handle_RegisterFrame(struct host_if_drv *drvHandler,
 				struct reg_frame *pstrHostIfRegisterFrame)
 {
 	s32 s32Error = 0;
-	tstrWID strWID;
+	struct wid strWID;
 	u8 *pu8CurrByte;
 	struct host_if_drv *pstrWFIDrv = (struct host_if_drv *)drvHandler;
 
@@ -3589,7 +3589,7 @@ static u32 Handle_ListenStateExpired(struct host_if_drv *drvHandler,
 				     struct remain_ch *pstrHostIfRemainOnChan)
 {
 	u8 u8remain_on_chan_flag;
-	tstrWID strWID;
+	struct wid strWID;
 	s32 s32Error = 0;
 	struct host_if_drv *pstrWFIDrv = (struct host_if_drv *) drvHandler;
 
@@ -3675,7 +3675,7 @@ static void Handle_PowerManagement(struct host_if_drv *drvHandler,
 				   struct power_mgmt_param *strPowerMgmtParam)
 {
 	s32 s32Error = 0;
-	tstrWID strWID;
+	struct wid strWID;
 	s8 s8PowerMode;
 	struct host_if_drv *pstrWFIDrv = (struct host_if_drv *)drvHandler;
 
@@ -3711,7 +3711,7 @@ static void Handle_SetMulticastFilter(struct host_if_drv *drvHandler,
 				      struct set_multicast *strHostIfSetMulti)
 {
 	s32 s32Error = 0;
-	tstrWID strWID;
+	struct wid strWID;
 	u8 *pu8CurrByte;
 
 	PRINT_D(HOSTINF_DBG, "Setup Multicast Filter\n");
@@ -3762,7 +3762,7 @@ static s32 Handle_AddBASession(struct host_if_drv *drvHandler,
 			       struct ba_session_info *strHostIfBASessionInfo)
 {
 	s32 s32Error = 0;
-	tstrWID strWID;
+	struct wid strWID;
 	int AddbaTimeout = 100;
 	char *ptr = NULL;
 	struct host_if_drv *pstrWFIDrv = (struct host_if_drv *)drvHandler;
@@ -3851,7 +3851,7 @@ static s32 Handle_DelAllRxBASessions(struct host_if_drv *drvHandler,
 				     struct ba_session_info *strHostIfBASessionInfo)
 {
 	s32 s32Error = 0;
-	tstrWID strWID;
+	struct wid strWID;
 	char *ptr = NULL;
 	struct host_if_drv *pstrWFIDrv = (struct host_if_drv *)drvHandler;
 
@@ -4158,7 +4158,7 @@ static void TimerCB_Connect(unsigned long arg)
 /* Check implementation in core adding 9 bytes to the input! */
 s32 host_int_remove_key(struct host_if_drv *hWFIDrv, const u8 *pu8StaAddress)
 {
-	tstrWID strWID;
+	struct wid strWID;
 
 	strWID.u16WIDid	= (u16)WID_REMOVE_KEY;
 	strWID.enuWIDtype	= WID_STR;
@@ -4680,7 +4680,7 @@ s32 host_int_set_pmkid_info(struct host_if_drv *hWFIDrv, struct host_if_pmkid_at
 s32 host_int_get_pmkid_info(struct host_if_drv *hWFIDrv, u8 *pu8PmkidInfoArray,
 				    u32 u32PmkidInfoLen)
 {
-	tstrWID strWID;
+	struct wid strWID;
 
 	strWID.u16WIDid	= (u16)WID_PMKID_INFO;
 	strWID.enuWIDtype	= WID_STR;
@@ -4707,7 +4707,7 @@ s32 host_int_get_pmkid_info(struct host_if_drv *hWFIDrv, u8 *pu8PmkidInfoArray,
 s32 host_int_set_RSNAConfigPSKPassPhrase(struct host_if_drv *hWFIDrv, u8 *pu8PassPhrase,
 						 u8 u8Psklength)
 {
-	tstrWID strWID;
+	struct wid strWID;
 
 	/*validating psk length*/
 	if ((u8Psklength > 7) && (u8Psklength < 65)) {
@@ -4802,7 +4802,7 @@ s32 host_int_set_MacAddress(struct host_if_drv *hWFIDrv, u8 *pu8MacAddress)
 s32 host_int_get_RSNAConfigPSKPassPhrase(struct host_if_drv *hWFIDrv,
 						 u8 *pu8PassPhrase, u8 u8Psklength)
 {
-	tstrWID strWID;
+	struct wid strWID;
 
 	strWID.u16WIDid	= (u16)WID_11I_PSK;
 	strWID.enuWIDtype	= WID_STR;
@@ -4829,7 +4829,7 @@ s32 host_int_get_RSNAConfigPSKPassPhrase(struct host_if_drv *hWFIDrv,
  */
 s32 host_int_set_start_scan_req(struct host_if_drv *hWFIDrv, u8 scanSource)
 {
-	tstrWID strWID;
+	struct wid strWID;
 
 	strWID.u16WIDid = (u16)WID_START_SCAN_REQ;
 	strWID.enuWIDtype = WID_CHAR;
@@ -4857,7 +4857,7 @@ s32 host_int_set_start_scan_req(struct host_if_drv *hWFIDrv, u8 scanSource)
 
 s32 host_int_get_start_scan_req(struct host_if_drv *hWFIDrv, u8 *pu8ScanSource)
 {
-	tstrWID strWID;
+	struct wid strWID;
 
 	strWID.u16WIDid = (u16)WID_START_SCAN_REQ;
 	strWID.enuWIDtype = WID_CHAR;
@@ -5054,7 +5054,7 @@ s32 host_int_disconnect(struct host_if_drv *hWFIDrv, u16 u16ReasonCode)
  */
 s32 host_int_disconnect_station(struct host_if_drv *hWFIDrv, u8 assoc_id)
 {
-	tstrWID strWID;
+	struct wid strWID;
 
 	strWID.u16WIDid = (u16)WID_DISCONNECT;
 	strWID.enuWIDtype = WID_CHAR;
@@ -5093,7 +5093,7 @@ s32 host_int_disconnect_station(struct host_if_drv *hWFIDrv, u8 assoc_id)
 s32 host_int_get_assoc_req_info(struct host_if_drv *hWFIDrv, u8 *pu8AssocReqInfo,
 					u32 u32AssocReqInfoLen)
 {
-	tstrWID strWID;
+	struct wid strWID;
 
 	strWID.u16WIDid = (u16)WID_ASSOC_REQ_INFO;
 	strWID.enuWIDtype = WID_STR;
@@ -5118,7 +5118,7 @@ s32 host_int_get_assoc_res_info(struct host_if_drv *hWFIDrv, u8 *pu8AssocRespInf
 					u32 u32MaxAssocRespInfoLen, u32 *pu32RcvdAssocRespInfoLen)
 {
 	s32 s32Error = 0;
-	tstrWID strWID;
+	struct wid strWID;
 	struct host_if_drv *pstrWFIDrv = (struct host_if_drv *)hWFIDrv;
 
 	if (pstrWFIDrv == NULL) {
@@ -5164,7 +5164,7 @@ s32 host_int_get_assoc_res_info(struct host_if_drv *hWFIDrv, u8 *pu8AssocRespInf
 s32 host_int_get_rx_power_level(struct host_if_drv *hWFIDrv, u8 *pu8RxPowerLevel,
 					u32 u32RxPowerLevelLen)
 {
-	tstrWID strWID;
+	struct wid strWID;
 
 	strWID.u16WIDid = (u16)WID_RX_POWER_LEVEL;
 	strWID.enuWIDtype = WID_STR;
@@ -5346,7 +5346,7 @@ s32 host_int_get_host_chnl_num(struct host_if_drv *hWFIDrv, u8 *pu8ChNo)
 s32 host_int_test_set_int_wid(struct host_if_drv *hWFIDrv, u32 u32TestMemAddr)
 {
 	s32 s32Error = 0;
-	tstrWID	strWID;
+	struct wid strWID;
 	struct host_if_drv *pstrWFIDrv = (struct host_if_drv *)hWFIDrv;
 
 
@@ -5432,7 +5432,7 @@ s32 host_int_test_get_int_wid(struct host_if_drv *hWFIDrv, u32 *pu32TestMemAddr)
 {
 
 	s32 s32Error = 0;
-	tstrWID	strWID;
+	struct wid strWID;
 	struct host_if_drv *pstrWFIDrv = (struct host_if_drv *)hWFIDrv;
 
 
-- 
1.9.1

