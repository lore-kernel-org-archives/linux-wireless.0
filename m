Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f174.google.com ([209.85.192.174]:36842 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753076AbbHSG7o (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Aug 2015 02:59:44 -0400
Received: by pdbmi9 with SMTP id mi9so36763903pdb.3
        for <linux-wireless@vger.kernel.org>; Tue, 18 Aug 2015 23:59:44 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, dean.lee@atmel.com,
	chris.park@atmel.com, linux-wireless@vger.kernel.org,
	devel@driverdev.osuosl.org, Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 10/13] staging: wilc1000: rename WILC_MsgQueueCreate to wilc_mq_create
Date: Wed, 19 Aug 2015 15:59:05 +0900
Message-Id: <1439967548-25876-10-git-send-email-chaehyun.lim@gmail.com> (sfid-20150819_085947_554919_88BF6E21)
In-Reply-To: <1439967548-25876-1-git-send-email-chaehyun.lim@gmail.com>
References: <1439967548-25876-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch replaces WILC_MsgQueueCreate with wilc_mq_create to
shorten function name and avoid CamelCase.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 2 +-
 drivers/staging/wilc1000/wilc_msgqueue.c  | 2 +-
 drivers/staging/wilc1000/wilc_msgqueue.h  | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 66fa677..159734f 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -6532,7 +6532,7 @@ s32 host_int_init(tstrWILC_WFIDrv **phWFIDrv)
 	PRINT_D(HOSTINF_DBG, "INIT: CLIENT COUNT %d\n", clients_count);
 
 	if (clients_count == 0)	{
-		s32Error = WILC_MsgQueueCreate(&gMsgQHostIF);
+		s32Error = wilc_mq_create(&gMsgQHostIF);
 
 		if (s32Error < 0) {
 			PRINT_ER("Failed to creat MQ\n");
diff --git a/drivers/staging/wilc1000/wilc_msgqueue.c b/drivers/staging/wilc1000/wilc_msgqueue.c
index f528f98..0358099 100644
--- a/drivers/staging/wilc1000/wilc_msgqueue.c
+++ b/drivers/staging/wilc1000/wilc_msgqueue.c
@@ -8,7 +8,7 @@
  *  @note		copied from FLO glue implementatuion
  *  @version		1.0
  */
-int WILC_MsgQueueCreate(WILC_MsgQueueHandle *pHandle)
+int wilc_mq_create(WILC_MsgQueueHandle *pHandle)
 {
 	spin_lock_init(&pHandle->strCriticalSection);
 	sema_init(&pHandle->hSem, 0);
diff --git a/drivers/staging/wilc1000/wilc_msgqueue.h b/drivers/staging/wilc1000/wilc_msgqueue.h
index a32c6db..555aa02 100644
--- a/drivers/staging/wilc1000/wilc_msgqueue.h
+++ b/drivers/staging/wilc1000/wilc_msgqueue.h
@@ -27,7 +27,7 @@
  *  @date		30 Aug 2010
  *  @version		1.0
  */
-int WILC_MsgQueueCreate(WILC_MsgQueueHandle *pHandle);
+int wilc_mq_create(WILC_MsgQueueHandle *pHandle);
 
 /*!
  *  @brief		Sends a message
-- 
1.9.1

