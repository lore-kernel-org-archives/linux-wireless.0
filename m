Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4421 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753528Ab3K2Ksd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Nov 2013 05:48:33 -0500
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Hante Meuleman" <meuleman@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH V2 1/7] brcmfmac: Update fwsignal to fix out of order
 tx.
Date: Fri, 29 Nov 2013 11:48:13 +0100
Message-ID: <1385722099-5102-2-git-send-email-arend@broadcom.com> (sfid-20131129_114840_775711_2D9EDFB2)
In-Reply-To: <1385722099-5102-1-git-send-email-arend@broadcom.com>
References: <1385722099-5102-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

When using fwsignal it is possible that tx packets get delivered out
of order. This patch fixes that by reordering suppressed packets and
tracking generation bit and sequence number per packet.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c |  167 +++++++++++++++++---
 1 file changed, 146 insertions(+), 21 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
index d0cd0bf..784cf94 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
@@ -105,6 +105,9 @@ static struct {
 };
 #undef BRCMF_FWS_TLV_DEF
 
+#define BRCMF_FWS_TYPE_SEQ_LEN				2
+
+
 static const char *brcmf_fws_get_tlv_name(enum brcmf_fws_tlv_type id)
 {
 	int i;
@@ -147,8 +150,15 @@ static const char *brcmf_fws_get_tlv_name(enum brcmf_fws_tlv_type id)
 #define BRCMF_FWS_HTOD_FLAG_PKTFROMHOST			0x01
 #define BRCMF_FWS_HTOD_FLAG_PKT_REQUESTED		0x02
 
-#define BRCMF_FWS_RET_OK_NOSCHEDULE	0
-#define BRCMF_FWS_RET_OK_SCHEDULE	1
+#define BRCMF_FWS_RET_OK_NOSCHEDULE			0
+#define BRCMF_FWS_RET_OK_SCHEDULE			1
+
+#define BRCMF_FWS_MODE_REUSESEQ_SHIFT			3	/* seq reuse */
+#define BRCMF_FWS_MODE_SET_REUSESEQ(x, val)	((x) = \
+		((x) & ~(1 << BRCMF_FWS_MODE_REUSESEQ_SHIFT)) | \
+		(((val) & 1) << BRCMF_FWS_MODE_REUSESEQ_SHIFT))
+#define BRCMF_FWS_MODE_GET_REUSESEQ(x)	\
+		(((x) >> BRCMF_FWS_MODE_REUSESEQ_SHIFT) & 1)
 
 /**
  * enum brcmf_fws_skb_state - indicates processing state of skb.
@@ -171,6 +181,7 @@ enum brcmf_fws_skb_state {
  * @bus_flags: 2 bytes reserved for bus specific parameters
  * @if_flags: holds interface index and packet related flags.
  * @htod: host to device packet identifier (used in PKTTAG tlv).
+ * @htod_seq: this 16-bit is original seq number for every suppress packet.
  * @state: transmit state of the packet.
  * @mac: descriptor related to destination for this packet.
  *
@@ -181,6 +192,7 @@ struct brcmf_skbuff_cb {
 	u16 bus_flags;
 	u16 if_flags;
 	u32 htod;
+	u16 htod_seq;
 	enum brcmf_fws_skb_state state;
 	struct brcmf_fws_mac_descriptor *mac;
 };
@@ -257,6 +269,22 @@ struct brcmf_skbuff_cb {
 			BRCMF_SKB_HTOD_TAG_ ## field ## _MASK, \
 			BRCMF_SKB_HTOD_TAG_ ## field ## _SHIFT)
 
+#define BRCMF_SKB_HTOD_SEQ_FROMFW_MASK			0x2000
+#define BRCMF_SKB_HTOD_SEQ_FROMFW_SHIFT			13
+#define BRCMF_SKB_HTOD_SEQ_FROMDRV_MASK			0x1000
+#define BRCMF_SKB_HTOD_SEQ_FROMDRV_SHIFT		12
+#define BRCMF_SKB_HTOD_SEQ_NR_MASK			0x0fff
+#define BRCMF_SKB_HTOD_SEQ_NR_SHIFT			0
+
+#define brcmf_skb_htod_seq_set_field(skb, field, value) \
+	brcmu_maskset16(&(brcmf_skbcb(skb)->htod_seq), \
+			BRCMF_SKB_HTOD_SEQ_ ## field ## _MASK, \
+			BRCMF_SKB_HTOD_SEQ_ ## field ## _SHIFT, (value))
+#define brcmf_skb_htod_seq_get_field(skb, field) \
+	brcmu_maskget16(brcmf_skbcb(skb)->htod_seq, \
+			BRCMF_SKB_HTOD_SEQ_ ## field ## _MASK, \
+			BRCMF_SKB_HTOD_SEQ_ ## field ## _SHIFT)
+
 #define BRCMF_FWS_TXSTAT_GENERATION_MASK	0x80000000
 #define BRCMF_FWS_TXSTAT_GENERATION_SHIFT	31
 #define BRCMF_FWS_TXSTAT_FLAGS_MASK		0x78000000
@@ -265,8 +293,8 @@ struct brcmf_skbuff_cb {
 #define BRCMF_FWS_TXSTAT_FIFO_SHIFT		24
 #define BRCMF_FWS_TXSTAT_HSLOT_MASK		0x00FFFF00
 #define BRCMF_FWS_TXSTAT_HSLOT_SHIFT		8
-#define BRCMF_FWS_TXSTAT_PKTID_MASK		0x00FFFFFF
-#define BRCMF_FWS_TXSTAT_PKTID_SHIFT		0
+#define BRCMF_FWS_TXSTAT_FREERUN_MASK		0x000000FF
+#define BRCMF_FWS_TXSTAT_FREERUN_SHIFT		0
 
 #define brcmf_txstatus_get_field(txs, field) \
 	brcmu_maskget32(txs, BRCMF_FWS_TXSTAT_ ## field ## _MASK, \
@@ -443,6 +471,7 @@ struct brcmf_fws_info {
 	unsigned long borrow_defer_timestamp;
 	bool bus_flow_blocked;
 	bool creditmap_received;
+	u8 mode;
 };
 
 /*
@@ -812,13 +841,16 @@ static int brcmf_fws_hdrpush(struct brcmf_fws_info *fws, struct sk_buff *skb)
 	u16 data_offset = 0;
 	u8 fillers;
 	__le32 pkttag = cpu_to_le32(brcmf_skbcb(skb)->htod);
+	__le16 pktseq = cpu_to_le16(brcmf_skbcb(skb)->htod_seq);
 
-	brcmf_dbg(TRACE, "enter: %s, idx=%d pkttag=0x%08X, hslot=%d\n",
+	brcmf_dbg(TRACE, "enter: %s, idx=%d hslot=%d htod %X seq %X\n",
 		  entry->name, brcmf_skb_if_flags_get_field(skb, INDEX),
-		  le32_to_cpu(pkttag), (le32_to_cpu(pkttag) >> 8) & 0xffff);
+		  (le32_to_cpu(pkttag) >> 8) & 0xffff,
+		  brcmf_skbcb(skb)->htod, brcmf_skbcb(skb)->htod_seq);
 	if (entry->send_tim_signal)
 		data_offset += 2 + BRCMF_FWS_TYPE_PENDING_TRAFFIC_BMP_LEN;
-
+	if (BRCMF_FWS_MODE_GET_REUSESEQ(fws->mode))
+		data_offset += BRCMF_FWS_TYPE_SEQ_LEN;
 	/* +2 is for Type[1] and Len[1] in TLV, plus TIM signal */
 	data_offset += 2 + BRCMF_FWS_TYPE_PKTTAG_LEN;
 	fillers = round_up(data_offset, 4) - data_offset;
