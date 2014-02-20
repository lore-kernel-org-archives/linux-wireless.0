Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f53.google.com ([74.125.83.53]:59364 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754518AbaBTMw0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Feb 2014 07:52:26 -0500
Received: by mail-ee0-f53.google.com with SMTP id t10so944136eei.12
        for <linux-wireless@vger.kernel.org>; Thu, 20 Feb 2014 04:52:25 -0800 (PST)
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, mcgrof@do-not-panic.com,
	linville@tuxdriver.com, Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [PATCH] cfg80211: regulatory, introduce NL80211_RRF_AUTO_BW rule flag
Date: Thu, 20 Feb 2014 13:52:16 +0100
Message-Id: <1392900736-2808-1-git-send-email-janusz.dziedzic@tieto.com> (sfid-20140220_135233_489113_530110B7)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Introduce NL80211_RRF_AUTO_BW rule flag. If this flag set
maximum available bandwidth should be calculated base on
contiguous rules and wider channels will be allowed to cross
multiple contiguous/overlapping frequency ranges.

In case of old kernels maximum bandwidth from regulatory
rule will be used, while there is no NL80211_RRF_AUTO_BW flag.

This extend patch:
cfg80211: regulatory introduce maximum bandwidth calculation

Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
---
 include/uapi/linux/nl80211.h |    9 ++---
 net/wireless/genregdb.awk    |    2 ++
 net/wireless/nl80211.c       |    7 ++--
 net/wireless/reg.c           |   76 ++++++++++++++++++++++++------------------
 4 files changed, 54 insertions(+), 40 deletions(-)

diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index ba1f762..bd2cb58 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -2437,10 +2437,7 @@ enum nl80211_reg_type {
  * 	in KHz. This is not a center a frequency but an actual regulatory
  * 	band edge.
  * @NL80211_ATTR_FREQ_RANGE_MAX_BW: maximum allowed bandwidth for this
- *	frequency range, in KHz. If not present or 0, maximum available
- *	bandwidth should be calculated base on contiguous rules and wider
- *	channels will be allowed to cross multiple contiguous/overlapping
- *	frequency ranges.
+ *	frequency range, in KHz.
  * @NL80211_ATTR_POWER_RULE_MAX_ANT_GAIN: the maximum allowed antenna gain
  * 	for a given frequency range. The value is in mBi (100 * dBi).
  * 	If you don't have one then don't send this.
@@ -2511,6 +2508,9 @@ enum nl80211_sched_scan_match_attr {
  * @NL80211_RRF_NO_IR: no mechanisms that initiate radiation are allowed,
  * 	this includes probe requests or modes of operation that require
  * 	beaconing.
+ * @NL80211_RRF_AUTO_BW: maximum available bandwidth should be calculated
+ *	base on contiguous rules and wider channels will be allowed to cross
+ *	multiple contiguous/overlapping frequency ranges.
  */
 enum nl80211_reg_rule_flags {
 	NL80211_RRF_NO_OFDM		= 1<<0,
@@ -2522,6 +2522,7 @@ enum nl80211_reg_rule_flags {
 	NL80211_RRF_PTMP_ONLY		= 1<<6,
 	NL80211_RRF_NO_IR		= 1<<7,
 	__NL80211_RRF_NO_IBSS		= 1<<8,
+	NL80211_RRF_AUTO_BW		= 1<<9,
 };
 
 #define NL80211_RRF_PASSIVE_SCAN	NL80211_RRF_NO_IR
diff --git a/net/wireless/genregdb.awk b/net/wireless/genregdb.awk
index 9a8217d..fdfd3f0 100644
--- a/net/wireless/genregdb.awk
+++ b/net/wireless/genregdb.awk
@@ -105,6 +105,8 @@ function parse_reg_rule()
 			flags = flags "\n\t\t\tNL80211_RRF_NO_IR | "
 		} else if (flagarray[arg] == "NO-IR") {
 			flags = flags "\n\t\t\tNL80211_RRF_NO_IR | "
+		} else if (flagarray[arg] == "AUTO-BW") {
+			flags = flags "\n\t\t\tNL80211_RRF_AUTO_BW | "
 		}
 
 	}
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 1797864..71a1fdb 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -4626,6 +4626,8 @@ static int parse_reg_rule(struct nlattr *tb[],
 		return -EINVAL;
 	if (!tb[NL80211_ATTR_FREQ_RANGE_END])
 		return -EINVAL;
+	if (!tb[NL80211_ATTR_FREQ_RANGE_MAX_BW])
+		return -EINVAL;
 	if (!tb[NL80211_ATTR_POWER_RULE_MAX_EIRP])
 		return -EINVAL;
 
@@ -4635,9 +4637,8 @@ static int parse_reg_rule(struct nlattr *tb[],
 		nla_get_u32(tb[NL80211_ATTR_FREQ_RANGE_START]);
 	freq_range->end_freq_khz =
 		nla_get_u32(tb[NL80211_ATTR_FREQ_RANGE_END]);
-	if (tb[NL80211_ATTR_FREQ_RANGE_MAX_BW])
-		freq_range->max_bandwidth_khz =
-			nla_get_u32(tb[NL80211_ATTR_FREQ_RANGE_MAX_BW]);
+	freq_range->max_bandwidth_khz =
+		nla_get_u32(tb[NL80211_ATTR_FREQ_RANGE_MAX_BW]);
 
 	power_rule->max_eirp =
 		nla_get_u32(tb[NL80211_ATTR_POWER_RULE_MAX_EIRP]);
diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 27c5253..7e09b4e 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -563,9 +563,6 @@ unsigned int reg_get_max_bandwidth(const struct ieee80211_regdomain *rd,
 		if (freq_range_tmp->end_freq_khz < freq_range->start_freq_khz)
 			break;
 
-		if (freq_range_tmp->max_bandwidth_khz)
-			break;
-
 		freq_range = freq_range_tmp;
 	}
 
@@ -582,9 +579,6 @@ unsigned int reg_get_max_bandwidth(const struct ieee80211_regdomain *rd,
 		if (freq_range_tmp->start_freq_khz > freq_range->end_freq_khz)
 			break;
 
-		if (freq_range_tmp->max_bandwidth_khz)
-			break;
-
 		freq_range = freq_range_tmp;
 	}
 
@@ -729,21 +723,29 @@ static int reg_rules_intersect(const struct ieee80211_regdomain *rd1,
 	max_bandwidth1 = freq_range1->max_bandwidth_khz;
 	max_bandwidth2 = freq_range2->max_bandwidth_khz;
 
-	/*
-	 * In case max_bandwidth1 == 0 and max_bandwith2 == 0 set
-	 * output bandwidth as 0 (auto calculation). Next we will
-	 * calculate this correctly in handle_channel function.
-	 * In other case calculate output bandwidth here.
-	 */
-	if (max_bandwidth1 || max_bandwidth2) {
-		if (!max_bandwidth1)
-			max_bandwidth1 = reg_get_max_bandwidth(rd1, rule1);
-		if (!max_bandwidth2)
-			max_bandwidth2 = reg_get_max_bandwidth(rd2, rule2);
-	}
+	if (rule1->flags & NL80211_RRF_AUTO_BW)
+		max_bandwidth1 = reg_get_max_bandwidth(rd1, rule1);
+	if (rule2->flags & NL80211_RRF_AUTO_BW)
+		max_bandwidth2 = reg_get_max_bandwidth(rd2, rule2);
 
 	freq_range->max_bandwidth_khz = min(max_bandwidth1, max_bandwidth2);
 
+	intersected_rule->flags = rule1->flags | rule2->flags;
+
+	/*
+	 * In case NL80211_RRF_AUTO_BW requested for both rules
+	 * set AUTO_BW in intersected rule also. Next we will
+	 * calculate BW correctly in handle_channel function.
+	 * In other case remove AUTO_BW flag while we calculate
+	 * maximum bandwidth correctly and auto calculation is
+	 * not required.
+	 */
+	if ((rule1->flags & NL80211_RRF_AUTO_BW) &&
+	    (rule2->flags & NL80211_RRF_AUTO_BW))
+		intersected_rule->flags |= NL80211_RRF_AUTO_BW;
+	else
+		intersected_rule->flags &= ~NL80211_RRF_AUTO_BW;
+
 	freq_diff = freq_range->end_freq_khz - freq_range->start_freq_khz;
 	if (freq_range->max_bandwidth_khz > freq_diff)
 		freq_range->max_bandwidth_khz = freq_diff;
@@ -753,8 +755,6 @@ static int reg_rules_intersect(const struct ieee80211_regdomain *rd1,
 	power_rule->max_antenna_gain = min(power_rule1->max_antenna_gain,
 		power_rule2->max_antenna_gain);
 
-	intersected_rule->flags = rule1->flags | rule2->flags;
-
 	if (!is_valid_reg_rule(intersected_rule))
 		return -EINVAL;
 
@@ -938,12 +938,13 @@ const char *reg_initiator_name(enum nl80211_reg_initiator initiator)
 EXPORT_SYMBOL(reg_initiator_name);
 
 #ifdef CONFIG_CFG80211_REG_DEBUG
-static void chan_reg_rule_print_dbg(struct ieee80211_channel *chan,
+static void chan_reg_rule_print_dbg(const struct ieee80211_regdomain *regd,
+				    struct ieee80211_channel *chan,
 				    const struct ieee80211_reg_rule *reg_rule)
 {
 	const struct ieee80211_power_rule *power_rule;
 	const struct ieee80211_freq_range *freq_range;
-	char max_antenna_gain[32];
+	char max_antenna_gain[32], bw[32];
 
 	power_rule = &reg_rule->power_rule;
 	freq_range = &reg_rule->freq_range;
@@ -953,16 +954,25 @@ static void chan_reg_rule_print_dbg(struct ieee80211_channel *chan,
 	else
 		snprintf(max_antenna_gain, 32, "%d", power_rule->max_antenna_gain);
 
+	if (reg_rule->flags & NL80211_RRF_AUTO_BW)
+		snprintf(bw, 32, "%d KHz, %d KHz AUTO",
+			 freq_range->max_bandwidth_khz,
+			 reg_get_max_bandwidth(regd, reg_rule));
+	else
+		snprintf(bw, 32, "%d KHz",
+			 freq_range->max_bandwidth_khz);
+
 	REG_DBG_PRINT("Updating information on frequency %d MHz with regulatory rule:\n",
 		      chan->center_freq);
 
-	REG_DBG_PRINT("%d KHz - %d KHz @ %d KHz), (%s mBi, %d mBm)\n",
+	REG_DBG_PRINT("%d KHz - %d KHz @ %s), (%s mBi, %d mBm)\n",
 		      freq_range->start_freq_khz, freq_range->end_freq_khz,
-		      freq_range->max_bandwidth_khz, max_antenna_gain,
+		      bw, max_antenna_gain,
 		      power_rule->max_eirp);
 }
 #else
-static void chan_reg_rule_print_dbg(struct ieee80211_channel *chan,
+static void chan_reg_rule_print_dbg(const struct ieee80211_regdomain *regd,
+				    struct ieee80211_channel *chan,
 				    const struct ieee80211_reg_rule *reg_rule)
 {
 	return;
@@ -1022,17 +1032,16 @@ static void handle_channel(struct wiphy *wiphy,
 		return;
 	}
 
-	chan_reg_rule_print_dbg(chan, reg_rule);
+	regd = reg_get_regdomain(wiphy);
+	chan_reg_rule_print_dbg(regd, chan, reg_rule);
 
 	power_rule = &reg_rule->power_rule;
 	freq_range = &reg_rule->freq_range;
 
 	max_bandwidth_khz = freq_range->max_bandwidth_khz;
 	/* Check if auto calculation requested */
-	if (!max_bandwidth_khz) {
-		regd = reg_get_regdomain(wiphy);
+	if (reg_rule->flags & NL80211_RRF_AUTO_BW)
 		max_bandwidth_khz = reg_get_max_bandwidth(regd, reg_rule);
-	}
 
 	if (max_bandwidth_khz < MHZ_TO_KHZ(40))
 		bw_flags = IEEE80211_CHAN_NO_HT40;
@@ -1437,14 +1446,14 @@ static void handle_channel_custom(struct wiphy *wiphy,
 		return;
 	}
 
-	chan_reg_rule_print_dbg(chan, reg_rule);
+	chan_reg_rule_print_dbg(regd, chan, reg_rule);
 
 	power_rule = &reg_rule->power_rule;
 	freq_range = &reg_rule->freq_range;
 
 	max_bandwidth_khz = freq_range->max_bandwidth_khz;
 	/* Check if auto calculation requested */
-	if (!max_bandwidth_khz)
+	if (reg_rule->flags & NL80211_RRF_AUTO_BW)
 		max_bandwidth_khz = reg_get_max_bandwidth(regd, reg_rule);
 
 	if (max_bandwidth_khz < MHZ_TO_KHZ(40))
@@ -2254,8 +2263,9 @@ static void print_rd_rules(const struct ieee80211_regdomain *rd)
 		freq_range = &reg_rule->freq_range;
 		power_rule = &reg_rule->power_rule;
 
-		if (!freq_range->max_bandwidth_khz)
-			snprintf(bw, 32, "%d KHz, AUTO",
+		if (reg_rule->flags & NL80211_RRF_AUTO_BW)
+			snprintf(bw, 32, "%d KHz, %d KHz AUTO",
+				 freq_range->max_bandwidth_khz,
 				 reg_get_max_bandwidth(rd, reg_rule));
 		else
 			snprintf(bw, 32, "%d KHz",
-- 
1.7.9.5

