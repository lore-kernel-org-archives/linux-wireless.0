Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f43.google.com ([74.125.83.43]:45172 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751579AbaANR3r (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Jan 2014 12:29:47 -0500
Received: by mail-ee0-f43.google.com with SMTP id c41so369691eek.16
        for <linux-wireless@vger.kernel.org>; Tue, 14 Jan 2014 09:29:46 -0800 (PST)
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, mcgrof@do-not-panic.com,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [RFC 2/5] cfg80211: regulatory, introduce DFS CAC time
Date: Tue, 14 Jan 2014 18:29:27 +0100
Message-Id: <1389720570-2430-3-git-send-email-janusz.dziedzic@tieto.com> (sfid-20140114_182954_171058_94EDCCAD)
In-Reply-To: <1389720570-2430-1-git-send-email-janusz.dziedzic@tieto.com>
References: <1389720570-2430-1-git-send-email-janusz.dziedzic@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Introduce DFS CAC time as a regd param, configured
per REG_RULE and set per channel in cfg80211.

Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
---
 include/net/cfg80211.h   |    2 ++
 include/net/regulatory.h |   12 ++++++++++++
 net/wireless/reg.c       |   32 +++++++++++++++++++++++++++-----
 3 files changed, 41 insertions(+), 5 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index b1f84b0..64d7964 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -151,6 +151,7 @@ enum ieee80211_channel_flags {
  * @dfs_state: current state of this channel. Only relevant if radar is required
  *	on this channel.
  * @dfs_state_entered: timestamp (jiffies) when the dfs state was entered.
+ * @dfs_cac_ms: DFS CAC time in miliseconds
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
index c96a0b8..3819d1f 100644
--- a/include/net/regulatory.h
+++ b/include/net/regulatory.h
@@ -151,6 +151,7 @@ struct ieee80211_reg_rule {
 	struct ieee80211_freq_range freq_range;
 	struct ieee80211_power_rule power_rule;
 	u32 flags;
+	u32 dfs_cac_time;
 };
 
 struct ieee80211_regdomain {
@@ -178,4 +179,15 @@ struct ieee80211_regdomain {
 	.flags = reg_flags,				\
 }
 
+#define REG_RULE_DFS(start, end, bw, gain, eirp, dfs_cac, reg_flags)	\
+{									\
+	.freq_range.start_freq_khz = MHZ_TO_KHZ(start),			\
+	.freq_range.end_freq_khz = MHZ_TO_KHZ(end),			\
+	.freq_range.max_bandwidth_khz = MHZ_TO_KHZ(bw),			\
+	.power_rule.max_antenna_gain = DBI_TO_MBI(gain),		\
+	.power_rule.max_eirp = DBM_TO_MBM(eirp),			\
+	.flags = reg_flags,						\
+	.dfs_cac_time = dfs_cac,					\
+}
+
 #endif
diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 4414fa5..eafd17c 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -716,6 +716,11 @@ static int reg_rules_intersect(const struct ieee80211_reg_rule *rule1,
 
 	intersected_rule->flags = rule1->flags | rule2->flags;
 
+	if (rule1->dfs_cac_time > rule2->dfs_cac_time)
+		intersected_rule->dfs_cac_time = rule1->dfs_cac_time;
+	else
+		intersected_rule->dfs_cac_time = rule2->dfs_cac_time;
+
 	if (!is_valid_reg_rule(intersected_rule, 0, 1))
 		return -EINVAL;
 
@@ -1027,6 +1032,14 @@ static void handle_channel(struct wiphy *wiphy,
 		min_t(int, chan->orig_mag,
 		      MBI_TO_DBI(power_rule->max_antenna_gain));
 	chan->max_reg_power = (int) MBM_TO_DBM(power_rule->max_eirp);
+
+	if (chan->flags & IEEE80211_CHAN_RADAR) {
+		if (reg_rule->dfs_cac_time)
+			chan->dfs_cac_ms = reg_rule->dfs_cac_time * 1000;
+		else
+			chan->dfs_cac_ms = IEEE80211_DFS_MIN_CAC_TIME_MS;
+	}
+
 	if (chan->orig_mpwr) {
 		/*
 		 * Devices that use REGULATORY_COUNTRY_IE_FOLLOW_POWER
@@ -2195,31 +2208,40 @@ static void print_rd_rules(const struct ieee80211_regdomain *rd)
 	const struct ieee80211_reg_rule *reg_rule = NULL;
 	const struct ieee80211_freq_range *freq_range = NULL;
 	const struct ieee80211_power_rule *power_rule = NULL;
+	const int size = 20;
+	char cac_time[size];
 
-	pr_info("  (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)\n");
+	pr_info("  (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp), (dfs_cac_time)\n");
 
 	for (i = 0; i < rd->n_reg_rules; i++) {
 		reg_rule = &rd->reg_rules[i];
 		freq_range = &reg_rule->freq_range;
 		power_rule = &reg_rule->power_rule;
 
+		if (reg_rule->flags & NL80211_RRF_DFS)
+			scnprintf(cac_time, size, "(%u sec)",
+				  reg_rule->dfs_cac_time);
+		else
+			scnprintf(cac_time, size, "(N/A)");
 		/*
 		 * There may not be documentation for max antenna gain
 		 * in certain regions
 		 */
 		if (power_rule->max_antenna_gain)
-			pr_info("  (%d KHz - %d KHz @ %d KHz), (%d mBi, %d mBm)\n",
+			pr_info("  (%d KHz - %d KHz @ %d KHz), (%d mBi, %d mBm), %s\n",
 				freq_range->start_freq_khz,
 				freq_range->end_freq_khz,
 				freq_range->max_bandwidth_khz,
 				power_rule->max_antenna_gain,
-				power_rule->max_eirp);
+				power_rule->max_eirp,
+				cac_time);
 		else
-			pr_info("  (%d KHz - %d KHz @ %d KHz), (N/A, %d mBm)\n",
+			pr_info("  (%d KHz - %d KHz @ %d KHz), (N/A, %d mBm), %s\n",
 				freq_range->start_freq_khz,
 				freq_range->end_freq_khz,
 				freq_range->max_bandwidth_khz,
-				power_rule->max_eirp);
+				power_rule->max_eirp,
+				cac_time);
 	}
 }
 
-- 
1.7.9.5

