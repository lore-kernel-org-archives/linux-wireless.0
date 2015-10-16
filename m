Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:52409 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753107AbbJPEjp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Oct 2015 00:39:45 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH V2 14/40] staging: wilc1000: rename variable hSemDeinitDrvHandle
Date: Fri, 16 Oct 2015 13:37:44 +0900
Message-ID: <1444970290-17609-14-git-send-email-tony.cho@atmel.com> (sfid-20151016_064658_668406_A6D2F492)
In-Reply-To: <1444970290-17609-1-git-send-email-tony.cho@atmel.com>
References: <1444970290-17609-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames variable hSemDeinitDrvHandle to hif_sema_driver
to avoid CamelCase naming convention.

Add to static because follow warning reported by kbuild system.
 - drivers/staging/wilc1000/host_interface.c:245:18: sparse: symbol
   'hif_sema_driver' was not declared. Should it be static?

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index a587080..32c73b1 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -242,7 +242,7 @@ u8 P2P_LISTEN_STATE;
 static struct task_struct *hif_thread_handler;
 static WILC_MsgQueueHandle hif_msg_q;
 static struct semaphore hif_sema_thread;
-struct semaphore hSemDeinitDrvHandle;
+static struct semaphore hif_sema_driver;
 static struct semaphore hWaitResponse;
 struct semaphore hSemHostIntDeinit;
 struct timer_list g_hPeriodicRSSI;
@@ -370,8 +370,7 @@ static s32 Handle_SetWfiDrvHandler(struct host_if_drv *hif_drv,
 				   pstrHostIfSetDrvHandler->u32Address);
 
 	if (!hif_drv)
-		up(&hSemDeinitDrvHandle);
-
+		up(&hif_sema_driver);
 
 	if (s32Error) {
 		PRINT_ER("Failed to set driver handler\n");
@@ -398,8 +397,7 @@ static s32 Handle_SetOperationMode(struct host_if_drv *hif_drv,
 
 
 	if ((pstrHostIfSetOperationMode->u32Mode) == IDLE_MODE)
-		up(&hSemDeinitDrvHandle);
-
+		up(&hif_sema_driver);
 
 	if (s32Error) {
 		PRINT_ER("Failed to set driver handler\n");
@@ -4250,7 +4248,7 @@ s32 host_int_init(struct host_if_drv **hif_drv_handler)
 	PRINT_D(HOSTINF_DBG, "Global handle pointer value=%p\n", hif_drv);
 	if (clients_count == 0)	{
 		sema_init(&hif_sema_thread, 0);
-		sema_init(&hSemDeinitDrvHandle, 0);
+		sema_init(&hif_sema_driver, 0);
 		sema_init(&hSemHostIntDeinit, 1);
 	}
 
@@ -4356,7 +4354,7 @@ s32 host_int_deinit(struct host_if_drv *hif_drv)
 	del_timer_sync(&hif_drv->hRemainOnChannel);
 
 	host_int_set_wfi_drv_handler(NULL);
-	down(&hSemDeinitDrvHandle);
+	down(&hif_sema_driver);
 
 	if (hif_drv->strWILC_UsrScanReq.pfUserScanResult) {
 		hif_drv->strWILC_UsrScanReq.pfUserScanResult(SCAN_EVENT_ABORTED, NULL,
-- 
1.9.1

