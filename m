Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:37029 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752423AbbJEK2b (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Oct 2015 06:28:31 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 1/6] staging: wilc1000: remove typedef from tstrWILC_WFIDrv
Date: Mon, 5 Oct 2015 19:28:09 +0900
Message-ID: <1444040894-18709-1-git-send-email-tony.cho@atmel.com> (sfid-20151005_122837_198347_48F96089)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch removes typedef from the struct tstrWILC_WFIDrv and
rename it to host_if_drv.
This patch includes the removal of the comment for tstrWILC_WFIDrv as well.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c         | 362 +++++++++++-----------
 drivers/staging/wilc1000/host_interface.h         | 108 +++----
 drivers/staging/wilc1000/linux_wlan.c             |  16 +-
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c |  24 +-
 drivers/staging/wilc1000/wilc_wfi_netdevice.h     |   4 +-
 5 files changed, 253 insertions(+), 261 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index dbaebad..66c37ef 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -402,7 +402,7 @@ union message_body {
 struct host_if_msg {
 	u16 id;                                           /*!< Message ID */
 	union message_body body;             /*!< Message body */
-	tstrWILC_WFIDrv *drvHandler;
+	struct host_if_drv *drvHandler;
 };
 
 typedef struct _tstrWidJoinReqExt {
@@ -460,9 +460,9 @@ typedef enum {
 /*																			 */
 /*****************************************************************************/
 /* Zero is not used, because a zero ID means termination */
-static tstrWILC_WFIDrv *wfidrv_list[NUM_CONCURRENT_IFC + 1];
-tstrWILC_WFIDrv *terminated_handle;
-tstrWILC_WFIDrv *gWFiDrvHandle;
+static struct host_if_drv *wfidrv_list[NUM_CONCURRENT_IFC + 1];
+struct host_if_drv *terminated_handle;
+struct host_if_drv *gWFiDrvHandle;
 bool g_obtainingIP = false;
 u8 P2P_LISTEN_STATE;
 static struct task_struct *HostIFthreadHandler;
@@ -497,7 +497,7 @@ u8 gu8Flushed11iMode;
 u8 gu8FlushedAuthType;
 u32 gu32FlushedJoinReqSize;
 u32 gu32FlushedInfoElemAsocSize;
-tstrWILC_WFIDrv *gu8FlushedJoinReqDrvHandler;
+struct host_if_drv *gu8FlushedJoinReqDrvHandler;
 #define REAL_JOIN_REQ 0
 #define FLUSHED_JOIN_REQ 1
 #define FLUSHED_BYTE_POS 79     /* Position the byte indicating flushing in the flushed request */
@@ -507,7 +507,7 @@ static void *host_int_ParseJoinBssParam(tstrNetworkInfo *ptstrNetworkInfo);
 extern void chip_sleep_manually(u32 u32SleepTime);
 extern int linux_wlan_get_num_conn_ifcs(void);
 
-static int add_handler_in_list(tstrWILC_WFIDrv *handler)
+static int add_handler_in_list(struct host_if_drv *handler)
 {
 	int i;
 
@@ -521,7 +521,7 @@ static int add_handler_in_list(tstrWILC_WFIDrv *handler)
 	return -ENOBUFS;
 }
 
-static int remove_handler_in_list(tstrWILC_WFIDrv *handler)
+static int remove_handler_in_list(struct host_if_drv *handler)
 {
 	int i;
 
@@ -535,7 +535,7 @@ static int remove_handler_in_list(tstrWILC_WFIDrv *handler)
 	return -EINVAL;
 }
 
-static int get_id_from_handler(tstrWILC_WFIDrv *handler)
+static int get_id_from_handler(struct host_if_drv *handler)
 {
 	int i;
 
@@ -550,7 +550,7 @@ static int get_id_from_handler(tstrWILC_WFIDrv *handler)
 	return 0;
 }
 
-static tstrWILC_WFIDrv *get_handler_from_id(int id)
+static struct host_if_drv *get_handler_from_id(int id)
 {
 	if (id <= 0 || id >= ARRAY_SIZE(wfidrv_list))
 		return NULL;
@@ -566,13 +566,13 @@ static tstrWILC_WFIDrv *get_handler_from_id(int id)
  *  @date
  *  @version	1.0
  */
-static s32 Handle_SetChannel(tstrWILC_WFIDrv *drvHandler,
+static s32 Handle_SetChannel(struct host_if_drv *drvHandler,
 			     struct channel_attr *pstrHostIFSetChan)
 {
 
 	s32 s32Error = 0;
 	tstrWID	strWID;
-	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)drvHandler;
+	struct host_if_drv *pstrWFIDrv = (struct host_if_drv *)drvHandler;
 
 	/*prepare configuration packet*/
 	strWID.u16WIDid = (u16)WID_CURRENT_CHANNEL;
@@ -601,13 +601,13 @@ static s32 Handle_SetChannel(tstrWILC_WFIDrv *drvHandler,
  *  @date
  *  @version	1.0
  */
-static s32 Handle_SetWfiDrvHandler(tstrWILC_WFIDrv *drvHandler,
+static s32 Handle_SetWfiDrvHandler(struct host_if_drv *drvHandler,
 				   struct drv_handler *pstrHostIfSetDrvHandler)
 {
 
 	s32 s32Error = 0;
 	tstrWID	strWID;
-	tstrWILC_WFIDrv *pstrWFIDrv = drvHandler;
+	struct host_if_drv *pstrWFIDrv = drvHandler;
 
 
 	/*prepare configuration packet*/
@@ -642,13 +642,13 @@ static s32 Handle_SetWfiDrvHandler(tstrWILC_WFIDrv *drvHandler,
  *  @date
  *  @version	1.0
  */
-static s32 Handle_SetOperationMode(tstrWILC_WFIDrv *drvHandler,
+static s32 Handle_SetOperationMode(struct host_if_drv *drvHandler,
 				   struct op_mode *pstrHostIfSetOperationMode)
 {
 
 	s32 s32Error = 0;
 	tstrWID	strWID;
-	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)drvHandler;
+	struct host_if_drv *pstrWFIDrv = (struct host_if_drv *)drvHandler;
 
 
 	/*prepare configuration packet*/
@@ -685,13 +685,13 @@ static s32 Handle_SetOperationMode(tstrWILC_WFIDrv *drvHandler,
  *  @date
  *  @version	1.0
  */
-s32 Handle_set_IPAddress(tstrWILC_WFIDrv *drvHandler, u8 *pu8IPAddr, u8 idx)
+s32 Handle_set_IPAddress(struct host_if_drv *drvHandler, u8 *pu8IPAddr, u8 idx)
 {
 
 	s32 s32Error = 0;
 	tstrWID strWID;
 	char firmwareIPAddress[4] = {0};
-	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)drvHandler;
+	struct host_if_drv *pstrWFIDrv = (struct host_if_drv *)drvHandler;
 
 	if (pu8IPAddr[0] < 192)
 		pu8IPAddr[0] = 0;
@@ -732,12 +732,12 @@ s32 Handle_set_IPAddress(tstrWILC_WFIDrv *drvHandler, u8 *pu8IPAddr, u8 idx)
  *  @date
  *  @version	1.0
  */
-s32 Handle_get_IPAddress(tstrWILC_WFIDrv *drvHandler, u8 *pu8IPAddr, u8 idx)
+s32 Handle_get_IPAddress(struct host_if_drv *drvHandler, u8 *pu8IPAddr, u8 idx)
 {
 
 	s32 s32Error = 0;
 	tstrWID strWID;
-	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)drvHandler;
+	struct host_if_drv *pstrWFIDrv = (struct host_if_drv *)drvHandler;
 
 	/*prepare configuration packet*/
 	strWID.u16WIDid = (u16)WID_IP_ADDRESS;
@@ -780,13 +780,13 @@ s32 Handle_get_IPAddress(tstrWILC_WFIDrv *drvHandler, u8 *pu8IPAddr, u8 idx)
  *  @date		November 2013
  *  @version	7.0
  */
-static s32 Handle_SetMacAddress(tstrWILC_WFIDrv *drvHandler,
+static s32 Handle_SetMacAddress(struct host_if_drv *drvHandler,
 				struct set_mac_addr *pstrHostIfSetMacAddress)
 {
 
 	s32 s32Error = 0;
 	tstrWID	strWID;
-	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)drvHandler;
+	struct host_if_drv *pstrWFIDrv = (struct host_if_drv *)drvHandler;
 	u8 *mac_buf = kmalloc(ETH_ALEN, GFP_KERNEL);
 
 	if (mac_buf == NULL) {
@@ -823,7 +823,7 @@ static s32 Handle_SetMacAddress(tstrWILC_WFIDrv *drvHandler,
  *  @date		JAN 2013
  *  @version	8.0
  */
-static s32 Handle_GetMacAddress(tstrWILC_WFIDrv *drvHandler,
+static s32 Handle_GetMacAddress(struct host_if_drv *drvHandler,
 				struct get_mac_addr *pstrHostIfGetMacAddress)
 {
 
@@ -858,13 +858,13 @@ static s32 Handle_GetMacAddress(tstrWILC_WFIDrv *drvHandler,
  *  @date
  *  @version	1.0
  */
-static s32 Handle_CfgParam(tstrWILC_WFIDrv *drvHandler,
+static s32 Handle_CfgParam(struct host_if_drv *drvHandler,
 			   struct cfg_param_attr *strHostIFCfgParamAttr)
 {
 	s32 s32Error = 0;
 	tstrWID strWIDList[32];
 	u8 u8WidCnt = 0;
-	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)drvHandler;
+	struct host_if_drv *pstrWFIDrv = (struct host_if_drv *)drvHandler;
 
 
 	down(&(pstrWFIDrv->gtOsCfgValuesSem));
@@ -1218,7 +1218,7 @@ static s32 Handle_wait_msg_q_empty(void)
  *  @date
  *  @version	1.0
  */
-static s32 Handle_Scan(tstrWILC_WFIDrv *drvHandler,
+static s32 Handle_Scan(struct host_if_drv *drvHandler,
 		       struct scan_attr *pstrHostIFscanAttr)
 {
 	s32 s32Error = 0;
@@ -1228,7 +1228,7 @@ static s32 Handle_Scan(tstrWILC_WFIDrv *drvHandler,
 	u8 *pu8Buffer;
 	u8 valuesize = 0;
 	u8 *pu8HdnNtwrksWidVal = NULL;
-	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *) drvHandler;
+	struct host_if_drv *pstrWFIDrv = (struct host_if_drv *) drvHandler;
 
 	PRINT_D(HOSTINF_DBG, "Setting SCAN params\n");
 	PRINT_D(HOSTINF_DBG, "Scanning: In [%d] state\n", pstrWFIDrv->enuHostIFstate);
@@ -1385,11 +1385,11 @@ ERRORHANDLER:
  *  @date
  *  @version	1.0
  */
-static s32 Handle_ScanDone(tstrWILC_WFIDrv *drvHandler, tenuScanEvent enuEvent)
+static s32 Handle_ScanDone(struct host_if_drv *drvHandler, tenuScanEvent enuEvent)
 {
 	s32 s32Error = 0;
 
-	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)drvHandler;
+	struct host_if_drv *pstrWFIDrv = (struct host_if_drv *)drvHandler;
 
 
 	u8 u8abort_running_scan;
@@ -1442,10 +1442,10 @@ static s32 Handle_ScanDone(tstrWILC_WFIDrv *drvHandler, tenuScanEvent enuEvent)
  *  @version	1.0
  */
 u8 u8ConnectedSSID[6] = {0};
-static s32 Handle_Connect(tstrWILC_WFIDrv *drvHandler,
+static s32 Handle_Connect(struct host_if_drv *drvHandler,
 			  struct connect_attr *pstrHostIFconnectAttr)
 {
-	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *) drvHandler;
+	struct host_if_drv *pstrWFIDrv = (struct host_if_drv *) drvHandler;
 	s32 s32Error = 0;
 	tstrWID strWIDList[8];
 	u32 u32WidsCount = 0, dummyval = 0;
@@ -1805,7 +1805,7 @@ ERRORHANDLER:
  *  @version		8.0
  */
 
-static s32 Handle_FlushConnect(tstrWILC_WFIDrv *drvHandler)
+static s32 Handle_FlushConnect(struct host_if_drv *drvHandler)
 {
 	s32 s32Error = 0;
 	tstrWID strWIDList[5];
@@ -1864,13 +1864,13 @@ static s32 Handle_FlushConnect(tstrWILC_WFIDrv *drvHandler)
  *  @date
  *  @version	1.0
  */
-static s32 Handle_ConnectTimeout(tstrWILC_WFIDrv *drvHandler)
+static s32 Handle_ConnectTimeout(struct host_if_drv *drvHandler)
 {
 	s32 s32Error = 0;
 	tstrConnectInfo strConnectInfo;
 	tstrWID strWID;
 	u16 u16DummyReasonCode = 0;
-	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *) drvHandler;
+	struct host_if_drv *pstrWFIDrv = (struct host_if_drv *) drvHandler;
 
 	if (pstrWFIDrv == NULL)	{
 		PRINT_ER("Driver handler is NULL\n");
@@ -1972,7 +1972,7 @@ static s32 Handle_ConnectTimeout(tstrWILC_WFIDrv *drvHandler)
  *  @date
  *  @version	1.0
  */
-static s32 Handle_RcvdNtwrkInfo(tstrWILC_WFIDrv *drvHandler,
+static s32 Handle_RcvdNtwrkInfo(struct host_if_drv *drvHandler,
 				struct rcvd_net_info *pstrRcvdNetworkInfo)
 {
 	u32 i;
@@ -1984,7 +1984,7 @@ static s32 Handle_RcvdNtwrkInfo(tstrWILC_WFIDrv *drvHandler,
 	tstrNetworkInfo *pstrNetworkInfo = NULL;
 	void *pJoinParams = NULL;
 
-	tstrWILC_WFIDrv *pstrWFIDrv  = (tstrWILC_WFIDrv *)drvHandler;
+	struct host_if_drv *pstrWFIDrv  = (struct host_if_drv *)drvHandler;
 
 
 
@@ -2088,7 +2088,7 @@ done:
  *  @date
  *  @version	1.0
  */
-static s32 Handle_RcvdGnrlAsyncInfo(tstrWILC_WFIDrv *drvHandler,
+static s32 Handle_RcvdGnrlAsyncInfo(struct host_if_drv *drvHandler,
 				    struct rcvd_async_info *pstrRcvdGnrlAsyncInfo)
 {
 	/* TODO: mostafa: till now, this function just handles only the received mac status msg, */
@@ -2105,7 +2105,7 @@ static s32 Handle_RcvdGnrlAsyncInfo(tstrWILC_WFIDrv *drvHandler,
 	tstrConnectInfo strConnectInfo;
 	tstrDisconnectNotifInfo strDisconnectNotifInfo;
 	s32 s32Err = 0;
-	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *) drvHandler;
+	struct host_if_drv *pstrWFIDrv = (struct host_if_drv *) drvHandler;
 
 	if (!pstrWFIDrv) {
 		PRINT_ER("Driver handler is NULL\n");
@@ -2404,7 +2404,7 @@ static s32 Handle_RcvdGnrlAsyncInfo(tstrWILC_WFIDrv *drvHandler,
  *  @date
  *  @version	1.0
  */
-static int Handle_Key(tstrWILC_WFIDrv *drvHandler,
+static int Handle_Key(struct host_if_drv *drvHandler,
 		      struct key_attr *pstrHostIFkeyAttr)
 {
 	s32 s32Error = 0;
@@ -2414,7 +2414,7 @@ static int Handle_Key(tstrWILC_WFIDrv *drvHandler,
 	u8 *pu8keybuf;
 	s8 s8idxarray[1];
 	s8 ret = 0;
-	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)drvHandler;
+	struct host_if_drv *pstrWFIDrv = (struct host_if_drv *)drvHandler;
 
 
 	switch (pstrHostIFkeyAttr->enuKeyType) {
@@ -2768,13 +2768,13 @@ _WPAPtk_end_case_:
  *  @date
  *  @version	1.0
  */
-static void Handle_Disconnect(tstrWILC_WFIDrv *drvHandler)
+static void Handle_Disconnect(struct host_if_drv *drvHandler)
 {
 	tstrWID strWID;
 
 	s32 s32Error = 0;
 	u16 u16DummyReasonCode = 0;
-	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)drvHandler;
+	struct host_if_drv *pstrWFIDrv = (struct host_if_drv *)drvHandler;
 
 
 	strWID.u16WIDid = (u16)WID_DISCONNECT;
@@ -2871,11 +2871,11 @@ static void Handle_Disconnect(tstrWILC_WFIDrv *drvHandler)
 }
 
 
-void resolve_disconnect_aberration(tstrWILC_WFIDrv *drvHandler)
+void resolve_disconnect_aberration(struct host_if_drv *drvHandler)
 {
-	tstrWILC_WFIDrv *pstrWFIDrv;
+	struct host_if_drv *pstrWFIDrv;
 
-	pstrWFIDrv = (tstrWILC_WFIDrv *)drvHandler;
+	pstrWFIDrv = (struct host_if_drv *)drvHandler;
 	if (pstrWFIDrv  == NULL)
 		return;
 	if ((pstrWFIDrv->enuHostIFstate == HOST_IF_WAITING_CONN_RESP) || (pstrWFIDrv->enuHostIFstate == HOST_IF_CONNECTING)) {
@@ -2894,13 +2894,12 @@ void resolve_disconnect_aberration(tstrWILC_WFIDrv *drvHandler)
  *  @date
  *  @version	1.0
  */
-static s32 Handle_GetChnl(tstrWILC_WFIDrv *drvHandler)
+static s32 Handle_GetChnl(struct host_if_drv *drvHandler)
 {
 
 	s32 s32Error = 0;
 	tstrWID	strWID;
-	/* tstrWILC_WFIDrv * pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv; */
-	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)drvHandler;
+	struct host_if_drv *pstrWFIDrv = (struct host_if_drv *)drvHandler;
 
 	strWID.u16WIDid = (u16)WID_CURRENT_CHANNEL;
 	strWID.enuWIDtype = WID_CHAR;
@@ -2935,11 +2934,11 @@ static s32 Handle_GetChnl(tstrWILC_WFIDrv *drvHandler)
  *  @date
  *  @version	1.0
  */
-static void Handle_GetRssi(tstrWILC_WFIDrv *drvHandler)
+static void Handle_GetRssi(struct host_if_drv *drvHandler)
 {
 	s32 s32Error = 0;
 	tstrWID strWID;
-	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)drvHandler;
+	struct host_if_drv *pstrWFIDrv = (struct host_if_drv *)drvHandler;
 
 	strWID.u16WIDid = (u16)WID_RSSI;
 	strWID.enuWIDtype = WID_CHAR;
@@ -2962,11 +2961,11 @@ static void Handle_GetRssi(tstrWILC_WFIDrv *drvHandler)
 }
 
 
-static void Handle_GetLinkspeed(tstrWILC_WFIDrv *drvHandler)
+static void Handle_GetLinkspeed(struct host_if_drv *drvHandler)
 {
 	s32 s32Error = 0;
 	tstrWID strWID;
-	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)drvHandler;
+	struct host_if_drv *pstrWFIDrv = (struct host_if_drv *)drvHandler;
 
 	gs8lnkspd = 0;
 
@@ -2989,7 +2988,7 @@ static void Handle_GetLinkspeed(tstrWILC_WFIDrv *drvHandler)
 
 }
 
-s32 Handle_GetStatistics(tstrWILC_WFIDrv *drvHandler, tstrStatistics *pstrStatistics)
+s32 Handle_GetStatistics(struct host_if_drv *drvHandler, tstrStatistics *pstrStatistics)
 {
 	tstrWID strWIDList[5];
 	u32 u32WidsCount = 0, s32Error = 0;
@@ -3046,14 +3045,14 @@ s32 Handle_GetStatistics(tstrWILC_WFIDrv *drvHandler, tstrStatistics *pstrStatis
  *  @date
  *  @version	1.0
  */
-static s32 Handle_Get_InActiveTime(tstrWILC_WFIDrv *drvHandler,
+static s32 Handle_Get_InActiveTime(struct host_if_drv *drvHandler,
 				   struct sta_inactive_t *strHostIfStaInactiveT)
 {
 
 	s32 s32Error = 0;
 	u8 *stamac;
 	tstrWID	strWID;
-	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)drvHandler;
+	struct host_if_drv *pstrWFIDrv = (struct host_if_drv *)drvHandler;
 
 
 	strWID.u16WIDid = (u16)WID_SET_STA_MAC_INACTIVE_TIME;
@@ -3113,13 +3112,13 @@ static s32 Handle_Get_InActiveTime(tstrWILC_WFIDrv *drvHandler,
  *  @date
  *  @version	1.0
  */
-static void Handle_AddBeacon(tstrWILC_WFIDrv *drvHandler,
+static void Handle_AddBeacon(struct host_if_drv *drvHandler,
 			     struct beacon_attr *pstrSetBeaconParam)
 {
 	s32 s32Error = 0;
 	tstrWID strWID;
 	u8 *pu8CurrByte;
-	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)drvHandler;
+	struct host_if_drv *pstrWFIDrv = (struct host_if_drv *)drvHandler;
 
 	PRINT_D(HOSTINF_DBG, "Adding BEACON\n");
 
@@ -3176,18 +3175,18 @@ ERRORHANDLER:
 /**
  *  @brief Handle_AddBeacon
  *  @details       Sending config packet to delete beacon
- *  @param[in]	tstrWILC_WFIDrv *drvHandler
+ *  @param[in]	struct host_if_drv *drvHandler
  *  @return         NONE
  *  @author
  *  @date
  *  @version	1.0
  */
-static void Handle_DelBeacon(tstrWILC_WFIDrv *drvHandler)
+static void Handle_DelBeacon(struct host_if_drv *drvHandler)
 {
 	s32 s32Error = 0;
 	tstrWID strWID;
 	u8 *pu8CurrByte;
-	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)drvHandler;
+	struct host_if_drv *pstrWFIDrv = (struct host_if_drv *)drvHandler;
 
 	strWID.u16WIDid = (u16)WID_DEL_BEACON;
 	strWID.enuWIDtype = WID_CHAR;
@@ -3274,13 +3273,13 @@ static u32 WILC_HostIf_PackStaParam(u8 *pu8Buffer,
  *  @date
  *  @version	1.0
  */
-static void Handle_AddStation(tstrWILC_WFIDrv *drvHandler,
+static void Handle_AddStation(struct host_if_drv *drvHandler,
 			      struct add_sta_param *pstrStationParam)
 {
 	s32 s32Error = 0;
 	tstrWID strWID;
 	u8 *pu8CurrByte;
-	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)drvHandler;
+	struct host_if_drv *pstrWFIDrv = (struct host_if_drv *)drvHandler;
 
 	PRINT_D(HOSTINF_DBG, "Handling add station\n");
 	strWID.u16WIDid = (u16)WID_ADD_STA;
@@ -3314,14 +3313,14 @@ ERRORHANDLER:
  *  @date
  *  @version	1.0
  */
-static void Handle_DelAllSta(tstrWILC_WFIDrv *drvHandler,
+static void Handle_DelAllSta(struct host_if_drv *drvHandler,
 			     struct del_all_sta *pstrDelAllStaParam)
 {
 	s32 s32Error = 0;
 
 	tstrWID strWID;
 	u8 *pu8CurrByte;
-	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)drvHandler;
+	struct host_if_drv *pstrWFIDrv = (struct host_if_drv *)drvHandler;
 	u8 i;
 	u8 au8Zero_Buff[6] = {0};
 
@@ -3370,13 +3369,13 @@ ERRORHANDLER:
  *  @date
  *  @version	1.0
  */
-static void Handle_DelStation(tstrWILC_WFIDrv *drvHandler,
+static void Handle_DelStation(struct host_if_drv *drvHandler,
 			      struct del_sta *pstrDelStaParam)
 {
 	s32 s32Error = 0;
 	tstrWID strWID;
 	u8 *pu8CurrByte;
-	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)drvHandler;
+	struct host_if_drv *pstrWFIDrv = (struct host_if_drv *)drvHandler;
 
 	strWID.u16WIDid = (u16)WID_REMOVE_STA;
 	strWID.enuWIDtype = WID_BIN;
@@ -3412,13 +3411,13 @@ ERRORHANDLER:
  *  @date
  *  @version	1.0
  */
-static void Handle_EditStation(tstrWILC_WFIDrv *drvHandler,
+static void Handle_EditStation(struct host_if_drv *drvHandler,
 			       struct add_sta_param *pstrStationParam)
 {
 	s32 s32Error = 0;
 	tstrWID strWID;
 	u8 *pu8CurrByte;
-	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)drvHandler;
+	struct host_if_drv *pstrWFIDrv = (struct host_if_drv *)drvHandler;
 
 	strWID.u16WIDid = (u16)WID_EDIT_STA;
 	strWID.enuWIDtype = WID_BIN;
@@ -3452,13 +3451,13 @@ ERRORHANDLER:
  *  @date
  *  @version	1.0
  */
-static int Handle_RemainOnChan(tstrWILC_WFIDrv *drvHandler,
+static int Handle_RemainOnChan(struct host_if_drv *drvHandler,
 			       struct remain_ch *pstrHostIfRemainOnChan)
 {
 	s32 s32Error = 0;
 	u8 u8remain_on_chan_flag;
 	tstrWID strWID;
-	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *) drvHandler;
+	struct host_if_drv *pstrWFIDrv = (struct host_if_drv *) drvHandler;
 
 	/*If it's a pendig remain-on-channel, don't overwrite gWFiDrvHandle values (since incoming msg is garbbage)*/
 	if (!pstrWFIDrv->u8RemainOnChan_pendingreq) {
@@ -3539,13 +3538,13 @@ ERRORHANDLER:
  *  @date
  *  @version	1.0
  */
-static int Handle_RegisterFrame(tstrWILC_WFIDrv *drvHandler,
+static int Handle_RegisterFrame(struct host_if_drv *drvHandler,
 				struct reg_frame *pstrHostIfRegisterFrame)
 {
 	s32 s32Error = 0;
 	tstrWID strWID;
 	u8 *pu8CurrByte;
-	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)drvHandler;
+	struct host_if_drv *pstrWFIDrv = (struct host_if_drv *)drvHandler;
 
 	PRINT_D(HOSTINF_DBG, "Handling frame register Flag : %d FrameType: %d\n", pstrHostIfRegisterFrame->bReg, pstrHostIfRegisterFrame->u16FrameType);
 
@@ -3588,13 +3587,13 @@ static int Handle_RegisterFrame(tstrWILC_WFIDrv *drvHandler,
  *  @version		1.0
  */
 #define FALSE_FRMWR_CHANNEL 100
-static u32 Handle_ListenStateExpired(tstrWILC_WFIDrv *drvHandler,
+static u32 Handle_ListenStateExpired(struct host_if_drv *drvHandler,
 				     struct remain_ch *pstrHostIfRemainOnChan)
 {
 	u8 u8remain_on_chan_flag;
 	tstrWID strWID;
 	s32 s32Error = 0;
-	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *) drvHandler;
+	struct host_if_drv *pstrWFIDrv = (struct host_if_drv *) drvHandler;
 
 	PRINT_D(HOSTINF_DBG, "CANCEL REMAIN ON CHAN\n");
 
@@ -3649,7 +3648,7 @@ static void ListenTimerCB(unsigned long arg)
 {
 	s32 s32Error = 0;
 	struct host_if_msg msg;
-	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)arg;
+	struct host_if_drv *pstrWFIDrv = (struct host_if_drv *)arg;
 	/*Stopping remain-on-channel timer*/
 	del_timer(&pstrWFIDrv->hRemainOnChannel);
 
@@ -3674,13 +3673,13 @@ static void ListenTimerCB(unsigned long arg)
  *  @date
  *  @version	1.0
  */
-static void Handle_PowerManagement(tstrWILC_WFIDrv *drvHandler,
+static void Handle_PowerManagement(struct host_if_drv *drvHandler,
 				   struct power_mgmt_param *strPowerMgmtParam)
 {
 	s32 s32Error = 0;
 	tstrWID strWID;
 	s8 s8PowerMode;
-	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)drvHandler;
+	struct host_if_drv *pstrWFIDrv = (struct host_if_drv *)drvHandler;
 
 	strWID.u16WIDid = (u16)WID_POWER_MANAGEMENT;
 
@@ -3710,7 +3709,7 @@ static void Handle_PowerManagement(tstrWILC_WFIDrv *drvHandler,
  *  @date
  *  @version	1.0
  */
-static void Handle_SetMulticastFilter(tstrWILC_WFIDrv *drvHandler,
+static void Handle_SetMulticastFilter(struct host_if_drv *drvHandler,
 				      struct set_multicast *strHostIfSetMulti)
 {
 	s32 s32Error = 0;
@@ -3761,14 +3760,14 @@ ERRORHANDLER:
  *  @date			Feb. 2014
  *  @version		9.0
  */
-static s32 Handle_AddBASession(tstrWILC_WFIDrv *drvHandler,
+static s32 Handle_AddBASession(struct host_if_drv *drvHandler,
 			       struct ba_session_info *strHostIfBASessionInfo)
 {
 	s32 s32Error = 0;
 	tstrWID strWID;
 	int AddbaTimeout = 100;
 	char *ptr = NULL;
-	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)drvHandler;
+	struct host_if_drv *pstrWFIDrv = (struct host_if_drv *)drvHandler;
 
 	PRINT_D(HOSTINF_DBG, "Opening Block Ack session with\nBSSID = %.2x:%.2x:%.2x\nTID=%d\nBufferSize == %d\nSessionTimeOut = %d\n",
 		strHostIfBASessionInfo->au8Bssid[0],
@@ -3850,13 +3849,13 @@ static s32 Handle_AddBASession(tstrWILC_WFIDrv *drvHandler,
  *  @date			Feb. 2013
  *  @version		9.0
  */
-static s32 Handle_DelAllRxBASessions(tstrWILC_WFIDrv *drvHandler,
+static s32 Handle_DelAllRxBASessions(struct host_if_drv *drvHandler,
 				     struct ba_session_info *strHostIfBASessionInfo)
 {
 	s32 s32Error = 0;
 	tstrWID strWID;
 	char *ptr = NULL;
-	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)drvHandler;
+	struct host_if_drv *pstrWFIDrv = (struct host_if_drv *)drvHandler;
 
 	PRINT_D(GENERIC_DBG, "Delete Block Ack session with\nBSSID = %.2x:%.2x:%.2x\nTID=%d\n",
 		strHostIfBASessionInfo->au8Bssid[0],
@@ -3908,13 +3907,13 @@ static int hostIFthread(void *pvArg)
 {
 	u32 u32Ret;
 	struct host_if_msg msg;
-	tstrWILC_WFIDrv *pstrWFIDrv;
+	struct host_if_drv *pstrWFIDrv;
 
 	memset(&msg, 0, sizeof(struct host_if_msg));
 
 	while (1) {
 		wilc_mq_recv(&gMsgQHostIF, &msg, sizeof(struct host_if_msg), &u32Ret);
-		pstrWFIDrv = (tstrWILC_WFIDrv *)msg.drvHandler;
+		pstrWFIDrv = (struct host_if_drv *)msg.drvHandler;
 		if (msg.id == HOST_IF_MSG_EXIT) {
 			PRINT_D(GENERIC_DBG, "THREAD: Exiting HostIfThread\n");
 			break;
@@ -4159,11 +4158,10 @@ static void TimerCB_Connect(unsigned long arg)
  *  @version		1.0
  */
 /* Check implementation in core adding 9 bytes to the input! */
-s32 host_int_remove_key(tstrWILC_WFIDrv *hWFIDrv, const u8 *pu8StaAddress)
+s32 host_int_remove_key(struct host_if_drv *hWFIDrv, const u8 *pu8StaAddress)
 {
 	s32 s32Error = 0;
 	tstrWID strWID;
-	/* tstrWILC_WFIDrv * pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv; */
 
 	strWID.u16WIDid	= (u16)WID_REMOVE_KEY;
 	strWID.enuWIDtype	= WID_STR;
@@ -4188,10 +4186,10 @@ s32 host_int_remove_key(tstrWILC_WFIDrv *hWFIDrv, const u8 *pu8StaAddress)
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 host_int_remove_wep_key(tstrWILC_WFIDrv *hWFIDrv, u8 u8keyIdx)
+s32 host_int_remove_wep_key(struct host_if_drv *hWFIDrv, u8 u8keyIdx)
 {
 	s32 s32Error = 0;
-	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
+	struct host_if_drv *pstrWFIDrv = (struct host_if_drv *)hWFIDrv;
 	struct host_if_msg msg;
 
 
@@ -4236,10 +4234,10 @@ s32 host_int_remove_wep_key(tstrWILC_WFIDrv *hWFIDrv, u8 u8keyIdx)
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 host_int_set_WEPDefaultKeyID(tstrWILC_WFIDrv *hWFIDrv, u8 u8Index)
+s32 host_int_set_WEPDefaultKeyID(struct host_if_drv *hWFIDrv, u8 u8Index)
 {
 	s32 s32Error = 0;
-	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
+	struct host_if_drv *pstrWFIDrv = (struct host_if_drv *)hWFIDrv;
 	struct host_if_msg msg;
 
 
@@ -4290,11 +4288,11 @@ s32 host_int_set_WEPDefaultKeyID(tstrWILC_WFIDrv *hWFIDrv, u8 u8Index)
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 host_int_add_wep_key_bss_sta(tstrWILC_WFIDrv *hWFIDrv, const u8 *pu8WepKey, u8 u8WepKeylen, u8 u8Keyidx)
+s32 host_int_add_wep_key_bss_sta(struct host_if_drv *hWFIDrv, const u8 *pu8WepKey, u8 u8WepKeylen, u8 u8Keyidx)
 {
 
 	s32 s32Error = 0;
-	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
+	struct host_if_drv *pstrWFIDrv = (struct host_if_drv *)hWFIDrv;
 	struct host_if_msg msg;
 
 	if (pstrWFIDrv == NULL) {
@@ -4352,11 +4350,11 @@ s32 host_int_add_wep_key_bss_sta(tstrWILC_WFIDrv *hWFIDrv, const u8 *pu8WepKey,
  *  @date		28 FEB 2013
  *  @version		1.0
  */
-s32 host_int_add_wep_key_bss_ap(tstrWILC_WFIDrv *hWFIDrv, const u8 *pu8WepKey, u8 u8WepKeylen, u8 u8Keyidx, u8 u8mode, enum AUTHTYPE tenuAuth_type)
+s32 host_int_add_wep_key_bss_ap(struct host_if_drv *hWFIDrv, const u8 *pu8WepKey, u8 u8WepKeylen, u8 u8Keyidx, u8 u8mode, enum AUTHTYPE tenuAuth_type)
 {
 
 	s32 s32Error = 0;
-	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
+	struct host_if_drv *pstrWFIDrv = (struct host_if_drv *)hWFIDrv;
 	struct host_if_msg msg;
 	u8 i;
 
@@ -4425,11 +4423,11 @@ s32 host_int_add_wep_key_bss_ap(tstrWILC_WFIDrv *hWFIDrv, const u8 *pu8WepKey, u
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 host_int_add_ptk(tstrWILC_WFIDrv *hWFIDrv, const u8 *pu8Ptk, u8 u8PtkKeylen,
+s32 host_int_add_ptk(struct host_if_drv *hWFIDrv, const u8 *pu8Ptk, u8 u8PtkKeylen,
 			     const u8 *mac_addr, const u8 *pu8RxMic, const u8 *pu8TxMic, u8 mode, u8 u8Ciphermode, u8 u8Idx)
 {
 	s32 s32Error = 0;
-	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
+	struct host_if_drv *pstrWFIDrv = (struct host_if_drv *)hWFIDrv;
 	struct host_if_msg msg;
 	u8 u8KeyLen = u8PtkKeylen;
 	u32 i;
@@ -4520,12 +4518,12 @@ s32 host_int_add_ptk(tstrWILC_WFIDrv *hWFIDrv, const u8 *pu8Ptk, u8 u8PtkKeylen,
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 host_int_add_rx_gtk(tstrWILC_WFIDrv *hWFIDrv, const u8 *pu8RxGtk, u8 u8GtkKeylen,
+s32 host_int_add_rx_gtk(struct host_if_drv *hWFIDrv, const u8 *pu8RxGtk, u8 u8GtkKeylen,
 				u8 u8KeyIdx, u32 u32KeyRSClen, const u8 *KeyRSC,
 				const u8 *pu8RxMic, const u8 *pu8TxMic, u8 mode, u8 u8Ciphermode)
 {
 	s32 s32Error = 0;
-	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
+	struct host_if_drv *pstrWFIDrv = (struct host_if_drv *)hWFIDrv;
 	struct host_if_msg msg;
 	u8 u8KeyLen = u8GtkKeylen;
 
@@ -4623,10 +4621,10 @@ s32 host_int_add_rx_gtk(tstrWILC_WFIDrv *hWFIDrv, const u8 *pu8RxGtk, u8 u8GtkKe
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 host_int_set_pmkid_info(tstrWILC_WFIDrv *hWFIDrv, struct host_if_pmkid_attr *pu8PmkidInfoArray)
+s32 host_int_set_pmkid_info(struct host_if_drv *hWFIDrv, struct host_if_pmkid_attr *pu8PmkidInfoArray)
 {
 	s32 s32Error = 0;
-	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
+	struct host_if_drv *pstrWFIDrv = (struct host_if_drv *)hWFIDrv;
 	struct host_if_msg msg;
 	u32 i;
 
@@ -4683,12 +4681,11 @@ s32 host_int_set_pmkid_info(tstrWILC_WFIDrv *hWFIDrv, struct host_if_pmkid_attr
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 host_int_get_pmkid_info(tstrWILC_WFIDrv *hWFIDrv, u8 *pu8PmkidInfoArray,
+s32 host_int_get_pmkid_info(struct host_if_drv *hWFIDrv, u8 *pu8PmkidInfoArray,
 				    u32 u32PmkidInfoLen)
 {
 	s32 s32Error = 0;
 	tstrWID strWID;
-	/* tstrWILC_WFIDrv * pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv; */
 
 	strWID.u16WIDid	= (u16)WID_PMKID_INFO;
 	strWID.enuWIDtype	= WID_STR;
@@ -4712,7 +4709,7 @@ s32 host_int_get_pmkid_info(tstrWILC_WFIDrv *hWFIDrv, u8 *pu8PmkidInfoArray,
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 host_int_set_RSNAConfigPSKPassPhrase(tstrWILC_WFIDrv *hWFIDrv, u8 *pu8PassPhrase,
+s32 host_int_set_RSNAConfigPSKPassPhrase(struct host_if_drv *hWFIDrv, u8 *pu8PassPhrase,
 						 u8 u8Psklength)
 {
 	s32 s32Error = 0;
@@ -4739,7 +4736,7 @@ s32 host_int_set_RSNAConfigPSKPassPhrase(tstrWILC_WFIDrv *hWFIDrv, u8 *pu8PassPh
  *  @date		19 April 2012
  *  @version		1.0
  */
-s32 host_int_get_MacAddress(tstrWILC_WFIDrv *hWFIDrv, u8 *pu8MacAddress)
+s32 host_int_get_MacAddress(struct host_if_drv *hWFIDrv, u8 *pu8MacAddress)
 {
 	s32 s32Error = 0;
 	struct host_if_msg msg;
@@ -4773,7 +4770,7 @@ s32 host_int_get_MacAddress(tstrWILC_WFIDrv *hWFIDrv, u8 *pu8MacAddress)
  *  @date		16 July 2012
  *  @version		1.0
  */
-s32 host_int_set_MacAddress(tstrWILC_WFIDrv *hWFIDrv, u8 *pu8MacAddress)
+s32 host_int_set_MacAddress(struct host_if_drv *hWFIDrv, u8 *pu8MacAddress)
 {
 	s32 s32Error = 0;
 	struct host_if_msg msg;
@@ -4808,12 +4805,11 @@ s32 host_int_set_MacAddress(tstrWILC_WFIDrv *hWFIDrv, u8 *pu8MacAddress)
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 host_int_get_RSNAConfigPSKPassPhrase(tstrWILC_WFIDrv *hWFIDrv,
+s32 host_int_get_RSNAConfigPSKPassPhrase(struct host_if_drv *hWFIDrv,
 						 u8 *pu8PassPhrase, u8 u8Psklength)
 {
 	s32 s32Error = 0;
 	tstrWID strWID;
-	/* tstrWILC_WFIDrv * pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv; */
 
 	strWID.u16WIDid	= (u16)WID_11I_PSK;
 	strWID.enuWIDtype	= WID_STR;
@@ -4838,11 +4834,10 @@ s32 host_int_get_RSNAConfigPSKPassPhrase(tstrWILC_WFIDrv *hWFIDrv,
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 host_int_set_start_scan_req(tstrWILC_WFIDrv *hWFIDrv, u8 scanSource)
+s32 host_int_set_start_scan_req(struct host_if_drv *hWFIDrv, u8 scanSource)
 {
 	s32 s32Error = 0;
 	tstrWID strWID;
-	/* tstrWILC_WFIDrv * pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv; */
 
 	strWID.u16WIDid = (u16)WID_START_SCAN_REQ;
 	strWID.enuWIDtype = WID_CHAR;
@@ -4868,11 +4863,10 @@ s32 host_int_set_start_scan_req(tstrWILC_WFIDrv *hWFIDrv, u8 scanSource)
  *  @version		1.0
  */
 
-s32 host_int_get_start_scan_req(tstrWILC_WFIDrv *hWFIDrv, u8 *pu8ScanSource)
+s32 host_int_get_start_scan_req(struct host_if_drv *hWFIDrv, u8 *pu8ScanSource)
 {
 	s32 s32Error = 0;
 	tstrWID strWID;
-	/* tstrWILC_WFIDrv * pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv; */
 
 	strWID.u16WIDid = (u16)WID_START_SCAN_REQ;
 	strWID.enuWIDtype = WID_CHAR;
@@ -4893,7 +4887,7 @@ s32 host_int_get_start_scan_req(tstrWILC_WFIDrv *hWFIDrv, u8 *pu8ScanSource)
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 host_int_set_join_req(tstrWILC_WFIDrv *hWFIDrv, u8 *pu8bssid,
+s32 host_int_set_join_req(struct host_if_drv *hWFIDrv, u8 *pu8bssid,
 				  const u8 *pu8ssid, size_t ssidLen,
 				  const u8 *pu8IEs, size_t IEsLen,
 				  wilc_connect_result pfConnectResult, void *pvUserArg,
@@ -4902,7 +4896,7 @@ s32 host_int_set_join_req(tstrWILC_WFIDrv *hWFIDrv, u8 *pu8bssid,
 				  void *pJoinParams)
 {
 	s32 s32Error = 0;
-	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
+	struct host_if_drv *pstrWFIDrv = (struct host_if_drv *)hWFIDrv;
 	struct host_if_msg msg;
 	tenuScanConnTimer enuScanConnTimer;
 
@@ -4987,7 +4981,7 @@ s32 host_int_set_join_req(tstrWILC_WFIDrv *hWFIDrv, u8 *pu8bssid,
  *  @version	8.0
  */
 
-s32 host_int_flush_join_req(tstrWILC_WFIDrv *hWFIDrv)
+s32 host_int_flush_join_req(struct host_if_drv *hWFIDrv)
 {
 	s32 s32Error = 0;
 	struct host_if_msg msg;
@@ -5028,11 +5022,11 @@ s32 host_int_flush_join_req(tstrWILC_WFIDrv *hWFIDrv)
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 host_int_disconnect(tstrWILC_WFIDrv *hWFIDrv, u16 u16ReasonCode)
+s32 host_int_disconnect(struct host_if_drv *hWFIDrv, u16 u16ReasonCode)
 {
 	s32 s32Error = 0;
 	struct host_if_msg msg;
-	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
+	struct host_if_drv *pstrWFIDrv = (struct host_if_drv *)hWFIDrv;
 
 	if (pstrWFIDrv == NULL) {
 		PRINT_ER("Driver is null\n");
@@ -5067,11 +5061,10 @@ s32 host_int_disconnect(tstrWILC_WFIDrv *hWFIDrv, u16 u16ReasonCode)
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 host_int_disconnect_station(tstrWILC_WFIDrv *hWFIDrv, u8 assoc_id)
+s32 host_int_disconnect_station(struct host_if_drv *hWFIDrv, u8 assoc_id)
 {
 	s32 s32Error = 0;
 	tstrWID strWID;
-	/* tstrWILC_WFIDrv * pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv; */
 
 	strWID.u16WIDid = (u16)WID_DISCONNECT;
 	strWID.enuWIDtype = WID_CHAR;
@@ -5107,12 +5100,11 @@ s32 host_int_disconnect_station(tstrWILC_WFIDrv *hWFIDrv, u8 assoc_id)
  *  @version		1.0
  */
 
-s32 host_int_get_assoc_req_info(tstrWILC_WFIDrv *hWFIDrv, u8 *pu8AssocReqInfo,
+s32 host_int_get_assoc_req_info(struct host_if_drv *hWFIDrv, u8 *pu8AssocReqInfo,
 					u32 u32AssocReqInfoLen)
 {
 	s32 s32Error = 0;
 	tstrWID strWID;
-	/* tstrWILC_WFIDrv * pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv; */
 
 	strWID.u16WIDid = (u16)WID_ASSOC_REQ_INFO;
 	strWID.enuWIDtype = WID_STR;
@@ -5134,12 +5126,12 @@ s32 host_int_get_assoc_req_info(tstrWILC_WFIDrv *hWFIDrv, u8 *pu8AssocReqInfo,
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 host_int_get_assoc_res_info(tstrWILC_WFIDrv *hWFIDrv, u8 *pu8AssocRespInfo,
+s32 host_int_get_assoc_res_info(struct host_if_drv *hWFIDrv, u8 *pu8AssocRespInfo,
 					u32 u32MaxAssocRespInfoLen, u32 *pu32RcvdAssocRespInfoLen)
 {
 	s32 s32Error = 0;
 	tstrWID strWID;
-	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
+	struct host_if_drv *pstrWFIDrv = (struct host_if_drv *)hWFIDrv;
 
 	if (pstrWFIDrv == NULL) {
 		PRINT_ER("Driver is null\n");
@@ -5181,12 +5173,11 @@ s32 host_int_get_assoc_res_info(tstrWILC_WFIDrv *hWFIDrv, u8 *pu8AssocRespInfo,
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 host_int_get_rx_power_level(tstrWILC_WFIDrv *hWFIDrv, u8 *pu8RxPowerLevel,
+s32 host_int_get_rx_power_level(struct host_if_drv *hWFIDrv, u8 *pu8RxPowerLevel,
 					u32 u32RxPowerLevelLen)
 {
 	s32 s32Error = 0;
 	tstrWID strWID;
-	/* tstrWILC_WFIDrv * pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv; */
 
 	strWID.u16WIDid = (u16)WID_RX_POWER_LEVEL;
 	strWID.enuWIDtype = WID_STR;
@@ -5212,10 +5203,10 @@ s32 host_int_get_rx_power_level(tstrWILC_WFIDrv *hWFIDrv, u8 *pu8RxPowerLevel,
  *  @date		8 March 2012
  *  @version		1.0
  */
-int host_int_set_mac_chnl_num(tstrWILC_WFIDrv *wfi_drv, u8 channel)
+int host_int_set_mac_chnl_num(struct host_if_drv *wfi_drv, u8 channel)
 {
 	int result = 0;
-	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)wfi_drv;
+	struct host_if_drv *pstrWFIDrv = (struct host_if_drv *)wfi_drv;
 	struct host_if_msg msg;
 
 	if (!pstrWFIDrv) {
@@ -5261,7 +5252,7 @@ int host_int_wait_msg_queue_idle(void)
 	return result;
 }
 
-s32 host_int_set_wfi_drv_handler(tstrWILC_WFIDrv *u32address)
+s32 host_int_set_wfi_drv_handler(struct host_if_drv *u32address)
 {
 	s32 s32Error = 0;
 
@@ -5286,7 +5277,7 @@ s32 host_int_set_wfi_drv_handler(tstrWILC_WFIDrv *u32address)
 
 
 
-s32 host_int_set_operation_mode(tstrWILC_WFIDrv *hWFIDrv, u32 u32mode)
+s32 host_int_set_operation_mode(struct host_if_drv *hWFIDrv, u32 u32mode)
 {
 	s32 s32Error = 0;
 
@@ -5324,10 +5315,10 @@ s32 host_int_set_operation_mode(tstrWILC_WFIDrv *hWFIDrv, u32 u32mode)
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 host_int_get_host_chnl_num(tstrWILC_WFIDrv *hWFIDrv, u8 *pu8ChNo)
+s32 host_int_get_host_chnl_num(struct host_if_drv *hWFIDrv, u8 *pu8ChNo)
 {
 	s32 s32Error = 0;
-	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
+	struct host_if_drv *pstrWFIDrv = (struct host_if_drv *)hWFIDrv;
 	struct host_if_msg msg;
 
 	if (pstrWFIDrv == NULL) {
@@ -5366,11 +5357,11 @@ s32 host_int_get_host_chnl_num(tstrWILC_WFIDrv *hWFIDrv, u8 *pu8ChNo)
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 host_int_test_set_int_wid(tstrWILC_WFIDrv *hWFIDrv, u32 u32TestMemAddr)
+s32 host_int_test_set_int_wid(struct host_if_drv *hWFIDrv, u32 u32TestMemAddr)
 {
 	s32 s32Error = 0;
 	tstrWID	strWID;
-	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
+	struct host_if_drv *pstrWFIDrv = (struct host_if_drv *)hWFIDrv;
 
 
 	if (pstrWFIDrv == NULL) {
@@ -5409,10 +5400,10 @@ s32 host_int_test_set_int_wid(tstrWILC_WFIDrv *hWFIDrv, u32 u32TestMemAddr)
  *  @date
  *  @version		1.0
  */
-s32 host_int_get_inactive_time(tstrWILC_WFIDrv *hWFIDrv, const u8 *mac, u32 *pu32InactiveTime)
+s32 host_int_get_inactive_time(struct host_if_drv *hWFIDrv, const u8 *mac, u32 *pu32InactiveTime)
 {
 	s32 s32Error = 0;
-	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
+	struct host_if_drv *pstrWFIDrv = (struct host_if_drv *)hWFIDrv;
 	struct host_if_msg msg;
 
 	if (pstrWFIDrv == NULL) {
@@ -5451,12 +5442,12 @@ s32 host_int_get_inactive_time(tstrWILC_WFIDrv *hWFIDrv, const u8 *mac, u32 *pu3
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 host_int_test_get_int_wid(tstrWILC_WFIDrv *hWFIDrv, u32 *pu32TestMemAddr)
+s32 host_int_test_get_int_wid(struct host_if_drv *hWFIDrv, u32 *pu32TestMemAddr)
 {
 
 	s32 s32Error = 0;
 	tstrWID	strWID;
-	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
+	struct host_if_drv *pstrWFIDrv = (struct host_if_drv *)hWFIDrv;
 
 
 	if (pstrWFIDrv == NULL) {
@@ -5497,11 +5488,11 @@ s32 host_int_test_get_int_wid(tstrWILC_WFIDrv *hWFIDrv, u32 *pu32TestMemAddr)
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 host_int_get_rssi(tstrWILC_WFIDrv *hWFIDrv, s8 *ps8Rssi)
+s32 host_int_get_rssi(struct host_if_drv *hWFIDrv, s8 *ps8Rssi)
 {
 	s32 s32Error = 0;
 	struct host_if_msg msg;
-	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
+	struct host_if_drv *pstrWFIDrv = (struct host_if_drv *)hWFIDrv;
 
 
 	/* prepare the Get RSSI Message */
@@ -5532,12 +5523,12 @@ s32 host_int_get_rssi(tstrWILC_WFIDrv *hWFIDrv, s8 *ps8Rssi)
 	return s32Error;
 }
 
-s32 host_int_get_link_speed(tstrWILC_WFIDrv *hWFIDrv, s8 *ps8lnkspd)
+s32 host_int_get_link_speed(struct host_if_drv *hWFIDrv, s8 *ps8lnkspd)
 {
 	struct host_if_msg msg;
 	s32 s32Error = 0;
 
-	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
+	struct host_if_drv *pstrWFIDrv = (struct host_if_drv *)hWFIDrv;
 
 
 
@@ -5569,7 +5560,7 @@ s32 host_int_get_link_speed(tstrWILC_WFIDrv *hWFIDrv, s8 *ps8lnkspd)
 	return s32Error;
 }
 
-s32 host_int_get_statistics(tstrWILC_WFIDrv *hWFIDrv, tstrStatistics *pstrStatistics)
+s32 host_int_get_statistics(struct host_if_drv *hWFIDrv, tstrStatistics *pstrStatistics)
 {
 	s32 s32Error = 0;
 	struct host_if_msg msg;
@@ -5609,7 +5600,7 @@ s32 host_int_get_statistics(tstrWILC_WFIDrv *hWFIDrv, tstrStatistics *pstrStatis
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 host_int_scan(tstrWILC_WFIDrv *hWFIDrv, u8 u8ScanSource,
+s32 host_int_scan(struct host_if_drv *hWFIDrv, u8 u8ScanSource,
 			  u8 u8ScanType, u8 *pu8ChnlFreqList,
 			  u8 u8ChnlListLen, const u8 *pu8IEs,
 			  size_t IEsLen, wilc_scan_result ScanResult,
@@ -5617,7 +5608,7 @@ s32 host_int_scan(tstrWILC_WFIDrv *hWFIDrv, u8 u8ScanSource,
 			  struct hidden_network *pstrHiddenNetwork)
 {
 	s32 s32Error = 0;
-	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
+	struct host_if_drv *pstrWFIDrv = (struct host_if_drv *)hWFIDrv;
 	struct host_if_msg msg;
 	tenuScanConnTimer enuScanConnTimer;
 
@@ -5681,11 +5672,11 @@ s32 host_int_scan(tstrWILC_WFIDrv *hWFIDrv, u8 u8ScanSource,
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 hif_set_cfg(tstrWILC_WFIDrv *hWFIDrv, struct cfg_param_val *pstrCfgParamVal)
+s32 hif_set_cfg(struct host_if_drv *hWFIDrv, struct cfg_param_val *pstrCfgParamVal)
 {
 
 	s32 s32Error = 0;
-	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
+	struct host_if_drv *pstrWFIDrv = (struct host_if_drv *)hWFIDrv;
 
 	struct host_if_msg msg;
 
@@ -5720,10 +5711,10 @@ s32 hif_set_cfg(tstrWILC_WFIDrv *hWFIDrv, struct cfg_param_val *pstrCfgParamVal)
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 hif_get_cfg(tstrWILC_WFIDrv *hWFIDrv, u16 u16WID, u16 *pu16WID_Value)
+s32 hif_get_cfg(struct host_if_drv *hWFIDrv, u16 u16WID, u16 *pu16WID_Value)
 {
 	s32 s32Error = 0;
-	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
+	struct host_if_drv *pstrWFIDrv = (struct host_if_drv *)hWFIDrv;
 
 	down(&(pstrWFIDrv->gtOsCfgValuesSem));
 
@@ -5854,7 +5845,7 @@ void host_int_send_join_leave_info_to_host
 
 static void GetPeriodicRSSI(unsigned long arg)
 {
-	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)arg;
+	struct host_if_drv *pstrWFIDrv = (struct host_if_drv *)arg;
 
 	if (pstrWFIDrv == NULL)	{
 		PRINT_ER("Driver handler is NULL\n");
@@ -5898,10 +5889,10 @@ void host_int_send_network_info_to_host
  */
 static u32 clients_count;
 
-s32 host_int_init(tstrWILC_WFIDrv **phWFIDrv)
+s32 host_int_init(struct host_if_drv **phWFIDrv)
 {
 	s32 result = 0;
-	tstrWILC_WFIDrv *pstrWFIDrv;
+	struct host_if_drv *pstrWFIDrv;
 	int err;
 
 	PRINT_D(HOSTINF_DBG, "Initializing host interface for client %d\n", clients_count + 1);
@@ -5911,7 +5902,7 @@ s32 host_int_init(tstrWILC_WFIDrv **phWFIDrv)
 	sema_init(&hWaitResponse, 0);
 
 	/*Allocate host interface private structure*/
-	pstrWFIDrv  = kzalloc(sizeof(tstrWILC_WFIDrv), GFP_KERNEL);
+	pstrWFIDrv  = kzalloc(sizeof(struct host_if_drv), GFP_KERNEL);
 	if (!pstrWFIDrv) {
 		result = -ENOMEM;
 		goto _fail_timer_2;
@@ -6013,14 +6004,14 @@ _fail_:
  *  @version		1.0
  */
 
-s32 host_int_deinit(tstrWILC_WFIDrv *hWFIDrv)
+s32 host_int_deinit(struct host_if_drv *hWFIDrv)
 {
 	s32 s32Error = 0;
 	struct host_if_msg msg;
 	int ret;
 
 	/*obtain driver handle*/
-	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
+	struct host_if_drv *pstrWFIDrv = (struct host_if_drv *)hWFIDrv;
 
 	if (pstrWFIDrv == NULL)	{
 		PRINT_ER("pstrWFIDrv = NULL\n");
@@ -6126,7 +6117,7 @@ void NetworkInfoReceived(u8 *pu8Buffer, u32 u32Length)
 	s32 s32Error = 0;
 	struct host_if_msg msg;
 	int id;
-	tstrWILC_WFIDrv *pstrWFIDrv = NULL;
+	struct host_if_drv *pstrWFIDrv = NULL;
 
 	id = ((pu8Buffer[u32Length - 4]) | (pu8Buffer[u32Length - 3] << 8) | (pu8Buffer[u32Length - 2] << 16) | (pu8Buffer[u32Length - 1] << 24));
 	pstrWFIDrv = get_handler_from_id(id);
@@ -6172,7 +6163,7 @@ void GnrlAsyncInfoReceived(u8 *pu8Buffer, u32 u32Length)
 	s32 s32Error = 0;
 	struct host_if_msg msg;
 	int id;
-	tstrWILC_WFIDrv *pstrWFIDrv = NULL;
+	struct host_if_drv *pstrWFIDrv = NULL;
 
 	down(&hSemHostIntDeinit);
 
@@ -6229,7 +6220,7 @@ void host_int_ScanCompleteReceived(u8 *pu8Buffer, u32 u32Length)
 	s32 s32Error = 0;
 	struct host_if_msg msg;
 	int id;
-	tstrWILC_WFIDrv *pstrWFIDrv = NULL;
+	struct host_if_drv *pstrWFIDrv = NULL;
 
 	id = ((pu8Buffer[u32Length - 4]) | (pu8Buffer[u32Length - 3] << 8) | (pu8Buffer[u32Length - 2] << 16) | (pu8Buffer[u32Length - 1] << 24));
 	pstrWFIDrv = get_handler_from_id(id);
@@ -6282,10 +6273,10 @@ void host_int_ScanCompleteReceived(u8 *pu8Buffer, u32 u32Length)
  *  @date
  *  @version		1.0
  */
-s32 host_int_remain_on_channel(tstrWILC_WFIDrv *hWFIDrv, u32 u32SessionID, u32 u32duration, u16 chan, wilc_remain_on_chan_expired RemainOnChanExpired, wilc_remain_on_chan_ready RemainOnChanReady, void *pvUserArg)
+s32 host_int_remain_on_channel(struct host_if_drv *hWFIDrv, u32 u32SessionID, u32 u32duration, u16 chan, wilc_remain_on_chan_expired RemainOnChanExpired, wilc_remain_on_chan_ready RemainOnChanReady, void *pvUserArg)
 {
 	s32 s32Error = 0;
-	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
+	struct host_if_drv *pstrWFIDrv = (struct host_if_drv *)hWFIDrv;
 	struct host_if_msg msg;
 
 	if (pstrWFIDrv == NULL) {
@@ -6327,10 +6318,10 @@ s32 host_int_remain_on_channel(tstrWILC_WFIDrv *hWFIDrv, u32 u32SessionID, u32 u
  *  @date
  *  @version		1.0
  */
-s32 host_int_ListenStateExpired(tstrWILC_WFIDrv *hWFIDrv, u32 u32SessionID)
+s32 host_int_ListenStateExpired(struct host_if_drv *hWFIDrv, u32 u32SessionID)
 {
 	s32 s32Error = 0;
-	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
+	struct host_if_drv *pstrWFIDrv = (struct host_if_drv *)hWFIDrv;
 	struct host_if_msg msg;
 
 	if (pstrWFIDrv == NULL) {
@@ -6362,10 +6353,10 @@ s32 host_int_ListenStateExpired(tstrWILC_WFIDrv *hWFIDrv, u32 u32SessionID)
  *  @author
  *  @date
  *  @version		1.0*/
-s32 host_int_frame_register(tstrWILC_WFIDrv *hWFIDrv, u16 u16FrameType, bool bReg)
+s32 host_int_frame_register(struct host_if_drv *hWFIDrv, u16 u16FrameType, bool bReg)
 {
 	s32 s32Error = 0;
-	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
+	struct host_if_drv *pstrWFIDrv = (struct host_if_drv *)hWFIDrv;
 	struct host_if_msg msg;
 
 	if (pstrWFIDrv == NULL) {
@@ -6416,13 +6407,13 @@ s32 host_int_frame_register(tstrWILC_WFIDrv *hWFIDrv, u16 u16FrameType, bool bRe
  *  @date
  *  @version	1.0
  */
-s32 host_int_add_beacon(tstrWILC_WFIDrv *hWFIDrv, u32 u32Interval,
+s32 host_int_add_beacon(struct host_if_drv *hWFIDrv, u32 u32Interval,
 				u32 u32DTIMPeriod,
 				u32 u32HeadLen, u8 *pu8Head,
 				u32 u32TailLen, u8 *pu8Tail)
 {
 	s32 s32Error = 0;
-	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
+	struct host_if_drv *pstrWFIDrv = (struct host_if_drv *)hWFIDrv;
 	struct host_if_msg msg;
 	struct beacon_attr *pstrSetBeaconParam = &msg.body.beacon_info;
 
@@ -6488,10 +6479,10 @@ ERRORHANDLER:
  *  @date
  *  @version	1.0
  */
-s32 host_int_del_beacon(tstrWILC_WFIDrv *hWFIDrv)
+s32 host_int_del_beacon(struct host_if_drv *hWFIDrv)
 {
 	s32 s32Error = 0;
-	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
+	struct host_if_drv *pstrWFIDrv = (struct host_if_drv *)hWFIDrv;
 	struct host_if_msg msg;
 
 	if (pstrWFIDrv == NULL) {
@@ -6521,11 +6512,11 @@ s32 host_int_del_beacon(tstrWILC_WFIDrv *hWFIDrv)
  *  @date
  *  @version	1.0
  */
-s32 host_int_add_station(tstrWILC_WFIDrv *hWFIDrv,
+s32 host_int_add_station(struct host_if_drv *hWFIDrv,
 			 struct add_sta_param *pstrStaParams)
 {
 	s32 s32Error = 0;
-	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
+	struct host_if_drv *pstrWFIDrv = (struct host_if_drv *)hWFIDrv;
 	struct host_if_msg msg;
 	struct add_sta_param *pstrAddStationMsg = &msg.body.add_sta_info;
 
@@ -6571,10 +6562,10 @@ s32 host_int_add_station(tstrWILC_WFIDrv *hWFIDrv,
  *  @date
  *  @version	1.0
  */
-s32 host_int_del_station(tstrWILC_WFIDrv *hWFIDrv, const u8 *pu8MacAddr)
+s32 host_int_del_station(struct host_if_drv *hWFIDrv, const u8 *pu8MacAddr)
 {
 	s32 s32Error = 0;
-	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
+	struct host_if_drv *pstrWFIDrv = (struct host_if_drv *)hWFIDrv;
 	struct host_if_msg msg;
 	struct del_sta *pstrDelStationMsg = &msg.body.del_sta_info;
 
@@ -6612,10 +6603,11 @@ s32 host_int_del_station(tstrWILC_WFIDrv *hWFIDrv, const u8 *pu8MacAddr)
  *  @date
  *  @version	1.0
  */
-s32 host_int_del_allstation(tstrWILC_WFIDrv *hWFIDrv, u8 pu8MacAddr[][ETH_ALEN])
+s32 host_int_del_allstation(struct host_if_drv *hWFIDrv,
+			    u8 pu8MacAddr[][ETH_ALEN])
 {
 	s32 s32Error = 0;
-	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
+	struct host_if_drv *pstrWFIDrv = (struct host_if_drv *)hWFIDrv;
 	struct host_if_msg msg;
 	struct del_all_sta *pstrDelAllStationMsg = &msg.body.del_all_sta_info;
 	u8 au8Zero_Buff[ETH_ALEN] = {0};
@@ -6672,11 +6664,11 @@ s32 host_int_del_allstation(tstrWILC_WFIDrv *hWFIDrv, u8 pu8MacAddr[][ETH_ALEN])
  *  @date
  *  @version	1.0
  */
-s32 host_int_edit_station(tstrWILC_WFIDrv *hWFIDrv,
+s32 host_int_edit_station(struct host_if_drv *hWFIDrv,
 			  struct add_sta_param *pstrStaParams)
 {
 	s32 s32Error = 0;
-	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
+	struct host_if_drv *pstrWFIDrv = (struct host_if_drv *)hWFIDrv;
 	struct host_if_msg msg;
 	struct add_sta_param *pstrAddStationMsg = &msg.body.add_sta_info;
 
@@ -6712,10 +6704,10 @@ s32 host_int_edit_station(tstrWILC_WFIDrv *hWFIDrv,
 	return s32Error;
 }
 
-s32 host_int_set_power_mgmt(tstrWILC_WFIDrv *hWFIDrv, bool bIsEnabled, u32 u32Timeout)
+s32 host_int_set_power_mgmt(struct host_if_drv *hWFIDrv, bool bIsEnabled, u32 u32Timeout)
 {
 	s32 s32Error = 0;
-	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
+	struct host_if_drv *pstrWFIDrv = (struct host_if_drv *)hWFIDrv;
 	struct host_if_msg msg;
 	struct power_mgmt_param *pstrPowerMgmtParam = &msg.body.pwr_mgmt_info;
 
@@ -6745,11 +6737,11 @@ s32 host_int_set_power_mgmt(tstrWILC_WFIDrv *hWFIDrv, bool bIsEnabled, u32 u32Ti
 	return s32Error;
 }
 
-s32 host_int_setup_multicast_filter(tstrWILC_WFIDrv *hWFIDrv, bool bIsEnabled, u32 u32count)
+s32 host_int_setup_multicast_filter(struct host_if_drv *hWFIDrv, bool bIsEnabled, u32 u32count)
 {
 	s32 s32Error = 0;
 
-	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
+	struct host_if_drv *pstrWFIDrv = (struct host_if_drv *)hWFIDrv;
 	struct host_if_msg msg;
 	struct set_multicast *pstrMulticastFilterParam = &msg.body.multicast_info;
 
@@ -6995,10 +6987,10 @@ void host_int_freeJoinParams(void *pJoinParams)
 		PRINT_ER("Unable to FREE null pointer\n");
 }
 
-s32 host_int_delBASession(tstrWILC_WFIDrv *hWFIDrv, char *pBSSID, char TID)
+s32 host_int_delBASession(struct host_if_drv *hWFIDrv, char *pBSSID, char TID)
 {
 	s32 s32Error = 0;
-	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
+	struct host_if_drv *pstrWFIDrv = (struct host_if_drv *)hWFIDrv;
 	struct host_if_msg msg;
 	struct ba_session_info *pBASessionInfo = &msg.body.session_info;
 
@@ -7025,10 +7017,10 @@ s32 host_int_delBASession(tstrWILC_WFIDrv *hWFIDrv, char *pBSSID, char TID)
 	return s32Error;
 }
 
-s32 host_int_del_All_Rx_BASession(tstrWILC_WFIDrv *hWFIDrv, char *pBSSID, char TID)
+s32 host_int_del_All_Rx_BASession(struct host_if_drv *hWFIDrv, char *pBSSID, char TID)
 {
 	s32 s32Error = 0;
-	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
+	struct host_if_drv *pstrWFIDrv = (struct host_if_drv *)hWFIDrv;
 	struct host_if_msg msg;
 	struct ba_session_info *pBASessionInfo = &msg.body.session_info;
 
@@ -7063,10 +7055,10 @@ s32 host_int_del_All_Rx_BASession(tstrWILC_WFIDrv *hWFIDrv, char *pBSSID, char T
  *  @author		Abdelrahman Sobhy
  *  @date
  *  @version		1.0*/
-s32 host_int_setup_ipaddress(tstrWILC_WFIDrv *hWFIDrv, u8 *u16ipadd, u8 idx)
+s32 host_int_setup_ipaddress(struct host_if_drv *hWFIDrv, u8 *u16ipadd, u8 idx)
 {
 	s32 s32Error = 0;
-	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
+	struct host_if_drv *pstrWFIDrv = (struct host_if_drv *)hWFIDrv;
 	struct host_if_msg msg;
 
 	/* TODO: Enable This feature on softap firmware */
@@ -7103,10 +7095,10 @@ s32 host_int_setup_ipaddress(tstrWILC_WFIDrv *hWFIDrv, u8 *u16ipadd, u8 idx)
  *  @author		Abdelrahman Sobhy
  *  @date
  *  @version		1.0*/
-s32 host_int_get_ipaddress(tstrWILC_WFIDrv *hWFIDrv, u8 *u16ipadd, u8 idx)
+s32 host_int_get_ipaddress(struct host_if_drv *hWFIDrv, u8 *u16ipadd, u8 idx)
 {
 	s32 s32Error = 0;
-	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
+	struct host_if_drv *pstrWFIDrv = (struct host_if_drv *)hWFIDrv;
 	struct host_if_msg msg;
 
 	if (pstrWFIDrv == NULL) {
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 7391903..1848f53 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -303,7 +303,7 @@ enum p2p_listen_state {
 	P2P_GRP_FORMATION
 };
 
-typedef struct {
+struct host_if_drv {
 	/* Scan user structure */
 	tstrWILC_UsrScanReq strWILC_UsrScanReq;
 
@@ -335,7 +335,7 @@ typedef struct {
 	struct timer_list hRemainOnChannel;
 
 	bool IFC_UP;
-} tstrWILC_WFIDrv;
+};
 
 /*!
  *  @enum               tenuWILC_StaFlag
@@ -391,7 +391,7 @@ struct add_sta_param {
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 host_int_remove_key(tstrWILC_WFIDrv *hWFIDrv, const u8 *pu8StaAddress);
+s32 host_int_remove_key(struct host_if_drv *hWFIDrv, const u8 *pu8StaAddress);
 /**
  *  @brief              removes WEP key
  *  @details    valid only in BSS STA mode if External Supplicant support is enabled.
@@ -406,7 +406,7 @@ s32 host_int_remove_key(tstrWILC_WFIDrv *hWFIDrv, const u8 *pu8StaAddress);
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 host_int_remove_wep_key(tstrWILC_WFIDrv *hWFIDrv, u8 u8Index);
+s32 host_int_remove_wep_key(struct host_if_drv *hWFIDrv, u8 u8Index);
 /**
  *  @brief              sets WEP deafault key
  *  @details    Sets the index of the WEP encryption key in use,
@@ -419,7 +419,7 @@ s32 host_int_remove_wep_key(tstrWILC_WFIDrv *hWFIDrv, u8 u8Index);
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 host_int_set_WEPDefaultKeyID(tstrWILC_WFIDrv *hWFIDrv, u8 u8Index);
+s32 host_int_set_WEPDefaultKeyID(struct host_if_drv *hWFIDrv, u8 u8Index);
 
 /**
  *  @brief              sets WEP deafault key
@@ -440,7 +440,7 @@ s32 host_int_set_WEPDefaultKeyID(tstrWILC_WFIDrv *hWFIDrv, u8 u8Index);
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 host_int_add_wep_key_bss_sta(tstrWILC_WFIDrv *hWFIDrv, const u8 *pu8WepKey, u8 u8WepKeylen, u8 u8Keyidx);
+s32 host_int_add_wep_key_bss_sta(struct host_if_drv *hWFIDrv, const u8 *pu8WepKey, u8 u8WepKeylen, u8 u8Keyidx);
 /**
  *  @brief              host_int_add_wep_key_bss_ap
  *  @details    valid only in AP mode if External Supplicant support is enabled.
@@ -455,7 +455,7 @@ s32 host_int_add_wep_key_bss_sta(tstrWILC_WFIDrv *hWFIDrv, const u8 *pu8WepKey,
  *  @date		28 Feb 2013
  *  @version		1.0
  */
-s32 host_int_add_wep_key_bss_ap(tstrWILC_WFIDrv *hWFIDrv, const u8 *pu8WepKey, u8 u8WepKeylen, u8 u8Keyidx, u8 u8mode, enum AUTHTYPE tenuAuth_type);
+s32 host_int_add_wep_key_bss_ap(struct host_if_drv *hWFIDrv, const u8 *pu8WepKey, u8 u8WepKeylen, u8 u8Keyidx, u8 u8mode, enum AUTHTYPE tenuAuth_type);
 
 /**
  *  @brief              adds ptk Key
@@ -473,7 +473,7 @@ s32 host_int_add_wep_key_bss_ap(tstrWILC_WFIDrv *hWFIDrv, const u8 *pu8WepKey, u
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 host_int_add_ptk(tstrWILC_WFIDrv *hWFIDrv, const u8 *pu8Ptk, u8 u8PtkKeylen,
+s32 host_int_add_ptk(struct host_if_drv *hWFIDrv, const u8 *pu8Ptk, u8 u8PtkKeylen,
 			     const u8 *mac_addr, const u8 *pu8RxMic, const u8 *pu8TxMic, u8 mode, u8 u8Ciphermode, u8 u8Idx);
 
 /**
@@ -488,7 +488,7 @@ s32 host_int_add_ptk(tstrWILC_WFIDrv *hWFIDrv, const u8 *pu8Ptk, u8 u8PtkKeylen,
  *  @date		15 April 2013
  *  @version		1.0
  */
-s32 host_int_get_inactive_time(tstrWILC_WFIDrv *hWFIDrv, const u8 *mac, u32 *pu32InactiveTime);
+s32 host_int_get_inactive_time(struct host_if_drv *hWFIDrv, const u8 *mac, u32 *pu32InactiveTime);
 
 /**
  *  @brief              adds Rx GTk Key
@@ -506,7 +506,7 @@ s32 host_int_get_inactive_time(tstrWILC_WFIDrv *hWFIDrv, const u8 *mac, u32 *pu3
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 host_int_add_rx_gtk(tstrWILC_WFIDrv *hWFIDrv, const u8 *pu8RxGtk, u8 u8GtkKeylen,
+s32 host_int_add_rx_gtk(struct host_if_drv *hWFIDrv, const u8 *pu8RxGtk, u8 u8GtkKeylen,
 				u8 u8KeyIdx, u32 u32KeyRSClen, const u8 *KeyRSC,
 				const u8 *pu8RxMic, const u8 *pu8TxMic, u8 mode, u8 u8Ciphermode);
 
@@ -527,7 +527,7 @@ s32 host_int_add_rx_gtk(tstrWILC_WFIDrv *hWFIDrv, const u8 *pu8RxGtk, u8 u8GtkKe
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 host_int_add_tx_gtk(tstrWILC_WFIDrv *hWFIDrv, u8 u8KeyLen, u8 *pu8TxGtk, u8 u8KeyIdx);
+s32 host_int_add_tx_gtk(struct host_if_drv *hWFIDrv, u8 u8KeyLen, u8 *pu8TxGtk, u8 u8KeyIdx);
 
 /**
  *  @brief              caches the pmkid
@@ -550,7 +550,7 @@ s32 host_int_add_tx_gtk(tstrWILC_WFIDrv *hWFIDrv, u8 u8KeyLen, u8 *pu8TxGtk, u8
  *  @version		1.0
  */
 
-s32 host_int_set_pmkid_info(tstrWILC_WFIDrv *hWFIDrv, struct host_if_pmkid_attr *pu8PmkidInfoArray);
+s32 host_int_set_pmkid_info(struct host_if_drv *hWFIDrv, struct host_if_pmkid_attr *pu8PmkidInfoArray);
 /**
  *  @brief              gets the cached the pmkid info
  *  @details    valid only in BSS STA mode if External Supplicant
@@ -574,7 +574,7 @@ s32 host_int_set_pmkid_info(tstrWILC_WFIDrv *hWFIDrv, struct host_if_pmkid_attr
  *  @version		1.0
  */
 
-s32 host_int_get_pmkid_info(tstrWILC_WFIDrv *hWFIDrv, u8 *pu8PmkidInfoArray,
+s32 host_int_get_pmkid_info(struct host_if_drv *hWFIDrv, u8 *pu8PmkidInfoArray,
 				    u32 u32PmkidInfoLen);
 
 /**
@@ -591,7 +591,7 @@ s32 host_int_get_pmkid_info(tstrWILC_WFIDrv *hWFIDrv, u8 *pu8PmkidInfoArray,
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 host_int_set_RSNAConfigPSKPassPhrase(tstrWILC_WFIDrv *hWFIDrv, u8 *pu8PassPhrase,
+s32 host_int_set_RSNAConfigPSKPassPhrase(struct host_if_drv *hWFIDrv, u8 *pu8PassPhrase,
 						 u8 u8Psklength);
 /**
  *  @brief              gets the pass phrase
@@ -607,7 +607,7 @@ s32 host_int_set_RSNAConfigPSKPassPhrase(tstrWILC_WFIDrv *hWFIDrv, u8 *pu8PassPh
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 host_int_get_RSNAConfigPSKPassPhrase(tstrWILC_WFIDrv *hWFIDrv,
+s32 host_int_get_RSNAConfigPSKPassPhrase(struct host_if_drv *hWFIDrv,
 						 u8 *pu8PassPhrase, u8 u8Psklength);
 
 /**
@@ -621,7 +621,7 @@ s32 host_int_get_RSNAConfigPSKPassPhrase(tstrWILC_WFIDrv *hWFIDrv,
  *  @date		19 April 2012
  *  @version		1.0
  */
-s32 host_int_get_MacAddress(tstrWILC_WFIDrv *hWFIDrv, u8 *pu8MacAddress);
+s32 host_int_get_MacAddress(struct host_if_drv *hWFIDrv, u8 *pu8MacAddress);
 
 /**
  *  @brief              sets mac address
@@ -634,7 +634,7 @@ s32 host_int_get_MacAddress(tstrWILC_WFIDrv *hWFIDrv, u8 *pu8MacAddress);
  *  @date		16 July 2012
  *  @version		1.0
  */
-s32 host_int_set_MacAddress(tstrWILC_WFIDrv *hWFIDrv, u8 *pu8MacAddress);
+s32 host_int_set_MacAddress(struct host_if_drv *hWFIDrv, u8 *pu8MacAddress);
 
 /**
  *  @brief              wait until msg q is empty
@@ -665,7 +665,7 @@ int host_int_wait_msg_queue_idle(void);
  *  @version		1.0
  */
 
-s32 host_int_set_start_scan_req(tstrWILC_WFIDrv *hWFIDrv, u8 scanSource);
+s32 host_int_set_start_scan_req(struct host_if_drv *hWFIDrv, u8 scanSource);
 /**
  *  @brief              gets scan source of the last scan
  *  @details
@@ -681,7 +681,7 @@ s32 host_int_set_start_scan_req(tstrWILC_WFIDrv *hWFIDrv, u8 scanSource);
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 host_int_get_start_scan_req(tstrWILC_WFIDrv *hWFIDrv, u8 *pu8ScanSource);
+s32 host_int_get_start_scan_req(struct host_if_drv *hWFIDrv, u8 *pu8ScanSource);
 
 /**
  *  @brief              sets a join request
@@ -695,7 +695,7 @@ s32 host_int_get_start_scan_req(tstrWILC_WFIDrv *hWFIDrv, u8 *pu8ScanSource);
  *  @version		1.0
  */
 
-s32 host_int_set_join_req(tstrWILC_WFIDrv *hWFIDrv, u8 *pu8bssid,
+s32 host_int_set_join_req(struct host_if_drv *hWFIDrv, u8 *pu8bssid,
 				  const u8 *pu8ssid, size_t ssidLen,
 				  const u8 *pu8IEs, size_t IEsLen,
 				  wilc_connect_result pfConnectResult, void *pvUserArg,
@@ -715,7 +715,7 @@ s32 host_int_set_join_req(tstrWILC_WFIDrv *hWFIDrv, u8 *pu8bssid,
  *  @version		8.0
  */
 
-s32 host_int_flush_join_req(tstrWILC_WFIDrv *hWFIDrv);
+s32 host_int_flush_join_req(struct host_if_drv *hWFIDrv);
 
 
 /**
@@ -729,7 +729,7 @@ s32 host_int_flush_join_req(tstrWILC_WFIDrv *hWFIDrv);
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 host_int_disconnect(tstrWILC_WFIDrv *hWFIDrv, u16 u16ReasonCode);
+s32 host_int_disconnect(struct host_if_drv *hWFIDrv, u16 u16ReasonCode);
 
 /**
  *  @brief              disconnects a sta
@@ -742,7 +742,7 @@ s32 host_int_disconnect(tstrWILC_WFIDrv *hWFIDrv, u16 u16ReasonCode);
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 host_int_disconnect_station(tstrWILC_WFIDrv *hWFIDrv, u8 assoc_id);
+s32 host_int_disconnect_station(struct host_if_drv *hWFIDrv, u8 assoc_id);
 /**
  *  @brief              gets a Association request info
  *  @details
@@ -769,7 +769,7 @@ s32 host_int_disconnect_station(tstrWILC_WFIDrv *hWFIDrv, u8 assoc_id);
  *  @version		1.0
  */
 
-s32 host_int_get_assoc_req_info(tstrWILC_WFIDrv *hWFIDrv, u8 *pu8AssocReqInfo,
+s32 host_int_get_assoc_req_info(struct host_if_drv *hWFIDrv, u8 *pu8AssocReqInfo,
 					u32 u32AssocReqInfoLen);
 /**
  *  @brief              gets a Association Response info
@@ -783,7 +783,7 @@ s32 host_int_get_assoc_req_info(tstrWILC_WFIDrv *hWFIDrv, u8 *pu8AssocReqInfo,
  *  @version		1.0
  */
 
-s32 host_int_get_assoc_res_info(tstrWILC_WFIDrv *hWFIDrv, u8 *pu8AssocRespInfo,
+s32 host_int_get_assoc_res_info(struct host_if_drv *hWFIDrv, u8 *pu8AssocRespInfo,
 					u32 u32MaxAssocRespInfoLen, u32 *pu32RcvdAssocRespInfoLen);
 /**
  *  @brief              gets a Association Response info
@@ -800,7 +800,7 @@ s32 host_int_get_assoc_res_info(tstrWILC_WFIDrv *hWFIDrv, u8 *pu8AssocRespInfo,
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 host_int_get_rx_power_level(tstrWILC_WFIDrv *hWFIDrv, u8 *pu8RxPowerLevel,
+s32 host_int_get_rx_power_level(struct host_if_drv *hWFIDrv, u8 *pu8RxPowerLevel,
 					u32 u32RxPowerLevelLen);
 
 /**
@@ -818,7 +818,7 @@ s32 host_int_get_rx_power_level(tstrWILC_WFIDrv *hWFIDrv, u8 *pu8RxPowerLevel,
  *  @date		8 March 2012
  *  @version		1.0
  */
-int host_int_set_mac_chnl_num(tstrWILC_WFIDrv *wfi_drv, u8 channel);
+int host_int_set_mac_chnl_num(struct host_if_drv *wfi_drv, u8 channel);
 
 /**
  *  @brief              gets the current channel index
@@ -835,7 +835,7 @@ int host_int_set_mac_chnl_num(tstrWILC_WFIDrv *wfi_drv, u8 channel);
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 host_int_get_host_chnl_num(tstrWILC_WFIDrv *hWFIDrv, u8 *pu8ChNo);
+s32 host_int_get_host_chnl_num(struct host_if_drv *hWFIDrv, u8 *pu8ChNo);
 /**
  *  @brief              gets the sta rssi
  *  @details    gets the currently maintained RSSI value for the station.
@@ -849,8 +849,8 @@ s32 host_int_get_host_chnl_num(tstrWILC_WFIDrv *hWFIDrv, u8 *pu8ChNo);
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 host_int_get_rssi(tstrWILC_WFIDrv *hWFIDrv, s8 *ps8Rssi);
-s32 host_int_get_link_speed(tstrWILC_WFIDrv *hWFIDrv, s8 *ps8lnkspd);
+s32 host_int_get_rssi(struct host_if_drv *hWFIDrv, s8 *ps8Rssi);
+s32 host_int_get_link_speed(struct host_if_drv *hWFIDrv, s8 *ps8lnkspd);
 /**
  *  @brief              scans a set of channels
  *  @details
@@ -868,7 +868,7 @@ s32 host_int_get_link_speed(tstrWILC_WFIDrv *hWFIDrv, s8 *ps8lnkspd);
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 host_int_scan(tstrWILC_WFIDrv *hWFIDrv, u8 u8ScanSource,
+s32 host_int_scan(struct host_if_drv *hWFIDrv, u8 u8ScanSource,
 			  u8 u8ScanType, u8 *pu8ChnlFreqList,
 			  u8 u8ChnlListLen, const u8 *pu8IEs,
 			  size_t IEsLen, wilc_scan_result ScanResult,
@@ -885,7 +885,7 @@ s32 host_int_scan(tstrWILC_WFIDrv *hWFIDrv, u8 u8ScanSource,
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 hif_set_cfg(tstrWILC_WFIDrv *hWFIDrv, struct cfg_param_val *pstrCfgParamVal);
+s32 hif_set_cfg(struct host_if_drv *hWFIDrv, struct cfg_param_val *pstrCfgParamVal);
 
 /**
  *  @brief              gets configuration wids values
@@ -899,7 +899,7 @@ s32 hif_set_cfg(tstrWILC_WFIDrv *hWFIDrv, struct cfg_param_val *pstrCfgParamVal)
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 hif_get_cfg(tstrWILC_WFIDrv *hWFIDrv, u16 u16WID, u16 *pu16WID_Value);
+s32 hif_get_cfg(struct host_if_drv *hWFIDrv, u16 u16WID, u16 *pu16WID_Value);
 /*****************************************************************************/
 /*							Notification Functions							 */
 /*****************************************************************************/
@@ -946,7 +946,7 @@ void host_int_send_network_info_to_host
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 host_int_init(tstrWILC_WFIDrv **phWFIDrv);
+s32 host_int_init(struct host_if_drv **phWFIDrv);
 
 /**
  *  @brief              host interface initialization function
@@ -957,7 +957,7 @@ s32 host_int_init(tstrWILC_WFIDrv **phWFIDrv);
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 host_int_deinit(tstrWILC_WFIDrv *hWFIDrv);
+s32 host_int_deinit(struct host_if_drv *hWFIDrv);
 
 
 /*!
@@ -982,7 +982,7 @@ s32 host_int_deinit(tstrWILC_WFIDrv *hWFIDrv);
  *  @version		1.0 Description
  *
  */
-s32 host_int_add_beacon(tstrWILC_WFIDrv *hWFIDrv, u32 u32Interval,
+s32 host_int_add_beacon(struct host_if_drv *hWFIDrv, u32 u32Interval,
 				u32 u32DTIMPeriod,
 				u32 u32HeadLen, u8 *pu8Head,
 				u32 u32TailLen, u8 *pu8tail);
@@ -1000,7 +1000,7 @@ s32 host_int_add_beacon(tstrWILC_WFIDrv *hWFIDrv, u32 u32Interval,
  *  @date		10 Julys 2012
  *  @version		1.0 Description
  */
-s32 host_int_del_beacon(tstrWILC_WFIDrv *hWFIDrv);
+s32 host_int_del_beacon(struct host_if_drv *hWFIDrv);
 
 /*!
  *  @fn		s32 host_int_add_station(WILC_WFIDrvHandle hWFIDrv,
@@ -1016,7 +1016,7 @@ s32 host_int_del_beacon(tstrWILC_WFIDrv *hWFIDrv);
  *  @date		12 July 2012
  *  @version		1.0 Description
  */
-s32 host_int_add_station(tstrWILC_WFIDrv *hWFIDrv,
+s32 host_int_add_station(struct host_if_drv *hWFIDrv,
 			 struct add_sta_param *pstrStaParams);
 
 /*!
@@ -1032,7 +1032,7 @@ s32 host_int_add_station(tstrWILC_WFIDrv *hWFIDrv,
  *  @date		09 April 2014
  *  @version		1.0 Description
  */
-s32 host_int_del_allstation(tstrWILC_WFIDrv *hWFIDrv, u8 pu8MacAddr[][ETH_ALEN]);
+s32 host_int_del_allstation(struct host_if_drv *hWFIDrv, u8 pu8MacAddr[][ETH_ALEN]);
 
 /*!
  *  @fn		s32 host_int_del_station(WILC_WFIDrvHandle hWFIDrv, u8* pu8MacAddr)
@@ -1047,7 +1047,7 @@ s32 host_int_del_allstation(tstrWILC_WFIDrv *hWFIDrv, u8 pu8MacAddr[][ETH_ALEN])
  *  @date		15 July 2012
  *  @version		1.0 Description
  */
-s32 host_int_del_station(tstrWILC_WFIDrv *hWFIDrv, const u8 *pu8MacAddr);
+s32 host_int_del_station(struct host_if_drv *hWFIDrv, const u8 *pu8MacAddr);
 
 /*!
  *  @fn		s32 host_int_edit_station(WILC_WFIDrvHandle hWFIDrv,
@@ -1063,7 +1063,7 @@ s32 host_int_del_station(tstrWILC_WFIDrv *hWFIDrv, const u8 *pu8MacAddr);
  *  @date		15 July 2012
  *  @version		1.0 Description
  */
-s32 host_int_edit_station(tstrWILC_WFIDrv *hWFIDrv,
+s32 host_int_edit_station(struct host_if_drv *hWFIDrv,
 			  struct add_sta_param *pstrStaParams);
 
 /*!
@@ -1081,7 +1081,7 @@ s32 host_int_edit_station(tstrWILC_WFIDrv *hWFIDrv,
  *  @date		24 November 2012
  *  @version		1.0 Description
  */
-s32 host_int_set_power_mgmt(tstrWILC_WFIDrv *hWFIDrv, bool bIsEnabled, u32 u32Timeout);
+s32 host_int_set_power_mgmt(struct host_if_drv *hWFIDrv, bool bIsEnabled, u32 u32Timeout);
 /*  @param[in,out]	hWFIDrv		handle to the wifi driver
  *  @param[in]	bIsEnabled	TRUE if enabled, FALSE otherwise
  *  @param[in]	u8count		count of mac address entries in the filter table
@@ -1093,7 +1093,7 @@ s32 host_int_set_power_mgmt(tstrWILC_WFIDrv *hWFIDrv, bool bIsEnabled, u32 u32Ti
  *  @date		24 November 2012
  *  @version		1.0 Description
  */
-s32 host_int_setup_multicast_filter(tstrWILC_WFIDrv *hWFIDrv, bool bIsEnabled, u32 u32count);
+s32 host_int_setup_multicast_filter(struct host_if_drv *hWFIDrv, bool bIsEnabled, u32 u32count);
 /**
  *  @brief           host_int_setup_ipaddress
  *  @details       set IP address on firmware
@@ -1103,7 +1103,7 @@ s32 host_int_setup_multicast_filter(tstrWILC_WFIDrv *hWFIDrv, bool bIsEnabled, u
  *  @date
  *  @version	1.0
  */
-s32 host_int_setup_ipaddress(tstrWILC_WFIDrv *hWFIDrv, u8 *pu8IPAddr, u8 idx);
+s32 host_int_setup_ipaddress(struct host_if_drv *hWFIDrv, u8 *pu8IPAddr, u8 idx);
 
 
 /**
@@ -1115,7 +1115,7 @@ s32 host_int_setup_ipaddress(tstrWILC_WFIDrv *hWFIDrv, u8 *pu8IPAddr, u8 idx);
  *  @date
  *  @version	1.0
  */
-s32 host_int_delBASession(tstrWILC_WFIDrv *hWFIDrv, char *pBSSID, char TID);
+s32 host_int_delBASession(struct host_if_drv *hWFIDrv, char *pBSSID, char TID);
 
 /**
  *  @brief           host_int_delBASession
@@ -1126,7 +1126,7 @@ s32 host_int_delBASession(tstrWILC_WFIDrv *hWFIDrv, char *pBSSID, char TID);
  *  @date
  *  @version	1.0
  */
-s32 host_int_del_All_Rx_BASession(tstrWILC_WFIDrv *hWFIDrv, char *pBSSID, char TID);
+s32 host_int_del_All_Rx_BASession(struct host_if_drv *hWFIDrv, char *pBSSID, char TID);
 
 
 /**
@@ -1138,7 +1138,7 @@ s32 host_int_del_All_Rx_BASession(tstrWILC_WFIDrv *hWFIDrv, char *pBSSID, char T
  *  @date
  *  @version	1.0
  */
-s32 host_int_get_ipaddress(tstrWILC_WFIDrv *hWFIDrv, u8 *pu8IPAddr, u8 idx);
+s32 host_int_get_ipaddress(struct host_if_drv *hWFIDrv, u8 *pu8IPAddr, u8 idx);
 
 /**
  *  @brief           host_int_remain_on_channel
@@ -1149,7 +1149,7 @@ s32 host_int_get_ipaddress(tstrWILC_WFIDrv *hWFIDrv, u8 *pu8IPAddr, u8 idx);
  *  @date
  *  @version	1.0
  */
-s32 host_int_remain_on_channel(tstrWILC_WFIDrv *hWFIDrv, u32 u32SessionID, u32 u32duration, u16 chan, wilc_remain_on_chan_expired RemainOnChanExpired, wilc_remain_on_chan_ready RemainOnChanReady, void *pvUserArg);
+s32 host_int_remain_on_channel(struct host_if_drv *hWFIDrv, u32 u32SessionID, u32 u32duration, u16 chan, wilc_remain_on_chan_expired RemainOnChanExpired, wilc_remain_on_chan_ready RemainOnChanReady, void *pvUserArg);
 
 /**
  *  @brief              host_int_ListenStateExpired
@@ -1165,7 +1165,7 @@ s32 host_int_remain_on_channel(tstrWILC_WFIDrv *hWFIDrv, u32 u32SessionID, u32 u
  *  @date
  *  @version		1.0
  */
-s32 host_int_ListenStateExpired(tstrWILC_WFIDrv *hWFIDrv, u32 u32SessionID);
+s32 host_int_ListenStateExpired(struct host_if_drv *hWFIDrv, u32 u32SessionID);
 
 /**
  *  @brief           host_int_frame_register
@@ -1176,7 +1176,7 @@ s32 host_int_ListenStateExpired(tstrWILC_WFIDrv *hWFIDrv, u32 u32SessionID);
  *  @date
  *  @version	1.0
  */
-s32 host_int_frame_register(tstrWILC_WFIDrv *hWFIDrv, u16 u16FrameType, bool bReg);
+s32 host_int_frame_register(struct host_if_drv *hWFIDrv, u16 u16FrameType, bool bReg);
 /**
  *  @brief           host_int_set_wfi_drv_handler
  *  @details
@@ -1186,13 +1186,13 @@ s32 host_int_frame_register(tstrWILC_WFIDrv *hWFIDrv, u16 u16FrameType, bool bRe
  *  @date
  *  @version	1.0
  */
-s32 host_int_set_wfi_drv_handler(tstrWILC_WFIDrv *u32address);
-s32 host_int_set_operation_mode(tstrWILC_WFIDrv *hWFIDrv, u32 u32mode);
+s32 host_int_set_wfi_drv_handler(struct host_if_drv *u32address);
+s32 host_int_set_operation_mode(struct host_if_drv *hWFIDrv, u32 u32mode);
 
-static s32 Handle_ScanDone(tstrWILC_WFIDrv *drvHandler, tenuScanEvent enuEvent);
+static s32 Handle_ScanDone(struct host_if_drv *drvHandler, tenuScanEvent enuEvent);
 
 void host_int_freeJoinParams(void *pJoinParams);
 
-s32 host_int_get_statistics(tstrWILC_WFIDrv *hWFIDrv, tstrStatistics *pstrStatistics);
+s32 host_int_get_statistics(struct host_if_drv *hWFIDrv, tstrStatistics *pstrStatistics);
 
 #endif
diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index f6a6287..fe4f305 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -132,7 +132,7 @@ static int dev_state_ev_handler(struct notifier_block *this, unsigned long event
 {
 	struct in_ifaddr *dev_iface = (struct in_ifaddr *)ptr;
 	struct wilc_priv *priv;
-	tstrWILC_WFIDrv *pstrWFIDrv;
+	struct host_if_drv *pstrWFIDrv;
 	struct net_device *dev;
 	u8 *pIP_Add_buff;
 	perInterface_wlan_t *nic;
@@ -159,7 +159,7 @@ static int dev_state_ev_handler(struct notifier_block *this, unsigned long event
 		PRINT_D(GENERIC_DBG, "No Wireless Priv\n");
 		return NOTIFY_DONE;
 	}
-	pstrWFIDrv = (tstrWILC_WFIDrv *)priv->hWILCWFIDrv;
+	pstrWFIDrv = (struct host_if_drv *)priv->hWILCWFIDrv;
 	nic = netdev_priv(dev);
 	if (nic == NULL || pstrWFIDrv == NULL) {
 		PRINT_D(GENERIC_DBG, "No Wireless Priv\n");
@@ -633,13 +633,13 @@ static int linux_wlan_init_test_config(struct net_device *dev, linux_wlan_t *p_n
 	unsigned char mac_add[] = {0x00, 0x80, 0xC2, 0x5E, 0xa2, 0xff};
 
 	struct wilc_priv *priv;
-	tstrWILC_WFIDrv *pstrWFIDrv;
+	struct host_if_drv *pstrWFIDrv;
 
 	PRINT_D(TX_DBG, "Start configuring Firmware\n");
 	get_random_bytes(&mac_add[5], 1);
 	get_random_bytes(&mac_add[4], 1);
 	priv = wiphy_priv(dev->ieee80211_ptr->wiphy);
-	pstrWFIDrv = (tstrWILC_WFIDrv *)priv->hWILCWFIDrv;
+	pstrWFIDrv = (struct host_if_drv *)priv->hWILCWFIDrv;
 	PRINT_D(INIT_DBG, "Host = %p\n", pstrWFIDrv);
 
 	PRINT_D(INIT_DBG, "MAC address is : %02x-%02x-%02x-%02x-%02x-%02x\n", mac_add[0], mac_add[1], mac_add[2], mac_add[3], mac_add[4], mac_add[5]);
@@ -1364,11 +1364,11 @@ static void wilc_set_multicast_list(struct net_device *dev)
 
 	struct netdev_hw_addr *ha;
 	struct wilc_priv *priv;
-	tstrWILC_WFIDrv *pstrWFIDrv;
+	struct host_if_drv *pstrWFIDrv;
 	int i = 0;
 
 	priv = wiphy_priv(dev->ieee80211_ptr->wiphy);
-	pstrWFIDrv = (tstrWILC_WFIDrv *)priv->hWILCWFIDrv;
+	pstrWFIDrv = (struct host_if_drv *)priv->hWILCWFIDrv;
 
 	if (!dev)
 		return;
@@ -1497,7 +1497,7 @@ int mac_close(struct net_device *ndev)
 {
 	struct wilc_priv *priv;
 	perInterface_wlan_t *nic;
-	tstrWILC_WFIDrv *pstrWFIDrv;
+	struct host_if_drv *pstrWFIDrv;
 
 	nic = netdev_priv(ndev);
 
@@ -1513,7 +1513,7 @@ int mac_close(struct net_device *ndev)
 		return 0;
 	}
 
-	pstrWFIDrv = (tstrWILC_WFIDrv *)priv->hWILCWFIDrv;
+	pstrWFIDrv = (struct host_if_drv *)priv->hWILCWFIDrv;
 
 	PRINT_D(GENERIC_DBG, "Mac close\n");
 
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 2f67546..fb79612 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -539,14 +539,14 @@ static void CfgConnectResult(tenuConnDisconnEvent enuConnDisconnEvent,
 {
 	struct wilc_priv *priv;
 	struct net_device *dev;
-	tstrWILC_WFIDrv *pstrWFIDrv;
+	struct host_if_drv *pstrWFIDrv;
 	u8 NullBssid[ETH_ALEN] = {0};
 
 	connecting = 0;
 
 	priv = (struct wilc_priv *)pUserVoid;
 	dev = priv->dev;
-	pstrWFIDrv = (tstrWILC_WFIDrv *)priv->hWILCWFIDrv;
+	pstrWFIDrv = (struct host_if_drv *)priv->hWILCWFIDrv;
 
 	if (enuConnDisconnEvent == CONN_DISCONN_EVENT_CONN_RESP) {
 		/*Initialization*/
@@ -792,13 +792,13 @@ static int connect(struct wiphy *wiphy, struct net_device *dev,
 	char *pcwpa_version = NULL;
 
 	struct wilc_priv *priv;
-	tstrWILC_WFIDrv *pstrWFIDrv;
+	struct host_if_drv *pstrWFIDrv;
 	tstrNetworkInfo *pstrNetworkInfo = NULL;
 
 
 	connecting = 1;
 	priv = wiphy_priv(wiphy);
-	pstrWFIDrv = (tstrWILC_WFIDrv *)(priv->hWILCWFIDrv);
+	pstrWFIDrv = (struct host_if_drv *)(priv->hWILCWFIDrv);
 
 	host_int_set_wfi_drv_handler(priv->hWILCWFIDrv);
 
@@ -1034,14 +1034,14 @@ static int disconnect(struct wiphy *wiphy, struct net_device *dev, u16 reason_co
 {
 	s32 s32Error = 0;
 	struct wilc_priv *priv;
-	tstrWILC_WFIDrv *pstrWFIDrv;
+	struct host_if_drv *pstrWFIDrv;
 	u8 NullBssid[ETH_ALEN] = {0};
 
 	connecting = 0;
 	priv = wiphy_priv(wiphy);
 
 	/*Invalidate u8WLANChannel value on wlan0 disconnect*/
-	pstrWFIDrv = (tstrWILC_WFIDrv *)priv->hWILCWFIDrv;
+	pstrWFIDrv = (struct host_if_drv *)priv->hWILCWFIDrv;
 	if (!pstrWFIDrv->u8P2PConnect)
 		u8WLANChannel = INVALID_CHANNEL;
 	linux_wlan_set_bssid(priv->dev, NullBssid);
@@ -1948,12 +1948,12 @@ void WILC_WFI_p2p_rx (struct net_device *dev, u8 *buff, u32 size)
 
 	struct wilc_priv *priv;
 	u32 header, pkt_offset;
-	tstrWILC_WFIDrv *pstrWFIDrv;
+	struct host_if_drv *pstrWFIDrv;
 	u32 i = 0;
 	s32 s32Freq;
 
 	priv = wiphy_priv(dev->ieee80211_ptr->wiphy);
-	pstrWFIDrv = (tstrWILC_WFIDrv *)priv->hWILCWFIDrv;
+	pstrWFIDrv = (struct host_if_drv *)priv->hWILCWFIDrv;
 
 	/* Get WILC header */
 	memcpy(&header, (buff - HOST_HDR_OFFSET), HOST_HDR_OFFSET);
@@ -2249,14 +2249,14 @@ static int mgmt_tx(struct wiphy *wiphy,
 	struct p2p_mgmt_data *mgmt_tx;
 	struct wilc_priv *priv;
 	s32 s32Error = 0;
-	tstrWILC_WFIDrv *pstrWFIDrv;
+	struct host_if_drv *pstrWFIDrv;
 	u32 i;
 	perInterface_wlan_t *nic;
 	u32 buf_len = len + sizeof(u8P2P_vendorspec) + sizeof(u8P2Plocalrandom);
 
 	nic = netdev_priv(wdev->netdev);
 	priv = wiphy_priv(wiphy);
-	pstrWFIDrv = (tstrWILC_WFIDrv *)priv->hWILCWFIDrv;
+	pstrWFIDrv = (struct host_if_drv *)priv->hWILCWFIDrv;
 
 	*cookie = (unsigned long)buf;
 	priv->u64tx_cookie = *cookie;
@@ -2394,10 +2394,10 @@ static int mgmt_tx_cancel_wait(struct wiphy *wiphy,
 			       u64 cookie)
 {
 	struct wilc_priv *priv;
-	tstrWILC_WFIDrv *pstrWFIDrv;
+	struct host_if_drv *pstrWFIDrv;
 
 	priv = wiphy_priv(wiphy);
-	pstrWFIDrv = (tstrWILC_WFIDrv *)priv->hWILCWFIDrv;
+	pstrWFIDrv = (struct host_if_drv *)priv->hWILCWFIDrv;
 
 
 	PRINT_D(GENERIC_DBG, "Tx Cancel wait :%lu\n", jiffies);
diff --git a/drivers/staging/wilc1000/wilc_wfi_netdevice.h b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
index cb21968..8bcfcc2 100644
--- a/drivers/staging/wilc1000/wilc_wfi_netdevice.h
+++ b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
@@ -121,7 +121,7 @@ struct wilc_priv {
 	spinlock_t lock;
 	struct net_device *dev;
 	struct napi_struct napi;
-	tstrWILC_WFIDrv *hWILCWFIDrv;
+	struct host_if_drv *hWILCWFIDrv;
 	struct host_if_pmkid_attr pmkid_list;
 	struct WILC_WFI_stats netstats;
 	u8 WILC_WFI_wep_default;
@@ -151,7 +151,7 @@ typedef struct {
 typedef struct {
 	u8 aSrcAddress[ETH_ALEN];
 	u8 aBSSID[ETH_ALEN];
-	tstrWILC_WFIDrv *drvHandler;
+	struct host_if_drv *drvHandler;
 	struct net_device *wilc_netdev;
 } tstrInterfaceInfo;
 typedef struct {
-- 
1.9.1

