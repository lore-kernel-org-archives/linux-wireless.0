Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:11393 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751794Ab1HMSSc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Aug 2011 14:18:32 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 07/60] iwlagn: hw_params moves to iwl_shared
Date: Sat, 13 Aug 2011 10:37:43 -0700
Message-Id: <1313257116-2697-8-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110813_201845_811518_F92BD9D2)
In-Reply-To: <1313257116-2697-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1313257116-2697-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Since it is used by all the layers, it needs to move to iwl_shared.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-1000.c          |   36 ++++++------
 drivers/net/wireless/iwlwifi/iwl-2000.c          |   38 ++++++------
 drivers/net/wireless/iwlwifi/iwl-5000.c          |   62 ++++++++++----------
 drivers/net/wireless/iwlwifi/iwl-6000.c          |   38 ++++++------
 drivers/net/wireless/iwlwifi/iwl-agn-calib.c     |   21 ++++---
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c       |   11 ++--
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c        |   66 ++++++++++++----------
 drivers/net/wireless/iwlwifi/iwl-agn-sta.c       |   12 ++--
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c        |    8 +-
 drivers/net/wireless/iwlwifi/iwl-agn.c           |   48 ++++++++--------
 drivers/net/wireless/iwlwifi/iwl-core.c          |   30 +++++-----
 drivers/net/wireless/iwlwifi/iwl-debugfs.c       |    6 +-
 drivers/net/wireless/iwlwifi/iwl-dev.h           |   54 +-----------------
 drivers/net/wireless/iwlwifi/iwl-prph.h          |    2 +-
 drivers/net/wireless/iwlwifi/iwl-scan.c          |    2 +-
 drivers/net/wireless/iwlwifi/iwl-shared.h        |   51 +++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-sta.c           |   11 ++--
 drivers/net/wireless/iwlwifi/iwl-trans-rx-pcie.c |   20 ++++---
 drivers/net/wireless/iwlwifi/iwl-trans.c         |   24 ++++----
 19 files changed, 278 insertions(+), 262 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-1000.c b/drivers/net/wireless/iwlwifi/iwl-1000.c
index 0ed7252..554d8ac 100644
--- a/drivers/net/wireless/iwlwifi/iwl-1000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-1000.c
@@ -78,8 +78,8 @@
 static void iwl1000_set_ct_threshold(struct iwl_priv *priv)
 {
 	/* want Celsius */
-	priv->hw_params.ct_kill_threshold = CT_KILL_THRESHOLD_LEGACY;
-	priv->hw_params.ct_kill_exit_threshold = CT_KILL_EXIT_THRESHOLD;
+	hw_params(priv).ct_kill_threshold = CT_KILL_THRESHOLD_LEGACY;
+	hw_params(priv).ct_kill_exit_threshold = CT_KILL_EXIT_THRESHOLD;
 }
 
 /* NIC configuration for 1000 series */
@@ -129,43 +129,43 @@ static int iwl1000_hw_set_hw_params(struct iwl_priv *priv)
 		priv->cfg->base_params->num_of_queues =
 			iwlagn_mod_params.num_of_queues;
 
-	priv->hw_params.max_txq_num = priv->cfg->base_params->num_of_queues;
-	priv->hw_params.scd_bc_tbls_size =
+	hw_params(priv).max_txq_num = priv->cfg->base_params->num_of_queues;
+	hw_params(priv).scd_bc_tbls_size =
 			priv->cfg->base_params->num_of_queues *
 			sizeof(struct iwlagn_scd_bc_tbl);
-	priv->hw_params.tfd_size = sizeof(struct iwl_tfd);
-	priv->hw_params.max_stations = IWLAGN_STATION_COUNT;
+	hw_params(priv).tfd_size = sizeof(struct iwl_tfd);
+	hw_params(priv).max_stations = IWLAGN_STATION_COUNT;
 	priv->contexts[IWL_RXON_CTX_BSS].bcast_sta_id = IWLAGN_BROADCAST_ID;
 
-	priv->hw_params.max_data_size = IWLAGN_RTC_DATA_SIZE;
-	priv->hw_params.max_inst_size = IWLAGN_RTC_INST_SIZE;
+	hw_params(priv).max_data_size = IWLAGN_RTC_DATA_SIZE;
+	hw_params(priv).max_inst_size = IWLAGN_RTC_INST_SIZE;
 
-	priv->hw_params.ht40_channel =  BIT(IEEE80211_BAND_2GHZ);
+	hw_params(priv).ht40_channel =  BIT(IEEE80211_BAND_2GHZ);
 
-	priv->hw_params.tx_chains_num = num_of_ant(priv->cfg->valid_tx_ant);
+	hw_params(priv).tx_chains_num = num_of_ant(priv->cfg->valid_tx_ant);
 	if (priv->cfg->rx_with_siso_diversity)
-		priv->hw_params.rx_chains_num = 1;
+		hw_params(priv).rx_chains_num = 1;
 	else
-		priv->hw_params.rx_chains_num =
+		hw_params(priv).rx_chains_num =
 			num_of_ant(priv->cfg->valid_rx_ant);
-	priv->hw_params.valid_tx_ant = priv->cfg->valid_tx_ant;
-	priv->hw_params.valid_rx_ant = priv->cfg->valid_rx_ant;
+	hw_params(priv).valid_tx_ant = priv->cfg->valid_tx_ant;
+	hw_params(priv).valid_rx_ant = priv->cfg->valid_rx_ant;
 
 	iwl1000_set_ct_threshold(priv);
 
 	/* Set initial sensitivity parameters */
 	/* Set initial calibration set */
-	priv->hw_params.sens = &iwl1000_sensitivity;
-	priv->hw_params.calib_init_cfg =
+	hw_params(priv).sens = &iwl1000_sensitivity;
+	hw_params(priv).calib_init_cfg =
 			BIT(IWL_CALIB_XTAL)		|
 			BIT(IWL_CALIB_LO)		|
 			BIT(IWL_CALIB_TX_IQ) 		|
 			BIT(IWL_CALIB_TX_IQ_PERD)	|
 			BIT(IWL_CALIB_BASE_BAND);
 	if (priv->cfg->need_dc_calib)
-		priv->hw_params.calib_init_cfg |= BIT(IWL_CALIB_DC);
+		hw_params(priv).calib_init_cfg |= BIT(IWL_CALIB_DC);
 
-	priv->hw_params.beacon_time_tsf_bits = IWLAGN_EXT_BEACON_TIME_POS;
+	hw_params(priv).beacon_time_tsf_bits = IWLAGN_EXT_BEACON_TIME_POS;
 
 	return 0;
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl-2000.c b/drivers/net/wireless/iwlwifi/iwl-2000.c
index 3c1b8a5..4e6eb89 100644
--- a/drivers/net/wireless/iwlwifi/iwl-2000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-2000.c
@@ -80,8 +80,8 @@
 static void iwl2000_set_ct_threshold(struct iwl_priv *priv)
 {
 	/* want Celsius */
-	priv->hw_params.ct_kill_threshold = CT_KILL_THRESHOLD;
-	priv->hw_params.ct_kill_exit_threshold = CT_KILL_EXIT_THRESHOLD;
+	hw_params(priv).ct_kill_threshold = CT_KILL_THRESHOLD;
+	hw_params(priv).ct_kill_exit_threshold = CT_KILL_EXIT_THRESHOLD;
 }
 
 /* NIC configuration for 2000 series */
@@ -126,44 +126,44 @@ static int iwl2000_hw_set_hw_params(struct iwl_priv *priv)
 		priv->cfg->base_params->num_of_queues =
 			iwlagn_mod_params.num_of_queues;
 
-	priv->hw_params.max_txq_num = priv->cfg->base_params->num_of_queues;
-	priv->hw_params.scd_bc_tbls_size =
+	hw_params(priv).max_txq_num = priv->cfg->base_params->num_of_queues;
+	hw_params(priv).scd_bc_tbls_size =
 		priv->cfg->base_params->num_of_queues *
 		sizeof(struct iwlagn_scd_bc_tbl);
-	priv->hw_params.tfd_size = sizeof(struct iwl_tfd);
-	priv->hw_params.max_stations = IWLAGN_STATION_COUNT;
+	hw_params(priv).tfd_size = sizeof(struct iwl_tfd);
+	hw_params(priv).max_stations = IWLAGN_STATION_COUNT;
 	priv->contexts[IWL_RXON_CTX_BSS].bcast_sta_id = IWLAGN_BROADCAST_ID;
 
-	priv->hw_params.max_data_size = IWL60_RTC_DATA_SIZE;
-	priv->hw_params.max_inst_size = IWL60_RTC_INST_SIZE;
+	hw_params(priv).max_data_size = IWL60_RTC_DATA_SIZE;
+	hw_params(priv).max_inst_size = IWL60_RTC_INST_SIZE;
 
-	priv->hw_params.ht40_channel =  BIT(IEEE80211_BAND_2GHZ);
+	hw_params(priv).ht40_channel =  BIT(IEEE80211_BAND_2GHZ);
 
-	priv->hw_params.tx_chains_num = num_of_ant(priv->cfg->valid_tx_ant);
+	hw_params(priv).tx_chains_num = num_of_ant(priv->cfg->valid_tx_ant);
 	if (priv->cfg->rx_with_siso_diversity)
-		priv->hw_params.rx_chains_num = 1;
+		hw_params(priv).rx_chains_num = 1;
 	else
-		priv->hw_params.rx_chains_num =
+		hw_params(priv).rx_chains_num =
 			num_of_ant(priv->cfg->valid_rx_ant);
-	priv->hw_params.valid_tx_ant = priv->cfg->valid_tx_ant;
-	priv->hw_params.valid_rx_ant = priv->cfg->valid_rx_ant;
+	hw_params(priv).valid_tx_ant = priv->cfg->valid_tx_ant;
+	hw_params(priv).valid_rx_ant = priv->cfg->valid_rx_ant;
 
 	iwl2000_set_ct_threshold(priv);
 
 	/* Set initial sensitivity parameters */
 	/* Set initial calibration set */
