Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=168.119.38.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793015513;
	b=0Vlkl4QWUVleJ1PL7f/1cq7WaSbUxsx08mWetCK0WQrwsedhc7y73L8Z8gDWbUBCQPs2
	 RHN0Rb3SSZaTuJZHJpp5y++54STG0DrrZ+zztNL1H1biYX5orq4zQernX5LTB+ZnX+6Xg
	 NU5PhcN6r0jNpQk2/HvecMyxfJERGO2TvihizBPafnWKQ8FLK2GiFlhFEcP6oWJJL2f1C
	 ohP2cDySAJSn5//W2ThH9eiKRq3B122xiiAOHxVf2864djgnBayV91wCBEp/+rxycqpXQ
	 h7d2yEZwHoN5OLlc6IpG4MbPschbdAwVhAkcdo69VKFhXcx7kt2itgJaa2tBFkoR5Ag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793015513;
	h=DKIM-Signature:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=R0RffiawqfZ+TJ/VbsiIwjd3QqVjxbiYKOOjaG4J4SQ=;
	b=ZW6iJ4P87P7qGVBjZ6dAAgXKtOfZZyJh831w8aygEGcnjKLMEUnglAfB8DBrKvMCjish
	 7Aizmmk52pPf7YEjqm3uLAycGsEUs4wXAv1xVWsGVC3Z+eo0+yuKDUaTb6CFgqefvWfrI
	 opy7bNOdLIy3RUbiYWoBzrWnYvBYRRRoMxhx6izeYveQX17er5ZtpB8NoXYiYAP+0dclc
	 PFiM2ypdhsFAK9uREDSNooomabAWAuJfdfUesdWsiZniq757iTNfkpEJv9Fz6Buta4YFC
	 xtmzAj4+63IiG70gn6/79jTd62X+Y5hDC80kZu3uywQg8ubF6dRUBYjP0H6m8YZ3v5A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=permerror header.from=sipsolutions.net;
	spf=pass smtp.mailfrom=sipsolutions.net;
	dkim=pass header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=IXBlIdpz;
	arc=none smtp.remote-ip=168.119.38.16
Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6D1F60A2621
	for <linux-wireless@vger.kernel.org>; Mon, 26 Oct 2026 11:51:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=IXBlIdpz
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=R0RffiawqfZ+TJ/VbsiIwjd3QqVjxbiYKOOjaG4J4SQ=;
	t=1793015512; x=1794225112; b=IXBlIdpzqqG/MtvOPyVNng4rdnaQodDYkZb3x85rkRC+UIg
	3m7NwEw29JWv31w6Cvaw9nE3pjyRQ5jdd188ZyuYP9lWt4lDtm/tJ2hkZO3lbFza3fWV1ld4203Yn
	pcK9YJTX3RnZBehENFXrIK3iIFCxYtncfXcKwQm81jyU56iQKwXSUTe2mkdmBJu/ENGzvf+W4jQDh
	Edwe18120tu3JEAj7/mkxWRWaJAFWKLcj5MqbPoddtjNpsTw1kt27IXJYwJ0KS0/4l5h27kTDqzU9
	JZBfuW25GyJlu4ObYkpGJzYJx2GqLymsqbgUQPoeoM5THOQBIhvGBd5LoCpl4Xwg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xLJF0-0000000BDPs-3WDH;
	Mon, 26 Oct 2026 12:51:51 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Miriam Rachel Korenblit <miriam.rachel.korenblit@intel.com>
Subject: [PATCH wireless-next 3/6] wifi: mac80211: simplify tailroom accounting
Date: Mon, 26 Oct 2026 12:48:37 +0100
Message-ID: <20261026125145.85a38a4ba7d2.Iafbf95bf95dc17d7ebf3bdffdba1d147be8b5d69@changeid>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261026115144.189706-8-johannes@sipsolutions.net>
References: <20261026115144.189706-8-johannes@sipsolutions.net>
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

