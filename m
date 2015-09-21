Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:21020 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755889AbbIUDRc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Sep 2015 23:17:32 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH v2 02/34] staging: wilc1000: remove typedef from the struct
Date: Mon, 21 Sep 2015 12:16:31 +0900
Message-ID: <1442805423-3711-3-git-send-email-tony.cho@atmel.com> (sfid-20150921_051740_016523_1BAD89E0)
In-Reply-To: <1442805423-3711-1-git-send-email-tony.cho@atmel.com>
References: <1442805423-3711-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The Linux kernel coding style does not recommend to use typedef for the
structure. This patch removes typedef from the host_if_msg structure.

Signed-off-by: Tony Cho <tony.cho@atmel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/wilc1000/host_interface.c | 294 +++++++++++++++---------------
 1 file changed, 147 insertions(+), 147 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 6d119c4..fdb0b9b 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -449,7 +449,7 @@ typedef union _tuniHostIFmsgBody {
 } tuniHostIFmsgBody;
 
 /*!
- *  @struct             host_if_msg
+ *  @struct             struct host_if_msg
  *  @brief		Host Interface message
  *  @details
  *  @todo
@@ -458,11 +458,11 @@ typedef union _tuniHostIFmsgBody {
  *  @date		25 March 2012
  *  @version		1.0
  */
-typedef struct _host_if_msg {
+struct host_if_msg {
 	u16 u16MsgId;                                           /*!< Message ID */
 	tuniHostIFmsgBody uniHostIFmsgBody;             /*!< Message body */
 	tstrWILC_WFIDrv *drvHandler;
-} host_if_msg;
+};
 
 #ifdef CONNECT_DIRECT
 typedef struct _tstrWidJoinReqExt {
@@ -3966,19 +3966,19 @@ _done_:
 static void ListenTimerCB(unsigned long arg)
 {
 	s32 s32Error = 0;
-	host_if_msg strHostIFmsg;
+	struct host_if_msg strHostIFmsg;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)arg;
 	/*Stopping remain-on-channel timer*/
 	del_timer(&pstrWFIDrv->hRemainOnChannel);
 
 	/* prepare the Timer Callback message */
-	memset(&strHostIFmsg, 0, sizeof(host_if_msg));
+	memset(&strHostIFmsg, 0, sizeof(struct host_if_msg));
 	strHostIFmsg.u16MsgId = HOST_IF_MSG_LISTEN_TIMER_FIRED;
 	strHostIFmsg.drvHandler = pstrWFIDrv;
 	strHostIFmsg.uniHostIFmsgBody.strHostIfRemainOnChan.u32ListenSessionID = pstrWFIDrv->strHostIfRemainOnChan.u32ListenSessionID;
 
 	/* send the message */
-	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(host_if_msg));
+	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
 	if (s32Error)
 		PRINT_ER("wilc_mq_send fail\n");
 }
@@ -4293,13 +4293,13 @@ static s32 Handle_DelAllRxBASessions(tstrWILC_WFIDrv *drvHandler, tstrHostIfBASe
 static int hostIFthread(void *pvArg)
 {
 	u32 u32Ret;
-	host_if_msg strHostIFmsg;
+	struct host_if_msg strHostIFmsg;
 	tstrWILC_WFIDrv *pstrWFIDrv;
 
-	memset(&strHostIFmsg, 0, sizeof(host_if_msg));
+	memset(&strHostIFmsg, 0, sizeof(struct host_if_msg));
 
 	while (1) {
-		wilc_mq_recv(&gMsgQHostIF, &strHostIFmsg, sizeof(host_if_msg), &u32Ret);
+		wilc_mq_recv(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg), &u32Ret);
 		pstrWFIDrv = (tstrWILC_WFIDrv *)strHostIFmsg.drvHandler;
 		if (strHostIFmsg.u16MsgId == HOST_IF_MSG_EXIT) {
 			PRINT_D(GENERIC_DBG, "THREAD: Exiting HostIfThread\n");
@@ -4311,13 +4311,13 @@ static int hostIFthread(void *pvArg)
 		if ((!g_wilc_initialized)) {
 			PRINT_D(GENERIC_DBG, "--WAIT--");
 			usleep_range(200 * 1000, 200 * 1000);
-			wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(host_if_msg));
+			wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
 			continue;
 		}
 
 		if (strHostIFmsg.u16MsgId == HOST_IF_MSG_CONNECT && pstrWFIDrv->strWILC_UsrScanReq.pfUserScanResult != NULL) {
 			PRINT_D(HOSTINF_DBG, "Requeue connect request till scan done received\n");
-			wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(host_if_msg));
+			wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
 			usleep_range(2 * 1000, 2 * 1000);
 			continue;
 		}
@@ -4506,29 +4506,29 @@ static int hostIFthread(void *pvArg)
 static void TimerCB_Scan(unsigned long arg)
 {
 	void *pvArg = (void *)arg;
-	host_if_msg strHostIFmsg;
+	struct host_if_msg strHostIFmsg;
 
 	/* prepare the Timer Callback message */
-	memset(&strHostIFmsg, 0, sizeof(host_if_msg));
+	memset(&strHostIFmsg, 0, sizeof(struct host_if_msg));
 	strHostIFmsg.drvHandler = pvArg;
 	strHostIFmsg.u16MsgId = HOST_IF_MSG_SCAN_TIMER_FIRED;
 
 	/* send the message */
-	wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(host_if_msg));
+	wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
 }
 
 static void TimerCB_Connect(unsigned long arg)
 {
 	void *pvArg = (void *)arg;
-	host_if_msg strHostIFmsg;
+	struct host_if_msg strHostIFmsg;
 
 	/* prepare the Timer Callback message */
-	memset(&strHostIFmsg, 0, sizeof(host_if_msg));
+	memset(&strHostIFmsg, 0, sizeof(struct host_if_msg));
 	strHostIFmsg.drvHandler = pvArg;
 	strHostIFmsg.u16MsgId = HOST_IF_MSG_CONNECT_TIMER_FIRED;
 
 	/* send the message */
-	wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(host_if_msg));
+	wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
 }
 
 
@@ -4578,7 +4578,7 @@ s32 host_int_remove_wep_key(tstrWILC_WFIDrv *hWFIDrv, u8 u8keyIdx)
 {
 	s32 s32Error = 0;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
-	host_if_msg strHostIFmsg;
+	struct host_if_msg strHostIFmsg;
 
 
 	if (pstrWFIDrv == NULL) {
@@ -4588,7 +4588,7 @@ s32 host_int_remove_wep_key(tstrWILC_WFIDrv *hWFIDrv, u8 u8keyIdx)
 	}
 
 	/* prepare the Remove Wep Key Message */
-	memset(&strHostIFmsg, 0, sizeof(host_if_msg));
+	memset(&strHostIFmsg, 0, sizeof(struct host_if_msg));
 
 
 	strHostIFmsg.u16MsgId = HOST_IF_MSG_KEY;
@@ -4602,7 +4602,7 @@ s32 host_int_remove_wep_key(tstrWILC_WFIDrv *hWFIDrv, u8 u8keyIdx)
 	uniHostIFkeyAttr.strHostIFwepAttr.u8Wepidx = u8keyIdx;
 
 	/* send the message */
-	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(host_if_msg));
+	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
 	if (s32Error)
 		PRINT_ER("Error in sending message queue : Request to remove WEP key\n");
 	down(&(pstrWFIDrv->hSemTestKeyBlock));
