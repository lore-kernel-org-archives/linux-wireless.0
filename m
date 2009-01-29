Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:55862 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753285AbZA2TGV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Jan 2009 14:06:21 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Jay Sternberg <jay.e.sternberg@linux.intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 3/7] iwlwifi: parametrize configuration of the PLL for exclusion on 6000
Date: Thu, 29 Jan 2009 11:09:13 -0800
Message-Id: <1233256157-21290-4-git-send-email-reinette.chatre@intel.com> (sfid-20090129_200626_370093_FE05293C)
In-Reply-To: <1233256157-21290-3-git-send-email-reinette.chatre@intel.com>
References: <>
 <1233256157-21290-1-git-send-email-reinette.chatre@intel.com>
 <1233256157-21290-2-git-send-email-reinette.chatre@intel.com>
 <1233256157-21290-3-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jay Sternberg <jay.e.sternberg@linux.intel.com>

added a config parameter to enable setting PLL_CFG.  older hardware has
this parameter set true.  the 6000 family does not support this setting,
so this parameter set false.

Signed-off-by: Jay Sternberg <jay.e.sternberg@linux.intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-100.c  |    1 +
 drivers/net/wireless/iwlwifi/iwl-5000.c |   12 ++++++++++--
 drivers/net/wireless/iwlwifi/iwl-6000.c |    5 +++++
 drivers/net/wireless/iwlwifi/iwl-core.h |    1 +
 4 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-100.c b/drivers/net/wireless/iwlwifi/iwl-100.c
index 4c4d165..a5df931 100644
--- a/drivers/net/wireless/iwlwifi/iwl-100.c
+++ b/drivers/net/wireless/iwlwifi/iwl-100.c
@@ -68,5 +68,6 @@ struct iwl_cfg iwl100_bgn_cfg = {
 	.mod_params = &iwl50_mod_params,
 	.valid_tx_ant = ANT_A,
 	.valid_rx_ant = ANT_AB,
+	.need_pll_cfg = true,
 };
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index 535a46c..ee58ddb 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -109,7 +109,8 @@ static int iwl5000_apm_init(struct iwl_priv *priv)
 	iwl_set_bit(priv, CSR_HW_IF_CONFIG_REG,
 		    CSR_HW_IF_CONFIG_REG_BIT_HAP_WAKE_L1A);
 
-	iwl_set_bit(priv, CSR_ANA_PLL_CFG, CSR50_ANA_PLL_CFG_VAL);
+	if (priv->cfg->need_pll_cfg)
+		iwl_set_bit(priv, CSR_ANA_PLL_CFG, CSR50_ANA_PLL_CFG_VAL);
 
 	/* set "initialization complete" bit to move adapter
 	 * D0U* --> D0A* state */
@@ -177,7 +178,8 @@ static int iwl5000_apm_reset(struct iwl_priv *priv)
 
 	/* FIXME: put here L1A -L0S w/a */
 
-	iwl_set_bit(priv, CSR_ANA_PLL_CFG, CSR50_ANA_PLL_CFG_VAL);
+	if (priv->cfg->need_pll_cfg)
+		iwl_set_bit(priv, CSR_ANA_PLL_CFG, CSR50_ANA_PLL_CFG_VAL);
 
 	/* set "initialization complete" bit to move adapter
 	 * D0U* --> D0A* state */
