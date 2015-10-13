Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:3221 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752629AbbJMKy0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Oct 2015 06:54:26 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 35/54] staging: wilc1000: rename pu8Buffer of struct rcvd_async_info
Date: Tue, 13 Oct 2015 19:50:00 +0900
Message-ID: <1444733419-17679-35-git-send-email-tony.cho@atmel.com> (sfid-20151013_125428_718787_B0C12071)
In-Reply-To: <1444733419-17679-1-git-send-email-tony.cho@atmel.com>
References: <1444733419-17679-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames pu8Buffer of struct rcvd_async_info to buffer to
avoid CamelCase naming convention.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 33 +++++++++++++++----------------
 1 file changed, 16 insertions(+), 17 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 4af2bd1..7a91010 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -122,7 +122,7 @@ struct connect_attr {
 };
 
 struct rcvd_async_info {
-	u8 *pu8Buffer;
+	u8 *buffer;
 	u32 u32Length;
 };
 
@@ -1544,31 +1544,31 @@ static s32 Handle_RcvdGnrlAsyncInfo(struct host_if_drv *hif_drv,
 		return -ENODEV;
 	}
 	PRINT_D(GENERIC_DBG, "Current State = %d,Received state = %d\n", hif_drv->enuHostIFstate,
-		pstrRcvdGnrlAsyncInfo->pu8Buffer[7]);
+		pstrRcvdGnrlAsyncInfo->buffer[7]);
 
 	if ((hif_drv->enuHostIFstate == HOST_IF_WAITING_CONN_RESP) ||
 	    (hif_drv->enuHostIFstate == HOST_IF_CONNECTED) ||
 	    hif_drv->strWILC_UsrScanReq.pfUserScanResult) {
-		if ((pstrRcvdGnrlAsyncInfo->pu8Buffer == NULL) ||
+		if ((pstrRcvdGnrlAsyncInfo->buffer == NULL) ||
 		    (hif_drv->strWILC_UsrConnReq.pfUserConnectResult == NULL)) {
 			PRINT_ER("driver is null\n");
 			return -EINVAL;
 		}
 
-		u8MsgType = pstrRcvdGnrlAsyncInfo->pu8Buffer[0];
+		u8MsgType = pstrRcvdGnrlAsyncInfo->buffer[0];
 
 		if ('I' != u8MsgType) {
 			PRINT_ER("Received Message format incorrect.\n");
 			return -EFAULT;
 		}
 
-		u8MsgID = pstrRcvdGnrlAsyncInfo->pu8Buffer[1];
-		u16MsgLen = MAKE_WORD16(pstrRcvdGnrlAsyncInfo->pu8Buffer[2], pstrRcvdGnrlAsyncInfo->pu8Buffer[3]);
-		u16WidID = MAKE_WORD16(pstrRcvdGnrlAsyncInfo->pu8Buffer[4], pstrRcvdGnrlAsyncInfo->pu8Buffer[5]);
-		u8WidLen = pstrRcvdGnrlAsyncInfo->pu8Buffer[6];
-		u8MacStatus  = pstrRcvdGnrlAsyncInfo->pu8Buffer[7];
-		u8MacStatusReasonCode = pstrRcvdGnrlAsyncInfo->pu8Buffer[8];
-		u8MacStatusAdditionalInfo = pstrRcvdGnrlAsyncInfo->pu8Buffer[9];
+		u8MsgID = pstrRcvdGnrlAsyncInfo->buffer[1];
+		u16MsgLen = MAKE_WORD16(pstrRcvdGnrlAsyncInfo->buffer[2], pstrRcvdGnrlAsyncInfo->buffer[3]);
+		u16WidID = MAKE_WORD16(pstrRcvdGnrlAsyncInfo->buffer[4], pstrRcvdGnrlAsyncInfo->buffer[5]);
+		u8WidLen = pstrRcvdGnrlAsyncInfo->buffer[6];
+		u8MacStatus  = pstrRcvdGnrlAsyncInfo->buffer[7];
+		u8MacStatusReasonCode = pstrRcvdGnrlAsyncInfo->buffer[8];
+		u8MacStatusAdditionalInfo = pstrRcvdGnrlAsyncInfo->buffer[9];
 		PRINT_INFO(HOSTINF_DBG, "Recieved MAC status = %d with Reason = %d , Info = %d\n", u8MacStatus, u8MacStatusReasonCode, u8MacStatusAdditionalInfo);
 		if (hif_drv->enuHostIFstate == HOST_IF_WAITING_CONN_RESP) {
 			u32 u32RcvdAssocRespInfoLen;
@@ -1750,9 +1750,9 @@ static s32 Handle_RcvdGnrlAsyncInfo(struct host_if_drv *hif_drv,
 
 	}
 
-	if (pstrRcvdGnrlAsyncInfo->pu8Buffer != NULL) {
-		kfree(pstrRcvdGnrlAsyncInfo->pu8Buffer);
-		pstrRcvdGnrlAsyncInfo->pu8Buffer = NULL;
+	if (pstrRcvdGnrlAsyncInfo->buffer != NULL) {
+		kfree(pstrRcvdGnrlAsyncInfo->buffer);
+		pstrRcvdGnrlAsyncInfo->buffer = NULL;
 	}
 
 	return s32Error;
@@ -4484,9 +4484,8 @@ void GnrlAsyncInfoReceived(u8 *pu8Buffer, u32 u32Length)
 
 
 	msg.body.async_info.u32Length = u32Length;
-	msg.body.async_info.pu8Buffer = kmalloc(u32Length, GFP_KERNEL);
-	memcpy(msg.body.async_info.pu8Buffer,
-		    pu8Buffer, u32Length);
+	msg.body.async_info.buffer = kmalloc(u32Length, GFP_KERNEL);
+	memcpy(msg.body.async_info.buffer, pu8Buffer, u32Length);
 
 	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
 	if (s32Error)
-- 
1.9.1

