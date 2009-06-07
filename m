Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from jessica.hrz.tu-chemnitz.de ([134.109.132.47]:52849 "EHLO
	jessica.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752873AbZFGMK1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Jun 2009 08:10:27 -0400
From: Tobias Doerffel <tobias.doerffel@gmail.com>
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Cc: Tobias Doerffel <tobias.doerffel@gmail.com>
Subject: [PATCH] ath5k: added cfg80211 based rfkill support
Date: Sun,  7 Jun 2009 13:40:33 +0200
Message-Id: <1244374833-11987-1-git-send-email-tobias.doerffel@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch introduces initial rfkill support for the ath5k driver
based on rfkill support in the cfg80211 framework.
All rfkill related code is separated into newly created rfkill.c.

Changes to existing code are minimal:

* added a new data structure ath5k_rfkill to the ath5k_softc structure
* new function ath5k_eeprom_read_rfkill() for retrieving RFKILL related
  parameters from EEPROM
* inserted calls to HW rfkill init/deinit routines
* ath5k_intr() has been extended to handle AR5K_INT_GPIO interrupts
---
 drivers/net/wireless/ath/ath5k/Kconfig  |    9 +++
 drivers/net/wireless/ath/ath5k/Makefile |    1 +
 drivers/net/wireless/ath/ath5k/ath5k.h  |   10 +++
 drivers/net/wireless/ath/ath5k/base.c   |   10 +++
 drivers/net/wireless/ath/ath5k/base.h   |   14 ++++
 drivers/net/wireless/ath/ath5k/eeprom.c |   16 ++++
 drivers/net/wireless/ath/ath5k/reset.c  |   17 -----
 drivers/net/wireless/ath/ath5k/rfkill.c |  120 +++++++++++++++++++++++++++++++
 8 files changed, 180 insertions(+), 17 deletions(-)
 create mode 100644 drivers/net/wireless/ath/ath5k/rfkill.c

diff --git a/drivers/net/wireless/ath/ath5k/Kconfig b/drivers/net/wireless/ath/ath5k/Kconfig
index 509b6f9..5f18954 100644
--- a/drivers/net/wireless/ath/ath5k/Kconfig
+++ b/drivers/net/wireless/ath/ath5k/Kconfig
@@ -39,3 +39,12 @@ config ATH5K_DEBUG
 
 	  modprobe ath5k debug=0x00000400
 
+config ATH5K_RFKILL
+	bool "Atheros 5xxx rfkill support"
+	depends on RFKILL
+	depends on ATH5K
+	default y
+	---help---
+	  Include support for enabling/disabling WiFi via rfkill switch
+	  with Atheros 5xxx cards
+
diff --git a/drivers/net/wireless/ath/ath5k/Makefile b/drivers/net/wireless/ath/ath5k/Makefile
index 84a74c5..f1e281c 100644
--- a/drivers/net/wireless/ath/ath5k/Makefile
+++ b/drivers/net/wireless/ath/ath5k/Makefile
@@ -12,4 +12,5 @@ ath5k-y				+= attach.o
 ath5k-y				+= base.o
 ath5k-y				+= led.o
 ath5k-$(CONFIG_ATH5K_DEBUG)	+= debug.o
+ath5k-$(CONFIG_ATH5K_RFKILL)	+= rfkill.o
 obj-$(CONFIG_ATH5K)		+= ath5k.o
diff --git a/drivers/net/wireless/ath/ath5k/ath5k.h b/drivers/net/wireless/ath/ath5k/ath5k.h
index 8137182..125e896 100644
--- a/drivers/net/wireless/ath/ath5k/ath5k.h
+++ b/drivers/net/wireless/ath/ath5k/ath5k.h
@@ -1190,6 +1190,7 @@ extern void ath5k_hw_update_mib_counters(struct ath5k_hw *ah, struct ieee80211_l
 extern int ath5k_eeprom_init(struct ath5k_hw *ah);
 extern void ath5k_eeprom_detach(struct ath5k_hw *ah);
 extern int ath5k_eeprom_read_mac(struct ath5k_hw *ah, u8 *mac);
+extern void ath5k_eeprom_read_rfkill(struct ath5k_hw *ah, u16 *gpio, u8 *polarity);
 extern bool ath5k_eeprom_is_hb63(struct ath5k_hw *ah);
 
 /* Protocol Control Unit Functions */
@@ -1256,6 +1257,15 @@ extern u32 ath5k_hw_get_gpio(struct ath5k_hw *ah, u32 gpio);
 extern int ath5k_hw_set_gpio(struct ath5k_hw *ah, u32 gpio, u32 val);
 extern void ath5k_hw_set_gpio_intr(struct ath5k_hw *ah, unsigned int gpio, u32 interrupt_level);
 
+/* rfkill Functions */
+#ifdef CONFIG_ATH5K_RFKILL
+extern void ath5k_rfkill_hw_start(struct ath5k_hw *ah);
+extern void ath5k_rfkill_hw_stop(struct ath5k_hw *ah);
+#else
+static inline void ath5k_rfkill_hw_start(struct ath5k_hw *ah) {}
+static inline void ath5k_rfkill_hw_stop(struct ath5k_hw *ah) {}
+#endif
+
 /* Misc functions */
 int ath5k_hw_set_capabilities(struct ath5k_hw *ah);
 extern int ath5k_hw_get_capability(struct ath5k_hw *ah, enum ath5k_capability_type cap_type, u32 capability, u32 *result);
diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index 85a00db..f55675c 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -2360,6 +2360,8 @@ ath5k_init(struct ath5k_softc *sc)
 	if (ret)
 		goto done;
 
+	ath5k_rfkill_hw_start(ah);
+
 	/*
 	 * Reset the key cache since some parts do not reset the
 	 * contents on initial power up or resume from suspend.
@@ -2468,6 +2470,8 @@ ath5k_stop_hw(struct ath5k_softc *sc)
 	tasklet_kill(&sc->restq);
 	tasklet_kill(&sc->beacontq);
 
+	ath5k_rfkill_hw_stop(sc->ah);
+
 	return ret;
 }
 
@@ -2526,6 +2530,12 @@ ath5k_intr(int irq, void *dev_id)
 				 */
 				ath5k_hw_update_mib_counters(ah, &sc->ll_stats);
 			}
+#ifdef CONFIG_ATH5K_RFKILL
+			if (status & AR5K_INT_GPIO)
+			{
+				tasklet_schedule(&sc->rf_kill.toggleq);
+			}
+#endif
 		}
 	} while (ath5k_hw_is_intr_pending(ah) && --counter > 0);
 
