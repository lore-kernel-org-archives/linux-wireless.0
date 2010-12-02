Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.ch ([80.75.119.105]:53053 "EHLO mail.neratec.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756405Ab0LBJ1Y (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Dec 2010 04:27:24 -0500
Date: Thu, 2 Dec 2010 10:27:21 +0100 (CET)
From: Wojciech Dubowik <dubowoj@neratec.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, nbd@openwrt.org,
	ath5k-devel@lists.ath5k.org, mickflemm@gmail.com
Message-ID: <23274444.1521291282037263.JavaMail.wlan@CHBU500181>
In-Reply-To: <32371853.1301291281887500.JavaMail.wlan@CHBU500181>
Subject: [PATCH v7 9/9] ath5k: Fix reset and interrupts for AHB type of
 devices.
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Felix Fietkau <nbd@openwrt.org>

On WiSoc we cannot access mac register before it is resetted.
It will crash hardware otherwise.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: Wojciech Dubowik <Wojciech.Dubowik@neratec.com>
---
 drivers/net/wireless/ath/ath5k/base.c  |    7 ++-
 drivers/net/wireless/ath/ath5k/reset.c |  103 ++++++++++++++++++++++++++++----
 2 files changed, 97 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index 685de2d..0a7071a 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -2148,7 +2148,8 @@ ath5k_intr(int irq, void *dev_id)
 	unsigned int counter = 1000;
 
 	if (unlikely(test_bit(ATH_STAT_INVALID, sc->status) ||
-				!ath5k_hw_is_intr_pending(ah)))
+		((ath5k_get_bus_type(ah) != ATH_AHB) &&
+				!ath5k_hw_is_intr_pending(ah))))
 		return IRQ_NONE;
 
 	do {
@@ -2214,6 +2215,10 @@ ath5k_intr(int irq, void *dev_id)
 				tasklet_schedule(&sc->rf_kill.toggleq);
 
 		}
+
+		if (ath5k_get_bus_type(ah) == ATH_AHB)
+			break;
+
 	} while (ath5k_hw_is_intr_pending(ah) && --counter > 0);
 
 	if (unlikely(!counter))
diff --git a/drivers/net/wireless/ath/ath5k/reset.c b/drivers/net/wireless/ath/ath5k/reset.c
index f2f889d..bc84aaa 100644
--- a/drivers/net/wireless/ath/ath5k/reset.c
+++ b/drivers/net/wireless/ath/ath5k/reset.c
@@ -27,6 +27,7 @@
 
 #include <linux/pci.h> 		/* To determine if a card is pci-e */
 #include <linux/log2.h>
+#include <linux/platform_device.h>
 #include "ath5k.h"
 #include "reg.h"
 #include "base.h"
@@ -141,7 +142,9 @@ static void ath5k_hw_init_core_clock(struct ath5k_hw *ah)
 
 	/* Set 32MHz USEC counter */
 	if ((ah->ah_radio == AR5K_RF5112) ||
-	(ah->ah_radio == AR5K_RF5413))
+		(ah->ah_radio == AR5K_RF5413) ||
+		(ah->ah_radio == AR5K_RF2316) ||
+		(ah->ah_radio == AR5K_RF2317))
 	/* Remain on 40MHz clock ? */
 		sclock = 40 - 1;
 	else
@@ -244,6 +247,7 @@ static void ath5k_hw_set_sleep_clock(struct ath5k_hw *ah, bool enable)
 
 		if ((ah->ah_radio == AR5K_RF5112) ||
 		(ah->ah_radio == AR5K_RF5413) ||
+		(ah->ah_radio == AR5K_RF2316) ||
 		(ah->ah_mac_version == (AR5K_SREV_AR2417 >> 4)))
 			spending = 0x14;
 		else
@@ -299,6 +303,7 @@ static void ath5k_hw_set_sleep_clock(struct ath5k_hw *ah, bool enable)
 
 		if ((ah->ah_radio == AR5K_RF5112) ||
 		(ah->ah_radio == AR5K_RF5413) ||
+		(ah->ah_radio == AR5K_RF2316) ||
 		(ah->ah_mac_version == (AR5K_SREV_AR2417 >> 4)))
 			spending = 0x14;
 		else
