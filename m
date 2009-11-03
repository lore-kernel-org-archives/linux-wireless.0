Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:40946 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757622AbZKCDH5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Nov 2009 22:07:57 -0500
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linux-wireless@vger.kernel.org
Cc: ath9k-devel@lists.ath9k.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	"Jouni.Malinen" <Jouni.Malinen@atheros.com>
Subject: [RFT 8/9] ath9k: handle low buffer space for virtual wiphys
Date: Mon,  2 Nov 2009 22:08:00 -0500
Message-Id: <1257217681-27180-9-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1257217681-27180-1-git-send-email-lrodriguez@atheros.com>
References: <1257217681-27180-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ath9k virtual wiphys all share the same internal buffer space
for TX but they do not share the mac80211 skb queues. When
ath9k detects it is running low on buffer space to TX it tells
mac80211 to stop sending it skbs its way but it always does
this only for the primary wiphy. This means mac80211 won't know
its best to avoid sending ath9k more skbs on a separate virtual
wiphy. The same issue is present for reliving the skb queue.

Since ath9k does not keep track of which virtual wiphy is hammering
on TX silence all wiphy's TX when we're low on buffer space. When
we're free on buffer space only bother informing the virtual wiphy
which is active that we have free buffers.

Cc: Jouni.Malinen <Jouni.Malinen@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h   |    3 ++
 drivers/net/wireless/ath/ath9k/virtual.c |   52 ++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/xmit.c    |   10 +++---
 3 files changed, 60 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 59ce7ec..4169d2b 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -695,5 +695,8 @@ void ath9k_wiphy_work(struct work_struct *work);
 bool ath9k_all_wiphys_idle(struct ath_softc *sc);
 void ath9k_set_wiphy_idle(struct ath_wiphy *aphy, bool idle);
 
+void ath_mac80211_stop_queue(struct ath_softc *sc, u16 skb_queue);
+void ath_mac80211_start_queue(struct ath_softc *sc, u16 skb_queue);
+
 int ath_tx_get_qnum(struct ath_softc *sc, int qtype, int haltype);
 #endif /* ATH9K_H */
diff --git a/drivers/net/wireless/ath/ath9k/virtual.c b/drivers/net/wireless/ath/ath9k/virtual.c
index 69a871b..0a36b57 100644
--- a/drivers/net/wireless/ath/ath9k/virtual.c
+++ b/drivers/net/wireless/ath/ath9k/virtual.c
@@ -697,3 +697,55 @@ void ath9k_set_wiphy_idle(struct ath_wiphy *aphy, bool idle)
 		  wiphy_name(aphy->hw->wiphy),
 		  idle ? "idle" : "not-idle");
 }
+/* Only bother starting a queue on an active virtual wiphy */
+void ath_mac80211_start_queue(struct ath_softc *sc, u16 skb_queue)
+{
+	struct ieee80211_hw *hw = sc->pri_wiphy->hw;
+	unsigned int i;
+
+	spin_lock_bh(&sc->wiphy_lock);
+
+	/* Start the primary wiphy */
+	if (sc->pri_wiphy->state == ATH_WIPHY_ACTIVE) {
+		ieee80211_wake_queue(hw, skb_queue);
+		goto unlock;
+	}
+
+	/* Now start the secondary wiphy queues */
+	for (i = 0; i < sc->num_sec_wiphy; i++) {
+		struct ath_wiphy *aphy = sc->sec_wiphy[i];
+		if (!aphy)
+			continue;
+		if (aphy->state != ATH_WIPHY_ACTIVE)
+			continue;
+
+		hw = aphy->hw;
+		ieee80211_wake_queue(hw, skb_queue);
+		break;
+	}
+
+unlock:
+	spin_unlock_bh(&sc->wiphy_lock);
+}
+
+/* Go ahead and propagate information to all virtual wiphys, it won't hurt */
+void ath_mac80211_stop_queue(struct ath_softc *sc, u16 skb_queue)
+{
+	struct ieee80211_hw *hw = sc->pri_wiphy->hw;
+	unsigned int i;
+
+	spin_lock_bh(&sc->wiphy_lock);
+
+	/* Stop the primary wiphy */
+	ieee80211_stop_queue(hw, skb_queue);
+
+	/* Now stop the secondary wiphy queues */
+	for (i = 0; i < sc->num_sec_wiphy; i++) {
+		struct ath_wiphy *aphy = sc->sec_wiphy[i];
+		if (!aphy)
+			continue;
+		hw = aphy->hw;
+		ieee80211_stop_queue(hw, skb_queue);
+	}
+	spin_unlock_bh(&sc->wiphy_lock);
+}
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 427bd1d..40d34ed 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -914,9 +914,10 @@ int ath_tx_get_qnum(struct ath_softc *sc, int qtype, int haltype)
 struct ath_txq *ath_test_get_txq(struct ath_softc *sc, struct sk_buff *skb)
 {
 	struct ath_txq *txq = NULL;
+	u16 skb_queue = skb_get_queue_mapping(skb);
 	int qnum;
 
-	qnum = ath_get_hal_qnum(skb_get_queue_mapping(skb), sc);
+	qnum = ath_get_hal_qnum(skb_queue, sc);
 	txq = &sc->tx.txq[qnum];
 
 	spin_lock_bh(&txq->axq_lock);
@@ -925,7 +926,7 @@ struct ath_txq *ath_test_get_txq(struct ath_softc *sc, struct sk_buff *skb)
 		ath_print(ath9k_hw_common(sc->sc_ah), ATH_DBG_XMIT,
 			  "TX queue: %d is full, depth: %d\n",
 			  qnum, txq->axq_depth);
-		ieee80211_stop_queue(sc->hw, skb_get_queue_mapping(skb));
+		ath_mac80211_stop_queue(sc, skb_queue);
 		txq->stopped = 1;
 		spin_unlock_bh(&txq->axq_lock);
 		return NULL;
@@ -1704,8 +1705,7 @@ int ath_tx_start(struct ieee80211_hw *hw, struct sk_buff *skb,
 		 * on the queue */
 		spin_lock_bh(&txq->axq_lock);
 		if (sc->tx.txq[txq->axq_qnum].axq_depth > 1) {
-			ieee80211_stop_queue(sc->hw,
-				skb_get_queue_mapping(skb));
+			ath_mac80211_stop_queue(sc, skb_get_queue_mapping(skb));
 			txq->stopped = 1;
 		}
 		spin_unlock_bh(&txq->axq_lock);
@@ -1945,7 +1945,7 @@ static void ath_wake_mac80211_queue(struct ath_softc *sc, struct ath_txq *txq)
 	    sc->tx.txq[txq->axq_qnum].axq_depth <= (ATH_TXBUF - 20)) {
 		qnum = ath_get_mac80211_qnum(txq->axq_qnum, sc);
 		if (qnum != -1) {
-			ieee80211_wake_queue(sc->hw, qnum);
+			ath_mac80211_start_queue(sc, qnum);
 			txq->stopped = 0;
 		}
 	}
-- 
1.6.5.2.143.g8cc62

