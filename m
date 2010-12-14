Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:1317 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758072Ab0LNARI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Dec 2010 19:17:08 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 05/14] iwlagn: rx antenna diversity
Date: Mon, 13 Dec 2010 16:09:23 -0800
Message-Id: <1292285372-11373-6-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1292285372-11373-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1292285372-11373-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

For the new 1x1 devices, hw and uCode will support rx
antenna diversity, but we need to indicate 1x1 device to
AccessPoint to make sure it won't use MIMO.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-1000.c |    8 +++++++-
 drivers/net/wireless/iwlwifi/iwl-6000.c |    8 +++++++-
 drivers/net/wireless/iwlwifi/iwl-core.h |    2 ++
 3 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-1000.c b/drivers/net/wireless/iwlwifi/iwl-1000.c
index 3c983e4..94521d4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-1000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-1000.c
@@ -147,7 +147,11 @@ static int iwl1000_hw_set_hw_params(struct iwl_priv *priv)
 	priv->hw_params.rx_wrt_ptr_reg = FH_RSCSR_CHNL0_WPTR;
 
 	priv->hw_params.tx_chains_num = num_of_ant(priv->cfg->valid_tx_ant);
-	priv->hw_params.rx_chains_num = num_of_ant(priv->cfg->valid_rx_ant);
+	if (priv->cfg->rx_with_siso_diversity)
+		priv->hw_params.rx_chains_num = 1;
+	else
+		priv->hw_params.rx_chains_num =
+			num_of_ant(priv->cfg->valid_rx_ant);
 	priv->hw_params.valid_tx_ant = priv->cfg->valid_tx_ant;
 	priv->hw_params.valid_rx_ant = priv->cfg->valid_rx_ant;
 
@@ -311,6 +315,7 @@ struct iwl_cfg iwl100_bgn_cfg = {
 	.base_params = &iwl1000_base_params,
 	.ht_params = &iwl1000_ht_params,
 	.led_mode = IWL_LED_RF_STATE,
+	.rx_with_siso_diversity = true,
 };
 
 struct iwl_cfg iwl100_bg_cfg = {
@@ -324,6 +329,7 @@ struct iwl_cfg iwl100_bg_cfg = {
 	.mod_params = &iwlagn_mod_params,
 	.base_params = &iwl1000_base_params,
 	.led_mode = IWL_LED_RF_STATE,
+	.rx_with_siso_diversity = true,
 };
 
 MODULE_FIRMWARE(IWL1000_MODULE_FIRMWARE(IWL1000_UCODE_API_MAX));
diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index 10a5369..8a78924 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -182,7 +182,11 @@ static int iwl6000_hw_set_hw_params(struct iwl_priv *priv)
 	priv->hw_params.rx_wrt_ptr_reg = FH_RSCSR_CHNL0_WPTR;
 
 	priv->hw_params.tx_chains_num = num_of_ant(priv->cfg->valid_tx_ant);
-	priv->hw_params.rx_chains_num = num_of_ant(priv->cfg->valid_rx_ant);
+	if (priv->cfg->rx_with_siso_diversity)
+		priv->hw_params.rx_chains_num = 1;
+	else
+		priv->hw_params.rx_chains_num =
+			num_of_ant(priv->cfg->valid_rx_ant);
 	priv->hw_params.valid_tx_ant = priv->cfg->valid_tx_ant;
 	priv->hw_params.valid_rx_ant = priv->cfg->valid_rx_ant;
 
@@ -841,6 +845,7 @@ struct iwl_cfg iwl130_bgn_cfg = {
 	.adv_pm = true,
 	/* Due to bluetooth, we transmit 2.4 GHz probes only on antenna A */
 	.scan_tx_antennas[IEEE80211_BAND_2GHZ] = ANT_A,
+	.rx_with_siso_diversity = true,
 };
 
 struct iwl_cfg iwl130_bg_cfg = {
@@ -859,6 +864,7 @@ struct iwl_cfg iwl130_bg_cfg = {
 	.adv_pm = true,
 	/* Due to bluetooth, we transmit 2.4 GHz probes only on antenna A */
 	.scan_tx_antennas[IEEE80211_BAND_2GHZ] = ANT_A,
+	.rx_with_siso_diversity = true,
 };
 
 MODULE_FIRMWARE(IWL6000_MODULE_FIRMWARE(IWL6000_UCODE_API_MAX));
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 568920a..d0b86f5 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -364,6 +364,7 @@ struct iwl_ht_params {
  * @scan_antennas: available antenna for scan operation
  * @led_mode: 0=blinking, 1=On(RF On)/Off(RF Off)
  * @adv_pm: advance power management
+ * @rx_with_siso_diversity: 1x1 device with rx antenna diversity
  *
  * We enable the driver to be backward compatible wrt API version. The
  * driver specifies which APIs it supports (with @ucode_api_max being the
@@ -412,6 +413,7 @@ struct iwl_cfg {
 	u8 scan_tx_antennas[IEEE80211_NUM_BANDS];
 	enum iwl_led_mode led_mode;
 	const bool adv_pm;
+	const bool rx_with_siso_diversity;
 };
 
 /***************************
-- 
1.7.0.4

