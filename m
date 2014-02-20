Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:48171 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752214AbaBTMTn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Feb 2014 07:19:43 -0500
From: Ilan Peer <ilan.peer@intel.com>
To: linux-wireless@vger.kernel.org
Cc: mcgrof@do-not-panic.com, Ilan Peer <ilan.peer@intel.com>
Subject: [PATCH v5 4/5] cfg80211: Add an option to hint indoor operation
Date: Thu, 20 Feb 2014 14:21:49 +0200
Message-Id: <1392898909-15953-1-git-send-email-ilan.peer@intel.com> (sfid-20140220_131946_336789_F6B979EE)
In-Reply-To: <1392896671-4288-5-git-send-email-ilan.peer@intel.com>
References: <1392896671-4288-5-git-send-email-ilan.peer@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add the option to hint the wireless core that it is operating in an indoor
environment.

Change-Id: Ie082a09b41292c6e12d4b2ffb01117c14b6a94f6
Signed-off-by: Ilan Peer <ilan.peer@intel.com>
---
 include/net/cfg80211.h       |    5 ++++
 include/uapi/linux/nl80211.h |    3 ++
 net/wireless/nl80211.c       |   18 +++++-------
 net/wireless/reg.c           |   64 +++++++++++++++++++++++++++++++++++++++++-
 net/wireless/reg.h           |    1 +
 5 files changed, 79 insertions(+), 12 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index e872c9c..5c6053c 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -3626,6 +3626,11 @@ const struct ieee80211_reg_rule *freq_reg_info(struct wiphy *wiphy,
  */
 const char *reg_initiator_name(enum nl80211_reg_initiator initiator);
 
+/**
+ * regulatory_indoor_allowed - is indoor operation allowed
+ */
+bool regulatory_indoor_allowed(void);
+
 /*
  * callbacks for asynchronous cfg80211 methods, notification
  * functions and BSS handling helpers
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 061f8d4..42710e5 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -2583,10 +2583,13 @@ enum nl80211_dfs_regions {
  *	present has been registered with the wireless core that
  *	has listed NL80211_FEATURE_CELL_BASE_REG_HINTS as a
  *	supported feature.
+ * @NL80211_USER_REG_HINT_INDOOR: a user sent an hint indicating that the
+ *	platform is operating in an indoor environment.
  */
 enum nl80211_user_reg_hint_type {
 	NL80211_USER_REG_HINT_USER	= 0,
 	NL80211_USER_REG_HINT_CELL_BASE = 1,
+	NL80211_USER_REG_HINT_INDOOR    = 2,
 };
 
 /**
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 2270d9b..50826a9 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -4659,7 +4659,6 @@ static int parse_reg_rule(struct nlattr *tb[],
 
 static int nl80211_req_set_reg(struct sk_buff *skb, struct genl_info *info)
 {
-	int r;
 	char *data = NULL;
 	enum nl80211_user_reg_hint_type user_reg_hint_type;
 
@@ -4672,11 +4671,6 @@ static int nl80211_req_set_reg(struct sk_buff *skb, struct genl_info *info)
 	if (unlikely(!rcu_access_pointer(cfg80211_regdomain)))
 		return -EINPROGRESS;
 
-	if (!info->attrs[NL80211_ATTR_REG_ALPHA2])
-		return -EINVAL;
-
-	data = nla_data(info->attrs[NL80211_ATTR_REG_ALPHA2]);
-
 	if (info->attrs[NL80211_ATTR_USER_REG_HINT_TYPE])
 		user_reg_hint_type =
 		  nla_get_u32(info->attrs[NL80211_ATTR_USER_REG_HINT_TYPE]);
@@ -4686,14 +4680,16 @@ static int nl80211_req_set_reg(struct sk_buff *skb, struct genl_info *info)
 	switch (user_reg_hint_type) {
 	case NL80211_USER_REG_HINT_USER:
 	case NL80211_USER_REG_HINT_CELL_BASE:
-		break;
+		if (!info->attrs[NL80211_ATTR_REG_ALPHA2])
+			return -EINVAL;
+
+		data = nla_data(info->attrs[NL80211_ATTR_REG_ALPHA2]);
+		return regulatory_hint_user(data, user_reg_hint_type);
+	case NL80211_USER_REG_HINT_INDOOR:
+		return regulatory_hint_indoor_user();
 	default:
 		return -EINVAL;
 	}
-
-	r = regulatory_hint_user(data, user_reg_hint_type);
-
-	return r;
 }
 
 static int nl80211_get_mesh_config(struct sk_buff *skb,
diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 8f5b460..50e41a5 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -65,11 +65,26 @@
 #define REG_DBG_PRINT(args...)
 #endif
 
+/**
+ * enum reg_request_treatment - regulatory request treatment
+ *
+ * @REG_REQ_OK: continue processing the regulatory request
+ * @REG_REQ_IGNORE: ignore the regulatory request
+ * @REG_REQ_INTERSECT: the regulatory domain resulting from this request should
+ *	be intersected with the current one.
+ * @REG_REQ_ALREADY_SET: the regulatory request will not change the current
+ *	regulatory settings, and no further processing is required.
+ * @REG_REQ_USER_HINT_HANDLED: a non alpha2  user hint was handled and no
+ *	further processing is required, i.e., not need to update last_request
+ *	etc. This should be used for user hints that do not provide an alpha2
+ *	but some other type of regulatory hint, i.e., indoor operation.
+ */
 enum reg_request_treatment {
 	REG_REQ_OK,
 	REG_REQ_IGNORE,
 	REG_REQ_INTERSECT,
 	REG_REQ_ALREADY_SET,
+	REG_REQ_USER_HINT_HANDLED,
 };
 
 static struct regulatory_request core_request_world = {
@@ -110,6 +125,14 @@ const struct ieee80211_regdomain __rcu *cfg80211_regdomain;
  */
 static int reg_num_devs_support_basehint;
 
+/*
+ * State variable indicating if the platform on which the devices
+ * are attached is operating in an indoor environment. The state variable
+ * is relevant for all registered devices.
+ * Note: currently not protected by any synchronization primitive.
+ */
+static bool reg_is_indoor;
+
 static const struct ieee80211_regdomain *get_cfg80211_regdom(void)
 {
 	return rtnl_dereference(cfg80211_regdomain);
@@ -1104,6 +1127,13 @@ static bool reg_request_cell_base(struct regulatory_request *request)
 	return request->user_reg_hint_type == NL80211_USER_REG_HINT_CELL_BASE;
 }
 
+static bool reg_request_indoor(struct regulatory_request *request)
+{
+	if (request->initiator != NL80211_REGDOM_SET_BY_USER)
+		return false;
+	return request->user_reg_hint_type == NL80211_USER_REG_HINT_INDOOR;
+}
+
 bool reg_last_request_cell_base(void)
 {
 	return reg_request_cell_base(get_last_request());
@@ -1546,6 +1576,11 @@ __reg_process_hint_user(struct regulatory_request *user_request)
 {
 	struct regulatory_request *lr = get_last_request();
 
+	if (reg_request_indoor(user_request)) {
+		reg_is_indoor = true;
+		return REG_REQ_USER_HINT_HANDLED;
+	}
+
 	if (reg_request_cell_base(user_request))
 		return reg_ignore_cell_hint(user_request);
 
@@ -1593,7 +1628,8 @@ reg_process_hint_user(struct regulatory_request *user_request)
 
 	treatment = __reg_process_hint_user(user_request);
 	if (treatment == REG_REQ_IGNORE ||
-	    treatment == REG_REQ_ALREADY_SET) {
+	    treatment == REG_REQ_ALREADY_SET ||
+	    treatment == REG_REQ_USER_HINT_HANDLED) {
 		kfree(user_request);
 		return treatment;
 	}
@@ -1654,6 +1690,7 @@ reg_process_hint_driver(struct wiphy *wiphy,
 	case REG_REQ_OK:
 		break;
 	case REG_REQ_IGNORE:
+	case REG_REQ_USER_HINT_HANDLED:
 		kfree(driver_request);
 		return treatment;
 	case REG_REQ_INTERSECT:
@@ -1753,6 +1790,7 @@ reg_process_hint_country_ie(struct wiphy *wiphy,
 	case REG_REQ_OK:
 		break;
 	case REG_REQ_IGNORE:
+	case REG_REQ_USER_HINT_HANDLED:
 		/* fall through */
 	case REG_REQ_ALREADY_SET:
 		kfree(country_ie_request);
@@ -1945,6 +1983,22 @@ int regulatory_hint_user(const char *alpha2,
 	return 0;
 }
 
+int regulatory_hint_indoor_user(void)
+{
+	struct regulatory_request *request;
+
+	request = kzalloc(sizeof(struct regulatory_request), GFP_KERNEL);
+	if (!request)
+		return -ENOMEM;
+
+	request->wiphy_idx = WIPHY_IDX_INVALID;
+	request->initiator = NL80211_REGDOM_SET_BY_USER;
+	request->user_reg_hint_type = NL80211_USER_REG_HINT_INDOOR;
+	queue_regulatory_request(request);
+
+	return 0;
+}
+
 /* Driver hints */
 int regulatory_hint(struct wiphy *wiphy, const char *alpha2)
 {
@@ -2112,6 +2166,8 @@ static void restore_regulatory_settings(bool reset_user)
 
 	ASSERT_RTNL();
 
+	reg_is_indoor = false;
+
 	reset_regdomains(true, &world_regdom);
 	restore_alpha2(alpha2, reset_user);
 
@@ -2626,6 +2682,12 @@ int cfg80211_get_unii(int freq)
 	return -EINVAL;
 }
 
+bool regulatory_indoor_allowed(void)
+{
+	return reg_is_indoor;
+}
+EXPORT_SYMBOL_GPL(regulatory_indoor_allowed);
+
 int __init regulatory_init(void)
 {
 	int err = 0;
diff --git a/net/wireless/reg.h b/net/wireless/reg.h
index 9c11e72..b350a30 100644
--- a/net/wireless/reg.h
+++ b/net/wireless/reg.h
@@ -25,6 +25,7 @@ enum nl80211_dfs_regions reg_get_dfs_region(struct wiphy *wiphy);
 
 int regulatory_hint_user(const char *alpha2,
 			 enum nl80211_user_reg_hint_type user_reg_hint_type);
+int regulatory_hint_indoor_user(void);
 
 int reg_device_uevent(struct device *dev, struct kobj_uevent_env *env);
 void wiphy_regulatory_register(struct wiphy *wiphy);
-- 
1.7.10.4