@@ -4626,7 +4626,7 @@ s32 host_int_set_WEPDefaultKeyID(tstrWILC_WFIDrv *hWFIDrv, u8 u8Index)
 {
 	s32 s32Error = 0;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
-	host_if_msg strHostIFmsg;
+	struct host_if_msg strHostIFmsg;
 
 
 	if (pstrWFIDrv == NULL) {
@@ -4636,7 +4636,7 @@ s32 host_int_set_WEPDefaultKeyID(tstrWILC_WFIDrv *hWFIDrv, u8 u8Index)
 	}
 
 	/* prepare the Key Message */
-	memset(&strHostIFmsg, 0, sizeof(host_if_msg));
+	memset(&strHostIFmsg, 0, sizeof(struct host_if_msg));
 
 
 	strHostIFmsg.u16MsgId = HOST_IF_MSG_KEY;
@@ -4649,7 +4649,7 @@ s32 host_int_set_WEPDefaultKeyID(tstrWILC_WFIDrv *hWFIDrv, u8 u8Index)
 	uniHostIFkeyAttr.strHostIFwepAttr.u8Wepidx = u8Index;
 
 	/* send the message */
-	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(host_if_msg));
+	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
 	if (s32Error)
 		PRINT_ER("Error in sending message queue : Default key index\n");
 	down(&(pstrWFIDrv->hSemTestKeyBlock));
