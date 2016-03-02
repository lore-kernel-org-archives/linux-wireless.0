Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:51900 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753350AbcCBH5p (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Mar 2016 02:57:45 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Andrei Otcheretianski <andrei.otcheretianski@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 41/43] iwlwifi: add disable_11ac module param
Date: Wed,  2 Mar 2016 09:56:42 +0200
Message-Id: <1456905404-14435-41-git-send-email-emmanuel.grumbach@intel.com> (sfid-20160302_085950_792912_53B39C5A)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32EA50146@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32EA50146@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Andrei Otcheretianski <andrei.otcheretianski@intel.com>

Add module parameter that disables VHT capabilities.

Signed-off-by: Andrei Otcheretianski <andrei.otcheretianski@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c       | 4 ++++
 drivers/net/wireless/intel/iwlwifi/iwl-modparams.h | 2 ++
 drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c | 2 +-
 3 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
index ee4ffa5..184c0fe 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
@@ -1719,3 +1719,7 @@ MODULE_PARM_DESC(fw_monitor,
 module_param_named(d0i3_timeout, iwlwifi_mod_params.d0i3_entry_delay,
 		   uint, S_IRUGO);
 MODULE_PARM_DESC(d0i3_timeout, "Timeout to D0i3 entry when idle (ms)");
+
+module_param_named(disable_11ac, iwlwifi_mod_params.disable_11ac, bool,
+		   S_IRUGO);
+MODULE_PARM_DESC(disable_11ac, "Disable VHT capabilities");
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-modparams.h b/drivers/net/wireless/intel/iwlwifi/iwl-modparams.h
index b88ecc7..d1a5dd1 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-modparams.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-modparams.h
@@ -115,6 +115,7 @@ enum iwl_amsdu_size {
  *	entering D0i3 (in msecs)
  * @lar_disable: disable LAR (regulatory), default = 0
  * @fw_monitor: allow to use firmware monitor
+ * @disable_11ac: disable VHT capabilities, default = false.
  */
 struct iwl_mod_params {
 	int sw_crypto;
@@ -135,6 +136,7 @@ struct iwl_mod_params {
 	unsigned int d0i3_entry_delay;
 	bool lar_disable;
 	bool fw_monitor;
+	bool disable_11ac;
 };
 
 #endif /* #__iwl_modparams_h__ */
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c b/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
index e84cb8d..3481357 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
@@ -452,7 +452,7 @@ static void iwl_init_sbands(struct device *dev, const struct iwl_cfg *cfg,
 					  IEEE80211_BAND_5GHZ);
 	iwl_init_ht_hw_capab(cfg, data, &sband->ht_cap, IEEE80211_BAND_5GHZ,
 			     tx_chains, rx_chains);
-	if (data->sku_cap_11ac_enable)
+	if (data->sku_cap_11ac_enable && !iwlwifi_mod_params.disable_11ac)
 		iwl_init_vht_hw_capab(cfg, data, &sband->vht_cap,
 				      tx_chains, rx_chains);
 
-- 
2.5.0

