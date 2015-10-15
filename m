Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:6175 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752260AbbJOE1L (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Oct 2015 00:27:11 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 15/40] staging: wilc1000: rename variable hWaitResponse
Date: Thu, 15 Oct 2015 13:24:56 +0900
Message-ID: <1444883121-31757-15-git-send-email-tony.cho@atmel.com> (sfid-20151015_062715_488902_80476C5F)
In-Reply-To: <1444883121-31757-1-git-send-email-tony.cho@atmel.com>
References: <1444883121-31757-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames variable hWaitResponse to hif_sema_wait_response
to avoid CamelCase naming convention.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index b4f8c3a..d9a4e3a 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -243,7 +243,7 @@ static struct task_struct *hif_thread_handler;
 static WILC_MsgQueueHandle hif_msg_q;
 static struct semaphore hif_sema_thread;
 struct semaphore hif_sema_driver;
-static struct semaphore hWaitResponse;
+static struct semaphore hif_sema_wait_response;
 struct semaphore hSemHostIntDeinit;
 struct timer_list g_hPeriodicRSSI;
 
@@ -526,7 +526,7 @@ static s32 Handle_GetMacAddress(struct host_if_drv *hif_drv,
 		PRINT_ER("Failed to get mac address\n");
 		s32Error = -EFAULT;
 	}
-	up(&hWaitResponse);
+	up(&hif_sema_wait_response);
 
 	return s32Error;
 }
@@ -817,7 +817,7 @@ ERRORHANDLER:
 static s32 Handle_wait_msg_q_empty(void)
 {
 	g_wilc_initialized = 0;
-	up(&hWaitResponse);
+	up(&hif_sema_wait_response);
 	return 0;
 }
 
@@ -2253,7 +2253,7 @@ s32 Handle_GetStatistics(struct host_if_drv *hif_drv, struct rf_info *pstrStatis
 	if (s32Error)
 		PRINT_ER("Failed to send scan paramters config packet\n");
 
-	up(&hWaitResponse);
+	up(&hif_sema_wait_response);
 	return 0;
 
 }
@@ -2508,7 +2508,7 @@ static void Handle_DelAllSta(struct host_if_drv *hif_drv,
 ERRORHANDLER:
 	kfree(strWID.val);
 
-	up(&hWaitResponse);
+	up(&hif_sema_wait_response);
 }
 
 static void Handle_DelStation(struct host_if_drv *hif_drv,
@@ -2908,7 +2908,7 @@ static s32 Handle_DelAllRxBASessions(struct host_if_drv *hif_drv,
 	if (strWID.val != NULL)
 		kfree(strWID.val);
 
-	up(&hWaitResponse);
+	up(&hif_sema_wait_response);
 
 	return s32Error;
 
@@ -3505,7 +3505,7 @@ s32 host_int_get_MacAddress(struct host_if_drv *hif_drv, u8 *pu8MacAddress)
 		return -EFAULT;
 	}
 
-	down(&hWaitResponse);
+	down(&hif_sema_wait_response);
 	return s32Error;
 }
 
@@ -3792,7 +3792,7 @@ int host_int_wait_msg_queue_idle(void)
 		result = -EINVAL;
 	}
 
-	down(&hWaitResponse);
+	down(&hif_sema_wait_response);
 
 	return result;
 }
@@ -3999,7 +3999,7 @@ s32 host_int_get_statistics(struct host_if_drv *hif_drv, struct rf_info *pstrSta
 		return -EFAULT;
 	}
 
-	down(&hWaitResponse);
+	down(&hif_sema_wait_response);
 	return s32Error;
 }
 
@@ -4229,7 +4229,7 @@ s32 host_int_init(struct host_if_drv **hif_drv_handler)
 
 	gbScanWhileConnected = false;
 
-	sema_init(&hWaitResponse, 0);
+	sema_init(&hif_sema_wait_response, 0);
 
 	hif_drv  = kzalloc(sizeof(struct host_if_drv), GFP_KERNEL);
 	if (!hif_drv) {
@@ -4795,7 +4795,7 @@ s32 host_int_del_allstation(struct host_if_drv *hif_drv,
 	if (s32Error)
 		PRINT_ER("wilc_mq_send fail\n");
 
-	down(&hWaitResponse);
+	down(&hif_sema_wait_response);
 
 	return s32Error;
 
@@ -5091,7 +5091,7 @@ s32 host_int_delBASession(struct host_if_drv *hif_drv, char *pBSSID, char TID)
 	if (s32Error)
 		PRINT_ER("wilc_mq_send fail\n");
 
-	down(&hWaitResponse);
+	down(&hif_sema_wait_response);
 
 	return s32Error;
 }
@@ -5121,7 +5121,7 @@ s32 host_int_del_All_Rx_BASession(struct host_if_drv *hif_drv,
 	if (s32Error)
 		PRINT_ER("wilc_mq_send fail\n");
 
-	down(&hWaitResponse);
+	down(&hif_sema_wait_response);
 
 	return s32Error;
 }
-- 
1.9.1

