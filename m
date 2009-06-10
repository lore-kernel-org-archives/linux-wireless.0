Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:4697 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760196AbZFJDoD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Jun 2009 23:44:03 -0400
Date: Tue, 9 Jun 2009 23:43:11 -0400
From: Bob Copeland <me@bobcopeland.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Tobias Doerffel <tobias.doerffel@gmail.com>,
	ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Subject: [PATCH] ath5k: minor rfkill cleanup
Message-ID: <20090610034311.GD19635@hash.localnet>
References: <20090607150755.GA19635@hash.localnet> <1244561607-6304-1-git-send-email-tobias.doerffel@gmail.com> <b6c5339f0906091126k573b8725hf623367abcdcdf1f@mail.gmail.com> <20090609190026.GA3910@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20090609190026.GA3910@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Always enable rfkill since the ifdefs in the code is not really worth
the Kconfig option.  Also fix a few code style things, and remove the
usage of the ah_gpio[] array so we can remove it later.

Signed-off-by: Bob Copeland <me@bobcopeland.com>
---
 drivers/net/wireless/ath/ath5k/Kconfig  |    8 --------
 drivers/net/wireless/ath/ath5k/Makefile |    2 +-
 drivers/net/wireless/ath/ath5k/ath5k.h  |    5 -----
 drivers/net/wireless/ath/ath5k/base.c   |    5 +----
 drivers/net/wireless/ath/ath5k/base.h   |    2 --
 drivers/net/wireless/ath/ath5k/rfkill.c |   12 ++++++------
 6 files changed, 8 insertions(+), 26 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/Kconfig b/drivers/net/wireless/ath/ath5k/Kconfig
index 4863f4b..509b6f9 100644
--- a/drivers/net/wireless/ath/ath5k/Kconfig
+++ b/drivers/net/wireless/ath/ath5k/Kconfig
@@ -39,11 +39,3 @@ config ATH5K_DEBUG
 
 	  modprobe ath5k debug=0x00000400
 
-config ATH5K_RFKILL
-	bool "Atheros 5xxx rfkill support"
-	depends on ATH5K
-	default y
-	---help---
-	  Include support for enabling/disabling WiFi via rfkill switch
-	  with Atheros 5xxx cards
-
diff --git a/drivers/net/wireless/ath/ath5k/Makefile b/drivers/net/wireless/ath/ath5k/Makefile
index f1e281c..090dc6d 100644
--- a/drivers/net/wireless/ath/ath5k/Makefile
+++ b/drivers/net/wireless/ath/ath5k/Makefile
@@ -11,6 +11,6 @@ ath5k-y				+= reset.o
 ath5k-y				+= attach.o
 ath5k-y				+= base.o
 ath5k-y				+= led.o
+ath5k-y				+= rfkill.o
 ath5k-$(CONFIG_ATH5K_DEBUG)	+= debug.o
-ath5k-$(CONFIG_ATH5K_RFKILL)	+= rfkill.o
 obj-$(CONFIG_ATH5K)		+= ath5k.o
diff --git a/drivers/net/wireless/ath/ath5k/ath5k.h b/drivers/net/wireless/ath/ath5k/ath5k.h
index 4c84e30..6358233 100644
--- a/drivers/net/wireless/ath/ath5k/ath5k.h
+++ b/drivers/net/wireless/ath/ath5k/ath5k.h
@@ -1257,13 +1257,8 @@ extern int ath5k_hw_set_gpio(struct ath5k_hw *ah, u32 gpio, u32 val);
 extern void ath5k_hw_set_gpio_intr(struct ath5k_hw *ah, unsigned int gpio, u32 interrupt_level);
 
 /* rfkill Functions */
-#ifdef CONFIG_ATH5K_RFKILL
 extern void ath5k_rfkill_hw_start(struct ath5k_hw *ah);
 extern void ath5k_rfkill_hw_stop(struct ath5k_hw *ah);
