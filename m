Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:6094 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932252AbbJOE0p (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Oct 2015 00:26:45 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 11/40] staging: wilc1000: rename variable HostIFthreadHandler
Date: Thu, 15 Oct 2015 13:24:52 +0900
Message-ID: <1444883121-31757-11-git-send-email-tony.cho@atmel.com> (sfid-20151015_062651_010637_25DB0809)
In-Reply-To: <1444883121-31757-1-git-send-email-tony.cho@atmel.com>
References: <1444883121-31757-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames variable HostIFthreadHandler to hif_thread_handler
to avoid CamelCase naming convention.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index ad7c102..4f24a05 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -239,7 +239,7 @@ static struct host_if_drv *wfidrv_list[NUM_CONCURRENT_IFC + 1];
 struct host_if_drv *terminated_handle;
 bool g_obtainingIP;
 u8 P2P_LISTEN_STATE;
-static struct task_struct *HostIFthreadHandler;
+static struct task_struct *hif_thread_handler;
 static WILC_MsgQueueHandle gMsgQHostIF;
 static struct semaphore hSemHostIFthrdEnd;
 
@@ -4271,8 +4271,10 @@ s32 host_int_init(struct host_if_drv **hif_drv_handler)
 			PRINT_ER("Failed to creat MQ\n");
 			goto _fail_;
 		}
-		HostIFthreadHandler = kthread_run(hostIFthread, NULL, "WILC_kthread");
-		if (IS_ERR(HostIFthreadHandler)) {
+
+		hif_thread_handler = kthread_run(hostIFthread, NULL, "WILC_kthread");
+
+		if (IS_ERR(hif_thread_handler)) {
 			PRINT_ER("Failed to creat Thread\n");
 			result = -EFAULT;
 			goto _fail_mq_;
@@ -4316,7 +4318,7 @@ _fail_timer_2:
 	up(&hif_drv->gtOsCfgValuesSem);
 	del_timer_sync(&hif_drv->hConnectTimer);
 	del_timer_sync(&hif_drv->hScanTimer);
-	kthread_stop(HostIFthreadHandler);
+	kthread_stop(hif_thread_handler);
 _fail_mq_:
 	wilc_mq_destroy(&gMsgQHostIF);
 _fail_:
-- 
1.9.1

