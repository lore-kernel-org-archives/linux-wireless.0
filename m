Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:39917 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756892Ab0EJW2c (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 May 2010 18:28:32 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 45/47] iwlwifi: rename iwl_add_local_station
Date: Mon, 10 May 2010 15:28:16 -0700
Message-Id: <1273530498-11876-46-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1273530498-11876-1-git-send-email-reinette.chatre@intel.com>
References: <1273530498-11876-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

This function is now only used for the special
IBSS BSSID station, so rename it to indicate
this. The new name is iwl_add_bssid_station.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945.c    |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c |    2 +-
 drivers/net/wireless/iwlwifi/iwl-sta.c     |    9 +++------
 drivers/net/wireless/iwlwifi/iwl-sta.h     |    2 +-
 4 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index 306e23a..0eb0faa 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -2465,7 +2465,7 @@ static int iwl3945_manage_ibss_station(struct iwl_priv *priv,
 	int ret;
 
 	if (add) {
-		ret = iwl_add_local_station(priv, vif->bss_conf.bssid, false,
+		ret = iwl_add_bssid_station(priv, vif->bss_conf.bssid, false,
 					    &vif_priv->ibss_bssid_sta_id);
 		if (ret)
 			return ret;
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index 81de88e..637d7b6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -1523,7 +1523,7 @@ int iwlagn_manage_ibss_station(struct iwl_priv *priv,
 	struct iwl_vif_priv *vif_priv = (void *)vif->drv_priv;
 
 	if (add)
-		return iwl_add_local_station(priv, vif->bss_conf.bssid, true,
+		return iwl_add_bssid_station(priv, vif->bss_conf.bssid, true,
 					     &vif_priv->ibss_bssid_sta_id);
 	return iwl_remove_station(priv, vif_priv->ibss_bssid_sta_id,
 				  vif->bss_conf.bssid);
diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.c b/drivers/net/wireless/iwlwifi/iwl-sta.c
index ba36df5..c15098e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.c
@@ -417,14 +417,11 @@ static struct iwl_link_quality_cmd *iwl_sta_alloc_lq(struct iwl_priv *priv,
 }
 
 /*
- * iwl_add_local_station - Add stations not requested by mac80211
- *
- * This will be either the broadcast station or the bssid station needed by
- * ad-hoc.
+ * iwl_add_bssid_station - Add the special IBSS BSSID station
  *
  * Function sleeps.
  */
-int iwl_add_local_station(struct iwl_priv *priv, const u8 *addr, bool init_rs,
+int iwl_add_bssid_station(struct iwl_priv *priv, const u8 *addr, bool init_rs,
 			  u8 *sta_id_r)
 {
 	int ret;
@@ -468,7 +465,7 @@ int iwl_add_local_station(struct iwl_priv *priv, const u8 *addr, bool init_rs,
 
 	return 0;
 }
-EXPORT_SYMBOL(iwl_add_local_station);
+EXPORT_SYMBOL(iwl_add_bssid_station);
 
 /**
  * iwl_sta_ucode_deactivate - deactivate ucode status for a station
diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.h b/drivers/net/wireless/iwlwifi/iwl-sta.h
index 6872bcf..6427148 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.h
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.h
@@ -63,7 +63,7 @@ void iwl_dealloc_bcast_station(struct iwl_priv *priv);
 int iwl_get_free_ucode_key_index(struct iwl_priv *priv);
 int iwl_send_add_sta(struct iwl_priv *priv,
 		     struct iwl_addsta_cmd *sta, u8 flags);
-int iwl_add_local_station(struct iwl_priv *priv, const u8 *addr, bool init_rs,
+int iwl_add_bssid_station(struct iwl_priv *priv, const u8 *addr, bool init_rs,
 			  u8 *sta_id_r);
 int iwl_add_station_common(struct iwl_priv *priv, const u8 *addr,
 				  bool is_ap,
-- 
1.6.3.3

