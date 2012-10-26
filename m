Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:34520 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933271Ab2JZOXv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Oct 2012 10:23:51 -0400
From: Seth Forshee <seth.forshee@canonical.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Arend van Spriel <arend@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Brett Rudley <brudley@broadcom.com>,
	Roland Vossen <rvossen@broadcom.com>,
	Kan Yan <kanyan@broadcom.com>, brcm80211-dev-list@broadcom.com,
	Seth Forshee <seth.forshee@canonical.com>
Subject: [PATCH 01/18] brcmsmac: Rework tx code to avoid internal buffering of packets
Date: Fri, 26 Oct 2012 09:23:16 -0500
Message-Id: <1351261413-20821-2-git-send-email-seth.forshee@canonical.com> (sfid-20121026_162358_270355_63617B63)
In-Reply-To: <1351261413-20821-1-git-send-email-seth.forshee@canonical.com>
References: <1351261413-20821-1-git-send-email-seth.forshee@canonical.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The brcmsmac internal tx buffering is problematic for a number of
reasons. The amount of buffering is excessive (228 packets in addition
to the 256 slots in each DMA ring), frames may be dropped due to a lack
of flow control, and the structure of the queues complicates the
otherwise straightforward mapping of mac80211 queues to device fifos.

This patch reworks the transmit code path to eliminate the internal
buffering. Frames are immediately handed off to the DMA support rather
than passing through an intermediate queue. ieee80211_(stop|wake)_queue()
are used for flow control to stop receiving frames when a DMA tx ring is
full.

To handle aggregation the concept of AMPDU sessions is added to the
driver. The AMPDU session allows MPDUs to be temporarily queued by the
DMA code until either a full AMPDU has been collected or circumstances
dictate that transmission should start with a partial AMPDU. The use of
a queue ensures that the tx headers are fully initialized before the
buffers are synced for DMA, and it allows non-aggregate frames to be
immediately placed in the tx ring so that more frames can be collected
for aggregation.

Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
---
 drivers/net/wireless/brcm80211/brcmsmac/ampdu.c |  666 ++++++++++-------------
 drivers/net/wireless/brcm80211/brcmsmac/ampdu.h |   29 +-
 drivers/net/wireless/brcm80211/brcmsmac/dma.c   |  182 ++++++-
 drivers/net/wireless/brcm80211/brcmsmac/dma.h   |    9 +-
 drivers/net/wireless/brcm80211/brcmsmac/main.c  |  514 +++++------------
 drivers/net/wireless/brcm80211/brcmsmac/main.h  |   39 +-
 drivers/net/wireless/brcm80211/brcmsmac/types.h |    1 -
 7 files changed, 628 insertions(+), 812 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/ampdu.c b/drivers/net/wireless/brcm80211/brcmsmac/ampdu.c
index be5bcfb..bfb04ec 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/ampdu.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/ampdu.c
@@ -40,8 +40,6 @@
 #define AMPDU_DEF_RETRY_LIMIT		5
 /* default tx retry limit at reg rate */
 #define AMPDU_DEF_RR_RETRY_LIMIT	2
-/* default weight of ampdu in txfifo */
-#define AMPDU_DEF_TXPKT_WEIGHT		2
 /* default ffpld reserved bytes */
 #define AMPDU_DEF_FFPLD_RSVD		2048
 /* # of inis to be freed on detach */
