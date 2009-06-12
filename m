Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:42648 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755780AbZFLUPv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Jun 2009 16:15:51 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 6/8] iwlwifi: modify sensitivity value for 5150
Date: Fri, 12 Jun 2009 13:22:53 -0700
Message-Id: <1244838175-15491-7-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1244838175-15491-6-git-send-email-reinette.chatre@intel.com>
References: <1244838175-15491-1-git-send-email-reinette.chatre@intel.com>
 <1244838175-15491-2-git-send-email-reinette.chatre@intel.com>
 <1244838175-15491-3-git-send-email-reinette.chatre@intel.com>
 <1244838175-15491-4-git-send-email-reinette.chatre@intel.com>
 <1244838175-15491-5-git-send-email-reinette.chatre@intel.com>
 <1244838175-15491-6-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

In 5150 there is a long delay between the AGC(Automatic Gain Control) command
till the RF is stabilized causing us to miss detections when there was
adjacent channel noise, so we need to adjusted the Sensitivity calibration
for 5150 differently.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-5000.c |   27 +++++++++++++++++++++++++--
 1 files changed, 25 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index b3c648c..0e445a9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -407,6 +407,28 @@ static struct iwl_sensitivity_ranges iwl5000_sensitivity = {
 	.nrg_th_ofdm = 95,
 };
 
+static struct iwl_sensitivity_ranges iwl5150_sensitivity = {
+	.min_nrg_cck = 95,
+	.max_nrg_cck = 0, /* not used, set to 0 */
+	.auto_corr_min_ofdm = 90,
+	.auto_corr_min_ofdm_mrc = 170,
+	.auto_corr_min_ofdm_x1 = 105,
+	.auto_corr_min_ofdm_mrc_x1 = 220,
+
+	.auto_corr_max_ofdm = 120,
+	.auto_corr_max_ofdm_mrc = 210,
+	/* max = min for performance bug in 5150 DSP */
+	.auto_corr_max_ofdm_x1 = 105,
+	.auto_corr_max_ofdm_mrc_x1 = 220,
+
+	.auto_corr_min_cck = 125,
+	.auto_corr_max_cck = 200,
+	.auto_corr_min_cck_mrc = 170,
+	.auto_corr_max_cck_mrc = 400,
+	.nrg_th_cck = 95,
+	.nrg_th_ofdm = 95,
+};
+
 static const u8 *iwl5000_eeprom_query_addr(const struct iwl_priv *priv,
 					   size_t offset)
 {
@@ -826,8 +848,6 @@ static int iwl5000_hw_set_hw_params(struct iwl_priv *priv)
 					BIT(IEEE80211_BAND_5GHZ);
 	priv->hw_params.rx_wrt_ptr_reg = FH_RSCSR_CHNL0_WPTR;
 
-	priv->hw_params.sens = &iwl5000_sensitivity;
-
 	priv->hw_params.tx_chains_num = num_of_ant(priv->cfg->valid_tx_ant);
 	priv->hw_params.rx_chains_num = num_of_ant(priv->cfg->valid_rx_ant);
 	priv->hw_params.valid_tx_ant = priv->cfg->valid_tx_ant;
@@ -836,9 +856,11 @@ static int iwl5000_hw_set_hw_params(struct iwl_priv *priv)
 	if (priv->cfg->ops->lib->temp_ops.set_ct_kill)
 		priv->cfg->ops->lib->temp_ops.set_ct_kill(priv);
 
+	/* Set initial sensitivity parameters */
 	/* Set initial calibration set */
 	switch (priv->hw_rev & CSR_HW_REV_TYPE_MSK) {
 	case CSR_HW_REV_TYPE_5150:
+		priv->hw_params.sens = &iwl5150_sensitivity;
 		priv->hw_params.calib_init_cfg =
 			BIT(IWL_CALIB_DC)		|
 			BIT(IWL_CALIB_LO)		|
@@ -847,6 +869,7 @@ static int iwl5000_hw_set_hw_params(struct iwl_priv *priv)
 
 		break;
 	default:
+		priv->hw_params.sens = &iwl5000_sensitivity;
 		priv->hw_params.calib_init_cfg =
 			BIT(IWL_CALIB_XTAL)		|
 			BIT(IWL_CALIB_LO)		|
-- 
1.5.6.3

