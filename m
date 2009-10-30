Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:41357 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756711AbZJ3J6l (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Oct 2009 05:58:41 -0400
Subject: [RFC] mac80211: make ieee80211_find_sta per virtual interface
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: Jouni Malinen <Jouni.Malinen@Atheros.com>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	Sujith Manoharan <Sujith.Manoharan@atheros.com>,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>,
	Senthil Balasubramanian <senthilkumar@atheros.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 30 Oct 2009 10:58:42 +0100
Message-ID: <1256896722.3555.39.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since we have a TODO item to make all station
management dependent on virtual interfaces, I
figured I'd start with pushing such a change
to drivers before more drivers use this kind
of functionality...

The iwlwifi bits are easy, but I don't know
what to do about the ath9k bits. Any ideas?
---
 drivers/net/wireless/ath/ath9k/recv.c      |    2 +-
 drivers/net/wireless/ath/ath9k/xmit.c      |    2 +-
 drivers/net/wireless/iwlwifi/iwl-3945-rs.c |    3 ++-
 drivers/net/wireless/iwlwifi/iwl-core.c    |    2 +-
 drivers/net/wireless/iwlwifi/iwl-sta.c     |    2 +-
 include/net/mac80211.h                     |    4 ++--
 net/mac80211/sta_info.c                    |    7 +++++--
 7 files changed, 13 insertions(+), 9 deletions(-)

--- wireless-testing.orig/drivers/net/wireless/iwlwifi/iwl-3945-rs.c	2009-10-30 10:54:30.000000000 +0100
+++ wireless-testing/drivers/net/wireless/iwlwifi/iwl-3945-rs.c	2009-10-30 10:54:46.000000000 +0100
@@ -960,7 +960,8 @@ void iwl3945_rate_scale_init(struct ieee
 
 	rcu_read_lock();
 
-	sta = ieee80211_find_sta(hw, priv->stations[sta_id].sta.sta.addr);
+	sta = ieee80211_find_sta(priv->vif,
+				 priv->stations[sta_id].sta.sta.addr);
 	if (!sta) {
 		rcu_read_unlock();
 		return;
--- wireless-testing.orig/drivers/net/wireless/iwlwifi/iwl-core.c	2009-10-30 10:54:50.000000000 +0100
+++ wireless-testing/drivers/net/wireless/iwlwifi/iwl-core.c	2009-10-30 10:54:56.000000000 +0100
@@ -2338,7 +2338,7 @@ static void iwl_ht_conf(struct iwl_priv 
 	switch (priv->iw_mode) {
 	case NL80211_IFTYPE_STATION:
 		rcu_read_lock();
-		sta = ieee80211_find_sta(priv->hw, priv->bssid);
+		sta = ieee80211_find_sta(priv->vif, priv->bssid);
 		if (sta) {
 			struct ieee80211_sta_ht_cap *ht_cap = &sta->ht_cap;
 			int maxstreams;
--- wireless-testing.orig/drivers/net/wireless/iwlwifi/iwl-sta.c	2009-10-30 10:55:00.000000000 +0100
+++ wireless-testing/drivers/net/wireless/iwlwifi/iwl-sta.c	2009-10-30 10:55:03.000000000 +0100
@@ -1012,7 +1012,7 @@ int iwl_rxon_add_station(struct iwl_priv
 	 */
 	if (priv->current_ht_config.is_ht) {
 		rcu_read_lock();
-		sta = ieee80211_find_sta(priv->hw, addr);
+		sta = ieee80211_find_sta(priv->vif, addr);
 		if (sta) {
 			memcpy(&ht_config, &sta->ht_cap, sizeof(ht_config));
 			cur_ht_config = &ht_config;
--- wireless-testing.orig/include/net/mac80211.h	2009-10-30 10:51:36.000000000 +0100
+++ wireless-testing/include/net/mac80211.h	2009-10-30 10:51:58.000000000 +0100
@@ -2106,13 +2106,13 @@ void ieee80211_stop_tx_ba_cb_irqsafe(str
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
--- wireless-testing.orig/net/mac80211/sta_info.c	2009-10-30 10:52:13.000000000 +0100
+++ wireless-testing/net/mac80211/sta_info.c	2009-10-30 10:53:07.000000000 +0100
@@ -801,10 +801,13 @@ void ieee80211_sta_expire(struct ieee802
 		sta_info_destroy(sta);
 }
 
-struct ieee80211_sta *ieee80211_find_sta(struct ieee80211_hw *hw,
+struct ieee80211_sta *ieee80211_find_sta(struct ieee80211_vif *vif,
 					 const u8 *addr)
 {
-	struct sta_info *sta = sta_info_get(hw_to_local(hw), addr);
+	struct ieee80211_sub_if_data *sdata = vif_to_sdata(vif);
+	struct sta_info *sta;
+
+	sta = sta_info_get(sdata->local, addr);
 
 	if (!sta)
 		return NULL;
--- wireless-testing.orig/drivers/net/wireless/ath/ath9k/recv.c	2009-10-30 10:53:27.000000000 +0100
+++ wireless-testing/drivers/net/wireless/ath/ath9k/recv.c	2009-10-30 10:55:38.000000000 +0100
@@ -202,7 +202,7 @@ static int ath_rx_prepare(struct sk_buff
 	}
 
 	rcu_read_lock();
-	sta = ieee80211_find_sta(sc->hw, hdr->addr2);
+	sta = ieee80211_find_sta(/*?????*/, hdr->addr2);
 	if (sta) {
 		an = (struct ath_node *) sta->drv_priv;
 		if (ds->ds_rxstat.rs_rssi != ATH9K_RSSI_BAD &&
--- wireless-testing.orig/drivers/net/wireless/ath/ath9k/xmit.c	2009-10-30 10:54:10.000000000 +0100
+++ wireless-testing/drivers/net/wireless/ath/ath9k/xmit.c	2009-10-30 10:55:48.000000000 +0100
@@ -282,7 +282,7 @@ static void ath_tx_complete_aggr(struct 
 
 	rcu_read_lock();
 
-	sta = ieee80211_find_sta(sc->hw, hdr->addr1);
+	sta = ieee80211_find_sta(/*??????*/, hdr->addr1);
 	if (!sta) {
 		rcu_read_unlock();
 		return;


