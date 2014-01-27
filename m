Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:46421 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753170AbaA0KU1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Jan 2014 05:20:27 -0500
From: Ilan Peer <ilan.peer@intel.com>
To: linux-wireless@vger.kernel.org
Cc: wireless-regdb@lists.infradead.org, Ilan Peer <ilan.peer@intel.com>
Subject: [PATCH v3 4/6] cfg80211: Add an option to hint indoor operation
Date: Mon, 27 Jan 2014 12:21:56 +0200
Message-Id: <1390818118-27261-5-git-send-email-ilan.peer@intel.com> (sfid-20140127_112047_079973_9230A036)
In-Reply-To: <1390818118-27261-1-git-send-email-ilan.peer@intel.com>
References: <1390818118-27261-1-git-send-email-ilan.peer@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add the option to hint the wireless core that it is operating in an indoor
environment.

In addition add regulatory_ir_allowed(), that can be used to
test if initiation radiation is allowed based on the channel flags
and the wireless core indoor hint.

Signed-off-by: Ilan Peer <ilan.peer@intel.com>
---
 include/net/cfg80211.h       |   14 +++++++++++
 include/uapi/linux/nl80211.h |    3 +++
 net/wireless/nl80211.c       |   18 +++++++-------
 net/wireless/reg.c           |   54 +++++++++++++++++++++++++++++++++++++++---
 net/wireless/reg.h           |    1 +
 5 files changed, 77 insertions(+), 13 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 317bd06..6e6c42c 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -3627,6 +3627,20 @@ const struct ieee80211_reg_rule *freq_reg_info(struct wiphy *wiphy,
  */
 const char *reg_initiator_name(enum nl80211_reg_initiator initiator);
 
+/**
+ * regulatory_ir_allowed - is it allowed to initiate radiation on the channel.
+ * @wiphy: the wiphy for which we want to test channel.
+ * @chan: the channel
+ *
+ * Generally, it is not allowed to initiate radiation on a channel marked with
+ * IEEE80211_CHAN_NO_IR. The exception is operation on channels marked with
+ * IEEE80211_CHAN_INDOOR_ONLY. For such channels, initiating radiation is
+ * allowed iff the wireless core was notified that it operates in an indoor
+ * environment.
+ */
+bool regulatory_ir_allowed(struct wiphy *wiphy,
+			   struct ieee80211_channel *chan);
+
 /*
  * callbacks for asynchronous cfg80211 methods, notification
  * functions and BSS handling helpers
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 06440ac..1dbf6d3 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -2533,10 +2533,13 @@ enum nl80211_dfs_regions {
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
index b37b36e..b33f346 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -4664,7 +4664,6 @@ static int parse_reg_rule(struct nlattr *tb[],
 
 static int nl80211_req_set_reg(struct sk_buff *skb, struct genl_info *info)
 {
-	int r;
 	char *data = NULL;
 	enum nl80211_user_reg_hint_type user_reg_hint_type;
 
@@ -4677,11 +4676,6 @@ static int nl80211_req_set_reg(struct sk_buff *skb, struct genl_info *info)
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
@@ -4691,14 +4685,18 @@ static int nl80211_req_set_reg(struct sk_buff *skb, struct genl_info *info)
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
 
-	r = regulatory_hint_user(data, user_reg_hint_type);
-
-	return r;
+	return 0;
 }
 
 static int nl80211_get_mesh_config(struct sk_buff *skb,
diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index ec38f5d..2f2d5db 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -110,6 +110,14 @@ const struct ieee80211_regdomain __rcu *cfg80211_regdomain;
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
@@ -1014,6 +1022,13 @@ static bool reg_request_cell_base(struct regulatory_request *request)
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
@@ -1450,6 +1465,11 @@ __reg_process_hint_user(struct regulatory_request *user_request)
 {
 	struct regulatory_request *lr = get_last_request();
 
+	if (reg_request_indoor(user_request)) {
+		reg_is_indoor = true;
+		return REG_REQ_ALREADY_SET;
+	}
+
 	if (reg_request_cell_base(user_request))
 		return reg_ignore_cell_hint(user_request);
 
@@ -1685,9 +1705,6 @@ static void reg_process_hint(struct regulatory_request *reg_request)
 	struct wiphy *wiphy = NULL;
 	enum reg_request_treatment treatment;
 
-	if (WARN_ON(!reg_request->alpha2))
-		return;
-
 	if (reg_request->wiphy_idx != WIPHY_IDX_INVALID)
 		wiphy = wiphy_idx_to_wiphy(reg_request->wiphy_idx);
 
@@ -1847,6 +1864,22 @@ int regulatory_hint_user(const char *alpha2,
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
@@ -2014,6 +2047,8 @@ static void restore_regulatory_settings(bool reset_user)
 
 	ASSERT_RTNL();
 
+	reg_is_indoor = false;
+
 	reset_regdomains(true, &world_regdom);
 	restore_alpha2(alpha2, reset_user);
 
@@ -2515,6 +2550,19 @@ int cfg80211_get_unii(int freq)
 	return -EINVAL;
 }
 
+bool regulatory_ir_allowed(struct wiphy *wiphy, struct ieee80211_channel *chan)
+{
+	if (config_enabled(CONFIG_CFG80211_REG_RELAX_NO_IR) &&
+	    !(wiphy->regulatory_flags & REGULATORY_DISABLE_RELAX_NO_IR) &&
+	    reg_is_indoor && (chan->flags & IEEE80211_CHAN_INDOOR_ONLY))
+		return true;
+
+	if (chan->flags & IEEE80211_CHAN_NO_IR)
+		return false;
+	return true;
+}
+EXPORT_SYMBOL(regulatory_ir_allowed);
+
 int __init regulatory_init(void)
 {
 	int err = 0;
diff --git a/net/wireless/reg.h b/net/wireless/reg.h
index 4d44cd4..2960024 100644
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

