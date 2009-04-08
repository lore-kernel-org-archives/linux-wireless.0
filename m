Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:34843 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760136AbZDHSVR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Apr 2009 14:21:17 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Abhijeet Kolekar <abhijeet.kolekar@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 08/18] iwl3945/iwlwifi: unify add_station function
Date: Wed,  8 Apr 2009 11:26:42 -0700
Message-Id: <1239215212-1657-9-git-send-email-reinette.chatre@intel.com> (sfid-20090408_202129_352312_6855DC2E)
In-Reply-To: <1239215212-1657-8-git-send-email-reinette.chatre@intel.com>
References: <1239215212-1657-1-git-send-email-reinette.chatre@intel.com>
 <1239215212-1657-2-git-send-email-reinette.chatre@intel.com>
 <1239215212-1657-3-git-send-email-reinette.chatre@intel.com>
 <1239215212-1657-4-git-send-email-reinette.chatre@intel.com>
 <1239215212-1657-5-git-send-email-reinette.chatre@intel.com>
 <1239215212-1657-6-git-send-email-reinette.chatre@intel.com>
 <1239215212-1657-7-git-send-email-reinette.chatre@intel.com>
 <1239215212-1657-8-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Abhijeet Kolekar <abhijeet.kolekar@intel.com>

Patch unifies the add_station function for 3945 and iwlwifi drivers.

Signed-off-by: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945-rs.c  |    2 +-
 drivers/net/wireless/iwlwifi/iwl-3945.c     |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-3945.h     |    2 +-
 drivers/net/wireless/iwlwifi/iwl-4965.c     |    2 +-
 drivers/net/wireless/iwlwifi/iwl-5000.c     |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c   |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-core.h     |    4 +---
 drivers/net/wireless/iwlwifi/iwl-sta.c      |    4 ++--
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   12 ++++++------
 9 files changed, 17 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945-rs.c b/drivers/net/wireless/iwlwifi/iwl-3945-rs.c
index af6b9d4..f63a9c5 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945-rs.c
@@ -719,7 +719,7 @@ static void rs_get_rate(void *priv_r, struct ieee80211_sta *sta,
 			IWL_DEBUG_RATE(priv, "LQ: ADD station %pm\n",
 				       hdr->addr1);
 			sta_id = iwl3945_add_station(priv,
-				    hdr->addr1, 0, CMD_ASYNC);
+				    hdr->addr1, 0, CMD_ASYNC, NULL);
 		}
 		if (sta_id != IWL_INVALID_STATION)
 			rs_sta->ibss_sta_added = 1;
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index 7c0c799..a854feb 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -2125,7 +2125,7 @@ static int iwl3945_commit_rxon(struct iwl_priv *priv)
 	}
 
 	/* Add the broadcast address so we can send broadcast frames */
