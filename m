Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh03.mail.saunalahti.fi ([62.142.5.109]:52880 "EHLO
	emh03.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751251Ab1HJHMC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Aug 2011 03:12:02 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: linux-wireless@vger.kernel.org
Cc: sfr@canb.auug.org.au, linux-next@vger.kernel.org
Subject: [PATCH] ath6kl: fix function name conflicts with ath9k
Date: Wed, 10 Aug 2011 10:11:52 +0300
Message-Id: <1312960312-7884-1-git-send-email-kvalo@qca.qualcomm.com> (sfid-20110810_091208_235657_F878F2CD)
In-Reply-To: <20110810122109.a81b3186e4131aba82a4cae0@canb.auug.org.au>
References: <20110810122109.a81b3186e4131aba82a4cae0@canb.auug.org.au>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Stepher reported that compilation fails if both ath6kl and ath9k are
compiled in:

drivers/net/wireless/ath/ath6kl/built-in.o: In function `htc_start':
(.opd+0x600): multiple definition of `htc_start'
drivers/net/wireless/ath/ath9k/built-in.o:(.opd+0x3e40): first defined here
drivers/net/wireless/ath/ath6kl/built-in.o: In function `.htc_stop':
(.text+0x7b40): multiple definition of `.htc_stop'
drivers/net/wireless/ath/ath9k/built-in.o:(.text+0x67b34): first defined he=
re
drivers/net/wireless/ath/ath6kl/built-in.o: In function `.htc_start':
(.text+0x7d18): multiple definition of `.htc_start'
drivers/net/wireless/ath/ath9k/built-in.o:(.text+0x67ba0): first defined he=
re
drivers/net/wireless/ath/ath6kl/built-in.o: In function `htc_stop':
(.opd+0x5e8): multiple definition of `htc_stop'
drivers/net/wireless/ath/ath9k/built-in.o:(.opd+0x3e28): first defined here

To fix this add ath6kl prefix to all public functions in htc.c.

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/htc.c     |   61 +++++++++++++++--------------
 drivers/net/wireless/ath/ath6kl/htc.h     |   45 +++++++++++----------
 drivers/net/wireless/ath/ath6kl/htc_hif.c |    4 +-
 drivers/net/wireless/ath/ath6kl/init.c    |   16 ++++----
 drivers/net/wireless/ath/ath6kl/main.c    |    4 +-
 drivers/net/wireless/ath/ath6kl/txrx.c    |   14 +++---
 6 files changed, 74 insertions(+), 70 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/htc.c b/drivers/net/wireless/ath/ath6kl/htc.c
index 5580e22..a8dc5c3 100644
--- a/drivers/net/wireless/ath/ath6kl/htc.c
+++ b/drivers/net/wireless/ath/ath6kl/htc.c
@@ -689,9 +689,9 @@ static int htc_setup_tx_complete(struct htc_target *target)
 	return status;
 }
 
-void htc_set_credit_dist(struct htc_target *target,
-			 struct htc_credit_state_info *cred_dist_cntxt,
-			 u16 srvc_pri_order[], int list_len)
+void ath6kl_htc_set_credit_dist(struct htc_target *target,
+				struct htc_credit_state_info *cred_dist_cntxt,
+				u16 srvc_pri_order[], int list_len)
 {
 	struct htc_endpoint *endpoint;
 	int i, ep;
@@ -717,7 +717,7 @@ void htc_set_credit_dist(struct htc_target *target,
 	}
 }
 
-int htc_tx(struct htc_target *target, struct htc_packet *packet)
+int ath6kl_htc_tx(struct htc_target *target, struct htc_packet *packet)
 {
 	struct htc_endpoint *endpoint;
 	struct list_head queue;
@@ -745,8 +745,8 @@ int htc_tx(struct htc_target *target, struct htc_packet *packet)
 }
 
 /* flush endpoint TX queue */
-void htc_flush_txep(struct htc_target *target,
-		    enum htc_endpoint_id eid, u16 tag)
+void ath6kl_htc_flush_txep(struct htc_target *target,
+			   enum htc_endpoint_id eid, u16 tag)
 {
 	struct htc_packet *packet, *tmp_pkt;
 	struct list_head discard_q, container;
@@ -785,7 +785,7 @@ void htc_flush_txep(struct htc_target *target,
 
 }
 
-static void htc_flush_txep_all(struct htc_target *target)
+static void ath6kl_htc_flush_txep_all(struct htc_target *target)
 {
 	struct htc_endpoint *endpoint;
 	int i;
@@ -797,12 +797,12 @@ static void htc_flush_txep_all(struct htc_target *target)
 		if (endpoint->svc_id == 0)
 			/* not in use.. */
 			continue;
-		htc_flush_txep(target, i, HTC_TX_PACKET_TAG_ALL);
+		ath6kl_htc_flush_txep(target, i, HTC_TX_PACKET_TAG_ALL);
 	}
 }
 
