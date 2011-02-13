Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:64088 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754119Ab1BMOk5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Feb 2011 09:40:57 -0500
Received: by bwz15 with SMTP id 15so4702340bwz.19
        for <linux-wireless@vger.kernel.org>; Sun, 13 Feb 2011 06:40:56 -0800 (PST)
From: Stanislav Fomichev <kernel@fomichev.me>
To: linux-wireless@vger.kernel.org
Cc: brudley@broadcom.com, gregkh@suse.de
Subject: [PATCH 1/8] brcm80211: replace dot11_header with ieee80211_hdr
Date: Sun, 13 Feb 2011 17:40:36 +0300
Message-Id: <1297608043-18381-1-git-send-email-kernel@fomichev.me>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a series of patches which remove brcm specific definitions.
Tested on MacBook 7.1.

Signed-off-by: Stanislav Fomichev <kernel@fomichev.me>
---
 drivers/staging/brcm80211/include/proto/802.11.h |   10 ----
 drivers/staging/brcm80211/sys/wlc_ampdu.c        |   18 +++---
 drivers/staging/brcm80211/sys/wlc_mac80211.c     |   64 +++++++++++-----------
 3 files changed, 41 insertions(+), 51 deletions(-)

diff --git a/drivers/staging/brcm80211/include/proto/802.11.h b/drivers/staging/brcm80211/include/proto/802.11.h
index ffde19c..3bc066a 100644
--- a/drivers/staging/brcm80211/include/proto/802.11.h
+++ b/drivers/staging/brcm80211/include/proto/802.11.h
@@ -45,16 +45,6 @@
 
 #define DOT11_OUI_LEN			3
 
