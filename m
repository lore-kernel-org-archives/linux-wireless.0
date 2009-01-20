Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.231]:45512 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751550AbZATF5Z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Jan 2009 00:57:25 -0500
Received: by rv-out-0506.google.com with SMTP id k40so2966208rvb.1
        for <linux-wireless@vger.kernel.org>; Mon, 19 Jan 2009 21:57:24 -0800 (PST)
Date: Tue, 20 Jan 2009 11:17:08 +0530
From: Vivek Natarajan <vivek.natraj@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH v4] ath9k: Enable dynamic power save in ath9k.
Message-ID: <20090120054708.GA3679@myhost.users.atheros.com> (sfid-20090120_065739_838614_D483F5C7)
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
index 3817645..0b305b8 100644
--- a/drivers/net/wireless/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath9k/ath9k.h
@@ -793,6 +793,8 @@ struct ath_hal {
 	u16 ah_currentRD5G;
 	u16 ah_currentRD2G;
 	char ah_iso[4];
+	enum ath9k_power_mode ah_power_mode;
+	enum ath9k_power_mode ah_restore_mode;
 
 	struct ath9k_channel ah_channels[150];
 	struct ath9k_channel *ah_curchan;
diff --git a/drivers/net/wireless/ath9k/core.h b/drivers/net/wireless/ath9k/core.h
index f65933d..0f50767 100644
--- a/drivers/net/wireless/ath9k/core.h
+++ b/drivers/net/wireless/ath9k/core.h
@@ -676,6 +676,7 @@ enum PROT_MODE {
 #define SC_OP_RFKILL_REGISTERED	BIT(11)
 #define SC_OP_RFKILL_SW_BLOCKED	BIT(12)
 #define SC_OP_RFKILL_HW_BLOCKED	BIT(13)
+#define SC_OP_WAIT_FOR_BEACON	BIT(14)
 
 struct ath_bus_ops {
 	void		(*read_cachesize)(struct ath_softc *sc, int *csz);
@@ -709,6 +710,7 @@ struct ath_softc {
 	u32 sc_keymax;
 	DECLARE_BITMAP(sc_keymap, ATH_KEYMAX);
 	u8 sc_splitmic;
+	atomic_t ps_usecount;
 	enum ath9k_int sc_imask;
 	enum PROT_MODE sc_protmode;
 	enum ath9k_ht_extprotspacing sc_ht_extprotspacing;
@@ -777,4 +779,20 @@ static inline int ath_ahb_init(void) { return 0; };
 static inline void ath_ahb_exit(void) {};
 #endif
 
+static inline void ath9k_ps_wakeup(struct ath_softc *sc)
+{
+	if (atomic_inc_return(&sc->ps_usecount) == 1)
+		if (sc->sc_ah->ah_power_mode !=  ATH9K_PM_AWAKE) {
+			sc->sc_ah->ah_restore_mode = sc->sc_ah->ah_power_mode;
+			ath9k_hw_setpower(sc->sc_ah, ATH9K_PM_AWAKE);
+		}
+}
+
+static inline void ath9k_ps_restore(struct ath_softc *sc)
+{
+	if (atomic_dec_and_test(&sc->ps_usecount))
+		if (sc->hw->conf.flags & IEEE80211_CONF_PS)
+			ath9k_hw_setpower(sc->sc_ah,
+					  sc->sc_ah->ah_restore_mode);
+}
 #endif /* CORE_H */
diff --git a/drivers/net/wireless/ath9k/hw.c b/drivers/net/wireless/ath9k/hw.c
index 88c8a62..ab15e55 100644
--- a/drivers/net/wireless/ath9k/hw.c
+++ b/drivers/net/wireless/ath9k/hw.c
@@ -2698,7 +2698,7 @@ bool ath9k_hw_setpower(struct ath_hal *ah,
 	int status = true, setChip = true;
 
 	DPRINTF(ah->ah_sc, ATH_DBG_POWER_MGMT, "%s -> %s (%s)\n",
-		modes[ahp->ah_powerMode], modes[mode],
+		modes[ah->ah_power_mode], modes[mode],
 		setChip ? "set chip " : "");
 
 	switch (mode) {
@@ -2717,7 +2717,7 @@ bool ath9k_hw_setpower(struct ath_hal *ah,
 			"Unknown power mode %u\n", mode);
 		return false;
 	}
-	ahp->ah_powerMode = mode;
+	ah->ah_power_mode = mode;
 
 	return status;
 }
diff --git a/drivers/net/wireless/ath9k/hw.h b/drivers/net/wireless/ath9k/hw.h
index d44e016..087c571 100644
--- a/drivers/net/wireless/ath9k/hw.h
+++ b/drivers/net/wireless/ath9k/hw.h
@@ -844,7 +844,6 @@ struct ath_hal_5416 {
 	bool ah_chipFullSleep;
 	u32 ah_atimWindow;
 	u16 ah_antennaSwitchSwap;
-	enum ath9k_power_mode ah_powerMode;
 	enum ath9k_ant_setting ah_diversityControl;
 
 	/* Calibration */
diff --git a/drivers/net/wireless/ath9k/main.c b/drivers/net/wireless/ath9k/main.c
index 8ad927a..b494a0d 100644
--- a/drivers/net/wireless/ath9k/main.c
+++ b/drivers/net/wireless/ath9k/main.c
@@ -237,6 +237,8 @@ static int ath_set_channel(struct ath_softc *sc, struct ath9k_channel *hchan)
 	if (sc->sc_flags & SC_OP_INVALID)
 		return -EIO;
 
+	ath9k_ps_wakeup(sc);
+
 	/*
 	 * This is only performed if the channel settings have
 	 * actually changed.
@@ -287,6 +289,7 @@ static int ath_set_channel(struct ath_softc *sc, struct ath9k_channel *hchan)
 	ath_cache_conf_rate(sc, &hw->conf);
 	ath_update_txpow(sc);
 	ath9k_hw_set_interrupts(ah, sc->sc_imask);
+	ath9k_ps_restore(sc);
 	return 0;
 }
 
@@ -559,8 +562,10 @@ irqreturn_t ath_isr(int irq, void *dev)
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
@@ -1044,6 +1049,7 @@ static void ath_radio_enable(struct ath_softc *sc)
 	struct ieee80211_channel *channel = sc->hw->conf.channel;
 	int r;
 
+	ath9k_ps_wakeup(sc);
 	spin_lock_bh(&sc->sc_resetlock);
 
 	r = ath9k_hw_reset(ah, ah->ah_curchan, false);
@@ -1075,6 +1081,7 @@ static void ath_radio_enable(struct ath_softc *sc)
 	ath9k_hw_set_gpio(ah, ATH_LED_PIN, 0);
 
 	ieee80211_wake_queues(sc->hw);
+	ath9k_ps_restore(sc);
 }
 
 static void ath_radio_disable(struct ath_softc *sc)
@@ -1083,6 +1090,7 @@ static void ath_radio_disable(struct ath_softc *sc)
 	struct ieee80211_channel *channel = sc->hw->conf.channel;
 	int r;
 
+	ath9k_ps_wakeup(sc);
 	ieee80211_stop_queues(sc->hw);
 
 	/* Disable LED */
@@ -1108,6 +1116,7 @@ static void ath_radio_disable(struct ath_softc *sc)
 
 	ath9k_hw_phy_disable(ah);
 	ath9k_hw_setpower(ah, ATH9K_PM_FULL_SLEEP);
+	ath9k_ps_restore(sc);
 }
 
 static bool ath_is_rfkill_set(struct ath_softc *sc)
@@ -1259,6 +1268,8 @@ void ath_detach(struct ath_softc *sc)
 	struct ieee80211_hw *hw = sc->hw;
 	int i = 0;
 
+	ath9k_ps_wakeup(sc);
+
 	DPRINTF(sc, ATH_DBG_CONFIG, "Detach ATH hw\n");
 
 #if defined(CONFIG_RFKILL) || defined(CONFIG_RFKILL_MODULE)
@@ -1283,6 +1294,7 @@ void ath_detach(struct ath_softc *sc)
 
 	ath9k_hw_detach(sc->sc_ah);
 	ath9k_exit_debug(sc);
+	ath9k_ps_restore(sc);
 }
 
 static int ath_init(u16 devid, struct ath_softc *sc)
@@ -1526,7 +1538,9 @@ int ath_attach(u16 devid, struct ath_softc *sc)
 	hw->flags = IEEE80211_HW_RX_INCLUDES_FCS |
 		IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING |
 		IEEE80211_HW_SIGNAL_DBM |
-		IEEE80211_HW_AMPDU_AGGREGATION;
+		IEEE80211_HW_AMPDU_AGGREGATION |
+		IEEE80211_HW_SUPPORTS_PS |
+		IEEE80211_HW_PS_NULLFUNC_STACK;
 
 	if (AR_SREV_9160_10_OR_LATER(sc->sc_ah))
 		hw->flags |= IEEE80211_HW_MFP_CAPABLE;
@@ -2090,6 +2104,27 @@ static int ath9k_config(struct ieee80211_hw *hw, u32 changed)
 	struct ieee80211_conf *conf = &hw->conf;
 
 	mutex_lock(&sc->mutex);
+	if (changed & IEEE80211_CONF_CHANGE_PS) {
+		if (conf->flags & IEEE80211_CONF_PS) {
+			if ((sc->sc_imask & ATH9K_INT_TIM_TIMER) == 0) {
+				sc->sc_imask |= ATH9K_INT_TIM_TIMER;
+				ath9k_hw_set_interrupts(sc->sc_ah,
+						sc->sc_imask);
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
+						sc->sc_imask);
+			}
+		}
+	}
+
 	if (changed & IEEE80211_CONF_CHANGE_CHANNEL) {
 		struct ieee80211_channel *curchan = hw->conf.channel;
 		int pos;
@@ -2310,6 +2345,7 @@ static int ath9k_set_key(struct ieee80211_hw *hw,
 	struct ath_softc *sc = hw->priv;
 	int ret = 0;
 
+	ath9k_ps_wakeup(sc);
 	DPRINTF(sc, ATH_DBG_KEYCACHE, "Set HW Key\n");
 
 	switch (cmd) {
@@ -2333,6 +2369,7 @@ static int ath9k_set_key(struct ieee80211_hw *hw,
 		ret = -EINVAL;
 	}
 
+	ath9k_ps_restore(sc);
 	return ret;
 }
 
diff --git a/drivers/net/wireless/ath9k/recv.c b/drivers/net/wireless/ath9k/recv.c
index 648bb49..8da08f9 100644
--- a/drivers/net/wireless/ath9k/recv.c
+++ b/drivers/net/wireless/ath9k/recv.c
@@ -628,6 +628,12 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush)
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