-void htc_indicate_activity_change(struct htc_target *target,
-				  enum htc_endpoint_id eid, bool active)
+void ath6kl_htc_indicate_activity_change(struct htc_target *target,
+					 enum htc_endpoint_id eid, bool active)
 {
 	struct htc_endpoint *endpoint = &target->endpoint[eid];
 	bool dist = false;
@@ -869,7 +869,7 @@ static int htc_add_rxbuf(struct htc_target *target, struct htc_packet *packet)
 
 	INIT_LIST_HEAD(&queue);
 	list_add_tail(&packet->list, &queue);
-	return htc_add_rxbuf_multiple(target, &queue);
+	return ath6kl_htc_add_rxbuf_multiple(target, &queue);
 }
 
 static void htc_reclaim_rxbuf(struct htc_target *target,
@@ -1721,8 +1721,8 @@ static int htc_fetch_rxpkts(struct htc_target *target,
 	return status;
 }
 
-int htc_rxmsg_pending_handler(struct htc_target *target, u32 msg_look_ahead[],
-			      int *num_pkts)
+int ath6kl_htc_rxmsg_pending_handler(struct htc_target *target,
+				     u32 msg_look_ahead[], int *num_pkts)
 {
 	struct htc_packet *packets, *tmp_pkt;
 	struct htc_endpoint *endpoint;
@@ -1904,8 +1904,8 @@ fail_ctrl_rx:
 	return NULL;
 }
 
-int htc_add_rxbuf_multiple(struct htc_target *target,
-			   struct list_head *pkt_queue)
+int ath6kl_htc_add_rxbuf_multiple(struct htc_target *target,
+				  struct list_head *pkt_queue)
 {
 	struct htc_endpoint *endpoint;
 	struct htc_packet *first_pkt;
@@ -1966,7 +1966,7 @@ int htc_add_rxbuf_multiple(struct htc_target *target,
 	return status;
 }
 
-void htc_flush_rx_buf(struct htc_target *target)
+void ath6kl_htc_flush_rx_buf(struct htc_target *target)
 {
 	struct htc_endpoint *endpoint;
 	struct htc_packet *packet, *tmp_pkt;
@@ -1994,9 +1994,9 @@ void htc_flush_rx_buf(struct htc_target *target)
 	}
 }
 
-int htc_conn_service(struct htc_target *target,
-		     struct htc_service_connect_req *conn_req,
-		     struct htc_service_connect_resp *conn_resp)
+int ath6kl_htc_conn_service(struct htc_target *target,
+			    struct htc_service_connect_req *conn_req,
+			    struct htc_service_connect_resp *conn_resp)
 {
 	struct htc_packet *rx_pkt = NULL;
 	struct htc_packet *tx_pkt = NULL;
@@ -2154,7 +2154,8 @@ static void reset_ep_state(struct htc_target *target)
 	INIT_LIST_HEAD(&target->cred_dist_list);
 }
 
-int htc_get_rxbuf_num(struct htc_target *target, enum htc_endpoint_id endpoint)
+int ath6kl_htc_get_rxbuf_num(struct htc_target *target,
+			     enum htc_endpoint_id endpoint)
 {
 	int num;
 
@@ -2212,7 +2213,7 @@ static void htc_setup_msg_bndl(struct htc_target *target)
 	}
 }
 
