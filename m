Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:34789 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755129AbbAFNIR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Jan 2015 08:08:17 -0500
From: Ilan Peer <ilan.peer@intel.com>
To: linux-wireless@vger.kernel.org
Cc: mcgrof@suse.com, Ilan Peer <ilan.peer@intel.com>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH v3 1/2] cfg80211: Add API to change the indoor regulatory setting
Date: Tue,  6 Jan 2015 02:10:26 -0500
Message-Id: <1420528226-16843-1-git-send-email-ilan.peer@intel.com> (sfid-20150106_140820_234051_00FC4618)
In-Reply-To: <1420519942-16109-1-git-send-email-ilan.peer@intel.com>
References: <1420519942-16109-1-git-send-email-ilan.peer@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

As the operating environment of a device can change, add
API for user space to indicate a change of indoor settings.
In addition modify the handling of the indoor processing as
follows:

1. Directly update the indoor setting without wrapping it as a
   regulatory request.
2. Track the socket on which the indoor hint is issued, and reset
   indoor setting if the socket was released. The motivation here is to
   force a user space process that sets the indoor setting to constantly
   monitor this setting, and be responsible to correctly toggling it,
   so indoor operation will not be enabled uncontrolled.
3. Do not reset the indoor setting when restoring the regulatory
   settings as it has nothing to do with CRDA or interface
   disconnection.

Signed-off-by: Ilan Peer <ilan.peer@intel.com>
Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 include/uapi/linux/nl80211.h |  5 +++
 net/wireless/nl80211.c       | 10 +++++-
 net/wireless/reg.c           | 80 +++++++++++++++++++++++++-------------------
 net/wireless/reg.h           | 15 ++++++++-
 4 files changed, 73 insertions(+), 37 deletions(-)

diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 54f3911..6ef0a5a 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -1713,6 +1713,9 @@ enum nl80211_commands {
  *	obtained from it is coming from the device's wiphy and not the global
  *	cfg80211 regdomain.
  *
+ * @NL80211_ATTR_REG_INDOOR: flag attribute, if set indicates that the device
+ *      is operating in an indoor environment.
+ *
  * @NUM_NL80211_ATTR: total number of nl80211_attrs available
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
@@ -2072,6 +2075,8 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_WIPHY_SELF_MANAGED_REG,
 
+	NL80211_ATTR_REG_INDOOR,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 7029201..ca12a31 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -397,6 +397,7 @@ static const struct nla_policy nl80211_policy[NUM_NL80211_ATTR] = {
 	[NL80211_ATTR_SMPS_MODE] = { .type = NLA_U8 },
 	[NL80211_ATTR_MAC_MASK] = { .len = ETH_ALEN },
 	[NL80211_ATTR_WIPHY_SELF_MANAGED_REG] = { .type = NLA_FLAG },
+	[NL80211_ATTR_REG_INDOOR] = { .type = NLA_FLAG },
 };
 
 /* policy for the key attributes */
@@ -4923,6 +4924,7 @@ static int parse_reg_rule(struct nlattr *tb[],
 static int nl80211_req_set_reg(struct sk_buff *skb, struct genl_info *info)
 {
 	char *data = NULL;
+	bool is_indoor;
 	enum nl80211_user_reg_hint_type user_reg_hint_type;
 
 	/*
@@ -4949,7 +4951,8 @@ static int nl80211_req_set_reg(struct sk_buff *skb, struct genl_info *info)
 		data = nla_data(info->attrs[NL80211_ATTR_REG_ALPHA2]);
 		return regulatory_hint_user(data, user_reg_hint_type);
 	case NL80211_USER_REG_HINT_INDOOR:
-		return regulatory_hint_indoor_user();
+		is_indoor = !!info->attrs[NL80211_ATTR_REG_INDOOR];
+		return regulatory_hint_indoor(is_indoor, info->snd_portid);
 	default:
 		return -EINVAL;
 	}
@@ -12669,6 +12672,11 @@ static int nl80211_netlink_notify(struct notifier_block * nb,
 
 	rcu_read_unlock();
 
+	/*
+	 * It is possible that the user space process that is controlling the
+	 * indoor setting disappeared, so notify the regulatory core.
+	 */
+	regulatory_netlink_notify(notify->portid);
 	return NOTIFY_OK;
 }
 
diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 9a5411c..6b0da81 100644
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
@@ -1815,11 +1806,6 @@ __reg_process_hint_user(struct regulatory_request *user_request)
 {
 	struct regulatory_request *lr = get_last_request();
 
-	if (reg_request_indoor(user_request)) {
-		reg_is_indoor = true;
-		return REG_REQ_USER_HINT_HANDLED;
-	}
-
 	if (reg_request_cell_base(user_request))
 		return reg_ignore_cell_hint(user_request);
 
@@ -1867,8 +1853,7 @@ reg_process_hint_user(struct regulatory_request *user_request)
 
 	treatment = __reg_process_hint_user(user_request);
 	if (treatment == REG_REQ_IGNORE ||
-	    treatment == REG_REQ_ALREADY_SET ||
-	    treatment == REG_REQ_USER_HINT_HANDLED) {
+	    treatment == REG_REQ_ALREADY_SET) {
 		reg_free_request(user_request);
 		return treatment;
 	}
@@ -1929,7 +1914,6 @@ reg_process_hint_driver(struct wiphy *wiphy,
 	case REG_REQ_OK:
 		break;
 	case REG_REQ_IGNORE:
-	case REG_REQ_USER_HINT_HANDLED:
 		reg_free_request(driver_request);
 		return treatment;
 	case REG_REQ_INTERSECT:
@@ -2029,7 +2013,6 @@ reg_process_hint_country_ie(struct wiphy *wiphy,
 	case REG_REQ_OK:
 		break;
 	case REG_REQ_IGNORE:
-	case REG_REQ_USER_HINT_HANDLED:
 		/* fall through */
 	case REG_REQ_ALREADY_SET:
 		reg_free_request(country_ie_request);
@@ -2068,8 +2051,7 @@ static void reg_process_hint(struct regulatory_request *reg_request)
 	case NL80211_REGDOM_SET_BY_USER:
 		treatment = reg_process_hint_user(reg_request);
 		if (treatment == REG_REQ_IGNORE ||
-		    treatment == REG_REQ_ALREADY_SET ||
-		    treatment == REG_REQ_USER_HINT_HANDLED)
+		    treatment == REG_REQ_ALREADY_SET)
 			return;
 		queue_delayed_work(system_power_efficient_wq,
 				   &reg_timeout, msecs_to_jiffies(3142));
@@ -2266,22 +2248,51 @@ int regulatory_hint_user(const char *alpha2,
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
@@ -2449,8 +2460,6 @@ static void restore_regulatory_settings(bool reset_user)
 
 	ASSERT_RTNL();
 
-	reg_is_indoor = false;
-
 	reset_regdomains(true, &world_regdom);
 	restore_alpha2(alpha2, reset_user);
 
@@ -3019,6 +3028,7 @@ int __init regulatory_init(void)
 
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

