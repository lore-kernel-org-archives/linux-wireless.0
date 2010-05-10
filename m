Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:48051 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756796Ab0EJW23 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 May 2010 18:28:29 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 39/47] iwlwifi: track station IDs
Date: Mon, 10 May 2010 15:28:10 -0700
Message-Id: <1273530498-11876-40-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1273530498-11876-1-git-send-email-reinette.chatre@intel.com>
References: <1273530498-11876-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

mac80211 allows us to store private data per
station, so put the station ID there. This
allows us to avoid the station ID lookup when
removing regular stations. To also be able to
avoid the lookup to remove the special IBSS
BSSID station, track its ID in the per-vif
private data.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945.c     |   16 +++----
 drivers/net/wireless/iwlwifi/iwl-3945.h     |    5 ++
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c  |    8 +++-
 drivers/net/wireless/iwlwifi/iwl-agn.c      |    8 +++-
 drivers/net/wireless/iwlwifi/iwl-dev.h      |   18 ++++++++
 drivers/net/wireless/iwlwifi/iwl-sta.c      |   61 ++++++++++++--------------
 drivers/net/wireless/iwlwifi/iwl-sta.h      |    6 ++-
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   12 +++--
 8 files changed, 82 insertions(+), 52 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index 7fb1595..306e23a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -2461,28 +2461,26 @@ static u16 iwl3945_build_addsta_hcmd(const struct iwl_addsta_cmd *cmd, u8 *data)
 static int iwl3945_manage_ibss_station(struct iwl_priv *priv,
 				       struct ieee80211_vif *vif, bool add)
 {
+	struct iwl_vif_priv *vif_priv = (void *)vif->drv_priv;
 	int ret;
 
-	/*
-	 * NB: this assumes that the station it gets will be
-	 *     IWL_STA_ID, which will happen but isn't obvious.
-	 */
-
 	if (add) {
-		ret = iwl_add_local_station(priv, vif->bss_conf.bssid, false);
+		ret = iwl_add_local_station(priv, vif->bss_conf.bssid, false,
+					    &vif_priv->ibss_bssid_sta_id);
 		if (ret)
 			return ret;
 
-		iwl3945_sync_sta(priv, IWL_STA_ID,
+		iwl3945_sync_sta(priv, vif_priv->ibss_bssid_sta_id,
 				 (priv->band == IEEE80211_BAND_5GHZ) ?
 				 IWL_RATE_6M_PLCP : IWL_RATE_1M_PLCP,
 				 CMD_ASYNC);
-		iwl3945_rate_scale_init(priv->hw, IWL_STA_ID);
+		iwl3945_rate_scale_init(priv->hw, vif_priv->ibss_bssid_sta_id);
 
 		return 0;
 	}
 
-	return iwl_remove_station(priv, vif->bss_conf.bssid);
+	return iwl_remove_station(priv, vif_priv->ibss_bssid_sta_id,
+				  vif->bss_conf.bssid);
 }
 
 /**
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.h b/drivers/net/wireless/iwlwifi/iwl-3945.h
index 8fe24ee..bb2aeeb 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.h
@@ -106,7 +106,12 @@ struct iwl3945_rs_sta {
 };
 
 
+/*
+ * The common struct MUST be first because it is shared between
+ * 3945 and agn!
+ */
 struct iwl3945_sta_priv {
+	struct iwl_station_priv_common common;
 	struct iwl3945_rs_sta rs_sta;
 };
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index f05e600..81de88e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -1520,7 +1520,11 @@ void iwlagn_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif)
 int iwlagn_manage_ibss_station(struct iwl_priv *priv,
 			       struct ieee80211_vif *vif, bool add)
 {
+	struct iwl_vif_priv *vif_priv = (void *)vif->drv_priv;
+
 	if (add)
-		return iwl_add_local_station(priv, vif->bss_conf.bssid, true);
-	return iwl_remove_station(priv, vif->bss_conf.bssid);
+		return iwl_add_local_station(priv, vif->bss_conf.bssid, true,
+					     &vif_priv->ibss_bssid_sta_id);
+	return iwl_remove_station(priv, vif_priv->ibss_bssid_sta_id,
+				  vif->bss_conf.bssid);
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 0c913ea..b2c5665 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -2854,6 +2854,8 @@ static int iwl_mac_setup_register(struct iwl_priv *priv,
 			     IEEE80211_HW_SUPPORTS_STATIC_SMPS;
 
 	hw->sta_data_size = sizeof(struct iwl_station_priv);
+	hw->vif_data_size = sizeof(struct iwl_vif_priv);
+
 	hw->wiphy->interface_modes =
 		BIT(NL80211_IFTYPE_STATION) |
 		BIT(NL80211_IFTYPE_ADHOC);
@@ -3229,6 +3231,8 @@ static int iwlagn_mac_sta_add(struct ieee80211_hw *hw,
 	int ret;
 	u8 sta_id;
 
+	sta_priv->common.sta_id = IWL_INVALID_STATION;
+
 	IWL_DEBUG_INFO(priv, "received request to add station %pM\n",
 			sta->addr);
 
@@ -3245,12 +3249,14 @@ static int iwlagn_mac_sta_add(struct ieee80211_hw *hw,
 		return ret;
 	}
 
+	sta_priv->common.sta_id = sta_id;
+
 	/* Initialize rate scaling */
 	IWL_DEBUG_INFO(priv, "Initializing rate scaling for station %pM\n",
 		       sta->addr);
 	iwl_rs_rate_init(priv, sta, sta_id);
 
-	return ret;
+	return 0;
 }
 
 /*****************************************************************************
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 46571f7..f3f3473 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -497,20 +497,38 @@ struct iwl_station_entry {
 	struct iwl_link_quality_cmd *lq;
 };
 
+struct iwl_station_priv_common {
+	u8 sta_id;
+};
+
 /*
  * iwl_station_priv: Driver's private station information
  *
  * When mac80211 creates a station it reserves some space (hw->sta_data_size)
  * in the structure for use by driver. This structure is places in that
  * space.
+ *
+ * The common struct MUST be first because it is shared between
+ * 3945 and agn!
  */
 struct iwl_station_priv {
+	struct iwl_station_priv_common common;
 	struct iwl_lq_sta lq_sta;
 	atomic_t pending_frames;
 	bool client;
 	bool asleep;
 };
 
+/**
+ * struct iwl_vif_priv - driver's private per-interface information
+ *
+ * When mac80211 allocates a virtual interface, it can allocate
+ * space for us to put data into.
+ */
+struct iwl_vif_priv {
+	u8 ibss_bssid_sta_id;
+};
+
 /* one for each uCode image (inst/data, boot/init/runtime) */
 struct fw_desc {
 	void *v_addr;		/* access by driver */
diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.c b/drivers/net/wireless/iwlwifi/iwl-sta.c
index e95282b..d1986de 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.c
@@ -462,26 +462,33 @@ static struct iwl_link_quality_cmd *iwl_sta_alloc_lq(struct iwl_priv *priv,
 }
 
 /*
- * iwl_add_local_stations - Add stations not requested by mac80211
+ * iwl_add_local_station - Add stations not requested by mac80211
  *
  * This will be either the broadcast station or the bssid station needed by
  * ad-hoc.
  *
  * Function sleeps.
  */
-int iwl_add_local_station(struct iwl_priv *priv, const u8 *addr, bool init_rs)
+int iwl_add_local_station(struct iwl_priv *priv, const u8 *addr, bool init_rs,
+			  u8 *sta_id_r)
 {
 	int ret;
 	u8 sta_id;
 	struct iwl_link_quality_cmd *link_cmd;
 	unsigned long flags;
 
+	if (*sta_id_r)
+		*sta_id_r = IWL_INVALID_STATION;
+
 	ret = iwl_add_station_common(priv, addr, 0, NULL, &sta_id);
 	if (ret) {
 		IWL_ERR(priv, "Unable to add station %pM\n", addr);
 		return ret;
 	}
 
+	if (sta_id_r)
+		*sta_id_r = sta_id;
+
 	spin_lock_irqsave(&priv->sta_lock, flags);
 	priv->stations[sta_id].used |= IWL_STA_LOCAL;
 	spin_unlock_irqrestore(&priv->sta_lock, flags);
@@ -582,13 +589,11 @@ static int iwl_send_remove_station(struct iwl_priv *priv,
 /**
  * iwl_remove_station - Remove driver's knowledge of station.
  */
-int iwl_remove_station(struct iwl_priv *priv, const u8 *addr)
+int iwl_remove_station(struct iwl_priv *priv, const u8 sta_id,
+		       const u8 *addr)
 {
-	int sta_id = IWL_INVALID_STATION;
-	int i, ret = -EINVAL;
-	unsigned long flags;
-	bool is_ap = priv->iw_mode == NL80211_IFTYPE_STATION;
 	struct iwl_station_entry *station;
+	unsigned long flags;
 
 	if (!iwl_is_ready(priv)) {
 		IWL_DEBUG_INFO(priv,
@@ -602,35 +607,24 @@ int iwl_remove_station(struct iwl_priv *priv, const u8 *addr)
 		return 0;
 	}
 
-	spin_lock_irqsave(&priv->sta_lock, flags);
-
-	if (is_ap)
-		sta_id = IWL_AP_ID;
-	else
-		for (i = IWL_STA_ID; i < priv->hw_params.max_stations; i++)
-			if (priv->stations[i].used &&
-			    !compare_ether_addr(priv->stations[i].sta.sta.addr,
-						addr)) {
-				sta_id = i;
-				break;
-			}
+	IWL_DEBUG_ASSOC(priv, "Removing STA from driver:%d  %pM\n",
+			sta_id, addr);
 
-	if (unlikely(sta_id == IWL_INVALID_STATION))
-		goto out;
+	if (WARN_ON(sta_id == IWL_INVALID_STATION))
+		return -EINVAL;
 
-	IWL_DEBUG_ASSOC(priv, "Removing STA from driver:%d  %pM\n",
-		sta_id, addr);
+	spin_lock_irqsave(&priv->sta_lock, flags);
 
 	if (!(priv->stations[sta_id].used & IWL_STA_DRIVER_ACTIVE)) {
 		IWL_DEBUG_INFO(priv, "Removing %pM but non DRIVER active\n",
 				addr);
-		goto out;
+		goto out_err;
 	}
 
 	if (!(priv->stations[sta_id].used & IWL_STA_UCODE_ACTIVE)) {
 		IWL_DEBUG_INFO(priv, "Removing %pM but non UCODE active\n",
 				addr);
-		goto out;
+		goto out_err;
 	}
 
 	if (priv->stations[sta_id].used & IWL_STA_LOCAL) {
@@ -647,11 +641,10 @@ int iwl_remove_station(struct iwl_priv *priv, const u8 *addr)
 	station = &priv->stations[sta_id];
 	spin_unlock_irqrestore(&priv->sta_lock, flags);
 
-	ret = iwl_send_remove_station(priv, station);
-	return ret;
-out:
+	return iwl_send_remove_station(priv, station);
+out_err:
 	spin_unlock_irqrestore(&priv->sta_lock, flags);
-	return ret;
+	return -EINVAL;
 }
 EXPORT_SYMBOL_GPL(iwl_remove_station);
 
@@ -1467,14 +1460,16 @@ void iwl_sta_modify_sleep_tx_count(struct iwl_priv *priv, int sta_id, int cnt)
 EXPORT_SYMBOL(iwl_sta_modify_sleep_tx_count);
 
 int iwl_mac_sta_remove(struct ieee80211_hw *hw,
-			       struct ieee80211_vif *vif,
-			       struct ieee80211_sta *sta)
+		       struct ieee80211_vif *vif,
+		       struct ieee80211_sta *sta)
 {
-	int ret;
 	struct iwl_priv *priv = hw->priv;
+	struct iwl_station_priv_common *sta_common = (void *)sta->drv_priv;
+	int ret;
+
 	IWL_DEBUG_INFO(priv, "received request to remove station %pM\n",
 			sta->addr);
-	ret = iwl_remove_station(priv, sta->addr);
+	ret = iwl_remove_station(priv, sta_common->sta_id, sta->addr);
 	if (ret)
 		IWL_ERR(priv, "Error removing station %pM\n",
 			sta->addr);
diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.h b/drivers/net/wireless/iwlwifi/iwl-sta.h
index 50c9d51..8efb83d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.h
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.h
@@ -68,12 +68,14 @@ int iwl_get_free_ucode_key_index(struct iwl_priv *priv);
 int iwl_get_sta_id(struct iwl_priv *priv, struct ieee80211_hdr *hdr);
 int iwl_send_add_sta(struct iwl_priv *priv,
 		     struct iwl_addsta_cmd *sta, u8 flags);
-int iwl_add_local_station(struct iwl_priv *priv, const u8 *addr, bool init_rs);
+int iwl_add_local_station(struct iwl_priv *priv, const u8 *addr, bool init_rs,
+			  u8 *sta_id_r);
 int iwl_add_station_common(struct iwl_priv *priv, const u8 *addr,
 				  bool is_ap,
 				  struct ieee80211_sta_ht_cap *ht_info,
 				  u8 *sta_id_r);
-int iwl_remove_station(struct iwl_priv *priv, const u8 *addr);
+int iwl_remove_station(struct iwl_priv *priv, const u8 sta_id,
+		       const u8 *addr);
 int iwl_mac_sta_remove(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 		       struct ieee80211_sta *sta);
 void iwl_sta_tx_modify_enable_tid(struct iwl_priv *priv, int sta_id, int tid);
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 1a44571..48fb59b 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -3378,10 +3378,13 @@ static int iwl3945_mac_sta_add(struct ieee80211_hw *hw,
 			       struct ieee80211_sta *sta)
 {
 	struct iwl_priv *priv = hw->priv;
+	struct iwl3945_sta_priv *sta_priv = (void *)sta->drv_priv;
 	int ret;
-	bool is_ap = priv->iw_mode == NL80211_IFTYPE_STATION;
+	bool is_ap = vif->type == NL80211_IFTYPE_STATION;
 	u8 sta_id;
 
+	sta_priv->common.sta_id = IWL_INVALID_STATION;
+
 	IWL_DEBUG_INFO(priv, "received request to add station %pM\n",
 			sta->addr);
 
@@ -3394,16 +3397,14 @@ static int iwl3945_mac_sta_add(struct ieee80211_hw *hw,
 		return ret;
 	}
 
+	sta_priv->common.sta_id = sta_id;
+
 	/* Initialize rate scaling */
 	IWL_DEBUG_INFO(priv, "Initializing rate scaling for station %pM\n",
 		       sta->addr);
 	iwl3945_rs_rate_init(priv, sta, sta_id);
 
 	return 0;
-
-
-
-	return ret;
 }
 /*****************************************************************************
  *
@@ -3887,6 +3888,7 @@ static int iwl3945_setup_mac(struct iwl_priv *priv)
 
 	hw->rate_control_algorithm = "iwl-3945-rs";
 	hw->sta_data_size = sizeof(struct iwl3945_sta_priv);
+	hw->vif_data_size = sizeof(struct iwl_vif_priv);
 
 	/* Tell mac80211 our characteristics */
 	hw->flags = IEEE80211_HW_SIGNAL_DBM |
-- 
1.6.3.3

