Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51626 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753250Ab1EDNjr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 May 2011 09:39:47 -0400
Message-Id: <20110504133842.579493801@sipsolutions.net> (sfid-20110504_153951_187949_722BB6BD)
Date: Wed, 04 May 2011 15:37:28 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Eliad Peller <eliad@wizery.com>, linux-wireless@vger.kernel.org
Subject: [PATCH 1/2] nl80211/cfg80211: WoWLAN support
References: <20110504133727.971543681@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

This is based on (but now quite far from) the
original work from Luis and Eliad. Add support
for configuring WoWLAN triggers, and getting
the configuration out again. Changes from the
original patchset are too numerous to list,
but one important change needs highlighting:
the suspend() callback is passed NULL for the
trigger configuration if userspace has not
configured WoWLAN at all.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
Signed-off-by: Eliad Peller <eliad@wizery.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/linux/nl80211.h |   99 +++++++++++++++++++
 include/net/cfg80211.h  |   74 ++++++++++++++
 net/mac80211/cfg.c      |    3 
 net/wireless/core.c     |    8 +
 net/wireless/core.h     |   14 ++
 net/wireless/nl80211.c  |  243 ++++++++++++++++++++++++++++++++++++++++++++++++
 net/wireless/sysfs.c    |    2 
 7 files changed, 439 insertions(+), 4 deletions(-)

--- a/include/linux/nl80211.h	2011-04-29 11:34:55.000000000 +0200
+++ b/include/linux/nl80211.h	2011-05-04 15:23:44.000000000 +0200
@@ -420,6 +420,14 @@
  *      new station with the AUTHENTICATED flag unset and maybe change it later
  *      depending on the authentication result.
  *
+ * @NL80211_CMD_GET_WOWLAN: get Wake-on-Wireless-LAN (WoWLAN) settings.
+ * @NL80211_CMD_SET_WOWLAN: set Wake-on-Wireless-LAN (WoWLAN) settings.
+ *	Since wireless is more complex than wired ethernet, it supports
+ *	various triggers. These triggers can be configured through this
+ *	command with the %NL80211_ATTR_WOWLAN_TRIGGERS attribute. For
+ *	more background information, see
+ *	http://wireless.kernel.org/en/users/Documentation/WoWLAN.
+ *
  * @NL80211_CMD_MAX: highest used command number
  * @__NL80211_CMD_AFTER_LAST: internal use
  */
