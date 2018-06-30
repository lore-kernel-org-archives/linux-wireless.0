Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:52012 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S932190AbeF3InG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 30 Jun 2018 04:43:06 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, emmanuel.grumbach@intel.com,
        ilan.peer@intel.com, johannes@sipsolutions.net,
        liad.kaufman@intel.com, sara.sharon@intel.com,
        shaul.triebitz@intel.com, Luca Coelho <luciano.coelho@intel.com>
Date: Sat, 30 Jun 2018 11:42:52 +0300
Message-Id: <20180630084253.30660-4-luca@coelho.fi> (sfid-20180630_104335_603967_3D0DE204)
In-Reply-To: <20180630084253.30660-1-luca@coelho.fi>
References: <20180630084253.30660-1-luca@coelho.fi>
Subject: [PATCH v2 3/4] iwlwifi: add module parameter to disable 802.11ax
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luca Coelho <luciano.coelho@intel.com>

Add a module parameter to disable 802.11ax features in supported
devices.  This is useful for testing or if there are interoperability
issues with some APs.

Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c       | 4 ++++
 drivers/net/wireless/intel/iwlwifi/iwl-modparams.h | 4 ++++
 drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c | 4 ++--
 drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c  | 3 ++-
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  | 3 ++-
 5 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
index c59ce4f8a5ed..650214ff0a1c 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
@@ -1856,3 +1856,7 @@ module_param_named(remove_when_gone,
 		   0444);
 MODULE_PARM_DESC(remove_when_gone,
 		 "Remove dev from PCIe bus if it is deemed inaccessible (default: false)");
+
+module_param_named(disable_11ax, iwlwifi_mod_params.disable_11ax, bool,
+		   S_IRUGO);
+MODULE_PARM_DESC(disable_11ax, "Disable HE capabilities (default: false)");
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-modparams.h b/drivers/net/wireless/intel/iwlwifi/iwl-modparams.h
index a7dd8a8cddf9..5dd848cb9d20 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-modparams.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-modparams.h
@@ -144,6 +144,10 @@ struct iwl_mod_params {
 	bool lar_disable;
 	bool fw_monitor;
 	bool disable_11ac;
+	/**
+	 * @disable_11ax: disable HE capabilities, default = false
+	 */
+	bool disable_11ax;
 	bool remove_when_gone;
 };
 
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c b/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
index 941604c24fa1..7bb0360d6807 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
@@ -578,7 +578,7 @@ static void iwl_init_sbands(struct device *dev, const struct iwl_cfg *cfg,
 	iwl_init_ht_hw_capab(cfg, data, &sband->ht_cap, NL80211_BAND_2GHZ,
 			     tx_chains, rx_chains);
 
-	if (data->sku_cap_11ax_enable)
+	if (data->sku_cap_11ax_enable && !iwlwifi_mod_params.disable_11ax)
 		iwl_init_he_hw_capab(sband, tx_chains, rx_chains);
 
 	sband = &data->bands[NL80211_BAND_5GHZ];
@@ -593,7 +593,7 @@ static void iwl_init_sbands(struct device *dev, const struct iwl_cfg *cfg,
 		iwl_init_vht_hw_capab(cfg, data, &sband->vht_cap,
 				      tx_chains, rx_chains);
 
-	if (data->sku_cap_11ax_enable)
+	if (data->sku_cap_11ax_enable && !iwlwifi_mod_params.disable_11ax)
 		iwl_init_he_hw_capab(sband, tx_chains, rx_chains);
 
 	if (n_channels != n_used)
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
index 362e9b77974d..b3fd20502abb 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
@@ -780,7 +780,8 @@ static int iwl_mvm_mac_ctxt_cmd_sta(struct iwl_mvm *mvm,
 	if (vif->probe_req_reg && vif->bss_conf.assoc && vif->p2p)
 		cmd.filter_flags |= cpu_to_le32(MAC_FILTER_IN_PROBE_REQUEST);
 
-	if (vif->bss_conf.assoc && vif->bss_conf.he_support)
+	if (vif->bss_conf.assoc && vif->bss_conf.he_support &&
+	    !iwlwifi_mod_params.disable_11ax)
 		cmd.filter_flags |= cpu_to_le32(MAC_FILTER_IN_11AX);
 
 	return iwl_mvm_mac_ctxt_send_cmd(mvm, &cmd);
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index 6d9a59847621..532487d7e376 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -2100,7 +2100,8 @@ static void iwl_mvm_bss_info_changed_station(struct iwl_mvm *mvm,
 	 * added.
 	 */
 	if (changes & BSS_CHANGED_ASSOC && bss_conf->assoc) {
-		if (vif->bss_conf.he_support)
+		if (vif->bss_conf.he_support &&
+		    !iwlwifi_mod_params.disable_11ax)
 			iwl_mvm_cfg_he_sta(mvm, vif, mvmvif->ap_sta_id);
 
 		iwl_mvm_mac_ctxt_recalc_tsf_id(mvm, vif);
-- 
2.18.0
