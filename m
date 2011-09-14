Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:58752 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932903Ab1INTYg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Sep 2011 15:24:36 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, mcgrof@qca.qualcomm.com
Subject: [PATCH 07/12] ath9k: use the new API for setting tx descriptors
Date: Wed, 14 Sep 2011 21:24:22 +0200
Message-Id: <1316028267-34187-7-git-send-email-nbd@openwrt.org> (sfid-20110914_212443_618657_A03D56F2)
In-Reply-To: <1316028267-34187-6-git-send-email-nbd@openwrt.org>
References: <1316028267-34187-1-git-send-email-nbd@openwrt.org>
 <1316028267-34187-2-git-send-email-nbd@openwrt.org>
 <1316028267-34187-3-git-send-email-nbd@openwrt.org>
 <1316028267-34187-4-git-send-email-nbd@openwrt.org>
 <1316028267-34187-5-git-send-email-nbd@openwrt.org>
 <1316028267-34187-6-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

With the new API, tx descriptors can be written in one single pass
instead of having to re-read and rewrite fields from multiple places.
This makes the code easier to read and also slightly improves performance
on embedded MIPS hardware.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ath9k.h  |    1 -
 drivers/net/wireless/ath/ath9k/beacon.c |   52 +++----
 drivers/net/wireless/ath/ath9k/xmit.c   |  229 +++++++++++++-----------------
 3 files changed, 122 insertions(+), 160 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 9a10ab1..7cdb44c 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -228,7 +228,6 @@ struct ath_buf {
 	dma_addr_t bf_daddr;		/* physical addr of desc */
 	dma_addr_t bf_buf_addr;	/* physical addr of data buffer, for DMA */
 	bool bf_stale;
-	u16 bf_flags;
 	struct ath_buf_state bf_state;
 };
 
