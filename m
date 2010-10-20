Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:14861 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756169Ab0JTXHR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Oct 2010 19:07:17 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 20 Oct 2010 16:07:07 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>, <stable@kernel.org>,
	Ben Greear <greearb@candelatech.com>,
	Kyungwan Nam <kyungwan.nam@atheros.com>
Subject: [PATCH 4/6] ath9k: lock reset and PCU start/stopping
Date: Wed, 20 Oct 2010 16:07:06 -0700
Message-ID: <1287616028-12547-5-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1287616028-12547-1-git-send-email-lrodriguez@atheros.com>
References: <1287616028-12547-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Apart from locking the start and stop PCU we need
to ensure we also content starting and stopping the PCU
between hardware resets.

This is part of a series that will help resolve the bug:

https://bugzilla.kernel.org/show_bug.cgi?id=14624

For more details about this issue refer to:

http://marc.info/?l=linux-wireless&m=128629803703756&w=2

Cc: stable@kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Cc: Kyungwan Nam <kyungwan.nam@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/main.c |   27 +++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/recv.c |    2 --
 2 files changed, 27 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 37f18ef..dac11eb 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -238,6 +238,9 @@ int ath_set_channel(struct ath_softc *sc, struct ieee80211_hw *hw,
 	 */
 	ath9k_hw_disable_interrupts(ah);
 	ath_drain_all_txq(sc, false);
+
+	spin_lock_bh(&sc->rx.pcu_lock);
+
 	stopped = ath_stoprecv(sc);
 
 	/* XXX: do not flush receive queue here. We don't want
@@ -265,6 +268,7 @@ int ath_set_channel(struct ath_softc *sc, struct ieee80211_hw *hw,
 			  "reset status %d\n",
 			  channel->center_freq, r);
 		spin_unlock_bh(&sc->sc_resetlock);
+		spin_unlock_bh(&sc->rx.pcu_lock);
 		goto ps_restore;
 	}
 	spin_unlock_bh(&sc->sc_resetlock);
@@ -273,9 +277,12 @@ int ath_set_channel(struct ath_softc *sc, struct ieee80211_hw *hw,
 		ath_print(common, ATH_DBG_FATAL,
 			  "Unable to restart recv logic\n");
 		r = -EIO;
+		spin_unlock_bh(&sc->rx.pcu_lock);
 		goto ps_restore;
 	}
 
+	spin_unlock_bh(&sc->rx.pcu_lock);
+
 	ath_update_txpow(sc);
 	ath9k_hw_set_interrupts(ah, ah->imask);
 
@@ -875,6 +882,7 @@ void ath_radio_enable(struct ath_softc *sc, struct ieee80211_hw *hw)
 	if (!ah->curchan)
 		ah->curchan = ath_get_curchannel(sc, sc->hw);
 
+	spin_lock_bh(&sc->rx.pcu_lock);
 	spin_lock_bh(&sc->sc_resetlock);
 	r = ath9k_hw_reset(ah, ah->curchan, ah->caldata, false);
 	if (r) {
@@ -889,8 +897,10 @@ void ath_radio_enable(struct ath_softc *sc, struct ieee80211_hw *hw)
 	if (ath_startrecv(sc) != 0) {
 		ath_print(common, ATH_DBG_FATAL,
 			  "Unable to restart recv logic\n");
+		spin_unlock_bh(&sc->rx.pcu_lock);
 		return;
 	}
+	spin_unlock_bh(&sc->rx.pcu_lock);
 
 	if (sc->sc_flags & SC_OP_BEACONS)
 		ath_beacon_config(sc, NULL);	/* restart beacons */
@@ -929,6 +939,9 @@ void ath_radio_disable(struct ath_softc *sc, struct ieee80211_hw *hw)
 	ath9k_hw_disable_interrupts(ah);
 
 	ath_drain_all_txq(sc, false);	/* clear pending tx frames */
+
+	spin_lock_bh(&sc->rx.pcu_lock);
+
 	ath_stoprecv(sc);		/* turn off frame recv */
 	ath_flushrecv(sc);		/* flush recv queue */
 
@@ -946,6 +959,9 @@ void ath_radio_disable(struct ath_softc *sc, struct ieee80211_hw *hw)
 	spin_unlock_bh(&sc->sc_resetlock);
 
 	ath9k_hw_phy_disable(ah);
+
+	spin_unlock_bh(&sc->rx.pcu_lock);
+
 	ath9k_hw_configpcipowersave(ah, 1, 1);
 	ath9k_ps_restore(sc);
 	ath9k_setpower(sc, ATH9K_PM_FULL_SLEEP);
@@ -965,6 +981,9 @@ int ath_reset(struct ath_softc *sc, bool retry_tx)
 
 	ath9k_hw_disable_interrupts(ah);
 	ath_drain_all_txq(sc, retry_tx);
+
+	spin_lock_bh(&sc->rx.pcu_lock);
+
 	ath_stoprecv(sc);
 	ath_flushrecv(sc);
 
@@ -979,6 +998,8 @@ int ath_reset(struct ath_softc *sc, bool retry_tx)
 		ath_print(common, ATH_DBG_FATAL,
 			  "Unable to start recv logic\n");
 
+	spin_unlock_bh(&sc->rx.pcu_lock);
+
 	/*
 	 * We may be doing a reset in response to a request
 	 * that changes the channel so update any state that
@@ -1141,6 +1162,7 @@ static int ath9k_start(struct ieee80211_hw *hw)
 	 * be followed by initialization of the appropriate bits
 	 * and then setup of the interrupt mask.
 	 */
+	spin_lock_bh(&sc->rx.pcu_lock);
 	spin_lock_bh(&sc->sc_resetlock);
 	r = ath9k_hw_reset(ah, init_channel, ah->caldata, false);
 	if (r) {
@@ -1149,6 +1171,7 @@ static int ath9k_start(struct ieee80211_hw *hw)
 			  "(freq %u MHz)\n", r,
 			  curchan->center_freq);
 		spin_unlock_bh(&sc->sc_resetlock);
+		spin_unlock_bh(&sc->rx.pcu_lock);
 		goto mutex_unlock;
 	}
 	spin_unlock_bh(&sc->sc_resetlock);