-BWL_PRE_PACKED_STRUCT struct dot11_header {
-	u16 fc;
-	u16 durid;
-	struct ether_addr a1;
-	struct ether_addr a2;
-	struct ether_addr a3;
-	u16 seq;
-	struct ether_addr a4;
-} BWL_POST_PACKED_STRUCT;
-
 BWL_PRE_PACKED_STRUCT struct dot11_rts_frame {
 	u16 fc;
 	u16 durid;
diff --git a/drivers/staging/brcm80211/sys/wlc_ampdu.c b/drivers/staging/brcm80211/sys/wlc_ampdu.c
index d749917..74da502 100644
--- a/drivers/staging/brcm80211/sys/wlc_ampdu.c
+++ b/drivers/staging/brcm80211/sys/wlc_ampdu.c
@@ -154,10 +154,10 @@ static void wlc_ampdu_dotxstatus_complete(struct ampdu_info *ampdu,
 static inline u16 pkt_txh_seqnum(struct wlc_info *wlc, struct sk_buff *p)
 {
 	d11txh_t *txh;
-	struct dot11_header *h;
+	struct ieee80211_hdr *h;
 	txh = (d11txh_t *) p->data;
-	h = (struct dot11_header *)((u8 *) (txh + 1) + D11_PHY_HDR_LEN);
-	return ltoh16(h->seq) >> SEQNUM_SHIFT;
+	h = (struct ieee80211_hdr *)((u8 *) (txh + 1) + D11_PHY_HDR_LEN);
+	return le16_to_cpu(h->seq_ctrl) >> SEQNUM_SHIFT;
 }
 
 struct ampdu_info *wlc_ampdu_attach(struct wlc_info *wlc)
@@ -510,7 +510,7 @@ wlc_sendampdu(struct ampdu_info *ampdu, wlc_txq_info_t *qi,
 	u32 ampdu_len, maxlen = 0;
 	d11txh_t *txh = NULL;
 	u8 *plcp;
-	struct dot11_header *h;
+	struct ieee80211_hdr *h;
 	struct scb *scb;
 	scb_ampdu_t *scb_ampdu;
 	scb_ampdu_tid_ini_t *ini;
@@ -596,8 +596,8 @@ wlc_sendampdu(struct ampdu_info *ampdu, wlc_txq_info_t *qi,
 		ASSERT(tx_info->flags & IEEE80211_TX_CTL_AMPDU);
 		txh = (d11txh_t *) p->data;
 		plcp = (u8 *) (txh + 1);
-		h = (struct dot11_header *)(plcp + D11_PHY_HDR_LEN);
-		seq = ltoh16(h->seq) >> SEQNUM_SHIFT;
+		h = (struct ieee80211_hdr *)(plcp + D11_PHY_HDR_LEN);
+		seq = le16_to_cpu(h->seq_ctrl) >> SEQNUM_SHIFT;
 		index = TX_SEQ_TO_INDEX(seq);
 
 		/* check mcl fields and test whether it can be agg'd */
@@ -968,7 +968,7 @@ wlc_ampdu_dotxstatus_complete(struct ampdu_info *ampdu, struct scb *scb,
 	u8 bitmap[8], queue, tid;
 	d11txh_t *txh;
 	u8 *plcp;
-	struct dot11_header *h;
+	struct ieee80211_hdr *h;
 	u16 seq, start_seq = 0, bindex, index, mcl;
 	u8 mcs = 0;
 	bool ba_recd = false, ack_recd = false;
@@ -1089,8 +1089,8 @@ wlc_ampdu_dotxstatus_complete(struct ampdu_info *ampdu, struct scb *scb,
 		txh = (d11txh_t *) p->data;
 		mcl = ltoh16(txh->MacTxControlLow);
 		plcp = (u8 *) (txh + 1);
-		h = (struct dot11_header *)(plcp + D11_PHY_HDR_LEN);
-		seq = ltoh16(h->seq) >> SEQNUM_SHIFT;
+		h = (struct ieee80211_hdr *)(plcp + D11_PHY_HDR_LEN);
+		seq = le16_to_cpu(h->seq_ctrl) >> SEQNUM_SHIFT;
 
 		if (tot_mpdu == 0) {
 			mcs = plcp[0] & MIMO_PLCP_MCS_MASK;
diff --git a/drivers/staging/brcm80211/sys/wlc_mac80211.c b/drivers/staging/brcm80211/sys/wlc_mac80211.c
index e37e805..96ff02f 100644
--- a/drivers/staging/brcm80211/sys/wlc_mac80211.c
+++ b/drivers/staging/brcm80211/sys/wlc_mac80211.c
@@ -1735,7 +1735,7 @@ void *wlc_attach(void *wl, u16 vendor, u16 device, uint unit, bool piomode,
 	ASSERT(sizeof(cck_phy_hdr_t) == D11_PHY_HDR_LEN);
 	ASSERT(sizeof(d11txh_t) == D11_TXH_LEN);
 	ASSERT(sizeof(d11rxhdr_t) == RXHDR_LEN);
-	ASSERT(sizeof(struct dot11_header) == DOT11_A4_HDR_LEN);
+	ASSERT(sizeof(struct ieee80211_hdr) == DOT11_A4_HDR_LEN);
 	ASSERT(sizeof(struct dot11_rts_frame) == DOT11_RTS_LEN);
 	ASSERT(sizeof(struct dot11_management_header) == DOT11_MGMT_HDR_LEN);
 	ASSERT(sizeof(struct dot11_bcn_prb) == DOT11_BCN_PRB_LEN);
@@ -5113,12 +5113,12 @@ wlc_sendpkt_mac80211(struct wlc_info *wlc, struct sk_buff *sdu,
 	uint fifo;
 	void *pkt;
 	struct scb *scb = &global_scb;
-	struct dot11_header *d11_header = (struct dot11_header *)(sdu->data);
+	struct ieee80211_hdr *d11_header = (struct ieee80211_hdr *)(sdu->data);
 	u16 type, fc;
 
 	ASSERT(sdu);
 
-	fc = ltoh16(d11_header->fc);
+	fc = le16_to_cpu(d11_header->frame_control);
 	type = FC_TYPE(fc);
 
 	/* 802.11 standard requires management traffic to go at highest priority */
@@ -5650,7 +5650,7 @@ wlc_d11hdrs_mac80211(struct wlc_info *wlc, struct ieee80211_hw *hw,
 		     uint nfrags, uint queue, uint next_frag_len,
 		     wsec_key_t *key, ratespec_t rspec_override)
 {
-	struct dot11_header *h;
+	struct ieee80211_hdr *h;
 	d11txh_t *txh;
 	u8 *plcp, plcp_fallback[D11_PHY_HDR_LEN];
 	struct osl_info *osh;
@@ -5693,8 +5693,8 @@ wlc_d11hdrs_mac80211(struct wlc_info *wlc, struct ieee80211_hw *hw,
 	osh = wlc->osh;
 
 	/* locate 802.11 MAC header */
-	h = (struct dot11_header *)(p->data);
-	fc = ltoh16(h->fc);
+	h = (struct ieee80211_hdr *)(p->data);
+	fc = le16_to_cpu(h->frame_control);
 	type = FC_TYPE(fc);
 
 	qos = (type == FC_TYPE_DATA && FC_SUBTYPE_ANY_QOS(FC_SUBTYPE(fc)));
@@ -5740,7 +5740,7 @@ wlc_d11hdrs_mac80211(struct wlc_info *wlc, struct ieee80211_hw *hw,
 			/* extract fragment number from frame first */
 			seq = ltoh16(seq) & FRAGNUM_MASK;
 			seq |= (SCB_SEQNUM(scb, p->priority) << SEQNUM_SHIFT);
-			h->seq = htol16(seq);
+			h->seq_ctrl = cpu_to_le16(seq);
 
 			frameid = ((seq << TXFID_SEQ_SHIFT) & TXFID_SEQ_MASK) |
 			    (queue & TXFID_QUEUE_MASK);
@@ -5810,7 +5810,7 @@ wlc_d11hdrs_mac80211(struct wlc_info *wlc, struct ieee80211_hw *hw,
 			rspec[k] = WLC_RATE_1M;
 		} else {
 			if (WLANTSEL_ENAB(wlc) &&
-			    !is_multicast_ether_addr(h->a1.octet)) {
+			    !is_multicast_ether_addr(h->addr1)) {
 				/* set tx antenna config */
 				wlc_antsel_antcfg_get(wlc->asi, false, false, 0,
 						      0, &antcfg, &fbantcfg);
@@ -5973,11 +5973,11 @@ wlc_d11hdrs_mac80211(struct wlc_info *wlc, struct ieee80211_hw *hw,
 
 	/* DUR field for main rate */
 	if ((fc != FC_PS_POLL) &&
-	    !is_multicast_ether_addr(h->a1.octet) && !use_rifs) {
+	    !is_multicast_ether_addr(h->addr1) && !use_rifs) {
 		durid =
 		    wlc_compute_frame_dur(wlc, rspec[0], preamble_type[0],
 					  next_frag_len);
-		h->durid = htol16(durid);
+		h->duration_id = cpu_to_le16(durid);
 	} else if (use_rifs) {
 		/* NAV protect to end of next max packet size */
 		durid =
@@ -5985,13 +5985,13 @@ wlc_d11hdrs_mac80211(struct wlc_info *wlc, struct ieee80211_hw *hw,
 						 preamble_type[0],
 						 DOT11_MAX_FRAG_LEN);
 		durid += RIFS_11N_TIME;
-		h->durid = htol16(durid);
+		h->duration_id = cpu_to_le16(durid);
 	}
 
 	/* DUR field for fallback rate */
 	if (fc == FC_PS_POLL)
-		txh->FragDurFallback = h->durid;
-	else if (is_multicast_ether_addr(h->a1.octet) || use_rifs)
+		txh->FragDurFallback = h->duration_id;
+	else if (is_multicast_ether_addr(h->addr1) || use_rifs)
 		txh->FragDurFallback = 0;
 	else {
 		durid = wlc_compute_frame_dur(wlc, rspec[1],
@@ -6003,7 +6003,7 @@ wlc_d11hdrs_mac80211(struct wlc_info *wlc, struct ieee80211_hw *hw,
 	if (frag == 0)
 		mcl |= TXC_STARTMSDU;
 
-	if (!is_multicast_ether_addr(h->a1.octet))
+	if (!is_multicast_ether_addr(h->addr1))
 		mcl |= TXC_IMMEDACK;
 
 	if (BAND_5G(wlc->band->bandtype))
@@ -6031,14 +6031,14 @@ wlc_d11hdrs_mac80211(struct wlc_info *wlc, struct ieee80211_hw *hw,
 	}
 
 	/* MacFrameControl */
-	bcopy((char *)&h->fc, (char *)&txh->MacFrameControl, sizeof(u16));
+	bcopy((char *)&h->frame_control, (char *)&txh->MacFrameControl, sizeof(u16));
 
 	txh->TxFesTimeNormal = htol16(0);
 
 	txh->TxFesTimeFallback = htol16(0);
 
 	/* TxFrameRA */
-	bcopy((char *)&h->a1, (char *)&txh->TxFrameRA, ETH_ALEN);
+	bcopy((char *)h->addr1, (char *)&txh->TxFrameRA, ETH_ALEN);
 
 	/* TxFrameID */
 	txh->TxFrameID = htol16(frameid);
@@ -6125,10 +6125,10 @@ wlc_d11hdrs_mac80211(struct wlc_info *wlc, struct ieee80211_hw *hw,
 
 		if (use_cts) {
 			rts->fc = htol16(FC_CTS);
-			bcopy((char *)&h->a2, (char *)&rts->ra, ETH_ALEN);
+			bcopy((char *)h->addr2, (char *)&rts->ra, ETH_ALEN);
 		} else {
 			rts->fc = htol16((u16) FC_RTS);
-			bcopy((char *)&h->a1, (char *)&rts->ra,
+			bcopy((char *)h->addr1, (char *)&rts->ra,
 			      2 * ETH_ALEN);
 		}
 
@@ -6232,7 +6232,7 @@ wlc_d11hdrs_mac80211(struct wlc_info *wlc, struct ieee80211_hw *hw,
 	if (SCB_WME(scb) && qos && wlc->edcf_txop[ac]) {
 		uint frag_dur, dur, dur_fallback;
 
-		ASSERT(!is_multicast_ether_addr(h->a1.octet));
+		ASSERT(!is_multicast_ether_addr(h->addr1));
 
 		/* WME: Update TXOP threshold */
 		if ((!(tx_info->flags & IEEE80211_TX_CTL_AMPDU)) && (frag == 0)) {
@@ -6534,7 +6534,7 @@ wlc_dotxstatus(struct wlc_info *wlc, tx_status_t *txs, u32 frm_tx2)
 	int tx_rts, tx_frame_count, tx_rts_count;
 	uint totlen, supr_status;
 	bool lastframe;
-	struct dot11_header *h;
+	struct ieee80211_hdr *h;
 	u16 fc;
 	u16 mcl;
 	struct ieee80211_tx_info *tx_info;
@@ -6590,8 +6590,8 @@ wlc_dotxstatus(struct wlc_info *wlc, tx_status_t *txs, u32 frm_tx2)
 		goto fatal;
 
 	tx_info = IEEE80211_SKB_CB(p);
-	h = (struct dot11_header *)((u8 *) (txh + 1) + D11_PHY_HDR_LEN);
-	fc = ltoh16(h->fc);
+	h = (struct ieee80211_hdr *)((u8 *) (txh + 1) + D11_PHY_HDR_LEN);
+	fc = le16_to_cpu(h->frame_control);
 
 	scb = (struct scb *)tx_info->control.sta->drv_priv;
 
@@ -6985,7 +6985,7 @@ void wlc_bss_list_free(struct wlc_info *wlc, wlc_bss_list_t *bss_list)
 void BCMFASTPATH wlc_recv(struct wlc_info *wlc, struct sk_buff *p)
 {
 	d11rxhdr_t *rxh;
-	struct dot11_header *h;
+	struct ieee80211_hdr *h;
 	struct osl_info *osh;
 	u16 fc;
 	uint len;
@@ -7015,7 +7015,7 @@ void BCMFASTPATH wlc_recv(struct wlc_info *wlc, struct sk_buff *p)
 		skb_pull(p, 2);
 	}
 
-	h = (struct dot11_header *)(p->data + D11_PHY_HDR_LEN);
+	h = (struct ieee80211_hdr *)(p->data + D11_PHY_HDR_LEN);
 	len = p->len;
 
 	if (rxh->RxStatus1 & RXS_FCSERR) {
@@ -7029,8 +7029,8 @@ void BCMFASTPATH wlc_recv(struct wlc_info *wlc, struct sk_buff *p)
 	}
 
 	/* check received pkt has at least frame control field */
-	if (len >= D11_PHY_HDR_LEN + sizeof(h->fc)) {
-		fc = ltoh16(h->fc);
+	if (len >= D11_PHY_HDR_LEN + sizeof(h->frame_control)) {
+		fc = le16_to_cpu(h->frame_control);
 	} else {
 		WLCNTINCR(wlc->pub->_cnt->rxrunt);
 		goto toss;
@@ -7042,10 +7042,10 @@ void BCMFASTPATH wlc_recv(struct wlc_info *wlc, struct sk_buff *p)
 	if (!is_amsdu) {
 		/* CTS and ACK CTL frames are w/o a2 */
 		if (FC_TYPE(fc) == FC_TYPE_DATA || FC_TYPE(fc) == FC_TYPE_MNG) {
-			if ((is_zero_ether_addr(h->a2.octet) ||
-			     is_multicast_ether_addr(h->a2.octet))) {
+			if ((is_zero_ether_addr(h->addr2) ||
+			     is_multicast_ether_addr(h->addr2))) {
 				WL_ERROR("wl%d: %s: dropping a frame with invalid src mac address, a2: %pM\n",
-					 wlc->pub->unit, __func__, &h->a2);
+					 wlc->pub->unit, __func__, h->addr2);
 				WLCNTINCR(wlc->pub->_cnt->rxbadsrcmac);
 				goto toss;
 			}
@@ -7818,7 +7818,7 @@ int wlc_prep_pdu(struct wlc_info *wlc, struct sk_buff *pdu, uint *fifop)
 	struct osl_info *osh;
 	uint fifo;
 	d11txh_t *txh;
-	struct dot11_header *h;
+	struct ieee80211_hdr *h;
 	struct scb *scb;
 	u16 fc;
 
@@ -7827,9 +7827,9 @@ int wlc_prep_pdu(struct wlc_info *wlc, struct sk_buff *pdu, uint *fifop)
 	ASSERT(pdu);
 	txh = (d11txh_t *) (pdu->data);
 	ASSERT(txh);
-	h = (struct dot11_header *)((u8 *) (txh + 1) + D11_PHY_HDR_LEN);
+	h = (struct ieee80211_hdr *)((u8 *) (txh + 1) + D11_PHY_HDR_LEN);
 	ASSERT(h);
-	fc = ltoh16(h->fc);
+	fc = le16_to_cpu(h->frame_control);
 
 	/* get the pkt queue info. This was put at wlc_sendctl or wlc_send for PDU */
 	fifo = ltoh16(txh->TxFrameID) & TXFID_QUEUE_MASK;
-- 
1.7.1

