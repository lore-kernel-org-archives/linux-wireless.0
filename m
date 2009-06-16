Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:52704 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759216AbZFPSbR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Jun 2009 14:31:17 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 1/2] [compat-2.6] Update compat.diff
Date: Tue, 16 Jun 2009 20:31:09 +0200
Message-Id: <1245177070-13290-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 compat/compat.diff |  130 +++-------------------------------------------------
 1 files changed, 7 insertions(+), 123 deletions(-)

diff --git a/compat/compat.diff b/compat/compat.diff
index cbf0b9e..c309732 100644
--- a/compat/compat.diff
+++ b/compat/compat.diff
@@ -195,133 +195,17 @@
  
  #include "ath5k.h"
  #include "debug.h"
---- a/drivers/net/wireless/ath/ath9k/ath9k.h
-+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
-@@ -21,7 +21,11 @@
- #include <linux/device.h>
- #include <net/mac80211.h>
- #include <linux/leds.h>
-+#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,31))
- #include <linux/rfkill.h>
-+#else
-+#include <linux/rfkill_backport.h>
-+#endif
+--- a/drivers/net/wireless/ath/ath9k/hw.c
++++ b/drivers/net/wireless/ath/ath9k/hw.c
+@@ -3385,7 +3385,7 @@ void ath9k_hw_fill_cap_info(struct ath_hw *ah)
  
- #include "hw.h"
- #include "rc.h"
---- a/drivers/net/wireless/ath/ath9k/main.c
-+++ b/drivers/net/wireless/ath/ath9k/main.c
-@@ -1178,7 +1178,7 @@ void ath_radio_disable(struct ath_softc *sc)
- 	ath9k_ps_restore(sc);
- }
+ 	pCap->hw_caps |= ATH9K_HW_CAP_ENHANCEDPM;
  
 -#if defined(CONFIG_RFKILL) || defined(CONFIG_RFKILL_MODULE)
 +#if ((LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,31)) && defined(CONFIG_RFKILL) || defined(CONFIG_RFKILL_MODULE)) || ((LINUX_VERSION_CODE < KERNEL_VERSION(2,6,31)) && defined(CONFIG_RFKILL_BACKPORT) || defined(CONFIG_RFKILL_BACKPORT_MODULE))
