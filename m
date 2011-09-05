Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh04.mail.saunalahti.fi ([62.142.5.110]:59459 "EHLO
	emh04.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750918Ab1IEIJr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Sep 2011 04:09:47 -0400
Received: from saunalahti-vams (vs3-11.mail.saunalahti.fi [62.142.5.95])
	by emh04-2.mail.saunalahti.fi (Postfix) with SMTP id 3FBA213B8C2
	for <linux-wireless@vger.kernel.org>; Mon,  5 Sep 2011 11:09:44 +0300 (EEST)
Received: from localhost6.localdomain6 (a88-115-188-95.elisa-laajakaista.fi [88.115.188.95])
	by emh03.mail.saunalahti.fi (Postfix) with ESMTP id 13E32158A6E
	for <linux-wireless@vger.kernel.org>; Mon,  5 Sep 2011 11:09:40 +0300 (EEST)
Subject: [PATCH 1/2] ath6kl: unify tx function names in htc.c
To: linux-wireless@vger.kernel.org
From: Kalle Valo <kvalo@qca.qualcomm.com>
Date: Mon, 05 Sep 2011 11:09:39 +0300
Message-ID: <20110905080939.1573.60815.stgit@localhost6.localdomain6> (sfid-20110905_100950_464427_59D75C03)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is to make it easier follow tx code path inside htc.No functional
changes.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/htc.c |   87 +++++++++++++++++----------------
 1 files changed, 44 insertions(+), 43 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/htc.c b/drivers/net/wireless/ath/ath6kl/htc.c
index 77e548c..46c6efb 100644
--- a/drivers/net/wireless/ath/ath6kl/htc.c
+++ b/drivers/net/wireless/ath/ath6kl/htc.c
@@ -22,7 +22,7 @@
 
 #define CALC_TXRX_PADDED_LEN(dev, len)  (__ALIGN_MASK((len), (dev)->block_mask))
 
-static void ath6kl_htc_buf_align(u8 **buf, unsigned long len)
+static void ath6kl_htc_tx_buf_align(u8 **buf, unsigned long len)
 {
 	u8 *align_addr;
 
@@ -33,8 +33,8 @@ static void ath6kl_htc_buf_align(u8 **buf, unsigned long len)
 	}
 }
 
