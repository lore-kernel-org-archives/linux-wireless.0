Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5616190462
	for <linux-wireless@vger.kernel.org>; Wed, 14 Oct 2026 20:23:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792009413; cv=none; b=lkss9N59+C5igFZQ3KtXLmKxP0/YmEEX0jvbJdHC48+WMbBfHMwed7rvz/obuTT1dw1qCVFbFz+qD3ET3j2yD5FwhG5C4kvENcAwGKNP1CCZRdPFGTJm914VV6e4mCqW2+9eH+yTs40t9VfbUsDC24rtu+hRwUHijo3c9C7SzD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792009413; c=relaxed/simple;
	bh=6igTCjsttsX3Qgz9ci6yB8f3GTVPHooKAtrjLcsh7mY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=XWx0J6cdUe6tdrHGx25KHH5BcMQ41JAJAVXQjRJL0sVP72+MafGHrvo3zAsSM+aRgPoI8oUf5aOIMxTGt7ovKqfQ53vI0psym9xtUNY/hmfZZtKnjM6pw3XMBU5F1QMIeHLJtpaM40d0LU2kHmJ0t6mCPaYQVcPNmcaJgIQYc0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=vacxkuw7; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="vacxkuw7"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-To:Resent-Cc:
	Resent-Message-ID:In-Reply-To:References;
	bh=euxtkeT7T+DUat5vLhk0XYem2qGRwxBQUEmPtiMXkIg=; t=1792009411; x=1793219011; 
	b=vacxkuw7UYRlw3fG74O9GXooRqK0yfDI7gAiYvEq/U0Dp8HnuVkxuZXKBIU9KTxzs8QDedn4UsM
	+g6CENKwUEM2c+wETnTQW0/Nop2BlH/emE9jtwwo76SiGwz8RzAyOk3V1kZNudS/RWlzCX9J2pBex
	BMb0k/74oQWG+aheD0x0WmNK1y9wIb34EWecpRL0sKzDmr2ugR0zfmI12prPFm/0aMVIm07O296Ha
	IpLH6bkdNFFZ1lb4SuxkbOUDwszmQq0fN8mEcX618voMjC35KN2qGpQ67VgQjLBWq/nHsWbp9T1ev
	3pJI8oE01xuoH5bhwUkVJRVvVlpVfDhRDDcQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xH5VX-0000000254S-2sio;
	Wed, 14 Oct 2026 22:23:28 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [RFC PATCH 1/2] wifi: mac80211: free keys asynchronously
Date: Wed, 14 Oct 2026 22:23:24 +0200
Message-ID: <20261014222324.2c196424ccd3.Ieaf95b8e1336f07866f54d174f699c6aa079d9b8@changeid>
X-Mailer: git-send-email 2.56.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

When a key is removed, we free it after a synchronize_net()
(which may be amortized with other calls thereof), so if it
was still being used under RCU, that code can no longer do
so. This can delay some operations significantly.

However, it's not really required that we do this, it'll be
concurrent with TX so we can just pretend the key is still
there as far as the concurrent TX is concerned and free it
asynchronously after a grace period.

This currently requires an RCU work item due to crypto TFMs,
but that can go away too once we convert to the library.
This then implies an rcu_barrier() before flushing the WQ to
ensure everything that must run on there actually will.

We also no longer need the STA's key_destroy_list, since
that just handled the collection and combined freeing of
the keys after synchronize_net().

