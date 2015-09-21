Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f42.google.com ([209.85.220.42]:35791 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752966AbbIUM7A (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Sep 2015 08:59:00 -0400
Received: by pacfv12 with SMTP id fv12so118703587pac.2
        for <linux-wireless@vger.kernel.org>; Mon, 21 Sep 2015 05:58:59 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 09/16] staging: wilc1000: host_int_init: remove meaningless comment
Date: Mon, 21 Sep 2015 21:58:19 +0900
Message-Id: <1442840306-9657-9-git-send-email-chaehyun.lim@gmail.com> (sfid-20150921_145902_855450_AA87FA92)
In-Reply-To: <1442840306-9657-1-git-send-email-chaehyun.lim@gmail.com>
References: <1442840306-9657-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes meaningless comment in host_int_init function.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index bc0adcd..317bc60 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -6378,9 +6378,7 @@ s32 host_int_init(tstrWILC_WFIDrv **phWFIDrv)
 		goto _fail_timer_2;
 	}
 	memset(pstrWFIDrv, 0, sizeof(tstrWILC_WFIDrv));
-	/*return driver handle to user*/
 	*phWFIDrv = pstrWFIDrv;
-	/*save into globl handle*/
 	err = add_handler_in_list(pstrWFIDrv);
 	if (err) {
 		s32Error = -EFAULT;
@@ -6393,7 +6391,6 @@ s32 host_int_init(tstrWILC_WFIDrv **phWFIDrv)
 	#endif
 
 	PRINT_D(HOSTINF_DBG, "Global handle pointer value=%p\n", pstrWFIDrv);
-	/* /////////////////////////////////////// */
 	if (clients_count == 0)	{
 		sema_init(&hSemHostIFthrdEnd, 0);
 		sema_init(&hSemDeinitDrvHandle, 0);
@@ -6407,7 +6404,6 @@ s32 host_int_init(tstrWILC_WFIDrv **phWFIDrv)
 	sema_init(&(pstrWFIDrv->hSemGetCHNL), 0);
 	sema_init(&(pstrWFIDrv->hSemInactiveTime), 0);
 
-	/* /////////////////////////////////////// */
 
 
 
@@ -6464,8 +6460,6 @@ s32 host_int_init(tstrWILC_WFIDrv **phWFIDrv)
 
 	up(&(pstrWFIDrv->gtOsCfgValuesSem));
 
-	/*TODO Code to setup simulation to be removed later*/
-
 	clients_count++; /* increase number of created entities */
 
 	return s32Error;
-- 
2.5.1

