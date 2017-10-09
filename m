Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:36442 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752504AbdJIJuY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 9 Oct 2017 05:50:24 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH v2 2/4] cfg80211: support reloading regulatory database
Date: Mon,  9 Oct 2017 11:50:16 +0200
Message-Id: <20171009095018.5289-3-johannes@sipsolutions.net> (sfid-20171009_115031_692408_C79F348F)
In-Reply-To: <20171009095018.5289-1-johannes@sipsolutions.net>
References: <20171009095018.5289-1-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

If the regulatory database is loaded, and then updated, it may
be necessary to reload it. Add an nl80211 command to do this.

Note that this just reloads the database, it doesn't re-apply
the rules from it immediately.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/uapi/linux/nl80211.h |  4 +++
 net/wireless/nl80211.c       | 11 ++++++
 net/wireless/reg.c           | 80 +++++++++++++++++++++++++++++++++-----------
 net/wireless/reg.h           |  6 ++++
 4 files changed, 81 insertions(+), 20 deletions(-)

diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 95832ce03a44..f882fe1f9709 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -990,6 +990,8 @@
  *	&NL80211_CMD_CONNECT or &NL80211_CMD_ROAM. If the 4 way handshake failed
  *	&NL80211_CMD_DISCONNECT should be indicated instead.
  *
+ * @NL80211_CMD_RELOAD_REGDB: Request that the regdb firmware file is reloaded.
+ *
  * @NL80211_CMD_MAX: highest used command number
  * @__NL80211_CMD_AFTER_LAST: internal use
  */
@@ -1194,6 +1196,8 @@ enum nl80211_commands {
 
 	NL80211_CMD_PORT_AUTHORIZED,
 
+	NL80211_CMD_RELOAD_REGDB,
+
 	/* add new commands above here */
 
 	/* used to define NL80211_CMD_MAX below */
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 5129342151e6..67a03f2885a4 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -5678,6 +5678,11 @@ static int nl80211_req_set_reg(struct sk_buff *skb, struct genl_info *info)
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
@@ -12708,6 +12713,12 @@ static const struct genl_ops nl80211_ops[] = {
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
index 3187a941b7bf..6b444898919b 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -782,6 +782,8 @@ static int query_regdb(const char *alpha2)
 	const struct fwdb_header *hdr = regdb;
 	const struct fwdb_country *country;
 
+	ASSERT_RTNL();
+
 	if (IS_ERR(regdb))
 		return PTR_ERR(regdb);
 
@@ -797,42 +799,48 @@ static int query_regdb(const char *alpha2)
 
 static void regdb_fw_cb(const struct firmware *fw, void *context)
 {
+	int set_error = 0;
+	bool restore = true;
 	void *db;
 
 	if (!fw) {
 		pr_info("failed to load regulatory.db\n");
 		if (fwregdb_attempts-- == 0)
-			regdb = ERR_PTR(-ENODATA);
-		goto restore;
-	}
-
-	if (!valid_regdb(fw->data, fw->size)) {
+			set_error = -ENODATA;
+	} else if (!valid_regdb(fw->data, fw->size)) {
 		pr_info("loaded regulatory.db is malformed\n");
-		release_firmware(fw);
-		regdb = ERR_PTR(-EINVAL);
-		goto restore;
+		set_error = -EINVAL;
 	}
 
-	db = kmemdup(fw->data, fw->size, GFP_KERNEL);
-	release_firmware(fw);
+	rtnl_lock();
+	if (WARN_ON(regdb && !IS_ERR(regdb))) {
+		/* just restore and free new db */
+	} else if (set_error) {
+		regdb = ERR_PTR(set_error);
+	} else if (fw) {
+		db = kmemdup(fw->data, fw->size, GFP_KERNEL);
+		if (db) {
+			regdb = db;
+			restore = context && query_regdb(context);
+		} else {
+			restore = true;
+		}
+	}
 
-	if (!db)
-		goto restore;
-	regdb = db;
+	if (restore)
+		restore_regulatory_settings(true);
 
-	if (query_regdb(context))
-		goto restore;
-	goto free;
- restore:
-	rtnl_lock();
-	restore_regulatory_settings(true);
 	rtnl_unlock();
- free:
+
 	kfree(context);
+
+	release_firmware(fw);
 }
 
 static int query_regdb_file(const char *alpha2)
 {
+	ASSERT_RTNL();
+
 	if (regdb)
 		return query_regdb(alpha2);
 
@@ -845,6 +853,38 @@ static int query_regdb_file(const char *alpha2)
 				       (void *)alpha2, regdb_fw_cb);
 }
 
+int reg_reload_regdb(void)
+{
+	const struct firmware *fw;
+	void *db;
+	int err;
+
+	err = request_firmware(&fw, "regulatory.db", &reg_pdev->dev);
+	if (err)
+		return err;
+
+	if (!valid_regdb(fw->data, fw->size)) {
+		err = -ENODATA;
+		goto out;
+	}
+
+	db = kmemdup(fw->data, fw->size, GFP_KERNEL);
+	if (!db) {
+		err = -ENOMEM;
+		goto out;
+	}
+
+	rtnl_lock();
+	if (!IS_ERR_OR_NULL(regdb))
+		kfree(regdb);
+	regdb = db;
+	rtnl_unlock();
+
+ out:
+	release_firmware(fw);
+	return err;
+}
+
 static bool reg_query_database(struct regulatory_request *request)
 {
 	/* query internal regulatory database (if it exists) */
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
2.14.2
