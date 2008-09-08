Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:23690 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753676AbYIHVcR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Sep 2008 17:32:17 -0400
From: Tomas Winkler <tomas.winkler@intel.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net, yi.zhu@intel.com
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 1/4 V2] mac80211: restructure disassoc/deauth flows
Date: Tue,  9 Sep 2008 00:32:12 +0300
Message-Id: <1220909532-7928-1-git-send-email-tomas.winkler@intel.com> (sfid-20080908_233221_627951_3165AF81)
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch restructure the flow of disassociation and deauthentication
flows to be consistent under all circumstances.
It ensures that BA session is treated down before deauthentication or disassociation,
adds the removal of the obsolete sta form station table and fixes a related bug (sta_info_destroy
without sta_info_unlink) in ieee80211_associated()
and reduce some code duplication

Signed-off-by: Ron Rindjunsky <ron.rindjunsky@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
Fixed commit log

 net/mac80211/mlme.c |   85 ++++++++++++++++++++++++++++++++------------------
 1 files changed, 54 insertions(+), 31 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index c396c35..b36df42 100644
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
@@ -990,6 +976,50 @@ static void ieee80211_send_disassoc(struct ieee80211_sub_if_data *sdata,
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
@@ -1084,7 +1114,6 @@ static void ieee80211_associated(struct ieee80211_sub_if_data *sdata,
 				       "range\n",
 				       sdata->dev->name, print_mac(mac, ifsta->bssid));
 				disassoc = 1;
-				sta_info_unlink(&sta);
 			} else
 				ieee80211_send_probe_req(sdata, ifsta->bssid,
 							 local->scan_ssid,
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
+		ieee80211_set_disassoc(sdata, ifsta, true, true,
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
+	ieee80211_set_disassoc(sdata, ifsta, true, false, 0);
 	ifsta->flags &= ~IEEE80211_STA_AUTHENTICATED;
 }
 
@@ -2008,7 +2033,7 @@ static void ieee80211_rx_mgmt_disassoc(struct ieee80211_sub_if_data *sdata,
 				      IEEE80211_RETRY_AUTH_INTERVAL);
 	}
 
-	ieee80211_set_disassoc(sdata, ifsta, 0);
+	ieee80211_set_disassoc(sdata, ifsta, false, false, 0);
 }
 
 
@@ -3343,8 +3368,8 @@ void ieee80211_sta_work(struct work_struct *work)
 		printk(KERN_DEBUG "%s: privacy configuration mismatch and "
 		       "mixed-cell disabled - disassociate\n", sdata->dev->name);
 
-		ieee80211_send_disassoc(sdata, ifsta, WLAN_REASON_UNSPECIFIED);
-		ieee80211_set_disassoc(sdata, ifsta, 0);
+		ieee80211_set_disassoc(sdata, ifsta, false, true,
+					WLAN_REASON_UNSPECIFIED);
 	}
 }
 
@@ -4379,8 +4404,7 @@ int ieee80211_sta_deauthenticate(struct ieee80211_sub_if_data *sdata, u16 reason
 	    sdata->vif.type != IEEE80211_IF_TYPE_IBSS)
 		return -EINVAL;
 
-	ieee80211_send_deauth(sdata, ifsta, reason);
-	ieee80211_set_disassoc(sdata, ifsta, 1);
+	ieee80211_set_disassoc(sdata, ifsta, true, true, reason);
 	return 0;
 }
 
@@ -4398,8 +4422,7 @@ int ieee80211_sta_disassociate(struct ieee80211_sub_if_data *sdata, u16 reason)
 	if (!(ifsta->flags & IEEE80211_STA_ASSOCIATED))
 		return -1;
 
-	ieee80211_send_disassoc(sdata, ifsta, reason);
-	ieee80211_set_disassoc(sdata, ifsta, 0);
+	ieee80211_set_disassoc(sdata, ifsta, false, true, reason);
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

