Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f54.google.com ([209.85.220.54]:33081 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753826AbbIVJfr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Sep 2015 05:35:47 -0400
Received: by pacex6 with SMTP id ex6so4754819pac.0
        for <linux-wireless@vger.kernel.org>; Tue, 22 Sep 2015 02:35:46 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH V2 14/16] staging: wilc1000: host_int_init: replace s32Error with result
Date: Tue, 22 Sep 2015 18:34:59 +0900
Message-Id: <1442914501-2315-14-git-send-email-chaehyun.lim@gmail.com> (sfid-20150922_114654_820623_EB5E0936)
In-Reply-To: <1442914501-2315-1-git-send-email-chaehyun.lim@gmail.com>
References: <1442914501-2315-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch replaces s32Error with result in host_int_init function to
avoid camelcase.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
v2: rebase latest staging-testing

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

