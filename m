Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:18946 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759048AbZJIUWJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Oct 2009 16:22:09 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Ben Cahill <ben.m.cahill@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 05/17] iwlagn, iwl3945: remove apm_reset() functions
Date: Fri,  9 Oct 2009 13:20:22 -0700
Message-Id: <1255119634-3060-7-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1255119634-3060-1-git-send-email-reinette.chatre@intel.com>
References: <1255119634-3060-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Cahill <ben.m.cahill@intel.com>

Clean up device-specific apm_reset() functions and library infrastructure,
now that these reset() functions are no longer being used.

Signed-off-by: Ben Cahill <ben.m.cahill@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-1000.c |    1 -
 drivers/net/wireless/iwlwifi/iwl-3945.c |   42 ----------------------------
 drivers/net/wireless/iwlwifi/iwl-4965.c |   41 ----------------------------
 drivers/net/wireless/iwlwifi/iwl-5000.c |   45 -------------------------------
 drivers/net/wireless/iwlwifi/iwl-6000.c |    1 -
 drivers/net/wireless/iwlwifi/iwl-core.h |    1 -
 drivers/net/wireless/iwlwifi/iwl-dev.h  |    1 -
 7 files changed, 0 insertions(+), 132 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-1000.c b/drivers/net/wireless/iwlwifi/iwl-1000.c
index 679a67f..1fc3814 100644
--- a/drivers/net/wireless/iwlwifi/iwl-1000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-1000.c
@@ -111,7 +111,6 @@ static struct iwl_lib_ops iwl1000_lib = {
 	.update_chain_flags = iwl_update_chain_flags,
 	.apm_ops = {
 		.init =	iwl5000_apm_init,
-		.reset = iwl5000_apm_reset,
 		.stop = iwl_apm_stop,
 		.config = iwl1000_nic_config,
 		.set_pwr_src = iwl_set_pwr_src,
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index 89f8239..f8ce96c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -1198,47 +1198,6 @@ void iwl3945_hw_txq_ctx_stop(struct iwl_priv *priv)
 	iwl3945_hw_txq_ctx_free(priv);
 }
 
-static int iwl3945_apm_reset(struct iwl_priv *priv)
-{
-	iwl_apm_stop_master(priv);
-
-
-	iwl_set_bit(priv, CSR_RESET, CSR_RESET_REG_FLAG_SW_RESET);
-	udelay(10);
-
-	iwl_set_bit(priv, CSR_GP_CNTRL, CSR_GP_CNTRL_REG_FLAG_INIT_DONE);
-
-	iwl_poll_bit(priv, CSR_GP_CNTRL,
-			CSR_GP_CNTRL_REG_FLAG_MAC_CLOCK_READY,
-			CSR_GP_CNTRL_REG_FLAG_MAC_CLOCK_READY, 25000);
-
-	iwl_write_prph(priv, APMG_CLK_CTRL_REG,
-				APMG_CLK_VAL_BSM_CLK_RQT);
-
-	iwl_write_prph(priv, APMG_RTC_INT_MSK_REG, 0x0);
-	iwl_write_prph(priv, APMG_RTC_INT_STT_REG,
-					0xFFFFFFFF);
-
-	/* enable DMA */
-	iwl_write_prph(priv, APMG_CLK_EN_REG,
-				APMG_CLK_VAL_DMA_CLK_RQT |
-				APMG_CLK_VAL_BSM_CLK_RQT);
-	udelay(10);
-
-	iwl_set_bits_prph(priv, APMG_PS_CTRL_REG,
-				APMG_PS_CTRL_VAL_RESET_REQ);
-	udelay(5);
-	iwl_clear_bits_prph(priv, APMG_PS_CTRL_REG,
-				APMG_PS_CTRL_VAL_RESET_REQ);
-
-	/* Clear the 'host command active' bit... */
-	clear_bit(STATUS_HCMD_ACTIVE, &priv->status);
-
-	wake_up_interruptible(&priv->wait_command_queue);
-
-	return 0;
-}
-
 /**
  * iwl3945_hw_reg_adjust_power_by_temp
  * return index delta into power gain settings table
@@ -2833,7 +2792,6 @@ static struct iwl_lib_ops iwl3945_lib = {
 	.dump_nic_error_log = iwl3945_dump_nic_error_log,
 	.apm_ops = {
 		.init = iwl3945_apm_init,
-		.reset = iwl3945_apm_reset,
 		.stop = iwl_apm_stop,
 		.config = iwl3945_nic_config,
 		.set_pwr_src = iwl3945_set_pwr_src,
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index f8eed9a..782a361 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -397,46 +397,6 @@ static void iwl4965_nic_config(struct iwl_priv *priv)
 	spin_unlock_irqrestore(&priv->lock, flags);
 }
 
-static int iwl4965_apm_reset(struct iwl_priv *priv)
-{
-	int ret = 0;
-
-	iwl_apm_stop_master(priv);
-
-
-	iwl_set_bit(priv, CSR_RESET, CSR_RESET_REG_FLAG_SW_RESET);
-
-	udelay(10);
-
-	/* FIXME: put here L1A -L0S w/a */
-
-	iwl_set_bit(priv, CSR_GP_CNTRL, CSR_GP_CNTRL_REG_FLAG_INIT_DONE);
-
-	ret = iwl_poll_bit(priv, CSR_GP_CNTRL,
-			CSR_GP_CNTRL_REG_FLAG_MAC_CLOCK_READY,
-			CSR_GP_CNTRL_REG_FLAG_MAC_CLOCK_READY, 25000);
-	if (ret < 0)
-		goto out;
-
-	udelay(10);
-
-	/* Enable DMA and BSM Clock */
-	iwl_write_prph(priv, APMG_CLK_EN_REG, APMG_CLK_VAL_DMA_CLK_RQT |
-					      APMG_CLK_VAL_BSM_CLK_RQT);
-
-	udelay(10);
-
-	/* disable L1A */
-	iwl_set_bits_prph(priv, APMG_PCIDEV_STT_REG,
-			  APMG_PCIDEV_STT_VAL_L1_ACT_DIS);
-
-	clear_bit(STATUS_HCMD_ACTIVE, &priv->status);
-	wake_up_interruptible(&priv->wait_command_queue);
-
-out:
-	return ret;
-}
-
 /* Reset differential Rx gains in NIC to prepare for chain noise calibration.
  * Called after every association, but this runs only once!
  *  ... once chain noise is calibrated the first time, it's good forever.  */
