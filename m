Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:16728 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932622Ab0BCRVS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Feb 2010 12:21:18 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 03 Feb 2010 09:21:18 -0800
From: Senthil Balasubramanian <senthilkumar@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Senthil Balasubramanian <senthilkumar@atheros.com>
Subject: [PATCH 2/3] ath9k: Enable TIM timer interrupt only when needed.
Date: Wed, 3 Feb 2010 22:51:13 +0530
Message-ID: <1265217673-2047-1-git-send-email-senthilkumar@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The TIM timer interrupt is enabled even before the ACK of nullqos
is received which is unnecessary.

Also clean up the CONF_PS part of config callback properly for
better readability.

Signed-off-by: Senthil Balasubramanian <senthilkumar@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h |    1 +
 drivers/net/wireless/ath/ath9k/main.c  |   24 ++++++++++++++----------
 drivers/net/wireless/ath/ath9k/xmit.c  |    7 +++----
 3 files changed, 18 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 0ea340f..83c7ea4 100644
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
index 6796d5c..40da7a6 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1492,6 +1492,19 @@ static void ath9k_remove_interface(struct ieee80211_hw *hw,
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
@@ -1546,22 +1559,13 @@ static int ath9k_config(struct ieee80211_hw *hw, u32 changed)
 	if (changed & IEEE80211_CONF_CHANGE_PS) {
 		if (conf->flags & IEEE80211_CONF_PS) {
 			sc->ps_flags |= PS_ENABLED;
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
 			if ((sc->ps_flags & PS_NULLFUNC_COMPLETED)) {
 				sc->ps_flags &= ~PS_NULLFUNC_COMPLETED;
-				sc->ps_enabled = true;
-				ath9k_hw_setrxabort(sc->sc_ah, 1);
+				ath9k_enable_ps(sc);
                         }
 		} else {
 			sc->ps_enabled = false;
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 3c790a4..f5cbbcb 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -2048,10 +2048,9 @@ static void ath_tx_processq(struct ath_softc *sc, struct ath_txq *txq)
 		 */
 		if (bf->bf_isnullfunc &&
 		    (ds->ds_txstat.ts_status & ATH9K_TX_ACKED)) {
-			if ((sc->ps_flags & PS_ENABLED)) {
-				sc->ps_enabled = true;
-				ath9k_hw_setrxabort(sc->sc_ah, 1);
-			} else
+			if ((sc->ps_flags & PS_ENABLED))
+				ath9k_enable_ps(sc);
+			else
 				sc->ps_flags |= PS_NULLFUNC_COMPLETED;
 		}

--
1.6.6.1