Now that we're no longer synchronizing against the TX path,
quite a bit of complexity can go: there's no need to try to
optimise the transitions as carefully anymore to avoid the
transitions from 0 to 1. We can also simplify hardware key
offload management and accept a temporary increment. This
also enables further optimisations depending on key type.

Also fix an issue that could leave the count wrong during
HW restart.

Assisted-by: LLM
Reviewed-by: Miriam Rachel Korenblit <miriam.rachel.korenblit@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/cfg.c         |   2 +-
 net/mac80211/ieee80211_i.h |   2 -
 net/mac80211/iface.c       |   3 -
 net/mac80211/key.c         | 176 +++++++++++++------------------------
 net/mac80211/key.h         |   5 +-
 net/mac80211/main.c        |   2 -
 net/mac80211/pm.c          |   4 +-
 7 files changed, 63 insertions(+), 131 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 08ee5ae64939..d92b8cf8e9f2 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -773,7 +773,7 @@ static int ieee80211_del_key(struct wiphy *wiphy, struct wireless_dev *wdev,
 	if (!rcu_access_pointer(*slot.key))
 		return -ENOENT;
 
-	ieee80211_key_free(sdata, &slot, sdata->vif.type == NL80211_IFTYPE_STATION);
+	ieee80211_key_free(sdata, &slot);
 
 	return 0;
 }
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 0cd276fb8133..9906a62ee99c 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1207,8 +1207,6 @@ struct ieee80211_sub_if_data {
 
 	/* count for keys needing tailroom space allocation */
 	int crypto_tx_tailroom_needed_cnt;
-	int crypto_tx_tailroom_pending_dec;
-	struct wiphy_delayed_work dec_tailroom_needed_wk;
 
 	struct net_device *dev;
 	struct ieee80211_local *local;
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index d0b0a503b229..581a5d57e560 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -2374,9 +2374,6 @@ int ieee80211_if_add(struct ieee80211_local *local, const char *name,
 
 	ieee80211_init_frag_cache(&sdata->frags);
 
-	wiphy_delayed_work_init(&sdata->dec_tailroom_needed_wk,
-				ieee80211_delayed_tailroom_dec);
-
 	for (i = 0; i < NUM_NL80211_BANDS; i++) {
 		struct ieee80211_supported_band *sband;
 		sband = local->hw.wiphy->bands[i];
diff --git a/net/mac80211/key.c b/net/mac80211/key.c
index 6904b519ef37..8d04fba60e17 100644
--- a/net/mac80211/key.c
+++ b/net/mac80211/key.c
@@ -81,15 +81,14 @@ static void increment_tailroom_need_count(struct ieee80211_sub_if_data *sdata)
 	sdata->crypto_tx_tailroom_needed_cnt++;
 }
 
-static void decrease_tailroom_need_count(struct ieee80211_sub_if_data *sdata,
-					 int delta)
+static void decrease_tailroom_need_count(struct ieee80211_sub_if_data *sdata)
 {
 	lockdep_assert_wiphy(sdata->local->hw.wiphy);
 
-	WARN_ON_ONCE(sdata->crypto_tx_tailroom_needed_cnt < delta);
+	WARN_ON_ONCE(!sdata->crypto_tx_tailroom_needed_cnt);
 
-	update_vlan_tailroom_need_count(sdata, -delta);
-	sdata->crypto_tx_tailroom_needed_cnt -= delta;
+	update_vlan_tailroom_need_count(sdata, -1);
+	sdata->crypto_tx_tailroom_needed_cnt--;
 }
 
 static bool ieee80211_key_needs_tailroom(struct ieee80211_key *key)
@@ -102,6 +101,25 @@ static bool ieee80211_key_needs_tailroom(struct ieee80211_key *key)
 	return !(key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE);
 }
 
+static void ieee80211_key_set_uploaded(struct ieee80211_key *key,
+				       bool uploaded)
+{
+	bool needed = ieee80211_key_needs_tailroom(key);
+	bool needs;
+
+	if (uploaded)
+		key->flags |= KEY_FLAG_UPLOADED_TO_HARDWARE;
+	else
+		key->flags &= ~KEY_FLAG_UPLOADED_TO_HARDWARE;
+
+	needs = ieee80211_key_needs_tailroom(key);
+	if (needs && !needed)
+		increment_tailroom_need_count(key->sdata);
+	else if (!needs && needed)
+		decrease_tailroom_need_count(key->sdata);
+}
+
+/* the key must already be accounted for in the tailroom count */
 static int ieee80211_key_enable_hw_accel(struct ieee80211_key *key)
 {
 	struct ieee80211_sub_if_data *sdata = key->sdata;
@@ -112,17 +130,8 @@ static int ieee80211_key_enable_hw_accel(struct ieee80211_key *key)
 	lockdep_assert_wiphy(key->local->hw.wiphy);
 
 	if (key->flags & KEY_FLAG_TAINTED) {
-		/* If we get here, it's during resume and the key is
-		 * tainted so shouldn't be used/programmed any more.
-		 * However, its flags may still indicate that it was
-		 * programmed into the device (since we're in resume)
-		 * so clear that flag now to avoid trying to remove
-		 * it again later.
-		 */
-		if (!ieee80211_key_needs_tailroom(key))
-			increment_tailroom_need_count(sdata);
-
-		key->flags &= ~KEY_FLAG_UPLOADED_TO_HARDWARE;
+		/* only during reconfig, it shouldn't be programmed any more */
+		ieee80211_key_set_uploaded(key, false);
 		return -EINVAL;
 	}
 
@@ -183,10 +192,7 @@ static int ieee80211_key_enable_hw_accel(struct ieee80211_key *key)
 			  sta ? &sta->sta : NULL, &key->conf);
 
 	if (!ret) {
-		key->flags |= KEY_FLAG_UPLOADED_TO_HARDWARE;
-
-		if (!ieee80211_key_needs_tailroom(key))
-			decrease_tailroom_need_count(sdata, 1);
+		ieee80211_key_set_uploaded(key, true);
 
 		WARN_ON((key->conf.flags & IEEE80211_KEY_FLAG_PUT_IV_SPACE) &&
 			(key->conf.flags & IEEE80211_KEY_FLAG_GENERATE_IV));
@@ -255,9 +261,6 @@ static void ieee80211_key_disable_hw_accel(struct ieee80211_key *key)
 	    !(sdata->vif.active_links & BIT(key->conf.link_id)))
 		return;
 
-	if (!ieee80211_key_needs_tailroom(key))
-		increment_tailroom_need_count(sdata);
-
 	pubsta = sta ? &sta->sta : NULL;
 	/* unless requested otherwise, NULL out the STA for client group keys */
 	if (sdata->vif.type == NL80211_IFTYPE_STATION &&
@@ -265,7 +268,8 @@ static void ieee80211_key_disable_hw_accel(struct ieee80211_key *key)
 	    !ieee80211_hw_check(&key->local->hw, PER_STA_AP_GTK))
 		pubsta = NULL;
 
-	key->flags &= ~KEY_FLAG_UPLOADED_TO_HARDWARE;
+	ieee80211_key_set_uploaded(key, false);
+
 	ret = drv_set_key(key->local, DISABLE_KEY, sdata, pubsta, &key->conf);
 
 	if (ret)
@@ -576,6 +580,10 @@ static int ieee80211_key_replace(struct ieee80211_sub_if_data *sdata,
 		ieee80211_pairwise_rekey(old, new);
 	}
 
+	/* enabling the new key in hardware may reduce it again */
+	if (new && ieee80211_key_needs_tailroom(new))
+		increment_tailroom_need_count(sdata);
+
 	if (old) {
 		if (old->flags & KEY_FLAG_UPLOADED_TO_HARDWARE) {
 			ieee80211_key_disable_hw_accel(old);
@@ -588,14 +596,15 @@ static int ieee80211_key_replace(struct ieee80211_sub_if_data *sdata,
 			ret = ieee80211_key_enable_hw_accel(new);
 		} else if (new->conf.link_id < 0 || !sdata->vif.active_links ||
 			 BIT(new->conf.link_id) & sdata->vif.active_links) {
-			new->flags |= KEY_FLAG_UPLOADED_TO_HARDWARE;
-			if (!ieee80211_key_needs_tailroom(new))
-				decrease_tailroom_need_count(sdata, 1);
+			ieee80211_key_set_uploaded(new, true);
 		}
 	}
 
-	if (ret)
+	if (ret) {
+		if (new && ieee80211_key_needs_tailroom(new))
+			decrease_tailroom_need_count(sdata);
 		return ret;
+	}
 
 	if (new) {
 		spin_lock_bh(&sdata->local->key_lock);
@@ -662,6 +671,9 @@ static int ieee80211_key_replace(struct ieee80211_sub_if_data *sdata,
 		spin_lock_bh(&sdata->local->key_lock);
 		list_del(&old->list);
 		spin_unlock_bh(&sdata->local->key_lock);
+
+		if (ieee80211_key_needs_tailroom(old))
+			decrease_tailroom_need_count(sdata);
 	}
 
 	return 0;
@@ -839,36 +851,20 @@ static void ieee80211_key_free_common(struct ieee80211_key *key)
 	kfree_sensitive(key);
 }
 
-static void __ieee80211_key_cleanup(struct ieee80211_key *key,
-				    bool delay_tailroom)
+static void __ieee80211_key_cleanup(struct ieee80211_key *key)
 {
-	if (key->local) {
-		struct ieee80211_sub_if_data *sdata = key->sdata;
-
+	if (key->local)
 		ieee80211_debugfs_key_remove(key);
-
-		if (delay_tailroom) {
-			/* see ieee80211_delayed_tailroom_dec */
-			sdata->crypto_tx_tailroom_pending_dec++;
-			wiphy_delayed_work_queue(sdata->local->hw.wiphy,
-						 &sdata->dec_tailroom_needed_wk,
-						 HZ / 2);
-		} else {
-			decrease_tailroom_need_count(sdata, 1);
-		}
-	}
 }
 
-static void __ieee80211_key_destroy(struct ieee80211_key *key,
-				    bool delay_tailroom)
+static void __ieee80211_key_destroy(struct ieee80211_key *key)
 {
-	__ieee80211_key_cleanup(key, delay_tailroom);
+	__ieee80211_key_cleanup(key);
 
 	ieee80211_key_free_common(key);
 }
 
-static void ieee80211_key_destroy(struct ieee80211_key *key,
-				  bool delay_tailroom)
+static void ieee80211_key_destroy(struct ieee80211_key *key)
 {
 	if (!key)
 		return;
@@ -879,7 +875,7 @@ static void ieee80211_key_destroy(struct ieee80211_key *key,
 	 */
 	synchronize_net();
 
-	__ieee80211_key_destroy(key, delay_tailroom);
+	__ieee80211_key_destroy(key);
 }
 
 void ieee80211_key_free_unused(struct ieee80211_key *key)
@@ -928,12 +924,6 @@ int ieee80211_key_link(struct ieee80211_sub_if_data *sdata,
 		       struct ieee80211_key_slot *slot,
 		       struct ieee80211_key *key)
 {
-	/*
-	 * We want to delay tailroom updates only for station - in that
-	 * case it helps roaming speed, but in other cases it hurts and
-	 * can cause warnings to appear.
-	 */
-	bool delay_tailroom = sdata->vif.type == NL80211_IFTYPE_STATION;
 	bool pairwise = key->conf.flags & IEEE80211_KEY_FLAG_PAIRWISE;
 	static atomic_t key_color = ATOMIC_INIT(0);
 	struct ieee80211_key *old_key = NULL;
@@ -1005,18 +995,15 @@ int ieee80211_key_link(struct ieee80211_sub_if_data *sdata,
 		goto out;
 	}
 
-	increment_tailroom_need_count(sdata);
-
 	ret = ieee80211_key_replace(sdata, slot, old_key, key);
 	if (ret) {
-		decrease_tailroom_need_count(sdata, 1);
 		key->local = NULL;
 		key->sdata = NULL;
 		goto out;
 	}
 
 	ieee80211_debugfs_key_add(key);
-	ieee80211_key_destroy(old_key, delay_tailroom);
+	ieee80211_key_destroy(old_key);
 
 	return 0;
  out:
@@ -1025,8 +1012,7 @@ int ieee80211_key_link(struct ieee80211_sub_if_data *sdata,
 }
 
 void ieee80211_key_free(struct ieee80211_sub_if_data *sdata,
-			struct ieee80211_key_slot *slot,
-			bool delay_tailroom)
+			struct ieee80211_key_slot *slot)
 {
 	struct ieee80211_key *key;
 
@@ -1037,7 +1023,7 @@ void ieee80211_key_free(struct ieee80211_sub_if_data *sdata,
 	/* replace key with nothing if it was ever used */
 	if (key->sdata)
 		ieee80211_key_replace(key->sdata, slot, key, NULL);
-	ieee80211_key_destroy(key, delay_tailroom);
+	ieee80211_key_destroy(key);
 }
 
 void ieee80211_reenable_keys(struct ieee80211_sub_if_data *sdata)
@@ -1048,18 +1034,17 @@ void ieee80211_reenable_keys(struct ieee80211_sub_if_data *sdata)
 	lockdep_assert_wiphy(sdata->local->hw.wiphy);
 
 	sdata->crypto_tx_tailroom_needed_cnt = 0;
-	sdata->crypto_tx_tailroom_pending_dec = 0;
 
 	if (sdata->vif.type == NL80211_IFTYPE_AP) {
-		list_for_each_entry(vlan, &sdata->u.ap.vlans, u.vlan.list) {
+		list_for_each_entry(vlan, &sdata->u.ap.vlans, u.vlan.list)
 			vlan->crypto_tx_tailroom_needed_cnt = 0;
-			vlan->crypto_tx_tailroom_pending_dec = 0;
-		}
 	}
 
 	if (ieee80211_sdata_running(sdata)) {
 		list_for_each_entry(key, &sdata->key_list, list) {
-			if (!(key->flags & KEY_FLAG_TAINTED))
+			/* the device was reset, it's no longer uploaded */
+			key->flags &= ~KEY_FLAG_UPLOADED_TO_HARDWARE;
+			if (ieee80211_key_needs_tailroom(key))
 				increment_tailroom_need_count(sdata);
 			ieee80211_key_enable_hw_accel(key);
 		}
@@ -1169,10 +1154,6 @@ EXPORT_SYMBOL(ieee80211_iter_keys_atomic);
 static void ieee80211_free_keys_iface(struct ieee80211_sub_if_data *sdata,
 				      struct list_head *keys)
 {
-	decrease_tailroom_need_count(sdata,
-				     sdata->crypto_tx_tailroom_pending_dec);
-	sdata->crypto_tx_tailroom_pending_dec = 0;
-
 	ieee80211_debugfs_key_remove_mgmt_default(sdata);
 	ieee80211_debugfs_key_remove_beacon_default(sdata);
 
@@ -1239,7 +1220,7 @@ void ieee80211_free_key_list(struct ieee80211_local *local,
 	lockdep_assert_wiphy(local->hw.wiphy);
 
 	list_for_each_entry_safe(key, tmp, keys, list)
-		__ieee80211_key_destroy(key, false);
+		__ieee80211_key_destroy(key);
 }
 
 void ieee80211_free_keys(struct ieee80211_sub_if_data *sdata,
@@ -1251,9 +1232,6 @@ void ieee80211_free_keys(struct ieee80211_sub_if_data *sdata,
 	struct ieee80211_key *key, *tmp;
 	LIST_HEAD(keys);
 
-	wiphy_delayed_work_cancel(local->hw.wiphy,
-				  &sdata->dec_tailroom_needed_wk);
-
 	lockdep_assert_wiphy(local->hw.wiphy);
 
 	ieee80211_remove_link_keys(&sdata->deflink, &keys);
@@ -1271,7 +1249,7 @@ void ieee80211_free_keys(struct ieee80211_sub_if_data *sdata,
 	if (!list_empty(&keys) || force_synchronize)
 		synchronize_net();
 	list_for_each_entry_safe(key, tmp, &keys, list)
-		__ieee80211_key_destroy(key, false);
+		__ieee80211_key_destroy(key);
 
 	if (sdata->vif.type == NL80211_IFTYPE_AP_VLAN) {
 		if (sdata->bss) {
@@ -1283,14 +1261,12 @@ void ieee80211_free_keys(struct ieee80211_sub_if_data *sdata,
 				     master->crypto_tx_tailroom_needed_cnt);
 		}
 	} else {
-		WARN_ON_ONCE(sdata->crypto_tx_tailroom_needed_cnt ||
-			     sdata->crypto_tx_tailroom_pending_dec);
+		WARN_ON_ONCE(sdata->crypto_tx_tailroom_needed_cnt);
 	}
 
 	if (sdata->vif.type == NL80211_IFTYPE_AP) {
 		list_for_each_entry(vlan, &sdata->u.ap.vlans, u.vlan.list)
-			WARN_ON_ONCE(vlan->crypto_tx_tailroom_needed_cnt ||
-				     vlan->crypto_tx_tailroom_pending_dec);
+			WARN_ON_ONCE(vlan->crypto_tx_tailroom_needed_cnt);
 	}
 }
 
@@ -1316,8 +1292,7 @@ void ieee80211_unlink_link_sta_keys(struct ieee80211_local *local,
 		if (WARN(ret, "failed to remove STA link key (%d)\n", ret))
 			continue;
 		list_add(&key->list, &link_sta->key_destroy_list);
-		__ieee80211_key_cleanup(key, key->sdata->vif.type ==
-					     NL80211_IFTYPE_STATION);
+		__ieee80211_key_cleanup(key);
 	}
 
 	for (int i = 0; i < ARRAY_SIZE(link_sta->rx_cigtk); i++) {
@@ -1332,8 +1307,7 @@ void ieee80211_unlink_link_sta_keys(struct ieee80211_local *local,
 		if (WARN(ret, "failed to remove STA link key (%d)\n", ret))
 			continue;
 		list_add(&key->list, &link_sta->key_destroy_list);
-		__ieee80211_key_cleanup(key, key->sdata->vif.type ==
-					     NL80211_IFTYPE_STATION);
+		__ieee80211_key_cleanup(key);
 	}
 }
 
@@ -1364,40 +1338,10 @@ void ieee80211_free_sta_keys(struct ieee80211_local *local,
 		if (!key)
 			continue;
 		ieee80211_key_replace(key->sdata, &slot, key, NULL);
-		__ieee80211_key_destroy(key, key->sdata->vif.type ==
-					NL80211_IFTYPE_STATION);
+		__ieee80211_key_destroy(key);
 	}
 }
 
-void ieee80211_delayed_tailroom_dec(struct wiphy *wiphy,
-				    struct wiphy_work *wk)
-{
-	struct ieee80211_sub_if_data *sdata;
-
-	sdata = container_of(wk, struct ieee80211_sub_if_data,
-			     dec_tailroom_needed_wk.work);
-
-	/*
-	 * The reason for the delayed tailroom needed decrementing is to
-	 * make roaming faster: during roaming, all keys are first deleted
-	 * and then new keys are installed. The first new key causes the
-	 * crypto_tx_tailroom_needed_cnt to go from 0 to 1, which invokes
-	 * the cost of synchronize_net() (which can be slow). Avoid this
-	 * by deferring the crypto_tx_tailroom_needed_cnt decrementing on
-	 * key removal for a while, so if we roam the value is larger than
-	 * zero and no 0->1 transition happens.
-	 *
-	 * The cost is that if the AP switching was from an AP with keys
-	 * to one without, we still allocate tailroom while it would no
-	 * longer be needed. However, in the typical (fast) roaming case
-	 * within an ESS this usually won't happen.
-	 */
-
-	decrease_tailroom_need_count(sdata,
-				     sdata->crypto_tx_tailroom_pending_dec);
-	sdata->crypto_tx_tailroom_pending_dec = 0;
-}
-
 void ieee80211_gtk_rekey_notify(struct ieee80211_vif *vif, const u8 *bssid,
 				const u8 *replay_ctr, gfp_t gfp)
 {
diff --git a/net/mac80211/key.h b/net/mac80211/key.h
index 2fc985d41e8f..b7caec277fbe 100644
--- a/net/mac80211/key.h
+++ b/net/mac80211/key.h
@@ -191,8 +191,7 @@ int ieee80211_key_link(struct ieee80211_sub_if_data *sdata,
 		       struct ieee80211_key *key);
 int ieee80211_set_tx_key(struct ieee80211_key *key);
 void ieee80211_key_free(struct ieee80211_sub_if_data *sdata,
-			struct ieee80211_key_slot *slot,
-			bool delay_tailroom);
+			struct ieee80211_key_slot *slot);
 void ieee80211_key_free_unused(struct ieee80211_key *key);
 void ieee80211_set_default_key(struct ieee80211_link_data *link, int idx,
 			       bool uni, bool multi);
@@ -215,7 +214,5 @@ void ieee80211_reenable_keys(struct ieee80211_sub_if_data *sdata);
 int ieee80211_key_switch_links(struct ieee80211_sub_if_data *sdata,
 			       unsigned long del_links_mask,
 			       unsigned long add_links_mask);
-void ieee80211_delayed_tailroom_dec(struct wiphy *wiphy,
-				    struct wiphy_work *wk);
 
 #endif /* IEEE80211_KEY_H */
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index dd00f126f037..c2cad0f92b43 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -512,8 +512,6 @@ static void ieee80211_restart_work(struct work_struct *work)
 							      WLAN_REASON_UNSPECIFIED,
 							      false);
 		}
-		wiphy_delayed_work_flush(local->hw.wiphy,
-					 &sdata->dec_tailroom_needed_wk);
 	}
 	ieee80211_scan_cancel(local);
 
diff --git a/net/mac80211/pm.c b/net/mac80211/pm.c
index f63676c44853..6a27f8f35c8e 100644
--- a/net/mac80211/pm.c
+++ b/net/mac80211/pm.c
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 /*
  * Portions
- * Copyright (C) 2020-2021, 2023-2024 Intel Corporation
+ * Copyright (C) 2020-2021, 2023-2024, 2026 Intel Corporation
  */
 #include <net/mac80211.h>
 #include <net/rtnetlink.h>
@@ -160,8 +160,6 @@ int __ieee80211_suspend(struct ieee80211_hw *hw, struct cfg80211_wowlan *wowlan,
 			break;
 		}
 
-		wiphy_delayed_work_flush(local->hw.wiphy,
-					 &sdata->dec_tailroom_needed_wk);
 		drv_remove_interface(local, sdata);
 	}
 
-- 
2.56.0

