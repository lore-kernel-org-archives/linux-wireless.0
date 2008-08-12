Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:43564 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752262AbYHLXoE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Aug 2008 19:44:04 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 12 Aug 2008 16:44:04 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <mcgrof@gmail.com>, <johannes@sipsolutions.net>,
	<linville@tuxdriver.com>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH] Add new wireless regulatory infrastructure. Regulatory domains
Date: Tue, 12 Aug 2008 16:44:00 -0700
Message-ID: <1218584641-9552-1-git-send-email-lrodriguez@atheros.com> (sfid-20080813_014413_621785_4B0C725B)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

For more information see:

http://wireless.kernel.org/en/developers/Regulatory/CRDA

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 include/linux/nl80211.h |   91 ++++++++-
 include/net/cfg80211.h  |   47 +++++
 include/net/mac80211.h  |    2 +
 include/net/wireless.h  |   39 ++++
 net/mac80211/cfg.c      |    7 +
 net/wireless/core.c     |   65 ++++++-
 net/wireless/core.h     |    2 +-
 net/wireless/nl80211.c  |  124 +++++++++++
 net/wireless/reg.c      |  521 ++++++++++++++++++++++++++++++++++++----------
 net/wireless/reg.h      |   43 ++++
 10 files changed, 823 insertions(+), 118 deletions(-)
 create mode 100644 net/wireless/reg.h

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index 2be7c63..825fcc6 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -90,6 +90,17 @@
  *	or, if no MAC address given, all mesh paths, on the interface identified
  *	by %NL80211_ATTR_IFINDEX.
  *
+ * @NL80211_CMD_SET_REG: Set current regulatory domain. CRDA sends this command
+ *	after being queried by the kernel. CRDA replies by sending a regulatory
+ *	domain structure which consists of %NL80211_ATTR_REG_ALPHA set to our
+ *	current alpha2 if it found a match. It also provides
+ * 	NL80211_ATTR_REG_RULE_FLAGS, and a set of regulatory rules. Each
+ * 	regulatory rule is a nested set of attributes  given by
+ * 	%NL80211_ATTR_REG_RULE_FREQ_[START|END] and
+ * 	%NL80211_ATTR_FREQ_RANGE_MAX_BW with an attached power rule given by
+ * 	%NL80211_ATTR_REG_RULE_POWER_MAX_ANT_GAIN and
+ * 	%NL80211_ATTR_REG_RULE_POWER_MAX_EIRP.
+ *
  * @NL80211_CMD_MAX: highest used command number
  * @__NL80211_CMD_AFTER_LAST: internal use
  */
