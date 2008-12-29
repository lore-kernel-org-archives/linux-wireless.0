Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.234]:48415 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751354AbYL2PJv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Dec 2008 10:09:51 -0500
Received: by rv-out-0506.google.com with SMTP id k40so4410190rvb.1
        for <linux-wireless@vger.kernel.org>; Mon, 29 Dec 2008 07:09:50 -0800 (PST)
Date: Mon, 29 Dec 2008 20:29:20 +0530
From: Vivek Natarajan <vivek.natraj@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH v3] ath9k: Enable dynamic power save in ath9k.
Message-ID: <20081229145920.GC2914@myhost.users.atheros.com> (sfid-20081229_160956_593705_6749BCC7)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch implements dynamic power save feature for ath9k.

Signed-off-by: Vivek Natarajan <vnatarajan@atheros.com>
---
 drivers/net/wireless/ath9k/ath9k.h |    2 +
 drivers/net/wireless/ath9k/core.h  |   18 ++++++++++++++++
 drivers/net/wireless/ath9k/hw.c    |    4 +-
 drivers/net/wireless/ath9k/hw.h    |    1 -
 drivers/net/wireless/ath9k/main.c  |   39 +++++++++++++++++++++++++++++++++++-
 drivers/net/wireless/ath9k/recv.c  |    6 +++++
 6 files changed, 66 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath9k/ath9k.h b/drivers/net/wireless/ath9k/ath9k.h
index d278135..c59e916 100644
--- a/drivers/net/wireless/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath9k/ath9k.h
@@ -790,6 +790,8 @@ struct ath_hal {
 	u16 ah_currentRD5G;
 	u16 ah_currentRD2G;
 	char ah_iso[4];
+	enum ath9k_power_mode ah_powerMode;
+	enum ath9k_power_mode ah_restoreMode;
 
 	struct ath9k_channel ah_channels[150];
 	struct ath9k_channel *ah_curchan;
diff --git a/drivers/net/wireless/ath9k/core.h b/drivers/net/wireless/ath9k/core.h
index 4ca2aed..98c7406 100644
--- a/drivers/net/wireless/ath9k/core.h
+++ b/drivers/net/wireless/ath9k/core.h
@@ -692,6 +692,7 @@ enum PROT_MODE {
 #define SC_OP_RFKILL_REGISTERED	BIT(11)
 #define SC_OP_RFKILL_SW_BLOCKED	BIT(12)
 #define SC_OP_RFKILL_HW_BLOCKED	BIT(13)
+#define SC_OP_WAIT_FOR_BEACON	BIT(14)
 
 struct ath_softc {
 	struct ieee80211_hw *hw;
@@ -719,6 +720,8 @@ struct ath_softc {
 	DECLARE_BITMAP(sc_keymap, ATH_KEYMAX);
 	u8 sc_splitmic;
 	u8 sc_protrix;
+	atomic_t ps_usecount;
+
 	enum ath9k_int sc_imask;
 	enum PROT_MODE sc_protmode;
 	enum ath9k_ht_extprotspacing sc_ht_extprotspacing;
@@ -751,4 +754,19 @@ int ath_get_hal_qnum(u16 queue, struct ath_softc *sc);
 int ath_get_mac80211_qnum(u32 queue, struct ath_softc *sc);
 int ath_cabq_update(struct ath_softc *);
 
+static inline void ath9k_ps_wakeup(struct ath_softc *sc)
+{
+	if (atomic_inc_return(&sc->ps_usecount) == 1)
+		if (sc->sc_ah->ah_powerMode !=  ATH9K_PM_AWAKE) {
+			sc->sc_ah->ah_restoreMode = sc->sc_ah->ah_powerMode;
+			ath9k_hw_setpower(sc->sc_ah, ATH9K_PM_AWAKE);
+		}
+}
+
+static inline void ath9k_ps_restore(struct ath_softc *sc)
+{
+	if (atomic_dec_and_test(&sc->ps_usecount))
+		if (sc->hw->conf.flags & IEEE80211_CONF_PS)
+			ath9k_hw_setpower(sc->sc_ah, sc->sc_ah->ah_restoreMode);
+}
 #endif /* CORE_H */
diff --git a/drivers/net/wireless/ath9k/hw.c b/drivers/net/wireless/ath9k/hw.c
index d2b0ecf..2da737c 100644
--- a/drivers/net/wireless/ath9k/hw.c
+++ b/drivers/net/wireless/ath9k/hw.c
@@ -2735,7 +2735,7 @@ bool ath9k_hw_setpower(struct ath_hal *ah,
 	int status = true, setChip = true;
 
 	DPRINTF(ah->ah_sc, ATH_DBG_POWER_MGMT, "%s -> %s (%s)\n",
-		modes[ahp->ah_powerMode], modes[mode],
+		modes[ah->ah_powerMode], modes[mode],
 		setChip ? "set chip " : "");
 
 	switch (mode) {
@@ -2754,7 +2754,7 @@ bool ath9k_hw_setpower(struct ath_hal *ah,
 			"Unknown power mode %u\n", mode);
 		return false;
 	}
-	ahp->ah_powerMode = mode;
+	ah->ah_powerMode = mode;
 
 	return status;
 }
diff --git a/drivers/net/wireless/ath9k/hw.h b/drivers/net/wireless/ath9k/hw.h
index 91d8f59..17608c5 100644
--- a/drivers/net/wireless/ath9k/hw.h
+++ b/drivers/net/wireless/ath9k/hw.h
@@ -830,7 +830,6 @@ struct ath_hal_5416 {
 	bool ah_chipFullSleep;
 	u32 ah_atimWindow;
 	u16 ah_antennaSwitchSwap;
-	enum ath9k_power_mode ah_powerMode;
 	enum ath9k_ant_setting ah_diversityControl;
 
 	/* Calibration */
diff --git a/drivers/net/wireless/ath9k/main.c b/drivers/net/wireless/ath9k/main.c
index 70affb7..ac32f8e 100644
--- a/drivers/net/wireless/ath9k/main.c
+++ b/drivers/net/wireless/ath9k/main.c
@@ -262,6 +262,8 @@ static int ath_set_channel(struct ath_softc *sc, struct ath9k_channel *hchan)
 	if (sc->sc_flags & SC_OP_INVALID)
 		return -EIO;
 
+	ath9k_ps_wakeup(sc);
+
 	if (hchan->channel != sc->sc_ah->ah_curchan->channel ||
 	    hchan->channelFlags != sc->sc_ah->ah_curchan->channelFlags ||
 	    (sc->sc_flags & SC_OP_CHAINMASK_UPDATE) ||
@@ -313,6 +315,7 @@ static int ath_set_channel(struct ath_softc *sc, struct ath9k_channel *hchan)
 		if (ath_startrecv(sc) != 0) {
 			DPRINTF(sc, ATH_DBG_FATAL,
 				"Unable to restart recv logic\n");
+			ath9k_ps_restore(sc);
 			return -EIO;
 		}
 
@@ -320,6 +323,7 @@ static int ath_set_channel(struct ath_softc *sc, struct ath9k_channel *hchan)
 		ath_update_txpow(sc);
 		ath9k_hw_set_interrupts(ah, sc->sc_imask);
 	}
+	ath9k_ps_restore(sc);
 	return 0;
 }
 
@@ -591,8 +595,10 @@ static irqreturn_t ath_isr(int irq, void *dev)
 				      ATH9K_HW_CAP_AUTOSLEEP)) {
 					/* Clear RxAbort bit so that we can
 					 * receive frames */
+					ath9k_hw_setpower(ah, ATH9K_PM_AWAKE);
 					ath9k_hw_setrxabort(ah, 0);
 					sched = true;
+					sc->sc_flags |= SC_OP_WAIT_FOR_BEACON;
 				}
 			}
 		}
