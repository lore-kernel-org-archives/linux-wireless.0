Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f54.google.com ([209.85.220.54]:36737 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753349AbbIWJD5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Sep 2015 05:03:57 -0400
Received: by pacgz1 with SMTP id gz1so1184481pac.3
        for <linux-wireless@vger.kernel.org>; Wed, 23 Sep 2015 02:03:56 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 1/6] staging: wilc1000: move struct Message and WILC_MsgQueueHandle
Date: Wed, 23 Sep 2015 18:03:45 +0900
Message-Id: <1442999030-31934-1-git-send-email-chaehyun.lim@gmail.com> (sfid-20150923_110441_452986_763CD98F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch moves struct Message and WILC_MsgQueueHandle from
wilc_platform.h to wilc_msgqueue.h because those two structures are used
only at wilc_msgqueue.c so that it is good to be defined at
wilc_msgqueue.h

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/wilc_msgqueue.h | 15 +++++++++++++++
 drivers/staging/wilc1000/wilc_platform.h | 14 --------------
 2 files changed, 15 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_msgqueue.h b/drivers/staging/wilc1000/wilc_msgqueue.h
index a3c0bba..982628e 100644
--- a/drivers/staging/wilc1000/wilc_msgqueue.h
+++ b/drivers/staging/wilc1000/wilc_msgqueue.h
@@ -12,6 +12,21 @@
 
 #include "wilc_platform.h"
 
+/* Message Queue type is a structure */
+typedef struct __Message_struct {
+	void *pvBuffer;
+	u32 u32Length;
+	struct __Message_struct *pstrNext;
+} Message;
+
+typedef struct __MessageQueue_struct {
+	struct semaphore hSem;
+	spinlock_t strCriticalSection;
+	bool bExiting;
+	u32 u32ReceiversCount;
+	Message *pstrMessageList;
+} WILC_MsgQueueHandle;
+
 /*!
  *  @brief		Creates a new Message queue
  *  @details		Creates a new Message queue, if the feature
diff --git a/drivers/staging/wilc1000/wilc_platform.h b/drivers/staging/wilc1000/wilc_platform.h
index b763616..6ec1aa3 100644
--- a/drivers/staging/wilc1000/wilc_platform.h
+++ b/drivers/staging/wilc1000/wilc_platform.h
@@ -16,20 +16,6 @@
  *      OS specific types
  *******************************************************************/
 
-/* Message Queue type is a structure */
-typedef struct __Message_struct {
-	void *pvBuffer;
-	u32 u32Length;
-	struct __Message_struct *pstrNext;
-} Message;
-
-typedef struct __MessageQueue_struct {
-	struct semaphore hSem;
-	spinlock_t strCriticalSection;
-	bool bExiting;
-	u32 u32ReceiversCount;
-	Message *pstrMessageList;
-} WILC_MsgQueueHandle;
 
 
 
-- 
2.5.1

