Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:40429 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753840AbXJYNWv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Oct 2007 09:22:51 -0400
Received: from [131.234.198.68]
	by sipsolutions.net with esmtpsa (TLS-1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.67)
	(envelope-from <johannes@sipsolutions.net>)
	id 1Il2ff-0000dz-No
	for linux-wireless@vger.kernel.org; Thu, 25 Oct 2007 14:22:48 +0100
Message-Id: <20071025093716.685606000@sipsolutions.net> (sfid-20071025_142259_000258_E3C7FFAE)
References: <20071025093618.440937000@sipsolutions.net>
Date: Thu, 25 Oct 2007 11:36:24 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [patch 6/9] nl80211/cfg80211: station handling
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds station handling to cfg80211/nl80211.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

---
 include/linux/nl80211.h |   68 +++++++++++++
 include/net/cfg80211.h  |   54 ++++++++++
 net/wireless/nl80211.c  |  236 ++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 358 insertions(+)

--- linux-2.6.orig/include/linux/nl80211.h	2007-10-24 16:50:00.170256240 +0200
+++ linux-2.6/include/linux/nl80211.h	2007-10-24 16:57:06.090256076 +0200
@@ -7,6 +7,18 @@
  */
 
 /**
+ * DOC: Station handling
+ *
+ * Stations are added per interface, but a special case exists with VLAN
+ * interfaces. When a station is bound to an AP interface, it may be moved
+ * into a VLAN identified by a VLAN interface index (%NL80211_ATTR_STA_VLAN).
+ * The station is still assumed to belong to the AP interface it was added
+ * to.
+ *
+ * TODO: need more info?
+ */
+
+/**
  * enum nl80211_commands - supported nl80211 commands
  *
  * @NL80211_CMD_UNSPEC: unspecified command to catch errors
@@ -51,6 +63,16 @@
  *	the %NL80211_ATTR_BEACON_INTERVAL, %NL80211_ATTR_DTIM_PERIOD,
  *	%NL80211_BEACON_HEAD and %NL80211_BEACON_TAIL attributes.
  *
+ * @NL80211_CMD_GET_STATION: Get station attributes for station identified by
+ *	%NL80211_ATTR_MAC on the interface identified by %NL80211_ATTR_IFINDEX.
+ * @NL80211_CMD_SET_STATION: Set station attributes for station identified by
+ *	%NL80211_ATTR_MAC on the interface identified by %NL80211_ATTR_IFINDEX.
+ * @NL80211_CMD_NEW_STATION: Add a station with given attributes to the
+ *	the interface identified by %NL80211_ATTR_IFINDEX.
+ * @NL80211_CMD_DEL_STATION: Remove a station identified by %NL80211_ATTR_MAC
+ *	or, if no MAC address given, all stations, on the interface identified
+ *	by %NL80211_ATTR_IFINDEX.
+ *
  * @NL80211_CMD_MAX: highest used command number
  * @__NL80211_CMD_AFTER_LAST: internal use
  */
