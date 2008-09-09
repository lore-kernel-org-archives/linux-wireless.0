Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:39339 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751956AbYIIPjt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Sep 2008 11:39:49 -0400
Date: Tue, 9 Sep 2008 21:04:22 +0530
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Jouni Malinen <Jouni.Malinen@Atheros.com>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>
Subject: [PATCH] ath9k: Add RF kill support
Message-ID: <20080909153422.GA7651@vasanth-lnx.users.atheros.com> (sfid-20080909_173954_277503_9881BAF1)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This support is compiled in if CONFIG_RFKILL
option is set.

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 drivers/net/wireless/ath9k/Kconfig |    1 +
 drivers/net/wireless/ath9k/ath9k.h |    9 +-
 drivers/net/wireless/ath9k/core.h  |   24 +
 drivers/net/wireless/ath9k/hw.c    |   70 ++-
 drivers/net/wireless/ath9k/hw.h    |    2 -
 drivers/net/wireless/ath9k/main.c  | 1205 ++++++++++++++++++++++--------------
 6 files changed, 808 insertions(+), 503 deletions(-)

diff --git a/drivers/net/wireless/ath9k/Kconfig b/drivers/net/wireless/ath9k/Kconfig
index 80a6924..9358e9a 100644
--- a/drivers/net/wireless/ath9k/Kconfig
+++ b/drivers/net/wireless/ath9k/Kconfig
@@ -4,6 +4,7 @@ config ATH9K
 	select MAC80211_LEDS
 	select LEDS_CLASS
 	select NEW_LEDS
+	select RFKILL
 	---help---
 	  This module adds support for wireless adapters based on
 	  Atheros IEEE 802.11n AR5008 and AR9001 family of chipsets.