diff --git a/drivers/net/wireless/ath/ath5k/base.h b/drivers/net/wireless/ath/ath5k/base.h
index 852b2c1..5e1f904 100644
--- a/drivers/net/wireless/ath/ath5k/base.h
+++ b/drivers/net/wireless/ath/ath5k/base.h
@@ -46,6 +46,7 @@
 #include <linux/wireless.h>
 #include <linux/if_ether.h>
 #include <linux/leds.h>
+#include <linux/rfkill.h>
 
 #include "ath5k.h"
 #include "debug.h"
@@ -91,6 +92,15 @@ struct ath5k_led
 	struct led_classdev led_dev;		/* led classdev */
 };
 
+/* Rfkill */
+struct ath5k_rfkill {
+	/* GPIO PIN for rfkill */
+	u16 gpio;
+	/* polarity of rfkill GPIO PIN */
+	u8 polarity;
+	/* RFKILL toggle tasklet */
+	struct tasklet_struct toggleq;
+};
 
 #if CHAN_DEBUG
 #define ATH_CHAN_MAX	(26+26+26+200+200)
@@ -167,6 +177,10 @@ struct ath5k_softc {
 	struct tasklet_struct	txtq;		/* tx intr tasklet */
 	struct ath5k_led	tx_led;		/* tx led */
 
+#ifdef CONFIG_ATH5K_RFKILL
+	struct ath5k_rfkill	rf_kill;
+#endif
+
 	spinlock_t		block;		/* protects beacon */
 	struct tasklet_struct	beacontq;	/* beacon intr tasklet */
 	struct ath5k_buf	*bbuf;		/* beacon buffer */
diff --git a/drivers/net/wireless/ath/ath5k/eeprom.c b/drivers/net/wireless/ath/ath5k/eeprom.c
index c56b494..ff00502 100644
--- a/drivers/net/wireless/ath/ath5k/eeprom.c
+++ b/drivers/net/wireless/ath/ath5k/eeprom.c
@@ -1800,3 +1800,19 @@ int ath5k_eeprom_read_mac(struct ath5k_hw *ah, u8 *mac)
 
 	return 0;
 }