@@ -78,6 +100,11 @@ enum nl80211_commands {
 	NL80211_CMD_NEW_BEACON, /* ? */
 	NL80211_CMD_DEL_BEACON, /* ? */
 
+	NL80211_CMD_GET_STATION,
+	NL80211_CMD_SET_STATION,
+	NL80211_CMD_NEW_STATION,
+	NL80211_CMD_DEL_STATION,
+
 	/* add commands here */
 
 	/* used to define NL80211_CMD_MAX below */
@@ -115,6 +142,17 @@ enum nl80211_commands {
  * @NL80211_ATTR_BEACON_HEAD: portion of the beacon before the TIM IE
  * @NL80211_ATTR_BEACON_TAIL: portion of the beacon after the TIM IE
  *
+ * @NL80211_ATTR_STA_AID: Association ID for the station (u16)
+ * @NL80211_ATTR_STA_FLAGS: flags, nested element with NLA_FLAG attributes of
+ *	&enum nl80211_sta_flags.
+ * @NL80211_ATTR_STA_LISTEN_INTERVAL: listen interval as defined by
+ *	IEEE 802.11 7.3.1.6 (u16).
+ * @NL80211_ATTR_STA_SUPPORTED_RATES: supported rates, array of supported
+ *	rates as defined by IEEE 802.11 7.3.2.2 but without the length
+ *	restriction (at most %NL80211_MAX_SUPP_RATES).
+ * @NL80211_ATTR_STA_VLAN: interface index of VLAN interface to move station
+ *	to, or the AP interface the station was originally added to to.
+ *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
@@ -142,12 +180,20 @@ enum nl80211_attrs {
 	NL80211_ATTR_BEACON_HEAD,
 	NL80211_ATTR_BEACON_TAIL,
 
+	NL80211_ATTR_STA_AID,
+	NL80211_ATTR_STA_FLAGS,
+	NL80211_ATTR_STA_LISTEN_INTERVAL,
+	NL80211_ATTR_STA_SUPPORTED_RATES,
+	NL80211_ATTR_STA_VLAN,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
 	NL80211_ATTR_MAX = __NL80211_ATTR_AFTER_LAST - 1
 };
 
+#define NL80211_MAX_SUPP_RATES	32
+
 /**
  * enum nl80211_iftype - (virtual) interface types
  *
@@ -179,4 +225,26 @@ enum nl80211_iftype {
 	NL80211_IFTYPE_MAX = __NL80211_IFTYPE_AFTER_LAST - 1
 };
 
+/**
+ * enum nl80211_sta_flags - station flags
+ *
+ * Station flags. When a station is added to an AP interface, it is
+ * assumed to be already associated (and hence authenticated.)
+ *
+ * @NL80211_STA_FLAG_AUTHORIZED: station is authorized (802.1X)
+ * @NL80211_STA_FLAG_SHORT_PREAMBLE: station is capable of receiving frames
+ *	with short barker preamble
+ * @NL80211_STA_FLAG_WME: station is WME/QoS capable
+ */
+enum nl80211_sta_flags {
+	__NL80211_STA_FLAG_INVALID,
+	NL80211_STA_FLAG_AUTHORIZED,
+	NL80211_STA_FLAG_SHORT_PREAMBLE,
+	NL80211_STA_FLAG_WME,
+
+	/* keep last */
+	__NL80211_STA_FLAG_AFTER_LAST,
+	NL80211_STA_FLAG_MAX = __NL80211_STA_FLAG_AFTER_LAST - 1
+};
+
 #endif /* __LINUX_NL80211_H */
--- linux-2.6.orig/include/net/cfg80211.h	2007-10-24 16:50:00.200259495 +0200
+++ linux-2.6/include/net/cfg80211.h	2007-10-24 16:56:35.020252386 +0200
@@ -89,6 +89,47 @@ struct beacon_parameters {
 	int head_len, tail_len;
 };
 
+/**
+ * enum station_flags - station flags
+ *
+ * Station capability flags. Note that these must be the bits
+ * according to the nl80211 flags.
+ *
+ * @STATION_FLAG_CHANGED: station flags were changed
+ * @STATION_FLAG_AUTHORIZED: station is authorized to send frames (802.1X)
+ * @STATION_FLAG_SHORT_PREAMBLE: station is capable of receiving frames
+ *	with short preambles
+ * @STATION_FLAG_WME: station is WME/QoS capable
+ */
+enum station_flags {
+	STATION_FLAG_CHANGED		= 1<<0,
+	STATION_FLAG_AUTHORIZED		= 1<<NL80211_STA_FLAG_AUTHORIZED,
+	STATION_FLAG_SHORT_PREAMBLE	= 1<<NL80211_STA_FLAG_SHORT_PREAMBLE,
+	STATION_FLAG_WME		= 1<<NL80211_STA_FLAG_WME,
+};
+
+/**
+ * struct station_parameters - station parameters
+ *
+ * Used to change and create a new station.
+ *
+ * @vlan: vlan interface station should belong to
+ * @supported_rates: supported rates in IEEE 802.11 format
+ *	(or NULL for no change)
+ * @supported_rates_len: number of supported rates
+ * @station_flags: station flags (see &enum station_flags)
+ * @listen_interval: listen interval or -1 for no change
+ * @aid: AID or zero for no change
+ */
+struct station_parameters {
+	u8 *supported_rates;
+	struct net_device *vlan;
+	u32 station_flags;
+	int listen_interval;
+	u16 aid;
+	u8 supported_rates_len;
+};
+
 /* from net/wireless.h */
 struct wiphy;
 
@@ -127,6 +168,12 @@ struct wiphy;
  * @set_beacon: Set the beacon parameters for an access point mode
  *	interface. The @info parameter can be %NULL when the beacon is
  *	removed.
+ *
+ * @add_station: Add a new station.
+ *
+ * @del_station: Remove a station; @mac may be NULL to remove all stations.
+ *
+ * @change_station: Modify a given station.
  */
 struct cfg80211_ops {
 	int	(*add_virtual_intf)(struct wiphy *wiphy, char *name,
@@ -149,6 +196,13 @@ struct cfg80211_ops {
 
 	int	(*set_beacon)(struct wiphy *wiphy, struct net_device *dev,
 			      struct beacon_parameters *info);
+
+	int	(*add_station)(struct wiphy *wiphy, struct net_device *dev,
+			       u8 *mac, struct station_parameters *params);
+	int	(*del_station)(struct wiphy *wiphy, struct net_device *dev,
+			       u8 *mac);
+	int	(*change_station)(struct wiphy *wiphy, struct net_device *dev,
+				  u8 *mac, struct station_parameters *params);
 };
 
 #endif /* __NET_CFG80211_H */
--- linux-2.6.orig/net/wireless/nl80211.c	2007-10-24 16:50:00.230261882 +0200
+++ linux-2.6/net/wireless/nl80211.c	2007-10-24 16:57:23.710253471 +0200
@@ -76,6 +76,12 @@ static struct nla_policy nl80211_policy[
 				       .len = IEEE80211_MAX_DATA_LEN },
 	[NL80211_ATTR_BEACON_TAIL] = { .type = NLA_BINARY,
 				       .len = IEEE80211_MAX_DATA_LEN },
+	[NL80211_ATTR_STA_AID] = { .type = NLA_U16 },
+	[NL80211_ATTR_STA_FLAGS] = { .type = NLA_NESTED },
+	[NL80211_ATTR_STA_LISTEN_INTERVAL] = { .type = NLA_U16 },
+	[NL80211_ATTR_STA_SUPPORTED_RATES] = { .type = NLA_BINARY,
+					       .len = NL80211_MAX_SUPP_RATES },
+	[NL80211_ATTR_STA_VLAN] = { .type = NLA_U32 },
 };
 
 /* message building helper */
@@ -692,6 +698,211 @@ static int nl80211_del_beacon(struct sk_
 	return err;
 }
 
+static
+struct nla_policy sta_flags_policy[NL80211_STA_FLAG_MAX + 1] __read_mostly = {
+	[NL80211_STA_FLAG_AUTHORIZED] = { .type = NLA_FLAG },
+	[NL80211_STA_FLAG_SHORT_PREAMBLE] = { .type = NLA_FLAG },
+	[NL80211_STA_FLAG_WME] = { .type = NLA_FLAG },
+};
+
+static int parse_station_flags(struct nlattr *nla, u32 *staflags)
+{
+	struct nlattr *flags[NL80211_STA_FLAG_MAX + 1];
+	int flag;
+
+	*staflags = 0;
+
+	if (!nla)
+		return 0;
+
+	if (nla_parse_nested(flags, NL80211_STA_FLAG_MAX,
+			     nla, sta_flags_policy))
+		return -EINVAL;
+
+	*staflags = STATION_FLAG_CHANGED;
+
+	for (flag = 1; flag <= NL80211_STA_FLAG_MAX; flag++)
+		if (flags[flag])
+			*staflags |= (1<<flag);
+
+	return 0;
+}
+
+static int nl80211_get_station(struct sk_buff *skb, struct genl_info *info)
+{
+	return -EOPNOTSUPP;
+}
+
+/*
+ * Get vlan interface making sure it is on the right wiphy.
+ */
+static int get_vlan(struct nlattr *vlanattr,
+		    struct cfg80211_registered_device *rdev,
+		    struct net_device **vlan)
+{
+	if (vlanattr) {
+		*vlan = dev_get_by_index(&init_net, nla_get_u32(vlanattr));
+		if (!*vlan)
+			return -ENODEV;
+		if (!(*vlan)->ieee80211_ptr)
+			return -EINVAL;
+		if (!(*vlan)->ieee80211_ptr)
+			return -EINVAL;
+		if ((*vlan)->ieee80211_ptr->wiphy != &rdev->wiphy)
+			return -EINVAL;
+	}
+	return 0;
+}
+
+static int nl80211_set_station(struct sk_buff *skb, struct genl_info *info)
+{
+	struct cfg80211_registered_device *drv;
+	int err;
+	struct net_device *dev;
+	struct station_parameters params;
+	u8 *mac_addr = NULL;
+
+	memset(&params, 0, sizeof(params));
+
+	params.listen_interval = -1;
+
+	if (info->attrs[NL80211_ATTR_STA_AID])
+		return -EINVAL;
+
+	if (!info->attrs[NL80211_ATTR_MAC])
+		return -EINVAL;
+
+	mac_addr = nla_data(info->attrs[NL80211_ATTR_MAC]);
+
+	if (info->attrs[NL80211_ATTR_STA_SUPPORTED_RATES]) {
+		params.supported_rates =
+			nla_data(info->attrs[NL80211_ATTR_STA_SUPPORTED_RATES]);
+		params.supported_rates_len =
+			nla_len(info->attrs[NL80211_ATTR_STA_SUPPORTED_RATES]);
+	}
+
+	if (info->attrs[NL80211_ATTR_STA_LISTEN_INTERVAL])
+		params.listen_interval =
+		    nla_get_u16(info->attrs[NL80211_ATTR_STA_LISTEN_INTERVAL]);
+
+	if (parse_station_flags(info->attrs[NL80211_ATTR_STA_FLAGS],
+				&params.station_flags))
+		return -EINVAL;
+
+	err = get_drv_dev_by_info_ifindex(info, &drv, &dev);
+	if (err)
+		return err;
+
+	err = get_vlan(info->attrs[NL80211_ATTR_STA_VLAN], drv, &params.vlan);
+	if (err)
+		goto out;
+
+	if (!drv->ops->change_station) {
+		err = -EOPNOTSUPP;
+		goto out;
+	}
+
+	rtnl_lock();
+	err = drv->ops->change_station(&drv->wiphy, dev, mac_addr, &params);
+	rtnl_unlock();
+
+ out:
+	if (params.vlan)
+		dev_put(params.vlan);
+	cfg80211_put_dev(drv);
+	dev_put(dev);
+	return err;
+}
+
+static int nl80211_new_station(struct sk_buff *skb, struct genl_info *info)
+{
+	struct cfg80211_registered_device *drv;
+	int err;
+	struct net_device *dev;
+	struct station_parameters params;
+	u8 *mac_addr = NULL;
+
+	memset(&params, 0, sizeof(params));
+
+	if (!info->attrs[NL80211_ATTR_MAC])
+		return -EINVAL;
+
+	if (!info->attrs[NL80211_ATTR_STA_AID])
+		return -EINVAL;
+
+	if (!info->attrs[NL80211_ATTR_STA_LISTEN_INTERVAL])
+		return -EINVAL;
+
+	if (!info->attrs[NL80211_ATTR_STA_SUPPORTED_RATES])
+		return -EINVAL;
+
+	mac_addr = nla_data(info->attrs[NL80211_ATTR_MAC]);
+	params.supported_rates =
+		nla_data(info->attrs[NL80211_ATTR_STA_SUPPORTED_RATES]);
+	params.supported_rates_len =
+		nla_len(info->attrs[NL80211_ATTR_STA_SUPPORTED_RATES]);
+	params.listen_interval =
+		nla_get_u16(info->attrs[NL80211_ATTR_STA_LISTEN_INTERVAL]);
+	params.listen_interval = nla_get_u16(info->attrs[NL80211_ATTR_STA_AID]);
+
+	if (parse_station_flags(info->attrs[NL80211_ATTR_STA_FLAGS],
+				&params.station_flags))
+		return -EINVAL;
+
+	err = get_drv_dev_by_info_ifindex(info, &drv, &dev);
+	if (err)
+		return err;
+
+	err = get_vlan(info->attrs[NL80211_ATTR_STA_VLAN], drv, &params.vlan);
+	if (err)
+		goto out;
+
+	if (!drv->ops->add_station) {
+		err = -EOPNOTSUPP;
+		goto out;
+	}
+
+	rtnl_lock();
+	err = drv->ops->add_station(&drv->wiphy, dev, mac_addr, &params);
+	rtnl_unlock();
+
+ out:
+	if (params.vlan)
+		dev_put(params.vlan);
+	cfg80211_put_dev(drv);
+	dev_put(dev);
+	return err;
+}
+
+static int nl80211_del_station(struct sk_buff *skb, struct genl_info *info)
+{
+	struct cfg80211_registered_device *drv;
+	int err;
+	struct net_device *dev;
+	u8 *mac_addr = NULL;
+
+	if (info->attrs[NL80211_ATTR_MAC])
+		mac_addr = nla_data(info->attrs[NL80211_ATTR_MAC]);
+
+	err = get_drv_dev_by_info_ifindex(info, &drv, &dev);
+	if (err)
+		return err;
+
+	if (!drv->ops->del_station) {
+		err = -EOPNOTSUPP;
+		goto out;
+	}
+
+	rtnl_lock();
+	err = drv->ops->del_station(&drv->wiphy, dev, mac_addr);
+	rtnl_unlock();
+
+ out:
+	cfg80211_put_dev(drv);
+	dev_put(dev);
+	return err;
+}
+
 static struct genl_ops nl80211_ops[] = {
 	{
 		.cmd = NL80211_CMD_GET_WIPHY,
@@ -774,6 +985,31 @@ static struct genl_ops nl80211_ops[] = {
 		.flags = GENL_ADMIN_PERM,
 		.doit = nl80211_del_beacon,
 	},
+	{
+		.cmd = NL80211_CMD_GET_STATION,
+		.doit = nl80211_get_station,
+		/* TODO: implement dumpit */
+		.policy = nl80211_policy,
+		.flags = GENL_ADMIN_PERM,
+	},
+	{
+		.cmd = NL80211_CMD_SET_STATION,
+		.doit = nl80211_set_station,
+		.policy = nl80211_policy,
+		.flags = GENL_ADMIN_PERM,
+	},
+	{
+		.cmd = NL80211_CMD_NEW_STATION,
+		.doit = nl80211_new_station,
+		.policy = nl80211_policy,
+		.flags = GENL_ADMIN_PERM,
+	},
+	{
+		.cmd = NL80211_CMD_DEL_STATION,
+		.doit = nl80211_del_station,
+		.policy = nl80211_policy,
+		.flags = GENL_ADMIN_PERM,
+	},
 };
 
 /* multicast groups */

-- 

