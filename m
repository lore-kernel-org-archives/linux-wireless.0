Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:55776 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752039Ab3B1WTQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Feb 2013 17:19:16 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: yogeshp@marvell.com, Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: defer tailroom counter manipulation when roaming
Date: Thu, 28 Feb 2013 23:19:10 +0100
Message-Id: <1362089950-12142-1-git-send-email-johannes@sipsolutions.net> (sfid-20130228_231919_069651_BE886B2B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

During roaming, the crypto_tx_tailroom_needed_cnt counter
will often take values 2,1,0,1,2 because first keys are
removed and then new keys are added. This is inefficient
because during the 0->1 transition, synchronize_net must
be called to avoid packet races, although typically no
packets would be flowing during that time.

To avoid that, defer the decrement (2->1, 1->0) when keys
are removed (by half a second). This means the counter
will really have the values 2,2,2,3,4 ... 2, thus never
reaching 0 and having to do the 0->1 transition.

Note that this patch entirely disregards the drivers for
which this optimisation was done to start with, for them
the key removal itself will be expensive because it has
to synchronize_net() after the counter is incremented to
remove the key from HW crypto. For them the sequence will
look like this: 0,1,0,1,0,1,0,1,0 (*) which is clearly a
lot more inefficient. This could be addressed separately,
during key removal the 0->1->0 sequence isn't necessary.

(*) it starts at 0 because HW crypto is on, then goes to
    1 when HW crypto is disabled for a key, then back to
    0 because the key is deleted; this happens for both
    keys in the example. When new keys are added, it goes
    to 1 first because they're added in software; when a
    key is moved to hardware it goes back to 0

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/cfg.c         |  2 +-
 net/mac80211/ieee80211_i.h |  2 ++
 net/mac80211/iface.c       |  2 ++
 net/mac80211/key.c         | 63 ++++++++++++++++++++++++++++++++++++++++------
 net/mac80211/key.h         |  4 ++-
 net/mac80211/sta_info.c    |  6 +++--
 6 files changed, 68 insertions(+), 11 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index a003f72..64da5a4 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -254,7 +254,7 @@ static int ieee80211_del_key(struct wiphy *wiphy, struct net_device *dev,
 		goto out_unlock;
 	}
 
-	__ieee80211_key_free(key);
+	__ieee80211_key_free(key, true);
 
 	ret = 0;
  out_unlock:
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 1281389..ea5ac15 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -685,6 +685,8 @@ struct ieee80211_sub_if_data {
 
 	/* count for keys needing tailroom space allocation */
 	int crypto_tx_tailroom_needed_cnt;
+	int crypto_tx_tailroom_pending_dec;
+	struct delayed_work dec_tailroom_needed_wk;
 
 	struct net_device *dev;
 	struct ieee80211_local *local;
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 2f2cbb7..feda9fb 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -1541,6 +1541,8 @@ int ieee80211_if_add(struct ieee80211_local *local, const char *name,
 	INIT_WORK(&sdata->cleanup_stations_wk, ieee80211_cleanup_sdata_stas_wk);
 	INIT_DELAYED_WORK(&sdata->dfs_cac_timer_work,
 			  ieee80211_dfs_cac_timer_work);
+	INIT_DELAYED_WORK(&sdata->dec_tailroom_needed_wk,
+			  ieee80211_delayed_tailroom_dec);
 
 	for (i = 0; i < IEEE80211_NUM_BANDS; i++) {
 		struct ieee80211_supported_band *sband;
diff --git a/net/mac80211/key.c b/net/mac80211/key.c
index c4bc3bd..3f98acf 100644
--- a/net/mac80211/key.c
+++ b/net/mac80211/key.c
@@ -397,7 +397,8 @@ struct ieee80211_key *ieee80211_key_alloc(u32 cipher, int idx, size_t key_len,
 	return key;
 }
 
-static void __ieee80211_key_destroy(struct ieee80211_key *key)
+static void __ieee80211_key_destroy(struct ieee80211_key *key,
+				    bool delay_tailroom)
 {
 	if (!key)
 		return;
@@ -416,8 +417,18 @@ static void __ieee80211_key_destroy(struct ieee80211_key *key)
 	if (key->conf.cipher == WLAN_CIPHER_SUITE_AES_CMAC)
 		ieee80211_aes_cmac_key_free(key->u.aes_cmac.tfm);
 	if (key->local) {
+		struct ieee80211_sub_if_data *sdata = key->sdata;
+
 		ieee80211_debugfs_key_remove(key);
-		key->sdata->crypto_tx_tailroom_needed_cnt--;
+
+		if (delay_tailroom) {
+			/* see ieee80211_delayed_tailroom_dec */
+			sdata->crypto_tx_tailroom_pending_dec++;
+			schedule_delayed_work(&sdata->dec_tailroom_needed_wk,
+					      HZ/2);
+		} else {
+			sdata->crypto_tx_tailroom_needed_cnt--;
+		}
 	}
 
 	kfree(key);
@@ -452,7 +463,7 @@ int ieee80211_key_link(struct ieee80211_key *key,
 	increment_tailroom_need_count(sdata);
 
 	__ieee80211_key_replace(sdata, sta, pairwise, old_key, key);
-	__ieee80211_key_destroy(old_key);
+	__ieee80211_key_destroy(old_key, true);
 
 	ieee80211_debugfs_key_add(key);
 
@@ -463,7 +474,7 @@ int ieee80211_key_link(struct ieee80211_key *key,
 	return ret;
 }
 
-void __ieee80211_key_free(struct ieee80211_key *key)
+void __ieee80211_key_free(struct ieee80211_key *key, bool delay_tailroom)
 {
 	if (!key)
 		return;
@@ -475,14 +486,14 @@ void __ieee80211_key_free(struct ieee80211_key *key)
 		__ieee80211_key_replace(key->sdata, key->sta,
 				key->conf.flags & IEEE80211_KEY_FLAG_PAIRWISE,
 				key, NULL);
-	__ieee80211_key_destroy(key);
+	__ieee80211_key_destroy(key, delay_tailroom);
 }
 
 void ieee80211_key_free(struct ieee80211_local *local,
 			struct ieee80211_key *key)
 {
 	mutex_lock(&local->key_mtx);
-	__ieee80211_key_free(key);
+	__ieee80211_key_free(key, true);
 	mutex_unlock(&local->key_mtx);
 }
 
@@ -558,18 +569,56 @@ void ieee80211_free_keys(struct ieee80211_sub_if_data *sdata)
 {
 	struct ieee80211_key *key, *tmp;
 
+	cancel_delayed_work_sync(&sdata->dec_tailroom_needed_wk);
+
 	mutex_lock(&sdata->local->key_mtx);
 
+	sdata->crypto_tx_tailroom_needed_cnt -=
+		sdata->crypto_tx_tailroom_pending_dec;
+	sdata->crypto_tx_tailroom_pending_dec = 0;
+
 	ieee80211_debugfs_key_remove_mgmt_default(sdata);
 
 	list_for_each_entry_safe(key, tmp, &sdata->key_list, list)
-		__ieee80211_key_free(key);
+		__ieee80211_key_free(key, false);
 
 	ieee80211_debugfs_key_update_default(sdata);
 
+	WARN_ON_ONCE(sdata->crypto_tx_tailroom_needed_cnt ||
+		     sdata->crypto_tx_tailroom_pending_dec);
+
 	mutex_unlock(&sdata->local->key_mtx);
 }
 
+void ieee80211_delayed_tailroom_dec(struct work_struct *wk)
+{
+	struct ieee80211_sub_if_data *sdata;
+
+	sdata = container_of(wk, struct ieee80211_sub_if_data,
+			     dec_tailroom_needed_wk.work);
+
+	/*
+	 * The reason for the delayed tailroom needed decrementing is to
+	 * make roaming faster: during roaming, all keys are first deleted
+	 * and then new keys are installed. The first new key causes the
+	 * crypto_tx_tailroom_needed_cnt to go from 0 to 1, which invokes
+	 * the cost of synchronize_net() (which can be slow). Avoid this
+	 * by deferring the crypto_tx_tailroom_needed_cnt decrementing on
+	 * key removal for a while, so if we roam the value is larger than
+	 * zero and no 0->1 transition happens.
+	 *
+	 * The cost is that if the AP switching was from an AP with keys
+	 * to one without, we still allocate tailroom while it would no
+	 * longer be needed. However, in the typical (fast) roaming case
+	 * within an ESS this usually won't happen.
+	 */
+
+	mutex_lock(&sdata->local->key_mtx);
+	sdata->crypto_tx_tailroom_needed_cnt -=
+		sdata->crypto_tx_tailroom_pending_dec;
+	sdata->crypto_tx_tailroom_pending_dec = 0;
+	mutex_unlock(&sdata->local->key_mtx);
+}
 
 void ieee80211_gtk_rekey_notify(struct ieee80211_vif *vif, const u8 *bssid,
 				const u8 *replay_ctr, gfp_t gfp)
diff --git a/net/mac80211/key.h b/net/mac80211/key.h
index 382dc44..d04f9e9 100644
--- a/net/mac80211/key.h
+++ b/net/mac80211/key.h
@@ -134,7 +134,7 @@ struct ieee80211_key *ieee80211_key_alloc(u32 cipher, int idx, size_t key_len,
 int __must_check ieee80211_key_link(struct ieee80211_key *key,
 				    struct ieee80211_sub_if_data *sdata,
 				    struct sta_info *sta);
-void __ieee80211_key_free(struct ieee80211_key *key);
+void __ieee80211_key_free(struct ieee80211_key *key, bool delay_tailroom);
 void ieee80211_key_free(struct ieee80211_local *local,
 			struct ieee80211_key *key);
 void ieee80211_set_default_key(struct ieee80211_sub_if_data *sdata, int idx,
@@ -148,4 +148,6 @@ void ieee80211_disable_keys(struct ieee80211_sub_if_data *sdata);
 #define key_mtx_dereference(local, ref) \
 	rcu_dereference_protected(ref, lockdep_is_held(&((local)->key_mtx)))
 
+void ieee80211_delayed_tailroom_dec(struct work_struct *wk);
+
 #endif /* IEEE80211_KEY_H */
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index a79ce82..0141e49 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -794,9 +794,11 @@ int __must_check __sta_info_destroy(struct sta_info *sta)
 
 	mutex_lock(&local->key_mtx);
 	for (i = 0; i < NUM_DEFAULT_KEYS; i++)
-		__ieee80211_key_free(key_mtx_dereference(local, sta->gtk[i]));
+		__ieee80211_key_free(key_mtx_dereference(local, sta->gtk[i]),
+				     true);
 	if (sta->ptk)
-		__ieee80211_key_free(key_mtx_dereference(local, sta->ptk));
+		__ieee80211_key_free(key_mtx_dereference(local, sta->ptk),
+				     true);
 	mutex_unlock(&local->key_mtx);
 
 	sta->dead = true;
-- 
1.8.0

