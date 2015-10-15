Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:37506 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752403AbbJOJrD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Oct 2015 05:47:03 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5/6] cfg80211: reg: make CRDA support optional
Date: Thu, 15 Oct 2015 11:46:57 +0200
Message-Id: <1444902418-25668-5-git-send-email-johannes@sipsolutions.net> (sfid-20151015_114722_750155_BC7D344A)
In-Reply-To: <1444902418-25668-1-git-send-email-johannes@sipsolutions.net>
References: <1444902418-25668-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

If there's a built-in regulatory database, there may be little point
in also calling out to CRDA and failing if the system is configured
that way. Allow removing CRDA support to save ~1K kernel size.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/Kconfig   |  10 +++++
 net/wireless/nl80211.c | 104 +++++++++++++++++++++++++------------------------
 net/wireless/reg.c     |  73 +++++++++++++++++++++++-----------
 3 files changed, 114 insertions(+), 73 deletions(-)

diff --git a/net/wireless/Kconfig b/net/wireless/Kconfig
index 4f5543dd2524..ab7017951083 100644
--- a/net/wireless/Kconfig
+++ b/net/wireless/Kconfig
@@ -174,6 +174,16 @@ config CFG80211_INTERNAL_REGDB
 
 	  Most distributions have a CRDA package.  So if unsure, say N.
 
+config CFG80211_CRDA_SUPPORT
+	bool "support CRDA" if EXPERT
+	default y
+	depends on CFG80211
+	help
+	  You should enable this option unless you know for sure you have no
+	  need for it, for example when using internal regdb (above.)
+
+	  If unsure, say Y.
+
 config CFG80211_WEXT
 	bool "cfg80211 wireless extensions compatibility" if !CFG80211_WEXT_EXPORT
 	depends on CFG80211
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 28c29e7da749..d693c9d031fc 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -4944,56 +4944,6 @@ static int nl80211_set_bss(struct sk_buff *skb, struct genl_info *info)
 	return err;
 }
 
-static const struct nla_policy reg_rule_policy[NL80211_REG_RULE_ATTR_MAX + 1] = {
-	[NL80211_ATTR_REG_RULE_FLAGS]		= { .type = NLA_U32 },
-	[NL80211_ATTR_FREQ_RANGE_START]		= { .type = NLA_U32 },
-	[NL80211_ATTR_FREQ_RANGE_END]		= { .type = NLA_U32 },
-	[NL80211_ATTR_FREQ_RANGE_MAX_BW]	= { .type = NLA_U32 },
-	[NL80211_ATTR_POWER_RULE_MAX_ANT_GAIN]	= { .type = NLA_U32 },
-	[NL80211_ATTR_POWER_RULE_MAX_EIRP]	= { .type = NLA_U32 },
-	[NL80211_ATTR_DFS_CAC_TIME]		= { .type = NLA_U32 },
-};
-
-static int parse_reg_rule(struct nlattr *tb[],
-	struct ieee80211_reg_rule *reg_rule)
-{
-	struct ieee80211_freq_range *freq_range = &reg_rule->freq_range;
-	struct ieee80211_power_rule *power_rule = &reg_rule->power_rule;
-
-	if (!tb[NL80211_ATTR_REG_RULE_FLAGS])
-		return -EINVAL;
-	if (!tb[NL80211_ATTR_FREQ_RANGE_START])
-		return -EINVAL;
-	if (!tb[NL80211_ATTR_FREQ_RANGE_END])
-		return -EINVAL;
-	if (!tb[NL80211_ATTR_FREQ_RANGE_MAX_BW])
-		return -EINVAL;
-	if (!tb[NL80211_ATTR_POWER_RULE_MAX_EIRP])
-		return -EINVAL;
-
-	reg_rule->flags = nla_get_u32(tb[NL80211_ATTR_REG_RULE_FLAGS]);
-
-	freq_range->start_freq_khz =
-		nla_get_u32(tb[NL80211_ATTR_FREQ_RANGE_START]);
-	freq_range->end_freq_khz =
-		nla_get_u32(tb[NL80211_ATTR_FREQ_RANGE_END]);
-	freq_range->max_bandwidth_khz =
-		nla_get_u32(tb[NL80211_ATTR_FREQ_RANGE_MAX_BW]);
-
-	power_rule->max_eirp =
-		nla_get_u32(tb[NL80211_ATTR_POWER_RULE_MAX_EIRP]);
-
-	if (tb[NL80211_ATTR_POWER_RULE_MAX_ANT_GAIN])
-		power_rule->max_antenna_gain =
-			nla_get_u32(tb[NL80211_ATTR_POWER_RULE_MAX_ANT_GAIN]);
-
-	if (tb[NL80211_ATTR_DFS_CAC_TIME])
-		reg_rule->dfs_cac_ms =
-			nla_get_u32(tb[NL80211_ATTR_DFS_CAC_TIME]);
-
-	return 0;
-}
-
 static int nl80211_req_set_reg(struct sk_buff *skb, struct genl_info *info)
 {
 	char *data = NULL;
@@ -5625,6 +5575,57 @@ out_err:
 	return err;
 }
 
