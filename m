Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:65350 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756464Ab0EJW20 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 May 2010 18:28:26 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 25/47] iwlagn: move iwl_get_ra_sta_id to 4965
Date: Mon, 10 May 2010 15:27:56 -0700
Message-Id: <1273530498-11876-26-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1273530498-11876-1-git-send-email-reinette.chatre@intel.com>
References: <1273530498-11876-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

This function is only needed by 4965, so
it need not be in core code and can be
made static.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965.c |   10 ++++++++++
 drivers/net/wireless/iwlwifi/iwl-sta.c  |   11 -----------
 drivers/net/wireless/iwlwifi/iwl-sta.h  |    1 -
 3 files changed, 10 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index a3562a1..b8bf837 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -1953,6 +1953,16 @@ static int iwl4965_tx_status_reply_tx(struct iwl_priv *priv,
 	return 0;
 }
 
+static int iwl_get_ra_sta_id(struct iwl_priv *priv, struct ieee80211_hdr *hdr)
+{
+	if (priv->iw_mode == NL80211_IFTYPE_STATION) {
+		return IWL_AP_ID;
+	} else {
+		u8 *da = ieee80211_get_DA(hdr);
+		return iwl_find_station(priv, da);
+	}
+}
+
 /**
  * iwl4965_rx_reply_tx - Handle standard (non-aggregation) Tx response
  */
diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.c b/drivers/net/wireless/iwlwifi/iwl-sta.c
index 7da8ede..0db742c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.c
@@ -80,17 +80,6 @@ u8 iwl_find_station(struct iwl_priv *priv, const u8 *addr)
 }
 EXPORT_SYMBOL(iwl_find_station);
 
-int iwl_get_ra_sta_id(struct iwl_priv *priv, struct ieee80211_hdr *hdr)
-{
-	if (priv->iw_mode == NL80211_IFTYPE_STATION) {
-		return IWL_AP_ID;
-	} else {
-		u8 *da = ieee80211_get_DA(hdr);
-		return iwl_find_station(priv, da);
-	}
-}
-EXPORT_SYMBOL(iwl_get_ra_sta_id);
-
 /* priv->sta_lock must be held */
 static void iwl_sta_ucode_activate(struct iwl_priv *priv, u8 sta_id)
 {
diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.h b/drivers/net/wireless/iwlwifi/iwl-sta.h
index 9a869f1..1a0e590 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.h
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.h
@@ -66,7 +66,6 @@ void iwl_restore_stations(struct iwl_priv *priv);
 void iwl_clear_ucode_stations(struct iwl_priv *priv, bool force);
 int iwl_get_free_ucode_key_index(struct iwl_priv *priv);
 int iwl_get_sta_id(struct iwl_priv *priv, struct ieee80211_hdr *hdr);
-int iwl_get_ra_sta_id(struct iwl_priv *priv, struct ieee80211_hdr *hdr);
 int iwl_send_add_sta(struct iwl_priv *priv,
 		     struct iwl_addsta_cmd *sta, u8 flags);
 int iwl_add_local_station(struct iwl_priv *priv, const u8 *addr, bool init_rs);
-- 
1.6.3.3

