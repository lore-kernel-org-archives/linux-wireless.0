Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f54.google.com ([209.85.220.54]:34025 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752903AbbHSG7x (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Aug 2015 02:59:53 -0400
Received: by paccq16 with SMTP id cq16so107276168pac.1
        for <linux-wireless@vger.kernel.org>; Tue, 18 Aug 2015 23:59:53 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, dean.lee@atmel.com,
	chris.park@atmel.com, linux-wireless@vger.kernel.org,
	devel@driverdev.osuosl.org, Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 13/13] staging: wilc1000: rename WILC_MsgQueueDestroy to wilc_mq_destroy
Date: Wed, 19 Aug 2015 15:59:08 +0900
Message-Id: <1439967548-25876-13-git-send-email-chaehyun.lim@gmail.com> (sfid-20150819_090108_328022_8D0B6A17)
In-Reply-To: <1439967548-25876-1-git-send-email-chaehyun.lim@gmail.com>
References: <1439967548-25876-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch replaces WILC_MsgQueueDestroy to wilc_mq_destroy to
shorten function name and avoid CamelCase.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 4 ++--
 drivers/staging/wilc1000/wilc_msgqueue.c  | 2 +-
 drivers/staging/wilc1000/wilc_msgqueue.h  | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index f0a1383..d411847 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -6616,7 +6616,7 @@ _fail_timer_2:
 	del_timer_sync(&pstrWFIDrv->hScanTimer);
 	kthread_stop(HostIFthreadHandler);
 _fail_mq_:
-	WILC_MsgQueueDestroy(&gMsgQHostIF);
+	wilc_mq_destroy(&gMsgQHostIF);
 _fail_:
 	return s32Error;
 
@@ -6717,7 +6717,7 @@ s32 host_int_deinit(tstrWILC_WFIDrv *hWFIDrv)
 
 		down(&hSemHostIFthrdEnd);
 
-		WILC_MsgQueueDestroy(&gMsgQHostIF);
+		wilc_mq_destroy(&gMsgQHostIF);
 		msgQ_created = 0;
 	}
 
diff --git a/drivers/staging/wilc1000/wilc_msgqueue.c b/drivers/staging/wilc1000/wilc_msgqueue.c
index 6015098..76d2e63 100644
--- a/drivers/staging/wilc1000/wilc_msgqueue.c
+++ b/drivers/staging/wilc1000/wilc_msgqueue.c
@@ -24,7 +24,7 @@ int wilc_mq_create(WILC_MsgQueueHandle *pHandle)
  *  @note		copied from FLO glue implementatuion
  *  @version		1.0
  */
-int WILC_MsgQueueDestroy(WILC_MsgQueueHandle *pHandle)
+int wilc_mq_destroy(WILC_MsgQueueHandle *pHandle)
 {
 	pHandle->bExiting = true;
 
diff --git a/drivers/staging/wilc1000/wilc_msgqueue.h b/drivers/staging/wilc1000/wilc_msgqueue.h
index 143fba4..fc65dfe 100644
--- a/drivers/staging/wilc1000/wilc_msgqueue.h
+++ b/drivers/staging/wilc1000/wilc_msgqueue.h
@@ -76,6 +76,6 @@ int wilc_mq_recv(WILC_MsgQueueHandle *pHandle,
  *  @date		30 Aug 2010
  *  @version		1.0
  */
-int WILC_MsgQueueDestroy(WILC_MsgQueueHandle *pHandle);
+int wilc_mq_destroy(WILC_MsgQueueHandle *pHandle);
 
 #endif
-- 
1.9.1