-#else
-static inline void ath5k_rfkill_hw_start(struct ath5k_hw *ah) {}
-static inline void ath5k_rfkill_hw_stop(struct ath5k_hw *ah) {}
-#endif
 
 /* Misc functions */
 int ath5k_hw_set_capabilities(struct ath5k_hw *ah);
diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index f55675c..55f7de0 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -2530,12 +2530,9 @@ ath5k_intr(int irq, void *dev_id)
 				 */
 				ath5k_hw_update_mib_counters(ah, &sc->ll_stats);
 			}
-#ifdef CONFIG_ATH5K_RFKILL
 			if (status & AR5K_INT_GPIO)
-			{
 				tasklet_schedule(&sc->rf_kill.toggleq);
-			}
-#endif
+
 		}
 	} while (ath5k_hw_is_intr_pending(ah) && --counter > 0);
 
diff --git a/drivers/net/wireless/ath/ath5k/base.h b/drivers/net/wireless/ath/ath5k/base.h
index 7a0ecdd..f9b7f2f 100644
--- a/drivers/net/wireless/ath/ath5k/base.h
+++ b/drivers/net/wireless/ath/ath5k/base.h
@@ -177,9 +177,7 @@ struct ath5k_softc {
 	struct tasklet_struct	txtq;		/* tx intr tasklet */
 	struct ath5k_led	tx_led;		/* tx led */
 
-#ifdef CONFIG_ATH5K_RFKILL
 	struct ath5k_rfkill	rf_kill;
-#endif
 
 	spinlock_t		block;		/* protects beacon */
 	struct tasklet_struct	beacontq;	/* beacon intr tasklet */
diff --git a/drivers/net/wireless/ath/ath5k/rfkill.c b/drivers/net/wireless/ath/ath5k/rfkill.c
index 492ada9..41a877b 100644
--- a/drivers/net/wireless/ath/ath5k/rfkill.c
+++ b/drivers/net/wireless/ath/ath5k/rfkill.c
@@ -56,10 +56,12 @@ static inline void ath5k_rfkill_enable(struct ath5k_softc *sc)
 static inline void ath5k_rfkill_set_intr(struct ath5k_softc *sc, bool enable)
 {
 	struct ath5k_hw *ah = sc->ah;
+	u32 curval;
+
 	ath5k_hw_set_gpio_input(ah, sc->rf_kill.gpio);
-	ah->ah_gpio[0] = ath5k_hw_get_gpio(ah, sc->rf_kill.gpio);
+	curval = ath5k_hw_get_gpio(ah, sc->rf_kill.gpio);
 	ath5k_hw_set_gpio_intr(ah, sc->rf_kill.gpio, enable ?
-					!!ah->ah_gpio[0] : !ah->ah_gpio[0]);
+					!!curval : !curval);
 }
 
 static bool
@@ -97,9 +99,8 @@ ath5k_rfkill_hw_start(struct ath5k_hw *ah)
 	ath5k_rfkill_disable(sc);
 
 	/* enable interrupt for rfkill switch */
-	if (AR5K_EEPROM_HDR_RFKILL(ah->ah_capabilities.cap_eeprom.ee_header)) {
+	if (AR5K_EEPROM_HDR_RFKILL(ah->ah_capabilities.cap_eeprom.ee_header))
 		ath5k_rfkill_set_intr(sc, true);
-	}
 }
 
 
@@ -109,9 +110,8 @@ ath5k_rfkill_hw_stop(struct ath5k_hw *ah)
 	struct ath5k_softc *sc = ah->ah_sc;
 
 	/* disable interrupt for rfkill switch */
-	if (AR5K_EEPROM_HDR_RFKILL(ah->ah_capabilities.cap_eeprom.ee_header)) {
+	if (AR5K_EEPROM_HDR_RFKILL(ah->ah_capabilities.cap_eeprom.ee_header))
 		ath5k_rfkill_set_intr(sc, false);
-	}
 
 	tasklet_kill(&sc->rf_kill.toggleq);
 
-- 
1.6.0.6


