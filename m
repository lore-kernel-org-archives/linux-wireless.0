Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:14617 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754496AbbCLNFm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Mar 2015 09:05:42 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Eliad Peller <eliad@wizery.com>,
	Eliad Peller <eliadx.peller@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 14/49] iwlwifi: disable 11ac if 11n is disabled
Date: Thu, 12 Mar 2015 15:03:59 +0200
Message-Id: <1426165474-25586-14-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150312_140545_906270_E74AEA85)
In-Reply-To: <1426164431.19690.4.camel@egrumbacBox>
References: <1426164431.19690.4.camel@egrumbacBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eliad Peller <eliad@wizery.com>

11ac depends on 11n, so disable it if 11n is disabled.

Signed-off-by: Eliad Peller <eliadx.peller@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-nvm-parse.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c b/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c
index 88ee84c..bca4582 100644
--- a/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c
+++ b/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c
@@ -396,7 +396,7 @@ static void iwl_init_vht_hw_capab(const struct iwl_cfg *cfg,
 
 static void iwl_init_sbands(struct device *dev, const struct iwl_cfg *cfg,
 			    struct iwl_nvm_data *data,
-			    const __le16 *ch_section, bool enable_vht,
+			    const __le16 *ch_section,
 			    u8 tx_chains, u8 rx_chains, bool lar_supported)
 {
 	int n_channels;
@@ -430,7 +430,7 @@ static void iwl_init_sbands(struct device *dev, const struct iwl_cfg *cfg,
 					  IEEE80211_BAND_5GHZ);
 	iwl_init_ht_hw_capab(cfg, data, &sband->ht_cap, IEEE80211_BAND_5GHZ,
 			     tx_chains, rx_chains);
-	if (enable_vht)
+	if (data->sku_cap_11ac_enable)
 		iwl_init_vht_hw_capab(cfg, data, &sband->vht_cap,
 				      tx_chains, rx_chains);
 
@@ -632,9 +632,10 @@ iwl_parse_nvm_data(struct device *dev, const struct iwl_cfg *cfg,
 	data->sku_cap_band_24GHz_enable = sku & NVM_SKU_CAP_BAND_24GHZ;
 	data->sku_cap_band_52GHz_enable = sku & NVM_SKU_CAP_BAND_52GHZ;
 	data->sku_cap_11n_enable = sku & NVM_SKU_CAP_11N_ENABLE;
-	data->sku_cap_11ac_enable = sku & NVM_SKU_CAP_11AC_ENABLE;
 	if (iwlwifi_mod_params.disable_11n & IWL_DISABLE_HT_ALL)
 		data->sku_cap_11n_enable = false;
+	data->sku_cap_11ac_enable = data->sku_cap_11n_enable &&
+				    (sku & NVM_SKU_CAP_11AC_ENABLE);
 
 	data->n_hw_addrs = iwl_get_n_hw_addrs(cfg, nvm_sw);
 
@@ -655,8 +656,7 @@ iwl_parse_nvm_data(struct device *dev, const struct iwl_cfg *cfg,
 		iwl_set_hw_address(cfg, data, nvm_hw);
 
 		iwl_init_sbands(dev, cfg, data, nvm_sw,
-				sku & NVM_SKU_CAP_11AC_ENABLE, tx_chains,
-				rx_chains, lar_fw_supported);
+				tx_chains, rx_chains, lar_fw_supported);
 	} else {
 		lar_config = le16_to_cpup(regulatory +
 					  NVM_LAR_OFFSET_FAMILY_8000);
@@ -668,9 +668,8 @@ iwl_parse_nvm_data(struct device *dev, const struct iwl_cfg *cfg,
 					       nvm_hw);
 
 		iwl_init_sbands(dev, cfg, data, regulatory,
-				sku & NVM_SKU_CAP_11AC_ENABLE, tx_chains,
-				rx_chains, lar_fw_supported &&
-				data->lar_enabled);
+				tx_chains, rx_chains,
+				lar_fw_supported && data->lar_enabled);
 	}
 
 	data->calib_version = 255;
-- 
1.9.1

