Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:39917 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756785Ab0EJW23 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 May 2010 18:28:29 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 41/47] iwlwifi: use iwl_find_station less
Date: Mon, 10 May 2010 15:28:12 -0700
Message-Id: <1273530498-11876-42-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1273530498-11876-1-git-send-email-reinette.chatre@intel.com>
References: <1273530498-11876-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Since we now store the station ID in each station
struct, many places need not look at the station
table any more since they can just pull the station
ID out of the struct. Remove iwl_get_sta_id() and
use iwl_sta_id() instead as appropriate.

This reduces the amount of code needed to find the
right station significantly, and works since
mac80211 passes the station only after it has been
fully initialised, ie. even if TX races with
station addition it will only be passed to TX once
the addition is complete.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c   |    6 +-
 drivers/net/wireless/iwlwifi/iwl-agn.c      |   19 +++++----
 drivers/net/wireless/iwlwifi/iwl-sta.c      |   56 ---------------------------
 drivers/net/wireless/iwlwifi/iwl-sta.h      |    3 +-
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   23 ++++++-----
 5 files changed, 29 insertions(+), 78 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
index 6a306e8..89c85d1 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
@@ -566,11 +566,11 @@ int iwlagn_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 
 	hdr_len = ieee80211_hdrlen(fc);
 
-	/* Find (or create) index into station table for destination station */
-	if (info->flags & IEEE80211_TX_CTL_INJECTED)
+	/* Find index into station table for destination station */
+	if (!info->control.sta)
 		sta_id = priv->hw_params.bcast_sta_id;
 	else
-		sta_id = iwl_get_sta_id(priv, hdr);
+		sta_id = iwl_sta_id(info->control.sta);
 	if (sta_id == IWL_INVALID_STATION) {
 		IWL_DEBUG_DROP(priv, "Dropping - INVALID STATION: %pM\n",
 			       hdr->addr1);
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index b2c5665..8a4b830 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -3070,7 +3070,6 @@ static int iwl_mac_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 			   struct ieee80211_key_conf *key)
 {
 	struct iwl_priv *priv = hw->priv;
-	const u8 *addr;
 	int ret;
 	u8 sta_id;
 	bool is_default_wep_key = false;
@@ -3081,13 +3080,17 @@ static int iwl_mac_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 		IWL_DEBUG_MAC80211(priv, "leave - hwcrypto disabled\n");
 		return -EOPNOTSUPP;
 	}
