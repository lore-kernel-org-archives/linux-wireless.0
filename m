Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f180.google.com ([209.85.192.180]:34378 "EHLO
	mail-pf0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751390AbcFVKDr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jun 2016 06:03:47 -0400
Received: by mail-pf0-f180.google.com with SMTP id h14so16411114pfe.1
        for <linux-wireless@vger.kernel.org>; Wed, 22 Jun 2016 03:03:02 -0700 (PDT)
From: Binoy Jayan <binoy.jayan@linaro.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Johnny Kim <johnny.kim@atmel.com>,
	Austin Shin <austin.shin@atmel.com>,
	Chris Park <chris.park@atmel.com>,
	Tony Cho <tony.cho@atmel.com>, Glen Lee <glen.lee@atmel.com>,
	Leo Kim <leo.kim@atmel.com>, Arnd Bergmann <arnd@arndb.de>,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org, Binoy Jayan <binoy.jayan@linaro.org>
Subject: [PATCH v3 2/3] staging: wilc1000: Replace kthread with workqueue for host interface
Date: Wed, 22 Jun 2016 15:31:30 +0530
Message-Id: <1466589691-14798-3-git-send-email-binoy.jayan@linaro.org> (sfid-20160622_120605_204177_23E4F9F6)
In-Reply-To: <1466589691-14798-1-git-send-email-binoy.jayan@linaro.org>
References: <1466417419-13568-1-git-send-email-binoy.jayan@linaro.org>
 <1466589691-14798-1-git-send-email-binoy.jayan@linaro.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Deconstruct the kthread / message_queue logic, replacing it with
create_singlethread_workqueue() / queue_work() setup, by adding a
'struct work_struct' to 'struct host_if_msg'. The current kthread
hostIFthread() is converted to a work queue helper with the name
'host_if_work'.

Signed-off-by: Binoy Jayan <binoy.jayan@linaro.org>
---
 drivers/staging/wilc1000/TODO             |   5 +
 drivers/staging/wilc1000/host_interface.c | 282 ++++++++----------------------
 2 files changed, 75 insertions(+), 212 deletions(-)

diff --git a/drivers/staging/wilc1000/TODO b/drivers/staging/wilc1000/TODO
index 95199d8..ec93b2e 100644
--- a/drivers/staging/wilc1000/TODO
+++ b/drivers/staging/wilc1000/TODO
@@ -4,6 +4,11 @@ TODO:
 - remove custom debug and tracing functions
 - rework comments and function headers(also coding style)
 - replace all semaphores with mutexes or completions
+- Move handling for each individual members of 'union message_body' out
+  into a separate 'struct work_struct' and completely remove the multiplexer
+  that is currently part of host_if_work(), allowing movement of the
+  implementation of each message handler into the callsite of the function
+  that currently queues the 'host_if_msg'.
 - make spi and sdio components coexist in one build
 - turn compile-time platform configuration (BEAGLE_BOARD,
   PANDA_BOARD, PLAT_WMS8304, PLAT_RKXXXX, CUSTOMER_PLATFORM, ...)
diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 2d250c6..242c3d7 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -4,6 +4,7 @@
 #include <linux/delay.h>
 #include <linux/completion.h>
 #include <linux/list.h>
+#include <linux/workqueue.h>
 #include "host_interface.h"
 #include <linux/spinlock.h>
 #include <linux/errno.h>
@@ -211,6 +212,7 @@ struct host_if_msg {
 	u16 id;
 	union message_body body;
 	struct wilc_vif *vif;
+	struct work_struct work;
 };
 
 struct join_bss_param {
@@ -245,7 +247,7 @@ struct join_bss_param {
 static struct host_if_drv *terminated_handle;
 bool wilc_optaining_ip;
 static u8 P2P_LISTEN_STATE;
-static struct task_struct *hif_thread_handler;
+static struct workqueue_struct *hif_workqueue;
 static struct message_queue hif_msg_q;
 static struct completion hif_thread_comp;
 static struct completion hif_driver_comp;
@@ -280,55 +282,7 @@ static struct wilc_vif *join_req_vif;
 static void *host_int_ParseJoinBssParam(struct network_info *ptstrNetworkInfo);
 static int host_int_get_ipaddress(struct wilc_vif *vif, u8 *ip_addr, u8 idx);
 static s32 Handle_ScanDone(struct wilc_vif *vif, enum scan_event enuEvent);
-static int wilc_mq_create(struct message_queue *mq);
-static int wilc_mq_send(struct message_queue *mq,
-		 const void *send_buf, u32 send_buf_size);
-static int wilc_mq_recv(struct message_queue *mq,
-		 void *recv_buf, u32 recv_buf_size, u32 *recv_len);
-static int wilc_mq_destroy(struct message_queue *mq);
-
-/*!
- *  @author		syounan
- *  @date		1 Sep 2010
- *  @note		copied from FLO glue implementatuion
- *  @version		1.0
- */
-static int wilc_mq_create(struct message_queue *mq)
-{
-	spin_lock_init(&mq->lock);
-	sema_init(&mq->sem, 0);
-	INIT_LIST_HEAD(&mq->msg_list);
-	mq->recv_count = 0;
-	mq->exiting = false;
-	return 0;
-}
-
-/*!
- *  @author		syounan
- *  @date		1 Sep 2010
- *  @note		copied from FLO glue implementatuion
- *  @version		1.0
- */
-static int wilc_mq_destroy(struct message_queue *mq)
-{
-	struct message *msg;
-
-	mq->exiting = true;
-
-	/* Release any waiting receiver thread. */
-	while (mq->recv_count > 0) {
-		up(&mq->sem);
-		mq->recv_count--;
-	}
-
-	while (!list_empty(&mq->msg_list)) {
-		msg = list_first_entry(&mq->msg_list, struct message, list);
-		list_del(&msg->list);
-		kfree(msg->buf);
-	}
-
-	return 0;
-}
+static void host_if_work(struct work_struct *work);
 
 /*!
  *  @author		syounan
@@ -339,92 +293,17 @@ static int wilc_mq_destroy(struct message_queue *mq)
 static int wilc_mq_send(struct message_queue *mq,
 			const void *send_buf, u32 send_buf_size)
 {
-	unsigned long flags;
-	struct message *new_msg = NULL;
+	struct host_if_msg *new_msg;
 
-	if (!mq || (send_buf_size == 0) || !send_buf)
-		return -EINVAL;
-
-	if (mq->exiting)
-		return -EFAULT;
-
-	/* construct a new message */
-	new_msg = kmalloc(sizeof(*new_msg), GFP_ATOMIC);
+	new_msg = kmemdup(send_buf, sizeof(*new_msg), GFP_ATOMIC);
 	if (!new_msg)
 		return -ENOMEM;
 
-	new_msg->len = send_buf_size;
-	INIT_LIST_HEAD(&new_msg->list);
-	new_msg->buf = kmemdup(send_buf, send_buf_size, GFP_ATOMIC);
-	if (!new_msg->buf) {
-		kfree(new_msg);
-		return -ENOMEM;
-	}
-
-	spin_lock_irqsave(&mq->lock, flags);
-
-	/* add it to the message queue */
-	list_add_tail(&new_msg->list, &mq->msg_list);
-
-	spin_unlock_irqrestore(&mq->lock, flags);
-
-	up(&mq->sem);
-
+	INIT_WORK(&new_msg->work, host_if_work);
+	queue_work(hif_workqueue, &new_msg->work);
 	return 0;
 }
 
-/*!
- *  @author		syounan
- *  @date		1 Sep 2010
- *  @note		copied from FLO glue implementatuion
- *  @version		1.0
- */
-static int wilc_mq_recv(struct message_queue *mq,
-		 void *recv_buf, u32 recv_buf_size, u32 *recv_len)
-{
-	struct message *msg;
-	unsigned long flags;
-
-	if (!mq || (recv_buf_size == 0) || !recv_buf || !recv_len)
-		return -EINVAL;
-
-	if (mq->exiting)
-		return -EFAULT;
-
-	spin_lock_irqsave(&mq->lock, flags);
-	mq->recv_count++;
-	spin_unlock_irqrestore(&mq->lock, flags);
-
-	down(&mq->sem);
-	spin_lock_irqsave(&mq->lock, flags);
-
-	if (list_empty(&mq->msg_list)) {
-		spin_unlock_irqrestore(&mq->lock, flags);
-		up(&mq->sem);
-		return -EFAULT;
-	}
-	/* check buffer size */
-	msg = list_first_entry(&mq->msg_list, struct message, list);
-	if (recv_buf_size < msg->len) {
-		spin_unlock_irqrestore(&mq->lock, flags);
-		up(&mq->sem);
-		return -EOVERFLOW;
-	}
-
-	/* consume the message */
-	mq->recv_count--;
-	memcpy(recv_buf, msg->buf, msg->len);
-	*recv_len = msg->len;
-
-	list_del(&msg->list);
-
-	kfree(msg->buf);
-	kfree(msg);
-
-	spin_unlock_irqrestore(&mq->lock, flags);
-
-	return 0;
-}
 
 /* The u8IfIdx starts from 0 to NUM_CONCURRENT_IFC -1, but 0 index used as
  * special purpose in wilc device, so we add 1 to the index to starts from 1.
@@ -2625,187 +2504,172 @@ static void handle_get_tx_pwr(struct wilc_vif *vif, u8 *tx_pwr)
 	complete(&hif_wait_response);
 }
 
-static int hostIFthread(void *pvArg)
+static void host_if_work(struct work_struct *work)
 {
-	u32 u32Ret;
-	struct host_if_msg msg;
-	struct wilc *wilc = pvArg;
-	struct wilc_vif *vif;
-
-	memset(&msg, 0, sizeof(struct host_if_msg));
+	struct host_if_msg *msg;
+	struct wilc *wilc;
 
-	while (1) {
-		wilc_mq_recv(&hif_msg_q, &msg, sizeof(struct host_if_msg), &u32Ret);
-		vif = msg.vif;
-		if (msg.id == HOST_IF_MSG_EXIT)
-			break;
+	msg = container_of(work, struct host_if_msg, work);
+	wilc = msg->vif->wilc;
 
-		if ((!wilc_initialized)) {
-			usleep_range(200 * 1000, 200 * 1000);
-			wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
-			continue;
-		}
-
-		if (msg.id == HOST_IF_MSG_CONNECT &&
-		    vif->hif_drv->usr_scan_req.scan_result) {
-			wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
-			usleep_range(2 * 1000, 2 * 1000);
-			continue;
-		}
+	if (msg->id == HOST_IF_MSG_CONNECT &&
+	    msg->vif->hif_drv->usr_scan_req.scan_result) {
+		wilc_mq_send(&hif_msg_q, msg, sizeof(struct host_if_msg));
+		usleep_range(2 * 1000, 2 * 1000);
+	} else {
 
-		switch (msg.id) {
+		switch (msg->id) {
 		case HOST_IF_MSG_SCAN:
-			handle_scan(msg.vif, &msg.body.scan_info);
+			handle_scan(msg->vif, &msg->body.scan_info);
 			break;
 
 		case HOST_IF_MSG_CONNECT:
-			Handle_Connect(msg.vif, &msg.body.con_info);
+			Handle_Connect(msg->vif, &msg->body.con_info);
 			break;
 
 		case HOST_IF_MSG_RCVD_NTWRK_INFO:
-			Handle_RcvdNtwrkInfo(msg.vif, &msg.body.net_info);
+			Handle_RcvdNtwrkInfo(msg->vif, &msg->body.net_info);
 			break;
 
 		case HOST_IF_MSG_RCVD_GNRL_ASYNC_INFO:
-			Handle_RcvdGnrlAsyncInfo(vif,
-						 &msg.body.async_info);
+			Handle_RcvdGnrlAsyncInfo(msg->vif,
+						 &msg->body.async_info);
 			break;
 
 		case HOST_IF_MSG_KEY:
-			Handle_Key(msg.vif, &msg.body.key_info);
+			Handle_Key(msg->vif, &msg->body.key_info);
 			break;
 
 		case HOST_IF_MSG_CFG_PARAMS:
-			handle_cfg_param(msg.vif, &msg.body.cfg_info);
+			handle_cfg_param(msg->vif, &msg->body.cfg_info);
 			break;
 
 		case HOST_IF_MSG_SET_CHANNEL:
-			handle_set_channel(msg.vif, &msg.body.channel_info);
+			handle_set_channel(msg->vif, &msg->body.channel_info);
 			break;
 
 		case HOST_IF_MSG_DISCONNECT:
-			Handle_Disconnect(msg.vif);
+			Handle_Disconnect(msg->vif);
 			break;
 
 		case HOST_IF_MSG_RCVD_SCAN_COMPLETE:
-			del_timer(&vif->hif_drv->scan_timer);
+			del_timer(&msg->vif->hif_drv->scan_timer);
 
 			if (!wilc_wlan_get_num_conn_ifcs(wilc))
 				wilc_chip_sleep_manually(wilc);
 
-			Handle_ScanDone(msg.vif, SCAN_EVENT_DONE);
+			Handle_ScanDone(msg->vif, SCAN_EVENT_DONE);
 
-			if (vif->hif_drv->remain_on_ch_pending)
-				Handle_RemainOnChan(msg.vif,
-						    &msg.body.remain_on_ch);
+			if (msg->vif->hif_drv->remain_on_ch_pending)
+				Handle_RemainOnChan(msg->vif,
+						    &msg->body.remain_on_ch);
 
 			break;
 
 		case HOST_IF_MSG_GET_RSSI:
-			Handle_GetRssi(msg.vif);
+			Handle_GetRssi(msg->vif);
 			break;
 
 		case HOST_IF_MSG_GET_STATISTICS:
-			Handle_GetStatistics(msg.vif,
-					     (struct rf_info *)msg.body.data);
+			Handle_GetStatistics(msg->vif,
+					     (struct rf_info *)msg->body.data);
 			break;
 
 		case HOST_IF_MSG_ADD_BEACON:
-			Handle_AddBeacon(msg.vif, &msg.body.beacon_info);
+			Handle_AddBeacon(msg->vif, &msg->body.beacon_info);
 			break;
 
 		case HOST_IF_MSG_DEL_BEACON:
-			Handle_DelBeacon(msg.vif);
+			Handle_DelBeacon(msg->vif);
 			break;
 
 		case HOST_IF_MSG_ADD_STATION:
-			Handle_AddStation(msg.vif, &msg.body.add_sta_info);
+			Handle_AddStation(msg->vif, &msg->body.add_sta_info);
 			break;
 
 		case HOST_IF_MSG_DEL_STATION:
-			Handle_DelStation(msg.vif, &msg.body.del_sta_info);
+			Handle_DelStation(msg->vif, &msg->body.del_sta_info);
 			break;
 
 		case HOST_IF_MSG_EDIT_STATION:
-			Handle_EditStation(msg.vif, &msg.body.edit_sta_info);
+			Handle_EditStation(msg->vif, &msg->body.edit_sta_info);
 			break;
 
 		case HOST_IF_MSG_GET_INACTIVETIME:
-			Handle_Get_InActiveTime(msg.vif, &msg.body.mac_info);
+			Handle_Get_InActiveTime(msg->vif, &msg->body.mac_info);
 			break;
 
 		case HOST_IF_MSG_SCAN_TIMER_FIRED:
 
-			Handle_ScanDone(msg.vif, SCAN_EVENT_ABORTED);
+			Handle_ScanDone(msg->vif, SCAN_EVENT_ABORTED);
 			break;
 
 		case HOST_IF_MSG_CONNECT_TIMER_FIRED:
-			Handle_ConnectTimeout(msg.vif);
+			Handle_ConnectTimeout(msg->vif);
 			break;
 
 		case HOST_IF_MSG_POWER_MGMT:
-			Handle_PowerManagement(msg.vif,
-					       &msg.body.pwr_mgmt_info);
+			Handle_PowerManagement(msg->vif,
+					       &msg->body.pwr_mgmt_info);
 			break;
 
 		case HOST_IF_MSG_SET_WFIDRV_HANDLER:
-			handle_set_wfi_drv_handler(msg.vif, &msg.body.drv);
+			handle_set_wfi_drv_handler(msg->vif, &msg->body.drv);
 			break;
 
 		case HOST_IF_MSG_SET_OPERATION_MODE:
-			handle_set_operation_mode(msg.vif, &msg.body.mode);
+			handle_set_operation_mode(msg->vif, &msg->body.mode);
 			break;
 
 		case HOST_IF_MSG_SET_IPADDRESS:
-			handle_set_ip_address(vif,
-					      msg.body.ip_info.ip_addr,
-					      msg.body.ip_info.idx);
+			handle_set_ip_address(msg->vif,
+					      msg->body.ip_info.ip_addr,
+					      msg->body.ip_info.idx);
 			break;
 
 		case HOST_IF_MSG_GET_IPADDRESS:
-			handle_get_ip_address(vif, msg.body.ip_info.idx);
+			handle_get_ip_address(msg->vif, msg->body.ip_info.idx);
 			break;
 
 		case HOST_IF_MSG_GET_MAC_ADDRESS:
-			handle_get_mac_address(msg.vif,
-					       &msg.body.get_mac_info);
+			handle_get_mac_address(msg->vif,
+					       &msg->body.get_mac_info);
 			break;
 
 		case HOST_IF_MSG_REMAIN_ON_CHAN:
-			Handle_RemainOnChan(msg.vif, &msg.body.remain_on_ch);
+			Handle_RemainOnChan(msg->vif, &msg->body.remain_on_ch);
 			break;
 
 		case HOST_IF_MSG_REGISTER_FRAME:
-			Handle_RegisterFrame(msg.vif, &msg.body.reg_frame);
+			Handle_RegisterFrame(msg->vif, &msg->body.reg_frame);
 			break;
 
 		case HOST_IF_MSG_LISTEN_TIMER_FIRED:
-			Handle_ListenStateExpired(msg.vif, &msg.body.remain_on_ch);
+			Handle_ListenStateExpired(msg->vif, &msg->body.remain_on_ch);
 			break;
 
 		case HOST_IF_MSG_SET_MULTICAST_FILTER:
-			Handle_SetMulticastFilter(msg.vif, &msg.body.multicast_info);
+			Handle_SetMulticastFilter(msg->vif, &msg->body.multicast_info);
 			break;
 
 		case HOST_IF_MSG_DEL_ALL_STA:
-			Handle_DelAllSta(msg.vif, &msg.body.del_all_sta_info);
+			Handle_DelAllSta(msg->vif, &msg->body.del_all_sta_info);
 			break;
 
 		case HOST_IF_MSG_SET_TX_POWER:
-			handle_set_tx_pwr(msg.vif, msg.body.tx_power.tx_pwr);
+			handle_set_tx_pwr(msg->vif, msg->body.tx_power.tx_pwr);
 			break;
 
 		case HOST_IF_MSG_GET_TX_POWER:
-			handle_get_tx_pwr(msg.vif, &msg.body.tx_power.tx_pwr);
+			handle_get_tx_pwr(msg->vif, &msg->body.tx_power.tx_pwr);
 			break;
 		default:
-			netdev_err(vif->ndev, "[Host Interface] undefined\n");
+			netdev_err(msg->vif->ndev, "[Host Interface] undefined\n");
 			break;
 		}
 	}
-
+	kfree(msg);
 	complete(&hif_thread_comp);
-	return 0;
 }
 
 static void TimerCB_Scan(unsigned long arg)
@@ -3532,21 +3396,17 @@ int wilc_init(struct net_device *dev, struct host_if_drv **hif_drv_handler)
 	init_completion(&hif_drv->comp_inactive_time);
 
 	if (clients_count == 0)	{
-		result = wilc_mq_create(&hif_msg_q);
-
 		if (result < 0) {
 			netdev_err(vif->ndev, "Failed to creat MQ\n");
 			goto _fail_;
 		}
-
-		hif_thread_handler = kthread_run(hostIFthread, wilc,
-						 "WILC_kthread");
-
-		if (IS_ERR(hif_thread_handler)) {
-			netdev_err(vif->ndev, "Failed to creat Thread\n");
-			result = -EFAULT;
+		hif_workqueue = create_singlethread_workqueue("WILC_wq");
+		if (!hif_workqueue) {
+			netdev_err(vif->ndev, "Failed to create workqueue\n");
+			result = -ENOMEM;
 			goto _fail_mq_;
 		}
+
 		setup_timer(&periodic_rssi, GetPeriodicRSSI,
 			    (unsigned long)vif);
 		mod_timer(&periodic_rssi, jiffies + msecs_to_jiffies(5000));
@@ -3572,10 +3432,8 @@ int wilc_init(struct net_device *dev, struct host_if_drv **hif_drv_handler)
 
 	clients_count++;
 
-	return result;
-
 _fail_mq_:
-	wilc_mq_destroy(&hif_msg_q);
+	destroy_workqueue(hif_workqueue);
 _fail_:
 	return result;
 }
@@ -3625,7 +3483,7 @@ int wilc_deinit(struct wilc_vif *vif)
 		else
 			wait_for_completion(&hif_thread_comp);
 
-		wilc_mq_destroy(&hif_msg_q);
+		destroy_workqueue(hif_workqueue);
 	}
 
 	kfree(hif_drv);
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

