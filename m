Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nick.hrz.tu-chemnitz.de ([134.109.228.11]:55764 "EHLO
	nick.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750861Ab3HSPM2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Aug 2013 11:12:28 -0400
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: [PATCHv3 3/6] mac80211: split off ibss disconnect
Date: Mon, 19 Aug 2013 17:12:17 +0200
Message-Id: <1376925141-15353-4-git-send-email-siwu@hrz.tu-chemnitz.de> (sfid-20130819_171239_427894_3D6E7631)
In-Reply-To: <1376925141-15353-1-git-send-email-siwu@hrz.tu-chemnitz.de>
References: <1376925141-15353-1-git-send-email-siwu@hrz.tu-chemnitz.de>
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
 net/mac80211/ibss.c |  124 ++++++++++++++++++++++++++++-----------------------
 1 file changed, 69 insertions(+), 55 deletions(-)

diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index 74de0f1..6507351 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -34,6 +34,8 @@
 
 #define IEEE80211_IBSS_MAX_STA_ENTRIES 128
 
+static int ieee80211_sta_active_ibss(struct ieee80211_sub_if_data *sdata);
+
 static struct beacon_data *
 ieee80211_ibss_build_presp(struct ieee80211_sub_if_data *sdata,
 			   const int beacon_int, const u32 basic_rates,
@@ -474,6 +476,71 @@ ieee80211_ibss_add_sta(struct ieee80211_sub_if_data *sdata, const u8 *bssid,
 	return ieee80211_ibss_finish_sta(sta);
 }
 
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
+}
+
 static void ieee80211_rx_mgmt_deauth_ibss(struct ieee80211_sub_if_data *sdata,
 					  struct ieee80211_mgmt *mgmt,
 					  size_t len)
@@ -1240,72 +1307,19 @@ int ieee80211_ibss_join(struct ieee80211_sub_if_data *sdata,
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
 	synchronize_rcu();
-	kfree(presp);
 
 	skb_queue_purge(&sdata->skb_queue);
 
-- 
1.7.10.4