@@ -1071,6 +1077,7 @@ static void ath_radio_enable(struct ath_softc *sc)
 	struct ath_hal *ah = sc->sc_ah;
 	int status;
 
+	ath9k_ps_wakeup(sc);
 	spin_lock_bh(&sc->sc_resetlock);
 	if (!ath9k_hw_reset(ah, ah->ah_curchan,
 			    sc->tx_chan_width,
@@ -1108,6 +1115,7 @@ static void ath_radio_enable(struct ath_softc *sc)
 	ath9k_hw_set_gpio(ah, ATH_LED_PIN, 0);
 
 	ieee80211_wake_queues(sc->hw);
+	ath9k_ps_restore(sc);
 }
 
 static void ath_radio_disable(struct ath_softc *sc)
@@ -1115,7 +1123,7 @@ static void ath_radio_disable(struct ath_softc *sc)
 	struct ath_hal *ah = sc->sc_ah;
 	int status;
 
-
+	ath9k_ps_wakeup(sc);
 	ieee80211_stop_queues(sc->hw);
 
 	/* Disable LED */
@@ -1149,6 +1157,7 @@ static void ath_radio_disable(struct ath_softc *sc)
 
 	ath9k_hw_phy_disable(ah);
 	ath9k_hw_setpower(ah, ATH9K_PM_FULL_SLEEP);
+	ath9k_ps_restore(sc);
 }
 
 static bool ath_is_rfkill_set(struct ath_softc *sc)
