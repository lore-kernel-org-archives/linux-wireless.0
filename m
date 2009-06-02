Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:41410 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751753AbZFBUaD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Jun 2009 16:30:03 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH] mac80211: check for existance sta before adding it
Date: Tue,  2 Jun 2009 16:30:03 -0400
Message-Id: <1243974603-15058-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Lets just check for the STA before its addition through
sta_info_insert() and make this mandatory. It simpifies
code.

In our mac80211 cfg80211 callback for device addition we
also can simplify the code by first checking for the STA
before trying to add it and then checking for -EEXIST which
we were not doing. If that actualy would happen we could
end up potentially with a stale sta and the rate info was
never updated. We should now be updating accordingly.

Since we are making part of the API to check for the STA
prior to addition lets warn in sta_info_insert() if the
sta does already exist instead of passing an -EEXIST.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---

johill, this is what I meant. Still not the right approach?

 net/mac80211/cfg.c      |   33 ++++++++++++++++++---------------
 net/mac80211/mlme.c     |    4 ++++
 net/mac80211/sta_info.c |   18 ++++++++++++++----
 3 files changed, 36 insertions(+), 19 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 77e9ff5..657e6b4 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -717,6 +717,7 @@ static int ieee80211_add_station(struct wiphy *wiphy, struct net_device *dev,
 	struct ieee80211_sub_if_data *sdata;
 	int err;
 	int layer2_update;
+	bool new_sta = true;
 
 	if (params->vlan) {
 		sdata = IEEE80211_DEV_TO_SUB_IF(params->vlan);
@@ -733,9 +734,18 @@ static int ieee80211_add_station(struct wiphy *wiphy, struct net_device *dev,
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
+	} else
+		new_sta = false;
 
 	sta->flags = WLAN_STA_AUTH | WLAN_STA_ASSOC;
 
@@ -746,19 +756,12 @@ static int ieee80211_add_station(struct wiphy *wiphy, struct net_device *dev,
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
+	if (new_sta) {
+		err = sta_info_insert(sta);
+		if (err) {
+			rcu_read_unlock();
+			return err;
 		}
-		rcu_read_unlock();
-		return err;
 	}
 
 	if (layer2_update)
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 509469c..ef79823 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1782,6 +1782,10 @@ static void ieee80211_rx_mgmt_assoc_resp(struct ieee80211_sub_if_data *sdata,
 
 	if (newsta) {
 		int err = sta_info_insert(sta);
+		/*
+		 * Since we checked earlier for this STA and we're under RCU
+		 * this should not happen.
+		 */
 		if (err) {
 			printk(KERN_DEBUG "%s: failed to insert STA entry for"
 			       " the AP (error %d)\n", sdata->dev->name, err);
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index d5611d8..c64a277 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -42,7 +42,9 @@
  * it may not start any mesh peer link management or add encryption keys.
  *
  * When the insertion fails (sta_info_insert()) returns non-zero), the
- * structure will have been freed by sta_info_insert()!
+ * structure will have been freed by sta_info_insert()! You _must_
+ * call sta_info_insert() only prior to first checking if the sta already
+ * exists with sta_info_get().
  *
  * Because there are debugfs entries for each station, and adding those
  * must be able to sleep, it is also possible to "pin" a station entry,
@@ -309,6 +311,11 @@ struct sta_info *sta_info_alloc(struct ieee80211_sub_if_data *sdata,
 	return sta;
 }
 
+/*
+ * Must be called with rcu_read_lock() held, you should also
+ * first check if the STA exists first prior to calling
+ * this routine to add it.
+ */
 int sta_info_insert(struct sta_info *sta)
 {
 	struct ieee80211_local *local = sta->local;
@@ -333,10 +340,13 @@ int sta_info_insert(struct sta_info *sta)
 	}
 
 	spin_lock_irqsave(&local->sta_lock, flags);
-	/* check if STA exists already */
-	if (sta_info_get(local, sta->sta.addr)) {
+	/*
+	 * check if STA exists already - callers should have
+	 * already done this while holding the RCU lock
+	 */
+	if (WARN_ON(sta_info_get(local, sta->sta.addr))) {
 		spin_unlock_irqrestore(&local->sta_lock, flags);
-		err = -EEXIST;
+		err = -EIO;
 		goto out_free;
 	}
 	list_add(&sta->list, &local->sta_list);
-- 
1.6.0.6

