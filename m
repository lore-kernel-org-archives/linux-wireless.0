Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 627C84908B4
	for <linux-wireless@vger.kernel.org>; Sun,  4 Oct 2026 19:01:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791140501; cv=none; b=QpQNWrYHWVCC6rioaZ0FNDiDmGzGo2aDw3iBBKv2l9nS0QpRmoCo0/nxnRsP0CZeHinUcVDmbJvJAjrgusVr7T4aKYq9x8YNwMhqhJzl1MbZClRe/hbbtlmosvwuwCC2F4s9SDwZkNh+B06cvFc+fxb38qFsXpdeyDYL6N8UxS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791140501; c=relaxed/simple;
	bh=jWE1v5l2uMfzpG3BZAyXI0DZmhU9vY41oAu8ePJWRWU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fwZ8q05Dt5hUZPcUo6VMZxs5f4SJ4k4WUNZQvLk33bXEz0qit388BoTGdbhhK1qlR6SMiPgy/XWVmhfd04LUJWlODFSakgTfhWLLIDReft/jZNbrsSctqz1qUtWgLWAiXjZUNzCmTb1nQeDPA43WHcLg45WcLdOvFsyNIUmvsz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=u0nkomaF; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="u0nkomaF"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=wbeLUXfPIAP41GbKgWB9QXMBroc+aX6ZVBcIpEnyfpM=;
	t=1791140497; x=1792350097; b=u0nkomaFnSBNqwBFZXUn4rOPZ0l3WTd7JnxlUw7sND5pZzC
	opAM2X68r1I1F2w5qfTVVxYToLIqotISuIxgZJwUrcbWj5kjTD+fmyVZNjnJftULDBqmENiqBqqa/
	dG3F52drIHRR4Yn5n3ejja9HMCO7OAdvT0nWoriO9dVx7OVfxM726/b4YkrZw/aXYlQQg5bBMOGDk
	5QnXVsKxd7Uo9RQkpd2mwbehfttMYC6ZJ0LFSJGcKXbi3RITnfnhQQspg9xf+nhgDt7u0x/AgWmVI
	YymICm0W1ScH/TQYUyhG1pbGl6TryjmoPn+P9xcp9kTeols4u4Y7/hHgwx6ZfPgg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xDRSm-00000004Jlo-0bIi;
	Sun, 04 Oct 2026 21:01:32 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH wireless-next 10/18] wifi: cfg80211: add a mutex for regulatory/device list
Date: Sun,  4 Oct 2026 21:01:24 +0200
Message-ID: <20261004210122.e3ab0e67f923.I5db33ad005ac5877d806e140ed0c41c464a7e5aa@changeid>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261004190122.1559001-20-johannes@sipsolutions.net>
References: <20261004190122.1559001-20-johannes@sipsolutions.net>
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
 net/wireless/core.c    | 13 +++++++++-
 net/wireless/core.h    |  3 +++
 net/wireless/mlme.c    |  3 +++
 net/wireless/nl80211.c |  2 ++
 net/wireless/reg.c     | 54 +++++++++++++++++++++++++++++-------------
 5 files changed, 58 insertions(+), 17 deletions(-)

diff --git a/net/wireless/core.c b/net/wireless/core.c
index ed6b5d3c148e..e12d8b301a37 100644
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
 
@@ -1231,10 +1237,12 @@ int wiphy_register(struct wiphy *wiphy)
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
@@ -1308,6 +1316,7 @@ int wiphy_register(struct wiphy *wiphy)
 				break;
 		}
 	}
+	mutex_unlock(&cfg80211_mutex);
 	rtnl_unlock();
 
 	res = rfkill_register(rdev->wiphy.rfkill);
@@ -1379,6 +1388,7 @@ void wiphy_unregister(struct wiphy *wiphy)
 		rfkill_unregister(rdev->wiphy.rfkill);
 
 	rtnl_lock();
+	mutex_lock(&cfg80211_mutex);
 	wiphy_lock(&rdev->wiphy);
 	nl80211_notify_wiphy(rdev, NL80211_CMD_DEL_WIPHY);
 	rdev->wiphy.registered = false;
@@ -1410,6 +1420,7 @@ void wiphy_unregister(struct wiphy *wiphy)
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
index d76b1fa54d64..d90d383deb27 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -11042,6 +11042,7 @@ static int nl80211_set_reg(struct sk_buff *skb, struct genl_info *info)
 	}
 
 	rtnl_lock();
+	mutex_lock(&cfg80211_mutex);
 	if (!reg_is_valid_request(alpha2)) {
 		r = -EINVAL;
 		goto out;
@@ -11089,6 +11090,7 @@ static int nl80211_set_reg(struct sk_buff *skb, struct genl_info *info)
  bad_reg:
 	kfree(rd);
  out:
+	mutex_unlock(&cfg80211_mutex);
 	rtnl_unlock();
 	return r;
 }
diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 28c431e0c5df..6a2bdb3d9d5e 100644
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
 
@@ -973,7 +981,7 @@ static int query_regdb(const char *alpha2)
 	const struct fwdb_header *hdr = regdb;
 	const struct fwdb_country *country;
 
-	ASSERT_RTNL();
+	lockdep_assert_held(&cfg80211_mutex);
 
 	if (IS_ERR(regdb))
 		return PTR_ERR(regdb);
@@ -1003,6 +1011,7 @@ static void regdb_fw_cb(const struct firmware *fw, void *context)
 	}
 
 	rtnl_lock();
