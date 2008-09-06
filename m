Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:39773 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751318AbYIFMoF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Sep 2008 08:44:05 -0400
Date: Sat, 6 Sep 2008 18:08:42 +0530
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Jouni Malinen <Jouni.Malinen@Atheros.com>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>
Subject: [PATCH] Ath9k: Add RF kill support.
Message-ID: <20080906123842.GA27504@vasanth-lnx.users.atheros.com> (sfid-20080906_144412_112288_0064FF8C)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

CONFIG_ATH9K_RFKILL needs to be set
to enable this support.

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 drivers/net/wireless/ath9k/Kconfig |    5 +
 drivers/net/wireless/ath9k/ath9k.h |    7 +-
 drivers/net/wireless/ath9k/core.h  |   25 ++++
 drivers/net/wireless/ath9k/hw.c    |   70 ++++++----
 drivers/net/wireless/ath9k/hw.h    |    2 -
 drivers/net/wireless/ath9k/main.c  |  259 ++++++++++++++++++++++++++++++++++++
 6 files changed, 335 insertions(+), 33 deletions(-)

diff --git a/drivers/net/wireless/ath9k/Kconfig b/drivers/net/wireless/ath9k/Kconfig
index 80a6924..54ba25a 100644
--- a/drivers/net/wireless/ath9k/Kconfig
+++ b/drivers/net/wireless/ath9k/Kconfig
@@ -4,8 +4,13 @@ config ATH9K
 	select MAC80211_LEDS
 	select LEDS_CLASS
 	select NEW_LEDS
+	select RFKILL if ATH9K_RFKILL
 	---help---
 	  This module adds support for wireless adapters based on
 	  Atheros IEEE 802.11n AR5008 and AR9001 family of chipsets.
 
 	  If you choose to build a module, it'll be called ath9k.
