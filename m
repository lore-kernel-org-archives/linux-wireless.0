Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:19647 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757691Ab0JZW1d (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Oct 2010 18:27:33 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 26 Oct 2010 15:27:22 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <greearb@candelatech.com>,
	<kyungwan.nam@atheros.com>, <amod.bodas@atheros.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>, <stable@kernel.org>
Subject: [PATCH 3/3] ath9k: content DMA start / stop through the PCU lock
Date: Tue, 26 Oct 2010 15:27:25 -0700
Message-ID: <1288132045-4718-4-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1288132045-4718-1-git-send-email-lrodriguez@atheros.com>
References: <1288132045-4718-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This helps align resets / RX enable & disable / TX stop / start.
Locking around the PCU is important to ensure the hardware doesn't
get stale data when working with DMA'able data.

This is part of a series of patches which fix stopping
TX DMA completley when requested on the driver.
For more details about this issue refer to this thread:

http://marc.info/?l=linux-wireless&m=128629803703756&w=2

Tested-by:  Ben Greear <greearb@candelatech.com>
Cc: Kyungwan Nam <kyungwan.nam@atheros.com>
Cc: stable@kernel.org
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/main.c |   52 ++++++++++++++++----------------
 drivers/net/wireless/ath/ath9k/xmit.c |    4 +-
 2 files changed, 28 insertions(+), 28 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 4196336..f494bb2 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -230,6 +230,8 @@ int ath_set_channel(struct ath_softc *sc, struct ieee80211_hw *hw,
 
 	ath9k_ps_wakeup(sc);
 
+	spin_lock_bh(&sc->sc_pcu_lock);
+
 	/*
 	 * This is only performed if the channel settings have
 	 * actually changed.
@@ -242,8 +244,6 @@ int ath_set_channel(struct ath_softc *sc, struct ieee80211_hw *hw,
 	ath9k_hw_set_interrupts(ah, 0);
 	ath_drain_all_txq(sc, false);
 
-	spin_lock_bh(&sc->sc_pcu_lock);
-
 	stopped = ath_stoprecv(sc);
 
 	/* XXX: do not flush receive queue here. We don't want
@@ -268,7 +268,6 @@ int ath_set_channel(struct ath_softc *sc, struct ieee80211_hw *hw,
 			  "Unable to reset channel (%u MHz), "
 			  "reset status %d\n",
 			  channel->center_freq, r);
-		spin_unlock_bh(&sc->sc_pcu_lock);
 		goto ps_restore;
 	}
 
@@ -276,12 +275,9 @@ int ath_set_channel(struct ath_softc *sc, struct ieee80211_hw *hw,
 		ath_print(common, ATH_DBG_FATAL,
 			  "Unable to restart recv logic\n");
 		r = -EIO;
-		spin_unlock_bh(&sc->sc_pcu_lock);
 		goto ps_restore;
 	}
 
-	spin_unlock_bh(&sc->sc_pcu_lock);
-
 	ath_update_txpow(sc);
 	ath9k_hw_set_interrupts(ah, ah->imask);
 
@@ -292,6 +288,8 @@ int ath_set_channel(struct ath_softc *sc, struct ieee80211_hw *hw,
 	}
 
  ps_restore:
+	spin_unlock_bh(&sc->sc_pcu_lock);
+
 	ath9k_ps_restore(sc);
 	return r;
 }
@@ -606,6 +604,8 @@ void ath9k_tasklet(unsigned long data)
 		return;
 	}
 
+	spin_lock_bh(&sc->sc_pcu_lock);
+
 	if (!ath9k_hw_check_alive(ah))
 		ieee80211_queue_work(sc->hw, &sc->hw_check_work);
 
@@ -616,15 +616,12 @@ void ath9k_tasklet(unsigned long data)
 		rxmask = (ATH9K_INT_RX | ATH9K_INT_RXEOL | ATH9K_INT_RXORN);
 
 	if (status & rxmask) {
-		spin_lock_bh(&sc->sc_pcu_lock);
-
 		/* Check for high priority Rx first */
 		if ((ah->caps.hw_caps & ATH9K_HW_CAP_EDMA) &&
 		    (status & ATH9K_INT_RXHP))
 			ath_rx_tasklet(sc, 0, true);
 
 		ath_rx_tasklet(sc, 0, false);
-		spin_unlock_bh(&sc->sc_pcu_lock);
 	}
 
 	if (status & ATH9K_INT_TX) {
@@ -650,6 +647,8 @@ void ath9k_tasklet(unsigned long data)
 
 	/* re-enable hardware interrupt */
 	ath9k_hw_set_interrupts(ah, ah->imask);
+
+	spin_unlock_bh(&sc->sc_pcu_lock);
 	ath9k_ps_restore(sc);
 }
 
@@ -874,12 +873,13 @@ void ath_radio_enable(struct ath_softc *sc, struct ieee80211_hw *hw)
 	int r;
 
 	ath9k_ps_wakeup(sc);
+	spin_lock_bh(&sc->sc_pcu_lock);
+
 	ath9k_hw_configpcipowersave(ah, 0, 0);
 
 	if (!ah->curchan)
 		ah->curchan = ath_get_curchannel(sc, sc->hw);
 
-	spin_lock_bh(&sc->sc_pcu_lock);
 	r = ath9k_hw_reset(ah, ah->curchan, ah->caldata, false);
 	if (r) {
 		ath_print(common, ATH_DBG_FATAL,
@@ -895,8 +895,6 @@ void ath_radio_enable(struct ath_softc *sc, struct ieee80211_hw *hw)
 		spin_unlock_bh(&sc->sc_pcu_lock);
 		return;
 	}
-	spin_unlock_bh(&sc->sc_pcu_lock);
-
 	if (sc->sc_flags & SC_OP_BEACONS)
 		ath_beacon_config(sc, NULL);	/* restart beacons */
 
@@ -909,6 +907,8 @@ void ath_radio_enable(struct ath_softc *sc, struct ieee80211_hw *hw)
 	ath9k_hw_set_gpio(ah, ah->led_pin, 0);
 
 	ieee80211_wake_queues(hw);
+	spin_unlock_bh(&sc->sc_pcu_lock);
+
 	ath9k_ps_restore(sc);
 }
 
@@ -919,6 +919,8 @@ void ath_radio_disable(struct ath_softc *sc, struct ieee80211_hw *hw)
 	int r;
 
 	ath9k_ps_wakeup(sc);
+	spin_lock_bh(&sc->sc_pcu_lock);
+
 	ieee80211_stop_queues(hw);
 
 	/*
@@ -935,8 +937,6 @@ void ath_radio_disable(struct ath_softc *sc, struct ieee80211_hw *hw)
 
 	ath_drain_all_txq(sc, false);	/* clear pending tx frames */
 
-	spin_lock_bh(&sc->sc_pcu_lock);
-
 	ath_stoprecv(sc);		/* turn off frame recv */
 	ath_flushrecv(sc);		/* flush recv queue */
 
@@ -953,10 +953,11 @@ void ath_radio_disable(struct ath_softc *sc, struct ieee80211_hw *hw)
 
 	ath9k_hw_phy_disable(ah);
 
-	spin_unlock_bh(&sc->sc_pcu_lock);
-
 	ath9k_hw_configpcipowersave(ah, 1, 1);
+
+	spin_unlock_bh(&sc->sc_pcu_lock);
 	ath9k_ps_restore(sc);
+
 	ath9k_setpower(sc, ATH9K_PM_FULL_SLEEP);
 }
 
