Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f178.google.com ([209.85.192.178]:34131 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753065AbbHSG7l (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Aug 2015 02:59:41 -0400
Received: by pdbfa8 with SMTP id fa8so77335990pdb.1
        for <linux-wireless@vger.kernel.org>; Tue, 18 Aug 2015 23:59:41 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, dean.lee@atmel.com,
	chris.park@atmel.com, linux-wireless@vger.kernel.org,
	devel@driverdev.osuosl.org, Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 09/13] staging: wilc1000: replace WILC_ErrNo by int type
Date: Wed, 19 Aug 2015 15:59:04 +0900
Message-Id: <1439967548-25876-9-git-send-email-chaehyun.lim@gmail.com> (sfid-20150819_085945_379960_52DBDEB3)
In-Reply-To: <1439967548-25876-1-git-send-email-chaehyun.lim@gmail.com>
References: <1439967548-25876-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch replaces WILC_ErrNo with int type.
WILC_ErrNo typedef is also removed.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/wilc_errorsupport.h |  2 --
 drivers/staging/wilc1000/wilc_msgqueue.c     | 12 ++++++------
 drivers/staging/wilc1000/wilc_msgqueue.h     |  8 ++++----
 3 files changed, 10 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_errorsupport.h b/drivers/staging/wilc1000/wilc_errorsupport.h
index b9517dc..6012ec4 100644
--- a/drivers/staging/wilc1000/wilc_errorsupport.h
+++ b/drivers/staging/wilc1000/wilc_errorsupport.h
@@ -36,8 +36,6 @@
 #define WILC_FILE_EOF			-116
 
 
-/* Error type */
-typedef s32 WILC_ErrNo;
 
 #define WILC_IS_ERR(__status__) (__status__ < WILC_SUCCESS)
 
diff --git a/drivers/staging/wilc1000/wilc_msgqueue.c b/drivers/staging/wilc1000/wilc_msgqueue.c
index f974f85..f528f98 100644
--- a/drivers/staging/wilc1000/wilc_msgqueue.c
+++ b/drivers/staging/wilc1000/wilc_msgqueue.c
@@ -8,7 +8,7 @@
  *  @note		copied from FLO glue implementatuion
  *  @version		1.0
  */
-WILC_ErrNo WILC_MsgQueueCreate(WILC_MsgQueueHandle *pHandle)
+int WILC_MsgQueueCreate(WILC_MsgQueueHandle *pHandle)
 {
 	spin_lock_init(&pHandle->strCriticalSection);
 	sema_init(&pHandle->hSem, 0);
@@ -24,7 +24,7 @@ WILC_ErrNo WILC_MsgQueueCreate(WILC_MsgQueueHandle *pHandle)
  *  @note		copied from FLO glue implementatuion
  *  @version		1.0
  */
-WILC_ErrNo WILC_MsgQueueDestroy(WILC_MsgQueueHandle *pHandle)
+int WILC_MsgQueueDestroy(WILC_MsgQueueHandle *pHandle)
 {
 	pHandle->bExiting = true;
 
@@ -50,10 +50,10 @@ WILC_ErrNo WILC_MsgQueueDestroy(WILC_MsgQueueHandle *pHandle)
  *  @note		copied from FLO glue implementatuion
  *  @version		1.0
  */
-WILC_ErrNo WILC_MsgQueueSend(WILC_MsgQueueHandle *pHandle,
+int WILC_MsgQueueSend(WILC_MsgQueueHandle *pHandle,
 			     const void *pvSendBuffer, u32 u32SendBufferSize)
 {
-	WILC_ErrNo s32RetStatus = WILC_SUCCESS;
+	int s32RetStatus = WILC_SUCCESS;
 	unsigned long flags;
 	Message *pstrMessage = NULL;
 
@@ -110,12 +110,12 @@ WILC_ErrNo WILC_MsgQueueSend(WILC_MsgQueueHandle *pHandle,
  *  @note		copied from FLO glue implementatuion
  *  @version		1.0
  */
-WILC_ErrNo WILC_MsgQueueRecv(WILC_MsgQueueHandle *pHandle,
+int WILC_MsgQueueRecv(WILC_MsgQueueHandle *pHandle,
 			     void *pvRecvBuffer, u32 u32RecvBufferSize,
 			     u32 *pu32ReceivedLength)
 {
 	Message *pstrMessage;
-	WILC_ErrNo s32RetStatus = WILC_SUCCESS;
+	int s32RetStatus = WILC_SUCCESS;
 	unsigned long flags;
 
 	if ((!pHandle) || (u32RecvBufferSize == 0)
diff --git a/drivers/staging/wilc1000/wilc_msgqueue.h b/drivers/staging/wilc1000/wilc_msgqueue.h
index ef1d2fa..a32c6db 100644
--- a/drivers/staging/wilc1000/wilc_msgqueue.h
+++ b/drivers/staging/wilc1000/wilc_msgqueue.h
@@ -27,7 +27,7 @@
  *  @date		30 Aug 2010
  *  @version		1.0
  */
-WILC_ErrNo WILC_MsgQueueCreate(WILC_MsgQueueHandle *pHandle);
+int WILC_MsgQueueCreate(WILC_MsgQueueHandle *pHandle);
 
 /*!
  *  @brief		Sends a message
@@ -44,7 +44,7 @@ WILC_ErrNo WILC_MsgQueueCreate(WILC_MsgQueueHandle *pHandle);
  *  @date		30 Aug 2010
  *  @version		1.0
  */
-WILC_ErrNo WILC_MsgQueueSend(WILC_MsgQueueHandle *pHandle,
+int WILC_MsgQueueSend(WILC_MsgQueueHandle *pHandle,
 			     const void *pvSendBuffer, u32 u32SendBufferSize);
 
 /*!
@@ -63,7 +63,7 @@ WILC_ErrNo WILC_MsgQueueSend(WILC_MsgQueueHandle *pHandle,
  *  @date		30 Aug 2010
  *  @version		1.0
  */
-WILC_ErrNo WILC_MsgQueueRecv(WILC_MsgQueueHandle *pHandle,
+int WILC_MsgQueueRecv(WILC_MsgQueueHandle *pHandle,
 			     void *pvRecvBuffer, u32 u32RecvBufferSize,
 			     u32 *pu32ReceivedLength);
 
@@ -76,6 +76,6 @@ WILC_ErrNo WILC_MsgQueueRecv(WILC_MsgQueueHandle *pHandle,
  *  @date		30 Aug 2010
  *  @version		1.0
  */
-WILC_ErrNo WILC_MsgQueueDestroy(WILC_MsgQueueHandle *pHandle);
+int WILC_MsgQueueDestroy(WILC_MsgQueueHandle *pHandle);
 
 #endif
-- 
1.9.1

