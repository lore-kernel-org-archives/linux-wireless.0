Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:46757 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750942AbaJIIMJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Oct 2014 04:12:09 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com
Subject: [PATCH 5/5] ath9k: Check for pending frames properly
Date: Thu,  9 Oct 2014 13:42:52 +0530
Message-Id: <1412842372-17628-6-git-send-email-sujith@msujith.org> (sfid-20141009_101221_672107_E4CC38BB)
In-Reply-To: <1412842372-17628-1-git-send-email-sujith@msujith.org>
References: <1412842372-17628-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Pending frames in the driver can be present
either in the HW queues or SW. ath9k_has_pending_frames()
currently checks for the HW queues first and then
checks if any ACs are queued in the driver.

In MCC mode, we need to check the HW queues alone, since
the SW queues are just marked as 'stopped' - they will
be processed in the next context switch. But since we
don't differentiate this now, mention whether we want
to check if there are frames in the SW queues.

* The flush() callback checks both HW and SW queues.
* The tx_frames_pending() callback does the same.
* The call to __ath9k_flush() in MCC mode checks HW queues alone.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h   |  3 ++-
 drivers/net/wireless/ath/ath9k/channel.c |  5 +++--
 drivers/net/wireless/ath/ath9k/main.c    | 21 ++++++++++++++-------
 3 files changed, 19 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 43c1987..d4b71ed 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -715,7 +715,8 @@ int ath_update_survey_stats(struct ath_softc *sc);
 void ath_update_survey_nf(struct ath_softc *sc, int channel);
 void ath9k_queue_reset(struct ath_softc *sc, enum ath_reset_type type);
 void ath_ps_full_sleep(unsigned long data);
-void __ath9k_flush(struct ieee80211_hw *hw, u32 queues, bool drop);
+void __ath9k_flush(struct ieee80211_hw *hw, u32 queues, bool drop,
+		   bool sw_pending);
 
 /**********/
 /* BTCOEX */
diff --git a/drivers/net/wireless/ath/ath9k/channel.c b/drivers/net/wireless/ath/ath9k/channel.c
index abc3e2e..9c4f872 100644
--- a/drivers/net/wireless/ath/ath9k/channel.c
+++ b/drivers/net/wireless/ath/ath9k/channel.c
@@ -1137,10 +1137,11 @@ void ath_chanctx_set_next(struct ath_softc *sc, bool force)
 		ath9k_chanctx_stop_queues(sc, sc->cur_chan);
 		queues_stopped = true;
 
-		__ath9k_flush(sc->hw, ~0, true);
+		__ath9k_flush(sc->hw, ~0, true, false);
 
 		if (ath_chanctx_send_ps_frame(sc, true))
-			__ath9k_flush(sc->hw, BIT(IEEE80211_AC_VO), false);
+			__ath9k_flush(sc->hw, BIT(IEEE80211_AC_VO),
+				      false, false);
 
 		send_ps = true;
 		spin_lock_bh(&sc->chan_lock);
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 81a20de..2048ef1 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -54,7 +54,8 @@ u8 ath9k_parse_mpdudensity(u8 mpdudensity)
 	}
 }
 
-static bool ath9k_has_pending_frames(struct ath_softc *sc, struct ath_txq *txq)
+static bool ath9k_has_pending_frames(struct ath_softc *sc, struct ath_txq *txq,
+				     bool sw_pending)
 {
 	bool pending = false;
 
@@ -65,6 +66,9 @@ static bool ath9k_has_pending_frames(struct ath_softc *sc, struct ath_txq *txq)
 		goto out;
 	}
 
+	if (!sw_pending)
+		goto out;
+
 	if (txq->mac80211_qnum >= 0) {
 		struct list_head *list;
 
@@ -2003,7 +2007,8 @@ static void ath9k_set_coverage_class(struct ieee80211_hw *hw,
 	mutex_unlock(&sc->mutex);
 }
 
-static bool ath9k_has_tx_pending(struct ath_softc *sc)
+static bool ath9k_has_tx_pending(struct ath_softc *sc,
+				 bool sw_pending)
 {
 	int i, npend = 0;
 
@@ -2011,7 +2016,8 @@ static bool ath9k_has_tx_pending(struct ath_softc *sc)
 		if (!ATH_TXQ_SETUP(sc, i))
 			continue;
 
-		npend = ath9k_has_pending_frames(sc, &sc->tx.txq[i]);
+		npend = ath9k_has_pending_frames(sc, &sc->tx.txq[i],
+						 sw_pending);
 		if (npend)
 			break;
 	}
@@ -2025,11 +2031,12 @@ static void ath9k_flush(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	struct ath_softc *sc = hw->priv;
 
 	mutex_lock(&sc->mutex);
-	__ath9k_flush(hw, queues, drop);
+	__ath9k_flush(hw, queues, drop, true);
 	mutex_unlock(&sc->mutex);
 }
 
-void __ath9k_flush(struct ieee80211_hw *hw, u32 queues, bool drop)
+void __ath9k_flush(struct ieee80211_hw *hw, u32 queues, bool drop,
+		   bool sw_pending)
 {
 	struct ath_softc *sc = hw->priv;
 	struct ath_hw *ah = sc->sc_ah;
@@ -2056,7 +2063,7 @@ void __ath9k_flush(struct ieee80211_hw *hw, u32 queues, bool drop)
 	ath_dbg(common, CHAN_CTX,
 		"Flush timeout: %d\n", jiffies_to_msecs(timeout));
 
-	if (wait_event_timeout(sc->tx_wait, !ath9k_has_tx_pending(sc),
+	if (wait_event_timeout(sc->tx_wait, !ath9k_has_tx_pending(sc, sw_pending),
 			       timeout) > 0)
 		drop = false;
 
@@ -2079,7 +2086,7 @@ static bool ath9k_tx_frames_pending(struct ieee80211_hw *hw)
 {
 	struct ath_softc *sc = hw->priv;
 
-	return ath9k_has_tx_pending(sc);
+	return ath9k_has_tx_pending(sc, true);
 }
 
 static int ath9k_tx_last_beacon(struct ieee80211_hw *hw)
-- 
2.1.2

