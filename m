Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:58847 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767820Ab2KOOIS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Nov 2012 09:08:18 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Arend van Spriel <arend@broadcom.com>,
	linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Brett Rudley <brudley@broadcom.com>,
	Roland Vossen <rvossen@broadcom.com>,
	Kan Yan <kanyan@broadcom.com>, brcm80211-dev-list@broadcom.com,
	Daniel Wagner <wagi@monom.org>,
	Seth Forshee <seth.forshee@canonical.com>
Subject: [PATCH v2 01/22] brcmsmac: Introduce AMPDU sessions for assembling AMPDUs
Date: Thu, 15 Nov 2012 08:07:51 -0600
Message-Id: <1352988492-21340-2-git-send-email-seth.forshee@canonical.com> (sfid-20121115_150836_988256_8BA68C94)
In-Reply-To: <1352988492-21340-1-git-send-email-seth.forshee@canonical.com>
References: <1352988492-21340-1-git-send-email-seth.forshee@canonical.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

AMPDU session allows MPDUs to be temporarily queued until either a full
AMPDU has been collected or circumstances dictate that transmission
should start with a partial AMPDU. Packets are added to the session by
calling brcms_c_ampdu_add_frame(). brcms_c_ampdu_finalize() should be
called to fix up the tx headers in the first and last packet before
adding the packets to the DMA ring. brmcs_c_sendampdu() is converted to
using AMPDU sessions.

This patch has no real value on it's own, but is needed in preparation
for elimination of the tx packet queue from brcmsmac.

Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
---
 drivers/net/wireless/brcm80211/brcmsmac/ampdu.c |  625 +++++++++++++----------
 drivers/net/wireless/brcm80211/brcmsmac/ampdu.h |   26 +
 2 files changed, 377 insertions(+), 274 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/ampdu.c b/drivers/net/wireless/brcm80211/brcmsmac/ampdu.c
index be5bcfb..5739534 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/ampdu.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/ampdu.c
@@ -498,38 +498,341 @@ brcms_c_ampdu_tx_operational(struct brcms_c_info *wlc, u8 tid,
 	scb_ampdu->max_rx_ampdu_bytes = max_rx_ampdu_bytes;
 }
 
