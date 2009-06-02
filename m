Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:52448 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754522AbZFBBXv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Jun 2009 21:23:51 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net,
	Jouni.Malinen@atheros.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [RFC] mac80211: handle -EXIST on sta_info_insert()
Date: Mon,  1 Jun 2009 21:23:48 -0400
Message-Id: <1243905828-21933-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There's a few places where we either did not rcu_read_lock()
prior to addition of a a new sta or we allocated it before
checking for its existance. In most places, like device open
and close we should have at least some guarantee the stas are
wiped but in other places this could not be the case.

Lets protect against RCU in the missing places. The only
place I see is is in ieee80211_rx_bss_info(). Not sure
we are calling ieee80211_ibss_add_sta() twice there though.

In our mac80211 cfg80211 callback for device addition we
also can simplify the code by first checking for the STA
before trying to add it and then checking for -EEXIST which
we were not doing. If that actualy would happen we could
end up potentially with a stale sta and the rate info was
never updated. It seems cleaner to check for the sta first.

Lastly, we add a WARN_ON() on the STA mlme path upon call to
ieee80211_rx_mgmt_assoc_resp() for -EEXIST. This should not
happen, we could just return -EIO or simply ignore it.

Thoughts?

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index d2fc18c..85fbd37 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -718,6 +718,7 @@ static int ieee80211_add_station(struct wiphy *wiphy, struct net_device *dev,
 	struct ieee80211_sub_if_data *sdata;
 	int err;
 	int layer2_update;
+	bool new_sta = true;
 
 	if (params->vlan) {
 		sdata = IEEE80211_DEV_TO_SUB_IF(params->vlan);
@@ -734,9 +735,19 @@ static int ieee80211_add_station(struct wiphy *wiphy, struct net_device *dev,
 	if (is_multicast_ether_addr(mac))
 		return -EINVAL;
 
-	sta = sta_info_alloc(sdata, mac, GFP_KERNEL);
-	if (!sta)
-		return -ENOMEM;
+	rcu_read_lock();
+
+	sta = sta_info_get(local, mac);
+
+	if (!sta) {
+		sta = sta_info_alloc(sdata, mac, GFP_KERNEL);
+		if (!sta) {
+			rcu_read_unlock();
+			return -ENOMEM;
+		}
+	}
+	else
+		new_sta = false
 
 	sta->flags = WLAN_STA_AUTH | WLAN_STA_ASSOC;
 
@@ -747,19 +758,9 @@ static int ieee80211_add_station(struct wiphy *wiphy, struct net_device *dev,
 	layer2_update = sdata->vif.type == NL80211_IFTYPE_AP_VLAN ||
 		sdata->vif.type == NL80211_IFTYPE_AP;
 
-	rcu_read_lock();
-
-	err = sta_info_insert(sta);
-	if (err) {
-		/* STA has been freed */
-		if (err == -EEXIST && layer2_update) {
-			/* Need to update layer 2 devices on reassociation */
-			sta = sta_info_get(local, mac);
-			if (sta)
-				ieee80211_send_layer2_update(sta);
-		}
+	if (new_sta && (sta_info_insert(sta))) {
 		rcu_read_unlock();
-		return err;
+		return -EIO;
 	}
 
 	if (layer2_update)
diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index 0b30277..446cada 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -365,7 +365,9 @@ static void ieee80211_rx_bss_info(struct ieee80211_sub_if_data *sdata,
 		       sdata->dev->name, mgmt->bssid);
 #endif
 		ieee80211_sta_join_ibss(sdata, bss);
+		rcu_read_lock();
 		ieee80211_ibss_add_sta(sdata, mgmt->bssid, mgmt->sa, supp_rates);
+		rcu_read_unlock();
 	}
 
  put_bss:
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 509469c..6a91751 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1782,6 +1782,11 @@ static void ieee80211_rx_mgmt_assoc_resp(struct ieee80211_sub_if_data *sdata,
 
 	if (newsta) {
 		int err = sta_info_insert(sta);
+		/*
+		 * Since we checked earlier for this STA and we're under RCU
+		 * this should not happen.
+		 */
+		WARN_ON(err == -EEXIST);
 		if (err) {
 			printk(KERN_DEBUG "%s: failed to insert STA entry for"
 			       " the AP (error %d)\n", sdata->dev->name, err);
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index d5611d8..ec7c4ea 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -42,7 +42,8 @@
  * it may not start any mesh peer link management or add encryption keys.
  *
  * When the insertion fails (sta_info_insert()) returns non-zero), the
- * structure will have been freed by sta_info_insert()!
+ * structure will have been freed by sta_info_insert()! If the sta is
+ * already present you will get -EEXIST and should handle this accordingly.
  *
  * Because there are debugfs entries for each station, and adding those
  * must be able to sleep, it is also possible to "pin" a station entry,
