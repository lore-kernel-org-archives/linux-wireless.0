Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD4BC3DD533
	for <linux-wireless@vger.kernel.org>; Tue,  6 Oct 2026 10:07:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791281236; cv=none; b=En/CS07oPVrsevMP7Y0G7eAbwy07655ulvQho9EbqzaJrMvd5ef7FUZDZaxOdTB3asdACRr6Hcd85oAbqYp2D72SuyAd0l1D7PFEswRQ8L7phd9u52jlKy3WPbTzLMuYEjG24WR3c0U7NcAKz2oIocZacGUosD4W92wTGBog5hM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791281236; c=relaxed/simple;
	bh=lw+ZmA0+wgIeq9AOuA1g5X3UvVAoMhzMUsUtIuFhzmM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WAoAU+whD7pQ/JXNFRV5GiN6FEk7sEbQD1Wbfof8Z07LE/6hVF7U6p/G6uGEhn0602jTsq2nqbfje19B2637ezXSF4Nzx6rIqVJewrQYRRS1NdkHxDdx7SC31m92bIL/7dgkjPkaQRl+2kdg+7xxQNhCb+k6CLF26qIcv2Xczew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=qvFVOKzy; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="qvFVOKzy"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=CaTw6iyRWO/gKuhPirQ/DHQgihion09oBMKtoxDv1tU=;
	t=1791281233; x=1792490833; b=qvFVOKzyX+OpDxe0GX3XbeIZJ+nylgiefijapBmGyUgW9LI
	5dqhhaSpTW7w57bO+3goeU2arwiwYb9MxW47AkJJ1feJXtOLyLpZ0VcHI8RB8ug8hH1hMTUxjUmfJ
	YnN+dUjQbWuYQjT8p6o9OMnBURtxCx0lWhMi/4rcgMfKvjpioKn23po4qKbk2EuHF2wFvDnBlQxX3
	Qf36WsyrJbLVJNnNQvjUPkZKznnGTRK/Go2rU05RvMGaTgWSLVYtEeHiEq0VouY5o7lOcYGJweUWV
	NXtOVHz1kQJv6dB5DvNXhEeF7CqzP5zHJmR3N2x+SfJNfZ7nqcvY7e1vUExUU20w==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xE24k-00000006XqW-28rZ;
	Tue, 06 Oct 2026 12:07:10 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH wireless-next v3 11/19] wifi: cfg80211: add a mutex for regulatory/device list
Date: Tue,  6 Oct 2026 12:04:09 +0200
Message-ID: <20261006120655.501ac570dbcc.I5db33ad005ac5877d806e140ed0c41c464a7e5aa@changeid>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261006100655.2687533-21-johannes@sipsolutions.net>
References: <20261006100655.2687533-21-johannes@sipsolutions.net>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

The global regulatory state is currently protected by the
RTNL (which is the new BKL). Prepare for further reducing
our dependency on it by adding a new mutex that protects
this data (as well, for now held inside RTNL) and the
wiphy list (so that regulatory code can walk it).

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/core.c    | 13 ++++++++-
 net/wireless/core.h    |  3 ++
 net/wireless/mlme.c    |  3 ++
 net/wireless/nl80211.c |  2 ++
 net/wireless/reg.c     | 66 ++++++++++++++++++++++++++++++------------
 5 files changed, 68 insertions(+), 19 deletions(-)

diff --git a/net/wireless/core.c b/net/wireless/core.c
index 270fb30e5265..deb3889ffeff 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -42,7 +42,9 @@ MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("wireless configuration support");
 MODULE_ALIAS_GENL_FAMILY(NL80211_GENL_NAME);
 
-/* RCU-protected (and RTNL for writers) */
+DEFINE_MUTEX(cfg80211_mutex);
+
+/* RCU-protected (writes under both RTNL/cfg80211_mutex) */
 LIST_HEAD(cfg80211_rdev_list);
 int cfg80211_rdev_list_generation;
 
@@ -565,11 +567,13 @@ static void cfg80211_propagate_radar_detect_wk(struct work_struct *work)
 			    propagate_radar_detect_wk);
 
 	rtnl_lock();