@@ -4681,7 +4681,7 @@ s32 host_int_add_wep_key_bss_sta(tstrWILC_WFIDrv *hWFIDrv, const u8 *pu8WepKey,
 
 	s32 s32Error = 0;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
-	host_if_msg strHostIFmsg;
+	struct host_if_msg strHostIFmsg;
 
 	if (pstrWFIDrv == NULL) {
 		s32Error = -EFAULT;
@@ -4690,7 +4690,7 @@ s32 host_int_add_wep_key_bss_sta(tstrWILC_WFIDrv *hWFIDrv, const u8 *pu8WepKey,
 	}
 
 	/* prepare the Key Message */
-	memset(&strHostIFmsg, 0, sizeof(host_if_msg));
+	memset(&strHostIFmsg, 0, sizeof(struct host_if_msg));
 
 
 	strHostIFmsg.u16MsgId = HOST_IF_MSG_KEY;
@@ -4713,7 +4713,7 @@ s32 host_int_add_wep_key_bss_sta(tstrWILC_WFIDrv *hWFIDrv, const u8 *pu8WepKey,
 	uniHostIFkeyAttr.strHostIFwepAttr.u8Wepidx = u8Keyidx;
 
 	/* send the message */
-	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(host_if_msg));
+	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
 	if (s32Error)
 		PRINT_ER("Error in sending message queue :WEP Key\n");
 	down(&(pstrWFIDrv->hSemTestKeyBlock));
@@ -4743,7 +4743,7 @@ s32 host_int_add_wep_key_bss_ap(tstrWILC_WFIDrv *hWFIDrv, const u8 *pu8WepKey, u
 
 	s32 s32Error = 0;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
-	host_if_msg strHostIFmsg;
+	struct host_if_msg strHostIFmsg;
 	u8 i;
 
 	if (pstrWFIDrv == NULL) {
@@ -4753,7 +4753,7 @@ s32 host_int_add_wep_key_bss_ap(tstrWILC_WFIDrv *hWFIDrv, const u8 *pu8WepKey, u
 	}
 
 	/* prepare the Key Message */
-	memset(&strHostIFmsg, 0, sizeof(host_if_msg));
+	memset(&strHostIFmsg, 0, sizeof(struct host_if_msg));
 
 	if (INFO) {
 		for (i = 0; i < u8WepKeylen; i++)
@@ -4785,7 +4785,7 @@ s32 host_int_add_wep_key_bss_ap(tstrWILC_WFIDrv *hWFIDrv, const u8 *pu8WepKey, u
 	strHostIFmsg.uniHostIFmsgBody.strHostIFkeyAttr.
 	uniHostIFkeyAttr.strHostIFwepAttr.tenuAuth_type = tenuAuth_type;
 	/* send the message */
-	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(host_if_msg));
+	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
 
 	if (s32Error)
 		PRINT_ER("Error in sending message queue :WEP Key\n");
@@ -4816,7 +4816,7 @@ s32 host_int_add_ptk(tstrWILC_WFIDrv *hWFIDrv, const u8 *pu8Ptk, u8 u8PtkKeylen,
 {
 	s32 s32Error = 0;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
-	host_if_msg strHostIFmsg;
+	struct host_if_msg strHostIFmsg;
 	u8 u8KeyLen = u8PtkKeylen;
 	u32 i;
 
@@ -4831,7 +4831,7 @@ s32 host_int_add_ptk(tstrWILC_WFIDrv *hWFIDrv, const u8 *pu8Ptk, u8 u8PtkKeylen,
 		u8KeyLen += TX_MIC_KEY_LEN;
 
 	/* prepare the Key Message */
-	memset(&strHostIFmsg, 0, sizeof(host_if_msg));
+	memset(&strHostIFmsg, 0, sizeof(struct host_if_msg));
 
 
 	strHostIFmsg.u16MsgId = HOST_IF_MSG_KEY;
@@ -4881,7 +4881,7 @@ s32 host_int_add_ptk(tstrWILC_WFIDrv *hWFIDrv, const u8 *pu8Ptk, u8 u8PtkKeylen,
 	strHostIFmsg.drvHandler = hWFIDrv;
 
 	/* send the message */
-	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(host_if_msg));
+	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
 
 	if (s32Error)
 		PRINT_ER("Error in sending message queue:  PTK Key\n");
@@ -4912,7 +4912,7 @@ s32 host_int_add_rx_gtk(tstrWILC_WFIDrv *hWFIDrv, const u8 *pu8RxGtk, u8 u8GtkKe
 {
 	s32 s32Error = 0;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
-	host_if_msg strHostIFmsg;
+	struct host_if_msg strHostIFmsg;
 	u8 u8KeyLen = u8GtkKeylen;
 
 	if (pstrWFIDrv == NULL) {
@@ -4921,7 +4921,7 @@ s32 host_int_add_rx_gtk(tstrWILC_WFIDrv *hWFIDrv, const u8 *pu8RxGtk, u8 u8GtkKe
 		return s32Error;
 	}
 	/* prepare the Key Message */
-	memset(&strHostIFmsg, 0, sizeof(host_if_msg));
+	memset(&strHostIFmsg, 0, sizeof(struct host_if_msg));
 
 
 	if (pu8RxMic != NULL)
@@ -4979,7 +4979,7 @@ s32 host_int_add_rx_gtk(tstrWILC_WFIDrv *hWFIDrv, const u8 *pu8RxGtk, u8 u8GtkKe
 
 
 	/* send the message */
-	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(host_if_msg));
+	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
 	if (s32Error)
 		PRINT_ER("Error in sending message queue:  RX GTK\n");
 	/* ////////////// */
@@ -5013,7 +5013,7 @@ s32 host_int_set_pmkid_info(tstrWILC_WFIDrv *hWFIDrv, tstrHostIFpmkidAttr *pu8Pm
 {
 	s32 s32Error = 0;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
-	host_if_msg strHostIFmsg;
+	struct host_if_msg strHostIFmsg;
 	u32 i;
 
 
@@ -5024,7 +5024,7 @@ s32 host_int_set_pmkid_info(tstrWILC_WFIDrv *hWFIDrv, tstrHostIFpmkidAttr *pu8Pm
 	}
 
 	/* prepare the Key Message */
-	memset(&strHostIFmsg, 0, sizeof(host_if_msg));
+	memset(&strHostIFmsg, 0, sizeof(struct host_if_msg));
 
 	strHostIFmsg.u16MsgId = HOST_IF_MSG_KEY;
 	strHostIFmsg.uniHostIFmsgBody.strHostIFkeyAttr.enuKeyType = PMKSA;
@@ -5041,7 +5041,7 @@ s32 host_int_set_pmkid_info(tstrWILC_WFIDrv *hWFIDrv, tstrHostIFpmkidAttr *pu8Pm
 	}
 
 	/* send the message */
-	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(host_if_msg));
+	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
 	if (s32Error)
 		PRINT_ER(" Error in sending messagequeue: PMKID Info\n");
 
@@ -5128,17 +5128,17 @@ s32 host_int_set_RSNAConfigPSKPassPhrase(tstrWILC_WFIDrv *hWFIDrv, u8 *pu8PassPh
 s32 host_int_get_MacAddress(tstrWILC_WFIDrv *hWFIDrv, u8 *pu8MacAddress)
 {
 	s32 s32Error = 0;
-	host_if_msg strHostIFmsg;
+	struct host_if_msg strHostIFmsg;
 
 
 	/* prepare the Message */
-	memset(&strHostIFmsg, 0, sizeof(host_if_msg));
+	memset(&strHostIFmsg, 0, sizeof(struct host_if_msg));
 
 	strHostIFmsg.u16MsgId = HOST_IF_MSG_GET_MAC_ADDRESS;
 	strHostIFmsg.uniHostIFmsgBody.strHostIfGetMacAddress.u8MacAddress = pu8MacAddress;
 	strHostIFmsg.drvHandler = hWFIDrv;
 	/* send the message */
-	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(host_if_msg));
+	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
 	if (s32Error) {
 		PRINT_ER("Failed to send get mac address\n");
 		return -EFAULT;
@@ -5162,17 +5162,17 @@ s32 host_int_get_MacAddress(tstrWILC_WFIDrv *hWFIDrv, u8 *pu8MacAddress)
 s32 host_int_set_MacAddress(tstrWILC_WFIDrv *hWFIDrv, u8 *pu8MacAddress)
 {
 	s32 s32Error = 0;
-	host_if_msg strHostIFmsg;
+	struct host_if_msg strHostIFmsg;
 
 	PRINT_D(GENERIC_DBG, "mac addr = %x:%x:%x\n", pu8MacAddress[0], pu8MacAddress[1], pu8MacAddress[2]);
 
 	/* prepare setting mac address message */
-	memset(&strHostIFmsg, 0, sizeof(host_if_msg));
+	memset(&strHostIFmsg, 0, sizeof(struct host_if_msg));
 	strHostIFmsg.u16MsgId = HOST_IF_MSG_SET_MAC_ADDRESS;
 	memcpy(strHostIFmsg.uniHostIFmsgBody.strHostIfSetMacAddress.u8MacAddress, pu8MacAddress, ETH_ALEN);
 	strHostIFmsg.drvHandler = hWFIDrv;
 
-	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(host_if_msg));
+	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
 	if (s32Error)
 		PRINT_ER("Failed to send message queue: Set mac address\n");
 
@@ -5352,7 +5352,7 @@ s32 host_int_set_join_req(tstrWILC_WFIDrv *hWFIDrv, u8 *pu8bssid,
 {
 	s32 s32Error = 0;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
-	host_if_msg strHostIFmsg;
+	struct host_if_msg strHostIFmsg;
 	tenuScanConnTimer enuScanConnTimer;
 
 	if (pstrWFIDrv == NULL || pfConnectResult == NULL) {
@@ -5372,7 +5372,7 @@ s32 host_int_set_join_req(tstrWILC_WFIDrv *hWFIDrv, u8 *pu8bssid,
 	}
 
 	/* prepare the Connect Message */
-	memset(&strHostIFmsg, 0, sizeof(host_if_msg));
+	memset(&strHostIFmsg, 0, sizeof(struct host_if_msg));
 
 	strHostIFmsg.u16MsgId = HOST_IF_MSG_CONNECT;
 
@@ -5410,7 +5410,7 @@ s32 host_int_set_join_req(tstrWILC_WFIDrv *hWFIDrv, u8 *pu8bssid,
 		PRINT_D(GENERIC_DBG, "Don't set state to 'connecting' as state is %d\n", pstrWFIDrv->enuHostIFstate);
 
 	/* send the message */
-	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(host_if_msg));
+	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
 	if (s32Error) {
 		PRINT_ER("Failed to send message queue: Set join request\n");
 		return -EFAULT;
@@ -5439,7 +5439,7 @@ s32 host_int_set_join_req(tstrWILC_WFIDrv *hWFIDrv, u8 *pu8bssid,
 s32 host_int_flush_join_req(tstrWILC_WFIDrv *hWFIDrv)
 {
 	s32 s32Error = 0;
-	host_if_msg strHostIFmsg;
+	struct host_if_msg strHostIFmsg;
 
 	if (!gu8FlushedJoinReq)	{
 		s32Error = -EFAULT;
@@ -5457,7 +5457,7 @@ s32 host_int_flush_join_req(tstrWILC_WFIDrv *hWFIDrv)
 	strHostIFmsg.drvHandler = hWFIDrv;
 
 	/* send the message */
-	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(host_if_msg));
+	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
 	if (s32Error) {
 		PRINT_ER("Failed to send message queue: Flush join request\n");
 		return -EFAULT;
@@ -5480,7 +5480,7 @@ s32 host_int_flush_join_req(tstrWILC_WFIDrv *hWFIDrv)
 s32 host_int_disconnect(tstrWILC_WFIDrv *hWFIDrv, u16 u16ReasonCode)
 {
 	s32 s32Error = 0;
-	host_if_msg strHostIFmsg;
+	struct host_if_msg strHostIFmsg;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
 
 	if (pstrWFIDrv == NULL) {
@@ -5489,13 +5489,13 @@ s32 host_int_disconnect(tstrWILC_WFIDrv *hWFIDrv, u16 u16ReasonCode)
 	}
 
 	/* prepare the Disconnect Message */
-	memset(&strHostIFmsg, 0, sizeof(host_if_msg));
+	memset(&strHostIFmsg, 0, sizeof(struct host_if_msg));
 
 	strHostIFmsg.u16MsgId = HOST_IF_MSG_DISCONNECT;
 	strHostIFmsg.drvHandler = hWFIDrv;
 
 	/* send the message */
-	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(host_if_msg));
+	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
 	if (s32Error)
 		PRINT_ER("Failed to send message queue: disconnect\n");
 	/* ////////////// */
@@ -5665,7 +5665,7 @@ s32 host_int_set_mac_chnl_num(tstrWILC_WFIDrv *hWFIDrv, u8 u8ChNum)
 {
 	s32 s32Error = 0;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
-	host_if_msg strHostIFmsg;
+	struct host_if_msg strHostIFmsg;
 
 	if (pstrWFIDrv == NULL) {
 		PRINT_ER("driver is null\n");
@@ -5673,12 +5673,12 @@ s32 host_int_set_mac_chnl_num(tstrWILC_WFIDrv *hWFIDrv, u8 u8ChNum)
 	}
 
 	/* prepare the set channel message */
-	memset(&strHostIFmsg, 0, sizeof(host_if_msg));
+	memset(&strHostIFmsg, 0, sizeof(struct host_if_msg));
 	strHostIFmsg.u16MsgId = HOST_IF_MSG_SET_CHANNEL;
 	strHostIFmsg.uniHostIFmsgBody.strHostIFSetChan.u8SetChan = u8ChNum;
 	strHostIFmsg.drvHandler = hWFIDrv;
 
-	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(host_if_msg));
+	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
 	if (s32Error) {
 		PRINT_ER("wilc mq send fail\n");
 		s32Error = -EINVAL;
@@ -5692,13 +5692,13 @@ s32 host_int_wait_msg_queue_idle(void)
 {
 	s32 s32Error = 0;
 
-	host_if_msg strHostIFmsg;
+	struct host_if_msg strHostIFmsg;
 
 	/* prepare the set driver handler message */
 
-	memset(&strHostIFmsg, 0, sizeof(host_if_msg));
+	memset(&strHostIFmsg, 0, sizeof(struct host_if_msg));
 	strHostIFmsg.u16MsgId = HOST_IF_MSG_Q_IDLE;
-	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(host_if_msg));
+	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
 	if (s32Error) {
 		PRINT_ER("wilc mq send fail\n");
 		s32Error = -EINVAL;
@@ -5715,17 +5715,17 @@ s32 host_int_set_wfi_drv_handler(tstrWILC_WFIDrv *u32address)
 {
 	s32 s32Error = 0;
 
-	host_if_msg strHostIFmsg;
+	struct host_if_msg strHostIFmsg;
 
 
 	/* prepare the set driver handler message */
 
-	memset(&strHostIFmsg, 0, sizeof(host_if_msg));
+	memset(&strHostIFmsg, 0, sizeof(struct host_if_msg));
 	strHostIFmsg.u16MsgId = HOST_IF_MSG_SET_WFIDRV_HANDLER;
 	strHostIFmsg.uniHostIFmsgBody.strHostIfSetDrvHandler.u32Address = get_id_from_handler(u32address);
 	strHostIFmsg.drvHandler = u32address;
 
-	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(host_if_msg));
+	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
 	if (s32Error) {
 		PRINT_ER("wilc mq send fail\n");
 		s32Error = -EINVAL;
@@ -5740,17 +5740,17 @@ s32 host_int_set_operation_mode(tstrWILC_WFIDrv *hWFIDrv, u32 u32mode)
 {
 	s32 s32Error = 0;
 
-	host_if_msg strHostIFmsg;
+	struct host_if_msg strHostIFmsg;
 
 
 	/* prepare the set driver handler message */
 
-	memset(&strHostIFmsg, 0, sizeof(host_if_msg));
+	memset(&strHostIFmsg, 0, sizeof(struct host_if_msg));
 	strHostIFmsg.u16MsgId = HOST_IF_MSG_SET_OPERATION_MODE;
 	strHostIFmsg.uniHostIFmsgBody.strHostIfSetOperationMode.u32Mode = u32mode;
 	strHostIFmsg.drvHandler = hWFIDrv;
 
-	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(host_if_msg));
+	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
 	if (s32Error) {
 		PRINT_ER("wilc mq send fail\n");
 		s32Error = -EINVAL;
@@ -5778,7 +5778,7 @@ s32 host_int_get_host_chnl_num(tstrWILC_WFIDrv *hWFIDrv, u8 *pu8ChNo)
 {
 	s32 s32Error = 0;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
-	host_if_msg strHostIFmsg;
+	struct host_if_msg strHostIFmsg;
 
 	if (pstrWFIDrv == NULL) {
 		PRINT_ER("driver is null\n");
@@ -5786,13 +5786,13 @@ s32 host_int_get_host_chnl_num(tstrWILC_WFIDrv *hWFIDrv, u8 *pu8ChNo)
 	}
 
 	/* prepare the Get Channel Message */
-	memset(&strHostIFmsg, 0, sizeof(host_if_msg));
+	memset(&strHostIFmsg, 0, sizeof(struct host_if_msg));
 
 	strHostIFmsg.u16MsgId = HOST_IF_MSG_GET_CHNL;
 	strHostIFmsg.drvHandler = hWFIDrv;
 
 	/* send the message */
-	s32Error =	wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(host_if_msg));
+	s32Error =	wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
 	if (s32Error)
 		PRINT_ER("wilc mq send fail\n");
 	down(&(pstrWFIDrv->hSemGetCHNL));
@@ -5863,14 +5863,14 @@ s32 host_int_get_inactive_time(tstrWILC_WFIDrv *hWFIDrv, const u8 *mac, u32 *pu3
 {
 	s32 s32Error = 0;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
-	host_if_msg strHostIFmsg;
+	struct host_if_msg strHostIFmsg;
 
 	if (pstrWFIDrv == NULL) {
 		PRINT_ER("driver is null\n");
 		return -EFAULT;
 	}
 
-	memset(&strHostIFmsg, 0, sizeof(host_if_msg));
+	memset(&strHostIFmsg, 0, sizeof(struct host_if_msg));
 
 
 	memcpy(strHostIFmsg.uniHostIFmsgBody.strHostIfStaInactiveT.mac,
@@ -5880,7 +5880,7 @@ s32 host_int_get_inactive_time(tstrWILC_WFIDrv *hWFIDrv, const u8 *mac, u32 *pu3
 	strHostIFmsg.drvHandler = hWFIDrv;
 
 	/* send the message */
-	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(host_if_msg));
+	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
 	if (s32Error)
 		PRINT_ER("Failed to send get host channel param's message queue ");
 
@@ -5950,18 +5950,18 @@ s32 host_int_test_get_int_wid(tstrWILC_WFIDrv *hWFIDrv, u32 *pu32TestMemAddr)
 s32 host_int_get_rssi(tstrWILC_WFIDrv *hWFIDrv, s8 *ps8Rssi)
 {
 	s32 s32Error = 0;
-	host_if_msg strHostIFmsg;
+	struct host_if_msg strHostIFmsg;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
 
 
 	/* prepare the Get RSSI Message */
-	memset(&strHostIFmsg, 0, sizeof(host_if_msg));
+	memset(&strHostIFmsg, 0, sizeof(struct host_if_msg));
 
 	strHostIFmsg.u16MsgId = HOST_IF_MSG_GET_RSSI;
 	strHostIFmsg.drvHandler = hWFIDrv;
 
 	/* send the message */
-	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(host_if_msg));
+	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
 	if (s32Error) {
 		PRINT_ER("Failed to send get host channel param's message queue ");
 		return -EFAULT;
@@ -5984,7 +5984,7 @@ s32 host_int_get_rssi(tstrWILC_WFIDrv *hWFIDrv, s8 *ps8Rssi)
 
 s32 host_int_get_link_speed(tstrWILC_WFIDrv *hWFIDrv, s8 *ps8lnkspd)
 {
-	host_if_msg strHostIFmsg;
+	struct host_if_msg strHostIFmsg;
 	s32 s32Error = 0;
 
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
@@ -5992,13 +5992,13 @@ s32 host_int_get_link_speed(tstrWILC_WFIDrv *hWFIDrv, s8 *ps8lnkspd)
 
 
 	/* prepare the Get LINKSPEED Message */
-	memset(&strHostIFmsg, 0, sizeof(host_if_msg));
+	memset(&strHostIFmsg, 0, sizeof(struct host_if_msg));
 
 	strHostIFmsg.u16MsgId = HOST_IF_MSG_GET_LINKSPEED;
 	strHostIFmsg.drvHandler = hWFIDrv;
 
 	/* send the message */
-	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(host_if_msg));
+	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
 	if (s32Error) {
 		PRINT_ER("Failed to send GET_LINKSPEED to message queue ");
 		return -EFAULT;
@@ -6022,17 +6022,17 @@ s32 host_int_get_link_speed(tstrWILC_WFIDrv *hWFIDrv, s8 *ps8lnkspd)
 s32 host_int_get_statistics(tstrWILC_WFIDrv *hWFIDrv, tstrStatistics *pstrStatistics)
 {
 	s32 s32Error = 0;
-	host_if_msg strHostIFmsg;
+	struct host_if_msg strHostIFmsg;
 
 
 	/* prepare the Get RSSI Message */
-	memset(&strHostIFmsg, 0, sizeof(host_if_msg));
+	memset(&strHostIFmsg, 0, sizeof(struct host_if_msg));
 
 	strHostIFmsg.u16MsgId = HOST_IF_MSG_GET_STATISTICS;
 	strHostIFmsg.uniHostIFmsgBody.pUserData = (char *)pstrStatistics;
 	strHostIFmsg.drvHandler = hWFIDrv;
 	/* send the message */
-	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(host_if_msg));
+	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
 	if (s32Error) {
 		PRINT_ER("Failed to send get host channel param's message queue ");
 		return -EFAULT;
@@ -6067,7 +6067,7 @@ s32 host_int_scan(tstrWILC_WFIDrv *hWFIDrv, u8 u8ScanSource,
 {
 	s32 s32Error = 0;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
-	host_if_msg strHostIFmsg;
+	struct host_if_msg strHostIFmsg;
 	tenuScanConnTimer enuScanConnTimer;
 
 	if (pstrWFIDrv == NULL || ScanResult == NULL) {
@@ -6076,7 +6076,7 @@ s32 host_int_scan(tstrWILC_WFIDrv *hWFIDrv, u8 u8ScanSource,
 	}
 
 	/* prepare the Scan Message */
-	memset(&strHostIFmsg, 0, sizeof(host_if_msg));
+	memset(&strHostIFmsg, 0, sizeof(struct host_if_msg));
 
 	strHostIFmsg.u16MsgId = HOST_IF_MSG_SCAN;
 
@@ -6104,7 +6104,7 @@ s32 host_int_scan(tstrWILC_WFIDrv *hWFIDrv, u8 u8ScanSource,
 		    pu8IEs, IEsLen);
 
 	/* send the message */
-	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(host_if_msg));
+	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
 	if (s32Error) {
 		PRINT_ER("Error in sending message queue\n");
 		return -EINVAL;
@@ -6136,7 +6136,7 @@ s32 hif_set_cfg(tstrWILC_WFIDrv *hWFIDrv, tstrCfgParamVal *pstrCfgParamVal)
 	s32 s32Error = 0;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
 
-	host_if_msg strHostIFmsg;
+	struct host_if_msg strHostIFmsg;
 
 
 	if (pstrWFIDrv == NULL) {
@@ -6144,12 +6144,12 @@ s32 hif_set_cfg(tstrWILC_WFIDrv *hWFIDrv, tstrCfgParamVal *pstrCfgParamVal)
 		return -EFAULT;
 	}
 	/* prepare the WiphyParams Message */
-	memset(&strHostIFmsg, 0, sizeof(host_if_msg));
+	memset(&strHostIFmsg, 0, sizeof(struct host_if_msg));
 	strHostIFmsg.u16MsgId = HOST_IF_MSG_CFG_PARAMS;
 	strHostIFmsg.uniHostIFmsgBody.strHostIFCfgParamAttr.pstrCfgParamVal = *pstrCfgParamVal;
 	strHostIFmsg.drvHandler = hWFIDrv;
 
-	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(host_if_msg));
+	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
 
 	return s32Error;
 
@@ -6312,16 +6312,16 @@ static void GetPeriodicRSSI(unsigned long arg)
 
 	if (pstrWFIDrv->enuHostIFstate == HOST_IF_CONNECTED) {
 		s32 s32Error = 0;
-		host_if_msg strHostIFmsg;
+		struct host_if_msg strHostIFmsg;
 
 		/* prepare the Get RSSI Message */
-		memset(&strHostIFmsg, 0, sizeof(host_if_msg));
+		memset(&strHostIFmsg, 0, sizeof(struct host_if_msg));
 
 		strHostIFmsg.u16MsgId = HOST_IF_MSG_GET_RSSI;
 		strHostIFmsg.drvHandler = pstrWFIDrv;
 
 		/* send the message */
-		s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(host_if_msg));
+		s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
 		if (s32Error) {
 			PRINT_ER("Failed to send get host channel param's message queue ");
 			return;
@@ -6507,7 +6507,7 @@ _fail_:
 s32 host_int_deinit(tstrWILC_WFIDrv *hWFIDrv)
 {
 	s32 s32Error = 0;
-	host_if_msg strHostIFmsg;
+	struct host_if_msg strHostIFmsg;
 	int ret;
 
 	/*obtain driver handle*/
@@ -6568,7 +6568,7 @@ s32 host_int_deinit(tstrWILC_WFIDrv *hWFIDrv)
 
 	gbScanWhileConnected = false;
 
-	memset(&strHostIFmsg, 0, sizeof(host_if_msg));
+	memset(&strHostIFmsg, 0, sizeof(struct host_if_msg));
 
 	if (clients_count == 1)	{
 		if (del_timer_sync(&g_hPeriodicRSSI)) {
@@ -6579,7 +6579,7 @@ s32 host_int_deinit(tstrWILC_WFIDrv *hWFIDrv)
 		strHostIFmsg.drvHandler = hWFIDrv;
 
 
-		s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(host_if_msg));
+		s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
 		if (s32Error != 0)
 			PRINT_ER("Error in sending deinit's message queue message function: Error(%d)\n", s32Error);
 
@@ -6625,7 +6625,7 @@ s32 host_int_deinit(tstrWILC_WFIDrv *hWFIDrv)
 void NetworkInfoReceived(u8 *pu8Buffer, u32 u32Length)
 {
 	s32 s32Error = 0;
-	host_if_msg strHostIFmsg;
+	struct host_if_msg strHostIFmsg;
 	int id;
 	tstrWILC_WFIDrv *pstrWFIDrv = NULL;
 
@@ -6641,7 +6641,7 @@ void NetworkInfoReceived(u8 *pu8Buffer, u32 u32Length)
 	}
 
 	/* prepare the Asynchronous Network Info message */
-	memset(&strHostIFmsg, 0, sizeof(host_if_msg));
+	memset(&strHostIFmsg, 0, sizeof(struct host_if_msg));
 
 	strHostIFmsg.u16MsgId = HOST_IF_MSG_RCVD_NTWRK_INFO;
 	strHostIFmsg.drvHandler = pstrWFIDrv;
@@ -6652,7 +6652,7 @@ void NetworkInfoReceived(u8 *pu8Buffer, u32 u32Length)
 		    pu8Buffer, u32Length);
 
 	/* send the message */
-	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(host_if_msg));
+	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
 	if (s32Error)
 		PRINT_ER("Error in sending network info message queue message parameters: Error(%d)\n", s32Error);
 }
@@ -6671,7 +6671,7 @@ void NetworkInfoReceived(u8 *pu8Buffer, u32 u32Length)
 void GnrlAsyncInfoReceived(u8 *pu8Buffer, u32 u32Length)
 {
 	s32 s32Error = 0;
-	host_if_msg strHostIFmsg;
+	struct host_if_msg strHostIFmsg;
 	int id;
 	tstrWILC_WFIDrv *pstrWFIDrv = NULL;
 
@@ -6696,7 +6696,7 @@ void GnrlAsyncInfoReceived(u8 *pu8Buffer, u32 u32Length)
 	}
 
 	/* prepare the General Asynchronous Info message */
-	memset(&strHostIFmsg, 0, sizeof(host_if_msg));
+	memset(&strHostIFmsg, 0, sizeof(struct host_if_msg));
 
 
 	strHostIFmsg.u16MsgId = HOST_IF_MSG_RCVD_GNRL_ASYNC_INFO;
@@ -6709,7 +6709,7 @@ void GnrlAsyncInfoReceived(u8 *pu8Buffer, u32 u32Length)
 		    pu8Buffer, u32Length);
 
 	/* send the message */
-	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(host_if_msg));
+	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
 	if (s32Error)
 		PRINT_ER("Error in sending message queue asynchronous message info: Error(%d)\n", s32Error);
 
@@ -6728,7 +6728,7 @@ void GnrlAsyncInfoReceived(u8 *pu8Buffer, u32 u32Length)
 void host_int_ScanCompleteReceived(u8 *pu8Buffer, u32 u32Length)
 {
 	s32 s32Error = 0;
-	host_if_msg strHostIFmsg;
+	struct host_if_msg strHostIFmsg;
 	int id;
 	tstrWILC_WFIDrv *pstrWFIDrv = NULL;
 
@@ -6744,7 +6744,7 @@ void host_int_ScanCompleteReceived(u8 *pu8Buffer, u32 u32Length)
 	/*if there is an ongoing scan request*/
 	if (pstrWFIDrv->strWILC_UsrScanReq.pfUserScanResult) {
 		/* prepare theScan Done message */
-		memset(&strHostIFmsg, 0, sizeof(host_if_msg));
+		memset(&strHostIFmsg, 0, sizeof(struct host_if_msg));
 
 		strHostIFmsg.u16MsgId = HOST_IF_MSG_RCVD_SCAN_COMPLETE;
 		strHostIFmsg.drvHandler = pstrWFIDrv;
@@ -6759,7 +6759,7 @@ void host_int_ScanCompleteReceived(u8 *pu8Buffer, u32 u32Length)
 		 *                        pu8Buffer, u32Length); */
 
 		/* send the message */
-		s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(host_if_msg));
+		s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
 		if (s32Error)
 			PRINT_ER("Error in sending message queue scan complete parameters: Error(%d)\n", s32Error);
 	}
@@ -6787,7 +6787,7 @@ s32 host_int_remain_on_channel(tstrWILC_WFIDrv *hWFIDrv, u32 u32SessionID, u32 u
 {
 	s32 s32Error = 0;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
-	host_if_msg strHostIFmsg;
+	struct host_if_msg strHostIFmsg;
 
 	if (pstrWFIDrv == NULL) {
 		PRINT_ER("driver is null\n");
@@ -6795,7 +6795,7 @@ s32 host_int_remain_on_channel(tstrWILC_WFIDrv *hWFIDrv, u32 u32SessionID, u32 u
 	}
 
 	/* prepare the remainonchan Message */
-	memset(&strHostIFmsg, 0, sizeof(host_if_msg));
+	memset(&strHostIFmsg, 0, sizeof(struct host_if_msg));
 
 	/* prepare the WiphyParams Message */
 	strHostIFmsg.u16MsgId = HOST_IF_MSG_REMAIN_ON_CHAN;
@@ -6807,7 +6807,7 @@ s32 host_int_remain_on_channel(tstrWILC_WFIDrv *hWFIDrv, u32 u32SessionID, u32 u
 	strHostIFmsg.uniHostIFmsgBody.strHostIfRemainOnChan.u32ListenSessionID = u32SessionID;
 	strHostIFmsg.drvHandler = hWFIDrv;
 
-	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(host_if_msg));
+	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
 	if (s32Error)
 		PRINT_ER("wilc mq send fail\n");
 
@@ -6832,7 +6832,7 @@ s32 host_int_ListenStateExpired(tstrWILC_WFIDrv *hWFIDrv, u32 u32SessionID)
 {
 	s32 s32Error = 0;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
-	host_if_msg strHostIFmsg;
+	struct host_if_msg strHostIFmsg;
 
 	if (pstrWFIDrv == NULL) {
 		PRINT_ER("driver is null\n");
@@ -6843,12 +6843,12 @@ s32 host_int_ListenStateExpired(tstrWILC_WFIDrv *hWFIDrv, u32 u32SessionID)
 	del_timer(&pstrWFIDrv->hRemainOnChannel);
 
 	/* prepare the timer fire Message */
-	memset(&strHostIFmsg, 0, sizeof(host_if_msg));
+	memset(&strHostIFmsg, 0, sizeof(struct host_if_msg));
 	strHostIFmsg.u16MsgId = HOST_IF_MSG_LISTEN_TIMER_FIRED;
 	strHostIFmsg.drvHandler = hWFIDrv;
 	strHostIFmsg.uniHostIFmsgBody.strHostIfRemainOnChan.u32ListenSessionID = u32SessionID;
 
-	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(host_if_msg));
+	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
 	if (s32Error)
 		PRINT_ER("wilc mq send fail\n");
 
@@ -6867,14 +6867,14 @@ s32 host_int_frame_register(tstrWILC_WFIDrv *hWFIDrv, u16 u16FrameType, bool bRe
 {
 	s32 s32Error = 0;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
-	host_if_msg strHostIFmsg;
+	struct host_if_msg strHostIFmsg;
 
 	if (pstrWFIDrv == NULL) {
 		PRINT_ER("driver is null\n");
 		return -EFAULT;
 	}
 
-	memset(&strHostIFmsg, 0, sizeof(host_if_msg));
+	memset(&strHostIFmsg, 0, sizeof(struct host_if_msg));
 
 	/* prepare the WiphyParams Message */
 	strHostIFmsg.u16MsgId = HOST_IF_MSG_REGISTER_FRAME;
@@ -6897,7 +6897,7 @@ s32 host_int_frame_register(tstrWILC_WFIDrv *hWFIDrv, u16 u16FrameType, bool bRe
 	strHostIFmsg.uniHostIFmsgBody.strHostIfRegisterFrame.bReg = bReg;
 	strHostIFmsg.drvHandler = hWFIDrv;
 
-	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(host_if_msg));
+	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
 	if (s32Error)
 		PRINT_ER("wilc mq send fail\n");
 
@@ -6924,7 +6924,7 @@ s32 host_int_add_beacon(tstrWILC_WFIDrv *hWFIDrv, u32 u32Interval,
 {
 	s32 s32Error = 0;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
-	host_if_msg strHostIFmsg;
+	struct host_if_msg strHostIFmsg;
 	tstrHostIFSetBeacon *pstrSetBeaconParam = &strHostIFmsg.uniHostIFmsgBody.strHostIFSetBeacon;
 
 	if (pstrWFIDrv == NULL) {
@@ -6932,7 +6932,7 @@ s32 host_int_add_beacon(tstrWILC_WFIDrv *hWFIDrv, u32 u32Interval,
 		return -EFAULT;
 	}
 
-	memset(&strHostIFmsg, 0, sizeof(host_if_msg));
+	memset(&strHostIFmsg, 0, sizeof(struct host_if_msg));
 
 	PRINT_D(HOSTINF_DBG, "Setting adding beacon message queue params\n");
 
@@ -6963,7 +6963,7 @@ s32 host_int_add_beacon(tstrWILC_WFIDrv *hWFIDrv, u32 u32Interval,
 		pstrSetBeaconParam->pu8Tail = NULL;
 	}
 
-	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(host_if_msg));
+	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
 	if (s32Error)
 		PRINT_ER("wilc mq send fail\n");
 
@@ -6994,7 +6994,7 @@ s32 host_int_del_beacon(tstrWILC_WFIDrv *hWFIDrv)
 {
 	s32 s32Error = 0;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
-	host_if_msg strHostIFmsg;
+	struct host_if_msg strHostIFmsg;
 
 	if (pstrWFIDrv == NULL) {
 		PRINT_ER("driver is null\n");
@@ -7006,7 +7006,7 @@ s32 host_int_del_beacon(tstrWILC_WFIDrv *hWFIDrv)
 	strHostIFmsg.drvHandler = hWFIDrv;
 	PRINT_D(HOSTINF_DBG, "Setting deleting beacon message queue params\n");
 
-	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(host_if_msg));
+	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
 	if (s32Error)
 		PRINT_ER("wilc_mq_send fail\n");
 
@@ -7027,7 +7027,7 @@ s32 host_int_add_station(tstrWILC_WFIDrv *hWFIDrv, tstrWILC_AddStaParam *pstrSta
 {
 	s32 s32Error = 0;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
-	host_if_msg strHostIFmsg;
+	struct host_if_msg strHostIFmsg;
 	tstrWILC_AddStaParam *pstrAddStationMsg = &strHostIFmsg.uniHostIFmsgBody.strAddStaParam;
 
 
@@ -7036,7 +7036,7 @@ s32 host_int_add_station(tstrWILC_WFIDrv *hWFIDrv, tstrWILC_AddStaParam *pstrSta
 		return -EFAULT;
 	}
 
-	memset(&strHostIFmsg, 0, sizeof(host_if_msg));
+	memset(&strHostIFmsg, 0, sizeof(struct host_if_msg));
 
 	PRINT_D(HOSTINF_DBG, "Setting adding station message queue params\n");
 
@@ -7057,7 +7057,7 @@ s32 host_int_add_station(tstrWILC_WFIDrv *hWFIDrv, tstrWILC_AddStaParam *pstrSta
 	}
 
 
-	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(host_if_msg));
+	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
 	if (s32Error)
 		PRINT_ER("wilc_mq_send fail\n");
 	return s32Error;
@@ -7076,7 +7076,7 @@ s32 host_int_del_station(tstrWILC_WFIDrv *hWFIDrv, const u8 *pu8MacAddr)
 {
 	s32 s32Error = 0;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
-	host_if_msg strHostIFmsg;
+	struct host_if_msg strHostIFmsg;
 	tstrHostIFDelSta *pstrDelStationMsg = &strHostIFmsg.uniHostIFmsgBody.strDelStaParam;
 
 	if (pstrWFIDrv == NULL) {
@@ -7084,7 +7084,7 @@ s32 host_int_del_station(tstrWILC_WFIDrv *hWFIDrv, const u8 *pu8MacAddr)
 		return -EFAULT;
 	}
 
-	memset(&strHostIFmsg, 0, sizeof(host_if_msg));
+	memset(&strHostIFmsg, 0, sizeof(struct host_if_msg));
 
 	PRINT_D(HOSTINF_DBG, "Setting deleting station message queue params\n");
 
@@ -7099,7 +7099,7 @@ s32 host_int_del_station(tstrWILC_WFIDrv *hWFIDrv, const u8 *pu8MacAddr)
 	else
 		memcpy(pstrDelStationMsg->au8MacAddr, pu8MacAddr, ETH_ALEN);
 
-	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(host_if_msg));
+	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
 	if (s32Error)
 		PRINT_ER("wilc_mq_send fail\n");
 	return s32Error;
@@ -7117,7 +7117,7 @@ s32 host_int_del_allstation(tstrWILC_WFIDrv *hWFIDrv, u8 pu8MacAddr[][ETH_ALEN])
 {
 	s32 s32Error = 0;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
-	host_if_msg strHostIFmsg;
+	struct host_if_msg strHostIFmsg;
 	tstrHostIFDelAllSta *pstrDelAllStationMsg = &strHostIFmsg.uniHostIFmsgBody.strHostIFDelAllSta;
 	u8 au8Zero_Buff[ETH_ALEN] = {0};
 	u32 i;
@@ -7129,7 +7129,7 @@ s32 host_int_del_allstation(tstrWILC_WFIDrv *hWFIDrv, u8 pu8MacAddr[][ETH_ALEN])
 		return -EFAULT;
 	}
 
-	memset(&strHostIFmsg, 0, sizeof(host_if_msg));
+	memset(&strHostIFmsg, 0, sizeof(struct host_if_msg));
 
 	PRINT_D(HOSTINF_DBG, "Setting deauthenticating station message queue params\n");
 
@@ -7152,7 +7152,7 @@ s32 host_int_del_allstation(tstrWILC_WFIDrv *hWFIDrv, u8 pu8MacAddr[][ETH_ALEN])
 	}
 
 	pstrDelAllStationMsg->u8Num_AssocSta = u8AssocNumb;
-	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(host_if_msg));
+	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
 
 
 	if (s32Error)
@@ -7177,7 +7177,7 @@ s32 host_int_edit_station(tstrWILC_WFIDrv *hWFIDrv, tstrWILC_AddStaParam *pstrSt
 {
 	s32 s32Error = 0;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
-	host_if_msg strHostIFmsg;
+	struct host_if_msg strHostIFmsg;
 	tstrWILC_AddStaParam *pstrAddStationMsg = &strHostIFmsg.uniHostIFmsgBody.strAddStaParam;
 
 	if (pstrWFIDrv == NULL) {
@@ -7187,7 +7187,7 @@ s32 host_int_edit_station(tstrWILC_WFIDrv *hWFIDrv, tstrWILC_AddStaParam *pstrSt
 
 	PRINT_D(HOSTINF_DBG, "Setting editing station message queue params\n");
 
-	memset(&strHostIFmsg, 0, sizeof(host_if_msg));
+	memset(&strHostIFmsg, 0, sizeof(struct host_if_msg));
 
 
 	/* prepare the WiphyParams Message */
@@ -7205,7 +7205,7 @@ s32 host_int_edit_station(tstrWILC_WFIDrv *hWFIDrv, tstrWILC_AddStaParam *pstrSt
 		pstrAddStationMsg->pu8Rates = rates;
 	}
 
-	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(host_if_msg));
+	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
 	if (s32Error)
 		PRINT_ER("wilc_mq_send fail\n");
 
@@ -7216,7 +7216,7 @@ s32 host_int_set_power_mgmt(tstrWILC_WFIDrv *hWFIDrv, bool bIsEnabled, u32 u32Ti
 {
 	s32 s32Error = 0;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
-	host_if_msg strHostIFmsg;
+	struct host_if_msg strHostIFmsg;
 	tstrHostIfPowerMgmtParam *pstrPowerMgmtParam = &strHostIFmsg.uniHostIFmsgBody.strPowerMgmtparam;
 
 	PRINT_INFO(HOSTINF_DBG, "\n\n>> Setting PS to %d <<\n\n", bIsEnabled);
@@ -7228,7 +7228,7 @@ s32 host_int_set_power_mgmt(tstrWILC_WFIDrv *hWFIDrv, bool bIsEnabled, u32 u32Ti
 
 	PRINT_D(HOSTINF_DBG, "Setting Power management message queue params\n");
 
-	memset(&strHostIFmsg, 0, sizeof(host_if_msg));
+	memset(&strHostIFmsg, 0, sizeof(struct host_if_msg));
 
 
 	/* prepare the WiphyParams Message */
@@ -7239,7 +7239,7 @@ s32 host_int_set_power_mgmt(tstrWILC_WFIDrv *hWFIDrv, bool bIsEnabled, u32 u32Ti
 	pstrPowerMgmtParam->u32Timeout = u32Timeout;
 
 
-	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(host_if_msg));
+	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
 	if (s32Error)
 		PRINT_ER("wilc_mq_send fail\n");
 	return s32Error;
@@ -7250,7 +7250,7 @@ s32 host_int_setup_multicast_filter(tstrWILC_WFIDrv *hWFIDrv, bool bIsEnabled, u
 	s32 s32Error = 0;
 
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
-	host_if_msg strHostIFmsg;
+	struct host_if_msg strHostIFmsg;
 	tstrHostIFSetMulti *pstrMulticastFilterParam = &strHostIFmsg.uniHostIFmsgBody.strHostIfSetMulti;
 
 
@@ -7261,7 +7261,7 @@ s32 host_int_setup_multicast_filter(tstrWILC_WFIDrv *hWFIDrv, bool bIsEnabled, u
 
 	PRINT_D(HOSTINF_DBG, "Setting Multicast Filter params\n");
 
-	memset(&strHostIFmsg, 0, sizeof(host_if_msg));
+	memset(&strHostIFmsg, 0, sizeof(struct host_if_msg));
 
 
 	/* prepare the WiphyParams Message */
@@ -7271,7 +7271,7 @@ s32 host_int_setup_multicast_filter(tstrWILC_WFIDrv *hWFIDrv, bool bIsEnabled, u
 	pstrMulticastFilterParam->bIsEnabled = bIsEnabled;
 	pstrMulticastFilterParam->u32count = u32count;
 
-	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(host_if_msg));
+	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
 	if (s32Error)
 		PRINT_ER("wilc_mq_send fail\n");
 	return s32Error;
@@ -7517,7 +7517,7 @@ static int host_int_addBASession(tstrWILC_WFIDrv *hWFIDrv, char *pBSSID, char TI
 {
 	s32 s32Error = 0;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
-	host_if_msg strHostIFmsg;
+	struct host_if_msg strHostIFmsg;
 	tstrHostIfBASessionInfo *pBASessionInfo = &strHostIFmsg.uniHostIFmsgBody.strHostIfBASessionInfo;
 
 	if (pstrWFIDrv == NULL) {
@@ -7525,7 +7525,7 @@ static int host_int_addBASession(tstrWILC_WFIDrv *hWFIDrv, char *pBSSID, char TI
 		return -EFAULT;
 	}
 
-	memset(&strHostIFmsg, 0, sizeof(host_if_msg));
+	memset(&strHostIFmsg, 0, sizeof(struct host_if_msg));
 
 	/* prepare the WiphyParams Message */
 	strHostIFmsg.u16MsgId = HOST_IF_MSG_ADD_BA_SESSION;
@@ -7536,7 +7536,7 @@ static int host_int_addBASession(tstrWILC_WFIDrv *hWFIDrv, char *pBSSID, char TI
 	pBASessionInfo->u16SessionTimeout = SessionTimeout;
 	strHostIFmsg.drvHandler = hWFIDrv;
 
-	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(host_if_msg));
+	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
 	if (s32Error)
 		PRINT_ER("wilc_mq_send fail\n");
 
@@ -7548,7 +7548,7 @@ s32 host_int_delBASession(tstrWILC_WFIDrv *hWFIDrv, char *pBSSID, char TID)
 {
 	s32 s32Error = 0;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
-	host_if_msg strHostIFmsg;
+	struct host_if_msg strHostIFmsg;
 	tstrHostIfBASessionInfo *pBASessionInfo = &strHostIFmsg.uniHostIFmsgBody.strHostIfBASessionInfo;
 
 	if (pstrWFIDrv == NULL) {
@@ -7556,7 +7556,7 @@ s32 host_int_delBASession(tstrWILC_WFIDrv *hWFIDrv, char *pBSSID, char TID)
 		return -EFAULT;
 	}
 
-	memset(&strHostIFmsg, 0, sizeof(host_if_msg));
+	memset(&strHostIFmsg, 0, sizeof(struct host_if_msg));
 
 	/* prepare the WiphyParams Message */
 	strHostIFmsg.u16MsgId = HOST_IF_MSG_DEL_BA_SESSION;
@@ -7565,7 +7565,7 @@ s32 host_int_delBASession(tstrWILC_WFIDrv *hWFIDrv, char *pBSSID, char TID)
 	pBASessionInfo->u8Ted = TID;
 	strHostIFmsg.drvHandler = hWFIDrv;
 
-	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(host_if_msg));
+	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
 	if (s32Error)
 		PRINT_ER("wilc_mq_send fail\n");
 
@@ -7578,7 +7578,7 @@ s32 host_int_del_All_Rx_BASession(tstrWILC_WFIDrv *hWFIDrv, char *pBSSID, char T
 {
 	s32 s32Error = 0;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
-	host_if_msg strHostIFmsg;
+	struct host_if_msg strHostIFmsg;
 	tstrHostIfBASessionInfo *pBASessionInfo = &strHostIFmsg.uniHostIFmsgBody.strHostIfBASessionInfo;
 
 	if (pstrWFIDrv == NULL) {
@@ -7586,7 +7586,7 @@ s32 host_int_del_All_Rx_BASession(tstrWILC_WFIDrv *hWFIDrv, char *pBSSID, char T
 		return -EFAULT;
 	}
 
-	memset(&strHostIFmsg, 0, sizeof(host_if_msg));
+	memset(&strHostIFmsg, 0, sizeof(struct host_if_msg));
 
 	/* prepare the WiphyParams Message */
 	strHostIFmsg.u16MsgId = HOST_IF_MSG_DEL_ALL_RX_BA_SESSIONS;
@@ -7595,7 +7595,7 @@ s32 host_int_del_All_Rx_BASession(tstrWILC_WFIDrv *hWFIDrv, char *pBSSID, char T
 	pBASessionInfo->u8Ted = TID;
 	strHostIFmsg.drvHandler = hWFIDrv;
 
-	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(host_if_msg));
+	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
 	if (s32Error)
 		PRINT_ER("wilc_mq_send fail\n");
 
@@ -7616,7 +7616,7 @@ s32 host_int_setup_ipaddress(tstrWILC_WFIDrv *hWFIDrv, u8 *u16ipadd, u8 idx)
 {
 	s32 s32Error = 0;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
-	host_if_msg strHostIFmsg;
+	struct host_if_msg strHostIFmsg;
 
 	/* TODO: Enable This feature on softap firmware */
 	return 0;
@@ -7626,7 +7626,7 @@ s32 host_int_setup_ipaddress(tstrWILC_WFIDrv *hWFIDrv, u8 *u16ipadd, u8 idx)
 		return -EFAULT;
 	}
 
-	memset(&strHostIFmsg, 0, sizeof(host_if_msg));
+	memset(&strHostIFmsg, 0, sizeof(struct host_if_msg));
 
 	/* prepare the WiphyParams Message */
 	strHostIFmsg.u16MsgId = HOST_IF_MSG_SET_IPADDRESS;
@@ -7635,7 +7635,7 @@ s32 host_int_setup_ipaddress(tstrWILC_WFIDrv *hWFIDrv, u8 *u16ipadd, u8 idx)
 	strHostIFmsg.drvHandler = hWFIDrv;
 	strHostIFmsg.uniHostIFmsgBody.strHostIfSetIP.idx = idx;
 
-	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(host_if_msg));
+	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
 	if (s32Error)
 		PRINT_ER("wilc_mq_send fail\n");
 
@@ -7656,14 +7656,14 @@ s32 host_int_get_ipaddress(tstrWILC_WFIDrv *hWFIDrv, u8 *u16ipadd, u8 idx)
 {
 	s32 s32Error = 0;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
-	host_if_msg strHostIFmsg;
+	struct host_if_msg strHostIFmsg;
 
 	if (pstrWFIDrv == NULL) {
 		PRINT_ER("driver is null\n");
 		return -EFAULT;
 	}
 
-	memset(&strHostIFmsg, 0, sizeof(host_if_msg));
+	memset(&strHostIFmsg, 0, sizeof(struct host_if_msg));
 
 	/* prepare the WiphyParams Message */
 	strHostIFmsg.u16MsgId = HOST_IF_MSG_GET_IPADDRESS;
@@ -7672,7 +7672,7 @@ s32 host_int_get_ipaddress(tstrWILC_WFIDrv *hWFIDrv, u8 *u16ipadd, u8 idx)
 	strHostIFmsg.drvHandler = hWFIDrv;
 	strHostIFmsg.uniHostIFmsgBody.strHostIfSetIP.idx = idx;
 
-	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(host_if_msg));
+	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
 	if (s32Error)
 		PRINT_ER("wilc_mq_send fail\n");
 
-- 
1.9.1

