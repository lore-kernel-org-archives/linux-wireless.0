Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53242 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946004Ab2LFQsS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Dec 2012 11:48:18 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 22/24] regulatory: use RCU to protect global and wiphy regdomains
Date: Thu,  6 Dec 2012 17:47:46 +0100
Message-Id: <1354812468-15709-23-git-send-email-johannes@sipsolutions.net> (sfid-20121206_174905_966334_CC7ACD45)
In-Reply-To: <1354812468-15709-1-git-send-email-johannes@sipsolutions.net>
References: <1354812468-15709-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

To simplify the locking and not require cfg80211_mutex
(which nl80211 uses to access the global regdomain) and
also to make it possible for drivers to access their
wiphy->regd safely, use RCU to protect these pointers.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/cfg80211.h   |   2 +-
 include/net/regulatory.h |   2 +
 net/wireless/nl80211.c   |  36 +++++++--------
 net/wireless/reg.c       | 113 +++++++++++++++++++++++++++--------------------
 net/wireless/reg.h       |   2 +-
 5 files changed, 88 insertions(+), 67 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 84fcb10..461d979 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -2369,7 +2369,7 @@ struct wiphy {
 
 	/* fields below are read-only, assigned by cfg80211 */
 
-	const struct ieee80211_regdomain *regd;
+	const struct ieee80211_regdomain __rcu *regd;
 
 	/* the item in /sys/class/ieee80211/ points to this,
 	 * you need use set_wiphy_dev() (see below) */
diff --git a/include/net/regulatory.h b/include/net/regulatory.h
index 7dcaa27..96b0f07 100644
--- a/include/net/regulatory.h
+++ b/include/net/regulatory.h
@@ -18,6 +18,7 @@
  * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 
+#include <linux/rcupdate.h>
 
 /**
  * enum environment_cap - Environment parsed from country IE
@@ -101,6 +102,7 @@ struct ieee80211_reg_rule {
 };
 
 struct ieee80211_regdomain {
+	struct rcu_head rcu_head;
 	u32 n_reg_rules;
 	char alpha2[2];
 	u8 dfs_region;
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 370cd31..dd3df5c 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -3811,12 +3811,8 @@ static int nl80211_req_set_reg(struct sk_buff *skb, struct genl_info *info)
 	 * window between nl80211_init() and regulatory_init(), if that is
 	 * even possible.
 	 */
-	mutex_lock(&cfg80211_mutex);
-	if (unlikely(!cfg80211_regdomain)) {
-		mutex_unlock(&cfg80211_mutex);
+	if (unlikely(!rcu_access_pointer(cfg80211_regdomain)))
 		return -EINPROGRESS;
-	}
-	mutex_unlock(&cfg80211_mutex);
 
 	if (!info->attrs[NL80211_ATTR_REG_ALPHA2])
 		return -EINVAL;
@@ -4176,6 +4172,7 @@ static int nl80211_update_mesh_config(struct sk_buff *skb,
 
 static int nl80211_get_reg(struct sk_buff *skb, struct genl_info *info)
 {
+	const struct ieee80211_regdomain *regdom;
 	struct sk_buff *msg;
 	void *hdr = NULL;
 	struct nlattr *nl_reg_rules;
@@ -4198,35 +4195,36 @@ static int nl80211_get_reg(struct sk_buff *skb, struct genl_info *info)
 	if (!hdr)
 		goto put_failure;
 
-	if (nla_put_string(msg, NL80211_ATTR_REG_ALPHA2,
-			   cfg80211_regdomain->alpha2) ||
-	    (cfg80211_regdomain->dfs_region &&
-	     nla_put_u8(msg, NL80211_ATTR_DFS_REGION,
-			cfg80211_regdomain->dfs_region)))
-		goto nla_put_failure;
+	rcu_read_lock();
+	regdom = rcu_dereference(cfg80211_regdomain);
+
+	if (nla_put_string(msg, NL80211_ATTR_REG_ALPHA2, regdom->alpha2) ||
+	    (regdom->dfs_region &&
+	     nla_put_u8(msg, NL80211_ATTR_DFS_REGION, regdom->dfs_region)))
+		goto nla_put_failure_rcu;
 
 	if (reg_last_request_cell_base() &&
 	    nla_put_u32(msg, NL80211_ATTR_USER_REG_HINT_TYPE,
 			NL80211_USER_REG_HINT_CELL_BASE))
-		goto nla_put_failure;
+		goto nla_put_failure_rcu;
 
 	nl_reg_rules = nla_nest_start(msg, NL80211_ATTR_REG_RULES);
 	if (!nl_reg_rules)
-		goto nla_put_failure;
+		goto nla_put_failure_rcu;
 
-	for (i = 0; i < cfg80211_regdomain->n_reg_rules; i++) {
+	for (i = 0; i < regdom->n_reg_rules; i++) {
 		struct nlattr *nl_reg_rule;
 		const struct ieee80211_reg_rule *reg_rule;
 		const struct ieee80211_freq_range *freq_range;
 		const struct ieee80211_power_rule *power_rule;
 
-		reg_rule = &cfg80211_regdomain->reg_rules[i];
+		reg_rule = &regdom->reg_rules[i];
 		freq_range = &reg_rule->freq_range;
 		power_rule = &reg_rule->power_rule;
 
 		nl_reg_rule = nla_nest_start(msg, i);
 		if (!nl_reg_rule)
-			goto nla_put_failure;
+			goto nla_put_failure_rcu;
 
 		if (nla_put_u32(msg, NL80211_ATTR_REG_RULE_FLAGS,
 				reg_rule->flags) ||
@@ -4240,10 +4238,11 @@ static int nl80211_get_reg(struct sk_buff *skb, struct genl_info *info)
 				power_rule->max_antenna_gain) ||
 		    nla_put_u32(msg, NL80211_ATTR_POWER_RULE_MAX_EIRP,
 				power_rule->max_eirp))
-			goto nla_put_failure;
+			goto nla_put_failure_rcu;
 
 		nla_nest_end(msg, nl_reg_rule);
 	}
+	rcu_read_unlock();
 
 	nla_nest_end(msg, nl_reg_rules);
 
@@ -4251,7 +4250,8 @@ static int nl80211_get_reg(struct sk_buff *skb, struct genl_info *info)
 	err = genlmsg_reply(msg, info);
 	goto out;
 
-nla_put_failure:
+nla_put_failure_rcu:
+	rcu_read_unlock();
 	genlmsg_cancel(msg, hdr);
 put_failure:
 	nlmsg_free(msg);
diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index ff5ac4a..6082c68 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -95,15 +95,15 @@ static struct device_type reg_device_type = {
  * Central wireless core regulatory domains, we only need two,
  * the current one and a world regulatory domain in case we have no
  * information to give us an alpha2.
- * Protected by the cfg80211_mutex.
  */
-const struct ieee80211_regdomain *cfg80211_regdomain;
+const struct ieee80211_regdomain __rcu *cfg80211_regdomain;
 
 /*
  * Protects static reg.c components:
- *     - cfg80211_world_regdom
- *     - last_request
- *     - reg_num_devs_support_basehint
+ *	- cfg80211_regdomain (if not used with RCU)
+ *	- cfg80211_world_regdom
+ *	- last_request
+ *	- reg_num_devs_support_basehint
  */
 static DEFINE_MUTEX(reg_mutex);
 
@@ -118,6 +118,25 @@ static inline void assert_reg_lock(void)
 	lockdep_assert_held(&reg_mutex);
 }
 
+static const struct ieee80211_regdomain *get_cfg80211_regdom(void)
+{
+	return rcu_dereference_protected(cfg80211_regdomain,
+					 lockdep_is_held(&reg_mutex));
+}
+
+static const struct ieee80211_regdomain *get_wiphy_regdom(struct wiphy *wiphy)
+{
+	return rcu_dereference_protected(wiphy->regd,
+					 lockdep_is_held(&reg_mutex));
+}
+
+static void rcu_free_regdom(const struct ieee80211_regdomain *r)
+{
+	if (!r)
+		return;
+	kfree_rcu((struct ieee80211_regdomain *)r, rcu_head);
+}
+
 /* Used to queue up regulatory hints */
 static LIST_HEAD(reg_requests_list);
 static spinlock_t reg_requests_lock;
@@ -187,22 +206,25 @@ MODULE_PARM_DESC(ieee80211_regdom, "IEEE 802.11 regulatory domain code");
 static void reset_regdomains(bool full_reset,
 			     const struct ieee80211_regdomain *new_regdom)
 {
-	assert_cfg80211_lock();
+	const struct ieee80211_regdomain *r;
+
 	assert_reg_lock();
 
+	r = get_cfg80211_regdom();
+
 	/* avoid freeing static information or freeing something twice */
-	if (cfg80211_regdomain == cfg80211_world_regdom)
-		cfg80211_regdomain = NULL;
+	if (r == cfg80211_world_regdom)
+		r = NULL;
 	if (cfg80211_world_regdom == &world_regdom)
 		cfg80211_world_regdom = NULL;
-	if (cfg80211_regdomain == &world_regdom)
-		cfg80211_regdomain = NULL;
+	if (r == &world_regdom)
+		r = NULL;
 
-	kfree(cfg80211_regdomain);
-	kfree(cfg80211_world_regdom);
+	rcu_free_regdom(r);
+	rcu_free_regdom(cfg80211_world_regdom);
 
 	cfg80211_world_regdom = &world_regdom;
-	cfg80211_regdomain = new_regdom;
+	rcu_assign_pointer(cfg80211_regdomain, new_regdom);
 
 	if (!full_reset)
 		return;
@@ -220,7 +242,6 @@ static void update_world_regdomain(const struct ieee80211_regdomain *rd)
 {
 	WARN_ON(!last_request);
 
-	assert_cfg80211_lock();
 	assert_reg_lock();
 
 	reset_regdomains(false, rd);
@@ -281,11 +302,11 @@ static bool alpha2_equal(const char *alpha2_x, const char *alpha2_y)
 
 static bool regdom_changes(const char *alpha2)
 {
-	assert_cfg80211_lock();
+	const struct ieee80211_regdomain *r = get_cfg80211_regdom();
 
-	if (!cfg80211_regdomain)
+	if (!r)
 		return true;
-	return !alpha2_equal(cfg80211_regdomain->alpha2, alpha2);
+	return !alpha2_equal(r->alpha2, alpha2);
 }
 
 /*
@@ -728,7 +749,6 @@ int freq_reg_info(struct wiphy *wiphy, u32 center_freq,
 	const struct ieee80211_regdomain *regd;
 
 	assert_reg_lock();
-	assert_cfg80211_lock();
 
 	/*
 	 * Follow the driver's regulatory domain, if present, unless a country
@@ -737,9 +757,9 @@ int freq_reg_info(struct wiphy *wiphy, u32 center_freq,
 	if (last_request->initiator != NL80211_REGDOM_SET_BY_COUNTRY_IE &&
 	    last_request->initiator != NL80211_REGDOM_SET_BY_USER &&
 	    wiphy->regd)
-		regd = wiphy->regd;
+		regd = get_wiphy_regdom(wiphy);
 	else
-		regd = cfg80211_regdomain;
+		regd = get_cfg80211_regdom();
 
 	return freq_reg_info_regd(wiphy, center_freq, reg_rule, regd);
 }
@@ -810,8 +830,6 @@ static void handle_channel(struct wiphy *wiphy,
 	const struct ieee80211_freq_range *freq_range = NULL;
 	struct wiphy *request_wiphy = NULL;
 
-	assert_cfg80211_lock();
-
 	request_wiphy = wiphy_idx_to_wiphy(last_request->wiphy_idx);
 
 	flags = chan->orig_flags;
@@ -1061,15 +1079,17 @@ static void wiphy_update_beacon_reg(struct wiphy *wiphy)
 
 static bool reg_is_world_roaming(struct wiphy *wiphy)
 {
-	assert_cfg80211_lock();
+	const struct ieee80211_regdomain *cr = get_cfg80211_regdom();
+	const struct ieee80211_regdomain *wr = get_wiphy_regdom(wiphy);
 
-	if (is_world_regdom(cfg80211_regdomain->alpha2) ||
-	    (wiphy->regd && is_world_regdom(wiphy->regd->alpha2)))
+	if (is_world_regdom(cr->alpha2) || (wr && is_world_regdom(wr->alpha2)))
 		return true;
+
 	if (last_request &&
 	    last_request->initiator != NL80211_REGDOM_SET_BY_COUNTRY_IE &&
 	    wiphy->flags & WIPHY_FLAG_CUSTOM_REGULATORY)
 		return true;
+
 	return false;
 }
 
@@ -1166,13 +1186,12 @@ static void wiphy_update_regulatory(struct wiphy *wiphy,
 {
 	enum ieee80211_band band;
 
-	assert_cfg80211_lock();
 	assert_reg_lock();
 
 	if (ignore_reg_update(wiphy, initiator))
 		return;
 
-	last_request->dfs_region = cfg80211_regdomain->dfs_region;
+	last_request->dfs_region = get_cfg80211_regdom()->dfs_region;
 
 	for (band = 0; band < IEEE80211_NUM_BANDS; band++)
 		handle_band(wiphy, initiator, wiphy->bands[band]);
@@ -1189,6 +1208,8 @@ static void update_all_wiphy_regulatory(enum nl80211_reg_initiator initiator)
 	struct cfg80211_registered_device *rdev;
 	struct wiphy *wiphy;
 
+	assert_cfg80211_lock();
+
 	list_for_each_entry(rdev, &cfg80211_rdev_list, list) {
 		wiphy = &rdev->wiphy;
 		wiphy_update_regulatory(wiphy, initiator);
@@ -1403,7 +1424,7 @@ static void reg_set_request_processed(void)
  *
  * Returns one of the different reg request treatment values.
  *
- * Caller must hold &cfg80211_mutex and &reg_mutex
+ * Caller must hold &reg_mutex
  */
 static enum reg_request_treatment
 __regulatory_hint(struct wiphy *wiphy,
@@ -1413,20 +1434,18 @@ __regulatory_hint(struct wiphy *wiphy,
 	bool intersect = false;
 	enum reg_request_treatment treatment;
 
-	assert_cfg80211_lock();
-
 	treatment = get_reg_request_treatment(wiphy, pending_request);
 
 	switch (treatment) {
 	case REG_REQ_INTERSECT:
 		if (pending_request->initiator ==
 		    NL80211_REGDOM_SET_BY_DRIVER) {
-			regd = reg_copy_regd(cfg80211_regdomain);
+			regd = reg_copy_regd(get_cfg80211_regdom());
 			if (IS_ERR(regd)) {
 				kfree(pending_request);
 				return PTR_ERR(regd);
 			}
-			wiphy->regd = regd;
+			rcu_assign_pointer(wiphy->regd, regd);
 		}
 		intersect = true;
 		break;
@@ -1440,13 +1459,13 @@ __regulatory_hint(struct wiphy *wiphy,
 		 */
 		if (treatment == REG_REQ_ALREADY_SET &&
 		    pending_request->initiator == NL80211_REGDOM_SET_BY_DRIVER) {
-			regd = reg_copy_regd(cfg80211_regdomain);
+			regd = reg_copy_regd(get_cfg80211_regdom());
 			if (IS_ERR(regd)) {
 				kfree(pending_request);
 				return REG_REQ_IGNORE;
 			}
 			treatment = REG_REQ_ALREADY_SET;
-			wiphy->regd = regd;
+			rcu_assign_pointer(wiphy->regd, regd);
 			goto new_request;
 		}
 		kfree(pending_request);
@@ -2052,6 +2071,8 @@ static int __set_regdom(const struct ieee80211_regdomain *rd)
 
 	/* Some basic sanity checks first */
 
+	assert_reg_lock();
+
 	if (!reg_is_valid_request(rd->alpha2))
 		return -EINVAL;
 
@@ -2123,7 +2144,7 @@ static int __set_regdom(const struct ieee80211_regdomain *rd)
 			return PTR_ERR(regd);
 		}
 
-		request_wiphy->regd = regd;
+		rcu_assign_pointer(request_wiphy->regd, regd);
 		reset_regdomains(false, rd);
 		return 0;
 	}
@@ -2131,7 +2152,7 @@ static int __set_regdom(const struct ieee80211_regdomain *rd)
 	/* Intersection requires a bit more work */
 
 	if (last_request->initiator != NL80211_REGDOM_SET_BY_COUNTRY_IE) {
-		intersected_rd = regdom_intersect(rd, cfg80211_regdomain);
+		intersected_rd = regdom_intersect(rd, get_cfg80211_regdom());
 		if (!intersected_rd)
 			return -EINVAL;
 
@@ -2141,7 +2162,7 @@ static int __set_regdom(const struct ieee80211_regdomain *rd)
 		 * domain we keep it for its private use
 		 */
 		if (last_request->initiator == NL80211_REGDOM_SET_BY_DRIVER)
-			request_wiphy->regd = rd;
+			rcu_assign_pointer(request_wiphy->regd, rd);
 		else
 			kfree(rd);
 
@@ -2159,14 +2180,12 @@ static int __set_regdom(const struct ieee80211_regdomain *rd)
 /*
  * Use this call to set the current regulatory domain. Conflicts with
  * multiple drivers can be ironed out later. Caller must've already
- * kmalloc'd the rd structure. Caller must hold cfg80211_mutex
+ * kmalloc'd the rd structure.
  */
 int set_regdom(const struct ieee80211_regdomain *rd)
 {
 	int r;
 
-	assert_cfg80211_lock();
-
 	mutex_lock(&reg_mutex);
 
 	/* Note that this doesn't update the wiphys, this is done below */
@@ -2180,7 +2199,8 @@ int set_regdom(const struct ieee80211_regdomain *rd)
 	}
 
 	/* This would make this whole thing pointless */
-	if (WARN_ON(!last_request->intersect && rd != cfg80211_regdomain)) {
+	if (WARN_ON(!last_request->intersect &&
+		    rd != get_cfg80211_regdom())) {
 		r = -EINVAL;
 		goto out;
 	}
@@ -2188,7 +2208,7 @@ int set_regdom(const struct ieee80211_regdomain *rd)
 	/* update all wiphys now with the new established regulatory domain */
 	update_all_wiphy_regulatory(last_request->initiator);
 
-	print_regdomain(cfg80211_regdomain);
+	print_regdomain(get_cfg80211_regdom());
 
 	nl80211_send_reg_change_event(last_request);
 
@@ -2241,7 +2261,8 @@ void wiphy_regulatory_deregister(struct wiphy *wiphy)
 	if (!reg_dev_ignore_cell_hint(wiphy))
 		reg_num_devs_support_basehint--;
 
-	kfree(wiphy->regd);
+	rcu_free_regdom(get_wiphy_regdom(wiphy));
+	rcu_assign_pointer(wiphy->regd, NULL);
 
 	if (last_request)
 		request_wiphy = wiphy_idx_to_wiphy(last_request->wiphy_idx);
@@ -2276,13 +2297,13 @@ int __init regulatory_init(void)
 
 	reg_regdb_size_check();
 
-	cfg80211_regdomain = cfg80211_world_regdom;
+	rcu_assign_pointer(cfg80211_regdomain, cfg80211_world_regdom);
 
 	user_alpha2[0] = '9';
 	user_alpha2[1] = '7';
 
 	/* We always try to get an update for the static regdomain */
-	err = regulatory_hint_core(cfg80211_regdomain->alpha2);
+	err = regulatory_hint_core(cfg80211_world_regdom->alpha2);
 	if (err) {
 		if (err == -ENOMEM)
 			return err;
@@ -2316,10 +2337,8 @@ void regulatory_exit(void)
 	cancel_delayed_work_sync(&reg_timeout);
 
 	/* Lock to suppress warnings */
-	mutex_lock(&cfg80211_mutex);
 	mutex_lock(&reg_mutex);
 	reset_regdomains(true, NULL);
-	mutex_unlock(&cfg80211_mutex);
 	mutex_unlock(&reg_mutex);
 
 	dev_set_uevent_suppress(&reg_pdev->dev, true);
diff --git a/net/wireless/reg.h b/net/wireless/reg.h
index d391b50..af2d5f8 100644
--- a/net/wireless/reg.h
+++ b/net/wireless/reg.h
@@ -16,7 +16,7 @@
  * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 
-extern const struct ieee80211_regdomain *cfg80211_regdomain;
+extern const struct ieee80211_regdomain __rcu *cfg80211_regdomain;
 
 bool is_world_regdom(const char *alpha2);
 bool reg_supported_dfs_region(u8 dfs_region);
-- 
1.8.0