+	mutex_lock(&cfg80211_mutex);
 
 	regulatory_propagate_dfs_state(&rdev->wiphy, &rdev->radar_chandef,
 				       NL80211_DFS_UNAVAILABLE,
 				       NL80211_RADAR_DETECTED);
 
+	mutex_unlock(&cfg80211_mutex);
 	rtnl_unlock();
 }
 
@@ -581,11 +585,13 @@ static void cfg80211_propagate_cac_done_wk(struct work_struct *work)
 			    propagate_cac_done_wk);
 
 	rtnl_lock();
+	mutex_lock(&cfg80211_mutex);
 
 	regulatory_propagate_dfs_state(&rdev->wiphy, &rdev->cac_done_chandef,
 				       NL80211_DFS_AVAILABLE,
 				       NL80211_RADAR_CAC_FINISHED);
 
+	mutex_unlock(&cfg80211_mutex);
 	rtnl_unlock();
 }
 
@@ -1243,10 +1249,12 @@ int wiphy_register(struct wiphy *wiphy)
 		rdev->wiphy.bss_param_support |= WIPHY_BSS_PARAM_P2P_OPPPS;
 
 	rtnl_lock();
+	mutex_lock(&cfg80211_mutex);
 	wiphy_lock(&rdev->wiphy);
 	res = device_add(&rdev->wiphy.dev);
 	if (res) {
 		wiphy_unlock(&rdev->wiphy);
+		mutex_unlock(&cfg80211_mutex);
 		rtnl_unlock();
 		return res;
 	}
@@ -1320,6 +1328,7 @@ int wiphy_register(struct wiphy *wiphy)
 				break;
 		}
 	}
+	mutex_unlock(&cfg80211_mutex);
 	rtnl_unlock();
 
 	res = rfkill_register(rdev->wiphy.rfkill);
@@ -1391,6 +1400,7 @@ void wiphy_unregister(struct wiphy *wiphy)
 		rfkill_unregister(rdev->wiphy.rfkill);
 
 	rtnl_lock();
+	mutex_lock(&cfg80211_mutex);
 	wiphy_lock(&rdev->wiphy);
 	nl80211_notify_wiphy(rdev, NL80211_CMD_DEL_WIPHY);
 	rdev->wiphy.registered = false;
@@ -1422,6 +1432,7 @@ void wiphy_unregister(struct wiphy *wiphy)
 	/* surely nothing is reachable now, clean up work */
 	cfg80211_process_wiphy_works(rdev, NULL);
 	wiphy_unlock(&rdev->wiphy);
+	mutex_unlock(&cfg80211_mutex);
 	rtnl_unlock();
 
 	/* this has nothing to do now but make sure it's gone */
diff --git a/net/wireless/core.h b/net/wireless/core.h
index 58445c09026a..414ce31af60c 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -19,6 +19,9 @@
 #include "reg.h"
 
 
+/* protects the wiphy list and regulatory state */
+extern struct mutex cfg80211_mutex;
+
 #define WIPHY_IDX_INVALID	-1
 
 struct cfg80211_scan_request_int {
diff --git a/net/wireless/mlme.c b/net/wireless/mlme.c
index 131039b675fe..082590d859e9 100644
--- a/net/wireless/mlme.c
+++ b/net/wireless/mlme.c
@@ -1120,6 +1120,7 @@ void cfg80211_dfs_channels_update_work(struct work_struct *work)
 	wiphy = &rdev->wiphy;
 
 	rtnl_lock();
+	mutex_lock(&cfg80211_mutex);
 	wiphy_lock(wiphy);
 	for (bandid = 0; bandid < NUM_NL80211_BANDS; bandid++) {
 		if (wiphy->bands[bandid])
@@ -1133,6 +1134,7 @@ void cfg80211_dfs_channels_update_work(struct work_struct *work)
 				   &rdev->dfs_update_channels_wk,
 				   HZ);
 		wiphy_unlock(wiphy);
+		mutex_unlock(&cfg80211_mutex);
 		rtnl_unlock();
 		return;
 	}