@@ -1170,8 +1193,10 @@ static int ath9k_start(struct ieee80211_hw *hw)
 		ath_print(common, ATH_DBG_FATAL,
 			  "Unable to start recv logic\n");
 		r = -EIO;
+		spin_unlock_bh(&sc->rx.pcu_lock);
 		goto mutex_unlock;
 	}
+	spin_unlock_bh(&sc->rx.pcu_lock);
 
 	/* Setup our intr mask. */
 	ah->imask = ATH9K_INT_TX | ATH9K_INT_RXEOL |
@@ -1370,12 +1395,14 @@ static void ath9k_stop(struct ieee80211_hw *hw)
 	 * before setting the invalid flag. */
 	ath9k_hw_disable_interrupts(ah);
 
+	spin_lock_bh(&sc->rx.pcu_lock);
 	if (!(sc->sc_flags & SC_OP_INVALID)) {
 		ath_drain_all_txq(sc, false);
 		ath_stoprecv(sc);
 		ath9k_hw_phy_disable(ah);
 	} else
 		sc->rx.rxlink = NULL;
+	spin_unlock_bh(&sc->rx.pcu_lock);
 
 	/* disable HAL and put h/w to sleep */
 	ath9k_hw_disable(ah);
diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index b099827..c04a940 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -533,13 +533,11 @@ bool ath_stoprecv(struct ath_softc *sc)
 
 void ath_flushrecv(struct ath_softc *sc)
 {
-	spin_lock_bh(&sc->rx.pcu_lock);
 	sc->sc_flags |= SC_OP_RXFLUSH;
 	if (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_EDMA)
 		ath_rx_tasklet(sc, 1, true);
 	ath_rx_tasklet(sc, 1, false);
 	sc->sc_flags &= ~SC_OP_RXFLUSH;
-	spin_unlock_bh(&sc->rx.pcu_lock);
 }
 
 static bool ath_beacon_dtim_pending_cab(struct sk_buff *skb)
-- 
1.7.0.4

