Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f47.google.com ([209.85.220.47]:33961 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754751AbbHQNop (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Aug 2015 09:44:45 -0400
Received: by paccq16 with SMTP id cq16so65422293pac.1
        for <linux-wireless@vger.kernel.org>; Mon, 17 Aug 2015 06:44:44 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, dean.lee@atmel.com,
	chris.park@atmel.com, linux-wireless@vger.kernel.org,
	devel@driverdev.osuosl.org, Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 3/4] staging: wilc1000: remove WILC_ErrNo
Date: Mon, 17 Aug 2015 22:44:30 +0900
Message-Id: <1439819071-30000-3-git-send-email-chaehyun.lim@gmail.com> (sfid-20150817_154448_131545_029761F3)
In-Reply-To: <1439819071-30000-1-git-send-email-chaehyun.lim@gmail.com>
References: <1439819071-30000-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

WILC_ErrNo is replaced by s32, then WILC_ErrNo typedef is removed.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/wilc_errorsupport.h |  2 --
 drivers/staging/wilc1000/wilc_msgqueue.c     | 12 ++++++------
 drivers/staging/wilc1000/wilc_msgqueue.h     |  8 ++++----
 drivers/staging/wilc1000/wilc_timer.c        |  4 ++--
 drivers/staging/wilc1000/wilc_timer.h        |  4 ++--
 5 files changed, 14 insertions(+), 16 deletions(-)

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
index 9783c15..dd87448 100644
--- a/drivers/staging/wilc1000/wilc_msgqueue.c
+++ b/drivers/staging/wilc1000/wilc_msgqueue.c
@@ -8,7 +8,7 @@
  *  @note		copied from FLO glue implementatuion
  *  @version		1.0
  */
-WILC_ErrNo WILC_MsgQueueCreate(WILC_MsgQueueHandle *pHandle,
+s32 WILC_MsgQueueCreate(WILC_MsgQueueHandle *pHandle,
 			       tstrWILC_MsgQueueAttrs *pstrAttrs)
 {
 	spin_lock_init(&pHandle->strCriticalSection);
@@ -25,7 +25,7 @@ WILC_ErrNo WILC_MsgQueueCreate(WILC_MsgQueueHandle *pHandle,
  *  @note		copied from FLO glue implementatuion
  *  @version		1.0
  */
-WILC_ErrNo WILC_MsgQueueDestroy(WILC_MsgQueueHandle *pHandle,
+s32 WILC_MsgQueueDestroy(WILC_MsgQueueHandle *pHandle,
 				tstrWILC_MsgQueueAttrs *pstrAttrs)
 {
 
@@ -52,11 +52,11 @@ WILC_ErrNo WILC_MsgQueueDestroy(WILC_MsgQueueHandle *pHandle,
  *  @note		copied from FLO glue implementatuion
  *  @version		1.0
  */
-WILC_ErrNo WILC_MsgQueueSend(WILC_MsgQueueHandle *pHandle,
+s32 WILC_MsgQueueSend(WILC_MsgQueueHandle *pHandle,
 			     const void *pvSendBuffer, u32 u32SendBufferSize,
 			     tstrWILC_MsgQueueAttrs *pstrAttrs)
 {
-	WILC_ErrNo s32RetStatus = WILC_SUCCESS;
+	s32 s32RetStatus = WILC_SUCCESS;
 	unsigned long flags;
 	Message *pstrMessage = NULL;
 
@@ -117,14 +117,14 @@ WILC_ErrNo WILC_MsgQueueSend(WILC_MsgQueueHandle *pHandle,
  *  @note		copied from FLO glue implementatuion
  *  @version		1.0
  */
-WILC_ErrNo WILC_MsgQueueRecv(WILC_MsgQueueHandle *pHandle,
+s32 WILC_MsgQueueRecv(WILC_MsgQueueHandle *pHandle,
 			     void *pvRecvBuffer, u32 u32RecvBufferSize,
 			     u32 *pu32ReceivedLength,
 			     tstrWILC_MsgQueueAttrs *pstrAttrs)
 {
 
 	Message *pstrMessage;
-	WILC_ErrNo s32RetStatus = WILC_SUCCESS;
+	s32 s32RetStatus = WILC_SUCCESS;
 	unsigned long flags;
 	if ((pHandle == NULL) || (u32RecvBufferSize == 0)
 	    || (pvRecvBuffer == NULL) || (pu32ReceivedLength == NULL)) {
diff --git a/drivers/staging/wilc1000/wilc_msgqueue.h b/drivers/staging/wilc1000/wilc_msgqueue.h
index de374ac..70c1148 100644
--- a/drivers/staging/wilc1000/wilc_msgqueue.h
+++ b/drivers/staging/wilc1000/wilc_msgqueue.h
@@ -41,7 +41,7 @@ typedef struct {
  *  @date		30 Aug 2010
  *  @version		1.0
  */
-WILC_ErrNo WILC_MsgQueueCreate(WILC_MsgQueueHandle *pHandle,
+s32 WILC_MsgQueueCreate(WILC_MsgQueueHandle *pHandle,
 			       tstrWILC_MsgQueueAttrs *pstrAttrs);
 
 
@@ -61,7 +61,7 @@ WILC_ErrNo WILC_MsgQueueCreate(WILC_MsgQueueHandle *pHandle,
  *  @date		30 Aug 2010
  *  @version		1.0
  */
-WILC_ErrNo WILC_MsgQueueSend(WILC_MsgQueueHandle *pHandle,
+s32 WILC_MsgQueueSend(WILC_MsgQueueHandle *pHandle,
 			     const void *pvSendBuffer, u32 u32SendBufferSize,
 			     tstrWILC_MsgQueueAttrs *pstrAttrs);
 
@@ -83,7 +83,7 @@ WILC_ErrNo WILC_MsgQueueSend(WILC_MsgQueueHandle *pHandle,
  *  @date		30 Aug 2010
  *  @version		1.0
  */
-WILC_ErrNo WILC_MsgQueueRecv(WILC_MsgQueueHandle *pHandle,
+s32 WILC_MsgQueueRecv(WILC_MsgQueueHandle *pHandle,
 			     void *pvRecvBuffer, u32 u32RecvBufferSize,
 			     u32 *pu32ReceivedLength,
 			     tstrWILC_MsgQueueAttrs *pstrAttrs);
@@ -99,7 +99,7 @@ WILC_ErrNo WILC_MsgQueueRecv(WILC_MsgQueueHandle *pHandle,
  *  @date		30 Aug 2010
  *  @version		1.0
  */
-WILC_ErrNo WILC_MsgQueueDestroy(WILC_MsgQueueHandle *pHandle,
+s32 WILC_MsgQueueDestroy(WILC_MsgQueueHandle *pHandle,
 				tstrWILC_MsgQueueAttrs *pstrAttrs);
 
 
diff --git a/drivers/staging/wilc1000/wilc_timer.c b/drivers/staging/wilc1000/wilc_timer.c
index 775e38b..447c8bd 100644
--- a/drivers/staging/wilc1000/wilc_timer.c
+++ b/drivers/staging/wilc1000/wilc_timer.c
@@ -1,10 +1,10 @@
 
 #include "wilc_timer.h"
 
-WILC_ErrNo WILC_TimerStart(struct timer_list *pHandle, u32 u32Timeout,
+s32 WILC_TimerStart(struct timer_list *pHandle, u32 u32Timeout,
 	void *pvArg)
 {
-	WILC_ErrNo s32RetStatus = WILC_FAIL;
+	s32 s32RetStatus = WILC_FAIL;
 	if (pHandle != NULL) {
 		pHandle->data = (unsigned long)pvArg;
 		s32RetStatus = mod_timer(pHandle, (jiffies + msecs_to_jiffies(u32Timeout)));
diff --git a/drivers/staging/wilc1000/wilc_timer.h b/drivers/staging/wilc1000/wilc_timer.h
index 925c613..017206b 100644
--- a/drivers/staging/wilc1000/wilc_timer.h
+++ b/drivers/staging/wilc1000/wilc_timer.h
@@ -45,7 +45,7 @@ typedef void (*tpfWILC_TimerFunction)(void *);
  *  @date	16 Aug 2010
  *  @version	1.0
  */
-WILC_ErrNo WILC_TimerCreate(struct timer_list *pHandle,
+s32 WILC_TimerCreate(struct timer_list *pHandle,
 			    tpfWILC_TimerFunction pfCallback);
 
 /*!
@@ -65,6 +65,6 @@ WILC_ErrNo WILC_TimerCreate(struct timer_list *pHandle,
  *  @date	16 Aug 2010
  *  @version	1.0
  */
-WILC_ErrNo WILC_TimerStart(struct timer_list *pHandle, u32 u32Timeout, void *pvArg);
+s32 WILC_TimerStart(struct timer_list *pHandle, u32 u32Timeout, void *pvArg);
 
 #endif
-- 
1.9.1