-	addr = sta ? sta->addr : iwl_bcast_addr;
-	sta_id = iwl_find_station(priv, addr);
-	if (sta_id == IWL_INVALID_STATION) {
-		IWL_DEBUG_MAC80211(priv, "leave - %pM not in station map.\n",
-				   addr);
-		return -EINVAL;
 
+	if (sta) {
+		sta_id = iwl_sta_id(sta);
+
+		if (sta_id == IWL_INVALID_STATION) {
+			IWL_DEBUG_MAC80211(priv, "leave - %pM not in station map.\n",
+					   sta->addr);
+			return -EINVAL;
+		}
+	} else {
+		sta_id = priv->hw_params.bcast_sta_id;
 	}
 
 	mutex_lock(&priv->mutex);
@@ -3212,7 +3215,7 @@ static void iwl_mac_sta_notify(struct ieee80211_hw *hw,
 		if (!sta_priv->asleep)
 			break;
 		sta_priv->asleep = false;
-		sta_id = iwl_find_station(priv, sta->addr);
+		sta_id = iwl_sta_id(sta);
 		if (sta_id != IWL_INVALID_STATION)
 			iwl_sta_modify_ps_wake(priv, sta_id);
 		break;
diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.c b/drivers/net/wireless/iwlwifi/iwl-sta.c
index d1986de..4be7940 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.c
@@ -1307,62 +1307,6 @@ void iwl_dealloc_bcast_station(struct iwl_priv *priv)
 EXPORT_SYMBOL_GPL(iwl_dealloc_bcast_station);
 
 /**
- * iwl_get_sta_id - Find station's index within station table
- *
- * If new IBSS station, create new entry in station table
- */
-int iwl_get_sta_id(struct iwl_priv *priv, struct ieee80211_hdr *hdr)
-{
-	int sta_id;
-	__le16 fc = hdr->frame_control;
-
-	/* If this frame is broadcast or management, use broadcast station id */
-	if (!ieee80211_is_data(fc) ||  is_multicast_ether_addr(hdr->addr1))
-		return priv->hw_params.bcast_sta_id;
-
-	switch (priv->iw_mode) {
-
-	/* If we are a client station in a BSS network, use the special
-	 * AP station entry (that's the only station we communicate with) */
-	case NL80211_IFTYPE_STATION:
-		/*
-		 * If addition of station not complete yet, which means
-		 * that rate scaling has not been initialized, then return
-		 * the broadcast station.
-		 */
-		if (!(priv->stations[IWL_AP_ID].used & IWL_STA_UCODE_ACTIVE))
-			return priv->hw_params.bcast_sta_id;
-		return IWL_AP_ID;
-
-	/* If we are an AP, then find the station, or use BCAST */
-	case NL80211_IFTYPE_AP:
-		sta_id = iwl_find_station(priv, hdr->addr1);
-		if (sta_id != IWL_INVALID_STATION)
-			return sta_id;
-		return priv->hw_params.bcast_sta_id;
-
-	/* If this frame is going out to an IBSS network, find the station,
-	 * or create a new station table entry */
-	case NL80211_IFTYPE_ADHOC:
-		sta_id = iwl_find_station(priv, hdr->addr1);
-		if (sta_id != IWL_INVALID_STATION)
-			return sta_id;
-
-		IWL_DEBUG_DROP(priv, "Station %pM not in station map. "
-			       "Defaulting to broadcast...\n",
-			       hdr->addr1);
-		iwl_print_hex_dump(priv, IWL_DL_DROP, (u8 *) hdr, sizeof(*hdr));
-		return priv->hw_params.bcast_sta_id;
-
-	default:
-		IWL_WARN(priv, "Unknown mode of operation: %d\n",
-			priv->iw_mode);
-		return priv->hw_params.bcast_sta_id;
-	}
-}
-EXPORT_SYMBOL(iwl_get_sta_id);
-
-/**
  * iwl_sta_tx_modify_enable_tid - Enable Tx for this TID in station table
  */
 void iwl_sta_tx_modify_enable_tid(struct iwl_priv *priv, int sta_id, int tid)
diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.h b/drivers/net/wireless/iwlwifi/iwl-sta.h
index 7229e2c..646f644 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.h
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.h
@@ -29,6 +29,8 @@
 #ifndef __iwl_sta_h__
 #define __iwl_sta_h__
 
+#include "iwl-dev.h"
+
 #define HW_KEY_DYNAMIC 0
 #define HW_KEY_DEFAULT 1
 
@@ -65,7 +67,6 @@ void iwl_clear_ucode_stations(struct iwl_priv *priv);
 int iwl_alloc_bcast_station(struct iwl_priv *priv, bool init_lq);
 void iwl_dealloc_bcast_station(struct iwl_priv *priv);
 int iwl_get_free_ucode_key_index(struct iwl_priv *priv);
-int iwl_get_sta_id(struct iwl_priv *priv, struct ieee80211_hdr *hdr);
 int iwl_send_add_sta(struct iwl_priv *priv,
 		     struct iwl_addsta_cmd *sta, u8 flags);
 int iwl_add_local_station(struct iwl_priv *priv, const u8 *addr, bool init_rs,
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 48fb59b..4916f23 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -508,11 +508,11 @@ static int iwl3945_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 
 	hdr_len = ieee80211_hdrlen(fc);
 
-	/* Find (or create) index into station table for destination station */
-	if (info->flags & IEEE80211_TX_CTL_INJECTED)
+	/* Find index into station table for destination station */
+	if (!info->control.sta)
 		sta_id = priv->hw_params.bcast_sta_id;
 	else
-		sta_id = iwl_get_sta_id(priv, hdr);
+		sta_id = iwl_sta_id(info->control.sta);
 	if (sta_id == IWL_INVALID_STATION) {
 		IWL_DEBUG_DROP(priv, "Dropping - INVALID STATION: %pM\n",
 			       hdr->addr1);
@@ -3321,7 +3321,6 @@ static int iwl3945_mac_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 			       struct ieee80211_key_conf *key)
 {
 	struct iwl_priv *priv = hw->priv;
-	const u8 *addr;
 	int ret = 0;
 	u8 sta_id = IWL_INVALID_STATION;
 	u8 static_key;
@@ -3333,15 +3332,19 @@ static int iwl3945_mac_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 		return -EOPNOTSUPP;
 	}
 
-	addr = sta ? sta->addr : iwl_bcast_addr;
 	static_key = !iwl_is_associated(priv);
 
 	if (!static_key) {
-		sta_id = iwl_find_station(priv, addr);
-		if (sta_id == IWL_INVALID_STATION) {
-			IWL_DEBUG_MAC80211(priv, "leave - %pM not in station map.\n",
-					    addr);
-			return -EINVAL;
+		if (!sta) {
+			sta_id = priv->hw_params.bcast_sta_id;
+		} else {
+			sta_id = iwl_sta_id(sta);
+			if (sta_id == IWL_INVALID_STATION) {
+				IWL_DEBUG_MAC80211(priv,
+						   "leave - %pM not in station map.\n",
+						   sta->addr);
+				return -EINVAL;
+			}
 		}
 	}
 
-- 
1.6.3.3

