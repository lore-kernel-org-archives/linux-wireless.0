Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:37242 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751424AbdIOKSQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 15 Sep 2017 06:18:16 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [RFC 1/4] cfg80211: support loading regulatory database as firmware file
Date: Fri, 15 Sep 2017 12:18:07 +0200
Message-Id: <20170915101810.11435-2-johannes@sipsolutions.net> (sfid-20170915_121824_153347_6F1B19D0)
In-Reply-To: <20170915101810.11435-1-johannes@sipsolutions.net>
References: <20170915101810.11435-1-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

As the current regulatory database is only about 4k big, and already
difficult to extend, we decided that overall it would be better to
get rid of the complications with CRDA and load the database into the
kernel directly, but in a new format that is extensible.

The new file format can be extended since it carries a length field
on all the structs that need to be extensible.

In order to be able to request firmware when the module initializes,
move cfg80211 from subsys_initcall() to the later fs_initcall(); the
firmware loader is at the same level but linked earlier, so it can
be called from there. Otherwise, when both the firmware loader and
cfg80211 are built-in, the request will crash the kernel. We also
need to be before device_initcall() so that cfg80211 is available
for devices when they initialize.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 Documentation/networking/regulatory.txt |   8 +
 net/wireless/Kconfig                    |   4 +-
 net/wireless/core.c                     |   2 +-
 net/wireless/reg.c                      | 265 +++++++++++++++++++++++++++++---
 4 files changed, 255 insertions(+), 24 deletions(-)

diff --git a/Documentation/networking/regulatory.txt b/Documentation/networking/regulatory.txt
index 7818b5fe448b..46c8d8b1cc66 100644
--- a/Documentation/networking/regulatory.txt
+++ b/Documentation/networking/regulatory.txt
@@ -19,6 +19,14 @@ core regulatory domain all wireless devices should adhere to.
 How to get regulatory domains to the kernel
 -------------------------------------------
 
+When the regulatory domain is first set up, the kernel will request a
+database file (regulatory.db) containing all the regulatory rules. It
+will then use that database when it needs to look up the rules for a
+given country.
+
+How to get regulatory domains to the kernel (old CRDA solution)
+---------------------------------------------------------------
+
 Userspace gets a regulatory domain in the kernel by having
 a userspace agent build it and send it via nl80211. Only
 expected regulatory domains will be respected by the kernel.
diff --git a/net/wireless/Kconfig b/net/wireless/Kconfig
index 6c606120abfe..24eec5516649 100644
--- a/net/wireless/Kconfig
+++ b/net/wireless/Kconfig
@@ -19,6 +19,7 @@ config WEXT_PRIV
 config CFG80211
 	tristate "cfg80211 - wireless configuration API"
 	depends on RFKILL || !RFKILL
+	select FW_LOADER
 	---help---
 	  cfg80211 is the Linux wireless LAN (802.11) configuration API.
 	  Enable this if you have a wireless device.
@@ -167,7 +168,8 @@ config CFG80211_CRDA_SUPPORT
 	depends on CFG80211
 	help
 	  You should enable this option unless you know for sure you have no
-	  need for it, for example when using internal regdb (above.)
+	  need for it, for example when using internal regdb (above) or the
+	  database loaded as a firmware file.
 
 	  If unsure, say Y.
 
diff --git a/net/wireless/core.c b/net/wireless/core.c
index 7b33e8c366bc..fdde0d98fde1 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -1384,7 +1384,7 @@ static int __init cfg80211_init(void)
 out_fail_pernet:
 	return err;
 }
