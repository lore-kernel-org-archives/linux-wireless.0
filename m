Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cora.hrz.tu-chemnitz.de ([134.109.228.40]:35100 "EHLO
	cora.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753633Ab3H1Lln (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Aug 2013 07:41:43 -0400
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: [PATCHv4 3/6] mac80211: split off ibss disconnect
Date: Wed, 28 Aug 2013 13:41:30 +0200
Message-Id: <1377690093-27024-4-git-send-email-siwu@hrz.tu-chemnitz.de> (sfid-20130828_134154_834351_0E30E1CA)
In-Reply-To: <1377690093-27024-1-git-send-email-siwu@hrz.tu-chemnitz.de>
References: <1377690093-27024-1-git-send-email-siwu@hrz.tu-chemnitz.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

IBSS CSA will require to disconnect if a channel switch fails, but
mac80211 should search and re-connect after this disconnect. To allow
such usage, split off the ibss disconnect process in a separate function
which only performs the disconnect without overwriting nl80211-supplied
parameters.

Signed-off-by: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Signed-off-by: Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>

---
Changes to PATCHv3:
 * move sta_active_ibss instead of declaring the prototype in the top
---
 net/mac80211/ibss.c |  172 +++++++++++++++++++++++++++------------------------
 1 file changed, 92 insertions(+), 80 deletions(-)

diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index a12afe7..0c3ec08 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -499,6 +499,96 @@ ieee80211_ibss_add_sta(struct ieee80211_sub_if_data *sdata, const u8 *bssid,
 	return ieee80211_ibss_finish_sta(sta);
 }
 
+static int ieee80211_sta_active_ibss(struct ieee80211_sub_if_data *sdata)
+{
+	struct ieee80211_local *local = sdata->local;
+	int active = 0;
+	struct sta_info *sta;
+
+	sdata_assert_lock(sdata);
+
+	rcu_read_lock();
+
+	list_for_each_entry_rcu(sta, &local->sta_list, list) {
+		if (sta->sdata == sdata &&
+		    time_after(sta->last_rx + IEEE80211_IBSS_MERGE_INTERVAL,
+			       jiffies)) {
+			active++;
+			break;
+		}
+	}
+
+	rcu_read_unlock();
+
+	return active;
+}
+
+static void ieee80211_ibss_disconnect(struct ieee80211_sub_if_data *sdata)
+{
+	struct ieee80211_if_ibss *ifibss = &sdata->u.ibss;
+	struct ieee80211_local *local = sdata->local;
+	struct cfg80211_bss *cbss;
+	struct beacon_data *presp;
+	struct sta_info *sta;
+	int active_ibss;
+	u16 capability;
+
+	active_ibss = ieee80211_sta_active_ibss(sdata);
+
+	if (!active_ibss && !is_zero_ether_addr(ifibss->bssid)) {
+		capability = WLAN_CAPABILITY_IBSS;
+
+		if (ifibss->privacy)
+			capability |= WLAN_CAPABILITY_PRIVACY;
+
+		cbss = cfg80211_get_bss(local->hw.wiphy, ifibss->chandef.chan,
+					ifibss->bssid, ifibss->ssid,
+					ifibss->ssid_len, WLAN_CAPABILITY_IBSS |
+					WLAN_CAPABILITY_PRIVACY,
+					capability);
+
+		if (cbss) {
+			cfg80211_unlink_bss(local->hw.wiphy, cbss);
+			cfg80211_put_bss(sdata->local->hw.wiphy, cbss);
+		}
+	}
+
+	ifibss->state = IEEE80211_IBSS_MLME_SEARCH;
+
+	sta_info_flush(sdata);
+
+	spin_lock_bh(&ifibss->incomplete_lock);
+	while (!list_empty(&ifibss->incomplete_stations)) {
+		sta = list_first_entry(&ifibss->incomplete_stations,
+				       struct sta_info, list);
+		list_del(&sta->list);
+		spin_unlock_bh(&ifibss->incomplete_lock);
+
+		sta_info_free(local, sta);
+		spin_lock_bh(&ifibss->incomplete_lock);
+	}
+	spin_unlock_bh(&ifibss->incomplete_lock);
+
+	netif_carrier_off(sdata->dev);
+
+	sdata->vif.bss_conf.ibss_joined = false;
+	sdata->vif.bss_conf.ibss_creator = false;
+	sdata->vif.bss_conf.enable_beacon = false;
+	sdata->vif.bss_conf.ssid_len = 0;
+
+	/* remove beacon */
+	presp = rcu_dereference_protected(ifibss->presp,
+					  lockdep_is_held(&sdata->wdev.mtx));
+	RCU_INIT_POINTER(sdata->u.ibss.presp, NULL);
+	if (presp)
+		kfree_rcu(presp, rcu_head);
+
+	clear_bit(SDATA_STATE_OFFCHANNEL_BEACON_STOPPED, &sdata->state);
+	ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_BEACON_ENABLED |
+						BSS_CHANGED_IBSS);
+	ieee80211_vif_release_channel(sdata);
+}
+
 static void ieee80211_rx_mgmt_deauth_ibss(struct ieee80211_sub_if_data *sdata,
 					  struct ieee80211_mgmt *mgmt,
 					  size_t len)
@@ -775,30 +865,6 @@ void ieee80211_ibss_rx_no_sta(struct ieee80211_sub_if_data *sdata,
 	ieee80211_queue_work(&local->hw, &sdata->work);
 }
 
-static int ieee80211_sta_active_ibss(struct ieee80211_sub_if_data *sdata)
-{
-	struct ieee80211_local *local = sdata->local;
-	int active = 0;
-	struct sta_info *sta;
-
-	sdata_assert_lock(sdata);
-
-	rcu_read_lock();
-
-	list_for_each_entry_rcu(sta, &local->sta_list, list) {
-		if (sta->sdata == sdata &&
-		    time_after(sta->last_rx + IEEE80211_IBSS_MERGE_INTERVAL,
-			       jiffies)) {
-			active++;
-			break;
-		}
-	}
-
-	rcu_read_unlock();
-
-	return active;
-}
-
 static void ieee80211_ibss_sta_expire(struct ieee80211_sub_if_data *sdata)
 {
 	struct ieee80211_local *local = sdata->local;
@@ -1265,73 +1331,19 @@ int ieee80211_ibss_join(struct ieee80211_sub_if_data *sdata,
 int ieee80211_ibss_leave(struct ieee80211_sub_if_data *sdata)
 {
 	struct ieee80211_if_ibss *ifibss = &sdata->u.ibss;
-	struct ieee80211_local *local = sdata->local;
-	struct cfg80211_bss *cbss;
-	u16 capability;
-	int active_ibss;
-	struct sta_info *sta;
-	struct beacon_data *presp;
 
-	active_ibss = ieee80211_sta_active_ibss(sdata);
-
-	if (!active_ibss && !is_zero_ether_addr(ifibss->bssid)) {
-		capability = WLAN_CAPABILITY_IBSS;
-
-		if (ifibss->privacy)
-			capability |= WLAN_CAPABILITY_PRIVACY;
-
-		cbss = cfg80211_get_bss(local->hw.wiphy, ifibss->chandef.chan,
-					ifibss->bssid, ifibss->ssid,
-					ifibss->ssid_len, WLAN_CAPABILITY_IBSS |
-					WLAN_CAPABILITY_PRIVACY,
-					capability);
-
-		if (cbss) {
-			cfg80211_unlink_bss(local->hw.wiphy, cbss);
-			cfg80211_put_bss(local->hw.wiphy, cbss);
-		}
-	}
-
-	ifibss->state = IEEE80211_IBSS_MLME_SEARCH;
-	memset(ifibss->bssid, 0, ETH_ALEN);
+	ieee80211_ibss_disconnect(sdata);
 	ifibss->ssid_len = 0;
-
-	sta_info_flush(sdata);
-
-	spin_lock_bh(&ifibss->incomplete_lock);
-	while (!list_empty(&ifibss->incomplete_stations)) {
-		sta = list_first_entry(&ifibss->incomplete_stations,
-				       struct sta_info, list);
-		list_del(&sta->list);
-		spin_unlock_bh(&ifibss->incomplete_lock);
-
-		sta_info_free(local, sta);
-		spin_lock_bh(&ifibss->incomplete_lock);
-	}
-	spin_unlock_bh(&ifibss->incomplete_lock);
-
-	netif_carrier_off(sdata->dev);
+	memset(ifibss->bssid, 0, ETH_ALEN);
 
 	/* remove beacon */
 	kfree(sdata->u.ibss.ie);
-	presp = rcu_dereference_protected(ifibss->presp,
-					  lockdep_is_held(&sdata->wdev.mtx));
-	RCU_INIT_POINTER(sdata->u.ibss.presp, NULL);
 
 	/* on the next join, re-program HT parameters */
 	memset(&ifibss->ht_capa, 0, sizeof(ifibss->ht_capa));
 	memset(&ifibss->ht_capa_mask, 0, sizeof(ifibss->ht_capa_mask));
 
-	sdata->vif.bss_conf.ibss_joined = false;
-	sdata->vif.bss_conf.ibss_creator = false;
-	sdata->vif.bss_conf.enable_beacon = false;
-	sdata->vif.bss_conf.ssid_len = 0;
-	clear_bit(SDATA_STATE_OFFCHANNEL_BEACON_STOPPED, &sdata->state);
-	ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_BEACON_ENABLED |
-						BSS_CHANGED_IBSS);
-	ieee80211_vif_release_channel(sdata);
 	synchronize_rcu();
-	kfree(presp);
 
 	skb_queue_purge(&sdata->skb_queue);
 
-- 
1.7.10.4

