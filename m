Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:18504 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751283AbbHTHdn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Aug 2015 03:33:43 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <jude.lee@atmel.com>, <robin.hwang@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 2/5] staging: wilc1000: add an argument for Handle_SetWfiDrvHandler
Date: Thu, 20 Aug 2015 16:32:51 +0900
Message-ID: <1440055974-9998-3-git-send-email-tony.cho@atmel.com> (sfid-20150820_093347_557115_A591CBBD)
In-Reply-To: <1440055974-9998-1-git-send-email-tony.cho@atmel.com>
References: <1440055974-9998-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johnny Kim <johnny.kim@atmel.com>

Similar to functions of same layer, this patch add an argument for
Handle_SetWfiDrvHandler function. As a result, the redundant typecasting is
removed.

Signed-off-by: Johnny Kim <johnny.kim@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 0913d18..47e43cc 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -637,12 +637,13 @@ static s32 Handle_SetChannel(tstrWILC_WFIDrv *drvHandler, tstrHostIFSetChan *pst
  *  @date
  *  @version	1.0
  */
-static s32 Handle_SetWfiDrvHandler(tstrHostIfSetDrvHandler *pstrHostIfSetDrvHandler)
+static s32 Handle_SetWfiDrvHandler(tstrWILC_WFIDrv *drvHandler,
+				   tstrHostIfSetDrvHandler *pstrHostIfSetDrvHandler)
 {
 
 	s32 s32Error = WILC_SUCCESS;
 	tstrWID	strWID;
-	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)((pstrHostIfSetDrvHandler->u32Address));
+	tstrWILC_WFIDrv *pstrWFIDrv = drvHandler;
 
 
 	/*prepare configuration packet*/
@@ -656,7 +657,7 @@ static s32 Handle_SetWfiDrvHandler(tstrHostIfSetDrvHandler *pstrHostIfSetDrvHand
 	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
 
 
-	if ((pstrHostIfSetDrvHandler->u32Address) == (u32)NULL)
+	if (pstrWFIDrv == NULL)
 		up(&hSemDeinitDrvHandle);
 
 
@@ -4474,7 +4475,8 @@ static int hostIFthread(void *pvArg)
 			break;
 
 		case HOST_IF_MSG_SET_WFIDRV_HANDLER:
-			Handle_SetWfiDrvHandler(&strHostIFmsg.uniHostIFmsgBody.strHostIfSetDrvHandler);
+			Handle_SetWfiDrvHandler(strHostIFmsg.drvHandler,
+						&strHostIFmsg.uniHostIFmsgBody.strHostIfSetDrvHandler);
 			break;
 
 		case HOST_IF_MSG_SET_OPERATION_MODE:
@@ -5819,7 +5821,7 @@ s32 host_int_set_wfi_drv_handler(tstrWILC_WFIDrv *u32address)
 	memset(&strHostIFmsg, 0, sizeof(tstrHostIFmsg));
 	strHostIFmsg.u16MsgId = HOST_IF_MSG_SET_WFIDRV_HANDLER;
 	strHostIFmsg.uniHostIFmsgBody.strHostIfSetDrvHandler.u32Address = u32address;
-	/* strHostIFmsg.drvHandler=hWFIDrv; */
+	strHostIFmsg.drvHandler = u32address;
 
 	s32Error = WILC_MsgQueueSend(&gMsgQHostIF, &strHostIFmsg, sizeof(tstrHostIFmsg));
 	if (s32Error)
-- 
1.9.1

