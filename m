Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1743 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932345Ab3FFLV2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Jun 2013 07:21:28 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Hante Meuleman" <meuleman@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 08/22] brcmfmac: For FW signalling it is necessary to
 track gen bit.
Date: Thu, 6 Jun 2013 13:17:53 +0200
Message-ID: <1370517487-14395-9-git-send-email-arend@broadcom.com> (sfid-20130606_132158_976921_5075794A)
In-Reply-To: <1370517487-14395-1-git-send-email-arend@broadcom.com>
References: <1370517487-14395-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

Store gen bit on suppressed packet per entry and use latest
stored version for each packet which gets transmitted to fw.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c |   92 ++++++--------------
 1 file changed, 29 insertions(+), 63 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
index 73e3e1d..682ac62 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
@@ -246,7 +246,7 @@ struct brcmf_skbuff_cb {
 #define BRCMF_SKB_HTOD_TAG_HSLOT_MASK			0x00ffff00
 #define BRCMF_SKB_HTOD_TAG_HSLOT_SHIFT			8
 #define BRCMF_SKB_HTOD_TAG_FREERUN_MASK			0x000000ff
-#define BRCMF_SKB_HTOD_TAG_FREERUN_SHIFT			0
+#define BRCMF_SKB_HTOD_TAG_FREERUN_SHIFT		0
 
 #define brcmf_skb_htod_tag_set_field(skb, field, value) \
 	brcmu_maskset32(&(brcmf_skbcb(skb)->htod), \
@@ -384,12 +384,10 @@ enum brcmf_fws_hanger_item_state {
  * struct brcmf_fws_hanger_item - single entry for tx pending packet.
  *
  * @state: entry is either free or occupied.
- * @gen: generation.
  * @pkt: packet itself.
  */
 struct brcmf_fws_hanger_item {
 	enum brcmf_fws_hanger_item_state state;
-	u8 gen;
 	struct sk_buff *pkt;
 };
 
@@ -537,7 +535,7 @@ done:
 }
 
 static int brcmf_fws_hanger_pushpkt(struct brcmf_fws_hanger *h,
-					   struct sk_buff *pkt, u32 slot_id)
+				    struct sk_buff *pkt, u32 slot_id)
 {
 	if (slot_id >= BRCMF_FWS_HANGER_MAXITEMS)
 		return -ENOENT;
@@ -571,20 +569,17 @@ static int brcmf_fws_hanger_poppkt(struct brcmf_fws_hanger *h,
 	if (remove_item) {
 		h->items[slot_id].state = BRCMF_FWS_HANGER_ITEM_STATE_FREE;
 		h->items[slot_id].pkt = NULL;
-		h->items[slot_id].gen = 0xff;
 		h->popped++;
 	}
 	return 0;
 }
 
 static int brcmf_fws_hanger_mark_suppressed(struct brcmf_fws_hanger *h,
-						   u32 slot_id, u8 gen)
+					    u32 slot_id)
 {
 	if (slot_id >= BRCMF_FWS_HANGER_MAXITEMS)
 		return -ENOENT;
 
-	h->items[slot_id].gen = gen;
-
 	if (h->items[slot_id].state != BRCMF_FWS_HANGER_ITEM_STATE_INUSE) {
 		brcmf_err("entry not in use\n");
 		return -EINVAL;
@@ -594,24 +589,6 @@ static int brcmf_fws_hanger_mark_suppressed(struct brcmf_fws_hanger *h,
 	return 0;
 }
 
-static int brcmf_fws_hanger_get_genbit(struct brcmf_fws_hanger *hanger,
-					      struct sk_buff *pkt, u32 slot_id,
-					      int *gen)
-{
-	*gen = 0xff;
-
-	if (slot_id >= BRCMF_FWS_HANGER_MAXITEMS)
-		return -ENOENT;
-
-	if (hanger->items[slot_id].state == BRCMF_FWS_HANGER_ITEM_STATE_FREE) {
-		brcmf_err("slot not in use\n");
-		return -EINVAL;
-	}
-
-	*gen = hanger->items[slot_id].gen;
-	return 0;
-}
-
 static void brcmf_fws_hanger_cleanup(struct brcmf_fws_info *fws,
 				     bool (*fn)(struct sk_buff *, void *),
 				     int ifidx)
@@ -838,9 +815,6 @@ brcmf_fws_flow_control_check(struct brcmf_fws_info *fws, struct pktq *pq,
 	if (WARN_ON(!ifp))
 		return;
 
-	brcmf_dbg(TRACE,
-		  "enter: bssidx=%d, ifidx=%d\n", ifp->bssidx, ifp->ifidx);
-
 	if ((ifp->netif_stop & BRCMF_NETIF_STOP_REASON_FWS_FC) &&
 	    pq->len <= BRCMF_FWS_FLOWCONTROL_LOWATER)
 		brcmf_txflowblock_if(ifp,
@@ -1220,7 +1194,7 @@ static int brcmf_fws_txstatus_suppressed(struct brcmf_fws_info *fws, int fifo,
 	hslot = brcmf_skb_htod_tag_get_field(skb, HSLOT);
 
 	/* this packet was suppressed */
-	if (!entry->suppressed || entry->generation != genbit) {
+	if (!entry->suppressed) {
 		entry->suppressed = true;
 		entry->suppress_count = brcmu_pktq_mlen(&entry->psq,
 							1 << (fifo * 2 + 1));
@@ -1242,8 +1216,7 @@ static int brcmf_fws_txstatus_suppressed(struct brcmf_fws_info *fws, int fifo,
 		 * Mark suppressed to avoid a double free during
 		 * wlfc cleanup
 		 */
-		brcmf_fws_hanger_mark_suppressed(&fws->hanger, hslot,
-						 genbit);
+		brcmf_fws_hanger_mark_suppressed(&fws->hanger, hslot);
 		entry->suppress_count++;
 	}
 
@@ -1573,15 +1546,34 @@ static int brcmf_fws_precommit_skb(struct brcmf_fws_info *fws, int fifo,
 	struct brcmf_skbuff_cb *skcb = brcmf_skbcb(p);
 	struct brcmf_fws_mac_descriptor *entry = skcb->mac;
 	int rc = 0;
-	bool header_needed;
+	bool first_time;
 	int hslot = BRCMF_FWS_HANGER_MAXITEMS;
 	u8 free_ctr;
 	u8 ifidx;
 	u8 flags;
 
-	header_needed = skcb->state != BRCMF_FWS_SKBSTATE_SUPPRESSED;
+	first_time = skcb->state != BRCMF_FWS_SKBSTATE_SUPPRESSED;
 
-	if (header_needed) {
+	if (!first_time) {
+		rc = brcmf_proto_hdrpull(fws->drvr, false, &ifidx, p);
+		if (rc) {
+			brcmf_err("hdrpull failed\n");
+			return rc;
+		}
+	}
+	brcmf_skb_if_flags_set_field(p, TRANSMIT, 1);
+	brcmf_skb_htod_tag_set_field(p, FIFO, fifo);
+	brcmf_skb_htod_tag_set_field(p, GENERATION, entry->generation);
+	flags = BRCMF_FWS_HTOD_FLAG_PKTFROMHOST;
+	if (!(skcb->if_flags & BRCMF_SKB_IF_FLAGS_CREDITCHECK_MASK)) {
+		/*
+		 * Indicate that this packet is being sent in response to an
+		 * explicit request from the firmware side.
+		 */
+		flags |= BRCMF_FWS_HTOD_FLAG_PKT_REQUESTED;
+	}
+	brcmf_skb_htod_tag_set_field(p, FLAGS, flags);
+	if (first_time) {
 		/* obtaining free slot may fail, but that will be caught
 		 * by the hanger push. This assures the packet has a BDC
 		 * header upon return.
@@ -1590,40 +1582,14 @@ static int brcmf_fws_precommit_skb(struct brcmf_fws_info *fws, int fifo,
 		free_ctr = entry->seq[fifo];
 		brcmf_skb_htod_tag_set_field(p, HSLOT, hslot);
 		brcmf_skb_htod_tag_set_field(p, FREERUN, free_ctr);
-		brcmf_skb_htod_tag_set_field(p, GENERATION, 1);
 		entry->transit_count++;
 	}
-	brcmf_skb_if_flags_set_field(p, TRANSMIT, 1);
-	brcmf_skb_htod_tag_set_field(p, FIFO, fifo);
 
-	flags = BRCMF_FWS_HTOD_FLAG_PKTFROMHOST;
-	if (!(skcb->if_flags & BRCMF_SKB_IF_FLAGS_CREDITCHECK_MASK)) {
-		/*
-		Indicate that this packet is being sent in response to an
-		explicit request from the firmware side.
-		*/
-		flags |= BRCMF_FWS_HTOD_FLAG_PKT_REQUESTED;
-	}
-	brcmf_skb_htod_tag_set_field(p, FLAGS, flags);
-	if (header_needed) {
-		brcmf_fws_hdrpush(fws, p);
+	brcmf_fws_hdrpush(fws, p);
+	if (first_time) {
 		rc = brcmf_fws_hanger_pushpkt(&fws->hanger, p, hslot);
 		if (rc)
 			brcmf_err("hanger push failed: rc=%d\n", rc);
-	} else {
-		int gen;
-
-		/* remove old header */
-		rc = brcmf_proto_hdrpull(fws->drvr, false, &ifidx, p);
-		if (rc == 0) {
-			hslot = brcmf_skb_htod_tag_get_field(p, HSLOT);
-			brcmf_fws_hanger_get_genbit(&fws->hanger, p,
-						    hslot, &gen);
-			brcmf_skb_htod_tag_set_field(p, GENERATION, gen);
-
-			/* push new header */
-			brcmf_fws_hdrpush(fws, p);
-		}
 	}
 
 	return rc;
-- 
1.7.10.4


