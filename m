Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:54655 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750805Ab2JCTIE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Oct 2012 15:08:04 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, mcgrof@qca.qualcomm.com,
	stable@vger.kernel.org
Subject: [PATCH 3.7 3/3] ath9k: use ieee80211_free_txskb
Date: Wed,  3 Oct 2012 21:07:52 +0200
Message-Id: <1349291272-93080-3-git-send-email-nbd@openwrt.org> (sfid-20121003_210811_068327_EE4F9503)
In-Reply-To: <1349291272-93080-2-git-send-email-nbd@openwrt.org>
References: <1349291272-93080-1-git-send-email-nbd@openwrt.org>
 <1349291272-93080-2-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Using ieee80211_free_txskb for tx frames is required, since mac80211 clones
skbs for which socket tx status is requested.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Cc: stable@vger.kernel.org
---
 drivers/net/wireless/ath/ath9k/beacon.c |    2 +-
 drivers/net/wireless/ath/ath9k/main.c   |    2 +-
 drivers/net/wireless/ath/ath9k/xmit.c   |   53 +++++++++++++++++--------------
 3 files changed, 31 insertions(+), 26 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/beacon.c b/drivers/net/wireless/ath/ath9k/beacon.c
index 76f07d8..1b48414 100644
--- a/drivers/net/wireless/ath/ath9k/beacon.c
+++ b/drivers/net/wireless/ath/ath9k/beacon.c
@@ -120,7 +120,7 @@ static void ath9k_tx_cabq(struct ieee80211_hw *hw, struct sk_buff *skb)
 
 	if (ath_tx_start(hw, skb, &txctl) != 0) {
 		ath_dbg(common, XMIT, "CABQ TX failed\n");
-		dev_kfree_skb_any(skb);
+		ieee80211_free_txskb(hw, skb);
 	}
 }
 
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index e2fe713..dd45edf 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -765,7 +765,7 @@ static void ath9k_tx(struct ieee80211_hw *hw,
 
 	return;
 exit:
-	dev_kfree_skb_any(skb);
+	ieee80211_free_txskb(hw, skb);
 }
 
 static void ath9k_stop(struct ieee80211_hw *hw)
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 36618e3..378bd70 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -66,8 +66,7 @@ static void ath_tx_update_baw(struct ath_softc *sc, struct ath_atx_tid *tid,
 static struct ath_buf *ath_tx_setup_buffer(struct ath_softc *sc,
 					   struct ath_txq *txq,
 					   struct ath_atx_tid *tid,
-					   struct sk_buff *skb,
-					   bool dequeue);
+					   struct sk_buff *skb);
 
 enum {
 	MCS_HT20,
@@ -176,7 +175,15 @@ static void ath_tx_flush_tid(struct ath_softc *sc, struct ath_atx_tid *tid)
 		fi = get_frame_info(skb);
 		bf = fi->bf;
 
-		if (bf && fi->retries) {
+		if (!bf) {
+			bf = ath_tx_setup_buffer(sc, txq, tid, skb);
+			if (!bf) {
+				ieee80211_free_txskb(sc->hw, skb);
+				continue;
+			}
+		}
+
+		if (fi->retries) {
 			list_add_tail(&bf->list, &bf_head);
 			ath_tx_update_baw(sc, tid, bf->bf_state.seqno);
 			ath_tx_complete_buf(sc, bf, txq, &bf_head, &ts, 0);
@@ -785,10 +792,13 @@ static enum ATH_AGGR_STATUS ath_tx_form_aggr(struct ath_softc *sc,
 		fi = get_frame_info(skb);
 		bf = fi->bf;
 		if (!fi->bf)
-			bf = ath_tx_setup_buffer(sc, txq, tid, skb, true);
+			bf = ath_tx_setup_buffer(sc, txq, tid, skb);
 
-		if (!bf)
+		if (!bf) {
+			__skb_unlink(skb, &tid->buf_q);
+			ieee80211_free_txskb(sc->hw, skb);
 			continue;
+		}
 
 		bf->bf_state.bf_type = BUF_AMPDU | BUF_AGGR;
 		seqno = bf->bf_state.seqno;
@@ -1731,9 +1741,11 @@ static void ath_tx_send_ampdu(struct ath_softc *sc, struct ath_atx_tid *tid,
 		return;
 	}
 
-	bf = ath_tx_setup_buffer(sc, txctl->txq, tid, skb, false);
-	if (!bf)
+	bf = ath_tx_setup_buffer(sc, txctl->txq, tid, skb);
+	if (!bf) {
+		ieee80211_free_txskb(sc->hw, skb);
 		return;
+	}
 
 	bf->bf_state.bf_type = BUF_AMPDU;
 	INIT_LIST_HEAD(&bf_head);
@@ -1757,11 +1769,6 @@ static void ath_tx_send_normal(struct ath_softc *sc, struct ath_txq *txq,
 	struct ath_buf *bf;
 
 	bf = fi->bf;
-	if (!bf)
-		bf = ath_tx_setup_buffer(sc, txq, tid, skb, false);
-
-	if (!bf)
-		return;
 
 	INIT_LIST_HEAD(&bf_head);
 	list_add_tail(&bf->list, &bf_head);
@@ -1839,8 +1846,7 @@ u8 ath_txchainmask_reduction(struct ath_softc *sc, u8 chainmask, u32 rate)
 static struct ath_buf *ath_tx_setup_buffer(struct ath_softc *sc,
 					   struct ath_txq *txq,
 					   struct ath_atx_tid *tid,
-					   struct sk_buff *skb,
-					   bool dequeue)
+					   struct sk_buff *skb)
 {
 	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
 	struct ath_frame_info *fi = get_frame_info(skb);
@@ -1852,7 +1858,7 @@ static struct ath_buf *ath_tx_setup_buffer(struct ath_softc *sc,
 	bf = ath_tx_get_buffer(sc);
 	if (!bf) {
 		ath_dbg(common, XMIT, "TX buffers are full\n");
-		goto error;
+		return NULL;
 	}
 
 	ATH_TXBUF_RESET(bf);
@@ -1881,18 +1887,12 @@ static struct ath_buf *ath_tx_setup_buffer(struct ath_softc *sc,
 		ath_err(ath9k_hw_common(sc->sc_ah),
 			"dma_mapping_error() on TX\n");
 		ath_tx_return_buffer(sc, bf);
-		goto error;
+		return NULL;
 	}
 
 	fi->bf = bf;
 
 	return bf;
-
-error:
-	if (dequeue)
-		__skb_unlink(skb, &tid->buf_q);
-	dev_kfree_skb_any(skb);
-	return NULL;
 }
 
 /* FIXME: tx power */
@@ -1921,9 +1921,14 @@ static void ath_tx_start_dma(struct ath_softc *sc, struct sk_buff *skb,
 		 */
 		ath_tx_send_ampdu(sc, tid, skb, txctl);
 	} else {
-		bf = ath_tx_setup_buffer(sc, txctl->txq, tid, skb, false);
-		if (!bf)
+		bf = ath_tx_setup_buffer(sc, txctl->txq, tid, skb);
+		if (!bf) {
+			if (txctl->paprd)
+				dev_kfree_skb_any(skb);
+			else
+				ieee80211_free_txskb(sc->hw, skb);
 			return;
+		}
 
 		bf->bf_state.bfs_paprd = txctl->paprd;
 
-- 
1.7.9.6 (Apple Git-31.1)

