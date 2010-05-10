Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:63760 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754096Ab0EJW2Z (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 May 2010 18:28:25 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 15/47] iwlwifi: pass address to iwl_remove_station
Date: Mon, 10 May 2010 15:27:46 -0700
Message-Id: <1273530498-11876-16-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1273530498-11876-1-git-send-email-reinette.chatre@intel.com>
References: <1273530498-11876-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

We'll need that function for IBSS station management,
so pass it the address, which is the only thing it
uses from the station struct.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-sta.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.c b/drivers/net/wireless/iwlwifi/iwl-sta.c
index 5c6b326..354eb13 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.c
@@ -596,7 +596,7 @@ static int iwl_send_remove_station(struct iwl_priv *priv,
 /**
  * iwl_remove_station - Remove driver's knowledge of station.
  */
-static int iwl_remove_station(struct iwl_priv *priv, struct ieee80211_sta *sta)
+static int iwl_remove_station(struct iwl_priv *priv, const u8 *addr)
 {
 	int sta_id = IWL_INVALID_STATION;
 	int i, ret = -EINVAL;
@@ -607,7 +607,7 @@ static int iwl_remove_station(struct iwl_priv *priv, struct ieee80211_sta *sta)
 	if (!iwl_is_ready(priv)) {
 		IWL_DEBUG_INFO(priv,
 			"Unable to remove station %pM, device not ready.\n",
-			sta->addr);
+			addr);
 		/*
 		 * It is typical for stations to be removed when we are
 		 * going down. Return success since device will be down
@@ -624,7 +624,7 @@ static int iwl_remove_station(struct iwl_priv *priv, struct ieee80211_sta *sta)
 		for (i = IWL_STA_ID; i < priv->hw_params.max_stations; i++)
 			if (priv->stations[i].used &&
 			    !compare_ether_addr(priv->stations[i].sta.sta.addr,
-						sta->addr)) {
+						addr)) {
 				sta_id = i;
 				break;
 			}
@@ -633,17 +633,17 @@ static int iwl_remove_station(struct iwl_priv *priv, struct ieee80211_sta *sta)
 		goto out;
 
 	IWL_DEBUG_ASSOC(priv, "Removing STA from driver:%d  %pM\n",
-		sta_id, sta->addr);
+		sta_id, addr);
 
 	if (!(priv->stations[sta_id].used & IWL_STA_DRIVER_ACTIVE)) {
 		IWL_DEBUG_INFO(priv, "Removing %pM but non DRIVER active\n",
-				sta->addr);
+				addr);
 		goto out;
 	}
 
 	if (!(priv->stations[sta_id].used & IWL_STA_UCODE_ACTIVE)) {
 		IWL_DEBUG_INFO(priv, "Removing %pM but non UCODE active\n",
-				sta->addr);
+				addr);
 		goto out;
 	}
 
@@ -1450,7 +1450,7 @@ int iwl_mac_sta_remove(struct ieee80211_hw *hw,
 	struct iwl_priv *priv = hw->priv;
 	IWL_DEBUG_INFO(priv, "received request to remove station %pM\n",
 			sta->addr);
-	ret = iwl_remove_station(priv, sta);
+	ret = iwl_remove_station(priv, sta->addr);
 	if (ret)
 		IWL_ERR(priv, "Error removing station %pM\n",
 			sta->addr);
-- 
1.6.3.3

