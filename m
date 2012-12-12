Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:40648 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751494Ab2LLMOe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Dec 2012 07:14:34 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, mcgrof@qca.qualcomm.com
Subject: [PATCH 2/2] ath9k_hw: use the devres API for allocations
Date: Wed, 12 Dec 2012 13:14:23 +0100
Message-Id: <1355314463-17742-2-git-send-email-nbd@openwrt.org> (sfid-20121212_131438_825432_08BE25EB)
In-Reply-To: <1355314463-17742-1-git-send-email-nbd@openwrt.org>
References: <1355314463-17742-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ar5008_phy.c | 50 +++++++++--------------------
 drivers/net/wireless/ath/ath9k/ar9002_hw.c  | 11 +++++--
 drivers/net/wireless/ath/ath9k/ar9002_phy.c |  2 --
 drivers/net/wireless/ath/ath9k/hw-ops.h     | 16 ---------
 drivers/net/wireless/ath/ath9k/hw.c         | 28 ++++++----------
 drivers/net/wireless/ath/ath9k/hw.h         |  9 ++----
 drivers/net/wireless/ath/ath9k/init.c       |  1 +
 7 files changed, 37 insertions(+), 80 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar5008_phy.c b/drivers/net/wireless/ath/ath9k/ar5008_phy.c
index 874186b..fd69376 100644
--- a/drivers/net/wireless/ath/ath9k/ar5008_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar5008_phy.c
@@ -470,16 +470,15 @@ static void ar5008_hw_spur_mitigate(struct ath_hw *ah,
 static int ar5008_hw_rf_alloc_ext_banks(struct ath_hw *ah)
 {
 #define ATH_ALLOC_BANK(bank, size) do { \
-		bank = kzalloc((sizeof(u32) * size), GFP_KERNEL); \
-		if (!bank) { \
-			ath_err(common, "Cannot allocate RF banks\n"); \
-			return -ENOMEM; \
-		} \
+		bank = devm_kzalloc(ah->dev, sizeof(u32) * size, GFP_KERNEL); \
+		if (!bank) \
+			goto error; \
 	} while (0);
 
 	struct ath_common *common = ath9k_hw_common(ah);
 
-	BUG_ON(AR_SREV_9280_20_OR_LATER(ah));
+	if (AR_SREV_9280_20_OR_LATER(ah))
+	    return 0;
 
 	ATH_ALLOC_BANK(ah->analogBank0Data, ah->iniBank0.ia_rows);
 	ATH_ALLOC_BANK(ah->analogBank1Data, ah->iniBank1.ia_rows);
@@ -492,35 +491,12 @@ static int ar5008_hw_rf_alloc_ext_banks(struct ath_hw *ah)
 
 	return 0;
 #undef ATH_ALLOC_BANK
+error:
+	ath_err(common, "Cannot allocate RF banks\n");
+	return -ENOMEM;
 }
 
 