-	priv->hw_params.sens = &iwl2000_sensitivity;
-	priv->hw_params.calib_init_cfg =
+	hw_params(priv).sens = &iwl2000_sensitivity;
+	hw_params(priv).calib_init_cfg =
 		BIT(IWL_CALIB_XTAL)             |
 		BIT(IWL_CALIB_LO)               |
 		BIT(IWL_CALIB_TX_IQ)            |
 		BIT(IWL_CALIB_BASE_BAND);
 	if (priv->cfg->need_dc_calib)
-		priv->hw_params.calib_rt_cfg |= IWL_CALIB_CFG_DC_IDX;
+		hw_params(priv).calib_rt_cfg |= IWL_CALIB_CFG_DC_IDX;
 	if (priv->cfg->need_temp_offset_calib)
-		priv->hw_params.calib_init_cfg |= BIT(IWL_CALIB_TEMP_OFFSET);
+		hw_params(priv).calib_init_cfg |= BIT(IWL_CALIB_TEMP_OFFSET);
 
-	priv->hw_params.beacon_time_tsf_bits = IWLAGN_EXT_BEACON_TIME_POS;
+	hw_params(priv).beacon_time_tsf_bits = IWLAGN_EXT_BEACON_TIME_POS;
 
 	return 0;
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index 01f50d3..74426c9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -141,13 +141,13 @@ static void iwl5150_set_ct_threshold(struct iwl_priv *priv)
 	s32 threshold = (s32)CELSIUS_TO_KELVIN(CT_KILL_THRESHOLD_LEGACY) -
 			iwl_temp_calib_to_offset(priv);
 
-	priv->hw_params.ct_kill_threshold = threshold * volt2temp_coef;
+	hw_params(priv).ct_kill_threshold = threshold * volt2temp_coef;
 }
 
 static void iwl5000_set_ct_threshold(struct iwl_priv *priv)
 {
 	/* want Celsius */
-	priv->hw_params.ct_kill_threshold = CT_KILL_THRESHOLD_LEGACY;
+	hw_params(priv).ct_kill_threshold = CT_KILL_THRESHOLD_LEGACY;
 }
 
 static int iwl5000_hw_set_hw_params(struct iwl_priv *priv)
@@ -157,38 +157,38 @@ static int iwl5000_hw_set_hw_params(struct iwl_priv *priv)
 		priv->cfg->base_params->num_of_queues =
 			iwlagn_mod_params.num_of_queues;
 
-	priv->hw_params.max_txq_num = priv->cfg->base_params->num_of_queues;
-	priv->hw_params.scd_bc_tbls_size =
+	hw_params(priv).max_txq_num = priv->cfg->base_params->num_of_queues;
+	hw_params(priv).scd_bc_tbls_size =
 			priv->cfg->base_params->num_of_queues *
 			sizeof(struct iwlagn_scd_bc_tbl);
-	priv->hw_params.tfd_size = sizeof(struct iwl_tfd);
-	priv->hw_params.max_stations = IWLAGN_STATION_COUNT;
+	hw_params(priv).tfd_size = sizeof(struct iwl_tfd);
+	hw_params(priv).max_stations = IWLAGN_STATION_COUNT;
 	priv->contexts[IWL_RXON_CTX_BSS].bcast_sta_id = IWLAGN_BROADCAST_ID;
 
-	priv->hw_params.max_data_size = IWLAGN_RTC_DATA_SIZE;
-	priv->hw_params.max_inst_size = IWLAGN_RTC_INST_SIZE;
+	hw_params(priv).max_data_size = IWLAGN_RTC_DATA_SIZE;
+	hw_params(priv).max_inst_size = IWLAGN_RTC_INST_SIZE;
 
-	priv->hw_params.ht40_channel =  BIT(IEEE80211_BAND_2GHZ) |
+	hw_params(priv).ht40_channel =  BIT(IEEE80211_BAND_2GHZ) |
 					BIT(IEEE80211_BAND_5GHZ);
 
-	priv->hw_params.tx_chains_num = num_of_ant(priv->cfg->valid_tx_ant);
-	priv->hw_params.rx_chains_num = num_of_ant(priv->cfg->valid_rx_ant);
-	priv->hw_params.valid_tx_ant = priv->cfg->valid_tx_ant;
-	priv->hw_params.valid_rx_ant = priv->cfg->valid_rx_ant;
+	hw_params(priv).tx_chains_num = num_of_ant(priv->cfg->valid_tx_ant);
+	hw_params(priv).rx_chains_num = num_of_ant(priv->cfg->valid_rx_ant);
+	hw_params(priv).valid_tx_ant = priv->cfg->valid_tx_ant;
+	hw_params(priv).valid_rx_ant = priv->cfg->valid_rx_ant;
 
 	iwl5000_set_ct_threshold(priv);
 
 	/* Set initial sensitivity parameters */
 	/* Set initial calibration set */
-	priv->hw_params.sens = &iwl5000_sensitivity;
-	priv->hw_params.calib_init_cfg =
+	hw_params(priv).sens = &iwl5000_sensitivity;
+	hw_params(priv).calib_init_cfg =
 		BIT(IWL_CALIB_XTAL)		|
 		BIT(IWL_CALIB_LO)		|
 		BIT(IWL_CALIB_TX_IQ)		|
 		BIT(IWL_CALIB_TX_IQ_PERD)	|
 		BIT(IWL_CALIB_BASE_BAND);
 
-	priv->hw_params.beacon_time_tsf_bits = IWLAGN_EXT_BEACON_TIME_POS;
+	hw_params(priv).beacon_time_tsf_bits = IWLAGN_EXT_BEACON_TIME_POS;
 
 	return 0;
 }
@@ -200,38 +200,38 @@ static int iwl5150_hw_set_hw_params(struct iwl_priv *priv)
 		priv->cfg->base_params->num_of_queues =
 			iwlagn_mod_params.num_of_queues;
 
-	priv->hw_params.max_txq_num = priv->cfg->base_params->num_of_queues;
-	priv->hw_params.scd_bc_tbls_size =
+	hw_params(priv).max_txq_num = priv->cfg->base_params->num_of_queues;
+	hw_params(priv).scd_bc_tbls_size =
 			priv->cfg->base_params->num_of_queues *
 			sizeof(struct iwlagn_scd_bc_tbl);
-	priv->hw_params.tfd_size = sizeof(struct iwl_tfd);
-	priv->hw_params.max_stations = IWLAGN_STATION_COUNT;
+	hw_params(priv).tfd_size = sizeof(struct iwl_tfd);
+	hw_params(priv).max_stations = IWLAGN_STATION_COUNT;
 	priv->contexts[IWL_RXON_CTX_BSS].bcast_sta_id = IWLAGN_BROADCAST_ID;
 
-	priv->hw_params.max_data_size = IWLAGN_RTC_DATA_SIZE;
-	priv->hw_params.max_inst_size = IWLAGN_RTC_INST_SIZE;
+	hw_params(priv).max_data_size = IWLAGN_RTC_DATA_SIZE;
+	hw_params(priv).max_inst_size = IWLAGN_RTC_INST_SIZE;
 
-	priv->hw_params.ht40_channel =  BIT(IEEE80211_BAND_2GHZ) |
+	hw_params(priv).ht40_channel =  BIT(IEEE80211_BAND_2GHZ) |
 					BIT(IEEE80211_BAND_5GHZ);
 
-	priv->hw_params.tx_chains_num = num_of_ant(priv->cfg->valid_tx_ant);
-	priv->hw_params.rx_chains_num = num_of_ant(priv->cfg->valid_rx_ant);
-	priv->hw_params.valid_tx_ant = priv->cfg->valid_tx_ant;
-	priv->hw_params.valid_rx_ant = priv->cfg->valid_rx_ant;
+	hw_params(priv).tx_chains_num = num_of_ant(priv->cfg->valid_tx_ant);
+	hw_params(priv).rx_chains_num = num_of_ant(priv->cfg->valid_rx_ant);
+	hw_params(priv).valid_tx_ant = priv->cfg->valid_tx_ant;
+	hw_params(priv).valid_rx_ant = priv->cfg->valid_rx_ant;
 
 	iwl5150_set_ct_threshold(priv);
 
 	/* Set initial sensitivity parameters */
 	/* Set initial calibration set */
-	priv->hw_params.sens = &iwl5150_sensitivity;
-	priv->hw_params.calib_init_cfg =
+	hw_params(priv).sens = &iwl5150_sensitivity;
+	hw_params(priv).calib_init_cfg =
 		BIT(IWL_CALIB_LO)		|
 		BIT(IWL_CALIB_TX_IQ)		|
 		BIT(IWL_CALIB_BASE_BAND);
 	if (priv->cfg->need_dc_calib)
-		priv->hw_params.calib_init_cfg |= BIT(IWL_CALIB_DC);
+		hw_params(priv).calib_init_cfg |= BIT(IWL_CALIB_DC);
 
-	priv->hw_params.beacon_time_tsf_bits = IWLAGN_EXT_BEACON_TIME_POS;
+	hw_params(priv).beacon_time_tsf_bits = IWLAGN_EXT_BEACON_TIME_POS;
 
 	return 0;
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index 439cec4..0f6539a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -76,8 +76,8 @@
 static void iwl6000_set_ct_threshold(struct iwl_priv *priv)
 {
 	/* want Celsius */
-	priv->hw_params.ct_kill_threshold = CT_KILL_THRESHOLD;
-	priv->hw_params.ct_kill_exit_threshold = CT_KILL_EXIT_THRESHOLD;
+	hw_params(priv).ct_kill_threshold = CT_KILL_THRESHOLD;
+	hw_params(priv).ct_kill_exit_threshold = CT_KILL_EXIT_THRESHOLD;
 }
 
 static void iwl6050_additional_nic_config(struct iwl_priv *priv)
@@ -146,45 +146,45 @@ static int iwl6000_hw_set_hw_params(struct iwl_priv *priv)
 		priv->cfg->base_params->num_of_queues =
 			iwlagn_mod_params.num_of_queues;
 
-	priv->hw_params.max_txq_num = priv->cfg->base_params->num_of_queues;
-	priv->hw_params.scd_bc_tbls_size =
+	hw_params(priv).max_txq_num = priv->cfg->base_params->num_of_queues;
+	hw_params(priv).scd_bc_tbls_size =
 			priv->cfg->base_params->num_of_queues *
 			sizeof(struct iwlagn_scd_bc_tbl);
