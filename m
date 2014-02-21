Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f180.google.com ([209.85.215.180]:59557 "EHLO
	mail-ea0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752417AbaBUSqZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Feb 2014 13:46:25 -0500
Received: by mail-ea0-f180.google.com with SMTP id o10so1772010eaj.39
        for <linux-wireless@vger.kernel.org>; Fri, 21 Feb 2014 10:46:23 -0800 (PST)
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, mcgrof@do-not-panic.com,
	linville@tuxdriver.com, Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [PATCH v2 1/2] cfg80211: regulatory, introduce DFS CAC time
Date: Fri, 21 Feb 2014 19:46:12 +0100
Message-Id: <1393008373-4069-1-git-send-email-janusz.dziedzic@tieto.com> (sfid-20140221_194643_833509_131CDBE8)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Introduce DFS CAC time as a regd param, configured
per REG_RULE and set per channel in cfg80211.
DFS CAC time is close connected with regulatory
database configuration. Instead of using hardcoded
values, get DFS CAC time form regulatory database.
Pass DFS CAC time to user mode (mainly for iw reg get,
iw list, iw info). Allow setting DFS CAC time via CRDA.
Add support for internal regulatory database.

Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
---
 include/net/cfg80211.h       |    2 ++
 include/net/regulatory.h     |   21 +++++++++++++--------
 include/uapi/linux/nl80211.h |    6 ++++++
 net/wireless/genregdb.awk    |    8 +++++++-
 net/wireless/nl80211.c       |   13 ++++++++++++-
 net/wireless/reg.c           |   32 ++++++++++++++++++++++++++------
 6 files changed, 66 insertions(+), 16 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 8c9ba44..bfa9a0c 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -151,6 +151,7 @@ enum ieee80211_channel_flags {
  * @dfs_state: current state of this channel. Only relevant if radar is required
  *	on this channel.
  * @dfs_state_entered: timestamp (jiffies) when the dfs state was entered.
+ * @dfs_cac_ms: DFS CAC time in milliseconds, this is valid for DFS channels.
  */
 struct ieee80211_channel {
 	enum ieee80211_band band;
@@ -165,6 +166,7 @@ struct ieee80211_channel {
 	int orig_mag, orig_mpwr;
 	enum nl80211_dfs_state dfs_state;
 	unsigned long dfs_state_entered;
+	unsigned int dfs_cac_ms;
 };
 
 /**
diff --git a/include/net/regulatory.h b/include/net/regulatory.h
index b07cdc9..75fc1f5 100644
--- a/include/net/regulatory.h
+++ b/include/net/regulatory.h
@@ -155,6 +155,7 @@ struct ieee80211_reg_rule {
 	struct ieee80211_freq_range freq_range;
 	struct ieee80211_power_rule power_rule;
 	u32 flags;
+	u32 dfs_cac_ms;
 };
 
 struct ieee80211_regdomain {
@@ -172,14 +173,18 @@ struct ieee80211_regdomain {
 #define DBM_TO_MBM(gain) ((gain) * 100)
 #define MBM_TO_DBM(gain) ((gain) / 100)
 
-#define REG_RULE(start, end, bw, gain, eirp, reg_flags) \
-{							\
-	.freq_range.start_freq_khz = MHZ_TO_KHZ(start),	\
-	.freq_range.end_freq_khz = MHZ_TO_KHZ(end),	\
-	.freq_range.max_bandwidth_khz = MHZ_TO_KHZ(bw),	\
-	.power_rule.max_antenna_gain = DBI_TO_MBI(gain),\
-	.power_rule.max_eirp = DBM_TO_MBM(eirp),	\
-	.flags = reg_flags,				\
+#define REG_RULE_EXT(start, end, bw, gain, eirp, dfs_cac, reg_flags)	\
+{									\
+	.freq_range.start_freq_khz = MHZ_TO_KHZ(start),			\
+	.freq_range.end_freq_khz = MHZ_TO_KHZ(end),			\
+	.freq_range.max_bandwidth_khz = MHZ_TO_KHZ(bw),			\
+	.power_rule.max_antenna_gain = DBI_TO_MBI(gain),		\
+	.power_rule.max_eirp = DBM_TO_MBM(eirp),			\
+	.flags = reg_flags,						\
+	.dfs_cac_ms = dfs_cac,						\
 }
 
+#define REG_RULE(start, end, bw, gain, eirp, reg_flags) \
+	REG_RULE_EXT(start, end, bw, gain, eirp, 0, reg_flags)
+
 #endif
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index ff72cab..1ba9d62 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -2335,6 +2335,7 @@ enum nl80211_band_attr {
  * @NL80211_FREQUENCY_ATTR_NO_160MHZ: any 160 MHz (but not 80+80) channel
  *	using this channel as the primary or any of the secondary channels
  *	isn't possible
+ * @NL80211_FREQUENCY_ATTR_DFS_CAC_TIME: DFS CAC time in milliseconds.
  * @NL80211_FREQUENCY_ATTR_MAX: highest frequency attribute number
  *	currently defined
  * @__NL80211_FREQUENCY_ATTR_AFTER_LAST: internal use
@@ -2353,6 +2354,7 @@ enum nl80211_frequency_attr {
 	NL80211_FREQUENCY_ATTR_NO_HT40_PLUS,
 	NL80211_FREQUENCY_ATTR_NO_80MHZ,
 	NL80211_FREQUENCY_ATTR_NO_160MHZ,
+	NL80211_FREQUENCY_ATTR_DFS_CAC_TIME,
 
 	/* keep last */
 	__NL80211_FREQUENCY_ATTR_AFTER_LAST,
@@ -2449,6 +2451,8 @@ enum nl80211_reg_type {
  * 	If you don't have one then don't send this.
  * @NL80211_ATTR_POWER_RULE_MAX_EIRP: the maximum allowed EIRP for
  * 	a given frequency range. The value is in mBm (100 * dBm).
+ * @NL80211_ATTR_DFS_CAC_TIME: DFS CAC time in milliseconds.
+ *	If not present or 0 default CAC time will be used.
  * @NL80211_REG_RULE_ATTR_MAX: highest regulatory rule attribute number
  *	currently defined
  * @__NL80211_REG_RULE_ATTR_AFTER_LAST: internal use
@@ -2464,6 +2468,8 @@ enum nl80211_reg_rule_attr {
 	NL80211_ATTR_POWER_RULE_MAX_ANT_GAIN,
 	NL80211_ATTR_POWER_RULE_MAX_EIRP,
 
+	NL80211_ATTR_DFS_CAC_TIME,
+
 	/* keep last */
 	__NL80211_REG_RULE_ATTR_AFTER_LAST,
 	NL80211_REG_RULE_ATTR_MAX = __NL80211_REG_RULE_ATTR_AFTER_LAST - 1
diff --git a/net/wireless/genregdb.awk b/net/wireless/genregdb.awk
index fdfd3f0..b35da8d 100644
--- a/net/wireless/genregdb.awk
+++ b/net/wireless/genregdb.awk
@@ -66,6 +66,7 @@ function parse_reg_rule()
 	units = $8
 	sub(/\)/, "", units)
 	sub(/,/, "", units)
+	dfs_cac = $9
 	if (units == "mW") {
 		if (power == 100) {
 			power = 20
@@ -78,7 +79,12 @@ function parse_reg_rule()
 		} else {
 			print "Unknown power value in database!"
 		}
+	} else {
+		dfs_cac = $8
 	}
+	sub(/,/, "", dfs_cac)
+	sub(/\(/, "", dfs_cac)
+	sub(/\)/, "", dfs_cac)
 	flagstr = ""
 	for (i=8; i<=NF; i++)
 		flagstr = flagstr $i
@@ -111,7 +117,7 @@ function parse_reg_rule()
 
 	}
 	flags = flags "0"
-	printf "\t\tREG_RULE(%d, %d, %d, %d, %d, %s),\n", start, end, bw, gain, power, flags
+	printf "\t\tREG_RULE_EXT(%d, %d, %d, %d, %d, %d, %s),\n", start, end, bw, gain, power, dfs_cac, flags
 	rules++
 }
 
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 2c38b28..9f7ebf9 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -593,6 +593,10 @@ static int nl80211_msg_put_channel(struct sk_buff *msg,
 			if (nla_put_u32(msg, NL80211_FREQUENCY_ATTR_DFS_TIME,
 					time))
 				goto nla_put_failure;
+			if (nla_put_u32(msg,
+					NL80211_FREQUENCY_ATTR_DFS_CAC_TIME,
+					chan->dfs_cac_ms))
+				goto nla_put_failure;
 		}
 	}
 
@@ -4614,6 +4618,7 @@ static const struct nla_policy reg_rule_policy[NL80211_REG_RULE_ATTR_MAX + 1] =
 	[NL80211_ATTR_FREQ_RANGE_MAX_BW]	= { .type = NLA_U32 },
 	[NL80211_ATTR_POWER_RULE_MAX_ANT_GAIN]	= { .type = NLA_U32 },
 	[NL80211_ATTR_POWER_RULE_MAX_EIRP]	= { .type = NLA_U32 },
+	[NL80211_ATTR_DFS_CAC_TIME]		= { .type = NLA_U32 },
 };
 
 static int parse_reg_rule(struct nlattr *tb[],
@@ -4649,6 +4654,10 @@ static int parse_reg_rule(struct nlattr *tb[],
 		power_rule->max_antenna_gain =
 			nla_get_u32(tb[NL80211_ATTR_POWER_RULE_MAX_ANT_GAIN]);
 
+	if (tb[NL80211_ATTR_DFS_CAC_TIME])
+		reg_rule->dfs_cac_ms =
+			nla_get_u32(tb[NL80211_ATTR_DFS_CAC_TIME]);
+
 	return 0;
 }
 
@@ -5136,7 +5145,9 @@ static int nl80211_get_reg(struct sk_buff *skb, struct genl_info *info)
 		    nla_put_u32(msg, NL80211_ATTR_POWER_RULE_MAX_ANT_GAIN,
 				power_rule->max_antenna_gain) ||
 		    nla_put_u32(msg, NL80211_ATTR_POWER_RULE_MAX_EIRP,
-				power_rule->max_eirp))
+				power_rule->max_eirp) ||
+		    nla_put_u32(msg, NL80211_ATTR_DFS_CAC_TIME,
+				reg_rule->dfs_cac_ms))
 			goto nla_put_failure_rcu;
 
 		nla_nest_end(msg, nl_reg_rule);
diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 6b6f33a..3e0619c 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -755,6 +755,9 @@ static int reg_rules_intersect(const struct ieee80211_regdomain *rd1,
 	power_rule->max_antenna_gain = min(power_rule1->max_antenna_gain,
 		power_rule2->max_antenna_gain);
 
+	intersected_rule->dfs_cac_ms = max(rule1->dfs_cac_ms,
+					   rule2->dfs_cac_ms);
+
 	if (!is_valid_reg_rule(intersected_rule))
 		return -EINVAL;
 
@@ -1077,6 +1080,14 @@ static void handle_channel(struct wiphy *wiphy,
 		min_t(int, chan->orig_mag,
 		      MBI_TO_DBI(power_rule->max_antenna_gain));
 	chan->max_reg_power = (int) MBM_TO_DBM(power_rule->max_eirp);
+
+	if (chan->flags & IEEE80211_CHAN_RADAR) {
+		if (reg_rule->dfs_cac_ms)
+			chan->dfs_cac_ms = reg_rule->dfs_cac_ms;
+		else
+			chan->dfs_cac_ms = IEEE80211_DFS_MIN_CAC_TIME_MS;
+	}
+
 	if (chan->orig_mpwr) {
 		/*
 		 * Devices that use REGULATORY_COUNTRY_IE_FOLLOW_POWER
@@ -2255,9 +2266,9 @@ static void print_rd_rules(const struct ieee80211_regdomain *rd)
 	const struct ieee80211_reg_rule *reg_rule = NULL;
 	const struct ieee80211_freq_range *freq_range = NULL;
 	const struct ieee80211_power_rule *power_rule = NULL;
-	char bw[32];
+	char bw[32], cac_time[32];
 
-	pr_info("  (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)\n");
+	pr_info("  (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp), (dfs_cac_time)\n");
 
 	for (i = 0; i < rd->n_reg_rules; i++) {
 		reg_rule = &rd->reg_rules[i];
@@ -2272,23 +2283,32 @@ static void print_rd_rules(const struct ieee80211_regdomain *rd)
 			snprintf(bw, sizeof(bw), "%d KHz",
 				 freq_range->max_bandwidth_khz);
 
+		if (reg_rule->flags & NL80211_RRF_DFS)
+			scnprintf(cac_time, sizeof(cac_time), "%u s",
+				  reg_rule->dfs_cac_ms/1000);
+		else
+			scnprintf(cac_time, sizeof(cac_time), "N/A");
+
+
 		/*
 		 * There may not be documentation for max antenna gain
 		 * in certain regions
 		 */
 		if (power_rule->max_antenna_gain)
-			pr_info("  (%d KHz - %d KHz @ %s), (%d mBi, %d mBm)\n",
+			pr_info("  (%d KHz - %d KHz @ %s), (%d mBi, %d mBm), (%s)\n",
 				freq_range->start_freq_khz,
 				freq_range->end_freq_khz,
 				bw,
 				power_rule->max_antenna_gain,
-				power_rule->max_eirp);
+				power_rule->max_eirp,
+				cac_time);
 		else
-			pr_info("  (%d KHz - %d KHz @ %s), (N/A, %d mBm)\n",
+			pr_info("  (%d KHz - %d KHz @ %s), (N/A, %d mBm), (%s)\n",
 				freq_range->start_freq_khz,
 				freq_range->end_freq_khz,
 				bw,
-				power_rule->max_eirp);
+				power_rule->max_eirp,
+				cac_time);
 	}
 }
 
-- 
1.7.9.5

