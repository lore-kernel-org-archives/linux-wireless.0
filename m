Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:34685 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752241AbbC3MNv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Mar 2015 08:13:51 -0400
From: Ilan Peer <ilan.peer@intel.com>
To: linux-wireless@vger.kernel.org
Cc: mcgrof@suse.com, Ilan Peer <ilan.peer@intel.com>
Subject: [PATCH v2] cfg80211: Stop calling crda if it is not responsive
Date: Mon, 30 Mar 2015 15:15:49 +0300
Message-Id: <1427717749-27225-1-git-send-email-ilan.peer@intel.com> (sfid-20150330_141354_463006_F82C75ED)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Patch eeca9fce1d71a4955855ceb0c3b13c1eb9db27c1 (cfg80211: Schedule
timeout for all CRDA call) introduced a regression, where in case
that crda is not installed (or not configured properly etc.), the
regulatory core will needlessly continue to call it, polluting the
log with the following log:

"cfg80211: Calling CRDA to update world regulatory domain"

Fix this by limiting the number of continuous CRDA request failures.

Signed-off-by: Ilan Peer <ilan.peer@intel.com>
---
 net/wireless/nl80211.c |  2 +-
 net/wireless/reg.c     | 32 ++++++++++++++++++++++++++++----
 net/wireless/reg.h     |  9 ++++++++-
 3 files changed, 37 insertions(+), 6 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index b020853..3f4c768 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -5655,7 +5655,7 @@ static int nl80211_set_reg(struct sk_buff *skb, struct genl_info *info)
 		}
 	}
 
-	r = set_regdom(rd);
+	r = set_regdom(rd, REGD_SOURCE_CRDA);
 	/* set_regdom took ownership */
 	rd = NULL;
 
diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 8c6cf52..cfed9db 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -135,6 +135,11 @@ static spinlock_t reg_indoor_lock;
 /* Used to track the userspace process controlling the indoor setting */
 static u32 reg_is_indoor_portid;
 
+/* Max number of consecutive attempts to communicate with CRDA  */
+#define REG_MAX_CRDA_TIMEOUTS 3
+
+static u32 reg_crda_timeouts;
+
 static const struct ieee80211_regdomain *get_cfg80211_regdom(void)
 {
 	return rtnl_dereference(cfg80211_regdomain);
@@ -485,7 +490,7 @@ static void reg_regdb_search(struct work_struct *work)
 	mutex_unlock(&reg_regdb_search_mutex);
 
 	if (!IS_ERR_OR_NULL(regdom))
-		set_regdom(regdom);
+		set_regdom(regdom, REGD_SOURCE_INTERNAL_DB);
 
 	rtnl_unlock();
 }
@@ -536,14 +541,19 @@ static int call_crda(const char *alpha2)
 		 alpha2[0], alpha2[1]);
 
 	if (!is_world_regdom((char *) alpha2))
-		pr_info("Calling CRDA for country: %c%c\n",
+		pr_info("Update country=%c%c\n",
 			alpha2[0], alpha2[1]);
 	else
-		pr_info("Calling CRDA to update world regulatory domain\n");
+		pr_info("Update to world regulatory domain\n");
 
 	/* query internal regulatory database (if it exists) */
 	reg_regdb_query(alpha2);
 
+	if (reg_crda_timeouts > REG_MAX_CRDA_TIMEOUTS) {
+		pr_info("Exceeded CRDA call max attempts. Not calling CRDA\n");
+		return -EINVAL;
+	}
+
 	return kobject_uevent_env(&reg_pdev->dev.kobj, KOBJ_CHANGE, env);
 }
 
@@ -2293,6 +2303,9 @@ int regulatory_hint_user(const char *alpha2,
 	request->initiator = NL80211_REGDOM_SET_BY_USER;
 	request->user_reg_hint_type = user_reg_hint_type;
 
+	/* Allow calling CRDA again */
+	reg_crda_timeouts = 0;
+
 	queue_regulatory_request(request);
 
 	return 0;
@@ -2362,6 +2375,9 @@ int regulatory_hint(struct wiphy *wiphy, const char *alpha2)
 	request->alpha2[1] = alpha2[1];
 	request->initiator = NL80211_REGDOM_SET_BY_DRIVER;
 
+	/* Allow calling CRDA again */
+	reg_crda_timeouts = 0;
+
 	queue_regulatory_request(request);
 
 	return 0;
@@ -2415,6 +2431,9 @@ void regulatory_hint_country_ie(struct wiphy *wiphy, enum ieee80211_band band,
 	request->initiator = NL80211_REGDOM_SET_BY_COUNTRY_IE;
 	request->country_ie_env = env;
 
+	/* Allow calling CRDA again */
+	reg_crda_timeouts = 0;
+
 	queue_regulatory_request(request);
 	request = NULL;
 out:
@@ -2893,7 +2912,8 @@ static int reg_set_rd_country_ie(const struct ieee80211_regdomain *rd,
  * multiple drivers can be ironed out later. Caller must've already
  * kmalloc'd the rd structure.
  */
-int set_regdom(const struct ieee80211_regdomain *rd)
+int set_regdom(const struct ieee80211_regdomain *rd,
+	       enum ieee80211_regd_source regd_src)
 {
 	struct regulatory_request *lr;
 	bool user_reset = false;
@@ -2904,6 +2924,9 @@ int set_regdom(const struct ieee80211_regdomain *rd)
 		return -EINVAL;
 	}
 
+	if (regd_src == REGD_SOURCE_CRDA)
+		reg_crda_timeouts = 0;
+
 	lr = get_last_request();
 
 	/* Note that this doesn't update the wiphys, this is done below */
@@ -3063,6 +3086,7 @@ static void reg_timeout_work(struct work_struct *work)
 {
 	REG_DBG_PRINT("Timeout while waiting for CRDA to reply, restoring regulatory settings\n");
 	rtnl_lock();
+	reg_crda_timeouts++;
 	restore_regulatory_settings(true);
 	rtnl_unlock();
 }
diff --git a/net/wireless/reg.h b/net/wireless/reg.h
index a2c4e16..3f310a5 100644
--- a/net/wireless/reg.h
+++ b/net/wireless/reg.h
@@ -16,6 +16,11 @@
  * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 
+enum ieee80211_regd_source {
+	REGD_SOURCE_INTERNAL_DB = 0,
+	REGD_SOURCE_CRDA,
+};
+
 extern const struct ieee80211_regdomain __rcu *cfg80211_regdomain;
 
 bool reg_is_valid_request(const char *alpha2);
@@ -46,7 +51,9 @@ void wiphy_regulatory_deregister(struct wiphy *wiphy);
 int __init regulatory_init(void);
 void regulatory_exit(void);
 
-int set_regdom(const struct ieee80211_regdomain *rd);
+int set_regdom(const struct ieee80211_regdomain *rd,
+	       enum ieee80211_regd_source regd_src);
+
 unsigned int reg_get_max_bandwidth(const struct ieee80211_regdomain *rd,
 				   const struct ieee80211_reg_rule *rule);
 
-- 
1.9.1

