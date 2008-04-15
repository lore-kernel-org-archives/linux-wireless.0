Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:61085 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752401AbYDOXCL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Apr 2008 19:02:11 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 11/11] iwlwifi: Use HW acceleration decryption by default
Date: Tue, 15 Apr 2008 16:01:47 -0700
Message-Id: <1208300507-25628-12-git-send-email-reinette.chatre@intel.com> (sfid-20080416_000232_180320_8C2E1447)
In-Reply-To: <1208300507-25628-11-git-send-email-reinette.chatre@intel.com>
References: <1208300507-25628-1-git-send-email-reinette.chatre@intel.com>
 <1208300507-25628-2-git-send-email-reinette.chatre@intel.com>
 <1208300507-25628-3-git-send-email-reinette.chatre@intel.com>
 <1208300507-25628-4-git-send-email-reinette.chatre@intel.com>
 <1208300507-25628-5-git-send-email-reinette.chatre@intel.com>
 <1208300507-25628-6-git-send-email-reinette.chatre@intel.com>
 <1208300507-25628-7-git-send-email-reinette.chatre@intel.com>
 <1208300507-25628-8-git-send-email-reinette.chatre@intel.com>
 <1208300507-25628-9-git-send-email-reinette.chatre@intel.com>
 <1208300507-25628-10-git-send-email-reinette.chatre@intel.com>
 <1208300507-25628-11-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

This patch reverses the hw_crypto logic and makes HW crypto a default.
Giving swcrypto=1 as parameter to the module disables HW crypto.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965.c     |    7 +++----
 drivers/net/wireless/iwlwifi/iwl-core.h     |    2 +-
 drivers/net/wireless/iwlwifi/iwl4965-base.c |    4 ++--
 3 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index b072523..17f629f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -3691,7 +3691,7 @@ static void iwl4965_handle_data_packet(struct iwl_priv *priv, int is_data,
 	stats->flag = 0;
 	hdr = (struct ieee80211_hdr *)rxb->skb->data;
 
-	if (priv->cfg->mod_params->hw_crypto)
+	if (!priv->cfg->mod_params->sw_crypto)
 		iwl4965_set_decrypted_flag(priv, rxb->skb, ampdu_status, stats);
 
 	if (priv->add_radiotap)
@@ -4988,9 +4988,8 @@ module_param_named(antenna, iwl4965_mod_params.antenna, int, 0444);
 MODULE_PARM_DESC(antenna, "select antenna (1=Main, 2=Aux, default 0 [both])");
 module_param_named(disable, iwl4965_mod_params.disable, int, 0444);
 MODULE_PARM_DESC(disable, "manually disable the radio (default 0 [radio on])");
-module_param_named(hwcrypto, iwl4965_mod_params.hw_crypto, int, 0444);
-MODULE_PARM_DESC(hwcrypto,
-		 "using hardware crypto engine (default 0 [software])\n");
+module_param_named(swcrypto, iwl4965_mod_params.sw_crypto, int, 0444);
+MODULE_PARM_DESC(swcrypto, "using crypto in software (default 0 [hardware])\n");
 module_param_named(debug, iwl4965_mod_params.debug, int, 0444);
 MODULE_PARM_DESC(debug, "debug output mask");
 module_param_named(
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index e22563a..7193d97 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -120,7 +120,7 @@ struct iwl_ops {
 
 struct iwl_mod_params {
 	int disable;		/* def: 0 = enable radio */
-	int hw_crypto;		/* def: 0 = using software encryption */
+	int sw_crypto;		/* def: 0 = using hardware encryption */
 	int debug;		/* def: 0 = minimal debug log messages */
 	int disable_hw_scan;	/* def: 0 = use h/w scan */
 	int num_of_queues;	/* def: HW dependent */
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index dae881e..d7e2358 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -835,7 +835,7 @@ static int iwl4965_commit_rxon(struct iwl_priv *priv)
 		       le16_to_cpu(priv->staging_rxon.channel),
 		       print_mac(mac, priv->staging_rxon.bssid_addr));
 
-	iwl4965_set_rxon_hwcrypto(priv, priv->cfg->mod_params->hw_crypto);
+	iwl4965_set_rxon_hwcrypto(priv, !priv->cfg->mod_params->sw_crypto);
 	/* Apply the new configuration */
 	rc = iwl_send_cmd_pdu(priv, REPLY_RXON,
 			      sizeof(struct iwl4965_rxon_cmd), &priv->staging_rxon);
@@ -6840,7 +6840,7 @@ static int iwl4965_mac_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 
 	IWL_DEBUG_MAC80211("enter\n");
 
-	if (!priv->cfg->mod_params->hw_crypto) {
+	if (priv->cfg->mod_params->sw_crypto) {
 		IWL_DEBUG_MAC80211("leave - hwcrypto disabled\n");
 		return -EOPNOTSUPP;
 	}
-- 
1.5.3.4

