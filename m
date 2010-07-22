Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:50721 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751926Ab0GVJYQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Jul 2010 05:24:16 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 22 Jul 2010 02:24:16 -0700
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 1/2] ath9k: Fix inconsistency between txq->stopped and the actual queue state
Date: Thu, 22 Jul 2010 02:24:11 -0700
Message-ID: <1279790651-11486-1-git-send-email-vasanth@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sometimes txq state(txq->stopped) can be marked as started but the actual
queue may not be started (in ATH_WIPHY_SCAN state, for example). Fix this.

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h   |    2 +-
 drivers/net/wireless/ath/ath9k/virtual.c |    6 +++++-
 drivers/net/wireless/ath/ath9k/xmit.c    |    4 ++--
 3 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 6e486a5..998ae2c 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -687,7 +687,7 @@ bool ath9k_all_wiphys_idle(struct ath_softc *sc);
 void ath9k_set_wiphy_idle(struct ath_wiphy *aphy, bool idle);
 
 void ath_mac80211_stop_queue(struct ath_softc *sc, u16 skb_queue);
-void ath_mac80211_start_queue(struct ath_softc *sc, u16 skb_queue);
+bool ath_mac80211_start_queue(struct ath_softc *sc, u16 skb_queue);
 
 void ath_start_rfkill_poll(struct ath_softc *sc);
 extern void ath9k_rfkill_poll_state(struct ieee80211_hw *hw);
diff --git a/drivers/net/wireless/ath/ath9k/virtual.c b/drivers/net/wireless/ath/ath9k/virtual.c
index 89423ca..fd20241 100644
--- a/drivers/net/wireless/ath/ath9k/virtual.c
+++ b/drivers/net/wireless/ath/ath9k/virtual.c
@@ -695,16 +695,18 @@ void ath9k_set_wiphy_idle(struct ath_wiphy *aphy, bool idle)
 		  idle ? "idle" : "not-idle");
 }
 /* Only bother starting a queue on an active virtual wiphy */
-void ath_mac80211_start_queue(struct ath_softc *sc, u16 skb_queue)
+bool ath_mac80211_start_queue(struct ath_softc *sc, u16 skb_queue)
 {
 	struct ieee80211_hw *hw = sc->pri_wiphy->hw;
 	unsigned int i;
+	bool txq_started = false;
 
 	spin_lock_bh(&sc->wiphy_lock);
 
 	/* Start the primary wiphy */
 	if (sc->pri_wiphy->state == ATH_WIPHY_ACTIVE) {
 		ieee80211_wake_queue(hw, skb_queue);
+		txq_started = true;
 		goto unlock;
 	}
 
@@ -718,11 +720,13 @@ void ath_mac80211_start_queue(struct ath_softc *sc, u16 skb_queue)
 
 		hw = aphy->hw;
 		ieee80211_wake_queue(hw, skb_queue);
+		txq_started = true;
 		break;
 	}
 
 unlock:
 	spin_unlock_bh(&sc->wiphy_lock);
+	return txq_started;
 }
 
 /* Go ahead and propagate information to all virtual wiphys, it won't hurt */
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 0644f1e..21aa5bd 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -2077,8 +2077,8 @@ static void ath_wake_mac80211_queue(struct ath_softc *sc, struct ath_txq *txq)
 
 	spin_lock_bh(&txq->axq_lock);
 	if (txq->stopped && sc->tx.pending_frames[qnum] < ATH_MAX_QDEPTH) {
-		ath_mac80211_start_queue(sc, qnum);
-		txq->stopped = 0;
+		if (ath_mac80211_start_queue(sc, qnum))
+			txq->stopped = 0;
 	}
 	spin_unlock_bh(&txq->axq_lock);
 }
-- 
1.7.0.4

