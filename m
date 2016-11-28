Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.toke.dk ([52.28.52.200]:35431 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754360AbcK1KUh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 28 Nov 2016 05:20:37 -0500
From: =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: linux-wireless@vger.kernel.org
Cc: =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
Subject: [PATCH] ath9k: Turn ath_txq_lock/unlock() into static inlines.
Date: Mon, 28 Nov 2016 11:20:24 +0100
Message-Id: <20161128102024.14925-1-toke@toke.dk> (sfid-20161128_112200_052340_9C1A9D85)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These are one-line functions that just call spin_lock/unlock_bh(); turn
them into static inlines to avoid the function call overhead.

Signed-off-by: Toke Høiland-Jørgensen <toke@toke.dk>
---
 drivers/net/wireless/ath/ath9k/ath9k.h | 11 +++++++++--
 drivers/net/wireless/ath/ath9k/xmit.c  | 12 ------------
 2 files changed, 9 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 378d345..dca4aaa3 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -555,6 +555,15 @@ static inline void ath_chanctx_check_active(struct ath_softc *sc,
 
 #endif /* CONFIG_ATH9K_CHANNEL_CONTEXT */
 
+static inline void ath_txq_lock(struct ath_softc *sc, struct ath_txq *txq)
+{
+	spin_lock_bh(&txq->axq_lock);
+}
+static inline void ath_txq_unlock(struct ath_softc *sc, struct ath_txq *txq)
+{
+	spin_unlock_bh(&txq->axq_lock);
+}
+
 void ath_startrecv(struct ath_softc *sc);
 bool ath_stoprecv(struct ath_softc *sc);
 u32 ath_calcrxfilter(struct ath_softc *sc);
@@ -562,8 +571,6 @@ int ath_rx_init(struct ath_softc *sc, int nbufs);
 void ath_rx_cleanup(struct ath_softc *sc);
 int ath_rx_tasklet(struct ath_softc *sc, int flush, bool hp);
 struct ath_txq *ath_txq_setup(struct ath_softc *sc, int qtype, int subtype);
-void ath_txq_lock(struct ath_softc *sc, struct ath_txq *txq);
-void ath_txq_unlock(struct ath_softc *sc, struct ath_txq *txq);
 void ath_txq_unlock_complete(struct ath_softc *sc, struct ath_txq *txq);
 void ath_tx_cleanupq(struct ath_softc *sc, struct ath_txq *txq);
 bool ath_drain_all_txq(struct ath_softc *sc);
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 486afa9..e5c0829 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -97,18 +97,6 @@ static void ath_tx_status(struct ieee80211_hw *hw, struct sk_buff *skb)
 	dev_kfree_skb(skb);
 }
 
-void ath_txq_lock(struct ath_softc *sc, struct ath_txq *txq)
-	__acquires(&txq->axq_lock)
-{
-	spin_lock_bh(&txq->axq_lock);
-}
-
-void ath_txq_unlock(struct ath_softc *sc, struct ath_txq *txq)
-	__releases(&txq->axq_lock)
-{
-	spin_unlock_bh(&txq->axq_lock);
-}
-
 void ath_txq_unlock_complete(struct ath_softc *sc, struct ath_txq *txq)
 	__releases(&txq->axq_lock)
 {

base-commit: 705d7aa062203226c8df73f18622664e30bd8a61
-- 
2.10.2