-/**
- * ar5008_hw_rf_free_ext_banks - Free memory for analog bank scratch buffers
- * @ah: atheros hardware struture
- * For the external AR2133/AR5133 radios banks.
- */
-static void ar5008_hw_rf_free_ext_banks(struct ath_hw *ah)
-{
-#define ATH_FREE_BANK(bank) do { \
-		kfree(bank); \
-		bank = NULL; \
-	} while (0);
-
-	BUG_ON(AR_SREV_9280_20_OR_LATER(ah));
-
-	ATH_FREE_BANK(ah->analogBank0Data);
-	ATH_FREE_BANK(ah->analogBank1Data);
-	ATH_FREE_BANK(ah->analogBank2Data);
-	ATH_FREE_BANK(ah->analogBank3Data);
-	ATH_FREE_BANK(ah->analogBank6Data);
-	ATH_FREE_BANK(ah->analogBank6TPCData);
-	ATH_FREE_BANK(ah->analogBank7Data);
-	ATH_FREE_BANK(ah->bank6Temp);
-
-#undef ATH_FREE_BANK
-}
-
 /* *
  * ar5008_hw_set_rf_regs - programs rf registers based on EEPROM
  * @ah: atheros hardware structure
@@ -1380,7 +1356,7 @@ static void ar5008_hw_set_radar_conf(struct ath_hw *ah)
 	conf->radar_inband = 8;
 }
 
-void ar5008_hw_attach_phy_ops(struct ath_hw *ah)
+int ar5008_hw_attach_phy_ops(struct ath_hw *ah)
 {
 	struct ath_hw_private_ops *priv_ops = ath9k_hw_private_ops(ah);
 	static const u32 ar5416_cca_regs[6] = {
@@ -1391,12 +1367,15 @@ void ar5008_hw_attach_phy_ops(struct ath_hw *ah)
 		AR_PHY_CH1_EXT_CCA,
 		AR_PHY_CH2_EXT_CCA
 	};
+	int ret;
+
+	ret = ar5008_hw_rf_alloc_ext_banks(ah);
+	if (ret)
+	    return ret;
 
 	priv_ops->rf_set_freq = ar5008_hw_set_channel;
 	priv_ops->spur_mitigate_freq = ar5008_hw_spur_mitigate;
 
-	priv_ops->rf_alloc_ext_banks = ar5008_hw_rf_alloc_ext_banks;
-	priv_ops->rf_free_ext_banks = ar5008_hw_rf_free_ext_banks;
 	priv_ops->set_rf_regs = ar5008_hw_set_rf_regs;
 	priv_ops->set_channel_regs = ar5008_hw_set_channel_regs;
 	priv_ops->init_bb = ar5008_hw_init_bb;
@@ -1421,4 +1400,5 @@ void ar5008_hw_attach_phy_ops(struct ath_hw *ah)
 	ar5008_hw_set_nf_limits(ah);
 	ar5008_hw_set_radar_conf(ah);
 	memcpy(ah->nf_regs, ar5416_cca_regs, sizeof(ah->nf_regs));
+	return 0;
 }
diff --git a/drivers/net/wireless/ath/ath9k/ar9002_hw.c b/drivers/net/wireless/ath/ath9k/ar9002_hw.c
index 648da3e..54da026 100644
--- a/drivers/net/wireless/ath/ath9k/ar9002_hw.c
+++ b/drivers/net/wireless/ath/ath9k/ar9002_hw.c
@@ -102,7 +102,7 @@ static void ar9002_hw_init_mode_regs(struct ath_hw *ah)
 		u32 size = sizeof(u32) * addac->ia_rows * addac->ia_columns;
 		u32 *data;
 
-		data = kmalloc(size, GFP_KERNEL);
+		data = devm_kzalloc(ah->dev, size, GFP_KERNEL);
 		if (!data)
 			return;
 
@@ -409,22 +409,27 @@ void ar9002_hw_enable_async_fifo(struct ath_hw *ah)
 }
 
 /* Sets up the AR5008/AR9001/AR9002 hardware familiy callbacks */
-void ar9002_hw_attach_ops(struct ath_hw *ah)
+int ar9002_hw_attach_ops(struct ath_hw *ah)
 {
 	struct ath_hw_private_ops *priv_ops = ath9k_hw_private_ops(ah);
 	struct ath_hw_ops *ops = ath9k_hw_ops(ah);
+	int ret;
 
 	priv_ops->init_mode_regs = ar9002_hw_init_mode_regs;
 	priv_ops->init_mode_gain_regs = ar9002_hw_init_mode_gain_regs;
 
 	ops->config_pci_powersave = ar9002_hw_configpcipowersave;
 
-	ar5008_hw_attach_phy_ops(ah);
+	ret = ar5008_hw_attach_phy_ops(ah);
+	if (ret)
+		return ret;
+
 	if (AR_SREV_9280_20_OR_LATER(ah))
 		ar9002_hw_attach_phy_ops(ah);
 
 	ar9002_hw_attach_calib_ops(ah);
 	ar9002_hw_attach_mac_ops(ah);
+	return 0;
 }
 
 void ar9002_hw_load_ani_reg(struct ath_hw *ah, struct ath9k_channel *chan)
