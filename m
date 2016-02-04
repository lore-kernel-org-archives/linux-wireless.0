Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:9307 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752327AbcBDJXf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Feb 2016 04:23:35 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <Chris.Park@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH RESEND 07/70] staging: wilc1000: increase link speed
Date: Thu, 4 Feb 2016 18:15:24 +0900
Message-ID: <1454577387-509-8-git-send-email-glen.lee@atmel.com> (sfid-20160204_102339_955132_748D84C8)
In-Reply-To: <1454577387-509-1-git-send-email-glen.lee@atmel.com>
References: <1454577387-509-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch increases throughput by enabling tcp ack filter base on checking
statistics and also handling tcp session.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c     | 31 +++++++++++++--------------
 drivers/staging/wilc1000/wilc_wfi_netdevice.h |  2 ++
 drivers/staging/wilc1000/wilc_wlan.c          | 27 ++++++++++++++---------
 3 files changed, 34 insertions(+), 26 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 7e1b5a0..4bbf38c 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -57,6 +57,9 @@
 #define BLOCK_ACK_REQ_SIZE                      0x14
 #define FALSE_FRMWR_CHANNEL			100
 
+#define TCP_ACK_FILTER_LINK_SPEED_THRESH	54
+#define DEFAULT_LINK_SPEED			72
+
 struct cfg_param_attr {
 	struct cfg_param_val cfg_attr_info;
 };
@@ -2187,7 +2190,14 @@ static s32 Handle_GetStatistics(struct wilc_vif *vif,
 	if (result)
 		PRINT_ER("Failed to send scan paramters config packet\n");
 
-	up(&hif_sema_wait_response);
+	if (pstrStatistics->link_speed > TCP_ACK_FILTER_LINK_SPEED_THRESH &&
+	    pstrStatistics->link_speed != DEFAULT_LINK_SPEED)
+		wilc_enable_tcp_ack_filter(true);
+	else if (pstrStatistics->link_speed != DEFAULT_LINK_SPEED)
+		wilc_enable_tcp_ack_filter(false);
+
+	if (pstrStatistics != &vif->wilc->dummy_statistics)
+		up(&hif_sema_wait_response);
 	return 0;
 }
 
@@ -3606,7 +3616,8 @@ int wilc_get_statistics(struct wilc_vif *vif, struct rf_info *stats)
 		return -EFAULT;
 	}
 
-	down(&hif_sema_wait_response);
+	if (stats != &vif->wilc->dummy_statistics)
+		down(&hif_sema_wait_response);
 	return result;
 }
 
@@ -3698,21 +3709,9 @@ static void GetPeriodicRSSI(unsigned long arg)
 		return;
 	}
 
-	if (vif->hif_drv->hif_state == HOST_IF_CONNECTED) {
-		s32 result = 0;
-		struct host_if_msg msg;
-
-		memset(&msg, 0, sizeof(struct host_if_msg));
-
-		msg.id = HOST_IF_MSG_GET_RSSI;
-		msg.vif = vif;
+	if (vif->hif_drv->hif_state == HOST_IF_CONNECTED)
+		wilc_get_statistics(vif, &vif->wilc->dummy_statistics);
 
-		result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
-		if (result) {
-			PRINT_ER("Failed to send get host channel param's message queue ");
-			return;
-		}
-	}
 	periodic_rssi.data = (unsigned long)vif;
 	mod_timer(&periodic_rssi, jiffies + msecs_to_jiffies(5000));
 }
diff --git a/drivers/staging/wilc1000/wilc_wfi_netdevice.h b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
index 54e762ec..9f8c79e 100644
--- a/drivers/staging/wilc1000/wilc_wfi_netdevice.h
+++ b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
@@ -217,6 +217,8 @@ struct wilc {
 
 	struct device *dev;
 	bool suspend_event;
+
+	struct rf_info dummy_statistics;
 };
 
 struct WILC_WFI_mon_priv {
diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index 9442016..04d4c92 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -178,19 +178,21 @@ static inline int init_tcp_tracking(void)
 
 static inline int add_tcp_session(u32 src_prt, u32 dst_prt, u32 seq)
 {
-	ack_session_info[tcp_session].seq_num = seq;
-	ack_session_info[tcp_session].bigger_ack_num = 0;
-	ack_session_info[tcp_session].src_port = src_prt;
-	ack_session_info[tcp_session].dst_port = dst_prt;
-	tcp_session++;
-
+	if (tcp_session < 2 * MAX_TCP_SESSION) {
+		ack_session_info[tcp_session].seq_num = seq;
+		ack_session_info[tcp_session].bigger_ack_num = 0;
+		ack_session_info[tcp_session].src_port = src_prt;
+		ack_session_info[tcp_session].dst_port = dst_prt;
+		tcp_session++;
+	}
 	PRINT_D(TCP_ENH, "TCP Session %d to Ack %d\n", tcp_session, seq);
 	return 0;
 }
 
 static inline int update_tcp_session(u32 index, u32 ack)
 {
-	if (ack > ack_session_info[index].bigger_ack_num)
+	if (index < 2 * MAX_TCP_SESSION &&
+	    ack > ack_session_info[index].bigger_ack_num)
 		ack_session_info[index].bigger_ack_num = ack;
 	return 0;
 }
@@ -198,7 +200,7 @@ static inline int update_tcp_session(u32 index, u32 ack)
 static inline int add_tcp_pending_ack(u32 ack, u32 session_index,
 				      struct txq_entry_t *txqe)
 {
-	if (pending_acks < MAX_PENDING_ACKS) {
+	if (pending_base + pending_acks < MAX_PENDING_ACKS) {
 		pending_acks_info[pending_base + pending_acks].ack_num = ack;
 		pending_acks_info[pending_base + pending_acks].txqe = txqe;
 		pending_acks_info[pending_base + pending_acks].session_index = session_index;
@@ -265,7 +267,8 @@ static inline int tcp_process(struct net_device *dev, struct txq_entry_t *tqe)
 					 (u32)tcp_hdr_ptr[11];
 
 				for (i = 0; i < tcp_session; i++) {
-					if (ack_session_info[i].seq_num == seq_no) {
+					if (i < 2 * MAX_TCP_SESSION &&
+					    ack_session_info[i].seq_num == seq_no) {
 						update_tcp_session(i, ack_no);
 						break;
 					}
@@ -298,6 +301,9 @@ static int wilc_wlan_txq_filter_dup_tcp_ack(struct net_device *dev)
 
 	spin_lock_irqsave(&wilc->txq_spinlock, wilc->txq_spinlock_flags);
 	for (i = pending_base; i < (pending_base + pending_acks); i++) {
+		if (i >= MAX_PENDING_ACKS ||
+		    pending_acks_info[i].session_index >= 2 * MAX_TCP_SESSION)
+			break;
 		if (pending_acks_info[i].ack_num < ack_session_info[pending_acks_info[i].session_index].bigger_ack_num) {
 			struct txq_entry_t *tqe;
 
@@ -815,7 +821,8 @@ int wilc_wlan_handle_txq(struct net_device *dev, u32 *txq_count)
 				if (tqe->tx_complete_func)
 					tqe->tx_complete_func(tqe->priv,
 							      tqe->status);
-				if (tqe->tcp_pending_ack_idx != NOT_TCP_ACK)
+				if (tqe->tcp_pending_ack_idx != NOT_TCP_ACK &&
+				    tqe->tcp_pending_ack_idx < MAX_PENDING_ACKS)
 					pending_acks_info[tqe->tcp_pending_ack_idx].txqe = NULL;
 				kfree(tqe);
 			} else {
-- 
1.9.1

