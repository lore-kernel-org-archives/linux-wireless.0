Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f52.google.com ([209.85.220.52]:33983 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753091AbbHSG7u (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Aug 2015 02:59:50 -0400
Received: by paccq16 with SMTP id cq16so107275234pac.1
        for <linux-wireless@vger.kernel.org>; Tue, 18 Aug 2015 23:59:50 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, dean.lee@atmel.com,
	chris.park@atmel.com, linux-wireless@vger.kernel.org,
	devel@driverdev.osuosl.org, Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 12/13] staging: wilc1000: rename WILC_MsgQueueRecv to wilc_mq_recv
Date: Wed, 19 Aug 2015 15:59:07 +0900
Message-Id: <1439967548-25876-12-git-send-email-chaehyun.lim@gmail.com> (sfid-20150819_090108_460729_E0DDFDA4)
In-Reply-To: <1439967548-25876-1-git-send-email-chaehyun.lim@gmail.com>
References: <1439967548-25876-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch replaces WILC_MsgQueueRecv with wilc_mq_recv
to shorten function name and avoid CamelCase.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 2 +-
 drivers/staging/wilc1000/wilc_msgqueue.c  | 2 +-
 drivers/staging/wilc1000/wilc_msgqueue.h  | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 6be2348..f0a1383 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -4332,7 +4332,7 @@ static int hostIFthread(void *pvArg)
 	memset(&strHostIFmsg, 0, sizeof(tstrHostIFmsg));
 
 	while (1) {
-		WILC_MsgQueueRecv(&gMsgQHostIF, &strHostIFmsg, sizeof(tstrHostIFmsg), &u32Ret);
+		wilc_mq_recv(&gMsgQHostIF, &strHostIFmsg, sizeof(tstrHostIFmsg), &u32Ret);
 		pstrWFIDrv = (tstrWILC_WFIDrv *)strHostIFmsg.drvHandler;
 		if (strHostIFmsg.u16MsgId == HOST_IF_MSG_EXIT) {
 			PRINT_D(GENERIC_DBG, "THREAD: Exiting HostIfThread\n");
diff --git a/drivers/staging/wilc1000/wilc_msgqueue.c b/drivers/staging/wilc1000/wilc_msgqueue.c
index b5d230b..6015098 100644
--- a/drivers/staging/wilc1000/wilc_msgqueue.c
+++ b/drivers/staging/wilc1000/wilc_msgqueue.c
@@ -110,7 +110,7 @@ int wilc_mq_send(WILC_MsgQueueHandle *pHandle,
  *  @note		copied from FLO glue implementatuion
  *  @version		1.0
  */
-int WILC_MsgQueueRecv(WILC_MsgQueueHandle *pHandle,
+int wilc_mq_recv(WILC_MsgQueueHandle *pHandle,
 			     void *pvRecvBuffer, u32 u32RecvBufferSize,
 			     u32 *pu32ReceivedLength)
 {
diff --git a/drivers/staging/wilc1000/wilc_msgqueue.h b/drivers/staging/wilc1000/wilc_msgqueue.h
index 197b0a9..143fba4 100644
--- a/drivers/staging/wilc1000/wilc_msgqueue.h
+++ b/drivers/staging/wilc1000/wilc_msgqueue.h
@@ -63,7 +63,7 @@ int wilc_mq_send(WILC_MsgQueueHandle *pHandle,
  *  @date		30 Aug 2010
  *  @version		1.0
  */
-int WILC_MsgQueueRecv(WILC_MsgQueueHandle *pHandle,
+int wilc_mq_recv(WILC_MsgQueueHandle *pHandle,
 			     void *pvRecvBuffer, u32 u32RecvBufferSize,
 			     u32 *pu32ReceivedLength);
 
-- 
1.9.1

