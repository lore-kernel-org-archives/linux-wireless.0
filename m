Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:40339 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755192AbZIJHKR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Sep 2009 03:10:17 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	devel@linuxdriverproject.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 5/7] ath9k: rename driver core and hw power save helpers
Date: Thu, 10 Sep 2009 03:10:17 -0400
Message-Id: <1252566619-30390-6-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1252566619-30390-1-git-send-email-lrodriguez@atheros.com>
References: <1252566619-30390-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ath9k_hw_setpower_nolock --> ath9k_hw_setpower()
ath9k_hw_setpower() --> ath9k_setpower()

Also change the param for ath9k_setpower() to pass the ath_softc.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/hw.c   |   12 ++++++------
 drivers/net/wireless/ath/ath9k/hw.h   |    2 +-
 drivers/net/wireless/ath/ath9k/main.c |   22 +++++++++++-----------
 3 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 352f197..eeaf77a 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -919,7 +919,7 @@ int ath9k_hw_init(struct ath_hw *ah)
 		return -EIO;
 	}
 
-	if (!ath9k_hw_setpower_nolock(ah, ATH9K_PM_AWAKE)) {
+	if (!ath9k_hw_setpower(ah, ATH9K_PM_AWAKE)) {
 		DPRINTF(ah, ATH_DBG_FATAL, "Couldn't wakeup chip\n");
 		return -EIO;
 	}
@@ -1234,7 +1234,7 @@ void ath9k_hw_detach(struct ath_hw *ah)
 		ath9k_hw_ani_disable(ah);
 
 	ath9k_hw_rf_free(ah);
-	ath9k_hw_setpower_nolock(ah, ATH9K_PM_FULL_SLEEP);
+	ath9k_hw_setpower(ah, ATH9K_PM_FULL_SLEEP);
 	kfree(ah);
 	ah = NULL;
 }
@@ -1791,7 +1791,7 @@ static bool ath9k_hw_chip_reset(struct ath_hw *ah,
 	} else if (!ath9k_hw_set_reset_reg(ah, ATH9K_RESET_WARM))
 		return false;
 
-	if (!ath9k_hw_setpower_nolock(ah, ATH9K_PM_AWAKE))
+	if (!ath9k_hw_setpower(ah, ATH9K_PM_AWAKE))
 		return false;
 
 	ah->chip_fullsleep = false;
@@ -2345,7 +2345,7 @@ int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 	ah->txchainmask = sc->tx_chainmask;
 	ah->rxchainmask = sc->rx_chainmask;
 
-	if (!ath9k_hw_setpower_nolock(ah, ATH9K_PM_AWAKE))
+	if (!ath9k_hw_setpower(ah, ATH9K_PM_AWAKE))
 		return -EIO;
 
 	if (curchan)
@@ -2914,7 +2914,7 @@ static bool ath9k_hw_set_power_awake(struct ath_hw *ah, int setChip)
 	return true;
 }
 
-bool ath9k_hw_setpower_nolock(struct ath_hw *ah, enum ath9k_power_mode mode)
+bool ath9k_hw_setpower(struct ath_hw *ah, enum ath9k_power_mode mode)
 {
 	int status = true, setChip = true;
 	static const char *modes[] = {
@@ -3946,7 +3946,7 @@ bool ath9k_hw_phy_disable(struct ath_hw *ah)
 
 bool ath9k_hw_disable(struct ath_hw *ah)
 {
-	if (!ath9k_hw_setpower_nolock(ah, ATH9K_PM_AWAKE))
+	if (!ath9k_hw_setpower(ah, ATH9K_PM_AWAKE))
 		return false;
 
 	return ath9k_hw_set_reset_reg(ah, ATH9K_RESET_COLD);
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index c81f0a0..421d2ba 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -653,7 +653,7 @@ void ath9k_hw_beaconinit(struct ath_hw *ah, u32 next_beacon, u32 beacon_period);
 void ath9k_hw_set_sta_beacon_timers(struct ath_hw *ah,
 				    const struct ath9k_beacon_state *bs);
 
-bool ath9k_hw_setpower_nolock(struct ath_hw *ah, enum ath9k_power_mode mode);
+bool ath9k_hw_setpower(struct ath_hw *ah, enum ath9k_power_mode mode);
 
 void ath9k_hw_configpcipowersave(struct ath_hw *ah, int restore);
 
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 38c34a2..94ef651 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -243,14 +243,14 @@ static struct ath9k_channel *ath_get_curchannel(struct ath_softc *sc,
 	return channel;
 }
 
-static bool ath9k_hw_setpower(struct ath_hw *ah, enum ath9k_power_mode mode)
+static bool ath9k_setpower(struct ath_softc *sc, enum ath9k_power_mode mode)
 {
 	unsigned long flags;
 	bool ret;
 
-	spin_lock_irqsave(&ah->ah_sc->sc_pm_lock, flags);
-	ret = ath9k_hw_setpower_nolock(ah, mode);
-	spin_unlock_irqrestore(&ah->ah_sc->sc_pm_lock, flags);
+	spin_lock_irqsave(&sc->sc_pm_lock, flags);
+	ret = ath9k_hw_setpower(sc->sc_ah, mode);
+	spin_unlock_irqrestore(&sc->sc_pm_lock, flags);
 
 	return ret;
 }
@@ -263,7 +263,7 @@ void ath9k_ps_wakeup(struct ath_softc *sc)
 	if (++sc->ps_usecount != 1)
 		goto unlock;
 
-	ath9k_hw_setpower_nolock(sc->sc_ah, ATH9K_PM_AWAKE);
+	ath9k_hw_setpower(sc->sc_ah, ATH9K_PM_AWAKE);
 
  unlock:
 	spin_unlock_irqrestore(&sc->sc_pm_lock, flags);
@@ -282,7 +282,7 @@ void ath9k_ps_restore(struct ath_softc *sc)
 			      SC_OP_WAIT_FOR_CAB |
 			      SC_OP_WAIT_FOR_PSPOLL_DATA |
 			      SC_OP_WAIT_FOR_TX_ACK)))
