Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f51.google.com ([209.85.220.51]:34249 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752803AbcFTKKu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Jun 2016 06:10:50 -0400
Received: by mail-pa0-f51.google.com with SMTP id bz2so49729125pad.1
        for <linux-wireless@vger.kernel.org>; Mon, 20 Jun 2016 03:10:43 -0700 (PDT)
From: Binoy Jayan <binoy.jayan@linaro.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Johnny Kim <johnny.kim@atmel.com>,
	Austin Shin <austin.shin@atmel.com>,
	Chris Park <chris.park@atmel.com>,
	Tony Cho <tony.cho@atmel.com>, Glen Lee <glen.lee@atmel.com>,
	Leo Kim <leo.kim@atmel.com>, Arnd Bergmann <arnd@arndb.de>,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org, Binoy Jayan <binoy.jayan@linaro.org>
Subject: [PATCH v2 2/2] staging: wilc1000: Replace kthread with workqueue for host interface
Date: Mon, 20 Jun 2016 15:40:19 +0530
Message-Id: <1466417419-13568-3-git-send-email-binoy.jayan@linaro.org> (sfid-20160620_121100_083811_97320705)
In-Reply-To: <1466417419-13568-1-git-send-email-binoy.jayan@linaro.org>
References: <1465814259-3009-1-git-send-email-binoy.jayan@linaro.org>
 <1466417419-13568-1-git-send-email-binoy.jayan@linaro.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Deconstruct the kthread / message_queue logic, replacing it with
create_singlethread_workqueue() / queue_work() setup, by adding a
'struct work_struct' to 'struct host_if_msg'. The current kthread
hostIFthread() is converted to a work queue helper with the name
'host_if_work'.

Signed-off-by: Binoy Jayan <binoy.jayan@linaro.org>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/staging/wilc1000/TODO             |   5 +
 drivers/staging/wilc1000/host_interface.c | 542 +++++++++++-------------------
 2 files changed, 198 insertions(+), 349 deletions(-)

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
index 494345b..92d4561 100644
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
@@ -59,20 +60,6 @@
 #define TCP_ACK_FILTER_LINK_SPEED_THRESH	54
 #define DEFAULT_LINK_SPEED			72
 
-struct message {
-	void *buf;
-	u32 len;
-	struct list_head list;
-};
-
-struct message_queue {
-	struct semaphore sem;
-	spinlock_t lock;
-	bool exiting;
-	u32 recv_count;
-	struct list_head msg_list;
-};
-
 struct host_if_wpa_attr {
 	u8 *key;
 	const u8 *mac_addr;
@@ -211,6 +198,7 @@ struct host_if_msg {
 	u16 id;
 	union message_body body;
 	struct wilc_vif *vif;
+	struct work_struct work;
 };
 
 struct join_bss_param {
@@ -245,8 +233,7 @@ struct join_bss_param {
 static struct host_if_drv *terminated_handle;
 bool wilc_optaining_ip;
 static u8 P2P_LISTEN_STATE;
-static struct task_struct *hif_thread_handler;
-static struct message_queue hif_msg_q;
+static struct workqueue_struct *hif_workqueue;
 static struct completion hif_thread_comp;
 static struct completion hif_driver_comp;
 static struct completion hif_wait_response;
@@ -280,55 +267,8 @@ static struct wilc_vif *join_req_vif;
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
+static int wilc_enqueue_cmd(struct host_if_msg *msg);
+static void host_if_work(struct work_struct *work);
 
 /*!
  *  @author		syounan
@@ -336,95 +276,19 @@ static int wilc_mq_destroy(struct message_queue *mq)
  *  @note		copied from FLO glue implementatuion
  *  @version		1.0
  */
-static int wilc_mq_send(struct message_queue *mq,
-		 const void *send_buf, u32 send_buf_size)
+static int wilc_enqueue_cmd(struct host_if_msg *msg)
 {
-	unsigned long flags;
-	struct message *new_msg = NULL;
-
-	if (!mq || (send_buf_size == 0) || !send_buf)
-		return -EINVAL;
-
-	if (mq->exiting)
-		return -EFAULT;
+	struct host_if_msg *new_msg;
 
-	/* construct a new message */
-	new_msg = kmalloc(sizeof(*new_msg), GFP_ATOMIC);
+	new_msg = kmemdup(msg, sizeof(*new_msg), GFP_ATOMIC);
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
@@ -2525,9 +2389,9 @@ static void ListenTimerCB(unsigned long arg)
 	msg.vif = vif;
 	msg.body.remain_on_ch.id = vif->hif_drv->remain_on_ch.id;
 
-	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
+	result = wilc_enqueue_cmd(&msg);
 	if (result)
-		netdev_err(vif->ndev, "wilc_mq_send fail\n");
+		netdev_err(vif->ndev, "wilc_enqueue_cmd fail\n");
 }
 
 static void Handle_PowerManagement(struct wilc_vif *vif,
@@ -2625,187 +2489,173 @@ static void handle_get_tx_pwr(struct wilc_vif *vif, u8 *tx_pwr)
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
+		wilc_enqueue_cmd(msg);
+		usleep_range(2 * 1000, 2 * 1000);
+		goto end;
+	}
 
-		switch (msg.id) {
-		case HOST_IF_MSG_SCAN:
-			handle_scan(msg.vif, &msg.body.scan_info);
-			break;
+	switch (msg->id) {
+	case HOST_IF_MSG_SCAN:
+		handle_scan(msg->vif, &msg->body.scan_info);
+		break;
 
-		case HOST_IF_MSG_CONNECT:
-			Handle_Connect(msg.vif, &msg.body.con_info);
-			break;
+	case HOST_IF_MSG_CONNECT:
+		Handle_Connect(msg->vif, &msg->body.con_info);
+		break;
 
-		case HOST_IF_MSG_RCVD_NTWRK_INFO:
-			Handle_RcvdNtwrkInfo(msg.vif, &msg.body.net_info);
-			break;
+	case HOST_IF_MSG_RCVD_NTWRK_INFO:
+		Handle_RcvdNtwrkInfo(msg->vif, &msg->body.net_info);
+		break;
 
-		case HOST_IF_MSG_RCVD_GNRL_ASYNC_INFO:
-			Handle_RcvdGnrlAsyncInfo(vif,
-						 &msg.body.async_info);
-			break;
+	case HOST_IF_MSG_RCVD_GNRL_ASYNC_INFO:
+		Handle_RcvdGnrlAsyncInfo(msg->vif,
+					 &msg->body.async_info);
+		break;
 
-		case HOST_IF_MSG_KEY:
-			Handle_Key(msg.vif, &msg.body.key_info);
-			break;
+	case HOST_IF_MSG_KEY:
+		Handle_Key(msg->vif, &msg->body.key_info);
+		break;
 
-		case HOST_IF_MSG_CFG_PARAMS:
-			handle_cfg_param(msg.vif, &msg.body.cfg_info);
-			break;
+	case HOST_IF_MSG_CFG_PARAMS:
+		handle_cfg_param(msg->vif, &msg->body.cfg_info);
+		break;
 
-		case HOST_IF_MSG_SET_CHANNEL:
-			handle_set_channel(msg.vif, &msg.body.channel_info);
-			break;
+	case HOST_IF_MSG_SET_CHANNEL:
+		handle_set_channel(msg->vif, &msg->body.channel_info);
+		break;
 
-		case HOST_IF_MSG_DISCONNECT:
-			Handle_Disconnect(msg.vif);
-			break;
+	case HOST_IF_MSG_DISCONNECT:
+		Handle_Disconnect(msg->vif);
+		break;
 
-		case HOST_IF_MSG_RCVD_SCAN_COMPLETE:
-			del_timer(&vif->hif_drv->scan_timer);
+	case HOST_IF_MSG_RCVD_SCAN_COMPLETE:
+		del_timer(&msg->vif->hif_drv->scan_timer);
 
-			if (!wilc_wlan_get_num_conn_ifcs(wilc))
-				wilc_chip_sleep_manually(wilc);
+		if (!wilc_wlan_get_num_conn_ifcs(wilc))
+			wilc_chip_sleep_manually(wilc);
 
-			Handle_ScanDone(msg.vif, SCAN_EVENT_DONE);
+		Handle_ScanDone(msg->vif, SCAN_EVENT_DONE);
 
-			if (vif->hif_drv->remain_on_ch_pending)
-				Handle_RemainOnChan(msg.vif,
-						    &msg.body.remain_on_ch);
+		if (msg->vif->hif_drv->remain_on_ch_pending)
+			Handle_RemainOnChan(msg->vif,
+					    &msg->body.remain_on_ch);
 
-			break;
+		break;
 
-		case HOST_IF_MSG_GET_RSSI:
-			Handle_GetRssi(msg.vif);
-			break;
+	case HOST_IF_MSG_GET_RSSI:
+		Handle_GetRssi(msg->vif);
+		break;
 
-		case HOST_IF_MSG_GET_STATISTICS:
-			Handle_GetStatistics(msg.vif,
-					     (struct rf_info *)msg.body.data);
-			break;
+	case HOST_IF_MSG_GET_STATISTICS:
+		Handle_GetStatistics(msg->vif,
+				     (struct rf_info *)msg->body.data);
+		break;
 
-		case HOST_IF_MSG_ADD_BEACON:
-			Handle_AddBeacon(msg.vif, &msg.body.beacon_info);
-			break;
+	case HOST_IF_MSG_ADD_BEACON:
+		Handle_AddBeacon(msg->vif, &msg->body.beacon_info);
+		break;
 
-		case HOST_IF_MSG_DEL_BEACON:
-			Handle_DelBeacon(msg.vif);
-			break;
+	case HOST_IF_MSG_DEL_BEACON:
+		Handle_DelBeacon(msg->vif);
+		break;
 
-		case HOST_IF_MSG_ADD_STATION:
-			Handle_AddStation(msg.vif, &msg.body.add_sta_info);
-			break;
+	case HOST_IF_MSG_ADD_STATION:
+		Handle_AddStation(msg->vif, &msg->body.add_sta_info);
+		break;
 
-		case HOST_IF_MSG_DEL_STATION:
-			Handle_DelStation(msg.vif, &msg.body.del_sta_info);
-			break;
+	case HOST_IF_MSG_DEL_STATION:
+		Handle_DelStation(msg->vif, &msg->body.del_sta_info);
+		break;
 
-		case HOST_IF_MSG_EDIT_STATION:
-			Handle_EditStation(msg.vif, &msg.body.edit_sta_info);
-			break;
+	case HOST_IF_MSG_EDIT_STATION:
+		Handle_EditStation(msg->vif, &msg->body.edit_sta_info);
+		break;
 
-		case HOST_IF_MSG_GET_INACTIVETIME:
-			Handle_Get_InActiveTime(msg.vif, &msg.body.mac_info);
-			break;
+	case HOST_IF_MSG_GET_INACTIVETIME:
+		Handle_Get_InActiveTime(msg->vif, &msg->body.mac_info);
+		break;
 
-		case HOST_IF_MSG_SCAN_TIMER_FIRED:
+	case HOST_IF_MSG_SCAN_TIMER_FIRED:
 
-			Handle_ScanDone(msg.vif, SCAN_EVENT_ABORTED);
-			break;
+		Handle_ScanDone(msg->vif, SCAN_EVENT_ABORTED);
+		break;
 
-		case HOST_IF_MSG_CONNECT_TIMER_FIRED:
-			Handle_ConnectTimeout(msg.vif);
-			break;
+	case HOST_IF_MSG_CONNECT_TIMER_FIRED:
+		Handle_ConnectTimeout(msg->vif);
+		break;
 
-		case HOST_IF_MSG_POWER_MGMT:
-			Handle_PowerManagement(msg.vif,
-					       &msg.body.pwr_mgmt_info);
-			break;
+	case HOST_IF_MSG_POWER_MGMT:
+		Handle_PowerManagement(msg->vif,
+				       &msg->body.pwr_mgmt_info);
+		break;
 
-		case HOST_IF_MSG_SET_WFIDRV_HANDLER:
-			handle_set_wfi_drv_handler(msg.vif, &msg.body.drv);
-			break;
+	case HOST_IF_MSG_SET_WFIDRV_HANDLER:
+		handle_set_wfi_drv_handler(msg->vif, &msg->body.drv);
+		break;
 
-		case HOST_IF_MSG_SET_OPERATION_MODE:
-			handle_set_operation_mode(msg.vif, &msg.body.mode);
-			break;
+	case HOST_IF_MSG_SET_OPERATION_MODE:
+		handle_set_operation_mode(msg->vif, &msg->body.mode);
+		break;
 
-		case HOST_IF_MSG_SET_IPADDRESS:
-			handle_set_ip_address(vif,
-					      msg.body.ip_info.ip_addr,
-					      msg.body.ip_info.idx);
-			break;
+	case HOST_IF_MSG_SET_IPADDRESS:
+		handle_set_ip_address(msg->vif,
+				      msg->body.ip_info.ip_addr,
+				      msg->body.ip_info.idx);
+		break;
 
-		case HOST_IF_MSG_GET_IPADDRESS:
-			handle_get_ip_address(vif, msg.body.ip_info.idx);
-			break;
+	case HOST_IF_MSG_GET_IPADDRESS:
+		handle_get_ip_address(msg->vif, msg->body.ip_info.idx);
+		break;
 
-		case HOST_IF_MSG_GET_MAC_ADDRESS:
-			handle_get_mac_address(msg.vif,
-					       &msg.body.get_mac_info);
-			break;
+	case HOST_IF_MSG_GET_MAC_ADDRESS:
+		handle_get_mac_address(msg->vif,
+				       &msg->body.get_mac_info);
+		break;
 
-		case HOST_IF_MSG_REMAIN_ON_CHAN:
-			Handle_RemainOnChan(msg.vif, &msg.body.remain_on_ch);
-			break;
+	case HOST_IF_MSG_REMAIN_ON_CHAN:
+		Handle_RemainOnChan(msg->vif, &msg->body.remain_on_ch);
+		break;
 
-		case HOST_IF_MSG_REGISTER_FRAME:
-			Handle_RegisterFrame(msg.vif, &msg.body.reg_frame);
-			break;
+	case HOST_IF_MSG_REGISTER_FRAME:
+		Handle_RegisterFrame(msg->vif, &msg->body.reg_frame);
+		break;
 
-		case HOST_IF_MSG_LISTEN_TIMER_FIRED:
-			Handle_ListenStateExpired(msg.vif, &msg.body.remain_on_ch);
-			break;
+	case HOST_IF_MSG_LISTEN_TIMER_FIRED:
+		Handle_ListenStateExpired(msg->vif, &msg->body.remain_on_ch);
+		break;
 
-		case HOST_IF_MSG_SET_MULTICAST_FILTER:
-			Handle_SetMulticastFilter(msg.vif, &msg.body.multicast_info);
-			break;
+	case HOST_IF_MSG_SET_MULTICAST_FILTER:
+		Handle_SetMulticastFilter(msg->vif, &msg->body.multicast_info);
+		break;
 
-		case HOST_IF_MSG_DEL_ALL_STA:
-			Handle_DelAllSta(msg.vif, &msg.body.del_all_sta_info);
-			break;
+	case HOST_IF_MSG_DEL_ALL_STA:
+		Handle_DelAllSta(msg->vif, &msg->body.del_all_sta_info);
+		break;
 
-		case HOST_IF_MSG_SET_TX_POWER:
-			handle_set_tx_pwr(msg.vif, msg.body.tx_power.tx_pwr);
-			break;
+	case HOST_IF_MSG_SET_TX_POWER:
+		handle_set_tx_pwr(msg->vif, msg->body.tx_power.tx_pwr);
+		break;
 
-		case HOST_IF_MSG_GET_TX_POWER:
-			handle_get_tx_pwr(msg.vif, &msg.body.tx_power.tx_pwr);
-			break;
-		default:
-			netdev_err(vif->ndev, "[Host Interface] undefined\n");
-			break;
-		}
+	case HOST_IF_MSG_GET_TX_POWER:
+		handle_get_tx_pwr(msg->vif, &msg->body.tx_power.tx_pwr);
+		break;
+	default:
+		netdev_err(msg->vif->ndev, "[Host Interface] undefined\n");
+		break;
 	}
-
+end:
+	kfree(msg);
 	complete(&hif_thread_comp);
-	return 0;
 }
 
 static void TimerCB_Scan(unsigned long arg)
@@ -2817,7 +2667,7 @@ static void TimerCB_Scan(unsigned long arg)
 	msg.vif = vif;
 	msg.id = HOST_IF_MSG_SCAN_TIMER_FIRED;
 
-	wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
+	wilc_enqueue_cmd(&msg);
 }
 
 static void TimerCB_Connect(unsigned long arg)
@@ -2829,7 +2679,7 @@ static void TimerCB_Connect(unsigned long arg)
 	msg.vif = vif;
 	msg.id = HOST_IF_MSG_CONNECT_TIMER_FIRED;
 
-	wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
+	wilc_enqueue_cmd(&msg);
 }
 
 s32 wilc_remove_key(struct host_if_drv *hif_drv, const u8 *pu8StaAddress)
@@ -2864,7 +2714,7 @@ int wilc_remove_wep_key(struct wilc_vif *vif, u8 index)
 	msg.vif = vif;
 	msg.body.key_info.attr.wep.index = index;
 
-	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
+	result = wilc_enqueue_cmd(&msg);
 	if (result)
 		netdev_err(vif->ndev, "Request to remove WEP key\n");
 	else
@@ -2893,7 +2743,7 @@ int wilc_set_wep_default_keyid(struct wilc_vif *vif, u8 index)
 	msg.vif = vif;
 	msg.body.key_info.attr.wep.index = index;
 
-	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
+	result = wilc_enqueue_cmd(&msg);
 	if (result)
 		netdev_err(vif->ndev, "Default key index\n");
 	else
@@ -2927,7 +2777,7 @@ int wilc_add_wep_key_bss_sta(struct wilc_vif *vif, const u8 *key, u8 len,
 	msg.body.key_info.attr.wep.key_len = len;
 	msg.body.key_info.attr.wep.index = index;
 
-	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
+	result = wilc_enqueue_cmd(&msg);
 	if (result)
 		netdev_err(vif->ndev, "STA - WEP Key\n");
 	wait_for_completion(&hif_drv->comp_test_key_block);
@@ -2962,7 +2812,7 @@ int wilc_add_wep_key_bss_ap(struct wilc_vif *vif, const u8 *key, u8 len,
 	msg.body.key_info.attr.wep.mode = mode;
 	msg.body.key_info.attr.wep.auth_type = auth_type;
 
-	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
+	result = wilc_enqueue_cmd(&msg);
 
 	if (result)
 		netdev_err(vif->ndev, "AP - WEP Key\n");
@@ -3018,7 +2868,7 @@ int wilc_add_ptk(struct wilc_vif *vif, const u8 *ptk, u8 ptk_key_len,
 	msg.body.key_info.attr.wpa.mode = cipher_mode;
 	msg.vif = vif;
 
-	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
+	result = wilc_enqueue_cmd(&msg);
 
 	if (result)
 		netdev_err(vif->ndev, "PTK Key\n");
@@ -3087,7 +2937,7 @@ int wilc_add_rx_gtk(struct wilc_vif *vif, const u8 *rx_gtk, u8 gtk_key_len,
 	msg.body.key_info.attr.wpa.key_len = key_len;
 	msg.body.key_info.attr.wpa.seq_len = key_rsc_len;
 
-	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
+	result = wilc_enqueue_cmd(&msg);
 	if (result)
 		netdev_err(vif->ndev, "RX GTK\n");
 	else
@@ -3117,7 +2967,7 @@ int wilc_set_pmkid_info(struct wilc_vif *vif,
 		       &pmkid->pmkidlist[i].pmkid, PMKID_LEN);
 	}
 
-	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
+	result = wilc_enqueue_cmd(&msg);
 	if (result)
 		netdev_err(vif->ndev, "PMKID Info\n");
 
@@ -3135,7 +2985,7 @@ int wilc_get_mac_address(struct wilc_vif *vif, u8 *mac_addr)
 	msg.body.get_mac_info.mac_addr = mac_addr;
 	msg.vif = vif;
 
-	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
+	result = wilc_enqueue_cmd(&msg);
 	if (result) {
 		netdev_err(vif->ndev, "Failed to send get mac address\n");
 		return -EFAULT;
@@ -3199,7 +3049,7 @@ int wilc_set_join_req(struct wilc_vif *vif, u8 *bssid, const u8 *ssid,
 	if (hif_drv->hif_state < HOST_IF_CONNECTING)
 		hif_drv->hif_state = HOST_IF_CONNECTING;
 
-	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
+	result = wilc_enqueue_cmd(&msg);
 	if (result) {
 		netdev_err(vif->ndev, "send message: Set join request\n");
 		return -EFAULT;
@@ -3228,7 +3078,7 @@ int wilc_disconnect(struct wilc_vif *vif, u16 reason_code)
 	msg.id = HOST_IF_MSG_DISCONNECT;
 	msg.vif = vif;
 
-	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
+	result = wilc_enqueue_cmd(&msg);
 	if (result)
 		netdev_err(vif->ndev, "Failed to send message: disconnect\n");
 	else
@@ -3272,7 +3122,7 @@ int wilc_set_mac_chnl_num(struct wilc_vif *vif, u8 channel)
 	msg.body.channel_info.set_ch = channel;
 	msg.vif = vif;
 
-	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
+	result = wilc_enqueue_cmd(&msg);
 	if (result) {
 		netdev_err(vif->ndev, "wilc mq send fail\n");
 		return -EINVAL;
@@ -3292,7 +3142,7 @@ int wilc_set_wfi_drv_handler(struct wilc_vif *vif, int index, u8 mac_idx)
 	msg.body.drv.mac_idx = mac_idx;
 	msg.vif = vif;
 
-	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
+	result = wilc_enqueue_cmd(&msg);
 	if (result) {
 		netdev_err(vif->ndev, "wilc mq send fail\n");
 		result = -EINVAL;
@@ -3311,7 +3161,7 @@ int wilc_set_operation_mode(struct wilc_vif *vif, u32 mode)
 	msg.body.mode.mode = mode;
 	msg.vif = vif;
 
-	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
+	result = wilc_enqueue_cmd(&msg);
 	if (result) {
 		netdev_err(vif->ndev, "wilc mq send fail\n");
 		result = -EINVAL;
@@ -3338,7 +3188,7 @@ s32 wilc_get_inactive_time(struct wilc_vif *vif, const u8 *mac,
 	msg.id = HOST_IF_MSG_GET_INACTIVETIME;
 	msg.vif = vif;
 
-	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
+	result = wilc_enqueue_cmd(&msg);
 	if (result)
 		netdev_err(vif->ndev, "Failed to send get host ch param\n");
 	else
@@ -3359,7 +3209,7 @@ int wilc_get_rssi(struct wilc_vif *vif, s8 *rssi_level)
 	msg.id = HOST_IF_MSG_GET_RSSI;
 	msg.vif = vif;
 
-	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
+	result = wilc_enqueue_cmd(&msg);
 	if (result) {
 		netdev_err(vif->ndev, "Failed to send get host ch param\n");
 		return -EFAULT;
@@ -3387,7 +3237,7 @@ int wilc_get_statistics(struct wilc_vif *vif, struct rf_info *stats)
 	msg.body.data = (char *)stats;
 	msg.vif = vif;
 
-	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
+	result = wilc_enqueue_cmd(&msg);
 	if (result) {
 		netdev_err(vif->ndev, "Failed to send get host channel\n");
 		return -EFAULT;
@@ -3440,7 +3290,7 @@ int wilc_scan(struct wilc_vif *vif, u8 scan_source, u8 scan_type,
 	if (!scan_info->ies)
 		return -ENOMEM;
 
-	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
+	result = wilc_enqueue_cmd(&msg);
 	if (result) {
 		netdev_err(vif->ndev, "Error in sending message queue\n");
 		return -EINVAL;
@@ -3470,7 +3320,7 @@ int wilc_hif_set_cfg(struct wilc_vif *vif,
 	msg.body.cfg_info = *cfg_param;
 	msg.vif = vif;
 
-	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
+	result = wilc_enqueue_cmd(&msg);
 
 	return result;
 }
@@ -3532,21 +3382,17 @@ int wilc_init(struct net_device *dev, struct host_if_drv **hif_drv_handler)
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
@@ -3572,10 +3418,8 @@ int wilc_init(struct net_device *dev, struct host_if_drv **hif_drv_handler)
 
 	clients_count++;
 
-	return result;
-
 _fail_mq_:
-	wilc_mq_destroy(&hif_msg_q);
+	destroy_workqueue(hif_workqueue);
 _fail_:
 	return result;
 }
@@ -3619,13 +3463,13 @@ int wilc_deinit(struct wilc_vif *vif)
 		msg.id = HOST_IF_MSG_EXIT;
 		msg.vif = vif;
 
-		result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
+		result = wilc_enqueue_cmd(&msg);
 		if (result != 0)
 			netdev_err(vif->ndev, "deinit : Error(%d)\n", result);
 		else
 			wait_for_completion(&hif_thread_comp);
 
-		wilc_mq_destroy(&hif_msg_q);
+		destroy_workqueue(hif_workqueue);
 	}
 
 	kfree(hif_drv);
@@ -3665,7 +3509,7 @@ void wilc_network_info_received(struct wilc *wilc, u8 *pu8Buffer,
 	msg.body.net_info.buffer = kmalloc(u32Length, GFP_KERNEL);
 	memcpy(msg.body.net_info.buffer, pu8Buffer, u32Length);
 
-	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
+	result = wilc_enqueue_cmd(&msg);
 	if (result)
 		netdev_err(vif->ndev, "message parameters (%d)\n", result);
 }
@@ -3710,7 +3554,7 @@ void wilc_gnrl_async_info_received(struct wilc *wilc, u8 *pu8Buffer,
 	msg.body.async_info.buffer = kmalloc(u32Length, GFP_KERNEL);
 	memcpy(msg.body.async_info.buffer, pu8Buffer, u32Length);
 
-	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
+	result = wilc_enqueue_cmd(&msg);
 	if (result)
 		netdev_err(vif->ndev, "synchronous info (%d)\n", result);
 
@@ -3741,7 +3585,7 @@ void wilc_scan_complete_received(struct wilc *wilc, u8 *pu8Buffer,
 		msg.id = HOST_IF_MSG_RCVD_SCAN_COMPLETE;
 		msg.vif = vif;
 
-		result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
+		result = wilc_enqueue_cmd(&msg);
 		if (result)
 			netdev_err(vif->ndev, "complete param (%d)\n", result);
 	}
@@ -3767,7 +3611,7 @@ int wilc_remain_on_channel(struct wilc_vif *vif, u32 session_id,
 	msg.body.remain_on_ch.id = session_id;
 	msg.vif = vif;
 
-	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
+	result = wilc_enqueue_cmd(&msg);
 	if (result)
 		netdev_err(vif->ndev, "wilc mq send fail\n");
 
@@ -3792,7 +3636,7 @@ int wilc_listen_state_expired(struct wilc_vif *vif, u32 session_id)
 	msg.vif = vif;
 	msg.body.remain_on_ch.id = session_id;
 
-	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
+	result = wilc_enqueue_cmd(&msg);
 	if (result)
 		netdev_err(vif->ndev, "wilc mq send fail\n");
 
@@ -3823,7 +3667,7 @@ int wilc_frame_register(struct wilc_vif *vif, u16 frame_type, bool reg)
 	msg.body.reg_frame.reg = reg;
 	msg.vif = vif;
 
-	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
+	result = wilc_enqueue_cmd(&msg);
 	if (result)
 		netdev_err(vif->ndev, "wilc mq send fail\n");
 
@@ -3861,7 +3705,7 @@ int wilc_add_beacon(struct wilc_vif *vif, u32 interval, u32 dtim_period,
 		beacon_info->tail = NULL;
 	}
 
-	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
+	result = wilc_enqueue_cmd(&msg);
 	if (result)
 		netdev_err(vif->ndev, "wilc mq send fail\n");
 
@@ -3883,9 +3727,9 @@ int wilc_del_beacon(struct wilc_vif *vif)
 	msg.id = HOST_IF_MSG_DEL_BEACON;
 	msg.vif = vif;
 
-	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
+	result = wilc_enqueue_cmd(&msg);
 	if (result)
-		netdev_err(vif->ndev, "wilc_mq_send fail\n");
+		netdev_err(vif->ndev, "wilc_enqueue_cmd fail\n");
 
 	return result;
 }
@@ -3910,9 +3754,9 @@ int wilc_add_station(struct wilc_vif *vif, struct add_sta_param *sta_param)
 			return -ENOMEM;
 	}
 
-	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
+	result = wilc_enqueue_cmd(&msg);
 	if (result)
-		netdev_err(vif->ndev, "wilc_mq_send fail\n");
+		netdev_err(vif->ndev, "wilc_enqueue_cmd fail\n");
 	return result;
 }
 
@@ -3932,9 +3776,9 @@ int wilc_del_station(struct wilc_vif *vif, const u8 *mac_addr)
 	else
 		memcpy(del_sta_info->mac_addr, mac_addr, ETH_ALEN);
 
-	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
+	result = wilc_enqueue_cmd(&msg);
 	if (result)
-		netdev_err(vif->ndev, "wilc_mq_send fail\n");
+		netdev_err(vif->ndev, "wilc_enqueue_cmd fail\n");
 	return result;
 }
 
@@ -3962,10 +3806,10 @@ int wilc_del_allstation(struct wilc_vif *vif, u8 mac_addr[][ETH_ALEN])
 		return result;
 
 	del_all_sta_info->assoc_sta = assoc_sta;
-	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
+	result = wilc_enqueue_cmd(&msg);
 
 	if (result)
-		netdev_err(vif->ndev, "wilc_mq_send fail\n");
+		netdev_err(vif->ndev, "wilc_enqueue_cmd fail\n");
 	else
 		wait_for_completion(&hif_wait_response);
 
@@ -3993,9 +3837,9 @@ int wilc_edit_station(struct wilc_vif *vif,
 			return -ENOMEM;
 	}
 
-	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
+	result = wilc_enqueue_cmd(&msg);
 	if (result)
-		netdev_err(vif->ndev, "wilc_mq_send fail\n");
+		netdev_err(vif->ndev, "wilc_enqueue_cmd fail\n");
 
 	return result;
 }
@@ -4017,9 +3861,9 @@ int wilc_set_power_mgmt(struct wilc_vif *vif, bool enabled, u32 timeout)
 	pwr_mgmt_info->enabled = enabled;
 	pwr_mgmt_info->timeout = timeout;
 
-	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
+	result = wilc_enqueue_cmd(&msg);
 	if (result)
-		netdev_err(vif->ndev, "wilc_mq_send fail\n");
+		netdev_err(vif->ndev, "wilc_enqueue_cmd fail\n");
 	return result;
 }
 
@@ -4038,9 +3882,9 @@ int wilc_setup_multicast_filter(struct wilc_vif *vif, bool enabled,
 	multicast_filter_param->enabled = enabled;
 	multicast_filter_param->cnt = count;
 
-	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
+	result = wilc_enqueue_cmd(&msg);
 	if (result)
-		netdev_err(vif->ndev, "wilc_mq_send fail\n");
+		netdev_err(vif->ndev, "wilc_enqueue_cmd fail\n");
 	return result;
 }
 
@@ -4211,9 +4055,9 @@ int wilc_setup_ipaddress(struct wilc_vif *vif, u8 *ip_addr, u8 idx)
 	msg.vif = vif;
 	msg.body.ip_info.idx = idx;
 
-	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
+	result = wilc_enqueue_cmd(&msg);
 	if (result)
-		netdev_err(vif->ndev, "wilc_mq_send fail\n");
+		netdev_err(vif->ndev, "wilc_enqueue_cmd fail\n");
 
 	return result;
 }
@@ -4231,9 +4075,9 @@ static int host_int_get_ipaddress(struct wilc_vif *vif, u8 *ip_addr, u8 idx)
 	msg.vif = vif;
 	msg.body.ip_info.idx = idx;
 
-	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
+	result = wilc_enqueue_cmd(&msg);
 	if (result)
-		netdev_err(vif->ndev, "wilc_mq_send fail\n");
+		netdev_err(vif->ndev, "wilc_enqueue_cmd fail\n");
 
 	return result;
 }
@@ -4249,9 +4093,9 @@ int wilc_set_tx_power(struct wilc_vif *vif, u8 tx_power)
 	msg.body.tx_power.tx_pwr = tx_power;
 	msg.vif = vif;
 
-	ret = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
+	ret = wilc_enqueue_cmd(&msg);
 	if (ret)
-		netdev_err(vif->ndev, "wilc_mq_send fail\n");
+		netdev_err(vif->ndev, "wilc_enqueue_cmd fail\n");
 
 	return ret;
 }
@@ -4266,7 +4110,7 @@ int wilc_get_tx_power(struct wilc_vif *vif, u8 *tx_power)
 	msg.id = HOST_IF_MSG_GET_TX_POWER;
 	msg.vif = vif;
 
-	ret = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
+	ret = wilc_enqueue_cmd(&msg);
 	if (ret)
 		netdev_err(vif->ndev, "Failed to get TX PWR\n");
 
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

