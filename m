Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:3008 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760779Ab3DCKlZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Apr 2013 06:41:25 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 25/25] brcmfmac: enable sk_buff queueing when credits
 deplete
Date: Wed, 3 Apr 2013 12:40:50 +0200
Message-ID: <1364985650-11719-26-git-send-email-arend@broadcom.com> (sfid-20130403_124141_959332_E6791C46)
In-Reply-To: <1364985650-11719-1-git-send-email-arend@broadcom.com>
References: <1364985650-11719-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Firmware provides the driver with credits used to transmit packets
to the firmware. When credits run out the packets should be queued
and dequeued when receiving creditback signals from the firmware.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.c  |   20 +-
 drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.h  |    6 +
 drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c |  661 ++++++++++++++++++--
 3 files changed, 627 insertions(+), 60 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.c
index 757701d..bd16f0b 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.c
@@ -130,7 +130,7 @@ ssize_t brcmf_debugfs_fws_stats_read(struct file *f, char __user *data,
 				     size_t count, loff_t *ppos)
 {
 	struct brcmf_fws_stats *fwstats = f->private_data;
-	char buf[100];
+	char buf[650];
 	int res;
 
 	/* only allow read from start */
@@ -145,12 +145,17 @@ ssize_t brcmf_debugfs_fws_stats_read(struct file *f, char __user *data,
 			"mac_update_fails:  %u\n"
 			"pkt2bus:           %u\n"
 			"generic_error:     %u\n"
+			"rollback_success:  %u\n"
+			"rollback_failed:   %u\n"
+			"delayq_full:       %u\n"
+			"supprq_full:       %u\n"
 			"txs_indicate:      %u\n"
 			"txs_discard:       %u\n"
 			"txs_suppr_core:    %u\n"
 			"txs_suppr_ps:      %u\n"
 			"txs_tossed:        %u\n"
-			"send_pkts:         BK:%u BE:%u VO:%u VI:%u BCMC:%u\n",
+			"send_pkts:         BK:%u BE:%u VO:%u VI:%u BCMC:%u\n"
+			"fifo_credits_sent: BK:%u BE:%u VO:%u VI:%u BCMC:%u\n",
 			fwstats->header_pulls,
 			fwstats->header_only_pkt,
 			fwstats->tlv_parse_failed,
@@ -158,6 +163,10 @@ ssize_t brcmf_debugfs_fws_stats_read(struct file *f, char __user *data,
 			fwstats->mac_update_failed,
 			fwstats->pkt2bus,
 			fwstats->generic_error,
+			fwstats->rollback_success,
+			fwstats->rollback_failed,
+			fwstats->delayq_full_error,
+			fwstats->supprq_full_error,
 			fwstats->txs_indicate,
 			fwstats->txs_discard,
 			fwstats->txs_supp_core,
@@ -165,7 +174,12 @@ ssize_t brcmf_debugfs_fws_stats_read(struct file *f, char __user *data,
 			fwstats->txs_tossed,
 			fwstats->send_pkts[0], fwstats->send_pkts[1],
 			fwstats->send_pkts[2], fwstats->send_pkts[3],
-			fwstats->send_pkts[4]);
+			fwstats->send_pkts[4],
+			fwstats->fifo_credits_sent[0],
+			fwstats->fifo_credits_sent[1],
+			fwstats->fifo_credits_sent[2],
+			fwstats->fifo_credits_sent[3],
+			fwstats->fifo_credits_sent[4]);
 
 	return simple_read_from_buffer(data, count, ppos, buf, res);
 }
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.h b/drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.h
index 30c2e9b..a6b16a1 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.h
@@ -140,8 +140,14 @@ struct brcmf_fws_stats {
 	u32 header_pulls;
 	u32 pkt2bus;
 	u32 send_pkts[5];
+	u32 fifo_credits_sent[5];
+	u32 fifo_credits_back[6];
 	u32 generic_error;
 	u32 mac_update_failed;
+	u32 rollback_success;
+	u32 rollback_failed;
+	u32 delayq_full_error;
+	u32 supprq_full_error;
 	u32 txs_indicate;
 	u32 txs_discard;
 	u32 txs_supp_core;
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
index 22a6eb2..8ce79af 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
@@ -130,15 +130,13 @@ static const char *brcmf_fws_get_tlv_name(enum brcmf_fws_tlv_type id)
 #define BRCMF_FWS_FLAGS_PSQ_ZERO_BUFFER_ENABLE		0x0020
 #define BRCMF_FWS_FLAGS_HOST_RXREORDER_ACTIVE		0x0040
 
-#define BRCMF_FWS_STATE_OPEN				1
-#define BRCMF_FWS_STATE_CLOSE				2
-
 #define BRCMF_FWS_MAC_DESC_TABLE_SIZE			32
-#define BRCMF_FWS_MAX_IFNUM				16
 #define BRCMF_FWS_MAC_DESC_ID_INVALID			0xff
 
 #define BRCMF_FWS_HOSTIF_FLOWSTATE_OFF			0
 #define BRCMF_FWS_HOSTIF_FLOWSTATE_ON			1
+#define BRCMF_FWS_FLOWCONTROL_HIWATER			128
+#define BRCMF_FWS_FLOWCONTROL_LOWATER			64
 
 #define BRCMF_FWS_PSQ_PREC_COUNT		((NL80211_NUM_ACS + 1) * 2)
 #define BRCMF_FWS_PSQ_LEN				256
@@ -313,6 +311,11 @@ enum brcmf_fws_fcmode {
 	BRCMF_FWS_FCMODE_EXPLICIT_CREDIT
 };
 
+enum brcmf_fws_mac_desc_state {
+	BRCMF_FWS_STATE_OPEN = 1,
+	BRCMF_FWS_STATE_CLOSE
+};
+
 /**
  * struct brcmf_fws_mac_descriptor - firmware signalling data per node/interface
  *
@@ -338,10 +341,16 @@ struct brcmf_fws_mac_descriptor {
 	u8 generation;
 	u8 ac_bitmap;
 	u8 requested_credit;
+	u8 requested_packet;
 	u8 ea[ETH_ALEN];
 	u8 seq[BRCMF_FWS_FIFO_COUNT];
 	struct pktq psq;
 	int transit_count;
+	int suppress_count;
+	int suppr_transit_count;
+	bool send_tim_signal;
+	u8 traffic_pending_bmp;
+	u8 traffic_lastreported_bmp;
 };
 
 #define BRCMF_FWS_HANGER_MAXITEMS	1024
@@ -394,14 +403,25 @@ struct brcmf_fws_hanger {
 	struct brcmf_fws_hanger_item items[BRCMF_FWS_HANGER_MAXITEMS];
 };
 
+struct brcmf_fws_macdesc_table {
+	struct brcmf_fws_mac_descriptor nodes[BRCMF_FWS_MAC_DESC_TABLE_SIZE];
+	struct brcmf_fws_mac_descriptor iface[BRCMF_MAX_IFS];
+	struct brcmf_fws_mac_descriptor other;
+};
+
 struct brcmf_fws_info {
 	struct brcmf_pub *drvr;
 	struct brcmf_fws_stats stats;
 	struct brcmf_fws_hanger hanger;
-	struct brcmf_fws_mac_descriptor nodes[BRCMF_FWS_MAC_DESC_TABLE_SIZE];
-	struct brcmf_fws_mac_descriptor other;
 	enum brcmf_fws_fcmode fcmode;
+	struct brcmf_fws_macdesc_table desc;
+	struct workqueue_struct *fws_wq;
+	struct work_struct fws_dequeue_work;
+	u32 fifo_enqpkt[BRCMF_FWS_FIFO_COUNT];
 	int fifo_credit[BRCMF_FWS_FIFO_COUNT];
+	int deq_node_pos[BRCMF_FWS_FIFO_COUNT];
+	u32 fifo_credit_map;
+	u32 fifo_delay_map;
 };
 
 /*
@@ -465,7 +485,7 @@ static void brcmf_fws_psq_flush(struct brcmf_fws_info *fws, struct pktq *q,
 	for (prec = 0; prec < q->num_prec; prec++) {
 		skb = brcmu_pktq_pdeq_match(q, prec, matchfn, &ifidx);
 		while (skb) {
-			brcmf_txfinalize(fws->drvr, skb, false);
+			brcmu_pkt_buf_free_skb(skb);
 			skb = brcmu_pktq_pdeq_match(q, prec, matchfn, &ifidx);
 		}
 	}
@@ -491,7 +511,7 @@ static u32 brcmf_fws_hanger_get_free_slot(struct brcmf_fws_hanger *h)
 	while (i != h->slot_pos) {
 		if (h->items[i].state == BRCMF_FWS_HANGER_ITEM_STATE_FREE) {
 			h->slot_pos = i;
-			return i;
+			goto done;
 		}
 		i++;
 		if (i == BRCMF_FWS_HANGER_MAXITEMS)
@@ -499,7 +519,10 @@ static u32 brcmf_fws_hanger_get_free_slot(struct brcmf_fws_hanger *h)
 	}
 	brcmf_err("all slots occupied\n");
 	h->failed_slotfind++;
-	return BRCMF_FWS_HANGER_MAXITEMS;
+	i = BRCMF_FWS_HANGER_MAXITEMS;
+done:
+	brcmf_dbg(TRACE, "exit: %d\n", i);
+	return i;
 }
 
 static int brcmf_fws_hanger_pushpkt(struct brcmf_fws_hanger *h,
@@ -545,7 +568,7 @@ static int brcmf_fws_hanger_poppkt(struct brcmf_fws_hanger *h,
 	return 0;
 }
 
-static __used int brcmf_fws_hanger_mark_suppressed(struct brcmf_fws_hanger *h,
+static int brcmf_fws_hanger_mark_suppressed(struct brcmf_fws_hanger *h,
 						   u32 slot_id, u8 gen)
 {
 	brcmf_dbg(TRACE, "enter\n");
@@ -583,10 +606,11 @@ static int brcmf_fws_hanger_get_genbit(struct brcmf_fws_hanger *hanger,
 	return 0;
 }
 
-static void brcmf_fws_hanger_cleanup(struct brcmf_fws_hanger *h,
+static void brcmf_fws_hanger_cleanup(struct brcmf_fws_info *fws,
 				     bool (*fn)(struct sk_buff *, void *),
 				     int ifidx)
 {
+	struct brcmf_fws_hanger *h = &fws->hanger;
 	struct sk_buff *skb;
 	int i;
 	enum brcmf_fws_hanger_item_state s;
@@ -611,14 +635,16 @@ static void brcmf_fws_hanger_cleanup(struct brcmf_fws_hanger *h,
 static void brcmf_fws_init_mac_descriptor(struct brcmf_fws_mac_descriptor *desc,
 					  u8 *addr, u8 ifidx)
 {
-	brcmf_dbg(TRACE, "enter: ea=%pM, ifidx=%u\n", addr, ifidx);
+	brcmf_dbg(TRACE,
+		  "enter: desc %p ea=%pM, ifidx=%u\n", desc, addr, ifidx);
 	desc->occupied = 1;
 	desc->state = BRCMF_FWS_STATE_OPEN;
 	desc->requested_credit = 0;
 	/* depending on use may need ifp->bssidx instead */
 	desc->interface_id = ifidx;
 	desc->ac_bitmap = 0xff; /* update this when handling APSD */
-	memcpy(&desc->ea[0], addr, ETH_ALEN);
+	if (addr)
+		memcpy(&desc->ea[0], addr, ETH_ALEN);
 }
 
 static
@@ -641,8 +667,8 @@ brcmf_fws_mac_descriptor_lookup(struct brcmf_fws_info *fws, u8 *ea)
 	if (ea == NULL)
 		return ERR_PTR(-EINVAL);
 
-	entry = &fws->nodes[0];
-	for (i = 0; i < ARRAY_SIZE(fws->nodes); i++) {
+	entry = &fws->desc.nodes[0];
+	for (i = 0; i < ARRAY_SIZE(fws->desc.nodes); i++) {
 		if (entry->occupied && !memcmp(entry->ea, ea, ETH_ALEN))
 			return entry;
 		entry++;
@@ -654,7 +680,7 @@ brcmf_fws_mac_descriptor_lookup(struct brcmf_fws_info *fws, u8 *ea)
 static struct brcmf_fws_mac_descriptor*
 brcmf_fws_find_mac_desc(struct brcmf_fws_info *fws, int ifidx, u8 *da)
 {
-	struct brcmf_fws_mac_descriptor *entry = &fws->other;
+	struct brcmf_fws_mac_descriptor *entry = &fws->desc.other;
 	struct brcmf_if *ifp;
 	bool multicast;
 
@@ -670,7 +696,7 @@ brcmf_fws_find_mac_desc(struct brcmf_fws_info *fws, int ifidx, u8 *da)
 	 * example, TDLS destinations have their own entry.
 	 */
 	entry = NULL;
-	if ((/* ifp->iftype == 0 ||*/ multicast) && ifp->fws_desc)
+	if (multicast && ifp->fws_desc)
 		entry = ifp->fws_desc;
 
 	if (entry != NULL && multicast)
@@ -678,13 +704,35 @@ brcmf_fws_find_mac_desc(struct brcmf_fws_info *fws, int ifidx, u8 *da)
 
 	entry = brcmf_fws_mac_descriptor_lookup(fws, da);
 	if (IS_ERR(entry))
-		entry = &fws->other;
+		entry = &fws->desc.other;
 
 done:
 	brcmf_dbg(TRACE, "exit: entry=%p\n", entry);
 	return entry;
 }
 
+static bool brcmf_fws_mac_desc_ready(struct brcmf_fws_mac_descriptor *entry,
+				     int fifo)
+{
+	bool ready;
+
+	/*
+	 * destination entry is ready when firmware says it is OPEN
+	 * and there are no packets enqueued for it.
+	 */
+	ready = entry->state == BRCMF_FWS_STATE_OPEN &&
+		!entry->suppressed &&
+		brcmu_pktq_mlen(&entry->psq, 3 << (fifo * 2)) == 0;
+
+	/*
+	 * Or when the destination entry is CLOSED, but firmware has
+	 * specifically requested packets for this entry.
+	 */
+	ready = ready || (entry->state == BRCMF_FWS_STATE_CLOSE &&
+		(entry->requested_credit + entry->requested_packet));
+	return ready;
+}
+
 static void brcmf_fws_mac_desc_cleanup(struct brcmf_fws_info *fws,
 				       struct brcmf_fws_mac_descriptor *entry,
 				       int ifidx)
@@ -743,13 +791,53 @@ static void brcmf_fws_cleanup(struct brcmf_fws_info *fws, int ifidx)
 		matchfn = brcmf_fws_ifidx_match;
 
 	/* cleanup individual nodes */
-	table = &fws->nodes[0];
-	for (i = 0; i < ARRAY_SIZE(fws->nodes); i++)
+	table = &fws->desc.nodes[0];
+	for (i = 0; i < ARRAY_SIZE(fws->desc.nodes); i++)
 		brcmf_fws_mac_desc_cleanup(fws, &table[i], ifidx);
 
-	brcmf_fws_mac_desc_cleanup(fws, &fws->other, ifidx);
+	brcmf_fws_mac_desc_cleanup(fws, &fws->desc.other, ifidx);
 	brcmf_fws_bus_txq_cleanup(fws, matchfn, ifidx);
-	brcmf_fws_hanger_cleanup(&fws->hanger, matchfn, ifidx);
+	brcmf_fws_hanger_cleanup(fws, matchfn, ifidx);
+}
+
+static void brcmf_fws_tim_update(struct brcmf_fws_info *ctx,
+				 struct brcmf_fws_mac_descriptor *entry,
+				 int prec)
+{
+	brcmf_dbg(TRACE, "enter: ea=%pM\n", entry->ea);
+	if (entry->state == BRCMF_FWS_STATE_CLOSE) {
+		/* check delayedQ and suppressQ in one call using bitmap */
+		if (brcmu_pktq_mlen(&entry->psq, 3 << (prec * 2)) == 0)
+			entry->traffic_pending_bmp =
+				entry->traffic_pending_bmp & ~NBITVAL(prec);
+		else
+			entry->traffic_pending_bmp =
+				entry->traffic_pending_bmp | NBITVAL(prec);
+	}
+	/* request a TIM update to firmware at the next piggyback opportunity */
+	if (entry->traffic_lastreported_bmp != entry->traffic_pending_bmp)
+		entry->send_tim_signal = true;
+}
+
+static void
+brcmf_fws_flow_control_check(struct brcmf_fws_info *fws, struct pktq *pq,
+			     u8 if_id)
+{
+	struct brcmf_if *ifp = fws->drvr->iflist[if_id];
+
+	brcmf_dbg(TRACE,
+		  "enter: bssidx=%d, ifidx=%d\n", ifp->bssidx, ifp->ifidx);
+	if (WARN_ON(!ifp))
+		return;
+
+	if ((ifp->netif_stop & BRCMF_NETIF_STOP_REASON_FWS_FC) &&
+	    pq->len <= BRCMF_FWS_FLOWCONTROL_LOWATER)
+		brcmf_txflowblock_if(ifp,
+				     BRCMF_NETIF_STOP_REASON_FWS_FC, false);
+	if (!(ifp->netif_stop & BRCMF_NETIF_STOP_REASON_FWS_FC) &&
+	    pq->len >= BRCMF_FWS_FLOWCONTROL_HIWATER)
+		brcmf_txflowblock_if(ifp, BRCMF_NETIF_STOP_REASON_FWS_FC, true);
+	return;
 }
 
 static int brcmf_fws_rssi_indicate(struct brcmf_fws_info *fws, s8 rssi)
@@ -770,7 +858,7 @@ int brcmf_fws_macdesc_indicate(struct brcmf_fws_info *fws, u8 type, u8 *data)
 	ifidx = *data++;
 	addr = data;
 
-	entry = &fws->nodes[mac_handle & 0x1F];
+	entry = &fws->desc.nodes[mac_handle & 0x1F];
 	if (type == BRCMF_FWS_TYPE_MACDESC_DEL) {
 		brcmf_dbg(TRACE, "deleting mac %pM idx %d\n", addr, ifidx);
 		if (entry->occupied)
@@ -808,25 +896,241 @@ int brcmf_fws_macdesc_indicate(struct brcmf_fws_info *fws, u8 type, u8 *data)
 	return 0;
 }
 
+static void brcmf_fws_return_credits(struct brcmf_fws_info *fws,
+				     u8 fifo, u8 credits)
+{
+	if (!credits)
+		return;
+
+	fws->fifo_credit_map |= 1 << fifo;
+	fws->fifo_credit[fifo] += credits;
+}
+
+static void brcmf_fws_schedule_deq(struct brcmf_fws_info *fws)
+{
+	/* only schedule dequeue when there are credits for delayed traffic */
+	if (fws->fifo_credit_map & fws->fifo_delay_map)
+		queue_work(fws->fws_wq, &fws->fws_dequeue_work);
+}
+
+static void brcmf_skb_pick_up_credit(struct brcmf_fws_info *fws, int fifo,
+				     struct sk_buff *p)
+{
+	struct brcmf_fws_mac_descriptor *entry = brcmf_skbcb(p)->mac;
+
+	if (brcmf_skbcb(p)->if_flags & BRCMF_SKB_IF_FLAGS_CREDITCHECK_MASK) {
+		if (fws->fcmode != BRCMF_FWS_FCMODE_IMPLIED_CREDIT)
+			return;
+		brcmf_fws_return_credits(fws, fifo, 1);
+	} else {
+		/*
+		 * if this packet did not count against FIFO credit, it
+		 * must have taken a requested_credit from the destination
+		 * entry (for pspoll etc.)
+		 */
+		if (!brcmf_skb_if_flags_get_field(p, REQUESTED))
+			entry->requested_credit++;
+	}
+	brcmf_fws_schedule_deq(fws);
+}
+
+static int brcmf_fws_enq(struct brcmf_fws_info *fws,
+			 enum brcmf_fws_skb_state state, int fifo,
+			 struct sk_buff *p)
+{
+	int prec = 2 * fifo;
+	u32 *qfull_stat = &fws->stats.delayq_full_error;
+
+	struct brcmf_fws_mac_descriptor *entry;
+
+	entry = brcmf_skbcb(p)->mac;
+	if (entry == NULL) {
+		brcmf_err("no mac descriptor found for skb %p\n", p);
+		return -ENOENT;
+	}
+
+	brcmf_dbg(TRACE, "enter: ea=%pM, qlen=%d\n", entry->ea, entry->psq.len);
+	if (state == BRCMF_FWS_SKBSTATE_SUPPRESSED) {
+		prec += 1;
+		qfull_stat = &fws->stats.supprq_full_error;
+	}
+
+	if (brcmu_pktq_penq(&entry->psq, prec, p) == NULL) {
+		*qfull_stat += 1;
+		return -ENFILE;
+	}
+
+	/* increment total enqueued packet count */
+	fws->fifo_delay_map |= 1 << fifo;
+	fws->fifo_enqpkt[fifo]++;
+
+	/* update the sk_buff state */
+	brcmf_skbcb(p)->state = state;
+	if (state == BRCMF_FWS_SKBSTATE_SUPPRESSED)
+		entry->suppress_count++;
+
+	/*
+	 * A packet has been pushed so update traffic
+	 * availability bitmap, if applicable
+	 */
+	brcmf_fws_tim_update(fws, entry, fifo);
+	brcmf_fws_flow_control_check(fws, &entry->psq,
+				     brcmf_skb_if_flags_get_field(p, INDEX));
+	return 0;
+}
+
+static struct sk_buff *brcmf_fws_deq(struct brcmf_fws_info *fws, int fifo)
+{
+	struct brcmf_fws_mac_descriptor *table;
+	struct brcmf_fws_mac_descriptor *entry;
+	struct sk_buff *p;
+	int use_credit = 1;
+	int num_nodes;
+	int node_pos;
+	int prec_out;
+	int pmsk = 3;
+	int i;
+
+	table = (struct brcmf_fws_mac_descriptor *)&fws->desc;
+	num_nodes = sizeof(fws->desc) / sizeof(struct brcmf_fws_mac_descriptor);
+	node_pos = fws->deq_node_pos[fifo];
+
+	for (i = 0; i < num_nodes; i++) {
+		entry = &table[(node_pos + i) % num_nodes];
+		if (!entry->occupied)
+			continue;
+
+		if (entry->suppressed)
+			pmsk = 2;
+		p = brcmu_pktq_mdeq(&entry->psq, pmsk << (fifo * 2), &prec_out);
+		if (p == NULL) {
+			if (entry->suppressed) {
+				if (entry->suppr_transit_count >
+				    entry->suppress_count)
+					return NULL;
+				entry->suppressed = false;
+				p = brcmu_pktq_mdeq(&entry->psq,
+						    1 << (fifo * 2), &prec_out);
+			}
+		}
+		if  (p == NULL)
+			continue;
+
+		/* did the packet come from suppress sub-queue? */
+		if (entry->requested_credit > 0) {
+			entry->requested_credit--;
+			/*
+			 * if the packet was pulled out while destination is in
+			 * closed state but had a non-zero packets requested,
+			 * then this should not count against the FIFO credit.
+			 * That is due to the fact that the firmware will
+			 * most likely hold onto this packet until a suitable
+			 * time later to push it to the appropriate AC FIFO.
+			 */
+			if (entry->state == BRCMF_FWS_STATE_CLOSE)
+				use_credit = 0;
+		} else if (entry->requested_packet > 0) {
+			entry->requested_packet--;
+			brcmf_skb_if_flags_set_field(p, REQUESTED, 1);
+			if (entry->state == BRCMF_FWS_STATE_CLOSE)
+				use_credit = 0;
+		}
+		brcmf_skb_if_flags_set_field(p, CREDITCHECK, use_credit);
+
+		/* move dequeue position to ensure fair round-robin */
+		fws->deq_node_pos[fifo] = (node_pos + i + 1) % num_nodes;
+		brcmf_fws_flow_control_check(fws, &entry->psq,
+					     brcmf_skb_if_flags_get_field(p,
+									  INDEX)
+					     );
+		/*
+		 * A packet has been picked up, update traffic
+		 * availability bitmap, if applicable
+		 */
+		brcmf_fws_tim_update(fws, entry, fifo);
+
+		/*
+		 * decrement total enqueued fifo packets and
+		 * clear delay bitmap if done.
+		 */
+		fws->fifo_enqpkt[fifo]--;
+		if (fws->fifo_enqpkt[fifo] == 0)
+			fws->fifo_delay_map &= ~(1 << fifo);
+		goto done;
+	}
+	p = NULL;
+done:
+	brcmf_dbg(TRACE, "exit: fifo %d skb %p\n", fifo, p);
+	return p;
+}
+
+static int brcmf_fws_txstatus_suppressed(struct brcmf_fws_info *fws, int fifo,
+					 struct sk_buff *skb, u32 genbit)
+{
+	struct brcmf_fws_mac_descriptor *entry = brcmf_skbcb(skb)->mac;
+	u32 hslot;
+	int ret;
+
+	hslot = brcmf_skb_htod_tag_get_field(skb, HSLOT);
+
+	/* this packet was suppressed */
+	if (!entry->suppressed || entry->generation != genbit) {
+		entry->suppressed = true;
+		entry->suppress_count = brcmu_pktq_mlen(&entry->psq,
+							1 << (fifo * 2 + 1));
+		entry->suppr_transit_count = entry->transit_count;
+	}
+
+	entry->generation = genbit;
+
+	ret = brcmf_fws_enq(fws, BRCMF_FWS_SKBSTATE_SUPPRESSED, fifo, skb);
+	if (ret != 0) {
+		/* suppress q is full, drop this packet */
+		brcmf_fws_hanger_poppkt(&fws->hanger, hslot, &skb,
+					true);
+	} else {
+		/*
+		 * Mark suppressed to avoid a double free during
+		 * wlfc cleanup
+		 */
+		brcmf_fws_hanger_mark_suppressed(&fws->hanger, hslot,
+						 genbit);
+		entry->suppress_count++;
+	}
+
+	return ret;
+}
+
 static int
-brcmf_fws_txstatus_process(struct brcmf_fws_info *fws, u8 flags, u32 hslot)
+brcmf_fws_txstatus_process(struct brcmf_fws_info *fws, u8 flags, u32 hslot,
+			   u32 genbit)
 {
+	u32 fifo;
 	int ret;
+	bool remove_from_hanger = true;
 	struct sk_buff *skb;
 	struct brcmf_fws_mac_descriptor *entry = NULL;
 
+	fws->stats.txs_indicate++;
+
 	brcmf_dbg(TRACE, "status: flags=0x%X, hslot=%d\n",
 		  flags, hslot);
 
 	if (flags == BRCMF_FWS_TXSTATUS_DISCARD)
 		fws->stats.txs_discard++;
-	else if (flags == BRCMF_FWS_TXSTATUS_FW_TOSSED)
+	else if (flags == BRCMF_FWS_TXSTATUS_CORE_SUPPRESS) {
+		fws->stats.txs_supp_core++;
+		remove_from_hanger = false;
+	} else if (flags == BRCMF_FWS_TXSTATUS_FW_PS_SUPPRESS) {
+		fws->stats.txs_supp_ps++;
+		remove_from_hanger = false;
+	} else if (flags == BRCMF_FWS_TXSTATUS_FW_TOSSED)
 		fws->stats.txs_tossed++;
 	else
 		brcmf_err("unexpected txstatus\n");
 
 	ret = brcmf_fws_hanger_poppkt(&fws->hanger, hslot, &skb,
-				      true);
+				      remove_from_hanger);
 	if (ret != 0) {
 		brcmf_err("no packet in hanger slot: hslot=%d\n", hslot);
 		return ret;
@@ -834,29 +1138,61 @@ brcmf_fws_txstatus_process(struct brcmf_fws_info *fws, u8 flags, u32 hslot)
 
 	entry = brcmf_skbcb(skb)->mac;
 	if (WARN_ON(!entry)) {
-		ret = -EINVAL;
-		goto done;
+		brcmu_pkt_buf_free_skb(skb);
+		return -EINVAL;
 	}
 
-	entry->transit_count--;
+	/* pick up the implicit credit from this packet */
+	fifo = brcmf_skb_htod_tag_get_field(skb, FIFO);
+	brcmf_skb_pick_up_credit(fws, fifo, skb);
 
-done:
-	brcmf_txfinalize(fws->drvr, skb, true);
-	return ret;
+	if (!remove_from_hanger)
+		ret = brcmf_fws_txstatus_suppressed(fws, fifo, skb, genbit);
+
+	if (remove_from_hanger || ret) {
+		entry->transit_count--;
+		if (entry->suppressed)
+			entry->suppr_transit_count--;
+
+		brcmf_txfinalize(fws->drvr, skb, true);
+	}
+	return 0;
+}
+
+static int brcmf_fws_fifocreditback_indicate(struct brcmf_fws_info *fws,
+					     u8 *data)
+{
+	int i;
+
+	if (fws->fcmode != BRCMF_FWS_FCMODE_EXPLICIT_CREDIT) {
+		brcmf_dbg(INFO, "ignored\n");
+		return 0;
+	}
+
+	brcmf_dbg(TRACE, "enter: data %pM\n", data);
+	for (i = 0; i < BRCMF_FWS_FIFO_COUNT; i++)
+		brcmf_fws_return_credits(fws, i, data[i]);
+
+	brcmf_dbg(INFO, "map: credit %x delay %x\n", fws->fifo_credit_map,
+		  fws->fifo_delay_map);
+	brcmf_fws_schedule_deq(fws);
+	return 0;
 }
 
 static int brcmf_fws_txstatus_indicate(struct brcmf_fws_info *fws, u8 *data)
 {
 	u32 status;
 	u32 hslot;
+	u32 genbit;
 	u8 flags;
 
 	fws->stats.txs_indicate++;
 	status = le32_to_cpu(*(__le32 *)data);
 	flags = brcmf_txstatus_get_field(status, FLAGS);
 	hslot = brcmf_txstatus_get_field(status, HSLOT);
+	genbit = brcmf_txstatus_get_field(status, GENERATION);
 
-	return brcmf_fws_txstatus_process(fws, flags, hslot);
+	return brcmf_fws_txstatus_process(fws, flags, hslot, genbit);
 }
 
 static int brcmf_fws_dbg_seqnum_check(struct brcmf_fws_info *fws, u8 *data)
@@ -893,9 +1229,21 @@ static int brcmf_fws_notify_credit_map(struct brcmf_if *ifp,
 	ulong flags;
 	u8 *credits = data;
 
+	if (e->datalen < BRCMF_FWS_FIFO_COUNT) {
+		brcmf_err("event payload too small (%d)\n", e->datalen);
+		return -EINVAL;
+	}
+
+	brcmf_dbg(TRACE, "enter: credits %pM\n", credits);
 	brcmf_fws_lock(ifp->drvr, flags);
-	for (i = 0; i < ARRAY_SIZE(fws->fifo_credit); i++)
+	for (i = 0; i < ARRAY_SIZE(fws->fifo_credit); i++) {
+		if (*credits)
+			fws->fifo_credit_map |= 1 << i;
+		else
+			fws->fifo_credit_map &= ~(1 << i);
 		fws->fifo_credit[i] = *credits++;
+	}
+	brcmf_fws_schedule_deq(fws);
 	brcmf_fws_unlock(ifp->drvr, flags);
 	return 0;
 }
@@ -958,11 +1306,8 @@ int brcmf_fws_hdrpull(struct brcmf_pub *drvr, int ifidx, s16 signal_len,
 		case BRCMF_FWS_TYPE_MAC_OPEN:
 		case BRCMF_FWS_TYPE_MAC_CLOSE:
 		case BRCMF_FWS_TYPE_MAC_REQUEST_CREDIT:
-		case BRCMF_FWS_TYPE_PKTTAG:
 		case BRCMF_FWS_TYPE_INTERFACE_OPEN:
 		case BRCMF_FWS_TYPE_INTERFACE_CLOSE:
-		case BRCMF_FWS_TYPE_FIFO_CREDITBACK:
-		case BRCMF_FWS_TYPE_PENDING_TRAFFIC_BMP:
 		case BRCMF_FWS_TYPE_MAC_REQUEST_PACKET:
 		case BRCMF_FWS_TYPE_HOST_REORDER_RXPKTS:
 		case BRCMF_FWS_TYPE_COMP_TXSTATUS:
@@ -974,12 +1319,17 @@ int brcmf_fws_hdrpull(struct brcmf_pub *drvr, int ifidx, s16 signal_len,
 		case BRCMF_FWS_TYPE_TXSTATUS:
 			brcmf_fws_txstatus_indicate(fws, data);
 			break;
+		case BRCMF_FWS_TYPE_FIFO_CREDITBACK:
+			brcmf_fws_fifocreditback_indicate(fws, data);
+			break;
 		case BRCMF_FWS_TYPE_RSSI:
 			brcmf_fws_rssi_indicate(fws, *data);
 			break;
 		case BRCMF_FWS_TYPE_TRANS_ID:
 			brcmf_fws_dbg_seqnum_check(fws, data);
 			break;
+		case BRCMF_FWS_TYPE_PKTTAG:
+		case BRCMF_FWS_TYPE_PENDING_TRAFFIC_BMP:
 		default:
 			fws->stats.tlv_invalid_type++;
 			break;
@@ -1010,14 +1360,17 @@ static int brcmf_fws_hdrpush(struct brcmf_fws_info *fws, struct sk_buff *skb)
 {
 	struct brcmf_fws_mac_descriptor *entry = brcmf_skbcb(skb)->mac;
 	u8 *wlh;
-	u16 data_offset;
+	u16 data_offset = 0;
 	u8 fillers;
 	__le32 pkttag = cpu_to_le32(brcmf_skbcb(skb)->htod);
 
 	brcmf_dbg(TRACE, "enter: ea=%pM, ifidx=%u, pkttag=0x%08X\n",
 		  entry->ea, entry->interface_id, le32_to_cpu(pkttag));
+	if (entry->send_tim_signal)
+		data_offset += 2 + BRCMF_FWS_TYPE_PENDING_TRAFFIC_BMP_LEN;
+
 	/* +2 is for Type[1] and Len[1] in TLV, plus TIM signal */
-	data_offset = 2 + BRCMF_FWS_TYPE_PKTTAG_LEN;
+	data_offset += 2 + BRCMF_FWS_TYPE_PKTTAG_LEN;
 	fillers = round_up(data_offset, 4) - data_offset;
 	data_offset += fillers;
 
@@ -1029,6 +1382,15 @@ static int brcmf_fws_hdrpush(struct brcmf_fws_info *fws, struct sk_buff *skb)
 	memcpy(&wlh[2], &pkttag, sizeof(pkttag));
 	wlh += BRCMF_FWS_TYPE_PKTTAG_LEN + 2;
 
+	if (entry->send_tim_signal) {
+		entry->send_tim_signal = 0;
+		wlh[0] = BRCMF_FWS_TYPE_PENDING_TRAFFIC_BMP;
+		wlh[1] = BRCMF_FWS_TYPE_PENDING_TRAFFIC_BMP_LEN;
+		wlh[2] = entry->mac_handle;
+		wlh[3] = entry->traffic_pending_bmp;
+		wlh += BRCMF_FWS_TYPE_PENDING_TRAFFIC_BMP_LEN + 2;
+		entry->traffic_lastreported_bmp = entry->traffic_pending_bmp;
+	}
 	if (fillers)
 		memset(wlh, BRCMF_FWS_TYPE_FILLER, fillers);
 
@@ -1049,7 +1411,7 @@ static int brcmf_fws_precommit_skb(struct brcmf_fws_info *fws, int fifo,
 	u8 ifidx;
 	u8 flags;
 
-	header_needed = skcb->state == BRCMF_FWS_SKBSTATE_NEW;
+	header_needed = skcb->state != BRCMF_FWS_SKBSTATE_SUPPRESSED;
 
 	if (header_needed) {
 		/* obtaining free slot may fail, but that will be caught
@@ -1099,6 +1461,133 @@ static int brcmf_fws_precommit_skb(struct brcmf_fws_info *fws, int fifo,
 	return rc;
 }
 
+static int
+brcmf_fws_rollback_toq(struct brcmf_fws_info *fws, struct sk_buff *skb)
+{
+	/*
+	put the packet back to the head of queue
+
+	- suppressed packet goes back to suppress sub-queue
+	- pull out the header, if new or delayed packet
+
+	Note: hslot is used only when header removal is done.
+	*/
+	struct brcmf_fws_mac_descriptor *entry;
+	enum brcmf_fws_skb_state state;
+	struct sk_buff *pktout;
+	int rc = 0;
+	int fifo;
+	int hslot;
+	u8 ifidx;
+
+	fifo = brcmf_skb_if_flags_get_field(skb, FIFO);
+	state = brcmf_skbcb(skb)->state;
+	entry = brcmf_skbcb(skb)->mac;
+
+	if (entry != NULL) {
+		if (state == BRCMF_FWS_SKBSTATE_SUPPRESSED) {
+			/* wl-header is saved for suppressed packets */
+			pktout = brcmu_pktq_penq_head(&entry->psq, 2 * fifo + 1,
+						      skb);
+			if (pktout == NULL) {
+				brcmf_err("suppress queue full\n");
+				rc = -ENOSPC;
+			}
+		} else {
+			hslot = brcmf_skb_htod_tag_get_field(skb, HSLOT);
+
+			/* remove header first */
+			rc = brcmf_proto_hdrpull(fws->drvr, false, &ifidx, skb);
+			if (rc) {
+				brcmf_err("header removal failed\n");
+				/* free the hanger slot */
+				brcmf_fws_hanger_poppkt(&fws->hanger, hslot,
+							&pktout, true);
+				brcmf_txfinalize(fws->drvr, skb, false);
+				rc = -EINVAL;
+				goto fail;
+			}
+
+			/* delay-q packets are going to delay-q */
+			pktout = brcmu_pktq_penq_head(&entry->psq,
+						      2 * fifo, skb);
+			if (pktout == NULL) {
+				brcmf_err("delay queue full\n");
+				rc = -ENOSPC;
+			}
+
+			/* free the hanger slot */
+			brcmf_fws_hanger_poppkt(&fws->hanger, hslot, &pktout,
+						true);
+
+			/* decrement sequence count */
+			entry->seq[fifo]--;
+		}
+		/*
+		if this packet did not count against FIFO credit, it must have
+		taken a requested_credit from the firmware (for pspoll etc.)
+		*/
+		if (!(brcmf_skbcb(skb)->if_flags &
+		      BRCMF_SKB_IF_FLAGS_CREDITCHECK_MASK))
+			entry->requested_credit++;
+	} else {
+		brcmf_err("no mac entry linked\n");
+		rc = -ENOENT;
+	}
+
+
+fail:
+	if (rc)
+		fws->stats.rollback_failed++;
+	else
+		fws->stats.rollback_success++;
+	return rc;
+}
+
+static int brcmf_fws_consume_credit(struct brcmf_fws_info *fws, int fifo,
+				    struct sk_buff *skb)
+{
+	struct brcmf_fws_mac_descriptor *entry = brcmf_skbcb(skb)->mac;
+	int *credit = &fws->fifo_credit[fifo];
+	int use_credit = 1;
+
+	brcmf_dbg(TRACE, "enter: ac=%d, credits=%d\n", fifo, *credit);
+
+	if (entry->requested_credit > 0) {
+		/*
+		 * if the packet was pulled out while destination is in
+		 * closed state but had a non-zero packets requested,
+		 * then this should not count against the FIFO credit.
+		 * That is due to the fact that the firmware will
+		 * most likely hold onto this packet until a suitable
+		 * time later to push it to the appropriate AC FIFO.
+		 */
+		entry->requested_credit--;
+		if (entry->state == BRCMF_FWS_STATE_CLOSE)
+			use_credit = 0;
+	} else if (entry->requested_packet > 0) {
+		entry->requested_packet--;
+		brcmf_skb_if_flags_set_field(skb, REQUESTED, 1);
+		if (entry->state == BRCMF_FWS_STATE_CLOSE)
+			use_credit = 0;
+	}
+	brcmf_skb_if_flags_set_field(skb, CREDITCHECK, use_credit);
+	if (!use_credit) {
+		brcmf_dbg(TRACE, "exit: no creditcheck set\n");
+		return 0;
+	}
+
+	if (!(*credit)) {
+		brcmf_dbg(TRACE, "exit: credits depleted\n");
+		return -ENAVAIL;
+	}
+	(*credit)--;
+	if (!(*credit))
+		fws->fifo_credit_map &= ~(1 << fifo);
+	brcmf_dbg(TRACE, "exit: ac=%d, credits=%d\n", fifo, *credit);
+	return 0;
+}
+
 static int brcmf_fws_commit_skb(struct brcmf_fws_info *fws, int fifo,
 				struct sk_buff *skb)
 {
@@ -1114,19 +1603,24 @@ static int brcmf_fws_commit_skb(struct brcmf_fws_info *fws, int fifo,
 	rc = brcmf_fws_precommit_skb(fws, fifo, skb);
 	if (rc < 0) {
 		fws->stats.generic_error++;
-		goto done;
+		goto rollback;
 	}
 
 	rc = brcmf_bus_txdata(bus, skb);
 	if (rc < 0)
-		goto done;
+		goto rollback;
 
 	entry->seq[fifo]++;
 	fws->stats.pkt2bus++;
+	if (brcmf_skbcb(skb)->if_flags & BRCMF_SKB_IF_FLAGS_CREDITCHECK_MASK) {
+		fws->stats.send_pkts[fifo]++;
+		fws->stats.fifo_credits_sent[fifo]++;
+	}
+
 	return rc;
 
-done:
-	brcmf_txfinalize(fws->drvr, skb, false);
+rollback:
+	rc = brcmf_fws_rollback_toq(fws, skb);
 	return rc;
 }
 
@@ -1157,19 +1651,27 @@ int brcmf_fws_process_skb(struct brcmf_if *ifp, struct sk_buff *skb)
 	}
 
 	/* set control buffer information */
+	skcb->if_flags = 0;
 	skcb->mac = brcmf_fws_find_mac_desc(drvr->fws, ifidx, eh->h_dest);
 	skcb->state = BRCMF_FWS_SKBSTATE_NEW;
 	brcmf_skb_if_flags_set_field(skb, INDEX, ifidx);
 	if (!multicast)
 		fifo = brcmf_fws_prio2fifo[skb->priority];
 	brcmf_skb_if_flags_set_field(skb, FIFO, fifo);
-	brcmf_skb_if_flags_set_field(skb, CREDITCHECK, 0);
 
 	brcmf_dbg(TRACE, "ea=%pM, multi=%d, fifo=%d\n", eh->h_dest,
 		  multicast, fifo);
 
 	brcmf_fws_lock(drvr, flags);
-	brcmf_fws_commit_skb(drvr->fws, fifo, skb);
+	if (!brcmf_fws_mac_desc_ready(skcb->mac, fifo) ||
+	    (!multicast &&
+	     brcmf_fws_consume_credit(drvr->fws, fifo, skb) < 0)) {
+		/* enqueue the packet in delayQ */
+		drvr->fws->fifo_delay_map |= 1 << fifo;
+		brcmf_fws_enq(drvr->fws, BRCMF_FWS_SKBSTATE_DELAYED, fifo, skb);
+	} else {
+		brcmf_fws_commit_skb(drvr->fws, fifo, skb);
+	}
 	brcmf_fws_unlock(drvr, flags);
 	return 0;
 }
@@ -1187,6 +1689,7 @@ void brcmf_fws_reset_interface(struct brcmf_if *ifp)
 
 void brcmf_fws_add_interface(struct brcmf_if *ifp)
 {
+	struct brcmf_fws_info *fws = ifp->drvr->fws;
 	struct brcmf_fws_mac_descriptor *entry;
 
 	brcmf_dbg(TRACE, "enter: idx=%d, mac=%pM\n",
@@ -1194,15 +1697,11 @@ void brcmf_fws_add_interface(struct brcmf_if *ifp)
 	if (!ifp->drvr->fw_signals)
 		return;
 
-	entry = kzalloc(sizeof(*entry), GFP_ATOMIC);
-	if (entry) {
-		ifp->fws_desc = entry;
-		brcmf_fws_init_mac_descriptor(entry, ifp->mac_addr, ifp->ifidx);
-		brcmu_pktq_init(&entry->psq, BRCMF_FWS_PSQ_PREC_COUNT,
-				BRCMF_FWS_PSQ_LEN);
-	} else {
-		brcmf_err("no firmware signalling\n");
-	}
+	entry = &fws->desc.iface[ifp->ifidx];
+	ifp->fws_desc = entry;
+	brcmf_fws_init_mac_descriptor(entry, ifp->mac_addr, ifp->ifidx);
+	brcmu_pktq_init(&entry->psq, BRCMF_FWS_PSQ_PREC_COUNT,
+			BRCMF_FWS_PSQ_LEN);
 }
 
 void brcmf_fws_del_interface(struct brcmf_if *ifp)
@@ -1216,7 +1715,35 @@ void brcmf_fws_del_interface(struct brcmf_if *ifp)
 	ifp->fws_desc = NULL;
 	brcmf_fws_clear_mac_descriptor(entry);
 	brcmf_fws_cleanup(ifp->drvr->fws, ifp->ifidx);
-	kfree(entry);
+}
+
+static void brcmf_fws_dequeue_worker(struct work_struct *worker)
+{
+	struct brcmf_fws_info *fws;
+	struct sk_buff *skb;
+	ulong flags;
+	int fifo;
+	int credit;
+
+	fws = container_of(worker, struct brcmf_fws_info, fws_dequeue_work);
+
+	brcmf_dbg(TRACE, "enter: fws=%p\n", fws);
+	brcmf_fws_lock(fws->drvr, flags);
+	for (fifo = NL80211_NUM_ACS; fifo >= 0; fifo--) {
+		brcmf_dbg(TRACE, "fifo %d credit %d\n", fifo,
+			  fws->fifo_credit[fifo]);
+		for (credit = 0; credit < fws->fifo_credit[fifo]; /* nop */) {
+			skb = brcmf_fws_deq(fws, fifo);
+			if (!skb)
+				break;
+			if (!brcmf_fws_commit_skb(fws, fifo, skb) &&
+			    brcmf_skbcb(skb)->if_flags &
+			    BRCMF_SKB_IF_FLAGS_CREDITCHECK_MASK)
+				credit++;
+		}
+		fws->fifo_credit[fifo] -= credit;
+	}
+	brcmf_fws_unlock(fws->drvr, flags);
 }
 
 int brcmf_fws_init(struct brcmf_pub *drvr)
@@ -1239,6 +1766,14 @@ int brcmf_fws_init(struct brcmf_pub *drvr)
 	drvr->fws->drvr = drvr;
 	drvr->fws->fcmode = fcmode;
 
+	drvr->fws->fws_wq = create_singlethread_workqueue("brcmf_fws_wq");
+	if (drvr->fws->fws_wq == NULL) {
+		brcmf_err("workqueue creation failed\n");
+		rc = -EBADF;
+		goto fail;
+	}
+	INIT_WORK(&drvr->fws->fws_dequeue_work, brcmf_fws_dequeue_worker);
+
 	/* enable firmware signalling if fcmode active */
 	if (drvr->fws->fcmode != BRCMF_FWS_FCMODE_NONE)
 		tlv |= BRCMF_FWS_FLAGS_XONXOFF_SIGNALS |
@@ -1257,6 +1792,9 @@ int brcmf_fws_init(struct brcmf_pub *drvr)
 	}
 
 	brcmf_fws_hanger_init(&drvr->fws->hanger);
+	brcmf_fws_init_mac_descriptor(&drvr->fws->desc.other, NULL, 0);
+	brcmu_pktq_init(&drvr->fws->desc.other.psq, BRCMF_FWS_PSQ_PREC_COUNT,
+			BRCMF_FWS_PSQ_LEN);
 
 	/* create debugfs file for statistics */
 	brcmf_debugfs_create_fws_stats(drvr, &drvr->fws->stats);
@@ -1306,6 +1844,15 @@ void brcmf_fws_bustxfail(struct brcmf_fws_info *fws, struct sk_buff *skb)
 
 	brcmf_fws_lock(fws->drvr, flags);
 	brcmf_fws_txstatus_process(fws, BRCMF_FWS_TXSTATUS_FW_TOSSED,
-				   brcmf_skb_htod_tag_get_field(skb, HSLOT));
+				   brcmf_skb_htod_tag_get_field(skb, HSLOT), 0);
+	/* the packet never reached firmware so reclaim credit */
+	if (fws->fcmode == BRCMF_FWS_FCMODE_EXPLICIT_CREDIT &&
+	    brcmf_skbcb(skb)->if_flags & BRCMF_SKB_IF_FLAGS_CREDITCHECK_MASK) {
+		brcmf_fws_return_credits(fws,
+					 brcmf_skb_htod_tag_get_field(skb,
+								      FIFO),
+					 1);
+		brcmf_fws_schedule_deq(fws);
+	}
 	brcmf_fws_unlock(fws->drvr, flags);
 }
-- 
1.7.10.4


