Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:42059 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932457Ab0EMVuQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 May 2010 17:50:16 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 01/17] iwlwifi: introduce iwl_sta_id_or_broadcast
Date: Thu, 13 May 2010 14:49:43 -0700
Message-Id: <1273787399-9280-2-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1273787399-9280-1-git-send-email-reinette.chatre@intel.com>
References: <1273787399-9280-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

There are now five places where we need to
look up the station ID, but the sta pointer
may be NULL due to mac80211 passing that to
indicate a certain special state.

Replace all these by a new inline function,
called iwl_sta_id_or_broadcast(), and add
documentation about when to use it.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c   |    5 +---
 drivers/net/wireless/iwlwifi/iwl-agn.c      |   14 ++----------
 drivers/net/wireless/iwlwifi/iwl-sta.c      |   16 +++-----------
 drivers/net/wireless/iwlwifi/iwl-sta.h      |   29 +++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   19 +++--------------
 5 files changed, 41 insertions(+), 42 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
index c402bfc..18b1546 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
@@ -567,10 +567,7 @@ int iwlagn_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 	hdr_len = ieee80211_hdrlen(fc);
 
 	/* Find index into station table for destination station */
-	if (!info->control.sta)
-		sta_id = priv->hw_params.bcast_sta_id;
-	else
-		sta_id = iwl_sta_id(info->control.sta);
+	sta_id = iwl_sta_id_or_broadcast(priv, info->control.sta);
 	if (sta_id == IWL_INVALID_STATION) {
 		IWL_DEBUG_DROP(priv, "Dropping - INVALID STATION: %pM\n",
 			       hdr->addr1);
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 47563cf..d7a9aea 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -3081,17 +3081,9 @@ static int iwl_mac_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 		return -EOPNOTSUPP;
 	}
 
-	if (sta) {
-		sta_id = iwl_sta_id(sta);
-
-		if (sta_id == IWL_INVALID_STATION) {
-			IWL_DEBUG_MAC80211(priv, "leave - %pM not in station map.\n",
-					   sta->addr);
-			return -EINVAL;
-		}
-	} else {
-		sta_id = priv->hw_params.bcast_sta_id;
-	}
+	sta_id = iwl_sta_id_or_broadcast(priv, sta);
+	if (sta_id == IWL_INVALID_STATION)
+		return -EINVAL;
 
 	mutex_lock(&priv->mutex);
 	iwl_scan_cancel_timeout(priv, 100);
diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.c b/drivers/net/wireless/iwlwifi/iwl-sta.c
index 85ed235..2eafba6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.c
@@ -972,24 +972,16 @@ void iwl_update_tkip_key(struct iwl_priv *priv,
 	unsigned long flags;
 	int i;
 
-	if (sta) {
-		sta_id = iwl_sta_id(sta);
-
-		if (sta_id == IWL_INVALID_STATION) {
-			IWL_DEBUG_MAC80211(priv, "leave - %pM not initialised.\n",
-					   sta->addr);
-			return;
-		}
-	} else
-		sta_id = priv->hw_params.bcast_sta_id;
-
-
 	if (iwl_scan_cancel(priv)) {
 		/* cancel scan failed, just live w/ bad key and rely
 		   briefly on SW decryption */
 		return;
 	}
 
+	sta_id = iwl_sta_id_or_broadcast(priv, sta);
+	if (sta_id == IWL_INVALID_STATION)
+		return;
+
 	spin_lock_irqsave(&priv->sta_lock, flags);
 
 	priv->stations[sta_id].sta.key.tkip_rx_tsc_byte2 = (u8) iv32;
diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.h b/drivers/net/wireless/iwlwifi/iwl-sta.h
index c2a453a..5b1b1e4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.h
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.h
@@ -107,4 +107,33 @@ static inline int iwl_sta_id(struct ieee80211_sta *sta)
 
 	return ((struct iwl_station_priv_common *)sta->drv_priv)->sta_id;
 }
+
+/**
+ * iwl_sta_id_or_broadcast - return sta_id or broadcast sta
+ * @priv: iwl priv
+ * @sta: mac80211 station
+ *
+ * In certain circumstances mac80211 passes a station pointer
+ * that may be %NULL, for example during TX or key setup. In
+ * that case, we need to use the broadcast station, so this
+ * inline wraps that pattern.
+ */
+static inline int iwl_sta_id_or_broadcast(struct iwl_priv *priv,
+					  struct ieee80211_sta *sta)
+{
+	int sta_id;
+
+	if (!sta)
+		return priv->hw_params.bcast_sta_id;
+
+	sta_id = iwl_sta_id(sta);
+
+	/*
+	 * mac80211 should not be passing a partially
+	 * initialised station!
+	 */
+	WARN_ON(sta_id == IWL_INVALID_STATION);
+
+	return sta_id;
+}
 #endif /* __iwl_sta_h__ */
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 4c78783..68b8a1a 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -509,10 +509,7 @@ static int iwl3945_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 	hdr_len = ieee80211_hdrlen(fc);
 
 	/* Find index into station table for destination station */
-	if (!info->control.sta)
-		sta_id = priv->hw_params.bcast_sta_id;
-	else
-		sta_id = iwl_sta_id(info->control.sta);
+	sta_id = iwl_sta_id_or_broadcast(priv, info->control.sta);
 	if (sta_id == IWL_INVALID_STATION) {
 		IWL_DEBUG_DROP(priv, "Dropping - INVALID STATION: %pM\n",
 			       hdr->addr1);
@@ -3336,17 +3333,9 @@ static int iwl3945_mac_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 	static_key = !iwl_is_associated(priv);
 
 	if (!static_key) {
-		if (!sta) {
-			sta_id = priv->hw_params.bcast_sta_id;
-		} else {
-			sta_id = iwl_sta_id(sta);
-			if (sta_id == IWL_INVALID_STATION) {
-				IWL_DEBUG_MAC80211(priv,
-						   "leave - %pM not in station map.\n",
-						   sta->addr);
-				return -EINVAL;
-			}
-		}
+		sta_id = iwl_sta_id_or_broadcast(priv, sta);
+		if (sta_id == IWL_INVALID_STATION)
+			return -EINVAL;
 	}
 
 	mutex_lock(&priv->mutex);
-- 
1.6.3.3