diff --git a/drivers/net/wireless/ath9k/ath9k.h b/drivers/net/wireless/ath9k/ath9k.h
index 28b8d84..d92e1ed 100644
--- a/drivers/net/wireless/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath9k/ath9k.h
@@ -798,10 +798,13 @@ struct ath_hal {
 	struct ath9k_channel *ah_curchan;
 	u32 ah_nchan;
 
-	u16 ah_rfsilent;
-	bool ah_rfkillEnabled;
 	bool ah_isPciExpress;
 	u16 ah_txTrigLevel;
+#ifdef CONFIG_RFKILL
+	u16 ah_rfsilent;
+	u32 ah_rfkill_gpio ;
+	u32 ah_rfkill_polarity;
+#endif
 
 #ifndef ATH_NF_PER_CHAN
 	struct ath9k_nfcal_hist nfCalHist[NUM_NF_READINGS];
@@ -1003,4 +1006,6 @@ bool ath9k_get_channel_edges(struct ath_hal *ah,
 void ath9k_hw_cfg_output(struct ath_hal *ah, u32 gpio,
 			u32 ah_signal_type);
 void ath9k_hw_set_gpio(struct ath_hal *ah, u32 gpio, u32 value);
+u32 ath9k_hw_gpio_get(struct ath_hal *ah, u32 gpio);
+void ath9k_hw_cfg_gpio_input(struct ath_hal *ah, u32 gpio);
 #endif
diff --git a/drivers/net/wireless/ath9k/core.h b/drivers/net/wireless/ath9k/core.h
index 1faa1ef..aae5a4f 100644
--- a/drivers/net/wireless/ath9k/core.h
+++ b/drivers/net/wireless/ath9k/core.h
@@ -40,6 +40,9 @@
 #include <asm/page.h>
 #include <net/mac80211.h>
 #include <linux/leds.h>
+#ifdef CONFIG_RFKILL
+#include <linux/rfkill.h>
+#endif
 
 #include "ath9k.h"
 #include "rc.h"
@@ -823,6 +826,17 @@ struct ath_led {
 	bool registered;
 };
 
+#ifdef CONFIG_RFKILL
+/* Rfkill */
+#define ATH_RFKILL_POLL_INTERVAL	2000 /* msecs */
+
+struct ath_rfkill {
+	struct rfkill *rfkill;
+	struct delayed_work rfkill_poll;
+	char rfkill_name[32];
+};
+#endif
+
 /********************/
 /* Main driver core */
 /********************/
@@ -906,6 +920,11 @@ struct ath_ht_info {
 #define SC_OP_PROTECT_ENABLE	BIT(8)
 #define SC_OP_RXFLUSH		BIT(9)
 #define SC_OP_LED_ASSOCIATED	BIT(10)
+#ifdef CONFIG_RFKILL
+#define SC_OP_RFKILL_REGISTERED	BIT(11)
+#define SC_OP_RFKILL_SW_BLOCKED	BIT(12)
+#define SC_OP_RFKILL_HW_BLOCKED	BIT(13)
+#endif
 
 struct ath_softc {
 	struct ieee80211_hw *hw;
@@ -1015,6 +1034,11 @@ struct ath_softc {
 	struct ath_led assoc_led;
 	struct ath_led tx_led;
 	struct ath_led rx_led;
+
+#ifdef CONFIG_RFKILL
+	/* Rfkill */
+	struct ath_rfkill rf_kill;
+#endif
 };
 
 int ath_init(u16 devid, struct ath_softc *sc);
diff --git a/drivers/net/wireless/ath9k/hw.c b/drivers/net/wireless/ath9k/hw.c
index 4ccbbc0..0251e59 100644
--- a/drivers/net/wireless/ath9k/hw.c
+++ b/drivers/net/wireless/ath9k/hw.c
@@ -2821,7 +2821,38 @@ void ath9k_hw_set_gpio(struct ath_hal *ah, u32 gpio, u32 val)
 		AR_GPIO_BIT(gpio));
 }
 
-static u32 ath9k_hw_gpio_get(struct ath_hal *ah, u32 gpio)
+/*
+ * Configure GPIO Input lines
+ */
+void ath9k_hw_cfg_gpio_input(struct ath_hal *ah, u32 gpio)
+{
+	u32 gpio_shift;
+
+	ASSERT(gpio < ah->ah_caps.num_gpio_pins);
+
+	gpio_shift = gpio << 1;
+
+	REG_RMW(ah,
+		AR_GPIO_OE_OUT,
+		(AR_GPIO_OE_OUT_DRV_NO << gpio_shift),
+		(AR_GPIO_OE_OUT_DRV << gpio_shift));
+}
+
+#ifdef CONFIG_RFKILL
+static void ath9k_enable_rfkill(struct ath_hal *ah)
+{
+	REG_SET_BIT(ah, AR_GPIO_INPUT_EN_VAL,
+		    AR_GPIO_INPUT_EN_VAL_RFSILENT_BB);
+
+	REG_CLR_BIT(ah, AR_GPIO_INPUT_MUX2,
+		    AR_GPIO_INPUT_MUX2_RFSILENT);
+
+	ath9k_hw_cfg_gpio_input(ah, ah->ah_rfkill_gpio);
+	REG_SET_BIT(ah, AR_PHY_TEST, RFSILENT_BB);
+}
+#endif
+
+u32 ath9k_hw_gpio_get(struct ath_hal *ah, u32 gpio)
 {
 	if (gpio >= ah->ah_caps.num_gpio_pins)
 		return 0xffffffff;
@@ -3034,17 +3065,17 @@ static bool ath9k_hw_fill_cap_info(struct ath_hal *ah)
 
 	pCap->hw_caps |= ATH9K_HW_CAP_ENHANCEDPM;
 
+#ifdef CONFIG_RFKILL
 	ah->ah_rfsilent = ath9k_hw_get_eeprom(ahp, EEP_RF_SILENT);
 	if (ah->ah_rfsilent & EEP_RFSILENT_ENABLED) {
-		ahp->ah_gpioSelect =
+		ah->ah_rfkill_gpio =
 			MS(ah->ah_rfsilent, EEP_RFSILENT_GPIO_SEL);
-		ahp->ah_polarity =
+		ah->ah_rfkill_polarity =
 			MS(ah->ah_rfsilent, EEP_RFSILENT_POLARITY);
 
-		ath9k_hw_setcapability(ah, ATH9K_CAP_RFSILENT, 1, true,
-				       NULL);
 		pCap->hw_caps |= ATH9K_HW_CAP_RFSILENT;
 	}
+#endif
 
 	if ((ah->ah_macVersion == AR_SREV_VERSION_5416_PCI) ||
 	    (ah->ah_macVersion == AR_SREV_VERSION_5416_PCIE) ||
@@ -5961,6 +5992,10 @@ bool ath9k_hw_reset(struct ath_hal *ah,
 	ath9k_hw_init_interrupt_masks(ah, ah->ah_opmode);
 	ath9k_hw_init_qos(ah);
 
+#ifdef CONFIG_RFKILL
+	if (ah->ah_caps.hw_caps & ATH9K_HW_CAP_RFSILENT)
+		ath9k_enable_rfkill(ah);
+#endif
 	ath9k_hw_init_user_settings(ah);
 
 	REG_WRITE(ah, AR_STA_ID1,
@@ -6490,31 +6525,6 @@ ath9k_hw_setbssidmask(struct ath_hal *ah, const u8 *mask)
 	return true;
 }
 
-#ifdef CONFIG_ATH9K_RFKILL
-static void ath9k_enable_rfkill(struct ath_hal *ah)
-{
-	struct ath_hal_5416 *ahp = AH5416(ah);
-
-	REG_SET_BIT(ah, AR_GPIO_INPUT_EN_VAL,
-		    AR_GPIO_INPUT_EN_VAL_RFSILENT_BB);
-
-	REG_CLR_BIT(ah, AR_GPIO_INPUT_MUX2,
-		    AR_GPIO_INPUT_MUX2_RFSILENT);
-
-	ath9k_hw_cfg_gpio_input(ah, ahp->ah_gpioSelect);
-	REG_SET_BIT(ah, AR_PHY_TEST, RFSILENT_BB);
-
-	if (ahp->ah_gpioBit == ath9k_hw_gpio_get(ah, ahp->ah_gpioSelect)) {
-
-		ath9k_hw_set_gpio_intr(ah, ahp->ah_gpioSelect,
-				       !ahp->ah_gpioBit);
-	} else {
-		ath9k_hw_set_gpio_intr(ah, ahp->ah_gpioSelect,
-				       ahp->ah_gpioBit);
-	}
-}
-#endif
-
 void
 ath9k_hw_write_associd(struct ath_hal *ah, const u8 *bssid,
 		       u16 assocId)
diff --git a/drivers/net/wireless/ath9k/hw.h b/drivers/net/wireless/ath9k/hw.h
index 2113818..2134838 100644
--- a/drivers/net/wireless/ath9k/hw.h
+++ b/drivers/net/wireless/ath9k/hw.h
@@ -757,8 +757,6 @@ struct ath_hal_5416 {
 	u32 ah_ctstimeout;
 	u32 ah_globaltxtimeout;
 	u8 ah_gBeaconRate;
-	u32 ah_gpioSelect;
-	u32 ah_polarity;
 	u32 ah_gpioBit;
 
 	/* ANI */
diff --git a/drivers/net/wireless/ath9k/main.c b/drivers/net/wireless/ath9k/main.c
index 57d7cc8..6caecc5 100644
--- a/drivers/net/wireless/ath9k/main.c
+++ b/drivers/net/wireless/ath9k/main.c
@@ -325,6 +325,693 @@ static u8 parse_mpdudensity(u8 mpdudensity)
 	}
 }
 
+#ifdef CONFIG_RFKILL
+/*******************/
+/*	Rfkill	   */
+/*******************/
+
+static void ath_radio_enable(struct ath_softc *sc)
+{
+	struct ath_hal *ah = sc->sc_ah;
+	int status;
+
+	spin_lock_bh(&sc->sc_resetlock);
+	if (!ath9k_hw_reset(ah, ah->ah_curchan,
+			    sc->sc_ht_info.tx_chan_width,
+			    sc->sc_tx_chainmask,
+			    sc->sc_rx_chainmask,
+			    sc->sc_ht_extprotspacing,
+			    false, &status)) {
+		DPRINTF(sc, ATH_DBG_FATAL,
+			"%s: unable to reset channel %u (%uMhz) "
+			"flags 0x%x hal status %u\n", __func__,
+			ath9k_hw_mhz2ieee(ah,
+					  ah->ah_curchan->channel,
+					  ah->ah_curchan->channelFlags),
+			ah->ah_curchan->channel,
+			ah->ah_curchan->channelFlags, status);
+	}
+	spin_unlock_bh(&sc->sc_resetlock);
+
+	ath_update_txpow(sc);
+	if (ath_startrecv(sc) != 0) {
+		DPRINTF(sc, ATH_DBG_FATAL,
+			"%s: unable to restart recv logic\n", __func__);
+		return;
+	}
+
+	if (sc->sc_flags & SC_OP_BEACONS)
+		ath_beacon_config(sc, ATH_IF_ID_ANY);	/* restart beacons */
+
+	/* Re-Enable  interrupts */
+	ath9k_hw_set_interrupts(ah, sc->sc_imask);
+
+	/* Enable LED */
+	ath9k_hw_cfg_output(ah, ATH_LED_PIN,
+			    AR_GPIO_OUTPUT_MUX_AS_OUTPUT);
+	ath9k_hw_set_gpio(ah, ATH_LED_PIN, 0);
+
+	ieee80211_wake_queues(sc->hw);
+}
+
+static void ath_radio_disable(struct ath_softc *sc)
+{
+	struct ath_hal *ah = sc->sc_ah;
+	int status;
+
+
+	ieee80211_stop_queues(sc->hw);
+
+	/* Disable LED */
+	ath9k_hw_set_gpio(ah, ATH_LED_PIN, 1);
+	ath9k_hw_cfg_gpio_input(ah, ATH_LED_PIN);
+
+	/* Disable interrupts */
+	ath9k_hw_set_interrupts(ah, 0);
+
+	ath_draintxq(sc, false);	/* clear pending tx frames */
+	ath_stoprecv(sc);		/* turn off frame recv */
+	ath_flushrecv(sc);		/* flush recv queue */
+
+	spin_lock_bh(&sc->sc_resetlock);
+	if (!ath9k_hw_reset(ah, ah->ah_curchan,
+			    sc->sc_ht_info.tx_chan_width,
+			    sc->sc_tx_chainmask,
+			    sc->sc_rx_chainmask,
+			    sc->sc_ht_extprotspacing,
+			    false, &status)) {
+		DPRINTF(sc, ATH_DBG_FATAL,
+			"%s: unable to reset channel %u (%uMhz) "
+			"flags 0x%x hal status %u\n", __func__,
+			ath9k_hw_mhz2ieee(ah,
+				ah->ah_curchan->channel,
+				ah->ah_curchan->channelFlags),
+			ah->ah_curchan->channel,
+			ah->ah_curchan->channelFlags, status);
+	}
+	spin_unlock_bh(&sc->sc_resetlock);
+
+	ath9k_hw_phy_disable(ah);
+	ath9k_hw_setpower(ah, ATH9K_PM_FULL_SLEEP);
+}
+
+static bool ath_is_rfkill_set(struct ath_softc *sc)
+{
+	struct ath_hal *ah = sc->sc_ah;
+
+	return ath9k_hw_gpio_get(ah, ah->ah_rfkill_gpio) ==
+				  ah->ah_rfkill_polarity;
+}
+
+/* h/w rfkill poll function */
+static void ath_rfkill_poll(struct work_struct *work)
+{
+	struct ath_softc *sc = container_of(work, struct ath_softc,
+					    rf_kill.rfkill_poll.work);
+	bool radio_on;
+
+	if (sc->sc_flags & SC_OP_INVALID)
+		return;
+
+	radio_on = !ath_is_rfkill_set(sc);
+
+	/*
+	 * enable/disable radio only when there is a
+	 * state change in RF switch
+	 */
+	if (radio_on == !!(sc->sc_flags & SC_OP_RFKILL_HW_BLOCKED)) {
+		enum rfkill_state state;
+
+		if (sc->sc_flags & SC_OP_RFKILL_SW_BLOCKED) {
+			state = radio_on ? RFKILL_STATE_SOFT_BLOCKED
+				: RFKILL_STATE_HARD_BLOCKED;
+		} else if (radio_on) {
+			ath_radio_enable(sc);
+			state = RFKILL_STATE_UNBLOCKED;
+		} else {
+			ath_radio_disable(sc);
+			state = RFKILL_STATE_HARD_BLOCKED;
+		}
+
+		if (state == RFKILL_STATE_HARD_BLOCKED)
+			sc->sc_flags |= SC_OP_RFKILL_HW_BLOCKED;
+		else
+			sc->sc_flags &= ~SC_OP_RFKILL_HW_BLOCKED;
+
+		rfkill_force_state(sc->rf_kill.rfkill, state);
+	}
+
+	queue_delayed_work(sc->hw->workqueue, &sc->rf_kill.rfkill_poll,
+			   msecs_to_jiffies(ATH_RFKILL_POLL_INTERVAL));
+}
+
+/* s/w rfkill handler */
+static int ath_sw_toggle_radio(void *data, enum rfkill_state state)
+{
+	struct ath_softc *sc = data;
+
+	switch (state) {
+	case RFKILL_STATE_SOFT_BLOCKED:
+		if (!(sc->sc_flags & (SC_OP_RFKILL_HW_BLOCKED |
+		    SC_OP_RFKILL_SW_BLOCKED)))
+			ath_radio_disable(sc);
+		sc->sc_flags |= SC_OP_RFKILL_SW_BLOCKED;
+		return 0;
+	case RFKILL_STATE_UNBLOCKED:
+		if ((sc->sc_flags & SC_OP_RFKILL_SW_BLOCKED)) {
+			sc->sc_flags &= ~SC_OP_RFKILL_SW_BLOCKED;
+			if (sc->sc_flags & SC_OP_RFKILL_HW_BLOCKED) {
+				DPRINTF(sc, ATH_DBG_FATAL, "Can't turn on the"
+					"radio as it is disabled by h/w \n");
+				return -EPERM;
+			}
+			ath_radio_enable(sc);
+		}
+		return 0;
+	default:
+		return -EINVAL;
+	}
+}
+
+/* Init s/w rfkill */
+static int ath_init_sw_rfkill(struct ath_softc *sc)
+{
+	sc->rf_kill.rfkill = rfkill_allocate(wiphy_dev(sc->hw->wiphy),
+					     RFKILL_TYPE_WLAN);
+	if (!sc->rf_kill.rfkill) {
+		DPRINTF(sc, ATH_DBG_FATAL, "Failed to allocate rfkill\n");
+		return -ENOMEM;
+	}
+
+	snprintf(sc->rf_kill.rfkill_name, sizeof(sc->rf_kill.rfkill_name),
+		"ath9k-%s:rfkill", wiphy_name(sc->hw->wiphy));
+	sc->rf_kill.rfkill->name = sc->rf_kill.rfkill_name;
+	sc->rf_kill.rfkill->data = sc;
+	sc->rf_kill.rfkill->toggle_radio = ath_sw_toggle_radio;
+	sc->rf_kill.rfkill->state = RFKILL_STATE_UNBLOCKED;
+	sc->rf_kill.rfkill->user_claim_unsupported = 1;
+
+	return 0;
+}
+
+/* Deinitialize rfkill */
+static void ath_deinit_rfkill(struct ath_softc *sc)
+{
+	if (sc->sc_ah->ah_caps.hw_caps & ATH9K_HW_CAP_RFSILENT)
+		cancel_delayed_work_sync(&sc->rf_kill.rfkill_poll);
+
+	if (sc->sc_flags & SC_OP_RFKILL_REGISTERED) {
+		rfkill_unregister(sc->rf_kill.rfkill);
+		sc->sc_flags &= ~SC_OP_RFKILL_REGISTERED;
+		sc->rf_kill.rfkill = NULL;
+	}
+}
+#endif /* CONFIG_RFKILL */
+
+static void ath9k_ht_conf(struct ath_softc *sc,
+			  struct ieee80211_bss_conf *bss_conf)
+{
+#define IEEE80211_HT_CAP_40MHZ_INTOLERANT BIT(14)
+	struct ath_ht_info *ht_info = &sc->sc_ht_info;
+
+	if (bss_conf->assoc_ht) {
+		ht_info->ext_chan_offset =
+			bss_conf->ht_bss_conf->bss_cap &
+				IEEE80211_HT_IE_CHA_SEC_OFFSET;
+
+		if (!(bss_conf->ht_conf->cap &
+			IEEE80211_HT_CAP_40MHZ_INTOLERANT) &&
+			    (bss_conf->ht_bss_conf->bss_cap &
+				IEEE80211_HT_IE_CHA_WIDTH))
+			ht_info->tx_chan_width = ATH9K_HT_MACMODE_2040;
+		else
+			ht_info->tx_chan_width = ATH9K_HT_MACMODE_20;
+
+		ath9k_hw_set11nmac2040(sc->sc_ah, ht_info->tx_chan_width);
+		ht_info->maxampdu = 1 << (IEEE80211_HTCAP_MAXRXAMPDU_FACTOR +
+					bss_conf->ht_conf->ampdu_factor);
+		ht_info->mpdudensity =
+			parse_mpdudensity(bss_conf->ht_conf->ampdu_density);
+
+	}
+
+#undef IEEE80211_HT_CAP_40MHZ_INTOLERANT
+}
+
+static void ath9k_bss_assoc_info(struct ath_softc *sc,
+				 struct ieee80211_bss_conf *bss_conf)
+{
+	struct ieee80211_hw *hw = sc->hw;
+	struct ieee80211_channel *curchan = hw->conf.channel;
+	struct ath_vap *avp;
+	int pos;
+	DECLARE_MAC_BUF(mac);
+
+	if (bss_conf->assoc) {
+		DPRINTF(sc, ATH_DBG_CONFIG, "%s: Bss Info ASSOC %d\n",
+			__func__,
+			bss_conf->aid);
+
+		avp = sc->sc_vaps[0];
+		if (avp == NULL) {
+			DPRINTF(sc, ATH_DBG_FATAL, "%s: Invalid interface\n",
+				__func__);
+			return;
+		}
+
+		/* New association, store aid */
+		if (avp->av_opmode == ATH9K_M_STA) {
+			sc->sc_curaid = bss_conf->aid;
+			ath9k_hw_write_associd(sc->sc_ah, sc->sc_curbssid,
+					       sc->sc_curaid);
+		}
+
+		/* Configure the beacon */
+		ath_beacon_config(sc, 0);
+		sc->sc_flags |= SC_OP_BEACONS;
+
+		/* Reset rssi stats */
+		sc->sc_halstats.ns_avgbrssi = ATH_RSSI_DUMMY_MARKER;
+		sc->sc_halstats.ns_avgrssi = ATH_RSSI_DUMMY_MARKER;
+		sc->sc_halstats.ns_avgtxrssi = ATH_RSSI_DUMMY_MARKER;
+		sc->sc_halstats.ns_avgtxrate = ATH_RATE_DUMMY_MARKER;
+
+		/* Update chainmask */
+		ath_update_chainmask(sc, bss_conf->assoc_ht);
+
+		DPRINTF(sc, ATH_DBG_CONFIG,
+			"%s: bssid %s aid 0x%x\n",
+			__func__,
+			print_mac(mac, sc->sc_curbssid), sc->sc_curaid);
+
+		DPRINTF(sc, ATH_DBG_CONFIG, "%s: Set channel: %d MHz\n",
+			__func__,
+			curchan->center_freq);
+
+		pos = ath_get_channel(sc, curchan);
+		if (pos == -1) {
+			DPRINTF(sc, ATH_DBG_FATAL,
+				"%s: Invalid channel\n", __func__);
+			return;
+		}
+
+		if (hw->conf.ht_conf.ht_supported)
+			sc->sc_ah->ah_channels[pos].chanmode =
+				ath_get_extchanmode(sc, curchan);
+		else
+			sc->sc_ah->ah_channels[pos].chanmode =
+				(curchan->band == IEEE80211_BAND_2GHZ) ?
+				CHANNEL_G : CHANNEL_A;
+
+		/* set h/w channel */
+		if (ath_set_channel(sc, &sc->sc_ah->ah_channels[pos]) < 0)
+			DPRINTF(sc, ATH_DBG_FATAL,
+				"%s: Unable to set channel\n",
+				__func__);
+
+		ath_rate_newstate(sc, avp);
+		/* Update ratectrl about the new state */
+		ath_rc_node_update(hw, avp->rc_node);
+	} else {
+		DPRINTF(sc, ATH_DBG_CONFIG,
+		"%s: Bss Info DISSOC\n", __func__);
+		sc->sc_curaid = 0;
+	}
+}
+
+void ath_get_beaconconfig(struct ath_softc *sc,
+			  int if_id,
+			  struct ath_beacon_config *conf)
+{
+	struct ieee80211_hw *hw = sc->hw;
+
+	/* fill in beacon config data */
+
+	conf->beacon_interval = hw->conf.beacon_int;
+	conf->listen_interval = 100;
+	conf->dtim_count = 1;
+	conf->bmiss_timeout = ATH_DEFAULT_BMISS_LIMIT * conf->listen_interval;
+}
+
+void ath_tx_complete(struct ath_softc *sc, struct sk_buff *skb,
+		     struct ath_xmit_status *tx_status, struct ath_node *an)
+{
+	struct ieee80211_hw *hw = sc->hw;
+	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(skb);
+
+	DPRINTF(sc, ATH_DBG_XMIT,
+		"%s: TX complete: skb: %p\n", __func__, skb);
+
+	if (tx_info->flags & IEEE80211_TX_CTL_NO_ACK ||
+		tx_info->flags & IEEE80211_TX_STAT_TX_FILTERED) {
+		/* free driver's private data area of tx_info */
+		if (tx_info->driver_data[0] != NULL)
+			kfree(tx_info->driver_data[0]);
+			tx_info->driver_data[0] = NULL;
+	}
+
+	if (tx_status->flags & ATH_TX_BAR) {
+		tx_info->flags |= IEEE80211_TX_STAT_AMPDU_NO_BACK;
+		tx_status->flags &= ~ATH_TX_BAR;
+	}
+
+	if (tx_status->flags & (ATH_TX_ERROR | ATH_TX_XRETRY)) {
+		if (!(tx_info->flags & IEEE80211_TX_CTL_NO_ACK)) {
+			/* Frame was not ACKed, but an ACK was expected */
+			tx_info->status.excessive_retries = 1;
+		}
+	} else {
+		/* Frame was ACKed */
+		tx_info->flags |= IEEE80211_TX_STAT_ACK;
+	}
+
+	tx_info->status.retry_count = tx_status->retries;
+
+	ieee80211_tx_status(hw, skb);
+	if (an)
+		ath_node_put(sc, an, ATH9K_BH_STATUS_CHANGE);
+}
+
+int _ath_rx_indicate(struct ath_softc *sc,
+		     struct sk_buff *skb,
+		     struct ath_recv_status *status,
+		     u16 keyix)
+{
+	struct ieee80211_hw *hw = sc->hw;
+	struct ath_node *an = NULL;
+	struct ieee80211_rx_status rx_status;
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
+	int hdrlen = ieee80211_get_hdrlen_from_skb(skb);
+	int padsize;
+	enum ATH_RX_TYPE st;
+
+	/* see if any padding is done by the hw and remove it */
+	if (hdrlen & 3) {
+		padsize = hdrlen % 4;
+		memmove(skb->data + padsize, skb->data, hdrlen);
+		skb_pull(skb, padsize);
+	}
+
+	/* Prepare rx status */
+	ath9k_rx_prepare(sc, skb, status, &rx_status);
+
+	if (!(keyix == ATH9K_RXKEYIX_INVALID) &&
+	    !(status->flags & ATH_RX_DECRYPT_ERROR)) {
+		rx_status.flag |= RX_FLAG_DECRYPTED;
+	} else if ((le16_to_cpu(hdr->frame_control) & IEEE80211_FCTL_PROTECTED)
+		   && !(status->flags & ATH_RX_DECRYPT_ERROR)
+		   && skb->len >= hdrlen + 4) {
+		keyix = skb->data[hdrlen + 3] >> 6;
+
+		if (test_bit(keyix, sc->sc_keymap))
+			rx_status.flag |= RX_FLAG_DECRYPTED;
+	}
+
+	spin_lock_bh(&sc->node_lock);
+	an = ath_node_find(sc, hdr->addr2);
+	spin_unlock_bh(&sc->node_lock);
+
+	if (an) {
+		ath_rx_input(sc, an,
+			     hw->conf.ht_conf.ht_supported,
+			     skb, status, &st);
+	}
+	if (!an || (st != ATH_RX_CONSUMED))
+		__ieee80211_rx(hw, skb, &rx_status);
+
+	return 0;
+}
+
+int ath_rx_subframe(struct ath_node *an,
+		    struct sk_buff *skb,
+		    struct ath_recv_status *status)
+{
+	struct ath_softc *sc = an->an_sc;
+	struct ieee80211_hw *hw = sc->hw;
+	struct ieee80211_rx_status rx_status;
+
+	/* Prepare rx status */
+	ath9k_rx_prepare(sc, skb, status, &rx_status);
+	if (!(status->flags & ATH_RX_DECRYPT_ERROR))
+		rx_status.flag |= RX_FLAG_DECRYPTED;
+
+	__ieee80211_rx(hw, skb, &rx_status);
+
+	return 0;
+}
+
+/********************************/
+/*	 LED functions		*/
+/********************************/
+
+static void ath_led_brightness(struct led_classdev *led_cdev,
+			       enum led_brightness brightness)
+{
+	struct ath_led *led = container_of(led_cdev, struct ath_led, led_cdev);
+	struct ath_softc *sc = led->sc;
+
+	switch (brightness) {
+	case LED_OFF:
+		if (led->led_type == ATH_LED_ASSOC ||
+		    led->led_type == ATH_LED_RADIO)
+			sc->sc_flags &= ~SC_OP_LED_ASSOCIATED;
+		ath9k_hw_set_gpio(sc->sc_ah, ATH_LED_PIN,
+				(led->led_type == ATH_LED_RADIO) ? 1 :
+				!!(sc->sc_flags & SC_OP_LED_ASSOCIATED));
+		break;
+	case LED_FULL:
+		if (led->led_type == ATH_LED_ASSOC)
+			sc->sc_flags |= SC_OP_LED_ASSOCIATED;
+		ath9k_hw_set_gpio(sc->sc_ah, ATH_LED_PIN, 0);
+		break;
+	default:
+		break;
+	}
+}
+
+static int ath_register_led(struct ath_softc *sc, struct ath_led *led,
+			    char *trigger)
+{
+	int ret;
+
+	led->sc = sc;
+	led->led_cdev.name = led->name;
+	led->led_cdev.default_trigger = trigger;
+	led->led_cdev.brightness_set = ath_led_brightness;
+
+	ret = led_classdev_register(wiphy_dev(sc->hw->wiphy), &led->led_cdev);
+	if (ret)
+		DPRINTF(sc, ATH_DBG_FATAL,
+			"Failed to register led:%s", led->name);
+	else
+		led->registered = 1;
+	return ret;
+}
+
+static void ath_unregister_led(struct ath_led *led)
+{
+	if (led->registered) {
+		led_classdev_unregister(&led->led_cdev);
+		led->registered = 0;
+	}
+}
+
+static void ath_deinit_leds(struct ath_softc *sc)
+{
+	ath_unregister_led(&sc->assoc_led);
+	sc->sc_flags &= ~SC_OP_LED_ASSOCIATED;
+	ath_unregister_led(&sc->tx_led);
+	ath_unregister_led(&sc->rx_led);
+	ath_unregister_led(&sc->radio_led);
+	ath9k_hw_set_gpio(sc->sc_ah, ATH_LED_PIN, 1);
+}
+
+static void ath_init_leds(struct ath_softc *sc)
+{
+	char *trigger;
+	int ret;
+
+	/* Configure gpio 1 for output */
+	ath9k_hw_cfg_output(sc->sc_ah, ATH_LED_PIN,
+			    AR_GPIO_OUTPUT_MUX_AS_OUTPUT);
+	/* LED off, active low */
+	ath9k_hw_set_gpio(sc->sc_ah, ATH_LED_PIN, 1);
+
+	trigger = ieee80211_get_radio_led_name(sc->hw);
+	snprintf(sc->radio_led.name, sizeof(sc->radio_led.name),
+		"ath9k-%s:radio", wiphy_name(sc->hw->wiphy));
+	ret = ath_register_led(sc, &sc->radio_led, trigger);
+	sc->radio_led.led_type = ATH_LED_RADIO;
+	if (ret)
+		goto fail;
+
+	trigger = ieee80211_get_assoc_led_name(sc->hw);
+	snprintf(sc->assoc_led.name, sizeof(sc->assoc_led.name),
+		"ath9k-%s:assoc", wiphy_name(sc->hw->wiphy));
+	ret = ath_register_led(sc, &sc->assoc_led, trigger);
+	sc->assoc_led.led_type = ATH_LED_ASSOC;
+	if (ret)
+		goto fail;
+
+	trigger = ieee80211_get_tx_led_name(sc->hw);
+	snprintf(sc->tx_led.name, sizeof(sc->tx_led.name),
+		"ath9k-%s:tx", wiphy_name(sc->hw->wiphy));
+	ret = ath_register_led(sc, &sc->tx_led, trigger);
+	sc->tx_led.led_type = ATH_LED_TX;
+	if (ret)
+		goto fail;
+
+	trigger = ieee80211_get_rx_led_name(sc->hw);
+	snprintf(sc->rx_led.name, sizeof(sc->rx_led.name),
+		"ath9k-%s:rx", wiphy_name(sc->hw->wiphy));
+	ret = ath_register_led(sc, &sc->rx_led, trigger);
+	sc->rx_led.led_type = ATH_LED_RX;
+	if (ret)
+		goto fail;
+
+	return;
+
+fail:
+	ath_deinit_leds(sc);
+}
+
+static int ath_detach(struct ath_softc *sc)
+{
+	struct ieee80211_hw *hw = sc->hw;
+
+	DPRINTF(sc, ATH_DBG_CONFIG, "%s: Detach ATH hw\n", __func__);
+
+	/* Deinit LED control */
+	ath_deinit_leds(sc);
+
+#ifdef CONFIG_RFKILL
+	/* deinit rfkill */
+	ath_deinit_rfkill(sc);
+#endif
+
+	/* Unregister hw */
+
+	ieee80211_unregister_hw(hw);
+
+	/* unregister Rate control */
+	ath_rate_control_unregister();
+
+	/* tx/rx cleanup */
+
+	ath_rx_cleanup(sc);
+	ath_tx_cleanup(sc);
+
+	/* Deinit */
+
+	ath_deinit(sc);
+
+	return 0;
+}
+
+static int ath_attach(u16 devid,
+		      struct ath_softc *sc)
+{
+	struct ieee80211_hw *hw = sc->hw;
+	int error = 0;
+
+	DPRINTF(sc, ATH_DBG_CONFIG, "%s: Attach ATH hw\n", __func__);
+
+	error = ath_init(devid, sc);
+	if (error != 0)
+		return error;
+
+	/* Init nodes */
+
+	INIT_LIST_HEAD(&sc->node_list);
+	spin_lock_init(&sc->node_lock);
+
+	/* get mac address from hardware and set in mac80211 */
+
+	SET_IEEE80211_PERM_ADDR(hw, sc->sc_myaddr);
+
+	/* setup channels and rates */
+
+	sc->sbands[IEEE80211_BAND_2GHZ].channels =
+		sc->channels[IEEE80211_BAND_2GHZ];
+	sc->sbands[IEEE80211_BAND_2GHZ].bitrates =
+		sc->rates[IEEE80211_BAND_2GHZ];
+	sc->sbands[IEEE80211_BAND_2GHZ].band = IEEE80211_BAND_2GHZ;
+
+	if (sc->sc_ah->ah_caps.hw_caps & ATH9K_HW_CAP_HT)
+		/* Setup HT capabilities for 2.4Ghz*/
+		setup_ht_cap(&sc->sbands[IEEE80211_BAND_2GHZ].ht_info);
+
+	hw->wiphy->bands[IEEE80211_BAND_2GHZ] =
+		&sc->sbands[IEEE80211_BAND_2GHZ];
+
+	if (test_bit(ATH9K_MODE_11A, sc->sc_ah->ah_caps.wireless_modes)) {
+		sc->sbands[IEEE80211_BAND_5GHZ].channels =
+			sc->channels[IEEE80211_BAND_5GHZ];
+		sc->sbands[IEEE80211_BAND_5GHZ].bitrates =
+			sc->rates[IEEE80211_BAND_5GHZ];
+		sc->sbands[IEEE80211_BAND_5GHZ].band =
+			IEEE80211_BAND_5GHZ;
+
+		if (sc->sc_ah->ah_caps.hw_caps & ATH9K_HW_CAP_HT)
+			/* Setup HT capabilities for 5Ghz*/
+			setup_ht_cap(&sc->sbands[IEEE80211_BAND_5GHZ].ht_info);
+
+		hw->wiphy->bands[IEEE80211_BAND_5GHZ] =
+			&sc->sbands[IEEE80211_BAND_5GHZ];
+	}
+
+	/* FIXME: Have to figure out proper hw init values later */
+
+	hw->queues = 4;
+	hw->ampdu_queues = 1;
+
+	/* Register rate control */
+	hw->rate_control_algorithm = "ath9k_rate_control";
+	error = ath_rate_control_register();
+	if (error != 0) {
+		DPRINTF(sc, ATH_DBG_FATAL,
+			"%s: Unable to register rate control "
+			"algorithm:%d\n", __func__, error);
+		ath_rate_control_unregister();
+		goto bad;
+	}
+
+	error = ieee80211_register_hw(hw);
+	if (error != 0) {
+		ath_rate_control_unregister();
+		goto bad;
+	}
+
+	/* Initialize LED control */
+	ath_init_leds(sc);
+
+#ifdef CONFIG_RFKILL
+	/* Initialze h/w Rfkill */
+	if (sc->sc_ah->ah_caps.hw_caps & ATH9K_HW_CAP_RFSILENT)
+		INIT_DELAYED_WORK(&sc->rf_kill.rfkill_poll, ath_rfkill_poll);
+
+	/* Initialize s/w rfkill */
+	if (ath_init_sw_rfkill(sc))
+		goto detach;
+#endif
+
+	/* initialize tx/rx engine */
+
+	error = ath_tx_init(sc, ATH_TXBUF);
+	if (error != 0)
+		goto detach;
+
+	error = ath_rx_init(sc, ATH_RXBUF);
+	if (error != 0)
+		goto detach;
+
+	return 0;
+detach:
+	ath_detach(sc);
+bad:
+	return error;
+}
+
 static int ath9k_start(struct ieee80211_hw *hw)
 {
 	struct ath_softc *sc = hw->priv;
@@ -354,6 +1041,34 @@ static int ath9k_start(struct ieee80211_hw *hw)
 	}
 
 	ieee80211_wake_queues(hw);
+
+#ifdef CONFIG_RFKILL
+	/* Start rfkill polling */
+	if (sc->sc_ah->ah_caps.hw_caps & ATH9K_HW_CAP_RFSILENT)
+		queue_delayed_work(sc->hw->workqueue,
+				   &sc->rf_kill.rfkill_poll, 0);
+
+	if (!(sc->sc_flags & SC_OP_RFKILL_REGISTERED)) {
+		if (rfkill_register(sc->rf_kill.rfkill)) {
+			DPRINTF(sc, ATH_DBG_FATAL,
+					"Unable to register rfkill\n");
+			rfkill_free(sc->rf_kill.rfkill);
+
+			/* Deinitialize the device */
+			if (sc->pdev->irq)
+				free_irq(sc->pdev->irq, sc);
+			ath_detach(sc);
+			pci_iounmap(sc->pdev, sc->mem);
+			pci_release_region(sc->pdev, 0);
+			pci_disable_device(sc->pdev);
+			ieee80211_free_hw(hw);
+			return -EIO;
+		} else {
+			sc->sc_flags |= SC_OP_RFKILL_REGISTERED;
+		}
+	}
+#endif
+
 	return 0;
 }
 
@@ -414,6 +1129,11 @@ static void ath9k_stop(struct ieee80211_hw *hw)
 			"%s: Device is no longer present\n", __func__);
 
 	ieee80211_stop_queues(hw);
+
+#ifdef CONFIG_RFKILL
+	if (sc->sc_ah->ah_caps.hw_caps & ATH9K_HW_CAP_RFSILENT)
+		cancel_delayed_work_sync(&sc->rf_kill.rfkill_poll);
+#endif
 }
 
 static int ath9k_add_interface(struct ieee80211_hw *hw,
@@ -798,117 +1518,6 @@ static int ath9k_set_key(struct ieee80211_hw *hw,
 	return ret;
 }
 
-static void ath9k_ht_conf(struct ath_softc *sc,
-			  struct ieee80211_bss_conf *bss_conf)
-{
-#define IEEE80211_HT_CAP_40MHZ_INTOLERANT BIT(14)
-	struct ath_ht_info *ht_info = &sc->sc_ht_info;
-
-	if (bss_conf->assoc_ht) {
-		ht_info->ext_chan_offset =
-			bss_conf->ht_bss_conf->bss_cap &
-				IEEE80211_HT_IE_CHA_SEC_OFFSET;
-
-		if (!(bss_conf->ht_conf->cap &
-			IEEE80211_HT_CAP_40MHZ_INTOLERANT) &&
-			    (bss_conf->ht_bss_conf->bss_cap &
-				IEEE80211_HT_IE_CHA_WIDTH))
-			ht_info->tx_chan_width = ATH9K_HT_MACMODE_2040;
-		else
-			ht_info->tx_chan_width = ATH9K_HT_MACMODE_20;
-
-		ath9k_hw_set11nmac2040(sc->sc_ah, ht_info->tx_chan_width);
-		ht_info->maxampdu = 1 << (IEEE80211_HTCAP_MAXRXAMPDU_FACTOR +
-					bss_conf->ht_conf->ampdu_factor);
-		ht_info->mpdudensity =
-			parse_mpdudensity(bss_conf->ht_conf->ampdu_density);
-
-	}
-
-#undef IEEE80211_HT_CAP_40MHZ_INTOLERANT
-}
-
-static void ath9k_bss_assoc_info(struct ath_softc *sc,
-				 struct ieee80211_bss_conf *bss_conf)
-{
-	struct ieee80211_hw *hw = sc->hw;
-	struct ieee80211_channel *curchan = hw->conf.channel;
-	struct ath_vap *avp;
-	int pos;
-	DECLARE_MAC_BUF(mac);
-
-	if (bss_conf->assoc) {
-		DPRINTF(sc, ATH_DBG_CONFIG, "%s: Bss Info ASSOC %d\n",
-			__func__,
-			bss_conf->aid);
-
-		avp = sc->sc_vaps[0];
-		if (avp == NULL) {
-			DPRINTF(sc, ATH_DBG_FATAL, "%s: Invalid interface\n",
-				__func__);
-			return;
-		}
-
-		/* New association, store aid */
-		if (avp->av_opmode == ATH9K_M_STA) {
-			sc->sc_curaid = bss_conf->aid;
-			ath9k_hw_write_associd(sc->sc_ah, sc->sc_curbssid,
-					       sc->sc_curaid);
-		}
-
-		/* Configure the beacon */
-		ath_beacon_config(sc, 0);
-		sc->sc_flags |= SC_OP_BEACONS;
-
-		/* Reset rssi stats */
-		sc->sc_halstats.ns_avgbrssi = ATH_RSSI_DUMMY_MARKER;
-		sc->sc_halstats.ns_avgrssi = ATH_RSSI_DUMMY_MARKER;
-		sc->sc_halstats.ns_avgtxrssi = ATH_RSSI_DUMMY_MARKER;
-		sc->sc_halstats.ns_avgtxrate = ATH_RATE_DUMMY_MARKER;
-
-		/* Update chainmask */
-		ath_update_chainmask(sc, bss_conf->assoc_ht);
-
-		DPRINTF(sc, ATH_DBG_CONFIG,
-			"%s: bssid %s aid 0x%x\n",
-			__func__,
-			print_mac(mac, sc->sc_curbssid), sc->sc_curaid);
-
-		DPRINTF(sc, ATH_DBG_CONFIG, "%s: Set channel: %d MHz\n",
-			__func__,
-			curchan->center_freq);
-
-		pos = ath_get_channel(sc, curchan);
-		if (pos == -1) {
-			DPRINTF(sc, ATH_DBG_FATAL,
-				"%s: Invalid channel\n", __func__);
-			return;
-		}
-
-		if (hw->conf.ht_conf.ht_supported)
-			sc->sc_ah->ah_channels[pos].chanmode =
-				ath_get_extchanmode(sc, curchan);
-		else
-			sc->sc_ah->ah_channels[pos].chanmode =
-				(curchan->band == IEEE80211_BAND_2GHZ) ?
-				CHANNEL_G : CHANNEL_A;
-
-		/* set h/w channel */
-		if (ath_set_channel(sc, &sc->sc_ah->ah_channels[pos]) < 0)
-			DPRINTF(sc, ATH_DBG_FATAL,
-				"%s: Unable to set channel\n",
-				__func__);
-
-		ath_rate_newstate(sc, avp);
-		/* Update ratectrl about the new state */
-		ath_rc_node_update(hw, avp->rc_node);
-	} else {
-		DPRINTF(sc, ATH_DBG_CONFIG,
-		"%s: Bss Info DISSOC\n", __func__);
-		sc->sc_curaid = 0;
-	}
-}
-
 static void ath9k_bss_info_changed(struct ieee80211_hw *hw,
 				   struct ieee80211_vif *vif,
 				   struct ieee80211_bss_conf *bss_conf,
@@ -1048,364 +1657,6 @@ static struct ieee80211_ops ath9k_ops = {
 	.ampdu_action       = ath9k_ampdu_action
 };
 
-void ath_get_beaconconfig(struct ath_softc *sc,
-			  int if_id,
-			  struct ath_beacon_config *conf)
-{
-	struct ieee80211_hw *hw = sc->hw;
-
-	/* fill in beacon config data */
-
-	conf->beacon_interval = hw->conf.beacon_int;
-	conf->listen_interval = 100;
-	conf->dtim_count = 1;
-	conf->bmiss_timeout = ATH_DEFAULT_BMISS_LIMIT * conf->listen_interval;
-}
-
-void ath_tx_complete(struct ath_softc *sc, struct sk_buff *skb,
-		     struct ath_xmit_status *tx_status, struct ath_node *an)
-{
-	struct ieee80211_hw *hw = sc->hw;
-	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(skb);
-
-	DPRINTF(sc, ATH_DBG_XMIT,
-		"%s: TX complete: skb: %p\n", __func__, skb);
-
-	if (tx_info->flags & IEEE80211_TX_CTL_NO_ACK ||
-		tx_info->flags & IEEE80211_TX_STAT_TX_FILTERED) {
-		/* free driver's private data area of tx_info */
-		if (tx_info->driver_data[0] != NULL)
-			kfree(tx_info->driver_data[0]);
-			tx_info->driver_data[0] = NULL;
-	}
-
-	if (tx_status->flags & ATH_TX_BAR) {
-		tx_info->flags |= IEEE80211_TX_STAT_AMPDU_NO_BACK;
-		tx_status->flags &= ~ATH_TX_BAR;
-	}
-
-	if (tx_status->flags & (ATH_TX_ERROR | ATH_TX_XRETRY)) {
-		if (!(tx_info->flags & IEEE80211_TX_CTL_NO_ACK)) {
-			/* Frame was not ACKed, but an ACK was expected */
-			tx_info->status.excessive_retries = 1;
-		}
-	} else {
-		/* Frame was ACKed */
-		tx_info->flags |= IEEE80211_TX_STAT_ACK;
-	}
-
-	tx_info->status.retry_count = tx_status->retries;
-
-	ieee80211_tx_status(hw, skb);
-	if (an)
-		ath_node_put(sc, an, ATH9K_BH_STATUS_CHANGE);
-}
-
-int _ath_rx_indicate(struct ath_softc *sc,
-		     struct sk_buff *skb,
-		     struct ath_recv_status *status,
-		     u16 keyix)
-{
-	struct ieee80211_hw *hw = sc->hw;
-	struct ath_node *an = NULL;
-	struct ieee80211_rx_status rx_status;
-	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
-	int hdrlen = ieee80211_get_hdrlen_from_skb(skb);
-	int padsize;
-	enum ATH_RX_TYPE st;
-
-	/* see if any padding is done by the hw and remove it */
-	if (hdrlen & 3) {
-		padsize = hdrlen % 4;
-		memmove(skb->data + padsize, skb->data, hdrlen);
-		skb_pull(skb, padsize);
-	}
-
-	/* Prepare rx status */
-	ath9k_rx_prepare(sc, skb, status, &rx_status);
-
-	if (!(keyix == ATH9K_RXKEYIX_INVALID) &&
-	    !(status->flags & ATH_RX_DECRYPT_ERROR)) {
-		rx_status.flag |= RX_FLAG_DECRYPTED;
-	} else if ((le16_to_cpu(hdr->frame_control) & IEEE80211_FCTL_PROTECTED)
-		   && !(status->flags & ATH_RX_DECRYPT_ERROR)
-		   && skb->len >= hdrlen + 4) {
-		keyix = skb->data[hdrlen + 3] >> 6;
-
-		if (test_bit(keyix, sc->sc_keymap))
-			rx_status.flag |= RX_FLAG_DECRYPTED;
-	}
-
-	spin_lock_bh(&sc->node_lock);
-	an = ath_node_find(sc, hdr->addr2);
-	spin_unlock_bh(&sc->node_lock);
-
-	if (an) {
-		ath_rx_input(sc, an,
-			     hw->conf.ht_conf.ht_supported,
-			     skb, status, &st);
-	}
-	if (!an || (st != ATH_RX_CONSUMED))
-		__ieee80211_rx(hw, skb, &rx_status);
-
-	return 0;
-}
-
-int ath_rx_subframe(struct ath_node *an,
-		    struct sk_buff *skb,
-		    struct ath_recv_status *status)
-{
-	struct ath_softc *sc = an->an_sc;
-	struct ieee80211_hw *hw = sc->hw;
-	struct ieee80211_rx_status rx_status;
-
-	/* Prepare rx status */
-	ath9k_rx_prepare(sc, skb, status, &rx_status);
-	if (!(status->flags & ATH_RX_DECRYPT_ERROR))
-		rx_status.flag |= RX_FLAG_DECRYPTED;
-
-	__ieee80211_rx(hw, skb, &rx_status);
-
-	return 0;
-}
-
-/********************************/
-/*	 LED functions		*/
-/********************************/
-
-static void ath_led_brightness(struct led_classdev *led_cdev,
-			       enum led_brightness brightness)
-{
-	struct ath_led *led = container_of(led_cdev, struct ath_led, led_cdev);
-	struct ath_softc *sc = led->sc;
-
-	switch (brightness) {
-	case LED_OFF:
-		if (led->led_type == ATH_LED_ASSOC ||
-		    led->led_type == ATH_LED_RADIO)
-			sc->sc_flags &= ~SC_OP_LED_ASSOCIATED;
-		ath9k_hw_set_gpio(sc->sc_ah, ATH_LED_PIN,
-				(led->led_type == ATH_LED_RADIO) ? 1 :
-				!!(sc->sc_flags & SC_OP_LED_ASSOCIATED));
-		break;
-	case LED_FULL:
-		if (led->led_type == ATH_LED_ASSOC)
-			sc->sc_flags |= SC_OP_LED_ASSOCIATED;
-		ath9k_hw_set_gpio(sc->sc_ah, ATH_LED_PIN, 0);
-		break;
-	default:
-		break;
-	}
-}
-
-static int ath_register_led(struct ath_softc *sc, struct ath_led *led,
-			    char *trigger)
-{
-	int ret;
-
-	led->sc = sc;
-	led->led_cdev.name = led->name;
-	led->led_cdev.default_trigger = trigger;
-	led->led_cdev.brightness_set = ath_led_brightness;
-
-	ret = led_classdev_register(wiphy_dev(sc->hw->wiphy), &led->led_cdev);
-	if (ret)
-		DPRINTF(sc, ATH_DBG_FATAL,
-			"Failed to register led:%s", led->name);
-	else
-		led->registered = 1;
-	return ret;
-}
-
-static void ath_unregister_led(struct ath_led *led)
-{
-	if (led->registered) {
-		led_classdev_unregister(&led->led_cdev);
-		led->registered = 0;
-	}
-}
-
-static void ath_deinit_leds(struct ath_softc *sc)
-{
-	ath_unregister_led(&sc->assoc_led);
-	sc->sc_flags &= ~SC_OP_LED_ASSOCIATED;
-	ath_unregister_led(&sc->tx_led);
-	ath_unregister_led(&sc->rx_led);
-	ath_unregister_led(&sc->radio_led);
-	ath9k_hw_set_gpio(sc->sc_ah, ATH_LED_PIN, 1);
-}
-
-static void ath_init_leds(struct ath_softc *sc)
-{
-	char *trigger;
-	int ret;
-
-	/* Configure gpio 1 for output */
-	ath9k_hw_cfg_output(sc->sc_ah, ATH_LED_PIN,
-			    AR_GPIO_OUTPUT_MUX_AS_OUTPUT);
-	/* LED off, active low */
-	ath9k_hw_set_gpio(sc->sc_ah, ATH_LED_PIN, 1);
-
-	trigger = ieee80211_get_radio_led_name(sc->hw);
-	snprintf(sc->radio_led.name, sizeof(sc->radio_led.name),
-		"ath9k-%s:radio", wiphy_name(sc->hw->wiphy));
-	ret = ath_register_led(sc, &sc->radio_led, trigger);
-	sc->radio_led.led_type = ATH_LED_RADIO;
-	if (ret)
-		goto fail;
-
-	trigger = ieee80211_get_assoc_led_name(sc->hw);
-	snprintf(sc->assoc_led.name, sizeof(sc->assoc_led.name),
-		"ath9k-%s:assoc", wiphy_name(sc->hw->wiphy));
-	ret = ath_register_led(sc, &sc->assoc_led, trigger);
-	sc->assoc_led.led_type = ATH_LED_ASSOC;
-	if (ret)
-		goto fail;
-
-	trigger = ieee80211_get_tx_led_name(sc->hw);
-	snprintf(sc->tx_led.name, sizeof(sc->tx_led.name),
-		"ath9k-%s:tx", wiphy_name(sc->hw->wiphy));
-	ret = ath_register_led(sc, &sc->tx_led, trigger);
-	sc->tx_led.led_type = ATH_LED_TX;
-	if (ret)
-		goto fail;
-
-	trigger = ieee80211_get_rx_led_name(sc->hw);
-	snprintf(sc->rx_led.name, sizeof(sc->rx_led.name),
-		"ath9k-%s:rx", wiphy_name(sc->hw->wiphy));
-	ret = ath_register_led(sc, &sc->rx_led, trigger);
-	sc->rx_led.led_type = ATH_LED_RX;
-	if (ret)
-		goto fail;
-
-	return;
-
-fail:
-	ath_deinit_leds(sc);
-}
-
-static int ath_detach(struct ath_softc *sc)
-{
-	struct ieee80211_hw *hw = sc->hw;
-
-	DPRINTF(sc, ATH_DBG_CONFIG, "%s: Detach ATH hw\n", __func__);
-
-	/* Deinit LED control */
-	ath_deinit_leds(sc);
-
-	/* Unregister hw */
-
-	ieee80211_unregister_hw(hw);
-
-	/* unregister Rate control */
-	ath_rate_control_unregister();
-
-	/* tx/rx cleanup */
-
-	ath_rx_cleanup(sc);
-	ath_tx_cleanup(sc);
-
-	/* Deinit */
-
-	ath_deinit(sc);
-
-	return 0;
-}
-
-static int ath_attach(u16 devid,
-		      struct ath_softc *sc)
-{
-	struct ieee80211_hw *hw = sc->hw;
-	int error = 0;
-
-	DPRINTF(sc, ATH_DBG_CONFIG, "%s: Attach ATH hw\n", __func__);
-
-	error = ath_init(devid, sc);
-	if (error != 0)
-		return error;
-
-	/* Init nodes */
-
-	INIT_LIST_HEAD(&sc->node_list);
-	spin_lock_init(&sc->node_lock);
-
-	/* get mac address from hardware and set in mac80211 */
-
-	SET_IEEE80211_PERM_ADDR(hw, sc->sc_myaddr);
-
-	/* setup channels and rates */
-
-	sc->sbands[IEEE80211_BAND_2GHZ].channels =
-		sc->channels[IEEE80211_BAND_2GHZ];
-	sc->sbands[IEEE80211_BAND_2GHZ].bitrates =
-		sc->rates[IEEE80211_BAND_2GHZ];
-	sc->sbands[IEEE80211_BAND_2GHZ].band = IEEE80211_BAND_2GHZ;
-
-	if (sc->sc_ah->ah_caps.hw_caps & ATH9K_HW_CAP_HT)
-		/* Setup HT capabilities for 2.4Ghz*/
-		setup_ht_cap(&sc->sbands[IEEE80211_BAND_2GHZ].ht_info);
-
-	hw->wiphy->bands[IEEE80211_BAND_2GHZ] =
-		&sc->sbands[IEEE80211_BAND_2GHZ];
-
-	if (test_bit(ATH9K_MODE_11A, sc->sc_ah->ah_caps.wireless_modes)) {
-		sc->sbands[IEEE80211_BAND_5GHZ].channels =
-			sc->channels[IEEE80211_BAND_5GHZ];
-		sc->sbands[IEEE80211_BAND_5GHZ].bitrates =
-			sc->rates[IEEE80211_BAND_5GHZ];
-		sc->sbands[IEEE80211_BAND_5GHZ].band =
-			IEEE80211_BAND_5GHZ;
-
-		if (sc->sc_ah->ah_caps.hw_caps & ATH9K_HW_CAP_HT)
-			/* Setup HT capabilities for 5Ghz*/
-			setup_ht_cap(&sc->sbands[IEEE80211_BAND_5GHZ].ht_info);
-
-		hw->wiphy->bands[IEEE80211_BAND_5GHZ] =
-			&sc->sbands[IEEE80211_BAND_5GHZ];
-	}
-
-	/* FIXME: Have to figure out proper hw init values later */
-
-	hw->queues = 4;
-	hw->ampdu_queues = 1;
-
-	/* Register rate control */
-	hw->rate_control_algorithm = "ath9k_rate_control";
-	error = ath_rate_control_register();
-	if (error != 0) {
-		DPRINTF(sc, ATH_DBG_FATAL,
-			"%s: Unable to register rate control "
-			"algorithm:%d\n", __func__, error);
-		ath_rate_control_unregister();
-		goto bad;
-	}
-
-	error = ieee80211_register_hw(hw);
-	if (error != 0) {
-		ath_rate_control_unregister();
-		goto bad;
-	}
-
-	/* Initialize LED control */
-	ath_init_leds(sc);
-
-	/* initialize tx/rx engine */
-
-	error = ath_tx_init(sc, ATH_TXBUF);
-	if (error != 0)
-		goto detach;
-
-	error = ath_rx_init(sc, ATH_RXBUF);
-	if (error != 0)
-		goto detach;
-
-	return 0;
-detach:
-	ath_detach(sc);
-bad:
-	return error;
-}
-
 static int ath_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 {
 	void __iomem *mem;
@@ -1554,6 +1805,12 @@ static int ath_pci_suspend(struct pci_dev *pdev, pm_message_t state)
 	struct ath_softc *sc = hw->priv;
 
 	ath9k_hw_set_gpio(sc->sc_ah, ATH_LED_PIN, 1);
+
+#ifdef CONFIG_RFKILL
+	if (sc->sc_ah->ah_caps.hw_caps & ATH9K_HW_CAP_RFSILENT)
+		cancel_delayed_work_sync(&sc->rf_kill.rfkill_poll);
+#endif
+
 	pci_save_state(pdev);
 	pci_disable_device(pdev);
 	pci_set_power_state(pdev, 3);
@@ -1586,6 +1843,16 @@ static int ath_pci_resume(struct pci_dev *pdev)
 			    AR_GPIO_OUTPUT_MUX_AS_OUTPUT);
 	ath9k_hw_set_gpio(sc->sc_ah, ATH_LED_PIN, 1);
 
+#ifdef CONFIG_RFKILL
+	/*
+	 * check the h/w rfkill state on resume
+	 * and start the rfkill poll timer
+	 */
+	if (sc->sc_ah->ah_caps.hw_caps & ATH9K_HW_CAP_RFSILENT)
+		queue_delayed_work(sc->hw->workqueue,
+				   &sc->rf_kill.rfkill_poll, 0);
+#endif
+
 	return 0;
 }
 
-- 
1.5.5.1

