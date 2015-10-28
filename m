Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:42116 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755122AbbJ1HA0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Oct 2015 03:00:26 -0400
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 28/80] staging: wilc1000: rename hConnectTimer of struct host_if_drv
Date: Wed, 28 Oct 2015 15:59:48 +0900
Message-ID: <1446015640-29398-28-git-send-email-glen.lee@atmel.com> (sfid-20151028_081701_018466_E3432550)
In-Reply-To: <1446015640-29398-1-git-send-email-glen.lee@atmel.com>
References: <1446015640-29398-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames hConnectTimer of struct host_if_drv to connect_timer
to avoid CamelCase naming convention.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 17 ++++++++---------
 drivers/staging/wilc1000/host_interface.h |  2 +-
 2 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 3f15812..8ee0a94 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -1223,7 +1223,7 @@ ERRORHANDLER:
 	if (result) {
 		tstrConnectInfo strConnectInfo;
 
-		del_timer(&hif_drv->hConnectTimer);
+		del_timer(&hif_drv->connect_timer);
 
 		PRINT_D(HOSTINF_DBG, "could not start connecting to the required network\n");
 
@@ -1594,7 +1594,7 @@ static s32 Handle_RcvdGnrlAsyncInfo(struct host_if_drv *hif_drv,
 				       hif_drv->usr_conn_req.ConnReqIEsLen);
 			}
 
-			del_timer(&hif_drv->hConnectTimer);
+			del_timer(&hif_drv->connect_timer);
 			hif_drv->usr_conn_req.pfUserConnectResult(CONN_DISCONN_EVENT_CONN_RESP,
 								  &strConnectInfo,
 								  u8MacStatus,
@@ -2010,7 +2010,7 @@ static void Handle_Disconnect(struct host_if_drv *hif_drv)
 		if (hif_drv->usr_conn_req.pfUserConnectResult) {
 			if (hif_drv->hif_state == HOST_IF_WAITING_CONN_RESP) {
 				PRINT_D(HOSTINF_DBG, "Upper layer requested termination of connection\n");
-				del_timer(&hif_drv->hConnectTimer);
+				del_timer(&hif_drv->connect_timer);
 			}
 
 			hif_drv->usr_conn_req.pfUserConnectResult(CONN_DISCONN_EVENT_DISCONN_NOTIF, NULL,
@@ -3509,8 +3509,8 @@ s32 host_int_set_join_req(struct host_if_drv *hif_drv, u8 *pu8bssid,
 		return -EFAULT;
 	}
 
-	hif_drv->hConnectTimer.data = (unsigned long)hif_drv;
-	mod_timer(&hif_drv->hConnectTimer,
+	hif_drv->connect_timer.data = (unsigned long)hif_drv;
+	mod_timer(&hif_drv->connect_timer,
 		  jiffies + msecs_to_jiffies(HOST_IF_CONNECT_TIMEOUT));
 
 	return result;
@@ -4135,8 +4135,7 @@ s32 host_int_init(struct net_device *dev, struct host_if_drv **hif_drv_handler)
 	}
 
 	setup_timer(&hif_drv->scan_timer, TimerCB_Scan, 0);
-	setup_timer(&hif_drv->hConnectTimer, TimerCB_Connect, 0);
-
+	setup_timer(&hif_drv->connect_timer, TimerCB_Connect, 0);
 	setup_timer(&hif_drv->hRemainOnChannel, ListenTimerCB, 0);
 
 	sema_init(&hif_drv->sem_cfg_values, 1);
@@ -4166,7 +4165,7 @@ s32 host_int_init(struct net_device *dev, struct host_if_drv **hif_drv_handler)
 
 _fail_timer_2:
 	up(&hif_drv->sem_cfg_values);
-	del_timer_sync(&hif_drv->hConnectTimer);
+	del_timer_sync(&hif_drv->connect_timer);
 	del_timer_sync(&hif_drv->scan_timer);
 	kthread_stop(hif_thread_handler);
 _fail_mq_:
@@ -4194,7 +4193,7 @@ s32 host_int_deinit(struct host_if_drv *hif_drv)
 	if (del_timer_sync(&hif_drv->scan_timer))
 		PRINT_D(HOSTINF_DBG, ">> Scan timer is active\n");
 
-	if (del_timer_sync(&hif_drv->hConnectTimer))
+	if (del_timer_sync(&hif_drv->connect_timer))
 		PRINT_D(HOSTINF_DBG, ">> Connect timer is active\n");
 
 	if (del_timer_sync(&periodic_rssi))
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index c596db9..d149fd5 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -313,7 +313,7 @@ struct host_if_drv {
 	struct semaphore sem_inactive_time;
 
 	struct timer_list scan_timer;
-	struct timer_list hConnectTimer;
+	struct timer_list connect_timer;
 	struct timer_list hRemainOnChannel;
 
 	bool IFC_UP;
-- 
1.9.1

