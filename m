Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:44891 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751702AbbIRJL6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Sep 2015 05:11:58 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 02/34] staging: wilc1000: remove typedef from the struct
Date: Fri, 18 Sep 2015 18:11:04 +0900
Message-ID: <1442567496-29331-2-git-send-email-tony.cho@atmel.com> (sfid-20150918_111209_960724_FE0CAABB)
In-Reply-To: <1442567496-29331-1-git-send-email-tony.cho@atmel.com>
References: <1442567496-29331-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The Linux kernel coding style does not recommend to use typedef for the
structure. This patch removes typedef from the host_if_msg structure.

Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 294 +++++++++++++++---------------
 1 file changed, 147 insertions(+), 147 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index d272091..7ffec1b 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -450,7 +450,7 @@ typedef union _tuniHostIFmsgBody {
 } tuniHostIFmsgBody;
 
 /*!
- *  @struct             host_if_msg
+ *  @struct             struct host_if_msg
  *  @brief		Host Interface message
  *  @details
  *  @todo
@@ -459,11 +459,11 @@ typedef union _tuniHostIFmsgBody {
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
@@ -3984,19 +3984,19 @@ _done_:
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
@@ -4315,13 +4315,13 @@ static s32 Handle_DelAllRxBASessions(tstrWILC_WFIDrv *drvHandler, tstrHostIfBASe
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
@@ -4333,13 +4333,13 @@ static int hostIFthread(void *pvArg)
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
@@ -4533,29 +4533,29 @@ static int hostIFthread(void *pvArg)
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
 
 
@@ -4605,7 +4605,7 @@ s32 host_int_remove_wep_key(tstrWILC_WFIDrv *hWFIDrv, u8 u8keyIdx)
 {
 	s32 s32Error = 0;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
-	host_if_msg strHostIFmsg;
+	struct host_if_msg strHostIFmsg;
 
 
 	if (pstrWFIDrv == NULL) {
@@ -4615,7 +4615,7 @@ s32 host_int_remove_wep_key(tstrWILC_WFIDrv *hWFIDrv, u8 u8keyIdx)
 	}
 
 	/* prepare the Remove Wep Key Message */
-	memset(&strHostIFmsg, 0, sizeof(host_if_msg));
+	memset(&strHostIFmsg, 0, sizeof(struct host_if_msg));
 
 
 	strHostIFmsg.u16MsgId = HOST_IF_MSG_KEY;
@@ -4629,7 +4629,7 @@ s32 host_int_remove_wep_key(tstrWILC_WFIDrv *hWFIDrv, u8 u8keyIdx)
 	uniHostIFkeyAttr.strHostIFwepAttr.u8Wepidx = u8keyIdx;
 
 	/* send the message */
-	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(host_if_msg));
+	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
 	if (s32Error)
 		PRINT_ER("Error in sending message queue : Request to remove WEP key\n");
 	down(&(pstrWFIDrv->hSemTestKeyBlock));
@@ -4653,7 +4653,7 @@ s32 host_int_set_WEPDefaultKeyID(tstrWILC_WFIDrv *hWFIDrv, u8 u8Index)
 {
 	s32 s32Error = 0;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
-	host_if_msg strHostIFmsg;
+	struct host_if_msg strHostIFmsg;
 
 
 	if (pstrWFIDrv == NULL) {
@@ -4663,7 +4663,7 @@ s32 host_int_set_WEPDefaultKeyID(tstrWILC_WFIDrv *hWFIDrv, u8 u8Index)
 	}
 
 	/* prepare the Key Message */
-	memset(&strHostIFmsg, 0, sizeof(host_if_msg));
+	memset(&strHostIFmsg, 0, sizeof(struct host_if_msg));
 
 
 	strHostIFmsg.u16MsgId = HOST_IF_MSG_KEY;
@@ -4676,7 +4676,7 @@ s32 host_int_set_WEPDefaultKeyID(tstrWILC_WFIDrv *hWFIDrv, u8 u8Index)
 	uniHostIFkeyAttr.strHostIFwepAttr.u8Wepidx = u8Index;
 
 	/* send the message */
-	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(host_if_msg));
+	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
 	if (s32Error)
 		PRINT_ER("Error in sending message queue : Default key index\n");
 	down(&(pstrWFIDrv->hSemTestKeyBlock));
