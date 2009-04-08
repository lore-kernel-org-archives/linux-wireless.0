Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:46412 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755621AbZDHSVR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Apr 2009 14:21:17 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Abhijeet Kolekar <abhijeet.kolekar@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 15/18] iwlwifi: add config_ap lib op
Date: Wed,  8 Apr 2009 11:26:49 -0700
Message-Id: <1239215212-1657-16-git-send-email-reinette.chatre@intel.com> (sfid-20090408_202131_656350_1E65FB26)
In-Reply-To: <1239215212-1657-15-git-send-email-reinette.chatre@intel.com>
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
 <1239215212-1657-11-git-send-email-reinette.chatre@intel.com>
 <1239215212-1657-12-git-send-email-reinette.chatre@intel.com>
 <1239215212-1657-13-git-send-email-reinette.chatre@intel.com>
 <1239215212-1657-14-git-send-email-reinette.chatre@intel.com>
 <1239215212-1657-15-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Abhijeet Kolekar <abhijeet.kolekar@intel.com>

add config_ap lib op to iwlwifi and iwl3945 in preparation
of future 3945 porting actions.

Signed-off-by: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945.c     |    1 +
 drivers/net/wireless/iwlwifi/iwl-3945.h     |    2 ++
 drivers/net/wireless/iwlwifi/iwl-4965.c     |    1 +
 drivers/net/wireless/iwlwifi/iwl-5000.c     |    1 +
 drivers/net/wireless/iwlwifi/iwl-agn.c      |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-core.h     |    7 ++++++-
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    4 ++--
 7 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index a854feb..edc0cb3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -2952,6 +2952,7 @@ static struct iwl_lib_ops iwl3945_lib = {
 	.send_tx_power	= iwl3945_send_tx_power,
 	.is_valid_rtc_data_addr = iwl3945_hw_valid_rtc_data_addr,
 	.post_associate = iwl3945_post_associate,
+	.config_ap = iwl3945_config_ap,
 };
 
 static struct iwl_station_mgmt_ops iwl3945_station_mgmt = {
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.h b/drivers/net/wireless/iwlwifi/iwl-3945.h
index 88628b2..4f5473e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.h
@@ -278,6 +278,8 @@ extern void iwl3945_hw_rx_statistics(struct iwl_priv *priv,
 extern void iwl3945_disable_events(struct iwl_priv *priv);
 extern int iwl4965_get_temperature(const struct iwl_priv *priv);
 extern void iwl3945_post_associate(struct iwl_priv *priv);
+extern void iwl3945_config_ap(struct iwl_priv *priv);
+
 /**
  * iwl3945_hw_find_station - Find station id for a given BSSID
  * @bssid: MAC address of station ID to find
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index ab25e6a..e4762e5 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -2333,6 +2333,7 @@ static struct iwl_lib_ops iwl4965_lib = {
 	.update_chain_flags = iwl_update_chain_flags,
 	.temperature = iwl4965_temperature_calib,
 	.post_associate = iwl_post_associate,
+	.config_ap = iwl_config_ap,
 };
 
 static struct iwl_ops iwl4965_ops = {
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index cf622a1..5bbb4f9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -1537,6 +1537,7 @@ struct iwl_lib_ops iwl5000_lib = {
 		.query_addr = iwl5000_eeprom_query_addr,
 	},
 	.post_associate = iwl_post_associate,
+	.config_ap = iwl_config_ap,
 };
 
 struct iwl_ops iwl5000_ops = {
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 8a8ff0a..049f741 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -2036,7 +2036,7 @@ static int iwl_mac_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 	return NETDEV_TX_OK;
 }
 
-static void iwl_config_ap(struct iwl_priv *priv)
+void iwl_config_ap(struct iwl_priv *priv)
 {
 	int ret = 0;
 	unsigned long flags;
@@ -2178,7 +2178,7 @@ static int iwl_mac_config_interface(struct ieee80211_hw *hw,
 		memcpy(priv->bssid, conf->bssid, ETH_ALEN);
 
 		if (priv->iw_mode == NL80211_IFTYPE_AP)
-			iwl_config_ap(priv);
+			iwlcore_config_ap(priv);
 		else {
 			rc = iwlcore_commit_rxon(priv);
 			if ((priv->iw_mode == NL80211_IFTYPE_STATION) && rc)
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index da8fae5..af559b0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -162,6 +162,7 @@ struct iwl_lib_ops {
 	void (*update_chain_flags)(struct iwl_priv *priv);
 	void (*temperature) (struct iwl_priv *priv);
 	void (*post_associate) (struct iwl_priv *priv);
+	void (*config_ap) (struct iwl_priv *priv);
 
 	/* eeprom operations (as defined in iwl-eeprom.h) */
 	struct iwl_eeprom_ops eeprom_ops;
@@ -279,6 +280,7 @@ int iwl_mac_add_interface(struct ieee80211_hw *hw,
 void iwl_mac_remove_interface(struct ieee80211_hw *hw,
 				 struct ieee80211_if_init_conf *conf);
 int iwl_mac_config(struct ieee80211_hw *hw, u32 changed);
+void iwl_config_ap(struct iwl_priv *priv);
 
 /*****************************************************
  * RX handlers.
@@ -565,7 +567,10 @@ static inline int iwlcore_commit_rxon(struct iwl_priv *priv)
 {
 	return priv->cfg->ops->hcmd->commit_rxon(priv);
 }
-
+static inline void iwlcore_config_ap(struct iwl_priv *priv)
+{
+	priv->cfg->ops->lib->config_ap(priv);
+}
 static inline const struct ieee80211_supported_band *iwl_get_hw_mode(
 			struct iwl_priv *priv, enum ieee80211_band band)
 {
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 8407bb8..313320a 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -3378,7 +3378,7 @@ static int iwl3945_mac_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 	return NETDEV_TX_OK;
 }
 
-static void iwl3945_config_ap(struct iwl_priv *priv)
+void iwl3945_config_ap(struct iwl_priv *priv)
 {
 	int rc = 0;
 
@@ -3515,7 +3515,7 @@ static int iwl3945_mac_config_interface(struct ieee80211_hw *hw,
 		memcpy(priv->bssid, conf->bssid, ETH_ALEN);
 
 		if (priv->iw_mode == NL80211_IFTYPE_AP)
-			iwl3945_config_ap(priv);
+			iwlcore_config_ap(priv);
 		else {
 			rc = iwlcore_commit_rxon(priv);
 			if ((priv->iw_mode == NL80211_IFTYPE_STATION) && rc)
-- 
1.5.6.3

