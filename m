Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:57153 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756238Ab0ITLp4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Sep 2010 07:45:56 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, lrodriguez@atheros.com
Subject: [PATCH 2/5] ath9k: fix an aggregation start related race condition
Date: Mon, 20 Sep 2010 13:45:37 +0200
Message-Id: <1284983140-30099-2-git-send-email-nbd@openwrt.org>
In-Reply-To: <1284983140-30099-1-git-send-email-nbd@openwrt.org>
References: <1284983140-30099-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

A new aggregation session start can be issued by mac80211, even when the
cleanup of the previous session has not completed yet. Since the data structure
for the session is not recreated, this could corrupt the block ack window
and lock up the aggregation session. Fix this by delaying the new session
until the old one has been cleaned up.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Cc: stable@kernel.org
---
 drivers/net/wireless/ath/ath9k/ath9k.h |    4 ++--
 drivers/net/wireless/ath/ath9k/main.c  |    2 +-
 drivers/net/wireless/ath/ath9k/xmit.c  |   10 ++++++++--
 3 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 9fddd80..dfd368a 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -346,8 +346,8 @@ void ath_tx_tasklet(struct ath_softc *sc);
 void ath_tx_edma_tasklet(struct ath_softc *sc);
 void ath_tx_cabq(struct ieee80211_hw *hw, struct sk_buff *skb);
 bool ath_tx_aggr_check(struct ath_softc *sc, struct ath_node *an, u8 tidno);
-void ath_tx_aggr_start(struct ath_softc *sc, struct ieee80211_sta *sta,
-		       u16 tid, u16 *ssn);
+int ath_tx_aggr_start(struct ath_softc *sc, struct ieee80211_sta *sta,
+		      u16 tid, u16 *ssn);
 void ath_tx_aggr_stop(struct ath_softc *sc, struct ieee80211_sta *sta, u16 tid);
 void ath_tx_aggr_resume(struct ath_softc *sc, struct ieee80211_sta *sta, u16 tid);
 void ath9k_enable_ps(struct ath_softc *sc);
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 1165f90..f5af9f9 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1975,7 +1975,7 @@ static int ath9k_ampdu_action(struct ieee80211_hw *hw,
 		break;
 	case IEEE80211_AMPDU_TX_START:
 		ath9k_ps_wakeup(sc);
-		ath_tx_aggr_start(sc, sta, tid, ssn);
+		ret = ath_tx_aggr_start(sc, sta, tid, ssn);
 		ieee80211_start_tx_ba_cb_irqsafe(vif, sta->addr, tid);
 		ath9k_ps_restore(sc);
 		break;
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 5323a4d..d629bfb 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -783,17 +783,23 @@ static void ath_tx_sched_aggr(struct ath_softc *sc, struct ath_txq *txq,
 		 status != ATH_AGGR_BAW_CLOSED);
 }
 
-void ath_tx_aggr_start(struct ath_softc *sc, struct ieee80211_sta *sta,
-		       u16 tid, u16 *ssn)
+int ath_tx_aggr_start(struct ath_softc *sc, struct ieee80211_sta *sta,
+		      u16 tid, u16 *ssn)
 {
 	struct ath_atx_tid *txtid;
 	struct ath_node *an;
 
 	an = (struct ath_node *)sta->drv_priv;
 	txtid = ATH_AN_2_TID(an, tid);
+
+	if (txtid->state & (AGGR_CLEANUP | AGGR_ADDBA_COMPLETE))
+		return -EAGAIN;
+
 	txtid->state |= AGGR_ADDBA_PROGRESS;
 	txtid->paused = true;
 	*ssn = txtid->seq_start;
+
+	return 0;
 }
 
 void ath_tx_aggr_stop(struct ath_softc *sc, struct ieee80211_sta *sta, u16 tid)
-- 
1.7.2.2

