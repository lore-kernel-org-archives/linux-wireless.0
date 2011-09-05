Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh03.mail.saunalahti.fi ([62.142.5.109]:55421 "EHLO
	emh03.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750918Ab1IEIJ5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Sep 2011 04:09:57 -0400
Received: from saunalahti-vams (vs3-11.mail.saunalahti.fi [62.142.5.95])
	by emh03-2.mail.saunalahti.fi (Postfix) with SMTP id 1EE8CEBE54
	for <linux-wireless@vger.kernel.org>; Mon,  5 Sep 2011 11:09:53 +0300 (EEST)
Received: from localhost6.localdomain6 (a88-115-188-95.elisa-laajakaista.fi [88.115.188.95])
	by emh02.mail.saunalahti.fi (Postfix) with ESMTP id D32362BD47
	for <linux-wireless@vger.kernel.org>; Mon,  5 Sep 2011 11:09:49 +0300 (EEST)
Subject: [PATCH 2/2] ath6kl: unify rx function naming in htc.c
To: linux-wireless@vger.kernel.org
From: Kalle Valo <kvalo@qca.qualcomm.com>
Date: Mon, 05 Sep 2011 11:09:49 +0300
Message-ID: <20110905080949.1573.76688.stgit@localhost6.localdomain6> (sfid-20110905_100959_895372_54FEEEE8)
In-Reply-To: <20110905080939.1573.60815.stgit@localhost6.localdomain6>
References: <20110905080939.1573.60815.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Similarly like with the tx path, unify naming in htc rx path. No functional
changes.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/htc.c |  126 +++++++++++++++++----------------
 1 files changed, 66 insertions(+), 60 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/htc.c b/drivers/net/wireless/ath/ath6kl/htc.c
index 46c6efb..9aa2e44 100644
--- a/drivers/net/wireless/ath/ath6kl/htc.c
+++ b/drivers/net/wireless/ath/ath6kl/htc.c
@@ -861,8 +861,8 @@ void ath6kl_htc_indicate_activity_change(struct htc_target *target,
 
 /* HTC Rx */
 
-static inline void htc_update_rx_stats(struct htc_endpoint *endpoint,
-				       int n_look_ahds)
+static inline void ath6kl_htc_rx_update_stats(struct htc_endpoint *endpoint,
+					      int n_look_ahds)
 {
 	endpoint->ep_st.rx_pkts++;
 	if (n_look_ahds == 1)
@@ -909,8 +909,9 @@ static void reclaim_rx_ctrl_buf(struct htc_target *target,
 	spin_unlock_bh(&target->htc_lock);
 }
 
-static int dev_rx_pkt(struct htc_target *target, struct htc_packet *packet,
-		      u32 rx_len)
+static int ath6kl_htc_rx_packet(struct htc_target *target,
+				struct htc_packet *packet,
+				u32 rx_len)
 {
 	struct ath6kl_device *dev = target->dev;
 	u32 padded_len;
@@ -944,9 +945,9 @@ static int dev_rx_pkt(struct htc_target *target, struct htc_packet *packet,
  * "hint" that there are more  single-packets to fetch
  * on this endpoint.
  */
-static void set_rxpkt_indication_flag(u32 lk_ahd,
-				      struct htc_endpoint *endpoint,
-				      struct htc_packet *packet)
+static void ath6kl_htc_rx_set_indicate(u32 lk_ahd,
+				       struct htc_endpoint *endpoint,
+				       struct htc_packet *packet)
 {
 	struct htc_frame_hdr *htc_hdr = (struct htc_frame_hdr *)&lk_ahd;
 
@@ -957,7 +958,7 @@ static void set_rxpkt_indication_flag(u32 lk_ahd,
 	}
 }
 
-static void chk_rx_water_mark(struct htc_endpoint *endpoint)
+static void ath6kl_htc_rx_chk_water_mark(struct htc_endpoint *endpoint)
 {
 	struct htc_ep_callbacks ep_cb = endpoint->ep_cb;
 
@@ -974,8 +975,9 @@ static void chk_rx_water_mark(struct htc_endpoint *endpoint)
 }
 
 /* This function is called with rx_lock held */
-static int htc_setup_rxpkts(struct htc_target *target, struct htc_endpoint *ep,
-			    u32 *lk_ahds, struct list_head *queue, int n_msg)
+static int ath6kl_htc_rx_setup(struct htc_target *target,
+			       struct htc_endpoint *ep,
+			       u32 *lk_ahds, struct list_head *queue, int n_msg)
 {
 	struct htc_packet *packet;
 	/* FIXME: type of lk_ahds can't be right */
@@ -1075,10 +1077,10 @@ static int htc_setup_rxpkts(struct htc_target *target, struct htc_endpoint *ep,
 	return status;
 }
 
-static int alloc_and_prep_rxpkts(struct htc_target *target,
-				 u32 lk_ahds[], int msg,
-				 struct htc_endpoint *endpoint,
-				 struct list_head *queue)
+static int ath6kl_htc_rx_alloc(struct htc_target *target,
+			       u32 lk_ahds[], int msg,
+			       struct htc_endpoint *endpoint,
+			       struct list_head *queue)
 {
 	int status = 0;
 	struct htc_packet *packet, *tmp_pkt;
@@ -1144,8 +1146,8 @@ static int alloc_and_prep_rxpkts(struct htc_target *target,
 			n_msg = 1;
 
 		/* Setup packet buffers for each message */
-		status = htc_setup_rxpkts(target, endpoint, &lk_ahds[i], queue,
-					  n_msg);
+		status = ath6kl_htc_rx_setup(target, endpoint, &lk_ahds[i],
+					     queue, n_msg);
 
 		/*
 		 * This is due to unavailabilty of buffers to rx entire data.
@@ -1422,9 +1424,9 @@ static int htc_proc_trailer(struct htc_target *target,
 	return status;
 }
 
-static int htc_proc_rxhdr(struct htc_target *target,
-			  struct htc_packet *packet,
-			  u32 *next_lkahds, int *n_lkahds)
+static int ath6kl_htc_rx_process_hdr(struct htc_target *target,
+				     struct htc_packet *packet,
+				     u32 *next_lkahds, int *n_lkahds)
 {
 	int status = 0;
 	u16 payload_len;
@@ -1476,8 +1478,8 @@ static int htc_proc_rxhdr(struct htc_target *target,
 	}
 
 	if (lk_ahd != packet->info.rx.exp_hdr) {
-		ath6kl_err("htc_proc_rxhdr, lk_ahd mismatch! (pPkt:0x%p flags:0x%X)\n",
-			   packet, packet->info.rx.rx_flags);
+		ath6kl_err("%s(): lk_ahd mismatch! (pPkt:0x%p flags:0x%X)\n",
+			   __func__, packet, packet->info.rx.rx_flags);
 		ath6kl_dbg_dump(ATH6KL_DBG_RAW_BYTES, "Expected Message lk_ahd",
 				&packet->info.rx.exp_hdr, 4);
 		ath6kl_dbg_dump(ATH6KL_DBG_RAW_BYTES, "Current Frame Header",
@@ -1489,8 +1491,8 @@ static int htc_proc_rxhdr(struct htc_target *target,
 	if (htc_hdr->flags & HTC_FLG_RX_TRAILER) {
 		if (htc_hdr->ctrl[0] < sizeof(struct htc_record_hdr) ||
 		    htc_hdr->ctrl[0] > payload_len) {
-			ath6kl_err("htc_proc_rxhdr, invalid hdr (payload len should be :%d, CB[0] is:%d)\n",
-				   payload_len, htc_hdr->ctrl[0]);
+			ath6kl_err("%s(): invalid hdr (payload len should be :%d, CB[0] is:%d)\n",
+				   __func__, payload_len, htc_hdr->ctrl[0]);
 			status = -ENOMEM;
 			goto fail_rx;
 		}
@@ -1529,8 +1531,8 @@ fail_rx:
 	return status;
 }
 
-static void do_rx_completion(struct htc_endpoint *endpoint,
-			     struct htc_packet *packet)
+static void ath6kl_htc_rx_complete(struct htc_endpoint *endpoint,
+				   struct htc_packet *packet)
 {
 		ath6kl_dbg(ATH6KL_DBG_HTC_RECV,
 			   "htc calling ep %d recv callback on packet 0x%p\n",
@@ -1538,10 +1540,10 @@ static void do_rx_completion(struct htc_endpoint *endpoint,
 		endpoint->ep_cb.rx(endpoint->target, packet);
 }
 
-static int htc_issue_rxpkt_bundle(struct htc_target *target,
-				  struct list_head *rxq,
-				  struct list_head *sync_compq,
-				  int *n_pkt_fetched, bool part_bundle)
+static int ath6kl_htc_rx_bundle(struct htc_target *target,
+				struct list_head *rxq,
+				struct list_head *sync_compq,
+				int *n_pkt_fetched, bool part_bundle)
 {
 	struct hif_scatter_req *scat_req;
 	struct htc_packet *packet;
@@ -1563,15 +1565,15 @@ static int htc_issue_rxpkt_bundle(struct htc_target *target,
 		 * This would only happen if the target ignored our max
 		 * bundle limit.
 		 */
-		ath6kl_warn("htc_issue_rxpkt_bundle : partial bundle detected num:%d , %d\n",
-			    get_queue_depth(rxq), n_scat_pkt);
+		ath6kl_warn("%s(): partial bundle detected num:%d , %d\n",
+			    __func__, get_queue_depth(rxq), n_scat_pkt);
 	}
 
 	len = 0;
 
 	ath6kl_dbg(ATH6KL_DBG_HTC_RECV,
-		"htc_issue_rxpkt_bundle (numpackets: %d , actual : %d)\n",
-		get_queue_depth(rxq), n_scat_pkt);
+		   "%s(): (numpackets: %d , actual : %d)\n",
+		   __func__, get_queue_depth(rxq), n_scat_pkt);
 
 	scat_req = hif_scatter_req_get(target->dev->ar);
 
@@ -1631,9 +1633,10 @@ fail_rx_pkt:
 	return status;
 }
 
-static int htc_proc_fetched_rxpkts(struct htc_target *target,
-				   struct list_head *comp_pktq, u32 lk_ahds[],
-				   int *n_lk_ahd)
+static int ath6kl_htc_rx_process_packets(struct htc_target *target,
+					 struct list_head *comp_pktq,
+					 u32 lk_ahds[],
+					 int *n_lk_ahd)
 {
 	struct htc_packet *packet, *tmp_pkt;
 	struct htc_endpoint *ep;
@@ -1644,7 +1647,8 @@ static int htc_proc_fetched_rxpkts(struct htc_target *target,
 		ep = &target->endpoint[packet->endpoint];
 
 		/* process header for each of the recv packet */
-		status = htc_proc_rxhdr(target, packet, lk_ahds, n_lk_ahd);
+		status = ath6kl_htc_rx_process_hdr(target, packet, lk_ahds,
+						   n_lk_ahd);
 		if (status)
 			return status;
 
@@ -1654,8 +1658,8 @@ static int htc_proc_fetched_rxpkts(struct htc_target *target,
 			 * based on the lookahead.
 			 */
 			if (*n_lk_ahd > 0)
-				set_rxpkt_indication_flag(lk_ahds[0],
-							  ep, packet);
+				ath6kl_htc_rx_set_indicate(lk_ahds[0],
+							   ep, packet);
 		} else
 			/*
 			 * Packets in a bundle automatically have
@@ -1664,20 +1668,20 @@ static int htc_proc_fetched_rxpkts(struct htc_target *target,
 			packet->info.rx.indicat_flags |=
 				HTC_RX_FLAGS_INDICATE_MORE_PKTS;
 
-		htc_update_rx_stats(ep, *n_lk_ahd);
+		ath6kl_htc_rx_update_stats(ep, *n_lk_ahd);
 
 		if (packet->info.rx.rx_flags & HTC_RX_PKT_PART_OF_BUNDLE)
 			ep->ep_st.rx_bundl += 1;
 
-		do_rx_completion(ep, packet);
+		ath6kl_htc_rx_complete(ep, packet);
 	}
 
 	return status;
 }
 
-static int htc_fetch_rxpkts(struct htc_target *target,
-			    struct list_head *rx_pktq,
-			    struct list_head *comp_pktq)
+static int ath6kl_htc_rx_fetch(struct htc_target *target,
+			       struct list_head *rx_pktq,
+			       struct list_head *comp_pktq)
 {
 	int fetched_pkts;
 	bool part_bundle = false;
@@ -1693,10 +1697,10 @@ static int htc_fetch_rxpkts(struct htc_target *target,
 			 * bundle transfer and recv bundling is
 			 * allowed.
 			 */
-			status = htc_issue_rxpkt_bundle(target, rx_pktq,
-							comp_pktq,
-							&fetched_pkts,
-							part_bundle);
+			status = ath6kl_htc_rx_bundle(target, rx_pktq,
+						      comp_pktq,
+						      &fetched_pkts,
+						      part_bundle);
 			if (status)
 				return status;
 
@@ -1725,7 +1729,8 @@ static int htc_fetch_rxpkts(struct htc_target *target,
 					HTC_RX_PKT_IGNORE_LOOKAHEAD;
 
 			/* go fetch the packet */
-			status = dev_rx_pkt(target, packet, packet->act_len);
+			status = ath6kl_htc_rx_packet(target, packet,
+						      packet->act_len);
 			if (status)
 				return status;
 
@@ -1779,9 +1784,9 @@ int ath6kl_htc_rxmsg_pending_handler(struct htc_target *target,
 		 * Try to allocate as many HTC RX packets indicated by the
 		 * look_aheads.
 		 */
-		status = alloc_and_prep_rxpkts(target, look_aheads,
-					       num_look_ahead, endpoint,
-					       &rx_pktq);
+		status = ath6kl_htc_rx_alloc(target, look_aheads,
+					     num_look_ahead, endpoint,
+					     &rx_pktq);
 		if (status)
 			break;
 
@@ -1796,14 +1801,15 @@ int ath6kl_htc_rxmsg_pending_handler(struct htc_target *target,
 
 		num_look_ahead = 0;
 
-		status = htc_fetch_rxpkts(target, &rx_pktq, &comp_pktq);
+		status = ath6kl_htc_rx_fetch(target, &rx_pktq, &comp_pktq);
 
 		if (!status)
-			chk_rx_water_mark(endpoint);
+			ath6kl_htc_rx_chk_water_mark(endpoint);
 
 		/* Process fetched packets */
-		status = htc_proc_fetched_rxpkts(target, &comp_pktq,
-						 look_aheads, &num_look_ahead);
+		status = ath6kl_htc_rx_process_packets(target, &comp_pktq,
+						       look_aheads,
+						       &num_look_ahead);
 
 		if (!num_look_ahead || status)
 			break;
@@ -1896,14 +1902,14 @@ static struct htc_packet *htc_wait_for_ctrl_msg(struct htc_target *target)
 	packet->completion = NULL;
 
 	/* get the message from the device, this will block */
-	if (dev_rx_pkt(target, packet, packet->act_len))
+	if (ath6kl_htc_rx_packet(target, packet, packet->act_len))
 		goto fail_ctrl_rx;
 
 	/* process receive header */
-	packet->status = htc_proc_rxhdr(target, packet, NULL, NULL);
+	packet->status = ath6kl_htc_rx_process_hdr(target, packet, NULL, NULL);
 
 	if (packet->status) {
-		ath6kl_err("htc_wait_for_ctrl_msg, htc_proc_rxhdr failed (status = %d)\n",
+		ath6kl_err("htc_wait_for_ctrl_msg, ath6kl_htc_rx_process_hdr failed (status = %d)\n",
 			   packet->status);
 		goto fail_ctrl_rx;
 	}
@@ -1950,7 +1956,7 @@ int ath6kl_htc_add_rxbuf_multiple(struct htc_target *target,
 		list_for_each_entry_safe(packet, tmp_pkt, pkt_queue, list) {
 			packet->status = -ECANCELED;
 			list_del(&packet->list);
-			do_rx_completion(endpoint, packet);
+			ath6kl_htc_rx_complete(endpoint, packet);
 		}
 
 		return status;

