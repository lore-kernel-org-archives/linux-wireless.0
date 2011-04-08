Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:56990 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757406Ab1DHPuN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Apr 2011 11:50:13 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 10/16] iwlagn: remove un-needed configuration
Date: Fri,  8 Apr 2011 08:30:30 -0700
Message-Id: <1302276636-12802-11-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1302276636-12802-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1302276636-12802-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

After driver split, set_l0s config is no longer needed, remove it

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-1000.c |    1 -
 drivers/net/wireless/iwlwifi/iwl-2000.c |    2 --
 drivers/net/wireless/iwlwifi/iwl-5000.c |    1 -
 drivers/net/wireless/iwlwifi/iwl-6000.c |    3 ---
 drivers/net/wireless/iwlwifi/iwl-core.c |   26 ++++++++++++--------------
 drivers/net/wireless/iwlwifi/iwl-core.h |    1 -
 6 files changed, 12 insertions(+), 22 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-1000.c b/drivers/net/wireless/iwlwifi/iwl-1000.c
index cb2f871..5a72810 100644
--- a/drivers/net/wireless/iwlwifi/iwl-1000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-1000.c
@@ -235,7 +235,6 @@ static struct iwl_base_params iwl1000_base_params = {
 	.num_of_ampdu_queues = IWLAGN_NUM_AMPDU_QUEUES,
 	.eeprom_size = OTP_LOW_IMAGE_SIZE,
 	.pll_cfg_val = CSR50_ANA_PLL_CFG_VAL,
-	.set_l0s = true,
 	.max_ll_items = OTP_MAX_LL_ITEMS_1000,
 	.shadow_ram_support = false,
 	.led_compensation = 51,
diff --git a/drivers/net/wireless/iwlwifi/iwl-2000.c b/drivers/net/wireless/iwlwifi/iwl-2000.c
index 86d7ffd..9daf888 100644
--- a/drivers/net/wireless/iwlwifi/iwl-2000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-2000.c
@@ -343,7 +343,6 @@ static struct iwl_base_params iwl2000_base_params = {
 	.num_of_queues = IWLAGN_NUM_QUEUES,
 	.num_of_ampdu_queues = IWLAGN_NUM_AMPDU_QUEUES,
 	.pll_cfg_val = 0,
-	.set_l0s = true,
 	.max_ll_items = OTP_MAX_LL_ITEMS_2x00,
 	.shadow_ram_support = true,
 	.led_compensation = 51,
@@ -366,7 +365,6 @@ static struct iwl_base_params iwl2030_base_params = {
 	.num_of_queues = IWLAGN_NUM_QUEUES,
 	.num_of_ampdu_queues = IWLAGN_NUM_AMPDU_QUEUES,
 	.pll_cfg_val = 0,
-	.set_l0s = true,
 	.max_ll_items = OTP_MAX_LL_ITEMS_2x00,
 	.shadow_ram_support = true,
 	.led_compensation = 57,
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index 4c8f72a..8106423 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -464,7 +464,6 @@ static struct iwl_base_params iwl5000_base_params = {
 	.num_of_queues = IWLAGN_NUM_QUEUES,
 	.num_of_ampdu_queues = IWLAGN_NUM_AMPDU_QUEUES,
 	.pll_cfg_val = CSR50_ANA_PLL_CFG_VAL,
-	.set_l0s = true,
 	.led_compensation = 51,
 	.chain_noise_num_beacons = IWL_CAL_NUM_BEACONS,
 	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_LONG_THRESHOLD_DEF,
diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index 80a335f..7f0715e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -432,7 +432,6 @@ static struct iwl_base_params iwl6000_base_params = {
 	.num_of_queues = IWLAGN_NUM_QUEUES,
 	.num_of_ampdu_queues = IWLAGN_NUM_AMPDU_QUEUES,
 	.pll_cfg_val = 0,
-	.set_l0s = true,
 	.max_ll_items = OTP_MAX_LL_ITEMS_6x00,
 	.shadow_ram_support = true,
 	.led_compensation = 51,
@@ -454,7 +453,6 @@ static struct iwl_base_params iwl6050_base_params = {
 	.num_of_queues = IWLAGN_NUM_QUEUES,
 	.num_of_ampdu_queues = IWLAGN_NUM_AMPDU_QUEUES,
 	.pll_cfg_val = 0,
-	.set_l0s = true,
 	.max_ll_items = OTP_MAX_LL_ITEMS_6x50,
 	.shadow_ram_support = true,
 	.led_compensation = 51,
@@ -475,7 +473,6 @@ static struct iwl_base_params iwl6000_g2_base_params = {
 	.num_of_queues = IWLAGN_NUM_QUEUES,
 	.num_of_ampdu_queues = IWLAGN_NUM_AMPDU_QUEUES,
 	.pll_cfg_val = 0,
-	.set_l0s = true,
 	.max_ll_items = OTP_MAX_LL_ITEMS_6x00,
 	.shadow_ram_support = true,
 	.led_compensation = 57,
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 4c76499..0e98a87 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -1061,20 +1061,18 @@ int iwl_apm_init(struct iwl_priv *priv)
 	 * If not (unlikely), enable L0S, so there is at least some
 	 *    power savings, even without L1.
 	 */
-	if (priv->cfg->base_params->set_l0s) {
-		lctl = iwl_pcie_link_ctl(priv);
-		if ((lctl & PCI_CFG_LINK_CTRL_VAL_L1_EN) ==
-					PCI_CFG_LINK_CTRL_VAL_L1_EN) {
-			/* L1-ASPM enabled; disable(!) L0S  */
-			iwl_set_bit(priv, CSR_GIO_REG,
-					CSR_GIO_REG_VAL_L0S_ENABLED);
-			IWL_DEBUG_POWER(priv, "L1 Enabled; Disabling L0S\n");
-		} else {
-			/* L1-ASPM disabled; enable(!) L0S */
-			iwl_clear_bit(priv, CSR_GIO_REG,
-					CSR_GIO_REG_VAL_L0S_ENABLED);
-			IWL_DEBUG_POWER(priv, "L1 Disabled; Enabling L0S\n");
-		}
+	lctl = iwl_pcie_link_ctl(priv);
+	if ((lctl & PCI_CFG_LINK_CTRL_VAL_L1_EN) ==
+				PCI_CFG_LINK_CTRL_VAL_L1_EN) {
+		/* L1-ASPM enabled; disable(!) L0S  */
+		iwl_set_bit(priv, CSR_GIO_REG,
+				CSR_GIO_REG_VAL_L0S_ENABLED);
+		IWL_DEBUG_POWER(priv, "L1 Enabled; Disabling L0S\n");
+	} else {
+		/* L1-ASPM disabled; enable(!) L0S */
+		iwl_clear_bit(priv, CSR_GIO_REG,
+				CSR_GIO_REG_VAL_L0S_ENABLED);
+		IWL_DEBUG_POWER(priv, "L1 Disabled; Enabling L0S\n");
 	}
 
 	/* Configure analog phase-lock-loop before activating to D0A */
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 10a6f85..7d303ac 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -265,7 +265,6 @@ struct iwl_base_params {
 	int num_of_ampdu_queues;/* def: HW dependent */
 	/* for iwl_apm_init() */
 	u32 pll_cfg_val;
-	bool set_l0s;
 
 	const u16 max_ll_items;
 	const bool shadow_ram_support;
-- 
1.7.0.4

