Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:23684 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755480Ab1GPPcO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 Jul 2011 11:32:14 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 12/18] iwlagn: calibration bitmap
Date: Sat, 16 Jul 2011 07:56:33 -0700
Message-Id: <1310828199-18000-14-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110716_173222_217769_2A248E8D)
In-Reply-To: <1310828199-18000-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1310828199-18000-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Define bitmap for calibration

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-2000.c     |    2 +-
 drivers/net/wireless/iwlwifi/iwl-6000.c     |    2 +-
 drivers/net/wireless/iwlwifi/iwl-commands.h |   19 +++++++++++--------
 3 files changed, 13 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-2000.c b/drivers/net/wireless/iwlwifi/iwl-2000.c
index f72f619..68ee25b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-2000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-2000.c
@@ -156,7 +156,7 @@ static int iwl2000_hw_set_hw_params(struct iwl_priv *priv)
 		BIT(IWL_CALIB_TX_IQ)            |
 		BIT(IWL_CALIB_BASE_BAND);
 	if (priv->cfg->need_dc_calib)
-		priv->hw_params.calib_rt_cfg |= BIT(IWL_CALIB_CFG_DC_IDX);
+		priv->hw_params.calib_rt_cfg |= IWL_CALIB_CFG_DC_IDX;
 	if (priv->cfg->need_temp_offset_calib)
 		priv->hw_params.calib_init_cfg |= BIT(IWL_CALIB_TEMP_OFFSET);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index 5ab7524..cffff09 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -176,7 +176,7 @@ static int iwl6000_hw_set_hw_params(struct iwl_priv *priv)
 		BIT(IWL_CALIB_TX_IQ)		|
 		BIT(IWL_CALIB_BASE_BAND);
 	if (priv->cfg->need_dc_calib)
-		priv->hw_params.calib_rt_cfg |= BIT(IWL_CALIB_CFG_DC_IDX);
+		priv->hw_params.calib_rt_cfg |= IWL_CALIB_CFG_DC_IDX;
 	if (priv->cfg->need_temp_offset_calib)
 		priv->hw_params.calib_init_cfg |= BIT(IWL_CALIB_TEMP_OFFSET);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-commands.h b/drivers/net/wireless/iwlwifi/iwl-commands.h
index ee25637..324a628 100644
--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
@@ -3174,14 +3174,17 @@ enum {
  * init ucode and runtime ucode through CALIBRATION_CFG_CMD.
  */
 enum iwl_ucode_calib_cfg {
-	IWL_CALIB_CFG_RX_BB_IDX,
-	IWL_CALIB_CFG_DC_IDX,
-	IWL_CALIB_CFG_TX_IQ_IDX,
-	IWL_CALIB_CFG_RX_IQ_IDX,
-	IWL_CALIB_CFG_NOISE_IDX,
-	IWL_CALIB_CFG_CRYSTAL_IDX,
-	IWL_CALIB_CFG_TEMPERATURE_IDX,
-	IWL_CALIB_CFG_PAPD_IDX,
+	IWL_CALIB_CFG_RX_BB_IDX			= BIT(0),
+	IWL_CALIB_CFG_DC_IDX			= BIT(1),
+	IWL_CALIB_CFG_LO_IDX			= BIT(2),
+	IWL_CALIB_CFG_TX_IQ_IDX			= BIT(3),
+	IWL_CALIB_CFG_RX_IQ_IDX			= BIT(4),
+	IWL_CALIB_CFG_NOISE_IDX			= BIT(5),
+	IWL_CALIB_CFG_CRYSTAL_IDX		= BIT(6),
+	IWL_CALIB_CFG_TEMPERATURE_IDX		= BIT(7),
+	IWL_CALIB_CFG_PAPD_IDX			= BIT(8),
+	IWL_CALIB_CFG_SENSITIVITY_IDX		= BIT(9),
+	IWL_CALIB_CFG_TX_PWR_IDX		= BIT(10),
 };
 
 
-- 
1.7.0.4

