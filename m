Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh07.mail.saunalahti.fi ([62.142.5.117]:36463 "EHLO
	emh07.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752289Ab1JMMVe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Oct 2011 08:21:34 -0400
Subject: [PATCH 1/4] ath6kl: merge htc debug levels
To: kvalo@qca.qualcomm.com
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 13 Oct 2011 15:21:15 +0300
Message-ID: <20111013122115.30551.94.stgit@localhost6.localdomain6> (sfid-20111013_142143_598955_5F9F32CB)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It's not really necessary to have separate debug levels for htc tx and rx
so combine them.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/debug.c |    5 +-
 drivers/net/wireless/ath/ath6kl/debug.h |    4 +
 drivers/net/wireless/ath/ath6kl/hif.c   |    6 +-
 drivers/net/wireless/ath/ath6kl/htc.c   |   84 ++++++++++++++++---------------
 4 files changed, 50 insertions(+), 49 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/debug.c b/drivers/net/wireless/ath/ath6kl/debug.c
index dd37785..e52f7e3 100644
--- a/drivers/net/wireless/ath/ath6kl/debug.c
+++ b/drivers/net/wireless/ath/ath6kl/debug.c
@@ -180,9 +180,10 @@ void dump_cred_dist_stats(struct htc_target *target)
 	list_for_each_entry(ep_list, &target->cred_dist_list, list)
 		dump_cred_dist(ep_list);
 
-	ath6kl_dbg(ATH6KL_DBG_HTC_SEND, "ctxt:%p dist:%p\n",
+	ath6kl_dbg(ATH6KL_DBG_HTC, "ctxt:%p dist:%p\n",
 		   target->cred_dist_cntxt, NULL);
-	ath6kl_dbg(ATH6KL_DBG_TRC, "credit distribution, total : %d, free : %d\n",
+	ath6kl_dbg(ATH6KL_DBG_HTC,
+		   "credit distribution, total : %d, free : %d\n",
 		   target->cred_dist_cntxt->total_avail_credits,
 		   target->cred_dist_cntxt->cur_free_credits);
 }
diff --git a/drivers/net/wireless/ath/ath6kl/debug.h b/drivers/net/wireless/ath/ath6kl/debug.h
index 7d5323d..01f4015 100644
--- a/drivers/net/wireless/ath/ath6kl/debug.h
+++ b/drivers/net/wireless/ath/ath6kl/debug.h
@@ -25,8 +25,8 @@ enum ATH6K_DEBUG_MASK {
 	ATH6KL_DBG_WLAN_TX      = BIT(2),     /* wlan tx */
 	ATH6KL_DBG_WLAN_RX      = BIT(3),     /* wlan rx */
 	ATH6KL_DBG_BMI		= BIT(4),     /* bmi tracing */
-	ATH6KL_DBG_HTC_SEND     = BIT(5),     /* htc send */
-	ATH6KL_DBG_HTC_RECV     = BIT(6),     /* htc recv */
+	ATH6KL_DBG_HTC		= BIT(5),
+	/* hole */
 	ATH6KL_DBG_IRQ		= BIT(7),     /* interrupt processing */
 	ATH6KL_DBG_PM           = BIT(8),     /* power management */
 	ATH6KL_DBG_WLAN_NODE    = BIT(9),     /* general wlan node tracing */
diff --git a/drivers/net/wireless/ath/ath6kl/hif.c b/drivers/net/wireless/ath/ath6kl/hif.c
index 57c9aff..7cc6cec 100644
--- a/drivers/net/wireless/ath/ath6kl/hif.c
+++ b/drivers/net/wireless/ath/ath6kl/hif.c
@@ -51,7 +51,7 @@ int ath6kl_hif_rw_comp_handler(void *context, int status)
 {
 	struct htc_packet *packet = context;
 
-	ath6kl_dbg(ATH6KL_DBG_HTC_RECV,
+	ath6kl_dbg(ATH6KL_DBG_HTC,
 		   "ath6kl_hif_rw_comp_handler (pkt:0x%p , status: %d\n",
 		   packet, status);
 
@@ -119,7 +119,7 @@ int ath6kl_hif_poll_mboxmsg_rx(struct ath6kl_device *dev, u32 *lk_ahd,
 
 		/* delay a little  */
 		mdelay(ATH6KL_TIME_QUANTUM);
-		ath6kl_dbg(ATH6KL_DBG_HTC_RECV, "retry mbox poll : %d\n", i);
+		ath6kl_dbg(ATH6KL_DBG_HTC, "retry mbox poll : %d\n", i);
 	}
 
 	if (i == 0) {
@@ -186,7 +186,7 @@ int ath6kl_hif_submit_scat_req(struct ath6kl_device *dev,
 			dev->ar->mbox_info.htc_addr;
 	}
 
-	ath6kl_dbg((ATH6KL_DBG_HTC_RECV | ATH6KL_DBG_HTC_SEND),
+	ath6kl_dbg(ATH6KL_DBG_HTC,
 		   "ath6kl_hif_submit_scat_req, entries: %d, total len: %d mbox:0x%X (mode: %s : %s)\n",
 		   scat_req->scat_entries, scat_req->len,
 		   scat_req->addr, !read ? "async" : "sync",
diff --git a/drivers/net/wireless/ath/ath6kl/htc.c b/drivers/net/wireless/ath/ath6kl/htc.c
index 9b8cb22..241a7ce 100644
--- a/drivers/net/wireless/ath/ath6kl/htc.c
+++ b/drivers/net/wireless/ath/ath6kl/htc.c
@@ -102,7 +102,7 @@ static void htc_tx_comp_update(struct htc_target *target,
 				packet->info.tx.cred_used;
 	endpoint->cred_dist.txq_depth = get_queue_depth(&endpoint->txq);
 
-	ath6kl_dbg(ATH6KL_DBG_HTC_SEND, "ctxt:0x%p dist:0x%p\n",
+	ath6kl_dbg(ATH6KL_DBG_HTC, "ctxt:0x%p dist:0x%p\n",
 		   target->cred_dist_cntxt, &target->cred_dist_list);
 
 	ath6k_credit_distribute(target->cred_dist_cntxt,
@@ -118,7 +118,7 @@ static void htc_tx_complete(struct htc_endpoint *endpoint,
 	if (list_empty(txq))
 		return;
 
-	ath6kl_dbg(ATH6KL_DBG_HTC_SEND,
+	ath6kl_dbg(ATH6KL_DBG_HTC,
 		   "send complete ep %d, (%d pkts)\n",
 		   endpoint->eid, get_queue_depth(txq));
 
@@ -148,7 +148,7 @@ static void htc_async_tx_scat_complete(struct htc_target *target,
 
 	INIT_LIST_HEAD(&tx_compq);
 
-	ath6kl_dbg(ATH6KL_DBG_HTC_SEND,
+	ath6kl_dbg(ATH6KL_DBG_HTC,
 		"htc_async_tx_scat_complete  total len: %d  entries: %d\n",
 		scat_req->len, scat_req->scat_entries);
 
@@ -190,12 +190,12 @@ static int ath6kl_htc_tx_issue(struct htc_target *target,
 
 	send_len = packet->act_len + HTC_HDR_LENGTH;
 
-	ath6kl_dbg(ATH6KL_DBG_HTC_SEND, "%s: transmit len : %d (%s)\n",
+	ath6kl_dbg(ATH6KL_DBG_HTC, "%s: transmit len : %d (%s)\n",
 		   __func__, send_len, sync ? "sync" : "async");
 
 	padded_len = CALC_TXRX_PADDED_LEN(target, send_len);
 
-	ath6kl_dbg(ATH6KL_DBG_HTC_SEND,
+	ath6kl_dbg(ATH6KL_DBG_HTC,
 		"DevSendPacket, padded len: %d mbox:0x%X (mode:%s)\n",
 		padded_len,
 		target->dev->ar->mbox_info.htc_addr,
@@ -227,7 +227,7 @@ static int htc_check_credits(struct htc_target *target,
 	*req_cred = (len > target->tgt_cred_sz) ?
 		     DIV_ROUND_UP(len, target->tgt_cred_sz) : 1;
 
-	ath6kl_dbg(ATH6KL_DBG_HTC_SEND, "creds required:%d got:%d\n",
+	ath6kl_dbg(ATH6KL_DBG_HTC, "creds required:%d got:%d\n",
 		   *req_cred, ep->cred_dist.credits);
 
 	if (ep->cred_dist.credits < *req_cred) {
@@ -237,7 +237,7 @@ static int htc_check_credits(struct htc_target *target,
 		/* Seek more credits */
 		ep->cred_dist.seek_cred = *req_cred - ep->cred_dist.credits;
 
-		ath6kl_dbg(ATH6KL_DBG_HTC_SEND, "ctxt:0x%p dist:0x%p\n",
+		ath6kl_dbg(ATH6KL_DBG_HTC, "ctxt:0x%p dist:0x%p\n",
 			   target->cred_dist_cntxt, &ep->cred_dist);
 
 		ath6k_seek_credits(target->cred_dist_cntxt, &ep->cred_dist);
@@ -245,7 +245,7 @@ static int htc_check_credits(struct htc_target *target,
 		ep->cred_dist.seek_cred = 0;
 
 		if (ep->cred_dist.credits < *req_cred) {
-			ath6kl_dbg(ATH6KL_DBG_HTC_SEND,
+			ath6kl_dbg(ATH6KL_DBG_HTC,
 				   "not enough credits for ep %d - leaving packet in queue\n",
 				   eid);
 			return -EINVAL;
@@ -260,7 +260,7 @@ static int htc_check_credits(struct htc_target *target,
 		ep->cred_dist.seek_cred =
 		ep->cred_dist.cred_per_msg - ep->cred_dist.credits;
 
-		ath6kl_dbg(ATH6KL_DBG_HTC_SEND, "ctxt:0x%p dist:0x%p\n",
+		ath6kl_dbg(ATH6KL_DBG_HTC, "ctxt:0x%p dist:0x%p\n",
 			   target->cred_dist_cntxt, &ep->cred_dist);
 
 		ath6k_seek_credits(target->cred_dist_cntxt, &ep->cred_dist);
@@ -270,7 +270,7 @@ static int htc_check_credits(struct htc_target *target,
 			/* tell the target we need credits ASAP! */
 			*flags |= HTC_FLAGS_NEED_CREDIT_UPDATE;
 			ep->ep_st.cred_low_indicate += 1;
-			ath6kl_dbg(ATH6KL_DBG_HTC_SEND, "host needs credits\n");
+			ath6kl_dbg(ATH6KL_DBG_HTC, "host needs credits\n");
 		}
 	}
 
@@ -295,7 +295,7 @@ static void ath6kl_htc_tx_pkts_get(struct htc_target *target,
 		packet = list_first_entry(&endpoint->txq, struct htc_packet,
 					  list);
 
-		ath6kl_dbg(ATH6KL_DBG_HTC_SEND,
+		ath6kl_dbg(ATH6KL_DBG_HTC,
 			"got head pkt:0x%p , queue depth: %d\n",
 			packet, get_queue_depth(&endpoint->txq));
 
@@ -404,7 +404,7 @@ static int ath6kl_htc_tx_setup_scat_list(struct htc_target *target,
 
 		scat_req->len += len;
 		scat_req->scat_entries++;
-		ath6kl_dbg(ATH6KL_DBG_HTC_SEND,
+		ath6kl_dbg(ATH6KL_DBG_HTC,
 			   "%d, adding pkt : 0x%p len:%d (remaining space:%d)\n",
 			   i, packet, len, rem_scat);
 	}
@@ -455,12 +455,12 @@ static void ath6kl_htc_tx_bundle(struct htc_endpoint *endpoint,
 
 		if (!scat_req) {
 			/* no scatter resources  */
-			ath6kl_dbg(ATH6KL_DBG_HTC_SEND,
+			ath6kl_dbg(ATH6KL_DBG_HTC,
 				"no more scatter resources\n");
 			break;
 		}
 
-		ath6kl_dbg(ATH6KL_DBG_HTC_SEND, "pkts to scatter: %d\n",
+		ath6kl_dbg(ATH6KL_DBG_HTC, "pkts to scatter: %d\n",
 			   n_scat);
 
 		scat_req->len = 0;
@@ -479,7 +479,7 @@ static void ath6kl_htc_tx_bundle(struct htc_endpoint *endpoint,
 		n_sent_bundle++;
 		tot_pkts_bundle += scat_req->scat_entries;
 
-		ath6kl_dbg(ATH6KL_DBG_HTC_SEND,
+		ath6kl_dbg(ATH6KL_DBG_HTC,
 			   "send scatter total bytes: %d , entries: %d\n",
 			   scat_req->len, scat_req->scat_entries);
 		ath6kl_hif_submit_scat_req(target->dev, scat_req, false);
@@ -490,7 +490,7 @@ static void ath6kl_htc_tx_bundle(struct htc_endpoint *endpoint,
 
 	*sent_bundle = n_sent_bundle;
 	*n_bundle_pkts = tot_pkts_bundle;
-	ath6kl_dbg(ATH6KL_DBG_HTC_SEND, "%s (sent:%d)\n",
+	ath6kl_dbg(ATH6KL_DBG_HTC, "%s (sent:%d)\n",
 		   __func__, n_sent_bundle);
 
 	return;
@@ -510,7 +510,7 @@ static void ath6kl_htc_tx_from_queue(struct htc_target *target,
 	if (endpoint->tx_proc_cnt > 1) {
 		endpoint->tx_proc_cnt--;
 		spin_unlock_bh(&target->tx_lock);
-		ath6kl_dbg(ATH6KL_DBG_HTC_SEND, "htc_try_send (busy)\n");
+		ath6kl_dbg(ATH6KL_DBG_HTC, "htc_try_send (busy)\n");
 		return;
 	}
 
@@ -588,13 +588,13 @@ static bool ath6kl_htc_tx_try(struct htc_target *target,
 		overflow = true;
 
 	if (overflow)
-		ath6kl_dbg(ATH6KL_DBG_HTC_SEND,
+		ath6kl_dbg(ATH6KL_DBG_HTC,
 			   "ep %d, tx queue will overflow :%d , tx depth:%d, max:%d\n",
 			   endpoint->eid, overflow, txq_depth,
 			   endpoint->max_txq_depth);
 
 	if (overflow && ep_cb.tx_full) {
-		ath6kl_dbg(ATH6KL_DBG_HTC_SEND,
+		ath6kl_dbg(ATH6KL_DBG_HTC,
 			   "indicating overflowed tx packet: 0x%p\n", tx_pkt);
 
 		if (ep_cb.tx_full(endpoint->target, tx_pkt) ==
@@ -629,7 +629,7 @@ static void htc_chk_ep_txq(struct htc_target *target)
 
 		spin_lock_bh(&target->tx_lock);
 		if (!list_empty(&endpoint->txq)) {
-			ath6kl_dbg(ATH6KL_DBG_HTC_SEND,
+			ath6kl_dbg(ATH6KL_DBG_HTC,
 				   "ep %d has %d credits and %d packets in tx queue\n",
 				   cred_dist->endpoint,
 				   endpoint->cred_dist.credits,
@@ -736,7 +736,7 @@ int ath6kl_htc_tx(struct htc_target *target, struct htc_packet *packet)
 	struct htc_endpoint *endpoint;
 	struct list_head queue;
 
-	ath6kl_dbg(ATH6KL_DBG_HTC_SEND,
+	ath6kl_dbg(ATH6KL_DBG_HTC,
 		   "htc_tx: ep id: %d, buf: 0x%p, len: %d\n",
 		   packet->endpoint, packet->buf, packet->act_len);
 
@@ -787,7 +787,7 @@ void ath6kl_htc_flush_txep(struct htc_target *target,
 	list_for_each_entry_safe(packet, tmp_pkt, &discard_q, list) {
 		packet->status = -ECANCELED;
 		list_del(&packet->list);
-		ath6kl_dbg(ATH6KL_DBG_TRC,
+		ath6kl_dbg(ATH6KL_DBG_HTC,
 			"flushing tx pkt:0x%p, len:%d, ep:%d tag:0x%X\n",
 			packet, packet->act_len,
 			packet->endpoint, packet->info.tx.tag);
@@ -844,7 +844,7 @@ void ath6kl_htc_indicate_activity_change(struct htc_target *target,
 		endpoint->cred_dist.txq_depth =
 			get_queue_depth(&endpoint->txq);
 
-		ath6kl_dbg(ATH6KL_DBG_HTC_SEND, "ctxt:0x%p dist:0x%p\n",
+		ath6kl_dbg(ATH6KL_DBG_HTC, "ctxt:0x%p dist:0x%p\n",
 			   target->cred_dist_cntxt, &target->cred_dist_list);
 
 		ath6k_credit_distribute(target->cred_dist_cntxt,
@@ -924,7 +924,7 @@ static int ath6kl_htc_rx_packet(struct htc_target *target,
 		return -ENOMEM;
 	}
 
-	ath6kl_dbg(ATH6KL_DBG_HTC_RECV,
+	ath6kl_dbg(ATH6KL_DBG_HTC,
 		   "dev_rx_pkt (0x%p : hdr:0x%X) padded len: %d mbox:0x%X (mode:%s)\n",
 		   packet, packet->info.rx.exp_hdr,
 		   padded_len, dev->ar->mbox_info.htc_addr, "sync");
@@ -1137,7 +1137,7 @@ static int ath6kl_htc_rx_alloc(struct htc_target *target,
 			}
 
 			endpoint->ep_st.rx_bundle_from_hdr += 1;
-			ath6kl_dbg(ATH6KL_DBG_HTC_RECV,
+			ath6kl_dbg(ATH6KL_DBG_HTC,
 				   "htc hdr indicates :%d msg can be fetched as a bundle\n",
 				   n_msg);
 		} else
@@ -1209,7 +1209,7 @@ static void htc_proc_cred_rpt(struct htc_target *target,
 	int tot_credits = 0, i;
 	bool dist = false;
 
-	ath6kl_dbg(ATH6KL_DBG_HTC_SEND,
+	ath6kl_dbg(ATH6KL_DBG_HTC,
 		   "htc_proc_cred_rpt, credit report entries:%d\n", n_entries);
 
 	spin_lock_bh(&target->tx_lock);
@@ -1223,7 +1223,7 @@ static void htc_proc_cred_rpt(struct htc_target *target,
 
 		endpoint = &target->endpoint[rpt->eid];
 
-		ath6kl_dbg(ATH6KL_DBG_HTC_SEND, " ep %d got %d credits\n",
+		ath6kl_dbg(ATH6KL_DBG_HTC, " ep %d got %d credits\n",
 			rpt->eid, rpt->credits);
 
 		endpoint->ep_st.tx_cred_rpt += 1;
@@ -1264,7 +1264,7 @@ static void htc_proc_cred_rpt(struct htc_target *target,
 		tot_credits += rpt->credits;
 	}
 
-	ath6kl_dbg(ATH6KL_DBG_HTC_SEND,
+	ath6kl_dbg(ATH6KL_DBG_HTC,
 		   "report indicated %d credits to distribute\n",
 		   tot_credits);
 
@@ -1273,7 +1273,7 @@ static void htc_proc_cred_rpt(struct htc_target *target,
 		 * This was a credit return based on a completed send
 		 * operations note, this is done with the lock held
 		 */
-		ath6kl_dbg(ATH6KL_DBG_HTC_SEND, "ctxt:0x%p dist:0x%p\n",
+		ath6kl_dbg(ATH6KL_DBG_HTC, "ctxt:0x%p dist:0x%p\n",
 			   target->cred_dist_cntxt, &target->cred_dist_list);
 
 		ath6k_credit_distribute(target->cred_dist_cntxt,
@@ -1320,7 +1320,7 @@ static int htc_parse_trailer(struct htc_target *target,
 		if ((lk_ahd->pre_valid == ((~lk_ahd->post_valid) & 0xFF))
 		    && next_lk_ahds) {
 
-			ath6kl_dbg(ATH6KL_DBG_HTC_RECV,
+			ath6kl_dbg(ATH6KL_DBG_HTC,
 				   "lk_ahd report found (pre valid:0x%X, post valid:0x%X)\n",
 				   lk_ahd->pre_valid, lk_ahd->post_valid);
 
@@ -1378,7 +1378,7 @@ static int htc_proc_trailer(struct htc_target *target,
 	u8 *record_buf;
 	u8 *orig_buf;
 
-	ath6kl_dbg(ATH6KL_DBG_HTC_RECV, "+htc_proc_trailer (len:%d)\n", len);
+	ath6kl_dbg(ATH6KL_DBG_HTC, "+htc_proc_trailer (len:%d)\n", len);
 
 	ath6kl_dbg_dump(ATH6KL_DBG_RAW_BYTES, "Recv Trailer", "",
 			buf, len);
@@ -1534,7 +1534,7 @@ fail_rx:
 static void ath6kl_htc_rx_complete(struct htc_endpoint *endpoint,
 				   struct htc_packet *packet)
 {
-		ath6kl_dbg(ATH6KL_DBG_HTC_RECV,
+		ath6kl_dbg(ATH6KL_DBG_HTC,
 			   "htc calling ep %d recv callback on packet 0x%p\n",
 			   endpoint->eid, packet);
 		endpoint->ep_cb.rx(endpoint->target, packet);
@@ -1571,7 +1571,7 @@ static int ath6kl_htc_rx_bundle(struct htc_target *target,
 
 	len = 0;
 
-	ath6kl_dbg(ATH6KL_DBG_HTC_RECV,
+	ath6kl_dbg(ATH6KL_DBG_HTC,
 		   "%s(): (numpackets: %d , actual : %d)\n",
 		   __func__, get_queue_depth(rxq), n_scat_pkt);
 
@@ -1897,7 +1897,7 @@ static struct htc_packet *htc_wait_for_ctrl_msg(struct htc_target *target)
 			       HTC_TARGET_RESPONSE_TIMEOUT))
 		return NULL;
 
-	ath6kl_dbg(ATH6KL_DBG_HTC_RECV,
+	ath6kl_dbg(ATH6KL_DBG_HTC,
 		"htc_wait_for_ctrl_msg: look_ahead : 0x%X\n", look_ahead);
 
 	htc_hdr = (struct htc_frame_hdr *)&look_ahead;
@@ -1962,7 +1962,7 @@ int ath6kl_htc_add_rxbuf_multiple(struct htc_target *target,
 
 	depth = get_queue_depth(pkt_queue);
 
-	ath6kl_dbg(ATH6KL_DBG_HTC_RECV,
+	ath6kl_dbg(ATH6KL_DBG_HTC,
 		"htc_add_rxbuf_multiple: ep id: %d, cnt:%d, len: %d\n",
 		first_pkt->endpoint, depth, first_pkt->buf_len);
 
@@ -1988,7 +1988,7 @@ int ath6kl_htc_add_rxbuf_multiple(struct htc_target *target,
 	/* check if we are blocked waiting for a new buffer */
 	if (target->rx_st_flags & HTC_RECV_WAIT_BUFFERS) {
 		if (target->ep_waiting == first_pkt->endpoint) {
-			ath6kl_dbg(ATH6KL_DBG_HTC_RECV,
+			ath6kl_dbg(ATH6KL_DBG_HTC,
 				"receiver was blocked on ep:%d, unblocking.\n",
 				target->ep_waiting);
 			target->rx_st_flags &= ~HTC_RECV_WAIT_BUFFERS;
@@ -2023,7 +2023,7 @@ void ath6kl_htc_flush_rx_buf(struct htc_target *target)
 					 &endpoint->rx_bufq, list) {
 			list_del(&packet->list);
 			spin_unlock_bh(&target->rx_lock);
-			ath6kl_dbg(ATH6KL_DBG_HTC_RECV,
+			ath6kl_dbg(ATH6KL_DBG_HTC,
 				   "flushing rx pkt:0x%p, len:%d, ep:%d\n",
 				   packet, packet->buf_len,
 				   packet->endpoint);
@@ -2047,7 +2047,7 @@ int ath6kl_htc_conn_service(struct htc_target *target,
 	unsigned int max_msg_sz = 0;
 	int status = 0;
 
-	ath6kl_dbg(ATH6KL_DBG_TRC,
+	ath6kl_dbg(ATH6KL_DBG_HTC,
 		   "htc_conn_service, target:0x%p service id:0x%X\n",
 		   target, conn_req->svc_id);
 
@@ -2220,7 +2220,7 @@ static void htc_setup_msg_bndl(struct htc_target *target)
 	target->msg_per_bndl_max = min(target->max_scat_entries,
 				       target->msg_per_bndl_max);
 
-	ath6kl_dbg(ATH6KL_DBG_TRC,
+	ath6kl_dbg(ATH6KL_DBG_HTC,
 		   "htc bundling allowed. max msg per htc bundle: %d\n",
 		   target->msg_per_bndl_max);
 
@@ -2230,7 +2230,7 @@ static void htc_setup_msg_bndl(struct htc_target *target)
 	target->max_tx_bndl_sz = min(HIF_MBOX0_EXT_WIDTH,
 				     target->max_xfer_szper_scatreq);
 
-	ath6kl_dbg(ATH6KL_DBG_ANY, "max recv: %d max send: %d\n",
+	ath6kl_dbg(ATH6KL_DBG_HTC, "max recv: %d max send: %d\n",
 		   target->max_rx_bndl_sz, target->max_tx_bndl_sz);
 
 	if (target->max_tx_bndl_sz)
@@ -2284,7 +2284,7 @@ int ath6kl_htc_wait_target(struct htc_target *target)
 	target->tgt_creds = le16_to_cpu(rdy_msg->ver2_0_info.cred_cnt);
 	target->tgt_cred_sz = le16_to_cpu(rdy_msg->ver2_0_info.cred_sz);
 
-	ath6kl_dbg(ATH6KL_DBG_HTC_RECV,
+	ath6kl_dbg(ATH6KL_DBG_HTC,
 		   "target ready: credits: %d credit size: %d\n",
 		   target->tgt_creds, target->tgt_cred_sz);
 
@@ -2299,7 +2299,7 @@ int ath6kl_htc_wait_target(struct htc_target *target)
 		target->msg_per_bndl_max = 0;
 	}
 
-	ath6kl_dbg(ATH6KL_DBG_TRC, "using htc protocol version : %s (%d)\n",
+	ath6kl_dbg(ATH6KL_DBG_HTC, "using htc protocol version : %s (%d)\n",
 		  (target->htc_tgt_ver == HTC_VERSION_2P0) ? "2.0" : ">= 2.1",
 		  target->htc_tgt_ver);
 

