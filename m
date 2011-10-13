Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh06.mail.saunalahti.fi ([62.142.5.116]:57103 "EHLO
	emh06.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752289Ab1JMMVm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Oct 2011 08:21:42 -0400
Subject: [PATCH 2/4] ath6kl: cleanup htc debug messages
To: kvalo@qca.qualcomm.com
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 13 Oct 2011 15:21:37 +0300
Message-ID: <20111013122137.30551.89218.stgit@localhost6.localdomain6> (sfid-20111013_142148_634535_BB7BAB31)
In-Reply-To: <20111013122115.30551.94.stgit@localhost6.localdomain6>
References: <20111013122115.30551.94.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Unify debug message format and other minor changes.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/htc.c |  138 ++++++++++++++++-----------------
 1 files changed, 67 insertions(+), 71 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/htc.c b/drivers/net/wireless/ath/ath6kl/htc.c
index 241a7ce..840f1b3 100644
--- a/drivers/net/wireless/ath/ath6kl/htc.c
+++ b/drivers/net/wireless/ath/ath6kl/htc.c
@@ -102,7 +102,7 @@ static void htc_tx_comp_update(struct htc_target *target,
 				packet->info.tx.cred_used;
 	endpoint->cred_dist.txq_depth = get_queue_depth(&endpoint->txq);
 
-	ath6kl_dbg(ATH6KL_DBG_HTC, "ctxt:0x%p dist:0x%p\n",
+	ath6kl_dbg(ATH6KL_DBG_HTC, "htc tx ctxt 0x%p dist 0x%p\n",
 		   target->cred_dist_cntxt, &target->cred_dist_list);
 
 	ath6k_credit_distribute(target->cred_dist_cntxt,
@@ -119,7 +119,7 @@ static void htc_tx_complete(struct htc_endpoint *endpoint,
 		return;
 
 	ath6kl_dbg(ATH6KL_DBG_HTC,
-		   "send complete ep %d, (%d pkts)\n",
+		   "htc tx complete ep %d pkts %d\n",
 		   endpoint->eid, get_queue_depth(txq));
 
 	ath6kl_tx_complete(endpoint->target->dev->ar, txq);
@@ -149,7 +149,7 @@ static void htc_async_tx_scat_complete(struct htc_target *target,
 	INIT_LIST_HEAD(&tx_compq);
 
 	ath6kl_dbg(ATH6KL_DBG_HTC,
-		"htc_async_tx_scat_complete  total len: %d  entries: %d\n",
+		"htc tx scat complete len %d entries %d\n",
 		scat_req->len, scat_req->scat_entries);
 
 	if (scat_req->status)
@@ -190,16 +190,13 @@ static int ath6kl_htc_tx_issue(struct htc_target *target,
 
 	send_len = packet->act_len + HTC_HDR_LENGTH;
 
-	ath6kl_dbg(ATH6KL_DBG_HTC, "%s: transmit len : %d (%s)\n",
-		   __func__, send_len, sync ? "sync" : "async");
-
 	padded_len = CALC_TXRX_PADDED_LEN(target, send_len);
 
 	ath6kl_dbg(ATH6KL_DBG_HTC,
-		"DevSendPacket, padded len: %d mbox:0x%X (mode:%s)\n",
-		padded_len,
-		target->dev->ar->mbox_info.htc_addr,
-		sync ? "sync" : "async");
+		   "htc tx issue len %d padded_len %d mbox 0x%X %s\n",
+		   send_len, padded_len,
+		   target->dev->ar->mbox_info.htc_addr,
+		   sync ? "sync" : "async");
 
 	if (sync) {
 		status = hif_read_write_sync(target->dev->ar,
@@ -227,7 +224,7 @@ static int htc_check_credits(struct htc_target *target,
 	*req_cred = (len > target->tgt_cred_sz) ?
 		     DIV_ROUND_UP(len, target->tgt_cred_sz) : 1;
 
-	ath6kl_dbg(ATH6KL_DBG_HTC, "creds required:%d got:%d\n",
+	ath6kl_dbg(ATH6KL_DBG_HTC, "htc creds required %d got %d\n",
 		   *req_cred, ep->cred_dist.credits);
 
 	if (ep->cred_dist.credits < *req_cred) {
@@ -237,7 +234,7 @@ static int htc_check_credits(struct htc_target *target,
 		/* Seek more credits */
 		ep->cred_dist.seek_cred = *req_cred - ep->cred_dist.credits;
 
-		ath6kl_dbg(ATH6KL_DBG_HTC, "ctxt:0x%p dist:0x%p\n",
+		ath6kl_dbg(ATH6KL_DBG_HTC, "htc creds ctxt 0x%p dist 0x%p\n",
 			   target->cred_dist_cntxt, &ep->cred_dist);
 
 		ath6k_seek_credits(target->cred_dist_cntxt, &ep->cred_dist);
@@ -246,7 +243,7 @@ static int htc_check_credits(struct htc_target *target,
 
 		if (ep->cred_dist.credits < *req_cred) {
 			ath6kl_dbg(ATH6KL_DBG_HTC,
-				   "not enough credits for ep %d - leaving packet in queue\n",
+				   "htc creds not enough credits for ep %d\n",
 				   eid);
 			return -EINVAL;
 		}
@@ -260,7 +257,7 @@ static int htc_check_credits(struct htc_target *target,
 		ep->cred_dist.seek_cred =
 		ep->cred_dist.cred_per_msg - ep->cred_dist.credits;
 
-		ath6kl_dbg(ATH6KL_DBG_HTC, "ctxt:0x%p dist:0x%p\n",
+		ath6kl_dbg(ATH6KL_DBG_HTC, "htc creds ctxt 0x%p dist 0x%p\n",
 			   target->cred_dist_cntxt, &ep->cred_dist);
 
 		ath6k_seek_credits(target->cred_dist_cntxt, &ep->cred_dist);
@@ -270,7 +267,7 @@ static int htc_check_credits(struct htc_target *target,
 			/* tell the target we need credits ASAP! */
 			*flags |= HTC_FLAGS_NEED_CREDIT_UPDATE;
 			ep->ep_st.cred_low_indicate += 1;
-			ath6kl_dbg(ATH6KL_DBG_HTC, "host needs credits\n");
+			ath6kl_dbg(ATH6KL_DBG_HTC, "htc creds host needs credits\n");
 		}
 	}
 
@@ -296,7 +293,7 @@ static void ath6kl_htc_tx_pkts_get(struct htc_target *target,
 					  list);
 
 		ath6kl_dbg(ATH6KL_DBG_HTC,
-			"got head pkt:0x%p , queue depth: %d\n",
+			"htc tx got packet 0x%p queue depth %d\n",
 			packet, get_queue_depth(&endpoint->txq));
 
 		len = CALC_TXRX_PADDED_LEN(target,
@@ -405,7 +402,7 @@ static int ath6kl_htc_tx_setup_scat_list(struct htc_target *target,
 		scat_req->len += len;
 		scat_req->scat_entries++;
 		ath6kl_dbg(ATH6KL_DBG_HTC,
-			   "%d, adding pkt : 0x%p len:%d (remaining space:%d)\n",
+			   "htc tx adding (%d) pkt 0x%p len %d remaining %d\n",
 			   i, packet, len, rem_scat);
 	}
 
@@ -456,11 +453,11 @@ static void ath6kl_htc_tx_bundle(struct htc_endpoint *endpoint,
 		if (!scat_req) {
 			/* no scatter resources  */
 			ath6kl_dbg(ATH6KL_DBG_HTC,
-				"no more scatter resources\n");
+				"htc tx no more scatter resources\n");
 			break;
 		}
 
-		ath6kl_dbg(ATH6KL_DBG_HTC, "pkts to scatter: %d\n",
+		ath6kl_dbg(ATH6KL_DBG_HTC, "htc tx pkts to scatter: %d\n",
 			   n_scat);
 
 		scat_req->len = 0;
@@ -480,7 +477,7 @@ static void ath6kl_htc_tx_bundle(struct htc_endpoint *endpoint,
 		tot_pkts_bundle += scat_req->scat_entries;
 
 		ath6kl_dbg(ATH6KL_DBG_HTC,
-			   "send scatter total bytes: %d , entries: %d\n",
+			   "htc tx scatter bytes %d entries %d\n",
 			   scat_req->len, scat_req->scat_entries);
 		ath6kl_hif_submit_scat_req(target->dev, scat_req, false);
 
@@ -490,8 +487,8 @@ static void ath6kl_htc_tx_bundle(struct htc_endpoint *endpoint,
 
 	*sent_bundle = n_sent_bundle;
 	*n_bundle_pkts = tot_pkts_bundle;
-	ath6kl_dbg(ATH6KL_DBG_HTC, "%s (sent:%d)\n",
-		   __func__, n_sent_bundle);
+	ath6kl_dbg(ATH6KL_DBG_HTC, "htc tx bundle sent %d pkts\n",
+		   n_sent_bundle);
 
 	return;
 }
@@ -510,7 +507,7 @@ static void ath6kl_htc_tx_from_queue(struct htc_target *target,
 	if (endpoint->tx_proc_cnt > 1) {
 		endpoint->tx_proc_cnt--;
 		spin_unlock_bh(&target->tx_lock);
-		ath6kl_dbg(ATH6KL_DBG_HTC, "htc_try_send (busy)\n");
+		ath6kl_dbg(ATH6KL_DBG_HTC, "htc tx busy\n");
 		return;
 	}
 
@@ -589,14 +586,11 @@ static bool ath6kl_htc_tx_try(struct htc_target *target,
 
 	if (overflow)
 		ath6kl_dbg(ATH6KL_DBG_HTC,
-			   "ep %d, tx queue will overflow :%d , tx depth:%d, max:%d\n",
-			   endpoint->eid, overflow, txq_depth,
+			   "htc tx overflow ep %d depth %d max %d\n",
+			   endpoint->eid, txq_depth,
 			   endpoint->max_txq_depth);
 
 	if (overflow && ep_cb.tx_full) {
-		ath6kl_dbg(ATH6KL_DBG_HTC,
-			   "indicating overflowed tx packet: 0x%p\n", tx_pkt);
-
 		if (ep_cb.tx_full(endpoint->target, tx_pkt) ==
 		    HTC_SEND_FULL_DROP) {
 			endpoint->ep_st.tx_dropped += 1;
@@ -630,7 +624,7 @@ static void htc_chk_ep_txq(struct htc_target *target)
 		spin_lock_bh(&target->tx_lock);
 		if (!list_empty(&endpoint->txq)) {
 			ath6kl_dbg(ATH6KL_DBG_HTC,
-				   "ep %d has %d credits and %d packets in tx queue\n",
+				   "htc creds ep %d credits %d pkts %d\n",
 				   cred_dist->endpoint,
 				   endpoint->cred_dist.credits,
 				   get_queue_depth(&endpoint->txq));
@@ -737,7 +731,7 @@ int ath6kl_htc_tx(struct htc_target *target, struct htc_packet *packet)
 	struct list_head queue;
 
 	ath6kl_dbg(ATH6KL_DBG_HTC,
-		   "htc_tx: ep id: %d, buf: 0x%p, len: %d\n",
+		   "htc tx ep id %d buf 0x%p len %d\n",
 		   packet->endpoint, packet->buf, packet->act_len);
 
 	if (packet->endpoint >= ENDPOINT_MAX) {
@@ -788,7 +782,7 @@ void ath6kl_htc_flush_txep(struct htc_target *target,
 		packet->status = -ECANCELED;
 		list_del(&packet->list);
 		ath6kl_dbg(ATH6KL_DBG_HTC,
-			"flushing tx pkt:0x%p, len:%d, ep:%d tag:0x%X\n",
+			"htc tx flushing pkt 0x%p len %d  ep %d tag 0x%x\n",
 			packet, packet->act_len,
 			packet->endpoint, packet->info.tx.tag);
 
@@ -844,7 +838,8 @@ void ath6kl_htc_indicate_activity_change(struct htc_target *target,
 		endpoint->cred_dist.txq_depth =
 			get_queue_depth(&endpoint->txq);
 
-		ath6kl_dbg(ATH6KL_DBG_HTC, "ctxt:0x%p dist:0x%p\n",
+		ath6kl_dbg(ATH6KL_DBG_HTC,
+			   "htc tx activity ctxt 0x%p dist 0x%p\n",
 			   target->cred_dist_cntxt, &target->cred_dist_list);
 
 		ath6k_credit_distribute(target->cred_dist_cntxt,
@@ -919,15 +914,15 @@ static int ath6kl_htc_rx_packet(struct htc_target *target,
 	padded_len = CALC_TXRX_PADDED_LEN(target, rx_len);
 
 	if (padded_len > packet->buf_len) {
-		ath6kl_err("not enough receive space for packet - padlen:%d recvlen:%d bufferlen:%d\n",
+		ath6kl_err("not enough receive space for packet - padlen %d recvlen %d bufferlen %d\n",
 			   padded_len, rx_len, packet->buf_len);
 		return -ENOMEM;
 	}
 
 	ath6kl_dbg(ATH6KL_DBG_HTC,
-		   "dev_rx_pkt (0x%p : hdr:0x%X) padded len: %d mbox:0x%X (mode:%s)\n",
+		   "htc rx 0x%p hdr x%x len %d mbox 0x%x\n",
 		   packet, packet->info.rx.exp_hdr,
-		   padded_len, dev->ar->mbox_info.htc_addr, "sync");
+		   padded_len, dev->ar->mbox_info.htc_addr);
 
 	status = hif_read_write_sync(dev->ar,
 				     dev->ar->mbox_info.htc_addr,
@@ -1138,7 +1133,7 @@ static int ath6kl_htc_rx_alloc(struct htc_target *target,
 
 			endpoint->ep_st.rx_bundle_from_hdr += 1;
 			ath6kl_dbg(ATH6KL_DBG_HTC,
-				   "htc hdr indicates :%d msg can be fetched as a bundle\n",
+				   "htc rx bundle pkts %d\n",
 				   n_msg);
 		} else
 			/* HTC header only indicates 1 message to fetch */
@@ -1191,8 +1186,8 @@ static void htc_ctrl_rx(struct htc_target *context, struct htc_packet *packets)
 		ath6kl_err("htc_ctrl_rx, got message with len:%zu\n",
 			packets->act_len + HTC_HDR_LENGTH);
 
-		ath6kl_dbg_dump(ATH6KL_DBG_RAW_BYTES,
-				"Unexpected ENDPOINT 0 Message", "",
+		ath6kl_dbg_dump(ATH6KL_DBG_HTC,
+				"htc rx unexpected endpoint 0 message", "",
 				packets->buf - HTC_HDR_LENGTH,
 				packets->act_len + HTC_HDR_LENGTH);
 	}
@@ -1210,7 +1205,7 @@ static void htc_proc_cred_rpt(struct htc_target *target,
 	bool dist = false;
 
 	ath6kl_dbg(ATH6KL_DBG_HTC,
-		   "htc_proc_cred_rpt, credit report entries:%d\n", n_entries);
+		   "htc creds report entries %d\n", n_entries);
 
 	spin_lock_bh(&target->tx_lock);
 
@@ -1223,8 +1218,9 @@ static void htc_proc_cred_rpt(struct htc_target *target,
 
 		endpoint = &target->endpoint[rpt->eid];
 
-		ath6kl_dbg(ATH6KL_DBG_HTC, " ep %d got %d credits\n",
-			rpt->eid, rpt->credits);
+		ath6kl_dbg(ATH6KL_DBG_HTC,
+			   "htc creds report ep %d credits %d\n",
+			   rpt->eid, rpt->credits);
 
 		endpoint->ep_st.tx_cred_rpt += 1;
 		endpoint->ep_st.cred_retnd += rpt->credits;
@@ -1265,7 +1261,7 @@ static void htc_proc_cred_rpt(struct htc_target *target,
 	}
 
 	ath6kl_dbg(ATH6KL_DBG_HTC,
-		   "report indicated %d credits to distribute\n",
+		   "htc creds report tot_credits %d\n",
 		   tot_credits);
 
 	if (dist) {
@@ -1273,7 +1269,7 @@ static void htc_proc_cred_rpt(struct htc_target *target,
 		 * This was a credit return based on a completed send
 		 * operations note, this is done with the lock held
 		 */
-		ath6kl_dbg(ATH6KL_DBG_HTC, "ctxt:0x%p dist:0x%p\n",
+		ath6kl_dbg(ATH6KL_DBG_HTC, "htc creds ctxt 0x%p dist 0x%p\n",
 			   target->cred_dist_cntxt, &target->cred_dist_list);
 
 		ath6k_credit_distribute(target->cred_dist_cntxt,
@@ -1321,13 +1317,14 @@ static int htc_parse_trailer(struct htc_target *target,
 		    && next_lk_ahds) {
 
 			ath6kl_dbg(ATH6KL_DBG_HTC,
-				   "lk_ahd report found (pre valid:0x%X, post valid:0x%X)\n",
+				   "htc rx lk_ahd found pre_valid 0x%x post_valid 0x%x\n",
 				   lk_ahd->pre_valid, lk_ahd->post_valid);
 
 			/* look ahead bytes are valid, copy them over */
 			memcpy((u8 *)&next_lk_ahds[0], lk_ahd->lk_ahd, 4);
 
-			ath6kl_dbg_dump(ATH6KL_DBG_RAW_BYTES, "Next Look Ahead",
+			ath6kl_dbg_dump(ATH6KL_DBG_HTC,
+					"htc rx next look ahead",
 					"", next_lk_ahds, 4);
 
 			*n_lk_ahds = 1;
@@ -1346,7 +1343,7 @@ static int htc_parse_trailer(struct htc_target *target,
 			bundle_lkahd_rpt =
 				(struct htc_bundle_lkahd_rpt *) record_buf;
 
-			ath6kl_dbg_dump(ATH6KL_DBG_RAW_BYTES, "Bundle lk_ahd",
+			ath6kl_dbg_dump(ATH6KL_DBG_HTC, "htc rx bundle lk_ahd",
 					"", record_buf, record->len);
 
 			for (i = 0; i < len; i++) {
@@ -1378,10 +1375,8 @@ static int htc_proc_trailer(struct htc_target *target,
 	u8 *record_buf;
 	u8 *orig_buf;
 
-	ath6kl_dbg(ATH6KL_DBG_HTC, "+htc_proc_trailer (len:%d)\n", len);
-
-	ath6kl_dbg_dump(ATH6KL_DBG_RAW_BYTES, "Recv Trailer", "",
-			buf, len);
+	ath6kl_dbg(ATH6KL_DBG_HTC, "htc rx trailer len %d\n", len);
+	ath6kl_dbg_dump(ATH6KL_DBG_HTC, NULL, "", buf, len);
 
 	orig_buf = buf;
 	orig_len = len;
@@ -1418,7 +1413,7 @@ static int htc_proc_trailer(struct htc_target *target,
 	}
 
 	if (status)
-		ath6kl_dbg_dump(ATH6KL_DBG_RAW_BYTES, "BAD Recv Trailer",
+		ath6kl_dbg_dump(ATH6KL_DBG_HTC, "htc rx bad trailer",
 				"", orig_buf, orig_len);
 
 	return status;
@@ -1436,7 +1431,8 @@ static int ath6kl_htc_rx_process_hdr(struct htc_target *target,
 	if (n_lkahds != NULL)
 		*n_lkahds = 0;
 
-	ath6kl_dbg_dump(ATH6KL_DBG_RAW_BYTES, "HTC Recv PKT", "htc ",
+	/* FIXME: is this needed? */
+	ath6kl_dbg_dump(ATH6KL_DBG_HTC, "htc rx", "htc rx",
 			packet->buf, packet->act_len);
 
 	/*
@@ -1480,9 +1476,9 @@ static int ath6kl_htc_rx_process_hdr(struct htc_target *target,
 	if (lk_ahd != packet->info.rx.exp_hdr) {
 		ath6kl_err("%s(): lk_ahd mismatch! (pPkt:0x%p flags:0x%X)\n",
 			   __func__, packet, packet->info.rx.rx_flags);
-		ath6kl_dbg_dump(ATH6KL_DBG_RAW_BYTES, "Expected Message lk_ahd",
+		ath6kl_dbg_dump(ATH6KL_DBG_HTC, "htc rx expected lk_ahd",
 				"", &packet->info.rx.exp_hdr, 4);
-		ath6kl_dbg_dump(ATH6KL_DBG_RAW_BYTES, "Current Frame Header",
+		ath6kl_dbg_dump(ATH6KL_DBG_HTC, "htc rx current header",
 				"", (u8 *)&lk_ahd, sizeof(lk_ahd));
 		status = -ENOMEM;
 		goto fail_rx;
@@ -1518,13 +1514,13 @@ static int ath6kl_htc_rx_process_hdr(struct htc_target *target,
 
 fail_rx:
 	if (status)
-		ath6kl_dbg_dump(ATH6KL_DBG_RAW_BYTES, "BAD HTC Recv PKT",
-				"", packet->buf,
-				packet->act_len < 256 ? packet->act_len : 256);
+		ath6kl_dbg_dump(ATH6KL_DBG_HTC, "htc rx bad packet",
+				"", packet->buf, packet->act_len);
 	else {
+		/* FIXME: is this needed? */
 		if (packet->act_len > 0)
-			ath6kl_dbg_dump(ATH6KL_DBG_RAW_BYTES,
-					"HTC - Application Msg", "",
+			ath6kl_dbg_dump(ATH6KL_DBG_HTC,
+					"htc rx application message", "",
 					packet->buf, packet->act_len);
 	}
 
@@ -1535,7 +1531,7 @@ static void ath6kl_htc_rx_complete(struct htc_endpoint *endpoint,
 				   struct htc_packet *packet)
 {
 		ath6kl_dbg(ATH6KL_DBG_HTC,
-			   "htc calling ep %d recv callback on packet 0x%p\n",
+			   "htc rx complete ep %d packet 0x%p\n",
 			   endpoint->eid, packet);
 		endpoint->ep_cb.rx(endpoint->target, packet);
 }
@@ -1572,8 +1568,8 @@ static int ath6kl_htc_rx_bundle(struct htc_target *target,
 	len = 0;
 
 	ath6kl_dbg(ATH6KL_DBG_HTC,
-		   "%s(): (numpackets: %d , actual : %d)\n",
-		   __func__, get_queue_depth(rxq), n_scat_pkt);
+		   "htc rx bundle depth %d pkts %d\n",
+		   get_queue_depth(rxq), n_scat_pkt);
 
 	scat_req = hif_scatter_req_get(target->dev->ar);
 
@@ -1898,7 +1894,7 @@ static struct htc_packet *htc_wait_for_ctrl_msg(struct htc_target *target)
 		return NULL;
 
 	ath6kl_dbg(ATH6KL_DBG_HTC,
-		"htc_wait_for_ctrl_msg: look_ahead : 0x%X\n", look_ahead);
+		"htc rx wait ctrl look_ahead 0x%X\n", look_ahead);
 
 	htc_hdr = (struct htc_frame_hdr *)&look_ahead;
 
@@ -1963,7 +1959,7 @@ int ath6kl_htc_add_rxbuf_multiple(struct htc_target *target,
 	depth = get_queue_depth(pkt_queue);
 
 	ath6kl_dbg(ATH6KL_DBG_HTC,
-		"htc_add_rxbuf_multiple: ep id: %d, cnt:%d, len: %d\n",
+		"htc rx add multiple ep id %d cnt %d len %d\n",
 		first_pkt->endpoint, depth, first_pkt->buf_len);
 
 	endpoint = &target->endpoint[first_pkt->endpoint];
@@ -1989,7 +1985,7 @@ int ath6kl_htc_add_rxbuf_multiple(struct htc_target *target,
 	if (target->rx_st_flags & HTC_RECV_WAIT_BUFFERS) {
 		if (target->ep_waiting == first_pkt->endpoint) {
 			ath6kl_dbg(ATH6KL_DBG_HTC,
-				"receiver was blocked on ep:%d, unblocking.\n",
+				"htc rx blocked on ep %d, unblocking\n",
 				target->ep_waiting);
 			target->rx_st_flags &= ~HTC_RECV_WAIT_BUFFERS;
 			target->ep_waiting = ENDPOINT_MAX;
@@ -2024,7 +2020,7 @@ void ath6kl_htc_flush_rx_buf(struct htc_target *target)
 			list_del(&packet->list);
 			spin_unlock_bh(&target->rx_lock);
 			ath6kl_dbg(ATH6KL_DBG_HTC,
-				   "flushing rx pkt:0x%p, len:%d, ep:%d\n",
+				   "htc rx flush pkt 0x%p  len %d  ep %d\n",
 				   packet, packet->buf_len,
 				   packet->endpoint);
 			dev_kfree_skb(packet->pkt_cntxt);
@@ -2048,7 +2044,7 @@ int ath6kl_htc_conn_service(struct htc_target *target,
 	int status = 0;
 
 	ath6kl_dbg(ATH6KL_DBG_HTC,
-		   "htc_conn_service, target:0x%p service id:0x%X\n",
+		   "htc connect service target 0x%p service id 0x%x\n",
 		   target, conn_req->svc_id);
 
 	if (conn_req->svc_id == HTC_CTRL_RSVD_SVC) {
@@ -2221,7 +2217,7 @@ static void htc_setup_msg_bndl(struct htc_target *target)
 				       target->msg_per_bndl_max);
 
 	ath6kl_dbg(ATH6KL_DBG_HTC,
-		   "htc bundling allowed. max msg per htc bundle: %d\n",
+		   "htc bundling allowed msg_per_bndl_max %d\n",
 		   target->msg_per_bndl_max);
 
 	/* Max rx bundle size is limited by the max tx bundle size */
@@ -2230,7 +2226,7 @@ static void htc_setup_msg_bndl(struct htc_target *target)
 	target->max_tx_bndl_sz = min(HIF_MBOX0_EXT_WIDTH,
 				     target->max_xfer_szper_scatreq);
 
-	ath6kl_dbg(ATH6KL_DBG_HTC, "max recv: %d max send: %d\n",
+	ath6kl_dbg(ATH6KL_DBG_HTC, "htc max_rx_bndl_sz %d max_tx_bndl_sz %d\n",
 		   target->max_rx_bndl_sz, target->max_tx_bndl_sz);
 
 	if (target->max_tx_bndl_sz)
@@ -2285,7 +2281,7 @@ int ath6kl_htc_wait_target(struct htc_target *target)
 	target->tgt_cred_sz = le16_to_cpu(rdy_msg->ver2_0_info.cred_sz);
 
 	ath6kl_dbg(ATH6KL_DBG_HTC,
-		   "target ready: credits: %d credit size: %d\n",
+		   "htc target ready credits %d size %d\n",
 		   target->tgt_creds, target->tgt_cred_sz);
 
 	/* check if this is an extended ready message */
@@ -2299,7 +2295,7 @@ int ath6kl_htc_wait_target(struct htc_target *target)
 		target->msg_per_bndl_max = 0;
 	}
 
-	ath6kl_dbg(ATH6KL_DBG_HTC, "using htc protocol version : %s (%d)\n",
+	ath6kl_dbg(ATH6KL_DBG_HTC, "htc using protocol %s (%d)\n",
 		  (target->htc_tgt_ver == HTC_VERSION_2P0) ? "2.0" : ">= 2.1",
 		  target->htc_tgt_ver);
 