diff --git a/drivers/net/wireless/ath/ath9k/beacon.c b/drivers/net/wireless/ath/ath9k/beacon.c
index b97d01d..9cdeaeb 100644
--- a/drivers/net/wireless/ath/ath9k/beacon.c
+++ b/drivers/net/wireless/ath/ath9k/beacon.c
@@ -73,45 +73,39 @@ static void ath_beacon_setup(struct ath_softc *sc, struct ath_vif *avp,
 	struct sk_buff *skb = bf->bf_mpdu;
 	struct ath_hw *ah = sc->sc_ah;
 	struct ath_common *common = ath9k_hw_common(ah);
-	struct ath_desc *ds;
-	struct ath9k_11n_rate_series series[4];
-	int flags, ctsrate = 0, ctsduration = 0;
+	struct ath_tx_info info;
 	struct ieee80211_supported_band *sband;
+	u8 chainmask = ah->txchainmask;
 	u8 rate = 0;
 
 	ath9k_reset_beacon_status(sc);
 
-	ds = bf->bf_desc;
-	flags = ATH9K_TXDESC_NOACK;
-
-	ds->ds_link = 0;
-
 	sband = &sc->sbands[common->hw->conf.channel->band];
 	rate = sband->bitrates[rateidx].hw_value;
 	if (sc->sc_flags & SC_OP_PREAMBLE_SHORT)
 		rate |= sband->bitrates[rateidx].hw_value_short;
 
-	ath9k_hw_set11n_txdesc(ah, ds, skb->len + FCS_LEN,
-			       ATH9K_PKT_TYPE_BEACON,
-			       MAX_RATE_POWER,
-			       ATH9K_TXKEYIX_INVALID,
-			       ATH9K_KEY_TYPE_CLEAR,
-			       flags);
-
-	/* NB: beacon's BufLen must be a multiple of 4 bytes */
-	ath9k_hw_filltxdesc(ah, ds, roundup(skb->len, 4),
-			    true, true, ds, bf->bf_buf_addr,
-			    sc->beacon.beaconq);
-
-	memset(series, 0, sizeof(struct ath9k_11n_rate_series) * 4);
-	series[0].Tries = 1;
-	series[0].Rate = rate;
-	series[0].ChSel = ath_txchainmask_reduction(sc,
-			ah->txchainmask, series[0].Rate);
-	series[0].RateFlags = (ctsrate) ? ATH9K_RATESERIES_RTS_CTS : 0;
-	ath9k_hw_set11n_ratescenario(ah, ds, ds, 0, ctsrate, ctsduration,
-				     series, 4, 0);
-	ath9k_hw_set_desc_link(ah, ds, 0);
+	memset(&info, 0, sizeof(info));
+	info.pkt_len = skb->len + FCS_LEN;
+	info.type = ATH9K_PKT_TYPE_BEACON;
+	info.txpower = MAX_RATE_POWER;
+	info.keyix = ATH9K_TXKEYIX_INVALID;
+	info.keytype = ATH9K_KEY_TYPE_CLEAR;
+	info.flags = ATH9K_TXDESC_NOACK;
+
+	info.buf_addr[0] = bf->bf_buf_addr;
+	info.buf_len[0] = roundup(skb->len, 4);
+
+	info.is_first = true;
+	info.is_last = true;
+
+	info.qcu = sc->beacon.beaconq;
+
+	info.rates[0].Tries = 1;
+	info.rates[0].Rate = rate;
+	info.rates[0].ChSel = ath_txchainmask_reduction(sc, chainmask, rate);
+
+	ath9k_hw_set_txdesc(ah, bf->bf_desc, &info);
 }
 
 static void ath_tx_cabq(struct ieee80211_hw *hw, struct sk_buff *skb)
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 485c0a3..7f8191e 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -504,7 +504,6 @@ static void ath_tx_complete_aggr(struct ath_softc *sc, struct ath_txq *txq,
 				!txfail, sendbar);
 		} else {
 			/* retry the un-acked ones */
-			ath9k_hw_set_clrdmask(sc->sc_ah, bf->bf_desc, false);
 			if (!(sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_EDMA)) {
 				if (bf->bf_next == NULL && bf_last->bf_stale) {
 					struct ath_buf *tbf;
@@ -528,16 +527,7 @@ static void ath_tx_complete_aggr(struct ath_softc *sc, struct ath_txq *txq,
 						break;
 					}
 
-					ath9k_hw_cleartxdesc(sc->sc_ah,
-							     tbf->bf_desc);
 					fi->bf = tbf;
-				} else {
-					/*
-					 * Clear descriptor status words for
-					 * software retry
-					 */
-					ath9k_hw_cleartxdesc(sc->sc_ah,
-							     bf->bf_desc);
 				}
 			}
 
@@ -873,26 +863,25 @@ static u32 ath_pkt_duration(struct ath_softc *sc, u8 rix, int pktlen,
 	return duration;
 }
 
-static void ath_buf_set_rate(struct ath_softc *sc, struct ath_buf *bf, int len)
+static void ath_buf_set_rate(struct ath_softc *sc, struct ath_buf *bf,
+			     struct ath_tx_info *info, int len)
 {
 	struct ath_hw *ah = sc->sc_ah;
-	struct ath9k_11n_rate_series series[4];
 	struct sk_buff *skb;
 	struct ieee80211_tx_info *tx_info;
 	struct ieee80211_tx_rate *rates;
 	const struct ieee80211_rate *rate;
 	struct ieee80211_hdr *hdr;
-	int i, flags = 0;
-	u8 rix = 0, ctsrate = 0;
-	bool is_pspoll;
-
-	memset(series, 0, sizeof(struct ath9k_11n_rate_series) * 4);
+	int i;
+	u8 rix = 0;
 
 	skb = bf->bf_mpdu;
 	tx_info = IEEE80211_SKB_CB(skb);
 	rates = tx_info->control.rates;
 	hdr = (struct ieee80211_hdr *)skb->data;
-	is_pspoll = ieee80211_is_pspoll(hdr->frame_control);
+
+	/* set dur_update_en for l-sig computation except for PS-Poll frames */
+	info->dur_update = !ieee80211_is_pspoll(hdr->frame_control);
 
 	/*
 	 * We check if Short Preamble is needed for the CTS rate by
@@ -900,9 +889,9 @@ static void ath_buf_set_rate(struct ath_softc *sc, struct ath_buf *bf, int len)
 	 * But for the rate series, IEEE80211_TX_RC_USE_SHORT_PREAMBLE is used.
 	 */
 	rate = ieee80211_get_rts_cts_rate(sc->hw, tx_info);
-	ctsrate = rate->hw_value;
+	info->rtscts_rate = rate->hw_value;
 	if (sc->sc_flags & SC_OP_PREAMBLE_SHORT)
-		ctsrate |= rate->hw_value_short;
+		info->rtscts_rate |= rate->hw_value_short;
 
 	for (i = 0; i < 4; i++) {
 		bool is_40, is_sgi, is_sp;
@@ -912,20 +901,20 @@ static void ath_buf_set_rate(struct ath_softc *sc, struct ath_buf *bf, int len)
 			continue;
 
 		rix = rates[i].idx;
-		series[i].Tries = rates[i].count;
+		info->rates[i].Tries = rates[i].count;
 
 		    if (rates[i].flags & IEEE80211_TX_RC_USE_RTS_CTS) {
-			series[i].RateFlags |= ATH9K_RATESERIES_RTS_CTS;
-			flags |= ATH9K_TXDESC_RTSENA;
+			info->rates[i].RateFlags |= ATH9K_RATESERIES_RTS_CTS;
+			info->flags |= ATH9K_TXDESC_RTSENA;
 		} else if (rates[i].flags & IEEE80211_TX_RC_USE_CTS_PROTECT) {
-			series[i].RateFlags |= ATH9K_RATESERIES_RTS_CTS;
-			flags |= ATH9K_TXDESC_CTSENA;
+			info->rates[i].RateFlags |= ATH9K_RATESERIES_RTS_CTS;
+			info->flags |= ATH9K_TXDESC_CTSENA;
 		}
 
 		if (rates[i].flags & IEEE80211_TX_RC_40_MHZ_WIDTH)
-			series[i].RateFlags |= ATH9K_RATESERIES_2040;
+			info->rates[i].RateFlags |= ATH9K_RATESERIES_2040;
 		if (rates[i].flags & IEEE80211_TX_RC_SHORT_GI)
-			series[i].RateFlags |= ATH9K_RATESERIES_HALFGI;
+			info->rates[i].RateFlags |= ATH9K_RATESERIES_HALFGI;
 
 		is_sgi = !!(rates[i].flags & IEEE80211_TX_RC_SHORT_GI);
 		is_40 = !!(rates[i].flags & IEEE80211_TX_RC_40_MHZ_WIDTH);
@@ -933,13 +922,13 @@ static void ath_buf_set_rate(struct ath_softc *sc, struct ath_buf *bf, int len)
 
 		if (rates[i].flags & IEEE80211_TX_RC_MCS) {
 			/* MCS rates */
-			series[i].Rate = rix | 0x80;
-			series[i].ChSel = ath_txchainmask_reduction(sc,
-					ah->txchainmask, series[i].Rate);
-			series[i].PktDuration = ath_pkt_duration(sc, rix, len,
+			info->rates[i].Rate = rix | 0x80;
+			info->rates[i].ChSel = ath_txchainmask_reduction(sc,
+					ah->txchainmask, info->rates[i].Rate);
+			info->rates[i].PktDuration = ath_pkt_duration(sc, rix, len,
 				 is_40, is_sgi, is_sp);
 			if (rix < 8 && (tx_info->flags & IEEE80211_TX_CTL_STBC))
-				series[i].RateFlags |= ATH9K_RATESERIES_STBC;
+				info->rates[i].RateFlags |= ATH9K_RATESERIES_STBC;
 			continue;
 		}
 
@@ -951,74 +940,115 @@ static void ath_buf_set_rate(struct ath_softc *sc, struct ath_buf *bf, int len)
 			phy = WLAN_RC_PHY_OFDM;
 
 		rate = &sc->sbands[tx_info->band].bitrates[rates[i].idx];
-		series[i].Rate = rate->hw_value;
+		info->rates[i].Rate = rate->hw_value;
 		if (rate->hw_value_short) {
 			if (rates[i].flags & IEEE80211_TX_RC_USE_SHORT_PREAMBLE)
-				series[i].Rate |= rate->hw_value_short;
+				info->rates[i].Rate |= rate->hw_value_short;
 		} else {
 			is_sp = false;
 		}
 
 		if (bf->bf_state.bfs_paprd)
-			series[i].ChSel = ah->txchainmask;
+			info->rates[i].ChSel = ah->txchainmask;
 		else
-			series[i].ChSel = ath_txchainmask_reduction(sc,
-					ah->txchainmask, series[i].Rate);
+			info->rates[i].ChSel = ath_txchainmask_reduction(sc,
+					ah->txchainmask, info->rates[i].Rate);
 
-		series[i].PktDuration = ath9k_hw_computetxtime(sc->sc_ah,
+		info->rates[i].PktDuration = ath9k_hw_computetxtime(sc->sc_ah,
 			phy, rate->bitrate * 100, len, rix, is_sp);
 	}
 
 	/* For AR5416 - RTS cannot be followed by a frame larger than 8K */
 	if (bf_isaggr(bf) && (len > sc->sc_ah->caps.rts_aggr_limit))
-		flags &= ~ATH9K_TXDESC_RTSENA;
+		info->flags &= ~ATH9K_TXDESC_RTSENA;
 
 	/* ATH9K_TXDESC_RTSENA and ATH9K_TXDESC_CTSENA are mutually exclusive. */
-	if (flags & ATH9K_TXDESC_RTSENA)
-		flags &= ~ATH9K_TXDESC_CTSENA;
+	if (info->flags & ATH9K_TXDESC_RTSENA)
+		info->flags &= ~ATH9K_TXDESC_CTSENA;
+}
 
-	/* set dur_update_en for l-sig computation except for PS-Poll frames */
-	ath9k_hw_set11n_ratescenario(sc->sc_ah, bf->bf_desc,
-				     bf->bf_lastbf->bf_desc,
-				     !is_pspoll, ctsrate,
-				     0, series, 4, flags);
+static enum ath9k_pkt_type get_hw_packet_type(struct sk_buff *skb)
+{
+	struct ieee80211_hdr *hdr;
+	enum ath9k_pkt_type htype;
+	__le16 fc;
+
+	hdr = (struct ieee80211_hdr *)skb->data;
+	fc = hdr->frame_control;
+
+	if (ieee80211_is_beacon(fc))
+		htype = ATH9K_PKT_TYPE_BEACON;
+	else if (ieee80211_is_probe_resp(fc))
+		htype = ATH9K_PKT_TYPE_PROBE_RESP;
+	else if (ieee80211_is_atim(fc))
+		htype = ATH9K_PKT_TYPE_ATIM;
+	else if (ieee80211_is_pspoll(fc))
+		htype = ATH9K_PKT_TYPE_PSPOLL;
+	else
+		htype = ATH9K_PKT_TYPE_NORMAL;
 
+	return htype;
 }
 
-static void ath_tx_fill_desc(struct ath_softc *sc, struct ath_buf *bf, int len)
+static void ath_tx_fill_desc(struct ath_softc *sc, struct ath_buf *bf,
+			     struct ath_txq *txq, int len)
 {
 	struct ath_hw *ah = sc->sc_ah;
 	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(bf->bf_mpdu);
 	struct ath_buf *bf_first = bf;
-
+	struct ath_tx_info info;
 	bool aggr = !!(bf->bf_state.bf_type & BUF_AGGR);
-	bool clrdmask = !!(tx_info->flags & IEEE80211_TX_CTL_CLEAR_PS_FILT);
 
-	u32 ds_next;
+	memset(&info, 0, sizeof(info));
+	info.is_first = true;
+	info.is_last = true;
+	info.txpower = MAX_RATE_POWER;
+	info.qcu = txq->axq_qnum;
+
+	info.flags = ATH9K_TXDESC_INTREQ;
+	if (tx_info->flags & IEEE80211_TX_CTL_NO_ACK)
+		info.flags |= ATH9K_TXDESC_NOACK;
+	if (tx_info->flags & IEEE80211_TX_CTL_LDPC)
+		info.flags |= ATH9K_TXDESC_LDPC;
+
+	ath_buf_set_rate(sc, bf, &info, len);
+
+	if (tx_info->flags & IEEE80211_TX_CTL_CLEAR_PS_FILT)
+		info.flags |= ATH9K_TXDESC_CLRDMASK;
+
+	if (bf->bf_state.bfs_paprd)
+		info.flags |= (u32) bf->bf_state.bfs_paprd << ATH9K_TXDESC_PAPRD_S;
 
-	ath_buf_set_rate(sc, bf, len);
 
 	while (bf) {
+		struct sk_buff *skb = bf->bf_mpdu;
+		struct ath_frame_info *fi = get_frame_info(skb);
+
+		info.type = get_hw_packet_type(skb);
 		if (bf->bf_next)
-			ds_next = bf->bf_next->bf_daddr;
+			info.link = bf->bf_next->bf_daddr;
 		else
-			ds_next = 0;
-
-		ath9k_hw_set_clrdmask(sc->sc_ah, bf->bf_desc, clrdmask);
-		if (!aggr)
-			ath9k_hw_clr11n_aggr(sc->sc_ah, bf->bf_desc);
-		else if (!bf->bf_next)
-			ath9k_hw_set11n_aggr_last(sc->sc_ah, bf->bf_desc);
-		else {
+			info.link = 0;
+
+		info.buf_addr[0] = bf->bf_buf_addr;
+		info.buf_len[0] = skb->len;
+		info.pkt_len = fi->framelen;
+		info.keyix = fi->keyix;
+		info.keytype = fi->keytype;
+
+		if (aggr) {
 			if (bf == bf_first)
-				ath9k_hw_set11n_aggr_first(sc->sc_ah,
-					bf->bf_desc, len);
+				info.aggr = AGGR_BUF_FIRST;
+			else if (!bf->bf_next)
+				info.aggr = AGGR_BUF_LAST;
+			else
+				info.aggr = AGGR_BUF_MIDDLE;
 
-			ath9k_hw_set11n_aggr_middle(sc->sc_ah, bf->bf_desc,
-				bf->bf_state.ndelim);
+			info.ndelim = bf->bf_state.ndelim;
+			info.aggr_len = len;
 		}
 
-		ath9k_hw_set_desc_link(ah, bf->bf_desc, ds_next);
+		ath9k_hw_set_txdesc(ah, bf->bf_desc, &info);
 		bf = bf->bf_next;
 	}
 }
@@ -1066,7 +1096,7 @@ static void ath_tx_sched_aggr(struct ath_softc *sc, struct ath_txq *txq,
 			TX_STAT_INC(txq->axq_qnum, a_aggr);
 		}
 
-		ath_tx_fill_desc(sc, bf, aggr_len);
+		ath_tx_fill_desc(sc, bf, txq, aggr_len);
 		ath_tx_txqaddbuf(sc, txq, &bf_q, false);
 	} while (txq->axq_ampdu_depth < ATH_AGGR_MIN_QDEPTH &&
 		 status != ATH_AGGR_BAW_CLOSED);
@@ -1655,7 +1685,7 @@ static void ath_tx_send_ampdu(struct ath_softc *sc, struct ath_atx_tid *tid,
 	/* Queue to h/w without aggregation */
 	TX_STAT_INC(txctl->txq->axq_qnum, a_queued_hw);
 	bf->bf_lastbf = bf;
-	ath_tx_fill_desc(sc, bf, fi->framelen);
+	ath_tx_fill_desc(sc, bf, txctl->txq, fi->framelen);
 	ath_tx_txqaddbuf(sc, txctl->txq, &bf_head, false);
 }
 
@@ -1682,34 +1712,11 @@ static void ath_tx_send_normal(struct ath_softc *sc, struct ath_txq *txq,
 		INCR(tid->seq_start, IEEE80211_SEQ_MAX);
 
 	bf->bf_lastbf = bf;
-	ath_tx_fill_desc(sc, bf, fi->framelen);
+	ath_tx_fill_desc(sc, bf, txq, fi->framelen);
 	ath_tx_txqaddbuf(sc, txq, &bf_head, false);
 	TX_STAT_INC(txq->axq_qnum, queued);
 }
 
-static enum ath9k_pkt_type get_hw_packet_type(struct sk_buff *skb)
-{
-	struct ieee80211_hdr *hdr;
-	enum ath9k_pkt_type htype;
-	__le16 fc;
-
-	hdr = (struct ieee80211_hdr *)skb->data;
-	fc = hdr->frame_control;
-
-	if (ieee80211_is_beacon(fc))
-		htype = ATH9K_PKT_TYPE_BEACON;
-	else if (ieee80211_is_probe_resp(fc))
-		htype = ATH9K_PKT_TYPE_PROBE_RESP;
-	else if (ieee80211_is_atim(fc))
-		htype = ATH9K_PKT_TYPE_ATIM;
-	else if (ieee80211_is_pspoll(fc))
-		htype = ATH9K_PKT_TYPE_PSPOLL;
-	else
-		htype = ATH9K_PKT_TYPE_NORMAL;
-
-	return htype;
-}
-
 static void setup_frame_info(struct ieee80211_hw *hw, struct sk_buff *skb,
 			     int framelen)
 {
@@ -1737,22 +1744,6 @@ static void setup_frame_info(struct ieee80211_hw *hw, struct sk_buff *skb,
 	fi->framelen = framelen;
 }
 
-static int setup_tx_flags(struct sk_buff *skb)
-{
-	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(skb);
-	int flags = 0;
-
-	flags |= ATH9K_TXDESC_INTREQ;
-
-	if (tx_info->flags & IEEE80211_TX_CTL_NO_ACK)
-		flags |= ATH9K_TXDESC_NOACK;
-
-	if (tx_info->flags & IEEE80211_TX_CTL_LDPC)
-		flags |= ATH9K_TXDESC_LDPC;
-
-	return flags;
-}
-
 u8 ath_txchainmask_reduction(struct ath_softc *sc, u8 chainmask, u32 rate)
 {
 	struct ath_hw *ah = sc->sc_ah;
@@ -1774,13 +1765,10 @@ static struct ath_buf *ath_tx_setup_buffer(struct ath_softc *sc,
 					   struct ath_atx_tid *tid,
 					   struct sk_buff *skb)
 {
-	struct ath_hw *ah = sc->sc_ah;
 	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
 	struct ath_frame_info *fi = get_frame_info(skb);
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
 	struct ath_buf *bf;
-	struct ath_desc *ds;
-	int frm_type;
 	u16 seqno;
 
 	bf = ath_tx_get_buffer(sc);
@@ -1798,7 +1786,6 @@ static struct ath_buf *ath_tx_setup_buffer(struct ath_softc *sc,
 		bf->bf_state.seqno = seqno;
 	}
 
-	bf->bf_flags = setup_tx_flags(skb);
 	bf->bf_mpdu = skb;
 
 	bf->bf_buf_addr = dma_map_single(sc->dev, skb->data,
@@ -1812,20 +1799,6 @@ static struct ath_buf *ath_tx_setup_buffer(struct ath_softc *sc,
 		goto error;
 	}
 
-	frm_type = get_hw_packet_type(skb);
-
-	ds = bf->bf_desc;
-	ath9k_hw_set11n_txdesc(ah, ds, fi->framelen, frm_type, MAX_RATE_POWER,
-			       fi->keyix, fi->keytype, bf->bf_flags);
-
-	ath9k_hw_filltxdesc(ah, ds,
-			    skb->len,	/* segment length */
-			    true,	/* first segment */
-			    true,	/* last segment */
-			    ds,		/* first descriptor */
-			    bf->bf_buf_addr,
-			    txq->axq_qnum);
-
 	fi->bf = bf;
 
 	return bf;
@@ -1868,10 +1841,6 @@ static void ath_tx_start_dma(struct ath_softc *sc, struct sk_buff *skb,
 
 		bf->bf_state.bfs_paprd = txctl->paprd;
 
-		if (bf->bf_state.bfs_paprd)
-			ar9003_hw_set_paprd_txdesc(sc->sc_ah, bf->bf_desc,
-						   bf->bf_state.bfs_paprd);
-
 		if (txctl->paprd)
 			bf->bf_state.bfs_paprd_timestamp = jiffies;
 
@@ -2080,7 +2049,7 @@ static void ath_tx_rc_status(struct ath_softc *sc, struct ath_buf *bf,
 	}
 
 	if ((ts->ts_status & ATH9K_TXERR_FILT) == 0 &&
-	    (bf->bf_flags & ATH9K_TXDESC_NOACK) == 0 && update_rc) {
+	    (tx_info->flags & IEEE80211_TX_CTL_NO_ACK) == 0 && update_rc) {
 		/*
 		 * If an underrun error is seen assume it as an excessive
 		 * retry only if max frame trigger level has been reached
-- 
1.7.3.2