-		ath9k_hw_setpower_nolock(sc->sc_ah, ATH9K_PM_NETWORK_SLEEP);
+		ath9k_hw_setpower(sc->sc_ah, ATH9K_PM_NETWORK_SLEEP);
 
  unlock:
 	spin_unlock_irqrestore(&sc->sc_pm_lock, flags);
@@ -652,7 +652,7 @@ irqreturn_t ath_isr(int irq, void *dev)
 		if (status & ATH9K_INT_TIM_TIMER) {
 			/* Clear RxAbort bit so that we can
 			 * receive frames */
-			ath9k_hw_setpower(ah, ATH9K_PM_AWAKE);
+			ath9k_setpower(sc, ATH9K_PM_AWAKE);
 			ath9k_hw_setrxabort(sc->sc_ah, 0);
 			sc->sc_flags |= SC_OP_WAIT_FOR_BEACON;
 		}
@@ -1254,7 +1254,7 @@ void ath_radio_disable(struct ath_softc *sc)
 	ath9k_hw_phy_disable(ah);
 	ath9k_hw_configpcipowersave(ah, 1);
 	ath9k_ps_restore(sc);
-	ath9k_hw_setpower(ah, ATH9K_PM_FULL_SLEEP);
+	ath9k_setpower(sc, ATH9K_PM_FULL_SLEEP);
 }
 
 /*******************/
@@ -1328,7 +1328,7 @@ void ath_detach(struct ath_softc *sc)
 	tasklet_kill(&sc->bcon_tasklet);
 
 	if (!(sc->sc_flags & SC_OP_INVALID))
-		ath9k_hw_setpower(ah, ATH9K_PM_AWAKE);
+		ath9k_setpower(sc, ATH9K_PM_AWAKE);
 
 	/* cleanup tx queues */
 	for (i = 0; i < ATH9K_NUM_TX_QUEUES; i++)
@@ -2415,7 +2415,7 @@ static void ath9k_stop(struct ieee80211_hw *hw)
 	/* disable HAL and put h/w to sleep */
 	ath9k_hw_disable(ah);
 	ath9k_hw_configpcipowersave(ah, 1);
-	ath9k_hw_setpower(ah, ATH9K_PM_FULL_SLEEP);
+	ath9k_setpower(sc, ATH9K_PM_FULL_SLEEP);
 
 	sc->sc_flags |= SC_OP_INVALID;
 
@@ -2587,7 +2587,7 @@ static int ath9k_config(struct ieee80211_hw *hw, u32 changed)
 			sc->ps_enabled = true;
 		} else {
 			sc->ps_enabled = false;
-			ath9k_hw_setpower(sc->sc_ah, ATH9K_PM_AWAKE);
+			ath9k_setpower(sc, ATH9K_PM_AWAKE);
 			if (!(ah->caps.hw_caps &
 			      ATH9K_HW_CAP_AUTOSLEEP)) {
 				ath9k_hw_setrxabort(sc->sc_ah, 0);
-- 
1.6.3.3