-static void htc_prep_send_pkt(struct htc_packet *packet, u8 flags, int ctrl0,
-			      int ctrl1)
+static void ath6kl_htc_tx_prep_pkt(struct htc_packet *packet, u8 flags,
+				   int ctrl0, int ctrl1)
 {
 	struct htc_frame_hdr *hdr;
 
@@ -178,7 +178,8 @@ static void htc_async_tx_scat_complete(struct htc_target *target,
 	htc_tx_complete(endpoint, &tx_compq);
 }
 
-static int htc_issue_send(struct htc_target *target, struct htc_packet *packet)
+static int ath6kl_htc_tx_issue(struct htc_target *target,
+			       struct htc_packet *packet)
 {
 	int status;
 	bool sync = false;
@@ -276,9 +277,9 @@ static int htc_check_credits(struct htc_target *target,
 	return 0;
 }
 
-static void htc_tx_pkts_get(struct htc_target *target,
-			    struct htc_endpoint *endpoint,
-			    struct list_head *queue)
+static void ath6kl_htc_tx_pkts_get(struct htc_target *target,
+				   struct htc_endpoint *endpoint,
+				   struct list_head *queue)
 {
 	int req_cred;
 	u8 flags;
@@ -357,11 +358,11 @@ static int htc_get_credit_padding(unsigned int cred_sz, int *len,
 	return cred_pad;
 }
 
-static int htc_setup_send_scat_list(struct htc_target *target,
-				    struct htc_endpoint *endpoint,
-				    struct hif_scatter_req *scat_req,
-				    int n_scat,
-				    struct list_head *queue)
+static int ath6kl_htc_tx_setup_scat_list(struct htc_target *target,
+					 struct htc_endpoint *endpoint,
+					 struct hif_scatter_req *scat_req,
+					 int n_scat,
+					 struct list_head *queue)
 {
 	struct htc_packet *packet;
 	int i, len, rem_scat, cred_pad;
@@ -393,12 +394,12 @@ static int htc_setup_send_scat_list(struct htc_target *target,
 
 		scat_req->scat_list[i].packet = packet;
 		/* prepare packet and flag message as part of a send bundle */
-		htc_prep_send_pkt(packet,
+		ath6kl_htc_tx_prep_pkt(packet,
 				packet->info.tx.flags | HTC_FLAGS_SEND_BUNDLE,
 				cred_pad, packet->info.tx.seqno);
 		/* Make sure the buffer is 4-byte aligned */
-		ath6kl_htc_buf_align(&packet->buf,
-				     packet->act_len + HTC_HDR_LENGTH);
+		ath6kl_htc_tx_buf_align(&packet->buf,
+					packet->act_len + HTC_HDR_LENGTH);
 		scat_req->scat_list[i].buf = packet->buf;
 		scat_req->scat_list[i].len = len;
 
@@ -425,18 +426,17 @@ static int htc_setup_send_scat_list(struct htc_target *target,
 }
 
 /*
- * htc_issue_send_bundle: drain a queue and send as bundles
- * this function may return without fully draining the queue
- * when
+ * Drain a queue and send as bundles this function may return without fully
+ * draining the queue when
  *
  *    1. scatter resources are exhausted
  *    2. a message that will consume a partial credit will stop the
  *    bundling process early
  *    3. we drop below the minimum number of messages for a bundle
  */
-static void htc_issue_send_bundle(struct htc_endpoint *endpoint,
-				  struct list_head *queue,
-				  int *sent_bundle, int *n_bundle_pkts)
+static void ath6kl_htc_tx_bundle(struct htc_endpoint *endpoint,
+				 struct list_head *queue,
+				 int *sent_bundle, int *n_bundle_pkts)
 {
 	struct htc_target *target = endpoint->target;
 	struct hif_scatter_req *scat_req = NULL;
@@ -467,8 +467,9 @@ static void htc_issue_send_bundle(struct htc_endpoint *endpoint,
 		scat_req->len = 0;
 		scat_req->scat_entries = 0;
 
-		status = htc_setup_send_scat_list(target, endpoint,
-						  scat_req, n_scat, queue);
+		status = ath6kl_htc_tx_setup_scat_list(target, endpoint,
+						       scat_req, n_scat,
+						       queue);
 		if (status == -EAGAIN) {
 			hif_scatter_req_add(target->dev->ar, scat_req);
 			break;
@@ -490,14 +491,14 @@ static void htc_issue_send_bundle(struct htc_endpoint *endpoint,
 
 	*sent_bundle = n_sent_bundle;
 	*n_bundle_pkts = tot_pkts_bundle;
-	ath6kl_dbg(ATH6KL_DBG_HTC_SEND, "htc_issue_send_bundle (sent:%d)\n",
-		   n_sent_bundle);
+	ath6kl_dbg(ATH6KL_DBG_HTC_SEND, "%s (sent:%d)\n",
+		   __func__, n_sent_bundle);
 
 	return;
 }
 
-static void htc_tx_from_ep_txq(struct htc_target *target,
-			       struct htc_endpoint *endpoint)
+static void ath6kl_htc_tx_from_queue(struct htc_target *target,
+				     struct htc_endpoint *endpoint)
 {
 	struct list_head txq;
 	struct htc_packet *packet;
@@ -525,7 +526,7 @@ static void htc_tx_from_ep_txq(struct htc_target *target,
 		if (list_empty(&endpoint->txq))
 			break;
 
-		htc_tx_pkts_get(target, endpoint, &txq);
+		ath6kl_htc_tx_pkts_get(target, endpoint, &txq);
 
 		if (list_empty(&txq))
 			break;
@@ -542,8 +543,8 @@ static void htc_tx_from_ep_txq(struct htc_target *target,
 			    HTC_MIN_HTC_MSGS_TO_BUNDLE)) {
 				int temp1 = 0, temp2 = 0;
 
-				htc_issue_send_bundle(endpoint, &txq,
-						      &temp1, &temp2);
+				ath6kl_htc_tx_bundle(endpoint, &txq,
+						     &temp1, &temp2);
 				bundle_sent += temp1;
 				n_pkts_bundle += temp2;
 			}
@@ -555,9 +556,9 @@ static void htc_tx_from_ep_txq(struct htc_target *target,
 						  list);
 			list_del(&packet->list);
 
-			htc_prep_send_pkt(packet, packet->info.tx.flags,
-					  0, packet->info.tx.seqno);
-			htc_issue_send(target, packet);
+			ath6kl_htc_tx_prep_pkt(packet, packet->info.tx.flags,
+					       0, packet->info.tx.seqno);
+			ath6kl_htc_tx_issue(target, packet);
 		}
 
 		spin_lock_bh(&target->tx_lock);
@@ -570,9 +571,9 @@ static void htc_tx_from_ep_txq(struct htc_target *target,
 	spin_unlock_bh(&target->tx_lock);
 }
 
-static bool htc_try_send(struct htc_target *target,
-			 struct htc_endpoint *endpoint,
-			 struct htc_packet *tx_pkt)
+static bool ath6kl_htc_tx_try(struct htc_target *target,
+			      struct htc_endpoint *endpoint,
+			      struct htc_packet *tx_pkt)
 {
 	struct htc_ep_callbacks ep_cb;
 	int txq_depth;
@@ -608,7 +609,7 @@ static bool htc_try_send(struct htc_target *target,
 	list_add_tail(&tx_pkt->list, &endpoint->txq);
 	spin_unlock_bh(&target->tx_lock);
 
-	htc_tx_from_ep_txq(target, endpoint);
+	ath6kl_htc_tx_from_queue(target, endpoint);
 
 	return true;
 }
@@ -642,7 +643,7 @@ static void htc_chk_ep_txq(struct htc_target *target)
 			 * chance to reclaim credits from lower priority
 			 * ones.
 			 */
-			htc_tx_from_ep_txq(target, endpoint);
+			ath6kl_htc_tx_from_queue(target, endpoint);
 			spin_lock_bh(&target->tx_lock);
 		}
 		spin_unlock_bh(&target->tx_lock);
@@ -694,8 +695,8 @@ static int htc_setup_tx_complete(struct htc_target *target)
 
 	/* we want synchronous operation */
 	send_pkt->completion = NULL;
-	htc_prep_send_pkt(send_pkt, 0, 0, 0);
-	status = htc_issue_send(target, send_pkt);
+	ath6kl_htc_tx_prep_pkt(send_pkt, 0, 0, 0);
+	status = ath6kl_htc_tx_issue(target, send_pkt);
 
 	if (send_pkt != NULL)
 		htc_reclaim_txctrl_buf(target, send_pkt);
@@ -747,7 +748,7 @@ int ath6kl_htc_tx(struct htc_target *target, struct htc_packet *packet)
 
 	endpoint = &target->endpoint[packet->endpoint];
 
-	if (!htc_try_send(target, endpoint, packet)) {
+	if (!ath6kl_htc_tx_try(target, endpoint, packet)) {
 		packet->status = (target->htc_flags & HTC_OP_STATE_STOPPING) ?
 				 -ECANCELED : -ENOSPC;
 		INIT_LIST_HEAD(&queue);
@@ -2048,8 +2049,8 @@ int ath6kl_htc_conn_service(struct htc_target *target,
 
 		/* we want synchronous operation */
 		tx_pkt->completion = NULL;
-		htc_prep_send_pkt(tx_pkt, 0, 0, 0);
-		status = htc_issue_send(target, tx_pkt);
+		ath6kl_htc_tx_prep_pkt(tx_pkt, 0, 0, 0);
+		status = ath6kl_htc_tx_issue(target, tx_pkt);
 
 		if (status)
 			goto fail_tx;

