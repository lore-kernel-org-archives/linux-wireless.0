Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh06.mail.saunalahti.fi ([62.142.5.116]:45443 "EHLO
	emh06.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752495Ab0BGIVT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Feb 2010 03:21:19 -0500
Subject: [PATCH 04/10] ath5k: remove get_tx_stats() mac80211 op
To: linux-wireless@vger.kernel.org
From: Kalle Valo <kalle.valo@iki.fi>
Cc: Bob Copeland <me@bobcopeland.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Jiri Slaby <jirislaby@gmail.com>,
	Nick Kossifidis <mickflemm@gmail.com>
Date: Sun, 07 Feb 2010 10:21:07 +0200
Message-ID: <20100207082107.31474.55453.stgit@tikku>
In-Reply-To: <20100207082044.31474.48583.stgit@tikku>
References: <20100207082044.31474.48583.stgit@tikku>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

get_tx_stats() will be removed from mac80211.

Compile-tested only.

Cc: Jiri Slaby <jirislaby@gmail.com>
Cc: Nick Kossifidis <mickflemm@gmail.com>
Cc: Luis R. Rodriguez <lrodriguez@atheros.com>
Cc: Bob Copeland <me@bobcopeland.com>
Signed-off-by: Kalle Valo <kalle.valo@iki.fi>
---
 drivers/net/wireless/ath/ath5k/base.c |   18 ------------------
 drivers/net/wireless/ath/ath5k/base.h |    1 -
 2 files changed, 0 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index 535a6af..97d6425 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -241,8 +241,6 @@ static int ath5k_set_key(struct ieee80211_hw *hw,
 		struct ieee80211_key_conf *key);
 static int ath5k_get_stats(struct ieee80211_hw *hw,
 		struct ieee80211_low_level_stats *stats);
-static int ath5k_get_tx_stats(struct ieee80211_hw *hw,
-		struct ieee80211_tx_queue_stats *stats);
 static u64 ath5k_get_tsf(struct ieee80211_hw *hw);
 static void ath5k_set_tsf(struct ieee80211_hw *hw, u64 tsf);
 static void ath5k_reset_tsf(struct ieee80211_hw *hw);
@@ -269,7 +267,6 @@ static const struct ieee80211_ops ath5k_hw_ops = {
 	.set_key 	= ath5k_set_key,
 	.get_stats 	= ath5k_get_stats,
 	.conf_tx 	= NULL,
-	.get_tx_stats 	= ath5k_get_tx_stats,
 	.get_tsf 	= ath5k_get_tsf,
 	.set_tsf 	= ath5k_set_tsf,
 	.reset_tsf 	= ath5k_reset_tsf,
@@ -1332,7 +1329,6 @@ ath5k_txbuf_setup(struct ath5k_softc *sc, struct ath5k_buf *bf,
 
 	spin_lock_bh(&txq->lock);
 	list_add_tail(&bf->list, &txq->q);
-	sc->tx_stats[txq->qnum].len++;
 	if (txq->link == NULL) /* is this first packet? */
 		ath5k_hw_set_txdp(ah, txq->qnum, bf->daddr);
 	else /* no, so only link it */
@@ -1581,7 +1577,6 @@ ath5k_txq_drainq(struct ath5k_softc *sc, struct ath5k_txq *txq)
 		ath5k_txbuf_free(sc, bf);
 
 		spin_lock_bh(&sc->txbuflock);
-		sc->tx_stats[txq->qnum].len--;
 		list_move_tail(&bf->list, &sc->txbuf);
 		sc->txbuf_len++;
 		spin_unlock_bh(&sc->txbuflock);
@@ -2011,10 +2006,8 @@ ath5k_tx_processq(struct ath5k_softc *sc, struct ath5k_txq *txq)
 		}
 
 		ieee80211_tx_status(sc->hw, skb);
-		sc->tx_stats[txq->qnum].count++;
 
 		spin_lock(&sc->txbuflock);
-		sc->tx_stats[txq->qnum].len--;
 		list_move_tail(&bf->list, &sc->txbuf);
 		sc->txbuf_len++;
 		spin_unlock(&sc->txbuflock);
@@ -3116,17 +3109,6 @@ ath5k_get_stats(struct ieee80211_hw *hw,
 	return 0;
 }
 
-static int
-ath5k_get_tx_stats(struct ieee80211_hw *hw,
-		struct ieee80211_tx_queue_stats *stats)
-{
-	struct ath5k_softc *sc = hw->priv;
-
-	memcpy(stats, &sc->tx_stats, sizeof(sc->tx_stats));
-
-	return 0;
-}
-
 static u64
 ath5k_get_tsf(struct ieee80211_hw *hw)
 {
diff --git a/drivers/net/wireless/ath/ath5k/base.h b/drivers/net/wireless/ath/ath5k/base.h
index 952b3a2..7e1a88a 100644
--- a/drivers/net/wireless/ath/ath5k/base.h
+++ b/drivers/net/wireless/ath/ath5k/base.h
@@ -117,7 +117,6 @@ struct ath5k_softc {
 	struct pci_dev		*pdev;		/* for dma mapping */
 	void __iomem		*iobase;	/* address of the device */
 	struct mutex		lock;		/* dev-level lock */
-	struct ieee80211_tx_queue_stats tx_stats[AR5K_NUM_TX_QUEUES];
 	struct ieee80211_low_level_stats ll_stats;
 	struct ieee80211_hw	*hw;		/* IEEE 802.11 common */
 	struct ieee80211_supported_band sbands[IEEE80211_NUM_BANDS];

