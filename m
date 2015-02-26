Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:28400 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752891AbbBZPv4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Feb 2015 10:51:56 -0500
From: Ilan Peer <ilan.peer@intel.com>
To: linux-wireless@vger.kernel.org, mcgrof@suse.com
Cc: Ilan Peer <ilan.peer@intel.com>, ArikX Nemtsov <arik@wizery.com>
Subject: [PATCH v8 2/3] cfg80211: Add API to change the indoor regulatory setting
Date: Thu, 26 Feb 2015 04:54:06 -0500
Message-Id: <1424944447-10988-2-git-send-email-ilan.peer@intel.com> (sfid-20150226_165201_227858_2ECEE1BE)
In-Reply-To: <1424944447-10988-1-git-send-email-ilan.peer@intel.com>
References: <1424944447-10988-1-git-send-email-ilan.peer@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Previously, the indoor setting configuration assumed that as
long as a station interface is connected, the indoor environment
setting does not change. However, this assumption is problematic
as:

- It is possible that a station interface is connected to a mobile
  AP, e.g., softAP or a P2P GO, where it is possible that both the
  station and the mobile AP move out of the indoor environment making
  the indoor setting invalid. In such a case, user space has no way to
  invalidate the setting.
- A station interface disconnection does not necessarily imply that
  the device is no longer operating in an indoor environment, e.g.,
  it is possible that the station interface is roaming but is still
  stays indoor.

To handle the above, extend the indoor configuration API to allow
user space to indicate a change of indoor settings, and allow it to
indicate weather it controls the indoor setting, such that:

1. If the user space process explicitly indicates that it is going
   to control the indoor setting, do not clear the indoor setting
   internally, unless the socket is released. The user space process
   should use the NL80211_ATTR_SOCKET_OWNER attribute in the command
   to state that it is going to control the indoor setting.
2. Reset the indoor setting when restoring the regulatory settings in
   case it is not owned by a user space process.

Based on the above, a user space tool that continuously monitors the
indoor settings, i.e., tracking power setting, location etc., can
indicate environment changes to the regulatory core.

Currently, in case a received country IE includes environment
information (indicates that the country IE applies only to
indoor operation or only to outdoor operation) it is currently not
used.

Signed-off-by: Ilan Peer <ilan.peer@intel.com>
Signed-off-by: ArikX Nemtsov <arik@wizery.com>
---
 include/uapi/linux/nl80211.h |  9 +++++++
 net/wireless/nl80211.c       | 19 ++++++++++++++-
 net/wireless/reg.c           | 58 +++++++++++++++++++++++++++++++++++++++++---
 net/wireless/reg.h           | 15 +++++++++++-
 4 files changed, 95 insertions(+), 6 deletions(-)

diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 2dcf9bb..e59ea18 100644
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
index 9c6e23e..aa221a3 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -399,6 +399,7 @@ static const struct nla_policy nl80211_policy[NUM_NL80211_ATTR] = {
 	[NL80211_ATTR_WIPHY_SELF_MANAGED_REG] = { .type = NLA_FLAG },
 	[NL80211_ATTR_NETNS_FD] = { .type = NLA_U32 },
 	[NL80211_ATTR_SCHED_SCAN_DELAY] = { .type = NLA_U32 },
+	[NL80211_ATTR_REG_INDOOR] = { .type = NLA_FLAG },
 };
 
 /* policy for the key attributes */
@@ -4958,7 +4959,10 @@ static int parse_reg_rule(struct nlattr *tb[],
 static int nl80211_req_set_reg(struct sk_buff *skb, struct genl_info *info)
 {
 	char *data = NULL;
+	bool is_indoor;
 	enum nl80211_user_reg_hint_type user_reg_hint_type;
+	u32 owner_nlportid;
+
 
 	/*
 	 * You should only get this when cfg80211 hasn't yet initialized
@@ -4984,7 +4988,15 @@ static int nl80211_req_set_reg(struct sk_buff *skb, struct genl_info *info)
 		data = nla_data(info->attrs[NL80211_ATTR_REG_ALPHA2]);
 		return regulatory_hint_user(data, user_reg_hint_type);
 	case NL80211_USER_REG_HINT_INDOOR:
-		return regulatory_hint_indoor_user();
+		if (info->attrs[NL80211_ATTR_SOCKET_OWNER]) {
+			owner_nlportid = info->snd_portid;
+			is_indoor = !!info->attrs[NL80211_ATTR_REG_INDOOR];
+		} else {
+			owner_nlportid = 0;
+			is_indoor = true;
+		}
+
+		return regulatory_hint_indoor(is_indoor, owner_nlportid);
 	default:
 		return -EINVAL;
 	}
@@ -12767,6 +12779,11 @@ static int nl80211_netlink_notify(struct notifier_block * nb,
 
 	rcu_read_unlock();
 
+	/*
+	 * It is possible that the user space process that is controlling the
+	 * indoor setting disappeared, so notify the regulatory core.
+	 */
+	regulatory_netlink_notify(notify->portid);
 	return NOTIFY_OK;
 }
 
diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index c24c8bf..4ccf563 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -128,9 +128,12 @@ static int reg_num_devs_support_basehint;
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
@@ -2288,15 +2291,51 @@ int regulatory_hint_user(const char *alpha2,
 	return 0;
 }
 
-int regulatory_hint_indoor_user(void)
+int regulatory_hint_indoor(bool is_indoor, u32 portid)
 {
+	spin_lock(&reg_indoor_lock);
 
+	/*
+	 * Process only if there is a real change, so the original port ID is
+	 * saved (to handle cases that several processes try to change the
+	 * indoor setting).
+	 */
+	if (reg_is_indoor == is_indoor) {
+		spin_unlock(&reg_indoor_lock);
+		return 0;
+	}
 
-	reg_is_indoor = true;
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
@@ -2464,7 +2503,17 @@ static void restore_regulatory_settings(bool reset_user)
 
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
@@ -3061,6 +3110,7 @@ int __init regulatory_init(void)
 
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