@@ -970,13 +971,13 @@ int ath_reset(struct ath_softc *sc, bool retry_tx)
 	/* Stop ANI */
 	del_timer_sync(&common->ani.timer);
 
+	spin_lock_bh(&sc->sc_pcu_lock);
+
 	ieee80211_stop_queues(hw);
 
 	ath9k_hw_set_interrupts(ah, 0);
 	ath_drain_all_txq(sc, retry_tx);
 
-	spin_lock_bh(&sc->sc_pcu_lock);
-
 	ath_stoprecv(sc);
 	ath_flushrecv(sc);
 
@@ -989,8 +990,6 @@ int ath_reset(struct ath_softc *sc, bool retry_tx)
 		ath_print(common, ATH_DBG_FATAL,
 			  "Unable to start recv logic\n");
 
-	spin_unlock_bh(&sc->sc_pcu_lock);
-
 	/*
 	 * We may be doing a reset in response to a request
 	 * that changes the channel so update any state that
@@ -1015,6 +1014,7 @@ int ath_reset(struct ath_softc *sc, bool retry_tx)
 	}
 
 	ieee80211_wake_queues(hw);
+	spin_unlock_bh(&sc->sc_pcu_lock);
 
 	/* Start ANI */
 	ath_start_ani(common);
@@ -1379,25 +1379,25 @@ static void ath9k_stop(struct ieee80211_hw *hw)
 			ath9k_btcoex_timer_pause(sc);
 	}
 
+	spin_lock_bh(&sc->sc_pcu_lock);
+
 	/* make sure h/w will not generate any interrupt
 	 * before setting the invalid flag. */
 	ath9k_hw_set_interrupts(ah, 0);
 
 	if (!(sc->sc_flags & SC_OP_INVALID)) {
 		ath_drain_all_txq(sc, false);
-		spin_lock_bh(&sc->sc_pcu_lock);
 		ath_stoprecv(sc);
 		ath9k_hw_phy_disable(ah);
-		spin_unlock_bh(&sc->sc_pcu_lock);
-	} else {
-		spin_lock_bh(&sc->sc_pcu_lock);
+	} else
 		sc->rx.rxlink = NULL;
-		spin_unlock_bh(&sc->sc_pcu_lock);
-	}
 
 	/* disable HAL and put h/w to sleep */
 	ath9k_hw_disable(ah);
 	ath9k_hw_configpcipowersave(ah, 1, 1);
+
+	spin_unlock_bh(&sc->sc_pcu_lock);
+
 	ath9k_ps_restore(sc);
 
 	/* Finally, put the chip in FULL SLEEP mode */
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 81f63e52..e1383e5 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -1148,13 +1148,11 @@ void ath_drain_all_txq(struct ath_softc *sc, bool retry_tx)
 		ath_print(common, ATH_DBG_FATAL,
 			  "Failed to stop TX DMA. Resetting hardware!\n");
 
-		spin_lock_bh(&sc->sc_pcu_lock);
 		r = ath9k_hw_reset(ah, sc->sc_ah->curchan, ah->caldata, false);
 		if (r)
 			ath_print(common, ATH_DBG_FATAL,
 				  "Unable to reset hardware; reset status %d\n",
 				  r);
-		spin_unlock_bh(&sc->sc_pcu_lock);
 	}
 
 	for (i = 0; i < ATH9K_NUM_TX_QUEUES; i++) {
-- 
1.7.3.2.90.gd4c43

