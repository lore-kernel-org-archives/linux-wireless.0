Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:39922 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750818AbYIJNZp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Sep 2008 09:25:45 -0400
Date: Wed, 10 Sep 2008 18:50:17 +0530
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Jouni Malinen <Jouni.Malinen@Atheros.com>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>
Subject: [PATCH 2/2] ath9k: Add RF kill support
Message-ID: <20080910132017.GA7801@vasanth-lnx.users.atheros.com> (sfid-20080910_152548_348524_37C666E6)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

RF kill support is enabled when CONFIG_RFKILL
is set.

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 drivers/net/wireless/ath9k/ath9k.h |    7 +-
 drivers/net/wireless/ath9k/core.h  |   16 ++
 drivers/net/wireless/ath9k/hw.c    |   70 ++++++----
 drivers/net/wireless/ath9k/main.c  |  266 ++++++++++++++++++++++++++++++++++++
 4 files changed, 327 insertions(+), 32 deletions(-)

diff --git a/drivers/net/wireless/ath9k/ath9k.h b/drivers/net/wireless/ath9k/ath9k.h
index 28b8d84..0e897c2 100644
--- a/drivers/net/wireless/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath9k/ath9k.h
@@ -798,10 +798,11 @@ struct ath_hal {
 	struct ath9k_channel *ah_curchan;
 	u32 ah_nchan;
 
-	u16 ah_rfsilent;
-	bool ah_rfkillEnabled;
 	bool ah_isPciExpress;
 	u16 ah_txTrigLevel;
+	u16 ah_rfsilent;
+	u32 ah_rfkill_gpio;
+	u32 ah_rfkill_polarity;
 
 #ifndef ATH_NF_PER_CHAN
 	struct ath9k_nfcal_hist nfCalHist[NUM_NF_READINGS];
@@ -1003,4 +1004,6 @@ bool ath9k_get_channel_edges(struct ath_hal *ah,
 void ath9k_hw_cfg_output(struct ath_hal *ah, u32 gpio,
 			u32 ah_signal_type);
 void ath9k_hw_set_gpio(struct ath_hal *ah, u32 gpio, u32 value);
+u32 ath9k_hw_gpio_get(struct ath_hal *ah, u32 gpio);
+void ath9k_hw_cfg_gpio_input(struct ath_hal *ah, u32 gpio);
 #endif
diff --git a/drivers/net/wireless/ath9k/core.h b/drivers/net/wireless/ath9k/core.h
index 1faa1ef..b66de29 100644
--- a/drivers/net/wireless/ath9k/core.h
+++ b/drivers/net/wireless/ath9k/core.h
@@ -40,6 +40,7 @@
 #include <asm/page.h>
 #include <net/mac80211.h>
 #include <linux/leds.h>
+#include <linux/rfkill.h>
 
 #include "ath9k.h"
 #include "rc.h"
@@ -823,6 +824,15 @@ struct ath_led {
 	bool registered;
 };
 
+/* Rfkill */
+#define ATH_RFKILL_POLL_INTERVAL	2000 /* msecs */
+
+struct ath_rfkill {
+	struct rfkill *rfkill;
+	struct delayed_work rfkill_poll;
+	char rfkill_name[32];
+};
+
 /********************/
 /* Main driver core */
 /********************/
@@ -906,6 +916,9 @@ struct ath_ht_info {
 #define SC_OP_PROTECT_ENABLE	BIT(8)
 #define SC_OP_RXFLUSH		BIT(9)
 #define SC_OP_LED_ASSOCIATED	BIT(10)
+#define SC_OP_RFKILL_REGISTERED	BIT(11)
+#define SC_OP_RFKILL_SW_BLOCKED	BIT(12)
+#define SC_OP_RFKILL_HW_BLOCKED	BIT(13)
 
 struct ath_softc {
 	struct ieee80211_hw *hw;
@@ -1015,6 +1028,9 @@ struct ath_softc {
 	struct ath_led assoc_led;
 	struct ath_led tx_led;
 	struct ath_led rx_led;
+
+	/* Rfkill */
+	struct ath_rfkill rf_kill;
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
diff --git a/drivers/net/wireless/ath9k/main.c b/drivers/net/wireless/ath9k/main.c
index 07e5b5d..b493dff 100644
--- a/drivers/net/wireless/ath9k/main.c
+++ b/drivers/net/wireless/ath9k/main.c
@@ -672,6 +672,209 @@ fail:
 	ath_deinit_leds(sc);
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
 static int ath_detach(struct ath_softc *sc)
 {
 	struct ieee80211_hw *hw = sc->hw;
@@ -681,6 +884,11 @@ static int ath_detach(struct ath_softc *sc)
 	/* Deinit LED control */
 	ath_deinit_leds(sc);
 
+#ifdef CONFIG_RFKILL
+	/* deinit rfkill */
+	ath_deinit_rfkill(sc);
+#endif
+
 	/* Unregister hw */
 
 	ieee80211_unregister_hw(hw);
@@ -777,6 +985,16 @@ static int ath_attach(u16 devid,
 	/* Initialize LED control */
 	ath_init_leds(sc);
 
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
 	/* initialize tx/rx engine */
 
 	error = ath_tx_init(sc, ATH_TXBUF);
@@ -822,6 +1040,33 @@ static int ath9k_start(struct ieee80211_hw *hw)
 		return error;
 	}
 
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
 	ieee80211_wake_queues(hw);
 	return 0;
 }
@@ -883,6 +1128,11 @@ static void ath9k_stop(struct ieee80211_hw *hw)
 			"%s: Device is no longer present\n", __func__);
 
 	ieee80211_stop_queues(hw);
+
+#ifdef CONFIG_RFKILL
+	if (sc->sc_ah->ah_caps.hw_caps & ATH9K_HW_CAP_RFSILENT)
+		cancel_delayed_work_sync(&sc->rf_kill.rfkill_poll);
+#endif
 }
 
 static int ath9k_add_interface(struct ieee80211_hw *hw,
@@ -1554,6 +1804,12 @@ static int ath_pci_suspend(struct pci_dev *pdev, pm_message_t state)
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
@@ -1586,6 +1842,16 @@ static int ath_pci_resume(struct pci_dev *pdev)
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

