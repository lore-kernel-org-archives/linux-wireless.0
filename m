Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:44330 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751534AbbGaHkL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Jul 2015 03:40:11 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <austin.shin@atmel.com>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<jude.lee@atmel.com>, <robin.hwang@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 11/28] staging: wilc1000: fix incompatible type in assignment warning
Date: Fri, 31 Jul 2015 16:38:19 +0900
Message-ID: <1438328316-30197-12-git-send-email-tony.cho@atmel.com> (sfid-20150731_100716_436356_238AC665)
In-Reply-To: <1438328316-30197-1-git-send-email-tony.cho@atmel.com>
References: <1438328316-30197-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: glen lee <glen.lee@atmel.com>

Cast type to WILC_WFIDrvHandle before assignment from incompatible pointer type
to fix the following warning.

drivers/staging/wilc1000/host_interface.c:6916:27: warning: assignment from
incompatible pointer type [enabled by default]
   strHostIFmsg.drvHandler = pstrWFIDrv;

Signed-off-by: glen lee <glen.lee@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 66565f6..e9cd77d 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -3981,7 +3981,7 @@ static void ListenTimerCB(void *pvArg)
 	/* prepare the Timer Callback message */
 	WILC_memset(&strHostIFmsg, 0, sizeof(tstrHostIFmsg));
 	strHostIFmsg.u16MsgId = HOST_IF_MSG_LISTEN_TIMER_FIRED;
-	strHostIFmsg.drvHandler = pstrWFIDrv;
+	strHostIFmsg.drvHandler = (WILC_WFIDrvHandle)pstrWFIDrv;
 	strHostIFmsg.uniHostIFmsgBody.strHostIfRemainOnChan.u32ListenSessionID = pstrWFIDrv->strHostIfRemainOnChan.u32ListenSessionID;
 
 	/* send the message */
@@ -6425,7 +6425,7 @@ void GetPeriodicRSSI(void *pvArg)
 		WILC_memset(&strHostIFmsg, 0, sizeof(tstrHostIFmsg));
 
 		strHostIFmsg.u16MsgId = HOST_IF_MSG_GET_RSSI;
-		strHostIFmsg.drvHandler = pstrWFIDrv;
+		strHostIFmsg.drvHandler = (WILC_WFIDrvHandle)pstrWFIDrv;
 
 		/* send the message */
 		s32Error =	WILC_MsgQueueSend(&gMsgQHostIF, &strHostIFmsg, sizeof(tstrHostIFmsg), NULL);
@@ -6779,7 +6779,7 @@ void NetworkInfoReceived(u8 *pu8Buffer, u32 u32Length)
 	WILC_memset(&strHostIFmsg, 0, sizeof(tstrHostIFmsg));
 
 	strHostIFmsg.u16MsgId = HOST_IF_MSG_RCVD_NTWRK_INFO;
-	strHostIFmsg.drvHandler = pstrWFIDrv;
+	strHostIFmsg.drvHandler = (WILC_WFIDrvHandle)pstrWFIDrv;
 
 	strHostIFmsg.uniHostIFmsgBody.strRcvdNetworkInfo.u32Length = u32Length;
 	strHostIFmsg.uniHostIFmsgBody.strRcvdNetworkInfo.pu8Buffer = (u8 *)WILC_MALLOC(u32Length); /* will be deallocated by the receiving thread */
@@ -6841,7 +6841,7 @@ void GnrlAsyncInfoReceived(u8 *pu8Buffer, u32 u32Length)
 
 
 	strHostIFmsg.u16MsgId = HOST_IF_MSG_RCVD_GNRL_ASYNC_INFO;
-	strHostIFmsg.drvHandler = pstrWFIDrv;
+	strHostIFmsg.drvHandler = (WILC_WFIDrvHandle)pstrWFIDrv;
 
 
 	strHostIFmsg.uniHostIFmsgBody.strRcvdGnrlAsyncInfo.u32Length = u32Length;
@@ -6890,7 +6890,7 @@ void host_int_ScanCompleteReceived(u8 *pu8Buffer, u32 u32Length)
 		WILC_memset(&strHostIFmsg, 0, sizeof(tstrHostIFmsg));
 
 		strHostIFmsg.u16MsgId = HOST_IF_MSG_RCVD_SCAN_COMPLETE;
-		strHostIFmsg.drvHandler = pstrWFIDrv;
+		strHostIFmsg.drvHandler = (WILC_WFIDrvHandle)pstrWFIDrv;
 
 
 		/* will be deallocated by the receiving thread */
-- 
1.9.1

