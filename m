Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:33865 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752730AbYIFWOY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Sep 2008 18:14:24 -0400
From: Tomas Winkler <tomas.winkler@intel.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net, yi.zhu@intel.com
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [RFC PATCH 1/3] mac80211: restructure disassoc/deauth flows
Date: Sun,  7 Sep 2008 01:14:17 +0300
Message-Id: <1220739259-16918-2-git-send-email-tomas.winkler@intel.com> (sfid-20080907_001428_136749_6D419236)
In-Reply-To: <1220739259-16918-1-git-send-email-tomas.winkler@intel.com>
References: <1220739259-16918-1-git-send-email-tomas.winkler@intel.com>
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch restructure the flow of disassociation and deauthentication
flows, and adds the removal of the obsolete sta form station table

Signed-off-by: Ron Rindjunsky <ron.rindjunsky@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 net/mac80211/mlme.c |   83 ++++++++++++++++++++++++++++++++------------------
 1 files changed, 53 insertions(+), 30 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index c396c35..ba255e2 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -561,8 +561,6 @@ static void ieee80211_set_associated(struct ieee80211_sub_if_data *sdata,
 		memcpy(wrqu.ap_addr.sa_data, sdata->u.sta.bssid, ETH_ALEN);
 		ieee80211_sta_send_associnfo(sdata, ifsta);
 	} else {
-		netif_carrier_off(sdata->dev);
-		ieee80211_sta_tear_down_BA_sessions(sdata, ifsta->bssid);
 		ifsta->flags &= ~IEEE80211_STA_ASSOCIATED;
 		changed |= ieee80211_reset_erp_info(sdata);
 
@@ -585,18 +583,6 @@ static void ieee80211_set_associated(struct ieee80211_sub_if_data *sdata,
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
@@ -990,6 +976,49 @@ static void ieee80211_send_disassoc(struct ieee80211_sub_if_data *sdata,
 	ieee80211_sta_tx(sdata, skb, 0);
 }
 
+static void ieee80211_set_disassoc(struct ieee80211_sub_if_data *sdata,
+				   struct ieee80211_if_sta *ifsta, int deauth,
+				   int self_disconnected, u16 reason)
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
+	rcu_read_unlock();
+
+	sta_info_unlink(&sta);
+	sta_info_destroy(sta);
+}
 
 static int ieee80211_privacy_mismatch(struct ieee80211_sub_if_data *sdata,
 				      struct ieee80211_if_sta *ifsta)
@@ -1104,16 +1133,12 @@ static void ieee80211_associated(struct ieee80211_sub_if_data *sdata,
 
 	rcu_read_unlock();
 
-	if (disassoc && sta)
-		sta_info_destroy(sta);
-
-	if (disassoc) {
-		ifsta->state = IEEE80211_STA_MLME_DISABLED;
-		ieee80211_set_associated(sdata, ifsta, 0);
-	} else {
+	if (disassoc)
+		ieee80211_set_disassoc(sdata, ifsta, 1, 1,
+					WLAN_REASON_PREV_AUTH_NOT_VALID);
+	else
 		mod_timer(&ifsta->timer, jiffies +
 				      IEEE80211_MONITORING_INTERVAL);
-	}
 }
 
 
@@ -1978,7 +2003,7 @@ static void ieee80211_rx_mgmt_deauth(struct ieee80211_sub_if_data *sdata,
 				      IEEE80211_RETRY_AUTH_INTERVAL);
 	}
 
-	ieee80211_set_disassoc(sdata, ifsta, 1);
+	ieee80211_set_disassoc(sdata, ifsta, 1, 0, 0);
 	ifsta->flags &= ~IEEE80211_STA_AUTHENTICATED;
 }
 
@@ -2008,7 +2033,7 @@ static void ieee80211_rx_mgmt_disassoc(struct ieee80211_sub_if_data *sdata,
 				      IEEE80211_RETRY_AUTH_INTERVAL);
 	}
 
-	ieee80211_set_disassoc(sdata, ifsta, 0);
+	ieee80211_set_disassoc(sdata, ifsta, 0, 0, 0);
 }
 
 
@@ -3343,8 +3368,8 @@ void ieee80211_sta_work(struct work_struct *work)
 		printk(KERN_DEBUG "%s: privacy configuration mismatch and "
 		       "mixed-cell disabled - disassociate\n", sdata->dev->name);
 
-		ieee80211_send_disassoc(sdata, ifsta, WLAN_REASON_UNSPECIFIED);
-		ieee80211_set_disassoc(sdata, ifsta, 0);
+		ieee80211_set_disassoc(sdata, ifsta, 0, 1,
+					WLAN_REASON_UNSPECIFIED);
 	}
 }
 
@@ -4379,8 +4404,7 @@ int ieee80211_sta_deauthenticate(struct ieee80211_sub_if_data *sdata, u16 reason
 	    sdata->vif.type != IEEE80211_IF_TYPE_IBSS)
 		return -EINVAL;
 
-	ieee80211_send_deauth(sdata, ifsta, reason);
-	ieee80211_set_disassoc(sdata, ifsta, 1);
+	ieee80211_set_disassoc(sdata, ifsta, 1, 1, reason);
 	return 0;
 }
 
@@ -4398,8 +4422,7 @@ int ieee80211_sta_disassociate(struct ieee80211_sub_if_data *sdata, u16 reason)
 	if (!(ifsta->flags & IEEE80211_STA_ASSOCIATED))
 		return -1;
 
-	ieee80211_send_disassoc(sdata, ifsta, reason);
-	ieee80211_set_disassoc(sdata, ifsta, 0);
+	ieee80211_set_disassoc(sdata, ifsta, 0, 1, reason);
 	return 0;
 }
 
-- 
1.5.4.1

---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

