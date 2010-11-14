Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:48056 "EHLO nbd.name"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755701Ab0KNOUW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Nov 2010 09:20:22 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, lrodriguez@atheros.com
Subject: [PATCH 02/13] ath9k: remove bfs_tidno from struct ath_buf_state
Date: Sun, 14 Nov 2010 15:20:02 +0100
Message-Id: <1289744413-20789-2-git-send-email-nbd@openwrt.org>
In-Reply-To: <1289744413-20789-1-git-send-email-nbd@openwrt.org>
References: <1289744413-20789-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ath9k.h |    2 --
 drivers/net/wireless/ath/ath9k/xmit.c  |   25 +++++++++++++------------
 2 files changed, 13 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 332c2c4..05fe1c1 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -105,7 +105,6 @@ enum buffer_type {
 #define bf_al           	bf_state.bfs_al
 #define bf_frmlen       	bf_state.bfs_frmlen
 #define bf_retries      	bf_state.bfs_retries
-#define bf_tidno        	bf_state.bfs_tidno
 #define bf_keyix                bf_state.bfs_keyix
 #define bf_keytype      	bf_state.bfs_keytype
 #define bf_isht(bf)		(bf->bf_state.bf_type & BUF_HT)
@@ -220,7 +219,6 @@ struct ath_buf_state {
 	int bfs_nframes;
 	u16 bfs_al;
 	u16 bfs_frmlen;
-	int bfs_tidno;
 	int bfs_retries;
 	u8 bf_type;
 	u8 bfs_paprd;
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index e84c9c2..c7097a5 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -323,6 +323,7 @@ static void ath_tx_complete_aggr(struct ath_softc *sc, struct ath_txq *txq,
 	struct ieee80211_tx_rate rates[4];
 	u16 bf_seqno;
 	int nframes;
+	u8 tidno;
 
 	skb = bf->bf_mpdu;
 	hdr = (struct ieee80211_hdr *)skb->data;
@@ -358,14 +359,15 @@ static void ath_tx_complete_aggr(struct ath_softc *sc, struct ath_txq *txq,
 	}
 
 	an = (struct ath_node *)sta->drv_priv;
-	tid = ATH_AN_2_TID(an, bf->bf_tidno);
+	tidno = ieee80211_get_qos_ctl(hdr)[0] & IEEE80211_QOS_CTL_TID_MASK;
+	tid = ATH_AN_2_TID(an, tidno);
 
 	/*
 	 * The hardware occasionally sends a tx status for the wrong TID.
 	 * In this case, the BA status cannot be considered valid and all
 	 * subframes need to be retransmitted
 	 */
-	if (bf->bf_tidno != ts->tid)
+	if (tidno != ts->tid)
 		txok = false;
 
 	isaggr = bf_isaggr(bf);
@@ -1386,7 +1388,7 @@ static void assign_aggr_tid_seqno(struct sk_buff *skb,
 	struct ath_node *an;
 	struct ath_atx_tid *tid;
 	__le16 fc;
-	u8 *qc;
+	u8 tidno;
 
 	if (!tx_info->control.sta)
 		return;
@@ -1394,18 +1396,13 @@ static void assign_aggr_tid_seqno(struct sk_buff *skb,
 	an = (struct ath_node *)tx_info->control.sta->drv_priv;
 	hdr = (struct ieee80211_hdr *)skb->data;
 	fc = hdr->frame_control;
-
-	if (ieee80211_is_data_qos(fc)) {
-		qc = ieee80211_get_qos_ctl(hdr);
-		bf->bf_tidno = qc[0] & 0xf;
-	}
+	tidno = ieee80211_get_qos_ctl(hdr)[0] & IEEE80211_QOS_CTL_TID_MASK;
 
 	/*
-	 * For HT capable stations, we save tidno for later use.
-	 * We also override seqno set by upper layer with the one
+	 * Override seqno set by upper layer with the one
 	 * in tx aggregation state.
 	 */
-	tid = ATH_AN_2_TID(an, bf->bf_tidno);
+	tid = ATH_AN_2_TID(an, tidno);
 	hdr->seq_ctrl = cpu_to_le16(tid->seq_next << IEEE80211_SEQ_SEQ_SHIFT);
 	INCR(tid->seq_next, IEEE80211_SEQ_MAX);
 }
@@ -1647,6 +1644,7 @@ static void ath_tx_start_dma(struct ath_softc *sc, struct ath_buf *bf,
 	struct ath_hw *ah = sc->sc_ah;
 	int frm_type;
 	__le16 fc;
+	u8 tidno;
 
 	frm_type = get_hw_packet_type(skb);
 	fc = hdr->frame_control;
@@ -1673,7 +1671,10 @@ static void ath_tx_start_dma(struct ath_softc *sc, struct ath_buf *bf,
 	if (bf_isht(bf) && (sc->sc_flags & SC_OP_TXAGGR) &&
 	    tx_info->control.sta) {
 		an = (struct ath_node *)tx_info->control.sta->drv_priv;
-		tid = ATH_AN_2_TID(an, bf->bf_tidno);
+		tidno = ieee80211_get_qos_ctl(hdr)[0] &
+			IEEE80211_QOS_CTL_TID_MASK;
+		tid = ATH_AN_2_TID(an, tidno);
+
 
 		WARN_ON(tid->ac->txq != txctl->txq);
 		if (tx_info->flags & IEEE80211_TX_CTL_AMPDU) {
-- 
1.7.3.2

