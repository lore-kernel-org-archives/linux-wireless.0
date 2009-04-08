Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:61547 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759501AbZDHSVQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Apr 2009 14:21:16 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Abhijeet Kolekar <abhijeet.kolekar@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 10/18] iwlwifi: add set_rxon_chain op
Date: Wed,  8 Apr 2009 11:26:44 -0700
Message-Id: <1239215212-1657-11-git-send-email-reinette.chatre@intel.com> (sfid-20090408_202125_320454_A8BCBF81)
In-Reply-To: <1239215212-1657-10-git-send-email-reinette.chatre@intel.com>
References: <1239215212-1657-1-git-send-email-reinette.chatre@intel.com>
 <1239215212-1657-2-git-send-email-reinette.chatre@intel.com>
 <1239215212-1657-3-git-send-email-reinette.chatre@intel.com>
 <1239215212-1657-4-git-send-email-reinette.chatre@intel.com>
 <1239215212-1657-5-git-send-email-reinette.chatre@intel.com>
 <1239215212-1657-6-git-send-email-reinette.chatre@intel.com>
 <1239215212-1657-7-git-send-email-reinette.chatre@intel.com>
 <1239215212-1657-8-git-send-email-reinette.chatre@intel.com>
 <1239215212-1657-9-git-send-email-reinette.chatre@intel.com>
 <1239215212-1657-10-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Abhijeet Kolekar <abhijeet.kolekar@intel.com>

add set_rxon_chain op to iwlwifi cfg ops in preparation of
future 3945 porting work.

