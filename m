Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:55973 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755228Ab2CDUnN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Mar 2012 15:43:13 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 099/101] iwlwifi: don't delete AP station directly
Date: Sun,  4 Mar 2012 11:29:53 -0800
Message-Id: <1330889395-533-100-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120304_214415_070867_511B4E6E)
In-Reply-To: <1330889395-533-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1330889395-533-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

With the mac80211 deauth sequence changes, the
station is deleted before the device is set
unassociated. This can cause the device to get
confused as it expects the station to be there
while the associated bit is set.

To fix this, do not delete the AP station from
the device when mac80211 asks for deletion,
instead just mark it as unused and rely on the
unassociated RXON to drop it from the station
database in the device.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-sta.c  |   35 +++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-agn.h      |    2 +
 drivers/net/wireless/iwlwifi/iwl-mac80211.c |   22 ++++++++++++----
 3 files changed, 53 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-sta.c b/drivers/net/wireless/iwlwifi/iwl-agn-sta.c
index 23e9eab..c417560 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-sta.c
@@ -546,6 +546,41 @@ out_err:
 	return -EINVAL;
 }
 
+void iwl_deactivate_station(struct iwl_priv *priv, const u8 sta_id,
+			    const u8 *addr)
+{
+	u8 tid;
+
+	if (!iwl_is_ready(priv)) {
+		IWL_DEBUG_INFO(priv,
+			"Unable to remove station %pM, device not ready.\n",
+			addr);
+		return;
+	}
+
+	IWL_DEBUG_ASSOC(priv, "Deactivating STA: %pM (%d)\n", addr, sta_id);
+
+	if (WARN_ON_ONCE(sta_id == IWL_INVALID_STATION))
+		return;
+
+	spin_lock_bh(&priv->sta_lock);
+
+	WARN_ON_ONCE(!(priv->stations[sta_id].used & IWL_STA_DRIVER_ACTIVE));
+
+	for (tid = 0; tid < IWL_MAX_TID_COUNT; tid++)
+		memset(&priv->tid_data[sta_id][tid], 0,
+			sizeof(priv->tid_data[sta_id][tid]));
+
+	priv->stations[sta_id].used &= ~IWL_STA_DRIVER_ACTIVE;
+
+	priv->num_stations--;
+
+	if (WARN_ON_ONCE(priv->num_stations < 0))
+		priv->num_stations = 0;
+
+	spin_unlock_bh(&priv->sta_lock);
+}
+
 /**
  * iwl_clear_ucode_stations - clear ucode station table bits
  *
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.h b/drivers/net/wireless/iwlwifi/iwl-agn.h
index 5410dfd..3780a03 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.h
@@ -234,6 +234,8 @@ int iwl_add_station_common(struct iwl_priv *priv, struct iwl_rxon_context *ctx,
 			   struct ieee80211_sta *sta, u8 *sta_id_r);
 int iwl_remove_station(struct iwl_priv *priv, const u8 sta_id,
 		       const u8 *addr);
+void iwl_deactivate_station(struct iwl_priv *priv, const u8 sta_id,
+			    const u8 *addr);
 u8 iwl_prep_station(struct iwl_priv *priv, struct iwl_rxon_context *ctx,
 		    const u8 *addr, bool is_ap, struct ieee80211_sta *sta);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-mac80211.c b/drivers/net/wireless/iwlwifi/iwl-mac80211.c
index 54d3709..9212ee3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-mac80211.c
+++ b/drivers/net/wireless/iwlwifi/iwl-mac80211.c
@@ -724,12 +724,22 @@ static int iwlagn_mac_sta_remove(struct ieee80211_hw *hw,
 	struct iwl_station_priv *sta_priv = (void *)sta->drv_priv;
 	int ret;
 
-	IWL_DEBUG_INFO(priv, "proceeding to remove station %pM\n",
-			sta->addr);
-	ret = iwl_remove_station(priv, sta_priv->sta_id, sta->addr);
-	if (ret)
-		IWL_DEBUG_QUIET_RFKILL(priv, "Error removing station %pM\n",
-			sta->addr);
+	IWL_DEBUG_INFO(priv, "proceeding to remove station %pM\n", sta->addr);
+
+	if (vif->type == NL80211_IFTYPE_STATION) {
+		/*
+		 * Station will be removed from device when the RXON
+		 * is set to unassociated -- just deactivate it here
+		 * to avoid re-programming it.
+		 */
+		ret = 0;
+		iwl_deactivate_station(priv, sta_priv->sta_id, sta->addr);
+	} else {
+		ret = iwl_remove_station(priv, sta_priv->sta_id, sta->addr);
+		if (ret)
+			IWL_DEBUG_QUIET_RFKILL(priv,
+				"Error removing station %pM\n", sta->addr);
+	}
 	return ret;
 }
 
-- 
1.7.0.4

