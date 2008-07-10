Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ruslug.rutgers.edu ([165.230.139.146]:47348 "EHLO
	ruslug.rutgers.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755330AbYGJPYT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Jul 2008 11:24:19 -0400
Date: Thu, 10 Jul 2008 11:24:15 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>,
	Tomas Winkler <tomas.winkler@intel.com>,
	"Rindjunsky, Ron" <ron.rindjunsky@intel.com>,
	Tim Gardner <tim.gardner@canonical.com>,
	Jouni Malinen <j@w1.fi>
Subject: [RFC] Add new regulatory framework for Linux wireless
Message-ID: <20080710152415.GK17936@ruslug.rutgers.edu> (sfid-20080710_172424_268269_0EE29B05)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This adds a new regulatory framework for the wireless subsystem (cfg80211).
This relies on the new Central Regulaotry Domain Agent:

http://wireless.kernel.org/en/developers/Regulatory/CRDA
git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/crda.git

CRDA and its integration allows us to keep the wireless regulatory
database completely in userspace. This lets us update it without
making kernel upgrades.

For drivers wishing to verify the regulatory data a callback
chain has been provided, regulatory_chain. Driver can use this
to update further enhance their regulatory compliance if required.

For drivers which can determine what country they were designed for
and wishing to support that regulatory domain first (before
considering Country IEs from APs) they can hint it to the wireless
using regulatory_hint().

Country IE parsing is not yet added by can be added and with this
framework can be used to enhance trust for regulatory data from APs.
The industry currently has different techniques for parsing and using
Country IEs. What I currently propose is to take the common denominator
between what the AP provides, what CRDA has and what the driver can
provide privately through its callback. So the wireless core can keep
as the common denominator between the AP's Country IE and what CRDA
has for the alpha2 provided by the Country IE. Drivers themselves can
further enhance regulatory enforcement by relying on private driver
data if they wish so.

For drivers with no regulatory information this work and CRDA will
provide the full regulatory solution.

Finally I'd like to invite you to review our current regulatory
database and help contribute on expanding it. You can send patches
using git or just send us an e-mail verbally explaining the changes
required. You can also view the database through our web front end:

http://wireless.kernel.org/en/developers/Regulatory/Database

This has been work which has been going for over 2 years now. Hopefully
we got it right now and it will attract more vendors to support Linux
wireless drivers.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 include/linux/nl80211.h |  104 ++++++++++-
 include/net/cfg80211.h  |   48 +++++
 include/net/wireless.h  |    2 +
 net/wireless/core.c     |   57 +++++-
 net/wireless/nl80211.c  |  138 +++++++++++++
 net/wireless/reg.c      |  512 +++++++++++++++++++++++++++++++++++++----------
 net/wireless/reg.h      |   31 +++
 7 files changed, 786 insertions(+), 106 deletions(-)
 create mode 100644 net/wireless/reg.h

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index 2be7c63..e8e5614 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -90,6 +90,19 @@
  *	or, if no MAC address given, all mesh paths, on the interface identified
  *	by %NL80211_ATTR_IFINDEX.
  *
+ * @NL80211_CMD_SET_REG: Set current regulatory domain. CRDA sends this command
+ *	after being queried by the kernel. CRDA replies by sending a regulatory
+ *	domain structure which consists of %NL80211_ATTR_REG_ALPHA set to our
+ *	current alpha2 if it found a match. It also provides %NL80211_ATTR_REG_NUM,
+ * 	NL80211_ATTR_REG_RULE_FLAGS, and a set of regulatory rules. Each
+ * 	regulatory rule is a nested set of attributes  given by
+ * 	%NL80211_ATTR_REG_RULE_FREQ_[START|END] and
+ * 	%NL80211_ATTR_FREQ_RANGE_MAX_BW with an attached power rule given by
+ * 	%NL80211_ATTR_REG_RULE_POWER_MAX_ANT_GAIN and
+ * 	%NL80211_ATTR_REG_RULE_POWER_MAX_EIRP. We provide CRDA with a receipt,
+ * 	%NL80211_ATTR_REG_UUID, which CRDA sends us back to ensure the request
+ * 	command is valid and came from us.
+ *
  * @NL80211_CMD_MAX: highest used command number
  * @__NL80211_CMD_AFTER_LAST: internal use
  */
@@ -129,6 +142,8 @@ enum nl80211_commands {
 
 	/* add commands here */
 
+	NL80211_CMD_SET_REG,
+
 	/* used to define NL80211_CMD_MAX below */
 	__NL80211_CMD_AFTER_LAST,
 	NL80211_CMD_MAX = __NL80211_CMD_AFTER_LAST - 1
@@ -188,10 +203,27 @@ enum nl80211_commands {
  * 	info given for %NL80211_CMD_GET_MPATH, nested attribute described at
  *	&enum nl80211_mpath_info.
  *
- *
  * @NL80211_ATTR_MNTR_FLAGS: flags, nested element with NLA_FLAG attributes of
  *      &enum nl80211_mntr_flags.
  *
+ * @NL80211_ATTR_REG_UUID: the random UUID we provided CRDA as a receipt,
+ *	we check our pending request list to see if this matches an expected
+ *	request we made, otherwise we ignore it.
+ * @NL80211_ATTR_REG_ALPHA2: an ISO-3166-alpha2 country code for which the
+ * 	current regulatory domain should be set to or is already set to.
+ * 	For example, 'CR', for Costa Rica. This attribute is used by the kernel
+ * 	to query the CRDA to retrieve one regulatory domain. This attribute can
+ * 	also be used by userspace to query the kernel for the currently set
+ * 	regulatory domain. We chose an alpha2 as that is also used by the
+ * 	IEEE-802.11d country information element to identify a country.
+ * @NL80211_ATTR_NUM_REG_RULES: the number of regulatory rules nested in
+ * 	%NL80211_ATTR_REG_RULES, we pass this to not abuse the stack
+ * 	and to gracefully use only one memory area in nl80211_set_reg().
+ * 	This value shall never exceed NL80211_MAX_SUPP_REG_RULES. We can
+ * 	increase this value as regulatory rules becomes more complex.
+ * @NL80211_ATTR_REG_RULES: a nested array of regulatory domain regulatory
+ *	rules.
+ *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
@@ -235,6 +267,11 @@ enum nl80211_attrs {
 	NL80211_ATTR_MPATH_NEXT_HOP,
 	NL80211_ATTR_MPATH_INFO,
 
+	NL80211_ATTR_REG_UUID,
+	NL80211_ATTR_REG_ALPHA2,
+	NL80211_ATTR_NUM_REG_RULES,
+	NL80211_ATTR_REG_RULES,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
@@ -242,6 +279,7 @@ enum nl80211_attrs {
 };
 
 #define NL80211_MAX_SUPP_RATES			32
+#define NL80211_MAX_SUPP_REG_RULES		32
 #define NL80211_TKIP_DATA_OFFSET_ENCR_KEY	0
 #define NL80211_TKIP_DATA_OFFSET_TX_MIC_KEY	16
 #define NL80211_TKIP_DATA_OFFSET_RX_MIC_KEY	24
@@ -436,6 +474,70 @@ enum nl80211_bitrate_attr {
 };
 
 /**
+ * enum nl80211_reg_rule_attr - regulatory rule attributes
+ * @NL80211_ATTR_REG_RULE_FLAGS: a set of flags which specify additional
+ * 	considerations for a given frequency range. These are the
+ * 	&enum nl80211_reg_rule_flags.
+ * @NL80211_ATTR_FREQ_RANGE_START: starting frequencry for the regulatory
+ * 	rule in KHz. This is not a center of frequency but an actual regulatory
+ * 	band edge.
+ * @NL80211_ATTR_FREQ_RANGE_END: ending frequency for the regulatory rule
+ * 	in KHz. This is not a center a frequency but an actual regulatory
+ * 	band edge.
+ * @NL80211_ATTR_FREQ_RANGE_MAX_BW: maximum allowed bandwidth for this
+ * 	frequency range, in KHz.
+ * @NL80211_ATTR_POWER_RULE_MAX_ANT_GAIN: the maximum allowed antenna gain
+ * 	for a given frequency range. The value is in mBi (100 * dBi).
+ * 	If you set this to 0 it means there is no available known limit.
+ * @NL80211_ATTR_POWER_RULE_MAX_EIRP: the maximum allowed EIRP for
+ * 	a given frequency range. The value is in mBm (100 * dBm).
+ */
+enum nl80211_reg_rule_attr {
+	__NL80211_REG_RULE_ATTR_INVALID,
+	NL80211_ATTR_REG_RULE_FLAGS,
+
+	NL80211_ATTR_FREQ_RANGE_START,
+	NL80211_ATTR_FREQ_RANGE_END,
+	NL80211_ATTR_FREQ_RANGE_MAX_BW,
+
+	NL80211_ATTR_POWER_RULE_MAX_ANT_GAIN,
+	NL80211_ATTR_POWER_RULE_MAX_EIRP,
+
+	/* keep last */
+	__NL80211_REG_RULE_ATTR_AFTER_LAST,
+	NL80211_REG_RULE_ATTR_MAX = __NL80211_REG_RULE_ATTR_AFTER_LAST - 1
+};
+
+/**
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
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index e007508..77eeb41 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -268,6 +268,54 @@ struct mpath_info {
 	u8 flags;
 };
 
+/**
+ * enum reg_set_by - Indicates who is trying to set the regulatory domain
+ * @REGDOM_SET_BY_INIT: regultory domain was set by initialization. We will be
+ * 	using a static world regulatory domain by default.
+ * @REGDOM_SET_BY_CORE: Core queried CRDA for a dynamic world regulatory domain.
+ * @REGDOM_SET_BY_DRIVER: a wireless drivers has hinted to the wireless core
+ *	it thinks its knows the regulatory domain we should be in.
+ * @REGDOM_SET_BY_80211D: the wireless core has received an 802.11 country
+ *	information element with regulotory information it thinks we
+ *	should consider.
+ */
+enum reg_set_by {
+	REGDOM_SET_BY_INIT,
+	REGDOM_SET_BY_CORE,
+	REGDOM_SET_BY_DRIVER,
+	REGDOM_SET_BY_80211D,
+};
+
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
+struct ieee80211_reg_rule {
+	struct ieee80211_freq_range freq_range;
+	struct ieee80211_power_rule power_rule;
+	u32 flags;
+};
+
+struct ieee80211_regdomain {
+	u32 n_reg_rules;
+	char alpha2[2];
+	struct ieee80211_reg_rule *reg_rules;
+};
+
+#define MHZ_TO_KHZ(freq) freq * 100
+#define KHZ_TO_MHZ(freq) freq / 100
+#define DBI_TO_MBI(gain) gain * 100
+#define MBI_TO_DBI(gain) gain / 100
+#define DBM_TO_MBM(gain) gain * 100
+#define MBM_TO_DBM(gain) gain / 100
 
 /* from net/wireless.h */
 struct wiphy;
diff --git a/include/net/wireless.h b/include/net/wireless.h
index 9324f8d..19dad2d 100644
--- a/include/net/wireless.h
+++ b/include/net/wireless.h
@@ -60,6 +60,7 @@ enum ieee80211_channel_flags {
  * with cfg80211.
  *
  * @center_freq: center frequency in MHz
+ * @max_bandwidth: maximum allowed bandwidth for this channel, in MHz
  * @hw_value: hardware-specific value for the channel
  * @flags: channel flags from &enum ieee80211_channel_flags.
  * @orig_flags: channel flags at registration time, used by regulatory
@@ -73,6 +74,7 @@ enum ieee80211_channel_flags {
 struct ieee80211_channel {
 	enum ieee80211_band band;
 	u16 center_freq;
+	u8 max_bandwidth;
 	u16 hw_value;
 	u32 flags;
 	int max_antenna_gain;
diff --git a/net/wireless/core.c b/net/wireless/core.c
index f1da0b9..c70462a 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -19,6 +19,7 @@
 #include "nl80211.h"
 #include "core.h"
 #include "sysfs.h"
+#include "reg.h"
 
 /* name for sysfs, %d is appended */
 #define PHY_NAME "phy"
@@ -27,6 +28,35 @@ MODULE_AUTHOR("Johannes Berg");
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("wireless configuration support");
 
+struct list_head regulatory_requests;
+
+/* Central wireless core regulatory domains, we only need two,
+ * the current one and a world regulatory domain in case we have no
+ * information to give us an alpha2 */
+struct ieee80211_regdomain *cfg80211_regdomain;
+
+/* CRDA can provide a dynamic world regulatory domain, we keep
+ * this static one updated as often as we can in case of the absense
+ * of CRDA */
+struct ieee80211_reg_rule world_reg_rules[] = {
+		REG_RULE(2402, 2472, 40, 6, 20,
+			NL80211_RRF_PASSIVE_SCAN |
+			NL80211_RRF_NO_IBSS |
+			NL80211_RRF_NO_HT40),
+};
+
+const struct ieee80211_regdomain world_regdom = {
+	.n_reg_rules = ARRAY_SIZE(world_reg_rules),
+	.alpha2 =  "00",
+	.reg_rules = (struct ieee80211_reg_rule *) &world_reg_rules,
+};
+
+struct ieee80211_regdomain *cfg80211_world_regdom =
+	(struct ieee80211_regdomain *) &world_regdom;
+
+LIST_HEAD(regulatory_requests);
+DEFINE_MUTEX(cfg80211_reg_mutex);
+
 /* RCU might be appropriate here since we usually
  * only read the list, and that can happen quite
  * often because we need to do it for each command */
@@ -295,7 +325,9 @@ int wiphy_register(struct wiphy *wiphy)
 	ieee80211_set_bitrate_flags(wiphy);
 
 	/* set up regulatory info */
+	mutex_lock(&cfg80211_reg_mutex);
 	wiphy_update_regulatory(wiphy);
+	mutex_unlock(&cfg80211_reg_mutex);
 
 	mutex_lock(&cfg80211_drv_mutex);
 
@@ -402,9 +434,14 @@ static struct notifier_block cfg80211_netdev_notifier = {
 	.notifier_call = cfg80211_netdev_notifier_call,
 };
 
+
 static int cfg80211_init(void)
 {
-	int err = wiphy_sysfs_init();
+	int err;
+
+	cfg80211_regdomain = (struct ieee80211_regdomain *) cfg80211_world_regdom;
+
+	err = wiphy_sysfs_init();
 	if (err)
 		goto out_fail_sysfs;
 
@@ -418,6 +455,11 @@ static int cfg80211_init(void)
 
 	ieee80211_debugfs_dir = debugfs_create_dir("ieee80211", NULL);
 
+	err = __regulatory_hint("00", REGDOM_SET_BY_CORE, NULL);
+	if (err)
+		printk("cfg80211: calling CRDA failed - unable to update "
+			"world regulatory domain, using static definition\n");
+
 	return 0;
 
 out_fail_nl80211:
@@ -427,12 +469,25 @@ out_fail_notifier:
 out_fail_sysfs:
 	return err;
 }
+
 subsys_initcall(cfg80211_init);
 
 static void cfg80211_exit(void)
 {
 	debugfs_remove(ieee80211_debugfs_dir);
 	nl80211_exit();
+	if (cfg80211_world_regdom != &world_regdom) {
+		if (cfg80211_world_regdom == cfg80211_regdomain) {
+			kfree(cfg80211_regdomain->reg_rules);
+			kfree(cfg80211_regdomain);
+		}
+		else {
+			kfree(cfg80211_world_regdom->reg_rules);
+			kfree(cfg80211_world_regdom);
+			kfree(cfg80211_regdomain->reg_rules);
+			kfree(cfg80211_regdomain);
+		}
+	}
 	unregister_netdevice_notifier(&cfg80211_netdev_notifier);
 	wiphy_sysfs_exit();
 }
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index b7fefff..b3ff515 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -18,6 +18,7 @@
 #include <net/cfg80211.h>
 #include "core.h"
 #include "nl80211.h"
+#include "reg.h"
 
 /* the netlink family */
 static struct genl_family nl80211_fam = {
@@ -87,6 +88,11 @@ static struct nla_policy nl80211_policy[NL80211_ATTR_MAX+1] __read_mostly = {
 	[NL80211_ATTR_MESH_ID] = { .type = NLA_BINARY,
 				.len = IEEE80211_MAX_MESH_ID_LEN },
 	[NL80211_ATTR_MPATH_NEXT_HOP] = { .type = NLA_U32 },
+
+	[NL80211_ATTR_REG_UUID] = { .type = NLA_BINARY, .len = 16 },
+	[NL80211_ATTR_REG_ALPHA2] = { .type = NLA_STRING, .len = 2 },
+	[NL80211_ATTR_NUM_REG_RULES] = { .type = NLA_U32 },
+	[NL80211_ATTR_REG_RULES] = { .type = NLA_NESTED },
 };
 
 /* message building helper */
@@ -1494,6 +1500,132 @@ static int nl80211_del_mpath(struct sk_buff *skb, struct genl_info *info)
 	return err;
 }
 
+static const struct nla_policy
+	reg_rule_policy[NL80211_REG_RULE_ATTR_MAX + 1] = {
+	[NL80211_ATTR_REG_RULE_FLAGS]		= { .type = NLA_U32 },
+	[NL80211_ATTR_FREQ_RANGE_START]		= { .type = NLA_U32 },
+	[NL80211_ATTR_FREQ_RANGE_END]		= { .type = NLA_U32 },
+	[NL80211_ATTR_FREQ_RANGE_MAX_BW]	= { .type = NLA_U32 },
+	[NL80211_ATTR_POWER_RULE_MAX_ANT_GAIN]	= { .type = NLA_U32 },
+	[NL80211_ATTR_POWER_RULE_MAX_EIRP]	= { .type = NLA_U32 },
+};
+
+static int parse_reg_rule(struct nlattr *tb[], struct ieee80211_reg_rule *reg_rule)
+{
+	struct ieee80211_freq_range *freq_range = &reg_rule->freq_range;
+	struct ieee80211_power_rule *power_rule = &reg_rule->power_rule;
+
+	if (!tb[NL80211_ATTR_REG_RULE_FLAGS])
+		return -EINVAL;
+	if (!tb[NL80211_ATTR_FREQ_RANGE_START])
+		return -EINVAL;
+	if (!tb[NL80211_ATTR_FREQ_RANGE_END])
+		return -EINVAL;
+	if (!tb[NL80211_ATTR_FREQ_RANGE_MAX_BW])
+		return -EINVAL;
+	if (!tb[NL80211_ATTR_POWER_RULE_MAX_ANT_GAIN])
+		return -EINVAL;
+	if (!tb[NL80211_ATTR_POWER_RULE_MAX_EIRP])
+		return -EINVAL;
+
+	reg_rule->flags = nla_get_u32(tb[NL80211_ATTR_REG_RULE_FLAGS]);
+
+	freq_range->start_freq	=
+		nla_get_u32(tb[NL80211_ATTR_FREQ_RANGE_START]);
+	freq_range->end_freq =
+		nla_get_u32(tb[NL80211_ATTR_FREQ_RANGE_END]);
+	freq_range->max_bandwidth =
+		nla_get_u32(tb[NL80211_ATTR_FREQ_RANGE_MAX_BW]);
+
+	power_rule->max_antenna_gain =
+		nla_get_u32(tb[NL80211_ATTR_POWER_RULE_MAX_ANT_GAIN]);
+	power_rule->max_eirp =
+		nla_get_u32(tb[NL80211_ATTR_POWER_RULE_MAX_EIRP]);
+
+	return 0;
+}
+
+static int nl80211_set_reg(struct sk_buff *skb, struct genl_info *info)
+{
+	struct nlattr *tb[NL80211_REG_RULE_ATTR_MAX + 1];
+	struct nlattr *nl_reg_rule;
+	unsigned char *uuid = NULL, *alpha2 = NULL;
+	int rem_reg_rules, r = 0;
+	u32 num_rules = 0, rule_idx = 0;
+	struct ieee80211_regdomain *rd;
+	struct ieee80211_reg_rule *reg_rules;
+
+	if (!info->attrs[NL80211_ATTR_REG_UUID])
+		return -EINVAL;
+
+	if (!info->attrs[NL80211_ATTR_REG_ALPHA2])
+		return -EINVAL;
+
+	if (!info->attrs[NL80211_ATTR_NUM_REG_RULES])
+		return -EINVAL;
+
+	if (!info->attrs[NL80211_ATTR_REG_RULES])
+		return -EINVAL;
+
+	uuid		= nla_data(info->attrs[NL80211_ATTR_REG_UUID]);
+	alpha2		= nla_data(info->attrs[NL80211_ATTR_REG_ALPHA2]);
+	num_rules	= nla_get_u32(info->attrs[NL80211_ATTR_NUM_REG_RULES]);
+
+	if (WARN_ON(num_rules > NL80211_MAX_SUPP_REG_RULES)) {
+		printk("nl80211: number of regulatory rules passed"
+				"exceeds our current limit: %d\n",
+				NL80211_MAX_SUPP_REG_RULES);
+		return -EINVAL;
+	}
+
+	if (!reg_is_valid_uuid(uuid))
+		return -EINVAL;
+
+	rd = kzalloc(sizeof(struct ieee80211_regdomain), GFP_KERNEL);
+	if (!rd)
+		return -ENOMEM;
+
+	reg_rules = kzalloc(sizeof(struct ieee80211_reg_rule) * num_rules,
+		GFP_KERNEL);
+	if (!reg_rules) {
+		kfree(rd);
+		return -ENOMEM;
+	}
+
+	rd->reg_rules = reg_rules;
+	rd->alpha2[0] = alpha2[0];
+	rd->alpha2[1] = alpha2[1];
+
+	nla_for_each_nested(nl_reg_rule, info->attrs[NL80211_ATTR_REG_RULES],
+			rem_reg_rules) {
+		nla_parse(tb, NL80211_REG_RULE_ATTR_MAX,
+			nla_data(nl_reg_rule), nla_len(nl_reg_rule),
+			reg_rule_policy);
+		r = parse_reg_rule(tb, &rd->reg_rules[rule_idx]);
+		if (r)
+			goto bad_reg;
+
+		rule_idx++;
+
+		if (rule_idx > NL80211_MAX_SUPP_REG_RULES)
+			goto bad_reg;
+	}
+
+	r = set_regdom(rd, uuid);
+	if (r) {
+		printk("nl80211: unable to set regulatory domain\n");
+		goto bad_reg;
+	}
+
+	return r;
+
+bad_reg:
+	kfree(rd);
+	kfree(reg_rules);
+	printk("nl80211: incorectly formatted regulatory domain\n");
+	return -EINVAL;
+}
+
 static struct genl_ops nl80211_ops[] = {
 	{
 		.cmd = NL80211_CMD_GET_WIPHY,
@@ -1625,6 +1757,12 @@ static struct genl_ops nl80211_ops[] = {
 		.policy = nl80211_policy,
 		.flags = GENL_ADMIN_PERM,
 	},
+	{
+		.cmd = NL80211_CMD_SET_REG,
+		.doit = nl80211_set_reg,
+		.policy = nl80211_policy,
+		.flags = GENL_ADMIN_PERM,
+	},
 };
 
 /* multicast groups */
diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 855bff4..a44b2b1 100644
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
@@ -9,155 +10,312 @@
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
+ * For some drivers which do not have any regulatory information CRDA
+ * provides the complete regulatory solution.
+ *
+ * Note: When number of rules --> infinity we will not be able to
+ * index on alpha2 any more, instead we'll probably have to
+ * rely on some SHA1 checksum of the regdomain for example.
+ *
  */
 #include <linux/kernel.h>
+#include <linux/list.h>
+#include <linux/random.h>
+#include <linux/nl80211.h>
 #include <net/wireless.h>
+#include <net/cfg80211.h>
 #include "core.h"
+#include "reg.h"
 
-static char *ieee80211_regdom = "US";
-module_param(ieee80211_regdom, charp, 0444);
-MODULE_PARM_DESC(ieee80211_regdom, "IEEE 802.11 regulatory domain code");
+static BLOCKING_NOTIFIER_HEAD(regulatory_chain);
 
-struct ieee80211_channel_range {
-	short start_freq;
-	short end_freq;
-	int max_power;
-	int max_antenna_gain;
-	u32 flags;
+/* wiphy is set if this request's initiator is REGDOM_SET_BY_DRIVER */
+struct regulatory_request {
+	struct list_head list;
+	struct wiphy *wiphy;
+	int granted;
+	enum reg_set_by initiator;
+	unsigned char uuid[16];
 };
 
-struct ieee80211_regdomain {
-	const char *code;
-	const struct ieee80211_channel_range *ranges;
-	int n_ranges;
+/* Keep the ordering from to large small */
+static u32 supported_bandwidths[] = {
+	MHZ_TO_KHZ(40),
+	MHZ_TO_KHZ(20),
 };
 
-#define RANGE_PWR(_start, _end, _pwr, _ag, _flags)	\
-	{ _start, _end, _pwr, _ag, _flags }
+static int is_world_regdom(char *alpha2)
+{
+	/* ASCII 0 */
+	if (alpha2[0] == 48 && alpha2[1] == 48)
+		return 1;
+	return 0;
+}
 
+/* This lets us keep regulatory code, which is
+ * updated on a regulatory basis to userspace. The
+ * uuid passed is random and used as a cookie to keep
+ * track of the request. CRDA is expectd to reply back
+ * with the same uuid in order for us to consider
+ * processing it */
+static int call_crda(const char *alpha2, unsigned char *uuid)
+{
+	static char * crda_path = "/sbin/crda";
+	unsigned char uuid_arg[16];
+	char *argv[] = { crda_path, (char *) alpha2, uuid_arg, NULL };
+	char *envp[] = {
+		"HOME=/",
+		"TERM=linux",
+		"PATH=/sbin:/usr/sbin:/bin:/usr/bin",
+		NULL
+	};
+	if (likely(!is_world_regdom((char *) alpha2)))
+		printk("cfg80211: Calling CRDA for country: %c%c\n",
+			alpha2[0], alpha2[1]);
+	else
+		printk("cfg80211: Calling CRDA to update world "
+			"regulatory domain\n");
+	sprintf(uuid_arg,
+		"%02x%02x%02x%02x"
+		"%02x%02x%02x%02x"
+		"%02x%02x%02x%02x"
+		"%02x%02x%02x%02x",
+		uuid[0], uuid[1], uuid[2], uuid[3],
+		uuid[4], uuid[5], uuid[6], uuid[7],
+		uuid[8], uuid[9], uuid[10], uuid[11],
+		uuid[12], uuid[13], uuid[14], uuid[15]);
+	return call_usermodehelper(crda_path,
+		argv, envp, UMH_WAIT_EXEC);
+}
 
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
+int __regulatory_hint(char *alpha2, enum reg_set_by set_by,
+	struct wiphy *wiphy)
+{
+	unsigned char uuid[16];
+	struct regulatory_request *request;
+	int r = 0;
 
-static const struct ieee80211_channel_range ieee80211_JP_channels[] = {
-	/* IEEE 802.11b/g, channels 1..14 */
-	RANGE_PWR(2412, 2484, 20, 6, 0),
-	/* IEEE 802.11a, channels 34..48 */
-	RANGE_PWR(5170, 5240, 20, 6, IEEE80211_CHAN_PASSIVE_SCAN),
-	/* IEEE 802.11a, channels 52..64 */
-	RANGE_PWR(5260, 5320, 20, 6, IEEE80211_CHAN_NO_IBSS |
-				     IEEE80211_CHAN_RADAR),
-};
+	switch (set_by) {
+	case REGDOM_SET_BY_CORE:
+	case REGDOM_SET_BY_DRIVER:
+	/* we may do this differently eventually */
+	case REGDOM_SET_BY_80211D:
+		/* XXX: Do basic sanity checks against alpha2 */
+		generate_random_uuid(uuid);
 
-static const struct ieee80211_channel_range ieee80211_EU_channels[] = {
-	/* IEEE 802.11b/g, channels 1..13 */
-	RANGE_PWR(2412, 2472, 20, 6, 0),
-	/* IEEE 802.11a, channel 36*/
-	RANGE_PWR(5180, 5180, 23, 6, IEEE80211_CHAN_PASSIVE_SCAN),
-	/* IEEE 802.11a, channel 40*/
-	RANGE_PWR(5200, 5200, 23, 6, IEEE80211_CHAN_PASSIVE_SCAN),
-	/* IEEE 802.11a, channel 44*/
-	RANGE_PWR(5220, 5220, 23, 6, IEEE80211_CHAN_PASSIVE_SCAN),
-	/* IEEE 802.11a, channels 48..64 */
-	RANGE_PWR(5240, 5320, 23, 6, IEEE80211_CHAN_NO_IBSS |
-				     IEEE80211_CHAN_RADAR),
-	/* IEEE 802.11a, channels 100..140 */
-	RANGE_PWR(5500, 5700, 30, 6, IEEE80211_CHAN_NO_IBSS |
-				     IEEE80211_CHAN_RADAR),
-};
+		request = kzalloc(sizeof(struct regulatory_request),
+			GFP_KERNEL);
+		if (!request)
+			return -ENOMEM;
+		memcpy(request->uuid, uuid, 16);
+
+		request->initiator = set_by;
+		request->wiphy = wiphy;
 
-#define REGDOM(_code)							\
-	{								\
-		.code = __stringify(_code),				\
-		.ranges = ieee80211_ ##_code## _channels,		\
-		.n_ranges = ARRAY_SIZE(ieee80211_ ##_code## _channels),	\
+		mutex_lock(&cfg80211_reg_mutex);
+		list_add_tail(&request->list, &regulatory_requests);
+		mutex_unlock(&cfg80211_reg_mutex);
+		r = call_crda(alpha2, uuid);
+		if (r)
+			printk("cfg80211: Failed calling CRDA\n");
+		return r;
+	default:
+		return -ENOTSUPP;
 	}
+}
 
-static const struct ieee80211_regdomain ieee80211_regdoms[] = {
-	REGDOM(US),
-	REGDOM(JP),
-	REGDOM(EU),
-};
+/**
+ * regulatory_hint - hint to wireless core a regulatory domain
+ * @alpha2: the ISO-3166 alpha2 the driver thinks we're on
+ * @wiphy: the driver's very own &struct wiphy
+ *
+ * Wireles drivers can use this function to hint to the wireles core
+ * what it believes should be the current regulatory domain by
+ * giving it an ISO-3166 alpha2 country code. If drivers have
+ * EEPROM values for a set regulatory domain it should provide
+ * mappings to a respective alpha2.
+ */
+int regulatory_hint(char *alpha2, struct wiphy *wiphy)
+{
+	return __regulatory_hint(alpha2, REGDOM_SET_BY_DRIVER, wiphy);
+}
+EXPORT_SYMBOL(regulatory_hint);
 
+/* Informs callbacks registered to notifier when a regulatory
+ * event has occurred */
+static inline void reg_notify(int event, void *param)
+{
+	blocking_notifier_call_chain(&regulatory_chain, event, param);
+}
 
-static const struct ieee80211_regdomain *get_regdom(void)
+/**
+ * register_regulatory_notifier - register a driver regulatory notifier
+ * @nb: pointer to the driver's own notifier block
+ *
+ * Wireles drivers can use this function to register with cfg80211
+ * a notifier callback to be called upon regulatory domain changes.
+ */
+int register_regulatory_notifier(struct notifier_block *nb)
 {
-	static const struct ieee80211_channel_range
-	ieee80211_world_channels[] = {
-		/* IEEE 802.11b/g, channels 1..11 */
-		RANGE_PWR(2412, 2462, 27, 6, 0),
-	};
-	static const struct ieee80211_regdomain regdom_world = REGDOM(world);
-	int i;
+	return blocking_notifier_chain_register(&regulatory_chain, nb);
+}
+EXPORT_SYMBOL(register_regulatory_notifier);
+
+/**
+ * unregister_regulatory_notifier - unregister a driver regulatory notifier
+ * @nb: pointer to the driver's own notifier block
+ *
+ * Wireles drivers use this function to unregister with cfg80211
+ * their notifier callback.
+ */
+static int unregister_regulatory_notifier(struct notifier_block *nb)
+{
+	return blocking_notifier_chain_unregister(&regulatory_chain, nb);
+}
+EXPORT_SYMBOL(unregister_regulatory_notifier);
+
+static int is_alpha2_set(char *alpha2)
+{
+	if (alpha2[0] != 0 && alpha2[1] != 0)
+		return 1;
+	return 0;
+}
+
+static int is_alpha_upper(char letter)
+{
+	/* ASCII A - Z */
+	if (letter >= 65 && letter <= 90)
+		return 1;
+	return 0;
+}
 
-	for (i = 0; i < ARRAY_SIZE(ieee80211_regdoms); i++)
-		if (strcmp(ieee80211_regdom, ieee80211_regdoms[i].code) == 0)
-			return &ieee80211_regdoms[i];
+static int is_an_alpha2(char *alpha2)
+{
+	if (is_alpha_upper(alpha2[0]) && is_alpha_upper(alpha2[1]))
+		return 1;
+	return 0;
+}
 
-	return &regdom_world;
+static int alpha2_equal(char *alpha2_x, char *alpha2_y)
+{
+	if (alpha2_x[0] == alpha2_y[0] &&
+		alpha2_x[1] == alpha2_y[1])
+		return 1;
+	return 0;
 }
 
+static int regdom_changed(char *alpha2)
+{
+	if (alpha2_equal(cfg80211_regdomain->alpha2, alpha2))
+		return 0;
+	return 1;
+}
+
+/* caller must lock cfg80211_reg_mutex */
+int __reg_is_valid_uuid(unsigned char *uuid,
+	struct regulatory_request *request)
+{
+	if (list_empty(&regulatory_requests))
+		return 0;
+	list_for_each_entry(request, &regulatory_requests, list) {
+		if (memcmp(request->uuid, uuid, 16) == 0)
+			return 1;
+		/* XXX: remove this else clause once we support handling
+		 * multiple requests, this is currenlty only respecting the
+		 * first request */
+		else
+			return 0;
+	}
+	return 0;
+}
+
+/* Used by nl80211 before kmalloc'ing our regulatory domain */
+int reg_is_valid_uuid(unsigned char *uuid) {
+	struct regulatory_request *request = NULL;
+	int r;
+	mutex_lock(&cfg80211_reg_mutex);
+	r = __reg_is_valid_uuid(uuid, request);
+	mutex_unlock(&cfg80211_reg_mutex);
+	return r;
+}
+
+static u32 freq_max_bandwidth(const struct ieee80211_freq_range *freq_range,
+	u32 freq)
+{
+	unsigned int i;
+	for (i=0; i<ARRAY_SIZE(supported_bandwidths); i++) {
+		u32 start_freq	= freq - supported_bandwidths[i];
+		u32 end_freq	= freq + supported_bandwidths[i];
+		if (likely(start_freq >= freq_range->start_freq &&
+			end_freq <= freq_range->end_freq))
+			return supported_bandwidths[i];
+	}
+	return 0;
+}
+
+/* XXX: add support for the rest of enum nl80211_reg_rule_flags, we may
+ * want to just have the channel structure use these */
+static u32 map_regdom_flags(u32 rd_flags) {
+	u32 channel_flags = 0;
+	if (rd_flags & NL80211_RRF_PASSIVE_SCAN)
+		channel_flags |= IEEE80211_CHAN_PASSIVE_SCAN;
+	if (rd_flags & NL80211_RRF_NO_IBSS)
+		channel_flags |= IEEE80211_CHAN_NO_IBSS;
+	if (rd_flags & NL80211_RRF_DFS)
+		channel_flags |= IEEE80211_CHAN_RADAR;
+	return channel_flags;
+}
 
 static void handle_channel(struct ieee80211_channel *chan,
 			   const struct ieee80211_regdomain *rd)
 {
 	int i;
 	u32 flags = chan->orig_flags;
-	const struct ieee80211_channel_range *rg = NULL;
+	u32 max_bandwidth = 0;
+	const struct ieee80211_reg_rule *reg_rule = NULL;
+	const struct ieee80211_power_rule *power_rule = NULL;
 
-	for (i = 0; i < rd->n_ranges; i++) {
-		if (rd->ranges[i].start_freq <= chan->center_freq &&
-		    chan->center_freq <= rd->ranges[i].end_freq) {
-			rg = &rd->ranges[i];
+	for (i = 0; i < rd->n_reg_rules; i++) {
+		const struct ieee80211_reg_rule *rr;
+		const struct ieee80211_freq_range *fr = NULL;
+		const struct ieee80211_power_rule *pr = NULL;
+		rr = &rd->reg_rules[i];
+		fr = &rr->freq_range;
+		pr = &rr->power_rule;
+		max_bandwidth = freq_max_bandwidth(fr,
+			MHZ_TO_KHZ(chan->center_freq));
+		if (max_bandwidth) {
+			reg_rule = rr;
+			power_rule = &rr->power_rule;
 			break;
 		}
 	}
 
-	if (!rg) {
-		/* not found */
+	if (!max_bandwidth) {
 		flags |= IEEE80211_CHAN_DISABLED;
 		chan->flags = flags;
 		return;
 	}
 
-	chan->flags = flags;
+	chan->flags = map_regdom_flags(reg_rule->flags);
 	chan->max_antenna_gain = min(chan->orig_mag,
-					 rg->max_antenna_gain);
+		(int) MBI_TO_DBI(power_rule->max_antenna_gain));
+	chan->max_bandwidth = KHZ_TO_MHZ(max_bandwidth);
 	if (chan->orig_mpwr)
-		chan->max_power = min(chan->orig_mpwr, rg->max_power);
+		chan->max_power = min(chan->orig_mpwr,
+			(int) MBM_TO_DBM(power_rule->max_eirp));
 	else
-		chan->max_power = rg->max_power;
+		chan->max_power = (int) MBM_TO_DBM(power_rule->max_eirp);
 }
 
 static void handle_band(struct ieee80211_supported_band *sband,
@@ -169,12 +327,158 @@ static void handle_band(struct ieee80211_supported_band *sband,
 		handle_channel(&sband->channels[i], rd);
 }
 
+/* requires cfg80211_drv_mutex *and* cfg80211_reg_mutex to be held */
+static void update_all_wiphy_regulatory(void)
+{
+	struct cfg80211_registered_device *drv;
+	list_for_each_entry(drv, &cfg80211_drv_list, list) {
+		struct wiphy *wiphy = &drv->wiphy;
+		if (wiphy)
+			wiphy_update_regulatory(wiphy);
+	}
+}
+
+/* requires cfg80211_reg_mutex lock */
 void wiphy_update_regulatory(struct wiphy *wiphy)
 {
 	enum ieee80211_band band;
-	const struct ieee80211_regdomain *rd = get_regdom();
-
 	for (band = 0; band < IEEE80211_NUM_BANDS; band++)
 		if (wiphy->bands[band])
-			handle_band(wiphy->bands[band], rd);
+			handle_band(wiphy->bands[band], cfg80211_regdomain);
+}
+
+static void print_regdomain(struct ieee80211_regdomain *rd)
+{
+	unsigned int i;
+	struct ieee80211_reg_rule *reg_rule = NULL;
+	struct ieee80211_freq_range *freq_range = NULL;
+	struct ieee80211_power_rule *power_rule = NULL;
+
+	printk("Country: %c%c\n", rd->alpha2[0], rd->alpha2[1]);
+
+	for (i=0; i<=rd->n_reg_rules; i++) {
+		reg_rule = &rd->reg_rules[i];
+		freq_range = &reg_rule->freq_range;
+		power_rule = &reg_rule->power_rule;
+
+		printk("\t(%d KHz - %d KHz @ %d KHz), (%d mBi, %d mBm)\n",
+			freq_range->start_freq,
+			freq_range->end_freq,
+			freq_range->max_bandwidth,
+			power_rule->max_antenna_gain,
+			power_rule->max_eirp);
+	}
+}
+
+/* Dynamic world regulatory domain requested by the wireless
+ * core upon initialization */
+static void update_world_regdomain(struct ieee80211_regdomain *rd)
+{
+	mutex_lock(&cfg80211_reg_mutex);
+	BUG_ON(list_empty(&regulatory_requests));
+
+	cfg80211_world_regdom = rd;
+	cfg80211_regdomain = rd;
+
+	print_regdomain(rd);
+
+	mutex_lock(&cfg80211_drv_mutex);
+	update_all_wiphy_regulatory();
+	mutex_unlock(&cfg80211_drv_mutex);
+
+	reg_notify(REGDOM_SET_BY_CORE, rd);
+	mutex_unlock(&cfg80211_reg_mutex);
+}
+
+/* caller must hold cfg80211_reg_mutex
+ *
+ * nl80211 uses this call to set the current regulatory
+ * domain. It provides a uuid as the cookie so we know what request it was
+ * for. For now we only consider the first request. Conflicts with multiple
+ * drivers can be ironed out later.  Caller must've already kmalloc'd
+ * the rd structure */
+int set_regdom(struct ieee80211_regdomain *rd, unsigned char *uuid)
+{
+	struct regulatory_request *request = NULL;
+	int r = 0;
+
+	/* Some basic sanity checks first */
+
+	if (is_world_regdom(rd->alpha2)) {
+		update_world_regdomain(rd);
+		return r;
+	}
+
+	if (!is_alpha2_set(rd->alpha2) || !is_an_alpha2(rd->alpha2)) {
+		printk("cfg80211: invalid regulatory domain received\n");
+		return -EINVAL;
+	}
+
+	mutex_lock(&cfg80211_reg_mutex);
+
+	if (list_empty(&regulatory_requests)) {
+		printk("cfg80211: no pending regulatory requests\n");
+		r = -EINVAL;
+		goto unlock_and_exit;
+	}
+
+	if (!regdom_changed(rd->alpha2)) {
+		/* XXX: inform who set it, either device name or country IE
+		 * from an AP we decided to associate to */
+		printk("cfg80211: regulatory domain for %c%c already"
+			"requested and set\n",
+			rd->alpha2[0], rd->alpha2[1]);
+		r = -EINVAL;
+		goto unlock_and_exit;
+	}
+
+	/* _For_now_ we only respect the first request */
+	if (!list_is_singular(&regulatory_requests)) {
+		printk("cfg80211: multiple requests to change regulatory"
+			"domain are in our queue, for now we'll only respect"
+			"the first request");
+		goto unlock_and_exit;
+	}
+
+	/* Now lets set the regulatory domain, update all driver channels
+	 * and finally inform them of what we have done, in case they want
+	 * to review or adjust their own settings based on their own
+	 * internal EEPROM data */
+
+	if (WARN_ON(!__reg_is_valid_uuid(uuid, request))) {
+		r = -EINVAL;
+		goto unlock_and_exit;
+	}
+
+	/* We only support the setting the regulatory domain by the driver or
+	 * core for a dynamic world regualtory domain right now. Country IE
+	 * parsing coming soon */
+	switch (request->initiator) {
+	case REGDOM_SET_BY_CORE:
+	case REGDOM_SET_BY_DRIVER:
+		break;
+	case REGDOM_SET_BY_80211D:
+	default:
+		r = -EOPNOTSUPP;
+		goto unlock_and_exit;
+	}
+
+	cfg80211_regdomain = rd;
+	print_regdomain(rd);
+
+	request->granted = 1;
+
+	/* update all wiphys first */
+	mutex_lock(&cfg80211_drv_mutex);
+	update_all_wiphy_regulatory();
+	mutex_unlock(&cfg80211_drv_mutex);
+
+	/* Keep the cfg80211_reg_mutex locked to ensure drivers
+	 * get a fair chance to review this new data. */
+	reg_notify(request->initiator, rd);
+
+unlock_and_exit:
+	mutex_unlock(&cfg80211_reg_mutex);
+	return r;
 }
+
diff --git a/net/wireless/reg.h b/net/wireless/reg.h
new file mode 100644
index 0000000..cc2dc99
--- /dev/null
+++ b/net/wireless/reg.h
@@ -0,0 +1,31 @@
+#ifndef __NET_WIRELESS_REG_H
+#define __NET_WIRELESS_REG_H
+
+extern struct ieee80211_regdomain *cfg80211_regdomain;
+extern struct ieee80211_regdomain *cfg80211_world_regdom;
+extern struct mutex cfg80211_reg_mutex;
+extern struct list_head regulatory_requests;
+
+struct regdom_last_setby {
+	struct wiphy *wiphy;
+	u8 initiator;
+};
+
+extern int reg_is_valid_uuid(unsigned char *uuid);
+extern int set_regdom(struct ieee80211_regdomain *rd, unsigned char *uuid);
+extern int __regulatory_hint(char *alpha2, enum reg_set_by set_by,
+        struct wiphy *wiphy);
+
+#define REG_RULE(start, end, bw, gain, eirp, reg_flags) { \
+	.freq_range.start_freq = start * 100, \
+	.freq_range.end_freq = end * 100, \
+	.freq_range.max_bandwidth = bw * 100, \
+	.power_rule.max_antenna_gain = gain * 100, \
+	.power_rule.max_eirp = eirp * 100, \
+	.flags = reg_flags, \
+	}
+
+/* If a char is A-Z */
+#define IS_ALPHA(letter) (letter >= 65 && letter <= 90)
+
+#endif  /* __NET_WIRELESS_REG_H */
-- 
1.5.4.3