@@ -129,6 +140,8 @@ enum nl80211_commands {
 
 	/* add commands here */
 
+	NL80211_CMD_SET_REG,
+
 	/* used to define NL80211_CMD_MAX below */
 	__NL80211_CMD_AFTER_LAST,
 	NL80211_CMD_MAX = __NL80211_CMD_AFTER_LAST - 1
@@ -188,10 +201,19 @@ enum nl80211_commands {
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
+ * 	to query the CRDA to retrieve one regulatory domain. This attribute can
+ * 	also be used by userspace to query the kernel for the currently set
+ * 	regulatory domain. We chose an alpha2 as that is also used by the
+ * 	IEEE-802.11d country information element to identify a country.
+ * @NL80211_ATTR_REG_RULES: a nested array of regulatory domain regulatory
+ *	rules.
+ *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
@@ -235,6 +257,9 @@ enum nl80211_attrs {
 	NL80211_ATTR_MPATH_NEXT_HOP,
 	NL80211_ATTR_MPATH_INFO,
 
+	NL80211_ATTR_REG_ALPHA2,
+	NL80211_ATTR_REG_RULES,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
@@ -242,6 +267,7 @@ enum nl80211_attrs {
 };
 
 #define NL80211_MAX_SUPP_RATES			32
+#define NL80211_MAX_SUPP_REG_RULES		32
 #define NL80211_TKIP_DATA_OFFSET_ENCR_KEY	0
 #define NL80211_TKIP_DATA_OFFSET_TX_MIC_KEY	16
 #define NL80211_TKIP_DATA_OFFSET_RX_MIC_KEY	24
@@ -436,6 +462,69 @@ enum nl80211_bitrate_attr {
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
+ * 	If you don't have one then don't send this.
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
+ * enum nl80211_reg_rule_flags - regulatory rule flags
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
index e007508..b5491c5 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -268,6 +268,53 @@ struct mpath_info {
 	u8 flags;
 };
 
+/**
+ * enum reg_set_by - Indicates who is trying to set the regulatory domain
+ * @REGDOM_SET_BY_INIT: regulatory domain was set by initialization. We will be
+ * 	using a static world regulatory domain by default.
+ * @REGDOM_SET_BY_CORE: Core queried CRDA for a dynamic world regulatory domain.
+ * @REGDOM_SET_BY_DRIVER: a wireless drivers has hinted to the wireless core
+ *	it thinks its knows the regulatory domain we should be in.
+ * @REGDOM_SET_BY_80211D: the wireless core has received an 802.11 country
+ *	information element with regulatory information it thinks we
+ *	should consider.
+ */
+enum reg_set_by {
+	REGDOM_SET_BY_INIT,
+	REGDOM_SET_BY_CORE,
+	REGDOM_SET_BY_DRIVER,
+	REGDOM_SET_BY_80211D,
+};
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
+#define MHZ_TO_KHZ(freq) freq * 1000
+#define KHZ_TO_MHZ(freq) freq / 1000
+#define DBI_TO_MBI(gain) gain * 100
+#define MBI_TO_DBI(gain) gain / 100
+#define DBM_TO_MBM(gain) gain * 100
+#define MBM_TO_DBM(gain) gain / 100
 
 /* from net/wireless.h */
 struct wiphy;
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 0fdab59..95de1ff 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -827,6 +827,8 @@ struct ieee80211_hw {
 	s8 max_signal;
 };
 
+struct ieee80211_hw *wiphy_to_hw(struct wiphy *wiphy);
+
 /**
  * SET_IEEE80211_DEV - set device for 802.11 hardware
  *
diff --git a/include/net/wireless.h b/include/net/wireless.h
index 9324f8d..4b947c2 100644
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
@@ -178,6 +180,7 @@ struct ieee80211_supported_band {
  * struct wiphy - wireless hardware description
  * @idx: the wiphy index assigned to this item
  * @class_dev: the class device representing /sys/class/ieee80211/<wiphy-name>
+ * @reg_notifier: the driver's regulatory notification callback
  */
 struct wiphy {
 	/* assign these fields before you register the wiphy */
@@ -194,6 +197,9 @@ struct wiphy {
 
 	struct ieee80211_supported_band *bands[IEEE80211_NUM_BANDS];
 
+	/* Lets us get back the wiphy on the callback */
+	int (*reg_notifier)(struct wiphy *wiphy, enum reg_set_by setby);
+
 	/* fields below are read-only, assigned by cfg80211 */
 
 	/* the item in /sys/class/ieee80211/ points to this,
@@ -319,6 +325,39 @@ extern int ieee80211_frequency_to_channel(int freq);
  */
 extern struct ieee80211_channel *__ieee80211_get_channel(struct wiphy *wiphy,
 							 int freq);
+/**
+ * __regulatory_hint - hint to the wireless core a regulatory domain
+ * @wiphy: if a driver is providing the hint this is the driver's very
+ * 	own &struct wiphy
+ * @alpha2: the ISO/IEC 3166 alpha2 being claimed the regulatory domain
+ * 	should be in. If @rd is set this should be NULL
+ * @rd: a complete regulatory domain, if passed the caller need not worry
+ * 	about freeing it
+ *
+ * The Wireless subsystem can use this function to hint to the wireless core
+ * what it believes should be the current regulatory domain by
+ * giving it an ISO/IEC 3166 alpha2 country code it knows its regulatory
+ * domain should be in or by providing a completely build regulatory domain.
+ */
+extern int __regulatory_hint(struct wiphy *wiphy, enum reg_set_by set_by,
+		const char *alpha2, struct ieee80211_regdomain *rd);
+/**
+ * regulatory_hint - driver hint to the wireless core a regulatory domain
+ * @wiphy: the driver's very own &struct wiphy
+ * @alpha2: the ISO/IEC 3166 alpha2 the driver claims its regulatory domain
+ * 	should be in. If @rd is set this should be NULL
+ * @rd: a complete regulatory domain provided by the driver. If passed
+ * 	the driver does not need to worry about freeing it.
+ *
+ * Wireless drivers can use this function to hint to the wireless core
+ * what it believes should be the current regulatory domain by
+ * giving it an ISO/IEC 3166 alpha2 country code it knows its regulatory
+ * domain should be in or by providing a completely build regulatory domain.
+ * If the driver provides an ISO/IEC 3166 alpha2 userspace will be queried
+ * for a regulatory domain structure for the respective country.
+ */
+extern int regulatory_hint(struct wiphy *wiphy,
+		const char *alpha2, struct ieee80211_regdomain *rd);
 
 /**
  * ieee80211_get_channel - get channel struct from wiphy for specified frequency
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 297c257..a528458 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -17,6 +17,13 @@
 #include "rate.h"
 #include "mesh.h"
 
+struct ieee80211_hw *wiphy_to_hw(struct wiphy *wiphy)
+{
+	struct ieee80211_local *local = wiphy_priv(wiphy);
+	return &local->hw;
+}
+EXPORT_SYMBOL(wiphy_to_hw);
+
 static enum ieee80211_if_types
 nl80211_type_to_mac80211_type(enum nl80211_iftype type)
 {
diff --git a/net/wireless/core.c b/net/wireless/core.c
index f1da0b9..1671a48 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -13,12 +13,14 @@
 #include <linux/debugfs.h>
 #include <linux/notifier.h>
 #include <linux/device.h>
+#include <linux/list.h>
 #include <net/genetlink.h>
 #include <net/cfg80211.h>
 #include <net/wireless.h>
 #include "nl80211.h"
 #include "core.h"
 #include "sysfs.h"
+#include "reg.h"
 
 /* name for sysfs, %d is appended */
 #define PHY_NAME "phy"
@@ -27,6 +29,33 @@ MODULE_AUTHOR("Johannes Berg");
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("wireless configuration support");
 
+struct list_head regulatory_requests;
+
+/* Central wireless core regulatory domains, we only need two,
+ * the current one and a world regulatory domain in case we have no
+ * information to give us an alpha2 */
+struct ieee80211_regdomain *cfg80211_regdomain;
+
+/* We keep a static world regulatory domain in case of the absence of CRDA */
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
@@ -295,7 +324,9 @@ int wiphy_register(struct wiphy *wiphy)
 	ieee80211_set_bitrate_flags(wiphy);
 
 	/* set up regulatory info */
-	wiphy_update_regulatory(wiphy);
+	mutex_lock(&cfg80211_reg_mutex);
+	wiphy_update_regulatory(wiphy, REGDOM_SET_BY_CORE);
+	mutex_unlock(&cfg80211_reg_mutex);
 
 	mutex_lock(&cfg80211_drv_mutex);
 
@@ -402,9 +433,14 @@ static struct notifier_block cfg80211_netdev_notifier = {
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
 
@@ -418,6 +454,15 @@ static int cfg80211_init(void)
 
 	ieee80211_debugfs_dir = debugfs_create_dir("ieee80211", NULL);
 
+	err = regulatory_init();
+	if (err)
+		goto out_fail_nl80211;
+
+	err = __regulatory_hint(NULL, REGDOM_SET_BY_CORE, "00", NULL);
+	if (err)
+		printk("cfg80211: calling CRDA failed - unable to update "
+			"world regulatory domain, using static definition\n");
+
 	return 0;
 
 out_fail_nl80211:
@@ -427,13 +472,29 @@ out_fail_notifier:
 out_fail_sysfs:
 	return err;
 }
+
 subsys_initcall(cfg80211_init);
 
 static void cfg80211_exit(void)
 {
+	struct regulatory_request *req, *req_tmp;
 	debugfs_remove(ieee80211_debugfs_dir);
 	nl80211_exit();
+	if (cfg80211_world_regdom != &world_regdom) {
+		if (cfg80211_world_regdom == cfg80211_regdomain) {
+			kfree(cfg80211_regdomain);
+		}
+		else {
+			kfree(cfg80211_world_regdom);
+			kfree(cfg80211_regdomain);
+		}
+	}
+	list_for_each_entry_safe(req, req_tmp, &regulatory_requests, list) {
+		list_del(&req->list);
+		kfree(req);
+	}
 	unregister_netdevice_notifier(&cfg80211_netdev_notifier);
 	wiphy_sysfs_exit();
+	regulatory_exit();
 }
 module_exit(cfg80211_exit);
diff --git a/net/wireless/core.h b/net/wireless/core.h
index 7a02c35..771cc5c 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -79,6 +79,6 @@ extern int cfg80211_dev_rename(struct cfg80211_registered_device *drv,
 			       char *newname);
 
 void ieee80211_set_bitrate_flags(struct wiphy *wiphy);
-void wiphy_update_regulatory(struct wiphy *wiphy);
+void wiphy_update_regulatory(struct wiphy *wiphy, enum reg_set_by setby);
 
 #endif /* __NET_WIRELESS_CORE_H */
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 59eb2cf..476d8b6 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -18,6 +18,7 @@
 #include <net/cfg80211.h>
 #include "core.h"
 #include "nl80211.h"
+#include "reg.h"
 
 /* the netlink family */
 static struct genl_family nl80211_fam = {
@@ -87,6 +88,9 @@ static struct nla_policy nl80211_policy[NL80211_ATTR_MAX+1] __read_mostly = {
 	[NL80211_ATTR_MESH_ID] = { .type = NLA_BINARY,
 				.len = IEEE80211_MAX_MESH_ID_LEN },
 	[NL80211_ATTR_MPATH_NEXT_HOP] = { .type = NLA_U32 },
+
+	[NL80211_ATTR_REG_ALPHA2] = { .type = NLA_STRING, .len = 2 },
+	[NL80211_ATTR_REG_RULES] = { .type = NLA_NESTED },
 };
 
 /* message building helper */
@@ -1525,6 +1529,120 @@ static int nl80211_del_mpath(struct sk_buff *skb, struct genl_info *info)
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
+	power_rule->max_eirp =
+		nla_get_u32(tb[NL80211_ATTR_POWER_RULE_MAX_EIRP]);
+
+	if (tb[NL80211_ATTR_POWER_RULE_MAX_ANT_GAIN])
+		power_rule->max_antenna_gain =
+			nla_get_u32(tb[NL80211_ATTR_POWER_RULE_MAX_ANT_GAIN]);
+
+	return 0;
+}
+
+static int nl80211_set_reg(struct sk_buff *skb, struct genl_info *info)
+{
+	struct nlattr *tb[NL80211_REG_RULE_ATTR_MAX + 1];
+	struct nlattr *nl_reg_rule;
+	char *alpha2 = NULL;
+	int rem_reg_rules = 0, r = 0;
+	u32 num_rules = 0, rule_idx = 0, size_of_regd;
+	struct ieee80211_regdomain *rd = NULL;
+
+	if (!info->attrs[NL80211_ATTR_REG_ALPHA2])
+		return -EINVAL;
+
+	if (!info->attrs[NL80211_ATTR_REG_RULES])
+		return -EINVAL;
+
+	alpha2 = nla_data(info->attrs[NL80211_ATTR_REG_ALPHA2]);
+
+	nla_for_each_nested(nl_reg_rule, info->attrs[NL80211_ATTR_REG_RULES],
+			rem_reg_rules) {
+		num_rules++;
+		if (num_rules > NL80211_MAX_SUPP_REG_RULES)
+			goto bad_reg;
+	}
+
+	if (!reg_is_valid_request(alpha2))
+		return -EINVAL;
+
+	size_of_regd = sizeof(struct ieee80211_regdomain) +
+		(sizeof(struct ieee80211_reg_rule) * num_rules);
+
+	rd = kzalloc(size_of_regd, GFP_KERNEL);
+	if (!rd)
+		return -ENOMEM;
+
+	/* How about Padding ? */
+	rd->reg_rules = (struct ieee80211_reg_rule *)
+		rd + sizeof(sizeof(struct ieee80211_regdomain));
+	rd->n_reg_rules = num_rules;
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
+	BUG_ON(rule_idx != num_rules);
+
+	r = set_regdom(rd);
+	if (r)
+		goto bad_reg;
+
+	return r;
+
+bad_reg:
+	kfree(rd);
+	return -EINVAL;
+}
+
 static struct genl_ops nl80211_ops[] = {
 	{
 		.cmd = NL80211_CMD_GET_WIPHY,
@@ -1656,6 +1774,12 @@ static struct genl_ops nl80211_ops[] = {
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
index 855bff4..c85d0e1 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -2,179 +2,472 @@
  * Copyright 2002-2005, Instant802 Networks, Inc.
  * Copyright 2005-2006, Devicescape Software, Inc.
  * Copyright 2007	Johannes Berg <johannes@sipsolutions.net>
+ * Copyright 2008	Luis R. Rodriguez <lrodriguz@atheros.com>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
  */
 
-/*
- * This regulatory domain control implementation is highly incomplete, it
- * only exists for the purpose of not regressing mac80211.
- *
- * For now, drivers can restrict the set of allowed channels by either
- * not registering those channels or setting the IEEE80211_CHAN_DISABLED
- * flag; that flag will only be *set* by this code, never *cleared.
+/**
+ * DOC: Wireless regulatory infrastructure
  *
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
+ * comformance. For drivers which do not have any regulatory
+ * information CRDA provides the complete regulatory solution.
+ * For others it provides a community effort on further restrictions
+ * to enhance compliance.
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
+#include <linux/platform_device.h>
 #include <net/wireless.h>
+#include <net/cfg80211.h>
 #include "core.h"
+#include "reg.h"
 
-static char *ieee80211_regdom = "US";
-module_param(ieee80211_regdom, charp, 0444);
-MODULE_PARM_DESC(ieee80211_regdom, "IEEE 802.11 regulatory domain code");
+/* To trigger userspace events */
+static struct platform_device *reg_pdev;
 
-struct ieee80211_channel_range {
-	short start_freq;
-	short end_freq;
-	int max_power;
-	int max_antenna_gain;
-	u32 flags;
+/* Keep the ordering from large to small */
+static u32 supported_bandwidths[] = {
+	MHZ_TO_KHZ(40),
+	MHZ_TO_KHZ(20),
 };
 
-struct ieee80211_regdomain {
-	const char *code;
-	const struct ieee80211_channel_range *ranges;
-	int n_ranges;
-};
+static int is_world_regdom(char *alpha2)
+{
+	/* ASCII 0 */
+	if (alpha2[0] == 48 && alpha2[1] == 48)
+		return 1;
+	return 0;
+}
 
-#define RANGE_PWR(_start, _end, _pwr, _ag, _flags)	\
-	{ _start, _end, _pwr, _ag, _flags }
+/* This lets us keep regulatory code, which is updated on a regulatory
+ * basis to userspace. */
+static int call_crda(const char *alpha2)
+{
+	char country_env[9 + 2] = "COUNTRY=";
+	char *envp[] = {
+		country_env,
+		NULL
+	};
 
+	if (!is_world_regdom((char *) alpha2))
+		printk(KERN_INFO "cfg80211: Calling CRDA for country: %c%c\n",
+			alpha2[0], alpha2[1]);
+	else
+		printk(KERN_INFO "cfg80211: Calling CRDA to update world "
+			"regulatory domain\n");
 
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
+	country_env[8] = alpha2[0];
+	country_env[9] = alpha2[1];
 
-static const struct ieee80211_channel_range ieee80211_JP_channels[] = {
-	/* IEEE 802.11b/g, channels 1..14 */
-	RANGE_PWR(2412, 2484, 20, 6, 0),
-	/* IEEE 802.11a, channels 34..48 */
-	RANGE_PWR(5170, 5240, 20, 6, IEEE80211_CHAN_PASSIVE_SCAN),
-	/* IEEE 802.11a, channels 52..64 */
-	RANGE_PWR(5260, 5320, 20, 6, IEEE80211_CHAN_NO_IBSS |
-				     IEEE80211_CHAN_RADAR),
-};
+	return kobject_uevent_env(&reg_pdev->dev.kobj, KOBJ_CHANGE, envp);
+}
 
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
+int __regulatory_hint(struct wiphy *wiphy, enum reg_set_by set_by,
+		      const char *alpha2, struct ieee80211_regdomain *rd)
+{
+	struct regulatory_request *request;
+	char *rd_alpha2;
+	int r = 0;
+
+	if (rd)
+		rd_alpha2 = rd->alpha2;
+	else
+		rd_alpha2 = (char *) alpha2;
+
+	switch (set_by) {
+	case REGDOM_SET_BY_CORE:
+	case REGDOM_SET_BY_DRIVER:
+	/* we may do this differently eventually */
+	case REGDOM_SET_BY_80211D:
+		request = kzalloc(sizeof(struct regulatory_request),
+			GFP_KERNEL);
+		if (!request)
+			return -ENOMEM;
+
+		request->alpha2[0] = rd_alpha2[0];
+		request->alpha2[1] = rd_alpha2[1];
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
+		if (rd) {
+			mutex_lock(&cfg80211_reg_mutex);
+			r = set_regdom(rd);
+			mutex_unlock(&cfg80211_reg_mutex);
+			if (r)
+				printk(KERN_ERR "cfg80211: Failed setting "
+					"regulatory domain\n");
+		}
+		else {
+			r = call_crda(alpha2);
+			if (r)
+				printk(KERN_ERR "cfg80211: Failed "
+					"calling CRDA\n");
+		}
+		return r;
+	default:
+		return -ENOTSUPP;
 	}
+}
+EXPORT_SYMBOL(__regulatory_hint);
 
-static const struct ieee80211_regdomain ieee80211_regdoms[] = {
-	REGDOM(US),
-	REGDOM(JP),
-	REGDOM(EU),
-};
+int regulatory_hint(struct wiphy *wiphy, const char *alpha2,
+	struct ieee80211_regdomain *rd)
+{
+	BUG_ON(!rd && !alpha2);
+	return __regulatory_hint(wiphy, REGDOM_SET_BY_DRIVER, alpha2, rd);
+}
+EXPORT_SYMBOL(regulatory_hint);
 
+static int is_alpha2_set(char *alpha2)
+{
+	if (alpha2[0] != 0 && alpha2[1] != 0)
+		return 1;
+	return 0;
+}
 
-static const struct ieee80211_regdomain *get_regdom(void)
+static int is_alpha_upper(char letter)
 {
-	static const struct ieee80211_channel_range
-	ieee80211_world_channels[] = {
-		/* IEEE 802.11b/g, channels 1..11 */
-		RANGE_PWR(2412, 2462, 27, 6, 0),
-	};
-	static const struct ieee80211_regdomain regdom_world = REGDOM(world);
-	int i;
+	/* ASCII A - Z */
+	if (letter >= 65 && letter <= 90)
+		return 1;
+	return 0;
+}
+
+static int is_an_alpha2(char *alpha2)
+{
+	if (is_alpha_upper(alpha2[0]) && is_alpha_upper(alpha2[1]))
+		return 1;
+	return 0;
+}
+
+static int alpha2_equal(char *alpha2_x, char *alpha2_y)
+{
+	if (alpha2_x[0] == alpha2_y[0] &&
+		alpha2_x[1] == alpha2_y[1])
+		return 1;
+	return 0;
+}
+
+static int regdom_changed(char *alpha2)
+{
+	if (alpha2_equal(cfg80211_regdomain->alpha2, alpha2))
+		return 0;
+	return 1;
+}
+
+/* caller must lock cfg80211_reg_mutex */
+int __reg_is_valid_request(char *alpha2,
+	struct regulatory_request **request)
+{
+	struct regulatory_request *req;
+	if (list_empty(&regulatory_requests))
+		return 0;
+	list_for_each_entry(req, &regulatory_requests, list) {
+		if (alpha2_equal(req->alpha2, alpha2)) {
+			*request = req;
+			return 1;
+		}
+		/* XXX: remove this else clause once we support handling
+		 * multiple requests, this is currenlty only respecting the
+		 * first request */
+		else
+			return 0;
+	}
+	return 0;
+}
 
-	for (i = 0; i < ARRAY_SIZE(ieee80211_regdoms); i++)
-		if (strcmp(ieee80211_regdom, ieee80211_regdoms[i].code) == 0)
-			return &ieee80211_regdoms[i];
+/* Used by nl80211 before kmalloc'ing our regulatory domain */
+int reg_is_valid_request(char *alpha2) {
+	struct regulatory_request *request = NULL;
+	int r;
+	mutex_lock(&cfg80211_reg_mutex);
+	r = __reg_is_valid_request(alpha2, &request);
+	mutex_unlock(&cfg80211_reg_mutex);
+	return r;
+}
 
-	return &regdom_world;
+static u32 freq_max_bandwidth(const struct ieee80211_freq_range *freq_range,
+	u32 freq)
+{
+	unsigned int i;
+	for (i=0; i<ARRAY_SIZE(supported_bandwidths); i++) {
+		u32 start_freq = freq - supported_bandwidths[i]/2;
+		u32 end_freq = freq + supported_bandwidths[i]/2;
+		if (start_freq >= freq_range->start_freq &&
+			end_freq <= freq_range->end_freq)
+			return supported_bandwidths[i];
+	}
+	return 0;
 }
 
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
 
-static void handle_channel(struct ieee80211_channel *chan,
-			   const struct ieee80211_regdomain *rd)
+/**
+ * freq_reg_info - get regulatory information for the given frequency
+ * @center_freq: Frequency in KHz for which we want regulatory information for
+ * @bandwidth: the bandwidth requirement you have in KHz, if you do not have one
+ * 	you can set this to 0. If this frequency is allowed we then set
+ * 	this value to the maximum allowed bandwidth.
+ * @reg_rule: the regulatory rule which we have for this frequency
+ *
+ * Use this function to get the regulatory rule for a specific frequency.
+ */
+static int freq_reg_info(u32 center_freq, u32 *bandwidth,
+			 const struct ieee80211_reg_rule **reg_rule)
 {
 	int i;
-	u32 flags = chan->orig_flags;
-	const struct ieee80211_channel_range *rg = NULL;
+	u32 max_bandwidth = 0;
 
-	for (i = 0; i < rd->n_ranges; i++) {
-		if (rd->ranges[i].start_freq <= chan->center_freq &&
-		    chan->center_freq <= rd->ranges[i].end_freq) {
-			rg = &rd->ranges[i];
+	for (i = 0; i < cfg80211_regdomain->n_reg_rules; i++) {
+		const struct ieee80211_reg_rule *rr;
+		const struct ieee80211_freq_range *fr = NULL;
+		const struct ieee80211_power_rule *pr = NULL;
+
+		rr = &cfg80211_regdomain->reg_rules[i];
+		fr = &rr->freq_range;
+		pr = &rr->power_rule;
+		max_bandwidth = freq_max_bandwidth(fr, center_freq);
+		if (max_bandwidth && *bandwidth <= max_bandwidth) {
+			*reg_rule = rr;
+			*bandwidth = max_bandwidth;
 			break;
 		}
 	}
 
-	if (!rg) {
-		/* not found */
+	return !max_bandwidth;
+}
+
+static void handle_channel(struct ieee80211_channel *chan)
+{
+	int r;
+	u32 flags = chan->orig_flags;
+	u32 max_bandwidth = 0;
+	const struct ieee80211_reg_rule *reg_rule = NULL;
+	const struct ieee80211_power_rule *power_rule = NULL;
+
+	r = freq_reg_info(MHZ_TO_KHZ(chan->center_freq),
+		&max_bandwidth, &reg_rule);
+
+	if (r) {
 		flags |= IEEE80211_CHAN_DISABLED;
 		chan->flags = flags;
 		return;
 	}
 
-	chan->flags = flags;
+	power_rule = &reg_rule->power_rule;
+
+	chan->flags = flags | map_regdom_flags(reg_rule->flags);
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
 
-static void handle_band(struct ieee80211_supported_band *sband,
-			const struct ieee80211_regdomain *rd)
-{
+static void handle_band(struct ieee80211_supported_band *sband) {
 	int i;
 
 	for (i = 0; i < sband->n_channels; i++)
-		handle_channel(&sband->channels[i], rd);
+		handle_channel(&sband->channels[i]);
 }
 
-void wiphy_update_regulatory(struct wiphy *wiphy)
+/* requires cfg80211_drv_mutex *and* cfg80211_reg_mutex to be held */
+static void update_all_wiphy_regulatory(enum reg_set_by setby)
 {
-	enum ieee80211_band band;
-	const struct ieee80211_regdomain *rd = get_regdom();
+	struct cfg80211_registered_device *drv;
 
-	for (band = 0; band < IEEE80211_NUM_BANDS; band++)
+	list_for_each_entry(drv, &cfg80211_drv_list, list)
+		wiphy_update_regulatory(&drv->wiphy, setby);
+}
+
+/* requires cfg80211_reg_mutex lock */
+void wiphy_update_regulatory(struct wiphy *wiphy, enum reg_set_by setby)
+{
+	enum ieee80211_band band;
+	for (band = 0; band < IEEE80211_NUM_BANDS; band++) {
 		if (wiphy->bands[band])
-			handle_band(wiphy->bands[band], rd);
+			handle_band(wiphy->bands[band]);
+		if (wiphy->reg_notifier)
+			wiphy->reg_notifier(wiphy, setby);
+	}
+}
+
+static void print_regdomain(struct ieee80211_regdomain *rd)
+{
+	unsigned int i;
+	struct ieee80211_reg_rule *reg_rule = NULL;
+	struct ieee80211_freq_range *freq_range = NULL;
+	struct ieee80211_power_rule *power_rule = NULL;
+
+	if (is_world_regdom(rd->alpha2))
+		printk(KERN_INFO "cfg80211: World regulatory "
+			"domain updated:\n");
+	else
+		printk(KERN_INFO "cfg80211: Regulatory domain changed to "
+			"country: %c%c\n", rd->alpha2[0], rd->alpha2[1]);
+
+	for (i=0; i<rd->n_reg_rules; i++) {
+		reg_rule = &rd->reg_rules[i];
+		freq_range = &reg_rule->freq_range;
+		power_rule = &reg_rule->power_rule;
+
+		printk(KERN_INFO "\t(%d KHz - %d KHz @ %d KHz), "
+			"(%d mBi, %d mBm)\n",
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
+	BUG_ON(list_empty(&regulatory_requests));
+
+	cfg80211_world_regdom = rd;
+	cfg80211_regdomain = rd;
+
+	print_regdomain(rd);
+
+	mutex_lock(&cfg80211_drv_mutex);
+	update_all_wiphy_regulatory(REGDOM_SET_BY_INIT);
+	mutex_unlock(&cfg80211_drv_mutex);
+}
+
+/* caller must hold cfg80211_reg_mutex
+ *
+ * Use this call to set the current regulatory
+ * domain. For now we only consider the first request. Conflicts with multiple
+ * drivers can be ironed out later.  Caller must've already kmalloc'd
+ * the rd structure */
+int set_regdom(struct ieee80211_regdomain *rd)
+{
+	struct regulatory_request *request = NULL;
+	int r = 0;
+
+	/* Some basic sanity checks first */
+
+	if (is_world_regdom(rd->alpha2)) {
+		mutex_lock(&cfg80211_reg_mutex);
+		if (WARN_ON(!__reg_is_valid_request(rd->alpha2, &request))) {
+			mutex_unlock(&cfg80211_reg_mutex);
+		}
+		update_world_regdomain(rd);
+		list_del(&request->list);
+		mutex_unlock(&cfg80211_reg_mutex);
+		return r;
+	}
+
+	if (!is_alpha2_set(rd->alpha2) || !is_an_alpha2(rd->alpha2))
+		return -EINVAL;
+
+	mutex_lock(&cfg80211_reg_mutex);
+
+	if (list_empty(&regulatory_requests)) {
+		r = -EINVAL;
+		goto unlock_and_exit;
+	}
+
+	if (!regdom_changed(rd->alpha2)) {
+		r = -EINVAL;
+		goto unlock_and_exit;
+	}
+
+	/* _For_now_ we only respect the first request */
+	if (!list_is_singular(&regulatory_requests)) {
+		printk(KERN_ERR "cfg80211: multiple requests to "
+			"change regulatory domain are in our queue, "
+			"for now we'll only respect the first request");
+		goto unlock_and_exit;
+	}
+
+	/* Now lets set the regulatory domain, update all driver channels
+	 * and finally inform them of what we have done, in case they want
+	 * to review or adjust their own settings based on their own
+	 * internal EEPROM data */
+
+	if (WARN_ON(!__reg_is_valid_request(rd->alpha2, &request))) {
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
+	update_all_wiphy_regulatory(request->initiator);
+	mutex_unlock(&cfg80211_drv_mutex);
+
+unlock_and_exit:
+	mutex_unlock(&cfg80211_reg_mutex);
+	return r;
+}
+
+int regulatory_init(void)
+{
+	reg_pdev = platform_device_register_simple("regulatory", 0, NULL, 0);
+	if (IS_ERR(reg_pdev))
+		return PTR_ERR(reg_pdev);
+	return 0;
+}
+
+void regulatory_exit(void)
+{
+	platform_device_unregister(reg_pdev);
 }
diff --git a/net/wireless/reg.h b/net/wireless/reg.h
new file mode 100644
index 0000000..76a36c6
--- /dev/null
+++ b/net/wireless/reg.h
@@ -0,0 +1,43 @@
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
+/* wiphy is set if this request's initiator is REGDOM_SET_BY_DRIVER */
+struct regulatory_request {
+	struct list_head list;
+	struct wiphy *wiphy;
+	int granted;
+	enum reg_set_by initiator;
+	char alpha2[2];
+};
+
+int reg_is_valid_request(char *alpha2);
+int set_regdom(struct ieee80211_regdomain *rd);
+int __regulatory_hint_alpha2(struct wiphy *wiphy, enum reg_set_by set_by,
+		      const char *alpha2);
+
+int regulatory_init(void);
+void regulatory_exit(void);
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
1.5.6.rc2.15.g457bb.dirty

