Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:18215 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758905AbYF3J1M (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Jun 2008 05:27:12 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Ron Rindjunsky <ron.rindjunsky@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 20/33] iwlwifi: unite common settings of HW params
Date: Mon, 30 Jun 2008 17:23:20 +0800
Message-Id: <1214817813-17639-21-git-send-email-yi.zhu@intel.com> (sfid-20080630_113813_572722_087F79DF)
In-Reply-To: <1214817813-17639-20-git-send-email-yi.zhu@intel.com>
References: <1214817813-17639-1-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-2-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-3-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-4-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-5-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-6-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-7-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-8-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-9-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-10-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-11-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-12-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-13-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-14-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-15-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-16-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-17-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-18-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-19-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-20-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ron Rindjunsky <ron.rindjunsky@intel.com>

This patch unites common settings of 4965 and 5000 hw params.

Signed-off-by: Ron Rindjunsky <ron.rindjunsky@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965.c     |    9 ---------
 drivers/net/wireless/iwlwifi/iwl-5000.c     |   10 +---------
 drivers/net/wireless/iwlwifi/iwl-core.c     |   15 +++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-core.h     |    1 +
 drivers/net/wireless/iwlwifi/iwl4965-base.c |    3 +--
 5 files changed, 18 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 311b37c..7f6713f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -837,17 +837,8 @@ static int iwl4965_hw_set_hw_params(struct iwl_priv *priv)
 
 	priv->hw_params.max_txq_num = priv->cfg->mod_params->num_of_queues;
 	priv->hw_params.first_ampdu_q = IWL49_FIRST_AMPDU_QUEUE;
-	priv->hw_params.sw_crypto = priv->cfg->mod_params->sw_crypto;
-	priv->hw_params.max_rxq_size = RX_QUEUE_SIZE;
-	priv->hw_params.max_rxq_log = RX_QUEUE_SIZE_LOG;
-	if (priv->cfg->mod_params->amsdu_size_8K)
-		priv->hw_params.rx_buf_size = IWL_RX_BUF_SIZE_8K;
-	else
-		priv->hw_params.rx_buf_size = IWL_RX_BUF_SIZE_4K;
-	priv->hw_params.max_pkt_size = priv->hw_params.rx_buf_size - 256;
 	priv->hw_params.max_stations = IWL4965_STATION_COUNT;
 	priv->hw_params.bcast_sta_id = IWL4965_BROADCAST_ID;
-
 	priv->hw_params.max_data_size = IWL49_RTC_DATA_SIZE;
 	priv->hw_params.max_inst_size = IWL49_RTC_INST_SIZE;
 	priv->hw_params.max_bsm_size = BSM_SRAM_SIZE;
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index 104b6f7..75283fb 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -827,19 +827,11 @@ static int iwl5000_hw_set_hw_params(struct iwl_priv *priv)
 
 	priv->hw_params.max_txq_num = priv->cfg->mod_params->num_of_queues;
 	priv->hw_params.first_ampdu_q = IWL50_FIRST_AMPDU_QUEUE;
-	priv->hw_params.sw_crypto = priv->cfg->mod_params->sw_crypto;
-	priv->hw_params.max_rxq_size = RX_QUEUE_SIZE;
-	priv->hw_params.max_rxq_log = RX_QUEUE_SIZE_LOG;
-	if (priv->cfg->mod_params->amsdu_size_8K)
-		priv->hw_params.rx_buf_size = IWL_RX_BUF_SIZE_8K;
-	else
-		priv->hw_params.rx_buf_size = IWL_RX_BUF_SIZE_4K;
-	priv->hw_params.max_pkt_size = priv->hw_params.rx_buf_size - 256;
 	priv->hw_params.max_stations = IWL5000_STATION_COUNT;
 	priv->hw_params.bcast_sta_id = IWL5000_BROADCAST_ID;
 	priv->hw_params.max_data_size = IWL50_RTC_DATA_SIZE;
 	priv->hw_params.max_inst_size = IWL50_RTC_INST_SIZE;
-	priv->hw_params.max_bsm_size = BSM_SRAM_SIZE;
+	priv->hw_params.max_bsm_size = 0;
 	priv->hw_params.fat_channel =  BIT(IEEE80211_BAND_2GHZ) |
 					BIT(IEEE80211_BAND_5GHZ);
 	priv->hw_params.sens = &iwl5000_sensitivity;
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 95f7320..97447df 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -842,6 +842,21 @@ int iwl_setup_mac(struct iwl_priv *priv)
 }
 EXPORT_SYMBOL(iwl_setup_mac);
 
+int iwl_set_hw_params(struct iwl_priv *priv)
+{
+	priv->hw_params.sw_crypto = priv->cfg->mod_params->sw_crypto;
+	priv->hw_params.max_rxq_size = RX_QUEUE_SIZE;
+	priv->hw_params.max_rxq_log = RX_QUEUE_SIZE_LOG;
+	if (priv->cfg->mod_params->amsdu_size_8K)
+		priv->hw_params.rx_buf_size = IWL_RX_BUF_SIZE_8K;
+	else
+		priv->hw_params.rx_buf_size = IWL_RX_BUF_SIZE_4K;
+	priv->hw_params.max_pkt_size = priv->hw_params.rx_buf_size - 256;
+
+	/* Device-specific setup */
+	return priv->cfg->ops->lib->set_hw_params(priv);
+}
+EXPORT_SYMBOL(iwl_set_hw_params);
 
 int iwl_init_drv(struct iwl_priv *priv)
 {
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 7814a48..f156d27 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -193,6 +193,7 @@ u8 iwl_is_fat_tx_allowed(struct iwl_priv *priv,
 			 struct ieee80211_ht_info *sta_ht_inf);
 int iwl_hw_nic_init(struct iwl_priv *priv);
 int iwl_setup_mac(struct iwl_priv *priv);
+int iwl_set_hw_params(struct iwl_priv *priv);
 int iwl_init_drv(struct iwl_priv *priv);
 void iwl_uninit_drv(struct iwl_priv *priv);
 /* "keep warm" functions */
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index 2d0d079..7c7b103 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -4243,8 +4243,7 @@ static int iwl4965_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 	/************************
 	 * 5. Setup HW constants
 	 ************************/
-	/* Device-specific setup */
-	if (priv->cfg->ops->lib->set_hw_params(priv)) {
+	if (iwl_set_hw_params(priv)) {
 		IWL_ERROR("failed to set hw parameters\n");
 		goto out_free_eeprom;
 	}
-- 
1.5.3.6

