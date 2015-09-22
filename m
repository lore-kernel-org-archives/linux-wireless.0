Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f45.google.com ([209.85.220.45]:32843 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932086AbbIVJfc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Sep 2015 05:35:32 -0400
Received: by pacex6 with SMTP id ex6so4749256pac.0
        for <linux-wireless@vger.kernel.org>; Tue, 22 Sep 2015 02:35:31 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH V2 09/16] staging: wilc1000: host_int_init: remove meaningless comment
Date: Tue, 22 Sep 2015 18:34:54 +0900
Message-Id: <1442914501-2315-9-git-send-email-chaehyun.lim@gmail.com> (sfid-20150922_113537_252096_467395DA)
In-Reply-To: <1442914501-2315-1-git-send-email-chaehyun.lim@gmail.com>
References: <1442914501-2315-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes meaningless comment in host_int_init function.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
v2: rebase latest staging-testing

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

