Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:11507 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752889Ab0JEPGt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Oct 2010 11:06:49 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 05 Oct 2010 08:06:40 -0700
From: Senthil Balasubramanian <senthilkumar@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Senthil Balasubramanian <senthilkumar@atheros.com>
Subject: [PATCH v2 1/2] ath9k: remove unnecessary power save flags.
Date: Tue, 5 Oct 2010 20:36:40 +0530
Message-ID: <1286291201-18052-1-git-send-email-senthilkumar@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

drv_config callback is called only after the ack for the nullframe
is received and so driver need not do anything special for this.

So remove NULLFUNC_COMPLETED, PS_ENABLED flags and bf_isnullfunc
flags from ath9k as mac80211 already handles them properly.

Signed-off-by: Senthil Balasubramanian <senthilkumar@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h |    4 ----
 drivers/net/wireless/ath/ath9k/main.c  |   18 ++++--------------
 drivers/net/wireless/ath/ath9k/xmit.c  |   30 ------------------------------
 3 files changed, 4 insertions(+), 48 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 9f8e542..de2b18e 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -241,7 +241,6 @@ struct ath_buf {
 	dma_addr_t bf_daddr;		/* physical addr of desc */
 	dma_addr_t bf_buf_addr;		/* physical addr of data buffer */
 	bool bf_stale;
-	bool bf_isnullfunc;
 	bool bf_tx_aborted;
 	u16 bf_flags;
 	struct ath_buf_state bf_state;
@@ -349,7 +348,6 @@ int ath_tx_aggr_start(struct ath_softc *sc, struct ieee80211_sta *sta,
 		      u16 tid, u16 *ssn);
 void ath_tx_aggr_stop(struct ath_softc *sc, struct ieee80211_sta *sta, u16 tid);
 void ath_tx_aggr_resume(struct ath_softc *sc, struct ieee80211_sta *sta, u16 tid);
-void ath9k_enable_ps(struct ath_softc *sc);
 
 /********/
 /* VIFs */
@@ -573,8 +571,6 @@ struct ath_ant_comb {
 #define PS_WAIT_FOR_PSPOLL_DATA   BIT(2)
 #define PS_WAIT_FOR_TX_ACK        BIT(3)
 #define PS_BEACON_SYNC            BIT(4)
-#define PS_NULLFUNC_COMPLETED     BIT(5)
-#define PS_ENABLED                BIT(6)
 
 struct ath_wiphy;
 struct ath_rate_table;
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index a133878..ccb2bf0 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1491,7 +1491,7 @@ static void ath9k_remove_interface(struct ieee80211_hw *hw,
 	mutex_unlock(&sc->mutex);
 }
 
-void ath9k_enable_ps(struct ath_softc *sc)
+static void ath9k_enable_ps(struct ath_softc *sc)
 {
 	struct ath_hw *ah = sc->sc_ah;
 
@@ -1558,20 +1558,10 @@ static int ath9k_config(struct ieee80211_hw *hw, u32 changed)
 	if (changed & IEEE80211_CONF_CHANGE_PS) {
 		unsigned long flags;
 		spin_lock_irqsave(&sc->sc_pm_lock, flags);
-		if (conf->flags & IEEE80211_CONF_PS) {
-			sc->ps_flags |= PS_ENABLED;
-			/*
-			 * At this point we know hardware has received an ACK
-			 * of a previously sent null data frame.
-			 */
-			if ((sc->ps_flags & PS_NULLFUNC_COMPLETED)) {
-				sc->ps_flags &= ~PS_NULLFUNC_COMPLETED;
-				ath9k_enable_ps(sc);
-                        }
-		} else {
+		if (conf->flags & IEEE80211_CONF_PS)
+			ath9k_enable_ps(sc);
+		else {
 			sc->ps_enabled = false;
-			sc->ps_flags &= ~(PS_ENABLED |
-					  PS_NULLFUNC_COMPLETED);
 			ath9k_hw_setpower(sc->sc_ah, ATH9K_PM_AWAKE);
 			if (!(ah->caps.hw_caps &
 			      ATH9K_HW_CAP_AUTOSLEEP)) {
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index f7da6b2..aa44777 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -1648,13 +1648,6 @@ static int ath_tx_setup_buffer(struct ieee80211_hw *hw, struct ath_buf *bf,
 
 	bf->bf_buf_addr = bf->bf_dmacontext;
 
-	/* tag if this is a nullfunc frame to enable PS when AP acks it */
-	if (ieee80211_is_nullfunc(fc) && ieee80211_has_pm(fc)) {
-		bf->bf_isnullfunc = true;
-		sc->ps_flags &= ~PS_NULLFUNC_COMPLETED;
-	} else
-		bf->bf_isnullfunc = false;
-
 	bf->bf_tx_aborted = false;
 
 	return 0;
@@ -2082,18 +2075,6 @@ static void ath_tx_processq(struct ath_softc *sc, struct ath_txq *txq)
 		}
 
 		/*
-		 * We now know the nullfunc frame has been ACKed so we
-		 * can disable RX.
-		 */
-		if (bf->bf_isnullfunc &&
-		    (ts.ts_status & ATH9K_TX_ACKED)) {
-			if ((sc->ps_flags & PS_ENABLED))
-				ath9k_enable_ps(sc);
-			else
-				sc->ps_flags |= PS_NULLFUNC_COMPLETED;
-		}
-
-		/*
 		 * Remove ath_buf's of the same transmit unit from txq,
 		 * however leave the last descriptor back as the holding
 		 * descriptor for hw.
@@ -2236,17 +2217,6 @@ void ath_tx_edma_tasklet(struct ath_softc *sc)
 
 		txok = !(txs.ts_status & ATH9K_TXERR_MASK);
 
-		/*
-		 * Make sure null func frame is acked before configuring
-		 * hw into ps mode.
-		 */
-		if (bf->bf_isnullfunc && txok) {
-			if ((sc->ps_flags & PS_ENABLED))
-				ath9k_enable_ps(sc);
-			else
-				sc->ps_flags |= PS_NULLFUNC_COMPLETED;
-		}
-
 		if (!bf_isampdu(bf)) {
 			if (txs.ts_status & ATH9K_TXERR_XRETRY)
 				bf->bf_state.bf_type |= BUF_XRETRY;
-- 
1.7.2.1

