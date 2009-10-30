Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:15110 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757475AbZJ3VgP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Oct 2009 17:36:15 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Ben Cahill <ben.m.cahill@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 04/15] iwlagn: invoke L0S workaround for 6000/1000 series
Date: Fri, 30 Oct 2009 14:36:07 -0700
Message-Id: <1256938578-9638-5-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1256938578-9638-1-git-send-email-reinette.chatre@intel.com>
References: <1256938578-9638-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Cahill <ben.m.cahill@intel.com>

Invoke workaround to avoid instability in L0->L0S->L1 transition on PCIe bus.
Workaround disables L0S state so device moves directly from L0->L1.
Workaround needed on all devices since and including 4965; add to 6000/1000.

Describe bug and workaround better in comments.

Signed-off-by: Ben Cahill <ben.m.cahill@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-1000.c |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-6000.c |   20 ++++++++++----------
 drivers/net/wireless/iwlwifi/iwl-core.c |    8 ++++++--
 3 files changed, 18 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-1000.c b/drivers/net/wireless/iwlwifi/iwl-1000.c
index 3a645e4..1e387b9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-1000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-1000.c
@@ -164,7 +164,7 @@ struct iwl_cfg iwl1000_bgn_cfg = {
 	.valid_tx_ant = ANT_A,
 	.valid_rx_ant = ANT_AB,
 	.pll_cfg_val = CSR50_ANA_PLL_CFG_VAL,
-	.set_l0s = false,
+	.set_l0s = true,
 	.use_bsm = false,
 	.max_ll_items = OTP_MAX_LL_ITEMS_1000,
 	.shadow_ram_support = false,
@@ -190,7 +190,7 @@ struct iwl_cfg iwl1000_bg_cfg = {
 	.valid_tx_ant = ANT_A,
 	.valid_rx_ant = ANT_AB,
 	.pll_cfg_val = CSR50_ANA_PLL_CFG_VAL,
-	.set_l0s = false,
+	.set_l0s = true,
 	.use_bsm = false,
 	.max_ll_items = OTP_MAX_LL_ITEMS_1000,
 	.shadow_ram_support = false,
diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index 32466d3..2f841a8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -299,7 +299,7 @@ struct iwl_cfg iwl6000h_2agn_cfg = {
 	.valid_tx_ant = ANT_AB,
 	.valid_rx_ant = ANT_AB,
 	.pll_cfg_val = 0,
-	.set_l0s = false,
+	.set_l0s = true,
 	.use_bsm = false,
 	.pa_type = IWL_PA_HYBRID,
 	.max_ll_items = OTP_MAX_LL_ITEMS_6x00,
@@ -329,7 +329,7 @@ struct iwl_cfg iwl6000h_2abg_cfg = {
 	.valid_tx_ant = ANT_AB,
 	.valid_rx_ant = ANT_AB,
 	.pll_cfg_val = 0,
-	.set_l0s = false,
+	.set_l0s = true,
 	.use_bsm = false,
 	.pa_type = IWL_PA_HYBRID,
 	.max_ll_items = OTP_MAX_LL_ITEMS_6x00,
@@ -358,7 +358,7 @@ struct iwl_cfg iwl6000h_2bg_cfg = {
 	.valid_tx_ant = ANT_AB,
 	.valid_rx_ant = ANT_AB,
 	.pll_cfg_val = 0,
-	.set_l0s = false,
+	.set_l0s = true,
 	.use_bsm = false,
 	.pa_type = IWL_PA_HYBRID,
 	.max_ll_items = OTP_MAX_LL_ITEMS_6x00,
@@ -390,7 +390,7 @@ struct iwl_cfg iwl6000i_2agn_cfg = {
 	.valid_tx_ant = ANT_BC,
 	.valid_rx_ant = ANT_BC,
 	.pll_cfg_val = 0,
-	.set_l0s = false,
+	.set_l0s = true,
 	.use_bsm = false,
 	.pa_type = IWL_PA_INTERNAL,
 	.max_ll_items = OTP_MAX_LL_ITEMS_6x00,
@@ -420,7 +420,7 @@ struct iwl_cfg iwl6000i_2abg_cfg = {
 	.valid_tx_ant = ANT_BC,
 	.valid_rx_ant = ANT_BC,
 	.pll_cfg_val = 0,
-	.set_l0s = false,
+	.set_l0s = true,
 	.use_bsm = false,
 	.pa_type = IWL_PA_INTERNAL,
 	.max_ll_items = OTP_MAX_LL_ITEMS_6x00,
@@ -449,7 +449,7 @@ struct iwl_cfg iwl6000i_2bg_cfg = {
 	.valid_tx_ant = ANT_BC,
 	.valid_rx_ant = ANT_BC,
 	.pll_cfg_val = 0,
-	.set_l0s = false,
+	.set_l0s = true,
 	.use_bsm = false,
 	.pa_type = IWL_PA_INTERNAL,
 	.max_ll_items = OTP_MAX_LL_ITEMS_6x00,
@@ -478,7 +478,7 @@ struct iwl_cfg iwl6050_2agn_cfg = {
 	.valid_tx_ant = ANT_AB,
 	.valid_rx_ant = ANT_AB,
 	.pll_cfg_val = 0,
-	.set_l0s = false,
+	.set_l0s = true,
 	.use_bsm = false,
 	.pa_type = IWL_PA_SYSTEM,
 	.max_ll_items = OTP_MAX_LL_ITEMS_6x50,
@@ -508,7 +508,7 @@ struct iwl_cfg iwl6050_2abg_cfg = {
 	.valid_tx_ant = ANT_AB,
 	.valid_rx_ant = ANT_AB,
 	.pll_cfg_val = 0,
-	.set_l0s = false,
+	.set_l0s = true,
 	.use_bsm = false,
 	.pa_type = IWL_PA_SYSTEM,
 	.max_ll_items = OTP_MAX_LL_ITEMS_6x50,
@@ -537,7 +537,7 @@ struct iwl_cfg iwl6000_3agn_cfg = {
 	.valid_tx_ant = ANT_ABC,
 	.valid_rx_ant = ANT_ABC,
 	.pll_cfg_val = 0,
-	.set_l0s = false,
+	.set_l0s = true,
 	.use_bsm = false,
 	.pa_type = IWL_PA_SYSTEM,
 	.max_ll_items = OTP_MAX_LL_ITEMS_6x00,
@@ -567,7 +567,7 @@ struct iwl_cfg iwl6050_3agn_cfg = {
 	.valid_tx_ant = ANT_ABC,
 	.valid_rx_ant = ANT_ABC,
 	.pll_cfg_val = 0,
-	.set_l0s = false,
+	.set_l0s = true,
 	.use_bsm = false,
 	.pa_type = IWL_PA_SYSTEM,
 	.max_ll_items = OTP_MAX_LL_ITEMS_6x50,
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 9e71544..2952890 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -1431,8 +1431,12 @@ int iwl_apm_init(struct iwl_priv *priv)
 				    CSR_HW_IF_CONFIG_REG_BIT_HAP_WAKE_L1A);
 
 	/*
-	 * HW bug W/A - costs negligible power consumption ...
-	 * Check if BIOS (or OS) enabled L1-ASPM on this device
+	 * HW bug W/A for instability in PCIe bus L0->L0S->L1 transition.
+	 * Check if BIOS (or OS) enabled L1-ASPM on this device.
+	 * If so (likely), disable L0S, so device moves directly L0->L1;
+	 *    costs negligible amount of power savings.
+	 * If not (unlikely), enable L0S, so there is at least some
+	 *    power savings, even without L1.
 	 */
 	if (priv->cfg->set_l0s) {
 		lctl = iwl_pcie_link_ctl(priv);
-- 
1.5.6.3

