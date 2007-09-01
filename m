Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:59393 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752151AbXIANix (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Sep 2007 09:38:53 -0400
Subject: Re: [PATCH] mac80211: fix race conditions with keys
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Michael Wu <flamingice@sourmilk.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1188484758.3978.18.camel@johannes.berg>
References: <1188484758.3978.18.camel@johannes.berg>
Content-Type: text/plain
Date: Sat, 01 Sep 2007 15:40:12 +0200
Message-Id: <1188654012.7585.151.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I should note that this opens a race condition when you rekey, it could
happen that we transmit packets while not having a key at all. We could
avoid that but the patch is largish and complex (below), not sure if
it's worth it. It's not something that may cause crashes or such, the
worst case really is that we transmit frames unencrypted.

johannes

---
 net/mac80211/key.c |   88 +++++++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 76 insertions(+), 12 deletions(-)

--- wireless-dev.orig/net/mac80211/key.c	2007-09-01 15:33:16.702769870 +0200
+++ wireless-dev/net/mac80211/key.c	2007-09-01 15:33:17.482769870 +0200
@@ -109,6 +109,29 @@ static void ieee80211_key_disable_hw_acc
 	key->flags &= ~KEY_FLAG_UPLOADED_TO_HARDWARE;
 }
 
+/*
+ * Make a copy of the key including key material,
+ * does not copy the AES crypto state.
+ */
+static struct ieee80211_key *ieee80211_key_clone(struct ieee80211_key *key)
+{
+	struct ieee80211_key *result;
+	int size;
+
+	if (!key)
+		return NULL;
+
+	size = sizeof(*result) + key->conf.keylen;
+
+	result = kmalloc(size, GFP_KERNEL);
+	if (!result)
+		return NULL;
+
+	memcpy(result, key, size);
+
+	return result;
+}
+
 struct ieee80211_key *ieee80211_key_alloc(struct ieee80211_sub_if_data *sdata,
 					  struct sta_info *sta,
 					  enum ieee80211_key_alg alg,
@@ -116,7 +139,8 @@ struct ieee80211_key *ieee80211_key_allo
 					  size_t key_len,
 					  const u8 *key_data)
 {
-	struct ieee80211_key *key;
+	struct ieee80211_key *key, *old;
+	struct ieee80211_key **replace;
 
 	BUG_ON(idx < 0 || idx >= NUM_DEFAULT_KEYS);
 	BUG_ON(alg == ALG_NONE);
@@ -156,13 +180,9 @@ struct ieee80211_key *ieee80211_key_allo
 
 	ieee80211_debugfs_key_add(key->local, key);
 
-	/* remove key first */
-	if (sta)
-		ieee80211_key_free(sta->key);
-	else
-		ieee80211_key_free(sdata->keys[idx]);
-
 	if (sta) {
+		replace = &sta->key;
+
 		ieee80211_debugfs_key_sta_link(key, sta);
 
 		/*
@@ -172,6 +192,8 @@ struct ieee80211_key *ieee80211_key_allo
 		if (sta->flags & WLAN_STA_WME)
 			key->conf.flags |= IEEE80211_KEY_FLAG_WMM_STA;
 	} else {
+		replace = &sdata->keys[idx];
+
 		if (sdata->type == IEEE80211_IF_TYPE_STA) {
 			struct sta_info *ap;
 
@@ -186,14 +208,56 @@ struct ieee80211_key *ieee80211_key_allo
 		}
 	}
 
-	/* enable hwaccel if appropriate */
+	/*
+	 * Now it gets tricky. To avoid sending unencrypted packets
+	 * because we have no key at some point, first clone the old
+	 * key and put it to use without hw accel.
+	 *
+	 * Then we can safely free the previous one and remove it from
+	 * hardware acceleration.
+	 */
+	if (*replace && ((*replace)->flags & KEY_FLAG_UPLOADED_TO_HARDWARE)) {
+		struct ieee80211_key *clone;
+
+		old = *replace;
+
+		/*
+		 * If we fail to clone, we have to live with a short window
+		 * where we may be sending frames unencrypted.
+		 */
+		clone = ieee80211_key_clone(old);
+		if (clone)
+			clone->flags &= ~KEY_FLAG_UPLOADED_TO_HARDWARE;
+
+		/* now put the clone to use (if any) */
+		rcu_assign_pointer(*replace, clone);
+		synchronize_rcu();
+
+		/*
+		 * We only copied the pointer to the AES tfm,
+		 * those can't be refcounted or such.
+		 */
+		old->u.ccmp.tfm = NULL;
+
+		/* free original, removing it from hw accel */
+		ieee80211_key_free(old);
+	}
+
+	/*
+	 * At this point, the key that's in use (if any) is not uploaded
+	 * to the hardware, so we can freely upload the new one.
+	 */
 	if (netif_running(key->sdata->dev))
 		ieee80211_key_enable_hw_accel(key);
 
-	if (sta)
-		rcu_assign_pointer(sta->key, key);
-	else
-		rcu_assign_pointer(sdata->keys[idx], key);
+	old = *replace;
+
+	/* put the new key to use */
+	rcu_assign_pointer(*replace, key);
+	synchronize_rcu();
+
+	/* and free the old one */
+	ieee80211_key_free(old);
 
 	list_add(&key->list, &sdata->key_list);
 


