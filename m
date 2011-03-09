Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:53092 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755612Ab1CIQaw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Mar 2011 11:30:52 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: bloat-devel@lists.bufferbloat.net, me@bobcopeland.com,
	mickflemm@gmail.com, "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 3/3] ath5k: implement ieee80211_ops->{get,set}_ringparam
Date: Wed,  9 Mar 2011 11:21:24 -0500
Message-Id: <1299687684-19638-3-git-send-email-linville@tuxdriver.com>
In-Reply-To: <1299687684-19638-1-git-send-email-linville@tuxdriver.com>
References: <1299687684-19638-1-git-send-email-linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

set_ringparam only allows changes to tx ring at this time.

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/ath/ath5k/base.c         |    3 +-
 drivers/net/wireless/ath/ath5k/base.h         |    1 +
 drivers/net/wireless/ath/ath5k/mac80211-ops.c |   43 +++++++++++++++++++++++++
 3 files changed, 46 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index e6ff62e..4d7f21e 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -943,6 +943,7 @@ ath5k_txq_setup(struct ath5k_softc *sc,
 		spin_lock_init(&txq->lock);
 		txq->setup = true;
 		txq->txq_len = 0;
+		txq->txq_max = ATH5K_TXQ_LEN_MAX;
 		txq->txq_poll_mark = false;
 		txq->txq_stuck = 0;
 	}
@@ -1534,7 +1535,7 @@ ath5k_tx_queue(struct ieee80211_hw *hw, struct sk_buff *skb,
 		goto drop_packet;
 	}
 
-	if (txq->txq_len >= ATH5K_TXQ_LEN_MAX)
+	if (txq->txq_len >= txq->txq_max)
 		ieee80211_stop_queue(hw, txq->qnum);
 
 	spin_lock_irqsave(&sc->txbuflock, flags);
diff --git a/drivers/net/wireless/ath/ath5k/base.h b/drivers/net/wireless/ath/ath5k/base.h
index 8d1df1f..978f1f4 100644
--- a/drivers/net/wireless/ath/ath5k/base.h
+++ b/drivers/net/wireless/ath/ath5k/base.h
@@ -86,6 +86,7 @@ struct ath5k_txq {
 	spinlock_t		lock;	/* lock on q and link */
 	bool			setup;
 	int			txq_len; /* number of queued buffers */
+	int			txq_max; /* max allowed num of queued buffers */
 	bool			txq_poll_mark;
 	unsigned int		txq_stuck;	/* informational counter */
 };
diff --git a/drivers/net/wireless/ath/ath5k/mac80211-ops.c b/drivers/net/wireless/ath/ath5k/mac80211-ops.c
index c9b0b67..9be29b7 100644
--- a/drivers/net/wireless/ath/ath5k/mac80211-ops.c
+++ b/drivers/net/wireless/ath/ath5k/mac80211-ops.c
@@ -740,6 +740,47 @@ ath5k_get_antenna(struct ieee80211_hw *hw, u32 *tx_ant, u32 *rx_ant)
 }
 
 
+static void ath5k_get_ringparam(struct ieee80211_hw *hw,
+				u32 *tx, u32 *tx_max, u32 *rx, u32 *rx_max)
+{
+	struct ath5k_softc *sc = hw->priv;
+
+	*tx = sc->txqs[AR5K_TX_QUEUE_ID_DATA_MIN].txq_max;
+
+	*tx_max = ATH5K_TXQ_LEN_MAX;
+	*rx = *rx_max = ATH_RXBUF;
+}
+
+
+static int ath5k_set_ringparam(struct ieee80211_hw *hw, u32 tx, u32 rx)
+{
+	struct ath5k_softc *sc = hw->priv;
+	u16 qnum;
+
+	/* only support setting tx ring size for now */
+	if (rx != ATH_RXBUF)
+		return -EINVAL;
+
+	/* restrict tx ring size min/max */
+	if (!tx || tx > ATH5K_TXQ_LEN_MAX)
+		return -EINVAL;
+
+	for (qnum = 0; qnum < ARRAY_SIZE(sc->txqs); qnum++) {
+		if (!sc->txqs[qnum].setup)
+			continue;
+		if (sc->txqs[qnum].qnum < AR5K_TX_QUEUE_ID_DATA_MIN ||
+		    sc->txqs[qnum].qnum > AR5K_TX_QUEUE_ID_DATA_MAX)
+			continue;
+
+		sc->txqs[qnum].txq_max = tx;
+		if (sc->txqs[qnum].txq_len >= sc->txqs[qnum].txq_max)
+			ieee80211_stop_queue(hw, sc->txqs[qnum].qnum);
+	}
+
+	return 0;
+}
+
+
 const struct ieee80211_ops ath5k_hw_ops = {
 	.tx			= ath5k_tx,
 	.start			= ath5k_start,
@@ -778,4 +819,6 @@ const struct ieee80211_ops ath5k_hw_ops = {
 	/* .napi_poll		= not implemented */
 	.set_antenna		= ath5k_set_antenna,
 	.get_antenna		= ath5k_get_antenna,
+	.set_ringparam		= ath5k_set_ringparam,
+	.get_ringparam		= ath5k_get_ringparam,
 };
-- 
1.7.4