Signed-off-by: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965.c |    1 +
 drivers/net/wireless/iwlwifi/iwl-5000.c |    1 +
 drivers/net/wireless/iwlwifi/iwl-agn.c  |   23 +++++++++++++++++------
 drivers/net/wireless/iwlwifi/iwl-core.c |   11 ++++++++---
 drivers/net/wireless/iwlwifi/iwl-core.h |    1 +
 5 files changed, 28 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index e98849e..ab25e6a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -2278,6 +2278,7 @@ static struct iwl_station_mgmt_ops iwl4965_station_mgmt = {
 static struct iwl_hcmd_ops iwl4965_hcmd = {
 	.rxon_assoc = iwl4965_send_rxon_assoc,
 	.commit_rxon = iwl_commit_rxon,
+	.set_rxon_chain = iwl_set_rxon_chain,
 };
 
 static struct iwl_hcmd_utils_ops iwl4965_hcmd_utils = {
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index 52ee773..cf622a1 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -1482,6 +1482,7 @@ struct iwl_station_mgmt_ops iwl5000_station_mgmt = {
 struct iwl_hcmd_ops iwl5000_hcmd = {
 	.rxon_assoc = iwl5000_send_rxon_assoc,
 	.commit_rxon = iwl_commit_rxon,
+	.set_rxon_chain = iwl_set_rxon_chain,
 };
 
 struct iwl_hcmd_utils_ops iwl5000_hcmd_utils = {
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 5013c5a..723f741 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -246,7 +246,8 @@ int iwl_commit_rxon(struct iwl_priv *priv)
 void iwl_update_chain_flags(struct iwl_priv *priv)
 {
 
-	iwl_set_rxon_chain(priv);
+	if (priv->cfg->ops->hcmd->set_rxon_chain)
+		priv->cfg->ops->hcmd->set_rxon_chain(priv);
 	iwlcore_commit_rxon(priv);
 }
 
@@ -590,7 +591,10 @@ static void iwl_setup_rxon_timing(struct iwl_priv *priv)
 static int iwl_set_mode(struct iwl_priv *priv, int mode)
 {
 	iwl_connection_init_rx_config(priv, mode);
-	iwl_set_rxon_chain(priv);
+
+	if (priv->cfg->ops->hcmd->set_rxon_chain)
+		priv->cfg->ops->hcmd->set_rxon_chain(priv);
+
 	memcpy(priv->staging_rxon.node_addr, priv->mac_addr, ETH_ALEN);
 
 	priv->cfg->ops->smgmt->clear_station_table(priv);
@@ -1499,7 +1503,10 @@ static void iwl_alive_start(struct iwl_priv *priv)
 	} else {
 		/* Initialize our rx_config data */
 		iwl_connection_init_rx_config(priv, priv->iw_mode);
-		iwl_set_rxon_chain(priv);
+
+		if (priv->cfg->ops->hcmd->set_rxon_chain)
+			priv->cfg->ops->hcmd->set_rxon_chain(priv);
+
 		memcpy(priv->staging_rxon.node_addr, priv->mac_addr, ETH_ALEN);
 	}
 
@@ -1878,7 +1885,9 @@ void iwl_post_associate(struct iwl_priv *priv)
 
 	iwl_set_rxon_ht(priv, &priv->current_ht_config);
 
-	iwl_set_rxon_chain(priv);
+	if (priv->cfg->ops->hcmd->set_rxon_chain)
+		priv->cfg->ops->hcmd->set_rxon_chain(priv);
+
 	priv->staging_rxon.assoc_id = cpu_to_le16(priv->assoc_id);
 
 	IWL_DEBUG_ASSOC(priv, "assoc id %d beacon interval %d\n",
@@ -2182,7 +2191,8 @@ static int iwl_mac_config(struct ieee80211_hw *hw, u32 changed)
 	}
 
 	/* call to ensure that 4965 rx_chain is set properly in monitor mode */
-	iwl_set_rxon_chain(priv);
+	if (priv->cfg->ops->hcmd->set_rxon_chain)
+		priv->cfg->ops->hcmd->set_rxon_chain(priv);
 
 	if (changed & IEEE80211_CONF_CHANGE_RADIO_ENABLED) {
 		if (conf->radio_enabled &&
@@ -2245,7 +2255,8 @@ static void iwl_config_ap(struct iwl_priv *priv)
 			IWL_WARN(priv, "REPLY_RXON_TIMING failed - "
 					"Attempting to continue.\n");
 
-		iwl_set_rxon_chain(priv);
+		if (priv->cfg->ops->hcmd->set_rxon_chain)
+			priv->cfg->ops->hcmd->set_rxon_chain(priv);
 
 		/* FIXME: what should be the assoc_id for AP? */
 		priv->staging_rxon.assoc_id = cpu_to_le16(priv->assoc_id);
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 6e96dcf..270d866 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -821,7 +821,8 @@ void iwl_set_rxon_ht(struct iwl_priv *priv, struct iwl_ht_info *ht_info)
 
 	rxon->flags |= cpu_to_le32(val << RXON_FLG_HT_OPERATING_MODE_POS);
 
-	iwl_set_rxon_chain(priv);
+	if (priv->cfg->ops->hcmd->set_rxon_chain)
+		priv->cfg->ops->hcmd->set_rxon_chain(priv);
 
 	IWL_DEBUG_ASSOC(priv, "supported HT rate 0x%X 0x%X 0x%X "
 			"rxon flags 0x%X operation mode :0x%X "
@@ -1379,7 +1380,9 @@ int iwl_init_drv(struct iwl_priv *priv)
 	priv->current_ht_config.sm_ps = WLAN_HT_CAP_SM_PS_DISABLED;
 
 	/* Choose which receivers/antennas to use */
-	iwl_set_rxon_chain(priv);
+	if (priv->cfg->ops->hcmd->set_rxon_chain)
+		priv->cfg->ops->hcmd->set_rxon_chain(priv);
+
 	iwl_init_scan_params(priv);
 
 	iwl_reset_qos(priv);
@@ -2256,7 +2259,9 @@ void iwl_bss_info_changed(struct ieee80211_hw *hw,
 
 	if (changes & BSS_CHANGED_HT) {
 		iwl_ht_conf(priv, bss_conf);
-		iwl_set_rxon_chain(priv);
+
+		if (priv->cfg->ops->hcmd->set_rxon_chain)
+			priv->cfg->ops->hcmd->set_rxon_chain(priv);
 	}
 
 	if (changes & BSS_CHANGED_ASSOC) {
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 383590c..f5eff74 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -95,6 +95,7 @@ struct iwl_station_mgmt_ops {
 struct iwl_hcmd_ops {
 	int (*rxon_assoc)(struct iwl_priv *priv);
 	int (*commit_rxon)(struct iwl_priv *priv);
+	void (*set_rxon_chain)(struct iwl_priv *priv);
 };
 
 struct iwl_hcmd_utils_ops {
-- 
1.5.6.3