-int htc_wait_target(struct htc_target *target)
+int ath6kl_htc_wait_target(struct htc_target *target)
 {
 	struct htc_packet *packet = NULL;
 	struct htc_ready_ext_msg *rdy_msg;
@@ -2275,7 +2276,7 @@ int htc_wait_target(struct htc_target *target)
 	connect.svc_id = HTC_CTRL_RSVD_SVC;
 
 	/* connect fake service */
-	status = htc_conn_service((void *)target, &connect, &resp);
+	status = ath6kl_htc_conn_service((void *)target, &connect, &resp);
 
 	if (status)
 		ath6kl_hif_cleanup_scatter(target->dev->ar);
@@ -2293,7 +2294,7 @@ fail_wait_target:
  * Start HTC, enable interrupts and let the target know
  * host has finished setup.
  */
-int htc_start(struct htc_target *target)
+int ath6kl_htc_start(struct htc_target *target)
 {
 	struct htc_packet *packet;
 	int status;
@@ -2327,13 +2328,13 @@ int htc_start(struct htc_target *target)
 	status = ath6kldev_unmask_intrs(target->dev);
 
 	if (status)
-		htc_stop(target);
+		ath6kl_htc_stop(target);
 
 	return status;
 }
 
 /* htc_stop: stop interrupt reception, and flush all queued buffers */
-void htc_stop(struct htc_target *target)
+void ath6kl_htc_stop(struct htc_target *target)
 {
 	spin_lock_bh(&target->htc_lock);
 	target->htc_flags |= HTC_OP_STATE_STOPPING;
@@ -2346,14 +2347,14 @@ void htc_stop(struct htc_target *target)
 	 */
 	ath6kldev_mask_intrs(target->dev);
 
-	htc_flush_txep_all(target);
+	ath6kl_htc_flush_txep_all(target);
 
-	htc_flush_rx_buf(target);
+	ath6kl_htc_flush_rx_buf(target);
 
 	reset_ep_state(target);
 }
 
-void *htc_create(struct ath6kl *ar)
+void *ath6kl_htc_create(struct ath6kl *ar)
 {
 	struct htc_target *target = NULL;
 	struct htc_packet *packet;
@@ -2422,7 +2423,7 @@ void *htc_create(struct ath6kl *ar)
 fail_create_htc:
 	if (i != NUM_CONTROL_BUFFERS || status) {
 		if (target) {
-			htc_cleanup(target);
+			ath6kl_htc_cleanup(target);
 			target = NULL;
 		}
 	}
@@ -2431,7 +2432,7 @@ fail_create_htc:
 }
 
 /* cleanup the HTC instance */
-void htc_cleanup(struct htc_target *target)
+void ath6kl_htc_cleanup(struct htc_target *target)
 {
 	struct htc_packet *packet, *tmp_packet;
 
diff --git a/drivers/net/wireless/ath/ath6kl/htc.h b/drivers/net/wireless/ath/ath6kl/htc.h
index d844d36..8ce0c2c 100644
--- a/drivers/net/wireless/ath/ath6kl/htc.h
+++ b/drivers/net/wireless/ath/ath6kl/htc.h
@@ -540,27 +540,30 @@ struct htc_target {
 	int chk_irq_status_cnt;
 };
 
-void *htc_create(struct ath6kl *ar);
-void htc_set_credit_dist(struct htc_target *target,
-			 struct htc_credit_state_info *cred_info,
-			  u16 svc_pri_order[], int len);
-int htc_wait_target(struct htc_target *target);
-int htc_start(struct htc_target *target);
-int htc_conn_service(struct htc_target *target,
-		     struct htc_service_connect_req *req,
-		     struct htc_service_connect_resp *resp);
-int htc_tx(struct htc_target *target, struct htc_packet *packet);
-void htc_stop(struct htc_target *target);
-void htc_cleanup(struct htc_target *target);
-void htc_flush_txep(struct htc_target *target,
-		    enum htc_endpoint_id endpoint, u16 tag);
-void htc_flush_rx_buf(struct htc_target *target);
-void htc_indicate_activity_change(struct htc_target *target,
-				  enum htc_endpoint_id endpoint, bool active);
-int htc_get_rxbuf_num(struct htc_target *target, enum htc_endpoint_id endpoint);
-int htc_add_rxbuf_multiple(struct htc_target *target, struct list_head *pktq);
-int htc_rxmsg_pending_handler(struct htc_target *target, u32 msg_look_ahead[],
-			      int *n_pkts);
+void *ath6kl_htc_create(struct ath6kl *ar);
+void ath6kl_htc_set_credit_dist(struct htc_target *target,
+				struct htc_credit_state_info *cred_info,
+				u16 svc_pri_order[], int len);
+int ath6kl_htc_wait_target(struct htc_target *target);
+int ath6kl_htc_start(struct htc_target *target);
+int ath6kl_htc_conn_service(struct htc_target *target,
+			    struct htc_service_connect_req *req,
+			    struct htc_service_connect_resp *resp);
+int ath6kl_htc_tx(struct htc_target *target, struct htc_packet *packet);
+void ath6kl_htc_stop(struct htc_target *target);
+void ath6kl_htc_cleanup(struct htc_target *target);
+void ath6kl_htc_flush_txep(struct htc_target *target,
+			   enum htc_endpoint_id endpoint, u16 tag);
+void ath6kl_htc_flush_rx_buf(struct htc_target *target);
+void ath6kl_htc_indicate_activity_change(struct htc_target *target,
+					 enum htc_endpoint_id endpoint,
+					 bool active);
+int ath6kl_htc_get_rxbuf_num(struct htc_target *target,
+			     enum htc_endpoint_id endpoint);
+int ath6kl_htc_add_rxbuf_multiple(struct htc_target *target,
+				  struct list_head *pktq);
+int ath6kl_htc_rxmsg_pending_handler(struct htc_target *target,
+				     u32 msg_look_ahead[], int *n_pkts);
 
 static inline void set_htc_pkt_info(struct htc_packet *packet, void *context,
 				    u8 *buf, unsigned int len,
diff --git a/drivers/net/wireless/ath/ath6kl/htc_hif.c b/drivers/net/wireless/ath/ath6kl/htc_hif.c
index 5d397b5..86b1cc7 100644
--- a/drivers/net/wireless/ath/ath6kl/htc_hif.c
+++ b/drivers/net/wireless/ath/ath6kl/htc_hif.c
@@ -416,8 +416,8 @@ static int proc_pending_irqs(struct ath6kl_device *dev, bool *done)
 		 * improve performance by reducing context switching when
 		 * we rapidly pull packets.
 		 */
-		status = htc_rxmsg_pending_handler(dev->htc_cnxt,
-						   &lk_ahd, &fetched);
+		status = ath6kl_htc_rxmsg_pending_handler(dev->htc_cnxt,
+							  &lk_ahd, &fetched);
 		if (status)
 			goto out;
 
diff --git a/drivers/net/wireless/ath/ath6kl/init.c b/drivers/net/wireless/ath/ath6kl/init.c
index 99ff2f9..9d10322 100644
--- a/drivers/net/wireless/ath/ath6kl/init.c
+++ b/drivers/net/wireless/ath/ath6kl/init.c
@@ -160,7 +160,7 @@ static int ath6kl_connectservice(struct ath6kl *ar,
 
 	memset(&response, 0, sizeof(response));
 
-	status = htc_conn_service(ar->htc_target, con_req, &response);
+	status = ath6kl_htc_conn_service(ar->htc_target, con_req, &response);
 	if (status) {
 		ath6kl_err("failed to connect to %s service status:%d\n",
 			   desc, status);
@@ -1069,7 +1069,7 @@ static int ath6kl_init(struct net_device *dev)
 	 * driver layer has to init BMI in order to set the host block
 	 * size.
 	 */
-	if (htc_wait_target(ar->htc_target)) {
+	if (ath6kl_htc_wait_target(ar->htc_target)) {
 		status = -EIO;
 		goto err_node_cleanup;
 	}
@@ -1098,7 +1098,7 @@ static int ath6kl_init(struct net_device *dev)
 	ath6kl_cookie_init(ar);
 
 	/* start HTC */
-	status = htc_start(ar->htc_target);
+	status = ath6kl_htc_start(ar->htc_target);
 
 	if (status) {
 		ath6kl_cookie_cleanup(ar);
@@ -1138,9 +1138,9 @@ static int ath6kl_init(struct net_device *dev)
 		goto ath6kl_init_done;
 
 err_htc_stop:
-	htc_stop(ar->htc_target);
+	ath6kl_htc_stop(ar->htc_target);
 err_rxbuf_cleanup:
-	htc_flush_rx_buf(ar->htc_target);
+	ath6kl_htc_flush_rx_buf(ar->htc_target);
 	ath6kl_cleanup_amsdu_rxbufs(ar);
 err_cleanup_scatter:
 	ath6kl_hif_cleanup_scatter(ar);
@@ -1179,7 +1179,7 @@ int ath6kl_core_init(struct ath6kl *ar)
 	if (ret)
 		goto err_bmi_cleanup;
 
-	ar->htc_target = htc_create(ar);
+	ar->htc_target = ath6kl_htc_create(ar);
 
 	if (!ar->htc_target) {
 		ret = -ENOMEM;
@@ -1217,7 +1217,7 @@ int ath6kl_core_init(struct ath6kl *ar)
 	return ret;
 
 err_htc_cleanup:
-	htc_cleanup(ar->htc_target);
+	ath6kl_htc_cleanup(ar->htc_target);
 err_bmi_cleanup:
 	ath6kl_bmi_cleanup(ar);
 err_wq:
@@ -1275,7 +1275,7 @@ void ath6kl_destroy(struct net_device *dev, unsigned int unregister)
 	destroy_workqueue(ar->ath6kl_wq);
 
 	if (ar->htc_target)
-		htc_cleanup(ar->htc_target);
+		ath6kl_htc_cleanup(ar->htc_target);
 
 	aggr_module_destroy(ar->aggr_cntxt);
 
diff --git a/drivers/net/wireless/ath/ath6kl/main.c b/drivers/net/wireless/ath/ath6kl/main.c
index 284e3e9..c336eae 100644
--- a/drivers/net/wireless/ath/ath6kl/main.c
+++ b/drivers/net/wireless/ath/ath6kl/main.c
@@ -375,7 +375,7 @@ void ath6kl_stop_endpoint(struct net_device *dev, bool keep_profile,
 
 	if (ar->htc_target) {
 		ath6kl_dbg(ATH6KL_DBG_TRC, "%s: shut down htc\n", __func__);
-		htc_stop(ar->htc_target);
+		ath6kl_htc_stop(ar->htc_target);
 	}
 
 	/*
@@ -568,7 +568,7 @@ int ath6k_setup_credit_dist(void *htc_handle,
 	servicepriority[4] = WMI_DATA_BK_SVC; /* lowest */
 
 	/* set priority list */
-	htc_set_credit_dist(htc_handle, cred_info, servicepriority, 5);
+	ath6kl_htc_set_credit_dist(htc_handle, cred_info, servicepriority, 5);
 
 	return 0;
 }
diff --git a/drivers/net/wireless/ath/ath6kl/txrx.c b/drivers/net/wireless/ath/ath6kl/txrx.c
index 0cab1c1..167bdb9 100644
--- a/drivers/net/wireless/ath/ath6kl/txrx.c
+++ b/drivers/net/wireless/ath/ath6kl/txrx.c
@@ -221,7 +221,7 @@ int ath6kl_control_tx(void *devt, struct sk_buff *skb,
 	 * This interface is asynchronous, if there is an error, cleanup
 	 * will happen in the TX completion callback.
 	 */
-	htc_tx(ar->htc_target, &cookie->htc_pkt);
+	ath6kl_htc_tx(ar->htc_target, &cookie->htc_pkt);
 
 	return 0;
 
@@ -331,7 +331,7 @@ int ath6kl_data_tx(struct sk_buff *skb, struct net_device *dev)
 	 * HTC interface is asynchronous, if this fails, cleanup will
 	 * happen in the ath6kl_tx_complete callback.
 	 */
-	htc_tx(ar->htc_target, &cookie->htc_pkt);
+	ath6kl_htc_tx(ar->htc_target, &cookie->htc_pkt);
 
 	return 0;
 
@@ -403,7 +403,7 @@ void ath6kl_indicate_tx_activity(void *devt, u8 traffic_class, bool active)
 
 notify_htc:
 	/* notify HTC, this may cause credit distribution changes */
-	htc_indicate_activity_change(ar->htc_target, eid, active);
+	ath6kl_htc_indicate_activity_change(ar->htc_target, eid, active);
 }
 
 enum htc_send_full_action ath6kl_tx_queue_full(struct htc_target *target,
@@ -611,8 +611,8 @@ void ath6kl_tx_data_cleanup(struct ath6kl *ar)
 
 	/* flush all the data (non-control) streams */
 	for (i = 0; i < WMM_NUM_AC; i++)
-		htc_flush_txep(ar->htc_target, ar->ac2ep_map[i],
-				 ATH6KL_DATA_PKT_TAG);
+		ath6kl_htc_flush_txep(ar->htc_target, ar->ac2ep_map[i],
+				      ATH6KL_DATA_PKT_TAG);
 }
 
 /* Rx functions */
@@ -672,7 +672,7 @@ void ath6kl_rx_refill(struct htc_target *target, enum htc_endpoint_id endpoint)
 	struct list_head queue;
 
 	n_buf_refill = ATH6KL_MAX_RX_BUFFERS -
-			  htc_get_rxbuf_num(ar->htc_target, endpoint);
+			  ath6kl_htc_get_rxbuf_num(ar->htc_target, endpoint);
 
 	if (n_buf_refill <= 0)
 		return;
@@ -695,7 +695,7 @@ void ath6kl_rx_refill(struct htc_target *target, enum htc_endpoint_id endpoint)
 	}
 
 	if (!list_empty(&queue))
-		htc_add_rxbuf_multiple(ar->htc_target, &queue);
+		ath6kl_htc_add_rxbuf_multiple(ar->htc_target, &queue);
 }
 
 void ath6kl_refill_amsdu_rxbufs(struct ath6kl *ar, int count)
-- 
1.7.1

