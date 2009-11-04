Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:46341 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752400AbZKDNna (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Nov 2009 08:43:30 -0500
Subject: [PATCH] mac80211: make ieee80211_find_sta per virtual interface
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Jouni Malinen <j@w1.fi>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 04 Nov 2009 14:42:28 +0100
Message-ID: <1257342148.28469.92.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since we have a TODO item to make all station
management dependent on virtual interfaces, I
figured I'd start with pushing such a change
to drivers before more drivers start using the
ieee80211_find_sta() API with a hw pointer and
cause us grief later on.

For now continue exporting the old API in form
of ieee80211_find_sta_by_hw(), but discourage
its use strongly.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 drivers/net/wireless/ath/ath9k/recv.c      |    3 ++-
 drivers/net/wireless/ath/ath9k/xmit.c      |    3 ++-
 drivers/net/wireless/iwlwifi/iwl-3945-rs.c |    3 ++-
 drivers/net/wireless/iwlwifi/iwl-core.c    |    2 +-
 drivers/net/wireless/iwlwifi/iwl-sta.c     |    2 +-
 include/net/mac80211.h                     |   25 +++++++++++++++++++++++--
 net/mac80211/sta_info.c                    |   18 ++++++++++++++++--
 7 files changed, 47 insertions(+), 9 deletions(-)

--- wireless-testing.orig/drivers/net/wireless/iwlwifi/iwl-3945-rs.c	2009-11-04 14:14:46.000000000 +0100
+++ wireless-testing/drivers/net/wireless/iwlwifi/iwl-3945-rs.c	2009-11-04 14:15:25.000000000 +0100
@@ -913,7 +913,8 @@ void iwl3945_rate_scale_init(struct ieee
 
 	rcu_read_lock();
 
-	sta = ieee80211_find_sta(hw, priv->stations[sta_id].sta.sta.addr);
+	sta = ieee80211_find_sta(priv->vif,
+				 priv->stations[sta_id].sta.sta.addr);
 	if (!sta) {
 		rcu_read_unlock();
 		return;
--- wireless-testing.orig/drivers/net/wireless/iwlwifi/iwl-core.c	2009-11-04 14:14:49.000000000 +0100
+++ wireless-testing/drivers/net/wireless/iwlwifi/iwl-core.c	2009-11-04 14:15:25.000000000 +0100
@@ -2301,7 +2301,7 @@ static void iwl_ht_conf(struct iwl_priv 
 	switch (priv->iw_mode) {
 	case NL80211_IFTYPE_STATION:
 		rcu_read_lock();
-		sta = ieee80211_find_sta(priv->hw, priv->bssid);
+		sta = ieee80211_find_sta(priv->vif, priv->bssid);
 		if (sta) {
 			struct ieee80211_sta_ht_cap *ht_cap = &sta->ht_cap;
 			int maxstreams;
--- wireless-testing.orig/drivers/net/wireless/iwlwifi/iwl-sta.c	2009-11-04 14:14:47.000000000 +0100
+++ wireless-testing/drivers/net/wireless/iwlwifi/iwl-sta.c	2009-11-04 14:15:25.000000000 +0100
@@ -1017,7 +1017,7 @@ int iwl_rxon_add_station(struct iwl_priv
 	 */
 	if (priv->current_ht_config.is_ht) {
 		rcu_read_lock();
-		sta = ieee80211_find_sta(priv->hw, addr);
+		sta = ieee80211_find_sta(priv->vif, addr);
 		if (sta) {
 			memcpy(&ht_config, &sta->ht_cap, sizeof(ht_config));
 			cur_ht_config = &ht_config;
--- wireless-testing.orig/include/net/mac80211.h	2009-11-04 14:14:50.000000000 +0100
+++ wireless-testing/include/net/mac80211.h	2009-11-04 14:15:25.000000000 +0100
@@ -2106,16 +2106,37 @@ void ieee80211_stop_tx_ba_cb_irqsafe(str
 /**
  * ieee80211_find_sta - find a station
  *
- * @hw: pointer as obtained from ieee80211_alloc_hw()
+ * @vif: virtual interface to look for station on
  * @addr: station's address
  *
  * This function must be called under RCU lock and the
  * resulting pointer is only valid under RCU lock as well.
  */
-struct ieee80211_sta *ieee80211_find_sta(struct ieee80211_hw *hw,
+struct ieee80211_sta *ieee80211_find_sta(struct ieee80211_vif *vif,
 					 const u8 *addr);
 
 /**
+ * ieee80211_find_sta_by_hw - find a station on hardware
+ *
+ * @hw: pointer as obtained from ieee80211_alloc_hw()
+ * @addr: station's address
+ *
+ * This function must be called under RCU lock and the
+ * resulting pointer is only valid under RCU lock as well.
+ *
+ * NOTE: This function should not be used! When mac80211 is converted
+ *	 internally to properly keep track of stations on multiple
+ *	 virtual interfaces, it will not always know which station to
+ *	 return here since a single address might be used by multiple
+ *	 logical stations (e.g. consider a station connecting to another
+ *	 BSSID on the same AP hardware without disconnecting first).
+ *
+ * DO NOT USE THIS FUNCTION.
+ */
+struct ieee80211_sta *ieee80211_find_sta_by_hw(struct ieee80211_hw *hw,
+					       const u8 *addr);
+
+/**
  * ieee80211_beacon_loss - inform hardware does not receive beacons
  *
  * @vif: &struct ieee80211_vif pointer from &struct ieee80211_if_init_conf.
--- wireless-testing.orig/net/mac80211/sta_info.c	2009-11-04 14:14:50.000000000 +0100
+++ wireless-testing/net/mac80211/sta_info.c	2009-11-04 14:33:56.000000000 +0100
@@ -801,8 +801,8 @@ void ieee80211_sta_expire(struct ieee802
 		sta_info_destroy(sta);
 }
 
-struct ieee80211_sta *ieee80211_find_sta(struct ieee80211_hw *hw,
-					 const u8 *addr)
+struct ieee80211_sta *ieee80211_find_sta_by_hw(struct ieee80211_hw *hw,
+					       const u8 *addr)
 {
 	struct sta_info *sta = sta_info_get(hw_to_local(hw), addr);
 
@@ -810,4 +810,18 @@ struct ieee80211_sta *ieee80211_find_sta
 		return NULL;
 	return &sta->sta;
 }
+EXPORT_SYMBOL_GPL(ieee80211_find_sta_by_hw);
+
+struct ieee80211_sta *ieee80211_find_sta(struct ieee80211_vif *vif,
+					 const u8 *addr)
+{
+	struct ieee80211_sub_if_data *sdata;
+
+	if (!vif)
+		return NULL;
+
+	sdata = vif_to_sdata(vif);
+
+	return ieee80211_find_sta_by_hw(&sdata->local->hw, addr);
+}
 EXPORT_SYMBOL(ieee80211_find_sta);
--- wireless-testing.orig/drivers/net/wireless/ath/ath9k/recv.c	2009-11-04 14:14:46.000000000 +0100
+++ wireless-testing/drivers/net/wireless/ath/ath9k/recv.c	2009-11-04 14:16:40.000000000 +0100
@@ -202,7 +202,8 @@ static int ath_rx_prepare(struct sk_buff
 	}
 
 	rcu_read_lock();
-	sta = ieee80211_find_sta(sc->hw, hdr->addr2);
+	/* XXX: use ieee80211_find_sta! */
+	sta = ieee80211_find_sta_by_hw(sc->hw, hdr->addr2);
 	if (sta) {
 		an = (struct ath_node *) sta->drv_priv;
 		if (ds->ds_rxstat.rs_rssi != ATH9K_RSSI_BAD &&
--- wireless-testing.orig/drivers/net/wireless/ath/ath9k/xmit.c	2009-11-04 14:14:46.000000000 +0100
+++ wireless-testing/drivers/net/wireless/ath/ath9k/xmit.c	2009-11-04 14:16:40.000000000 +0100
@@ -282,7 +282,8 @@ static void ath_tx_complete_aggr(struct 
 
 	rcu_read_lock();
 
-	sta = ieee80211_find_sta(sc->hw, hdr->addr1);
+	/* XXX: use ieee80211_find_sta! */
+	sta = ieee80211_find_sta_by_hw(sc->hw, hdr->addr1);
 	if (!sta) {
 		rcu_read_unlock();
 		return;