- 
- /*******************/
- /*	Rfkill	   */
-@@ -1210,7 +1210,11 @@ static void ath_rfkill_poll_state(struct rfkill *rfkill, void *data)
- 	struct ath_softc *sc = data;
- 	bool blocked = !!ath_is_rfkill_set(sc);
- 
-+#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,31))
- 	if (rfkill_set_hw_state(rfkill, blocked))
-+#else
-+	if (backport_rfkill_set_hw_state(rfkill, blocked))
-+#endif
- 		ath_radio_disable(sc);
- 	else
- 		ath_radio_enable(sc);
-@@ -1226,10 +1230,17 @@ static int ath_init_sw_rfkill(struct ath_softc *sc)
- 	snprintf(sc->rf_kill.rfkill_name, sizeof(sc->rf_kill.rfkill_name),
- 		"ath9k-%s::rfkill", wiphy_name(sc->hw->wiphy));
- 
-+#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,31))
- 	sc->rf_kill.rfkill = rfkill_alloc(sc->rf_kill.rfkill_name,
- 					  wiphy_dev(sc->hw->wiphy),
- 					  RFKILL_TYPE_WLAN,
- 					  &sc->rf_kill.ops, sc);
-+#else
-+	sc->rf_kill.rfkill = backport_rfkill_alloc(sc->rf_kill.rfkill_name,
-+					  wiphy_dev(sc->hw->wiphy),
-+					  RFKILL_TYPE_WLAN,
-+					  &sc->rf_kill.ops, sc);
-+#endif
- 	if (!sc->rf_kill.rfkill) {
- 		DPRINTF(sc, ATH_DBG_FATAL, "Failed to allocate rfkill\n");
- 		return -ENOMEM;
-@@ -1242,8 +1253,13 @@ static int ath_init_sw_rfkill(struct ath_softc *sc)
- static void ath_deinit_rfkill(struct ath_softc *sc)
- {
- 	if (sc->sc_flags & SC_OP_RFKILL_REGISTERED) {
-+#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,31))
- 		rfkill_unregister(sc->rf_kill.rfkill);
- 		rfkill_destroy(sc->rf_kill.rfkill);
-+#else
-+		backport_rfkill_unregister(sc->rf_kill.rfkill);
-+		backport_rfkill_destroy(sc->rf_kill.rfkill);
-+#endif
- 		sc->sc_flags &= ~SC_OP_RFKILL_REGISTERED;
- 	}
- }
-@@ -1251,10 +1267,18 @@ static void ath_deinit_rfkill(struct ath_softc *sc)
- static int ath_start_rfkill_poll(struct ath_softc *sc)
- {
- 	if (!(sc->sc_flags & SC_OP_RFKILL_REGISTERED)) {
-+#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,31))
- 		if (rfkill_register(sc->rf_kill.rfkill)) {
-+#else
-+		if (backport_rfkill_register(sc->rf_kill.rfkill)) {
-+#endif
- 			DPRINTF(sc, ATH_DBG_FATAL,
- 				"Unable to register rfkill\n");
-+#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,31))
- 			rfkill_destroy(sc->rf_kill.rfkill);
-+#else
-+			backport_rfkill_destroy(sc->rf_kill.rfkill);
-+#endif
- 
- 			/* Deinitialize the device */
- 			ath_cleanup(sc);
-@@ -1286,7 +1310,7 @@ void ath_detach(struct ath_softc *sc)
- 
- 	DPRINTF(sc, ATH_DBG_CONFIG, "Detach ATH hw\n");
- 
--#if defined(CONFIG_RFKILL) || defined(CONFIG_RFKILL_MODULE)
-+#if ((LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,31)) && defined(CONFIG_RFKILL) || defined(CONFIG_RFKILL_MODULE)) || ((LINUX_VERSION_CODE < KERNEL_VERSION(2,6,31)) && defined(CONFIG_RFKILL_BACKPORT) || defined(CONFIG_RFKILL_BACKPORT_MODULE))
- 	ath_deinit_rfkill(sc);
- #endif
- 	ath_deinit_leds(sc);
-@@ -1626,7 +1650,7 @@ int ath_attach(u16 devid, struct ath_softc *sc)
- 	if (error != 0)
- 		goto error_attach;
- 
--#if defined(CONFIG_RFKILL) || defined(CONFIG_RFKILL_MODULE)
-+#if ((LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,31)) && defined(CONFIG_RFKILL) || defined(CONFIG_RFKILL_MODULE)) || ((LINUX_VERSION_CODE < KERNEL_VERSION(2,6,31)) && defined(CONFIG_RFKILL_BACKPORT) || defined(CONFIG_RFKILL_BACKPORT_MODULE))
- 	/* Initialize s/w rfkill */
- 	error = ath_init_sw_rfkill(sc);
- 	if (error)
-@@ -2018,7 +2042,7 @@ static int ath9k_start(struct ieee80211_hw *hw)
- 
- 	ieee80211_wake_queues(hw);
- 
--#if defined(CONFIG_RFKILL) || defined(CONFIG_RFKILL_MODULE)
-+#if ((LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,31)) && defined(CONFIG_RFKILL) || defined(CONFIG_RFKILL_MODULE)) || ((LINUX_VERSION_CODE < KERNEL_VERSION(2,6,31)) && defined(CONFIG_RFKILL_BACKPORT) || defined(CONFIG_RFKILL_BACKPORT_MODULE))
- 	r = ath_start_rfkill_poll(sc);
- #endif
- 
-@@ -2159,7 +2183,11 @@ static void ath9k_stop(struct ieee80211_hw *hw)
- 	} else
- 		sc->rx.rxlink = NULL;
- 
-+#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,31))
- 	rfkill_pause_polling(sc->rf_kill.rfkill);
-+#else
-+	backport_rfkill_pause_polling(sc->rf_kill.rfkill);
-+#endif
- 
- 	/* disable HAL and put h/w to sleep */
- 	ath9k_hw_disable(sc->sc_ah);
+ 	ah->rfsilent = ah->eep_ops->get_eeprom(ah, EEP_RF_SILENT);
+ 	if (ah->rfsilent & EEP_RFSILENT_ENABLED) {
+ 		ah->rfkill_gpio =
 --- a/drivers/net/wireless/b43/pcmcia.c
 +++ b/drivers/net/wireless/b43/pcmcia.c
 @@ -87,7 +87,11 @@ static int __devinit b43_pcmcia_probe(struct pcmcia_device *dev)
-- 
1.6.2.1