-	priv->hw_params.tfd_size = sizeof(struct iwl_tfd);
-	priv->hw_params.max_stations = IWLAGN_STATION_COUNT;
+	hw_params(priv).tfd_size = sizeof(struct iwl_tfd);
+	hw_params(priv).max_stations = IWLAGN_STATION_COUNT;
 	priv->contexts[IWL_RXON_CTX_BSS].bcast_sta_id = IWLAGN_BROADCAST_ID;
 
-	priv->hw_params.max_data_size = IWL60_RTC_DATA_SIZE;
-	priv->hw_params.max_inst_size = IWL60_RTC_INST_SIZE;
+	hw_params(priv).max_data_size = IWL60_RTC_DATA_SIZE;
+	hw_params(priv).max_inst_size = IWL60_RTC_INST_SIZE;
 
-	priv->hw_params.ht40_channel =  BIT(IEEE80211_BAND_2GHZ) |
+	hw_params(priv).ht40_channel =  BIT(IEEE80211_BAND_2GHZ) |
 					BIT(IEEE80211_BAND_5GHZ);
 
-	priv->hw_params.tx_chains_num = num_of_ant(priv->cfg->valid_tx_ant);
+	hw_params(priv).tx_chains_num = num_of_ant(priv->cfg->valid_tx_ant);
 	if (priv->cfg->rx_with_siso_diversity)
-		priv->hw_params.rx_chains_num = 1;
+		hw_params(priv).rx_chains_num = 1;
 	else
-		priv->hw_params.rx_chains_num =
+		hw_params(priv).rx_chains_num =
 			num_of_ant(priv->cfg->valid_rx_ant);
-	priv->hw_params.valid_tx_ant = priv->cfg->valid_tx_ant;
-	priv->hw_params.valid_rx_ant = priv->cfg->valid_rx_ant;
+	hw_params(priv).valid_tx_ant = priv->cfg->valid_tx_ant;
+	hw_params(priv).valid_rx_ant = priv->cfg->valid_rx_ant;
 
 	iwl6000_set_ct_threshold(priv);
 
 	/* Set initial sensitivity parameters */
 	/* Set initial calibration set */
-	priv->hw_params.sens = &iwl6000_sensitivity;
-	priv->hw_params.calib_init_cfg =
+	hw_params(priv).sens = &iwl6000_sensitivity;
+	hw_params(priv).calib_init_cfg =
 		BIT(IWL_CALIB_XTAL)		|
 		BIT(IWL_CALIB_LO)		|
 		BIT(IWL_CALIB_TX_IQ)		|
 		BIT(IWL_CALIB_BASE_BAND);
 	if (priv->cfg->need_dc_calib)
-		priv->hw_params.calib_rt_cfg |= IWL_CALIB_CFG_DC_IDX;
+		hw_params(priv).calib_rt_cfg |= IWL_CALIB_CFG_DC_IDX;
 	if (priv->cfg->need_temp_offset_calib)
-		priv->hw_params.calib_init_cfg |= BIT(IWL_CALIB_TEMP_OFFSET);
+		hw_params(priv).calib_init_cfg |= BIT(IWL_CALIB_TEMP_OFFSET);
 