@@ -4708,7 +4708,7 @@ s32 host_int_add_wep_key_bss_sta(tstrWILC_WFIDrv *hWFIDrv, const u8 *pu8WepKey,
 
 	s32 s32Error = 0;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
-	host_if_msg strHostIFmsg;
+	struct host_if_msg strHostIFmsg;
 
 	if (pstrWFIDrv == NULL) {
 		s32Error = -EFAULT;
@@ -4717,7 +4717,7 @@ s32 host_int_add_wep_key_bss_sta(tstrWILC_WFIDrv *hWFIDrv, const u8 *pu8WepKey,
 	}
 
 	/* prepare the Key Message */
-	memset(&strHostIFmsg, 0, sizeof(host_if_msg));
+	memset(&strHostIFmsg, 0, sizeof(struct host_if_msg));
 
 
 	strHostIFmsg.u16MsgId = HOST_IF_MSG_KEY;
@@ -4740,7 +4740,7 @@ s32 host_int_add_wep_key_bss_sta(tstrWILC_WFIDrv *hWFIDrv, const u8 *pu8WepKey,
 	uniHostIFkeyAttr.strHostIFwepAttr.u8Wepidx = u8Keyidx;
 
 	/* send the message */
-	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(host_if_msg));
+	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
 	if (s32Error)
 		PRINT_ER("Error in sending message queue :WEP Key\n");
 	down(&(pstrWFIDrv->hSemTestKeyBlock));
@@ -4770,7 +4770,7 @@ s32 host_int_add_wep_key_bss_ap(tstrWILC_WFIDrv *hWFIDrv, const u8 *pu8WepKey, u
 
 	s32 s32Error = 0;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
-	host_if_msg strHostIFmsg;
+	struct host_if_msg strHostIFmsg;
 	u8 i;
 
 	if (pstrWFIDrv == NULL) {
@@ -4780,7 +4780,7 @@ s32 host_int_add_wep_key_bss_ap(tstrWILC_WFIDrv *hWFIDrv, const u8 *pu8WepKey, u
 	}
 
 	/* prepare the Key Message */
-	memset(&strHostIFmsg, 0, sizeof(host_if_msg));
+	memset(&strHostIFmsg, 0, sizeof(struct host_if_msg));
 
 	if (INFO) {
 		for (i = 0; i < u8WepKeylen; i++)
@@ -4812,7 +4812,7 @@ s32 host_int_add_wep_key_bss_ap(tstrWILC_WFIDrv *hWFIDrv, const u8 *pu8WepKey, u
 	strHostIFmsg.uniHostIFmsgBody.strHostIFkeyAttr.
 	uniHostIFkeyAttr.strHostIFwepAttr.tenuAuth_type = tenuAuth_type;
 	/* send the message */
-	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(host_if_msg));
+	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
 
 	if (s32Error)
 		PRINT_ER("Error in sending message queue :WEP Key\n");
@@ -4843,7 +4843,7 @@ s32 host_int_add_ptk(tstrWILC_WFIDrv *hWFIDrv, const u8 *pu8Ptk, u8 u8PtkKeylen,
 {
 	s32 s32Error = 0;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
-	host_if_msg strHostIFmsg;
+	struct host_if_msg strHostIFmsg;
 	u8 u8KeyLen = u8PtkKeylen;
 	u32 i;
 
@@ -4858,7 +4858,7 @@ s32 host_int_add_ptk(tstrWILC_WFIDrv *hWFIDrv, const u8 *pu8Ptk, u8 u8PtkKeylen,
 		u8KeyLen += TX_MIC_KEY_LEN;
 
 	/* prepare the Key Message */
-	memset(&strHostIFmsg, 0, sizeof(host_if_msg));
+	memset(&strHostIFmsg, 0, sizeof(struct host_if_msg));
 
 
 	strHostIFmsg.u16MsgId = HOST_IF_MSG_KEY;
@@ -4908,7 +4908,7 @@ s32 host_int_add_ptk(tstrWILC_WFIDrv *hWFIDrv, const u8 *pu8Ptk, u8 u8PtkKeylen,
 	strHostIFmsg.drvHandler = hWFIDrv;
 
 	/* send the message */
-	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(host_if_msg));
+	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
 
 	if (s32Error)
 		PRINT_ER("Error in sending message queue:  PTK Key\n");
@@ -4939,7 +4939,7 @@ s32 host_int_add_rx_gtk(tstrWILC_WFIDrv *hWFIDrv, const u8 *pu8RxGtk, u8 u8GtkKe
 {
 	s32 s32Error = 0;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
-	host_if_msg strHostIFmsg;
+	struct host_if_msg strHostIFmsg;
 	u8 u8KeyLen = u8GtkKeylen;
 
 	if (pstrWFIDrv == NULL) {
@@ -4948,7 +4948,7 @@ s32 host_int_add_rx_gtk(tstrWILC_WFIDrv *hWFIDrv, const u8 *pu8RxGtk, u8 u8GtkKe
 		return s32Error;
 	}
 	/* prepare the Key Message */
-	memset(&strHostIFmsg, 0, sizeof(host_if_msg));
+	memset(&strHostIFmsg, 0, sizeof(struct host_if_msg));
 
 
 	if (pu8RxMic != NULL)
@@ -5006,7 +5006,7 @@ s32 host_int_add_rx_gtk(tstrWILC_WFIDrv *hWFIDrv, const u8 *pu8RxGtk, u8 u8GtkKe
 
 
 	/* send the message */
-	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(host_if_msg));
+	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
 	if (s32Error)
 		PRINT_ER("Error in sending message queue:  RX GTK\n");
 	/* ////////////// */
@@ -5040,7 +5040,7 @@ s32 host_int_set_pmkid_info(tstrWILC_WFIDrv *hWFIDrv, tstrHostIFpmkidAttr *pu8Pm
 {
 	s32 s32Error = 0;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
-	host_if_msg strHostIFmsg;
+	struct host_if_msg strHostIFmsg;
 	u32 i;
 
 
@@ -5051,7 +5051,7 @@ s32 host_int_set_pmkid_info(tstrWILC_WFIDrv *hWFIDrv, tstrHostIFpmkidAttr *pu8Pm
 	}
 
 	/* prepare the Key Message */
-	memset(&strHostIFmsg, 0, sizeof(host_if_msg));
+	memset(&strHostIFmsg, 0, sizeof(struct host_if_msg));
 
 	strHostIFmsg.u16MsgId = HOST_IF_MSG_KEY;
 	strHostIFmsg.uniHostIFmsgBody.strHostIFkeyAttr.enuKeyType = PMKSA;
@@ -5068,7 +5068,7 @@ s32 host_int_set_pmkid_info(tstrWILC_WFIDrv *hWFIDrv, tstrHostIFpmkidAttr *pu8Pm
 	}
 
 	/* send the message */
-	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(host_if_msg));
+	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
 	if (s32Error)
 		PRINT_ER(" Error in sending messagequeue: PMKID Info\n");
 
@@ -5155,17 +5155,17 @@ s32 host_int_set_RSNAConfigPSKPassPhrase(tstrWILC_WFIDrv *hWFIDrv, u8 *pu8PassPh
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
@@ -5189,17 +5189,17 @@ s32 host_int_get_MacAddress(tstrWILC_WFIDrv *hWFIDrv, u8 *pu8MacAddress)
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
 
@@ -5379,7 +5379,7 @@ s32 host_int_set_join_req(tstrWILC_WFIDrv *hWFIDrv, u8 *pu8bssid,
 {
 	s32 s32Error = 0;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
-	host_if_msg strHostIFmsg;
+	struct host_if_msg strHostIFmsg;
 	tenuScanConnTimer enuScanConnTimer;
 
 	if (pstrWFIDrv == NULL || pfConnectResult == NULL) {
@@ -5399,7 +5399,7 @@ s32 host_int_set_join_req(tstrWILC_WFIDrv *hWFIDrv, u8 *pu8bssid,
 	}
 
 	/* prepare the Connect Message */
-	memset(&strHostIFmsg, 0, sizeof(host_if_msg));
+	memset(&strHostIFmsg, 0, sizeof(struct host_if_msg));
 
 	strHostIFmsg.u16MsgId = HOST_IF_MSG_CONNECT;
 
@@ -5437,7 +5437,7 @@ s32 host_int_set_join_req(tstrWILC_WFIDrv *hWFIDrv, u8 *pu8bssid,
 		PRINT_D(GENERIC_DBG, "Don't set state to 'connecting' as state is %d\n", pstrWFIDrv->enuHostIFstate);
 
 	/* send the message */
-	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(host_if_msg));
+	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
 	if (s32Error) {
 		PRINT_ER("Failed to send message queue: Set join request\n");
 		return -EFAULT;
@@ -5466,7 +5466,7 @@ s32 host_int_set_join_req(tstrWILC_WFIDrv *hWFIDrv, u8 *pu8bssid,
 s32 host_int_flush_join_req(tstrWILC_WFIDrv *hWFIDrv)
 {
 	s32 s32Error = 0;
-	host_if_msg strHostIFmsg;
+	struct host_if_msg strHostIFmsg;
 
 	if (!gu8FlushedJoinReq)	{
 		s32Error = -EFAULT;
@@ -5484,7 +5484,7 @@ s32 host_int_flush_join_req(tstrWILC_WFIDrv *hWFIDrv)
 	strHostIFmsg.drvHandler = hWFIDrv;
 
 	/* send the message */
-	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(host_if_msg));
+	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
 	if (s32Error) {
 		PRINT_ER("Failed to send message queue: Flush join request\n");
 		return -EFAULT;
@@ -5507,7 +5507,7 @@ s32 host_int_flush_join_req(tstrWILC_WFIDrv *hWFIDrv)
 s32 host_int_disconnect(tstrWILC_WFIDrv *hWFIDrv, u16 u16ReasonCode)
 {
 	s32 s32Error = 0;
-	host_if_msg strHostIFmsg;
+	struct host_if_msg strHostIFmsg;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
 
 	if (pstrWFIDrv == NULL) {
@@ -5516,13 +5516,13 @@ s32 host_int_disconnect(tstrWILC_WFIDrv *hWFIDrv, u16 u16ReasonCode)
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
@@ -5692,7 +5692,7 @@ s32 host_int_set_mac_chnl_num(tstrWILC_WFIDrv *hWFIDrv, u8 u8ChNum)
 {
 	s32 s32Error = 0;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
-	host_if_msg strHostIFmsg;
+	struct host_if_msg strHostIFmsg;
 
 	if (pstrWFIDrv == NULL) {
 		PRINT_ER("driver is null\n");
@@ -5700,12 +5700,12 @@ s32 host_int_set_mac_chnl_num(tstrWILC_WFIDrv *hWFIDrv, u8 u8ChNum)
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
@@ -5719,13 +5719,13 @@ s32 host_int_wait_msg_queue_idle(void)
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
@@ -5742,17 +5742,17 @@ s32 host_int_set_wfi_drv_handler(tstrWILC_WFIDrv *u32address)
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
@@ -5767,17 +5767,17 @@ s32 host_int_set_operation_mode(tstrWILC_WFIDrv *hWFIDrv, u32 u32mode)
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
@@ -5805,7 +5805,7 @@ s32 host_int_get_host_chnl_num(tstrWILC_WFIDrv *hWFIDrv, u8 *pu8ChNo)
 {
 	s32 s32Error = 0;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
-	host_if_msg strHostIFmsg;
+	struct host_if_msg strHostIFmsg;
 
 	if (pstrWFIDrv == NULL) {
 		PRINT_ER("driver is null\n");
@@ -5813,13 +5813,13 @@ s32 host_int_get_host_chnl_num(tstrWILC_WFIDrv *hWFIDrv, u8 *pu8ChNo)
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
@@ -5890,14 +5890,14 @@ s32 host_int_get_inactive_time(tstrWILC_WFIDrv *hWFIDrv, const u8 *mac, u32 *pu3
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
@@ -5907,7 +5907,7 @@ s32 host_int_get_inactive_time(tstrWILC_WFIDrv *hWFIDrv, const u8 *mac, u32 *pu3
 	strHostIFmsg.drvHandler = hWFIDrv;
 
 	/* send the message */
-	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(host_if_msg));
+	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
 	if (s32Error)
 		PRINT_ER("Failed to send get host channel param's message queue ");
 
@@ -5977,18 +5977,18 @@ s32 host_int_test_get_int_wid(tstrWILC_WFIDrv *hWFIDrv, u32 *pu32TestMemAddr)
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
@@ -6011,7 +6011,7 @@ s32 host_int_get_rssi(tstrWILC_WFIDrv *hWFIDrv, s8 *ps8Rssi)
 
 s32 host_int_get_link_speed(tstrWILC_WFIDrv *hWFIDrv, s8 *ps8lnkspd)
 {
-	host_if_msg strHostIFmsg;
+	struct host_if_msg strHostIFmsg;
 	s32 s32Error = 0;
 
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
@@ -6019,13 +6019,13 @@ s32 host_int_get_link_speed(tstrWILC_WFIDrv *hWFIDrv, s8 *ps8lnkspd)
 
 
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
@@ -6049,17 +6049,17 @@ s32 host_int_get_link_speed(tstrWILC_WFIDrv *hWFIDrv, s8 *ps8lnkspd)
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
@@ -6094,7 +6094,7 @@ s32 host_int_scan(tstrWILC_WFIDrv *hWFIDrv, u8 u8ScanSource,
 {
 	s32 s32Error = 0;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
-	host_if_msg strHostIFmsg;
+	struct host_if_msg strHostIFmsg;
 	tenuScanConnTimer enuScanConnTimer;
 
 	if (pstrWFIDrv == NULL || ScanResult == NULL) {
@@ -6103,7 +6103,7 @@ s32 host_int_scan(tstrWILC_WFIDrv *hWFIDrv, u8 u8ScanSource,
 	}
 
 	/* prepare the Scan Message */
-	memset(&strHostIFmsg, 0, sizeof(host_if_msg));
+	memset(&strHostIFmsg, 0, sizeof(struct host_if_msg));
 
 	strHostIFmsg.u16MsgId = HOST_IF_MSG_SCAN;
 
@@ -6131,7 +6131,7 @@ s32 host_int_scan(tstrWILC_WFIDrv *hWFIDrv, u8 u8ScanSource,
 		    pu8IEs, IEsLen);
 
 	/* send the message */
-	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(host_if_msg));
+	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
 	if (s32Error) {
 		PRINT_ER("Error in sending message queue\n");
 		return -EINVAL;
@@ -6163,7 +6163,7 @@ s32 hif_set_cfg(tstrWILC_WFIDrv *hWFIDrv, tstrCfgParamVal *pstrCfgParamVal)
 	s32 s32Error = 0;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
 
-	host_if_msg strHostIFmsg;
+	struct host_if_msg strHostIFmsg;
 
 
 	if (pstrWFIDrv == NULL) {
@@ -6171,12 +6171,12 @@ s32 hif_set_cfg(tstrWILC_WFIDrv *hWFIDrv, tstrCfgParamVal *pstrCfgParamVal)
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
 
@@ -6339,16 +6339,16 @@ static void GetPeriodicRSSI(unsigned long arg)
 
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
@@ -6535,7 +6535,7 @@ _fail_:
 s32 host_int_deinit(tstrWILC_WFIDrv *hWFIDrv)
 {
 	s32 s32Error = 0;
-	host_if_msg strHostIFmsg;
+	struct host_if_msg strHostIFmsg;
 	int ret;
 
 	/*obtain driver handle*/
@@ -6598,7 +6598,7 @@ s32 host_int_deinit(tstrWILC_WFIDrv *hWFIDrv)
 
 	gbScanWhileConnected = false;
 
-	memset(&strHostIFmsg, 0, sizeof(host_if_msg));
+	memset(&strHostIFmsg, 0, sizeof(struct host_if_msg));
 
 	if (clients_count == 1)	{
 		if (del_timer_sync(&g_hPeriodicRSSI)) {
@@ -6609,7 +6609,7 @@ s32 host_int_deinit(tstrWILC_WFIDrv *hWFIDrv)
 		strHostIFmsg.drvHandler = hWFIDrv;
 
 
-		s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(host_if_msg));
+		s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
 		if (s32Error != 0)
 			PRINT_ER("Error in sending deinit's message queue message function: Error(%d)\n", s32Error);
 
@@ -6655,7 +6655,7 @@ s32 host_int_deinit(tstrWILC_WFIDrv *hWFIDrv)
 void NetworkInfoReceived(u8 *pu8Buffer, u32 u32Length)
 {
 	s32 s32Error = 0;
-	host_if_msg strHostIFmsg;
+	struct host_if_msg strHostIFmsg;
 	int id;
 	tstrWILC_WFIDrv *pstrWFIDrv = NULL;
 
@@ -6671,7 +6671,7 @@ void NetworkInfoReceived(u8 *pu8Buffer, u32 u32Length)
 	}
 
 	/* prepare the Asynchronous Network Info message */
-	memset(&strHostIFmsg, 0, sizeof(host_if_msg));
+	memset(&strHostIFmsg, 0, sizeof(struct host_if_msg));
 
 	strHostIFmsg.u16MsgId = HOST_IF_MSG_RCVD_NTWRK_INFO;
 	strHostIFmsg.drvHandler = pstrWFIDrv;
@@ -6682,7 +6682,7 @@ void NetworkInfoReceived(u8 *pu8Buffer, u32 u32Length)
 		    pu8Buffer, u32Length);
 
 	/* send the message */
-	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(host_if_msg));
+	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
 	if (s32Error)
 		PRINT_ER("Error in sending network info message queue message parameters: Error(%d)\n", s32Error);
 }
@@ -6701,7 +6701,7 @@ void NetworkInfoReceived(u8 *pu8Buffer, u32 u32Length)
 void GnrlAsyncInfoReceived(u8 *pu8Buffer, u32 u32Length)
 {
 	s32 s32Error = 0;
-	host_if_msg strHostIFmsg;
+	struct host_if_msg strHostIFmsg;
 	int id;
 	tstrWILC_WFIDrv *pstrWFIDrv = NULL;
 
@@ -6729,7 +6729,7 @@ void GnrlAsyncInfoReceived(u8 *pu8Buffer, u32 u32Length)
 	}
 
 	/* prepare the General Asynchronous Info message */
-	memset(&strHostIFmsg, 0, sizeof(host_if_msg));
+	memset(&strHostIFmsg, 0, sizeof(struct host_if_msg));
 
 
 	strHostIFmsg.u16MsgId = HOST_IF_MSG_RCVD_GNRL_ASYNC_INFO;
@@ -6742,7 +6742,7 @@ void GnrlAsyncInfoReceived(u8 *pu8Buffer, u32 u32Length)
 		    pu8Buffer, u32Length);
 
 	/* send the message */
-	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(host_if_msg));
+	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
 	if (s32Error)
 		PRINT_ER("Error in sending message queue asynchronous message info: Error(%d)\n", s32Error);
 
@@ -6762,7 +6762,7 @@ void GnrlAsyncInfoReceived(u8 *pu8Buffer, u32 u32Length)
 void host_int_ScanCompleteReceived(u8 *pu8Buffer, u32 u32Length)
 {
 	s32 s32Error = 0;
-	host_if_msg strHostIFmsg;
+	struct host_if_msg strHostIFmsg;
 	int id;
 	tstrWILC_WFIDrv *pstrWFIDrv = NULL;
 
@@ -6778,7 +6778,7 @@ void host_int_ScanCompleteReceived(u8 *pu8Buffer, u32 u32Length)
 	/*if there is an ongoing scan request*/
 	if (pstrWFIDrv->strWILC_UsrScanReq.pfUserScanResult) {
 		/* prepare theScan Done message */
-		memset(&strHostIFmsg, 0, sizeof(host_if_msg));
+		memset(&strHostIFmsg, 0, sizeof(struct host_if_msg));
 
 		strHostIFmsg.u16MsgId = HOST_IF_MSG_RCVD_SCAN_COMPLETE;
 		strHostIFmsg.drvHandler = pstrWFIDrv;
@@ -6793,7 +6793,7 @@ void host_int_ScanCompleteReceived(u8 *pu8Buffer, u32 u32Length)
 		 *                        pu8Buffer, u32Length); */
 
 		/* send the message */
-		s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(host_if_msg));
+		s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
 		if (s32Error)
 			PRINT_ER("Error in sending message queue scan complete parameters: Error(%d)\n", s32Error);
 	}
@@ -6821,7 +6821,7 @@ s32 host_int_remain_on_channel(tstrWILC_WFIDrv *hWFIDrv, u32 u32SessionID, u32 u
 {
 	s32 s32Error = 0;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
-	host_if_msg strHostIFmsg;
+	struct host_if_msg strHostIFmsg;
 
 	if (pstrWFIDrv == NULL) {
 		PRINT_ER("driver is null\n");
@@ -6829,7 +6829,7 @@ s32 host_int_remain_on_channel(tstrWILC_WFIDrv *hWFIDrv, u32 u32SessionID, u32 u
 	}
 
 	/* prepare the remainonchan Message */
-	memset(&strHostIFmsg, 0, sizeof(host_if_msg));
+	memset(&strHostIFmsg, 0, sizeof(struct host_if_msg));
 
 	/* prepare the WiphyParams Message */
 	strHostIFmsg.u16MsgId = HOST_IF_MSG_REMAIN_ON_CHAN;
@@ -6841,7 +6841,7 @@ s32 host_int_remain_on_channel(tstrWILC_WFIDrv *hWFIDrv, u32 u32SessionID, u32 u
 	strHostIFmsg.uniHostIFmsgBody.strHostIfRemainOnChan.u32ListenSessionID = u32SessionID;
 	strHostIFmsg.drvHandler = hWFIDrv;
 
-	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(host_if_msg));
+	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
 	if (s32Error)
 		PRINT_ER("wilc mq send fail\n");
 
@@ -6866,7 +6866,7 @@ s32 host_int_ListenStateExpired(tstrWILC_WFIDrv *hWFIDrv, u32 u32SessionID)
 {
 	s32 s32Error = 0;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
-	host_if_msg strHostIFmsg;
+	struct host_if_msg strHostIFmsg;
 
 	if (pstrWFIDrv == NULL) {
 		PRINT_ER("driver is null\n");
@@ -6877,12 +6877,12 @@ s32 host_int_ListenStateExpired(tstrWILC_WFIDrv *hWFIDrv, u32 u32SessionID)
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
 
@@ -6901,14 +6901,14 @@ s32 host_int_frame_register(tstrWILC_WFIDrv *hWFIDrv, u16 u16FrameType, bool bRe
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
@@ -6931,7 +6931,7 @@ s32 host_int_frame_register(tstrWILC_WFIDrv *hWFIDrv, u16 u16FrameType, bool bRe
 	strHostIFmsg.uniHostIFmsgBody.strHostIfRegisterFrame.bReg = bReg;
 	strHostIFmsg.drvHandler = hWFIDrv;
 
-	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(host_if_msg));
+	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
 	if (s32Error)
 		PRINT_ER("wilc mq send fail\n");
 
@@ -6958,7 +6958,7 @@ s32 host_int_add_beacon(tstrWILC_WFIDrv *hWFIDrv, u32 u32Interval,
 {
 	s32 s32Error = 0;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
-	host_if_msg strHostIFmsg;
+	struct host_if_msg strHostIFmsg;
 	tstrHostIFSetBeacon *pstrSetBeaconParam = &strHostIFmsg.uniHostIFmsgBody.strHostIFSetBeacon;
 
 	if (pstrWFIDrv == NULL) {
@@ -6966,7 +6966,7 @@ s32 host_int_add_beacon(tstrWILC_WFIDrv *hWFIDrv, u32 u32Interval,
 		return -EFAULT;
 	}
 
-	memset(&strHostIFmsg, 0, sizeof(host_if_msg));
+	memset(&strHostIFmsg, 0, sizeof(struct host_if_msg));
 
 	PRINT_D(HOSTINF_DBG, "Setting adding beacon message queue params\n");
 
@@ -6997,7 +6997,7 @@ s32 host_int_add_beacon(tstrWILC_WFIDrv *hWFIDrv, u32 u32Interval,
 		pstrSetBeaconParam->pu8Tail = NULL;
 	}
 
-	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(host_if_msg));
+	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
 	if (s32Error)
 		PRINT_ER("wilc mq send fail\n");
 
@@ -7028,7 +7028,7 @@ s32 host_int_del_beacon(tstrWILC_WFIDrv *hWFIDrv)
 {
 	s32 s32Error = 0;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
-	host_if_msg strHostIFmsg;
+	struct host_if_msg strHostIFmsg;
 
 	if (pstrWFIDrv == NULL) {
 		PRINT_ER("driver is null\n");
@@ -7040,7 +7040,7 @@ s32 host_int_del_beacon(tstrWILC_WFIDrv *hWFIDrv)
 	strHostIFmsg.drvHandler = hWFIDrv;
 	PRINT_D(HOSTINF_DBG, "Setting deleting beacon message queue params\n");
 
-	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(host_if_msg));
+	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
 	if (s32Error)
 		PRINT_ER("wilc_mq_send fail\n");
 
@@ -7061,7 +7061,7 @@ s32 host_int_add_station(tstrWILC_WFIDrv *hWFIDrv, tstrWILC_AddStaParam *pstrSta
 {
 	s32 s32Error = 0;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
-	host_if_msg strHostIFmsg;
+	struct host_if_msg strHostIFmsg;
 	tstrWILC_AddStaParam *pstrAddStationMsg = &strHostIFmsg.uniHostIFmsgBody.strAddStaParam;
 
 
@@ -7070,7 +7070,7 @@ s32 host_int_add_station(tstrWILC_WFIDrv *hWFIDrv, tstrWILC_AddStaParam *pstrSta
 		return -EFAULT;
 	}
 
-	memset(&strHostIFmsg, 0, sizeof(host_if_msg));
+	memset(&strHostIFmsg, 0, sizeof(struct host_if_msg));
 
 	PRINT_D(HOSTINF_DBG, "Setting adding station message queue params\n");
 
@@ -7091,7 +7091,7 @@ s32 host_int_add_station(tstrWILC_WFIDrv *hWFIDrv, tstrWILC_AddStaParam *pstrSta
 	}
 
 
-	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(host_if_msg));
+	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
 	if (s32Error)
 		PRINT_ER("wilc_mq_send fail\n");
 	return s32Error;
@@ -7110,7 +7110,7 @@ s32 host_int_del_station(tstrWILC_WFIDrv *hWFIDrv, const u8 *pu8MacAddr)
 {
 	s32 s32Error = 0;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
-	host_if_msg strHostIFmsg;
+	struct host_if_msg strHostIFmsg;
 	tstrHostIFDelSta *pstrDelStationMsg = &strHostIFmsg.uniHostIFmsgBody.strDelStaParam;
 
 	if (pstrWFIDrv == NULL) {
@@ -7118,7 +7118,7 @@ s32 host_int_del_station(tstrWILC_WFIDrv *hWFIDrv, const u8 *pu8MacAddr)
 		return -EFAULT;
 	}
 
-	memset(&strHostIFmsg, 0, sizeof(host_if_msg));
+	memset(&strHostIFmsg, 0, sizeof(struct host_if_msg));
 
 	PRINT_D(HOSTINF_DBG, "Setting deleting station message queue params\n");
 
@@ -7134,7 +7134,7 @@ s32 host_int_del_station(tstrWILC_WFIDrv *hWFIDrv, const u8 *pu8MacAddr)
 	else
 		memcpy(pstrDelStationMsg->au8MacAddr, pu8MacAddr, ETH_ALEN);
 
-	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(host_if_msg));
+	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
 	if (s32Error)
 		PRINT_ER("wilc_mq_send fail\n");
 	return s32Error;
@@ -7152,7 +7152,7 @@ s32 host_int_del_allstation(tstrWILC_WFIDrv *hWFIDrv, u8 pu8MacAddr[][ETH_ALEN])
 {
 	s32 s32Error = 0;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
-	host_if_msg strHostIFmsg;
+	struct host_if_msg strHostIFmsg;
 	tstrHostIFDelAllSta *pstrDelAllStationMsg = &strHostIFmsg.uniHostIFmsgBody.strHostIFDelAllSta;
 	u8 au8Zero_Buff[ETH_ALEN] = {0};
 	u32 i;
@@ -7164,7 +7164,7 @@ s32 host_int_del_allstation(tstrWILC_WFIDrv *hWFIDrv, u8 pu8MacAddr[][ETH_ALEN])
 		return -EFAULT;
 	}
 
-	memset(&strHostIFmsg, 0, sizeof(host_if_msg));
+	memset(&strHostIFmsg, 0, sizeof(struct host_if_msg));
 
 	PRINT_D(HOSTINF_DBG, "Setting deauthenticating station message queue params\n");
 
@@ -7187,7 +7187,7 @@ s32 host_int_del_allstation(tstrWILC_WFIDrv *hWFIDrv, u8 pu8MacAddr[][ETH_ALEN])
 	}
 
 	pstrDelAllStationMsg->u8Num_AssocSta = u8AssocNumb;
-	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(host_if_msg));
+	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
 
 
 	if (s32Error)
@@ -7212,7 +7212,7 @@ s32 host_int_edit_station(tstrWILC_WFIDrv *hWFIDrv, tstrWILC_AddStaParam *pstrSt
 {
 	s32 s32Error = 0;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
-	host_if_msg strHostIFmsg;
+	struct host_if_msg strHostIFmsg;
 	tstrWILC_AddStaParam *pstrAddStationMsg = &strHostIFmsg.uniHostIFmsgBody.strAddStaParam;
 
 	if (pstrWFIDrv == NULL) {
@@ -7222,7 +7222,7 @@ s32 host_int_edit_station(tstrWILC_WFIDrv *hWFIDrv, tstrWILC_AddStaParam *pstrSt
 
 	PRINT_D(HOSTINF_DBG, "Setting editing station message queue params\n");
 
-	memset(&strHostIFmsg, 0, sizeof(host_if_msg));
+	memset(&strHostIFmsg, 0, sizeof(struct host_if_msg));
 
 
 	/* prepare the WiphyParams Message */
@@ -7240,7 +7240,7 @@ s32 host_int_edit_station(tstrWILC_WFIDrv *hWFIDrv, tstrWILC_AddStaParam *pstrSt
 		pstrAddStationMsg->pu8Rates = rates;
 	}
 
-	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(host_if_msg));
+	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
 	if (s32Error)
 		PRINT_ER("wilc_mq_send fail\n");
 
@@ -7253,7 +7253,7 @@ s32 host_int_set_power_mgmt(tstrWILC_WFIDrv *hWFIDrv, bool bIsEnabled, u32 u32Ti
 {
 	s32 s32Error = 0;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
-	host_if_msg strHostIFmsg;
+	struct host_if_msg strHostIFmsg;
 	tstrHostIfPowerMgmtParam *pstrPowerMgmtParam = &strHostIFmsg.uniHostIFmsgBody.strPowerMgmtparam;
 
 	PRINT_INFO(HOSTINF_DBG, "\n\n>> Setting PS to %d <<\n\n", bIsEnabled);
@@ -7265,7 +7265,7 @@ s32 host_int_set_power_mgmt(tstrWILC_WFIDrv *hWFIDrv, bool bIsEnabled, u32 u32Ti
 
 	PRINT_D(HOSTINF_DBG, "Setting Power management message queue params\n");
 
-	memset(&strHostIFmsg, 0, sizeof(host_if_msg));
+	memset(&strHostIFmsg, 0, sizeof(struct host_if_msg));
 
 
 	/* prepare the WiphyParams Message */
@@ -7276,7 +7276,7 @@ s32 host_int_set_power_mgmt(tstrWILC_WFIDrv *hWFIDrv, bool bIsEnabled, u32 u32Ti
 	pstrPowerMgmtParam->u32Timeout = u32Timeout;
 
 
-	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(host_if_msg));
+	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
 	if (s32Error)
 		PRINT_ER("wilc_mq_send fail\n");
 	return s32Error;
@@ -7287,7 +7287,7 @@ s32 host_int_setup_multicast_filter(tstrWILC_WFIDrv *hWFIDrv, bool bIsEnabled, u
 	s32 s32Error = 0;
 
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
-	host_if_msg strHostIFmsg;
+	struct host_if_msg strHostIFmsg;
 	tstrHostIFSetMulti *pstrMulticastFilterParam = &strHostIFmsg.uniHostIFmsgBody.strHostIfSetMulti;
 
 
@@ -7298,7 +7298,7 @@ s32 host_int_setup_multicast_filter(tstrWILC_WFIDrv *hWFIDrv, bool bIsEnabled, u
 
 	PRINT_D(HOSTINF_DBG, "Setting Multicast Filter params\n");
 
-	memset(&strHostIFmsg, 0, sizeof(host_if_msg));
+	memset(&strHostIFmsg, 0, sizeof(struct host_if_msg));
 
 
 	/* prepare the WiphyParams Message */
@@ -7308,7 +7308,7 @@ s32 host_int_setup_multicast_filter(tstrWILC_WFIDrv *hWFIDrv, bool bIsEnabled, u
 	pstrMulticastFilterParam->bIsEnabled = bIsEnabled;
 	pstrMulticastFilterParam->u32count = u32count;
 
-	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(host_if_msg));
+	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
 	if (s32Error)
 		PRINT_ER("wilc_mq_send fail\n");
 	return s32Error;
@@ -7554,7 +7554,7 @@ static int host_int_addBASession(tstrWILC_WFIDrv *hWFIDrv, char *pBSSID, char TI
 {
 	s32 s32Error = 0;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
-	host_if_msg strHostIFmsg;
+	struct host_if_msg strHostIFmsg;
 	tstrHostIfBASessionInfo *pBASessionInfo = &strHostIFmsg.uniHostIFmsgBody.strHostIfBASessionInfo;
 
 	if (pstrWFIDrv == NULL) {
@@ -7562,7 +7562,7 @@ static int host_int_addBASession(tstrWILC_WFIDrv *hWFIDrv, char *pBSSID, char TI
 		return -EFAULT;
 	}
 
-	memset(&strHostIFmsg, 0, sizeof(host_if_msg));
+	memset(&strHostIFmsg, 0, sizeof(struct host_if_msg));
 
 	/* prepare the WiphyParams Message */
 	strHostIFmsg.u16MsgId = HOST_IF_MSG_ADD_BA_SESSION;
@@ -7573,7 +7573,7 @@ static int host_int_addBASession(tstrWILC_WFIDrv *hWFIDrv, char *pBSSID, char TI
 	pBASessionInfo->u16SessionTimeout = SessionTimeout;
 	strHostIFmsg.drvHandler = hWFIDrv;
 
-	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(host_if_msg));
+	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
 	if (s32Error)
 		PRINT_ER("wilc_mq_send fail\n");
 
@@ -7585,7 +7585,7 @@ s32 host_int_delBASession(tstrWILC_WFIDrv *hWFIDrv, char *pBSSID, char TID)
 {
 	s32 s32Error = 0;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
-	host_if_msg strHostIFmsg;
+	struct host_if_msg strHostIFmsg;
 	tstrHostIfBASessionInfo *pBASessionInfo = &strHostIFmsg.uniHostIFmsgBody.strHostIfBASessionInfo;
 
 	if (pstrWFIDrv == NULL) {
@@ -7593,7 +7593,7 @@ s32 host_int_delBASession(tstrWILC_WFIDrv *hWFIDrv, char *pBSSID, char TID)
 		return -EFAULT;
 	}
 
-	memset(&strHostIFmsg, 0, sizeof(host_if_msg));
+	memset(&strHostIFmsg, 0, sizeof(struct host_if_msg));
 
 	/* prepare the WiphyParams Message */
 	strHostIFmsg.u16MsgId = HOST_IF_MSG_DEL_BA_SESSION;
@@ -7602,7 +7602,7 @@ s32 host_int_delBASession(tstrWILC_WFIDrv *hWFIDrv, char *pBSSID, char TID)
 	pBASessionInfo->u8Ted = TID;
 	strHostIFmsg.drvHandler = hWFIDrv;
 
-	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(host_if_msg));
+	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
 	if (s32Error)
 		PRINT_ER("wilc_mq_send fail\n");
 
@@ -7616,7 +7616,7 @@ s32 host_int_del_All_Rx_BASession(tstrWILC_WFIDrv *hWFIDrv, char *pBSSID, char T
 {
 	s32 s32Error = 0;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
-	host_if_msg strHostIFmsg;
+	struct host_if_msg strHostIFmsg;
 	tstrHostIfBASessionInfo *pBASessionInfo = &strHostIFmsg.uniHostIFmsgBody.strHostIfBASessionInfo;
 
 	if (pstrWFIDrv == NULL) {
@@ -7624,7 +7624,7 @@ s32 host_int_del_All_Rx_BASession(tstrWILC_WFIDrv *hWFIDrv, char *pBSSID, char T
 		return -EFAULT;
 	}
 
-	memset(&strHostIFmsg, 0, sizeof(host_if_msg));
+	memset(&strHostIFmsg, 0, sizeof(struct host_if_msg));
 
 	/* prepare the WiphyParams Message */
 	strHostIFmsg.u16MsgId = HOST_IF_MSG_DEL_ALL_RX_BA_SESSIONS;
@@ -7633,7 +7633,7 @@ s32 host_int_del_All_Rx_BASession(tstrWILC_WFIDrv *hWFIDrv, char *pBSSID, char T
 	pBASessionInfo->u8Ted = TID;
 	strHostIFmsg.drvHandler = hWFIDrv;
 
-	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(host_if_msg));
+	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
 	if (s32Error)
 		PRINT_ER("wilc_mq_send fail\n");
 
@@ -7655,7 +7655,7 @@ s32 host_int_setup_ipaddress(tstrWILC_WFIDrv *hWFIDrv, u8 *u16ipadd, u8 idx)
 {
 	s32 s32Error = 0;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
-	host_if_msg strHostIFmsg;
+	struct host_if_msg strHostIFmsg;
 
 	/* TODO: Enable This feature on softap firmware */
 	return 0;
@@ -7665,7 +7665,7 @@ s32 host_int_setup_ipaddress(tstrWILC_WFIDrv *hWFIDrv, u8 *u16ipadd, u8 idx)
 		return -EFAULT;
 	}
 
-	memset(&strHostIFmsg, 0, sizeof(host_if_msg));
+	memset(&strHostIFmsg, 0, sizeof(struct host_if_msg));
 
 	/* prepare the WiphyParams Message */
 	strHostIFmsg.u16MsgId = HOST_IF_MSG_SET_IPADDRESS;
@@ -7674,7 +7674,7 @@ s32 host_int_setup_ipaddress(tstrWILC_WFIDrv *hWFIDrv, u8 *u16ipadd, u8 idx)
 	strHostIFmsg.drvHandler = hWFIDrv;
 	strHostIFmsg.uniHostIFmsgBody.strHostIfSetIP.idx = idx;
 
-	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(host_if_msg));
+	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
 	if (s32Error)
 		PRINT_ER("wilc_mq_send fail\n");
 
@@ -7695,14 +7695,14 @@ s32 host_int_get_ipaddress(tstrWILC_WFIDrv *hWFIDrv, u8 *u16ipadd, u8 idx)
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
@@ -7711,7 +7711,7 @@ s32 host_int_get_ipaddress(tstrWILC_WFIDrv *hWFIDrv, u8 *u16ipadd, u8 idx)
 	strHostIFmsg.drvHandler = hWFIDrv;
 	strHostIFmsg.uniHostIFmsgBody.strHostIfSetIP.idx = idx;
 
-	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(host_if_msg));
+	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
 	if (s32Error)
 		PRINT_ER("wilc_mq_send fail\n");
 
-- 
1.9.1

