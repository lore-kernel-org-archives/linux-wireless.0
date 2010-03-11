Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:57778 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756865Ab0CKV4E (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Mar 2010 16:56:04 -0500
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: stable@kernel.org
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Senthil Balasubramanian <senthilkumar@atheros.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 1/2] ath9k: Enable TIM timer interrupt only when needed.
Date: Thu, 11 Mar 2010 16:55:57 -0500
Message-Id: <1268344558-13835-2-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1268344558-13835-1-git-send-email-lrodriguez@atheros.com>
References: <1268344558-13835-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Senthil Balasubramanian <senthilkumar@atheros.com>

commit 3f7c5c10e9dc6bf90179eb9f7c06151d508fb324 upstream.

The TIM timer interrupt is enabled even before the ACK of nullqos
is received which is unnecessary.

Also clean up the CONF_PS part of config callback properly for
better readability.

Signed-off-by: Senthil Balasubramanian <senthilkumar@atheros.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h |    1 +
 drivers/net/wireless/ath/ath9k/main.c  |   24 ++++++++++++++----------
 drivers/net/wireless/ath/ath9k/xmit.c  |    7 +++----
 3 files changed, 18 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 1597a42..2bad712 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -267,6 +267,7 @@ void ath_tx_aggr_start(struct ath_softc *sc, struct ieee80211_sta *sta,
 		       u16 tid, u16 *ssn);
 void ath_tx_aggr_stop(struct ath_softc *sc, struct ieee80211_sta *sta, u16 tid);
 void ath_tx_aggr_resume(struct ath_softc *sc, struct ieee80211_sta *sta, u16 tid);
+void ath9k_enable_ps(struct ath_softc *sc);
 
 /********/
 /* VIFs */
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index fda25b5..806c9ce 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -2677,6 +2677,19 @@ static void ath9k_remove_interface(struct ieee80211_hw *hw,
 	mutex_unlock(&sc->mutex);
 }
 
+void ath9k_enable_ps(struct ath_softc *sc)
+{
+	sc->ps_enabled = true;
+	if (!(sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_AUTOSLEEP)) {
+		if ((sc->imask & ATH9K_INT_TIM_TIMER) == 0) {
+			sc->imask |= ATH9K_INT_TIM_TIMER;
+			ath9k_hw_set_interrupts(sc->sc_ah,
+					sc->imask);
+		}
+	}
+	ath9k_hw_setrxabort(sc->sc_ah, 1);
+}
+
 static int ath9k_config(struct ieee80211_hw *hw, u32 changed)
 {
 	struct ath_wiphy *aphy = hw->priv;
@@ -2730,22 +2743,13 @@ static int ath9k_config(struct ieee80211_hw *hw, u32 changed)
 	if (changed & IEEE80211_CONF_CHANGE_PS) {
 		if (conf->flags & IEEE80211_CONF_PS) {
 			sc->sc_flags |= SC_OP_PS_ENABLED;
-			if (!(ah->caps.hw_caps &
-			      ATH9K_HW_CAP_AUTOSLEEP)) {
-				if ((sc->imask & ATH9K_INT_TIM_TIMER) == 0) {
-					sc->imask |= ATH9K_INT_TIM_TIMER;
-					ath9k_hw_set_interrupts(sc->sc_ah,
-							sc->imask);
-				}
-			}
 			/*
 			 * At this point we know hardware has received an ACK
 			 * of a previously sent null data frame.
 			 */
 			if ((sc->sc_flags & SC_OP_NULLFUNC_COMPLETED)) {
 				sc->sc_flags &= ~SC_OP_NULLFUNC_COMPLETED;
-				sc->ps_enabled = true;
-				ath9k_hw_setrxabort(sc->sc_ah, 1);
+				ath9k_enable_ps(sc);
                         }
 		} else {
 			sc->ps_enabled = false;
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 29bf336..736a04d 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -2053,10 +2053,9 @@ static void ath_tx_processq(struct ath_softc *sc, struct ath_txq *txq)
 		 */
 		if (bf->bf_isnullfunc &&
 		    (ds->ds_txstat.ts_status & ATH9K_TX_ACKED)) {
-			if ((sc->sc_flags & SC_OP_PS_ENABLED)) {
-				sc->ps_enabled = true;
-				ath9k_hw_setrxabort(sc->sc_ah, 1);
-			} else
+			if ((sc->sc_flags & SC_OP_PS_ENABLED))
+				ath9k_enable_ps(sc);
+			else
 				sc->sc_flags |= SC_OP_NULLFUNC_COMPLETED;
 		}
 
-- 
1.6.3.3

