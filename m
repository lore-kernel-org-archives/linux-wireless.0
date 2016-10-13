Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f65.google.com ([209.85.215.65]:34209 "EHLO
        mail-lf0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933158AbcJMQlu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 13 Oct 2016 12:41:50 -0400
Received: by mail-lf0-f65.google.com with SMTP id x23so7786467lfi.1
        for <linux-wireless@vger.kernel.org>; Thu, 13 Oct 2016 09:41:15 -0700 (PDT)
From: Erik Stromdahl <erik.stromdahl@gmail.com>
To: kvalo@qca.qualcomm.com, linux-wireless@vger.kernel.org
Cc: Erik Stromdahl <erik.stromdahl@gmail.com>
Subject: [RFC 3/5] ath6kl: Added disable credit flow ctrl for mbox
Date: Thu, 13 Oct 2016 18:39:27 +0200
Message-Id: <1476376769-4708-4-git-send-email-erik.stromdahl@gmail.com> (sfid-20161013_184202_017223_DC3897FD)
In-Reply-To: <1476376769-4708-1-git-send-email-erik.stromdahl@gmail.com>
References: <1476376769-4708-1-git-send-email-erik.stromdahl@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Added support for disabling credit flow control for htc_mbox
in a similar way as htc_pipe.

The tx_credit_flow_enabled member was moved out from the pipe
struct in struct htc_endpoint since it is now used by htc_mbox
as well.

Signed-off-by: Erik Stromdahl <erik.stromdahl@gmail.com>
---
 drivers/net/wireless/ath/ath6kl/htc.h      |  2 +-
 drivers/net/wireless/ath/ath6kl/htc_mbox.c | 18 ++++++++++++++++--
 drivers/net/wireless/ath/ath6kl/htc_pipe.c | 14 +++++++-------
 3 files changed, 24 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/htc.h b/drivers/net/wireless/ath/ath6kl/htc.h
index 112d8a9..532b13b 100644
--- a/drivers/net/wireless/ath/ath6kl/htc.h
+++ b/drivers/net/wireless/ath/ath6kl/htc.h
@@ -521,12 +521,12 @@ struct htc_endpoint {
 	u32 conn_flags;
 	struct htc_endpoint_stats ep_st;
 	u16 tx_drop_packet_threshold;
+	bool tx_credit_flow_enabled;
 
 	struct {
 		u8 pipeid_ul;
 		u8 pipeid_dl;
 		struct list_head tx_lookup_queue;
-		bool tx_credit_flow_enabled;
 	} pipe;
 };
 
diff --git a/drivers/net/wireless/ath/ath6kl/htc_mbox.c b/drivers/net/wireless/ath/ath6kl/htc_mbox.c
index 6e8c493..2c4477d 100644
--- a/drivers/net/wireless/ath/ath6kl/htc_mbox.c
+++ b/drivers/net/wireless/ath/ath6kl/htc_mbox.c
@@ -603,7 +603,7 @@ static void ath6kl_htc_tx_pkts_get(struct htc_target *target,
 				   struct htc_endpoint *endpoint,
 				   struct list_head *queue)
 {
-	int req_cred;
+	int req_cred = 0;
 	u8 flags;
 	struct htc_packet *packet;
 	unsigned int len;
@@ -623,7 +623,8 @@ static void ath6kl_htc_tx_pkts_get(struct htc_target *target,
 		len = CALC_TXRX_PADDED_LEN(target,
 					   packet->act_len + HTC_HDR_LENGTH);
 
-		if (htc_check_credits(target, endpoint, &flags,
+		if (endpoint->tx_credit_flow_enabled &&
+		    htc_check_credits(target, endpoint, &flags,
 				      packet->endpoint, len, &req_cred))
 			break;
 
@@ -2434,6 +2435,7 @@ static int ath6kl_htc_mbox_conn_service(struct htc_target *target,
 	struct htc_conn_service_msg *conn_msg;
 	struct htc_endpoint *endpoint;
 	enum htc_endpoint_id assigned_ep = ENDPOINT_MAX;
+	bool disable_credit_flowctrl = false;
 	unsigned int max_msg_sz = 0;
 	int status = 0;
 	u16 msg_id;
@@ -2459,6 +2461,10 @@ static int ath6kl_htc_mbox_conn_service(struct htc_target *target,
 		conn_msg->svc_id = cpu_to_le16(conn_req->svc_id);
 		conn_msg->conn_flags = cpu_to_le16(conn_req->conn_flags);
 
+		if (conn_req->conn_flags &
+		    HTC_CONN_FLGS_DISABLE_CRED_FLOW_CTRL)
+			disable_credit_flowctrl = true;
+
 		set_htc_pkt_info(tx_pkt, NULL, (u8 *) conn_msg,
 				 sizeof(*conn_msg) + conn_msg->svc_meta_len,
 				 ENDPOINT_0, HTC_SERVICE_TX_PACKET_TAG);
@@ -2562,6 +2568,13 @@ static int ath6kl_htc_mbox_conn_service(struct htc_target *target,
 	/* save local connection flags */
 	endpoint->conn_flags = conn_req->flags;
 
+	if (disable_credit_flowctrl && endpoint->tx_credit_flow_enabled) {
+		endpoint->tx_credit_flow_enabled = false;
+		ath6kl_dbg(ATH6KL_DBG_HTC,
+			   "SVC: 0x%4.4X ep:%d TX flow control off\n",
+			   endpoint->svc_id, assigned_ep);
+	}
+
 fail_tx:
 	if (tx_pkt)
 		htc_reclaim_txctrl_buf(target, tx_pkt);
@@ -2590,6 +2603,7 @@ static void reset_ep_state(struct htc_target *target)
 		INIT_LIST_HEAD(&endpoint->rx_bufq);
 		INIT_LIST_HEAD(&endpoint->txq);
 		endpoint->target = target;
+		endpoint->tx_credit_flow_enabled = true;
 	}
 
 	/* reset distribution list */
diff --git a/drivers/net/wireless/ath/ath6kl/htc_pipe.c b/drivers/net/wireless/ath/ath6kl/htc_pipe.c
index ca1a18c..93aac63 100644
--- a/drivers/net/wireless/ath/ath6kl/htc_pipe.c
+++ b/drivers/net/wireless/ath/ath6kl/htc_pipe.c
@@ -408,7 +408,7 @@ static enum htc_send_queue_result htc_try_send(struct htc_target *target,
 		}
 	}
 
-	if (!ep->pipe.tx_credit_flow_enabled) {
+	if (!ep->tx_credit_flow_enabled) {
 		tx_resources =
 		    ath6kl_hif_pipe_get_free_queue_number(ar,
 							  ep->pipe.pipeid_ul);
@@ -452,7 +452,7 @@ static enum htc_send_queue_result htc_try_send(struct htc_target *target,
 		if (get_queue_depth(&ep->txq) == 0)
 			break;
 
-		if (ep->pipe.tx_credit_flow_enabled) {
+		if (ep->tx_credit_flow_enabled) {
 			/*
 			 * Credit based mechanism provides flow control
 			 * based on target transmit resource availability,
@@ -482,7 +482,7 @@ static enum htc_send_queue_result htc_try_send(struct htc_target *target,
 		/* send what we can */
 		htc_issue_packets(target, ep, &send_queue);
 
-		if (!ep->pipe.tx_credit_flow_enabled) {
+		if (!ep->tx_credit_flow_enabled) {
 			pipeid = ep->pipe.pipeid_ul;
 			tx_resources =
 			    ath6kl_hif_pipe_get_free_queue_number(ar, pipeid);
@@ -768,7 +768,7 @@ static int ath6kl_htc_pipe_tx_complete(struct ath6kl *ar, struct sk_buff *skb)
 	}
 	skb = NULL;
 
-	if (!ep->pipe.tx_credit_flow_enabled) {
+	if (!ep->tx_credit_flow_enabled) {
 		/*
 		 * note: when using TX credit flow, the re-checking of queues
 		 * happens when credits flow back from the target. in the
@@ -1194,7 +1194,7 @@ static void reset_endpoint_states(struct htc_target *target)
 		INIT_LIST_HEAD(&ep->pipe.tx_lookup_queue);
 		INIT_LIST_HEAD(&ep->rx_bufq);
 		ep->target = target;
-		ep->pipe.tx_credit_flow_enabled = true;
+		ep->tx_credit_flow_enabled = true;
 	}
 }
 
@@ -1399,8 +1399,8 @@ static int ath6kl_htc_pipe_conn_service(struct htc_target *target,
 		   ep->svc_id, ep->pipe.pipeid_ul,
 		   ep->pipe.pipeid_dl, ep->eid);
 
-	if (disable_credit_flowctrl && ep->pipe.tx_credit_flow_enabled) {
-		ep->pipe.tx_credit_flow_enabled = false;
+	if (disable_credit_flowctrl && ep->tx_credit_flow_enabled) {
+		ep->tx_credit_flow_enabled = false;
 		ath6kl_dbg(ATH6KL_DBG_HTC,
 			   "SVC: 0x%4.4X ep:%d TX flow control off\n",
 			   ep->svc_id, assigned_epid);
-- 
2.1.4
