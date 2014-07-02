Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:57299 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750991AbaGBMCZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Jul 2014 08:02:25 -0400
Received: by mail-wi0-f182.google.com with SMTP id bs8so340444wib.9
        for <linux-wireless@vger.kernel.org>; Wed, 02 Jul 2014 05:02:24 -0700 (PDT)
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: wireless-regdb@lists.infradead.org
Cc: mcgrof@do-not-panic.com, linux-wireless@vger.kernel.org,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [PATCH] crda: db2rd, parse/print CAC time
Date: Wed,  2 Jul 2014 14:02:11 +0200
Message-Id: <1404302531-18132-1-git-send-email-janusz.dziedzic@tieto.com> (sfid-20140702_140229_557834_ECB6BE08)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

db2rd, parse and print DFS CAC time

Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
---
 crda.c   |    3 +++
 reglib.c |   15 ++++++++++++++-
 reglib.h |    1 +
 3 files changed, 18 insertions(+), 1 deletion(-)

diff --git a/crda.c b/crda.c
index 4751a39..f40131f 100644
--- a/crda.c
+++ b/crda.c
@@ -131,6 +131,9 @@ static int put_reg_rule(const struct ieee80211_reg_rule *rule, struct nl_msg *ms
 	NLA_PUT_U32(msg, NL80211_ATTR_POWER_RULE_MAX_ANT_GAIN,	power_rule->max_antenna_gain);
 	NLA_PUT_U32(msg, NL80211_ATTR_POWER_RULE_MAX_EIRP,	power_rule->max_eirp);
 
+	if (rule->dfs_cac_ms)
+		NLA_PUT_U32(msg, NL80211_ATTR_DFS_CAC_TIME, rule->dfs_cac_ms);
+
 	return 0;
 
 nla_put_failure:
diff --git a/reglib.c b/reglib.c
index 6db3e75..e00e9b8 100644
--- a/reglib.c
+++ b/reglib.c
@@ -723,6 +723,11 @@ static void print_reg_rule(const struct ieee80211_reg_rule *rule)
 	else
 		printf("N/A)");
 
+	if (rule->dfs_cac_ms)
+		printf(", (%u)", rule->dfs_cac_ms);
+	else
+		printf(", (N/A)");
+
 	if (rule->flags & RRF_NO_OFDM)
 		printf(", NO-OFDM");
 	if (rule->flags & RRF_NO_CCK)
@@ -801,6 +806,7 @@ static int reglib_parse_rule(FILE *fp, struct ieee80211_reg_rule *reg_rule)
 	char *line_p;
 	int hits, r = 0;
 	float start_freq_khz, end_freq_khz, max_bandwidth_khz, max_eirp;
+	unsigned int dfs_cac_ms = 0;
 
 	memset(line, 0, sizeof(line));
 	line_p = fgets(line, sizeof(line), fp);
@@ -846,8 +852,15 @@ static int reglib_parse_rule(FILE *fp, struct ieee80211_reg_rule *reg_rule)
 
 	/* Next get optional arguments (flags ...) */
 	strsep(&line_p, ",");
-	if (line_p)
+	if (line_p) {
+		/* Check DFS CAC time */
+		hits = sscanf(line_p, " (%u)", &dfs_cac_ms);
+		if (hits == 1)
+			reg_rule->dfs_cac_ms = dfs_cac_ms;
+
+		/* Check flags */
 		reg_rule->flags = reglib_parse_rule_flag(line_p);
+	}
 
 	return r;
 }
diff --git a/reglib.h b/reglib.h
index afd5ef6..77aa42a 100644
--- a/reglib.h
+++ b/reglib.h
@@ -28,6 +28,7 @@ struct ieee80211_reg_rule {
 	struct ieee80211_freq_range freq_range;
 	struct ieee80211_power_rule power_rule;
 	uint32_t flags;
+	uint32_t dfs_cac_ms;
 };
 
 struct ieee80211_regdomain {
-- 
1.7.9.5

