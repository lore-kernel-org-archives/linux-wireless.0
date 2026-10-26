Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=168.119.38.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793015515;
	b=SLnjftrav6GD6uZzHiI8dM3ssvcldywhAumIOfivyITdgj3bwkhBNTAAaX/yTI1i2l1u
	 fbYKst3JNlZriHCRdvoC1CFG2D8UEzxYOdeyaMwvWbJDqhXq7Dt0vDM1iSi34kdEBnMXo
	 bob/q9k9lvBpW48VkfNESW0BGABO9VVUpM40ocsQoah45ZYh7tUwCCNlbFn8JY30nPNEA
	 TCHxlbEZqqDFwRKP0R6WSwLl/abPynJAKpj7WGXtfc3MxP6S2lSpJR/+VQnDHfvz+sFt1
	 haI0QDuv6stX1sxrnyANe+dlcgdN5gK1SPWYuOjtJbwBwJqqWVIsOrWh+qTicFHBQ0g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793015515;
	h=DKIM-Signature:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=MPf59pdb7UvvXIeoXbdABFDPDCsWCixGP5DcBD34erI=;
	b=j2PPLLQ+xxqZxdVnkzSPpJrDehRYykLNfOUfxSi2faRqDuRzGVajm2/Fo3cZBRH+Ta6i
	 N5lph6QOxiwGsYi27PoLynFpyfuORMDOXc4zlK5LryOZLCS4cyt+oASkj4/cbJOj2e3+B
	 cO5DbZrMfBTAlzaEmUXlzZnlhYTBcsMmqBZaRY/NIq79G0ck0z3PC8ZGmi9cz1CqtkfrT
	 FZnCk5nvJP4MWCPS/rEbJWET6s3u2ZITWIuujO/ju0eSMpVdAtwFYWI/2ESDcoMJNyLHV
	 XC/g8Eydc3ySk690INcOhZfdZYHqEZfkmoo0vcLlMH4fv7QHy5PmPIziBVXjBSvSisw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=permerror header.from=sipsolutions.net;
	spf=pass smtp.mailfrom=sipsolutions.net;
	dkim=pass header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=pZuxbUK4;
	arc=none smtp.remote-ip=168.119.38.16
Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C4EE60A262E
	for <linux-wireless@vger.kernel.org>; Mon, 26 Oct 2026 11:51:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=pZuxbUK4
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=MPf59pdb7UvvXIeoXbdABFDPDCsWCixGP5DcBD34erI=;
	t=1793015515; x=1794225115; b=pZuxbUK49bm9XquHdfZQauWYEKgiM0tDAFz50rh57smkB0u
	Fs+Ds3QfkYfaVPtE5wlgDdb17e4bWiJiQBHrS6rqYV3JmSHP6nGIHIe8IP1zIWBeIUaej3n+XrxHH
	bLrGEufPFj2dc7Dxlw4QfMJsmVkxSeNl+TNFxiVAV9cwNp3AwNbZtfEvzsMmomQnEY1438bd1PIby
	XJveKUwJoVSmvODYLgKE0CgBN8m5a2WcMOuxRCW2D8xV7RcF33HQIYg2yGAQCXq//vtZKGp5qavqU
	tQA2VDBMMYudS6EehCJ1uszEw/rSbQomOVVxKh2NEI2v13vjF87fdbzK+P7X1GEQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xLJF2-0000000BDPs-0MQO;
	Mon, 26 Oct 2026 12:51:52 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Miriam Rachel Korenblit <miriam.rachel.korenblit@intel.com>
Subject: [PATCH wireless-next 5/6] wifi: mac80211: free keys asynchronously
Date: Mon, 26 Oct 2026 12:48:39 +0100
Message-ID: <20261026125145.68153c510dfe.Ieaf95b8e1336f07866f54d174f699c6aa079d9b8@changeid>
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
Reviewed-by: Miriam Rachel Korenblit <miriam.rachel.korenblit@intel.com>
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
index d92b8cf8e9f2..6e466f8e1653 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -2356,10 +2356,7 @@ static int ieee80211_stop_ap(struct wiphy *wiphy, struct net_device *dev,
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
index c2cad0f92b43..6e31076bcc10 100644
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

