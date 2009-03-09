Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:37829 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750953AbZCIEGC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Mar 2009 00:06:02 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Sun, 08 Mar 2009 21:06:01 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18868.38069.799625.565603@gargle.gargle.HOWL> (sfid-20090309_050613_800994_90A0DFFB)
Date: Mon, 9 Mar 2009 09:31:57 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Jouni.Malinen@Atheros.com>,
	<Luis.Rodriguez@Atheros.com>
Subject: [PATCH 2/3] ath9k: Fix bug in TX aggregation
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

mac80211 expects the driver to fill in the starting
sequence number of an ADDBA request to initiate TX aggregation.
IEEE80211_TX_CTL_AMPDU would be set for frames only after a
successful ADDBA exchange, but we have to increment the
internal sequence counter for the normal(non-AMPDU) data frames proerly.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath9k/xmit.c |   49 +++++++++++++++++++++++++------------
 1 files changed, 33 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/ath9k/xmit.c b/drivers/net/wireless/ath9k/xmit.c
index a82d2ab..f61ba2b 100644
--- a/drivers/net/wireless/ath9k/xmit.c
+++ b/drivers/net/wireless/ath9k/xmit.c
@@ -55,9 +55,9 @@ static u32 bits_per_symbol[][2] = {
 
 #define IS_HT_RATE(_rate)     ((_rate) & 0x80)
 
-static void ath_tx_send_normal(struct ath_softc *sc, struct ath_txq *txq,
-			       struct ath_atx_tid *tid,
-			       struct list_head *bf_head);
+static void ath_tx_send_ht_normal(struct ath_softc *sc, struct ath_txq *txq,
+				  struct ath_atx_tid *tid,
+				  struct list_head *bf_head);
 static void ath_tx_complete_buf(struct ath_softc *sc, struct ath_buf *bf,
 				struct list_head *bf_q,
 				int txok, int sendbar);
@@ -152,7 +152,7 @@ static void ath_tx_flush_tid(struct ath_softc *sc, struct ath_atx_tid *tid)
 		bf = list_first_entry(&tid->buf_q, struct ath_buf, list);
 		ASSERT(!bf_isretried(bf));
 		list_move_tail(&bf->list, &bf_head);
-		ath_tx_send_normal(sc, txq, tid, &bf_head);
+		ath_tx_send_ht_normal(sc, txq, tid, &bf_head);
 	}
 
 	spin_unlock_bh(&txq->axq_lock);
@@ -1238,9 +1238,9 @@ static void ath_tx_send_ampdu(struct ath_softc *sc, struct ath_atx_tid *tid,
 	ath_tx_txqaddbuf(sc, txctl->txq, bf_head);
 }
 
-static void ath_tx_send_normal(struct ath_softc *sc, struct ath_txq *txq,
-			       struct ath_atx_tid *tid,
-			       struct list_head *bf_head)
+static void ath_tx_send_ht_normal(struct ath_softc *sc, struct ath_txq *txq,
+				  struct ath_atx_tid *tid,
+				  struct list_head *bf_head)
 {
 	struct ath_buf *bf;
 
@@ -1256,6 +1256,19 @@ static void ath_tx_send_normal(struct ath_softc *sc, struct ath_txq *txq,
 	ath_tx_txqaddbuf(sc, txq, bf_head);
 }
 
+static void ath_tx_send_normal(struct ath_softc *sc, struct ath_txq *txq,
+			       struct list_head *bf_head)
+{
+	struct ath_buf *bf;
+
+	bf = list_first_entry(bf_head, struct ath_buf, list);
+
+	bf->bf_lastbf = bf;
+	bf->bf_nframes = 1;
+	ath_buf_set_rate(sc, bf);
+	ath_tx_txqaddbuf(sc, txq, bf_head);
+}
+
 static enum ath9k_pkt_type get_hw_packet_type(struct sk_buff *skb)
 {
 	struct ieee80211_hdr *hdr;
@@ -1522,8 +1535,7 @@ static int ath_tx_setup_buffer(struct ieee80211_hw *hw, struct ath_buf *bf,
 
 	bf->bf_frmlen = skb->len + FCS_LEN - (hdrlen & 3);
 
-	if ((conf_is_ht(&sc->hw->conf) && !is_pae(skb) &&
-	     (tx_info->flags & IEEE80211_TX_CTL_AMPDU)))
+	if (conf_is_ht(&sc->hw->conf) && !is_pae(skb))
 		bf->bf_state.bf_type |= BUF_HT;
 
 	bf->bf_flags = setup_tx_flags(sc, skb, txctl->txq);
@@ -1560,14 +1572,17 @@ static void ath_tx_start_dma(struct ath_softc *sc, struct ath_buf *bf,
 {
 	struct sk_buff *skb = (struct sk_buff *)bf->bf_mpdu;
 	struct ieee80211_tx_info *tx_info =  IEEE80211_SKB_CB(skb);
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
 	struct ath_node *an = NULL;
 	struct list_head bf_head;
 	struct ath_desc *ds;
 	struct ath_atx_tid *tid;
 	struct ath_hw *ah = sc->sc_ah;
 	int frm_type;
+	__le16 fc;
 
 	frm_type = get_hw_packet_type(skb);
+	fc = hdr->frame_control;
 
 	INIT_LIST_HEAD(&bf_head);
 	list_add_tail(&bf->list, &bf_head);
@@ -1592,6 +1607,11 @@ static void ath_tx_start_dma(struct ath_softc *sc, struct ath_buf *bf,
 		an = (struct ath_node *)tx_info->control.sta->drv_priv;
 		tid = ATH_AN_2_TID(an, bf->bf_tidno);
 
+		if (!ieee80211_is_data_qos(fc)) {
+			ath_tx_send_normal(sc, txctl->txq, &bf_head);
+			goto tx_done;
+		}
+
 		if (ath_aggr_query(sc, an, bf->bf_tidno)) {
 			/*
 			 * Try aggregation if it's a unicast data frame
@@ -1603,17 +1623,14 @@ static void ath_tx_start_dma(struct ath_softc *sc, struct ath_buf *bf,
 			 * Send this frame as regular when ADDBA
 			 * exchange is neither complete nor pending.
 			 */
-			ath_tx_send_normal(sc, txctl->txq,
-					   tid, &bf_head);
+			ath_tx_send_ht_normal(sc, txctl->txq,
+					      tid, &bf_head);
 		}
 	} else {
-		bf->bf_lastbf = bf;
-		bf->bf_nframes = 1;
-
-		ath_buf_set_rate(sc, bf);
-		ath_tx_txqaddbuf(sc, txctl->txq, &bf_head);
+		ath_tx_send_normal(sc, txctl->txq, &bf_head);
 	}
 
+tx_done:
 	spin_unlock_bh(&txctl->txq->axq_lock);
 }
 
-- 
1.6.1

