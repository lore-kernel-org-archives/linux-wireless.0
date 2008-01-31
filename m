Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:39071 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755857AbYBAMJO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Feb 2008 07:09:14 -0500
Message-Id: <20080131185052.585558000@sipsolutions.net> (sfid-20080201_120922_489895_0DD2EFB0)
References: <20080131184819.103174000@sipsolutions.net>
Date: Thu, 31 Jan 2008 19:48:22 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Michael Wu <flamingice@sourmilk.net>
Subject: [PATCH 3/8] nl80211: Add monitor interface configuration flags
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Michael Wu <flamingice@sourmilk.net>

This allows precise control over what a monitor interface shows.

Signed-off-by: Michael Wu <flamingice@sourmilk.net>
Signed-off-by: Johannes Berg <johannes@sipsolutions.net> 
---

 include/linux/nl80211.h |   35 +++++++++++++++++++++++++++++++++++
 include/net/cfg80211.h  |   24 ++++++++++++++++++++++--
 net/mac80211/cfg.c      |    4 ++--
 net/wireless/nl80211.c  |   44 ++++++++++++++++++++++++++++++++++++++++++--
 4 files changed, 101 insertions(+), 6 deletions(-)

--- everything.orig/include/linux/nl80211.h	2008-01-31 15:45:56.535794433 +0100
+++ everything/include/linux/nl80211.h	2008-01-31 15:46:10.795795138 +0100
@@ -164,6 +164,9 @@ enum nl80211_commands {
  * @NL80211_ATTR_WIPHY_BANDS: Information about an operating bands,
  *	consisting of a nested array.
  *
+ * @NL80211_ATTR_MNTR_FLAGS: flags, nested element with NLA_FLAG attributes of
+ *      &enum nl80211_mntr_flags.
+ *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
@@ -200,6 +203,8 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_WIPHY_BANDS,
 
+	NL80211_ATTR_MNTR_FLAGS,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
@@ -344,4 +349,34 @@ enum nl80211_bitrate_attr {
 	NL80211_BITRATE_ATTR_MAX = __NL80211_BITRATE_ATTR_AFTER_LAST - 1
 };
 
+/**
+ * enum nl80211_mntr_flags - monitor configuration flags
+ *
+ * Monitor configuration flags.
+ *
+ * @__NL80211_MNTR_FLAG_INVALID: reserved
+ *
+ * @NL80211_MNTR_FLAG_FCSFAIL: pass frames with bad FCS
+ * @NL80211_MNTR_FLAG_PLCPFAIL: pass frames with bad PLCP
+ * @NL80211_MNTR_FLAG_CONTROL: pass control frames
+ * @NL80211_MNTR_FLAG_OTHER_BSS: disable BSSID filtering
+ * @NL80211_MNTR_FLAG_COOK_FRAMES: report frames after processing.
+ *	overrides all other flags.
+ *
+ * @__NL80211_MNTR_FLAG_AFTER_LAST: internal use
+ * @NL80211_MNTR_FLAG_MAX: highest possible monitor flag
+ */
+enum nl80211_mntr_flags {
+	__NL80211_MNTR_FLAG_INVALID,
+	NL80211_MNTR_FLAG_FCSFAIL,
+	NL80211_MNTR_FLAG_PLCPFAIL,
+	NL80211_MNTR_FLAG_CONTROL,
+	NL80211_MNTR_FLAG_OTHER_BSS,
+	NL80211_MNTR_FLAG_COOK_FRAMES,
+
+	/* keep last */
+	__NL80211_MNTR_FLAG_AFTER_LAST,
+	NL80211_MNTR_FLAG_MAX = __NL80211_MNTR_FLAG_AFTER_LAST - 1
+};
+
 #endif /* __LINUX_NL80211_H */
--- everything.orig/include/net/cfg80211.h	2008-01-31 15:45:56.615793023 +0100
+++ everything/include/net/cfg80211.h	2008-01-31 15:46:10.795795138 +0100
@@ -163,6 +163,26 @@ struct station_stats {
 	u32 tx_bytes;
 };
 
+/**
+ * enum monitor_flags - monitor flags
+ *
+ * Monitor interface configuration flags. Note that these must be the bits
+ * according to the nl80211 flags.
+ *
+ * @MONITOR_FLAG_FCSFAIL: pass frames with bad FCS
+ * @MONITOR_FLAG_PLCPFAIL: pass frames with bad PLCP
+ * @MONITOR_FLAG_CONTROL: pass control frames
+ * @MONITOR_FLAG_OTHER_BSS: disable BSSID filtering
+ * @MONITOR_FLAG_COOK_FRAMES: report frames after processing
+ */
+enum monitor_flags {
+	MONITOR_FLAG_FCSFAIL		= 1<<NL80211_MNTR_FLAG_FCSFAIL,
+	MONITOR_FLAG_PLCPFAIL		= 1<<NL80211_MNTR_FLAG_PLCPFAIL,
+	MONITOR_FLAG_CONTROL		= 1<<NL80211_MNTR_FLAG_CONTROL,
+	MONITOR_FLAG_OTHER_BSS		= 1<<NL80211_MNTR_FLAG_OTHER_BSS,
+	MONITOR_FLAG_COOK_FRAMES	= 1<<NL80211_MNTR_FLAG_COOK_FRAMES,
+};
+
 /* from net/wireless.h */
 struct wiphy;
 
@@ -213,10 +233,10 @@ struct wiphy;
  */
 struct cfg80211_ops {
 	int	(*add_virtual_intf)(struct wiphy *wiphy, char *name,
-				    enum nl80211_iftype type);
+				    enum nl80211_iftype type, u32 *flags);
 	int	(*del_virtual_intf)(struct wiphy *wiphy, int ifindex);
 	int	(*change_virtual_intf)(struct wiphy *wiphy, int ifindex,
-				       enum nl80211_iftype type);
+				       enum nl80211_iftype type, u32 *flags);
 
 	int	(*add_key)(struct wiphy *wiphy, struct net_device *netdev,
 			   u8 key_index, u8 *mac_addr,
--- everything.orig/net/mac80211/cfg.c	2008-01-31 15:45:59.195794920 +0100
+++ everything/net/mac80211/cfg.c	2008-01-31 15:46:10.825789821 +0100
@@ -34,7 +34,7 @@ nl80211_type_to_mac80211_type(enum nl802
 }
 
 static int ieee80211_add_iface(struct wiphy *wiphy, char *name,
-			       enum nl80211_iftype type)
+			       enum nl80211_iftype type, u32 *flags)
 {
 	struct ieee80211_local *local = wiphy_priv(wiphy);
 	enum ieee80211_if_types itype;
@@ -69,7 +69,7 @@ static int ieee80211_del_iface(struct wi
 }
 
 static int ieee80211_change_iface(struct wiphy *wiphy, int ifindex,
-				  enum nl80211_iftype type)
+				  enum nl80211_iftype type, u32 *flags)
 {
 	struct ieee80211_local *local = wiphy_priv(wiphy);
 	struct net_device *dev;
--- everything.orig/net/wireless/nl80211.c	2008-01-31 15:45:56.725795193 +0100
+++ everything/net/wireless/nl80211.c	2008-01-31 15:46:10.825789821 +0100
@@ -82,6 +82,7 @@ static struct nla_policy nl80211_policy[
 	[NL80211_ATTR_STA_SUPPORTED_RATES] = { .type = NLA_BINARY,
 					       .len = NL80211_MAX_SUPP_RATES },
 	[NL80211_ATTR_STA_VLAN] = { .type = NLA_U32 },
+	[NL80211_ATTR_MNTR_FLAGS] = { .type = NLA_NESTED },
 };
 
 /* message building helper */
@@ -336,12 +337,42 @@ static int nl80211_get_interface(struct 
 	return -ENOBUFS;
 }
 
+static const struct nla_policy mntr_flags_policy[NL80211_MNTR_FLAG_MAX + 1] = {
+	[NL80211_MNTR_FLAG_FCSFAIL] = { .type = NLA_FLAG },
+	[NL80211_MNTR_FLAG_PLCPFAIL] = { .type = NLA_FLAG },
+	[NL80211_MNTR_FLAG_CONTROL] = { .type = NLA_FLAG },
+	[NL80211_MNTR_FLAG_OTHER_BSS] = { .type = NLA_FLAG },
+	[NL80211_MNTR_FLAG_COOK_FRAMES] = { .type = NLA_FLAG },
+};
+
+static int parse_monitor_flags(struct nlattr *nla, u32 *mntrflags)
+{
+	struct nlattr *flags[NL80211_MNTR_FLAG_MAX + 1];
+	int flag;
+
+	*mntrflags = 0;
+
+	if (!nla)
+		return -EINVAL;
+
+	if (nla_parse_nested(flags, NL80211_MNTR_FLAG_MAX,
+			     nla, mntr_flags_policy))
+		return -EINVAL;
+
+	for (flag = 1; flag <= NL80211_MNTR_FLAG_MAX; flag++)
+		if (flags[flag])
+			*mntrflags |= (1<<flag);
+
+	return 0;
+}
+
 static int nl80211_set_interface(struct sk_buff *skb, struct genl_info *info)
 {
 	struct cfg80211_registered_device *drv;
 	int err, ifindex;
 	enum nl80211_iftype type;
 	struct net_device *dev;
+	u32 flags;
 
 	if (info->attrs[NL80211_ATTR_IFTYPE]) {
 		type = nla_get_u32(info->attrs[NL80211_ATTR_IFTYPE]);
@@ -362,7 +393,11 @@ static int nl80211_set_interface(struct 
 	}
 
 	rtnl_lock();
-	err = drv->ops->change_virtual_intf(&drv->wiphy, ifindex, type);
+	err = parse_monitor_flags(type == NL80211_IFTYPE_MONITOR ?
+				  info->attrs[NL80211_ATTR_MNTR_FLAGS] : NULL,
+				  &flags);
+	err = drv->ops->change_virtual_intf(&drv->wiphy, ifindex,
+					    type, err ? NULL : &flags);
 	rtnl_unlock();
 
  unlock:
@@ -375,6 +410,7 @@ static int nl80211_new_interface(struct 
 	struct cfg80211_registered_device *drv;
 	int err;
 	enum nl80211_iftype type = NL80211_IFTYPE_UNSPECIFIED;
+	u32 flags;
 
 	if (!info->attrs[NL80211_ATTR_IFNAME])
 		return -EINVAL;
@@ -395,8 +431,12 @@ static int nl80211_new_interface(struct 
 	}
 
 	rtnl_lock();
+	err = parse_monitor_flags(type == NL80211_IFTYPE_MONITOR ?
+				  info->attrs[NL80211_ATTR_MNTR_FLAGS] : NULL,
+				  &flags);
 	err = drv->ops->add_virtual_intf(&drv->wiphy,
-		nla_data(info->attrs[NL80211_ATTR_IFNAME]), type);
+		nla_data(info->attrs[NL80211_ATTR_IFNAME]),
+		type, err ? NULL : &flags);
 	rtnl_unlock();
 
  unlock:

-- 