@@ -358,6 +363,64 @@ static int ath5k_hw_nic_reset(struct ath5k_hw *ah, u32 val)
 }
 
 /*
+ * Reset AHB chipset
+ * AR5K_RESET_CTL_PCU flag resets WMAC
+ * AR5K_RESET_CTL_BASEBAND flag resets WBB
+ */
+static int ath5k_hw_wisoc_reset(struct ath5k_hw *ah, u32 flags)
+{
+	u32 mask = flags ? flags : ~0U;
+	volatile u32 *reg;
+	u32 regval;
+	u32 val = 0;
+
+	/* ah->ah_mac_srev is not available at this point yet */
+	if (ah->ah_sc->devid >= AR5K_SREV_AR2315_R6) {
+		reg = (u32 *) AR5K_AR2315_RESET;
+		if (mask & AR5K_RESET_CTL_PCU)
+			val |= AR5K_AR2315_RESET_WMAC;
+		if (mask & AR5K_RESET_CTL_BASEBAND)
+			val |= AR5K_AR2315_RESET_BB_WARM;
+	} else {
+		reg = (u32 *) AR5K_AR5312_RESET;
+		if (to_platform_device(ah->ah_sc->dev)->id == 0) {
+			if (mask & AR5K_RESET_CTL_PCU)
+				val |= AR5K_AR5312_RESET_WMAC0;
+			if (mask & AR5K_RESET_CTL_BASEBAND)
+				val |= AR5K_AR5312_RESET_BB0_COLD |
+				       AR5K_AR5312_RESET_BB0_WARM;
+		} else {
+			if (mask & AR5K_RESET_CTL_PCU)
+				val |= AR5K_AR5312_RESET_WMAC1;
+			if (mask & AR5K_RESET_CTL_BASEBAND)
+				val |= AR5K_AR5312_RESET_BB1_COLD |
+				       AR5K_AR5312_RESET_BB1_WARM;
+		}
+	}
+
+	/* Put BB/MAC into reset */
+	regval = __raw_readl(reg);
+	__raw_writel(regval | val, reg);
+	regval = __raw_readl(reg);
+	udelay(100);
+
+	/* Bring BB/MAC out of reset */
+	__raw_writel(regval & ~val, reg);
+	regval = __raw_readl(reg);
+
+	/*
+	 * Reset configuration register (for hw byte-swap). Note that this
+	 * is only set for big endian. We do the necessary magic in
+	 * AR5K_INIT_CFG.
+	 */
+	if ((flags & AR5K_RESET_CTL_PCU) == 0)
+		ath5k_hw_reg_write(ah, AR5K_INIT_CFG, AR5K_CFG);
+
+	return 0;
+}
+
+
+/*
  * Sleep control
  */
 static int ath5k_hw_set_power(struct ath5k_hw *ah, enum ath5k_power_mode mode,
@@ -456,6 +519,9 @@ int ath5k_hw_on_hold(struct ath5k_hw *ah)
 	u32 bus_flags;
 	int ret;
 
+	if (ath5k_get_bus_type(ah) == ATH_AHB)
+		return 0;
+
 	/* Make sure device is awake */
 	ret = ath5k_hw_set_power(ah, AR5K_PM_AWAKE, true, 0);
 	if (ret) {
@@ -511,11 +577,13 @@ int ath5k_hw_nic_wakeup(struct ath5k_hw *ah, int flags, bool initial)
 	mode = 0;
 	clock = 0;
 
-	/* Wakeup the device */
-	ret = ath5k_hw_set_power(ah, AR5K_PM_AWAKE, true, 0);
-	if (ret) {
-		ATH5K_ERR(ah->ah_sc, "failed to wakeup the MAC Chip\n");
-		return ret;
+	if ((ath5k_get_bus_type(ah) != ATH_AHB) || !initial) {
+		/* Wakeup the device */
+		ret = ath5k_hw_set_power(ah, AR5K_PM_AWAKE, true, 0);
+		if (ret) {
+			ATH5K_ERR(ah->ah_sc, "failed to wakeup the MAC Chip\n");
+			return ret;
+		}
 	}
 
 	/*
@@ -534,8 +602,12 @@ int ath5k_hw_nic_wakeup(struct ath5k_hw *ah, int flags, bool initial)
 			AR5K_RESET_CTL_PHY | AR5K_RESET_CTL_PCI);
 			mdelay(2);
 	} else {
-		ret = ath5k_hw_nic_reset(ah, AR5K_RESET_CTL_PCU |
-			AR5K_RESET_CTL_BASEBAND | bus_flags);
+		if (ath5k_get_bus_type(ah) == ATH_AHB)
+			ret = ath5k_hw_wisoc_reset(ah, AR5K_RESET_CTL_PCU |
+				AR5K_RESET_CTL_BASEBAND);
+		else
+			ret = ath5k_hw_nic_reset(ah, AR5K_RESET_CTL_PCU |
+				AR5K_RESET_CTL_BASEBAND | bus_flags);
 	}
 
 	if (ret) {
@@ -550,9 +622,15 @@ int ath5k_hw_nic_wakeup(struct ath5k_hw *ah, int flags, bool initial)
 		return ret;
 	}
 
-	/* ...clear reset control register and pull device out of
-	 * warm reset */
-	if (ath5k_hw_nic_reset(ah, 0)) {
+	/* ...reset configuration regiter on Wisoc ...
+	 * ...clear reset control register and pull device out of
+	 * warm reset on others */
+	if (ath5k_get_bus_type(ah) == ATH_AHB)
+		ret = ath5k_hw_wisoc_reset(ah, 0);
+	else
+		ret = ath5k_hw_nic_reset(ah, 0);
+
+	if (ret) {
 		ATH5K_ERR(ah->ah_sc, "failed to warm reset the MAC Chip\n");
 		return -EIO;
 	}
@@ -708,7 +786,8 @@ static void ath5k_hw_tweak_initval_settings(struct ath5k_hw *ah,
 
 	/* Set fast ADC */
 	if ((ah->ah_radio == AR5K_RF5413) ||
-	(ah->ah_mac_version == (AR5K_SREV_AR2417 >> 4))) {
+		(ah->ah_radio == AR5K_RF2317) ||
+		(ah->ah_mac_version == (AR5K_SREV_AR2417 >> 4))) {
 		u32 fast_adc = true;
 
 		if (channel->center_freq == 2462 ||
-- 
1.7.1

