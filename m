Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:55161 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756545Ab0GaQyt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 31 Jul 2010 12:54:49 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 4/8] iwlwifi: make iwl_set_hw_params static to _agn
Date: Sat, 31 Jul 2010 08:34:08 -0700
Message-Id: <1280590452-10655-5-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1280590452-10655-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1280590452-10655-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

iwl_set_hw_params() only used by _agn, make it static

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c  |   18 ++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-core.c |   19 -------------------
 drivers/net/wireless/iwlwifi/iwl-core.h |    1 -
 3 files changed, 18 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index fcbc42c..32fdc5a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -3979,6 +3979,24 @@ static void iwl_hw_detect(struct iwl_priv *priv)
 	IWL_DEBUG_INFO(priv, "HW Revision ID = 0x%X\n", priv->rev_id);
 }
 
+static int iwl_set_hw_params(struct iwl_priv *priv)
+{
+	priv->hw_params.max_rxq_size = RX_QUEUE_SIZE;
+	priv->hw_params.max_rxq_log = RX_QUEUE_SIZE_LOG;
+	if (priv->cfg->mod_params->amsdu_size_8K)
+		priv->hw_params.rx_page_order = get_order(IWL_RX_BUF_SIZE_8K);
+	else
+		priv->hw_params.rx_page_order = get_order(IWL_RX_BUF_SIZE_4K);
+
+	priv->hw_params.max_beacon_itrvl = IWL_MAX_UCODE_BEACON_INTERVAL;
+
+	if (priv->cfg->mod_params->disable_11n)
+		priv->cfg->sku &= ~IWL_SKU_N;
+
+	/* Device-specific setup */
+	return priv->cfg->ops->lib->set_hw_params(priv);
+}
+
 static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
 	int err = 0;
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 5af5e23..78d8eb8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -1348,25 +1348,6 @@ void iwl_configure_filter(struct ieee80211_hw *hw,
 }
 EXPORT_SYMBOL(iwl_configure_filter);
 
-int iwl_set_hw_params(struct iwl_priv *priv)
-{
-	priv->hw_params.max_rxq_size = RX_QUEUE_SIZE;
-	priv->hw_params.max_rxq_log = RX_QUEUE_SIZE_LOG;
-	if (priv->cfg->mod_params->amsdu_size_8K)
-		priv->hw_params.rx_page_order = get_order(IWL_RX_BUF_SIZE_8K);
-	else
-		priv->hw_params.rx_page_order = get_order(IWL_RX_BUF_SIZE_4K);
-
-	priv->hw_params.max_beacon_itrvl = IWL_MAX_UCODE_BEACON_INTERVAL;
-
-	if (priv->cfg->mod_params->disable_11n)
-		priv->cfg->sku &= ~IWL_SKU_N;
-
-	/* Device-specific setup */
-	return priv->cfg->ops->lib->set_hw_params(priv);
-}
-EXPORT_SYMBOL(iwl_set_hw_params);
-
 int iwl_set_tx_power(struct iwl_priv *priv, s8 tx_power, bool force)
 {
 	int ret = 0;
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 4c3bf4d..a166f3a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -382,7 +382,6 @@ void iwl_irq_handle_error(struct iwl_priv *priv);
 void iwl_configure_filter(struct ieee80211_hw *hw,
 			  unsigned int changed_flags,
 			  unsigned int *total_flags, u64 multicast);
-int iwl_set_hw_params(struct iwl_priv *priv);
 void iwl_post_associate(struct iwl_priv *priv, struct ieee80211_vif *vif);
 void iwl_bss_info_changed(struct ieee80211_hw *hw,
 				     struct ieee80211_vif *vif,
-- 
1.7.0.4