+#ifdef CONFIG_CFG80211_CRDA_SUPPORT
+static const struct nla_policy reg_rule_policy[NL80211_REG_RULE_ATTR_MAX + 1] = {
+	[NL80211_ATTR_REG_RULE_FLAGS]		= { .type = NLA_U32 },
+	[NL80211_ATTR_FREQ_RANGE_START]		= { .type = NLA_U32 },
+	[NL80211_ATTR_FREQ_RANGE_END]		= { .type = NLA_U32 },
+	[NL80211_ATTR_FREQ_RANGE_MAX_BW]	= { .type = NLA_U32 },
+	[NL80211_ATTR_POWER_RULE_MAX_ANT_GAIN]	= { .type = NLA_U32 },
+	[NL80211_ATTR_POWER_RULE_MAX_EIRP]	= { .type = NLA_U32 },
+	[NL80211_ATTR_DFS_CAC_TIME]		= { .type = NLA_U32 },
+};
+
+static int parse_reg_rule(struct nlattr *tb[],
+	struct ieee80211_reg_rule *reg_rule)
+{
+	struct ieee80211_freq_range *freq_range = &reg_rule->freq_range;
+	struct ieee80211_power_rule *power_rule = &reg_rule->power_rule;
+
+	if (!tb[NL80211_ATTR_REG_RULE_FLAGS])
+		return -EINVAL;
+	if (!tb[NL80211_ATTR_FREQ_RANGE_START])
+		return -EINVAL;
+	if (!tb[NL80211_ATTR_FREQ_RANGE_END])
+		return -EINVAL;
+	if (!tb[NL80211_ATTR_FREQ_RANGE_MAX_BW])
+		return -EINVAL;
+	if (!tb[NL80211_ATTR_POWER_RULE_MAX_EIRP])
+		return -EINVAL;
+
+	reg_rule->flags = nla_get_u32(tb[NL80211_ATTR_REG_RULE_FLAGS]);
+
+	freq_range->start_freq_khz =
+		nla_get_u32(tb[NL80211_ATTR_FREQ_RANGE_START]);
+	freq_range->end_freq_khz =
+		nla_get_u32(tb[NL80211_ATTR_FREQ_RANGE_END]);
+	freq_range->max_bandwidth_khz =
+		nla_get_u32(tb[NL80211_ATTR_FREQ_RANGE_MAX_BW]);
+
+	power_rule->max_eirp =
+		nla_get_u32(tb[NL80211_ATTR_POWER_RULE_MAX_EIRP]);
+
+	if (tb[NL80211_ATTR_POWER_RULE_MAX_ANT_GAIN])
+		power_rule->max_antenna_gain =
+			nla_get_u32(tb[NL80211_ATTR_POWER_RULE_MAX_ANT_GAIN]);
+
+	if (tb[NL80211_ATTR_DFS_CAC_TIME])
+		reg_rule->dfs_cac_ms =
+			nla_get_u32(tb[NL80211_ATTR_DFS_CAC_TIME]);
+
+	return 0;
+}
+
 static int nl80211_set_reg(struct sk_buff *skb, struct genl_info *info)
 {
 	struct nlattr *tb[NL80211_REG_RULE_ATTR_MAX + 1];
@@ -5701,6 +5702,7 @@ static int nl80211_set_reg(struct sk_buff *skb, struct genl_info *info)
 	kfree(rd);
 	return r;
 }