@@ -534,6 +542,9 @@ enum nl80211_commands {
 
 	NL80211_CMD_NEW_PEER_CANDIDATE,
 
+	NL80211_CMD_GET_WOWLAN,
+	NL80211_CMD_SET_WOWLAN,
+
 	/* add new commands above here */
 
 	/* used to define NL80211_CMD_MAX below */
@@ -903,6 +914,13 @@ enum nl80211_commands {
  *	allows auth frames in a mesh to be passed to userspace for processing via
  *	the @NL80211_MESH_SETUP_USERSPACE_AUTH flag.
  *
+ * @NL80211_ATTR_WOWLAN_SUPPORTED: indicates, as part of the wiphy capabilities,
+ *	the supported WoWLAN triggers
+ * @NL80211_ATTR_WOWLAN_TRIGGERS: used by %NL80211_CMD_SET_WOWLAN to
+ *	indicate which WoW triggers should be enabled. This is also
+ *	used by %NL80211_CMD_GET_WOWLAN to get the currently enabled WoWLAN
+ *	triggers.
+ *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
@@ -1092,6 +1110,9 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_SUPPORT_MESH_AUTH,
 
+	NL80211_ATTR_WOWLAN_TRIGGERS,
+	NL80211_ATTR_WOWLAN_TRIGGERS_SUPPORTED,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
@@ -2061,4 +2082,82 @@ enum nl80211_tx_power_setting {
 	NL80211_TX_POWER_FIXED,
 };
 
+/**
+ * enum nl80211_wowlan_packet_pattern_attr - WoWLAN packet pattern attribute
+ * @__NL80211_WOWLAN_PKTPAT_INVALID: invalid number for nested attribute
+ * @NL80211_WOWLAN_PKTPAT_PATTERN: the pattern, values where the mask has
+ *	a zero bit are ignored
+ * @NL80211_WOWLAN_PKTPAT_MASK: pattern mask, must be long enough to have
+ *	a bit for each byte in the pattern. The lowest-order bit corresponds
+ *	to the first byte of the pattern, but the bytes of the pattern are
+ *	in a little-endian-like format, i.e. the 9th byte of the pattern
+ *	corresponds to the lowest-order bit in the second byte of the mask.
+ *	For example: The match 00:xx:00:00:xx:00:00:00:00:xx:xx:xx (where
+ *	xx indicates "don't care") would be represented by a pattern of
+ *	twelve zero bytes, and a mask of "0xed,0x07".
+ *	Note that the pattern matching is done as though frames were not
+ *	802.11 frames but 802.3 frames, i.e. the frame is fully unpacked
+ *	first (including SNAP header unpacking) and then matched.
+ * @NUM_NL80211_WOWLAN_PKTPAT: number of attributes
+ * @MAX_NL80211_WOWLAN_PKTPAT: max attribute number
+ */
+enum nl80211_wowlan_packet_pattern_attr {
+	__NL80211_WOWLAN_PKTPAT_INVALID,
+	NL80211_WOWLAN_PKTPAT_MASK,
+	NL80211_WOWLAN_PKTPAT_PATTERN,
+
+	NUM_NL80211_WOWLAN_PKTPAT,
+	MAX_NL80211_WOWLAN_PKTPAT = NUM_NL80211_WOWLAN_PKTPAT - 1,
+};
+
+/**
+ * struct nl80211_wowlan_pattern_support - pattern support information
+ * @max_patterns: maximum number of patterns supported
+ * @min_pattern_len: minimum length of each pattern
+ * @max_pattern_len: maximum length of each pattern
+ *
+ * This struct is carried in %NL80211_WOWLAN_TRIG_PKT_PATTERN when
+ * that is part of %NL80211_ATTR_WOWLAN_TRIGGERS_SUPPORTED in the
+ * capability information given by the kernel to userspace.
+ */
+struct nl80211_wowlan_pattern_support {
+	__u32 max_patterns;
+	__u32 min_pattern_len;
+	__u32 max_pattern_len;
+} __attribute__((packed));
+
+/**
+ * enum nl80211_wowlan_triggers - WoWLAN trigger definitions
+ * @__NL80211_WOWLAN_TRIG_INVALID: invalid number for nested attributes
+ * @NL80211_WOWLAN_TRIG_ANY: wake up on any activity, do not really put
+ *	the chip into a special state -- works best with chips that have
+ *	support for low-power operation already (flag)
+ * @NL80211_WOWLAN_TRIG_DISCONNECT: wake up on disconnect, the way disconnect
+ *	is detected is implementation-specific (flag)
+ * @NL80211_WOWLAN_TRIG_MAGIC_PKT: wake up on magic packet (6x 0xff, followed
+ *	by 16 repetitions of MAC addr, anywhere in payload) (flag)
+ * @NL80211_WOWLAN_TRIG_PKT_PATTERN: wake up on the specified packet patterns
+ *	which are passed in an array of nested attributes, each nested attribute
+ *	defining a with attributes from &struct nl80211_wowlan_trig_pkt_pattern.
+ *	Each pattern defines a wakeup packet. The matching is done on the MSDU,
+ *	i.e. as though the packet was an 802.3 packet, so the pattern matching
+ *	is done after the packet is converted to the MSDU.
+ *
+ *	In %NL80211_ATTR_WOWLAN_TRIGGERS_SUPPORTED, it is a binary attribute
+ *	carrying a &struct nl80211_wowlan_pattern_support.
+ * @NUM_NL80211_WOWLAN_TRIG: number of wake on wireless triggers
+ * @MAX_NL80211_WOWLAN_TRIG: highest wowlan trigger attribute number
+ */
+enum nl80211_wowlan_triggers {
+	__NL80211_WOWLAN_TRIG_INVALID,
+	NL80211_WOWLAN_TRIG_ANY,
+	NL80211_WOWLAN_TRIG_DISCONNECT,
+	NL80211_WOWLAN_TRIG_MAGIC_PKT,
+	NL80211_WOWLAN_TRIG_PKT_PATTERN,
+
+	/* keep last */
+	NUM_NL80211_WOWLAN_TRIG,
+	MAX_NL80211_WOWLAN_TRIG = NUM_NL80211_WOWLAN_TRIG - 1
+};
+
 #endif /* __LINUX_NL80211_H */
--- a/include/net/cfg80211.h	2011-04-29 11:34:55.000000000 +0200
+++ b/include/net/cfg80211.h	2011-05-04 15:16:19.000000000 +0200
@@ -1088,6 +1088,38 @@ struct cfg80211_pmksa {
 };
 
 /**
+ * struct cfg80211_wowlan_trig_pkt_pattern - packet pattern
+ * @mask: bitmask where to match pattern and where to ignore bytes,
+ *	one bit per byte, in same format as nl80211
+ * @pattern: bytes to match where bitmask is 1
+ * @pattern_len: length of pattern (in bytes)
+ *
+ * Internal note: @mask and @pattern are allocated in one chunk of
+ * memory, free @mask only!
+ */
+struct cfg80211_wowlan_trig_pkt_pattern {
+	u8 *mask, *pattern;
+	int pattern_len;
+};
+
+/**
+ * struct cfg80211_wowlan - Wake on Wireless-LAN support info
+ *
+ * This structure defines the enabled WoWLAN triggers for the device.
+ * @any: wake up on any activity -- special trigger if device continues
+ *	operating as normal during suspend
+ * @disconnect: wake up if getting disconnected
+ * @magic_pkt: wake up on receiving magic packet
+ * @patterns: wake up on receiving packet matching a pattern
+ * @n_patterns: number of patterns
+ */
+struct cfg80211_wowlan {
+	bool any, disconnect, magic_pkt;
+	struct cfg80211_wowlan_trig_pkt_pattern *patterns;
+	int n_patterns;
+};
+
+/**
  * struct cfg80211_ops - backend description for wireless configuration
  *
  * This struct is registered by fullmac card drivers and/or wireless stacks
@@ -1100,7 +1132,9 @@ struct cfg80211_pmksa {
  * wireless extensions but this is subject to reevaluation as soon as this
  * code is used more widely and we have a first user without wext.
  *
- * @suspend: wiphy device needs to be suspended
+ * @suspend: wiphy device needs to be suspended. The variable @wow will
+ *	be %NULL or contain the enabled Wake-on-Wireless triggers that are
+ *	configured for the device.
  * @resume: wiphy device needs to be resumed
  *
  * @add_virtual_intf: create a new virtual interface with the given name,
@@ -1244,7 +1278,7 @@ struct cfg80211_pmksa {
  * @get_ringparam: Get tx and rx ring current and maximum sizes.
  */
 struct cfg80211_ops {
-	int	(*suspend)(struct wiphy *wiphy);
+	int	(*suspend)(struct wiphy *wiphy, struct cfg80211_wowlan *wow);
 	int	(*resume)(struct wiphy *wiphy);
 
 	struct net_device * (*add_virtual_intf)(struct wiphy *wiphy,
@@ -1483,6 +1517,38 @@ struct ieee80211_txrx_stypes {
 };
 
 /**
+ * enum wiphy_wowlan_support_flags - WoWLAN support flags
+ * @WIPHY_WOWLAN_ANY: supports wakeup for the special "any"
+ *	trigger that keeps the device operating as-is and
+ *	wakes up the host on any activity, for example a
+ *	received packet that passed filtering; note that the
+ *	packet should be preserved in that case
+ * @WIPHY_WOWLAN_MAGIC_PKT: supports wakeup on magic packet
+ *	(see nl80211.h)
+ * @WIPHY_WOWLAN_DISCONNECT: supports wakeup on disconnect
+ */
+enum wiphy_wowlan_support_flags {
+	WIPHY_WOWLAN_ANY	= BIT(0),
+	WIPHY_WOWLAN_MAGIC_PKT	= BIT(1),
+	WIPHY_WOWLAN_DISCONNECT	= BIT(2),
+};
+
+/**
+ * struct wiphy_wowlan_support - WoWLAN support data
+ * @flags: see &enum wiphy_wowlan_support_flags
+ * @n_patterns: number of supported wakeup patterns
+ *	(see nl80211.h for the pattern definition)
+ * @pattern_max_len: maximum length of each pattern
+ * @pattern_min_len: minimum length of each pattern
+ */
+struct wiphy_wowlan_support {
+	u32 flags;
+	int n_patterns;
+	int pattern_max_len;
+	int pattern_min_len;
+};
+
+/**
  * struct wiphy - wireless hardware description
  * @reg_notifier: the driver's regulatory notification callback,
  *	note that if your driver uses wiphy_apply_custom_regulatory()
@@ -1549,6 +1615,8 @@ struct ieee80211_txrx_stypes {
  *
  * @max_remain_on_channel_duration: Maximum time a remain-on-channel operation
  *	may request, if implemented.
+ *
+ * @wowlan: WoWLAN support information
  */
 struct wiphy {
 	/* assign these fields before you register the wiphy */
@@ -1586,6 +1654,8 @@ struct wiphy {
 	char fw_version[ETHTOOL_BUSINFO_LEN];
 	u32 hw_version;
 
+	struct wiphy_wowlan_support wowlan;
+
 	u16 max_remain_on_channel_duration;
 
 	u8 max_num_pmkids;
--- a/net/wireless/core.h	2011-04-26 13:52:34.000000000 +0200
+++ b/net/wireless/core.h	2011-05-04 15:16:19.000000000 +0200
@@ -70,6 +70,8 @@ struct cfg80211_registered_device {
 	struct work_struct conn_work;
 	struct work_struct event_work;
 
+	struct cfg80211_wowlan *wowlan;
+
 	/* must be last because of the way we do wiphy_priv(),
 	 * and it should at least be aligned to NETDEV_ALIGN */
 	struct wiphy wiphy __attribute__((__aligned__(NETDEV_ALIGN)));
@@ -89,6 +91,18 @@ bool wiphy_idx_valid(int wiphy_idx)
 	return wiphy_idx >= 0;
 }
 
+static inline void
+cfg80211_rdev_free_wowlan(struct cfg80211_registered_device *rdev)
+{
+	int i;
+
+	if (!rdev->wowlan)
+		return;
+	for (i = 0; i < rdev->wowlan->n_patterns; i++)
+		kfree(rdev->wowlan->patterns[i].mask);
+	kfree(rdev->wowlan->patterns);
+	kfree(rdev->wowlan);
+}
 
 extern struct workqueue_struct *cfg80211_wq;
 extern struct mutex cfg80211_mutex;
--- a/net/wireless/nl80211.c	2011-04-29 11:34:58.000000000 +0200
+++ b/net/wireless/nl80211.c	2011-05-04 15:16:19.000000000 +0200
@@ -173,6 +173,7 @@ static const struct nla_policy nl80211_p
 	[NL80211_ATTR_MCAST_RATE] = { .type = NLA_U32 },
 	[NL80211_ATTR_OFFCHANNEL_TX_OK] = { .type = NLA_FLAG },
 	[NL80211_ATTR_KEY_DEFAULT_TYPES] = { .type = NLA_NESTED },
+	[NL80211_ATTR_WOWLAN_TRIGGERS] = { .type = NLA_NESTED },
 };
 
 /* policy for the key attributes */
@@ -194,6 +195,15 @@ nl80211_key_default_policy[NUM_NL80211_K
 	[NL80211_KEY_DEFAULT_TYPE_MULTICAST] = { .type = NLA_FLAG },
 };
 
+/* policy for WoWLAN attributes */
+static const struct nla_policy
+nl80211_wowlan_policy[NUM_NL80211_WOWLAN_TRIG] = {
+	[NL80211_WOWLAN_TRIG_ANY] = { .type = NLA_FLAG },
+	[NL80211_WOWLAN_TRIG_DISCONNECT] = { .type = NLA_FLAG },
+	[NL80211_WOWLAN_TRIG_MAGIC_PKT] = { .type = NLA_FLAG },
+	[NL80211_WOWLAN_TRIG_PKT_PATTERN] = { .type = NLA_NESTED },
+};
+
 /* ifidx get helper */
 static int nl80211_get_ifidx(struct netlink_callback *cb)
 {
@@ -821,6 +831,35 @@ static int nl80211_send_wiphy(struct sk_
 		nla_nest_end(msg, nl_ifs);
 	}
 
+	if (dev->wiphy.wowlan.flags || dev->wiphy.wowlan.n_patterns) {
+		struct nlattr *nl_wowlan;
+
+		nl_wowlan = nla_nest_start(msg,
+				NL80211_ATTR_WOWLAN_TRIGGERS_SUPPORTED);
+		if (!nl_wowlan)
+			goto nla_put_failure;
+
+		if (dev->wiphy.wowlan.flags & WIPHY_WOWLAN_ANY)
+			NLA_PUT_FLAG(msg, NL80211_WOWLAN_TRIG_ANY);
+		if (dev->wiphy.wowlan.flags & WIPHY_WOWLAN_DISCONNECT)
+			NLA_PUT_FLAG(msg, NL80211_WOWLAN_TRIG_DISCONNECT);
+		if (dev->wiphy.wowlan.flags & WIPHY_WOWLAN_MAGIC_PKT)
+			NLA_PUT_FLAG(msg, NL80211_WOWLAN_TRIG_MAGIC_PKT);
+		if (dev->wiphy.wowlan.n_patterns) {
+			struct nl80211_wowlan_pattern_support pat = {
+				.max_patterns = dev->wiphy.wowlan.n_patterns,
+				.min_pattern_len =
+					dev->wiphy.wowlan.pattern_min_len,
+				.max_pattern_len =
+					dev->wiphy.wowlan.pattern_max_len,
+			};
+			NLA_PUT(msg, NL80211_WOWLAN_TRIG_PKT_PATTERN,
+				sizeof(pat), &pat);
+		}
+
+		nla_nest_end(msg, nl_wowlan);
+	}
+
 	return genlmsg_end(msg, hdr);
 
  nla_put_failure:
@@ -4816,6 +4855,194 @@ static int nl80211_leave_mesh(struct sk_
 	return cfg80211_leave_mesh(rdev, dev);
 }
 
+static int nl80211_get_wowlan(struct sk_buff *skb, struct genl_info *info)
+{
+	struct cfg80211_registered_device *rdev = info->user_ptr[0];
+	struct sk_buff *msg;
+	void *hdr;
+
+	if (!rdev->wiphy.wowlan.flags && !rdev->wiphy.wowlan.n_patterns)
+		return -EOPNOTSUPP;
+
+	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
+	if (!msg)
+		return -ENOMEM;
+
+	hdr = nl80211hdr_put(msg, info->snd_pid, info->snd_seq, 0,
+			     NL80211_CMD_GET_WOWLAN);
+	if (!hdr)
+		goto nla_put_failure;
+
+	if (rdev->wowlan) {
+		struct nlattr *nl_wowlan;
+
+		nl_wowlan = nla_nest_start(msg, NL80211_ATTR_WOWLAN_TRIGGERS);
+		if (!nl_wowlan)
+			goto nla_put_failure;
+
+		if (rdev->wowlan->any)
+			NLA_PUT_FLAG(msg, NL80211_WOWLAN_TRIG_ANY);
+		if (rdev->wowlan->disconnect)
+			NLA_PUT_FLAG(msg, NL80211_WOWLAN_TRIG_DISCONNECT);
+		if (rdev->wowlan->magic_pkt)
+			NLA_PUT_FLAG(msg, NL80211_WOWLAN_TRIG_MAGIC_PKT);
+		if (rdev->wowlan->n_patterns) {
+			struct nlattr *nl_pats, *nl_pat;
+			int i, pat_len;
+
+			nl_pats = nla_nest_start(msg,
+					NL80211_WOWLAN_TRIG_PKT_PATTERN);
+			if (!nl_pats)
+				goto nla_put_failure;
+
+			for (i = 0; i < rdev->wowlan->n_patterns; i++) {
+				nl_pat = nla_nest_start(msg, i + 1);
+				if (!nl_pat)
+					goto nla_put_failure;
+				pat_len = rdev->wowlan->patterns[i].pattern_len;
+				NLA_PUT(msg, NL80211_WOWLAN_PKTPAT_MASK,
+					DIV_ROUND_UP(pat_len, 8),
+					rdev->wowlan->patterns[i].mask);
+				NLA_PUT(msg, NL80211_WOWLAN_PKTPAT_PATTERN,
+					pat_len,
+					rdev->wowlan->patterns[i].pattern);
+				nla_nest_end(msg, nl_pat);
+			}
+			nla_nest_end(msg, nl_pats);
+		}
+
+		nla_nest_end(msg, nl_wowlan);
+	}
+
+	genlmsg_end(msg, hdr);
+	return genlmsg_reply(msg, info);
+
+nla_put_failure:
+	nlmsg_free(msg);
+	return -ENOBUFS;
+}
+
+static int nl80211_set_wowlan(struct sk_buff *skb, struct genl_info *info)
+{
+	struct cfg80211_registered_device *rdev = info->user_ptr[0];
+	struct nlattr *tb[NUM_NL80211_WOWLAN_TRIG];
+	struct cfg80211_wowlan no_triggers = {};
+	struct cfg80211_wowlan new_triggers = {};
+	struct wiphy_wowlan_support *wowlan = &rdev->wiphy.wowlan;
+	int err, i;
+
+	if (!rdev->wiphy.wowlan.flags && !rdev->wiphy.wowlan.n_patterns)
+		return -EOPNOTSUPP;
+
+	if (!info->attrs[NL80211_ATTR_WOWLAN_TRIGGERS])
+		goto no_triggers;
+
+	err = nla_parse(tb, MAX_NL80211_WOWLAN_TRIG,
+			nla_data(info->attrs[NL80211_ATTR_WOWLAN_TRIGGERS]),
+			nla_len(info->attrs[NL80211_ATTR_WOWLAN_TRIGGERS]),
+			nl80211_wowlan_policy);
+	if (err)
+		return err;
+
+	if (tb[NL80211_WOWLAN_TRIG_ANY]) {
+		if (!(wowlan->flags & WIPHY_WOWLAN_ANY))
+			return -EINVAL;
+		new_triggers.any = true;
+	}
+
+	if (tb[NL80211_WOWLAN_TRIG_DISCONNECT]) {
+		if (!(wowlan->flags & WIPHY_WOWLAN_DISCONNECT))
+			return -EINVAL;
+		new_triggers.disconnect = true;
+	}
+
+	if (tb[NL80211_WOWLAN_TRIG_MAGIC_PKT]) {
+		if (!(wowlan->flags & WIPHY_WOWLAN_MAGIC_PKT))
+			return -EINVAL;
+		new_triggers.magic_pkt = true;
+	}
+
+	if (tb[NL80211_WOWLAN_TRIG_PKT_PATTERN]) {
+		struct nlattr *pat;
+		int n_patterns = 0;
+		int rem, pat_len, mask_len;
+		struct nlattr *pat_tb[NUM_NL80211_WOWLAN_PKTPAT];
+
+		nla_for_each_nested(pat, tb[NL80211_WOWLAN_TRIG_PKT_PATTERN],
+				    rem)
+			n_patterns++;
+		if (n_patterns > wowlan->n_patterns)
+			return -EINVAL;
+
+		new_triggers.patterns = kcalloc(n_patterns,
+						sizeof(new_triggers.patterns[0]),
+						GFP_KERNEL);
+		if (!new_triggers.patterns)
+			return -ENOMEM;
+
+		new_triggers.n_patterns = n_patterns;
+		i = 0;
+
+		nla_for_each_nested(pat, tb[NL80211_WOWLAN_TRIG_PKT_PATTERN],
+				    rem) {
+			nla_parse(pat_tb, MAX_NL80211_WOWLAN_PKTPAT,
+				  nla_data(pat), nla_len(pat), NULL);
+			err = -EINVAL;
+			if (!pat_tb[NL80211_WOWLAN_PKTPAT_MASK] ||
+			    !pat_tb[NL80211_WOWLAN_PKTPAT_PATTERN])
+				goto error;
+			pat_len = nla_len(pat_tb[NL80211_WOWLAN_PKTPAT_PATTERN]);
+			mask_len = DIV_ROUND_UP(pat_len, 8);
+			if (nla_len(pat_tb[NL80211_WOWLAN_PKTPAT_MASK]) !=
+			    mask_len)
+				goto error;
+			if (pat_len > wowlan->pattern_max_len ||
+			    pat_len < wowlan->pattern_min_len)
+				goto error;
+
+			new_triggers.patterns[i].mask =
+				kmalloc(mask_len + pat_len, GFP_KERNEL);
+			if (!new_triggers.patterns[i].mask) {
+				err = -ENOMEM;
+				goto error;
+			}
+			new_triggers.patterns[i].pattern =
+				new_triggers.patterns[i].mask + mask_len;
+			memcpy(new_triggers.patterns[i].mask,
+			       nla_data(pat_tb[NL80211_WOWLAN_PKTPAT_MASK]),
+			       mask_len);
+			new_triggers.patterns[i].pattern_len = pat_len;
+			memcpy(new_triggers.patterns[i].pattern,
+			       nla_data(pat_tb[NL80211_WOWLAN_PKTPAT_PATTERN]),
+			       pat_len);
+			i++;
+		}
+	}
+
+	if (memcmp(&new_triggers, &no_triggers, sizeof(new_triggers))) {
+		struct cfg80211_wowlan *ntrig;
+		ntrig = kmemdup(&new_triggers, sizeof(new_triggers),
+				GFP_KERNEL);
+		if (!ntrig) {
+			err = -ENOMEM;
+			goto error;
+		}
+		cfg80211_rdev_free_wowlan(rdev);
+		rdev->wowlan = ntrig;
+	} else {
+ no_triggers:
+		cfg80211_rdev_free_wowlan(rdev);
+		rdev->wowlan = NULL;
+	}
+
+	return 0;
+ error:
+	for (i = 0; i < new_triggers.n_patterns; i++)
+		kfree(new_triggers.patterns[i].mask);
+	kfree(new_triggers.patterns);
+	return err;
+}
+
 #define NL80211_FLAG_NEED_WIPHY		0x01
 #define NL80211_FLAG_NEED_NETDEV	0x02
 #define NL80211_FLAG_NEED_RTNL		0x04
@@ -5314,6 +5541,22 @@ static struct genl_ops nl80211_ops[] = {
 		.internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
 				  NL80211_FLAG_NEED_RTNL,
 	},
+	{
+		.cmd = NL80211_CMD_GET_WOWLAN,
+		.doit = nl80211_get_wowlan,
+		.policy = nl80211_policy,
+		/* can be retrieved by unprivileged users */
+		.internal_flags = NL80211_FLAG_NEED_WIPHY |
+				  NL80211_FLAG_NEED_RTNL,
+	},
+	{
+		.cmd = NL80211_CMD_SET_WOWLAN,
+		.doit = nl80211_set_wowlan,
+		.policy = nl80211_policy,
+		.flags = GENL_ADMIN_PERM,
+		.internal_flags = NL80211_FLAG_NEED_WIPHY |
+				  NL80211_FLAG_NEED_RTNL,
+	},
 };
 
 static struct genl_multicast_group nl80211_mlme_mcgrp = {
--- a/net/wireless/sysfs.c	2011-04-26 13:52:34.000000000 +0200
+++ b/net/wireless/sysfs.c	2011-05-04 15:16:19.000000000 +0200
@@ -93,7 +93,7 @@ static int wiphy_suspend(struct device *
 
 	if (rdev->ops->suspend) {
 		rtnl_lock();
-		ret = rdev->ops->suspend(&rdev->wiphy);
+		ret = rdev->ops->suspend(&rdev->wiphy, rdev->wowlan);
 		rtnl_unlock();
 	}
 
--- a/net/wireless/core.c	2011-04-29 11:34:58.000000000 +0200
+++ b/net/wireless/core.c	2011-05-04 15:16:19.000000000 +0200
@@ -493,6 +493,13 @@ int wiphy_register(struct wiphy *wiphy)
 		return -EINVAL;
 	}
 
+	if (rdev->wiphy.wowlan.n_patterns) {
+		if (WARN_ON(!rdev->wiphy.wowlan.pattern_min_len ||
+			    rdev->wiphy.wowlan.pattern_min_len >
+			    rdev->wiphy.wowlan.pattern_max_len))
+			return -EINVAL;
+	}
+
 	/* check and set up bitrates */
 	ieee80211_set_bitrate_flags(wiphy);
 
@@ -631,6 +638,7 @@ void cfg80211_dev_free(struct cfg80211_r
 	mutex_destroy(&rdev->devlist_mtx);
 	list_for_each_entry_safe(scan, tmp, &rdev->bss_list, list)
 		cfg80211_put_bss(&scan->pub);
+	cfg80211_rdev_free_wowlan(rdev);
 	kfree(rdev);
 }
 
--- a/net/mac80211/cfg.c	2011-05-04 15:16:19.000000000 +0200
+++ b/net/mac80211/cfg.c	2011-05-04 15:22:39.000000000 +0200
@@ -1297,7 +1297,8 @@ static int ieee80211_set_channel(struct
 }
 
 #ifdef CONFIG_PM
-static int ieee80211_suspend(struct wiphy *wiphy)
+static int ieee80211_suspend(struct wiphy *wiphy,
+			     struct cfg80211_wowlan *wowlan)
 {
 	return __ieee80211_suspend(wiphy_priv(wiphy));
 }


