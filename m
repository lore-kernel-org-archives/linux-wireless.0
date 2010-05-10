Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:65350 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756794Ab0EJW23 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 May 2010 18:28:29 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 44/47] iwlwifi: move iwl_find_station() to 4965
Date: Mon, 10 May 2010 15:28:15 -0700
Message-Id: <1273530498-11876-45-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1273530498-11876-1-git-send-email-reinette.chatre@intel.com>
References: <1273530498-11876-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

4965 code is the only thing that now still
needs iwl_find_station(), so move it there
and make it static. Everything else can
rely on the station data passed by mac80211.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965.c |   44 ++++++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-sta.c  |   45 -------------------------------
 drivers/net/wireless/iwlwifi/iwl-sta.h  |    6 ----
 3 files changed, 44 insertions(+), 51 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 93893ae..d3afdda 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -1953,6 +1953,50 @@ static int iwl4965_tx_status_reply_tx(struct iwl_priv *priv,
 	return 0;
 }
 
+static u8 iwl_find_station(struct iwl_priv *priv, const u8 *addr)
+{
+	int i;
+	int start = 0;
+	int ret = IWL_INVALID_STATION;
+	unsigned long flags;
+
+	if ((priv->iw_mode == NL80211_IFTYPE_ADHOC) ||
+	    (priv->iw_mode == NL80211_IFTYPE_AP))
+		start = IWL_STA_ID;
+
+	if (is_broadcast_ether_addr(addr))
+		return priv->hw_params.bcast_sta_id;
+
+	spin_lock_irqsave(&priv->sta_lock, flags);
+	for (i = start; i < priv->hw_params.max_stations; i++)
+		if (priv->stations[i].used &&
+		    (!compare_ether_addr(priv->stations[i].sta.sta.addr,
+					 addr))) {
+			ret = i;
+			goto out;
+		}
+
+	IWL_DEBUG_ASSOC_LIMIT(priv, "can not find STA %pM total %d\n",
+			      addr, priv->num_stations);
+
+ out:
+	/*
+	 * It may be possible that more commands interacting with stations
+	 * arrive before we completed processing the adding of
+	 * station
+	 */
+	if (ret != IWL_INVALID_STATION &&
+	    (!(priv->stations[ret].used & IWL_STA_UCODE_ACTIVE) ||
+	     ((priv->stations[ret].used & IWL_STA_UCODE_ACTIVE) &&
+	      (priv->stations[ret].used & IWL_STA_UCODE_INPROGRESS)))) {
+		IWL_ERR(priv, "Requested station info for sta %d before ready.\n",
+			ret);
+		ret = IWL_INVALID_STATION;
+	}
+	spin_unlock_irqrestore(&priv->sta_lock, flags);
+	return ret;
+}
+
 static int iwl_get_ra_sta_id(struct iwl_priv *priv, struct ieee80211_hdr *hdr)
 {
 	if (priv->iw_mode == NL80211_IFTYPE_STATION) {
diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.c b/drivers/net/wireless/iwlwifi/iwl-sta.c
index b8053e7..ba36df5 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.c
@@ -35,51 +35,6 @@
 #include "iwl-core.h"
 #include "iwl-sta.h"
 
-u8 iwl_find_station(struct iwl_priv *priv, const u8 *addr)
-{
-	int i;
-	int start = 0;
-	int ret = IWL_INVALID_STATION;
-	unsigned long flags;
-
-	if ((priv->iw_mode == NL80211_IFTYPE_ADHOC) ||
-	    (priv->iw_mode == NL80211_IFTYPE_AP))
-		start = IWL_STA_ID;
-
-	if (is_broadcast_ether_addr(addr))
-		return priv->hw_params.bcast_sta_id;
-
-	spin_lock_irqsave(&priv->sta_lock, flags);
-	for (i = start; i < priv->hw_params.max_stations; i++)
-		if (priv->stations[i].used &&
-		    (!compare_ether_addr(priv->stations[i].sta.sta.addr,
-					 addr))) {
-			ret = i;
-			goto out;
-		}
-
-	IWL_DEBUG_ASSOC_LIMIT(priv, "can not find STA %pM total %d\n",
-			      addr, priv->num_stations);
-
- out:
-	/*
-	 * It may be possible that more commands interacting with stations
-	 * arrive before we completed processing the adding of
-	 * station
-	 */
-	if (ret != IWL_INVALID_STATION &&
-	    (!(priv->stations[ret].used & IWL_STA_UCODE_ACTIVE) ||
-	     ((priv->stations[ret].used & IWL_STA_UCODE_ACTIVE) &&
-	      (priv->stations[ret].used & IWL_STA_UCODE_INPROGRESS)))) {
-		IWL_ERR(priv, "Requested station info for sta %d before ready.\n",
-			ret);
-		ret = IWL_INVALID_STATION;
-	}
-	spin_unlock_irqrestore(&priv->sta_lock, flags);
-	return ret;
-}
-EXPORT_SYMBOL(iwl_find_station);
-
 /* priv->sta_lock must be held */
 static void iwl_sta_ucode_activate(struct iwl_priv *priv, u8 sta_id)
 {
diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.h b/drivers/net/wireless/iwlwifi/iwl-sta.h
index 08d4bc1..6872bcf 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.h
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.h
@@ -43,12 +43,6 @@
 #define IWL_STA_BCAST BIT(4) /* this station is the special bcast station */
 
 
-/**
- * iwl_find_station - Find station id for a given BSSID
- * @bssid: MAC address of station ID to find
- */
-u8 iwl_find_station(struct iwl_priv *priv, const u8 *bssid);
-
 int iwl_remove_default_wep_key(struct iwl_priv *priv,
 			       struct ieee80211_key_conf *key);
 int iwl_set_default_wep_key(struct iwl_priv *priv,
-- 
1.6.3.3