diff --git a/drivers/net/wireless/ath/ath9k/ar9002_phy.c b/drivers/net/wireless/ath/ath9k/ar9002_phy.c
index 846dd79..8b11981 100644
--- a/drivers/net/wireless/ath/ath9k/ar9002_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9002_phy.c
@@ -561,8 +561,6 @@ void ar9002_hw_attach_phy_ops(struct ath_hw *ah)
 	struct ath_hw_ops *ops = ath9k_hw_ops(ah);
 
 	priv_ops->set_rf_regs = NULL;
-	priv_ops->rf_alloc_ext_banks = NULL;
-	priv_ops->rf_free_ext_banks = NULL;
 	priv_ops->rf_set_freq = ar9002_hw_set_channel;
 	priv_ops->spur_mitigate_freq = ar9002_hw_spur_mitigate;
 	priv_ops->olc_init = ar9002_olc_init;
diff --git a/drivers/net/wireless/ath/ath9k/hw-ops.h b/drivers/net/wireless/ath/ath9k/hw-ops.h
index 0f2b97f..14b7011 100644
--- a/drivers/net/wireless/ath/ath9k/hw-ops.h
+++ b/drivers/net/wireless/ath/ath9k/hw-ops.h
@@ -101,22 +101,6 @@ static inline void ath9k_hw_spur_mitigate_freq(struct ath_hw *ah,
 	ath9k_hw_private_ops(ah)->spur_mitigate_freq(ah, chan);
 }
 
-static inline int ath9k_hw_rf_alloc_ext_banks(struct ath_hw *ah)
-{
-	if (!ath9k_hw_private_ops(ah)->rf_alloc_ext_banks)
-		return 0;
-
-	return ath9k_hw_private_ops(ah)->rf_alloc_ext_banks(ah);
-}
-
-static inline void ath9k_hw_rf_free_ext_banks(struct ath_hw *ah)
-{
-	if (!ath9k_hw_private_ops(ah)->rf_free_ext_banks)
-		return;
-
-	ath9k_hw_private_ops(ah)->rf_free_ext_banks(ah);
-}
-
 static inline bool ath9k_hw_set_rf_regs(struct ath_hw *ah,
 					struct ath9k_channel *chan,
 					u16 modesIndex)
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 7cb7870..ecf1c08 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -554,14 +554,6 @@ static int ath9k_hw_post_init(struct ath_hw *ah)
 		ah->eep_ops->get_eeprom_ver(ah),
 		ah->eep_ops->get_eeprom_rev(ah));
 
-	ecode = ath9k_hw_rf_alloc_ext_banks(ah);
-	if (ecode) {
-		ath_err(ath9k_hw_common(ah),
-			"Failed allocating banks for external radio\n");
-		ath9k_hw_rf_free_ext_banks(ah);
-		return ecode;
-	}
-
 	if (ah->config.enable_ani) {
 		ath9k_hw_ani_setup(ah);
 		ath9k_hw_ani_init(ah);
@@ -570,12 +562,13 @@ static int ath9k_hw_post_init(struct ath_hw *ah)
 	return 0;
 }
 
-static void ath9k_hw_attach_ops(struct ath_hw *ah)
+static int ath9k_hw_attach_ops(struct ath_hw *ah)
 {
-	if (AR_SREV_9300_20_OR_LATER(ah))
-		ar9003_hw_attach_ops(ah);
-	else
-		ar9002_hw_attach_ops(ah);
+	if (!AR_SREV_9300_20_OR_LATER(ah))
+		return ar9002_hw_attach_ops(ah);
+
+	ar9003_hw_attach_ops(ah);
+	return 0;
 }
 
 /* Called for all hardware families */