+void brcms_c_ampdu_reset_session(struct brcms_ampdu_session *session,
+				 struct brcms_c_info *wlc)
+{
+	session->wlc = wlc;
+	skb_queue_head_init(&session->skb_list);
+	session->max_ampdu_len = 0;    /* determined from first MPDU */
+	session->max_ampdu_frames = 0; /* determined from first MPDU */
+	session->ampdu_len = 0;
+	session->dma_len = 0;
+}
+
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
+	u8 *plcp;
+	uint len;
+	u16 mcl;
+	bool fbr_iscck;
+	bool rr;
+
+	ndelim = txh->RTSPLCPFallback[AMPDU_FBR_NULL_DELIM];
+	plcp = (u8 *)(txh + 1);
+	fbr_iscck = !(le16_to_cpu(txh->XtraFrameTypes) & 0x03);
+	len = fbr_iscck ? BRCMS_GET_CCK_PLCP_LEN(txh->FragPLCPFallback) :
+			  BRCMS_GET_MIMO_PLCP_LEN(txh->FragPLCPFallback);
+	len = roundup(len, 4) + (ndelim + 1) * AMPDU_DELIMITER_LEN;
+
+	ampdu_frames = skb_queue_len(&session->skb_list);
+	if (ampdu_frames != 0) {
+		struct sk_buff *first;
+
+		if (ampdu_frames + 1 > session->max_ampdu_frames ||
+		    session->ampdu_len + len > session->max_ampdu_len)
+			return -ENOSPC;
+
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
+
+	/*
+	 * Now that we're sure this frame can be accomodated, update the
+	 * session information.
+	 */
+	session->ampdu_len += len;
+	session->dma_len += p->len;
+
+	tid = (u8)p->priority;
+
+	/* Handle retry limits */
+	if (txrate[0].count <= ampdu->rr_retry_limit_tid[tid]) {
+		txrate[0].count++;
+		rr = true;
+	} else {
+		txrate[1].count++;
+		rr = false;
+	}
+
+	if (ampdu_frames == 0) {
+		u8 plcp0, plcp3, is40, sgi, mcs;
+		uint fifo = le16_to_cpu(txh->TxFrameID) & TXFID_QUEUE_MASK;
+		struct brcms_fifo_info *f = &ampdu->fifo_tb[fifo];
+
+		if (rr) {
+			plcp0 = plcp[0];
+			plcp3 = plcp[3];
+		} else {
+			plcp0 = txh->FragPLCPFallback[0];
+			plcp3 = txh->FragPLCPFallback[3];
+
+		}
+
+		/* Limit AMPDU size based on MCS */
+		is40 = (plcp0 & MIMO_PLCP_40MHZ) ? 1 : 0;
+		sgi = plcp3_issgi(plcp3) ? 1 : 0;
+		mcs = plcp0 & ~MIMO_PLCP_40MHZ;
+		session->max_ampdu_len = min(scb_ampdu->max_rx_ampdu_bytes,
+					     ampdu->max_txlen[mcs][is40][sgi]);
+
+		session->max_ampdu_frames = scb_ampdu->max_pdu;
+		if (mcs_2_rate(mcs, true, false) >= f->dmaxferrate) {
+			session->max_ampdu_frames =
+				min_t(u16, f->mcs2ampdu_table[mcs],
+				      session->max_ampdu_frames);
+		}
+	}
+
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
+
+	skb_queue_tail(&session->skb_list, p);
+
+	return 0;
+}
+
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
+
+	if (skb_queue_empty(&session->skb_list))
+		return;
+
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
+
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
+
+	/* rebuild the rspec and rspec_fallback */
+	rspec = RSPEC_MIMORATE;
+	rspec |= plcp[0] & ~MIMO_PLCP_40MHZ;
+	if (plcp[0] & MIMO_PLCP_40MHZ)
+		rspec |= (PHY_TXC1_BW_40MHZ << RSPEC_BW_SHIFT);
+
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
+
+	if (use_rts || use_cts) {
+		rts_rspec =
+			brcms_c_rspec_to_rts_rspec(wlc, rspec,
+						   false, mimo_ctlchbw);
+		rts_rspec_fallback =
+			brcms_c_rspec_to_rts_rspec(wlc, rspec_fallback,
+						   false, mimo_ctlchbw);
+	}
+
+	BRCMS_SET_MIMO_PLCP_LEN(plcp, session->ampdu_len);
+	/* mark plcp to indicate ampdu */
+	BRCMS_SET_MIMO_PLCP_AMPDU(plcp);
+
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
+
+	/* set the preload length */
+	if (mcs_2_rate(mcs, true, false) >= f->dmaxferrate) {
+		dma_len = min(dma_len, f->ampdu_pld_size);
+		txh->PreloadSize = cpu_to_le16(dma_len);
+	} else {
+		txh->PreloadSize = 0;
+	}
+
+	mch = le16_to_cpu(txh->MacTxControlHigh);
+
+	/* update RTS dur fields */
+	if (use_rts || use_cts) {
+		u16 durid;
+		if ((mch & TXC_PREAMBLE_RTS_MAIN_SHORT) ==
+		    TXC_PREAMBLE_RTS_MAIN_SHORT)
+			rts_preamble_type = BRCMS_SHORT_PREAMBLE;
+
+		if ((mch & TXC_PREAMBLE_RTS_FB_SHORT) ==
+		     TXC_PREAMBLE_RTS_FB_SHORT)
+			rts_fbr_preamble_type = BRCMS_SHORT_PREAMBLE;
+
+		durid = brcms_c_compute_rtscts_dur(wlc, use_cts, rts_rspec,
+						   rspec, rts_preamble_type,
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
+
+	/* set flag and plcp for fallback rate */
+	if (fbr) {
+		mch |= TXC_AMPDU_FBR;
+		txh->MacTxControlHigh = cpu_to_le16(mch);
+		BRCMS_SET_MIMO_PLCP_AMPDU(plcp);
+		BRCMS_SET_MIMO_PLCP_AMPDU(txh->FragPLCPFallback);
+	}
+
+	BCMMSG(wlc->wiphy, "wl%d: count %d ampdu_len %d\n",
+		wlc->pub->unit, skb_queue_len(&session->skb_list),
+		session->ampdu_len);
+}
+
 int
 brcms_c_sendampdu(struct ampdu_info *ampdu, struct brcms_txq_info *qi,
 	      struct sk_buff **pdu, int prec)
 {
 	struct brcms_c_info *wlc;
-	struct sk_buff *p, *pkt[AMPDU_MAX_MPDU];
-	u8 tid, ndelim;
+	struct sk_buff *p;
+	struct brcms_ampdu_session session;
 	int err = 0;
-	u8 preamble_type = BRCMS_GF_PREAMBLE;
-	u8 fbr_preamble_type = BRCMS_GF_PREAMBLE;
-	u8 rts_preamble_type = BRCMS_LONG_PREAMBLE;
-	u8 rts_fbr_preamble_type = BRCMS_LONG_PREAMBLE;
+	u8 tid;
 
-	bool rr = true, fbr = false;
-	uint i, count = 0, fifo, seg_cnt = 0;
-	u16 plen, len, seq = 0, mcl, mch, index, frameid, dma_len = 0;
-	u32 ampdu_len, max_ampdu_bytes = 0;
-	struct d11txh *txh = NULL;
-	u8 *plcp;
-	struct ieee80211_hdr *h;
+	uint count, fifo, seg_cnt = 0;
 	struct scb *scb;
 	struct scb_ampdu *scb_ampdu;
 	struct scb_ampdu_tid_ini *ini;
-	u8 mcs = 0;
-	bool use_rts = false, use_cts = false;
-	u32 rspec = 0, rspec_fallback = 0;
-	u32 rts_rspec = 0, rts_rspec_fallback = 0;
-	u16 mimo_ctlchbw = PHY_TXC1_BW_20MHZ;
-	struct ieee80211_rts *rts;
-	u8 rr_retry_limit;
 	struct brcms_fifo_info *f;
-	bool fbr_iscck;
 	struct ieee80211_tx_info *tx_info;
 	u16 qlen;
 	struct wiphy *wiphy;
@@ -554,9 +857,8 @@ brcms_c_sendampdu(struct ampdu_info *ampdu, struct brcms_txq_info *qi,
 		return -EBUSY;
 
 	/* at this point we intend to transmit an AMPDU */
-	rr_retry_limit = ampdu->rr_retry_limit_tid[tid];
-	ampdu_len = 0;
-	dma_len = 0;
+	brcms_c_ampdu_reset_session(&session, wlc);
+
 	while (p) {
 		struct ieee80211_tx_rate *txrate;
 
@@ -575,157 +877,35 @@ brcms_c_sendampdu(struct ampdu_info *ampdu, struct brcms_txq_info *qi,
 		if (err) {
 			if (err == -EBUSY) {
 				wiphy_err(wiphy, "wl%d: sendampdu: "
-					  "prep_xdu retry; seq 0x%x\n",
-					  wlc->pub->unit, seq);
+					  "prep_xdu retry\n", wlc->pub->unit);
 				*pdu = p;
 				break;
 			}
 
 			/* error in the packet; reject it */
 			wiphy_err(wiphy, "wl%d: sendampdu: prep_xdu "
-				  "rejected; seq 0x%x\n", wlc->pub->unit, seq);
+				  "rejected\n", wlc->pub->unit);
 			*pdu = NULL;
 			break;
 		}
 
-		/* pkt is good to be aggregated */
-		txh = (struct d11txh *) p->data;
-		plcp = (u8 *) (txh + 1);
-		h = (struct ieee80211_hdr *)(plcp + D11_PHY_HDR_LEN);
-		seq = le16_to_cpu(h->seq_ctrl) >> SEQNUM_SHIFT;
-		index = TX_SEQ_TO_INDEX(seq);
-
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
-		} else {
-			fbr = true;
-			rr = false;
-			txrate[1].count++;
-		}
-
-		/* extract the length info */
-		len = fbr_iscck ? BRCMS_GET_CCK_PLCP_LEN(txh->FragPLCPFallback)
-		    : BRCMS_GET_MIMO_PLCP_LEN(txh->FragPLCPFallback);
-
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
-		}
-
-		len = roundup(len, 4);
-		ampdu_len += (len + (ndelim + 1) * AMPDU_DELIMITER_LEN);
-
-		dma_len += (u16) p->len;
-
-		BCMMSG(wlc->wiphy, "wl%d: ampdu_len %d"
-			" seg_cnt %d null delim %d\n",
-			wlc->pub->unit, ampdu_len, seg_cnt, ndelim);
-
-		txh->MacTxControlLow = cpu_to_le16(mcl);
-
-		/* this packet is added */
-		pkt[count++] = p;
-
-		/* patch the first MPDU */
-		if (count == 1) {
-			u8 plcp0, plcp3, is40, sgi;
-
-			if (rr) {
-				plcp0 = plcp[0];
-				plcp3 = plcp[3];
-			} else {
-				plcp0 = txh->FragPLCPFallback[0];
-				plcp3 = txh->FragPLCPFallback[3];
-
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
-
-			if (use_rts || use_cts) {
-				rts_rspec =
-				    brcms_c_rspec_to_rts_rspec(wlc,
-					rspec, false, mimo_ctlchbw);
-				rts_rspec_fallback =
-				    brcms_c_rspec_to_rts_rspec(wlc,
-					rspec_fallback, false, mimo_ctlchbw);
-			}
-		}
-
-		/* if (first mpdu for host agg) */
-		/* test whether to add more */
-		if ((mcs_2_rate(mcs, true, false) >= f->dmaxferrate) &&
-		    (count == f->mcs2ampdu_table[mcs])) {
-			BCMMSG(wlc->wiphy, "wl%d: PR 37644: stopping"
-				" ampdu at %d for mcs %d\n",
-				wlc->pub->unit, count, mcs);
+		err = brcms_c_ampdu_add_frame(&session, p);
+		if (err == -ENOSPC) {
+			/*
+			 * No space for this packet in the AMPDU.
+			 * Requeue packet and proceed;
+			 */
+			*pdu = p;
+			break;
+		} else if (err) {
+			/* Unexpected error; reject packet */
+			wiphy_err(wiphy, "wl%d: sendampdu: add_frame rejected",
+				  wlc->pub->unit);
+			*pdu = NULL;
 			break;
 		}
 
-		if (count == scb_ampdu->max_pdu)
-			break;
+		seg_cnt += 1;
 
 		/*
 		 * check to see if the next pkt is
@@ -734,22 +914,13 @@ brcms_c_sendampdu(struct ampdu_info *ampdu, struct brcms_txq_info *qi,
 		p = pktq_ppeek(&qi->q, prec);
 		if (p) {
 			tx_info = IEEE80211_SKB_CB(p);
-			if ((tx_info->flags & IEEE80211_TX_CTL_AMPDU) &&
-			    ((u8) (p->priority) == tid)) {
-				plen = p->len + AMPDU_MAX_MPDU_OVERHEAD;
-				plen = max(scb_ampdu->min_len, plen);
-
-				if ((plen + ampdu_len) > max_ampdu_bytes) {
-					p = NULL;
-					continue;
-				}
-
+			if (tx_info->flags & IEEE80211_TX_CTL_AMPDU) {
 				/*
 				 * check if there are enough
 				 * descriptors available
 				 */
 				if (*wlc->core->txavail[fifo] <= seg_cnt + 1) {
-					wiphy_err(wiphy, "%s: No fifo space  "
+					wiphy_err(wiphy, "%s: No fifo space "
 						  "!!\n", __func__);
 					p = NULL;
 					continue;
@@ -762,111 +933,17 @@ brcms_c_sendampdu(struct ampdu_info *ampdu, struct brcms_txq_info *qi,
 		}
 	}			/* end while(p) */
 
+	count = skb_queue_len(&session.skb_list);
 	ini->tx_in_transit += count;
 
 	if (count) {
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
-
-		BRCMS_SET_MIMO_PLCP_LEN(plcp, ampdu_len);
-		/* mark plcp to indicate ampdu */
-		BRCMS_SET_MIMO_PLCP_AMPDU(plcp);
-
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
-
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
-						   rspec, rts_preamble_type,
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
+		/* patch up first and last txh's */
+		brcms_c_ampdu_finalize(&session);
 
+		while ((p = skb_dequeue(&session.skb_list)) != NULL)
+			brcms_c_txfifo(wlc, fifo, p,
+				       skb_queue_empty(&session.skb_list),
+				       ampdu->txpkt_weight);
 	}
 	/* endif (count) */
 	return err;
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/ampdu.h b/drivers/net/wireless/brcm80211/brcmsmac/ampdu.h
index 421f4ba..9a94923 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/ampdu.h
+++ b/drivers/net/wireless/brcm80211/brcmsmac/ampdu.h
@@ -17,6 +17,32 @@
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
 extern int brcms_c_sendampdu(struct ampdu_info *ampdu,
-- 
1.7.9.5

