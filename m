Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:34894 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751189AbdFYLMM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 25 Jun 2017 07:12:12 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Luca Coelho <luciano.coelho@intel.com>
Date: Sun, 25 Jun 2017 14:11:41 +0300
Message-Id: <20170625111158.1792-10-luca@coelho.fi> (sfid-20170625_131218_698846_C2C2AA0C)
In-Reply-To: <20170625111158.1792-1-luca@coelho.fi>
References: <20170625111158.1792-1-luca@coelho.fi>
Subject: [PATCH 09/26] iwlwifi: remove useless iwl_free_nvm_data() function
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luca Coelho <luciano.coelho@intel.com>

This function just calls kfree(), so it only obscures the code without
bringing any benefits.  Remove it.

Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/dvm/main.c         | 4 ++--
 drivers/net/wireless/intel/iwlwifi/iwl-eeprom-parse.h | 9 ---------
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c          | 2 +-
 3 files changed, 3 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/main.c b/drivers/net/wireless/intel/iwlwifi/dvm/main.c
index b49848683587..4c8f9f1a5532 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/main.c
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/main.c
@@ -1513,7 +1513,7 @@ static struct iwl_op_mode *iwl_op_mode_dvm_start(struct iwl_trans *trans,
 out_free_eeprom_blob:
 	kfree(priv->eeprom_blob);
 out_free_eeprom:
-	iwl_free_nvm_data(priv->nvm_data);
+	kfree(priv->nvm_data);
 out_free_hw:
 	ieee80211_free_hw(priv->hw);
 out:
@@ -1532,7 +1532,7 @@ static void iwl_op_mode_dvm_stop(struct iwl_op_mode *op_mode)
 	iwl_tt_exit(priv);
 
 	kfree(priv->eeprom_blob);
-	iwl_free_nvm_data(priv->nvm_data);
+	kfree(priv->nvm_data);
 
 	/*netif_stop_queue(dev); */
 	flush_workqueue(priv->workqueue);
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-eeprom-parse.h b/drivers/net/wireless/intel/iwlwifi/iwl-eeprom-parse.h
index e04a91d70a15..b33888991b94 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-eeprom-parse.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-eeprom-parse.h
@@ -121,15 +121,6 @@ struct iwl_nvm_data *
 iwl_parse_eeprom_data(struct device *dev, const struct iwl_cfg *cfg,
 		      const u8 *eeprom, size_t eeprom_size);
 
-/**
- * iwl_free_nvm_data - free NVM data
- * @data: the data to free
- */
-static inline void iwl_free_nvm_data(struct iwl_nvm_data *data)
-{
-	kfree(data);
-}
-
 int iwl_nvm_check_version(struct iwl_nvm_data *data,
 			  struct iwl_trans *trans);
 
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
index 4e66cc662120..fc2c607013fb 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
@@ -849,7 +849,7 @@ static void iwl_op_mode_mvm_stop(struct iwl_op_mode *op_mode)
 	iwl_phy_db_free(mvm->phy_db);
 	mvm->phy_db = NULL;
 
-	iwl_free_nvm_data(mvm->nvm_data);
+	kfree(mvm->nvm_data);
 	for (i = 0; i < NVM_MAX_NUM_SECTIONS; i++)
 		kfree(mvm->nvm_sections[i].data);
 
-- 
2.11.0
