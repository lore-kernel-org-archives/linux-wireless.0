Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:43473 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750985AbYIHPhN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Sep 2008 11:37:13 -0400
Message-Id: <20080908153508.413468000@sipsolutions.net> (sfid-20080908_173718_189705_310288DE)
References: <20080908153336.891710000@sipsolutions.net>
Date: Mon, 08 Sep 2008 17:33:37 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, tomasw@gmail.com,
	Ron Rindjunsky <ron.rindjunsky@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 1/4] mac80211: restructure disassoc/deauth flows
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch restructures disassociation and deauthentication to be
consistent under all circumstances and adds the removal of the APs
sta_info from the station table.

Signed-off-by: Ron Rindjunsky <ron.rindjunsky@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/mlme.c |   85 +++++++++++++++++++++++++++++++++-------------------
 1 file changed, 54 insertions(+), 31 deletions(-)

--- everything.orig/net/mac80211/mlme.c	2008-09-08 16:37:58.000000000 +0200
+++ everything/net/mac80211/mlme.c	2008-09-08 16:39:55.000000000 +0200
@@ -416,8 +416,6 @@ static void ieee80211_set_associated(str
 		memcpy(wrqu.ap_addr.sa_data, sdata->u.sta.bssid, ETH_ALEN);
 		ieee80211_sta_send_associnfo(sdata, ifsta);
 	} else {
-		netif_carrier_off(sdata->dev);
-		ieee80211_sta_tear_down_BA_sessions(sdata, ifsta->bssid);
 		ifsta->flags &= ~IEEE80211_STA_ASSOCIATED;
 		changed |= ieee80211_reset_erp_info(sdata);
 
@@ -440,18 +438,6 @@ static void ieee80211_set_associated(str
 	wireless_send_event(sdata->dev, SIOCGIWAP, &wrqu, NULL);
 }
 
-static void ieee80211_set_disassoc(struct ieee80211_sub_if_data *sdata,
-				   struct ieee80211_if_sta *ifsta, int deauth)
-{
-	if (deauth) {
-		ifsta->direct_probe_tries = 0;
-		ifsta->auth_tries = 0;
-	}
-	ifsta->assoc_scan_tries = 0;
-	ifsta->assoc_tries = 0;
-	ieee80211_set_associated(sdata, ifsta, 0);
-}
-
 void ieee80211_sta_tx(struct ieee80211_sub_if_data *sdata, struct sk_buff *skb,
 		      int encrypt)
 {
@@ -845,6 +831,50 @@ static void ieee80211_send_disassoc(stru
 	ieee80211_sta_tx(sdata, skb, 0);
 }
 
+static void ieee80211_set_disassoc(struct ieee80211_sub_if_data *sdata,
+				   struct ieee80211_if_sta *ifsta, bool deauth,
+				   bool self_disconnected, u16 reason)
+{
+	struct ieee80211_local *local = sdata->local;
+	struct sta_info *sta;
+
+	rcu_read_lock();
+
+	sta = sta_info_get(local, ifsta->bssid);
+	if (!sta) {
+		rcu_read_unlock();
+		return;
+	}
+
+	if (deauth) {
+		ifsta->direct_probe_tries = 0;
+		ifsta->auth_tries = 0;
+	}
+	ifsta->assoc_scan_tries = 0;
+	ifsta->assoc_tries = 0;
+
+	netif_carrier_off(sdata->dev);
+
+	ieee80211_sta_tear_down_BA_sessions(sdata, sta->addr);
+
+	if (self_disconnected) {
+		if (deauth)
+			ieee80211_send_deauth(sdata, ifsta, reason);
+		else
+			ieee80211_send_disassoc(sdata, ifsta, reason);
+	}
+
+	ieee80211_set_associated(sdata, ifsta, 0);
+
+	if (self_disconnected)
+		ifsta->state = IEEE80211_STA_MLME_DISABLED;
+
+	sta_info_unlink(&sta);
+
+	rcu_read_unlock();
+
+	sta_info_destroy(sta);
+}
 
 static int ieee80211_privacy_mismatch(struct ieee80211_sub_if_data *sdata,
 				      struct ieee80211_if_sta *ifsta)
@@ -939,7 +969,6 @@ static void ieee80211_associated(struct 
 				       "range\n",
 				       sdata->dev->name, print_mac(mac, ifsta->bssid));
 				disassoc = 1;
-				sta_info_unlink(&sta);
 			} else
 				ieee80211_send_probe_req(sdata, ifsta->bssid,
 							 local->scan_ssid,
@@ -959,16 +988,12 @@ static void ieee80211_associated(struct 
 
 	rcu_read_unlock();
 
-	if (disassoc && sta)
-		sta_info_destroy(sta);
-
-	if (disassoc) {
-		ifsta->state = IEEE80211_STA_MLME_DISABLED;
-		ieee80211_set_associated(sdata, ifsta, 0);
-	} else {
+	if (disassoc)
+		ieee80211_set_disassoc(sdata, ifsta, true, true,
+					WLAN_REASON_PREV_AUTH_NOT_VALID);
+	else
 		mod_timer(&ifsta->timer, jiffies +
 				      IEEE80211_MONITORING_INTERVAL);
-	}
 }
 
 
@@ -1833,7 +1858,7 @@ static void ieee80211_rx_mgmt_deauth(str
 				      IEEE80211_RETRY_AUTH_INTERVAL);
 	}
 
-	ieee80211_set_disassoc(sdata, ifsta, 1);
+	ieee80211_set_disassoc(sdata, ifsta, true, false, 0);
 	ifsta->flags &= ~IEEE80211_STA_AUTHENTICATED;
 }
 
@@ -1863,7 +1888,7 @@ static void ieee80211_rx_mgmt_disassoc(s
 				      IEEE80211_RETRY_AUTH_INTERVAL);
 	}
 
-	ieee80211_set_disassoc(sdata, ifsta, 0);
+	ieee80211_set_disassoc(sdata, ifsta, false, false, 0);
 }
 
 
@@ -3201,8 +3226,8 @@ void ieee80211_sta_work(struct work_stru
 		printk(KERN_DEBUG "%s: privacy configuration mismatch and "
 		       "mixed-cell disabled - disassociate\n", sdata->dev->name);
 
-		ieee80211_send_disassoc(sdata, ifsta, WLAN_REASON_UNSPECIFIED);
-		ieee80211_set_disassoc(sdata, ifsta, 0);
+		ieee80211_set_disassoc(sdata, ifsta, false, true,
+					WLAN_REASON_UNSPECIFIED);
 	}
 }
 
@@ -4237,8 +4262,7 @@ int ieee80211_sta_deauthenticate(struct 
 	    sdata->vif.type != IEEE80211_IF_TYPE_IBSS)
 		return -EINVAL;
 
-	ieee80211_send_deauth(sdata, ifsta, reason);
-	ieee80211_set_disassoc(sdata, ifsta, 1);
+	ieee80211_set_disassoc(sdata, ifsta, true, true, reason);
 	return 0;
 }
 
@@ -4256,8 +4280,7 @@ int ieee80211_sta_disassociate(struct ie
 	if (!(ifsta->flags & IEEE80211_STA_ASSOCIATED))
 		return -1;
 
-	ieee80211_send_disassoc(sdata, ifsta, reason);
-	ieee80211_set_disassoc(sdata, ifsta, 0);
+	ieee80211_set_disassoc(sdata, ifsta, false, true, reason);
 	return 0;
 }
 

-- 

