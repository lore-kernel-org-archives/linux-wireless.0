Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1406 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759258Ab3E2QjY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 May 2013 12:39:24 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH for 3.10 05/16] brcmfmac: explicitly indicate sk_buff is
 sent upon request credit
Date: Wed, 29 May 2013 18:38:55 +0200
Message-ID: <1369845546-31950-6-git-send-email-arend@broadcom.com> (sfid-20130529_183940_166928_18410FFF)
In-Reply-To: <1369845546-31950-1-git-send-email-arend@broadcom.com>
References: <1369845546-31950-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Firmware can request the driver for transmit packets using two different
signals. Only for one signal a flag was set in the sk_buff control
buffer. This patch adds explicit flag for the other signal as well.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c |  122 +++++++++-----------
 1 file changed, 53 insertions(+), 69 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
index ff8c2f0..9b7b65a 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
@@ -190,13 +190,16 @@ struct brcmf_skbuff_cb {
 /*
  * sk_buff control if flags
  *
- *	b[11]  - packet sent upon firmware request.
+ *	b[12]  - packet sent upon credit request.
+ *	b[11]  - packet sent upon packet request.
  *	b[10]  - packet only contains signalling data.
  *	b[9]   - packet is a tx packet.
  *	b[8]   - packet uses FIFO credit (non-pspoll).
  *	b[7]   - interface in AP mode.
  *	b[3:0] - interface index.
  */
+#define BRCMF_SKB_IF_FLAGS_REQ_CREDIT_MASK	0x1000
+#define BRCMF_SKB_IF_FLAGS_REQ_CREDIT_SHIFT	12
 #define BRCMF_SKB_IF_FLAGS_REQUESTED_MASK	0x0800
 #define BRCMF_SKB_IF_FLAGS_REQUESTED_SHIFT	11
 #define BRCMF_SKB_IF_FLAGS_SIGNAL_ONLY_MASK	0x0400
@@ -998,6 +1001,37 @@ static int brcmf_fws_request_indicate(struct brcmf_fws_info *fws, u8 type,
 	return BRCMF_FWS_RET_OK_SCHEDULE;
 }
 
+static int brcmf_fws_macdesc_use_credit(struct brcmf_fws_mac_descriptor *entry,
+					struct sk_buff *skb)
+{
+	int use_credit = 1;
+
+	if (entry->state == BRCMF_FWS_STATE_CLOSE) {
+		if (entry->requested_credit > 0) {
+			/*
+			 * if the packet was pulled out while destination is in
+			 * closed state but had a non-zero packets requested,
+			 * then this should not count against the FIFO credit.
+			 * That is due to the fact that the firmware will
+			 * most likely hold onto this packet until a suitable
+			 * time later to push it to the appropriate AC FIFO.
+			 */
+			entry->requested_credit--;
+			brcmf_skb_if_flags_set_field(skb, REQ_CREDIT, 1);
+			use_credit = 0;
+		} else if (entry->requested_packet > 0) {
+			entry->requested_packet--;
+			brcmf_skb_if_flags_set_field(skb, REQUESTED, 1);
+			use_credit = 0;
+		}
+	} else {
+		WARN_ON(entry->requested_credit);
+		WARN_ON(entry->requested_packet);
+	}
+	brcmf_skb_if_flags_set_field(skb, CREDITCHECK, use_credit);
+	return use_credit;
+}
+
 static void brcmf_fws_return_credits(struct brcmf_fws_info *fws,
 				     u8 fifo, u8 credits)
 {
@@ -1047,10 +1081,11 @@ static void brcmf_fws_skb_pickup_credit(struct brcmf_fws_info *fws, int fifo,
 
 	if (brcmf_skbcb(p)->if_flags & BRCMF_SKB_IF_FLAGS_CREDITCHECK_MASK)
 		brcmf_fws_return_credits(fws, fifo, 1);
-	else if (!brcmf_skb_if_flags_get_field(p, REQUESTED))
+	else if (brcmf_skb_if_flags_get_field(p, REQ_CREDIT) &&
+		 entry->state == BRCMF_FWS_STATE_CLOSE)
 		/*
 		 * if this packet did not count against FIFO credit, it
-		 * must have taken a requested_credit from the destination
+		 * could have taken a requested_credit from the destination
 		 * entry (for pspoll etc.)
 		 */
 		entry->requested_credit++;
@@ -1108,7 +1143,6 @@ static struct sk_buff *brcmf_fws_deq(struct brcmf_fws_info *fws, int fifo)
 	struct brcmf_fws_mac_descriptor *table;
 	struct brcmf_fws_mac_descriptor *entry;
 	struct sk_buff *p;
-	int use_credit = 1;
 	int num_nodes;
 	int node_pos;
 	int prec_out;
@@ -1143,26 +1177,7 @@ static struct sk_buff *brcmf_fws_deq(struct brcmf_fws_info *fws, int fifo)
 		if  (p == NULL)
 			continue;
 
-		/* did the packet come from suppress sub-queue? */
-		if (entry->requested_credit > 0) {
-			entry->requested_credit--;
-			/*
-			 * if the packet was pulled out while destination is in
-			 * closed state but had a non-zero packets requested,
-			 * then this should not count against the FIFO credit.
-			 * That is due to the fact that the firmware will
-			 * most likely hold onto this packet until a suitable
-			 * time later to push it to the appropriate AC FIFO.
-			 */
-			if (entry->state == BRCMF_FWS_STATE_CLOSE)
-				use_credit = 0;
-		} else if (entry->requested_packet > 0) {
-			entry->requested_packet--;
-			brcmf_skb_if_flags_set_field(p, REQUESTED, 1);
-			if (entry->state == BRCMF_FWS_STATE_CLOSE)
-				use_credit = 0;
-		}
-		brcmf_skb_if_flags_set_field(p, CREDITCHECK, use_credit);
+		brcmf_fws_macdesc_use_credit(entry, p);
 
 		/* move dequeue position to ensure fair round-robin */
 		fws->deq_node_pos[fifo] = (node_pos + i + 1) % num_nodes;
@@ -1664,13 +1679,6 @@ brcmf_fws_rollback_toq(struct brcmf_fws_info *fws,
 			/* decrement sequence count */
 			entry->seq[fifo]--;
 		}
-		/*
-		if this packet did not count against FIFO credit, it must have
-		taken a requested_credit from the firmware (for pspoll etc.)
-		*/
-		if (!(brcmf_skbcb(skb)->if_flags &
-		      BRCMF_SKB_IF_FLAGS_CREDITCHECK_MASK))
-			entry->requested_credit++;
 	} else {
 		brcmf_err("no mac entry linked\n");
 		rc = -ENOENT;
@@ -1679,10 +1687,12 @@ brcmf_fws_rollback_toq(struct brcmf_fws_info *fws,
 
 fail:
 	if (rc) {
-		brcmf_txfinalize(fws->drvr, skb, false);
+		brcmf_fws_bustxfail(fws, skb);
 		fws->stats.rollback_failed++;
-	} else
+	} else {
 		fws->stats.rollback_success++;
+		brcmf_fws_skb_pickup_credit(fws, fifo, skb);
+	}
 }
 
 static int brcmf_fws_borrow_credit(struct brcmf_fws_info *fws)
@@ -1710,30 +1720,10 @@ static int brcmf_fws_consume_credit(struct brcmf_fws_info *fws, int fifo,
 {
 	struct brcmf_fws_mac_descriptor *entry = brcmf_skbcb(skb)->mac;
 	int *credit = &fws->fifo_credit[fifo];
-	int use_credit = 1;
 
 	brcmf_dbg(TRACE, "enter: ac=%d, credits=%d\n", fifo, *credit);
 
-	if (entry->requested_credit > 0) {
-		/*
-		 * if the packet was pulled out while destination is in
-		 * closed state but had a non-zero packets requested,
-		 * then this should not count against the FIFO credit.
-		 * That is due to the fact that the firmware will
-		 * most likely hold onto this packet until a suitable
-		 * time later to push it to the appropriate AC FIFO.
-		 */
-		entry->requested_credit--;
-		if (entry->state == BRCMF_FWS_STATE_CLOSE)
-			use_credit = 0;
-	} else if (entry->requested_packet > 0) {
-		entry->requested_packet--;
-		brcmf_skb_if_flags_set_field(skb, REQUESTED, 1);
-		if (entry->state == BRCMF_FWS_STATE_CLOSE)
-			use_credit = 0;
-	}
-	brcmf_skb_if_flags_set_field(skb, CREDITCHECK, use_credit);
-	if (!use_credit) {
+	if (!brcmf_fws_macdesc_use_credit(entry, skb)) {
 		brcmf_dbg(TRACE, "exit: no creditcheck set\n");
 		return 0;
 	}
@@ -1842,9 +1832,7 @@ int brcmf_fws_process_skb(struct brcmf_if *ifp, struct sk_buff *skb)
 		drvr->fws->fifo_delay_map |= 1 << fifo;
 		brcmf_fws_enq(fws, BRCMF_FWS_SKBSTATE_DELAYED, fifo, skb);
 	} else {
-		if (brcmf_fws_commit_skb(fws, fifo, skb))
-			if (!multicast)
-				brcmf_fws_skb_pickup_credit(fws, fifo, skb);
+		brcmf_fws_commit_skb(fws, fifo, skb);
 	}
 	brcmf_fws_unlock(drvr, flags);
 	return 0;
@@ -1900,7 +1888,6 @@ static void brcmf_fws_dequeue_worker(struct work_struct *worker)
 	struct sk_buff *skb;
 	ulong flags;
 	int fifo;
-	int credit;
 
 	fws = container_of(worker, struct brcmf_fws_info, fws_dequeue_work);
 
@@ -1910,35 +1897,32 @@ static void brcmf_fws_dequeue_worker(struct work_struct *worker)
 	     fifo--) {
 		brcmf_dbg(TRACE, "fifo %d credit %d\n", fifo,
 			  fws->fifo_credit[fifo]);
-		for (credit = 0; credit < fws->fifo_credit[fifo]; /* nop */) {
+		while (fws->fifo_credit[fifo]) {
 			skb = brcmf_fws_deq(fws, fifo);
-			if (!skb || brcmf_fws_commit_skb(fws, fifo, skb))
+			if (!skb)
 				break;
 			if (brcmf_skbcb(skb)->if_flags &
 			    BRCMF_SKB_IF_FLAGS_CREDITCHECK_MASK)
-				credit++;
+				fws->fifo_credit[fifo]--;
+
+			if (brcmf_fws_commit_skb(fws, fifo, skb))
+				break;
 			if (fws->bus_flow_blocked)
 				break;
 		}
 		if ((fifo == BRCMF_FWS_FIFO_AC_BE) &&
-		    (credit == fws->fifo_credit[fifo]) &&
+		    (fws->fifo_credit[fifo] == 0) &&
 		    (!fws->bus_flow_blocked)) {
-			fws->fifo_credit[fifo] -= credit;
 			while (brcmf_fws_borrow_credit(fws) == 0) {
 				skb = brcmf_fws_deq(fws, fifo);
 				if (!skb) {
 					brcmf_fws_return_credits(fws, fifo, 1);
 					break;
 				}
-				if (brcmf_fws_commit_skb(fws, fifo, skb)) {
-					brcmf_fws_return_credits(fws, fifo, 1);
-					break;
-				}
+				brcmf_fws_commit_skb(fws, fifo, skb);
 				if (fws->bus_flow_blocked)
 					break;
 			}
-		} else {
-			fws->fifo_credit[fifo] -= credit;
 		}
 	}
 	brcmf_fws_unlock(fws->drvr, flags);
-- 
1.7.10.4