@@ -1298,6 +1307,8 @@ static void ath_detach(struct ath_softc *sc)
 	struct ieee80211_hw *hw = sc->hw;
 	int i = 0;
 
+	ath9k_ps_wakeup(sc);
+
 	DPRINTF(sc, ATH_DBG_CONFIG, "Detach ATH hw\n");
 
 #if defined(CONFIG_RFKILL) || defined(CONFIG_RFKILL_MODULE)
@@ -1322,6 +1333,7 @@ static void ath_detach(struct ath_softc *sc)
 
 	ath9k_hw_detach(sc->sc_ah);
 	ath9k_exit_debug(sc);
+	ath9k_ps_restore(sc);
 }
 
 static int ath_init(u16 devid, struct ath_softc *sc)
@@ -2135,6 +2147,27 @@ static int ath9k_config(struct ieee80211_hw *hw, u32 changed)
 	struct ieee80211_conf *conf = &hw->conf;
 
 	mutex_lock(&sc->mutex);
+	if (changed & IEEE80211_CONF_CHANGE_PS) {
+		if (conf->flags & IEEE80211_CONF_PS) {
+			if ((sc->sc_imask & ATH9K_INT_TIM_TIMER) == 0) {
+				sc->sc_imask |= ATH9K_INT_TIM_TIMER;
+				ath9k_hw_set_interrupts(sc->sc_ah,
+							sc->sc_imask);
+			}
+			ath9k_hw_setrxabort(sc->sc_ah, 1);
+			ath9k_hw_setpower(sc->sc_ah, ATH9K_PM_NETWORK_SLEEP);
+		} else {
+			ath9k_hw_setpower(sc->sc_ah, ATH9K_PM_AWAKE);
+			ath9k_hw_setrxabort(sc->sc_ah, 0);
+			sc->sc_flags &= ~SC_OP_WAIT_FOR_BEACON;
+			if (sc->sc_imask & ATH9K_INT_TIM_TIMER) {
+				sc->sc_imask &= ~ATH9K_INT_TIM_TIMER;
+				ath9k_hw_set_interrupts(sc->sc_ah,
+							sc->sc_imask);
+			}
+		}
+	}
+
 	if (changed & (IEEE80211_CONF_CHANGE_CHANNEL |
 		       IEEE80211_CONF_CHANGE_HT)) {
 		struct ieee80211_channel *curchan = hw->conf.channel;
@@ -2359,6 +2392,7 @@ static int ath9k_set_key(struct ieee80211_hw *hw,
 	struct ath_softc *sc = hw->priv;
 	int ret = 0;
 
+	ath9k_ps_wakeup(sc);
 	DPRINTF(sc, ATH_DBG_KEYCACHE, "Set HW Key\n");
 
 	switch (cmd) {
@@ -2380,6 +2414,7 @@ static int ath9k_set_key(struct ieee80211_hw *hw,
 		ret = -EINVAL;
 	}
 
+	ath9k_ps_restore(sc);
 	return ret;
 }
 
@@ -2443,6 +2478,7 @@ static int ath9k_ampdu_action(struct ieee80211_hw *hw,
 	struct ath_softc *sc = hw->priv;
 	int ret = 0;
 
+	ath9k_ps_wakeup(sc);
 	switch (action) {
 	case IEEE80211_AMPDU_RX_START:
 		if (!(sc->sc_flags & SC_OP_RXAGGR))
@@ -2472,6 +2508,7 @@ static int ath9k_ampdu_action(struct ieee80211_hw *hw,
 	default:
 		DPRINTF(sc, ATH_DBG_FATAL, "Unknown AMPDU action\n");
 	}
+	ath9k_ps_restore(sc);
 
 	return ret;
 }
diff --git a/drivers/net/wireless/ath9k/recv.c b/drivers/net/wireless/ath9k/recv.c
index 462e08c..35d9209 100644
--- a/drivers/net/wireless/ath9k/recv.c
+++ b/drivers/net/wireless/ath9k/recv.c
@@ -622,6 +622,12 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush)
 		} else {
 			sc->rx.rxotherant = 0;
 		}
+
+		if (ieee80211_is_beacon(hdr->frame_control) &&
+				(sc->sc_flags & SC_OP_WAIT_FOR_BEACON)) {
+			sc->sc_flags &= ~SC_OP_WAIT_FOR_BEACON;
+			ath9k_hw_setpower(sc->sc_ah, ATH9K_PM_NETWORK_SLEEP);
+		}
 requeue:
 		list_move_tail(&bf->list, &sc->rx.rxbuf);
 		ath_rx_buf_link(sc, bf);
-- 
1.6.0.1