+
+config ATH9K_RFKILL
+	boolean "Ath9k RF kill support"
+	depends on ATH9K
diff --git a/drivers/net/wireless/ath9k/ath9k.h b/drivers/net/wireless/ath9k/ath9k.h
index 28b8d84..5589094 100644
--- a/drivers/net/wireless/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath9k/ath9k.h
@@ -802,7 +802,10 @@ struct ath_hal {
 	bool ah_rfkillEnabled;
 	bool ah_isPciExpress;
 	u16 ah_txTrigLevel;
-
+#ifdef CONFIG_ATH9K_RFKILL
+	u32 ah_rfkill_gpio ;
+	u32 ah_rfkill_polarity;
+#endif
 #ifndef ATH_NF_PER_CHAN
 	struct ath9k_nfcal_hist nfCalHist[NUM_NF_READINGS];
 #endif
@@ -1003,4 +1006,6 @@ bool ath9k_get_channel_edges(struct ath_hal *ah,
 void ath9k_hw_cfg_output(struct ath_hal *ah, u32 gpio,
 			u32 ah_signal_type);
 void ath9k_hw_set_gpio(struct ath_hal *ah, u32 gpio, u32 value);
+u32 ath9k_hw_gpio_get(struct ath_hal *ah, u32 gpio);
+void ath9k_hw_cfg_gpio_input(struct ath_hal *ah, u32 gpio);
 #endif
diff --git a/drivers/net/wireless/ath9k/core.h b/drivers/net/wireless/ath9k/core.h
index 1faa1ef..5bbf747 100644
--- a/drivers/net/wireless/ath9k/core.h
+++ b/drivers/net/wireless/ath9k/core.h
@@ -40,6 +40,9 @@
 #include <asm/page.h>
 #include <net/mac80211.h>
 #include <linux/leds.h>
+#ifdef CONFIG_ATH9K_RFKILL
+#include <linux/rfkill.h>
+#endif
 
 #include "ath9k.h"
 #include "rc.h"
@@ -823,6 +826,17 @@ struct ath_led {
 	bool registered;
 };
 
+#ifdef CONFIG_ATH9K_RFKILL
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
@@ -906,6 +920,12 @@ struct ath_ht_info {
 #define SC_OP_PROTECT_ENABLE	BIT(8)
 #define SC_OP_RXFLUSH		BIT(9)
 #define SC_OP_LED_ASSOCIATED	BIT(10)
+#ifdef CONFIG_ATH9K_RFKILL
+#define SC_OP_RFKILL_ALLOCATED	BIT(11)
+#define SC_OP_RFKILL_REGISTERED	BIT(12)
+#define SC_OP_RFKILL_SW_BLOCKED	BIT(13)
+#define SC_OP_RFKILL_HW_BLOCKED	BIT(14)
+#endif
 
 struct ath_softc {
 	struct ieee80211_hw *hw;
@@ -1015,6 +1035,11 @@ struct ath_softc {
 	struct ath_led assoc_led;
 	struct ath_led tx_led;
 	struct ath_led rx_led;
+
+#ifdef CONFIG_ATH9K_RFKILL
+	/* Rfkill */
+	struct ath_rfkill rf_kill;
+#endif
 };
 
 int ath_init(u16 devid, struct ath_softc *sc);
diff --git a/drivers/net/wireless/ath9k/hw.c b/drivers/net/wireless/ath9k/hw.c
index 4ccbbc0..9cc91e1 100644
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
+	gpio_shift = 2 * gpio;
+
+	REG_RMW(ah,
+		AR_GPIO_OE_OUT,
+		(AR_GPIO_OE_OUT_DRV_NO << gpio_shift),
+		(AR_GPIO_OE_OUT_DRV << gpio_shift));
+}
+
+#ifdef CONFIG_ATH9K_RFKILL
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
 
+#ifdef CONFIG_ATH9K_RFKILL
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
 
+#ifdef CONFIG_ATH9K_RFKILL
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
index 57d7cc8..836ccab 100644
--- a/drivers/net/wireless/ath9k/main.c
+++ b/drivers/net/wireless/ath9k/main.c
@@ -325,6 +325,213 @@ static u8 parse_mpdudensity(u8 mpdudensity)
 	}
 }
 
+#ifdef CONFIG_ATH9K_RFKILL
+
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
+static bool ath_get_rfkill(struct ath_softc *sc)
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
+	radio_on = !ath_get_rfkill(sc);
+	if (radio_on == !!(sc->sc_flags & SC_OP_RFKILL_HW_BLOCKED)) {
+		if (radio_on)
+			sc->sc_flags &= ~SC_OP_RFKILL_HW_BLOCKED;
+		else
+			sc->sc_flags |= SC_OP_RFKILL_HW_BLOCKED;
+
+		if (sc->sc_flags & SC_OP_RFKILL_REGISTERED) {
+			enum rfkill_state state;
+
+			if (sc->sc_flags & SC_OP_RFKILL_SW_BLOCKED) {
+				state = radio_on ? RFKILL_STATE_SOFT_BLOCKED
+					: RFKILL_STATE_HARD_BLOCKED;
+			} else if (radio_on) {
+				ath_radio_enable(sc);
+				state = RFKILL_STATE_UNBLOCKED;
+			} else {
+				ath_radio_disable(sc);
+				state = RFKILL_STATE_HARD_BLOCKED;
+			}
+			rfkill_force_state(sc->rf_kill.rfkill, state);
+		} else {
+			if (sc->sc_flags & SC_OP_RFKILL_HW_BLOCKED)
+				ath_radio_disable(sc);
+			else
+				ath_radio_enable(sc);
+		}
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
+		    if (sc->sc_flags & SC_OP_RFKILL_HW_BLOCKED) {
+			DPRINTF(sc, ATH_DBG_FATAL, "Can't turn on the radio"
+				"as it is disabled by h/w \n");
+			return -EPERM;
+		    }
+		    ath_radio_enable(sc);
+		}
+		return 0;
+	default:
+		return -EINVAL;
+	}
+}
+
+/* Init s/w rfkill */
+static void ath_init_sw_rfkill(struct ath_softc *sc)
+{
+	sc->rf_kill.rfkill = rfkill_allocate(wiphy_dev(sc->hw->wiphy),
+					     RFKILL_TYPE_WLAN);
+	if (!sc->rf_kill.rfkill) {
+		DPRINTF(sc, ATH_DBG_FATAL, "Failed to allocate rfkill\n");
+		return;
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
+	sc->sc_flags |= SC_OP_RFKILL_ALLOCATED;
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
+		sc->sc_flags &= ~(SC_OP_RFKILL_REGISTERED |
+				  SC_OP_RFKILL_ALLOCATED);
+		sc->rf_kill.rfkill = NULL;
+	}
+}
+
+#endif /* CONFIG_ATH9K_RFKILL */
+
 static int ath9k_start(struct ieee80211_hw *hw)
 {
 	struct ath_softc *sc = hw->priv;
@@ -354,6 +561,26 @@ static int ath9k_start(struct ieee80211_hw *hw)
 	}
 
 	ieee80211_wake_queues(hw);