+
+
+/*
+ * Read RFKILL GPIO configuration from eeprom
+ */
+void ath5k_eeprom_read_rfkill(struct ath5k_hw *ah, u16 *gpio, u8 *polarity)
+{
+	u16 data;
+
+	ath5k_hw_eeprom_read(ah, AR5K_EEPROM_RFKILL_GPIO_SEL, &data);
+	*gpio = AR5K_REG_MS(data, AR5K_EEPROM_RFKILL_GPIO_SEL);
+
+	ath5k_hw_eeprom_read(ah, AR5K_EEPROM_RFKILL_POLARITY, &data);
+	*polarity = AR5K_REG_MS(data, AR5K_EEPROM_RFKILL_POLARITY);
+}
+
diff --git a/drivers/net/wireless/ath/ath5k/reset.c b/drivers/net/wireless/ath/ath5k/reset.c
index bd1940e..8077f0a 100644
--- a/drivers/net/wireless/ath/ath5k/reset.c
+++ b/drivers/net/wireless/ath/ath5k/reset.c
@@ -1305,23 +1305,6 @@ int ath5k_hw_reset(struct ath5k_hw *ah, enum nl80211_iftype op_mode,
 	if (ah->ah_version != AR5K_AR5210)
 		ath5k_hw_set_imr(ah, ah->ah_imr);
 
-	/*
-	 * Setup RFKill interrupt if rfkill flag is set on eeprom.
-	 * TODO: Use gpio pin and polarity infos from eeprom
-	 * TODO: Handle this in ath5k_intr because it'll result
-	 * 	 a nasty interrupt storm.
-	 */
-#if 0
-	if (AR5K_EEPROM_HDR_RFKILL(ah->ah_capabilities.cap_eeprom.ee_header)) {
-		ath5k_hw_set_gpio_input(ah, 0);
-		ah->ah_gpio[0] = ath5k_hw_get_gpio(ah, 0);
-		if (ah->ah_gpio[0] == 0)
-			ath5k_hw_set_gpio_intr(ah, 0, 1);
-		else
-			ath5k_hw_set_gpio_intr(ah, 0, 0);
-	}
-#endif
-
 	/* Enable 32KHz clock function for AR5212+ chips
 	 * Set clocks to 32KHz operation and use an
 	 * external 32KHz crystal when sleeping if one
diff --git a/drivers/net/wireless/ath/ath5k/rfkill.c b/drivers/net/wireless/ath/ath5k/rfkill.c
new file mode 100644
index 0000000..b57ab27
--- /dev/null
+++ b/drivers/net/wireless/ath/ath5k/rfkill.c
@@ -0,0 +1,120 @@
+/*
+ * RFKILL support for ath5k
+ *
+ * Copyright (c) 2009 Tobias Doerffel <tobias.doerffel@gmail.com>
+ *
+ * All rights reserved.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ * 1. Redistributions of source code must retain the above copyright
+ *    notice, this list of conditions and the following disclaimer,
+ *    without modification.
+ * 2. Redistributions in binary form must reproduce at minimum a disclaimer
+ *    similar to the "NO WARRANTY" disclaimer below ("Disclaimer") and any
+ *    redistribution must be conditioned upon including a substantially
+ *    similar Disclaimer requirement for further binary redistribution.
+ * 3. Neither the names of the above-listed copyright holders nor the names
+ *    of any contributors may be used to endorse or promote products derived
+ *    from this software without specific prior written permission.
+ *
+ * NO WARRANTY
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+ * ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+ * LIMITED TO, THE IMPLIED WARRANTIES OF NONINFRINGEMENT, MERCHANTIBILITY
+ * AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL
+ * THE COPYRIGHT HOLDERS OR CONTRIBUTORS BE LIABLE FOR SPECIAL, EXEMPLARY,
+ * OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
+ * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
+ * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER
+ * IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
+ * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF
+ * THE POSSIBILITY OF SUCH DAMAGES.
+ */
+
+#include "base.h"
+
+
+static inline void ath5k_rfkill_disable(struct ath5k_softc *sc)
+{
+	ATH5K_DBG(sc, ATH5K_DEBUG_ANY, "rfkill disable (gpio:%d polarity:%d)\n",
+		sc->rf_kill.gpio, sc->rf_kill.polarity);
+	ath5k_hw_set_gpio_output(sc->ah, sc->rf_kill.gpio);
+	ath5k_hw_set_gpio(sc->ah, sc->rf_kill.gpio, !sc->rf_kill.polarity);
+}
+
+
+static inline void ath5k_rfkill_enable(struct ath5k_softc *sc)
+{
+	ATH5K_DBG(sc, ATH5K_DEBUG_ANY, "rfkill enable (gpio:%d polarity:%d)\n",
+		sc->rf_kill.gpio, sc->rf_kill.polarity);
+	ath5k_hw_set_gpio_output(sc->ah, sc->rf_kill.gpio);
+	ath5k_hw_set_gpio(sc->ah, sc->rf_kill.gpio, sc->rf_kill.polarity);
+}
+
+static inline void ath5k_rfkill_set_intr(struct ath5k_softc *sc, bool enable)
+{
+	struct ath5k_hw *ah = sc->ah;
+	ath5k_hw_set_gpio_input(ah, sc->rf_kill.gpio);
+	ah->ah_gpio[0] = ath5k_hw_get_gpio(ah, sc->rf_kill.gpio);
+	ath5k_hw_set_gpio_intr(ah, sc->rf_kill.gpio, enable ?
+					!!ah->ah_gpio[0] : !ah->ah_gpio[0]);
+}
+
+static bool
+ath5k_is_rfkill_set(struct ath5k_softc *sc)
+{
+	/* configuring GPIO for input for some reason disables rfkill */
+	/*ath5k_hw_set_gpio_input(sc->ah, sc->rf_kill.gpio);*/
+	return ath5k_hw_get_gpio(sc->ah, sc->rf_kill.gpio) ==
+							sc->rf_kill.polarity;
+}
+
+static void
+ath5k_tasklet_rfkill_toggle(unsigned long data)
+{
+	struct ath5k_softc *sc = (void *)data;
+	bool blocked;
+
+	blocked = ath5k_is_rfkill_set(sc);
+	wiphy_rfkill_set_hw_state(sc->hw->wiphy, blocked);
+}
+
+
+void
+ath5k_rfkill_hw_start(struct ath5k_hw *ah)
+{
+	struct ath5k_softc *sc = ah->ah_sc;
+
+	/* read rfkill GPIO configuration from EEPROM */
+	ath5k_eeprom_read_rfkill(ah, &sc->rf_kill.gpio, &sc->rf_kill.polarity);
+
+	tasklet_init(&sc->rf_kill.toggleq, ath5k_tasklet_rfkill_toggle,
+		(unsigned long)sc);
+
+	ath5k_rfkill_disable(sc);
+
+	/* enable interrupt for rfkill switch */
+	if (AR5K_EEPROM_HDR_RFKILL(ah->ah_capabilities.cap_eeprom.ee_header)) {
+		ath5k_rfkill_set_intr(sc, true);
+	}
+}
+
+
+void
+ath5k_rfkill_hw_stop(struct ath5k_hw *ah)
+{
+	struct ath5k_softc *sc = ah->ah_sc;
+
+	/* disable interrupt for rfkill switch */
+	if (AR5K_EEPROM_HDR_RFKILL(ah->ah_capabilities.cap_eeprom.ee_header)) {
+		ath5k_rfkill_set_intr(sc, false);
+	}
+
+	tasklet_kill(&sc->rf_kill.toggleq);
+
+	/* enable RFKILL when stopping HW so Wifi LED is turned off */
+	ath5k_rfkill_enable(sc);
+}
+
-- 
1.6.3.1

