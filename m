Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:16857 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752080AbYKMMaG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Nov 2008 07:30:06 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 13 Nov 2008 04:30:06 -0800
Date: Thu, 13 Nov 2008 18:00:02 +0530
From: Senthil Balasubramanian <senthilkumar@atheros.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <jouni.malinen@atheros.com>,
	<lrodriguez@atheros.com>
Subject: [PATCH 03/05] ath9k: Build RFKILL feature even when RFKILL
	subsystem is a MODULE
Message-ID: <20081113123002.GD7688@senthil-lnx.users.atheros.com> (sfid-20081113_133011_477751_5F76AF29)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Currently, ath9k builds RFKILL feature only when the RFKILL subsystem
is built part of the kernel. Build RFKILL feature regardless of whether
RFKILL subsystem is built as a MODULE or part of the kernel.

Signed-off-by: Senthil Balasubramanian <senthilkumar@atheros.com>
---
 drivers/net/wireless/ath9k/ath9k.h |    2 +-
 drivers/net/wireless/ath9k/core.c  |    2 +-
 drivers/net/wireless/ath9k/hw.c    |    6 +++---
 drivers/net/wireless/ath9k/main.c  |   12 ++++++------
 4 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/ath9k/ath9k.h b/drivers/net/wireless/ath9k/ath9k.h
index 3a180ce..6be2b94 100644
--- a/drivers/net/wireless/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath9k/ath9k.h
@@ -904,7 +904,7 @@ u32 ath9k_hw_gpio_get(struct ath_hal *ah, u32 gpio);
 void ath9k_hw_cfg_output(struct ath_hal *ah, u32 gpio,
 			 u32 ah_signal_type);
 void ath9k_hw_set_gpio(struct ath_hal *ah, u32 gpio, u32 val);
-#ifdef CONFIG_RFKILL
+#if defined(CONFIG_RFKILL) || defined(CONFIG_RFKILL_MODULE)
 void ath9k_enable_rfkill(struct ath_hal *ah);
 #endif
 int ath9k_hw_select_antconfig(struct ath_hal *ah, u32 cfg);
diff --git a/drivers/net/wireless/ath9k/core.c b/drivers/net/wireless/ath9k/core.c
index 5f5184a..3e94dab 100644
--- a/drivers/net/wireless/ath9k/core.c
+++ b/drivers/net/wireless/ath9k/core.c
@@ -705,7 +705,7 @@ void ath_stop(struct ath_softc *sc)
 	} else
 		sc->sc_rxlink = NULL;
 
-#ifdef CONFIG_RFKILL
+#if defined(CONFIG_RFKILL) || defined(CONFIG_RFKILL_MODULE)
 	if (sc->sc_ah->ah_caps.hw_caps & ATH9K_HW_CAP_RFSILENT)
 		cancel_delayed_work_sync(&sc->rf_kill.rfkill_poll);
 #endif
diff --git a/drivers/net/wireless/ath9k/hw.c b/drivers/net/wireless/ath9k/hw.c
index 7ca2efa..dc30703 100644
--- a/drivers/net/wireless/ath9k/hw.c
+++ b/drivers/net/wireless/ath9k/hw.c
@@ -2341,7 +2341,7 @@ bool ath9k_hw_reset(struct ath_hal *ah, struct ath9k_channel *chan,
 	ath9k_hw_init_interrupt_masks(ah, ah->ah_opmode);
 	ath9k_hw_init_qos(ah);
 
-#ifdef CONFIG_RFKILL
+#if defined(CONFIG_RFKILL) || defined(CONFIG_RFKILL_MODULE)
 	if (ah->ah_caps.hw_caps & ATH9K_HW_CAP_RFSILENT)
 		ath9k_enable_rfkill(ah);
 #endif
@@ -3516,7 +3516,7 @@ bool ath9k_hw_fill_cap_info(struct ath_hal *ah)
 
 	pCap->hw_caps |= ATH9K_HW_CAP_ENHANCEDPM;
 
-#ifdef CONFIG_RFKILL
+#if defined(CONFIG_RFKILL) || defined(CONFIG_RFKILL_MODULE)
 	ah->ah_rfsilent = ath9k_hw_get_eeprom(ah, EEP_RF_SILENT);
 	if (ah->ah_rfsilent & EEP_RFSILENT_ENABLED) {
 		ah->ah_rfkill_gpio =
@@ -3773,7 +3773,7 @@ void ath9k_hw_set_gpio(struct ath_hal *ah, u32 gpio, u32 val)
 		AR_GPIO_BIT(gpio));
 }
 