+#endif /* CONFIG_CFG80211_CRDA_SUPPORT */
 
 static int validate_scan_freqs(struct nlattr *freqs)
 {
@@ -10895,6 +10897,7 @@ static const struct genl_ops nl80211_ops[] = {
 		.internal_flags = NL80211_FLAG_NEED_RTNL,
 		/* can be retrieved by unprivileged users */
 	},
+#ifdef CONFIG_CFG80211_CRDA_SUPPORT
 	{
 		.cmd = NL80211_CMD_SET_REG,
 		.doit = nl80211_set_reg,
@@ -10902,6 +10905,7 @@ static const struct genl_ops nl80211_ops[] = {
 		.flags = GENL_ADMIN_PERM,
 		.internal_flags = NL80211_FLAG_NEED_RTNL,
 	},
+#endif
 	{
 		.cmd = NL80211_CMD_REQ_SET_REG,
 		.doit = nl80211_req_set_reg,
diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 3c4363be6bb0..2d1343a7b60e 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -135,10 +135,7 @@ static spinlock_t reg_indoor_lock;
 /* Used to track the userspace process controlling the indoor setting */
 static u32 reg_is_indoor_portid;
 
-/* Max number of consecutive attempts to communicate with CRDA  */
-#define REG_MAX_CRDA_TIMEOUTS 10
-
-static u32 reg_crda_timeouts;
+static void restore_regulatory_settings(bool reset_user);
 
 static const struct ieee80211_regdomain *get_cfg80211_regdom(void)
 {
@@ -226,9 +223,6 @@ static DECLARE_DELAYED_WORK(reg_check_chans, reg_check_chans_work);
 static void reg_todo(struct work_struct *work);
 static DECLARE_WORK(reg_work, reg_todo);
 
-static void reg_timeout_work(struct work_struct *work);
-static DECLARE_DELAYED_WORK(reg_timeout, reg_timeout_work);
-
 /* We keep a static world regulatory domain in case of the absence of CRDA */
 static const struct ieee80211_regdomain world_regdom = {
 	.n_reg_rules = 8,
@@ -533,6 +527,39 @@ static inline int reg_regdb_query(const char *alpha2)
 }
 #endif /* CONFIG_CFG80211_INTERNAL_REGDB */
 
+#ifdef CONFIG_CFG80211_CRDA_SUPPORT
+/* Max number of consecutive attempts to communicate with CRDA  */
+#define REG_MAX_CRDA_TIMEOUTS 10
+
+static u32 reg_crda_timeouts;
+
+static void crda_timeout_work(struct work_struct *work);
+static DECLARE_DELAYED_WORK(crda_timeout, crda_timeout_work);
+
+static void crda_timeout_work(struct work_struct *work)
+{
+	REG_DBG_PRINT("Timeout while waiting for CRDA to reply, restoring regulatory settings\n");
+	rtnl_lock();
+	reg_crda_timeouts++;
+	restore_regulatory_settings(true);
+	rtnl_unlock();
+}
+
+static void cancel_crda_timeout(void)
+{
+	cancel_delayed_work(&crda_timeout);
+}
+
+static void cancel_crda_timeout_sync(void)
+{
+	cancel_delayed_work_sync(&crda_timeout);
+}
+
+static void reset_crda_timeouts(void)
+{
+	reg_crda_timeouts = 0;
+}
+
 /*
  * This lets us keep regulatory code which is updated on a regulatory
  * basis in userspace.
@@ -562,9 +589,18 @@ static int call_crda(const char *alpha2)
 		return ret;
 
 	queue_delayed_work(system_power_efficient_wq,
-			   &reg_timeout, msecs_to_jiffies(3142));
+			   &crda_timeout, msecs_to_jiffies(3142));
 	return 0;
 }
+#else
+static inline void cancel_crda_timeout(void) {}
+static inline void cancel_crda_timeout_sync(void) {}
+static inline void reset_crda_timeouts(void) {}
+static inline int call_crda(const char *alpha2)
+{
+	return -ENODATA;
+}
+#endif /* CONFIG_CFG80211_CRDA_SUPPORT */
 
 static enum reg_request_treatment
 reg_query_database(struct regulatory_request *request)
@@ -1857,7 +1893,7 @@ static void reg_set_request_processed(void)
 		need_more_processing = true;
 	spin_unlock(&reg_requests_lock);
 
-	cancel_delayed_work(&reg_timeout);
+	cancel_crda_timeout();
 
 	if (need_more_processing)
 		schedule_work(&reg_work);
@@ -2356,7 +2392,7 @@ int regulatory_hint_user(const char *alpha2,
 	request->user_reg_hint_type = user_reg_hint_type;
 
 	/* Allow calling CRDA again */
-	reg_crda_timeouts = 0;
+	reset_crda_timeouts();
 
 	queue_regulatory_request(request);
 
@@ -2428,7 +2464,7 @@ int regulatory_hint(struct wiphy *wiphy, const char *alpha2)
 	request->initiator = NL80211_REGDOM_SET_BY_DRIVER;
 
 	/* Allow calling CRDA again */
-	reg_crda_timeouts = 0;
+	reset_crda_timeouts();
 
 	queue_regulatory_request(request);
 
@@ -2484,7 +2520,7 @@ void regulatory_hint_country_ie(struct wiphy *wiphy, enum ieee80211_band band,
 	request->country_ie_env = env;
 
 	/* Allow calling CRDA again */
-	reg_crda_timeouts = 0;
+	reset_crda_timeouts();
 
 	queue_regulatory_request(request);
 	request = NULL;
@@ -2971,7 +3007,7 @@ int set_regdom(const struct ieee80211_regdomain *rd,
 	}
 
 	if (regd_src == REGD_SOURCE_CRDA)
-		reg_crda_timeouts = 0;
+		reset_crda_timeouts();
 
 	lr = get_last_request();
 
@@ -3128,15 +3164,6 @@ void wiphy_regulatory_deregister(struct wiphy *wiphy)
 	lr->country_ie_env = ENVIRON_ANY;
 }
 
-static void reg_timeout_work(struct work_struct *work)
-{
-	REG_DBG_PRINT("Timeout while waiting for CRDA to reply, restoring regulatory settings\n");
-	rtnl_lock();
-	reg_crda_timeouts++;
-	restore_regulatory_settings(true);
-	rtnl_unlock();
-}
-
 /*
  * See http://www.fcc.gov/document/5-ghz-unlicensed-spectrum-unii, for
  * UNII band definitions
@@ -3222,7 +3249,7 @@ void regulatory_exit(void)
 	struct reg_beacon *reg_beacon, *btmp;
 
 	cancel_work_sync(&reg_work);
-	cancel_delayed_work_sync(&reg_timeout);
+	cancel_crda_timeout_sync();
 	cancel_delayed_work_sync(&reg_check_chans);
 
 	/* Lock to suppress warnings */
-- 
2.5.1

