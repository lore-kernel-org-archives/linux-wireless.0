Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:59924 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753751Ab0JGXIv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Oct 2010 19:08:51 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 14/22] iwlwifi: remove set_ct_kill operation
Date: Thu,  7 Oct 2010 16:07:53 -0700
Message-Id: <1286492881-15743-15-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1286492881-15743-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1286492881-15743-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

This operation is only ever called from set_hw_params,
which is also already based on the config/ops, so that
there's no need to have a separate set_ct_kill op and
we can just call the right ct_threshold function.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-1000.c |    4 +---
 drivers/net/wireless/iwlwifi/iwl-4965.c |    5 ++---
 drivers/net/wireless/iwlwifi/iwl-5000.c |    8 ++------
 drivers/net/wireless/iwlwifi/iwl-6000.c |    5 +----
 drivers/net/wireless/iwlwifi/iwl-core.h |    1 -
 5 files changed, 6 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-1000.c b/drivers/net/wireless/iwlwifi/iwl-1000.c
index 8c2db55..8aed9ea 100644
--- a/drivers/net/wireless/iwlwifi/iwl-1000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-1000.c
@@ -151,8 +151,7 @@ static int iwl1000_hw_set_hw_params(struct iwl_priv *priv)
 	priv->hw_params.valid_tx_ant = priv->cfg->valid_tx_ant;
 	priv->hw_params.valid_rx_ant = priv->cfg->valid_rx_ant;
 
-	if (priv->cfg->ops->lib->temp_ops.set_ct_kill)
-		priv->cfg->ops->lib->temp_ops.set_ct_kill(priv);
+	iwl1000_set_ct_threshold(priv);
 
 	/* Set initial sensitivity parameters */
 	/* Set initial calibration set */
@@ -219,7 +218,6 @@ static struct iwl_lib_ops iwl1000_lib = {
 	.config_ap = iwl_config_ap,
 	.temp_ops = {
 		.temperature = iwlagn_temperature,
-		.set_ct_kill = iwl1000_set_ct_threshold,
 	 },
 	.manage_ibss_station = iwlagn_manage_ibss_station,
 	.update_bcast_stations = iwl_update_bcast_stations,
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 08d2dbc..c192856 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -669,8 +669,8 @@ static int iwl4965_hw_set_hw_params(struct iwl_priv *priv)
 	priv->hw_params.rx_chains_num = num_of_ant(priv->cfg->valid_rx_ant);
 	priv->hw_params.valid_tx_ant = priv->cfg->valid_tx_ant;
 	priv->hw_params.valid_rx_ant = priv->cfg->valid_rx_ant;
-	if (priv->cfg->ops->lib->temp_ops.set_ct_kill)
-		priv->cfg->ops->lib->temp_ops.set_ct_kill(priv);
+
+	iwl4965_set_ct_threshold(priv);
 
 	priv->hw_params.sens = &iwl4965_sensitivity;
 	priv->hw_params.beacon_time_tsf_bits = IWLAGN_EXT_BEACON_TIME_POS;
@@ -2292,7 +2292,6 @@ static struct iwl_lib_ops iwl4965_lib = {
 	.isr = iwl_isr_legacy,
 	.temp_ops = {
 		.temperature = iwl4965_temperature_calib,
-		.set_ct_kill = iwl4965_set_ct_threshold,
 	},
 	.manage_ibss_station = iwlagn_manage_ibss_station,
 	.update_bcast_stations = iwl_update_bcast_stations,
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index ddbbb93..084271e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -195,8 +195,7 @@ static int iwl5000_hw_set_hw_params(struct iwl_priv *priv)
 	priv->hw_params.valid_tx_ant = priv->cfg->valid_tx_ant;
 	priv->hw_params.valid_rx_ant = priv->cfg->valid_rx_ant;
 
-	if (priv->cfg->ops->lib->temp_ops.set_ct_kill)
-		priv->cfg->ops->lib->temp_ops.set_ct_kill(priv);
+	iwl5000_set_ct_threshold(priv);
 
 	/* Set initial sensitivity parameters */
 	/* Set initial calibration set */
@@ -242,8 +241,7 @@ static int iwl5150_hw_set_hw_params(struct iwl_priv *priv)
 	priv->hw_params.valid_tx_ant = priv->cfg->valid_tx_ant;
 	priv->hw_params.valid_rx_ant = priv->cfg->valid_rx_ant;
 
-	if (priv->cfg->ops->lib->temp_ops.set_ct_kill)
-		priv->cfg->ops->lib->temp_ops.set_ct_kill(priv);
+	iwl5150_set_ct_threshold(priv);
 
 	/* Set initial sensitivity parameters */
 	/* Set initial calibration set */
@@ -394,7 +392,6 @@ static struct iwl_lib_ops iwl5000_lib = {
 	.config_ap = iwl_config_ap,
 	.temp_ops = {
 		.temperature = iwlagn_temperature,
-		.set_ct_kill = iwl5000_set_ct_threshold,
 	 },
 	.manage_ibss_station = iwlagn_manage_ibss_station,
 	.update_bcast_stations = iwl_update_bcast_stations,
@@ -465,7 +462,6 @@ static struct iwl_lib_ops iwl5150_lib = {
 	.config_ap = iwl_config_ap,
 	.temp_ops = {
 		.temperature = iwl5150_temperature,
-		.set_ct_kill = iwl5150_set_ct_threshold,
 	 },
 	.manage_ibss_station = iwlagn_manage_ibss_station,
 	.update_bcast_stations = iwl_update_bcast_stations,
diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index 198cd8f..84f1814 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -192,8 +192,7 @@ static int iwl6000_hw_set_hw_params(struct iwl_priv *priv)
 	priv->hw_params.valid_tx_ant = priv->cfg->valid_tx_ant;
 	priv->hw_params.valid_rx_ant = priv->cfg->valid_rx_ant;
 
-	if (priv->cfg->ops->lib->temp_ops.set_ct_kill)
-		priv->cfg->ops->lib->temp_ops.set_ct_kill(priv);
+	iwl6000_set_ct_threshold(priv);
 
 	/* Set initial sensitivity parameters */
 	/* Set initial calibration set */
@@ -334,7 +333,6 @@ static struct iwl_lib_ops iwl6000_lib = {
 	.config_ap = iwl_config_ap,
 	.temp_ops = {
 		.temperature = iwlagn_temperature,
-		.set_ct_kill = iwl6000_set_ct_threshold,
 	 },
 	.manage_ibss_station = iwlagn_manage_ibss_station,
 	.update_bcast_stations = iwl_update_bcast_stations,
@@ -408,7 +406,6 @@ static struct iwl_lib_ops iwl6000g2b_lib = {
 	.config_ap = iwl_config_ap,
 	.temp_ops = {
 		.temperature = iwlagn_temperature,
-		.set_ct_kill = iwl6000_set_ct_threshold,
 	 },
 	.manage_ibss_station = iwlagn_manage_ibss_station,
 	.update_bcast_stations = iwl_update_bcast_stations,
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index b02db31..f3c3d85 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -137,7 +137,6 @@ struct iwl_debugfs_ops {
 
 struct iwl_temp_ops {
 	void (*temperature)(struct iwl_priv *priv);
-	void (*set_ct_kill)(struct iwl_priv *priv);
 };
 
 struct iwl_tt_ops {
-- 
1.7.0.4

