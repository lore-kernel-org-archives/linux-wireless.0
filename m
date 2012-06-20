Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39622 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755241Ab2FTHiv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jun 2012 03:38:51 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 12/12] iwlwifi: remove sku field from hw_params
Date: Wed, 20 Jun 2012 09:38:14 +0200
Message-Id: <1340177894-12992-13-git-send-email-johannes@sipsolutions.net> (sfid-20120620_093854_742758_35D95951)
In-Reply-To: <1340177894-12992-1-git-send-email-johannes@sipsolutions.net>
References: <1340177894-12992-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Now that the eeprom parsing code overrides the sku
field directly with 11n_disable parameters, there's
no longer a need to keep a copy of this field.

Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/dvm/dev.h      |    2 --
 drivers/net/wireless/iwlwifi/dvm/lib.c      |    2 +-
 drivers/net/wireless/iwlwifi/dvm/mac80211.c |    4 ++--
 drivers/net/wireless/iwlwifi/dvm/main.c     |   13 +++++--------
 4 files changed, 8 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/dvm/dev.h b/drivers/net/wireless/iwlwifi/dvm/dev.h
index 4620b65..54cf085 100644
--- a/drivers/net/wireless/iwlwifi/dvm/dev.h
+++ b/drivers/net/wireless/iwlwifi/dvm/dev.h
@@ -568,7 +568,6 @@ enum iwl_scan_type {
  *
  * @tx_chains_num: Number of TX chains
  * @rx_chains_num: Number of RX chains
- * @sku: sku read from EEPROM
  * @ct_kill_threshold: temperature threshold - in hw dependent unit
  * @ct_kill_exit_threshold: when to reeable the device - in hw dependent unit
  *	relevant for 1000, 6000 and up
@@ -579,7 +578,6 @@ struct iwl_hw_params {
 	u8  tx_chains_num;
 	u8  rx_chains_num;
 	bool use_rts_for_aggregation;
-	u16 sku;
 	u32 ct_kill_threshold;
 	u32 ct_kill_exit_threshold;
 
diff --git a/drivers/net/wireless/iwlwifi/dvm/lib.c b/drivers/net/wireless/iwlwifi/dvm/lib.c
index 76f2592..207ae91 100644
--- a/drivers/net/wireless/iwlwifi/dvm/lib.c
+++ b/drivers/net/wireless/iwlwifi/dvm/lib.c
@@ -160,7 +160,7 @@ int iwlagn_txfifo_flush(struct iwl_priv *priv, u16 flush_control)
 				IWL_PAN_SCD_BK_MSK | IWL_PAN_SCD_MGMT_MSK |
 				IWL_PAN_SCD_MULTICAST_MSK;
 
-	if (priv->hw_params.sku & EEPROM_SKU_CAP_11N_ENABLE)
+	if (priv->eeprom_data->sku & EEPROM_SKU_CAP_11N_ENABLE)
 		flush_cmd.fifo_control |= IWL_AGG_TX_QUEUE_MSK;
 
 	IWL_DEBUG_INFO(priv, "fifo queue control: 0X%x\n",
diff --git a/drivers/net/wireless/iwlwifi/dvm/mac80211.c b/drivers/net/wireless/iwlwifi/dvm/mac80211.c
index c577263..b581f03 100644
--- a/drivers/net/wireless/iwlwifi/dvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/dvm/mac80211.c
@@ -164,7 +164,7 @@ int iwlagn_mac_setup_register(struct iwl_priv *priv,
 	hw->max_tx_aggregation_subframes = LINK_QUAL_AGG_FRAME_LIMIT_DEF;
 	 */
 
-	if (priv->hw_params.sku & EEPROM_SKU_CAP_11N_ENABLE)
+	if (priv->eeprom_data->sku & EEPROM_SKU_CAP_11N_ENABLE)
 		hw->flags |= IEEE80211_HW_SUPPORTS_DYNAMIC_SMPS |
 			     IEEE80211_HW_SUPPORTS_STATIC_SMPS;
 
@@ -649,7 +649,7 @@ static int iwlagn_mac_ampdu_action(struct ieee80211_hw *hw,
 	IWL_DEBUG_HT(priv, "A-MPDU action on addr %pM tid %d\n",
 		     sta->addr, tid);
 
-	if (!(priv->hw_params.sku & EEPROM_SKU_CAP_11N_ENABLE))
+	if (!(priv->eeprom_data->sku & EEPROM_SKU_CAP_11N_ENABLE))
 		return -EACCES;
 
 	IWL_DEBUG_MAC80211(priv, "enter\n");
diff --git a/drivers/net/wireless/iwlwifi/dvm/main.c b/drivers/net/wireless/iwlwifi/dvm/main.c
index c642c21..abfd791 100644
--- a/drivers/net/wireless/iwlwifi/dvm/main.c
+++ b/drivers/net/wireless/iwlwifi/dvm/main.c
@@ -1187,9 +1187,6 @@ static void iwl_set_hw_params(struct iwl_priv *priv)
 		priv->hw_params.use_rts_for_aggregation =
 			priv->cfg->ht_params->use_rts_for_aggregation;
 
-	if (iwlwifi_mod_params.disable_11n & IWL_DISABLE_HT_ALL)
-		priv->hw_params.sku &= ~EEPROM_SKU_CAP_11N_ENABLE;
-
 	/* Device-specific setup */
 	priv->lib->set_hw_params(priv);
 }
@@ -1234,20 +1231,20 @@ static int iwl_eeprom_init_hw_params(struct iwl_priv *priv)
 {
 	u16 radio_cfg;
 
-	priv->hw_params.sku = priv->eeprom_data->sku;
+	priv->eeprom_data->sku = priv->eeprom_data->sku;
 
-	if (priv->hw_params.sku & EEPROM_SKU_CAP_11N_ENABLE &&
+	if (priv->eeprom_data->sku & EEPROM_SKU_CAP_11N_ENABLE &&
 	    !priv->cfg->ht_params) {
 		IWL_ERR(priv, "Invalid 11n configuration\n");
 		return -EINVAL;
 	}
 
-	if (!priv->hw_params.sku) {
+	if (!priv->eeprom_data->sku) {
 		IWL_ERR(priv, "Invalid device sku\n");
 		return -EINVAL;
 	}
 
-	IWL_INFO(priv, "Device SKU: 0x%X\n", priv->hw_params.sku);
+	IWL_INFO(priv, "Device SKU: 0x%X\n", priv->eeprom_data->sku);
 
 	radio_cfg = priv->eeprom_data->radio_cfg;
 
@@ -1453,7 +1450,7 @@ static struct iwl_op_mode *iwl_op_mode_dvm_start(struct iwl_trans *trans,
 	 ************************/
 	iwl_set_hw_params(priv);
 
-	if (!(priv->hw_params.sku & EEPROM_SKU_CAP_IPAN_ENABLE)) {
+	if (!(priv->eeprom_data->sku & EEPROM_SKU_CAP_IPAN_ENABLE)) {
 		IWL_DEBUG_INFO(priv, "Your EEPROM disabled PAN");
 		ucode_flags &= ~IWL_UCODE_TLV_FLAGS_PAN;
 		/*
-- 
1.7.10

