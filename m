Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4842 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932700Ab3FFLTR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Jun 2013 07:19:17 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Hante Meuleman" <meuleman@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 18/22] brcmfmac: Always use fifo_credits, also for
 requested credits.
Date: Thu, 6 Jun 2013 13:18:03 +0200
Message-ID: <1370517487-14395-19-git-send-email-arend@broadcom.com> (sfid-20130606_131927_558377_818930BC)
In-Reply-To: <1370517487-14395-1-git-send-email-arend@broadcom.com>
References: <1370517487-14395-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

Currently firmware requested credits do not require fifo credits.
>From a buffer management point of view this is incorrect. So
firwmware requested credits require also fifo credits before the
packet can be transferred to the host.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.c  |   10 +-
 drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.h  |    3 +-
 drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c |  163 +++++++++-----------
 3 files changed, 79 insertions(+), 97 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.c
index 202869c..ce50686 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.c
@@ -179,11 +179,11 @@ ssize_t brcmf_debugfs_fws_stats_read(struct file *f, char __user *data,
 			fwstats->send_pkts[0], fwstats->send_pkts[1],
 			fwstats->send_pkts[2], fwstats->send_pkts[3],
 			fwstats->send_pkts[4],
-			fwstats->fifo_credits_sent[0],
-			fwstats->fifo_credits_sent[1],
-			fwstats->fifo_credits_sent[2],
-			fwstats->fifo_credits_sent[3],
-			fwstats->fifo_credits_sent[4]);
+			fwstats->requested_sent[0],
+			fwstats->requested_sent[1],
+			fwstats->requested_sent[2],
+			fwstats->requested_sent[3],
+			fwstats->requested_sent[4]);
 
 	return simple_read_from_buffer(data, count, ppos, buf, res);
 }
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.h b/drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.h
index 009c87b..451ebac 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.h
@@ -141,8 +141,7 @@ struct brcmf_fws_stats {
 	u32 header_pulls;
 	u32 pkt2bus;
 	u32 send_pkts[5];
-	u32 fifo_credits_sent[5];
-	u32 fifo_credits_back[6];
+	u32 requested_sent[5];
 	u32 generic_error;
 	u32 mac_update_failed;
 	u32 mac_ps_update_failed;
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
index 534507a..5d809c7 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
@@ -192,24 +192,21 @@ struct brcmf_skbuff_cb {
 /*
  * sk_buff control if flags
  *
- *	b[12]  - packet sent upon credit request.
- *	b[11]  - packet sent upon packet request.
+ *	b[11]  - packet sent upon firmware request.
  *	b[10]  - packet only contains signalling data.
  *	b[9]   - packet is a tx packet.
- *	b[8]   - packet uses FIFO credit (non-pspoll).
+ *	b[8]   - packet used requested credit
  *	b[7]   - interface in AP mode.
  *	b[3:0] - interface index.
  */
-#define BRCMF_SKB_IF_FLAGS_REQ_CREDIT_MASK	0x1000
-#define BRCMF_SKB_IF_FLAGS_REQ_CREDIT_SHIFT	12
 #define BRCMF_SKB_IF_FLAGS_REQUESTED_MASK	0x0800
 #define BRCMF_SKB_IF_FLAGS_REQUESTED_SHIFT	11
 #define BRCMF_SKB_IF_FLAGS_SIGNAL_ONLY_MASK	0x0400
 #define BRCMF_SKB_IF_FLAGS_SIGNAL_ONLY_SHIFT	10
 #define BRCMF_SKB_IF_FLAGS_TRANSMIT_MASK        0x0200
 #define BRCMF_SKB_IF_FLAGS_TRANSMIT_SHIFT	9
-#define BRCMF_SKB_IF_FLAGS_CREDITCHECK_MASK	0x0100
-#define BRCMF_SKB_IF_FLAGS_CREDITCHECK_SHIFT	8
+#define BRCMF_SKB_IF_FLAGS_REQ_CREDIT_MASK	0x0100
+#define BRCMF_SKB_IF_FLAGS_REQ_CREDIT_SHIFT	8
 #define BRCMF_SKB_IF_FLAGS_IF_AP_MASK		0x0080
 #define BRCMF_SKB_IF_FLAGS_IF_AP_SHIFT		7
 #define BRCMF_SKB_IF_FLAGS_INDEX_MASK		0x000f
@@ -311,12 +308,15 @@ enum brcmf_fws_fifo {
  *	firmware suppress the packet as device is already in PS mode.
  * @BRCMF_FWS_TXSTATUS_FW_TOSSED:
  *	firmware tossed the packet.
+ * @BRCMF_FWS_TXSTATUS_HOST_TOSSED:
+ *	host tossed the packet.
  */
 enum brcmf_fws_txstatus {
 	BRCMF_FWS_TXSTATUS_DISCARD,
 	BRCMF_FWS_TXSTATUS_CORE_SUPPRESS,
 	BRCMF_FWS_TXSTATUS_FW_PS_SUPPRESS,
-	BRCMF_FWS_TXSTATUS_FW_TOSSED
+	BRCMF_FWS_TXSTATUS_FW_TOSSED,
+	BRCMF_FWS_TXSTATUS_HOST_TOSSED
 };
 
 enum brcmf_fws_fcmode {
@@ -639,6 +639,7 @@ static void brcmf_fws_init_mac_descriptor(struct brcmf_fws_mac_descriptor *desc,
 	desc->occupied = 1;
 	desc->state = BRCMF_FWS_STATE_OPEN;
 	desc->requested_credit = 0;
+	desc->requested_packet = 0;
 	/* depending on use may need ifp->bssidx instead */
 	desc->interface_id = ifidx;
 	desc->ac_bitmap = 0xff; /* update this when handling APSD */
@@ -654,6 +655,7 @@ void brcmf_fws_clear_mac_descriptor(struct brcmf_fws_mac_descriptor *desc)
 	desc->occupied = 0;
 	desc->state = BRCMF_FWS_STATE_CLOSE;
 	desc->requested_credit = 0;
+	desc->requested_packet = 0;
 }
 
 static struct brcmf_fws_mac_descriptor *
@@ -1050,35 +1052,35 @@ static int brcmf_fws_request_indicate(struct brcmf_fws_info *fws, u8 type,
 	return BRCMF_FWS_RET_OK_SCHEDULE;
 }
 
-static int brcmf_fws_macdesc_use_credit(struct brcmf_fws_mac_descriptor *entry,
-					struct sk_buff *skb)
+static void
+brcmf_fws_macdesc_use_req_credit(struct brcmf_fws_mac_descriptor *entry,
+				 struct sk_buff *skb)
 {
-	int use_credit = 1;
-
-	if (entry->state == BRCMF_FWS_STATE_CLOSE) {
-		if (entry->requested_credit > 0) {
-			/*
-			 * if the packet was pulled out while destination is in
-			 * closed state but had a non-zero packets requested,
-			 * then this should not count against the FIFO credit.
-			 * That is due to the fact that the firmware will
-			 * most likely hold onto this packet until a suitable
-			 * time later to push it to the appropriate AC FIFO.
-			 */
-			entry->requested_credit--;
-			brcmf_skb_if_flags_set_field(skb, REQ_CREDIT, 1);
-			use_credit = 0;
-		} else if (entry->requested_packet > 0) {
-			entry->requested_packet--;
-			brcmf_skb_if_flags_set_field(skb, REQUESTED, 1);
-			use_credit = 0;
-		}
+	if (entry->requested_credit > 0) {
+		entry->requested_credit--;
+		brcmf_skb_if_flags_set_field(skb, REQUESTED, 1);
+		brcmf_skb_if_flags_set_field(skb, REQ_CREDIT, 1);
+		if (entry->state != BRCMF_FWS_STATE_CLOSE)
+			brcmf_err("requested credit set while mac not closed!\n");
+	} else if (entry->requested_packet > 0) {
+		entry->requested_packet--;
+		brcmf_skb_if_flags_set_field(skb, REQUESTED, 1);
+		brcmf_skb_if_flags_set_field(skb, REQ_CREDIT, 0);
+		if (entry->state != BRCMF_FWS_STATE_CLOSE)
+			brcmf_err("requested packet set while mac not closed!\n");
 	} else {
-		WARN_ON(entry->requested_credit);
-		WARN_ON(entry->requested_packet);
+		brcmf_skb_if_flags_set_field(skb, REQUESTED, 0);
+		brcmf_skb_if_flags_set_field(skb, REQ_CREDIT, 0);
 	}
-	brcmf_skb_if_flags_set_field(skb, CREDITCHECK, use_credit);
-	return use_credit;
+}
+
+static void brcmf_fws_macdesc_return_req_credit(struct sk_buff *skb)
+{
+	struct brcmf_fws_mac_descriptor *entry = brcmf_skbcb(skb)->mac;
+
+	if ((brcmf_skb_if_flags_get_field(skb, REQ_CREDIT)) &&
+	    (entry->state == BRCMF_FWS_STATE_CLOSE))
+		entry->requested_credit++;
 }
 
 static void brcmf_fws_return_credits(struct brcmf_fws_info *fws,
@@ -1124,25 +1126,6 @@ static void brcmf_fws_schedule_deq(struct brcmf_fws_info *fws)
 		queue_work(fws->fws_wq, &fws->fws_dequeue_work);
 }
 
-static void brcmf_fws_skb_pickup_credit(struct brcmf_fws_info *fws, int fifo,
-				     struct sk_buff *p)
-{
-	struct brcmf_fws_mac_descriptor *entry = brcmf_skbcb(p)->mac;
-
-	if (brcmf_skbcb(p)->if_flags & BRCMF_SKB_IF_FLAGS_CREDITCHECK_MASK)
-		brcmf_fws_return_credits(fws, fifo, 1);
-	else if (brcmf_skb_if_flags_get_field(p, REQ_CREDIT) &&
-		 entry->state == BRCMF_FWS_STATE_CLOSE)
-		/*
-		 * if this packet did not count against FIFO credit, it
-		 * could have taken a requested_credit from the destination
-		 * entry (for pspoll etc.)
-		 */
-		entry->requested_credit++;
-
-	brcmf_fws_schedule_deq(fws);
-}
-
 static int brcmf_fws_enq(struct brcmf_fws_info *fws,
 			 enum brcmf_fws_skb_state state, int fifo,
 			 struct sk_buff *p)
@@ -1224,7 +1207,7 @@ static struct sk_buff *brcmf_fws_deq(struct brcmf_fws_info *fws, int fifo)
 		if  (p == NULL)
 			continue;
 
-		brcmf_fws_macdesc_use_credit(entry, p);
+		brcmf_fws_macdesc_use_req_credit(entry, p);
 
 		/* move dequeue position to ensure fair round-robin */
 		fws->deq_node_pos[fifo] = (node_pos + i + 1) % num_nodes;
@@ -1313,7 +1296,8 @@ brcmf_fws_txs_process(struct brcmf_fws_info *fws, u8 flags, u32 hslot,
 	} else if (flags == BRCMF_FWS_TXSTATUS_FW_PS_SUPPRESS) {
 		fws->stats.txs_supp_ps++;
 		remove_from_hanger = false;
-	} else if (flags == BRCMF_FWS_TXSTATUS_FW_TOSSED)
+	} else if ((flags == BRCMF_FWS_TXSTATUS_FW_TOSSED) ||
+		   (flags == BRCMF_FWS_TXSTATUS_HOST_TOSSED))
 		fws->stats.txs_tossed++;
 	else
 		brcmf_err("unexpected txstatus\n");
@@ -1340,9 +1324,13 @@ brcmf_fws_txs_process(struct brcmf_fws_info *fws, u8 flags, u32 hslot,
 
 	/* pick up the implicit credit from this packet */
 	fifo = brcmf_skb_htod_tag_get_field(skb, FIFO);
-	if (fws->fcmode == BRCMF_FWS_FCMODE_IMPLIED_CREDIT ||
-	    !(brcmf_skbcb(skb)->if_flags & BRCMF_SKB_IF_FLAGS_CREDITCHECK_MASK))
-		brcmf_fws_skb_pickup_credit(fws, fifo, skb);
+	if ((fws->fcmode == BRCMF_FWS_FCMODE_IMPLIED_CREDIT) ||
+	    (brcmf_skb_if_flags_get_field(skb, REQ_CREDIT)) ||
+	    (flags == BRCMF_FWS_TXSTATUS_HOST_TOSSED)) {
+		brcmf_fws_return_credits(fws, fifo, 1);
+		brcmf_fws_schedule_deq(fws);
+	}
+	brcmf_fws_macdesc_return_req_credit(skb);
 
 	if (!remove_from_hanger)
 		ret = brcmf_fws_txstatus_suppressed(fws, fifo, skb, genbit);
@@ -1588,7 +1576,7 @@ static int brcmf_fws_precommit_skb(struct brcmf_fws_info *fws, int fifo,
 	brcmf_skb_htod_tag_set_field(p, FIFO, fifo);
 	brcmf_skb_htod_tag_set_field(p, GENERATION, entry->generation);
 	flags = BRCMF_FWS_HTOD_FLAG_PKTFROMHOST;
-	if (!(skcb->if_flags & BRCMF_SKB_IF_FLAGS_CREDITCHECK_MASK)) {
+	if (brcmf_skb_if_flags_get_field(p, REQUESTED)) {
 		/*
 		 * Indicate that this packet is being sent in response to an
 		 * explicit request from the firmware side.
@@ -1636,6 +1624,7 @@ brcmf_fws_rollback_toq(struct brcmf_fws_info *fws,
 
 	state = brcmf_skbcb(skb)->state;
 	entry = brcmf_skbcb(skb)->mac;
+	hslot = brcmf_skb_htod_tag_get_field(skb, HSLOT);
 
 	if (entry != NULL) {
 		if (state == BRCMF_FWS_SKBSTATE_SUPPRESSED) {
@@ -1647,8 +1636,6 @@ brcmf_fws_rollback_toq(struct brcmf_fws_info *fws,
 				rc = -ENOSPC;
 			}
 		} else {
-			hslot = brcmf_skb_htod_tag_get_field(skb, HSLOT);
-
 			/* delay-q packets are going to delay-q */
 			pktout = brcmu_pktq_penq_head(&entry->psq,
 						      2 * fifo, skb);
@@ -1670,11 +1657,13 @@ brcmf_fws_rollback_toq(struct brcmf_fws_info *fws,
 	}
 
 	if (rc) {
-		brcmf_fws_bustxfail(fws, skb);
 		fws->stats.rollback_failed++;
+		brcmf_fws_txs_process(fws, BRCMF_FWS_TXSTATUS_HOST_TOSSED,
+				      hslot, 0);
 	} else {
 		fws->stats.rollback_success++;
-		brcmf_fws_skb_pickup_credit(fws, fifo, skb);
+		brcmf_fws_return_credits(fws, fifo, 1);
+		brcmf_fws_macdesc_return_req_credit(skb);
 	}
 }
 
@@ -1708,26 +1697,28 @@ static int brcmf_fws_consume_credit(struct brcmf_fws_info *fws, int fifo,
 	struct brcmf_fws_mac_descriptor *entry = brcmf_skbcb(skb)->mac;
 	int *credit = &fws->fifo_credit[fifo];
 
-	if (!brcmf_fws_macdesc_use_credit(entry, skb))
-		return 0;
-
 	if (fifo != BRCMF_FWS_FIFO_AC_BE)
 		fws->borrow_defer_timestamp = jiffies +
 					      BRCMF_FWS_BORROW_DEFER_PERIOD;
 
 	if (!(*credit)) {
 		/* Try to borrow a credit from other queue */
-		if (fifo == BRCMF_FWS_FIFO_AC_BE &&
-		    brcmf_fws_borrow_credit(fws) == 0)
-			return 0;
-
-		brcmf_dbg(DATA, "exit: ac=%d, credits depleted\n", fifo);
-		return -ENAVAIL;
+		if (fifo != BRCMF_FWS_FIFO_AC_BE ||
+		    (brcmf_fws_borrow_credit(fws) != 0)) {
+			brcmf_dbg(DATA, "ac=%d, credits depleted\n", fifo);
+			return -ENAVAIL;
+		}
+	} else {
+		(*credit)--;
+		if (!(*credit))
+			fws->fifo_credit_map &= ~(1 << fifo);
 	}
-	(*credit)--;
-	if (!(*credit))
-		fws->fifo_credit_map &= ~(1 << fifo);
-	brcmf_dbg(DATA, "exit: ac=%d, credits=%d\n", fifo, *credit);
+
+	brcmf_fws_macdesc_use_req_credit(entry, skb);
+
+	brcmf_dbg(DATA, "ac=%d, credits=%02d:%02d:%02d:%02d\n", fifo,
+		  fws->fifo_credit[0], fws->fifo_credit[1],
+		  fws->fifo_credit[2], fws->fifo_credit[3]);
 	return 0;
 }
 
@@ -1764,8 +1755,8 @@ static int brcmf_fws_commit_skb(struct brcmf_fws_info *fws, int fifo,
 	entry->seq[fifo]++;
 	fws->stats.pkt2bus++;
 	fws->stats.send_pkts[fifo]++;
-	if (brcmf_skbcb(skb)->if_flags & BRCMF_SKB_IF_FLAGS_CREDITCHECK_MASK)
-		fws->stats.fifo_credits_sent[fifo]++;
+	if (brcmf_skb_if_flags_get_field(skb, REQUESTED))
+		fws->stats.requested_sent[fifo]++;
 
 	return rc;
 
@@ -1888,10 +1879,7 @@ static void brcmf_fws_dequeue_worker(struct work_struct *worker)
 			skb = brcmf_fws_deq(fws, fifo);
 			if (!skb)
 				break;
-			if (brcmf_skbcb(skb)->if_flags &
-			    BRCMF_SKB_IF_FLAGS_CREDITCHECK_MASK)
-				fws->fifo_credit[fifo]--;
-
+			fws->fifo_credit[fifo]--;
 			if (brcmf_fws_commit_skb(fws, fifo, skb))
 				break;
 			if (fws->bus_flow_blocked)
@@ -2023,20 +2011,15 @@ bool brcmf_fws_fc_active(struct brcmf_fws_info *fws)
 void brcmf_fws_bustxfail(struct brcmf_fws_info *fws, struct sk_buff *skb)
 {
 	ulong flags;
-	int fifo;
+	u32 hslot;
 
 	if (brcmf_skbcb(skb)->state == BRCMF_FWS_SKBSTATE_TIM) {
 		brcmu_pkt_buf_free_skb(skb);
 		return;
 	}
 	brcmf_fws_lock(fws->drvr, flags);
-	brcmf_fws_txs_process(fws, BRCMF_FWS_TXSTATUS_FW_TOSSED,
-				   brcmf_skb_htod_tag_get_field(skb, HSLOT), 0);
-	/* the packet never reached firmware so reclaim credit */
-	if (fws->fcmode == BRCMF_FWS_FCMODE_EXPLICIT_CREDIT) {
-		fifo = brcmf_skb_htod_tag_get_field(skb, FIFO);
-		brcmf_fws_skb_pickup_credit(fws, fifo, skb);
-	}
+	hslot = brcmf_skb_htod_tag_get_field(skb, HSLOT);
+	brcmf_fws_txs_process(fws, BRCMF_FWS_TXSTATUS_HOST_TOSSED, hslot, 0);
 	brcmf_fws_unlock(fws->drvr, flags);
 }
 
-- 
1.7.10.4


