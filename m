Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:42087 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755122AbbJ1HAU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Oct 2015 03:00:20 -0400
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 27/80] staging: wilc1000: rename hScanTimer of struct host_if_drv
Date: Wed, 28 Oct 2015 15:59:47 +0900
Message-ID: <1446015640-29398-27-git-send-email-glen.lee@atmel.com> (sfid-20151028_081659_792786_3FF92F93)
In-Reply-To: <1446015640-29398-1-git-send-email-glen.lee@atmel.com>
References: <1446015640-29398-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames hScanTimer of struct host_if_drv to scan_timer
to avoid CamelCase naming convention.
And, remove the relation comment.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 21 ++++++++++-----------
 drivers/staging/wilc1000/host_interface.h |  4 ++--
 2 files changed, 12 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 2e68f52..3f15812 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -921,7 +921,7 @@ static s32 Handle_Scan(struct host_if_drv *hif_drv,
 
 ERRORHANDLER:
 	if (result) {
-		del_timer(&hif_drv->hScanTimer);
+		del_timer(&hif_drv->scan_timer);
 		Handle_ScanDone(hif_drv, SCAN_EVENT_ABORTED);
 	}
 
@@ -1636,7 +1636,7 @@ static s32 Handle_RcvdGnrlAsyncInfo(struct host_if_drv *hif_drv,
 
 			if (hif_drv->usr_scan_req.pfUserScanResult) {
 				PRINT_D(HOSTINF_DBG, "\n\n<< Abort the running OBSS Scan >>\n\n");
-				del_timer(&hif_drv->hScanTimer);
+				del_timer(&hif_drv->scan_timer);
 				Handle_ScanDone((void *)hif_drv, SCAN_EVENT_ABORTED);
 			}
 
@@ -1683,7 +1683,7 @@ static s32 Handle_RcvdGnrlAsyncInfo(struct host_if_drv *hif_drv,
 			PRINT_D(HOSTINF_DBG, "Received MAC_DISCONNECTED from the FW while scanning\n");
 			PRINT_D(HOSTINF_DBG, "\n\n<< Abort the running Scan >>\n\n");
 
-			del_timer(&hif_drv->hScanTimer);
+			del_timer(&hif_drv->scan_timer);
 			if (hif_drv->usr_scan_req.pfUserScanResult)
 				Handle_ScanDone(hif_drv, SCAN_EVENT_ABORTED);
 		}
@@ -2000,7 +2000,7 @@ static void Handle_Disconnect(struct host_if_drv *hif_drv)
 		strDisconnectNotifInfo.ie_len = 0;
 
 		if (hif_drv->usr_scan_req.pfUserScanResult) {
-			del_timer(&hif_drv->hScanTimer);
+			del_timer(&hif_drv->scan_timer);
 			hif_drv->usr_scan_req.pfUserScanResult(SCAN_EVENT_ABORTED, NULL,
 							       hif_drv->usr_scan_req.u32UserScanPvoid, NULL);
 
@@ -2882,7 +2882,7 @@ static int hostIFthread(void *pvArg)
 			break;
 
 		case HOST_IF_MSG_RCVD_SCAN_COMPLETE:
-			del_timer(&hif_drv->hScanTimer);
+			del_timer(&hif_drv->scan_timer);
 			PRINT_D(HOSTINF_DBG, "scan completed successfully\n");
 
 			if (!linux_wlan_get_num_conn_ifcs())
@@ -3917,8 +3917,8 @@ s32 host_int_scan(struct host_if_drv *hif_drv, u8 u8ScanSource,
 	}
 
 	PRINT_D(HOSTINF_DBG, ">> Starting the SCAN timer\n");
-	hif_drv->hScanTimer.data = (unsigned long)hif_drv;
-	mod_timer(&hif_drv->hScanTimer,
+	hif_drv->scan_timer.data = (unsigned long)hif_drv;
+	mod_timer(&hif_drv->scan_timer,
 		  jiffies + msecs_to_jiffies(HOST_IF_SCAN_TIMEOUT));
 
 	return result;
@@ -4134,8 +4134,7 @@ s32 host_int_init(struct net_device *dev, struct host_if_drv **hif_drv_handler)
 		mod_timer(&periodic_rssi, jiffies + msecs_to_jiffies(5000));
 	}
 
-	setup_timer(&hif_drv->hScanTimer, TimerCB_Scan, 0);
-
+	setup_timer(&hif_drv->scan_timer, TimerCB_Scan, 0);
 	setup_timer(&hif_drv->hConnectTimer, TimerCB_Connect, 0);
 
 	setup_timer(&hif_drv->hRemainOnChannel, ListenTimerCB, 0);
@@ -4168,7 +4167,7 @@ s32 host_int_init(struct net_device *dev, struct host_if_drv **hif_drv_handler)
 _fail_timer_2:
 	up(&hif_drv->sem_cfg_values);
 	del_timer_sync(&hif_drv->hConnectTimer);
-	del_timer_sync(&hif_drv->hScanTimer);
+	del_timer_sync(&hif_drv->scan_timer);
 	kthread_stop(hif_thread_handler);
 _fail_mq_:
 	wilc_mq_destroy(&hif_msg_q);
@@ -4192,7 +4191,7 @@ s32 host_int_deinit(struct host_if_drv *hif_drv)
 	terminated_handle = hif_drv;
 	PRINT_D(HOSTINF_DBG, "De-initializing host interface for client %d\n", clients_count);
 
-	if (del_timer_sync(&hif_drv->hScanTimer))
+	if (del_timer_sync(&hif_drv->scan_timer))
 		PRINT_D(HOSTINF_DBG, ">> Scan timer is active\n");
 
 	if (del_timer_sync(&hif_drv->hConnectTimer))
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 7236481..c596db9 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -311,8 +311,8 @@ struct host_if_drv {
 	struct semaphore sem_get_link_speed;
 	struct semaphore sem_get_chnl;
 	struct semaphore sem_inactive_time;
-/* timer handlers */
-	struct timer_list hScanTimer;
+
+	struct timer_list scan_timer;
 	struct timer_list hConnectTimer;
 	struct timer_list hRemainOnChannel;
 
-- 
1.9.1