Assisted-by: LLM
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/cfg.c      |  5 +----
 net/mac80211/key.c      | 45 ++++++++++++-----------------------------
 net/mac80211/key.h      |  3 ++-
 net/mac80211/main.c     |  2 ++
 net/mac80211/sta_info.c |  4 ----
 net/mac80211/sta_info.h |  3 ---
 6 files changed, 18 insertions(+), 44 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 1d6dd26bff2a..2ae9326deb68 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -2349,10 +2349,7 @@ static int ieee80211_stop_ap(struct wiphy *wiphy, struct net_device *dev,
 	ieee80211_link_info_change_notify(sdata, link, changes);
 
 	ieee80211_remove_link_keys(link, &keys);
-	if (!list_empty(&keys)) {
-		synchronize_net();
-		ieee80211_free_key_list(local, &keys);
-	}
+	ieee80211_free_key_list(local, &keys);
 
 	if (sdata->wdev.links[link_id].cac_started) {
 		chandef = link_conf->chanreq.oper;
diff --git a/net/mac80211/key.c b/net/mac80211/key.c
index 436a165d0b91..b66168edab25 100644
--- a/net/mac80211/key.c
+++ b/net/mac80211/key.c
@@ -864,31 +864,24 @@ static void ieee80211_key_free_common(struct ieee80211_key *key)
 	kfree_sensitive(key);
 }
 
-static void __ieee80211_key_cleanup(struct ieee80211_key *key)
+static void ieee80211_key_free_work(struct work_struct *wk)
 {
-	if (key->local)
-		ieee80211_debugfs_key_remove(key);
-}
-
-static void __ieee80211_key_destroy(struct ieee80211_key *key)
-{
-	__ieee80211_key_cleanup(key);
+	struct ieee80211_key *key;
 
+	key = container_of(to_rcu_work(wk), struct ieee80211_key, free_work);
 	ieee80211_key_free_common(key);
 }
 
+/* the key must no longer be reachable, it's freed after an RCU grace period */
 static void ieee80211_key_destroy(struct ieee80211_key *key)
 {
 	if (!key)
 		return;
 
-	/*
-	 * Synchronize so the TX path can no longer be using this
-	 * key before we free/remove it.
-	 */
-	synchronize_net();
+	ieee80211_debugfs_key_remove(key);
 
-	__ieee80211_key_destroy(key);
+	INIT_RCU_WORK(&key->free_work, ieee80211_key_free_work);
+	queue_rcu_work(key->local->workqueue, &key->free_work);
 }
 
 void ieee80211_key_free_unused(struct ieee80211_key *key)
@@ -1233,7 +1226,7 @@ void ieee80211_free_key_list(struct ieee80211_local *local,
 	lockdep_assert_wiphy(local->hw.wiphy);
 
 	list_for_each_entry_safe(key, tmp, keys, list)
-		__ieee80211_key_destroy(key);
+		ieee80211_key_destroy(key);
 }
 
 void ieee80211_free_keys(struct ieee80211_sub_if_data *sdata,
@@ -1259,10 +1252,10 @@ void ieee80211_free_keys(struct ieee80211_sub_if_data *sdata,
 
 	WARN_ON(!list_empty(&sdata->key_list));
 
-	if (!list_empty(&keys) || force_synchronize)
+	if (force_synchronize)
 		synchronize_net();
 	list_for_each_entry_safe(key, tmp, &keys, list)
-		__ieee80211_key_destroy(key);
+		ieee80211_key_destroy(key);
 
 	if (sdata->vif.type == NL80211_IFTYPE_AP_VLAN) {
 		if (sdata->bss) {
@@ -1304,8 +1297,7 @@ void ieee80211_unlink_link_sta_keys(struct ieee80211_local *local,
 		ret = ieee80211_key_replace(key->sdata, &slot, key, NULL);
 		if (WARN(ret, "failed to remove STA link key (%d)\n", ret))
 			continue;
-		list_add(&key->list, &link_sta->key_destroy_list);
-		__ieee80211_key_cleanup(key);
+		ieee80211_key_destroy(key);
 	}
 
 	for (int i = 0; i < ARRAY_SIZE(link_sta->rx_cigtk); i++) {
@@ -1319,18 +1311,7 @@ void ieee80211_unlink_link_sta_keys(struct ieee80211_local *local,
 		ret = ieee80211_key_replace(key->sdata, &slot, key, NULL);
 		if (WARN(ret, "failed to remove STA link key (%d)\n", ret))
 			continue;
-		list_add(&key->list, &link_sta->key_destroy_list);
-		__ieee80211_key_cleanup(key);
-	}
-}
-
-void ieee80211_free_link_sta_keys(struct link_sta_info *link_sta)
-{
-	struct ieee80211_key *key, *tmp;
-
-	list_for_each_entry_safe(key, tmp, &link_sta->key_destroy_list, list) {
-		list_del(&key->list);
-		ieee80211_key_free_common(key);
+		ieee80211_key_destroy(key);
 	}
 }
 
@@ -1351,7 +1332,7 @@ void ieee80211_free_sta_keys(struct ieee80211_local *local,
 		if (!key)
 			continue;
 		ieee80211_key_replace(key->sdata, &slot, key, NULL);
-		__ieee80211_key_destroy(key);
+		ieee80211_key_destroy(key);
 	}
 }
 
diff --git a/net/mac80211/key.h b/net/mac80211/key.h
index b7caec277fbe..b7afd6c90eb0 100644
--- a/net/mac80211/key.h
+++ b/net/mac80211/key.h
@@ -131,6 +131,8 @@ struct ieee80211_key {
 
 	unsigned int color;
 
+	struct rcu_work free_work;
+
 	/*
 	 * key config, must be last because it contains key
 	 * material as variable length member
@@ -207,7 +209,6 @@ void ieee80211_free_keys(struct ieee80211_sub_if_data *sdata,
 			 bool force_synchronize);
 void ieee80211_unlink_link_sta_keys(struct ieee80211_local *local,
 				    struct link_sta_info *link_sta);
-void ieee80211_free_link_sta_keys(struct link_sta_info *link_sta);
 void ieee80211_free_sta_keys(struct ieee80211_local *local,
 			     struct sta_info *sta);
 void ieee80211_reenable_keys(struct ieee80211_sub_if_data *sdata);
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index fdf34d51620f..fb1e7fdd928a 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -1748,6 +1748,8 @@ void ieee80211_unregister_hw(struct ieee80211_hw *hw)
 	skb_queue_purge(&local->skb_queue_unreliable);
 
 	wiphy_unregister(local->hw.wiphy);
+	/* keys are freed via queue_rcu_work() */
+	rcu_barrier();
 	destroy_workqueue(local->workqueue);
 	ieee80211_led_exit(local);
 	kfree(local->int_scan_req);
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 790997592d8c..23166fc39729 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -353,7 +353,6 @@ struct sta_info *sta_info_get_by_idx(struct ieee80211_sub_if_data *sdata,
 static void sta_info_free_link(struct link_sta_info *link_sta)
 {
 	free_percpu(link_sta->pcpu_rx_stats);
-	ieee80211_free_link_sta_keys(link_sta);
 }
 
 static void sta_link_free_rcu(struct rcu_head *head)
@@ -561,8 +560,6 @@ static int sta_info_alloc_link(struct ieee80211_local *local,
 	struct ieee80211_hw *hw = &local->hw;
 	int i;
 
-	INIT_LIST_HEAD(&link_info->key_destroy_list);
-
 	if (ieee80211_hw_check(hw, USES_RSS)) {
 		link_info->pcpu_rx_stats =
 			alloc_percpu_gfp(struct ieee80211_sta_rx_stats, gfp);
@@ -1586,7 +1583,6 @@ static void __sta_info_destroy_part2(struct sta_info *sta, bool recalc)
 			continue;
 
 		ieee80211_unlink_link_sta_keys(local, link_sta);
-		ieee80211_free_link_sta_keys(link_sta);
 	}
 
 	ieee80211_free_sta_keys(local, sta);
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index 27f31fd7258e..8c6a9fee6b29 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -522,7 +522,6 @@ struct ieee80211_fragment_cache {
  * @uhr_dbe_enabled: for STAs as clients to an AP interface indicates
  *	DBE is enabled by the STA
  * @debugfs_dir: debug filesystem directory dentry
- * @key_destroy_list: used during removal, keys to destroy
  * @pub: public (driver visible) link STA data
  */
 struct link_sta_info {
@@ -582,8 +581,6 @@ struct link_sta_info {
 	struct dentry *debugfs_dir;
 #endif
 
-	struct list_head key_destroy_list;
-
 	struct ieee80211_link_sta *pub;
 };
 
-- 
2.56.0

