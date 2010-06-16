Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30s.wh2.ocn.ne.jp ([125.206.180.198]:15311 "HELO
	mail30s.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756163Ab0FPKLk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Jun 2010 06:11:40 -0400
Received: from vs3015.wh2.ocn.ne.jp (125.206.180.247)
	by mail30s.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 2-0855383098
	for <linux-wireless@vger.kernel.org>; Wed, 16 Jun 2010 19:11:38 +0900 (JST)
Subject: [PATCH 02/17] ath5k: rename ath5k_txbuf_free() to
	ath5k_txbuf_free_skb()
To: linville@tuxdriver.com
From: Bruno Randolf <br1@einfach.org>
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Date: Wed, 16 Jun 2010 19:11:17 +0900
Message-ID: <20100616101117.10067.527.stgit@tt-desk>
In-Reply-To: <20100616100809.10067.34787.stgit@tt-desk>
References: <20100616100809.10067.34787.stgit@tt-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rename ath5k_txbuf_free() to ath5k_txbuf_free_skb() since this is what it does:
it frees the skb and not the buf. Same for ath5k_rxbuf_free().

Signed-off-by: Bruno Randolf <br1@einfach.org>
Acked-by: Bob Copeland <me@bobcopeland.com>
---
 drivers/net/wireless/ath/ath5k/base.c |   17 +++++++++--------
 1 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index 936afd7..8e6b54d 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -311,7 +311,8 @@ static int 	ath5k_rxbuf_setup(struct ath5k_softc *sc,
 static int 	ath5k_txbuf_setup(struct ath5k_softc *sc,
 				struct ath5k_buf *bf,
 				struct ath5k_txq *txq, int padsize);
-static inline void ath5k_txbuf_free(struct ath5k_softc *sc,
+
+static inline void ath5k_txbuf_free_skb(struct ath5k_softc *sc,
 				struct ath5k_buf *bf)
 {
 	BUG_ON(!bf);
@@ -323,7 +324,7 @@ static inline void ath5k_txbuf_free(struct ath5k_softc *sc,
 	bf->skb = NULL;
 }
 
-static inline void ath5k_rxbuf_free(struct ath5k_softc *sc,
+static inline void ath5k_rxbuf_free_skb(struct ath5k_softc *sc,
 				struct ath5k_buf *bf)
 {
 	struct ath5k_hw *ah = sc->ah;
@@ -1444,11 +1445,11 @@ ath5k_desc_free(struct ath5k_softc *sc, struct pci_dev *pdev)
 {
 	struct ath5k_buf *bf;
 
-	ath5k_txbuf_free(sc, sc->bbuf);
+	ath5k_txbuf_free_skb(sc, sc->bbuf);
 	list_for_each_entry(bf, &sc->txbuf, list)
-		ath5k_txbuf_free(sc, bf);
+		ath5k_txbuf_free_skb(sc, bf);
 	list_for_each_entry(bf, &sc->rxbuf, list)
-		ath5k_rxbuf_free(sc, bf);
+		ath5k_rxbuf_free_skb(sc, bf);
 
 	/* Free memory associated with all descriptors */
 	pci_free_consistent(pdev, sc->desc_len, sc->desc, sc->desc_daddr);
@@ -1603,7 +1604,7 @@ ath5k_txq_drainq(struct ath5k_softc *sc, struct ath5k_txq *txq)
 	list_for_each_entry_safe(bf, bf0, &txq->q, list) {
 		ath5k_debug_printtxbuf(sc, bf);
 
-		ath5k_txbuf_free(sc, bf);
+		ath5k_txbuf_free_skb(sc, bf);
 
 		spin_lock_bh(&sc->txbuflock);
 		list_move_tail(&bf->list, &sc->txbuf);
@@ -2650,7 +2651,7 @@ ath5k_stop_hw(struct ath5k_softc *sc)
 		ATH5K_DBG(sc, ATH5K_DEBUG_RESET,
 				"putting device to sleep\n");
 	}
-	ath5k_txbuf_free(sc, sc->bbuf);
+	ath5k_txbuf_free_skb(sc, sc->bbuf);
 
 	mmiowb();
 	mutex_unlock(&sc->lock);
@@ -3376,7 +3377,7 @@ ath5k_beacon_update(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 
 	ath5k_debug_dump_skb(sc, skb, "BC  ", 1);
 
-	ath5k_txbuf_free(sc, sc->bbuf);
+	ath5k_txbuf_free_skb(sc, sc->bbuf);
 	sc->bbuf->skb = skb;
 	ret = ath5k_beacon_setup(sc, sc->bbuf);
 	if (ret)

