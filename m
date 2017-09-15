Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:37238 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751427AbdIOKSQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 15 Sep 2017 06:18:16 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [RFC 2/4] cfg80211: support reloading regulatory database
Date: Fri, 15 Sep 2017 12:18:08 +0200
Message-Id: <20170915101810.11435-3-johannes@sipsolutions.net> (sfid-20170915_121826_341654_BFEE820F)
In-Reply-To: <20170915101810.11435-1-johannes@sipsolutions.net>
References: <20170915101810.11435-1-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

If the regulatory database is loaded, and then updated, it may
be necessary to reload it. Add an nl80211 command to do this,
and RCU-ify the pointer to the regdb "firmware" to allow it to
be replaced at runtime.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/uapi/linux/nl80211.h |  4 +++
 net/wireless/nl80211.c       | 11 ++++++
 net/wireless/reg.c           | 84 ++++++++++++++++++++++++++++++++++++--------
 net/wireless/reg.h           |  6 ++++
 4 files changed, 90 insertions(+), 15 deletions(-)

diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 51626b4175c0..926eb92cb4a8 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -983,6 +983,8 @@
  *	configured PMK for the authenticator address identified by
  *	&NL80211_ATTR_MAC.
  *
+ * @NL80211_CMD_RELOAD_REGDB: Request that the regdb firmware file is reloaded.
+ *
  * @NL80211_CMD_MAX: highest used command number
  * @__NL80211_CMD_AFTER_LAST: internal use
  */
@@ -1185,6 +1187,8 @@ enum nl80211_commands {
 	NL80211_CMD_SET_PMK,
 	NL80211_CMD_DEL_PMK,
 
+	NL80211_CMD_RELOAD_REGDB,
+
 	/* add new commands above here */
 
 	/* used to define NL80211_CMD_MAX below */
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 8ce85420ecb0..ee902ea13833 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -5669,6 +5669,11 @@ static int nl80211_req_set_reg(struct sk_buff *skb, struct genl_info *info)
 	}
 }
 
