Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f41.google.com ([209.85.220.41]:36668 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932086AbbIVJfl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Sep 2015 05:35:41 -0400
Received: by pacgz1 with SMTP id gz1so2047851pac.3
        for <linux-wireless@vger.kernel.org>; Tue, 22 Sep 2015 02:35:40 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH V2 12/16] staging: wilc1000: host_int_init: remove multiple blank lines
Date: Tue, 22 Sep 2015 18:34:57 +0900
Message-Id: <1442914501-2315-12-git-send-email-chaehyun.lim@gmail.com> (sfid-20150922_114654_458473_49729CBC)
In-Reply-To: <1442914501-2315-1-git-send-email-chaehyun.lim@gmail.com>
References: <1442914501-2315-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes multiple blank lines in host_int_init function.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
v2: rebase latest staging-testing

 drivers/staging/wilc1000/host_interface.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 2150c89..43062c5 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -6368,8 +6368,6 @@ s32 host_int_init(tstrWILC_WFIDrv **phWFIDrv)
 
 	sema_init(&hWaitResponse, 0);
 
-
-
 	/*Allocate host interface private structure*/
 	pstrWFIDrv  = kzalloc(sizeof(tstrWILC_WFIDrv), GFP_KERNEL);
 	if (!pstrWFIDrv) {
@@ -6402,9 +6400,6 @@ s32 host_int_init(tstrWILC_WFIDrv **phWFIDrv)
 	sema_init(&(pstrWFIDrv->hSemGetCHNL), 0);
 	sema_init(&(pstrWFIDrv->hSemInactiveTime), 0);
 
-
-
-
 	PRINT_D(HOSTINF_DBG, "INIT: CLIENT COUNT %d\n", clients_count);
 
 	if (clients_count == 0)	{
@@ -6425,7 +6420,6 @@ s32 host_int_init(tstrWILC_WFIDrv **phWFIDrv)
 		mod_timer(&g_hPeriodicRSSI, jiffies + msecs_to_jiffies(5000));
 	}
 
-
 	setup_timer(&pstrWFIDrv->hScanTimer, TimerCB_Scan, 0);
 
 	setup_timer(&pstrWFIDrv->hConnectTimer, TimerCB_Connect, 0);
@@ -6455,7 +6449,6 @@ s32 host_int_init(tstrWILC_WFIDrv **phWFIDrv)
 		   pstrWFIDrv->strCfgValues.active_scan_time, pstrWFIDrv->strCfgValues.passive_scan_time,
 		   pstrWFIDrv->strCfgValues.curr_tx_rate);
 
-
 	up(&(pstrWFIDrv->gtOsCfgValuesSem));
 
 	clients_count++; /* increase number of created entities */
@@ -6472,7 +6465,6 @@ _fail_mq_:
 _fail_:
 	return s32Error;
 
-
 }
 /**
  *  @brief              host_int_deinit
-- 
2.5.1

