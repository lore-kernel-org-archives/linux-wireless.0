Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:20287 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755370Ab1DERBf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Apr 2011 13:01:35 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 19/25] iwlagn: remove BSM clock setting
Date: Tue,  5 Apr 2011 09:42:06 -0700
Message-Id: <1302021732-21250-20-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1302021732-21250-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1302021732-21250-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Again, a 4965 specific code path that we no
longer need in iwlagn.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-1000.c |    1 -
 drivers/net/wireless/iwlwifi/iwl-2000.c |    2 --
 drivers/net/wireless/iwlwifi/iwl-5000.c |    1 -
 drivers/net/wireless/iwlwifi/iwl-6000.c |    3 ---
 drivers/net/wireless/iwlwifi/iwl-core.c |   12 ++----------
 drivers/net/wireless/iwlwifi/iwl-core.h |    1 -
 6 files changed, 2 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-1000.c b/drivers/net/wireless/iwlwifi/iwl-1000.c
index 5c3bb47..de5b287 100644
--- a/drivers/net/wireless/iwlwifi/iwl-1000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-1000.c
@@ -249,7 +249,6 @@ static struct iwl_base_params iwl1000_base_params = {
 	.eeprom_size = OTP_LOW_IMAGE_SIZE,
 	.pll_cfg_val = CSR50_ANA_PLL_CFG_VAL,
 	.set_l0s = true,
-	.use_bsm = false,
 	.max_ll_items = OTP_MAX_LL_ITEMS_1000,
 	.shadow_ram_support = false,
 	.led_compensation = 51,
diff --git a/drivers/net/wireless/iwlwifi/iwl-2000.c b/drivers/net/wireless/iwlwifi/iwl-2000.c
index f87adbf..d22e006 100644
--- a/drivers/net/wireless/iwlwifi/iwl-2000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-2000.c
@@ -356,7 +356,6 @@ static struct iwl_base_params iwl2000_base_params = {
 	.num_of_ampdu_queues = IWLAGN_NUM_AMPDU_QUEUES,
 	.pll_cfg_val = 0,
 	.set_l0s = true,
-	.use_bsm = false,
 	.max_ll_items = OTP_MAX_LL_ITEMS_2x00,
 	.shadow_ram_support = true,
 	.led_compensation = 51,
@@ -380,7 +379,6 @@ static struct iwl_base_params iwl2030_base_params = {
 	.num_of_ampdu_queues = IWLAGN_NUM_AMPDU_QUEUES,
 	.pll_cfg_val = 0,
 	.set_l0s = true,
-	.use_bsm = false,
 	.max_ll_items = OTP_MAX_LL_ITEMS_2x00,
 	.shadow_ram_support = true,
 	.led_compensation = 57,
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index d2f4eb3..de0e86a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -488,7 +488,6 @@ static struct iwl_base_params iwl5000_base_params = {
 	.num_of_ampdu_queues = IWLAGN_NUM_AMPDU_QUEUES,
 	.pll_cfg_val = CSR50_ANA_PLL_CFG_VAL,
 	.set_l0s = true,
-	.use_bsm = false,
 	.led_compensation = 51,
 	.chain_noise_num_beacons = IWL_CAL_NUM_BEACONS,
 	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_LONG_THRESHOLD_DEF,
diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index c1f8d1d..be2dbf7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -459,7 +459,6 @@ static struct iwl_base_params iwl6000_base_params = {
 	.num_of_ampdu_queues = IWLAGN_NUM_AMPDU_QUEUES,
 	.pll_cfg_val = 0,
 	.set_l0s = true,
-	.use_bsm = false,
 	.max_ll_items = OTP_MAX_LL_ITEMS_6x00,
 	.shadow_ram_support = true,
 	.led_compensation = 51,
@@ -482,7 +481,6 @@ static struct iwl_base_params iwl6050_base_params = {
 	.num_of_ampdu_queues = IWLAGN_NUM_AMPDU_QUEUES,
 	.pll_cfg_val = 0,
 	.set_l0s = true,
-	.use_bsm = false,
 	.max_ll_items = OTP_MAX_LL_ITEMS_6x50,
 	.shadow_ram_support = true,
 	.led_compensation = 51,
@@ -504,7 +502,6 @@ static struct iwl_base_params iwl6000_g2_base_params = {
 	.num_of_ampdu_queues = IWLAGN_NUM_AMPDU_QUEUES,
 	.pll_cfg_val = 0,
 	.set_l0s = true,
-	.use_bsm = false,
 	.max_ll_items = OTP_MAX_LL_ITEMS_6x00,
 	.shadow_ram_support = true,
 	.led_compensation = 57,
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 6e9829f..c46be36 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -1105,21 +1105,13 @@ int iwl_apm_init(struct iwl_priv *priv)
 	}
 
 	/*
-	 * Enable DMA and BSM (if used) clocks, wait for them to stabilize.
-	 * BSM (Boostrap State Machine) is only in 3945 and 4965;
-	 * later devices (i.e. 5000 and later) have non-volatile SRAM,
-	 * and don't need BSM to restore data after power-saving sleep.
+	 * Enable DMA clock and wait for it to stabilize.
 	 *
 	 * Write to "CLK_EN_REG"; "1" bits enable clocks, while "0" bits
 	 * do not disable clocks.  This preserves any hardware bits already
 	 * set by default in "CLK_CTRL_REG" after reset.
 	 */
-	if (priv->cfg->base_params->use_bsm)
-		iwl_write_prph(priv, APMG_CLK_EN_REG,
-			APMG_CLK_VAL_DMA_CLK_RQT | APMG_CLK_VAL_BSM_CLK_RQT);
-	else
-		iwl_write_prph(priv, APMG_CLK_EN_REG,
-			APMG_CLK_VAL_DMA_CLK_RQT);
+	iwl_write_prph(priv, APMG_CLK_EN_REG, APMG_CLK_VAL_DMA_CLK_RQT);
 	udelay(20);
 
 	/* Disable L1-Active */
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 7b9f64e..ada76af 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -283,7 +283,6 @@ struct iwl_base_params {
 	/* for iwl_apm_init() */
 	u32 pll_cfg_val;
 	bool set_l0s;
-	bool use_bsm;
 
 	const u16 max_ll_items;
 	const bool shadow_ram_support;
-- 
1.7.0.4

