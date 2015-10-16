Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:52394 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753107AbbJPEjk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Oct 2015 00:39:40 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH V2 13/40] staging: wilc1000: rename variable hSemHostIFthrdEnd
Date: Fri, 16 Oct 2015 13:37:43 +0900
Message-ID: <1444970290-17609-13-git-send-email-tony.cho@atmel.com> (sfid-20151016_064656_248458_EC1BCCDD)
In-Reply-To: <1444970290-17609-1-git-send-email-tony.cho@atmel.com>
References: <1444970290-17609-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames variable hSemHostIFthrdEnd to hif_sema_thread
to avoid CamelCase naming convention.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index bb770ab1..a587080 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -241,8 +241,7 @@ bool g_obtainingIP;
 u8 P2P_LISTEN_STATE;
 static struct task_struct *hif_thread_handler;
 static WILC_MsgQueueHandle hif_msg_q;
-static struct semaphore hSemHostIFthrdEnd;
-
+static struct semaphore hif_sema_thread;
 struct semaphore hSemDeinitDrvHandle;
 static struct semaphore hWaitResponse;
 struct semaphore hSemHostIntDeinit;
@@ -3123,7 +3122,7 @@ static int hostIFthread(void *pvArg)
 	}
 
 	PRINT_D(HOSTINF_DBG, "Releasing thread exit semaphore\n");
-	up(&hSemHostIFthrdEnd);
+	up(&hif_sema_thread);
 	return 0;
 }
 
@@ -4250,7 +4249,7 @@ s32 host_int_init(struct host_if_drv **hif_drv_handler)
 
 	PRINT_D(HOSTINF_DBG, "Global handle pointer value=%p\n", hif_drv);
 	if (clients_count == 0)	{
-		sema_init(&hSemHostIFthrdEnd, 0);
+		sema_init(&hif_sema_thread, 0);
 		sema_init(&hSemDeinitDrvHandle, 0);
 		sema_init(&hSemHostIntDeinit, 1);
 	}
@@ -4383,7 +4382,7 @@ s32 host_int_deinit(struct host_if_drv *hif_drv)
 		if (s32Error != 0)
 			PRINT_ER("Error in sending deinit's message queue message function: Error(%d)\n", s32Error);
 
-		down(&hSemHostIFthrdEnd);
+		down(&hif_sema_thread);
 
 		wilc_mq_destroy(&hif_msg_q);
 	}
-- 
1.9.1

