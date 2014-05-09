Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f42.google.com ([74.125.83.42]:55725 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755866AbaEIIkm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 May 2014 04:40:42 -0400
Received: by mail-ee0-f42.google.com with SMTP id d49so2366113eek.15
        for <linux-wireless@vger.kernel.org>; Fri, 09 May 2014 01:40:41 -0700 (PDT)
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: wireless-regdb@lists.infradead.org
Cc: linux-wireless@vger.kernel.org, mcgrof@do-not-panic.com,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [PATCH] crda: add DFS CAC time support
Date: Fri,  9 May 2014 10:40:24 +0200
Message-Id: <1399624824-9204-2-git-send-email-janusz.dziedzic@tieto.com> (sfid-20140509_104058_160606_9DB31A5F)
In-Reply-To: <1399624824-9204-1-git-send-email-janusz.dziedzic@tieto.com>
References: <1399624824-9204-1-git-send-email-janusz.dziedzic@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add DFS CAC time support. Get this
value form regulatory.bin file.
Add parsers required by db2rd.

Change REGDB_VERSION while binary file
format was changed little bit (rule structure).

Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
---
 crda.c   |    3 ++
 regdb.h  |    5 ++-
 reglib.c |  149 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++---
 reglib.h |    1 +
 4 files changed, 150 insertions(+), 8 deletions(-)

diff --git a/crda.c b/crda.c
index 4751a39..0bf83a1 100644
--- a/crda.c
+++ b/crda.c
@@ -131,6 +131,9 @@ static int put_reg_rule(const struct ieee80211_reg_rule *rule, struct nl_msg *ms
 	NLA_PUT_U32(msg, NL80211_ATTR_POWER_RULE_MAX_ANT_GAIN,	power_rule->max_antenna_gain);
 	NLA_PUT_U32(msg, NL80211_ATTR_POWER_RULE_MAX_EIRP,	power_rule->max_eirp);
 
+	if (rule->dfs_cac_ms)
+		NLA_PUT_U32(msg, NL80211_ATTR_DFS_CAC_TIME,	rule->dfs_cac_ms);
+
 	return 0;
 
 nla_put_failure:
diff --git a/regdb.h b/regdb.h
index 3ffb781..e7b7ab6 100644
--- a/regdb.h
+++ b/regdb.h
@@ -21,7 +21,7 @@
  * to have some more magic. We still consider this to be
  * "Version 1" of the file.
  */
-#define REGDB_VERSION	19
+#define REGDB_VERSION	20
 
 /*
  * The signature at the end of the file is an RSA-signed
@@ -107,6 +107,7 @@ struct regdb_file_reg_rule {
 	uint32_t	power_rule_ptr; /* pointer to a struct regdb_file_power_rule */
 	/* rule flags using enum reg_rule_flags */
 	uint32_t flags;
+	uint32_t dfs_cac_ms;
 };
 
 struct regdb_file_reg_rules_collection {
@@ -143,7 +144,7 @@ static inline void check_db_binary_structs(void)
 	CHECK_STRUCT(regdb_file_header, 20);
 	CHECK_STRUCT(regdb_file_freq_range, 12);
 	CHECK_STRUCT(regdb_file_power_rule, 8);
-	CHECK_STRUCT(regdb_file_reg_rule, 12);
+	CHECK_STRUCT(regdb_file_reg_rule, 16);
 	CHECK_STRUCT(regdb_file_reg_rules_collection, 4);
 	CHECK_STRUCT(regdb_file_reg_country, 8);
 }
diff --git a/reglib.c b/reglib.c
index 3deca4a..beddecd 100644
--- a/reglib.c
+++ b/reglib.c
@@ -326,6 +326,7 @@ static void reg_rule2rd(uint8_t *db, size_t dblen,
 	rd_power_rule->max_eirp = ntohl(power->max_eirp);
 
 	rd_reg_rule->flags = ntohl(rule->flags);
+	rd_reg_rule->dfs_cac_ms = ntohl(rule->dfs_cac_ms);
 
 	if (rd_reg_rule->flags & RRF_NO_IR_ALL)
 		rd_reg_rule->flags |= RRF_NO_IR_ALL;
@@ -734,6 +735,9 @@ static void print_reg_rule(const struct ieee80211_reg_rule *rule)
 	else
 		printf("N/A)");
 
+	if ((rule->flags & RRF_DFS) && rule->dfs_cac_ms)
+		printf(", (%u)", rule->dfs_cac_ms);
+
 	if (rule->flags & RRF_NO_OFDM)
 		printf(", NO-OFDM");
 	if (rule->flags & RRF_NO_CCK)
@@ -826,6 +830,7 @@ reglib_parse_rule_simple(char *line, struct ieee80211_reg_rule *reg_rule)
 		REGLIB_DBM_TO_MBM(max_eirp);
 
 	reg_rule->flags = 0;
+	reg_rule->dfs_cac_ms = 0;
 
 	if (debug)
 		printf("reglib_parse_rule_simple(): %d line: %s", hits, line);
@@ -861,6 +866,7 @@ reglib_parse_rule_simple_mw(char *line, struct ieee80211_reg_rule *reg_rule)
 		REGLIB_MW_TO_MBM(max_eirp);
 
 	reg_rule->flags = 0;
+	reg_rule->dfs_cac_ms = 0;
 
 	if (debug)
 		printf("reglib_parse_rule_simple_mw(): %d line: %s",
@@ -920,6 +926,8 @@ reglib_parse_rule_args(char *line, struct ieee80211_reg_rule *reg_rule)
 	for (i = 0; i < 8; i++)
 		reg_rule->flags |= reglib_parse_rule_flag(flag_list[i]);
 
+	reg_rule->dfs_cac_ms = 0;
+
 	if (debug)
 		printf("reglib_parse_rule_args(): %d flags: %d, line: %s",
 		       hits, reg_rule->flags, line);
@@ -982,6 +990,8 @@ reglib_parse_rule_args_mw(char *line, struct ieee80211_reg_rule *reg_rule)
 	for (i = 0; i < 8; i++)
 		reg_rule->flags |= reglib_parse_rule_flag(flag_list[i]);
 
+	reg_rule->dfs_cac_ms = 0;
+
 	if (debug)
 		printf("reglib_parse_rule_args_mw(): %d flags: %d, line: %s",
 		       hits, reg_rule->flags, line);
@@ -989,6 +999,130 @@ reglib_parse_rule_args_mw(char *line, struct ieee80211_reg_rule *reg_rule)
 #undef IGNORE_COMMA_OR_SPACE
 }
 
+static int
+reglib_parse_rule_args_mw_cac(char *line, struct ieee80211_reg_rule *reg_rule)
+{
+#define IGNORE_COMMA_OR_SPACE "%*[ ,]"
+	int hits;
+	char flag_list[9][100];
+	unsigned int i = 0, dfs_cac_ms;
+	char mw[3];
+	float start_freq_khz, end_freq_khz, max_bandwidth_khz, max_eirp;
+
+	for (i = 0; i < 9; i++)
+		memset(flag_list[i], 0, sizeof(flag_list[i]));
+
+	hits = sscanf(line, "\t(%f - %f @ %f), (%f %2[mW]), (%u),"
+		      IGNORE_COMMA_OR_SPACE "%s"
+		      IGNORE_COMMA_OR_SPACE "%s"
+		      IGNORE_COMMA_OR_SPACE "%s"
+		      IGNORE_COMMA_OR_SPACE "%s"
+		      IGNORE_COMMA_OR_SPACE "%s"
+		      IGNORE_COMMA_OR_SPACE "%s"
+		      IGNORE_COMMA_OR_SPACE "%s"
+		      IGNORE_COMMA_OR_SPACE "%s"
+		      IGNORE_COMMA_OR_SPACE "%s",
+		      &start_freq_khz,
+		      &end_freq_khz,
+		      &max_bandwidth_khz,
+		      &max_eirp,
+		      mw,
+		      &dfs_cac_ms,
+		      flag_list[0],
+		      flag_list[1],
+		      flag_list[2],
+		      flag_list[3],
+		      flag_list[4],
+		      flag_list[5],
+		      flag_list[6],
+		      flag_list[7],
+		      flag_list[8]);
+
+	if (hits < 6)
+		return -EINVAL;
+
+	reg_rule->freq_range.start_freq_khz =
+		REGLIB_MHZ_TO_KHZ(start_freq_khz);
+	reg_rule->freq_range.end_freq_khz =
+		REGLIB_MHZ_TO_KHZ(end_freq_khz);
+	reg_rule->freq_range.max_bandwidth_khz =
+		REGLIB_MHZ_TO_KHZ(max_bandwidth_khz);
+	reg_rule->power_rule.max_eirp =
+		REGLIB_MW_TO_MBM(max_eirp);
+
+	for (i = 0; i < 8; i++)
+		reg_rule->flags |= reglib_parse_rule_flag(flag_list[i]);
+
+	reg_rule->dfs_cac_ms = dfs_cac_ms;
+
+	if (debug)
+		printf("reglib_parse_rule_args_mw_cac(): %d flags: %d, line: %s",
+		       hits, reg_rule->flags, line);
+	return 0;
+#undef IGNORE_COMMA_OR_SPACE
+}
+
+static int
+reglib_parse_rule_args_cac(char *line, struct ieee80211_reg_rule *reg_rule)
+{
+#define IGNORE_COMMA_OR_SPACE "%*[ ,]"
+	int hits;
+	char flag_list[9][100];
+	unsigned int i = 0, dfs_cac_ms;
+	float start_freq_khz, end_freq_khz, max_bandwidth_khz, max_eirp;
+
+	for (i = 0; i < 9; i++)
+		memset(flag_list[i], 0, sizeof(flag_list[i]));
+
+	hits = sscanf(line, "\t(%f - %f @ %f), (%f), (%u)"
+		      IGNORE_COMMA_OR_SPACE "%s"
+		      IGNORE_COMMA_OR_SPACE "%s"
+		      IGNORE_COMMA_OR_SPACE "%s"
+		      IGNORE_COMMA_OR_SPACE "%s"
+		      IGNORE_COMMA_OR_SPACE "%s"
+		      IGNORE_COMMA_OR_SPACE "%s"
+		      IGNORE_COMMA_OR_SPACE "%s"
+		      IGNORE_COMMA_OR_SPACE "%s"
+		      IGNORE_COMMA_OR_SPACE "%s",
+		      &start_freq_khz,
+		      &end_freq_khz,
+		      &max_bandwidth_khz,
+		      &max_eirp,
+		      &dfs_cac_ms,
+		      flag_list[0],
+		      flag_list[1],
+		      flag_list[2],
+		      flag_list[3],
+		      flag_list[4],
+		      flag_list[5],
+		      flag_list[6],
+		      flag_list[7],
+		      flag_list[8]);
+
+	if (hits < 6)
+		return -EINVAL;
+
+	reg_rule->freq_range.start_freq_khz =
+		REGLIB_MHZ_TO_KHZ(start_freq_khz);
+	reg_rule->freq_range.end_freq_khz =
+		REGLIB_MHZ_TO_KHZ(end_freq_khz);
+	reg_rule->freq_range.max_bandwidth_khz =
+		REGLIB_MHZ_TO_KHZ(max_bandwidth_khz);
+	reg_rule->power_rule.max_eirp =
+		REGLIB_DBM_TO_MBM(max_eirp);
+
+	for (i = 0; i < 8; i++)
+		reg_rule->flags |= reglib_parse_rule_flag(flag_list[i]);
+
+	reg_rule->dfs_cac_ms = dfs_cac_ms;
+
+	if (debug)
+		printf("reglib_parse_rule_args_cac(): %d flags: %d, line: %s",
+		       hits, reg_rule->flags, line);
+
+	return 0;
+#undef IGNORE_COMMA_OR_SPACE
+}
 static int reglib_parse_rule(FILE *fp, struct ieee80211_reg_rule *reg_rule)
 {
 	char line[1024];
@@ -997,24 +1131,27 @@ static int reglib_parse_rule(FILE *fp, struct ieee80211_reg_rule *reg_rule)
 	int r = 0;
 	struct reglib_rule_parse_list *reglib_rule_parsers;
 	size_t size_parsers = sizeof(struct reglib_rule_parse_list) + 
-				4 * sizeof(int (*)(char *, struct ieee80211_reg_rule *));
+				6 * sizeof(int (*)(char *, struct ieee80211_reg_rule *));
 
 	reglib_rule_parsers = malloc(size_parsers);
 	if (!reglib_rule_parsers)
 		return -EINVAL;
 	memset(reglib_rule_parsers, 0, size_parsers);
 
-	reglib_rule_parsers->n_parsers = 4;
+	reglib_rule_parsers->n_parsers = 6;
+
 
 	/*
 	 * XXX: sscanf() is a bit odd with picking up mW
 	 * case over the simple one, this order however works,
 	 * gotta figure out how to be more precise.
 	 */
-	reglib_rule_parsers->rule_parsers[0] = reglib_parse_rule_args_mw;
-	reglib_rule_parsers->rule_parsers[1] = reglib_parse_rule_args;
-	reglib_rule_parsers->rule_parsers[2] = reglib_parse_rule_simple;
-	reglib_rule_parsers->rule_parsers[3] = reglib_parse_rule_simple_mw;
+	reglib_rule_parsers->rule_parsers[0] = reglib_parse_rule_args_mw_cac;
+	reglib_rule_parsers->rule_parsers[1] = reglib_parse_rule_args_cac;
+	reglib_rule_parsers->rule_parsers[2] = reglib_parse_rule_args_mw;
+	reglib_rule_parsers->rule_parsers[3] = reglib_parse_rule_args;
+	reglib_rule_parsers->rule_parsers[4] = reglib_parse_rule_simple;
+	reglib_rule_parsers->rule_parsers[5] = reglib_parse_rule_simple_mw;
 
 	memset(line, 0, sizeof(line));
 	line_p = fgets(line, sizeof(line), fp);
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