-	priv->hw_params.beacon_time_tsf_bits = IWLAGN_EXT_BEACON_TIME_POS;
+	hw_params(priv).beacon_time_tsf_bits = IWLAGN_EXT_BEACON_TIME_POS;
 
 	return 0;
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-calib.c b/drivers/net/wireless/iwlwifi/iwl-agn-calib.c
index 1789e3a..f0e38a1 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-calib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-calib.c
@@ -93,7 +93,7 @@ int iwl_send_calib_results(struct iwl_priv *priv)
 	};
 
 	for (i = 0; i < IWL_CALIB_MAX; i++) {
-		if ((BIT(i) & priv->hw_params.calib_init_cfg) &&
+		if ((BIT(i) & hw_params(priv).calib_init_cfg) &&
 		    priv->calib_results[i].buf) {
 			hcmd.len[0] = priv->calib_results[i].buf_len;
 			hcmd.data[0] = priv->calib_results[i].buf;
@@ -174,7 +174,7 @@ static int iwl_sens_energy_cck(struct iwl_priv *priv,
 	u32 max_false_alarms = MAX_FA_CCK * rx_enable_time;
 	u32 min_false_alarms = MIN_FA_CCK * rx_enable_time;
 	struct iwl_sensitivity_data *data = NULL;
-	const struct iwl_sensitivity_ranges *ranges = priv->hw_params.sens;
+	const struct iwl_sensitivity_ranges *ranges = hw_params(priv).sens;
 
 	data = &(priv->sensitivity_data);
 
@@ -357,7 +357,7 @@ static int iwl_sens_auto_corr_ofdm(struct iwl_priv *priv,
 	u32 max_false_alarms = MAX_FA_OFDM * rx_enable_time;
 	u32 min_false_alarms = MIN_FA_OFDM * rx_enable_time;
 	struct iwl_sensitivity_data *data = NULL;
-	const struct iwl_sensitivity_ranges *ranges = priv->hw_params.sens;
+	const struct iwl_sensitivity_ranges *ranges = hw_params(priv).sens;
 
 	data = &(priv->sensitivity_data);
 
@@ -581,7 +581,7 @@ void iwl_init_sensitivity(struct iwl_priv *priv)
 	int ret = 0;
 	int i;
 	struct iwl_sensitivity_data *data = NULL;
-	const struct iwl_sensitivity_ranges *ranges = priv->hw_params.sens;
+	const struct iwl_sensitivity_ranges *ranges = hw_params(priv).sens;
 
 	if (priv->disable_sens_cal)
 		return;
@@ -821,21 +821,21 @@ static void iwl_find_disconn_antenna(struct iwl_priv *priv, u32* average_sig,
 	 * To be safe, simply mask out any chains that we know
 	 * are not on the device.
 	 */
-	active_chains &= priv->hw_params.valid_rx_ant;
+	active_chains &= hw_params(priv).valid_rx_ant;
 
 	num_tx_chains = 0;
 	for (i = 0; i < NUM_RX_CHAINS; i++) {
 		/* loops on all the bits of
 		 * priv->hw_setting.valid_tx_ant */
 		u8 ant_msk = (1 << i);
-		if (!(priv->hw_params.valid_tx_ant & ant_msk))
+		if (!(hw_params(priv).valid_tx_ant & ant_msk))
 			continue;
 
 		num_tx_chains++;
 		if (data->disconn_array[i] == 0)
 			/* there is a Tx antenna connected */
 			break;
-		if (num_tx_chains == priv->hw_params.tx_chains_num &&
+		if (num_tx_chains == hw_params(priv).tx_chains_num &&
 		    data->disconn_array[i]) {
 			/*
 			 * If all chains are disconnected
@@ -852,12 +852,13 @@ static void iwl_find_disconn_antenna(struct iwl_priv *priv, u32* average_sig,
 		}
 	}
 
-	if (active_chains != priv->hw_params.valid_rx_ant &&
+	if (active_chains != hw_params(priv).valid_rx_ant &&
 	    active_chains != priv->chain_noise_data.active_chains)
 		IWL_DEBUG_CALIB(priv,
 				"Detected that not all antennas are connected! "
 				"Connected: %#x, valid: %#x.\n",
-				active_chains, priv->hw_params.valid_rx_ant);
+				active_chains,
+				hw_params(priv).valid_rx_ant);
 
 	/* Save for use within RXON, TX, SCAN commands, etc. */
 	data->active_chains = active_chains;
@@ -1046,7 +1047,7 @@ void iwl_chain_noise_calibration(struct iwl_priv *priv)
 	    priv->cfg->bt_params->advanced_bt_coexist) {
 		/* Disable disconnected antenna algorithm for advanced
 		   bt coex, assuming valid antennas are connected */
-		data->active_chains = priv->hw_params.valid_rx_ant;
+		data->active_chains = hw_params(priv).valid_rx_ant;
 		for (i = 0; i < NUM_RX_CHAINS; i++)
 			if (!(data->active_chains & (1<<i)))
 				data->disconn_array[i] = 1;
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index dd95f47..048ccba 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -770,12 +770,12 @@ int iwlagn_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif)
 	u16 rx_chain = 0;
 	enum ieee80211_band band;
 	u8 n_probes = 0;
-	u8 rx_ant = priv->hw_params.valid_rx_ant;
+	u8 rx_ant = hw_params(priv).valid_rx_ant;
 	u8 rate;
 	bool is_active = false;
 	int  chan_mod;
 	u8 active_chains;
-	u8 scan_tx_antennas = priv->hw_params.valid_tx_ant;
+	u8 scan_tx_antennas = hw_params(priv).valid_tx_ant;
 	int ret;
 
 	lockdep_assert_held(&priv->mutex);
@@ -965,7 +965,8 @@ int iwlagn_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif)
 	}
 
 	/* MIMO is not used here, but value is required */
-	rx_chain |= priv->hw_params.valid_rx_ant << RXON_RX_CHAIN_VALID_POS;
+	rx_chain |=
+		hw_params(priv).valid_rx_ant << RXON_RX_CHAIN_VALID_POS;
 	rx_chain |= rx_ant << RXON_RX_CHAIN_FORCE_MIMO_SEL_POS;
 	rx_chain |= rx_ant << RXON_RX_CHAIN_FORCE_SEL_POS;
 	rx_chain |= 0x1 << RXON_RX_CHAIN_DRIVER_FORCE_POS;
@@ -1101,7 +1102,7 @@ int iwlagn_wait_tx_queue_empty(struct iwl_priv *priv)
 	int ret = 0;
 
 	/* waiting for all the tx frames complete might take a while */
-	for (cnt = 0; cnt < priv->hw_params.max_txq_num; cnt++) {
+	for (cnt = 0; cnt < hw_params(priv).max_txq_num; cnt++) {
 		if (cnt == priv->cmd_queue)
 			continue;
 		txq = &priv->txq[cnt];
@@ -1786,7 +1787,7 @@ void iwlagn_set_rxon_chain(struct iwl_priv *priv, struct iwl_rxon_context *ctx)
 	if (priv->chain_noise_data.active_chains)
 		active_chains = priv->chain_noise_data.active_chains;
 	else
-		active_chains = priv->hw_params.valid_rx_ant;
+		active_chains = hw_params(priv).valid_rx_ant;
 
 	if (priv->cfg->bt_params &&
 	    priv->cfg->bt_params->advanced_bt_coexist &&
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
index 3789ff4..84e43ed 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
@@ -820,7 +820,7 @@ static u32 rs_get_lower_rate(struct iwl_lq_sta *lq_sta,
 
 		if (num_of_ant(tbl->ant_type) > 1)
 			tbl->ant_type =
-				first_antenna(priv->hw_params.valid_tx_ant);
+			    first_antenna(hw_params(priv).valid_tx_ant);
 
 		tbl->is_ht40 = 0;
 		tbl->is_SGI = 0;
@@ -1294,7 +1294,7 @@ static int rs_switch_to_mimo2(struct iwl_priv *priv,
 		return -1;
 
 	/* Need both Tx chains/antennas to support MIMO */
-	if (priv->hw_params.tx_chains_num < 2)
+	if (hw_params(priv).tx_chains_num < 2)
 		return -1;
 
 	IWL_DEBUG_RATE(priv, "LQ: try to switch to MIMO2\n");
@@ -1350,7 +1350,7 @@ static int rs_switch_to_mimo3(struct iwl_priv *priv,
 		return -1;
 
 	/* Need both Tx chains/antennas to support MIMO */
-	if (priv->hw_params.tx_chains_num < 3)
+	if (hw_params(priv).tx_chains_num < 3)
 		return -1;
 
 	IWL_DEBUG_RATE(priv, "LQ: try to switch to MIMO3\n");
@@ -1449,8 +1449,8 @@ static int rs_move_legacy_other(struct iwl_priv *priv,
 	u32 sz = (sizeof(struct iwl_scale_tbl_info) -
 		  (sizeof(struct iwl_rate_scale_data) * IWL_RATE_COUNT));
 	u8 start_action;
-	u8 valid_tx_ant = priv->hw_params.valid_tx_ant;
-	u8 tx_chains_num = priv->hw_params.tx_chains_num;
+	u8 valid_tx_ant = hw_params(priv).valid_tx_ant;
+	u8 tx_chains_num = hw_params(priv).tx_chains_num;
 	int ret = 0;
 	u8 update_search_tbl_counter = 0;
 
@@ -1460,14 +1460,16 @@ static int rs_move_legacy_other(struct iwl_priv *priv,
 		break;
 	case IWL_BT_COEX_TRAFFIC_LOAD_LOW:
 		/* avoid antenna B unless MIMO */
-		valid_tx_ant = first_antenna(priv->hw_params.valid_tx_ant);
+		valid_tx_ant =
+			first_antenna(hw_params(priv).valid_tx_ant);
 		if (tbl->action == IWL_LEGACY_SWITCH_ANTENNA2)
 			tbl->action = IWL_LEGACY_SWITCH_ANTENNA1;
 		break;
 	case IWL_BT_COEX_TRAFFIC_LOAD_HIGH:
 	case IWL_BT_COEX_TRAFFIC_LOAD_CONTINUOUS:
 		/* avoid antenna B and MIMO */
-		valid_tx_ant = first_antenna(priv->hw_params.valid_tx_ant);
+		valid_tx_ant =
+			first_antenna(hw_params(priv).valid_tx_ant);
 		if (tbl->action >= IWL_LEGACY_SWITCH_ANTENNA2 &&
 		    tbl->action != IWL_LEGACY_SWITCH_SISO)
 			tbl->action = IWL_LEGACY_SWITCH_SISO;
@@ -1490,7 +1492,8 @@ static int rs_move_legacy_other(struct iwl_priv *priv,
 			tbl->action = IWL_LEGACY_SWITCH_ANTENNA1;
 		else if (tbl->action >= IWL_LEGACY_SWITCH_ANTENNA2)
 			tbl->action = IWL_LEGACY_SWITCH_SISO;
-		valid_tx_ant = first_antenna(priv->hw_params.valid_tx_ant);
+		valid_tx_ant =
+			first_antenna(hw_params(priv).valid_tx_ant);
 	}
 
 	start_action = tbl->action;
@@ -1624,8 +1627,8 @@ static int rs_move_siso_to_other(struct iwl_priv *priv,
 	u32 sz = (sizeof(struct iwl_scale_tbl_info) -
 		  (sizeof(struct iwl_rate_scale_data) * IWL_RATE_COUNT));
 	u8 start_action;
-	u8 valid_tx_ant = priv->hw_params.valid_tx_ant;
-	u8 tx_chains_num = priv->hw_params.tx_chains_num;
+	u8 valid_tx_ant = hw_params(priv).valid_tx_ant;
+	u8 tx_chains_num = hw_params(priv).tx_chains_num;
 	u8 update_search_tbl_counter = 0;
 	int ret;
 
@@ -1635,14 +1638,16 @@ static int rs_move_siso_to_other(struct iwl_priv *priv,
 		break;
 	case IWL_BT_COEX_TRAFFIC_LOAD_LOW:
 		/* avoid antenna B unless MIMO */
-		valid_tx_ant = first_antenna(priv->hw_params.valid_tx_ant);
+		valid_tx_ant =
+			first_antenna(hw_params(priv).valid_tx_ant);
 		if (tbl->action == IWL_SISO_SWITCH_ANTENNA2)
 			tbl->action = IWL_SISO_SWITCH_ANTENNA1;
 		break;
 	case IWL_BT_COEX_TRAFFIC_LOAD_HIGH:
 	case IWL_BT_COEX_TRAFFIC_LOAD_CONTINUOUS:
 		/* avoid antenna B and MIMO */
-		valid_tx_ant = first_antenna(priv->hw_params.valid_tx_ant);
+		valid_tx_ant =
+			first_antenna(hw_params(priv).valid_tx_ant);
 		if (tbl->action != IWL_SISO_SWITCH_ANTENNA1)
 			tbl->action = IWL_SISO_SWITCH_ANTENNA1;
 		break;
@@ -1659,7 +1664,8 @@ static int rs_move_siso_to_other(struct iwl_priv *priv,
 
 	/* configure as 1x1 if bt full concurrency */
 	if (priv->bt_full_concurrent) {
-		valid_tx_ant = first_antenna(priv->hw_params.valid_tx_ant);
+		valid_tx_ant =
+			first_antenna(hw_params(priv).valid_tx_ant);
 		if (tbl->action >= IWL_LEGACY_SWITCH_ANTENNA2)
 			tbl->action = IWL_SISO_SWITCH_ANTENNA1;
 	}
@@ -1795,8 +1801,8 @@ static int rs_move_mimo2_to_other(struct iwl_priv *priv,
 	u32 sz = (sizeof(struct iwl_scale_tbl_info) -
 		  (sizeof(struct iwl_rate_scale_data) * IWL_RATE_COUNT));
 	u8 start_action;
-	u8 valid_tx_ant = priv->hw_params.valid_tx_ant;
-	u8 tx_chains_num = priv->hw_params.tx_chains_num;
+	u8 valid_tx_ant = hw_params(priv).valid_tx_ant;
+	u8 tx_chains_num = hw_params(priv).tx_chains_num;
 	u8 update_search_tbl_counter = 0;
 	int ret;
 
@@ -1965,8 +1971,8 @@ static int rs_move_mimo3_to_other(struct iwl_priv *priv,
 	u32 sz = (sizeof(struct iwl_scale_tbl_info) -
 		  (sizeof(struct iwl_rate_scale_data) * IWL_RATE_COUNT));
 	u8 start_action;
-	u8 valid_tx_ant = priv->hw_params.valid_tx_ant;
-	u8 tx_chains_num = priv->hw_params.tx_chains_num;
+	u8 valid_tx_ant = hw_params(priv).valid_tx_ant;
+	u8 tx_chains_num = hw_params(priv).tx_chains_num;
 	int ret;
 	u8 update_search_tbl_counter = 0;
 
@@ -2704,7 +2710,7 @@ static void rs_initialize_lq(struct iwl_priv *priv,
 
 	i = lq_sta->last_txrate_idx;
 
-	valid_tx_ant = priv->hw_params.valid_tx_ant;
+	valid_tx_ant = hw_params(priv).valid_tx_ant;
 
 	if (!lq_sta->search_better_tbl)
 		active_tbl = lq_sta->active_tbl;
@@ -2887,15 +2893,15 @@ void iwl_rs_rate_init(struct iwl_priv *priv, struct ieee80211_sta *sta, u8 sta_i
 
 	/* These values will be overridden later */
 	lq_sta->lq.general_params.single_stream_ant_msk =
-		first_antenna(priv->hw_params.valid_tx_ant);
+		first_antenna(hw_params(priv).valid_tx_ant);
 	lq_sta->lq.general_params.dual_stream_ant_msk =
-		priv->hw_params.valid_tx_ant &
-		~first_antenna(priv->hw_params.valid_tx_ant);
+		hw_params(priv).valid_tx_ant &
+		~first_antenna(hw_params(priv).valid_tx_ant);
 	if (!lq_sta->lq.general_params.dual_stream_ant_msk) {
 		lq_sta->lq.general_params.dual_stream_ant_msk = ANT_AB;
-	} else if (num_of_ant(priv->hw_params.valid_tx_ant) == 2) {
+	} else if (num_of_ant(hw_params(priv).valid_tx_ant) == 2) {
 		lq_sta->lq.general_params.dual_stream_ant_msk =
-			priv->hw_params.valid_tx_ant;
+			hw_params(priv).valid_tx_ant;
 	}
 
 	/* as default allow aggregation for all tids */
@@ -2941,7 +2947,7 @@ static void rs_fill_link_cmd(struct iwl_priv *priv,
 	if (priv && priv->bt_full_concurrent) {
 		/* 1x1 only */
 		tbl_type.ant_type =
-			first_antenna(priv->hw_params.valid_tx_ant);
+			first_antenna(hw_params(priv).valid_tx_ant);
 	}
 
 	/* How many times should we repeat the initial rate? */
@@ -2973,7 +2979,7 @@ static void rs_fill_link_cmd(struct iwl_priv *priv,
 		if (priv->bt_full_concurrent)
 			valid_tx_ant = ANT_A;
 		else
-			valid_tx_ant = priv->hw_params.valid_tx_ant;
+			valid_tx_ant = hw_params(priv).valid_tx_ant;
 	}
 
 	/* Fill rest of rate table */
@@ -3007,7 +3013,7 @@ static void rs_fill_link_cmd(struct iwl_priv *priv,
 		if (priv && priv->bt_full_concurrent) {
 			/* 1x1 only */
 			tbl_type.ant_type =
-				first_antenna(priv->hw_params.valid_tx_ant);
+			    first_antenna(hw_params(priv).valid_tx_ant);
 		}
 
 		/* Indicate to uCode which entries might be MIMO.
@@ -3098,7 +3104,7 @@ static void rs_dbgfs_set_mcs(struct iwl_lq_sta *lq_sta,
 	u8 ant_sel_tx;
 
 	priv = lq_sta->drv;
-	valid_tx_ant = priv->hw_params.valid_tx_ant;
+	valid_tx_ant = hw_params(priv).valid_tx_ant;
 	if (lq_sta->dbg_fixed_rate) {
 		ant_sel_tx =
 		  ((lq_sta->dbg_fixed_rate & RATE_MCS_ANT_ABC_MSK)
@@ -3169,9 +3175,9 @@ static ssize_t rs_sta_dbgfs_scale_table_read(struct file *file,
 	desc += sprintf(buff+desc, "fixed rate 0x%X\n",
 			lq_sta->dbg_fixed_rate);
 	desc += sprintf(buff+desc, "valid_tx_ant %s%s%s\n",
-	    (priv->hw_params.valid_tx_ant & ANT_A) ? "ANT_A," : "",
-	    (priv->hw_params.valid_tx_ant & ANT_B) ? "ANT_B," : "",
-	    (priv->hw_params.valid_tx_ant & ANT_C) ? "ANT_C" : "");
+	    (hw_params(priv).valid_tx_ant & ANT_A) ? "ANT_A," : "",
+	    (hw_params(priv).valid_tx_ant & ANT_B) ? "ANT_B," : "",
+	    (hw_params(priv).valid_tx_ant & ANT_C) ? "ANT_C" : "");
 	desc += sprintf(buff+desc, "lq type %s\n",
 	   (is_legacy(tbl->lq_type)) ? "legacy" : "HT");
 	if (is_Ht(tbl->lq_type)) {
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-sta.c b/drivers/net/wireless/iwlwifi/iwl-agn-sta.c
index 37e6240..f894bfb 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-sta.c
@@ -63,23 +63,23 @@ iwl_sta_alloc_lq(struct iwl_priv *priv, struct iwl_rxon_context *ctx, u8 sta_id)
 	if (r >= IWL_FIRST_CCK_RATE && r <= IWL_LAST_CCK_RATE)
 		rate_flags |= RATE_MCS_CCK_MSK;
 
-	rate_flags |= first_antenna(priv->hw_params.valid_tx_ant) <<
+	rate_flags |= first_antenna(hw_params(priv).valid_tx_ant) <<
 				RATE_MCS_ANT_POS;
 	rate_n_flags = iwl_hw_set_rate_n_flags(iwl_rates[r].plcp, rate_flags);
 	for (i = 0; i < LINK_QUAL_MAX_RETRY_NUM; i++)
 		link_cmd->rs_table[i].rate_n_flags = rate_n_flags;
 
 	link_cmd->general_params.single_stream_ant_msk =
-				first_antenna(priv->hw_params.valid_tx_ant);
+			first_antenna(hw_params(priv).valid_tx_ant);
 
 	link_cmd->general_params.dual_stream_ant_msk =
-		priv->hw_params.valid_tx_ant &
-		~first_antenna(priv->hw_params.valid_tx_ant);
+		hw_params(priv).valid_tx_ant &
+		~first_antenna(hw_params(priv).valid_tx_ant);
 	if (!link_cmd->general_params.dual_stream_ant_msk) {
 		link_cmd->general_params.dual_stream_ant_msk = ANT_AB;
-	} else if (num_of_ant(priv->hw_params.valid_tx_ant) == 2) {
+	} else if (num_of_ant(hw_params(priv).valid_tx_ant) == 2) {
 		link_cmd->general_params.dual_stream_ant_msk =
-			priv->hw_params.valid_tx_ant;
+			hw_params(priv).valid_tx_ant;
 	}
 
 	link_cmd->agg_params.agg_dis_start_th = LINK_QUAL_AGG_DISABLE_START_DEF;
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
index 9bc26da..3e2a904 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
@@ -260,10 +260,10 @@ static void iwlagn_tx_cmd_build_rate(struct iwl_priv *priv,
 	     priv->bt_full_concurrent) {
 		/* operated as 1x1 in full concurrency mode */
 		priv->mgmt_tx_ant = iwl_toggle_tx_ant(priv, priv->mgmt_tx_ant,
-				first_antenna(priv->hw_params.valid_tx_ant));
+				first_antenna(hw_params(priv).valid_tx_ant));
 	} else
 		priv->mgmt_tx_ant = iwl_toggle_tx_ant(priv, priv->mgmt_tx_ant,
-					      priv->hw_params.valid_tx_ant);
+						hw_params(priv).valid_tx_ant);
 	rate_flags |= iwl_ant_idx_to_flags(priv->mgmt_tx_ant);
 
 	/* Set the rate in the TX cmd */
@@ -492,7 +492,7 @@ static int iwlagn_txq_ctx_activate_free(struct iwl_priv *priv)
 {
 	int txq_id;
 
-	for (txq_id = 0; txq_id < priv->hw_params.max_txq_num; txq_id++)
+	for (txq_id = 0; txq_id < hw_params(priv).max_txq_num; txq_id++)
 		if (!test_and_set_bit(txq_id, &priv->txq_ctx_active_msk))
 			return txq_id;
 	return -1;
@@ -864,7 +864,7 @@ void iwlagn_rx_reply_compressed_ba(struct iwl_priv *priv,
 	 * (in Tx queue's circular buffer) of first TFD/frame in window */
 	u16 ba_resp_scd_ssn = le16_to_cpu(ba_resp->scd_ssn);
 
-	if (scd_flow >= priv->hw_params.max_txq_num) {
+	if (scd_flow >= hw_params(priv).max_txq_num) {
 		IWL_ERR(priv,
 			"BUG_ON scd_flow is bigger than number of queues\n");
 		return;
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 5509c8d..ba658b3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -181,7 +181,7 @@ int iwlagn_send_beacon_cmd(struct iwl_priv *priv)
 		rate = info->control.rates[0].idx;
 
 	priv->mgmt_tx_ant = iwl_toggle_tx_ant(priv, priv->mgmt_tx_ant,
-					      priv->hw_params.valid_tx_ant);
+					      hw_params(priv).valid_tx_ant);
 	rate_flags = iwl_ant_idx_to_flags(priv->mgmt_tx_ant);
 
 	/* In mac80211, rates for 5 GHz start at 0 */
@@ -1150,25 +1150,25 @@ static void iwl_ucode_callback(const struct firmware *ucode_raw, void *context)
 		       pieces.init_data_size);
 
 	/* Verify that uCode images will fit in card's SRAM */
-	if (pieces.inst_size > priv->hw_params.max_inst_size) {
+	if (pieces.inst_size > hw_params(priv).max_inst_size) {
 		IWL_ERR(priv, "uCode instr len %Zd too large to fit in\n",
 			pieces.inst_size);
 		goto try_again;
 	}
 
-	if (pieces.data_size > priv->hw_params.max_data_size) {
+	if (pieces.data_size > hw_params(priv).max_data_size) {
 		IWL_ERR(priv, "uCode data len %Zd too large to fit in\n",
 			pieces.data_size);
 		goto try_again;
 	}
 
-	if (pieces.init_size > priv->hw_params.max_inst_size) {
+	if (pieces.init_size > hw_params(priv).max_inst_size) {
 		IWL_ERR(priv, "uCode init instr len %Zd too large to fit in\n",
 			pieces.init_size);
 		goto try_again;
 	}
 
-	if (pieces.init_data_size > priv->hw_params.max_data_size) {
+	if (pieces.init_data_size > hw_params(priv).max_data_size) {
 		IWL_ERR(priv, "uCode init data len %Zd too large to fit in\n",
 			pieces.init_data_size);
 		goto try_again;
@@ -1682,9 +1682,9 @@ static void iwl_rf_kill_ct_config(struct iwl_priv *priv)
 
 	if (priv->cfg->base_params->support_ct_kill_exit) {
 		adv_cmd.critical_temperature_enter =
-			cpu_to_le32(priv->hw_params.ct_kill_threshold);
+			cpu_to_le32(hw_params(priv).ct_kill_threshold);
 		adv_cmd.critical_temperature_exit =
-			cpu_to_le32(priv->hw_params.ct_kill_exit_threshold);
+			cpu_to_le32(hw_params(priv).ct_kill_exit_threshold);
 
 		ret = trans_send_cmd_pdu(&priv->trans,
 				       REPLY_CT_KILL_CONFIG_CMD,
@@ -1693,14 +1693,13 @@ static void iwl_rf_kill_ct_config(struct iwl_priv *priv)
 			IWL_ERR(priv, "REPLY_CT_KILL_CONFIG_CMD failed\n");
 		else
 			IWL_DEBUG_INFO(priv, "REPLY_CT_KILL_CONFIG_CMD "
-					"succeeded, "
-					"critical temperature enter is %d,"
-					"exit is %d\n",
-				       priv->hw_params.ct_kill_threshold,
-				       priv->hw_params.ct_kill_exit_threshold);
+				"succeeded, critical temperature enter is %d,"
+				"exit is %d\n",
+				hw_params(priv).ct_kill_threshold,
+				hw_params(priv).ct_kill_exit_threshold);
 	} else {
 		cmd.critical_temperature_R =
-			cpu_to_le32(priv->hw_params.ct_kill_threshold);
+			cpu_to_le32(hw_params(priv).ct_kill_threshold);
 
 		ret = trans_send_cmd_pdu(&priv->trans,
 				       REPLY_CT_KILL_CONFIG_CMD,
@@ -1709,9 +1708,9 @@ static void iwl_rf_kill_ct_config(struct iwl_priv *priv)
 			IWL_ERR(priv, "REPLY_CT_KILL_CONFIG_CMD failed\n");
 		else
 			IWL_DEBUG_INFO(priv, "REPLY_CT_KILL_CONFIG_CMD "
-					"succeeded, "
-					"critical temperature is %d\n",
-					priv->hw_params.ct_kill_threshold);
+				"succeeded, "
+				"critical temperature is %d\n",
+				hw_params(priv).ct_kill_threshold);
 	}
 }
 
@@ -1809,8 +1808,9 @@ int iwl_alive_start(struct iwl_priv *priv)
 		iwl_send_bt_config(priv);
 	}
 
-	if (priv->hw_params.calib_rt_cfg)
-		iwlagn_send_calib_cfg_rt(priv, priv->hw_params.calib_rt_cfg);
+	if (hw_params(priv).calib_rt_cfg)
+		iwlagn_send_calib_cfg_rt(priv,
+					 hw_params(priv).calib_rt_cfg);
 
 	ieee80211_wake_queues(priv->hw);
 
@@ -3611,14 +3611,16 @@ static u32 iwl_hw_detect(struct iwl_priv *priv)
 
 static int iwl_set_hw_params(struct iwl_priv *priv)
 {
-	priv->hw_params.max_rxq_size = RX_QUEUE_SIZE;
-	priv->hw_params.max_rxq_log = RX_QUEUE_SIZE_LOG;
+	hw_params(priv).max_rxq_size = RX_QUEUE_SIZE;
+	hw_params(priv).max_rxq_log = RX_QUEUE_SIZE_LOG;
 	if (iwlagn_mod_params.amsdu_size_8K)
-		priv->hw_params.rx_page_order = get_order(IWL_RX_BUF_SIZE_8K);
+		hw_params(priv).rx_page_order =
+			get_order(IWL_RX_BUF_SIZE_8K);
 	else
-		priv->hw_params.rx_page_order = get_order(IWL_RX_BUF_SIZE_4K);
+		hw_params(priv).rx_page_order =
+			get_order(IWL_RX_BUF_SIZE_4K);
 
-	priv->hw_params.max_beacon_itrvl = IWL_MAX_UCODE_BEACON_INTERVAL;
+	hw_params(priv).max_beacon_itrvl = IWL_MAX_UCODE_BEACON_INTERVAL;
 
 	if (iwlagn_mod_params.disable_11n)
 		priv->cfg->sku &= ~EEPROM_SKU_CAP_11N_ENABLE;
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 2b3d052..2aeafa1 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -55,8 +55,8 @@ static void iwl_init_ht_hw_capab(const struct iwl_priv *priv,
 			      enum ieee80211_band band)
 {
 	u16 max_bit_rate = 0;
-	u8 rx_chains_num = priv->hw_params.rx_chains_num;
-	u8 tx_chains_num = priv->hw_params.tx_chains_num;
+	u8 rx_chains_num = hw_params(priv).rx_chains_num;
+	u8 tx_chains_num = hw_params(priv).tx_chains_num;
 
 	ht_info->cap = 0;
 	memset(&ht_info->mcs, 0, sizeof(ht_info->mcs));
@@ -68,7 +68,7 @@ static void iwl_init_ht_hw_capab(const struct iwl_priv *priv,
 		ht_info->cap |= IEEE80211_HT_CAP_GRN_FLD;
 	ht_info->cap |= IEEE80211_HT_CAP_SGI_20;
 	max_bit_rate = MAX_BIT_RATE_20_MHZ;
-	if (priv->hw_params.ht40_channel & BIT(band)) {
+	if (hw_params(priv).ht40_channel & BIT(band)) {
 		ht_info->cap |= IEEE80211_HT_CAP_SUP_WIDTH_20_40;
 		ht_info->cap |= IEEE80211_HT_CAP_SGI_40;
 		ht_info->mcs.rx_mask[4] = 0x01;
@@ -359,7 +359,7 @@ int iwl_send_rxon_timing(struct iwl_priv *priv, struct iwl_rxon_context *ctx)
 		beacon_int = le16_to_cpu(ctx->timing.beacon_interval);
 	} else {
 		beacon_int = iwl_adjust_beacon_interval(beacon_int,
-				priv->hw_params.max_beacon_itrvl * TIME_UNIT);
+			hw_params(priv).max_beacon_itrvl * TIME_UNIT);
 		ctx->timing.beacon_interval = cpu_to_le16(beacon_int);
 	}
 
@@ -1823,7 +1823,7 @@ void iwl_bg_watchdog(unsigned long data)
 
 	/* monitor and check for other stuck queues */
 	if (iwl_is_any_associated(priv)) {
-		for (cnt = 0; cnt < priv->hw_params.max_txq_num; cnt++) {
+		for (cnt = 0; cnt < hw_params(priv).max_txq_num; cnt++) {
 			/* skip as we already checked the command queue */
 			if (cnt == priv->cmd_queue)
 				continue;
@@ -1864,12 +1864,12 @@ u32 iwl_usecs_to_beacons(struct iwl_priv *priv, u32 usec, u32 beacon_interval)
 
 	quot = (usec / interval) &
 		(iwl_beacon_time_mask_high(priv,
-		priv->hw_params.beacon_time_tsf_bits) >>
-		priv->hw_params.beacon_time_tsf_bits);
+		hw_params(priv).beacon_time_tsf_bits) >>
+		hw_params(priv).beacon_time_tsf_bits);
 	rem = (usec % interval) & iwl_beacon_time_mask_low(priv,
-				   priv->hw_params.beacon_time_tsf_bits);
+				   hw_params(priv).beacon_time_tsf_bits);
 
-	return (quot << priv->hw_params.beacon_time_tsf_bits) + rem;
+	return (quot << hw_params(priv).beacon_time_tsf_bits) + rem;
 }
 
 /* base is usually what we get from ucode with each received frame,
@@ -1879,22 +1879,22 @@ __le32 iwl_add_beacon_time(struct iwl_priv *priv, u32 base,
 			   u32 addon, u32 beacon_interval)
 {
 	u32 base_low = base & iwl_beacon_time_mask_low(priv,
-					priv->hw_params.beacon_time_tsf_bits);
+				hw_params(priv).beacon_time_tsf_bits);
 	u32 addon_low = addon & iwl_beacon_time_mask_low(priv,
-					priv->hw_params.beacon_time_tsf_bits);
+				hw_params(priv).beacon_time_tsf_bits);
 	u32 interval = beacon_interval * TIME_UNIT;
 	u32 res = (base & iwl_beacon_time_mask_high(priv,
-				priv->hw_params.beacon_time_tsf_bits)) +
+				hw_params(priv).beacon_time_tsf_bits)) +
 				(addon & iwl_beacon_time_mask_high(priv,
-				priv->hw_params.beacon_time_tsf_bits));
+				hw_params(priv).beacon_time_tsf_bits));
 
 	if (base_low > addon_low)
 		res += base_low - addon_low;
 	else if (base_low < addon_low) {
 		res += interval + base_low - addon_low;
-		res += (1 << priv->hw_params.beacon_time_tsf_bits);
+		res += (1 << hw_params(priv).beacon_time_tsf_bits);
 	} else
-		res += (1 << priv->hw_params.beacon_time_tsf_bits);
+		res += (1 << hw_params(priv).beacon_time_tsf_bits);
 
 	return cpu_to_le32(res);
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
index c798c68..43543e5 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
@@ -340,7 +340,7 @@ static ssize_t iwl_dbgfs_stations_read(struct file *file, char __user *user_buf,
 {
 	struct iwl_priv *priv = file->private_data;
 	struct iwl_station_entry *station;
-	int max_sta = priv->hw_params.max_stations;
+	int max_sta = hw_params(priv).max_stations;
 	char *buf;
 	int i, j, pos = 0;
 	ssize_t ret;
@@ -908,7 +908,7 @@ static ssize_t iwl_dbgfs_traffic_log_read(struct file *file,
 		return -ENOMEM;
 	}
 	pos += scnprintf(buf + pos, bufsz - pos, "Tx Queue\n");
-	for (cnt = 0; cnt < priv->hw_params.max_txq_num; cnt++) {
+	for (cnt = 0; cnt < hw_params(priv).max_txq_num; cnt++) {
 		txq = &priv->txq[cnt];
 		q = &txq->q;
 		pos += scnprintf(buf + pos, bufsz - pos,
@@ -1006,7 +1006,7 @@ static ssize_t iwl_dbgfs_tx_queue_read(struct file *file,
 	if (!buf)
 		return -ENOMEM;
 
-	for (cnt = 0; cnt < priv->hw_params.max_txq_num; cnt++) {
+	for (cnt = 0; cnt < hw_params(priv).max_txq_num; cnt++) {
 		txq = &priv->txq[cnt];
 		q = &txq->q;
 		pos += scnprintf(buf + pos, bufsz - pos,
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index e0ea3d5..4dfe84b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -647,54 +647,6 @@ struct iwl_sensitivity_ranges {
 #define CELSIUS_TO_KELVIN(x) ((x)+273)
 
 
-/**
- * struct iwl_hw_params
- * @max_txq_num: Max # Tx queues supported
- * @scd_bc_tbls_size: size of scheduler byte count tables
- * @tfd_size: TFD size
- * @tx/rx_chains_num: Number of TX/RX chains
- * @valid_tx/rx_ant: usable antennas
- * @max_rxq_size: Max # Rx frames in Rx queue (must be power-of-2)
- * @max_rxq_log: Log-base-2 of max_rxq_size
- * @rx_page_order: Rx buffer page order
- * @rx_wrt_ptr_reg: FH{39}_RSCSR_CHNL0_WPTR
- * @max_stations:
- * @ht40_channel: is 40MHz width possible in band 2.4
- * BIT(IEEE80211_BAND_5GHZ) BIT(IEEE80211_BAND_5GHZ)
- * @sw_crypto: 0 for hw, 1 for sw
- * @max_xxx_size: for ucode uses
- * @ct_kill_threshold: temperature threshold
- * @beacon_time_tsf_bits: number of valid tsf bits for beacon time
- * @calib_init_cfg: setup initial calibrations for the hw
- * @calib_rt_cfg: setup runtime calibrations for the hw
- * @struct iwl_sensitivity_ranges: range of sensitivity values
- */
-struct iwl_hw_params {
-	u8 max_txq_num;
-	u16 scd_bc_tbls_size;
-	u32 tfd_size;
-	u8  tx_chains_num;
-	u8  rx_chains_num;
-	u8  valid_tx_ant;
-	u8  valid_rx_ant;
-	u16 max_rxq_size;
-	u16 max_rxq_log;
-	u32 rx_page_order;
-	u8  max_stations;
-	u8  ht40_channel;
-	u8  max_beacon_itrvl;	/* in 1024 ms */
-	u32 max_inst_size;
-	u32 max_data_size;
-	u32 ct_kill_threshold; /* value in hw-dependent units */
-	u32 ct_kill_exit_threshold; /* value in hw-dependent units */
-				    /* for 1000, 6000 series and up */
-	u16 beacon_time_tsf_bits;
-	u32 calib_init_cfg;
-	u32 calib_rt_cfg;
-	const struct iwl_sensitivity_ranges *sens;
-};
-
-
 /******************************************************************************
  *
  * Functions implemented in core module which are forward declared here
@@ -1482,8 +1434,6 @@ struct iwl_priv {
 	struct iwl_rxon_context *cur_rssi_ctx;
 	bool bt_is_sco;
 
-	struct iwl_hw_params hw_params;
-
 	u32 inta_mask;
 
 	struct workqueue_struct *workqueue;
@@ -1641,11 +1591,11 @@ static inline int is_channel_ibss(const struct iwl_channel_info *ch)
 
 static inline void __iwl_free_pages(struct iwl_priv *priv, struct page *page)
 {
-	__free_pages(page, priv->hw_params.rx_page_order);
+	__free_pages(page, hw_params(priv).rx_page_order);
 }
 
 static inline void iwl_free_pages(struct iwl_priv *priv, unsigned long page)
 {
-	free_pages(page, priv->hw_params.rx_page_order);
+	free_pages(page, hw_params(priv).rx_page_order);
 }
 #endif				/* __iwl_dev_h__ */
diff --git a/drivers/net/wireless/iwlwifi/iwl-prph.h b/drivers/net/wireless/iwlwifi/iwl-prph.h
index 2f267b8..40f6dd4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-prph.h
+++ b/drivers/net/wireless/iwlwifi/iwl-prph.h
@@ -217,7 +217,7 @@
 	((SCD_TRANS_TBL_MEM_LOWER_BOUND + ((x) * 2)) & 0xfffc)
 
 #define SCD_QUEUECHAIN_SEL_ALL(priv)	\
-	(((1<<(priv)->hw_params.max_txq_num) - 1) &\
+	(((1<<hw_params(priv).max_txq_num) - 1) &\
 	(~(1<<(priv)->cmd_queue)))
 
 #define SCD_BASE			(PRPH_BASE + 0xa02c00)
diff --git a/drivers/net/wireless/iwlwifi/iwl-scan.c b/drivers/net/wireless/iwlwifi/iwl-scan.c
index 28e5931..bddb2da 100644
--- a/drivers/net/wireless/iwlwifi/iwl-scan.c
+++ b/drivers/net/wireless/iwlwifi/iwl-scan.c
@@ -343,7 +343,7 @@ u16 iwl_get_passive_dwell_time(struct iwl_priv *priv,
 
 void iwl_init_scan_params(struct iwl_priv *priv)
 {
-	u8 ant_idx = fls(priv->hw_params.valid_tx_ant) - 1;
+	u8 ant_idx = fls(hw_params(priv).valid_tx_ant) - 1;
 	if (!priv->scan_tx_ant[IEEE80211_BAND_5GHZ])
 		priv->scan_tx_ant[IEEE80211_BAND_5GHZ] = ant_idx;
 	if (!priv->scan_tx_ant[IEEE80211_BAND_2GHZ])
diff --git a/drivers/net/wireless/iwlwifi/iwl-shared.h b/drivers/net/wireless/iwlwifi/iwl-shared.h
index a7c0315..483785c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-shared.h
+++ b/drivers/net/wireless/iwlwifi/iwl-shared.h
@@ -66,6 +66,7 @@
 struct iwl_cfg;
 struct iwl_bus;
 struct iwl_priv;
+struct iwl_sensitivity_ranges;
 
 extern struct iwl_mod_params iwlagn_mod_params;
 
@@ -91,12 +92,60 @@ struct iwl_mod_params {
 };
 
 /**
+ * struct iwl_hw_params
+ * @max_txq_num: Max # Tx queues supported
+ * @scd_bc_tbls_size: size of scheduler byte count tables
+ * @tfd_size: TFD size
+ * @tx/rx_chains_num: Number of TX/RX chains
+ * @valid_tx/rx_ant: usable antennas
+ * @max_rxq_size: Max # Rx frames in Rx queue (must be power-of-2)
+ * @max_rxq_log: Log-base-2 of max_rxq_size
+ * @rx_page_order: Rx buffer page order
+ * @rx_wrt_ptr_reg: FH{39}_RSCSR_CHNL0_WPTR
+ * @max_stations:
+ * @ht40_channel: is 40MHz width possible in band 2.4
+ * BIT(IEEE80211_BAND_5GHZ) BIT(IEEE80211_BAND_5GHZ)
+ * @sw_crypto: 0 for hw, 1 for sw
+ * @max_xxx_size: for ucode uses
+ * @ct_kill_threshold: temperature threshold
+ * @beacon_time_tsf_bits: number of valid tsf bits for beacon time
+ * @calib_init_cfg: setup initial calibrations for the hw
+ * @calib_rt_cfg: setup runtime calibrations for the hw
+ * @struct iwl_sensitivity_ranges: range of sensitivity values
+ */
+struct iwl_hw_params {
+	u8 max_txq_num;
+	u16 scd_bc_tbls_size;
+	u32 tfd_size;
+	u8  tx_chains_num;
+	u8  rx_chains_num;
+	u8  valid_tx_ant;
+	u8  valid_rx_ant;
+	u16 max_rxq_size;
+	u16 max_rxq_log;
+	u32 rx_page_order;
+	u8  max_stations;
+	u8  ht40_channel;
+	u8  max_beacon_itrvl;	/* in 1024 ms */
+	u32 max_inst_size;
+	u32 max_data_size;
+	u32 ct_kill_threshold; /* value in hw-dependent units */
+	u32 ct_kill_exit_threshold; /* value in hw-dependent units */
+				    /* for 1000, 6000 series and up */
+	u16 beacon_time_tsf_bits;
+	u32 calib_init_cfg;
+	u32 calib_rt_cfg;
+	const struct iwl_sensitivity_ranges *sens;
+};
+
+/**
  * struct iwl_shared - shared fields for all the layers of the driver
  *
  * @dbg_level_dev: dbg level set per device. Prevails on
  *	iwlagn_mod_params.debug_level if set (!= 0)
  * @bus: pointer to the bus layer data
  * @priv: pointer to the upper layer data
+ * @hw_params: see struct iwl_hw_params
  */
 struct iwl_shared {
 #ifdef CONFIG_IWLWIFI_DEBUG
@@ -105,11 +154,13 @@ struct iwl_shared {
 
 	struct iwl_bus *bus;
 	struct iwl_priv *priv;
+	struct iwl_hw_params hw_params;
 };
 
 /*Whatever _m is (iwl_trans, iwl_priv, iwl_bus, these macros will work */
 #define priv(_m)	((_m)->shrd->priv)
 #define bus(_m)		((_m)->shrd->bus)
+#define hw_params(_m)	((_m)->shrd->hw_params)
 
 #ifdef CONFIG_IWLWIFI_DEBUG
 /*
diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.c b/drivers/net/wireless/iwlwifi/iwl-sta.c
index 1ef3b71..b5b0ff3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.c
@@ -251,7 +251,8 @@ u8 iwl_prep_station(struct iwl_priv *priv, struct iwl_rxon_context *ctx,
 	else if (is_broadcast_ether_addr(addr))
 		sta_id = ctx->bcast_sta_id;
 	else
-		for (i = IWL_STA_ID; i < priv->hw_params.max_stations; i++) {
+		for (i = IWL_STA_ID;
+		     i < hw_params(priv).max_stations; i++) {
 			if (!compare_ether_addr(priv->stations[i].sta.sta.addr,
 						addr)) {
 				sta_id = i;
@@ -535,7 +536,7 @@ void iwl_clear_ucode_stations(struct iwl_priv *priv,
 	IWL_DEBUG_INFO(priv, "Clearing ucode stations in driver\n");
 
 	spin_lock_irqsave(&priv->sta_lock, flags_spin);
-	for (i = 0; i < priv->hw_params.max_stations; i++) {
+	for (i = 0; i < hw_params(priv).max_stations; i++) {
 		if (ctx && ctx->ctxid != priv->stations[i].ctxid)
 			continue;
 
@@ -576,7 +577,7 @@ void iwl_restore_stations(struct iwl_priv *priv, struct iwl_rxon_context *ctx)
 
 	IWL_DEBUG_ASSOC(priv, "Restoring all known stations ... start.\n");
 	spin_lock_irqsave(&priv->sta_lock, flags_spin);
-	for (i = 0; i < priv->hw_params.max_stations; i++) {
+	for (i = 0; i < hw_params(priv).max_stations; i++) {
 		if (ctx->ctxid != priv->stations[i].ctxid)
 			continue;
 		if ((priv->stations[i].used & IWL_STA_DRIVER_ACTIVE) &&
@@ -589,7 +590,7 @@ void iwl_restore_stations(struct iwl_priv *priv, struct iwl_rxon_context *ctx)
 		}
 	}
 
-	for (i = 0; i < priv->hw_params.max_stations; i++) {
+	for (i = 0; i < hw_params(priv).max_stations; i++) {
 		if ((priv->stations[i].used & IWL_STA_UCODE_INPROGRESS)) {
 			memcpy(&sta_cmd, &priv->stations[i].sta,
 			       sizeof(struct iwl_addsta_cmd));
@@ -686,7 +687,7 @@ void iwl_dealloc_bcast_stations(struct iwl_priv *priv)
 	int i;
 
 	spin_lock_irqsave(&priv->sta_lock, flags);
-	for (i = 0; i < priv->hw_params.max_stations; i++) {
+	for (i = 0; i < hw_params(priv).max_stations; i++) {
 		if (!(priv->stations[i].used & IWL_STA_BCAST))
 			continue;
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-rx-pcie.c b/drivers/net/wireless/iwlwifi/iwl-trans-rx-pcie.c
index 846db8f..52edd6a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-rx-pcie.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-rx-pcie.c
@@ -265,16 +265,17 @@ static void iwlagn_rx_allocate(struct iwl_priv *priv, gfp_t priority)
 		if (rxq->free_count > RX_LOW_WATERMARK)
 			gfp_mask |= __GFP_NOWARN;
 
-		if (priv->hw_params.rx_page_order > 0)
+		if (hw_params(priv).rx_page_order > 0)
 			gfp_mask |= __GFP_COMP;
 
 		/* Alloc a new receive buffer */
-		page = alloc_pages(gfp_mask, priv->hw_params.rx_page_order);
+		page = alloc_pages(gfp_mask,
+				  hw_params(priv).rx_page_order);
 		if (!page) {
 			if (net_ratelimit())
 				IWL_DEBUG_INFO(priv, "alloc_pages failed, "
-					       "order: %d\n",
-					       priv->hw_params.rx_page_order);
+					   "order: %d\n",
+					   hw_params(priv).rx_page_order);
 
 			if ((rxq->free_count <= RX_LOW_WATERMARK) &&
 			    net_ratelimit())
@@ -293,7 +294,7 @@ static void iwlagn_rx_allocate(struct iwl_priv *priv, gfp_t priority)
 
 		if (list_empty(&rxq->rx_used)) {
 			spin_unlock_irqrestore(&rxq->lock, flags);
-			__free_pages(page, priv->hw_params.rx_page_order);
+			__free_pages(page, hw_params(priv).rx_page_order);
 			return;
 		}
 		element = rxq->rx_used.next;
@@ -306,7 +307,7 @@ static void iwlagn_rx_allocate(struct iwl_priv *priv, gfp_t priority)
 		rxb->page = page;
 		/* Get physical address of the RB */
 		rxb->page_dma = dma_map_page(priv->bus->dev, page, 0,
-				PAGE_SIZE << priv->hw_params.rx_page_order,
+				PAGE_SIZE << hw_params(priv).rx_page_order,
 				DMA_FROM_DEVICE);
 		/* dma address must be no more than 36 bits */
 		BUG_ON(rxb->page_dma & ~DMA_BIT_MASK(36));
@@ -405,7 +406,7 @@ static void iwl_rx_handle(struct iwl_priv *priv)
 		rxq->queue[i] = NULL;
 
 		dma_unmap_page(priv->bus->dev, rxb->page_dma,
-			       PAGE_SIZE << priv->hw_params.rx_page_order,
+			       PAGE_SIZE << hw_params(priv).rx_page_order,
 			       DMA_FROM_DEVICE);
 		pkt = rxb_addr(rxb);
 
@@ -456,7 +457,8 @@ static void iwl_rx_handle(struct iwl_priv *priv)
 		spin_lock_irqsave(&rxq->lock, flags);
 		if (rxb->page != NULL) {
 			rxb->page_dma = dma_map_page(priv->bus->dev, rxb->page,
-				0, PAGE_SIZE << priv->hw_params.rx_page_order,
+				0, PAGE_SIZE <<
+				    hw_params(priv).rx_page_order,
 				DMA_FROM_DEVICE);
 			list_add_tail(&rxb->list, &rxq->rx_free);
 			rxq->free_count++;
@@ -610,7 +612,7 @@ void iwl_irq_tasklet(struct iwl_priv *priv)
 	if (inta & CSR_INT_BIT_WAKEUP) {
 		IWL_DEBUG_ISR(priv, "Wakeup interrupt\n");
 		iwl_rx_queue_update_write_ptr(priv, &priv->rxq);
-		for (i = 0; i < priv->hw_params.max_txq_num; i++)
+		for (i = 0; i < hw_params(priv).max_txq_num; i++)
 			iwl_txq_update_write_ptr(priv, &priv->txq[i]);
 
 		priv->isr_stats.wakeup++;
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.c b/drivers/net/wireless/iwlwifi/iwl-trans.c
index e4a70fe..9212838 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.c
@@ -120,7 +120,7 @@ static void iwl_trans_rxq_free_rx_bufs(struct iwl_priv *priv)
 		 * to an SKB, so we need to unmap and free potential storage */
 		if (rxq->pool[i].page != NULL) {
 			dma_unmap_page(priv->bus->dev, rxq->pool[i].page_dma,
-				PAGE_SIZE << priv->hw_params.rx_page_order,
+				PAGE_SIZE << hw_params(priv).rx_page_order,
 				DMA_FROM_DEVICE);
 			__iwl_free_pages(priv, rxq->pool[i].page);
 			rxq->pool[i].page = NULL;
@@ -285,7 +285,7 @@ static inline void iwlagn_free_dma_ptr(struct iwl_priv *priv,
 static int iwl_trans_txq_alloc(struct iwl_priv *priv, struct iwl_tx_queue *txq,
 		      int slots_num, u32 txq_id)
 {
-	size_t tfd_sz = priv->hw_params.tfd_size * TFD_QUEUE_SIZE_MAX;
+	size_t tfd_sz = hw_params(priv).tfd_size * TFD_QUEUE_SIZE_MAX;
 	int i;
 
 	if (WARN_ON(txq->meta || txq->cmd || txq->txb || txq->tfds))
@@ -429,7 +429,7 @@ static void iwl_tx_queue_free(struct iwl_priv *priv, int txq_id)
 
 	/* De-alloc circular buffer of TFDs */
 	if (txq->q.n_bd) {
-		dma_free_coherent(dev, priv->hw_params.tfd_size *
+		dma_free_coherent(dev, hw_params(priv).tfd_size *
 				  txq->q.n_bd, txq->tfds, txq->q.dma_addr);
 		memset(&txq->q.dma_addr, 0, sizeof(txq->q.dma_addr));
 	}
@@ -459,7 +459,8 @@ static void iwl_trans_tx_free(struct iwl_priv *priv)
 
 	/* Tx queues */
 	if (priv->txq) {
-		for (txq_id = 0; txq_id < priv->hw_params.max_txq_num; txq_id++)
+		for (txq_id = 0;
+		     txq_id < hw_params(priv).max_txq_num; txq_id++)
 			iwl_tx_queue_free(priv, txq_id);
 	}
 
@@ -491,7 +492,7 @@ static int iwl_trans_tx_alloc(struct iwl_priv *priv)
 	}
 
 	ret = iwlagn_alloc_dma_ptr(priv, &priv->scd_bc_tbls,
-				priv->hw_params.scd_bc_tbls_size);
+				hw_params(priv).scd_bc_tbls_size);
 	if (ret) {
 		IWL_ERR(priv, "Scheduler BC Table allocation failed\n");
 		goto error;
@@ -513,7 +514,7 @@ static int iwl_trans_tx_alloc(struct iwl_priv *priv)
 	}
 
 	/* Alloc and init all Tx queues, including the command queue (#4/#9) */
-	for (txq_id = 0; txq_id < priv->hw_params.max_txq_num; txq_id++) {
+	for (txq_id = 0; txq_id < hw_params(priv).max_txq_num; txq_id++) {
 		slots_num = (txq_id == priv->cmd_queue) ?
 					TFD_CMD_SLOTS : TFD_TX_CMD_SLOTS;
 		ret = iwl_trans_txq_alloc(priv, &priv->txq[txq_id], slots_num,
@@ -556,7 +557,7 @@ static int iwl_tx_init(struct iwl_priv *priv)
 	spin_unlock_irqrestore(&priv->lock, flags);
 
 	/* Alloc and init all Tx queues, including the command queue (#4/#9) */
-	for (txq_id = 0; txq_id < priv->hw_params.max_txq_num; txq_id++) {
+	for (txq_id = 0; txq_id < hw_params(priv).max_txq_num; txq_id++) {
 		slots_num = (txq_id == priv->cmd_queue) ?
 					TFD_CMD_SLOTS : TFD_TX_CMD_SLOTS;
 		ret = iwl_trans_txq_init(priv, &priv->txq[txq_id], slots_num,
@@ -789,7 +790,8 @@ static void iwl_trans_tx_start(struct iwl_priv *priv)
 		a += 4)
 		iwl_write_targ_mem(priv, a, 0);
 	for (; a < priv->scd_base_addr +
-	       SCD_TRANS_TBL_OFFSET_QUEUE(priv->hw_params.max_txq_num); a += 4)
+	       SCD_TRANS_TBL_OFFSET_QUEUE(hw_params(priv).max_txq_num);
+	       a += 4)
 		iwl_write_targ_mem(priv, a, 0);
 
 	iwl_write_prph(priv, SCD_DRAM_BASE_ADDR,
@@ -811,7 +813,7 @@ static void iwl_trans_tx_start(struct iwl_priv *priv)
 	iwl_write_prph(priv, SCD_AGGR_SEL, 0);
 
 	/* initiate the queues */
-	for (i = 0; i < priv->hw_params.max_txq_num; i++) {
+	for (i = 0; i < hw_params(priv).max_txq_num; i++) {
 		iwl_write_prph(priv, SCD_QUEUE_RDPTR(i), 0);
 		iwl_write_direct32(priv, HBUS_TARG_WRPTR, 0 | (i << 8));
 		iwl_write_targ_mem(priv, priv->scd_base_addr +
@@ -828,7 +830,7 @@ static void iwl_trans_tx_start(struct iwl_priv *priv)
 	}
 
 	iwl_write_prph(priv, SCD_INTERRUPT_MASK,
-			IWL_MASK(0, priv->hw_params.max_txq_num));
+			IWL_MASK(0, hw_params(priv).max_txq_num));
 
 	/* Activate all Tx DMA/FIFO channels */
 	iwl_trans_txq_set_sched(priv, IWL_MASK(0, 7));
@@ -908,7 +910,7 @@ static int iwl_trans_tx_stop(struct iwl_priv *priv)
 	}
 
 	/* Unmap DMA from host system and free skb's */
-	for (txq_id = 0; txq_id < priv->hw_params.max_txq_num; txq_id++)
+	for (txq_id = 0; txq_id < hw_params(priv).max_txq_num; txq_id++)
 		iwl_tx_queue_unmap(priv, txq_id);
 
 	return 0;
-- 
1.7.0.4