@@ -611,7 +604,9 @@ static int __ath9k_hw_init(struct ath_hw *ah)
 	ath9k_hw_init_defaults(ah);
 	ath9k_hw_init_config(ah);
 
-	ath9k_hw_attach_ops(ah);
+	r = ath9k_hw_attach_ops(ah);
+	if (r)
+		return r;
 
 	if (!ath9k_hw_setpower(ah, ATH9K_PM_AWAKE)) {
 		ath_err(common, "Couldn't wakeup chip\n");
@@ -1153,12 +1148,9 @@ void ath9k_hw_deinit(struct ath_hw *ah)
 	struct ath_common *common = ath9k_hw_common(ah);
 
 	if (common->state < ATH_HW_INITIALIZED)
-		goto free_hw;
+		return;
 
 	ath9k_hw_setpower(ah, ATH9K_PM_FULL_SLEEP);
-
-free_hw:
-	ath9k_hw_rf_free_ext_banks(ah);
 }
 EXPORT_SYMBOL(ath9k_hw_deinit);
 
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 7f1a8e9..d2b5229 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -604,8 +604,6 @@ struct ath_hw_radar_conf {
  *
  * @rf_set_freq: change frequency
  * @spur_mitigate_freq: spur mitigation
- * @rf_alloc_ext_banks:
- * @rf_free_ext_banks:
  * @set_rf_regs:
  * @compute_pll_control: compute the PLL control value to use for
  *	AR_RTC_PLL_CONTROL for a given channel
@@ -630,8 +628,6 @@ struct ath_hw_private_ops {
 			   struct ath9k_channel *chan);
 	void (*spur_mitigate_freq)(struct ath_hw *ah,
 				   struct ath9k_channel *chan);
-	int (*rf_alloc_ext_banks)(struct ath_hw *ah);
-	void (*rf_free_ext_banks)(struct ath_hw *ah);
 	bool (*set_rf_regs)(struct ath_hw *ah,
 			    struct ath9k_channel *chan,
 			    u16 modesIndex);
@@ -710,6 +706,7 @@ enum ath_cal_list {
 struct ath_hw {
 	struct ath_ops reg_ops;
 
+	struct device *dev;
 	struct ieee80211_hw *hw;
 	struct ath_common common;
 	struct ath9k_hw_version hw_version;
@@ -1068,14 +1065,14 @@ bool ar9003_paprd_is_done(struct ath_hw *ah);
 bool ar9003_is_paprd_enabled(struct ath_hw *ah);
 
 /* Hardware family op attach helpers */
-void ar5008_hw_attach_phy_ops(struct ath_hw *ah);
+int ar5008_hw_attach_phy_ops(struct ath_hw *ah);
 void ar9002_hw_attach_phy_ops(struct ath_hw *ah);
 void ar9003_hw_attach_phy_ops(struct ath_hw *ah);
 
 void ar9002_hw_attach_calib_ops(struct ath_hw *ah);
 void ar9003_hw_attach_calib_ops(struct ath_hw *ah);
 
-void ar9002_hw_attach_ops(struct ath_hw *ah);
+int ar9002_hw_attach_ops(struct ath_hw *ah);
 void ar9003_hw_attach_ops(struct ath_hw *ah);
 
 void ar9002_hw_load_ani_reg(struct ath_hw *ah, struct ath9k_channel *chan);
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index 0f00a13..5c01f43 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -559,6 +559,7 @@ static int ath9k_init_softc(u16 devid, struct ath_softc *sc,
 	if (!ah)
 		return -ENOMEM;
 
+	ah->dev = sc->dev;
 	ah->hw = sc->hw;
 	ah->hw_version.devid = devid;
 	ah->reg_ops.read = ath9k_ioread32;
-- 
1.7.12.2