+	mutex_lock(&cfg80211_mutex);
 	if (regdb && !IS_ERR(regdb)) {
 		/* negative case - a bug
 		 * positive case - can happen due to race in case of multiple cb's in
@@ -1025,6 +1034,7 @@ static void regdb_fw_cb(const struct firmware *fw, void *context)
 	if (restore)
 		restore_regulatory_settings(true, false);
 
+	mutex_unlock(&cfg80211_mutex);
 	rtnl_unlock();
 
 	kfree(context);
@@ -1038,7 +1048,7 @@ static int query_regdb_file(const char *alpha2)
 {
 	int err;
 
-	ASSERT_RTNL();
+	lockdep_assert_held(&cfg80211_mutex);
 
 	if (regdb)
 		return query_regdb(alpha2);
@@ -1080,6 +1090,7 @@ int reg_reload_regdb(void)
 	}
 
 	rtnl_lock();
+	mutex_lock(&cfg80211_mutex);
 	if (!IS_ERR_OR_NULL(regdb))
 		kfree(regdb);
 	regdb = db;
@@ -1102,6 +1113,7 @@ int reg_reload_regdb(void)
 	reg_process_hint(request);
 
 out_unlock:
+	mutex_unlock(&cfg80211_mutex);
 	rtnl_unlock();
  out:
 	release_firmware(fw);
@@ -2569,7 +2581,7 @@ static void update_all_wiphy_regulatory(enum nl80211_reg_initiator initiator)
 	struct cfg80211_registered_device *rdev;
 	struct wiphy *wiphy;
 
-	ASSERT_RTNL();
+	lockdep_assert_held(&cfg80211_mutex);
 
 	for_each_rdev(rdev) {
 		wiphy = &rdev->wiphy;
@@ -2859,7 +2871,7 @@ reg_process_hint_driver(struct wiphy *wiphy,
 		if (IS_ERR(regd))
 			return REG_REQ_IGNORE;
 
-		ASSERT_RTNL();
+		lockdep_assert_held(&cfg80211_mutex);
 		scoped_guard(wiphy, wiphy) {
 			tmp = get_wiphy_regdom(wiphy);
 			rcu_assign_pointer(wiphy->regd, regd);
@@ -3052,7 +3064,7 @@ static void wiphy_all_share_dfs_chan_state(struct wiphy *wiphy)
 {
 	struct cfg80211_registered_device *rdev;
 
-	ASSERT_RTNL();
+	lockdep_assert_held(&cfg80211_mutex);
 
 	guard(wiphy)(wiphy);
 
@@ -3240,7 +3252,7 @@ static void reg_process_self_managed_hints(void)
 {
 	struct cfg80211_registered_device *rdev;
 
-	ASSERT_RTNL();
+	lockdep_assert_held(&cfg80211_mutex);
 
 	for_each_rdev(rdev) {
 		guard(wiphy)(&rdev->wiphy);
@@ -3254,9 +3266,11 @@ static void reg_process_self_managed_hints(void)
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
 
@@ -3536,7 +3550,7 @@ static void restore_regulatory_settings(bool reset_user, bool cached)
 	LIST_HEAD(tmp_reg_req_list);
 	struct cfg80211_registered_device *rdev;
 
-	ASSERT_RTNL();
+	lockdep_assert_held(&cfg80211_mutex);
 
 	/*
 	 * Clear the indoor setting in case that it is not controlled by user
@@ -3654,6 +3668,8 @@ static bool is_wiphy_all_set_reg_flag(enum ieee80211_regulatory_flags flag)
 
 void regulatory_hint_disconnect(void)
 {
+	guard(mutex)(&cfg80211_mutex);
+
 	/* Restore of regulatory settings is not required when wiphy(s)
 	 * ignore IE from connected access point but clearance of beacon hints
 	 * is required when wiphy(s) supports beacon hints.
@@ -3922,7 +3938,7 @@ static int reg_set_rd_driver(const struct ieee80211_regdomain *rd,
 		return -ENODEV;
 
 	if (!driver_request->intersect) {
-		ASSERT_RTNL();
+		lockdep_assert_held(&cfg80211_mutex);
 		scoped_guard(wiphy, request_wiphy) {
 			if (request_wiphy->regd)
 				tmp = get_wiphy_regdom(request_wiphy);
@@ -4142,6 +4158,8 @@ void wiphy_regulatory_register(struct wiphy *wiphy)
 {
 	struct regulatory_request *lr = get_last_request();
 
+	lockdep_assert_held(&cfg80211_mutex);
+
 	/* self-managed devices ignore beacon hints and country IE */
 	if (wiphy->regulatory_flags & REGULATORY_WIPHY_SELF_MANAGED) {
 		wiphy->regulatory_flags |= REGULATORY_DISABLE_BEACON_HINTS |
@@ -4169,6 +4187,8 @@ void wiphy_regulatory_deregister(struct wiphy *wiphy)
 	struct wiphy *request_wiphy = NULL;
 	struct regulatory_request *lr;
 
+	lockdep_assert_held(&cfg80211_mutex);
+
 	lr = get_last_request();
 
 	if (!reg_dev_ignore_cell_hint(wiphy))
@@ -4307,7 +4327,7 @@ void regulatory_propagate_dfs_state(struct wiphy *wiphy,
 {
 	struct cfg80211_registered_device *rdev;
 
-	ASSERT_RTNL();
+	lockdep_assert_held(&cfg80211_mutex);
 
 	if (WARN_ON(!cfg80211_chandef_valid(chandef)))
 		return;
@@ -4416,7 +4436,9 @@ void regulatory_exit(void)
 
 	/* Lock to suppress warnings */
 	rtnl_lock();
+	mutex_lock(&cfg80211_mutex);
 	reset_regdomains(true, NULL);
+	mutex_unlock(&cfg80211_mutex);
 	rtnl_unlock();
 
 	dev_set_uevent_suppress(&reg_fdev->dev, true);
-- 
2.55.0