+
+#ifdef CONFIG_ATH9K_RFKILL
+	/* Start rfkill polling */
+	if (sc->sc_ah->ah_caps.hw_caps & ATH9K_HW_CAP_RFSILENT)
+		queue_delayed_work(sc->hw->workqueue,
+				   &sc->rf_kill.rfkill_poll, 0);
+
+	if ((sc->sc_flags & SC_OP_RFKILL_ALLOCATED) &&
+	    !(sc->sc_flags & SC_OP_RFKILL_REGISTERED)) {
+		if (rfkill_register(sc->rf_kill.rfkill)) {
+			DPRINTF(sc, ATH_DBG_FATAL,
+				"Unable to register rfkill\n");
+			rfkill_free(sc->rf_kill.rfkill);
+			sc->sc_flags &= ~SC_OP_RFKILL_ALLOCATED;
+		} else {
+			sc->sc_flags |= SC_OP_RFKILL_REGISTERED;
+		}
+	}
+#endif
+
 	return 0;
 }
 
@@ -414,6 +641,11 @@ static void ath9k_stop(struct ieee80211_hw *hw)
 			"%s: Device is no longer present\n", __func__);
 
 	ieee80211_stop_queues(hw);
+
+#ifdef CONFIG_ATH9K_RFKILL
+	if (sc->sc_ah->ah_caps.hw_caps & ATH9K_HW_CAP_RFSILENT)
+		cancel_delayed_work_sync(&sc->rf_kill.rfkill_poll);
+#endif
 }
 
 static int ath9k_add_interface(struct ieee80211_hw *hw,
@@ -1293,6 +1525,10 @@ static int ath_detach(struct ath_softc *sc)
 	/* Deinit LED control */
 	ath_deinit_leds(sc);
 
+#ifdef CONFIG_ATH9K_RFKILL
+	/* deinit rfkill */
+	ath_deinit_rfkill(sc);
+#endif
 	/* Unregister hw */
 
 	ieee80211_unregister_hw(hw);
@@ -1389,6 +1625,15 @@ static int ath_attach(u16 devid,
 	/* Initialize LED control */
 	ath_init_leds(sc);
 
+#ifdef CONFIG_ATH9K_RFKILL
+	/* Initialze h/w Rfkill */
+	if (sc->sc_ah->ah_caps.hw_caps & ATH9K_HW_CAP_RFSILENT)
+		INIT_DELAYED_WORK(&sc->rf_kill.rfkill_poll, ath_rfkill_poll);
+
+	/* Initialize s/w rfkill */
+	ath_init_sw_rfkill(sc);
+#endif
+
 	/* initialize tx/rx engine */
 
 	error = ath_tx_init(sc, ATH_TXBUF);
@@ -1554,6 +1799,10 @@ static int ath_pci_suspend(struct pci_dev *pdev, pm_message_t state)
 	struct ath_softc *sc = hw->priv;
 
 	ath9k_hw_set_gpio(sc->sc_ah, ATH_LED_PIN, 1);
+#ifdef CONFIG_ATH9K_RFKILL
+	if (sc->sc_ah->ah_caps.hw_caps & ATH9K_HW_CAP_RFSILENT)
+		cancel_delayed_work_sync(&sc->rf_kill.rfkill_poll);
+#endif
 	pci_save_state(pdev);
 	pci_disable_device(pdev);
 	pci_set_power_state(pdev, 3);
@@ -1586,6 +1835,16 @@ static int ath_pci_resume(struct pci_dev *pdev)
 			    AR_GPIO_OUTPUT_MUX_AS_OUTPUT);
 	ath9k_hw_set_gpio(sc->sc_ah, ATH_LED_PIN, 1);
 
+#ifdef CONFIG_ATH9K_RFKILL
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

