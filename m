Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:49576 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751230AbbBRHtM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Feb 2015 02:49:12 -0500
From: Ilan Peer <ilan.peer@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Ilan Peer <ilan.peer@intel.com>, ArikX Nemtsov <arik@wizery.com>
Subject: [PATCH v5 1/2] cfg80211: Add API to change the indoor regulatory setting
Date: Tue, 17 Feb 2015 20:51:23 -0500
Message-Id: <1424224284-17377-1-git-send-email-ilan.peer@intel.com> (sfid-20150218_084915_543800_2496FA54)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

As the operating environment of a device can change, add
API for user space to indicate a change of indoor settings.
In addition modify the handling of the indoor processing as
follows:

1. Directly update the indoor setting without wrapping it as a
   regulatory request.
2. If the user space process explicitly indicates that it is going
   to control the indoor setting, do not clear the indoor setting
   internally, unless the socket is released. The user space process
   should use the NL80211_ATTR_SOCKET_OWNER attribute in the command
   to state that it is going to control the indoor setting.
3. Reset the indoor setting when restoring the regulatory settings in
   case it is not owned by a user space process.

Signed-off-by: Ilan Peer <ilan.peer@intel.com>
Signed-off-by: ArikX Nemtsov <arik@wizery.com>
---
 include/uapi/linux/nl80211.h |  9 +++++
 net/wireless/nl80211.c       | 15 +++++++-
 net/wireless/reg.c           | 90 +++++++++++++++++++++++++++-----------------
 net/wireless/reg.h           | 15 +++++++-
 4 files changed, 93 insertions(+), 36 deletions(-)

diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 68b294e..98fc77f 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -1684,6 +1684,10 @@ enum nl80211_commands {
  *	If set during scheduled scan start then the new scan req will be
  *	owned by the netlink socket that created it and the scheduled scan will
  *	be stopped when the socket is closed.
+ *	If set during configuration of regulatory indoor operation then the
+ *	regulatory indoor configuration would be owned by the netlink socket
+ *	that configured the indoor setting, and the indoor operation would be
+ *	cleared when the socket is closed.
  *
  * @NL80211_ATTR_TDLS_INITIATOR: flag attribute indicating the current end is
  *	the TDLS link initiator.
@@ -1739,6 +1743,9 @@ enum nl80211_commands {
  *
  * @NL80211_ATTR_SCHED_SCAN_DELAY: delay before a scheduled scan (or a
  *	WoWLAN net-detect scan) is started, u32 in seconds.
+
+ * @NL80211_ATTR_REG_INDOOR: flag attribute, if set indicates that the device
+ *      is operating in an indoor environment.
  *
  * @NUM_NL80211_ATTR: total number of nl80211_attrs available
  * @NL80211_ATTR_MAX: highest attribute number currently defined
@@ -2107,6 +2114,8 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_SCHED_SCAN_DELAY,
 
+	NL80211_ATTR_REG_INDOOR,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 454d7a0..3f6b395 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -399,6 +399,7 @@ static const struct nla_policy nl80211_policy[NUM_NL80211_ATTR] = {
 	[NL80211_ATTR_WIPHY_SELF_MANAGED_REG] = { .type = NLA_FLAG },
 	[NL80211_ATTR_NETNS_FD] = { .type = NLA_U32 },
 	[NL80211_ATTR_SCHED_SCAN_DELAY] = { .type = NLA_U32 },
+	[NL80211_ATTR_REG_INDOOR] = { .type = NLA_FLAG },
 };
 
 /* policy for the key attributes */
@@ -4955,7 +4956,10 @@ static int parse_reg_rule(struct nlattr *tb[],
 static int nl80211_req_set_reg(struct sk_buff *skb, struct genl_info *info)
 {
 	char *data = NULL;
+	bool is_indoor;
 	enum nl80211_user_reg_hint_type user_reg_hint_type;
+	u32 owner_nlportid = 0;
+
 
 	/*
 	 * You should only get this when cfg80211 hasn't yet initialized
@@ -4981,7 +4985,11 @@ static int nl80211_req_set_reg(struct sk_buff *skb, struct genl_info *info)
 		data = nla_data(info->attrs[NL80211_ATTR_REG_ALPHA2]);
 		return regulatory_hint_user(data, user_reg_hint_type);
 	case NL80211_USER_REG_HINT_INDOOR:
-		return regulatory_hint_indoor_user();
+		is_indoor = !!info->attrs[NL80211_ATTR_REG_INDOOR];
+		if (info->attrs[NL80211_ATTR_SOCKET_OWNER])
+			owner_nlportid = info->snd_portid;
+
+		return regulatory_hint_indoor(is_indoor, owner_nlportid);
 	default:
 		return -EINVAL;
 	}
@@ -12759,6 +12767,11 @@ static int nl80211_netlink_notify(struct notifier_block * nb,
 
 	rcu_read_unlock();
 
+	/*
+	 * It is possible that the user space process that is controlling the
+	 * indoor setting disappeared, so notify the regulatory core.
+	 */
+	regulatory_netlink_notify(notify->portid);
 	return NOTIFY_OK;
 }
 
diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 886cc7c..771319e 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -82,17 +82,12 @@
  *	be intersected with the current one.
  * @REG_REQ_ALREADY_SET: the regulatory request will not change the current
  *	regulatory settings, and no further processing is required.
- * @REG_REQ_USER_HINT_HANDLED: a non alpha2  user hint was handled and no
- *	further processing is required, i.e., not need to update last_request
- *	etc. This should be used for user hints that do not provide an alpha2
- *	but some other type of regulatory hint, i.e., indoor operation.
  */
 enum reg_request_treatment {
 	REG_REQ_OK,
 	REG_REQ_IGNORE,
 	REG_REQ_INTERSECT,
 	REG_REQ_ALREADY_SET,
-	REG_REQ_USER_HINT_HANDLED,
 };
 
 static struct regulatory_request core_request_world = {
@@ -133,9 +128,12 @@ static int reg_num_devs_support_basehint;
  * State variable indicating if the platform on which the devices
  * are attached is operating in an indoor environment. The state variable
  * is relevant for all registered devices.
- * (protected by RTNL)
  */
 static bool reg_is_indoor;
+static spinlock_t reg_indoor_lock;
+
+/* Used to track the userspace process controlling the indoor setting */
+static u32 reg_is_indoor_portid;
 
 static const struct ieee80211_regdomain *get_cfg80211_regdom(void)
 {
@@ -1248,13 +1246,6 @@ static bool reg_request_cell_base(struct regulatory_request *request)
 	return request->user_reg_hint_type == NL80211_USER_REG_HINT_CELL_BASE;
 }
 
-static bool reg_request_indoor(struct regulatory_request *request)
-{
-	if (request->initiator != NL80211_REGDOM_SET_BY_USER)
-		return false;
-	return request->user_reg_hint_type == NL80211_USER_REG_HINT_INDOOR;
-}
-
 bool reg_last_request_cell_base(void)
 {
 	return reg_request_cell_base(get_last_request());
@@ -1821,11 +1812,6 @@ __reg_process_hint_user(struct regulatory_request *user_request)
 {
 	struct regulatory_request *lr = get_last_request();
 
-	if (reg_request_indoor(user_request)) {
-		reg_is_indoor = true;
-		return REG_REQ_USER_HINT_HANDLED;
-	}
-
 	if (reg_request_cell_base(user_request))
 		return reg_ignore_cell_hint(user_request);
 
@@ -1873,8 +1859,7 @@ reg_process_hint_user(struct regulatory_request *user_request)
 
 	treatment = __reg_process_hint_user(user_request);
 	if (treatment == REG_REQ_IGNORE ||
-	    treatment == REG_REQ_ALREADY_SET ||
-	    treatment == REG_REQ_USER_HINT_HANDLED) {
+	    treatment == REG_REQ_ALREADY_SET) {
 		reg_free_request(user_request);
 		return treatment;
 	}
@@ -1935,7 +1920,6 @@ reg_process_hint_driver(struct wiphy *wiphy,
 	case REG_REQ_OK:
 		break;
 	case REG_REQ_IGNORE:
-	case REG_REQ_USER_HINT_HANDLED:
 		reg_free_request(driver_request);
 		return treatment;
 	case REG_REQ_INTERSECT:
@@ -2035,7 +2019,6 @@ reg_process_hint_country_ie(struct wiphy *wiphy,
 	case REG_REQ_OK:
 		break;
 	case REG_REQ_IGNORE:
-	case REG_REQ_USER_HINT_HANDLED:
 		/* fall through */
 	case REG_REQ_ALREADY_SET:
 		reg_free_request(country_ie_request);
@@ -2074,8 +2057,7 @@ static void reg_process_hint(struct regulatory_request *reg_request)
 	case NL80211_REGDOM_SET_BY_USER:
 		treatment = reg_process_hint_user(reg_request);
 		if (treatment == REG_REQ_IGNORE ||
-		    treatment == REG_REQ_ALREADY_SET ||
-		    treatment == REG_REQ_USER_HINT_HANDLED)
+		    treatment == REG_REQ_ALREADY_SET)
 			return;
 		queue_delayed_work(system_power_efficient_wq,
 				   &reg_timeout, msecs_to_jiffies(3142));
@@ -2297,22 +2279,51 @@ int regulatory_hint_user(const char *alpha2,
 	return 0;
 }
 
-int regulatory_hint_indoor_user(void)
+int regulatory_hint_indoor(bool is_indoor, u32 portid)
 {
-	struct regulatory_request *request;
+	spin_lock(&reg_indoor_lock);
 
-	request = kzalloc(sizeof(struct regulatory_request), GFP_KERNEL);
-	if (!request)
-		return -ENOMEM;
+	/*
+	 * Process only if there is a real change, so the original port ID is
+	 * saved (to handle cases that several processes try to change the
+	 * indoor setting).
+	 */
+	if (reg_is_indoor == is_indoor) {
+		spin_unlock(&reg_indoor_lock);
+		return 0;
+	}
 
-	request->wiphy_idx = WIPHY_IDX_INVALID;
-	request->initiator = NL80211_REGDOM_SET_BY_USER;
-	request->user_reg_hint_type = NL80211_USER_REG_HINT_INDOOR;
-	queue_regulatory_request(request);
+	reg_is_indoor = is_indoor;
+	if (reg_is_indoor)
+		reg_is_indoor_portid = portid;
+	else
+		reg_is_indoor_portid = 0;
+
+	spin_unlock(&reg_indoor_lock);
+
+	if (!is_indoor)
+		reg_check_channels();
 
 	return 0;
 }
 
+void regulatory_netlink_notify(u32 portid)
+{
+	spin_lock(&reg_indoor_lock);
+
+	if (reg_is_indoor_portid != portid) {
+		spin_unlock(&reg_indoor_lock);
+		return;
+	}
+
+	reg_is_indoor = false;
+	reg_is_indoor_portid = 0;
+
+	spin_unlock(&reg_indoor_lock);
+
+	reg_check_channels();
+}
+
 /* Driver hints */
 int regulatory_hint(struct wiphy *wiphy, const char *alpha2)
 {
@@ -2480,7 +2491,17 @@ static void restore_regulatory_settings(bool reset_user)
 
 	ASSERT_RTNL();
 
-	reg_is_indoor = false;
+	/*
+	 * Clear the indoor setting in case that it is not controlled by user
+	 * space, as otherwise there is no guarantee that the device is still
+	 * operating in an indoor environment.
+	 */
+	spin_lock(&reg_indoor_lock);
+	if (reg_is_indoor && !reg_is_indoor_portid) {
+		reg_is_indoor = false;
+		reg_check_channels();
+	}
+	spin_unlock(&reg_indoor_lock);
 
 	reset_regdomains(true, &world_regdom);
 	restore_alpha2(alpha2, reset_user);
@@ -3077,6 +3098,7 @@ int __init regulatory_init(void)
 
 	spin_lock_init(&reg_requests_lock);
 	spin_lock_init(&reg_pending_beacons_lock);
+	spin_lock_init(&reg_indoor_lock);
 
 	reg_regdb_size_check();
 
diff --git a/net/wireless/reg.h b/net/wireless/reg.h
index 4b45d6e..a2c4e16 100644
--- a/net/wireless/reg.h
+++ b/net/wireless/reg.h
@@ -25,7 +25,20 @@ enum nl80211_dfs_regions reg_get_dfs_region(struct wiphy *wiphy);
 
 int regulatory_hint_user(const char *alpha2,
 			 enum nl80211_user_reg_hint_type user_reg_hint_type);
-int regulatory_hint_indoor_user(void);
+
+/**
+ * regulatory_hint_indoor - hint operation in indoor env. or not
+ * @is_indoor: if true indicates that user space thinks that the
+ * device is operating in an indoor environment.
+ * @portid: the netlink port ID on which the hint was given.
+ */
+int regulatory_hint_indoor(bool is_indoor, u32 portid);
+
+/**
+ * regulatory_netlink_notify - notify on released netlink socket
+ * @portid: the netlink socket port ID
+ */
+void regulatory_netlink_notify(u32 portid);
 
 void wiphy_regulatory_register(struct wiphy *wiphy);
 void wiphy_regulatory_deregister(struct wiphy *wiphy);
-- 
1.8.3.2

