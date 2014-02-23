Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f173.google.com ([74.125.82.173]:63409 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751729AbaBWT5e (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 23 Feb 2014 14:57:34 -0500
Received: by mail-we0-f173.google.com with SMTP id x48so4010470wes.18
        for <linux-wireless@vger.kernel.org>; Sun, 23 Feb 2014 11:57:33 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 14/17] iwlwifi: nvm: remove reading valid antennas from NVM
Date: Sun, 23 Feb 2014 21:57:05 +0200
Message-Id: <1393185428-8524-14-git-send-email-egrumbach@gmail.com> (sfid-20140223_211709_868596_AAD612AB)
In-Reply-To: <530A51A4.6000007@gmail.com>
References: <530A51A4.6000007@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

These values aren't used as the firmware values should be used,
so reading them is pointless and hides potential errors when
somebody uses these values. Leave them zero to make it clearer
that they can't be used. We can't remove the struct members as
the DVM driver does read the values from EEPROM/OTP and the
structure is shared between drivers.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-nvm-parse.c |   17 -----------------
 drivers/net/wireless/iwlwifi/mvm/fw.c        |    2 --
 2 files changed, 19 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c b/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c
index 80c4096..eeb3a83 100644
--- a/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c
+++ b/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c
@@ -425,8 +425,6 @@ static void iwl_set_radio_cfg(const struct iwl_cfg *cfg,
 		data->radio_cfg_step = NVM_RF_CFG_STEP_MSK(radio_cfg);
 		data->radio_cfg_dash = NVM_RF_CFG_DASH_MSK(radio_cfg);
 		data->radio_cfg_pnum = NVM_RF_CFG_PNUM_MSK(radio_cfg);
-		data->valid_tx_ant = NVM_RF_CFG_TX_ANT_MSK(radio_cfg);
-		data->valid_rx_ant = NVM_RF_CFG_RX_ANT_MSK(radio_cfg);
 		return;
 	}
 
@@ -435,8 +433,6 @@ static void iwl_set_radio_cfg(const struct iwl_cfg *cfg,
 	data->radio_cfg_step = NVM_RF_CFG_STEP_MSK_FAMILY_8000(radio_cfg);
 	data->radio_cfg_dash = NVM_RF_CFG_DASH_MSK_FAMILY_8000(radio_cfg);
 	data->radio_cfg_pnum = NVM_RF_CFG_FLAVOR_MSK_FAMILY_8000(radio_cfg);
-	data->valid_tx_ant = NVM_RF_CFG_TX_ANT_MSK_FAMILY_8000(radio_cfg);
-	data->valid_rx_ant = NVM_RF_CFG_RX_ANT_MSK_FAMILY_8000(radio_cfg);
 }
 
 static void iwl_set_hw_address(const struct iwl_cfg *cfg,
@@ -496,19 +492,6 @@ iwl_parse_nvm_data(struct device *dev, const struct iwl_cfg *cfg,
 	if (iwlwifi_mod_params.disable_11n & IWL_DISABLE_HT_ALL)
 		data->sku_cap_11n_enable = false;
 
-	/* check overrides (some devices have wrong NVM) */
-	if (cfg->valid_tx_ant)
-		data->valid_tx_ant = cfg->valid_tx_ant;
-	if (cfg->valid_rx_ant)
-		data->valid_rx_ant = cfg->valid_rx_ant;
-
-	if (!data->valid_tx_ant || !data->valid_rx_ant) {
-		IWL_ERR_DEV(dev, "invalid antennas (0x%x, 0x%x)\n",
-			    data->valid_tx_ant, data->valid_rx_ant);
-		kfree(data);
-		return NULL;
-	}
-
 	data->n_hw_addrs = iwl_get_n_hw_addrs(cfg, nvm_sw);
 
 	if (cfg->device_family != IWL_DEVICE_FAMILY_8000) {
diff --git a/drivers/net/wireless/iwlwifi/mvm/fw.c b/drivers/net/wireless/iwlwifi/mvm/fw.c
index 979b35b..93e1b4d 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/iwlwifi/mvm/fw.c
@@ -358,8 +358,6 @@ out:
 					GFP_KERNEL);
 		if (!mvm->nvm_data)
 			return -ENOMEM;
-		mvm->nvm_data->valid_rx_ant = 1;
-		mvm->nvm_data->valid_tx_ant = 1;
 		mvm->nvm_data->bands[0].channels = mvm->nvm_data->channels;
 		mvm->nvm_data->bands[0].n_channels = 1;
 		mvm->nvm_data->bands[0].n_bitrates = 1;
-- 
1.7.9.5

