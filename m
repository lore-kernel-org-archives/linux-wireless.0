Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:51762 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756340Ab3LEMgF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Dec 2013 07:36:05 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 8/8] mac80211: free all AP/VLAN keys at once
Date: Thu,  5 Dec 2013 13:35:56 +0100
Message-Id: <1386246956-14257-9-git-send-email-johannes@sipsolutions.net> (sfid-20131205_133625_013593_EA235566)
In-Reply-To: <1386246956-14257-1-git-send-email-johannes@sipsolutions.net>
References: <1386192610.5660.4.camel@jlt4.sipsolutions.net>
 <1386246956-14257-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When the AP interface is stopped, free all AP and VLAN keys at
once to only require synchronize_net() once. Since that does
synchronize_net(), also move two such calls into the function
(using the new force_synchronize parameter) to avoid doing it
twice.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/cfg.c   |  5 +----
 net/mac80211/iface.c | 19 ++++++++-----------
 net/mac80211/key.c   | 44 ++++++++++++++++++++++++++++++++------------
 net/mac80211/key.h   |  3 ++-
 4 files changed, 43 insertions(+), 28 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index b045deb2..556809a 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1098,10 +1098,7 @@ static int ieee80211_stop_ap(struct wiphy *wiphy, struct net_device *dev)
 		kfree_rcu(old_probe_resp, rcu_head);
 
 	__sta_info_flush(sdata, true);
-	synchronize_net();
-	list_for_each_entry(vlan, &sdata->u.ap.vlans, u.vlan.list)
-		ieee80211_free_keys(vlan);
-	ieee80211_free_keys(sdata);
+	ieee80211_free_keys(sdata, true);
 
 	sdata->vif.bss_conf.enable_beacon = false;
 	sdata->vif.bss_conf.ssid_len = 0;
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index c5e9a11..3ef9674 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -889,18 +889,15 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata,
 		cancel_work_sync(&sdata->work);
 		/*
 		 * When we get here, the interface is marked down.
+		 * Free the remaining keys, if there are any
+		 * (shouldn't be, except maybe in WDS mode?)
 		 *
-		 * We need synchronize_rcu() to wait for the RX path in
-		 * case it is using the interface and enqueuing frames
-		 * at this very time on another CPU.
+		 * Force the key freeing to always synchronize_net()
+		 * to wait for the RX path in case it is using this
+		 * interface enqueuing frames * at this very time on
+		 * another CPU.
 		 */
-		synchronize_rcu();
-
-		/*
-		 * Free all remaining keys, there shouldn't be any,
-		 * except maybe in WDS mode?
-		 */
-		ieee80211_free_keys(sdata);
+		ieee80211_free_keys(sdata, true);
 
 		/* fall through */
 	case NL80211_IFTYPE_AP:
@@ -1026,7 +1023,7 @@ static void ieee80211_teardown_sdata(struct ieee80211_sub_if_data *sdata)
 	int i;
 
 	/* free extra data */
-	ieee80211_free_keys(sdata);
+	ieee80211_free_keys(sdata, false);
 
 	ieee80211_debugfs_remove_netdev(sdata);
 
diff --git a/net/mac80211/key.c b/net/mac80211/key.c
index 12e6154..6ff65a1 100644
--- a/net/mac80211/key.c
+++ b/net/mac80211/key.c
@@ -589,14 +589,10 @@ void ieee80211_iter_keys(struct ieee80211_hw *hw,
 }
 EXPORT_SYMBOL(ieee80211_iter_keys);
 
-void ieee80211_free_keys(struct ieee80211_sub_if_data *sdata)
+static void ieee80211_free_keys_iface(struct ieee80211_sub_if_data *sdata,
+				      struct list_head *keys)
 {
 	struct ieee80211_key *key, *tmp;
-	LIST_HEAD(keys);
-
-	cancel_delayed_work_sync(&sdata->dec_tailroom_needed_wk);
-
-	mutex_lock(&sdata->local->key_mtx);
 
 	sdata->crypto_tx_tailroom_needed_cnt -=
 		sdata->crypto_tx_tailroom_pending_dec;
@@ -608,21 +604,45 @@ void ieee80211_free_keys(struct ieee80211_sub_if_data *sdata)
 		ieee80211_key_replace(key->sdata, key->sta,
 				key->conf.flags & IEEE80211_KEY_FLAG_PAIRWISE,
 				key, NULL);
-		list_add_tail(&key->list, &keys);
+		list_add_tail(&key->list, keys);
 	}
 
 	ieee80211_debugfs_key_update_default(sdata);
+}
 
-	if (!list_empty(&keys)) {
-		synchronize_net();
-		list_for_each_entry_safe(key, tmp, &keys, list)
-			__ieee80211_key_destroy(key, false);
+void ieee80211_free_keys(struct ieee80211_sub_if_data *sdata,
+			 bool force_synchronize)
+{
+	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_sub_if_data *vlan;
+	struct ieee80211_key *key, *tmp;
+	LIST_HEAD(keys);
+
+	cancel_delayed_work_sync(&sdata->dec_tailroom_needed_wk);
+
+	mutex_lock(&local->key_mtx);
+
+	ieee80211_free_keys_iface(sdata, &keys);
+
+	if (sdata->vif.type == NL80211_IFTYPE_AP) {
+		list_for_each_entry(vlan, &sdata->u.ap.vlans, u.vlan.list)
+			ieee80211_free_keys_iface(vlan, &keys);
 	}
 
+	if (!list_empty(&keys) || force_synchronize)
+		synchronize_net();
+	list_for_each_entry_safe(key, tmp, &keys, list)
+		__ieee80211_key_destroy(key, false);
+
 	WARN_ON_ONCE(sdata->crypto_tx_tailroom_needed_cnt ||
 		     sdata->crypto_tx_tailroom_pending_dec);
+	if (sdata->vif.type == NL80211_IFTYPE_AP) {
+		list_for_each_entry(vlan, &sdata->u.ap.vlans, u.vlan.list)
+			WARN_ON_ONCE(vlan->crypto_tx_tailroom_needed_cnt ||
+				     vlan->crypto_tx_tailroom_pending_dec);
+	}
 
-	mutex_unlock(&sdata->local->key_mtx);
+	mutex_unlock(&local->key_mtx);
 }
 
 void ieee80211_free_sta_keys(struct ieee80211_local *local,
diff --git a/net/mac80211/key.h b/net/mac80211/key.h
index 0aebb88..19db686 100644
--- a/net/mac80211/key.h
+++ b/net/mac80211/key.h
@@ -136,7 +136,8 @@ void ieee80211_set_default_key(struct ieee80211_sub_if_data *sdata, int idx,
 			       bool uni, bool multi);
 void ieee80211_set_default_mgmt_key(struct ieee80211_sub_if_data *sdata,
 				    int idx);
-void ieee80211_free_keys(struct ieee80211_sub_if_data *sdata);
+void ieee80211_free_keys(struct ieee80211_sub_if_data *sdata,
+			 bool force_synchronize);
 void ieee80211_free_sta_keys(struct ieee80211_local *local,
 			     struct sta_info *sta);
 void ieee80211_enable_keys(struct ieee80211_sub_if_data *sdata);
-- 
1.8.4.rc3