@@ -1199,6 +1201,7 @@ void cfg80211_dfs_channels_update_work(struct work_struct *work)
 					       NL80211_DFS_USABLE,
 					       expired[i].event);
 	}
+	mutex_unlock(&cfg80211_mutex);
 	rtnl_unlock();
 
 	kvfree(expired);
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index a3c8252420e7..b3a46240ea6b 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -11050,6 +11050,7 @@ static int nl80211_set_reg(struct sk_buff *skb, struct genl_info *info)
 	}
 
 	rtnl_lock();
+	mutex_lock(&cfg80211_mutex);
 	if (!reg_is_valid_request(alpha2)) {
 		r = -EINVAL;
 		goto out;
@@ -11097,6 +11098,7 @@ static int nl80211_set_reg(struct sk_buff *skb, struct genl_info *info)
  bad_reg:
 	kfree(rd);
  out:
+	mutex_unlock(&cfg80211_mutex);
 	rtnl_unlock();
 	return r;
 }
diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index a7602d6d4c64..46643d9ce28d 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -88,7 +88,7 @@ static struct regulatory_request core_request_world = {
 
 /*
  * Receipt of information from last regulatory request,
- * protected by RTNL (and can be accessed with RCU protection)
+ * protected by cfg80211_mutex (and can be accessed with RCU protection)
  */
 static struct regulatory_request __rcu *last_request =
 	(void __force __rcu *)&core_request_world;
@@ -100,14 +100,14 @@ static struct faux_device *reg_fdev;
  * Central wireless core regulatory domains, we only need two,
  * the current one and a world regulatory domain in case we have no
  * information to give us an alpha2.
- * (protected by RTNL, can be read under RCU)
+ * (protected by cfg80211_mutex, can be read under RCU)
  */
 const struct ieee80211_regdomain __rcu *cfg80211_regdomain;
 
 /*
  * Number of devices that registered to the core
  * that support cellular base station regulatory hints
- * (protected by RTNL)
+ * (protected by cfg80211_mutex)
  */
 static int reg_num_devs_support_basehint;
 
@@ -128,7 +128,9 @@ static void reg_process_hint(struct regulatory_request *reg_request);
 
 static const struct ieee80211_regdomain *get_cfg80211_regdom(void)
 {
-	return rcu_dereference_rtnl(cfg80211_regdomain);
+	return rcu_dereference_check(cfg80211_regdomain,
+				     lockdep_is_held(&cfg80211_mutex) ||
+				     lockdep_rtnl_is_held());
 }
 
 /*
@@ -204,7 +206,9 @@ static void rcu_free_regdom(const struct ieee80211_regdomain *r)
 
 static struct regulatory_request *get_last_request(void)
 {
-	return rcu_dereference_rtnl(last_request);
+	return rcu_dereference_check(last_request,
+				     lockdep_is_held(&cfg80211_mutex) ||
+				     lockdep_rtnl_is_held());
 }
 
 /* Used to queue up regulatory hints */
@@ -314,7 +318,7 @@ static void reset_regdomains(bool full_reset,
 {
 	const struct ieee80211_regdomain *r;
 
-	ASSERT_RTNL();
+	lockdep_assert_held(&cfg80211_mutex);
 
 	r = get_cfg80211_regdom();
 
@@ -456,7 +460,7 @@ reg_copy_regd(const struct ieee80211_regdomain *src_regd)
 
 static void cfg80211_save_user_regdom(const struct ieee80211_regdomain *rd)
 {
-	ASSERT_RTNL();
+	lockdep_assert_held(&cfg80211_mutex);
 
 	if (!IS_ERR(cfg80211_user_regdom))
 		kfree(cfg80211_user_regdom);
@@ -476,6 +480,7 @@ static void reg_regdb_apply(struct work_struct *work)
 	struct reg_regdb_apply_request *request;
 
 	rtnl_lock();
+	mutex_lock(&cfg80211_mutex);
 
 	mutex_lock(&reg_regdb_apply_mutex);
 	while (!list_empty(&reg_regdb_apply_list)) {
@@ -489,6 +494,7 @@ static void reg_regdb_apply(struct work_struct *work)
 	}
 	mutex_unlock(&reg_regdb_apply_mutex);
 
+	mutex_unlock(&cfg80211_mutex);
 	rtnl_unlock();
 }
 
@@ -527,8 +533,10 @@ static void crda_timeout_work(struct work_struct *work)
 {
 	pr_debug("Timeout while waiting for CRDA to reply, restoring regulatory settings\n");
 	rtnl_lock();
+	mutex_lock(&cfg80211_mutex);
 	reg_crda_timeouts++;
 	restore_regulatory_settings(true, false);
+	mutex_unlock(&cfg80211_mutex);
 	rtnl_unlock();
 }
 
@@ -973,8 +981,12 @@ static int regdb_query_country(const struct fwdb_header *db,
 
 static int query_regdb(const char *alpha2)
 {
-	const struct fwdb_header *regdb = rtnl_dereference(global_regdb);
 	const struct fwdb_country *country;
+	const struct fwdb_header *regdb;
+
+	regdb = rcu_dereference_protected(global_regdb,
+					  lockdep_rtnl_is_held() ||
+					  lockdep_is_held(&cfg80211_mutex));
 
 	if (IS_ERR(regdb))
 		return PTR_ERR(regdb);
@@ -1005,7 +1017,10 @@ static void regdb_fw_cb(const struct firmware *fw, void *context)
 	}
 
 	rtnl_lock();
-	regdb = rtnl_dereference(global_regdb);
+	mutex_lock(&cfg80211_mutex);
+	regdb = rcu_dereference_protected(global_regdb,
+					  lockdep_rtnl_is_held() ||
+					  lockdep_is_held(&cfg80211_mutex));
 	if (regdb && !IS_ERR(regdb)) {
 		/* negative case - a bug
 		 * positive case - can happen due to race in case of multiple cb's in
@@ -1028,6 +1043,7 @@ static void regdb_fw_cb(const struct firmware *fw, void *context)
 	if (restore)
 		restore_regulatory_settings(true, false);
 
+	mutex_unlock(&cfg80211_mutex);
 	rtnl_unlock();
 
 	kfree(context);
@@ -1041,7 +1057,7 @@ static int query_regdb_file(const char *alpha2)
 {
 	int err;
 
-	ASSERT_RTNL();
+	lockdep_assert_held(&cfg80211_mutex);
 
 	if (rcu_access_pointer(global_regdb))
 		return query_regdb(alpha2);
@@ -1083,7 +1099,10 @@ int reg_reload_regdb(void)
 	}
 
 	rtnl_lock();
-	old = rcu_replace_pointer_rtnl(global_regdb, db);
+	mutex_lock(&cfg80211_mutex);
+	old = rcu_replace_pointer(global_regdb, db,
+				  lockdep_rtnl_is_held() ||
+				  lockdep_is_held(&cfg80211_mutex));
 
 	/* reset regulatory domain */
 	current_regdomain = get_cfg80211_regdom();
@@ -1103,6 +1122,7 @@ int reg_reload_regdb(void)
 	reg_process_hint(request);
 
 out_unlock:
+	mutex_unlock(&cfg80211_mutex);
 	rtnl_unlock();
 
 	if (!IS_ERR_OR_NULL(old)) {
@@ -2575,7 +2595,7 @@ static void update_all_wiphy_regulatory(enum nl80211_reg_initiator initiator)
 	struct cfg80211_registered_device *rdev;
 	struct wiphy *wiphy;
 
-	ASSERT_RTNL();
+	lockdep_assert_held(&cfg80211_mutex);
 
 	for_each_rdev(rdev) {
 		wiphy = &rdev->wiphy;
@@ -2865,7 +2885,7 @@ reg_process_hint_driver(struct wiphy *wiphy,
 		if (IS_ERR(regd))
 			return REG_REQ_IGNORE;
 
-		ASSERT_RTNL();
+		lockdep_assert_held(&cfg80211_mutex);
 		scoped_guard(wiphy, wiphy) {
 			tmp = get_wiphy_regdom(wiphy);
 			rcu_assign_pointer(wiphy->regd, regd);
@@ -3058,7 +3078,7 @@ static void wiphy_all_share_dfs_chan_state(struct wiphy *wiphy)
 {
 	struct cfg80211_registered_device *rdev;
 
-	ASSERT_RTNL();
+	lockdep_assert_held(&cfg80211_mutex);
 
 	guard(wiphy)(wiphy);
 
@@ -3246,7 +3266,7 @@ static void reg_process_self_managed_hints(void)
 {
 	struct cfg80211_registered_device *rdev;
 
-	ASSERT_RTNL();
+	lockdep_assert_held(&cfg80211_mutex);
 
 	for_each_rdev(rdev) {
 		guard(wiphy)(&rdev->wiphy);
@@ -3260,9 +3280,11 @@ static void reg_process_self_managed_hints(void)
 static void reg_todo(struct work_struct *work)
 {
 	rtnl_lock();
+	mutex_lock(&cfg80211_mutex);
 	reg_process_pending_hints();
 	reg_process_pending_beacon_hints();
 	reg_process_self_managed_hints();
+	mutex_unlock(&cfg80211_mutex);
 	rtnl_unlock();
 }
 
@@ -3542,7 +3564,7 @@ static void restore_regulatory_settings(bool reset_user, bool cached)
 	LIST_HEAD(tmp_reg_req_list);
 	struct cfg80211_registered_device *rdev;
 
-	ASSERT_RTNL();
+	lockdep_assert_held(&cfg80211_mutex);
 
 	/*
 	 * Clear the indoor setting in case that it is not controlled by user
@@ -3660,6 +3682,8 @@ static bool is_wiphy_all_set_reg_flag(enum ieee80211_regulatory_flags flag)
 
 void regulatory_hint_disconnect(void)
 {
+	guard(mutex)(&cfg80211_mutex);
+
 	/* Restore of regulatory settings is not required when wiphy(s)
 	 * ignore IE from connected access point but clearance of beacon hints
 	 * is required when wiphy(s) supports beacon hints.
@@ -3928,7 +3952,7 @@ static int reg_set_rd_driver(const struct ieee80211_regdomain *rd,
 		return -ENODEV;
 
 	if (!driver_request->intersect) {
-		ASSERT_RTNL();
+		lockdep_assert_held(&cfg80211_mutex);
 		scoped_guard(wiphy, request_wiphy) {
 			if (request_wiphy->regd)
 				tmp = get_wiphy_regdom(request_wiphy);
@@ -4148,6 +4172,8 @@ void wiphy_regulatory_register(struct wiphy *wiphy)
 {
 	struct regulatory_request *lr = get_last_request();
 
+	lockdep_assert_held(&cfg80211_mutex);
+
 	/* self-managed devices ignore beacon hints and country IE */
 	if (wiphy->regulatory_flags & REGULATORY_WIPHY_SELF_MANAGED) {
 		wiphy->regulatory_flags |= REGULATORY_DISABLE_BEACON_HINTS |
@@ -4175,6 +4201,8 @@ void wiphy_regulatory_deregister(struct wiphy *wiphy)
 	struct wiphy *request_wiphy = NULL;
 	struct regulatory_request *lr;
 
+	lockdep_assert_held(&cfg80211_mutex);
+
 	lr = get_last_request();
 
 	if (!reg_dev_ignore_cell_hint(wiphy))
@@ -4313,7 +4341,7 @@ void regulatory_propagate_dfs_state(struct wiphy *wiphy,
 {
 	struct cfg80211_registered_device *rdev;
 
-	ASSERT_RTNL();
+	lockdep_assert_held(&cfg80211_mutex);
 
 	if (WARN_ON(!cfg80211_chandef_valid(chandef)))
 		return;
@@ -4423,7 +4451,9 @@ void regulatory_exit(void)
 
 	/* Lock to suppress warnings */
 	rtnl_lock();
+	mutex_lock(&cfg80211_mutex);
 	reset_regdomains(true, NULL);
+	mutex_unlock(&cfg80211_mutex);
 	rtnl_unlock();
 
 	dev_set_uevent_suppress(&reg_fdev->dev, true);
-- 
2.55.0