-subsys_initcall(cfg80211_init);
+fs_initcall(cfg80211_init);
 
 static void __exit cfg80211_exit(void)
 {
diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 5fae296a6a58..7a1d6cda64f3 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -53,6 +53,7 @@
 #include <linux/nl80211.h>
 #include <linux/platform_device.h>
 #include <linux/moduleparam.h>
+#include <linux/firmware.h>
 #include <net/cfg80211.h>
 #include "core.h"
 #include "reg.h"
@@ -99,7 +100,7 @@ static struct regulatory_request core_request_world = {
 static struct regulatory_request __rcu *last_request =
 	(void __force __rcu *)&core_request_world;
 
-/* To trigger userspace events */
+/* To trigger userspace events and load firmware */
 static struct platform_device *reg_pdev;
 
 /*
@@ -442,7 +443,6 @@ reg_copy_regd(const struct ieee80211_regdomain *src_regd)
 	return regd;
 }
 
-#ifdef CONFIG_CFG80211_INTERNAL_REGDB
 struct reg_regdb_apply_request {
 	struct list_head list;
 	const struct ieee80211_regdomain *regdom;
@@ -474,41 +474,44 @@ static void reg_regdb_apply(struct work_struct *work)
 
 static DECLARE_WORK(reg_regdb_work, reg_regdb_apply);
 
-static int reg_query_builtin(const char *alpha2)
+static int reg_schedule_apply(const struct ieee80211_regdomain *regdom)
 {
-	const struct ieee80211_regdomain *regdom = NULL;
 	struct reg_regdb_apply_request *request;
-	unsigned int i;
-
-	for (i = 0; i < reg_regdb_size; i++) {
-		if (alpha2_equal(alpha2, reg_regdb[i]->alpha2)) {
-			regdom = reg_regdb[i];
-			break;
-		}
-	}
-
-	if (!regdom)
-		return -ENODATA;
 
 	request = kzalloc(sizeof(struct reg_regdb_apply_request), GFP_KERNEL);
-	if (!request)
-		return -ENOMEM;
-
-	request->regdom = reg_copy_regd(regdom);
-	if (IS_ERR_OR_NULL(request->regdom)) {
-		kfree(request);
+	if (!request) {
+		kfree(regdom);
 		return -ENOMEM;
 	}
 
+	request->regdom = regdom;
+
 	mutex_lock(&reg_regdb_apply_mutex);
 	list_add_tail(&request->list, &reg_regdb_apply_list);
 	mutex_unlock(&reg_regdb_apply_mutex);
 
 	schedule_work(&reg_regdb_work);
-
 	return 0;
 }
 
+#ifdef CONFIG_CFG80211_INTERNAL_REGDB
+static int reg_query_builtin(const char *alpha2)
+{
+	const struct ieee80211_regdomain *regdom = NULL;
+	unsigned int i;
+
+	for (i = 0; i < reg_regdb_size; i++) {
+		if (alpha2_equal(alpha2, reg_regdb[i]->alpha2)) {
+			regdom = reg_copy_regd(reg_regdb[i]);
+			break;
+		}
+	}
+	if (!regdom)
+		return -ENODATA;
+
+	return reg_schedule_apply(regdom);
+}
+
 /* Feel free to add any other sanity checks here */
 static void reg_regdb_size_check(void)
 {
@@ -598,12 +601,227 @@ static inline int call_crda(const char *alpha2)
 }
 #endif /* CONFIG_CFG80211_CRDA_SUPPORT */
 
+/* code to directly load a firmware database through request_firmware */
+static const struct firmware *regdb;
+static unsigned int fwregdb_attempts = 10;
+
+struct fwdb_country {
+	u8 alpha2[2];
+	__be16 coll_ptr;
+} __packed __aligned(4);
+
+struct fwdb_collection {
+	__be16 len;
+	__be16 n_rules;
+	u8 dfs_region;
+	u8 pad_reserved;
+	__be16 rules_ptr[];
+} __packed __aligned(4);
+
+struct fwdb_rule {
+	__be16 len;
+	__be16 flags;
+	__be32 start, end, max_bw;
+	__be32 cac_timeout;
+	__be16 max_ant_gain;
+	__be16 max_eirp;
+} __packed __aligned(4);
+
+#define FWDB_MAGIC 0x52474442
+#define FWDB_VERSION 20
+
+struct fwdb_header {
+	__be32 magic;
+	__be32 version;
+	struct fwdb_country country[];
+} __packed __aligned(4);
+
+static bool valid_rule(const struct firmware *db, u16 rule_ptr)
+{
+	struct fwdb_rule *rule = (void *)(db->data + (rule_ptr << 2));
+
+	if ((u8 *)rule + sizeof(rule->len) > db->data + db->size)
+		return false;
+
+	/* mandatory fields */
+	if (be16_to_cpu(rule->len) < offsetofend(struct fwdb_rule, max_eirp))
+		return false;
+
+	return true;
+}
+
+static bool valid_country(const struct firmware *db,
+			  const struct fwdb_country *country)
+{
+	unsigned int ptr = be16_to_cpu(country->coll_ptr) << 2;
+	struct fwdb_collection *coll = (void *)(db->data + ptr);
+	unsigned int i;
+
+	if ((u8 *)coll + sizeof(coll->len) > db->data + db->size)
+		return false;
+
+	if ((u8 *)coll + be16_to_cpu(coll->len) > db->data + db->size)
+		return false;
+
+	/* mandatory fields */
+	if (be16_to_cpu(coll->len) < offsetof(struct fwdb_collection,
+					      rules_ptr))
+		return false;
+
+	if (be16_to_cpu(coll->len) < offsetof(struct fwdb_collection,
+					      rules_ptr) +
+				     be16_to_cpu(coll->n_rules) *
+					sizeof(coll->rules_ptr[0]))
+		return false;
+
+	for (i = 0; i < be16_to_cpu(coll->n_rules); i++) {
+		u16 rule_ptr = be16_to_cpu(coll->rules_ptr[i]);
+
+		if (!valid_rule(db, rule_ptr))
+			return false;
+	}
+
+	return true;
+}
+
+static bool valid_regdb(const struct firmware *db)
+{
+	const struct fwdb_header *hdr = (void *)db->data;
+	const struct fwdb_country *country;
+
+	if (db->size < sizeof(*hdr))
+		return false;
+
+	if (hdr->magic != cpu_to_be32(FWDB_MAGIC))
+		return false;
+
+	if (hdr->version != cpu_to_be32(FWDB_VERSION))
+		return false;
+
+	country = &hdr->country[0];
+	while ((u8 *)(country + 1) <= db->data + db->size) {
+		if (!country->coll_ptr)
+			break;
+		if (!valid_country(db, country))
+			return false;
+		country++;
+	}
+
+	return true;
+}
+
+static int regdb_query_country(const struct firmware *db,
+			       const struct fwdb_country *country)
+{
+	unsigned int ptr = be16_to_cpu(country->coll_ptr) << 2;
+	struct fwdb_collection *coll = (void *)(db->data + ptr);
+	struct ieee80211_regdomain *regdom;
+	unsigned int size_of_regd;
+	unsigned int i;
+
+	size_of_regd =
+		sizeof(struct ieee80211_regdomain) +
+		be16_to_cpu(coll->n_rules) * sizeof(struct ieee80211_reg_rule);
+
+	regdom = kzalloc(size_of_regd, GFP_KERNEL);
+	if (!regdom)
+		return -ENOMEM;
+
+	regdom->n_reg_rules = be16_to_cpu(coll->n_rules);
+	regdom->alpha2[0] = country->alpha2[0];
+	regdom->alpha2[1] = country->alpha2[1];
+	regdom->dfs_region = coll->dfs_region;
+
+	for (i = 0; i < regdom->n_reg_rules; i++) {
+		unsigned int rule_ptr = be16_to_cpu(coll->rules_ptr[i]) << 2;
+		struct fwdb_rule *rule = (void *)(db->data + rule_ptr);
+		struct ieee80211_reg_rule *rrule = &regdom->reg_rules[i];
+
+		rrule->freq_range.start_freq_khz = be32_to_cpu(rule->start);
+		rrule->freq_range.end_freq_khz = be32_to_cpu(rule->end);
+		rrule->freq_range.max_bandwidth_khz = be32_to_cpu(rule->max_bw);
+
+		rrule->power_rule.max_antenna_gain =
+			be16_to_cpu(rule->max_ant_gain);
+		rrule->power_rule.max_eirp = be16_to_cpu(rule->max_eirp);
+
+		rrule->flags = be16_to_cpu(rule->flags);
+		rrule->dfs_cac_ms = be32_to_cpu(rule->cac_timeout);
+	}
+
+	return reg_schedule_apply(regdom);
+}
+
+static int query_regdb(const char *alpha2)
+{
+	const struct fwdb_header *hdr;
+	const struct fwdb_country *country;
+
+	if (IS_ERR(regdb))
+		return PTR_ERR(regdb);
+
+	hdr = (void *)regdb->data;
+	country = &hdr->country[0];
+	while (country->coll_ptr) {
+		if (alpha2_equal(alpha2, country->alpha2))
+			return regdb_query_country(regdb, country);
+		country++;
+	}
+
+	return -ENODATA;
+}
+
+static void regdb_fw_cb(const struct firmware *fw, void *context)
+{
+	if (!fw) {
+		pr_info("failed to load regulatory.db\n");
+		if (fwregdb_attempts-- == 0)
+			regdb = ERR_PTR(-ENODATA);
+		goto restore;
+	}
+
+	if (!valid_regdb(fw)) {
+		pr_info("loaded regulatory.db is malformed\n");
+		release_firmware(fw);
+		regdb = ERR_PTR(-EINVAL);
+		goto restore;
+	}
+
+	regdb = fw;
+	if (query_regdb(context))
+		goto restore;
+	goto free;
+ restore:
+	rtnl_lock();
+	restore_regulatory_settings(true);
+	rtnl_unlock();
+ free:
+	kfree(context);
+}
+
+static int query_regdb_file(const char *alpha2)
+{
+	if (regdb)
+		return query_regdb(alpha2);
+
+	alpha2 = kmemdup(alpha2, 2, GFP_KERNEL);
+	if (!alpha2)
+		return -ENOMEM;
+
+	return request_firmware_nowait(THIS_MODULE, true, "regulatory.db",
+				       &reg_pdev->dev, GFP_KERNEL,
+				       (void *)alpha2, regdb_fw_cb);
+}
+
 static bool reg_query_database(struct regulatory_request *request)
 {
 	/* query internal regulatory database (if it exists) */
 	if (reg_query_builtin(request->alpha2) == 0)
 		return true;
 
+	if (query_regdb_file(request->alpha2) == 0)
+		return true;
+
 	if (call_crda(request->alpha2) == 0)
 		return true;
 
@@ -3344,4 +3562,7 @@ void regulatory_exit(void)
 		list_del(&reg_request->list);
 		kfree(reg_request);
 	}
+
+	if (!IS_ERR_OR_NULL(regdb))
+		release_firmware(regdb);
 }
-- 
2.14.1