-	if (priv->cfg->ops->smgmt->add_station(priv, iwl_bcast_addr, 0, 0) ==
+	if (priv->cfg->ops->smgmt->add_station(priv, iwl_bcast_addr, 0, 0, NULL) ==
 	    IWL_INVALID_STATION) {
 		IWL_ERR(priv, "Error adding BROADCAST address for transmit.\n");
 		return -EIO;
@@ -2136,7 +2136,7 @@ static int iwl3945_commit_rxon(struct iwl_priv *priv)
 	if (iwl_is_associated(priv) &&
 	    (priv->iw_mode == NL80211_IFTYPE_STATION))
 		if (priv->cfg->ops->smgmt->add_station(priv,
-					priv->active_rxon.bssid_addr, 1, 0)
+					priv->active_rxon.bssid_addr, 1, 0, NULL)
 		    == IWL_INVALID_STATION) {
 			IWL_ERR(priv, "Error adding AP address for transmit\n");
 			return -EIO;
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.h b/drivers/net/wireless/iwlwifi/iwl-3945.h
index 8e3e816..88628b2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.h
@@ -206,7 +206,7 @@ struct iwl3945_addsta_cmd;
 extern int iwl3945_send_add_station(struct iwl_priv *priv,
 				struct iwl3945_addsta_cmd *sta, u8 flags);
 extern u8 iwl3945_add_station(struct iwl_priv *priv, const u8 *bssid,
-			  int is_ap, u8 flags);
+			  int is_ap, u8 flags, struct ieee80211_sta_ht_cap *ht_info);
 extern void iwl3945_clear_stations_table(struct iwl_priv *priv);
 extern int iwl3945_power_init_handle(struct iwl_priv *priv);
 extern int iwl3945_eeprom_init(struct iwl_priv *priv);
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index e3d1e30..e98849e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -2269,7 +2269,7 @@ static void iwl4965_cancel_deferred_work(struct iwl_priv *priv)
 }
 
 static struct iwl_station_mgmt_ops iwl4965_station_mgmt = {
-	.add_station_ht = iwl_add_station_flags,
+	.add_station = iwl_add_station_flags,
 	.remove_station = iwl_remove_station,
 	.find_station = iwl_find_station,
 	.clear_station_table = iwl_clear_stations_table,
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index 26f30a7..52ee773 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -1473,7 +1473,7 @@ int iwl5000_calc_rssi(struct iwl_priv *priv,
 }
 
 struct iwl_station_mgmt_ops iwl5000_station_mgmt = {
-	.add_station_ht = iwl_add_station_flags,
+	.add_station = iwl_add_station_flags,
 	.remove_station = iwl_remove_station,
 	.find_station = iwl_find_station,
 	.clear_station_table = iwl_clear_stations_table,
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
index a995128..b1818a3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
@@ -2459,7 +2459,7 @@ static void rs_get_rate(void *priv_r, struct ieee80211_sta *sta, void *priv_sta,
 		if (sta_id == IWL_INVALID_STATION) {
 			IWL_DEBUG_RATE(priv, "LQ: ADD station %pM\n",
 				       hdr->addr1);
-			sta_id = priv->cfg->ops->smgmt->add_station_ht(priv,
+			sta_id = priv->cfg->ops->smgmt->add_station(priv,
 						hdr->addr1, 0,
 						CMD_ASYNC, NULL);
 		}
@@ -2536,7 +2536,7 @@ static void rs_rate_init(void *priv_r, struct ieee80211_supported_band *sband,
 
 		if (sta_id == IWL_INVALID_STATION) {
 			IWL_DEBUG_RATE(priv, "LQ: ADD station %pM\n", sta->addr);
-			sta_id = priv->cfg->ops->smgmt->add_station_ht(priv,
+			sta_id = priv->cfg->ops->smgmt->add_station(priv,
 							sta->addr, 0,
 							CMD_ASYNC, NULL);
 		}
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 8b7f5bd..383590c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -84,10 +84,8 @@ struct iwl_cmd;
 #define IWL_SKU_N       0x8
 
 struct iwl_station_mgmt_ops {
-	u8 (*add_station_ht)(struct iwl_priv *priv, const u8 *addr,
-			int is_ap, u8 flags, struct ieee80211_sta_ht_cap *ht_info);
 	u8 (*add_station)(struct iwl_priv *priv, const u8 *addr,
-			int is_ap, u8 flags);
+			int is_ap, u8 flags, struct ieee80211_sta_ht_cap *ht_info);
 	int (*remove_station)(struct iwl_priv *priv, const u8 *addr,
 			int is_ap);
 	u8 (*find_station)(struct iwl_priv *priv, const u8 *addr);
diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.c b/drivers/net/wireless/iwlwifi/iwl-sta.c
index 5816368..b8f18c6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.c
@@ -1019,7 +1019,7 @@ int iwl_rxon_add_station(struct iwl_priv *priv, const u8 *addr, int is_ap)
 		rcu_read_unlock();
 	}
 
-	sta_id = priv->cfg->ops->smgmt->add_station_ht(priv, addr, is_ap,
+	sta_id = priv->cfg->ops->smgmt->add_station(priv, addr, is_ap,
 				       0, cur_ht_config);
 
 	/* Set up default rate scaling table in device's station table */
@@ -1066,7 +1066,7 @@ int iwl_get_sta_id(struct iwl_priv *priv, struct ieee80211_hdr *hdr)
 			return sta_id;
 
 		/* Create new station table entry */
-		sta_id = priv->cfg->ops->smgmt->add_station_ht(priv, hdr->addr1,
+		sta_id = priv->cfg->ops->smgmt->add_station(priv, hdr->addr1,
 						   0, CMD_ASYNC, NULL);
 
 		if (sta_id != IWL_INVALID_STATION)
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 6161abd..c1f3324 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -164,7 +164,7 @@ void iwl3945_clear_stations_table(struct iwl_priv *priv)
 /**
  * iwl3945_add_station - Add station to station tables in driver and device
  */
-u8 iwl3945_add_station(struct iwl_priv *priv, const u8 *addr, int is_ap, u8 flags)
+u8 iwl3945_add_station(struct iwl_priv *priv, const u8 *addr, int is_ap, u8 flags, struct ieee80211_sta_ht_cap *ht_info)
 {
 	int i;
 	int index = IWL_INVALID_STATION;
@@ -748,7 +748,7 @@ static int iwl3945_get_sta_id(struct iwl_priv *priv, struct ieee80211_hdr *hdr)
 			return sta_id;
 
 		sta_id = priv->cfg->ops->smgmt->add_station(priv,
-				hdr->addr1, 0, CMD_ASYNC);
+				hdr->addr1, 0, CMD_ASYNC, NULL);
 
 		if (sta_id != IWL_INVALID_STATION)
 			return sta_id;
@@ -1884,7 +1884,7 @@ static void iwl3945_error_recovery(struct iwl_priv *priv)
 	priv->staging_rxon.filter_flags &= ~RXON_FILTER_ASSOC_MSK;
 	iwlcore_commit_rxon(priv);
 
-	priv->cfg->ops->smgmt->add_station(priv, priv->bssid, 1, 0);
+	priv->cfg->ops->smgmt->add_station(priv, priv->bssid, 1, 0, NULL);
 
 	spin_lock_irqsave(&priv->lock, flags);
 	priv->assoc_id = le16_to_cpu(priv->staging_rxon.assoc_id);
@@ -3333,7 +3333,7 @@ void iwl3945_post_associate(struct iwl_priv *priv)
 	case NL80211_IFTYPE_ADHOC:
 
 		priv->assoc_id = 1;
-		priv->cfg->ops->smgmt->add_station(priv, priv->bssid, 0, 0);
+		priv->cfg->ops->smgmt->add_station(priv, priv->bssid, 0, 0, NULL);
 		iwl3945_sync_sta(priv, IWL_STA_ID,
 				 (priv->band == IEEE80211_BAND_5GHZ) ?
 				 IWL_RATE_6M_PLCP : IWL_RATE_1M_PLCP,
@@ -3661,7 +3661,7 @@ static void iwl3945_config_ap(struct iwl_priv *priv)
 		/* restore RXON assoc */
 		priv->staging_rxon.filter_flags |= RXON_FILTER_ASSOC_MSK;
 		iwlcore_commit_rxon(priv);
-		priv->cfg->ops->smgmt->add_station(priv, iwl_bcast_addr, 0, 0);
+		priv->cfg->ops->smgmt->add_station(priv, iwl_bcast_addr, 0, 0, NULL);
 	}
 	iwl3945_send_beacon_cmd(priv);
 
@@ -3754,7 +3754,7 @@ static int iwl3945_mac_config_interface(struct ieee80211_hw *hw,
 			rc = iwlcore_commit_rxon(priv);
 			if ((priv->iw_mode == NL80211_IFTYPE_STATION) && rc)
 				priv->cfg->ops->smgmt->add_station(priv,
-					priv->active_rxon.bssid_addr, 1, 0);
+					priv->active_rxon.bssid_addr, 1, 0, NULL);
 		}
 
 	} else {
-- 
1.5.6.3