+static int nl80211_reload_regdb(struct sk_buff *skb, struct genl_info *info)
+{
+	return reg_reload_regdb();
+}
+
 static int nl80211_get_mesh_config(struct sk_buff *skb,
 				   struct genl_info *info)
 {
@@ -12668,6 +12673,12 @@ static const struct genl_ops nl80211_ops[] = {
 		.policy = nl80211_policy,
 		.flags = GENL_ADMIN_PERM,
 	},
+	{
+		.cmd = NL80211_CMD_RELOAD_REGDB,
+		.doit = nl80211_reload_regdb,
+		.policy = nl80211_policy,
+		.flags = GENL_ADMIN_PERM,
+	},
 	{
 		.cmd = NL80211_CMD_GET_MESH_CONFIG,
 		.doit = nl80211_get_mesh_config,
diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 7a1d6cda64f3..8d366738c08a 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -602,7 +602,7 @@ static inline int call_crda(const char *alpha2)
 #endif /* CONFIG_CFG80211_CRDA_SUPPORT */
 
 /* code to directly load a firmware database through request_firmware */
-static const struct firmware *regdb;
+static const struct firmware __rcu *regdb;
 static unsigned int fwregdb_attempts = 10;
 
 struct fwdb_country {
@@ -756,47 +756,76 @@ static int query_regdb(const char *alpha2)
 {
 	const struct fwdb_header *hdr;
 	const struct fwdb_country *country;
+	const struct firmware *db;
+	int err;
 
-	if (IS_ERR(regdb))
-		return PTR_ERR(regdb);
+	rcu_read_lock();
+	db = rcu_dereference(regdb);
 
-	hdr = (void *)regdb->data;
+	if (IS_ERR(db)) {
+		err = PTR_ERR(db);
+		goto out;
+	}
+
+	hdr = (void *)db->data;
 	country = &hdr->country[0];
 	while (country->coll_ptr) {
-		if (alpha2_equal(alpha2, country->alpha2))
-			return regdb_query_country(regdb, country);
+		if (alpha2_equal(alpha2, country->alpha2)) {
+			err = regdb_query_country(db, country);
+			goto out;
+		}
 		country++;
 	}
 
-	return -ENODATA;
+	err = -ENODATA;
+ out:
+	rcu_read_unlock();
+	return err;
 }
 
 static void regdb_fw_cb(const struct firmware *fw, void *context)
 {
+	const struct firmware *db;
+
+	rtnl_lock();
+
+	db = rcu_dereference_protected(regdb, lockdep_rtnl_is_held());
+
+	if (WARN_ON(db)) {
+		release_firmware(fw);
+		goto out;
+	}
+
 	if (!fw) {
 		pr_info("failed to load regulatory.db\n");
 		if (fwregdb_attempts-- == 0)
-			regdb = ERR_PTR(-ENODATA);
+			rcu_assign_pointer(regdb, ERR_PTR(-ENODATA));
 		goto restore;
 	}
 
 	if (!valid_regdb(fw)) {
 		pr_info("loaded regulatory.db is malformed\n");
 		release_firmware(fw);
-		regdb = ERR_PTR(-EINVAL);
+		rcu_assign_pointer(regdb, ERR_PTR(-EINVAL));
 		goto restore;
 	}
 
-	regdb = fw;
-	if (query_regdb(context))
+	rcu_assign_pointer(regdb, fw);
+
+	if (context && query_regdb(context))
 		goto restore;
-	goto free;
+	goto out;
+
  restore:
-	rtnl_lock();
 	restore_regulatory_settings(true);
+ out:
 	rtnl_unlock();
- free:
 	kfree(context);
+
+	if (!IS_ERR_OR_NULL(db)) {
+		synchronize_rcu();
+		release_firmware(db);
+	}
 }
 
 static int query_regdb_file(const char *alpha2)
@@ -813,6 +842,31 @@ static int query_regdb_file(const char *alpha2)
 				       (void *)alpha2, regdb_fw_cb);
 }
 
+int reg_reload_regdb(void)
+{
+	const struct firmware *db, *old;
+	int err;
+
+	err = request_firmware(&db, "regulatory.db", &reg_pdev->dev);
+	if (err)
+		return err;
+
+	if (!valid_regdb(db))
+		return -ENODATA;
+
+	rtnl_lock();
+	old = rcu_dereference_protected(regdb, lockdep_rtnl_is_held());
+	rcu_assign_pointer(regdb, db);
+	rtnl_unlock();
+
+	if (!IS_ERR_OR_NULL(old)) {
+		synchronize_rcu();
+		release_firmware(old);
+	}
+
+	return 0;
+}
+
 static bool reg_query_database(struct regulatory_request *request)
 {
 	/* query internal regulatory database (if it exists) */
@@ -3564,5 +3618,5 @@ void regulatory_exit(void)
 	}
 
 	if (!IS_ERR_OR_NULL(regdb))
-		release_firmware(regdb);
+		release_firmware(rcu_access_pointer(regdb));
 }
diff --git a/net/wireless/reg.h b/net/wireless/reg.h
index ca7fedf2e7a1..9529c522611a 100644
--- a/net/wireless/reg.h
+++ b/net/wireless/reg.h
@@ -179,4 +179,10 @@ void regulatory_propagate_dfs_state(struct wiphy *wiphy,
  * @wiphy2 - wiphy it's dfs_region to be checked against that of wiphy1
  */
 bool reg_dfs_domain_same(struct wiphy *wiphy1, struct wiphy *wiphy2);
+
+/**
+ * reg_reload_regdb - reload the regulatory.db firmware file
+ */
+int reg_reload_regdb(void);
+
 #endif  /* __NET_WIRELESS_REG_H */
-- 
2.14.1
