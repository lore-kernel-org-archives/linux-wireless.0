Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:56797 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932303Ab1EMI7B (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 May 2011 04:59:01 -0400
Subject: [PATCH] cfg80211: advertise possible interface combinations
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 13 May 2011 10:58:57 +0200
Message-ID: <1305277137.3487.7.camel@jlt3.sipsolutions.net> (sfid-20110513_105908_152174_A8DD220B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Add the ability to advertise interface combinations in nl80211.
This allows the driver to indicate what the combinations are
that it supports. "Combinations" of just a single interface are
implicit, as previously. Note that cfg80211 will enforce that
the restrictions are met, but not for all drivers yet (once all
drivers are updated, we can remove the flag and enforce for all).

When no combinations are actually supported, an empty list will
be exported so that userspace can know if the kernel exported
this info or not (although it isn't clear to me what tools using
the info should do if the kernel didn't export it).

Since some interface types are purely virtual/software and don't
fit the restrictions, those are exposed in a new list of pure SW
types, not subject to restrictions. This mainly exists to handle
AP-VLAN and monitor interfaces in mac80211.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/linux/nl80211.h |  122 +++++++++++++++++++++++++++++++++++++++++++++++-
 include/net/cfg80211.h  |   88 ++++++++++++++++++++++++++++++++++
 net/mac80211/main.c     |   16 ++++--
 net/wireless/core.c     |   69 +++++++++++++++++++++++++++
 net/wireless/core.h     |   11 ++++
 net/wireless/nl80211.c  |  105 +++++++++++++++++++++++++++++++++++------
 net/wireless/util.c     |   80 +++++++++++++++++++++++++++++++
 7 files changed, 472 insertions(+), 19 deletions(-)

--- a/include/linux/nl80211.h	2011-05-13 10:31:13.000000000 +0200
+++ b/include/linux/nl80211.h	2011-05-13 10:56:04.000000000 +0200
@@ -77,6 +77,39 @@
  */
 
 /**
+ * DOC: Virtual interface / concurrency capabilities
+ *
+ * Some devices are able to operate with virtual MACs, they can have
+ * more than one virtual interface. The capability handling for this
+ * is a bit complex though, as there may be a number of restrictions
+ * on the types of concurrency that are supported.
+ *
+ * To start with, each device supports the interface types listed in
+ * the %NL80211_ATTR_SUPPORTED_IFTYPES attribute, but by listing the
+ * types there no concurrency is implied.
+ *
+ * Once concurrency is desired, more attributes must be observed:
+ * To start with, since some interface types are purely managed in
+ * software, like the AP-VLAN type in mac80211 for example, there's
+ * an additional list of these, they can be added at any time and
+ * are only restricted by some semantic restrictions (e.g. AP-VLAN
+ * cannot be added without a corresponding AP interface). This list
+ * is exported in the %NL80211_ATTR_SOFTWARE_IFTYPES attribute.
+ *
+ * Further, the list of supported combinations is exported. This is
+ * in the %NL80211_ATTR_INTERFACE_COMBINATIONS attribute. Basically,
+ * it exports a list of "groups", and at any point in time the
+ * interfaces that are currently active must fall into any one of
+ * the advertised groups. Within each group, there are restrictions
+ * on the number of interfaces of different types that are supported
+ * and also the number of different channels, along with potentially
+ * some other restrictions. See &enum nl80211_if_combination_attrs.
+ *
+ * All together, these attributes define the concurrency of virtual
+ * interfaces that a given device supports.
+ */
+
+/**
  * enum nl80211_commands - supported nl80211 commands
  *
  * @NL80211_CMD_UNSPEC: unspecified command to catch errors
@@ -954,6 +987,14 @@ enum nl80211_commands {
  * @NL80211_ATTR_SCHED_SCAN_INTERVAL: Interval between scheduled scan
  *	cycles, in msecs.
  *
+ * @NL80211_ATTR_INTERFACE_COMBINATIONS: Nested attribute listing the supported
+ *	interface combinations. In each nested item, it contains attributes
+ *	defined in &enum nl80211_if_combination_attrs.
+ * @NL80211_ATTR_SOFTWARE_IFTYPES: Nested attribute (just like
+ *	%NL80211_ATTR_SUPPORTED_IFTYPES) containing the interface types that
+ *	are managed in software: interfaces of these types aren't subject to
+ *	any restrictions in their number or combinations.
+ *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
@@ -1149,6 +1190,9 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_SCHED_SCAN_INTERVAL,
 
+	NL80211_ATTR_INTERFACE_COMBINATIONS,
+	NL80211_ATTR_SOFTWARE_IFTYPES,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
@@ -1201,7 +1245,9 @@ enum nl80211_attrs {
  * @NL80211_IFTYPE_ADHOC: independent BSS member
  * @NL80211_IFTYPE_STATION: managed BSS member
  * @NL80211_IFTYPE_AP: access point
- * @NL80211_IFTYPE_AP_VLAN: VLAN interface for access points
+ * @NL80211_IFTYPE_AP_VLAN: VLAN interface for access points; VLAN interfaces
+ *	are a bit special in that they must always be tied to a pre-existing
+ *	AP type interface.
  * @NL80211_IFTYPE_WDS: wireless distribution interface
  * @NL80211_IFTYPE_MONITOR: monitor interface receiving all frames
  * @NL80211_IFTYPE_MESH_POINT: mesh point
@@ -2206,4 +2252,78 @@ enum nl80211_wowlan_triggers {
 	MAX_NL80211_WOWLAN_TRIG = NUM_NL80211_WOWLAN_TRIG - 1
 };
 
+/**
+ * enum nl80211_iface_limit_attrs - limit attributes
+ * @NL80211_IFACE_LIMIT_UNSPEC: (reserved)
+ * @NL80211_IFACE_LIMIT_MAX: maximum number of interfaces that
+ *	can be chosen from this set of interface types (u32)
+ * @NL80211_IFACE_LIMIT_TYPES: nested attribute containing a
+ *	flag attribute for each interface type in this set
+ * @NUM_NL80211_IFACE_LIMIT: number of attributes
+ * @MAX_NL80211_IFACE_LIMIT: highest attribute number
+ */
+enum nl80211_iface_limit_attrs {
+	NL80211_IFACE_LIMIT_UNSPEC,
+	NL80211_IFACE_LIMIT_MAX,
+	NL80211_IFACE_LIMIT_TYPES,
+
+	/* keep last */
+	NUM_NL80211_IFACE_LIMIT,
+	MAX_NL80211_IFACE_LIMIT = NUM_NL80211_IFACE_LIMIT - 1
+};
+
+/**
+ * enum nl80211_if_combination_attrs -- interface combination attributes
+ *
+ * @NL80211_IFACE_COMB_UNSPEC: (reserved)
+ * @NL80211_IFACE_COMB_LIMITS: Nested attributes containing the limits
+ *	for given interface types, see &enum nl80211_iface_limit_attrs.
+ * @NL80211_IFACE_COMB_MAXNUM: u32 attribute giving the total number of
+ *	interfaces that can be created in this group. This number doesn't
+ *	apply to interfaces purely managed in software, which are listed
+ *	in a separate attribute %NL80211_ATTR_INTERFACES_SOFTWARE.
+ * @NL80211_IFACE_COMB_STA_AP_BI_MATCH: flag attribute specifying that
+ *	beacon intervals within this group must be all the same even for
+ *	infrastructure and AP/GO combinations, i.e. the GO(s) must adopt
+ *	the infrastructure network's beacon interval.
+ * @NL80211_IFACE_COMB_NUM_CHANNELS: u32 attribute specifying how many
+ *	different channels may be used within this group.
+ * @NUM_NL80211_IFACE_COMB: number of attributes
+ * @MAX_NL80211_IFACE_COMB: highest attribute number
+ *
+ * Examples:
+ *	limits = [ #{STA} <= 1, #{AP} <= 1 ], matching BI, channels = 1, max = 2
+ *	=> allows an AP and a STA that must match BIs
+ *
+ *	numbers = [ #{AP, P2P-GO} <= 8 ], channels = 1, max = 8
+ *	=> allows 8 of AP/GO
+ *
+ *	numbers = [ #{STA} <= 2 ], channels = 2, max = 2
+ *	=> allows two STAs on different channels
+ *
+ *	numbers = [ #{STA} <= 1, #{P2P-client,P2P-GO} <= 3 ], max = 4
+ *	=> allows a STA plus three P2P interfaces
+ *
+ * The list of these four possiblities could completely be contained
+ * within the %NL80211_ATTR_INTERFACE_COMBINATIONS attribute to indicate
+ * that any of these groups must match.
+ *
+ * "Combinations" of just a single interface will not be listed here,
+ * a single interface of any valid interface type is assumed to always
+ * be possible by itself. This means that implicitly, for each valid
+ * interface type, the following group always exists:
+ *	numbers = [ #{<type>} <= 1 ], channels = 1, max = 1
+ */
+enum nl80211_if_combination_attrs {
+	NL80211_IFACE_COMB_UNSPEC,
+	NL80211_IFACE_COMB_LIMITS,
+	NL80211_IFACE_COMB_MAXNUM,
+	NL80211_IFACE_COMB_STA_AP_BI_MATCH,
+	NL80211_IFACE_COMB_NUM_CHANNELS,
+
+	/* keep last */
+	NUM_NL80211_IFACE_COMB,
+	MAX_NL80211_IFACE_COMB = NUM_NL80211_IFACE_COMB - 1
+};
+
 #endif /* __LINUX_NL80211_H */
--- a/include/net/cfg80211.h	2011-05-13 10:31:13.000000000 +0200
+++ b/include/net/cfg80211.h	2011-05-13 10:38:05.000000000 +0200
@@ -1547,6 +1547,10 @@ struct cfg80211_ops {
  *	hints read the documenation for regulatory_hint_found_beacon()
  * @WIPHY_FLAG_NETNS_OK: if not set, do not allow changing the netns of this
  *	wiphy at all
+ * @WIPHY_FLAG_ENFORCE_COMBINATIONS: Set this flag to enforce interface
+ *	combinations for this device. This flag is used for backward
+ *	compatibility only until all drivers advertise combinations and
+ *	they will always be enforced.
  * @WIPHY_FLAG_PS_ON_BY_DEFAULT: if set to true, powersave will be enabled
  *	by default -- this flag will be set depending on the kernel's default
  *	on wiphy_new(), but can be changed by the driver if it has a good
@@ -1574,6 +1578,81 @@ enum wiphy_flags {
 	WIPHY_FLAG_IBSS_RSN			= BIT(8),
 	WIPHY_FLAG_MESH_AUTH			= BIT(10),
 	WIPHY_FLAG_SUPPORTS_SCHED_SCAN		= BIT(11),
+	WIPHY_FLAG_ENFORCE_COMBINATIONS		= BIT(12),
+};
+
+/**
+ * struct ieee80211_iface_limit - limit on certain interface types
+ * @max: maximum number of interfaces of these types
+ * @types: interface types (bits)
+ */
+struct ieee80211_iface_limit {
+	u16 max;
+	u16 types;
+};
+
+/**
+ * struct ieee80211_iface_combination - possible interface combination
+ * @limits: limits for the given interface types
+ * @n_limits: number of limitations
+ * @num_different_channels: can use up to this many different channels
+ * @max_interfaces: maximum number of interfaces in total allowed in this
+ *	group
+ * @beacon_int_infra_match: In this combination, the beacon intervals
+ *	between infrastructure and AP types must match. This is required
+ *	only in special cases.
+ *
+ * These examples can be expressed as follows:
+ *
+ * Allow #STA <= 1, #AP <= 1, matching BI, channels = 1, 2 total:
+ *
+ *  struct ieee80211_iface_limit limits1[] = {
+ *	{ .max = 1, .types = BIT(NL80211_IFTYPE_STATION), },
+ *	{ .max = 1, .types = BIT(NL80211_IFTYPE_AP}, },
+ *  };
+ *  struct ieee80211_iface_combination combination1 = {
+ *	.limits = limits1,
+ *	.n_limits = ARRAY_SIZE(limits1),
+ *	.max_interfaces = 2,
+ *	.beacon_int_infra_match = true,
+ *  };
+ *
+ *
+ * Allow #{AP, P2P-GO} <= 8, channels = 1, 8 total:
+ *
+ *  struct ieee80211_iface_limit limits2[] = {
+ *	{ .max = 8, .types = BIT(NL80211_IFTYPE_AP) |
+ *			     BIT(NL80211_IFTYPE_P2P_GO), },
+ *  };
+ *  struct ieee80211_iface_combination combination2 = {
+ *	.limits = limits2,
+ *	.n_limits = ARRAY_SIZE(limits2),
+ *	.max_interfaces = 8,
+ *	.num_different_channels = 1,
+ *  };
+ *
+ *
+ * Allow #STA <= 1, #{P2P-client,P2P-GO} <= 3 on two channels, 4 total.
+ * This allows for an infrastructure connection and three P2P connections.
+ *
+ *  struct ieee80211_iface_limit limits3[] = {
+ *	{ .max = 1, .types = BIT(NL80211_IFTYPE_STATION), },
+ *	{ .max = 3, .types = BIT(NL80211_IFTYPE_P2P_GO) |
+ *			     BIT(NL80211_IFTYPE_P2P_CLIENT), },
+ *  };
+ *  struct ieee80211_iface_combination combination3 = {
+ *	.limits = limits3,
+ *	.n_limits = ARRAY_SIZE(limits3),
+ *	.max_interfaces = 4,
+ *	.num_different_channels = 2,
+ *  };
+ */
+struct ieee80211_iface_combination {
+	const struct ieee80211_iface_limit *limits;
+	u32 num_different_channels;
+	u16 max_interfaces;
+	u8 n_limits;
+	bool beacon_int_infra_match;
 };
 
 struct mac_address {
@@ -1653,6 +1732,11 @@ struct wiphy_wowlan_support {
  * @priv: driver private data (sized according to wiphy_new() parameter)
  * @interface_modes: bitmask of interfaces types valid for this wiphy,
  *	must be set by driver
+ * @iface_combinations: Valid interface combinations array, should not
+ *	list single interface types.
+ * @n_iface_combinations: number of entries in @iface_combinations array.
+ * @software_iftypes: bitmask of software interface types, these are not
+ *	subject to any restrictions since they are purely managed in SW.
  * @flags: wiphy flags, see &enum wiphy_flags
  * @bss_priv_size: each BSS struct has private data allocated with it,
  *	this variable determines its size
@@ -1697,6 +1781,10 @@ struct wiphy {
 
 	const struct ieee80211_txrx_stypes *mgmt_stypes;
 
+	const struct ieee80211_iface_combination *iface_combinations;
+	int n_iface_combinations;
+	u16 software_iftypes;
+
 	u16 n_addresses;
 
 	/* Supported interface modes, OR together BIT(NL80211_IFTYPE_...) */
--- a/net/wireless/nl80211.c	2011-05-13 10:31:13.000000000 +0200
+++ b/net/wireless/nl80211.c	2011-05-13 10:38:05.000000000 +0200
@@ -564,6 +564,88 @@ static int nl80211_key_allowed(struct wi
 	return 0;
 }
 
+static int nl80211_put_iftypes(struct sk_buff *msg, u32 attr, u16 ifmodes)
+{
+	struct nlattr *nl_modes = nla_nest_start(msg, attr);
+	int i;
+
+	if (!nl_modes)
+		goto nla_put_failure;
+
+	i = 0;
+	while (ifmodes) {
+		if (ifmodes & 1)
+			NLA_PUT_FLAG(msg, i);
+		ifmodes >>= 1;
+		i++;
+	}
+
+	nla_nest_end(msg, nl_modes);
+	return 0;
+
+nla_put_failure:
+	return -ENOBUFS;
+}
+
+static int nl80211_put_iface_combinations(struct wiphy *wiphy,
+					  struct sk_buff *msg)
+{
+	struct nlattr *nl_combis;
+	int i, j;
+
+	nl_combis = nla_nest_start(msg,
+				NL80211_ATTR_INTERFACE_COMBINATIONS);
+	if (!nl_combis)
+		goto nla_put_failure;
+
+	for (i = 0; i < wiphy->n_iface_combinations; i++) {
+		const struct ieee80211_iface_combination *c;
+		struct nlattr *nl_combi, *nl_limits;
+
+		c = &wiphy->iface_combinations[i];
+
+		nl_combi = nla_nest_start(msg, i + 1);
+		if (!nl_combi)
+			goto nla_put_failure;
+
+		nl_limits = nla_nest_start(msg, NL80211_IFACE_COMB_LIMITS);
+		if (!nl_limits)
+			goto nla_put_failure;
+
+		for (j = 0; j < c->n_limits; j++) {
+			struct nlattr *nl_limit;
+
+			nl_limit = nla_nest_start(msg, j + 1);
+			if (!nl_limit)
+				goto nla_put_failure;
+			NLA_PUT_U32(msg, NL80211_IFACE_LIMIT_MAX,
+				    c->limits[j].max);
+			if (nl80211_put_iftypes(msg, NL80211_IFACE_LIMIT_TYPES,
+						c->limits[j].types))
+				goto nla_put_failure;
+			nla_nest_end(msg, nl_limit);
+		}
+
+		nla_nest_end(msg, nl_limits);
+
+		if (c->beacon_int_infra_match)
+			NLA_PUT_FLAG(msg,
+				NL80211_IFACE_COMB_STA_AP_BI_MATCH);
+		NLA_PUT_U32(msg, NL80211_IFACE_COMB_NUM_CHANNELS,
+			    c->num_different_channels);
+		NLA_PUT_U32(msg, NL80211_IFACE_COMB_MAXNUM,
+			    c->max_interfaces);
+
+		nla_nest_end(msg, nl_combi);
+	}
+
+	nla_nest_end(msg, nl_combis);
+
+	return 0;
+nla_put_failure:
+	return -ENOBUFS;
+}
+
 static int nl80211_send_wiphy(struct sk_buff *msg, u32 pid, u32 seq, int flags,
 			      struct cfg80211_registered_device *dev)
 {
@@ -571,13 +653,11 @@ static int nl80211_send_wiphy(struct sk_
 	struct nlattr *nl_bands, *nl_band;
 	struct nlattr *nl_freqs, *nl_freq;
 	struct nlattr *nl_rates, *nl_rate;
-	struct nlattr *nl_modes;
 	struct nlattr *nl_cmds;
 	enum ieee80211_band band;
 	struct ieee80211_channel *chan;
 	struct ieee80211_rate *rate;
 	int i;
-	u16 ifmodes = dev->wiphy.interface_modes;
 	const struct ieee80211_txrx_stypes *mgmt_stypes =
 				dev->wiphy.mgmt_stypes;
 
@@ -637,20 +717,10 @@ static int nl80211_send_wiphy(struct sk_
 		}
 	}
 
-	nl_modes = nla_nest_start(msg, NL80211_ATTR_SUPPORTED_IFTYPES);
-	if (!nl_modes)
+	if (nl80211_put_iftypes(msg, NL80211_ATTR_SUPPORTED_IFTYPES,
+				dev->wiphy.interface_modes))
 		goto nla_put_failure;
 
-	i = 0;
-	while (ifmodes) {
-		if (ifmodes & 1)
-			NLA_PUT_FLAG(msg, i);
-		ifmodes >>= 1;
-		i++;
-	}
-
-	nla_nest_end(msg, nl_modes);
-
 	nl_bands = nla_nest_start(msg, NL80211_ATTR_WIPHY_BANDS);
 	if (!nl_bands)
 		goto nla_put_failure;
@@ -865,6 +935,13 @@ static int nl80211_send_wiphy(struct sk_
 		nla_nest_end(msg, nl_wowlan);
 	}
 
+	if (nl80211_put_iftypes(msg, NL80211_ATTR_SOFTWARE_IFTYPES,
+				dev->wiphy.software_iftypes))
+		goto nla_put_failure;
+
+	if (nl80211_put_iface_combinations(&dev->wiphy, msg))
+		goto nla_put_failure;
+
 	return genlmsg_end(msg, hdr);
 
  nla_put_failure:
--- a/net/wireless/core.c	2011-05-13 10:31:13.000000000 +0200
+++ b/net/wireless/core.c	2011-05-13 10:38:05.000000000 +0200
@@ -416,6 +416,67 @@ struct wiphy *wiphy_new(const struct cfg
 }
 EXPORT_SYMBOL(wiphy_new);
 
+static int wiphy_verify_combinations(struct wiphy *wiphy)
+{
+	const struct ieee80211_iface_combination *c;
+	int i, j;
+
+	/* If we have combinations enforce them */
+	if (wiphy->n_iface_combinations)
+		wiphy->flags |= WIPHY_FLAG_ENFORCE_COMBINATIONS;
+
+	for (i = 0; i < wiphy->n_iface_combinations; i++) {
+		u32 cnt = 0;
+		u16 all_iftypes = 0;
+
+		c = &wiphy->iface_combinations[i];
+
+		/* Combinations with just one interface aren't real */
+		if (WARN_ON(c->max_interfaces < 2))
+			return -EINVAL;
+
+		/* Need at least one channel */
+		if (WARN_ON(!c->num_different_channels))
+			return -EINVAL;
+
+		if (WARN_ON(!c->n_limits))
+			return -EINVAL;
+
+		for (j = 0; j < c->n_limits; j++) {
+			u16 types = c->limits[j].types;
+
+			/*
+			 * interface types shouldn't overlap, this is
+			 * used in cfg80211_can_change_interface()
+			 */
+			if (WARN_ON(types & all_iftypes))
+				return -EINVAL;
+			all_iftypes |= types;
+
+			if (WARN_ON(!c->limits[j].max))
+				return -EINVAL;
+
+			/* Shouldn't list software iftypes in combinations! */
+			if (WARN_ON(wiphy->software_iftypes & types))
+				return -EINVAL;
+
+			cnt += c->limits[j].max;
+			/*
+			 * Don't advertise an unsupported type
+			 * in a combination.
+			 */
+			if (WARN_ON((wiphy->interface_modes & types) != types))
+				return -EINVAL;
+		}
+
+		/* You can't even choose that many! */
+		if (WARN_ON(cnt < c->max_interfaces))
+			return -EINVAL;
+	}
+
+	return 0;
+}
+
 int wiphy_register(struct wiphy *wiphy)
 {
 	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
@@ -444,6 +505,10 @@ int wiphy_register(struct wiphy *wiphy)
 	if (WARN_ON(ifmodes != wiphy->interface_modes))
 		wiphy->interface_modes = ifmodes;
 
+	res = wiphy_verify_combinations(wiphy);
+	if (res)
+		return res;
+
 	/* sanity check supported bands/channels */
 	for (band = 0; band < IEEE80211_NUM_BANDS; band++) {
 		sband = wiphy->bands[band];
@@ -698,6 +763,7 @@ static int cfg80211_netdev_notifier_call
 	struct net_device *dev = ndev;
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	struct cfg80211_registered_device *rdev;
+	int ret;
 
 	if (!wdev)
 		return NOTIFY_DONE;
@@ -893,6 +959,9 @@ static int cfg80211_netdev_notifier_call
 			return notifier_from_errno(-EOPNOTSUPP);
 		if (rfkill_blocked(rdev->rfkill))
 			return notifier_from_errno(-ERFKILL);
+		ret = cfg80211_can_add_interface(rdev, wdev->iftype);
+		if (ret)
+			return notifier_from_errno(ret);
 		break;
 	}
 
--- a/net/mac80211/main.c	2011-05-13 10:31:13.000000000 +0200
+++ b/net/mac80211/main.c	2011-05-13 10:38:29.000000000 +0200
@@ -685,7 +685,7 @@ EXPORT_SYMBOL(ieee80211_alloc_hw);
 int ieee80211_register_hw(struct ieee80211_hw *hw)
 {
 	struct ieee80211_local *local = hw_to_local(hw);
-	int result;
+	int result, i;
 	enum ieee80211_band band;
 	int channels, max_bitrates;
 	bool supp_ht;
@@ -743,11 +743,19 @@ int ieee80211_register_hw(struct ieee802
 		return -ENOMEM;
 
 	/* if low-level driver supports AP, we also support VLAN */
-	if (local->hw.wiphy->interface_modes & BIT(NL80211_IFTYPE_AP))
-		local->hw.wiphy->interface_modes |= BIT(NL80211_IFTYPE_AP_VLAN);
+	if (local->hw.wiphy->interface_modes & BIT(NL80211_IFTYPE_AP)) {
+		hw->wiphy->interface_modes |= BIT(NL80211_IFTYPE_AP_VLAN);
+		hw->wiphy->software_iftypes |= BIT(NL80211_IFTYPE_AP_VLAN);
+	}
 
 	/* mac80211 always supports monitor */
-	local->hw.wiphy->interface_modes |= BIT(NL80211_IFTYPE_MONITOR);
+	hw->wiphy->interface_modes |= BIT(NL80211_IFTYPE_MONITOR);
+	hw->wiphy->software_iftypes |= BIT(NL80211_IFTYPE_MONITOR);
+
+	/* mac80211 doesn't support more than 1 channel */
+	for (i = 0; i < hw->wiphy->n_iface_combinations; i++)
+		if (hw->wiphy->iface_combinations[i].num_different_channels > 1)
+			return -EINVAL;
 
 #ifndef CONFIG_MAC80211_MESH
 	/* mesh depends on Kconfig, but drivers should set it if they want */
--- a/net/wireless/core.h	2011-05-13 10:31:13.000000000 +0200
+++ b/net/wireless/core.h	2011-05-13 10:38:05.000000000 +0200
@@ -422,6 +422,17 @@ int cfg80211_change_iface(struct cfg8021
 			  u32 *flags, struct vif_params *params);
 void cfg80211_process_rdev_events(struct cfg80211_registered_device *rdev);
 
+int cfg80211_can_change_interface(struct cfg80211_registered_device *rdev,
+				  struct wireless_dev *wdev,
+				  enum nl80211_iftype iftype);
+
+static inline int
+cfg80211_can_add_interface(struct cfg80211_registered_device *rdev,
+			   enum nl80211_iftype iftype)
+{
+	return cfg80211_can_change_interface(rdev, NULL, iftype);
+}
+
 struct ieee80211_channel *
 rdev_freq_to_chan(struct cfg80211_registered_device *rdev,
 		  int freq, enum nl80211_channel_type channel_type);
--- a/net/wireless/util.c	2011-05-13 10:31:13.000000000 +0200
+++ b/net/wireless/util.c	2011-05-13 10:38:05.000000000 +0200
@@ -803,6 +803,11 @@ int cfg80211_change_iface(struct cfg8021
 		return -EBUSY;
 
 	if (ntype != otype) {
+		err = cfg80211_can_change_interface(rdev, dev->ieee80211_ptr,
+						    ntype);
+		if (err)
+			return err;
+
 		dev->ieee80211_ptr->use_4addr = false;
 		dev->ieee80211_ptr->mesh_id_up_len = 0;
 
@@ -921,3 +926,78 @@ int cfg80211_validate_beacon_int(struct
 
 	return res;
 }
+
+int cfg80211_can_change_interface(struct cfg80211_registered_device *rdev,
+				  struct wireless_dev *wdev,
+				  enum nl80211_iftype iftype)
+{
+	struct wireless_dev *wdev_iter;
+	int num[NUM_NL80211_IFTYPES];
+	int total = 1;
+	int i, j;
+
+	ASSERT_RTNL();
+
+	/* Always allow software iftypes */
+	if (rdev->wiphy.software_iftypes & BIT(iftype))
+		return 0;
+
+	/*
+	 * Drivers will gradually all set this flag, until all
+	 * have it we only enforce for those that set it.
+	 */
+	if (!(rdev->wiphy.flags & WIPHY_FLAG_ENFORCE_COMBINATIONS))
+		return 0;
+
+	memset(num, 0, sizeof(num));
+
+	num[iftype] = 1;
+
+	mutex_lock(&rdev->devlist_mtx);
+	list_for_each_entry(wdev_iter, &rdev->netdev_list, list) {
+		if (wdev_iter == wdev)
+			continue;
+		if (!netif_running(wdev_iter->netdev))
+			continue;
+
+		if (rdev->wiphy.software_iftypes & BIT(wdev_iter->iftype))
+			continue;
+
+		num[wdev_iter->iftype]++;
+		total++;
+	}
+	mutex_unlock(&rdev->devlist_mtx);
+
+	for (i = 0; i < rdev->wiphy.n_iface_combinations; i++) {
+		const struct ieee80211_iface_combination *c;
+		struct ieee80211_iface_limit *limits;
+
+		c = &rdev->wiphy.iface_combinations[i];
+
+		limits = kmemdup(c->limits, sizeof(limits[0]) * c->n_limits,
+				 GFP_KERNEL);
+		if (!limits)
+			return -ENOMEM;
+		if (total > c->max_interfaces)
+			goto cont;
+
+		for (iftype = 0; iftype < NUM_NL80211_IFTYPES; iftype++) {
+			if (rdev->wiphy.software_iftypes & BIT(iftype))
+				continue;
+			for (j = 0; j < c->n_limits; j++) {
+				if (!(limits[j].types & iftype))
+					continue;
+				if (limits[j].max < num[iftype])
+					goto cont;
+				limits[j].max -= num[iftype];
+			}
+		}
+		/* yay, it fits */
+		kfree(limits);
+		return 0;
+ cont:
+		kfree(limits);
+	}
+
+	return -EBUSY;
+}


