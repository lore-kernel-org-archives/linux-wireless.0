Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:38639 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752963AbbF3IgT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Jun 2015 04:36:19 -0400
From: Dean Lee <dean.lee@atmel.com>
To: <gregkh@linuxfoundation.org>, <devel@driverdev.osuosl.org>,
	<linux-wireless@vger.kernel.org>
CC: <johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <dean.lee@atmel.com>,
	<nicolas.ferre@atmel.com>
Subject: [PATCH 4/6] staging: wilc1000: rework address value.
Date: Tue, 30 Jun 2015 17:34:36 +0900
Message-ID: <1435653278-5168-4-git-send-email-dean.lee@atmel.com> (sfid-20150630_103641_064344_59982F98)
In-Reply-To: <1435653278-5168-1-git-send-email-dean.lee@atmel.com>
References: <1435653278-5168-1-git-send-email-dean.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

change type to pointer.

Signed-off-by: Dean Lee <dean.lee@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 22 +++++++++-------------
 drivers/staging/wilc1000/host_interface.h |  4 ++--
 2 files changed, 11 insertions(+), 15 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 1d59f41..1e40dca 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -640,26 +640,24 @@ static s32 Handle_SetChannel(void *drvHandler, tstrHostIFSetChan *pstrHostIFSetC
  *  @date
  *  @version	1.0
  */
-static s32 Handle_SetWfiDrvHandler(tstrHostIfSetDrvHandler *pstrHostIfSetDrvHandler)
+static s32 Handle_SetWfiDrvHandler(void *drvHandler, tstrHostIfSetDrvHandler *pstrHostIfSetDrvHandler)
 {
 
 	s32 s32Error = WILC_SUCCESS;
 	tstrWID	strWID;
-	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)((pstrHostIfSetDrvHandler->u32Address));
-
 
 	/*prepare configuration packet*/
 	strWID.u16WIDid = (u16)WID_SET_DRV_HANDLER;
-	strWID.enuWIDtype = WID_INT;
-	strWID.ps8WidVal = (s8 *)&(pstrHostIfSetDrvHandler->u32Address);
-	strWID.s32ValueSize = sizeof(u32);
+	strWID.enuWIDtype = WID_STR;
+	strWID.ps8WidVal = (s8 *)(pstrHostIfSetDrvHandler);
+	strWID.s32ValueSize = sizeof(tstrHostIfSetDrvHandler);
 
 	/*Sending Cfg*/
 
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, drvHandler);
 
 
-	if ((pstrHostIfSetDrvHandler->u32Address) == (u32)NULL) {
+	if (pstrHostIfSetDrvHandler->pAddress == NULL) {
 		up(&hSemDeinitDrvHandle);
 	}
 
@@ -4501,7 +4499,7 @@ static int hostIFthread(void *pvArg)
 			break;
 
 		case HOST_IF_MSG_SET_WFIDRV_HANDLER:
-			Handle_SetWfiDrvHandler(&strHostIFmsg.uniHostIFmsgBody.strHostIfSetDrvHandler);
+			Handle_SetWfiDrvHandler(strHostIFmsg.drvHandler, &strHostIFmsg.uniHostIFmsgBody.strHostIfSetDrvHandler);
 			break;
 
 		case HOST_IF_MSG_SET_OPERATION_MODE:
@@ -5848,7 +5846,7 @@ s32 host_int_wait_msg_queue_idle(void)
 
 }
 
-s32 host_int_set_wfi_drv_handler(u32 u32address)
+s32 host_int_set_wfi_drv_handler(void *pAddress)
 {
 	s32 s32Error = WILC_SUCCESS;
 
@@ -5859,7 +5857,7 @@ s32 host_int_set_wfi_drv_handler(u32 u32address)
 
 	WILC_memset(&strHostIFmsg, 0, sizeof(tstrHostIFmsg));
 	strHostIFmsg.u16MsgId = HOST_IF_MSG_SET_WFIDRV_HANDLER;
-	strHostIFmsg.uniHostIFmsgBody.strHostIfSetDrvHandler.u32Address = u32address;
+	strHostIFmsg.uniHostIFmsgBody.strHostIfSetDrvHandler.pAddress = pAddress;
 	/* strHostIFmsg.drvHandler=hWFIDrv; */
 
 	s32Error = WILC_MsgQueueSend(&gMsgQHostIF, &strHostIFmsg, sizeof(tstrHostIFmsg), NULL);
@@ -6953,8 +6951,6 @@ void host_int_ScanCompleteReceived(u8 *pu8Buffer, u32 u32Length)
 	uintptr_t drvData;
 	void *drvHandler = NULL;
 	tstrWILC_WFIDrv *pstrWFIDrv = NULL;
-	drvHandler = ((pu8Buffer[u32Length - 4]) | (pu8Buffer[u32Length - 3] << 8) | (pu8Buffer[u32Length - 2] << 16) | (pu8Buffer[u32Length - 1] << 24));
-	pstrWFIDrv = (tstrWILC_WFIDrv *)drvHandler;
 
 	drvData = ((pu8Buffer[u32Length - 4]) | (pu8Buffer[u32Length - 3] << 8) | (pu8Buffer[u32Length - 2] << 16) | (pu8Buffer[u32Length - 1] << 24));
 	drvHandler = (void *)drvData;
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index fc07fd2..37aaf95 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -268,7 +268,7 @@ typedef struct {
 } tstrWILC_UsrConnReq;
 
 typedef struct {
-	u32 u32Address;
+	void *pAddress;
 } tstrHostIfSetDrvHandler;
 
 typedef struct {
@@ -1255,7 +1255,7 @@ s32 host_int_frame_register(void *hWFIDrv, u16 u16FrameType, bool bReg);
  *  @date
  *  @version	1.0
  */
-s32 host_int_set_wfi_drv_handler(u32 u32address);
+s32 host_int_set_wfi_drv_handler(void *pAddress);
 s32 host_int_set_operation_mode(void *hWFIDrv, u32 u32mode);
 
 static s32 Handle_ScanDone(void *drvHandler, tenuScanEvent enuEvent);
-- 
2.4.4

