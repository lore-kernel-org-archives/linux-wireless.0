Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:30284 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753911AbZGWKCh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jul 2009 06:02:37 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 23 Jul 2009 03:02:38 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19048.13629.94762.506456@localhost.localdomain>
Date: Thu, 23 Jul 2009 15:32:37 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 5/6] ath9k: Cleanup return values
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Cleanup aggregation start/stop function interfaces.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h |    6 +++---
 drivers/net/wireless/ath/ath9k/main.c  |   14 +++-----------
 drivers/net/wireless/ath/ath9k/xmit.c  |   25 +++++++++----------------
 3 files changed, 15 insertions(+), 30 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index d3c1633..9d01d99 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -362,9 +362,9 @@ int ath_tx_start(struct ieee80211_hw *hw, struct sk_buff *skb,
 void ath_tx_tasklet(struct ath_softc *sc);
 void ath_tx_cabq(struct ieee80211_hw *hw, struct sk_buff *skb);
 bool ath_tx_aggr_check(struct ath_softc *sc, struct ath_node *an, u8 tidno);
-int ath_tx_aggr_start(struct ath_softc *sc, struct ieee80211_sta *sta,
-		      u16 tid, u16 *ssn);
-int ath_tx_aggr_stop(struct ath_softc *sc, struct ieee80211_sta *sta, u16 tid);
+void ath_tx_aggr_start(struct ath_softc *sc, struct ieee80211_sta *sta,
+		       u16 tid, u16 *ssn);
+void ath_tx_aggr_stop(struct ath_softc *sc, struct ieee80211_sta *sta, u16 tid);
 void ath_tx_aggr_resume(struct ath_softc *sc, struct ieee80211_sta *sta, u16 tid);
 
 /********/
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index fb84dd8..f2fa333 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -2671,19 +2671,11 @@ static int ath9k_ampdu_action(struct ieee80211_hw *hw,
 	case IEEE80211_AMPDU_RX_STOP:
 		break;
 	case IEEE80211_AMPDU_TX_START:
-		ret = ath_tx_aggr_start(sc, sta, tid, ssn);
-		if (ret < 0)
-			DPRINTF(sc, ATH_DBG_FATAL,
-				"Unable to start TX aggregation\n");
-		else
-			ieee80211_start_tx_ba_cb_irqsafe(hw, sta->addr, tid);
+		ath_tx_aggr_start(sc, sta, tid, ssn);
+		ieee80211_start_tx_ba_cb_irqsafe(hw, sta->addr, tid);
 		break;
 	case IEEE80211_AMPDU_TX_STOP:
-		ret = ath_tx_aggr_stop(sc, sta, tid);
-		if (ret < 0)
-			DPRINTF(sc, ATH_DBG_FATAL,
-				"Unable to stop TX aggregation\n");
-
+		ath_tx_aggr_stop(sc, sta, tid);
 		ieee80211_stop_tx_ba_cb_irqsafe(hw, sta->addr, tid);
 		break;
 	case IEEE80211_AMPDU_TX_OPERATIONAL:
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 8a8d7ed..fd07aa1 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -701,25 +701,20 @@ static void ath_tx_sched_aggr(struct ath_softc *sc, struct ath_txq *txq,
 		 status != ATH_AGGR_BAW_CLOSED);
 }
 
-int ath_tx_aggr_start(struct ath_softc *sc, struct ieee80211_sta *sta,
-		      u16 tid, u16 *ssn)
+void ath_tx_aggr_start(struct ath_softc *sc, struct ieee80211_sta *sta,
+		       u16 tid, u16 *ssn)
 {
 	struct ath_atx_tid *txtid;
 	struct ath_node *an;
 
 	an = (struct ath_node *)sta->drv_priv;
-
-	if (sc->sc_flags & SC_OP_TXAGGR) {
-		txtid = ATH_AN_2_TID(an, tid);
-		txtid->state |= AGGR_ADDBA_PROGRESS;
-		ath_tx_pause_tid(sc, txtid);
-		*ssn = txtid->seq_start;
-	}
-
-	return 0;
+	txtid = ATH_AN_2_TID(an, tid);
+	txtid->state |= AGGR_ADDBA_PROGRESS;
+	ath_tx_pause_tid(sc, txtid);
+	*ssn = txtid->seq_start;
 }
 
-int ath_tx_aggr_stop(struct ath_softc *sc, struct ieee80211_sta *sta, u16 tid)
+void ath_tx_aggr_stop(struct ath_softc *sc, struct ieee80211_sta *sta, u16 tid)
 {
 	struct ath_node *an = (struct ath_node *)sta->drv_priv;
 	struct ath_atx_tid *txtid = ATH_AN_2_TID(an, tid);
@@ -729,11 +724,11 @@ int ath_tx_aggr_stop(struct ath_softc *sc, struct ieee80211_sta *sta, u16 tid)
 	INIT_LIST_HEAD(&bf_head);
 
 	if (txtid->state & AGGR_CLEANUP)
-		return 0;
+		return;
 
 	if (!(txtid->state & AGGR_ADDBA_COMPLETE)) {
 		txtid->state &= ~AGGR_ADDBA_PROGRESS;
-		return 0;
+		return;
 	}
 
 	ath_tx_pause_tid(sc, txtid);
@@ -762,8 +757,6 @@ int ath_tx_aggr_stop(struct ath_softc *sc, struct ieee80211_sta *sta, u16 tid)
 		txtid->state &= ~AGGR_ADDBA_COMPLETE;
 		ath_tx_flush_tid(sc, txtid);
 	}
-
-	return 0;
 }
 
 void ath_tx_aggr_resume(struct ath_softc *sc, struct ieee80211_sta *sta, u16 tid)
-- 
1.6.3.3