-#ifdef CONFIG_RFKILL
+#if defined(CONFIG_RFKILL) || defined(CONFIG_RFKILL_MODULE)
 void ath9k_enable_rfkill(struct ath_hal *ah)
 {
 	REG_SET_BIT(ah, AR_GPIO_INPUT_EN_VAL,
diff --git a/drivers/net/wireless/ath9k/main.c b/drivers/net/wireless/ath9k/main.c
index 04342ec..97f0b47 100644
--- a/drivers/net/wireless/ath9k/main.c
+++ b/drivers/net/wireless/ath9k/main.c
@@ -595,7 +595,7 @@ fail:
 	ath_deinit_leds(sc);
 }
 
-#ifdef CONFIG_RFKILL
+#if defined(CONFIG_RFKILL) || defined(CONFIG_RFKILL_MODULE)
 
 /*******************/
 /*	Rfkill	   */
@@ -839,7 +839,7 @@ static void ath_detach(struct ath_softc *sc)
 
 	ath_deinit_leds(sc);
 
-#ifdef CONFIG_RFKILL
+#if defined(CONFIG_RFKILL) || defined(CONFIG_RFKILL_MODULE)
 	ath_deinit_rfkill(sc);
 #endif
 	ath_rate_control_unregister();
@@ -922,7 +922,7 @@ static int ath_attach(u16 devid, struct ath_softc *sc)
 	/* Initialize LED control */
 	ath_init_leds(sc);
 
-#ifdef CONFIG_RFKILL
+#if defined(CONFIG_RFKILL) || defined(CONFIG_RFKILL_MODULE)
 	/* Initialze h/w Rfkill */
 	if (sc->sc_ah->ah_caps.hw_caps & ATH9K_HW_CAP_RFSILENT)
 		INIT_DELAYED_WORK(&sc->rf_kill.rfkill_poll, ath_rfkill_poll);
@@ -979,7 +979,7 @@ static int ath9k_start(struct ieee80211_hw *hw)
 		goto exit;
 	}
 
-#ifdef CONFIG_RFKILL
+#if defined(CONFIG_RFKILL) || defined(CONFIG_RFKILL_MODULE)
 	error = ath_start_rfkill_poll(sc);
 #endif
 
@@ -1724,7 +1724,7 @@ static int ath_pci_suspend(struct pci_dev *pdev, pm_message_t state)
 
 	ath9k_hw_set_gpio(sc->sc_ah, ATH_LED_PIN, 1);
 
-#ifdef CONFIG_RFKILL
+#if defined(CONFIG_RFKILL) || defined(CONFIG_RFKILL_MODULE)
 	if (sc->sc_ah->ah_caps.hw_caps & ATH9K_HW_CAP_RFSILENT)
 		cancel_delayed_work_sync(&sc->rf_kill.rfkill_poll);
 #endif
@@ -1761,7 +1761,7 @@ static int ath_pci_resume(struct pci_dev *pdev)
 			    AR_GPIO_OUTPUT_MUX_AS_OUTPUT);
 	ath9k_hw_set_gpio(sc->sc_ah, ATH_LED_PIN, 1);
 
-#ifdef CONFIG_RFKILL
+#if defined(CONFIG_RFKILL) || defined(CONFIG_RFKILL_MODULE)
 	/*
 	 * check the h/w rfkill state on resume
 	 * and start the rfkill poll timer
-- 
1.5.5