@@ -2273,7 +2233,6 @@ static struct iwl_lib_ops iwl4965_lib = {
 	.dump_nic_error_log = iwl_dump_nic_error_log,
 	.apm_ops = {
 		.init = iwl4965_apm_init,
-		.reset = iwl4965_apm_reset,
 		.stop = iwl_apm_stop,
 		.config = iwl4965_nic_config,
 		.set_pwr_src = iwl_set_pwr_src,
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index 8cc3d50..33b38aa 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -118,49 +118,6 @@ int iwl5000_apm_init(struct iwl_priv *priv)
 	return ret;
 }
 
-int iwl5000_apm_reset(struct iwl_priv *priv)
-{
-	int ret = 0;
-
-	iwl_apm_stop_master(priv);
-
-	iwl_set_bit(priv, CSR_RESET, CSR_RESET_REG_FLAG_SW_RESET);
-
-	udelay(10);
-
-
-	/* FIXME: put here L1A -L0S w/a */
-
-	if (priv->cfg->need_pll_cfg)
-		iwl_set_bit(priv, CSR_ANA_PLL_CFG, CSR50_ANA_PLL_CFG_VAL);
-
-	/* set "initialization complete" bit to move adapter
-	 * D0U* --> D0A* state */
-	iwl_set_bit(priv, CSR_GP_CNTRL, CSR_GP_CNTRL_REG_FLAG_INIT_DONE);
-
-	/* wait for clock stabilization */
-	ret = iwl_poll_bit(priv, CSR_GP_CNTRL,
-			CSR_GP_CNTRL_REG_FLAG_MAC_CLOCK_READY,
-			CSR_GP_CNTRL_REG_FLAG_MAC_CLOCK_READY, 25000);
-	if (ret < 0) {
-		IWL_DEBUG_INFO(priv, "Failed to init the card\n");
-		goto out;
-	}
-
-	/* enable DMA */
-	iwl_write_prph(priv, APMG_CLK_EN_REG, APMG_CLK_VAL_DMA_CLK_RQT);
-
-	udelay(20);
-
-	/* disable L1-Active */
-	iwl_set_bits_prph(priv, APMG_PCIDEV_STT_REG,
-			  APMG_PCIDEV_STT_VAL_L1_ACT_DIS);
-out:
-
-	return ret;
-}
-
-
 /* NIC configuration for 5000 series */
 void iwl5000_nic_config(struct iwl_priv *priv)
 {
@@ -1522,7 +1479,6 @@ struct iwl_lib_ops iwl5000_lib = {
 	.update_chain_flags = iwl_update_chain_flags,
 	.apm_ops = {
 		.init =	iwl5000_apm_init,
-		.reset = iwl5000_apm_reset,
 		.stop = iwl_apm_stop,
 		.config = iwl5000_nic_config,
 		.set_pwr_src = iwl_set_pwr_src,
@@ -1574,7 +1530,6 @@ static struct iwl_lib_ops iwl5150_lib = {
 	.update_chain_flags = iwl_update_chain_flags,
 	.apm_ops = {
 		.init =	iwl5000_apm_init,
-		.reset = iwl5000_apm_reset,
 		.stop = iwl_apm_stop,
 		.config = iwl5000_nic_config,
 		.set_pwr_src = iwl_set_pwr_src,
diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index d1f0b0b..46af74b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -192,7 +192,6 @@ static struct iwl_lib_ops iwl6000_lib = {
 	.update_chain_flags = iwl_update_chain_flags,
 	.apm_ops = {
 		.init =	iwl5000_apm_init,
-		.reset = iwl5000_apm_reset,
 		.stop = iwl_apm_stop,
 		.config = iwl6000_nic_config,
 		.set_pwr_src = iwl_set_pwr_src,
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 6688b69..447eb64 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -109,7 +109,6 @@ struct iwl_hcmd_utils_ops {
 
 struct iwl_apm_ops {
 	int (*init)(struct iwl_priv *priv);
-	int (*reset)(struct iwl_priv *priv);
 	void (*stop)(struct iwl_priv *priv);
 	void (*config)(struct iwl_priv *priv);
 	int (*set_pwr_src)(struct iwl_priv *priv, enum iwl_pwr_src src);
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 72946c1..9da0b03 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -86,7 +86,6 @@ extern void iwl5000_rts_tx_cmd_flag(struct ieee80211_tx_info *info,
 extern int iwl5000_calc_rssi(struct iwl_priv *priv,
 			     struct iwl_rx_phy_res *rx_resp);
 extern int iwl5000_apm_init(struct iwl_priv *priv);
-extern int iwl5000_apm_reset(struct iwl_priv *priv);
 extern void iwl5000_nic_config(struct iwl_priv *priv);
 extern u16 iwl5000_eeprom_calib_version(struct iwl_priv *priv);
 extern const u8 *iwl5000_eeprom_query_addr(const struct iwl_priv *priv,
-- 
1.5.6.3

