Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f51.google.com ([209.85.220.51]:33661 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752966AbbIUM7P (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Sep 2015 08:59:15 -0400
Received: by pacex6 with SMTP id ex6so116417581pac.0
        for <linux-wireless@vger.kernel.org>; Mon, 21 Sep 2015 05:59:15 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 14/16] staging: wilc1000: host_int_init: replace s32Error with result
Date: Mon, 21 Sep 2015 21:58:24 +0900
Message-Id: <1442840306-9657-14-git-send-email-chaehyun.lim@gmail.com> (sfid-20150921_145919_843903_53C0B439)
In-Reply-To: <1442840306-9657-1-git-send-email-chaehyun.lim@gmail.com>
References: <1442840306-9657-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch replaces s32Error with result in host_int_init function to
avoid camelcase.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index ce7bb0f..ee4f169 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -6358,7 +6358,7 @@ static u32 clients_count;
 
 s32 host_int_init(tstrWILC_WFIDrv **phWFIDrv)
 {
-	s32 s32Error = 0;
+	s32 result = 0;
 	tstrWILC_WFIDrv *pstrWFIDrv;
 	int err;
 
@@ -6371,13 +6371,13 @@ s32 host_int_init(tstrWILC_WFIDrv **phWFIDrv)
 	/*Allocate host interface private structure*/
 	pstrWFIDrv  = kzalloc(sizeof(tstrWILC_WFIDrv), GFP_KERNEL);
 	if (!pstrWFIDrv) {
-		s32Error = -ENOMEM;
+		result = -ENOMEM;
 		goto _fail_timer_2;
 	}
 	*phWFIDrv = pstrWFIDrv;
 	err = add_handler_in_list(pstrWFIDrv);
 	if (err) {
-		s32Error = -EFAULT;
+		result = -EFAULT;
 		goto _fail_timer_2;
 	}
 
@@ -6403,16 +6403,16 @@ s32 host_int_init(tstrWILC_WFIDrv **phWFIDrv)
 	PRINT_D(HOSTINF_DBG, "INIT: CLIENT COUNT %d\n", clients_count);
 
 	if (clients_count == 0)	{
-		s32Error = wilc_mq_create(&gMsgQHostIF);
+		result = wilc_mq_create(&gMsgQHostIF);
 
-		if (s32Error < 0) {
+		if (result < 0) {
 			PRINT_ER("Failed to creat MQ\n");
 			goto _fail_;
 		}
 		HostIFthreadHandler = kthread_run(hostIFthread, NULL, "WILC_kthread");
 		if (IS_ERR(HostIFthreadHandler)) {
 			PRINT_ER("Failed to creat Thread\n");
-			s32Error = -EFAULT;
+			result = -EFAULT;
 			goto _fail_mq_;
 		}
 		setup_timer(&g_hPeriodicRSSI, GetPeriodicRSSI,
@@ -6452,7 +6452,7 @@ s32 host_int_init(tstrWILC_WFIDrv **phWFIDrv)
 
 	clients_count++; /* increase number of created entities */
 
-	return s32Error;
+	return result;
 
 _fail_timer_2:
 	up(&(pstrWFIDrv->gtOsCfgValuesSem));
@@ -6462,7 +6462,7 @@ _fail_timer_2:
 _fail_mq_:
 	wilc_mq_destroy(&gMsgQHostIF);
 _fail_:
-	return s32Error;
+	return result;
 
 }
 /**
-- 
2.5.1

