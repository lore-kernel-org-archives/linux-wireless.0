Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44581 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751732Ab2LDOtK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Dec 2012 09:49:10 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [RFC v2 18/18] regulatory: allow arbitrary channel widths
Date: Tue,  4 Dec 2012 15:49:00 +0100
Message-Id: <1354632540-21207-19-git-send-email-johannes@sipsolutions.net> (sfid-20121204_154915_471388_649524BB)
In-Reply-To: <1354632540-21207-1-git-send-email-johannes@sipsolutions.net>
References: <1354632540-21207-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

There aren't any channel width restrictions in the
2.4 GHz band (except the natural ones by the (sub)band
boundaries), nor do default restrictions in the 5 GHz
band make sense when limited to passive scan/no IBSS
etc.

Allow passing NL80211_NO_REG_BANDWIDTH_LIMIT as the
max_bandwidth_khz and make that mean no restrictions.
Use it for the default world roaming regdomain.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/regulatory.h     |  5 ++-
 include/uapi/linux/nl80211.h |  4 ++-
 net/wireless/reg.c           | 77 +++++++++++++++++++++++---------------------
 3 files changed, 48 insertions(+), 38 deletions(-)

diff --git a/include/net/regulatory.h b/include/net/regulatory.h
index 7dcaa27..9414a8f 100644
--- a/include/net/regulatory.h
+++ b/include/net/regulatory.h
@@ -118,7 +118,10 @@ struct ieee80211_regdomain {
 {							\
 	.freq_range.start_freq_khz = MHZ_TO_KHZ(start),	\
 	.freq_range.end_freq_khz = MHZ_TO_KHZ(end),	\
-	.freq_range.max_bandwidth_khz = MHZ_TO_KHZ(bw),	\
+	.freq_range.max_bandwidth_khz =			\
+		(bw) == NL80211_NO_REG_BANDWIDTH_LIMIT ?\
+			NL80211_NO_REG_BANDWIDTH_LIMIT :\
+			MHZ_TO_KHZ(bw),			\
 	.power_rule.max_antenna_gain = DBI_TO_MBI(gain),\
 	.power_rule.max_eirp = DBM_TO_MBM(eirp),	\
 	.flags = reg_flags,				\
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 5470171..331cfb3 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -2070,7 +2070,7 @@ enum nl80211_reg_type {
  * 	in KHz. This is not a center a frequency but an actual regulatory
  * 	band edge.
  * @NL80211_ATTR_FREQ_RANGE_MAX_BW: maximum allowed bandwidth for this
- * 	frequency range, in KHz.
+ * 	frequency range, in KHz, or %NL80211_NO_REG_BANDWIDTH_LIMIT.
  * @NL80211_ATTR_POWER_RULE_MAX_ANT_GAIN: the maximum allowed antenna gain
  * 	for a given frequency range. The value is in mBi (100 * dBi).
  * 	If you don't have one then don't send this.
@@ -2096,6 +2096,8 @@ enum nl80211_reg_rule_attr {
 	NL80211_REG_RULE_ATTR_MAX = __NL80211_REG_RULE_ATTR_AFTER_LAST - 1
 };
 
+#define NL80211_NO_REG_BANDWIDTH_LIMIT	0xffffffff
+
 /**
  * enum nl80211_sched_scan_match_attr - scheduled scan match attributes
  * @__NL80211_SCHED_SCAN_MATCH_ATTR_INVALID: attribute number 0 is reserved
diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 4e0ccad..5deb60c 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -146,29 +146,29 @@ static const struct ieee80211_regdomain world_regdom = {
 	.alpha2 =  "00",
 	.reg_rules = {
 		/* IEEE 802.11b/g, channels 1..11 */
-		REG_RULE(2412-10, 2462+10, 40, 6, 20, 0),
-		/* IEEE 802.11b/g, channels 12..13. No HT40
-		 * channel fits here. */
-		REG_RULE(2467-10, 2472+10, 20, 6, 20,
-			NL80211_RRF_PASSIVE_SCAN |
-			NL80211_RRF_NO_IBSS),
+		REG_RULE(2412-10, 2462+10, NL80211_NO_REG_BANDWIDTH_LIMIT,
+			 6, 20, 0),
+		/* IEEE 802.11b/g, channels 12..13. */
+		REG_RULE(2467-10, 2472+10, NL80211_NO_REG_BANDWIDTH_LIMIT,
+			 6, 20, NL80211_RRF_PASSIVE_SCAN |
+				NL80211_RRF_NO_IBSS),
 		/* IEEE 802.11 channel 14 - Only JP enables
 		 * this and for 802.11b only */
-		REG_RULE(2484-10, 2484+10, 20, 6, 20,
-			NL80211_RRF_PASSIVE_SCAN |
-			NL80211_RRF_NO_IBSS |
-			NL80211_RRF_NO_OFDM),
+		REG_RULE(2484-10, 2484+10, NL80211_NO_REG_BANDWIDTH_LIMIT,
+			 6, 20, NL80211_RRF_PASSIVE_SCAN |
+				NL80211_RRF_NO_IBSS |
+				NL80211_RRF_NO_OFDM),
 		/* IEEE 802.11a, channel 36..48 */
-		REG_RULE(5180-10, 5240+10, 40, 6, 20,
-                        NL80211_RRF_PASSIVE_SCAN |
-                        NL80211_RRF_NO_IBSS),
+		REG_RULE(5180-10, 5240+10, NL80211_NO_REG_BANDWIDTH_LIMIT,
+			 6, 20, NL80211_RRF_PASSIVE_SCAN |
+				NL80211_RRF_NO_IBSS),
 
 		/* NB: 5260 MHz - 5700 MHz requies DFS */
 
 		/* IEEE 802.11a, channel 149..165 */
-		REG_RULE(5745-10, 5825+10, 40, 6, 20,
-			NL80211_RRF_PASSIVE_SCAN |
-			NL80211_RRF_NO_IBSS),
+		REG_RULE(5745-10, 5825+10, NL80211_NO_REG_BANDWIDTH_LIMIT,
+			 6, 20, NL80211_RRF_PASSIVE_SCAN |
+				NL80211_RRF_NO_IBSS),
 
 		/* IEEE 802.11ad (60gHz), channels 1..3 */
 		REG_RULE(56160+2160*1-1080, 56160+2160*3+1080, 2160, 0, 0, 0),
@@ -453,8 +453,13 @@ static bool is_valid_reg_rule(const struct ieee80211_reg_rule *rule)
 
 	freq_diff = freq_range->end_freq_khz - freq_range->start_freq_khz;
 
-	if (freq_range->end_freq_khz <= freq_range->start_freq_khz ||
-	    freq_range->max_bandwidth_khz > freq_diff)
+	if (freq_range->end_freq_khz <= freq_range->start_freq_khz)
+		return false;
+
+	if (freq_range->max_bandwidth_khz == NL80211_NO_REG_BANDWIDTH_LIMIT)
+		return true;
+
+	if (freq_range->max_bandwidth_khz > freq_diff)
 		return false;
 
 	return true;
@@ -559,7 +564,8 @@ static int reg_rules_intersect(const struct ieee80211_reg_rule *rule1,
 					    freq_range2->max_bandwidth_khz);
 
 	freq_diff = freq_range->end_freq_khz - freq_range->start_freq_khz;
-	if (freq_range->max_bandwidth_khz > freq_diff)
+	if (freq_range->max_bandwidth_khz != NL80211_NO_REG_BANDWIDTH_LIMIT &&
+	    freq_range->max_bandwidth_khz > freq_diff)
 		freq_range->max_bandwidth_khz = freq_diff;
 
 	power_rule->max_eirp = min(power_rule1->max_eirp,
@@ -789,7 +795,7 @@ static void chan_reg_rule_print_dbg(struct ieee80211_channel *chan,
 	REG_DBG_PRINT("Updating information on frequency %d MHz with regulatory rule:\n",
 		      chan->center_freq);
 
-	REG_DBG_PRINT("%d KHz - %d KHz @ %d KHz), (%s mBi, %d mBm)\n",
+	REG_DBG_PRINT("%d KHz - %d KHz @ %u KHz), (%s mBi, %d mBm)\n",
 		      freq_range->start_freq_khz, freq_range->end_freq_khz,
 		      freq_range->max_bandwidth_khz, max_antenna_gain,
 		      power_rule->max_eirp);
@@ -1950,27 +1956,26 @@ static void print_rd_rules(const struct ieee80211_regdomain *rd)
 	pr_info("  (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)\n");
 
 	for (i = 0; i < rd->n_reg_rules; i++) {
+		char bandwidth[20] = "";
+		char max_ag[20] = "N/A";
+
 		reg_rule = &rd->reg_rules[i];
 		freq_range = &reg_rule->freq_range;
 		power_rule = &reg_rule->power_rule;
 
-		/*
-		 * There may not be documentation for max antenna gain
-		 * in certain regions
-		 */
+		if (freq_range->max_bandwidth_khz != NL80211_NO_REG_BANDWIDTH_LIMIT)
+			snprintf(bandwidth, sizeof(bandwidth),
+				 " @ %u KHz", freq_range->max_bandwidth_khz);
+
 		if (power_rule->max_antenna_gain)
-			pr_info("  (%d KHz - %d KHz @ %d KHz), (%d mBi, %d mBm)\n",
-				freq_range->start_freq_khz,
-				freq_range->end_freq_khz,
-				freq_range->max_bandwidth_khz,
-				power_rule->max_antenna_gain,
-				power_rule->max_eirp);
-		else
-			pr_info("  (%d KHz - %d KHz @ %d KHz), (N/A, %d mBm)\n",
-				freq_range->start_freq_khz,
-				freq_range->end_freq_khz,
-				freq_range->max_bandwidth_khz,
-				power_rule->max_eirp);
+			snprintf(max_ag, sizeof(max_ag),
+				 "%u mBi", power_rule->max_antenna_gain);
+
+		pr_info("  (%d KHz - %d KHz%s), (%s, %d mBm)\n",
+			freq_range->start_freq_khz,
+			freq_range->end_freq_khz,
+			bandwidth, max_ag,
+			power_rule->max_eirp);
 	}
 }
 
-- 
1.8.0

