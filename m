Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:62487 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750920AbaFLGgO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Jun 2014 02:36:14 -0400
Received: by mail-wi0-f172.google.com with SMTP id hi2so6964607wib.5
        for <linux-wireless@vger.kernel.org>; Wed, 11 Jun 2014 23:36:12 -0700 (PDT)
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: wireless-regdb@lists.infradead.org
Cc: mcgrof@do-not-panic.com, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [PATCH v2] crda: simplify text parsing for country/rules
Date: Thu, 12 Jun 2014 08:35:38 +0200
Message-Id: <1402554938-4495-1-git-send-email-janusz.dziedzic@tieto.com> (sfid-20140612_083618_097354_9AC69959)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove strange parsers.

Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
---
*V2: rebased on master

 reglib.c |  355 +++++++++++---------------------------------------------------
 1 file changed, 62 insertions(+), 293 deletions(-)

diff --git a/reglib.c b/reglib.c
index 3deca4a..6db3e75 100644
--- a/reglib.c
+++ b/reglib.c
@@ -40,17 +40,6 @@
 
 int debug = 0;
 
-struct reglib_rule_parse_list {
-	int n_parsers;
-	int (*rule_parsers[])(char *line, struct ieee80211_reg_rule *reg_rule);
-};
-
-struct reglib_country_parse_list {
-	int n_parsers;
-	int (*country_parsers[])(char *line, struct ieee80211_regdomain *rd);
-};
-
-
 void *
 reglib_get_file_ptr(uint8_t *db, size_t dblen, size_t structlen, uint32_t ptr)
 {
@@ -768,206 +757,63 @@ void reglib_print_regdom(const struct ieee80211_regdomain *rd)
 
 static unsigned int reglib_parse_dfs_region(char *dfs_region)
 {
-	if (strncmp(dfs_region, "DFS-FCC", 7) == 0)
+	if (!dfs_region)
+		return REGDB_DFS_UNSET;
+
+	if (strstr(dfs_region, "DFS-FCC"))
 		return REGDB_DFS_FCC;
-	if (strncmp(dfs_region, "DFS-ETSI", 8) == 0)
+	if (strstr(dfs_region, "DFS-ETSI"))
 		return REGDB_DFS_ETSI;
-	if (strncmp(dfs_region, "DFS-JP", 6) == 0)
+	if (strstr(dfs_region, "DFS-JP"))
 		return REGDB_DFS_JP;
 	return REGDB_DFS_UNSET;
 }
 
 static uint32_t reglib_parse_rule_flag(char *flag_s)
 {
-	if (strncmp(flag_s, "NO-OFDM", 7) == 0)
-		return RRF_NO_OFDM;
-	if (strncmp(flag_s, "NO-CCK", 6) == 0)
-		return RRF_NO_CCK;
-	if (strncmp(flag_s, "NO-INDOOR", 9) == 0)
-		return RRF_NO_INDOOR;
-	if (strncmp(flag_s, "NO-OUTDOOR", 10) == 0)
-		return RRF_NO_OUTDOOR;
-	if (strncmp(flag_s, "DFS", 3) == 0)
-		return RRF_DFS;
-	if (strncmp(flag_s, "PTP-ONLY", 8) == 0)
-		return RRF_PTP_ONLY;
-	if (strncmp(flag_s, "PTMP-ONLY", 9) == 0)
-		return RRF_PTMP_ONLY;
-	if (strncmp(flag_s, "NO-IR", 5) == 0)
-		return RRF_NO_IR;
-	if (strncmp(flag_s, "AUTO-BW", 7) == 0)
-		return RRF_AUTO_BW;
-
-	return 0;
-}
-
-static int
-reglib_parse_rule_simple(char *line, struct ieee80211_reg_rule *reg_rule)
-{
-	int hits;
-	float start_freq_khz, end_freq_khz, max_bandwidth_khz, max_eirp;
-
-	hits = sscanf(line, "\t(%f - %f @ %f), (%f)\n",
-		      &start_freq_khz,
-		      &end_freq_khz,
-		      &max_bandwidth_khz,
-		      &max_eirp);
-
-	if (hits != 4)
-		return -EINVAL;
-
-	reg_rule->freq_range.start_freq_khz =
-		REGLIB_MHZ_TO_KHZ(start_freq_khz);
-	reg_rule->freq_range.end_freq_khz =
-		REGLIB_MHZ_TO_KHZ(end_freq_khz);
-	reg_rule->freq_range.max_bandwidth_khz =
-		REGLIB_MHZ_TO_KHZ(max_bandwidth_khz);
-	reg_rule->power_rule.max_eirp =
-		REGLIB_DBM_TO_MBM(max_eirp);
-
-	reg_rule->flags = 0;
-
-	if (debug)
-		printf("reglib_parse_rule_simple(): %d line: %s", hits, line);
-
-
-	return 0;
+	uint32_t flags = 0;
+
+	if (strstr(flag_s, "NO-OFDM"))
+		flags |= RRF_NO_OFDM;
+	if (strstr(flag_s, "NO-CCK"))
+		flags |= RRF_NO_CCK;
+	if (strstr(flag_s, "NO-INDOOR"))
+		flags |= RRF_NO_INDOOR;
+	if (strstr(flag_s, "NO-OUTDOOR"))
+		flags |= RRF_NO_OUTDOOR;
+	if (strstr(flag_s, "DFS"))
+		flags |= RRF_DFS;
+	if (strstr(flag_s, "PTP-ONLY"))
+		flags |= RRF_PTP_ONLY;
+	if (strstr(flag_s, "PTMP-ONLY"))
+		flags |= RRF_PTMP_ONLY;
+	if (strstr(flag_s, "NO-IR"))
+		flags |= RRF_NO_IR;
+	if (strstr(flag_s, "AUTO-BW"))
+		flags |= RRF_AUTO_BW;
+
+	return flags;
 }
 
-static int
-reglib_parse_rule_simple_mw(char *line, struct ieee80211_reg_rule *reg_rule)
+static int reglib_parse_rule(FILE *fp, struct ieee80211_reg_rule *reg_rule)
 {
-	int hits;
+	char line[1024];
+	char *line_p;
+	int hits, r = 0;
 	float start_freq_khz, end_freq_khz, max_bandwidth_khz, max_eirp;
-	char mw[3];
-
-	hits = sscanf(line, "\t(%f - %f @ %f), (%f %2[mW])\n",
-		      &start_freq_khz,
-		      &end_freq_khz,
-		      &max_bandwidth_khz,
-		      &max_eirp, mw);
 
-	if (hits != 4)
+	memset(line, 0, sizeof(line));
+	line_p = fgets(line, sizeof(line), fp);
+	if (line_p != line)
 		return -EINVAL;
 
-
-	reg_rule->freq_range.start_freq_khz =
-		REGLIB_MHZ_TO_KHZ(start_freq_khz);
-	reg_rule->freq_range.end_freq_khz =
-		REGLIB_MHZ_TO_KHZ(end_freq_khz);
-	reg_rule->freq_range.max_bandwidth_khz =
-		REGLIB_MHZ_TO_KHZ(max_bandwidth_khz);
-	reg_rule->power_rule.max_eirp =
-		REGLIB_MW_TO_MBM(max_eirp);
-
-	reg_rule->flags = 0;
-
-	if (debug)
-		printf("reglib_parse_rule_simple_mw(): %d line: %s",
-		       hits, line);
-
-	return 0;
-}
-
-static int
-reglib_parse_rule_args(char *line, struct ieee80211_reg_rule *reg_rule)
-{
-#define IGNORE_COMMA_OR_SPACE "%*[ ,]"
-	int hits;
-	char flag_list[9][100];
-	unsigned int i = 0;
-	float start_freq_khz, end_freq_khz, max_bandwidth_khz, max_eirp;
-
-	for (i = 0; i < 9; i++)
-		memset(flag_list[i], 0, sizeof(flag_list[i]));
-
-	hits = sscanf(line, "\t(%f - %f @ %f), (%f)"
-		      IGNORE_COMMA_OR_SPACE "%s"
-		      IGNORE_COMMA_OR_SPACE "%s"
-		      IGNORE_COMMA_OR_SPACE "%s"
-		      IGNORE_COMMA_OR_SPACE "%s"
-		      IGNORE_COMMA_OR_SPACE "%s"
-		      IGNORE_COMMA_OR_SPACE "%s"
-		      IGNORE_COMMA_OR_SPACE "%s"
-		      IGNORE_COMMA_OR_SPACE "%s"
-		      IGNORE_COMMA_OR_SPACE "%s",
+	/* First get start, end and bandwidth */
+	hits = sscanf(line_p, "\t(%f - %f @ %f),",
 		      &start_freq_khz,
 		      &end_freq_khz,
-		      &max_bandwidth_khz,
-		      &max_eirp,
-		      flag_list[0],
-		      flag_list[1],
-		      flag_list[2],
-		      flag_list[3],
-		      flag_list[4],
-		      flag_list[5],
-		      flag_list[6],
-		      flag_list[7],
-		      flag_list[8]);
-
-	if (hits < 5)
-		return -EINVAL;
-
-	reg_rule->freq_range.start_freq_khz =
-		REGLIB_MHZ_TO_KHZ(start_freq_khz);
-	reg_rule->freq_range.end_freq_khz =
-		REGLIB_MHZ_TO_KHZ(end_freq_khz);
-	reg_rule->freq_range.max_bandwidth_khz =
-		REGLIB_MHZ_TO_KHZ(max_bandwidth_khz);
-	reg_rule->power_rule.max_eirp =
-		REGLIB_DBM_TO_MBM(max_eirp);
-
-	for (i = 0; i < 8; i++)
-		reg_rule->flags |= reglib_parse_rule_flag(flag_list[i]);
-
-	if (debug)
-		printf("reglib_parse_rule_args(): %d flags: %d, line: %s",
-		       hits, reg_rule->flags, line);
-
-	return 0;
-#undef IGNORE_COMMA_OR_SPACE
-}
-
+		      &max_bandwidth_khz);
 
-static int
-reglib_parse_rule_args_mw(char *line, struct ieee80211_reg_rule *reg_rule)
-{
-#define IGNORE_COMMA_OR_SPACE "%*[ ,]"
-	int hits;
-	char flag_list[9][100];
-	unsigned int i = 0;
-	char mw[3];
-	float start_freq_khz, end_freq_khz, max_bandwidth_khz, max_eirp;
-
-	for (i = 0; i < 9; i++)
-		memset(flag_list[i], 0, sizeof(flag_list[i]));
-
-	hits = sscanf(line, "\t(%f - %f @ %f), (%f %2[mW])"
-		      IGNORE_COMMA_OR_SPACE "%s"
-		      IGNORE_COMMA_OR_SPACE "%s"
-		      IGNORE_COMMA_OR_SPACE "%s"
-		      IGNORE_COMMA_OR_SPACE "%s"
-		      IGNORE_COMMA_OR_SPACE "%s"
-		      IGNORE_COMMA_OR_SPACE "%s"
-		      IGNORE_COMMA_OR_SPACE "%s"
-		      IGNORE_COMMA_OR_SPACE "%s"
-		      IGNORE_COMMA_OR_SPACE "%s",
-		      &start_freq_khz,
-		      &end_freq_khz,
-		      &max_bandwidth_khz,
-		      &max_eirp,
-		      mw,
-		      flag_list[0],
-		      flag_list[1],
-		      flag_list[2],
-		      flag_list[3],
-		      flag_list[4],
-		      flag_list[5],
-		      flag_list[6],
-		      flag_list[7],
-		      flag_list[8]);
-
-	if (hits < 5)
+	if (hits != 3)
 		return -EINVAL;
 
 	reg_rule->freq_range.start_freq_khz =
@@ -976,60 +822,32 @@ reglib_parse_rule_args_mw(char *line, struct ieee80211_reg_rule *reg_rule)
 		REGLIB_MHZ_TO_KHZ(end_freq_khz);
 	reg_rule->freq_range.max_bandwidth_khz =
 		REGLIB_MHZ_TO_KHZ(max_bandwidth_khz);
-	reg_rule->power_rule.max_eirp =
-		REGLIB_MW_TO_MBM(max_eirp);
-
-	for (i = 0; i < 8; i++)
-		reg_rule->flags |= reglib_parse_rule_flag(flag_list[i]);
 
-	if (debug)
-		printf("reglib_parse_rule_args_mw(): %d flags: %d, line: %s",
-		       hits, reg_rule->flags, line);
-	return 0;
-#undef IGNORE_COMMA_OR_SPACE
-}
-
-static int reglib_parse_rule(FILE *fp, struct ieee80211_reg_rule *reg_rule)
-{
-	char line[1024];
-	char *line_p;
-	unsigned int i;
-	int r = 0;
-	struct reglib_rule_parse_list *reglib_rule_parsers;
-	size_t size_parsers = sizeof(struct reglib_rule_parse_list) + 
-				4 * sizeof(int (*)(char *, struct ieee80211_reg_rule *));
-
-	reglib_rule_parsers = malloc(size_parsers);
-	if (!reglib_rule_parsers)
-		return -EINVAL;
-	memset(reglib_rule_parsers, 0, size_parsers);
-
-	reglib_rule_parsers->n_parsers = 4;
-
-	/*
-	 * XXX: sscanf() is a bit odd with picking up mW
-	 * case over the simple one, this order however works,
-	 * gotta figure out how to be more precise.
-	 */
-	reglib_rule_parsers->rule_parsers[0] = reglib_parse_rule_args_mw;
-	reglib_rule_parsers->rule_parsers[1] = reglib_parse_rule_args;
-	reglib_rule_parsers->rule_parsers[2] = reglib_parse_rule_simple;
-	reglib_rule_parsers->rule_parsers[3] = reglib_parse_rule_simple_mw;
-
-	memset(line, 0, sizeof(line));
-	line_p = fgets(line, sizeof(line), fp);
-	if (line_p != line) {
-		free(reglib_rule_parsers);
+	/* Next get eirp */
+	strsep(&line_p, ",");
+	if (!line_p) {
+		fprintf(stderr, "not found eirp in line: %s\n", line);
 		return -EINVAL;
 	}
 
-	for (i = 0; i < reglib_rule_parsers->n_parsers; i++) {
-		r = reglib_rule_parsers->rule_parsers[i](line, reg_rule);
-		if (r == 0)
-			break;
+	if (strstr(line_p, "mW")) {
+		hits = sscanf(line_p, " (%f mW)", &max_eirp);
+		if (hits != 1)
+			return -EINVAL;
+		reg_rule->power_rule.max_eirp =
+			REGLIB_MW_TO_MBM(max_eirp);
+	} else {
+		hits = sscanf(line_p, " (%f)", &max_eirp);
+		if (hits != 1)
+			return -EINVAL;
+		reg_rule->power_rule.max_eirp =
+			REGLIB_DBM_TO_MBM(max_eirp);
 	}
 
-	free(reglib_rule_parsers);
+	/* Next get optional arguments (flags ...) */
+	strsep(&line_p, ",");
+	if (line_p)
+		reg_rule->flags = reglib_parse_rule_flag(line_p);
 
 	return r;
 }
@@ -1124,29 +942,6 @@ reglib_parse_rules(FILE *fp, struct ieee80211_regdomain *trd)
 	return rd;
 }
 
-static int
-reglib_parse_country_simple(char *line, struct ieee80211_regdomain *rd)
-{
-	char dfs_region_alpha[9];
-	char alpha2[2];
-	int hits;
-
-	memset(rd, 0, sizeof(*rd));
-	memset(alpha2, 0, sizeof(alpha2));
-	memset(dfs_region_alpha, 0, sizeof(dfs_region_alpha));
-
-	hits = sscanf(line, "country %2[a-zA-Z0-9]:",
-		      alpha2);
-
-	if (hits != 1)
-		return -EINVAL;
-
-	rd->alpha2[0] = alpha2[0];
-	rd->alpha2[1] = alpha2[1];
-
-	return 0;
-}
-
 static int reglib_parse_country_dfs(char *line, struct ieee80211_regdomain *rd)
 {
 	char dfs_region_alpha[9];
@@ -1163,10 +958,6 @@ static int reglib_parse_country_dfs(char *line, struct ieee80211_regdomain *rd)
 	if (hits <= 0)
 		return -EINVAL;
 
-	if (hits != 2)
-		return -EINVAL;
-
-
 	rd->alpha2[0] = alpha2[0];
 	rd->alpha2[1] = alpha2[1];
 	rd->dfs_region = reglib_parse_dfs_region(dfs_region_alpha);
@@ -1180,22 +971,7 @@ struct ieee80211_regdomain *__reglib_parse_country(FILE *fp)
 	struct ieee80211_regdomain tmp_rd;
 	char line[1024];
 	char *line_p;
-	unsigned int i;
 	int r = 0;
-	struct reglib_country_parse_list *reglib_country_parsers;
-	size_t size_of_parsers = sizeof(struct reglib_country_parse_list) +
-					2 * sizeof(int (*)(char *, struct ieee80211_regdomain *));
-
-	reglib_country_parsers = malloc(size_of_parsers);
-	if (!reglib_country_parsers)
-		return NULL;
-	memset(reglib_country_parsers, 0, size_of_parsers);
-
-	reglib_country_parsers->n_parsers = 2;
-	reglib_country_parsers->country_parsers[0] =
-			reglib_parse_country_dfs;
-	reglib_country_parsers->country_parsers[1] =
-			reglib_parse_country_simple;
 
 	memset(&tmp_rd, 0, sizeof(tmp_rd));
 	memset(line, 0, sizeof(line));
@@ -1203,26 +979,19 @@ struct ieee80211_regdomain *__reglib_parse_country(FILE *fp)
 	line_p = fgets(line, sizeof(line), fp);
 
 	if (line_p != line) {
-		free(reglib_country_parsers);
 		return NULL;
 	}
 
-	for (i = 0; i < reglib_country_parsers->n_parsers; i++) {
-		r = reglib_country_parsers->country_parsers[i](line, &tmp_rd);
-		if (r == 0)
-			break;
-	}
-
+	/* Country */
+	r = reglib_parse_country_dfs(line_p, &tmp_rd);
 	if (r != 0) {
 		fprintf(stderr, "Invalid country line: %s", line);
-		free(reglib_country_parsers);
 		return NULL;
 	}
 
+	/* Rules */
 	rd = reglib_parse_rules(fp, &tmp_rd);
 
-	free(reglib_country_parsers);
-
 	return rd;
 }
 
-- 
1.7.9.5