@@ -1548,6 +1550,7 @@ struct iwl_cfg iwl5300_agn_cfg = {
 	.mod_params = &iwl50_mod_params,
 	.valid_tx_ant = ANT_ABC,
 	.valid_rx_ant = ANT_ABC,
+	.need_pll_cfg = true,
 };
 
 struct iwl_cfg iwl5100_bg_cfg = {
@@ -1563,6 +1566,7 @@ struct iwl_cfg iwl5100_bg_cfg = {
 	.mod_params = &iwl50_mod_params,
 	.valid_tx_ant = ANT_A,
 	.valid_rx_ant = ANT_AB,
+	.need_pll_cfg = true,
 };
 
 struct iwl_cfg iwl5100_abg_cfg = {
@@ -1578,6 +1582,7 @@ struct iwl_cfg iwl5100_abg_cfg = {
 	.mod_params = &iwl50_mod_params,
 	.valid_tx_ant = ANT_B,
 	.valid_rx_ant = ANT_AB,
+	.need_pll_cfg = true,
 };
 
 struct iwl_cfg iwl5100_agn_cfg = {
@@ -1593,6 +1598,7 @@ struct iwl_cfg iwl5100_agn_cfg = {
 	.mod_params = &iwl50_mod_params,
 	.valid_tx_ant = ANT_B,
 	.valid_rx_ant = ANT_AB,
+	.need_pll_cfg = true,
 };
 
 struct iwl_cfg iwl5350_agn_cfg = {
@@ -1608,6 +1614,7 @@ struct iwl_cfg iwl5350_agn_cfg = {
 	.mod_params = &iwl50_mod_params,
 	.valid_tx_ant = ANT_ABC,
 	.valid_rx_ant = ANT_ABC,
+	.need_pll_cfg = true,
 };
 
 struct iwl_cfg iwl5150_agn_cfg = {
@@ -1623,6 +1630,7 @@ struct iwl_cfg iwl5150_agn_cfg = {
 	.mod_params = &iwl50_mod_params,
 	.valid_tx_ant = ANT_B,
 	.valid_rx_ant = ANT_AB,
+	.need_pll_cfg = true,
 };
 
 MODULE_FIRMWARE(IWL5000_MODULE_FIRMWARE(IWL5000_UCODE_API_MAX));
diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index b78d676..1672a98 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -74,6 +74,7 @@ struct iwl_cfg iwl6000_2ag_cfg = {
 	.mod_params = &iwl50_mod_params,
 	.valid_tx_ant = ANT_BC,
 	.valid_rx_ant = ANT_BC,
+	.need_pll_cfg = false,
 };
 
 struct iwl_cfg iwl6000_2agn_cfg = {
@@ -89,6 +90,7 @@ struct iwl_cfg iwl6000_2agn_cfg = {
 	.mod_params = &iwl50_mod_params,
 	.valid_tx_ant = ANT_BC,
 	.valid_rx_ant = ANT_BC,
+	.need_pll_cfg = false,
 };
 
 struct iwl_cfg iwl6050_2agn_cfg = {
@@ -104,6 +106,7 @@ struct iwl_cfg iwl6050_2agn_cfg = {
 	.mod_params = &iwl50_mod_params,
 	.valid_tx_ant = ANT_BC,
 	.valid_rx_ant = ANT_BC,
+	.need_pll_cfg = false,
 };
 
 struct iwl_cfg iwl6000_3agn_cfg = {
@@ -119,6 +122,7 @@ struct iwl_cfg iwl6000_3agn_cfg = {
 	.mod_params = &iwl50_mod_params,
 	.valid_tx_ant = ANT_ABC,
 	.valid_rx_ant = ANT_ABC,
+	.need_pll_cfg = false,
 };
 
 struct iwl_cfg iwl6050_3agn_cfg = {
@@ -134,6 +138,7 @@ struct iwl_cfg iwl6050_3agn_cfg = {
 	.mod_params = &iwl50_mod_params,
 	.valid_tx_ant = ANT_ABC,
 	.valid_rx_ant = ANT_ABC,
+	.need_pll_cfg = false,
 };
 
 MODULE_FIRMWARE(IWL6000_MODULE_FIRMWARE(IWL6000_UCODE_API_MAX));
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 02e92be..789fe6e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -213,6 +213,7 @@ struct iwl_cfg {
 	const struct iwl_mod_params *mod_params;
 	u8   valid_tx_ant;
 	u8   valid_rx_ant;
+	bool need_pll_cfg;
 };
 
 /***************************
-- 
1.5.4.3

