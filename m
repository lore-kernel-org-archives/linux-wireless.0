Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:5806 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752191AbaAOPvB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Jan 2014 10:51:01 -0500
From: Ilan Peer <ilan.peer@intel.com>
To: linux-wireless@vger.kernel.org
Cc: mcgrof@do-not-panic.com, wireless-regdb@lists.infradead.org,
	Ilan Peer <ilan.peer@intel.com>
Subject: [PATCH v2 4/6] cfg80211: Add an option to hint indoor operation
Date: Wed, 15 Jan 2014 17:52:40 +0200
Message-Id: <1389801162-14488-5-git-send-email-ilan.peer@intel.com> (sfid-20140115_165113_879111_C6FD08BF)
In-Reply-To: <1389801162-14488-1-git-send-email-ilan.peer@intel.com>
References: <1389801162-14488-1-git-send-email-ilan.peer@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add the option to hint the wireless core that it is operating in an indoor
environment.

In addition add regulatory_ir_allowed(), that can be used to
test if initiation radiation is allowed based on the channel flags
and the wireless core indoor hint.

Signed-off-by: Ilan Peer <ilan.peer@intel.com>
---
 include/net/cfg80211.h       |   12 +++++++++
 include/uapi/linux/nl80211.h |    3 +++
 net/wireless/nl80211.c       |   18 ++++++-------
 net/wireless/reg.c           |   57 +++++++++++++++++++++++++++++++++++++++---
 net/wireless/reg.h           |    1 +
 5 files changed, 78 insertions(+), 13 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 504d656..8c29b3d 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -3534,6 +3534,18 @@ const struct ieee80211_reg_rule *freq_reg_info(struct wiphy *wiphy,
  */
 const char *reg_initiator_name(enum nl80211_reg_initiator initiator);
 
+/**
+ * regulatory_ir_allowed - is it allowed to initiate radiation on the channel.
+ * @chan: the channel
+ *
+ * Generally, it is not allowed to initiate radiation on a channel marked with
+ * IEEE80211_CHAN_NO_IR. The exception is operation on channels marked with
+ * IEEE80211_CHAN_INDOOR_ONLY. For such channels, initiating radiation is
+ * allowed iff the wireless core was notified that it operates in an indoor
+ * environment.
+ */
+bool regulatory_ir_allowed(struct ieee80211_channel *chan);
+
 /*
  * callbacks for asynchronous cfg80211 methods, notification
  * functions and BSS handling helpers
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index b6721a1..6674444 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -2489,10 +2489,13 @@ enum nl80211_dfs_regions {
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
index 267d37e..514170c 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -4614,7 +4614,6 @@ static int parse_reg_rule(struct nlattr *tb[],
 
 static int nl80211_req_set_reg(struct sk_buff *skb, struct genl_info *info)
 {
-	int r;
 	char *data = NULL;
 	enum nl80211_user_reg_hint_type user_reg_hint_type;
 
@@ -4627,11 +4626,6 @@ static int nl80211_req_set_reg(struct sk_buff *skb, struct genl_info *info)
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
@@ -4641,14 +4635,18 @@ static int nl80211_req_set_reg(struct sk_buff *skb, struct genl_info *info)
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
index 212b5c2..0361035 100644
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
@@ -987,6 +995,13 @@ static bool reg_request_cell_base(struct regulatory_request *request)
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
@@ -1423,6 +1438,9 @@ __reg_process_hint_user(struct regulatory_request *user_request)
 {
 	struct regulatory_request *lr = get_last_request();
 
+	if (reg_request_indoor(user_request))
+		return REG_REQ_OK;
+
 	if (reg_request_cell_base(user_request))
 		return reg_ignore_cell_hint(user_request);
 
@@ -1475,6 +1493,11 @@ reg_process_hint_user(struct regulatory_request *user_request)
 		return treatment;
 	}
 
+	if (reg_request_indoor(user_request) && treatment == REG_REQ_OK) {
+		reg_is_indoor = true;
+		return REG_REQ_OK;
+	}
+
 	user_request->intersect = treatment == REG_REQ_INTERSECT;
 	user_request->processed = false;
 
@@ -1658,9 +1681,6 @@ static void reg_process_hint(struct regulatory_request *reg_request)
 	struct wiphy *wiphy = NULL;
 	enum reg_request_treatment treatment;
 
-	if (WARN_ON(!reg_request->alpha2))
-		return;
-
 	if (reg_request->wiphy_idx != WIPHY_IDX_INVALID)
 		wiphy = wiphy_idx_to_wiphy(reg_request->wiphy_idx);
 
@@ -1820,6 +1840,22 @@ int regulatory_hint_user(const char *alpha2,
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
@@ -2482,6 +2518,19 @@ int cfg80211_get_unii(int freq)
 	return -EINVAL;
 }
 
+bool regulatory_ir_allowed(struct ieee80211_channel *chan)
+{
+#ifdef CONFIG_CFG80211_REG_SOFT_CONFIGURATIONS
+	if (reg_is_indoor && (chan->flags & IEEE80211_CHAN_INDOOR_ONLY))
+		return true;
+#endif /* CONFIG_CFG80211_REG_SOFT_CONFIGURATIONS */
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
@@ -2502,6 +2551,8 @@ int __init regulatory_init(void)
 	user_alpha2[0] = '9';
 	user_alpha2[1] = '7';
 
+	reg_is_indoor = false;
+
 	/* We always try to get an update for the static regdomain */
 	err = regulatory_hint_core(cfg80211_world_regdom->alpha2);
 	if (err) {
diff --git a/net/wireless/reg.h b/net/wireless/reg.h
index 1ef2daa..bd708d1 100644
--- a/net/wireless/reg.h
+++ b/net/wireless/reg.h
@@ -24,6 +24,7 @@ bool reg_supported_dfs_region(enum nl80211_dfs_regions dfs_region);
 
 int regulatory_hint_user(const char *alpha2,
 			 enum nl80211_user_reg_hint_type user_reg_hint_type);
+int regulatory_hint_indoor_user(void);
 
 int reg_device_uevent(struct device *dev, struct kobj_uevent_env *env);
 void wiphy_regulatory_register(struct wiphy *wiphy);
-- 
1.7.10.4

