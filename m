Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4339 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751368Ab3FZMf2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Jun 2013 08:35:28 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH V2 6/9] brcmfmac: tag packet in the netdev transmit
 callback
Date: Wed, 26 Jun 2013 14:35:10 +0200
Message-ID: <1372250110-19917-1-git-send-email-arend@broadcom.com> (sfid-20130626_143548_539765_A9C2B7AA)
In-Reply-To: <1372249222-4858-7-git-send-email-arend@broadcom.com>
References: <1372249222-4858-7-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Transmit packets needs to be tagged in order to receive a tx status
feedback from the firmware. Determine the tag in the netdev transmit
callback instead of determining the tag just before transfer to the
device. This reduces the number of exception flows and hence makes
the driver code simpler.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
Found a checkpatch warning after sending the patch. This patch
replaces the previous patch with message ID:

Message-ID: <1372249222-4858-7-git-send-email-arend@broadcom.com>

---
 drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c |  130 ++++++++------------
 1 file changed, 48 insertions(+), 82 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
index e4fd13a..44b3192 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
@@ -1575,21 +1575,14 @@ int brcmf_fws_hdrpull(struct brcmf_pub *drvr, int ifidx, s16 signal_len,
 	return 0;
 }
 
-static int brcmf_fws_precommit_skb(struct brcmf_fws_info *fws, int fifo,
+static void brcmf_fws_precommit_skb(struct brcmf_fws_info *fws, int fifo,
 				   struct sk_buff *p)
 {
 	struct brcmf_skbuff_cb *skcb = brcmf_skbcb(p);
 	struct brcmf_fws_mac_descriptor *entry = skcb->mac;
-	int rc = 0;
-	bool first_time;
-	int hslot = BRCMF_FWS_HANGER_MAXITEMS;
-	u8 free_ctr;
 	u8 flags;
 
-	first_time = skcb->state != BRCMF_FWS_SKBSTATE_SUPPRESSED;
-
 	brcmf_skb_if_flags_set_field(p, TRANSMIT, 1);
-	brcmf_skb_htod_tag_set_field(p, FIFO, fifo);
 	brcmf_skb_htod_tag_set_field(p, GENERATION, entry->generation);
 	flags = BRCMF_FWS_HTOD_FLAG_PKTFROMHOST;
 	if (brcmf_skb_if_flags_get_field(p, REQUESTED)) {
@@ -1600,80 +1593,36 @@ static int brcmf_fws_precommit_skb(struct brcmf_fws_info *fws, int fifo,
 		flags |= BRCMF_FWS_HTOD_FLAG_PKT_REQUESTED;
 	}
 	brcmf_skb_htod_tag_set_field(p, FLAGS, flags);
-	if (first_time) {
-		/* obtaining free slot may fail, but that will be caught
-		 * by the hanger push. This assures the packet has a BDC
-		 * header upon return.
-		 */
-		hslot = brcmf_fws_hanger_get_free_slot(&fws->hanger);
-		free_ctr = entry->seq[fifo];
-		brcmf_skb_htod_tag_set_field(p, HSLOT, hslot);
-		brcmf_skb_htod_tag_set_field(p, FREERUN, free_ctr);
-		rc = brcmf_fws_hanger_pushpkt(&fws->hanger, p, hslot);
-		if (rc)
-			brcmf_err("hanger push failed: rc=%d\n", rc);
-	}
-
-	if (rc == 0)
-		brcmf_fws_hdrpush(fws, p);
-
-	return rc;
+	brcmf_fws_hdrpush(fws, p);
 }
 
-static void
-brcmf_fws_rollback_toq(struct brcmf_fws_info *fws,
-		       struct sk_buff *skb, int fifo)
+static void brcmf_fws_rollback_toq(struct brcmf_fws_info *fws,
+				   struct sk_buff *skb, int fifo)
 {
-	/*
-	put the packet back to the head of queue
-
-	- suppressed packet goes back to suppress sub-queue
-	- pull out the header, if new or delayed packet
-
-	Note: hslot is used only when header removal is done.
-	*/
 	struct brcmf_fws_mac_descriptor *entry;
-	enum brcmf_fws_skb_state state;
 	struct sk_buff *pktout;
+	int qidx, hslot;
 	int rc = 0;
-	int hslot;
 
-	state = brcmf_skbcb(skb)->state;
 	entry = brcmf_skbcb(skb)->mac;
-	hslot = brcmf_skb_htod_tag_get_field(skb, HSLOT);
-
-	if (entry != NULL) {
-		if (state == BRCMF_FWS_SKBSTATE_SUPPRESSED) {
-			/* wl-header is saved for suppressed packets */
-			pktout = brcmu_pktq_penq_head(&entry->psq, 2 * fifo + 1,
-						      skb);
-			if (pktout == NULL) {
-				brcmf_err("suppress queue full\n");
-				rc = -ENOSPC;
-			}
-		} else {
-			/* delay-q packets are going to delay-q */
-			pktout = brcmu_pktq_penq_head(&entry->psq,
-						      2 * fifo, skb);
-			if (pktout == NULL) {
-				brcmf_err("delay queue full\n");
-				rc = -ENOSPC;
-			}
-
-			/* free the hanger slot */
-			brcmf_fws_hanger_poppkt(&fws->hanger, hslot, &pktout,
-						true);
-
-			/* decrement sequence count */
-			entry->seq[fifo]--;
+	if (entry->occupied) {
+		qidx = 2 * fifo;
+		if (brcmf_skbcb(skb)->state == BRCMF_FWS_SKBSTATE_SUPPRESSED)
+			qidx++;
+
+		pktout = brcmu_pktq_penq_head(&entry->psq, qidx, skb);
+		if (pktout == NULL) {
+			brcmf_err("%s queue %d full\n", entry->name, qidx);
+			rc = -ENOSPC;
 		}
 	} else {
-		brcmf_err("no mac entry linked\n");
+		brcmf_err("%s entry removed\n", entry->name);
 		rc = -ENOENT;
 	}
 
 	if (rc) {
 		fws->stats.rollback_failed++;
+		hslot = brcmf_skb_htod_tag_get_field(skb, HSLOT);
 		brcmf_fws_txs_process(fws, BRCMF_FWS_TXSTATUS_HOST_TOSSED,
 				      hslot, 0);
 	} else {
@@ -1720,15 +1669,10 @@ static int brcmf_fws_commit_skb(struct brcmf_fws_info *fws, int fifo,
 	if (IS_ERR(entry))
 		return PTR_ERR(entry);
 
-	rc = brcmf_fws_precommit_skb(fws, fifo, skb);
-	if (rc < 0) {
-		fws->stats.generic_error++;
-		goto rollback;
-	}
-
-	brcmf_dbg(DATA, "%s flags %X htod %X\n", entry->name, skcb->if_flags,
-		  skcb->htod);
+	brcmf_fws_precommit_skb(fws, fifo, skb);
 	rc = brcmf_bus_txdata(bus, skb);
+	brcmf_dbg(DATA, "%s flags %X htod %X bus_tx %d\n", entry->name,
+		  skcb->if_flags, skcb->htod, rc);
 	if (rc < 0) {
 		brcmf_proto_hdrpull(fws->drvr, false, &ifidx, skb);
 		goto rollback;
@@ -1737,7 +1681,6 @@ static int brcmf_fws_commit_skb(struct brcmf_fws_info *fws, int fifo,
 	entry->transit_count++;
 	if (entry->suppressed)
 		entry->suppr_transit_count++;
-	entry->seq[fifo]++;
 	fws->stats.pkt2bus++;
 	fws->stats.send_pkts[fifo]++;
 	if (brcmf_skb_if_flags_get_field(skb, REQUESTED))
@@ -1750,6 +1693,24 @@ rollback:
 	return rc;
 }
 
+static int brcmf_fws_assign_htod(struct brcmf_fws_info *fws, struct sk_buff *p,
+				  int fifo)
+{
+	struct brcmf_skbuff_cb *skcb = brcmf_skbcb(p);
+	int rc, hslot;
+
+	hslot = brcmf_fws_hanger_get_free_slot(&fws->hanger);
+	brcmf_skb_htod_tag_set_field(p, HSLOT, hslot);
+	brcmf_skb_htod_tag_set_field(p, FREERUN, skcb->mac->seq[fifo]);
+	brcmf_skb_htod_tag_set_field(p, FIFO, fifo);
+	rc = brcmf_fws_hanger_pushpkt(&fws->hanger, p, hslot);
+	if (!rc)
+		skcb->mac->seq[fifo]++;
+	else
+		fws->stats.generic_error++;
+	return rc;
+}
+
 int brcmf_fws_process_skb(struct brcmf_if *ifp, struct sk_buff *skb)
 {
 	struct brcmf_pub *drvr = ifp->drvr;
@@ -1778,22 +1739,27 @@ int brcmf_fws_process_skb(struct brcmf_if *ifp, struct sk_buff *skb)
 
 	/* set control buffer information */
 	skcb->if_flags = 0;
-	skcb->mac = brcmf_fws_macdesc_find(fws, ifp, eh->h_dest);
 	skcb->state = BRCMF_FWS_SKBSTATE_NEW;
 	brcmf_skb_if_flags_set_field(skb, INDEX, ifp->ifidx);
 	if (!multicast)
 		fifo = brcmf_fws_prio2fifo[skb->priority];
 
-	brcmf_dbg(DATA, "%s mac %pM multi %d fifo %d\n", skcb->mac->name,
-		  eh->h_dest, multicast, fifo);
-
 	brcmf_fws_lock(drvr, flags);
-	brcmf_fws_enq(fws, BRCMF_FWS_SKBSTATE_DELAYED, fifo, skb);
 	if (fifo != BRCMF_FWS_FIFO_AC_BE && fifo < BRCMF_FWS_FIFO_BCMC)
 		fws->borrow_defer_timestamp = jiffies +
 					      BRCMF_FWS_BORROW_DEFER_PERIOD;
+
+	skcb->mac = brcmf_fws_macdesc_find(fws, ifp, eh->h_dest);
+	brcmf_dbg(DATA, "%s mac %pM multi %d fifo %d\n", skcb->mac->name,
+		  eh->h_dest, multicast, fifo);
+	if (!brcmf_fws_assign_htod(fws, skb, fifo)) {
+		brcmf_fws_enq(fws, BRCMF_FWS_SKBSTATE_DELAYED, fifo, skb);
+		brcmf_fws_schedule_deq(fws);
+	} else {
+		brcmf_err("drop skb: no hanger slot\n");
+		brcmu_pkt_buf_free_skb(skb);
+	}
 	brcmf_fws_unlock(drvr, flags);
-	brcmf_fws_schedule_deq(fws);
 	return 0;
 }
 
-- 
1.7.10.4


