Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:43661 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753457AbZASX2P (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Jan 2009 18:28:15 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	"Winkler, Tomas" <tomas.winkler@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 02/15] iwlwifi: fix iwl_mac_set_key and iwl3945_mac_set_key
Date: Mon, 19 Jan 2009 15:30:22 -0800
Message-Id: <1232407835-19451-3-git-send-email-reinette.chatre@intel.com> (sfid-20090120_002824_083466_3A0436F9)
In-Reply-To: <1232407835-19451-2-git-send-email-reinette.chatre@intel.com>
References: <>
 <1232407835-19451-1-git-send-email-reinette.chatre@intel.com>
 <1232407835-19451-2-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Winkler, Tomas <tomas.winkler@intel.com>

This patch fix iwl_mac_set_key function changed in patch
commit b30f80baeb65d84106e27bd2bff9162ab76f94bd
mac80211: clean up set_key callback

1. removing 'static' const u8 *addr' that can possible cause
conflict when two or more NICs are present in the system.
2. simplifying functions

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c      |   14 +++++---------
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   19 ++++++++-----------
 2 files changed, 13 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index d1994de..de6e999 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -3026,12 +3026,10 @@ static int iwl_mac_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 			   struct ieee80211_key_conf *key)
 {
 	struct iwl_priv *priv = hw->priv;
-	int ret = 0;
-	u8 sta_id = IWL_INVALID_STATION;
-	u8 is_default_wep_key = 0;
-	static const u8 bcast_addr[ETH_ALEN] =
-		{ 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, };
-	static const u8 *addr;
+	const u8 *addr;
+	int ret;
+	u8 sta_id;
+	bool is_default_wep_key = false;
 
 	IWL_DEBUG_MAC80211("enter\n");
 
@@ -3039,9 +3037,7 @@ static int iwl_mac_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 		IWL_DEBUG_MAC80211("leave - hwcrypto disabled\n");
 		return -EOPNOTSUPP;
 	}
-
-	addr = sta ? sta->addr : bcast_addr;
-
+	addr = sta ? sta->addr : iwl_bcast_addr;
 	sta_id = iwl_find_station(priv, addr);
 	if (sta_id == IWL_INVALID_STATION) {
 		IWL_DEBUG_MAC80211("leave - %pM not in station map.\n",
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index ee7bccf..313f874 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -6494,10 +6494,8 @@ static int iwl3945_mac_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 {
 	struct iwl_priv *priv = hw->priv;
 	const u8 *addr;
-	int rc = 0;
+	int ret;
 	u8 sta_id;
-	static const u8 bcast_addr[ETH_ALEN] =
-		{ 0xff, 0xff, 0xff, 0xff, 0xff, 0xff };
 
 	IWL_DEBUG_MAC80211("enter\n");
 
@@ -6506,8 +6504,7 @@ static int iwl3945_mac_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 		return -EOPNOTSUPP;
 	}
 
-	addr = sta ? sta->addr : bcast_addr;
-
+	addr = sta ? sta->addr : iwl_bcast_addr;
 	sta_id = iwl3945_hw_find_station(priv, addr);
 	if (sta_id == IWL_INVALID_STATION) {
 		IWL_DEBUG_MAC80211("leave - %pM not in station map.\n",
@@ -6521,8 +6518,8 @@ static int iwl3945_mac_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 
 	switch (cmd) {
 	case  SET_KEY:
-		rc = iwl3945_update_sta_key_info(priv, key, sta_id);
-		if (!rc) {
+		ret = iwl3945_update_sta_key_info(priv, key, sta_id);
+		if (!ret) {
 			iwl3945_set_rxon_hwcrypto(priv, 1);
 			iwl3945_commit_rxon(priv);
 			key->hw_key_idx = sta_id;
@@ -6531,21 +6528,21 @@ static int iwl3945_mac_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 		}
 		break;
 	case DISABLE_KEY:
-		rc = iwl3945_clear_sta_key_info(priv, sta_id);
-		if (!rc) {
+		ret = iwl3945_clear_sta_key_info(priv, sta_id);
+		if (!ret) {
 			iwl3945_set_rxon_hwcrypto(priv, 0);
 			iwl3945_commit_rxon(priv);
 			IWL_DEBUG_MAC80211("disable hwcrypto key\n");
 		}
 		break;
 	default:
-		rc = -EINVAL;
+		ret = -EINVAL;
 	}
 
 	IWL_DEBUG_MAC80211("leave\n");
 	mutex_unlock(&priv->mutex);
 
-	return rc;
+	return ret;
 }
 
 static int iwl3945_mac_conf_tx(struct ieee80211_hw *hw, u16 queue,
-- 
1.5.4.3

