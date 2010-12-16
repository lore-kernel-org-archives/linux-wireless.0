Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:36134 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752790Ab0LPX5S (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Dec 2010 18:57:18 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, lrodriguez@atheros.com,
	Felix Fietkau <nbd@openwrt.org>
Subject: [PATCH 2/2] ath9k_hw: remove baseband rfsilent support
Date: Fri, 17 Dec 2010 00:57:01 +0100
Message-Id: <1292543821-95686-2-git-send-email-nbd@openwrt.org>
In-Reply-To: <1292543821-95686-1-git-send-email-nbd@openwrt.org>
References: <1292543821-95686-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When rfkill is enabled, ath9k_hw unnecessarily configured the baseband to
turn off based on GPIO input, however that code was hardcoded to GPIO 0
instead of ah->rfkill_gpio.
Since ath9k uses software rfkill anyway, this code is completely unnecessary
and should be removed in case anything else ever uses GPIO 0.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ar5008_phy.c |   13 -------------
 drivers/net/wireless/ath/ath9k/ar9003_phy.c |   23 -----------------------
 drivers/net/wireless/ath/ath9k/hw-ops.h     |    5 -----
 drivers/net/wireless/ath/ath9k/hw.c         |    2 +-
 drivers/net/wireless/ath/ath9k/hw.h         |    1 -
 5 files changed, 1 insertions(+), 43 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar5008_phy.c b/drivers/net/wireless/ath/ath9k/ar5008_phy.c
index 059330a..ffcf44a 100644
--- a/drivers/net/wireless/ath/ath9k/ar5008_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar5008_phy.c
@@ -961,18 +961,6 @@ static void ar5008_hw_rfbus_done(struct ath_hw *ah)
 	REG_WRITE(ah, AR_PHY_RFBUS_REQ, 0);
 }
 
-static void ar5008_hw_enable_rfkill(struct ath_hw *ah)
-{
-	REG_SET_BIT(ah, AR_GPIO_INPUT_EN_VAL,
-		    AR_GPIO_INPUT_EN_VAL_RFSILENT_BB);
-
-	REG_CLR_BIT(ah, AR_GPIO_INPUT_MUX2,
-		    AR_GPIO_INPUT_MUX2_RFSILENT);
-
-	ath9k_hw_cfg_gpio_input(ah, ah->rfkill_gpio);
-	REG_SET_BIT(ah, AR_PHY_TEST, RFSILENT_BB);
-}
-
 static void ar5008_restore_chainmask(struct ath_hw *ah)
 {
 	int rx_chainmask = ah->rxchainmask;
@@ -1629,7 +1617,6 @@ void ar5008_hw_attach_phy_ops(struct ath_hw *ah)
 	priv_ops->set_delta_slope = ar5008_hw_set_delta_slope;
 	priv_ops->rfbus_req = ar5008_hw_rfbus_req;
 	priv_ops->rfbus_done = ar5008_hw_rfbus_done;
-	priv_ops->enable_rfkill = ar5008_hw_enable_rfkill;
 	priv_ops->restore_chainmask = ar5008_restore_chainmask;
 	priv_ops->set_diversity = ar5008_set_diversity;
 	priv_ops->do_getnf = ar5008_hw_do_getnf;
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.c b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
index da4a571..cdf46c1 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
@@ -748,28 +748,6 @@ static void ar9003_hw_rfbus_done(struct ath_hw *ah)
 	REG_WRITE(ah, AR_PHY_RFBUS_REQ, 0);
 }
 
-/*
- * Set the interrupt and GPIO values so the ISR can disable RF
- * on a switch signal.  Assumes GPIO port and interrupt polarity
- * are set prior to call.
- */
-static void ar9003_hw_enable_rfkill(struct ath_hw *ah)
-{
-	/* Connect rfsilent_bb_l to baseband */
-	REG_SET_BIT(ah, AR_GPIO_INPUT_EN_VAL,
-		    AR_GPIO_INPUT_EN_VAL_RFSILENT_BB);
-	/* Set input mux for rfsilent_bb_l to GPIO #0 */
-	REG_CLR_BIT(ah, AR_GPIO_INPUT_MUX2,
-		    AR_GPIO_INPUT_MUX2_RFSILENT);
-
-	/*
-	 * Configure the desired GPIO port for input and
-	 * enable baseband rf silence.
-	 */
-	ath9k_hw_cfg_gpio_input(ah, ah->rfkill_gpio);
-	REG_SET_BIT(ah, AR_PHY_TEST, RFSILENT_BB);
-}
-
 static void ar9003_hw_set_diversity(struct ath_hw *ah, bool value)
 {
 	u32 v = REG_READ(ah, AR_PHY_CCK_DETECT);
@@ -1206,7 +1184,6 @@ void ar9003_hw_attach_phy_ops(struct ath_hw *ah)
 	priv_ops->set_delta_slope = ar9003_hw_set_delta_slope;
 	priv_ops->rfbus_req = ar9003_hw_rfbus_req;
 	priv_ops->rfbus_done = ar9003_hw_rfbus_done;
-	priv_ops->enable_rfkill = ar9003_hw_enable_rfkill;
 	priv_ops->set_diversity = ar9003_hw_set_diversity;
 	priv_ops->ani_control = ar9003_hw_ani_control;
 	priv_ops->do_getnf = ar9003_hw_do_getnf;
diff --git a/drivers/net/wireless/ath/ath9k/hw-ops.h b/drivers/net/wireless/ath/ath9k/hw-ops.h
index 0a4ad34..c8f254f 100644
--- a/drivers/net/wireless/ath/ath9k/hw-ops.h
+++ b/drivers/net/wireless/ath/ath9k/hw-ops.h
@@ -223,11 +223,6 @@ static inline void ath9k_hw_rfbus_done(struct ath_hw *ah)
 	return ath9k_hw_private_ops(ah)->rfbus_done(ah);
 }
 
-static inline void ath9k_enable_rfkill(struct ath_hw *ah)
-{
-	return ath9k_hw_private_ops(ah)->enable_rfkill(ah);
-}
-
 static inline void ath9k_hw_restore_chainmask(struct ath_hw *ah)
 {
 	if (!ath9k_hw_private_ops(ah)->restore_chainmask)
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 0f373be..beb513d 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1383,7 +1383,7 @@ int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 	ath9k_hw_init_qos(ah);
 
 	if (ah->caps.hw_caps & ATH9K_HW_CAP_RFSILENT)
-		ath9k_enable_rfkill(ah);
+		ath9k_hw_cfg_gpio_input(ah, ah->rfkill_gpio);
 
 	ath9k_hw_init_global_settings(ah);
 
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 97f22c4..a461e67 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -576,7 +576,6 @@ struct ath_hw_private_ops {
 	void (*set_delta_slope)(struct ath_hw *ah, struct ath9k_channel *chan);
 	bool (*rfbus_req)(struct ath_hw *ah);
 	void (*rfbus_done)(struct ath_hw *ah);
-	void (*enable_rfkill)(struct ath_hw *ah);
 	void (*restore_chainmask)(struct ath_hw *ah);
 	void (*set_diversity)(struct ath_hw *ah, bool value);
 	u32 (*compute_pll_control)(struct ath_hw *ah,
-- 
1.7.3.2

