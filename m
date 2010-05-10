Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:65350 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756736Ab0EJW23 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 May 2010 18:28:29 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 31/47] iwlwifi: use vif in iwl_ht_conf
Date: Mon, 10 May 2010 15:28:02 -0700
Message-Id: <1273530498-11876-32-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1273530498-11876-1-git-send-email-reinette.chatre@intel.com>
References: <1273530498-11876-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Pass the virtual interface pointer to iwl_ht_conf()
so it doesn't need to rely on iw_mode and other
global variables.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-core.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 68c3693..d7a3620 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -1740,10 +1740,11 @@ int iwl_mac_conf_tx(struct ieee80211_hw *hw, u16 queue,
 EXPORT_SYMBOL(iwl_mac_conf_tx);
 
 static void iwl_ht_conf(struct iwl_priv *priv,
-			struct ieee80211_bss_conf *bss_conf)
+			struct ieee80211_vif *vif)
 {
 	struct iwl_ht_config *ht_conf = &priv->current_ht_config;
 	struct ieee80211_sta *sta;
+	struct ieee80211_bss_conf *bss_conf = &vif->bss_conf;
 
 	IWL_DEBUG_MAC80211(priv, "enter:\n");
 
@@ -1757,10 +1758,10 @@ static void iwl_ht_conf(struct iwl_priv *priv,
 
 	ht_conf->single_chain_sufficient = false;
 
-	switch (priv->iw_mode) {
+	switch (vif->type) {
 	case NL80211_IFTYPE_STATION:
 		rcu_read_lock();
-		sta = ieee80211_find_sta(priv->vif, priv->bssid);
+		sta = ieee80211_find_sta(vif, bss_conf->bssid);
 		if (sta) {
 			struct ieee80211_sta_ht_cap *ht_cap = &sta->ht_cap;
 			int maxstreams;
@@ -1911,7 +1912,7 @@ void iwl_bss_info_changed(struct ieee80211_hw *hw,
 	}
 
 	if (changes & BSS_CHANGED_HT) {
-		iwl_ht_conf(priv, bss_conf);
+		iwl_ht_conf(priv, vif);
 
 		if (priv->cfg->ops->hcmd->set_rxon_chain)
 			priv->cfg->ops->hcmd->set_rxon_chain(priv);
-- 
1.6.3.3

