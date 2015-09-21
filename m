Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f52.google.com ([209.85.220.52]:35059 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932084AbbIUM7V (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Sep 2015 08:59:21 -0400
Received: by pacfv12 with SMTP id fv12so118710882pac.2
        for <linux-wireless@vger.kernel.org>; Mon, 21 Sep 2015 05:59:21 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 16/16] staging: wilc1000: host_int_init: remove unnecessary parentheses
Date: Mon, 21 Sep 2015 21:58:26 +0900
Message-Id: <1442840306-9657-16-git-send-email-chaehyun.lim@gmail.com> (sfid-20150921_145924_880956_04445ACF)
In-Reply-To: <1442840306-9657-1-git-send-email-chaehyun.lim@gmail.com>
References: <1442840306-9657-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes unnecessary parentheses found by checkpatch.pl

Unnecessary parentheses around pstrWFIDrv->hSemTestKeyBlock
Unnecessary parentheses around pstrWFIDrv->hSemTestDisconnectBlock
Unnecessary parentheses around pstrWFIDrv->hSemGetRSSI
Unnecessary parentheses around pstrWFIDrv->hSemGetLINKSPEED
Unnecessary parentheses around pstrWFIDrv->hSemGetCHNL
Unnecessary parentheses around pstrWFIDrv->hSemInactiveTime
Unnecessary parentheses around pstrWFIDrv->gtOsCfgValuesSem
Unnecessary parentheses around pstrWFIDrv->gtOsCfgValuesSem

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 82db248..db93940 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -6393,12 +6393,12 @@ s32 host_int_init(tstrWILC_WFIDrv **phWFIDrv)
 		sema_init(&hSemHostIntDeinit, 1);
 	}
 
-	sema_init(&(pstrWFIDrv->hSemTestKeyBlock), 0);
-	sema_init(&(pstrWFIDrv->hSemTestDisconnectBlock), 0);
-	sema_init(&(pstrWFIDrv->hSemGetRSSI), 0);
-	sema_init(&(pstrWFIDrv->hSemGetLINKSPEED), 0);
-	sema_init(&(pstrWFIDrv->hSemGetCHNL), 0);
-	sema_init(&(pstrWFIDrv->hSemInactiveTime), 0);
+	sema_init(&pstrWFIDrv->hSemTestKeyBlock, 0);
+	sema_init(&pstrWFIDrv->hSemTestDisconnectBlock, 0);
+	sema_init(&pstrWFIDrv->hSemGetRSSI, 0);
+	sema_init(&pstrWFIDrv->hSemGetLINKSPEED, 0);
+	sema_init(&pstrWFIDrv->hSemGetCHNL, 0);
+	sema_init(&pstrWFIDrv->hSemInactiveTime, 0);
 
 	PRINT_D(HOSTINF_DBG, "INIT: CLIENT COUNT %d\n", clients_count);
 
@@ -6428,7 +6428,7 @@ s32 host_int_init(tstrWILC_WFIDrv **phWFIDrv)
 	setup_timer(&pstrWFIDrv->hRemainOnChannel, ListenTimerCB, 0);
 
 	sema_init(&(pstrWFIDrv->gtOsCfgValuesSem), 1);
-	down(&(pstrWFIDrv->gtOsCfgValuesSem));
+	down(&pstrWFIDrv->gtOsCfgValuesSem);
 
 	pstrWFIDrv->enuHostIFstate = HOST_IF_IDLE;
 
@@ -6448,14 +6448,14 @@ s32 host_int_init(tstrWILC_WFIDrv **phWFIDrv)
 		   pstrWFIDrv->strCfgValues.active_scan_time, pstrWFIDrv->strCfgValues.passive_scan_time,
 		   pstrWFIDrv->strCfgValues.curr_tx_rate);
 
-	up(&(pstrWFIDrv->gtOsCfgValuesSem));
+	up(&pstrWFIDrv->gtOsCfgValuesSem);
 
 	clients_count++; /* increase number of created entities */
 
 	return result;
 
 _fail_timer_2:
-	up(&(pstrWFIDrv->gtOsCfgValuesSem));
+	up(&pstrWFIDrv->gtOsCfgValuesSem);
 	del_timer_sync(&pstrWFIDrv->hConnectTimer);
 	del_timer_sync(&pstrWFIDrv->hScanTimer);
 	kthread_stop(HostIFthreadHandler);
-- 
2.5.1

