Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ruslug.rutgers.edu ([165.230.139.146]:58377 "EHLO
	ruslug.rutgers.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750712AbYFKEEK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jun 2008 00:04:10 -0400
Date: Wed, 11 Jun 2008 00:04:02 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [RFC] First CRDA integration work
Message-ID: <20080611040402.GE17936@ruslug.rutgers.edu> (sfid-20080611_060416_621995_1B270F70)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Release, review early. First work patch for integration of
CRDA work. Nukes old regulatory work, adds CRDA-like data structures
to cfg80211, adds a world regdom and uses it by default,
and start nl80211 definitions. The fun part, nl80211_get_reg()
and nl80211_set_reg() are pending. Hoping the second
shift <cough Johannes> can take over as I'm going to bed now.

At least it compiles, and should give an idea of where this is
going. This wasn't tested either :)

CRDA stuff can be checked out from:

git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/crda.git

For those who like diagrams:

http://wireless.kernel.org/crda.png

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 include/linux/nl80211.h |   88 +++++++++++++++++++++++++++-
 net/wireless/core.c     |   33 ++++++++++-
 net/wireless/core.h     |    1 +
 net/wireless/nl80211.c  |   33 ++++++++++
 net/wireless/reg.c      |  149 +++++++++++++++++------------------------------
 net/wireless/reg.h      |   56 ++++++++++++++++++
 6 files changed, 262 insertions(+), 98 deletions(-)
 create mode 100644 net/wireless/reg.h

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index ea6517e..aa55eb4 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -90,6 +90,20 @@
  *	or, if no MAC address given, all mesh paths, on the interface identified
  *	by %NL80211_ATTR_IFINDEX.
  *
+ * @NL80211_CMD_GET_REG: Get current regulatory domain, this is a query 
+ * 	to the kernel wireless core, the wireless core returns currently
+ * 	set alpha2 by %NL80211_ATTR_REG_ALPHA2,.
+ * @NL80211_CMD_SET_REG: Set current regulatory domain. CRDA sets this after
+ * 	being queried by the kernel. CRDA replies by sending a regulatory domain
+ * 	structure which consists of %NL80211_ATTR_REG_ALPHA set to our current alpha2
+ * 	if it found a match. It also provides %NL80211_ATTR_REG_NUM,
+ * 	%NL80211_ATTR_REG_PGP_SIGNATURE_CHECK, and a regulatory rule. The regulatory
+ * 	rule consists of set of frequency ranges given by
+ * 	%NL80211_ATTR_REG_RULE_FREQ_[START|END] with an attached power rule given
+ * 	by %NL80211_ATTR_REG_RULE_POWER_MAX_ANT_GAIN and
+ * 	%NL80211_ATTR_REG_RULE_POWER_MAX_EIRP. Each regulatory rule also has 
+ * 	an attached %NL80211_ATTR_REG_RULE_FLAGS.
+ *
  * @NL80211_CMD_MAX: highest used command number
  * @__NL80211_CMD_AFTER_LAST: internal use
  */
@@ -129,6 +143,9 @@ enum nl80211_commands {
 	NL80211_CMD_NEW_MPATH,
 	NL80211_CMD_DEL_MPATH,
 
+	NL80211_CMD_GET_REG,
+	NL80211_CMD_SET_REG,
+
 	/* used to define NL80211_CMD_MAX below */
 	__NL80211_CMD_AFTER_LAST,
 	NL80211_CMD_MAX = __NL80211_CMD_AFTER_LAST - 1
@@ -188,10 +205,40 @@ enum nl80211_commands {
  * 	info given for %NL80211_CMD_GET_MPATH, nested attribute described at
  *	&enum nl80211_mpath_info.
  *
- *
  * @NL80211_ATTR_MNTR_FLAGS: flags, nested element with NLA_FLAG attributes of
  *      &enum nl80211_mntr_flags.
  *
+ * @NL80211_ATTR_REG_ALPHA2: an ISO-3166-alpha2 country code for which the
+ * 	current regulatory domain should be set to or is already set to.
+ * 	For example, 'CR', for Costa Rica. This attribute is used by the kernel
+ * 	to query the CRDA userspace agent to retrieve one regulatory domain.
+ * 	This attribute can also be used by userspace to query the kernel for
+ * 	the currently set regulatory domain.
+ * @NL80211_ATTR_REG_NUM_RULES: number of regulatory rules passed
+ * @NL80211_ATTR_REG_PGP_SIGNATURE_CHECK: whether or not CRDA has blessed
+ * 	this information through a PGP signature check. If its not blessed
+ * 	we go ahead and regulatory-taint the kernel. This is obviously
+ * 	hackable but the purpose is to allow distributions to be able to use
+ * 	a CRDA with a regulatory database signed off by the community
+ * 	and get the communities' blessing on this. Vendors can also
+ * 	support their own custom databases for custom solutions (AP, military).
+ * 	Start to shift liablity to the user, where it should be.
+ * @NL80211_ATTR_REG_RULE_FLAGS: a set of flags which specify additional
+ * 	considerations for a given frequency range. These are the
+ * 	&enum nl80211_reg_rule_flags.
+ * @NL80211_ATTR_REG_RULE_FREQ_START: starting frequencry for the regulatory
+ * 	rule in KHz. This is not a center of frequency but an actual regulatory
+ * 	band edge.
+ * @NL80211_ATTR_REG_RULE_FREQ_END: ending frequency for the regulatory rule
+ * 	in KHz. This is not a center a frequency but an actual regulatory
+ * 	band edge.
+ * @NL80211_ATTR_REG_RULE_FREQ_MAX_BW: maximum allowed bandwidth for this
+ * 	frequency range, in KHz.
+ * @NL80211_ATTR_REG_RULE_POWER_MAX_ANT_GAIN: the maximum allowed antenna gain
+ * 	for a given frequency range. The value is in mBi (100 * dBi).
+ * @NL80211_ATTR_REG_RULE_POWER_MAX_EIRP: the maximum allowed EIRP for
+ * 	a given frequency range. The value is in mBm (100 * dBm).
+ *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
@@ -237,6 +284,16 @@ enum nl80211_attrs {
 	NL80211_ATTR_MPATH_NEXT_HOP,
 	NL80211_ATTR_MPATH_INFO,
 
+	NL80211_ATTR_REG_RULE_ALPHA2,
+	NL80211_ATTR_REG_RULE_NUM_RULES,
+	NL80211_ATTR_REG_PGP_SIGNATURE_CHECK,
+	NL80211_ATTR_REG_RULE_FREQ_START,
+	NL80211_ATTR_REG_RULE_FREQ_END,
+	NL80211_ATTR_REG_RULE_FREQ_MAX_BW,
+	NL80211_ATTR_REG_RULE_POWER_MAX_ANT_GAIN,
+	NL80211_ATTR_REG_RULE_POWER_MAX_EIRP,
+	NL80211_ATTR_REG_RULE_FLAGS,
+
 	__NL80211_ATTR_AFTER_LAST,
 	NL80211_ATTR_MAX = __NL80211_ATTR_AFTER_LAST - 1
 };
@@ -433,6 +490,35 @@ enum nl80211_bitrate_attr {
 };
 
 /**
+ * enum nl80211_reg_rule_flags - regulatory rule flags. These should match
+ * 	the latest regdb.h regulatory rule flags from CRDA.
+ *
+ * @NL80211_RRF_NO_OFDM: OFDM modulation not allowed
+ * @NL80211_RRF_NO_CCK: CCK modulation not allowed
+ * @NL80211_RRF_NO_INDOOR: indoor operation not allowed
+ * @NL80211_RRF_NO_OUTDOOR: outdoor operation not allowed
+ * @NL80211_RRF_DFS: DFS support is required to be used
+ * @NL80211_RRF_PTP_ONLY: this is only for Point To Point links
+ * @NL80211_RRF_PTMP_ONLY: this is only for Point To Multi Point links
+ * @NL80211_RRF_PASSIVE_SCAN: passive scan is required
+ * @NL80211_RRF_NO_IBSS: no IBSS is allowed
+ * @NL80211_RRF_NO_HT40: HT40 is not allowed
+ */
+enum nl80211_reg_rule_flags {
+	NL80211_RRF_NO_OFDM		= 1<<0,
+	NL80211_RRF_NO_CCK		= 1<<1,
+	NL80211_RRF_NO_INDOOR		= 1<<2,
+	NL80211_RRF_NO_OUTDOOR		= 1<<3,
+	NL80211_RRF_DFS			= 1<<4,
+	NL80211_RRF_PTP_ONLY		= 1<<4,
+	NL80211_RRF_PTMP_ONLY		= 1<<4,
+	NL80211_RRF_PASSIVE_SCAN	= 1<<4,
+	NL80211_RRF_NO_IBSS		= 1<<8,
+	/* hole at 9, used to be NO_HT20  */
+	NL80211_RRF_NO_HT40		= 1<<10,
+};
+
+/**
  * enum nl80211_mntr_flags - monitor configuration flags
  *
  * Monitor configuration flags.
diff --git a/net/wireless/core.c b/net/wireless/core.c
index f1da0b9..aeefc00 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -19,6 +19,7 @@
 #include "nl80211.h"
 #include "core.h"
 #include "sysfs.h"
+#include "reg.h"
 
 /* name for sysfs, %d is appended */
 #define PHY_NAME "phy"
@@ -27,6 +28,13 @@ MODULE_AUTHOR("Johannes Berg");
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("wireless configuration support");
 
+/* Central wireless core regulatory domains, we only need two,
+ * the current one and a world regulatory domain in case we have no
+ * information to give us an alpha2 */
+const struct ieee80211_regdomain *cfg80211_regdomain;
+const struct ieee80211_regdomain *cfg80211_world_regdom;
+DEFINE_MUTEX(cfg80211_reg_mutex);
+
 /* RCU might be appropriate here since we usually
  * only read the list, and that can happen quite
  * often because we need to do it for each command */
@@ -402,9 +410,30 @@ static struct notifier_block cfg80211_netdev_notifier = {
 	.notifier_call = cfg80211_netdev_notifier_call,
 };
 
+
 static int cfg80211_init(void)
 {
-	int err = wiphy_sysfs_init();
+#define	PASSIVE_AND_NO_IBSS	RRF_PASSIVE_SCAN | RRF_NO_IBSS
+	int err;
+	static const struct ieee80211_regdomain world_regdom = {
+		.n_reg_rules = 7, /* I hope we can count */
+		.pgp_signature_check = 1, /* Duh, we're already here */
+		.alpha2 =  { '0', '0' }, /* Got any better ideas? */
+		.reg_rules = {
+			REG_RULE(2402, 2472, 40, 0, 20,	RRF_PASSIVE_SCAN),
+			REG_RULE(2474, 2494, 40, 0, 20,	PASSIVE_AND_NO_IBSS),
+			REG_RULE(5160, 5240, 40, 0, 30,	PASSIVE_AND_NO_IBSS),
+			REG_RULE(5250, 5330, 40, 0, 30, PASSIVE_AND_NO_IBSS),
+			REG_RULE(5735, 5835, 40, 0, 30, PASSIVE_AND_NO_IBSS),
+			REG_RULE(5490, 5710, 40, 0, 30, PASSIVE_AND_NO_IBSS),
+			REG_RULE(5490, 5710, 40, 0, 30, PASSIVE_AND_NO_IBSS)
+		}
+	};
+
+	cfg80211_regdomain = NULL;
+	cfg80211_world_regdom = (struct ieee80211_regdomain *) &world_regdom;
+
+	err = wiphy_sysfs_init();
 	if (err)
 		goto out_fail_sysfs;
 
@@ -426,7 +455,9 @@ out_fail_notifier:
 	wiphy_sysfs_exit();
 out_fail_sysfs:
 	return err;
+#undef	PASSIVE_AND_NO_IBSS
 }
+
 subsys_initcall(cfg80211_init);
 
 static void cfg80211_exit(void)
diff --git a/net/wireless/core.h b/net/wireless/core.h
index 7a02c35..a1af113 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -11,6 +11,7 @@
 #include <net/genetlink.h>
 #include <net/wireless.h>
 #include <net/cfg80211.h>
+#include "reg.h"
 
 struct cfg80211_registered_device {
 	struct cfg80211_ops *ops;
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index fb75f26..9659412 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -18,6 +18,7 @@
 #include <net/cfg80211.h>
 #include "core.h"
 #include "nl80211.h"
+#include "reg.h"
 
 /* the netlink family */
 static struct genl_family nl80211_fam = {
@@ -87,6 +88,16 @@ static struct nla_policy nl80211_policy[NL80211_ATTR_MAX+1] __read_mostly = {
 	[NL80211_ATTR_MESH_ID] = { .type = NLA_BINARY,
 				.len = IEEE80211_MAX_MESH_ID_LEN },
 	[NL80211_ATTR_MPATH_NEXT_HOP] = { .type = NLA_U32 },
+
+	[NL80211_ATTR_REG_RULE_ALPHA2] = { .type = NLA_NUL_STRING, .len = 3 },
+	[NL80211_ATTR_REG_RULE_NUM_RULES] = { .type = NLA_U32 },
+	[NL80211_ATTR_REG_PGP_SIGNATURE_CHECK] = { .type = NLA_U8 },
+	[NL80211_ATTR_REG_RULE_FREQ_START] = { .type = NLA_U32 },
+	[NL80211_ATTR_REG_RULE_FREQ_END] = { .type = NLA_U32 },
+	[NL80211_ATTR_REG_RULE_FREQ_MAX_BW] = { .type = NLA_U32 },
+	[NL80211_ATTR_REG_RULE_POWER_MAX_ANT_GAIN] = { .type = NLA_U32 },
+	[NL80211_ATTR_REG_RULE_POWER_MAX_EIRP] = { .type = NLA_U32 },
+	[NL80211_ATTR_REG_RULE_FLAGS] = { .type = NLA_U32 },
 };
 
 /* message building helper */
@@ -1492,6 +1503,16 @@ static int nl80211_del_mpath(struct sk_buff *skb, struct genl_info *info)
 	return err;
 }
 
+static int nl80211_get_reg(struct sk_buff *skb, struct genl_info *info)
+{
+	return -EOPNOTSUPP;
+}
+
+static int nl80211_set_reg(struct sk_buff *skb, struct genl_info *info)
+{
+	return -EOPNOTSUPP;
+}
+
 static struct genl_ops nl80211_ops[] = {
 	{
 		.cmd = NL80211_CMD_GET_WIPHY,
@@ -1623,6 +1644,18 @@ static struct genl_ops nl80211_ops[] = {
 		.policy = nl80211_policy,
 		.flags = GENL_ADMIN_PERM,
 	},
+	{
+		.cmd = NL80211_CMD_GET_REG,
+		.doit = nl80211_get_reg,
+		.policy = nl80211_policy,
+		.flags = GENL_ADMIN_PERM,
+	},
+	{
+		.cmd = NL80211_CMD_SET_REG,
+		.doit = nl80211_set_reg,
+		.policy = nl80211_policy,
+		.flags = GENL_ADMIN_PERM,
+	},
 };
 
 /* multicast groups */
diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 185488d..13c9efc 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -2,6 +2,7 @@
  * Copyright 2002-2005, Instant802 Networks, Inc.
  * Copyright 2005-2006, Devicescape Software, Inc.
  * Copyright 2007	Johannes Berg <johannes@sipsolutions.net>
+ * Copyright 2008	Luis R. Rodriguez <lrodriguz@atheros.com>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -9,137 +10,93 @@
  */
 
 /*
- * This regulatory domain control implementation is highly incomplete, it
- * only exists for the purpose of not regressing mac80211.
- *
- * For now, drivers can restrict the set of allowed channels by either
- * not registering those channels or setting the IEEE80211_CHAN_DISABLED
- * flag; that flag will only be *set* by this code, never *cleared.
- *
  * The usual implementation is for a driver to read a device EEPROM to
  * determine which regulatory domain it should be operating under, then
  * looking up the allowable channels in a driver-local table and finally
  * registering those channels in the wiphy structure.
  *
- * Alternatively, drivers that trust the regulatory domain control here
- * will register a complete set of capabilities and the control code
- * will restrict the set by setting the IEEE80211_CHAN_* flags.
+ * Another set of compliance enforcement is for drivers to use their
+ * own compliance limits which can be stored on the EEPROM. The host
+ * driver or firmware may ensure these are used.
+ *
+ * In addition to all this we provide an extra layer of regulatory
+ * compliance, however, that of what is provided by CRDA. This tries
+ * to ensure we remain complaint by not letting the user up front try
+ * to set their wireless device to settings we know we shouldn't be
+ * setting to. We also disable channels on the driver which we know we
+ * shouldn't be using in current regulatory domain. This is because
+ * some drivers may have outdated EEPROMs or no regulatory control at all.
+ *
  */
 #include <linux/kernel.h>
 #include <net/wireless.h>
 #include "core.h"
 
-static char *ieee80211_regdom = "US";
-module_param(ieee80211_regdom, charp, 0444);
-MODULE_PARM_DESC(ieee80211_regdom, "IEEE 802.11 regulatory domain code");
-
-struct ieee80211_channel_range {
-	short start_freq;
-	short end_freq;
-	int max_power;
-	int max_antenna_gain;
-	u32 flags;
-};
-
-struct ieee80211_regdomain {
-	const char *code;
-	const struct ieee80211_channel_range *ranges;
-	int n_ranges;
-};
-
-#define RANGE_PWR(_start, _end, _pwr, _ag, _flags)	\
-	{ _start, _end, _pwr, _ag, _flags }
-
-
-/*
- * Ideally, in the future, these definitions will be loaded from a
- * userspace table via some daemon.
- */
-static const struct ieee80211_channel_range ieee80211_US_channels[] = {
-	/* IEEE 802.11b/g, channels 1..11 */
-	RANGE_PWR(2412, 2462, 27, 6, 0),
-	/* IEEE 802.11a, channel 36*/
-	RANGE_PWR(5180, 5180, 23, 6, 0),
-	/* IEEE 802.11a, channel 40*/
-	RANGE_PWR(5200, 5200, 23, 6, 0),
-	/* IEEE 802.11a, channel 44*/
-	RANGE_PWR(5220, 5220, 23, 6, 0),
-	/* IEEE 802.11a, channels 48..64 */
-	RANGE_PWR(5240, 5320, 23, 6, 0),
-	/* IEEE 802.11a, channels 149..165, outdoor */
-	RANGE_PWR(5745, 5825, 30, 6, 0),
-};
-
-static const struct ieee80211_channel_range ieee80211_JP_channels[] = {
-	/* IEEE 802.11b/g, channels 1..14 */
-	RANGE_PWR(2412, 2484, 20, 6, 0),
-	/* IEEE 802.11a, channels 34..48 */
-	RANGE_PWR(5170, 5240, 20, 6, IEEE80211_CHAN_PASSIVE_SCAN),
-	/* IEEE 802.11a, channels 52..64 */
-	RANGE_PWR(5260, 5320, 20, 6, IEEE80211_CHAN_NO_IBSS |
-				     IEEE80211_CHAN_RADAR),
-};
-
-#define REGDOM(_code)							\
-	{								\
-		.code = __stringify(_code),				\
-		.ranges = ieee80211_ ##_code## _channels,		\
-		.n_ranges = ARRAY_SIZE(ieee80211_ ##_code## _channels),	\
-	}
-
-static const struct ieee80211_regdomain ieee80211_regdoms[] = {
-	REGDOM(US),
-	REGDOM(JP),
-};
-
-
 static const struct ieee80211_regdomain *get_regdom(void)
 {
-	static const struct ieee80211_channel_range
-	ieee80211_world_channels[] = {
-		/* IEEE 802.11b/g, channels 1..11 */
-		RANGE_PWR(2412, 2462, 27, 6, 0),
-	};
-	static const struct ieee80211_regdomain regdom_world = REGDOM(world);
-	int i;
+	/* XXX: Query CRDA and if we don't get a response or if we don't get a
+	 * response for a specific alpha2 then use world_regdom */
 
-	for (i = 0; i < ARRAY_SIZE(ieee80211_regdoms); i++)
-		if (strcmp(ieee80211_regdom, ieee80211_regdoms[i].code) == 0)
-			return &ieee80211_regdoms[i];
+	/* use world_regdom for now to test this */
+	return cfg80211_world_regdom;
+}
 
-	return &regdom_world;
+static int freq_in_range(const struct ieee80211_freq_range *freq_range, u32 freq)
+{
+	if (freq >= freq_range->start_freq &&
+		freq <= freq_range->end_freq)
+		return 1;
+	return 0;
 }
 
+/* XXX: map the rest, add the rest  */
+static u32 map_regdom_flags(u32 rd_flags) {
+	u32 channel_flags = 0;
+	if (rd_flags & RRF_PASSIVE_SCAN)
+		channel_flags |= IEEE80211_CHAN_PASSIVE_SCAN;
+	if (rd_flags & RRF_NO_IBSS)
+		channel_flags |= IEEE80211_CHAN_NO_IBSS;
+	if (rd_flags & RRF_DFS)
+		channel_flags |= IEEE80211_CHAN_RADAR;
+	return channel_flags;
+}
 
 static void handle_channel(struct ieee80211_channel *chan,
 			   const struct ieee80211_regdomain *rd)
 {
 	int i;
 	u32 flags = chan->orig_flags;
-	const struct ieee80211_channel_range *rg = NULL;
-
-	for (i = 0; i < rd->n_ranges; i++) {
-		if (rd->ranges[i].start_freq <= chan->center_freq &&
-		    chan->center_freq <= rd->ranges[i].end_freq) {
-			rg = &rd->ranges[i];
+	const struct ieee80211_reg_rule *reg_rule = NULL;
+	const struct ieee80211_power_rule *power_rule = NULL;
+
+	for (i = 0; i < rd->n_reg_rules; i++) {
+		const struct ieee80211_reg_rule *rr;
+		const struct ieee80211_freq_range *fr = NULL;
+		const struct ieee80211_power_rule *pr = NULL;
+		rr = &rd->reg_rules[i];
+		fr = &rr->freq_range;
+		pr = &rr->power_rule;
+		if (freq_in_range(fr, chan->center_freq * 100)) {
+			reg_rule = rr;
+			power_rule = &rr->power_rule;
 			break;
 		}
 	}
 
-	if (!rg) {
+	if (!reg_rule) {
 		/* not found */
 		flags |= IEEE80211_CHAN_DISABLED;
 		chan->flags = flags;
 		return;
 	}
 
-	chan->flags = flags;
+	chan->flags = map_regdom_flags(reg_rule->flags);
 	chan->max_antenna_gain = min(chan->orig_mag,
-					 rg->max_antenna_gain);
+					 (int) power_rule->max_antenna_gain);
 	if (chan->orig_mpwr)
-		chan->max_power = min(chan->orig_mpwr, rg->max_power);
+		chan->max_power = min(chan->orig_mpwr, (int) power_rule->max_eirp);
 	else
-		chan->max_power = rg->max_power;
+		chan->max_power = power_rule->max_eirp;
 }
 
 static void handle_band(struct ieee80211_supported_band *sband,
diff --git a/net/wireless/reg.h b/net/wireless/reg.h
new file mode 100644
index 0000000..d1e7d6e
--- /dev/null
+++ b/net/wireless/reg.h
@@ -0,0 +1,56 @@
+#ifndef __NET_WIRELESS_REG_H
+#define __NET_WIRELESS_REG_H
+
+extern const struct ieee80211_regdomain *cfg80211_regdomain;
+extern const struct ieee80211_regdomain *cfg80211_world_regdom;
+
+struct ieee80211_freq_range {
+	u32 start_freq;
+	u32 end_freq;
+	u32 max_bandwidth;
+};
+
+struct ieee80211_power_rule {
+	u32 max_antenna_gain;
+	u32 max_eirp;
+};
+
+/* These must match CRDA regdb.h reg_rule_flags. nl80211
+ * must also be synced. */
+enum reg_rule_flags {
+	RRF_NO_OFDM             = 1<<0,
+	RRF_NO_CCK              = 1<<1,
+	RRF_NO_INDOOR           = 1<<2,
+	RRF_NO_OUTDOOR          = 1<<3,
+	RRF_DFS                 = 1<<4,
+	RRF_PTP_ONLY            = 1<<5,
+	RRF_PTMP_ONLY           = 1<<6,
+	RRF_PASSIVE_SCAN        = 1<<7,
+	RRF_NO_IBSS             = 1<<8,
+	/* hole at 9 */
+	RRF_NO_HT40             = 1<<10,
+};
+
+struct ieee80211_reg_rule {
+	struct ieee80211_freq_range freq_range;
+	struct ieee80211_power_rule power_rule;
+	u32 flags;
+};
+
+struct ieee80211_regdomain {
+	u32 n_reg_rules;
+	int pgp_signature_check;
+	char alpha2[2];
+	struct ieee80211_reg_rule reg_rules[];
+};
+
+#define REG_RULE(start, end, bw, gain, eirp, reg_flags) { \
+	.freq_range.start_freq = start * 100, \
+	.freq_range.end_freq = end * 100, \
+	.freq_range.max_bandwidth = bw, \
+	.power_rule.max_antenna_gain = gain, \
+	.power_rule.max_eirp = eirp, \
+	.flags = reg_flags, \
+	}
+
+#endif  /* __NET_WIRELESS_REG_H */
-- 
1.5.4.3

