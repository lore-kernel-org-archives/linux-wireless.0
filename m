Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:6195 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752260AbbJOE1S (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Oct 2015 00:27:18 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 16/40] staging: wilc1000: rename variable hSemHostIntDeinit
Date: Thu, 15 Oct 2015 13:24:57 +0900
Message-ID: <1444883121-31757-16-git-send-email-tony.cho@atmel.com> (sfid-20151015_062721_213714_FD7BF61C)
In-Reply-To: <1444883121-31757-1-git-send-email-tony.cho@atmel.com>
References: <1444883121-31757-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames variable hSemHostIntDeinit to hif_sema_deinit
to avoid CamelCase naming convention.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index d9a4e3a..acb8379d 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -244,7 +244,7 @@ static WILC_MsgQueueHandle hif_msg_q;
 static struct semaphore hif_sema_thread;
 struct semaphore hif_sema_driver;
 static struct semaphore hif_sema_wait_response;
-struct semaphore hSemHostIntDeinit;
+struct semaphore hif_sema_deinit;
 struct timer_list g_hPeriodicRSSI;
 
 
@@ -4249,7 +4249,7 @@ s32 host_int_init(struct host_if_drv **hif_drv_handler)
 	if (clients_count == 0)	{
 		sema_init(&hif_sema_thread, 0);
 		sema_init(&hif_sema_driver, 0);
-		sema_init(&hSemHostIntDeinit, 1);
+		sema_init(&hif_sema_deinit, 1);
 	}
 
 	sema_init(&hif_drv->hSemTestKeyBlock, 0);
@@ -4333,7 +4333,7 @@ s32 host_int_deinit(struct host_if_drv *hif_drv)
 		return 0;
 	}
 
-	down(&hSemHostIntDeinit);
+	down(&hif_sema_deinit);
 
 	terminated_handle = hif_drv;
 	PRINT_D(HOSTINF_DBG, "De-initializing host interface for client %d\n", clients_count);
@@ -4395,7 +4395,7 @@ s32 host_int_deinit(struct host_if_drv *hif_drv)
 
 	clients_count--;
 	terminated_handle = NULL;
-	up(&hSemHostIntDeinit);
+	up(&hif_sema_deinit);
 	return s32Error;
 }
 
@@ -4438,7 +4438,7 @@ void GnrlAsyncInfoReceived(u8 *pu8Buffer, u32 u32Length)
 	int id;
 	struct host_if_drv *hif_drv = NULL;
 
-	down(&hSemHostIntDeinit);
+	down(&hif_sema_deinit);
 
 	id = ((pu8Buffer[u32Length - 4]) | (pu8Buffer[u32Length - 3] << 8) | (pu8Buffer[u32Length - 2] << 16) | (pu8Buffer[u32Length - 1] << 24));
 	hif_drv = get_handler_from_id(id);
@@ -4447,13 +4447,13 @@ void GnrlAsyncInfoReceived(u8 *pu8Buffer, u32 u32Length)
 
 	if (!hif_drv || hif_drv == terminated_handle) {
 		PRINT_D(HOSTINF_DBG, "Wifi driver handler is equal to NULL\n");
-		up(&hSemHostIntDeinit);
+		up(&hif_sema_deinit);
 		return;
 	}
 
 	if (!hif_drv->strWILC_UsrConnReq.pfUserConnectResult) {
 		PRINT_ER("Received mac status is not needed when there is no current Connect Reques\n");
-		up(&hSemHostIntDeinit);
+		up(&hif_sema_deinit);
 		return;
 	}
 
@@ -4471,7 +4471,7 @@ void GnrlAsyncInfoReceived(u8 *pu8Buffer, u32 u32Length)
 	if (s32Error)
 		PRINT_ER("Error in sending message queue asynchronous message info: Error(%d)\n", s32Error);
 
-	up(&hSemHostIntDeinit);
+	up(&hif_sema_deinit);
 }
 
 void host_int_ScanCompleteReceived(u8 *pu8Buffer, u32 u32Length)
-- 
1.9.1