@@ -830,7 +862,12 @@ static int brcmf_fws_hdrpush(struct brcmf_fws_info *fws, struct sk_buff *skb)
 	wlh[0] = BRCMF_FWS_TYPE_PKTTAG;
 	wlh[1] = BRCMF_FWS_TYPE_PKTTAG_LEN;
 	memcpy(&wlh[2], &pkttag, sizeof(pkttag));
-	wlh += BRCMF_FWS_TYPE_PKTTAG_LEN + 2;
+	if (BRCMF_FWS_MODE_GET_REUSESEQ(fws->mode)) {
+		wlh[1] += BRCMF_FWS_TYPE_SEQ_LEN;
+		memcpy(&wlh[2 + BRCMF_FWS_TYPE_PKTTAG_LEN], &pktseq,
+		       sizeof(pktseq));
+	}
+	wlh += wlh[1] + 2;
 
 	if (entry->send_tim_signal) {
 		entry->send_tim_signal = 0;
@@ -875,6 +912,7 @@ static bool brcmf_fws_tim_update(struct brcmf_fws_info *fws,
 		/* create a dummy packet and sent that. The traffic          */
 		/* bitmap info will automatically be attached to that packet */
 		len = BRCMF_FWS_TYPE_PKTTAG_LEN + 2 +
+		      BRCMF_FWS_TYPE_SEQ_LEN +
 		      BRCMF_FWS_TYPE_PENDING_TRAFFIC_BMP_LEN + 2 +
 		      4 + fws->drvr->hdrlen;
 		skb = brcmu_pkt_buf_get_skb(len);
@@ -884,6 +922,8 @@ static bool brcmf_fws_tim_update(struct brcmf_fws_info *fws,
 		skcb = brcmf_skbcb(skb);
 		skcb->mac = entry;
 		skcb->state = BRCMF_FWS_SKBSTATE_TIM;
+		skcb->htod = 0;
+		skcb->htod_seq = 0;
 		bus = fws->drvr->bus_if;
 		err = brcmf_fws_hdrpush(fws, skb);
 		if (err == 0) {
@@ -1172,8 +1212,13 @@ static int brcmf_fws_enq(struct brcmf_fws_info *fws,
 {
 	int prec = 2 * fifo;
 	u32 *qfull_stat = &fws->stats.delayq_full_error;
-
 	struct brcmf_fws_mac_descriptor *entry;
+	struct pktq *pq;
+	struct sk_buff_head *queue;
+	struct sk_buff *p_head;
+	struct sk_buff *p_tail;
+	u32 fr_new;
+	u32 fr_compare;
 
 	entry = brcmf_skbcb(p)->mac;
 	if (entry == NULL) {
@@ -1185,9 +1230,55 @@ static int brcmf_fws_enq(struct brcmf_fws_info *fws,
 	if (state == BRCMF_FWS_SKBSTATE_SUPPRESSED) {
 		prec += 1;
 		qfull_stat = &fws->stats.supprq_full_error;
-	}
 
-	if (brcmu_pktq_penq(&entry->psq, prec, p) == NULL) {
+		/* Fix out of order delivery of frames. Dont assume frame    */
+		/* can be inserted at the end, but look for correct position */
+		pq = &entry->psq;
+		if (pktq_full(pq) || pktq_pfull(pq, prec)) {
+			*qfull_stat += 1;
+			return -ENFILE;
+		}
+		queue = &pq->q[prec].skblist;
+
+		p_head = skb_peek(queue);
+		p_tail = skb_peek_tail(queue);
+		fr_new = brcmf_skb_htod_tag_get_field(p, FREERUN);
+
+		while (p_head != p_tail) {
+			fr_compare = brcmf_skb_htod_tag_get_field(p_tail,
+								  FREERUN);
+			/* be sure to handle wrap of 256 */
+			if (((fr_new > fr_compare) &&
+			     ((fr_new - fr_compare) < 128)) ||
+			    ((fr_new < fr_compare) &&
+			     ((fr_compare - fr_new) > 128)))
+				break;
+			p_tail = skb_queue_prev(queue, p_tail);
+		}
+		/* Position found. Determine what to do */
+		if (p_tail == NULL) {
+			/* empty list */
+			__skb_queue_tail(queue, p);
+		} else {
+			fr_compare = brcmf_skb_htod_tag_get_field(p_tail,
+								  FREERUN);
+			if (((fr_new > fr_compare) &&
+			     ((fr_new - fr_compare) < 128)) ||
+			    ((fr_new < fr_compare) &&
+			     ((fr_compare - fr_new) > 128))) {
+				/* After tail */
+				__skb_queue_after(queue, p_tail, p);
+			} else {
+				/* Before tail */
+				__skb_insert(p, p_tail->prev, p_tail, queue);
+			}
+		}
+
+		/* Complete the counters and statistics */
+		pq->len++;
+		if (pq->hi_prec < prec)
+			pq->hi_prec = (u8) prec;
+	} else if (brcmu_pktq_penq(&entry->psq, prec, p) == NULL) {
 		*qfull_stat += 1;
 		return -ENFILE;
 	}
@@ -1277,7 +1368,8 @@ done:
 }
 
 static int brcmf_fws_txstatus_suppressed(struct brcmf_fws_info *fws, int fifo,
-					 struct sk_buff *skb, u32 genbit)
+					 struct sk_buff *skb, u32 genbit,
+					 u16 seq)
 {
 	struct brcmf_fws_mac_descriptor *entry = brcmf_skbcb(skb)->mac;
 	u32 hslot;
@@ -1298,6 +1390,14 @@ static int brcmf_fws_txstatus_suppressed(struct brcmf_fws_info *fws, int fifo,
 
 	ret = brcmf_proto_hdrpull(fws->drvr, false, &ifidx, skb);
 	if (ret == 0)
+		brcmf_skb_htod_tag_set_field(skb, GENERATION, genbit);
+		brcmf_skbcb(skb)->htod_seq = seq;
+		if (brcmf_skb_htod_seq_get_field(skb, FROMFW)) {
+			brcmf_skb_htod_seq_set_field(skb, FROMDRV, 1);
+			brcmf_skb_htod_seq_set_field(skb, FROMFW, 0);
+		} else {
+			brcmf_skb_htod_seq_set_field(skb, FROMDRV, 0);
+		}
 		ret = brcmf_fws_enq(fws, BRCMF_FWS_SKBSTATE_SUPPRESSED, fifo,
 				    skb);
 	if (ret != 0) {
@@ -1317,7 +1417,7 @@ static int brcmf_fws_txstatus_suppressed(struct brcmf_fws_info *fws, int fifo,
 
 static int
 brcmf_fws_txs_process(struct brcmf_fws_info *fws, u8 flags, u32 hslot,
-			   u32 genbit)
+		      u32 genbit, u16 seq)
 {
 	u32 fifo;
 	int ret;
@@ -1360,8 +1460,8 @@ brcmf_fws_txs_process(struct brcmf_fws_info *fws, u8 flags, u32 hslot,
 	if (entry->suppressed && entry->suppr_transit_count)
 		entry->suppr_transit_count--;
 
-	brcmf_dbg(DATA, "%s flags %X htod %X\n", entry->name, skcb->if_flags,
-		  skcb->htod);
+	brcmf_dbg(DATA, "%s flags %d htod %X seq %X\n", entry->name, flags,
+		  skcb->htod, seq);
 
 	/* pick up the implicit credit from this packet */
 	fifo = brcmf_skb_htod_tag_get_field(skb, FIFO);
@@ -1374,7 +1474,8 @@ brcmf_fws_txs_process(struct brcmf_fws_info *fws, u8 flags, u32 hslot,
 	brcmf_fws_macdesc_return_req_credit(skb);
 
 	if (!remove_from_hanger)
-		ret = brcmf_fws_txstatus_suppressed(fws, fifo, skb, genbit);
+		ret = brcmf_fws_txstatus_suppressed(fws, fifo, skb, genbit,
+						    seq);
 
 	if (remove_from_hanger || ret)
 		brcmf_txfinalize(fws->drvr, skb, true);
@@ -1406,10 +1507,12 @@ static int brcmf_fws_fifocreditback_indicate(struct brcmf_fws_info *fws,
 static int brcmf_fws_txstatus_indicate(struct brcmf_fws_info *fws, u8 *data)
 {
 	__le32 status_le;
+	__le16 seq_le;
 	u32 status;
 	u32 hslot;
 	u32 genbit;
 	u8 flags;
+	u16 seq;
 
 	fws->stats.txs_indicate++;
 	memcpy(&status_le, data, sizeof(status_le));
@@ -1417,9 +1520,16 @@ static int brcmf_fws_txstatus_indicate(struct brcmf_fws_info *fws, u8 *data)
 	flags = brcmf_txstatus_get_field(status, FLAGS);
 	hslot = brcmf_txstatus_get_field(status, HSLOT);
 	genbit = brcmf_txstatus_get_field(status, GENERATION);
+	if (BRCMF_FWS_MODE_GET_REUSESEQ(fws->mode)) {
+		memcpy(&seq_le, &data[BRCMF_FWS_TYPE_PKTTAG_LEN],
+		       sizeof(seq_le));
+		seq = le16_to_cpu(seq_le);
+	} else {
+		seq = 0;
+	}
 
 	brcmf_fws_lock(fws);
-	brcmf_fws_txs_process(fws, flags, hslot, genbit);
+	brcmf_fws_txs_process(fws, flags, hslot, genbit, seq);
 	brcmf_fws_unlock(fws);
 	return BRCMF_FWS_RET_OK_NOSCHEDULE;
 }
@@ -1610,8 +1720,8 @@ static void brcmf_fws_precommit_skb(struct brcmf_fws_info *fws, int fifo,
 	struct brcmf_fws_mac_descriptor *entry = skcb->mac;
 	u8 flags;
 
-	brcmf_skb_if_flags_set_field(p, TRANSMIT, 1);
-	brcmf_skb_htod_tag_set_field(p, GENERATION, entry->generation);
+	if (skcb->state != BRCMF_FWS_SKBSTATE_SUPPRESSED)
+		brcmf_skb_htod_tag_set_field(p, GENERATION, entry->generation);
 	flags = BRCMF_FWS_HTOD_FLAG_PKTFROMHOST;
 	if (brcmf_skb_if_flags_get_field(p, REQUESTED)) {
 		/*
@@ -1652,7 +1762,7 @@ static void brcmf_fws_rollback_toq(struct brcmf_fws_info *fws,
 		fws->stats.rollback_failed++;
 		hslot = brcmf_skb_htod_tag_get_field(skb, HSLOT);
 		brcmf_fws_txs_process(fws, BRCMF_FWS_TXSTATUS_HOST_TOSSED,
-				      hslot, 0);
+				      hslot, 0, 0);
 	} else {
 		fws->stats.rollback_success++;
 		brcmf_fws_return_credits(fws, fifo, 1);
@@ -1732,6 +1842,8 @@ static int brcmf_fws_assign_htod(struct brcmf_fws_info *fws, struct sk_buff *p,
 	struct brcmf_skbuff_cb *skcb = brcmf_skbcb(p);
 	int rc, hslot;
 
+	skcb->htod = 0;
+	skcb->htod_seq = 0;
 	hslot = brcmf_fws_hanger_get_free_slot(&fws->hanger);
 	brcmf_skb_htod_tag_set_field(p, HSLOT, hslot);
 	brcmf_skb_htod_tag_set_field(p, FREERUN, skcb->mac->seq[fifo]);
@@ -1908,6 +2020,7 @@ int brcmf_fws_init(struct brcmf_pub *drvr)
 	struct brcmf_fws_info *fws;
 	u32 tlv = BRCMF_FWS_FLAGS_RSSI_SIGNALS;
 	int rc;
+	u32 mode;
 
 	drvr->fws = kzalloc(sizeof(*(drvr->fws)), GFP_KERNEL);
 	if (!drvr->fws) {
@@ -1966,6 +2079,18 @@ int brcmf_fws_init(struct brcmf_pub *drvr)
 	if (brcmf_fil_iovar_int_set(drvr->iflist[0], "ampdu_hostreorder", 1))
 		brcmf_dbg(INFO, "enabling AMPDU host-reorder failed\n");
 
+	/* Enable seq number reuse, if supported */
+	if (brcmf_fil_iovar_int_get(drvr->iflist[0], "wlfc_mode", &mode) == 0) {
+		if (BRCMF_FWS_MODE_GET_REUSESEQ(mode)) {
+			mode = 0;
+			BRCMF_FWS_MODE_SET_REUSESEQ(mode, 1);
+			if (brcmf_fil_iovar_int_set(drvr->iflist[0],
+						    "wlfc_mode", mode) == 0) {
+				BRCMF_FWS_MODE_SET_REUSESEQ(fws->mode, 1);
+			}
+		}
+	}
+
 	brcmf_fws_hanger_init(&fws->hanger);
 	brcmf_fws_macdesc_init(&fws->desc.other, NULL, 0);
 	brcmf_fws_macdesc_set_name(fws, &fws->desc.other);
@@ -2022,7 +2147,7 @@ void brcmf_fws_bustxfail(struct brcmf_fws_info *fws, struct sk_buff *skb)
 	}
 	brcmf_fws_lock(fws);
 	hslot = brcmf_skb_htod_tag_get_field(skb, HSLOT);
-	brcmf_fws_txs_process(fws, BRCMF_FWS_TXSTATUS_HOST_TOSSED, hslot, 0);
+	brcmf_fws_txs_process(fws, BRCMF_FWS_TXSTATUS_HOST_TOSSED, hslot, 0, 0);
 	brcmf_fws_unlock(fws);
 }
 
-- 
1.7.10.4


