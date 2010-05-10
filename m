Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:39917 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756802Ab0EJW2a (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 May 2010 18:28:30 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 43/47] iwlwifi: use iwl_sta_id() for TKIP key update
Date: Mon, 10 May 2010 15:28:14 -0700
Message-Id: <1273530498-11876-44-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1273530498-11876-1-git-send-email-reinette.chatre@intel.com>
References: <1273530498-11876-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

With the station ID being stored in the
station struct, which mac80211 gives us
for TKIP phase 1 key updates, we can also
remove the use of iwl_find_station() in
that code path.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c |    3 +--
 drivers/net/wireless/iwlwifi/iwl-sta.c |   21 +++++++++++++--------
 drivers/net/wireless/iwlwifi/iwl-sta.h |    2 +-
 3 files changed, 15 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 3265b63..dd26965 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -3057,8 +3057,7 @@ static void iwl_mac_update_tkip_key(struct ieee80211_hw *hw,
 	struct iwl_priv *priv = hw->priv;
 	IWL_DEBUG_MAC80211(priv, "enter\n");
 
-	iwl_update_tkip_key(priv, keyconf,
-			    sta ? sta->addr : iwl_bcast_addr,
+	iwl_update_tkip_key(priv, keyconf, sta,
 			    iv32, phase1key);
 
 	IWL_DEBUG_MAC80211(priv, "leave\n");
diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.c b/drivers/net/wireless/iwlwifi/iwl-sta.c
index 8fec026..b8053e7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.c
@@ -1012,18 +1012,23 @@ static int iwl_set_tkip_dynamic_key_info(struct iwl_priv *priv,
 
 void iwl_update_tkip_key(struct iwl_priv *priv,
 			struct ieee80211_key_conf *keyconf,
-			const u8 *addr, u32 iv32, u16 *phase1key)
+			struct ieee80211_sta *sta, u32 iv32, u16 *phase1key)
 {
-	u8 sta_id = IWL_INVALID_STATION;
+	u8 sta_id;
 	unsigned long flags;
 	int i;
 
-	sta_id = iwl_find_station(priv, addr);
-	if (sta_id == IWL_INVALID_STATION) {
-		IWL_DEBUG_MAC80211(priv, "leave - %pM not in station map.\n",
-				   addr);
-		return;
-	}
+	if (sta) {
+		sta_id = iwl_sta_id(sta);
+
+		if (sta_id == IWL_INVALID_STATION) {
+			IWL_DEBUG_MAC80211(priv, "leave - %pM not initialised.\n",
+					   sta->addr);
+			return;
+		}
+	} else
+		sta_id = priv->hw_params.bcast_sta_id;
+
 
 	if (iwl_scan_cancel(priv)) {
 		/* cancel scan failed, just live w/ bad key and rely
diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.h b/drivers/net/wireless/iwlwifi/iwl-sta.h
index d0ab3f8..08d4bc1 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.h
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.h
@@ -60,7 +60,7 @@ int iwl_remove_dynamic_key(struct iwl_priv *priv,
 			   struct ieee80211_key_conf *key, u8 sta_id);
 void iwl_update_tkip_key(struct iwl_priv *priv,
 			struct ieee80211_key_conf *keyconf,
-			const u8 *addr, u32 iv32, u16 *phase1key);
+			struct ieee80211_sta *sta, u32 iv32, u16 *phase1key);
 
 void iwl_restore_stations(struct iwl_priv *priv);
 void iwl_clear_ucode_stations(struct iwl_priv *priv);
-- 
1.6.3.3