@@ -114,7 +112,6 @@ struct brcms_fifo_info {
  * mpdu_density: min mpdu spacing (0-7) ==> 2^(x-1)/8 usec
  * max_pdu: max pdus allowed in ampdu
  * dur: max duration of an ampdu (in msec)
- * txpkt_weight: weight of ampdu in txfifo; reduces rate lag
  * rx_factor: maximum rx ampdu factor (0-3) ==> 2^(13+x) bytes
  * ffpld_rsvd: number of bytes to reserve for preload
  * max_txlen: max size of ampdu per mcs, bw and sgi
@@ -136,7 +133,6 @@ struct ampdu_info {
 	u8 mpdu_density;
 	s8 max_pdu;
 	u8 dur;
-	u8 txpkt_weight;
 	u8 rx_factor;
 	u32 ffpld_rsvd;
 	u32 max_txlen[MCS_TABLE_SIZE][2][2];
@@ -247,7 +243,6 @@ struct ampdu_info *brcms_c_ampdu_attach(struct brcms_c_info *wlc)
 	ampdu->mpdu_density = AMPDU_DEF_MPDU_DENSITY;
 	ampdu->max_pdu = AUTO;
 	ampdu->dur = AMPDU_MAX_DUR;
-	ampdu->txpkt_weight = AMPDU_DEF_TXPKT_WEIGHT;
 
 	ampdu->ffpld_rsvd = AMPDU_DEF_FFPLD_RSVD;
 	/*
@@ -498,378 +493,324 @@ brcms_c_ampdu_tx_operational(struct brcms_c_info *wlc, u8 tid,
 	scb_ampdu->max_rx_ampdu_bytes = max_rx_ampdu_bytes;
 }
 
-int
-brcms_c_sendampdu(struct ampdu_info *ampdu, struct brcms_txq_info *qi,
-	      struct sk_buff **pdu, int prec)
+void brcms_c_ampdu_reset_session(struct brcms_ampdu_session *session,
+				 struct brcms_c_info *wlc)
 {
-	struct brcms_c_info *wlc;
-	struct sk_buff *p, *pkt[AMPDU_MAX_MPDU];
-	u8 tid, ndelim;
-	int err = 0;
-	u8 preamble_type = BRCMS_GF_PREAMBLE;
-	u8 fbr_preamble_type = BRCMS_GF_PREAMBLE;
-	u8 rts_preamble_type = BRCMS_LONG_PREAMBLE;
-	u8 rts_fbr_preamble_type = BRCMS_LONG_PREAMBLE;
+	session->wlc = wlc;
+	skb_queue_head_init(&session->skb_list);
+	session->max_ampdu_len = 0;    /* determined from first MPDU */
+	session->max_ampdu_frames = 0; /* determined from first MPDU */
+	session->ampdu_len = 0;
+	session->dma_len = 0;
+}
 
-	bool rr = true, fbr = false;
-	uint i, count = 0, fifo, seg_cnt = 0;
-	u16 plen, len, seq = 0, mcl, mch, index, frameid, dma_len = 0;
-	u32 ampdu_len, max_ampdu_bytes = 0;
-	struct d11txh *txh = NULL;
+/*
+ * Preps the given packet for AMPDU based on the session data. If the
+ * frame cannot be accomodated in the current session, -ENOSPC is
+ * returned.
+ */
+int brcms_c_ampdu_add_frame(struct brcms_ampdu_session *session,
+			    struct sk_buff *p)
+{
+	struct brcms_c_info *wlc = session->wlc;
+	struct ampdu_info *ampdu = wlc->ampdu;
+	struct scb *scb = &wlc->pri_scb;
+	struct scb_ampdu *scb_ampdu = &scb->scb_ampdu;
+	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(p);
+	struct ieee80211_tx_rate *txrate = tx_info->status.rates;
+	struct d11txh *txh = (struct d11txh *)p->data;
+	unsigned ampdu_frames;
+	u8 ndelim, tid;
 	u8 *plcp;
-	struct ieee80211_hdr *h;
-	struct scb *scb;
-	struct scb_ampdu *scb_ampdu;
-	struct scb_ampdu_tid_ini *ini;
-	u8 mcs = 0;
-	bool use_rts = false, use_cts = false;
-	u32 rspec = 0, rspec_fallback = 0;
-	u32 rts_rspec = 0, rts_rspec_fallback = 0;
-	u16 mimo_ctlchbw = PHY_TXC1_BW_20MHZ;
-	struct ieee80211_rts *rts;
-	u8 rr_retry_limit;
-	struct brcms_fifo_info *f;
+	uint len;
+	u16 mcl;
 	bool fbr_iscck;
-	struct ieee80211_tx_info *tx_info;
-	u16 qlen;
-	struct wiphy *wiphy;
-
-	wlc = ampdu->wlc;
-	wiphy = wlc->wiphy;
-	p = *pdu;
+	bool rr;
 
-	tid = (u8) (p->priority);
+	ndelim = txh->RTSPLCPFallback[AMPDU_FBR_NULL_DELIM];
+	plcp = (u8 *)(txh + 1);
+	fbr_iscck = !(le16_to_cpu(txh->XtraFrameTypes) & 0x03);
+	len = fbr_iscck ? BRCMS_GET_CCK_PLCP_LEN(txh->FragPLCPFallback) :
+			  BRCMS_GET_MIMO_PLCP_LEN(txh->FragPLCPFallback);
+	len = roundup(len, 4) + (ndelim + 1) * AMPDU_DELIMITER_LEN;
 
-	f = ampdu->fifo_tb + prio2fifo[tid];
+	ampdu_frames = skb_queue_len(&session->skb_list);
+	if (ampdu_frames != 0) {
+		struct sk_buff *first;
 
-	scb = &wlc->pri_scb;
-	scb_ampdu = &scb->scb_ampdu;
-	ini = &scb_ampdu->ini[tid];
+		if (ampdu_frames + 1 > session->max_ampdu_frames ||
+		    session->ampdu_len + len > session->max_ampdu_len)
+			return -ENOSPC;
 
-	/* Let pressure continue to build ... */
-	qlen = pktq_plen(&qi->q, prec);
-	if (ini->tx_in_transit > 0 &&
-	    qlen < min(scb_ampdu->max_pdu, ini->ba_wsize))
-		/* Collect multiple MPDU's to be sent in the next AMPDU */
-		return -EBUSY;
-
-	/* at this point we intend to transmit an AMPDU */
-	rr_retry_limit = ampdu->rr_retry_limit_tid[tid];
-	ampdu_len = 0;
-	dma_len = 0;
-	while (p) {
-		struct ieee80211_tx_rate *txrate;
-
-		tx_info = IEEE80211_SKB_CB(p);
-		txrate = tx_info->status.rates;
+		/*
+		 * We aren't really out of space if the new frame is of
+		 * a different priority, but we want the same behaviour
+		 * so return -ENOSPC anyway.
+		 *
+		 * XXX: The old AMPDU code did this, but is it really
+		 * necessary?
+		 */
+		first = skb_peek(&session->skb_list);
+		if (p->priority != first->priority)
+			return -ENOSPC;
+	}
 
-		if (tx_info->flags & IEEE80211_TX_CTL_AMPDU) {
-			err = brcms_c_prep_pdu(wlc, p, &fifo);
-		} else {
-			wiphy_err(wiphy, "%s: AMPDU flag is off!\n", __func__);
-			*pdu = NULL;
-			err = 0;
-			break;
-		}
+	/*
+	 * Now that we're sure this frame can be accomodated, update the
+	 * session information.
+	 */
+	session->ampdu_len += len;
+	session->dma_len += p->len;
 
-		if (err) {
-			if (err == -EBUSY) {
-				wiphy_err(wiphy, "wl%d: sendampdu: "
-					  "prep_xdu retry; seq 0x%x\n",
-					  wlc->pub->unit, seq);
-				*pdu = p;
-				break;
-			}
+	tid = (u8)p->priority;
 
-			/* error in the packet; reject it */
-			wiphy_err(wiphy, "wl%d: sendampdu: prep_xdu "
-				  "rejected; seq 0x%x\n", wlc->pub->unit, seq);
-			*pdu = NULL;
-			break;
-		}
+	/* Handle retry limits */
+	if (txrate[0].count <= ampdu->rr_retry_limit_tid[tid]) {
+		txrate[0].count++;
+		rr = true;
+	} else {
+		txrate[1].count++;
+		rr = false;
+	}
 
-		/* pkt is good to be aggregated */
-		txh = (struct d11txh *) p->data;
-		plcp = (u8 *) (txh + 1);
-		h = (struct ieee80211_hdr *)(plcp + D11_PHY_HDR_LEN);
-		seq = le16_to_cpu(h->seq_ctrl) >> SEQNUM_SHIFT;
-		index = TX_SEQ_TO_INDEX(seq);
+	if (ampdu_frames == 0) {
+		u8 plcp0, plcp3, is40, sgi, mcs;
+		uint fifo = le16_to_cpu(txh->TxFrameID) & TXFID_QUEUE_MASK;
+		struct brcms_fifo_info *f = &ampdu->fifo_tb[fifo];
 
-		/* check mcl fields and test whether it can be agg'd */
-		mcl = le16_to_cpu(txh->MacTxControlLow);
-		mcl &= ~TXC_AMPDU_MASK;
-		fbr_iscck = !(le16_to_cpu(txh->XtraFrameTypes) & 0x3);
-		txh->PreloadSize = 0;	/* always default to 0 */
-
-		/*  Handle retry limits */
-		if (txrate[0].count <= rr_retry_limit) {
-			txrate[0].count++;
-			rr = true;
-			fbr = false;
+		if (rr) {
+			plcp0 = plcp[0];
+			plcp3 = plcp[3];
 		} else {
-			fbr = true;
-			rr = false;
-			txrate[1].count++;
-		}
-
-		/* extract the length info */
-		len = fbr_iscck ? BRCMS_GET_CCK_PLCP_LEN(txh->FragPLCPFallback)
-		    : BRCMS_GET_MIMO_PLCP_LEN(txh->FragPLCPFallback);
+			plcp0 = txh->FragPLCPFallback[0];
+			plcp3 = txh->FragPLCPFallback[3];
 
-		/* retrieve null delimiter count */
-		ndelim = txh->RTSPLCPFallback[AMPDU_FBR_NULL_DELIM];
-		seg_cnt += 1;
-
-		BCMMSG(wlc->wiphy, "wl%d: mpdu %d plcp_len %d\n",
-			wlc->pub->unit, count, len);
-
-		/*
-		 * aggregateable mpdu. For ucode/hw agg,
-		 * test whether need to break or change the epoch
-		 */
-		if (count == 0) {
-			mcl |= (TXC_AMPDU_FIRST << TXC_AMPDU_SHIFT);
-			/* refill the bits since might be a retx mpdu */
-			mcl |= TXC_STARTMSDU;
-			rts = (struct ieee80211_rts *)&txh->rts_frame;
-
-			if (ieee80211_is_rts(rts->frame_control)) {
-				mcl |= TXC_SENDRTS;
-				use_rts = true;
-			}
-			if (ieee80211_is_cts(rts->frame_control)) {
-				mcl |= TXC_SENDCTS;
-				use_cts = true;
-			}
-		} else {
-			mcl |= (TXC_AMPDU_MIDDLE << TXC_AMPDU_SHIFT);
-			mcl &= ~(TXC_STARTMSDU | TXC_SENDRTS | TXC_SENDCTS);
 		}
 
-		len = roundup(len, 4);
-		ampdu_len += (len + (ndelim + 1) * AMPDU_DELIMITER_LEN);
+		/* Limit AMPDU size based on MCS */
+		is40 = (plcp0 & MIMO_PLCP_40MHZ) ? 1 : 0;
+		sgi = plcp3_issgi(plcp3) ? 1 : 0;
+		mcs = plcp0 & ~MIMO_PLCP_40MHZ;
+		session->max_ampdu_len = min(scb_ampdu->max_rx_ampdu_bytes,
+					     ampdu->max_txlen[mcs][is40][sgi]);
 
-		dma_len += (u16) p->len;
+		session->max_ampdu_frames = scb_ampdu->max_pdu;
+		if (mcs_2_rate(mcs, true, false) >= f->dmaxferrate) {
+			session->max_ampdu_frames =
+				min_t(u16, f->mcs2ampdu_table[mcs],
+				      session->max_ampdu_frames);
+		}
+	}
 
-		BCMMSG(wlc->wiphy, "wl%d: ampdu_len %d"
-			" seg_cnt %d null delim %d\n",
-			wlc->pub->unit, ampdu_len, seg_cnt, ndelim);
+	/*
+	 * Treat all frames as "middle" frames of AMPDU here. First and
+	 * last frames must be fixed up after all MPDUs have been prepped.
+	 */
+	mcl = le16_to_cpu(txh->MacTxControlLow);
+	mcl &= ~TXC_AMPDU_MASK;
+	mcl |= (TXC_AMPDU_MIDDLE << TXC_AMPDU_SHIFT);
+	mcl &= ~(TXC_STARTMSDU | TXC_SENDRTS | TXC_SENDCTS);
+	txh->MacTxControlLow = cpu_to_le16(mcl);
+	txh->PreloadSize = 0;	/* always default to 0 */
 
-		txh->MacTxControlLow = cpu_to_le16(mcl);
+	skb_queue_tail(&session->skb_list, p);
 
-		/* this packet is added */
-		pkt[count++] = p;
+	return 0;
+}
 
-		/* patch the first MPDU */
-		if (count == 1) {
-			u8 plcp0, plcp3, is40, sgi;
+void brcms_c_ampdu_finalize(struct brcms_ampdu_session *session)
+{
+	struct brcms_c_info *wlc = session->wlc;
+	struct ampdu_info *ampdu = wlc->ampdu;
+	struct sk_buff *first, *last;
+	struct d11txh *txh;
+	struct ieee80211_tx_info *tx_info;
+	struct ieee80211_tx_rate *txrate;
+	u8 ndelim;
+	u8 *plcp;
+	uint len;
+	uint fifo;
+	struct brcms_fifo_info *f;
+	u16 mcl;
+	bool fbr;
+	bool fbr_iscck;
+	struct ieee80211_rts *rts;
+	bool use_rts = false, use_cts = false;
+	u16 dma_len = session->dma_len;
+	u16 mimo_ctlchbw = PHY_TXC1_BW_20MHZ;
+	u32 rspec = 0, rspec_fallback = 0;
+	u32 rts_rspec = 0, rts_rspec_fallback = 0;
+	u8 plcp0, plcp3, is40, sgi, mcs;
+	u16 mch;
+	u8 preamble_type = BRCMS_GF_PREAMBLE;
+	u8 fbr_preamble_type = BRCMS_GF_PREAMBLE;
+	u8 rts_preamble_type = BRCMS_LONG_PREAMBLE;
+	u8 rts_fbr_preamble_type = BRCMS_LONG_PREAMBLE;
 
-			if (rr) {
-				plcp0 = plcp[0];
-				plcp3 = plcp[3];
-			} else {
-				plcp0 = txh->FragPLCPFallback[0];
-				plcp3 = txh->FragPLCPFallback[3];
+	if (skb_queue_empty(&session->skb_list))
+		return;
 
-			}
-			is40 = (plcp0 & MIMO_PLCP_40MHZ) ? 1 : 0;
-			sgi = plcp3_issgi(plcp3) ? 1 : 0;
-			mcs = plcp0 & ~MIMO_PLCP_40MHZ;
-			max_ampdu_bytes =
-			    min(scb_ampdu->max_rx_ampdu_bytes,
-				ampdu->max_txlen[mcs][is40][sgi]);
-
-			if (is40)
-				mimo_ctlchbw =
-				   CHSPEC_SB_UPPER(wlc_phy_chanspec_get(
-								 wlc->band->pi))
-				   ? PHY_TXC1_BW_20MHZ_UP : PHY_TXC1_BW_20MHZ;
-
-			/* rebuild the rspec and rspec_fallback */
-			rspec = RSPEC_MIMORATE;
-			rspec |= plcp[0] & ~MIMO_PLCP_40MHZ;
-			if (plcp[0] & MIMO_PLCP_40MHZ)
-				rspec |= (PHY_TXC1_BW_40MHZ << RSPEC_BW_SHIFT);
-
-			if (fbr_iscck)	/* CCK */
-				rspec_fallback = cck_rspec(cck_phy2mac_rate
-						    (txh->FragPLCPFallback[0]));
-			else {	/* MIMO */
-				rspec_fallback = RSPEC_MIMORATE;
-				rspec_fallback |=
-				    txh->FragPLCPFallback[0] & ~MIMO_PLCP_40MHZ;
-				if (txh->FragPLCPFallback[0] & MIMO_PLCP_40MHZ)
-					rspec_fallback |=
-					    (PHY_TXC1_BW_40MHZ <<
-					     RSPEC_BW_SHIFT);
-			}
+	first = skb_peek(&session->skb_list);
+	last = skb_peek_tail(&session->skb_list);
+
+	/* Need to fix up last MPDU first to adjust AMPDU length */
+	txh = (struct d11txh *)last->data;
+	fifo = le16_to_cpu(txh->TxFrameID) & TXFID_QUEUE_MASK;
+	f = &ampdu->fifo_tb[fifo];
+
+	mcl = le16_to_cpu(txh->MacTxControlLow);
+	mcl &= ~TXC_AMPDU_MASK;
+	mcl |= (TXC_AMPDU_LAST << TXC_AMPDU_SHIFT);
+	txh->MacTxControlLow = cpu_to_le16(mcl);
+
+	/* remove the null delimiter after last mpdu */
+	ndelim = txh->RTSPLCPFallback[AMPDU_FBR_NULL_DELIM];
+	txh->RTSPLCPFallback[AMPDU_FBR_NULL_DELIM] = 0;
+	session->ampdu_len -= ndelim * AMPDU_DELIMITER_LEN;
+
+	/* remove the pad len from last mpdu */
+	fbr_iscck = ((le16_to_cpu(txh->XtraFrameTypes) & 0x3) == 0);
+	len = fbr_iscck ? BRCMS_GET_CCK_PLCP_LEN(txh->FragPLCPFallback) :
+			  BRCMS_GET_MIMO_PLCP_LEN(txh->FragPLCPFallback);
+	session->ampdu_len -= roundup(len, 4) - len;
+
+	/* Now fix up the first MPDU */
+	tx_info = IEEE80211_SKB_CB(first);
+	txrate = tx_info->status.rates;
+	txh = (struct d11txh *)first->data;
+	plcp = (u8 *)(txh + 1);
+	rts = (struct ieee80211_rts *)&txh->rts_frame;
+
+	mcl = le16_to_cpu(txh->MacTxControlLow);
+	/* If only one MPDU leave it marked as last */
+	if (first != last) {
+		mcl &= ~TXC_AMPDU_MASK;
+		mcl |= (TXC_AMPDU_FIRST << TXC_AMPDU_SHIFT);
+	}
+	mcl |= TXC_STARTMSDU;
+	if (ieee80211_is_rts(rts->frame_control)) {
+		mcl |= TXC_SENDRTS;
+		use_rts = true;
+	}
+	if (ieee80211_is_cts(rts->frame_control)) {
+		mcl |= TXC_SENDCTS;
+		use_cts = true;
+	}
+	txh->MacTxControlLow = cpu_to_le16(mcl);
 
-			if (use_rts || use_cts) {
-				rts_rspec =
-				    brcms_c_rspec_to_rts_rspec(wlc,
-					rspec, false, mimo_ctlchbw);
-				rts_rspec_fallback =
-				    brcms_c_rspec_to_rts_rspec(wlc,
-					rspec_fallback, false, mimo_ctlchbw);
-			}
-		}
+	fbr = txrate[1].count > 0;
+	if (!fbr) {
+		plcp0 = plcp[0];
+		plcp3 = plcp[3];
+	} else {
+		plcp0 = txh->FragPLCPFallback[0];
+		plcp3 = txh->FragPLCPFallback[3];
+	}
+	is40 = (plcp0 & MIMO_PLCP_40MHZ) ? 1 : 0;
+	sgi = plcp3_issgi(plcp3) ? 1 : 0;
+	mcs = plcp0 & ~MIMO_PLCP_40MHZ;
+
+	if (is40) {
+		if (CHSPEC_SB_UPPER(wlc_phy_chanspec_get(wlc->band->pi)))
+			mimo_ctlchbw = PHY_TXC1_BW_20MHZ_UP;
+		else
+			mimo_ctlchbw = PHY_TXC1_BW_20MHZ;
+	}
 
-		/* if (first mpdu for host agg) */
-		/* test whether to add more */
-		if ((mcs_2_rate(mcs, true, false) >= f->dmaxferrate) &&
-		    (count == f->mcs2ampdu_table[mcs])) {
-			BCMMSG(wlc->wiphy, "wl%d: PR 37644: stopping"
-				" ampdu at %d for mcs %d\n",
-				wlc->pub->unit, count, mcs);
-			break;
-		}
+	/* rebuild the rspec and rspec_fallback */
+	rspec = RSPEC_MIMORATE;
+	rspec |= plcp[0] & ~MIMO_PLCP_40MHZ;
+	if (plcp[0] & MIMO_PLCP_40MHZ)
+		rspec |= (PHY_TXC1_BW_40MHZ << RSPEC_BW_SHIFT);
 
-		if (count == scb_ampdu->max_pdu)
-			break;
+	fbr_iscck = !(le16_to_cpu(txh->XtraFrameTypes) & 0x03);
+	if (fbr_iscck) {
+		rspec_fallback =
+			cck_rspec(cck_phy2mac_rate(txh->FragPLCPFallback[0]));
+	} else {
+		rspec_fallback = RSPEC_MIMORATE;
+		rspec_fallback |= txh->FragPLCPFallback[0] & ~MIMO_PLCP_40MHZ;
+		if (txh->FragPLCPFallback[0] & MIMO_PLCP_40MHZ)
+			rspec_fallback |= PHY_TXC1_BW_40MHZ << RSPEC_BW_SHIFT;
+	}
 
-		/*
-		 * check to see if the next pkt is
-		 * a candidate for aggregation
-		 */
-		p = pktq_ppeek(&qi->q, prec);
-		if (p) {
-			tx_info = IEEE80211_SKB_CB(p);
-			if ((tx_info->flags & IEEE80211_TX_CTL_AMPDU) &&
-			    ((u8) (p->priority) == tid)) {
-				plen = p->len + AMPDU_MAX_MPDU_OVERHEAD;
-				plen = max(scb_ampdu->min_len, plen);
+	if (use_rts || use_cts) {
+		rts_rspec =
+			brcms_c_rspec_to_rts_rspec(wlc, rspec,
+						   false, mimo_ctlchbw);
+		rts_rspec_fallback =
+			brcms_c_rspec_to_rts_rspec(wlc, rspec_fallback,
+						   false, mimo_ctlchbw);
+	}
 
-				if ((plen + ampdu_len) > max_ampdu_bytes) {
-					p = NULL;
-					continue;
-				}
+	BRCMS_SET_MIMO_PLCP_LEN(plcp, session->ampdu_len);
+	/* mark plcp to indicate ampdu */
+	BRCMS_SET_MIMO_PLCP_AMPDU(plcp);
 
-				/*
-				 * check if there are enough
-				 * descriptors available
-				 */
-				if (*wlc->core->txavail[fifo] <= seg_cnt + 1) {
-					wiphy_err(wiphy, "%s: No fifo space  "
-						  "!!\n", __func__);
-					p = NULL;
-					continue;
-				}
-				/* next packet fit for aggregation so dequeue */
-				p = brcmu_pktq_pdeq(&qi->q, prec);
-			} else {
-				p = NULL;
-			}
-		}
-	}			/* end while(p) */
+	/* reset the mixed mode header durations */
+	if (txh->MModeLen) {
+		u16 mmodelen = brcms_c_calc_lsig_len(wlc, rspec,
+						     session->ampdu_len);
+		txh->MModeLen = cpu_to_le16(mmodelen);
+		preamble_type = BRCMS_MM_PREAMBLE;
+	}
+	if (txh->MModeFbrLen) {
+		u16 mmfbrlen = brcms_c_calc_lsig_len(wlc, rspec_fallback,
+						     session->ampdu_len);
+		txh->MModeFbrLen = cpu_to_le16(mmfbrlen);
+		fbr_preamble_type = BRCMS_MM_PREAMBLE;
+	}
 
-	ini->tx_in_transit += count;
+	/* set the preload length */
+	if (mcs_2_rate(mcs, true, false) >= f->dmaxferrate) {
+		dma_len = min(dma_len, f->ampdu_pld_size);
+		txh->PreloadSize = cpu_to_le16(dma_len);
+	} else {
+		txh->PreloadSize = 0;
+	}
 
-	if (count) {
-		/* patch up the last txh */
-		txh = (struct d11txh *) pkt[count - 1]->data;
-		mcl = le16_to_cpu(txh->MacTxControlLow);
-		mcl &= ~TXC_AMPDU_MASK;
-		mcl |= (TXC_AMPDU_LAST << TXC_AMPDU_SHIFT);
-		txh->MacTxControlLow = cpu_to_le16(mcl);
-
-		/* remove the null delimiter after last mpdu */
-		ndelim = txh->RTSPLCPFallback[AMPDU_FBR_NULL_DELIM];
-		txh->RTSPLCPFallback[AMPDU_FBR_NULL_DELIM] = 0;
-		ampdu_len -= ndelim * AMPDU_DELIMITER_LEN;
-
-		/* remove the pad len from last mpdu */
-		fbr_iscck = ((le16_to_cpu(txh->XtraFrameTypes) & 0x3) == 0);
-		len = fbr_iscck ? BRCMS_GET_CCK_PLCP_LEN(txh->FragPLCPFallback)
-		    : BRCMS_GET_MIMO_PLCP_LEN(txh->FragPLCPFallback);
-		ampdu_len -= roundup(len, 4) - len;
-
-		/* patch up the first txh & plcp */
-		txh = (struct d11txh *) pkt[0]->data;
-		plcp = (u8 *) (txh + 1);
+	mch = le16_to_cpu(txh->MacTxControlHigh);
 
-		BRCMS_SET_MIMO_PLCP_LEN(plcp, ampdu_len);
-		/* mark plcp to indicate ampdu */
-		BRCMS_SET_MIMO_PLCP_AMPDU(plcp);
+	/* update RTS dur fields */
+	if (use_rts || use_cts) {
+		u16 durid;
+		if ((mch & TXC_PREAMBLE_RTS_MAIN_SHORT) ==
+		    TXC_PREAMBLE_RTS_MAIN_SHORT)
+			rts_preamble_type = BRCMS_SHORT_PREAMBLE;
 
-		/* reset the mixed mode header durations */
-		if (txh->MModeLen) {
-			u16 mmodelen =
-			    brcms_c_calc_lsig_len(wlc, rspec, ampdu_len);
-			txh->MModeLen = cpu_to_le16(mmodelen);
-			preamble_type = BRCMS_MM_PREAMBLE;
-		}
-		if (txh->MModeFbrLen) {
-			u16 mmfbrlen =
-			    brcms_c_calc_lsig_len(wlc, rspec_fallback,
-						  ampdu_len);
-			txh->MModeFbrLen = cpu_to_le16(mmfbrlen);
-			fbr_preamble_type = BRCMS_MM_PREAMBLE;
-		}
+		if ((mch & TXC_PREAMBLE_RTS_FB_SHORT) ==
+		     TXC_PREAMBLE_RTS_FB_SHORT)
+			rts_fbr_preamble_type = BRCMS_SHORT_PREAMBLE;
 
-		/* set the preload length */
-		if (mcs_2_rate(mcs, true, false) >= f->dmaxferrate) {
-			dma_len = min(dma_len, f->ampdu_pld_size);
-			txh->PreloadSize = cpu_to_le16(dma_len);
-		} else
-			txh->PreloadSize = 0;
-
-		mch = le16_to_cpu(txh->MacTxControlHigh);
-
-		/* update RTS dur fields */
-		if (use_rts || use_cts) {
-			u16 durid;
-			rts = (struct ieee80211_rts *)&txh->rts_frame;
-			if ((mch & TXC_PREAMBLE_RTS_MAIN_SHORT) ==
-			    TXC_PREAMBLE_RTS_MAIN_SHORT)
-				rts_preamble_type = BRCMS_SHORT_PREAMBLE;
-
-			if ((mch & TXC_PREAMBLE_RTS_FB_SHORT) ==
-			    TXC_PREAMBLE_RTS_FB_SHORT)
-				rts_fbr_preamble_type = BRCMS_SHORT_PREAMBLE;
-
-			durid =
-			    brcms_c_compute_rtscts_dur(wlc, use_cts, rts_rspec,
+		durid = brcms_c_compute_rtscts_dur(wlc, use_cts, rts_rspec,
 						   rspec, rts_preamble_type,
-						   preamble_type, ampdu_len,
-						   true);
-			rts->duration = cpu_to_le16(durid);
-			durid = brcms_c_compute_rtscts_dur(wlc, use_cts,
-						       rts_rspec_fallback,
-						       rspec_fallback,
-						       rts_fbr_preamble_type,
-						       fbr_preamble_type,
-						       ampdu_len, true);
-			txh->RTSDurFallback = cpu_to_le16(durid);
-			/* set TxFesTimeNormal */
-			txh->TxFesTimeNormal = rts->duration;
-			/* set fallback rate version of TxFesTimeNormal */
-			txh->TxFesTimeFallback = txh->RTSDurFallback;
-		}
-
-		/* set flag and plcp for fallback rate */
-		if (fbr) {
-			mch |= TXC_AMPDU_FBR;
-			txh->MacTxControlHigh = cpu_to_le16(mch);
-			BRCMS_SET_MIMO_PLCP_AMPDU(plcp);
-			BRCMS_SET_MIMO_PLCP_AMPDU(txh->FragPLCPFallback);
-		}
-
-		BCMMSG(wlc->wiphy, "wl%d: count %d ampdu_len %d\n",
-			wlc->pub->unit, count, ampdu_len);
-
-		/* inform rate_sel if it this is a rate probe pkt */
-		frameid = le16_to_cpu(txh->TxFrameID);
-		if (frameid & TXFID_RATE_PROBE_MASK)
-			wiphy_err(wiphy, "%s: XXX what to do with "
-				  "TXFID_RATE_PROBE_MASK!?\n", __func__);
-
-		for (i = 0; i < count; i++)
-			brcms_c_txfifo(wlc, fifo, pkt[i], i == (count - 1),
-				   ampdu->txpkt_weight);
+						   preamble_type,
+						   session->ampdu_len, true);
+		rts->duration = cpu_to_le16(durid);
+		durid = brcms_c_compute_rtscts_dur(wlc, use_cts,
+						   rts_rspec_fallback,
+						   rspec_fallback,
+						   rts_fbr_preamble_type,
+						   fbr_preamble_type,
+						   session->ampdu_len, true);
+		txh->RTSDurFallback = cpu_to_le16(durid);
+		/* set TxFesTimeNormal */
+		txh->TxFesTimeNormal = rts->duration;
+		/* set fallback rate version of TxFesTimeNormal */
+		txh->TxFesTimeFallback = txh->RTSDurFallback;
+	}
 
+	/* set flag and plcp for fallback rate */
+	if (fbr) {
+		mch |= TXC_AMPDU_FBR;
+		txh->MacTxControlHigh = cpu_to_le16(mch);
+		BRCMS_SET_MIMO_PLCP_AMPDU(plcp);
+		BRCMS_SET_MIMO_PLCP_AMPDU(txh->FragPLCPFallback);
 	}
-	/* endif (count) */
-	return err;
+
+	BCMMSG(wlc->wiphy, "wl%d: count %d ampdu_len %d\n",
+		wlc->pub->unit, skb_queue_len(&session->skb_list),
+		session->ampdu_len);
 }
 
 static void
@@ -977,8 +918,7 @@ brcms_c_ampdu_dotxstatus_complete(struct ampdu_info *ampdu, struct scb *scb,
 				 * if there were underflows, but pre-loading
 				 * is not active, notify rate adaptation.
 				 */
-				if (brcms_c_ffpld_check_txfunfl(wlc,
-					prio2fifo[tid]) > 0)
+				if (brcms_c_ffpld_check_txfunfl(wlc, queue) > 0)
 					tx_error = true;
 			}
 		} else if (txs->phyerr) {
@@ -1046,14 +986,16 @@ brcms_c_ampdu_dotxstatus_complete(struct ampdu_info *ampdu, struct scb *scb,
 		/* either retransmit or send bar if ack not recd */
 		if (!ack_recd) {
 			if (retry && (ini->txretry[index] < (int)retry_limit)) {
+				int ret;
 				ini->txretry[index]++;
 				ini->tx_in_transit--;
+				ret = brcms_c_txfifo(wlc, queue, p);
 				/*
-				 * Use high prededence for retransmit to
-				 * give some punch
+				 * We shouldn't be out of space in the DMA
+				 * ring here since we're reinserting a frame
+				 * that was just pulled out.
 				 */
-				brcms_c_txq_enq(wlc, scb, p,
-						BRCMS_PRIO_TO_HI_PREC(tid));
+				WARN_ONCE(ret, "queue %d out of txds\n", queue);
 			} else {
 				/* Retry timeout */
 				ini->tx_in_transit--;
@@ -1080,12 +1022,9 @@ brcms_c_ampdu_dotxstatus_complete(struct ampdu_info *ampdu, struct scb *scb,
 
 		p = dma_getnexttxp(wlc->hw->di[queue], DMA_RANGE_TRANSMITTED);
 	}
-	brcms_c_send_q(wlc);
 
 	/* update rate state */
 	antselid = brcms_c_antsel_antsel2id(wlc->asi, mimoantsel);
-
-	brcms_c_txfifo_complete(wlc, queue, ampdu->txpkt_weight);
 }
 
 void
@@ -1097,8 +1036,10 @@ brcms_c_ampdu_dotxstatus(struct ampdu_info *ampdu, struct scb *scb,
 	struct scb_ampdu_tid_ini *ini;
 	u32 s1 = 0, s2 = 0;
 	struct ieee80211_tx_info *tx_info;
+	uint queue;
 
 	tx_info = IEEE80211_SKB_CB(p);
+	queue = txs->frameid & TXFID_QUEUE_MASK;
 
 	/* BMAC_NOTE: For the split driver, second level txstatus comes later
 	 * So if the ACK was received then wait for the second level else just
@@ -1127,7 +1068,6 @@ brcms_c_ampdu_dotxstatus(struct ampdu_info *ampdu, struct scb *scb,
 		brcms_c_ampdu_dotxstatus_complete(ampdu, scb, p, txs, s1, s2);
 	} else {
 		/* loop through all pkts and free */
-		u8 queue = txs->frameid & TXFID_QUEUE_MASK;
 		struct d11txh *txh;
 		u16 mcl;
 		while (p) {
@@ -1142,7 +1082,6 @@ brcms_c_ampdu_dotxstatus(struct ampdu_info *ampdu, struct scb *scb,
 			p = dma_getnexttxp(wlc->hw->di[queue],
 					   DMA_RANGE_TRANSMITTED);
 		}
-		brcms_c_txfifo_complete(wlc, queue, ampdu->txpkt_weight);
 	}
 }
 
@@ -1182,23 +1121,6 @@ void brcms_c_ampdu_shm_upd(struct ampdu_info *ampdu)
 }
 
 /*
- * callback function that helps flushing ampdu packets from a priority queue
- */
-static bool cb_del_ampdu_pkt(struct sk_buff *mpdu, void *arg_a)
-{
-	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(mpdu);
-	struct cb_del_ampdu_pars *ampdu_pars =
-				 (struct cb_del_ampdu_pars *)arg_a;
-	bool rc;
-
-	rc = tx_info->flags & IEEE80211_TX_CTL_AMPDU ? true : false;
-	rc = rc && (tx_info->rate_driver_data[0] == NULL || ampdu_pars->sta == NULL ||
-		    tx_info->rate_driver_data[0] == ampdu_pars->sta);
-	rc = rc && ((u8)(mpdu->priority) == ampdu_pars->tid);
-	return rc;
-}
-
-/*
  * callback function that helps invalidating ampdu packets in a DMA queue
  */
 static void dma_cb_fn_ampdu(void *txi, void *arg_a)
@@ -1218,15 +1140,5 @@ static void dma_cb_fn_ampdu(void *txi, void *arg_a)
 void brcms_c_ampdu_flush(struct brcms_c_info *wlc,
 		     struct ieee80211_sta *sta, u16 tid)
 {
-	struct brcms_txq_info *qi = wlc->pkt_queue;
-	struct pktq *pq = &qi->q;
-	int prec;
-	struct cb_del_ampdu_pars ampdu_pars;
-
-	ampdu_pars.sta = sta;
-	ampdu_pars.tid = tid;
-	for (prec = 0; prec < pq->num_prec; prec++)
-		brcmu_pktq_pflush(pq, prec, true, cb_del_ampdu_pkt,
-			    (void *)&ampdu_pars);
 	brcms_c_inval_dma_pkts(wlc->hw, sta, dma_cb_fn_ampdu);
 }
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/ampdu.h b/drivers/net/wireless/brcm80211/brcmsmac/ampdu.h
index 421f4ba..73d01e5 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/ampdu.h
+++ b/drivers/net/wireless/brcm80211/brcmsmac/ampdu.h
@@ -17,11 +17,34 @@
 #ifndef _BRCM_AMPDU_H_
 #define _BRCM_AMPDU_H_
 
+/*
+ * Data structure representing an in-progress session for accumulating
+ * frames for AMPDU.
+ *
+ * wlc: pointer to common driver data
+ * skb_list: queue of skb's for AMPDU
+ * max_ampdu_len: maximum length for this AMPDU
+ * max_ampdu_frames: maximum number of frames for this AMPDU
+ * ampdu_len: total number of bytes accumulated for this AMPDU
+ * dma_len: DMA length of this AMPDU
+ */
+struct brcms_ampdu_session {
+	struct brcms_c_info *wlc;
+	struct sk_buff_head skb_list;
+	unsigned max_ampdu_len;
+	u16 max_ampdu_frames;
+	u16 ampdu_len;
+	u16 dma_len;
+};
+
+extern void brcms_c_ampdu_reset_session(struct brcms_ampdu_session *session,
+					struct brcms_c_info *wlc);
+extern int brcms_c_ampdu_add_frame(struct brcms_ampdu_session *session,
+				   struct sk_buff *p);
+extern void brcms_c_ampdu_finalize(struct brcms_ampdu_session *session);
+
 extern struct ampdu_info *brcms_c_ampdu_attach(struct brcms_c_info *wlc);
 extern void brcms_c_ampdu_detach(struct ampdu_info *ampdu);
-extern int brcms_c_sendampdu(struct ampdu_info *ampdu,
-			     struct brcms_txq_info *qi,
-			     struct sk_buff **aggp, int prec);
 extern void brcms_c_ampdu_dotxstatus(struct ampdu_info *ampdu, struct scb *scb,
 				 struct sk_buff *p, struct tx_status *txs);
 extern void brcms_c_ampdu_macaddr_upd(struct brcms_c_info *wlc);
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/dma.c b/drivers/net/wireless/brcm80211/brcmsmac/dma.c
index 5e53305..426b9a9 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/dma.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/dma.c
@@ -19,12 +19,17 @@
 #include <linux/slab.h>
 #include <linux/delay.h>
 #include <linux/pci.h>
+#include <net/cfg80211.h>
+#include <net/mac80211.h>
 
 #include <brcmu_utils.h>
 #include <aiutils.h>
 #include "types.h"
+#include "main.h"
 #include "dma.h"
 #include "soc.h"
+#include "scb.h"
+#include "ampdu.h"
 
 /*
  * dma register field offset calculation
@@ -230,6 +235,9 @@ struct dma_info {
 	struct bcma_device *core;
 	struct device *dmadev;
 
+	/* session information for AMPDU */
+	struct brcms_ampdu_session ampdu_session;
+
 	bool dma64;	/* this dma engine is operating in 64-bit mode */
 	bool addrext;	/* this dma engine supports DmaExtendedAddrChanges */
 
@@ -564,12 +572,13 @@ static bool _dma_alloc(struct dma_info *di, uint direction)
 	return dma64_alloc(di, direction);
 }
 
-struct dma_pub *dma_attach(char *name, struct si_pub *sih,
-			   struct bcma_device *core,
+struct dma_pub *dma_attach(char *name, struct brcms_c_info *wlc,
 			   uint txregbase, uint rxregbase, uint ntxd, uint nrxd,
 			   uint rxbufsize, int rxextheadroom,
 			   uint nrxpost, uint rxoffset, uint *msg_level)
 {
+	struct si_pub *sih = wlc->hw->sih;
+	struct bcma_device *core = wlc->hw->d11core;
 	struct dma_info *di;
 	u8 rev = core->id.rev;
 	uint size;
@@ -714,6 +723,9 @@ struct dma_pub *dma_attach(char *name, struct si_pub *sih,
 		}
 	}
 
+	/* Initialize AMPDU session */
+	brcms_c_ampdu_reset_session(&di->ampdu_session, wlc);
+
 	DMA_TRACE("ddoffsetlow 0x%x ddoffsethigh 0x%x dataoffsetlow 0x%x dataoffsethigh 0x%x addrext %d\n",
 		  di->ddoffsetlow, di->ddoffsethigh,
 		  di->dataoffsetlow, di->dataoffsethigh,
@@ -1016,6 +1028,17 @@ static bool dma64_rxidle(struct dma_info *di)
 		 D64_RS0_CD_MASK));
 }
 
+static bool dma64_txidle(struct dma_info *di)
+{
+	if (di->ntxd == 0)
+		return true;
+
+	return ((bcma_read32(di->core,
+			     DMA64TXREGOFFS(di, status0)) & D64_XS0_CD_MASK) ==
+		(bcma_read32(di->core, DMA64TXREGOFFS(di, ptr)) &
+		 D64_XS0_CD_MASK));
+}
+
 /*
  * post receive buffers
  *  return false is refill failed completely and ring is empty this will stall
@@ -1264,39 +1287,25 @@ bool dma_rxreset(struct dma_pub *pub)
 	return status == D64_RS0_RS_DISABLED;
 }
 
-/*
- * !! tx entry routine
- * WARNING: call must check the return value for error.
- *   the error(toss frames) could be fatal and cause many subsequent hard
- *   to debug problems
- */
-int dma_txfast(struct dma_pub *pub, struct sk_buff *p, bool commit)
+static void dma_txenq(struct dma_info *di, struct sk_buff *p)
 {
-	struct dma_info *di = (struct dma_info *)pub;
 	unsigned char *data;
 	uint len;
 	u16 txout;
 	u32 flags = 0;
 	dma_addr_t pa;
 
-	DMA_TRACE("%s:\n", di->name);
-
 	txout = di->txout;
 
+	if (WARN_ON(nexttxd(di, txout) == di->txin))
+		return;
+
 	/*
 	 * obtain and initialize transmit descriptor entry.
 	 */
 	data = p->data;
 	len = p->len;
 
-	/* no use to transmit a zero length packet */
-	if (len == 0)
-		return 0;
-
-	/* return nonzero if out of tx descriptors */
-	if (nexttxd(di, txout) == di->txin)
-		goto outoftxd;
-
 	/* get physical address of buffer start */
 	pa = dma_map_single(di->dmadev, data, len, DMA_TO_DEVICE);
 
@@ -1318,14 +1327,105 @@ int dma_txfast(struct dma_pub *pub, struct sk_buff *p, bool commit)
 
 	/* bump the tx descriptor index */
 	di->txout = txout;
+}
 
-	/* kick the chip */
-	if (commit)
-		bcma_write32(di->core, DMA64TXREGOFFS(di, ptr),
-		      di->xmtptrbase + I2B(txout, struct dma64desc));
+static void ampdu_finalize(struct dma_info *di)
+{
+	struct brcms_ampdu_session *session = &di->ampdu_session;
+	struct sk_buff *p;
+
+	if (WARN_ON(skb_queue_empty(&session->skb_list)))
+		return;
+
+	brcms_c_ampdu_finalize(session);
+
+	while (!skb_queue_empty(&session->skb_list)) {
+		p = skb_dequeue(&session->skb_list);
+		dma_txenq(di, p);
+	}
+
+	bcma_write32(di->core, DMA64TXREGOFFS(di, ptr),
+		     di->xmtptrbase + I2B(di->txout, struct dma64desc));
+	brcms_c_ampdu_reset_session(session, session->wlc);
+}
+
+static void prep_ampdu_frame(struct dma_info *di, struct sk_buff *p)
+{
+	struct brcms_ampdu_session *session = &di->ampdu_session;
+	int ret;
+
+	ret = brcms_c_ampdu_add_frame(session, p);
+	if (ret == -ENOSPC) {
+		/*
+		 * AMPDU cannot accomodate this frame. Close out the in-
+		 * progress AMPDU session and start a new one.
+		 */
+		ampdu_finalize(di);
+		ret = brcms_c_ampdu_add_frame(session, p);
+	}
+
+	WARN_ON(ret);
+}
+
+/* Update count of available tx descriptors based on current DMA state */
+static void dma_update_txavail(struct dma_info *di)
+{
+	/*
+	 * Available space is number of descriptors less the number of
+	 * active descriptors and the number of queued AMPDU frames.
+	 */
+	di->dma.txavail = di->ntxd - ntxdactive(di, di->txin, di->txout) -
+			  skb_queue_len(&di->ampdu_session.skb_list) - 1;
+}
+
+/*
+ * !! tx entry routine
+ * WARNING: call must check the return value for error.
+ *   the error(toss frames) could be fatal and cause many subsequent hard
+ *   to debug problems
+ */
+int dma_txfast(struct brcms_c_info *wlc, struct dma_pub *pub,
+	       struct sk_buff *p)
+{
+	struct dma_info *di = (struct dma_info *)pub;
+	struct brcms_ampdu_session *session = &di->ampdu_session;
+	struct ieee80211_tx_info *tx_info;
+	bool is_ampdu;
+
+	DMA_TRACE("%s:\n", di->name);
+
+	/* no use to transmit a zero length packet */
+	if (p->len == 0)
+		return 0;
+
+	/* return nonzero if out of tx descriptors */
+	if (di->dma.txavail == 0 || nexttxd(di, di->txout) == di->txin)
+		goto outoftxd;
+
+	tx_info = IEEE80211_SKB_CB(p);
+	is_ampdu = tx_info->flags & IEEE80211_TX_CTL_AMPDU;
+	if (is_ampdu)
+		prep_ampdu_frame(di, p);
+	else
+		dma_txenq(di, p);
 
 	/* tx flow control */
-	di->dma.txavail = di->ntxd - ntxdactive(di, di->txin, di->txout) - 1;
+	dma_update_txavail(di);
+
+	/* kick the chip */
+	if (is_ampdu) {
+		/*
+		 * Start sending data if we've got a full AMPDU, there's
+		 * no more space in the DMA ring, or the ring isn't
+		 * currently transmitting.
+		 */
+		if (skb_queue_len(&session->skb_list) == session->max_ampdu_frames ||
+		    di->dma.txavail == 0 || dma64_txidle(di))
+			ampdu_finalize(di);
+	} else {
+		bcma_write32(di->core, DMA64TXREGOFFS(di, ptr),
+			     di->xmtptrbase + I2B(di->txout, struct dma64desc));
+	}
 
 	return 0;
 
@@ -1334,7 +1434,35 @@ int dma_txfast(struct dma_pub *pub, struct sk_buff *p, bool commit)
 	brcmu_pkt_buf_free_skb(p);
 	di->dma.txavail = 0;
 	di->dma.txnobuf++;
-	return -1;
+	return -ENOSPC;
+}
+
+void dma_txflush(struct dma_pub *pub)
+{
+	struct dma_info *di = (struct dma_info *)pub;
+	struct brcms_ampdu_session *session = &di->ampdu_session;
+
+	if (!skb_queue_empty(&session->skb_list))
+		ampdu_finalize(di);
+}
+
+int dma_txpending(struct dma_pub *pub)
+{
+	struct dma_info *di = (struct dma_info *)pub;
+	return ntxdactive(di, di->txin, di->txout);
+}
+
+/*
+ * If we have an active AMPDU session and are not transmitting,
+ * this function will force tx to start.
+ */
+void dma_kick_tx(struct dma_pub *pub)
+{
+	struct dma_info *di = (struct dma_info *)pub;
+	struct brcms_ampdu_session *session = &di->ampdu_session;
+
+	if (!skb_queue_empty(&session->skb_list) && dma64_txidle(di))
+		ampdu_finalize(di);
 }
 
 /*
@@ -1412,7 +1540,7 @@ struct sk_buff *dma_getnexttxp(struct dma_pub *pub, enum txd_range range)
 	di->txin = i;
 
 	/* tx flow control */
-	di->dma.txavail = di->ntxd - ntxdactive(di, di->txin, di->txout) - 1;
+	dma_update_txavail(di);
 
 	return txp;
 
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/dma.h b/drivers/net/wireless/brcm80211/brcmsmac/dma.h
index cc269ee..459abf1 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/dma.h
+++ b/drivers/net/wireless/brcm80211/brcmsmac/dma.h
@@ -74,8 +74,7 @@ struct dma_pub {
 	uint txnobuf;		/* tx out of dma descriptors */
 };
 
-extern struct dma_pub *dma_attach(char *name, struct si_pub *sih,
-				  struct bcma_device *d11core,
+extern struct dma_pub *dma_attach(char *name, struct brcms_c_info *wlc,
 				  uint txregbase, uint rxregbase,
 				  uint ntxd, uint nrxd,
 				  uint rxbufsize, int rxextheadroom,
@@ -87,7 +86,11 @@ bool dma_rxfill(struct dma_pub *pub);
 bool dma_rxreset(struct dma_pub *pub);
 bool dma_txreset(struct dma_pub *pub);
 void dma_txinit(struct dma_pub *pub);
-int dma_txfast(struct dma_pub *pub, struct sk_buff *p0, bool commit);
+int dma_txfast(struct brcms_c_info *wlc, struct dma_pub *pub,
+	       struct sk_buff *p0);
+void dma_txflush(struct dma_pub *pub);
+int dma_txpending(struct dma_pub *pub);
+void dma_kick_tx(struct dma_pub *pub);
 void dma_txsuspend(struct dma_pub *pub);
 bool dma_txsuspended(struct dma_pub *pub);
 void dma_txresume(struct dma_pub *pub);
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/main.c b/drivers/net/wireless/brcm80211/brcmsmac/main.c
index 565c15a..2dd0e4f 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/main.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/main.c
@@ -34,6 +34,7 @@
 #include "ucode_loader.h"
 #include "main.h"
 #include "soc.h"
+#include "dma.h"
 
 /*
  * Indication for txflowcontrol that all priority bits in
@@ -242,12 +243,12 @@
 /* Max # of entries in Rx FIFO based on 4kb page size */
 #define NRXD				256
 
+/* Amount of headroom to leave in Tx FIFO */
+#define TX_HEADROOM			4
+
 /* try to keep this # rbufs posted to the chip */
 #define NRXBUFPOST			32
 
-/* data msg txq hiwat mark */
-#define BRCMS_DATAHIWAT			50
-
 /* max # frames to process in brcms_c_recv() */
 #define RXBND				8
 /* max # tx status to process in wlc_txstatus() */
@@ -283,17 +284,6 @@ struct edcf_acparam {
 	u16 TXOP;
 } __packed;
 
-const u8 prio2fifo[NUMPRIO] = {
-	TX_AC_BE_FIFO,		/* 0    BE      AC_BE   Best Effort */
-	TX_AC_BK_FIFO,		/* 1    BK      AC_BK   Background */
-	TX_AC_BK_FIFO,		/* 2    --      AC_BK   Background */
-	TX_AC_BE_FIFO,		/* 3    EE      AC_BE   Best Effort */
-	TX_AC_VI_FIFO,		/* 4    CL      AC_VI   Video */
-	TX_AC_VI_FIFO,		/* 5    VI      AC_VI   Video */
-	TX_AC_VO_FIFO,		/* 6    VO      AC_VO   Voice */
-	TX_AC_VO_FIFO		/* 7    NC      AC_VO   Voice */
-};
-
 /* debug/trace */
 uint brcm_msg_level =
 #if defined(DEBUG)
@@ -371,6 +361,36 @@ static const char fifo_names[6][0];
 static struct brcms_c_info *wlc_info_dbg = (struct brcms_c_info *) (NULL);
 #endif
 
+/* Mapping of ieee80211 AC numbers to tx fifos */
+static const u8 fifo_mapping[IEEE80211_NUM_ACS] = {
+	[IEEE80211_AC_VO]	= TX_AC_VO_FIFO,
+	[IEEE80211_AC_VI]	= TX_AC_VI_FIFO,
+	[IEEE80211_AC_BE]	= TX_AC_BE_FIFO,
+	[IEEE80211_AC_BK]	= TX_AC_BK_FIFO,
+};
+
+/* Mapping of tx fifos to ieee80211 AC numbers */
+static const u8 ac_mapping[IEEE80211_NUM_ACS] = {
+	[TX_AC_BK_FIFO]	= IEEE80211_AC_BK,
+	[TX_AC_BE_FIFO]	= IEEE80211_AC_BE,
+	[TX_AC_VI_FIFO]	= IEEE80211_AC_VI,
+	[TX_AC_VO_FIFO]	= IEEE80211_AC_VO,
+};
+
+static u8 brcms_ac_to_fifo(u8 ac)
+{
+	if (ac >= ARRAY_SIZE(fifo_mapping))
+		return TX_AC_BE_FIFO;
+	return fifo_mapping[ac];
+}
+
+static u8 brcms_fifo_to_ac(u8 fifo)
+{
+	if (fifo >= ARRAY_SIZE(ac_mapping))
+		return IEEE80211_AC_BE;
+	return ac_mapping[fifo];
+}
+
 /* Find basic rate for a given rate */
 static u8 brcms_basic_rate(struct brcms_c_info *wlc, u32 rspec)
 {
@@ -415,10 +435,15 @@ static bool brcms_deviceremoved(struct brcms_c_info *wlc)
 }
 
 /* sum the individual fifo tx pending packet counts */
-static s16 brcms_txpktpendtot(struct brcms_c_info *wlc)
+static int brcms_txpktpendtot(struct brcms_c_info *wlc)
 {
-	return wlc->core->txpktpend[0] + wlc->core->txpktpend[1] +
-	       wlc->core->txpktpend[2] + wlc->core->txpktpend[3];
+	int i;
+	int pending = 0;
+
+	for (i = 0; i < ARRAY_SIZE(wlc->hw->di); i++)
+		if (wlc->hw->di[i])
+			pending += dma_txpending(wlc->hw->di[i]);
+	return pending;
 }
 
 static bool brcms_is_mband_unlocked(struct brcms_c_info *wlc)
@@ -841,8 +866,9 @@ static u32 brcms_c_setband_inact(struct brcms_c_info *wlc, uint bandunit)
 static bool
 brcms_c_dotxstatus(struct brcms_c_info *wlc, struct tx_status *txs)
 {
-	struct sk_buff *p;
-	uint queue;
+	struct sk_buff *p = NULL;
+	uint queue = NFIFO;
+	struct dma_pub *dma = NULL;
 	struct d11txh *txh;
 	struct scb *scb = NULL;
 	bool free_pdu;
@@ -854,6 +880,7 @@ brcms_c_dotxstatus(struct brcms_c_info *wlc, struct tx_status *txs)
 	struct ieee80211_tx_info *tx_info;
 	struct ieee80211_tx_rate *txrate;
 	int i;
+	bool fatal = true;
 
 	/* discard intermediate indications for ucode with one legitimate case:
 	 *   e.g. if "useRTS" is set. ucode did a successful rts/cts exchange,
@@ -863,18 +890,19 @@ brcms_c_dotxstatus(struct brcms_c_info *wlc, struct tx_status *txs)
 	if (!(txs->status & TX_STATUS_AMPDU)
 	    && (txs->status & TX_STATUS_INTERMEDIATE)) {
 		BCMMSG(wlc->wiphy, "INTERMEDIATE but not AMPDU\n");
-		return false;
+		fatal = false;
+		goto out;
 	}
 
 	queue = txs->frameid & TXFID_QUEUE_MASK;
-	if (queue >= NFIFO) {
-		p = NULL;
-		goto fatal;
-	}
+	if (queue >= NFIFO)
+		goto out;
+
+	dma = wlc->hw->di[queue];
 
 	p = dma_getnexttxp(wlc->hw->di[queue], DMA_RANGE_TRANSMITTED);
 	if (p == NULL)
-		goto fatal;
+		goto out;
 
 	txh = (struct d11txh *) (p->data);
 	mcl = le16_to_cpu(txh->MacTxControlLow);
@@ -889,7 +917,7 @@ brcms_c_dotxstatus(struct brcms_c_info *wlc, struct tx_status *txs)
 	}
 
 	if (txs->frameid != le16_to_cpu(txh->TxFrameID))
-		goto fatal;
+		goto out;
 	tx_info = IEEE80211_SKB_CB(p);
 	h = (struct ieee80211_hdr *)((u8 *) (txh + 1) + D11_PHY_HDR_LEN);
 
@@ -898,7 +926,8 @@ brcms_c_dotxstatus(struct brcms_c_info *wlc, struct tx_status *txs)
 
 	if (tx_info->flags & IEEE80211_TX_CTL_AMPDU) {
 		brcms_c_ampdu_dotxstatus(wlc->ampdu, scb, p, txs);
-		return false;
+		fatal = false;
+		goto out;
 	}
 
 	supr_status = txs->status & TX_STATUS_SUPR_MASK;
@@ -982,8 +1011,6 @@ brcms_c_dotxstatus(struct brcms_c_info *wlc, struct tx_status *txs)
 	totlen = p->len;
 	free_pdu = true;
 
-	brcms_c_txfifo_complete(wlc, queue, 1);
-
 	if (lastframe) {
 		/* remove PLCP & Broadcom tx descriptor header */
 		skb_pull(p, D11_PHY_HDR_LEN);
@@ -994,14 +1021,21 @@ brcms_c_dotxstatus(struct brcms_c_info *wlc, struct tx_status *txs)
 			  "tx_status\n", __func__);
 	}
 
-	return false;
+	fatal = false;
 
- fatal:
-	if (p)
+ out:
+	if (fatal && p)
 		brcmu_pkt_buf_free_skb(p);
 
-	return true;
+	if (dma && queue < NFIFO) {
+		u16 ac_queue = brcms_fifo_to_ac(queue);
+		if (dma->txavail > TX_HEADROOM && queue < TX_BCMC_FIFO &&
+		    ieee80211_queue_stopped(wlc->pub->ieee_hw, ac_queue))
+			ieee80211_wake_queue(wlc->pub->ieee_hw, ac_queue);
+		dma_kick_tx(dma);
+	}
 
+	return fatal;
 }
 
 /* process tx completion events in BMAC
@@ -1058,9 +1092,6 @@ brcms_b_txstatus(struct brcms_hardware *wlc_hw, bool bound, bool *fatal)
 	if (n >= max_tx_num)
 		morepending = true;
 
-	if (!pktq_empty(&wlc->pkt_queue->q))
-		brcms_c_send_q(wlc);
-
 	return morepending;
 }
 
@@ -1125,7 +1156,7 @@ static bool brcms_b_attach_dmapio(struct brcms_c_info *wlc, uint j, bool wme)
 		 * TX: TX_AC_BK_FIFO (TX AC Background data packets)
 		 * RX: RX_FIFO (RX data packets)
 		 */
-		wlc_hw->di[0] = dma_attach(name, wlc_hw->sih, wlc_hw->d11core,
+		wlc_hw->di[0] = dma_attach(name, wlc,
 					   (wme ? dmareg(DMA_TX, 0) : 0),
 					   dmareg(DMA_RX, 0),
 					   (wme ? NTXD : 0), NRXD,
@@ -1139,7 +1170,7 @@ static bool brcms_b_attach_dmapio(struct brcms_c_info *wlc, uint j, bool wme)
 		 *   (legacy) TX_DATA_FIFO (TX data packets)
 		 * RX: UNUSED
 		 */
-		wlc_hw->di[1] = dma_attach(name, wlc_hw->sih, wlc_hw->d11core,
+		wlc_hw->di[1] = dma_attach(name, wlc,
 					   dmareg(DMA_TX, 1), 0,
 					   NTXD, 0, 0, -1, 0, 0,
 					   &brcm_msg_level);
@@ -1150,7 +1181,7 @@ static bool brcms_b_attach_dmapio(struct brcms_c_info *wlc, uint j, bool wme)
 		 * TX: TX_AC_VI_FIFO (TX AC Video data packets)
 		 * RX: UNUSED
 		 */
-		wlc_hw->di[2] = dma_attach(name, wlc_hw->sih, wlc_hw->d11core,
+		wlc_hw->di[2] = dma_attach(name, wlc,
 					   dmareg(DMA_TX, 2), 0,
 					   NTXD, 0, 0, -1, 0, 0,
 					   &brcm_msg_level);
@@ -1160,7 +1191,7 @@ static bool brcms_b_attach_dmapio(struct brcms_c_info *wlc, uint j, bool wme)
 		 * TX: TX_AC_VO_FIFO (TX AC Voice data packets)
 		 *   (legacy) TX_CTL_FIFO (TX control & mgmt packets)
 		 */
-		wlc_hw->di[3] = dma_attach(name, wlc_hw->sih, wlc_hw->d11core,
+		wlc_hw->di[3] = dma_attach(name, wlc,
 					   dmareg(DMA_TX, 3),
 					   0, NTXD, 0, 0, -1,
 					   0, 0, &brcm_msg_level);
@@ -2884,12 +2915,14 @@ static void brcms_c_flushqueues(struct brcms_c_info *wlc)
 	uint i;
 
 	/* free any posted tx packets */
-	for (i = 0; i < NFIFO; i++)
+	for (i = 0; i < NFIFO; i++) {
 		if (wlc_hw->di[i]) {
 			dma_txreclaim(wlc_hw->di[i], DMA_RANGE_ALL);
-			wlc->core->txpktpend[i] = 0;
-			BCMMSG(wlc->wiphy, "pktpend fifo %d clrd\n", i);
+			if (i < TX_BCMC_FIFO)
+				ieee80211_wake_queue(wlc->pub->ieee_hw,
+						     brcms_fifo_to_ac(i));
 		}
+	}
 
 	/* free any posted rx packets */
 	dma_rxreclaim(wlc_hw->di[RX_FIFO]);
@@ -3752,40 +3785,6 @@ brcms_c_duty_cycle_set(struct brcms_c_info *wlc, int duty_cycle, bool isOFDM,
 	return 0;
 }
 
-/*
- * Initialize the base precedence map for dequeueing
- * from txq based on WME settings
- */
-static void brcms_c_tx_prec_map_init(struct brcms_c_info *wlc)
-{
-	wlc->tx_prec_map = BRCMS_PREC_BMP_ALL;
-	memset(wlc->fifo2prec_map, 0, NFIFO * sizeof(u16));
-
-	wlc->fifo2prec_map[TX_AC_BK_FIFO] = BRCMS_PREC_BMP_AC_BK;
-	wlc->fifo2prec_map[TX_AC_BE_FIFO] = BRCMS_PREC_BMP_AC_BE;
-	wlc->fifo2prec_map[TX_AC_VI_FIFO] = BRCMS_PREC_BMP_AC_VI;
-	wlc->fifo2prec_map[TX_AC_VO_FIFO] = BRCMS_PREC_BMP_AC_VO;
-}
-
-static void
-brcms_c_txflowcontrol_signal(struct brcms_c_info *wlc,
-			     struct brcms_txq_info *qi, bool on, int prio)
-{
-	/* transmit flowcontrol is not yet implemented */
-}
-
-static void brcms_c_txflowcontrol_reset(struct brcms_c_info *wlc)
-{
-	struct brcms_txq_info *qi;
-
-	for (qi = wlc->tx_queues; qi != NULL; qi = qi->next) {
-		if (qi->stopped) {
-			brcms_c_txflowcontrol_signal(wlc, qi, OFF, ALLPRIO);
-			qi->stopped = 0;
-		}
-	}
-}
-
 /* push sw hps and wake state through hardware */
 static void brcms_c_set_ps_ctrl(struct brcms_c_info *wlc)
 {
@@ -4836,56 +4835,6 @@ static void brcms_c_bss_default_init(struct brcms_c_info *wlc)
 		bi->flags |= BRCMS_BSS_HT;
 }
 
-static struct brcms_txq_info *brcms_c_txq_alloc(struct brcms_c_info *wlc)
-{
-	struct brcms_txq_info *qi, *p;
-
-	qi = kzalloc(sizeof(struct brcms_txq_info), GFP_ATOMIC);
-	if (qi != NULL) {
-		/*
-		 * Have enough room for control packets along with HI watermark
-		 * Also, add room to txq for total psq packets if all the SCBs
-		 * leave PS mode. The watermark for flowcontrol to OS packets
-		 * will remain the same
-		 */
-		brcmu_pktq_init(&qi->q, BRCMS_PREC_COUNT,
-			  2 * BRCMS_DATAHIWAT + PKTQ_LEN_DEFAULT);
-
-		/* add this queue to the the global list */
-		p = wlc->tx_queues;
-		if (p == NULL) {
-			wlc->tx_queues = qi;
-		} else {
-			while (p->next != NULL)
-				p = p->next;
-			p->next = qi;
-		}
-	}
-	return qi;
-}
-
-static void brcms_c_txq_free(struct brcms_c_info *wlc,
-			     struct brcms_txq_info *qi)
-{
-	struct brcms_txq_info *p;
-
-	if (qi == NULL)
-		return;
-
-	/* remove the queue from the linked list */
-	p = wlc->tx_queues;
-	if (p == qi)
-		wlc->tx_queues = p->next;
-	else {
-		while (p != NULL && p->next != qi)
-			p = p->next;
-		if (p != NULL)
-			p->next = p->next->next;
-	}
-
-	kfree(qi);
-}
-
 static void brcms_c_update_mimo_band_bwcap(struct brcms_c_info *wlc, u8 bwcap)
 {
 	uint i;
@@ -5005,10 +4954,6 @@ uint brcms_c_detach(struct brcms_c_info *wlc)
 
 	brcms_c_detach_module(wlc);
 
-
-	while (wlc->tx_queues != NULL)
-		brcms_c_txq_free(wlc, wlc->tx_queues);
-
 	brcms_c_detach_mfree(wlc);
 	return callbacks;
 }
@@ -5314,7 +5259,6 @@ uint brcms_c_down(struct brcms_c_info *wlc)
 	uint callbacks = 0;
 	int i;
 	bool dev_gone = false;
-	struct brcms_txq_info *qi;
 
 	BCMMSG(wlc->wiphy, "wl%d\n", wlc->pub->unit);
 
@@ -5353,13 +5297,6 @@ uint brcms_c_down(struct brcms_c_info *wlc)
 
 	wlc_phy_mute_upd(wlc->band->pi, false, PHY_MUTE_ALL);
 
-	/* clear txq flow control */
-	brcms_c_txflowcontrol_reset(wlc);
-
-	/* flush tx queues */
-	for (qi = wlc->tx_queues; qi != NULL; qi = qi->next)
-		brcmu_pktq_flush(&qi->q, true, NULL, NULL);
-
 	callbacks += brcms_b_down_finish(wlc->hw);
 
 	/* brcms_b_down_finish has done brcms_c_coredisable(). so clk is off */
@@ -6033,86 +5970,6 @@ u16 brcms_b_rate_shm_offset(struct brcms_hardware *wlc_hw, u8 rate)
 	return 2 * brcms_b_read_shm(wlc_hw, table_ptr + (index * 2));
 }
 
-static bool
-brcms_c_prec_enq_head(struct brcms_c_info *wlc, struct pktq *q,
-		      struct sk_buff *pkt, int prec, bool head)
-{
-	struct sk_buff *p;
-	int eprec = -1;		/* precedence to evict from */
-
-	/* Determine precedence from which to evict packet, if any */
-	if (pktq_pfull(q, prec))
-		eprec = prec;
-	else if (pktq_full(q)) {
-		p = brcmu_pktq_peek_tail(q, &eprec);
-		if (eprec > prec) {
-			wiphy_err(wlc->wiphy, "%s: Failing: eprec %d > prec %d"
-				  "\n", __func__, eprec, prec);
-			return false;
-		}
-	}
-
-	/* Evict if needed */
-	if (eprec >= 0) {
-		bool discard_oldest;
-
-		discard_oldest = ac_bitmap_tst(0, eprec);
-
-		/* Refuse newer packet unless configured to discard oldest */
-		if (eprec == prec && !discard_oldest) {
-			wiphy_err(wlc->wiphy, "%s: No where to go, prec == %d"
-				  "\n", __func__, prec);
-			return false;
-		}
-
-		/* Evict packet according to discard policy */
-		p = discard_oldest ? brcmu_pktq_pdeq(q, eprec) :
-			brcmu_pktq_pdeq_tail(q, eprec);
-		brcmu_pkt_buf_free_skb(p);
-	}
-
-	/* Enqueue */
-	if (head)
-		p = brcmu_pktq_penq_head(q, prec, pkt);
-	else
-		p = brcmu_pktq_penq(q, prec, pkt);
-
-	return true;
-}
-
-/*
- * Attempts to queue a packet onto a multiple-precedence queue,
- * if necessary evicting a lower precedence packet from the queue.
- *
- * 'prec' is the precedence number that has already been mapped
- * from the packet priority.
- *
- * Returns true if packet consumed (queued), false if not.
- */
-static bool brcms_c_prec_enq(struct brcms_c_info *wlc, struct pktq *q,
-		      struct sk_buff *pkt, int prec)
-{
-	return brcms_c_prec_enq_head(wlc, q, pkt, prec, false);
-}
-
-void brcms_c_txq_enq(struct brcms_c_info *wlc, struct scb *scb,
-		     struct sk_buff *sdu, uint prec)
-{
-	struct brcms_txq_info *qi = wlc->pkt_queue;	/* Check me */
-	struct pktq *q = &qi->q;
-	int prio;
-
-	prio = sdu->priority;
-
-	if (!brcms_c_prec_enq(wlc, q, sdu, prec)) {
-		/*
-		 * we might hit this condtion in case
-		 * packet flooding from mac80211 stack
-		 */
-		brcmu_pkt_buf_free_skb(sdu);
-	}
-}
-
 /*
  * bcmc_fid_generate:
  * Generate frame ID for a BCMC packet.  The frag field is not used
@@ -7273,79 +7130,33 @@ brcms_c_d11hdrs_mac80211(struct brcms_c_info *wlc, struct ieee80211_hw *hw,
 	return 0;
 }
 
-void brcms_c_sendpkt_mac80211(struct brcms_c_info *wlc, struct sk_buff *sdu,
-			      struct ieee80211_hw *hw)
+static int brcms_c_tx(struct brcms_c_info *wlc, struct sk_buff *skb)
 {
-	u8 prio;
-	uint fifo;
-	struct scb *scb = &wlc->pri_scb;
-	struct ieee80211_hdr *d11_header = (struct ieee80211_hdr *)(sdu->data);
-
-	/*
-	 * 802.11 standard requires management traffic
-	 * to go at highest priority
-	 */
-	prio = ieee80211_is_data(d11_header->frame_control) ? sdu->priority :
-		MAXPRIO;
-	fifo = prio2fifo[prio];
-	if (brcms_c_d11hdrs_mac80211(wlc, hw, sdu, scb, 0, 1, fifo, 0))
-		return;
-	brcms_c_txq_enq(wlc, scb, sdu, BRCMS_PRIO_TO_PREC(prio));
-	brcms_c_send_q(wlc);
-}
-
-void brcms_c_send_q(struct brcms_c_info *wlc)
-{
-	struct sk_buff *pkt[DOT11_MAXNUMFRAGS];
-	int prec;
-	u16 prec_map;
-	int err = 0, i, count;
-	uint fifo;
-	struct brcms_txq_info *qi = wlc->pkt_queue;
-	struct pktq *q = &qi->q;
-	struct ieee80211_tx_info *tx_info;
+	struct dma_pub *dma;
+	int fifo, ret = -ENOSPC;
+	struct d11txh *txh;
+	u16 frameid = INVALIDFID;
 
-	prec_map = wlc->tx_prec_map;
+	fifo = brcms_ac_to_fifo(skb_get_queue_mapping(skb));
+	dma = wlc->hw->di[fifo];
+	txh = (struct d11txh *)(skb->data);
 
-	/* Send all the enq'd pkts that we can.
-	 * Dequeue packets with precedence with empty HW fifo only
-	 */
-	while (prec_map && (pkt[0] = brcmu_pktq_mdeq(q, prec_map, &prec))) {
-		tx_info = IEEE80211_SKB_CB(pkt[0]);
-		if (tx_info->flags & IEEE80211_TX_CTL_AMPDU) {
-			err = brcms_c_sendampdu(wlc->ampdu, qi, pkt, prec);
-		} else {
-			count = 1;
-			err = brcms_c_prep_pdu(wlc, pkt[0], &fifo);
-			if (!err) {
-				for (i = 0; i < count; i++)
-					brcms_c_txfifo(wlc, fifo, pkt[i], true,
-						       1);
-			}
-		}
-
-		if (err == -EBUSY) {
-			brcmu_pktq_penq_head(q, prec, pkt[0]);
-			/*
-			 * If send failed due to any other reason than a
-			 * change in HW FIFO condition, quit. Otherwise,
-			 * read the new prec_map!
-			 */
-			if (prec_map == wlc->tx_prec_map)
-				break;
-			prec_map = wlc->tx_prec_map;
-		}
+	if (dma->txavail == 0) {
+		/*
+		 * We sometimes get a frame from mac80211 after stopping
+		 * the queues. This only ever seems to be a single frame
+		 * and is seems likely to be a race. TX_HEADROOM should
+		 * ensure that we have enough space to handle these stray
+		 * packets, so warn if there isn't. If we're out of space
+		 * in the tx ring and the tx queue isn't stopped then
+		 * we've really got a bug; warn loudly if that happens.
+		 */
+		wiphy_warn(wlc->wiphy,
+			   "Received frame for tx with no space in DMA ring\n");
+		WARN_ON(!ieee80211_queue_stopped(wlc->pub->ieee_hw,
+						 skb_get_queue_mapping(skb)));
+		return -ENOSPC;
 	}
-}
-
-void
-brcms_c_txfifo(struct brcms_c_info *wlc, uint fifo, struct sk_buff *p,
-	       bool commit, s8 txpktpend)
-{
-	u16 frameid = INVALIDFID;
-	struct d11txh *txh;
-
-	txh = (struct d11txh *) (p->data);
 
 	/* When a BC/MC frame is being committed to the BCMC fifo
 	 * via DMA (NOT PIO), update ucode or BSS info as appropriate.
@@ -7353,16 +7164,6 @@ brcms_c_txfifo(struct brcms_c_info *wlc, uint fifo, struct sk_buff *p,
 	if (fifo == TX_BCMC_FIFO)
 		frameid = le16_to_cpu(txh->TxFrameID);
 
-	/*
-	 * Bump up pending count for if not using rpc. If rpc is
-	 * used, this will be handled in brcms_b_txfifo()
-	 */
-	if (commit) {
-		wlc->core->txpktpend[fifo] += txpktpend;
-		BCMMSG(wlc->wiphy, "pktpend inc %d to %d\n",
-			 txpktpend, wlc->core->txpktpend[fifo]);
-	}
-
 	/* Commit BCMC sequence number in the SHM frame ID location */
 	if (frameid != INVALIDFID) {
 		/*
@@ -7372,8 +7173,52 @@ brcms_c_txfifo(struct brcms_c_info *wlc, uint fifo, struct sk_buff *p,
 		brcms_b_write_shm(wlc->hw, M_BCMC_FID, frameid);
 	}
 
-	if (dma_txfast(wlc->hw->di[fifo], p, commit) < 0)
+	ret = brcms_c_txfifo(wlc, fifo, skb);
+	/*
+	 * The only reason for brcms_c_txfifo to fail is because
+	 * there weren't any DMA descriptors, but we've already
+	 * checked for that. So if it does fail yell loudly.
+	 */
+	WARN_ON_ONCE(ret);
+
+	return ret;
+}
+
+void brcms_c_sendpkt_mac80211(struct brcms_c_info *wlc, struct sk_buff *sdu,
+			      struct ieee80211_hw *hw)
+{
+	uint fifo;
+	struct scb *scb = &wlc->pri_scb;
+
+	fifo = brcms_ac_to_fifo(skb_get_queue_mapping(sdu));
+	if (brcms_c_d11hdrs_mac80211(wlc, hw, sdu, scb, 0, 1, fifo, 0))
+		return;
+	if (brcms_c_tx(wlc, sdu))
+		dev_kfree_skb_any(sdu);
+}
+
+int
+brcms_c_txfifo(struct brcms_c_info *wlc, uint fifo, struct sk_buff *p)
+{
+	struct dma_pub *dma = wlc->hw->di[fifo];
+	int ret;
+	u16 queue;
+
+	ret = dma_txfast(wlc, wlc->hw->di[fifo], p);
+	if (ret	< 0)
 		wiphy_err(wlc->wiphy, "txfifo: fatal, toss frames !!!\n");
+
+	/*
+	 * Stop queue if DMA ring is full. Reserve some free descriptors,
+	 * as we sometimes receive a frame from mac80211 after the queues
+	 * are stopped.
+	 */
+	queue = skb_get_queue_mapping(p);
+	if (dma->txavail <= TX_HEADROOM && fifo < TX_BCMC_FIFO &&
+	    !ieee80211_queue_stopped(wlc->pub->ieee_hw, queue))
+		ieee80211_stop_queue(wlc->pub->ieee_hw, queue);
+
+	return ret;
 }
 
 u32
@@ -7423,19 +7268,6 @@ brcms_c_rspec_to_rts_rspec(struct brcms_c_info *wlc, u32 rspec,
 	return rts_rspec;
 }
 
-void
-brcms_c_txfifo_complete(struct brcms_c_info *wlc, uint fifo, s8 txpktpend)
-{
-	wlc->core->txpktpend[fifo] -= txpktpend;
-	BCMMSG(wlc->wiphy, "pktpend dec %d to %d\n", txpktpend,
-	       wlc->core->txpktpend[fifo]);
-
-	/* There is more room; mark precedences related to this FIFO sendable */
-	wlc->tx_prec_map |= wlc->fifo2prec_map[fifo];
-
-	/* figure out which bsscfg is being worked on... */
-}
-
 /* Update beacon listen interval in shared memory */
 static void brcms_c_bcn_li_upd(struct brcms_c_info *wlc)
 {
@@ -7883,35 +7715,6 @@ void brcms_c_update_probe_resp(struct brcms_c_info *wlc, bool suspend)
 		brcms_c_bss_update_probe_resp(wlc, bsscfg, suspend);
 }
 
-/* prepares pdu for transmission. returns BCM error codes */
-int brcms_c_prep_pdu(struct brcms_c_info *wlc, struct sk_buff *pdu, uint *fifop)
-{
-	uint fifo;
-	struct d11txh *txh;
-	struct ieee80211_hdr *h;
-	struct scb *scb;
-
-	txh = (struct d11txh *) (pdu->data);
-	h = (struct ieee80211_hdr *)((u8 *) (txh + 1) + D11_PHY_HDR_LEN);
-
-	/* get the pkt queue info. This was put at brcms_c_sendctl or
-	 * brcms_c_send for PDU */
-	fifo = le16_to_cpu(txh->TxFrameID) & TXFID_QUEUE_MASK;
-
-	scb = NULL;
-
-	*fifop = fifo;
-
-	/* return if insufficient dma resources */
-	if (*wlc->core->txavail[fifo] < MAX_DMA_SEGS) {
-		/* Mark precedences related to this FIFO, unsendable */
-		/* A fifo is full. Clear precedences related to that FIFO */
-		wlc->tx_prec_map &= ~(wlc->fifo2prec_map[fifo]);
-		return -EBUSY;
-	}
-	return 0;
-}
-
 int brcms_b_xmtfifo_sz_get(struct brcms_hardware *wlc_hw, uint fifo,
 			   uint *blocks)
 {
@@ -7977,13 +7780,15 @@ int brcms_c_get_curband(struct brcms_c_info *wlc)
 void brcms_c_wait_for_tx_completion(struct brcms_c_info *wlc, bool drop)
 {
 	int timeout = 20;
+	int i;
 
-	/* flush packet queue when requested */
-	if (drop)
-		brcmu_pktq_flush(&wlc->pkt_queue->q, false, NULL, NULL);
+	/* Kick DMA to send any pending AMPDU */
+	for (i = 0; i < ARRAY_SIZE(wlc->hw->di); i++)
+		if (wlc->hw->di[i])
+			dma_txflush(wlc->hw->di[i]);
 
 	/* wait for queue and DMA fifos to run dry */
-	while (!pktq_empty(&wlc->pkt_queue->q) || brcms_txpktpendtot(wlc) > 0) {
+	while (brcms_txpktpendtot(wlc) > 0) {
 		brcms_msleep(wlc->wl, 1);
 
 		if (--timeout == 0)
@@ -8211,10 +8016,6 @@ bool brcms_c_dpc(struct brcms_c_info *wlc, bool bounded)
 		brcms_rfkill_set_hw_state(wlc->wl);
 	}
 
-	/* send any enq'd tx packets. Just makes sure to jump start tx */
-	if (!pktq_empty(&wlc->pkt_queue->q))
-		brcms_c_send_q(wlc);
-
 	/* it isn't done and needs to be resched if macintstatus is non-zero */
 	return wlc->macintstatus != 0;
 
@@ -8286,9 +8087,6 @@ void brcms_c_init(struct brcms_c_info *wlc, bool mute_tx)
 	bcma_set16(core, D11REGOFFS(ifs_ctl), IFS_USEEDCF);
 	brcms_c_edcf_setparams(wlc, false);
 
-	/* Init precedence maps for empty FIFOs */
-	brcms_c_tx_prec_map_init(wlc);
-
 	/* read the ucode version if we have not yet done so */
 	if (wlc->ucode_rev == 0) {
 		wlc->ucode_rev =
@@ -8303,9 +8101,6 @@ void brcms_c_init(struct brcms_c_info *wlc, bool mute_tx)
 	if (mute_tx)
 		brcms_b_mute(wlc->hw, true);
 
-	/* clear tx flow control */
-	brcms_c_txflowcontrol_reset(wlc);
-
 	/* enable the RF Disable Delay timer */
 	bcma_write32(core, D11REGOFFS(rfdisabledly), RFDISABLE_DEFAULT);
 
@@ -8464,15 +8259,6 @@ brcms_c_attach(struct brcms_info *wl, struct bcma_device *core, uint unit,
 	 * Complete the wlc default state initializations..
 	 */
 
-	/* allocate our initial queue */
-	wlc->pkt_queue = brcms_c_txq_alloc(wlc);
-	if (wlc->pkt_queue == NULL) {
-		wiphy_err(wl->wiphy, "wl%d: %s: failed to malloc tx queue\n",
-			  unit, __func__);
-		err = 100;
-		goto fail;
-	}
-
 	wlc->bsscfg->wlc = wlc;
 
 	wlc->mimoft = FT_HT;
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/main.h b/drivers/net/wireless/brcm80211/brcmsmac/main.h
index 8debc74..8a58cc1 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/main.h
+++ b/drivers/net/wireless/brcm80211/brcmsmac/main.h
@@ -101,9 +101,6 @@
 
 #define DATA_BLOCK_TX_SUPR	(1 << 4)
 
-/* 802.1D Priority to TX FIFO number for wme */
-extern const u8 prio2fifo[];
-
 /* Ucode MCTL_WAKE override bits */
 #define BRCMS_WAKE_OVERRIDE_CLKCTL	0x01
 #define BRCMS_WAKE_OVERRIDE_PHYREG	0x02
@@ -242,7 +239,6 @@ struct brcms_core {
 
 	/* fifo */
 	uint *txavail[NFIFO];	/* # tx descriptors available */
-	s16 txpktpend[NFIFO];	/* tx admission control */
 
 	struct macstat *macstat_snapshot;	/* mac hw prev read values */
 };
@@ -382,19 +378,6 @@ struct brcms_hardware {
 				 */
 };
 
-/* TX Queue information
- *
- * Each flow of traffic out of the device has a TX Queue with independent
- * flow control. Several interfaces may be associated with a single TX Queue
- * if they belong to the same flow of traffic from the device. For multi-channel
- * operation there are independent TX Queues for each channel.
- */
-struct brcms_txq_info {
-	struct brcms_txq_info *next;
-	struct pktq q;
-	uint stopped;		/* tx flow control bits */
-};
-
 /*
  * Principal common driver data structure.
  *
@@ -435,11 +418,8 @@ struct brcms_txq_info {
  * WDlast: last time wlc_watchdog() was called.
  * edcf_txop[IEEE80211_NUM_ACS]: current txop for each ac.
  * wme_retries: per-AC retry limits.
- * tx_prec_map: Precedence map based on HW FIFO space.
- * fifo2prec_map[NFIFO]: pointer to fifo2_prec map based on WME.
  * bsscfg: set of BSS configurations, idx 0 is default and always valid.
  * cfg: the primary bsscfg (can be AP or STA).
- * tx_queues: common TX Queue list.
  * modulecb:
  * mimoft: SIGN or 11N.
  * cck_40txbw: 11N, cck tx b/w override when in 40MHZ mode.
@@ -469,7 +449,6 @@ struct brcms_txq_info {
  * tempsense_lasttime;
  * tx_duty_cycle_ofdm: maximum allowed duty cycle for OFDM.
  * tx_duty_cycle_cck: maximum allowed duty cycle for CCK.
- * pkt_queue: txq for transmit packets.
  * wiphy:
  * pri_scb: primary Station Control Block
  */
@@ -533,14 +512,9 @@ struct brcms_c_info {
 	u16 edcf_txop[IEEE80211_NUM_ACS];
 
 	u16 wme_retries[IEEE80211_NUM_ACS];
-	u16 tx_prec_map;
-	u16 fifo2prec_map[NFIFO];
 
 	struct brcms_bss_cfg *bsscfg;
 
-	/* tx queue */
-	struct brcms_txq_info *tx_queues;
-
 	struct modulecb *modulecb;
 
 	u8 mimoft;
@@ -585,7 +559,6 @@ struct brcms_c_info {
 	u16 tx_duty_cycle_ofdm;
 	u16 tx_duty_cycle_cck;
 
-	struct brcms_txq_info *pkt_queue;
 	struct wiphy *wiphy;
 	struct scb pri_scb;
 };
@@ -637,13 +610,8 @@ struct brcms_bss_cfg {
 	struct brcms_bss_info *current_bss;
 };
 
-extern void brcms_c_txfifo(struct brcms_c_info *wlc, uint fifo,
-			   struct sk_buff *p,
-			   bool commit, s8 txpktpend);
-extern void brcms_c_txfifo_complete(struct brcms_c_info *wlc, uint fifo,
-				    s8 txpktpend);
-extern void brcms_c_txq_enq(struct brcms_c_info *wlc, struct scb *scb,
-			    struct sk_buff *sdu, uint prec);
+extern int brcms_c_txfifo(struct brcms_c_info *wlc, uint fifo,
+			   struct sk_buff *p);
 extern void brcms_c_print_txstatus(struct tx_status *txs);
 extern int brcms_b_xmtfifo_sz_get(struct brcms_hardware *wlc_hw, uint fifo,
 		   uint *blocks);
@@ -658,9 +626,6 @@ static inline void brcms_c_print_txdesc(struct d11txh *txh)
 
 extern int brcms_c_set_gmode(struct brcms_c_info *wlc, u8 gmode, bool config);
 extern void brcms_c_mac_promisc(struct brcms_c_info *wlc, uint filter_flags);
-extern void brcms_c_send_q(struct brcms_c_info *wlc);
-extern int brcms_c_prep_pdu(struct brcms_c_info *wlc, struct sk_buff *pdu,
-			    uint *fifo);
 extern u16 brcms_c_calc_lsig_len(struct brcms_c_info *wlc, u32 ratespec,
 				uint mac_len);
 extern u32 brcms_c_rspec_to_rts_rspec(struct brcms_c_info *wlc,
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/types.h b/drivers/net/wireless/brcm80211/brcmsmac/types.h
index e11ae83..e3abc0e 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/types.h
+++ b/drivers/net/wireless/brcm80211/brcmsmac/types.h
@@ -281,7 +281,6 @@ struct ieee80211_tx_queue_params;
 struct brcms_info;
 struct brcms_c_info;
 struct brcms_hardware;
-struct brcms_txq_info;
 struct brcms_band;
 struct dma_pub;
 struct si_pub;
-- 
1.7.9.5

