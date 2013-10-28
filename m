Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:45868 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755041Ab3J1BxQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Oct 2013 21:53:16 -0400
Received: by mail-wi0-f179.google.com with SMTP id hm4so3280361wib.6
        for <linux-wireless@vger.kernel.org>; Sun, 27 Oct 2013 18:53:14 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: linux-wireless@vger.kernel.org
Cc: wireless-regdb@lists.infradead.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 3/6] crda: add regulatory domain stream parser
Date: Mon, 28 Oct 2013 02:52:59 +0100
Message-Id: <1382925182-7393-4-git-send-email-mcgrof@do-not-panic.com> (sfid-20131028_025319_491889_397C86E9)
In-Reply-To: <1382925182-7393-1-git-send-email-mcgrof@do-not-panic.com>
References: <1382925182-7393-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This adds a stream parser for regulatory domains. This
allows developers to build regulatory domains now using
the db.txt from a stream, either stdin, or a from an
opened file.

This also adds a simple db2rd which for now only uses the
library but with a bit of effort can also be used as a
suitable replacement for the kernel's genregdb.awk.

Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 Makefile |  10 +-
 db2rd.c  |  30 ++++
 reglib.c | 539 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 reglib.h |  44 ++++++
 4 files changed, 621 insertions(+), 2 deletions(-)
 create mode 100644 db2rd.c

diff --git a/Makefile b/Makefile
index 7d2e33f..bd9c220 100644
--- a/Makefile
+++ b/Makefile
@@ -24,10 +24,11 @@ PUBKEY_DIR?=pubkeys
 RUNTIME_PUBKEY_DIR?=/etc/wireless-regdb/pubkeys
 
 CFLAGS += -Wall -g
+LDLIBS += -lm
 
 all: all_noverify verify
 
-all_noverify: crda intersect regdbdump
+all_noverify: crda intersect regdbdump db2rd
 
 ifeq ($(USE_OPENSSL),1)
 CFLAGS += -DUSE_OPENSSL -DPUBKEY_DIR=\"$(RUNTIME_PUBKEY_DIR)\" `pkg-config --cflags openssl`
@@ -121,6 +122,10 @@ intersect: reglib.o intersect.o
 	$(NQ) '  LD  ' $@
 	$(Q)$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $^ $(LDLIBS)
 
+db2rd: reglib.o db2rd.o
+	$(NQ) '  LD  ' $@
+	$(Q)$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $^ $(LDLIBS)
+
 verify: $(REG_BIN) regdbdump
 	$(NQ) '  CHK  $(REG_BIN)'
 	$(Q)./regdbdump $(REG_BIN) >/dev/null
@@ -152,5 +157,6 @@ install: crda crda.8.gz regdbdump.8.gz
 	$(Q)$(INSTALL) -m 644 -t $(DESTDIR)/$(MANDIR)/man8/ regdbdump.8.gz
 
 clean:
-	$(Q)rm -f crda regdbdump intersect *.o *~ *.pyc keys-*.c *.gz \
+	$(Q)rm -f crda regdbdump intersect db2rd \
+		*.o *~ *.pyc keys-*.c *.gz \
 	udev/$(UDEV_LEVEL)regulatory.rules udev/regulatory.rules.parsed
diff --git a/db2rd.c b/db2rd.c
new file mode 100644
index 0000000..fe6f55b
--- /dev/null
+++ b/db2rd.c
@@ -0,0 +1,30 @@
+#include <errno.h>
+#include <stdlib.h>
+#include <stdio.h>
+#include <arpa/inet.h> /* ntohl */
+#include <string.h>
+
+#include "nl80211.h"
+#include "reglib.h"
+
+int main(int argc, char **argv)
+{
+	struct ieee80211_regdomain *rd = NULL;
+	FILE *fp;
+
+	if (argc != 1) {
+		fprintf(stderr, "Usage: cat db.txt | %s\n", argv[0]);
+		return -EINVAL;
+	}
+
+	fp = reglib_create_parse_stream(stdin);
+
+	reglib_for_each_country_stream(fp, rd) {
+		reglib_print_regdom(rd);
+		free(rd);
+	}
+
+	fclose(fp);
+
+	return 0;
+}
diff --git a/reglib.c b/reglib.c
index b0c61e5..0793fab 100644
--- a/reglib.c
+++ b/reglib.c
@@ -38,6 +38,19 @@
 #include "keys-gcrypt.c"
 #endif
 
+int debug = 0;
+
+struct reglib_rule_parse_list {
+	int n_parsers;
+	int (*rule_parsers[])(char *line, struct ieee80211_reg_rule *reg_rule);
+};
+
+struct reglib_country_parse_list {
+	int n_parsers;
+	int (*country_parsers[])(char *line, struct ieee80211_regdomain *rd);
+};
+
+
 void *
 reglib_get_file_ptr(uint8_t *db, size_t dblen, size_t structlen, uint32_t ptr)
 {
@@ -707,3 +720,529 @@ void reglib_print_regdom(const struct ieee80211_regdomain *rd)
 		print_reg_rule(&rd->reg_rules[i]);
 	printf("\n");
 }
+
+static unsigned int reglib_parse_dfs_region(char *dfs_region)
+{
+	if (strncmp(dfs_region, "DFS-FCC", 7) == 0)
+		return REGDB_DFS_FCC;
+	if (strncmp(dfs_region, "DFS-ETSI", 8) == 0)
+		return REGDB_DFS_ETSI;
+	if (strncmp(dfs_region, "DFS-JP", 6) == 0)
+		return REGDB_DFS_JP;
+	return REGDB_DFS_UNSET;
+}
+
+static uint32_t reglib_parse_rule_flag(char *flag_s)
+{
+	if (strncmp(flag_s, "NO-OFDM", 7) == 0)
+		return RRF_NO_OFDM;
+	if (strncmp(flag_s, "NO-CCK", 6) == 0)
+		return RRF_NO_CCK;
+	if (strncmp(flag_s, "NO-INDOOR", 9) == 0)
+		return RRF_NO_INDOOR;
+	if (strncmp(flag_s, "NO-OUTDOOR", 10) == 0)
+		return RRF_NO_OUTDOOR;
+	if (strncmp(flag_s, "DFS", 3) == 0)
+		return RRF_DFS;
+	if (strncmp(flag_s, "PTP-ONLY", 8) == 0)
+		return RRF_PTP_ONLY;
+	if (strncmp(flag_s, "PTMP-ONLY", 9) == 0)
+		return RRF_PTMP_ONLY;
+	if (strncmp(flag_s, "NO-IR", 5) == 0)
+		return RRF_NO_IR;
+
+	return 0;
+}
+
+static int
+reglib_parse_rule_simple(char *line, struct ieee80211_reg_rule *reg_rule)
+{
+	int hits;
+	float start_freq_khz, end_freq_khz, max_bandwidth_khz, max_eirp;
+
+	hits = sscanf(line, "\t(%f - %f @ %f), (%f)\n",
+		      &start_freq_khz,
+		      &end_freq_khz,
+		      &max_bandwidth_khz,
+		      &max_eirp);
+
+	if (hits != 4)
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
+	reg_rule->flags = 0;
+
+	if (debug)
+		printf("reglib_parse_rule_simple(): %d line: %s", hits, line);
+
+
+	return 0;
+}
+
+static int
+reglib_parse_rule_simple_mw(char *line, struct ieee80211_reg_rule *reg_rule)
+{
+	int hits;
+	float start_freq_khz, end_freq_khz, max_bandwidth_khz, max_eirp;
+	char mw[3];
+
+	hits = sscanf(line, "\t(%f - %f @ %f), (%f %2[mW])\n",
+		      &start_freq_khz,
+		      &end_freq_khz,
+		      &max_bandwidth_khz,
+		      &max_eirp, mw);
+
+	if (hits != 4)
+		return -EINVAL;
+
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
+	reg_rule->flags = 0;
+
+	if (debug)
+		printf("reglib_parse_rule_simple_mw(): %d line: %s",
+		       hits, line);
+
+	return 0;
+}
+
+static int
+reglib_parse_rule_args(char *line, struct ieee80211_reg_rule *reg_rule)
+{
+#define IGNORE_COMMA_OR_SPACE "%*[ ,]"
+	int hits;
+	char flag_list[9][100];
+	unsigned int i = 0;
+	float start_freq_khz, end_freq_khz, max_bandwidth_khz, max_eirp;
+
+	for (i = 0; i < 9; i++)
+		memset(flag_list[i], 0, sizeof(flag_list[i]));
+
+	hits = sscanf(line, "\t(%f - %f @ %f), (%f)"
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
+	if (hits < 5)
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
+	if (debug)
+		printf("reglib_parse_rule_args(): %d flags: %d, line: %s",
+		       hits, reg_rule->flags, line);
+
+	return 0;
+#undef IGNORE_COMMA_OR_SPACE
+}
+
+
+static int
+reglib_parse_rule_args_mw(char *line, struct ieee80211_reg_rule *reg_rule)
+{
+#define IGNORE_COMMA_OR_SPACE "%*[ ,]"
+	int hits;
+	char flag_list[9][100];
+	unsigned int i = 0;
+	char mw[3];
+	float start_freq_khz, end_freq_khz, max_bandwidth_khz, max_eirp;
+
+	for (i = 0; i < 9; i++)
+		memset(flag_list[i], 0, sizeof(flag_list[i]));
+
+	hits = sscanf(line, "\t(%f - %f @ %f), (%f %2[mW])"
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
+	if (hits < 5)
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
+	if (debug)
+		printf("reglib_parse_rule_args_mw(): %d flags: %d, line: %s",
+		       hits, reg_rule->flags, line);
+	return 0;
+#undef IGNORE_COMMA_OR_SPACE
+}
+
+static int reglib_parse_rule(FILE *fp, struct ieee80211_reg_rule *reg_rule)
+{
+	char line[1024];
+	char *line_p;
+	unsigned int i;
+	int r = 0;
+	struct reglib_rule_parse_list *reglib_rule_parsers;
+
+	reglib_rule_parsers = malloc(sizeof(struct reglib_rule_parse_list) + 
+				     4 * sizeof(int (*)(char *, struct ieee80211_reg_rule *)));
+	if (!reglib_rule_parsers)
+		return -EINVAL;
+
+	reglib_rule_parsers->n_parsers = 4;
+
+	/*
+	 * XXX: sscanf() is a bit odd with picking up mW
+	 * case over the simple one, this order however works,
+	 * gotta figure out how to be more precise.
+	 */
+	reglib_rule_parsers->rule_parsers[0] = reglib_parse_rule_args_mw;
+	reglib_rule_parsers->rule_parsers[1] = reglib_parse_rule_args;
+	reglib_rule_parsers->rule_parsers[2] = reglib_parse_rule_simple;
+	reglib_rule_parsers->rule_parsers[3] = reglib_parse_rule_simple_mw;
+
+	memset(line, 0, sizeof(line));
+	line_p = fgets(line, sizeof(line), fp);
+	if (line_p != line)
+		return -EINVAL;
+
+	for (i = 0; i < reglib_rule_parsers->n_parsers; i++) {
+		r = reglib_rule_parsers->rule_parsers[i](line, reg_rule);
+		if (r == 0)
+			break;
+	}
+
+	return r;
+}
+
+static uint32_t
+reglib_get_n_rules(FILE *fp, struct ieee80211_reg_rule *reg_rule)
+{
+	uint32_t n_rules = 0;
+	int r;
+	bool save_debug = false;
+
+	save_debug = debug;
+	debug = false;
+
+	while (1) {
+		r = reglib_parse_rule(fp, reg_rule);
+		if (r != 0)
+			break;
+		n_rules++;
+	}
+
+	debug = save_debug;
+
+	return n_rules;
+}
+
+static int reglib_parse_reg_rule(FILE *fp, struct ieee80211_reg_rule *reg_rule)
+{
+	int r;
+
+	while (1) {
+		r = reglib_parse_rule(fp, reg_rule);
+		if (r != 0)
+			continue;
+		return 0;
+	}
+}
+
+static struct ieee80211_regdomain *
+reglib_parse_rules(FILE *fp, struct ieee80211_regdomain *trd)
+{
+	struct ieee80211_regdomain *rd;
+	struct ieee80211_reg_rule rule;
+	struct ieee80211_reg_rule *reg_rule;
+	fpos_t pos;
+	unsigned int i;
+	uint32_t size_of_regd = 0, num_rules = 0;
+	int r;
+
+	memset(&rule, 0, sizeof(rule));
+	reg_rule = &rule;
+
+	r = fgetpos(fp, &pos);
+	if (r != 0) {
+		fprintf(stderr, "fgetpos() failed: %s\n",
+			strerror(errno));
+		return NULL;
+	}
+
+	num_rules = reglib_get_n_rules(fp, reg_rule);
+	if (!num_rules)
+		return NULL;
+
+	size_of_regd = reglib_array_len(sizeof(struct ieee80211_regdomain),
+					num_rules + 1,
+					sizeof(struct ieee80211_reg_rule));
+	rd = malloc(size_of_regd);
+	if (!rd)
+		return NULL;
+
+	memset(rd, 0, size_of_regd);
+	memcpy(rd, trd, sizeof(*trd));
+
+	rd->n_reg_rules = num_rules;
+
+	r = fsetpos(fp, &pos);
+	if (r != 0) {
+		fprintf(stderr, "fsetpos() failed: %s\n",
+			strerror(errno));
+		free(rd);
+		return NULL;
+	}
+	for (i = 0; i < num_rules; i++) {
+		struct ieee80211_reg_rule *rrule = &rd->reg_rules[i];
+
+		if (reglib_parse_reg_rule(fp, rrule) != 0) {
+			fprintf(stderr, "rule parse failed\n");
+			free(rd);
+			return NULL;
+		}
+	}
+	return rd;
+}
+
+static int
+reglib_parse_country_simple(char *line, struct ieee80211_regdomain *rd)
+{
+	char dfs_region_alpha[9];
+	char alpha2[2];
+	int hits;
+
+	memset(rd, 0, sizeof(rd));
+	memset(alpha2, 0, sizeof(alpha2));
+	memset(dfs_region_alpha, 0, sizeof(dfs_region_alpha));
+
+	hits = sscanf(line, "country %2[a-zA-Z0-9]:",
+		      alpha2);
+
+	if (hits != 1)
+		return -EINVAL;
+
+	rd->alpha2[0] = alpha2[0];
+	rd->alpha2[1] = alpha2[1];
+
+	return 0;
+}
+
+static int reglib_parse_country_dfs(char *line, struct ieee80211_regdomain *rd)
+{
+	char dfs_region_alpha[9];
+	char alpha2[2];
+	int hits;
+
+	memset(rd, 0, sizeof(rd));
+	memset(alpha2, 0, sizeof(alpha2));
+	memset(dfs_region_alpha, 0, sizeof(dfs_region_alpha));
+
+	hits = sscanf(line, "country %2[a-zA-Z0-9]:%*[ ]%s\n",
+		      alpha2,
+		      dfs_region_alpha);
+	if (hits <= 0)
+		return -EINVAL;
+
+	if (hits != 2)
+		return -EINVAL;
+
+
+	rd->alpha2[0] = alpha2[0];
+	rd->alpha2[1] = alpha2[1];
+	rd->dfs_region = reglib_parse_dfs_region(dfs_region_alpha);
+
+	return 0;
+}
+
+struct ieee80211_regdomain *__reglib_parse_country(FILE *fp)
+{
+	struct ieee80211_regdomain *rd;
+	struct ieee80211_regdomain tmp_rd;
+	char line[1024];
+	char *line_p;
+	unsigned int i;
+	int r = 0;
+	struct reglib_country_parse_list *reglib_country_parsers;
+
+	reglib_country_parsers = malloc(sizeof(struct reglib_country_parse_list) +
+					2 * sizeof(int (*)(char *, struct ieee80211_regdomain *)));
+	if (!reglib_country_parsers)
+		return NULL;
+
+	reglib_country_parsers->n_parsers = 2;
+	reglib_country_parsers->country_parsers[0] =
+			reglib_parse_country_simple;
+	reglib_country_parsers->country_parsers[1] =
+			reglib_parse_country_dfs;
+
+	memset(&tmp_rd, 0, sizeof(tmp_rd));
+	memset(line, 0, sizeof(line));
+
+	line_p = fgets(line, sizeof(line), fp);
+
+	if (line_p != line)
+		return NULL;
+
+	for (i = 0; i < reglib_country_parsers->n_parsers; i++) {
+		r = reglib_country_parsers->country_parsers[i](line, &tmp_rd);
+		if (r == 0)
+			break;
+	}
+
+	if (r != 0) {
+		fprintf(stderr, "Invalid country line: %s", line);
+		return NULL;
+	}
+
+	rd = reglib_parse_rules(fp, &tmp_rd);
+
+	return rd;
+}
+
+static int reglib_find_next_country_stream(FILE *fp)
+{
+	fpos_t prev_pos;
+	int r;
+	unsigned int i = 0;
+
+	while(1) {
+		char line[1024];
+		char *line_p;
+
+		r = fgetpos(fp, &prev_pos);
+		if (r != 0) {
+			fprintf(stderr, "fgetpos() failed: %s\n",
+				strerror(errno));
+			return r;
+		}
+
+		memset(line, 0, sizeof(line));
+
+		line_p = fgets(line, sizeof(line), fp);
+		if (line_p == line) {
+			if (strspn(line, "\n") == strlen(line)) {
+				i++;
+				continue;
+			}
+			if (strncmp(line, "country", 7) != 0)
+				continue;
+			r = fsetpos(fp, &prev_pos);
+			if (r != 0) {
+				fprintf(stderr, "fsetpos() failed: %s\n",
+					strerror(errno));
+				return r;
+			}
+			return 0;
+		} else
+			return EOF;
+	}
+}
+
+struct ieee80211_regdomain *reglib_parse_country(FILE *fp)
+{
+	int r;
+
+	r = reglib_find_next_country_stream(fp);
+	if (r != 0)
+		return NULL;
+	return __reglib_parse_country(fp);
+}
+
+FILE *reglib_create_parse_stream(FILE *f)
+{
+	unsigned int lines = 0;
+	FILE *fp;
+
+	fp = tmpfile();
+	if (errno) {
+		fprintf(stderr, "%s\n", strerror(errno));
+		return NULL;
+	}
+
+	while(1) {
+		char line[1024];
+		char *line_p;
+
+		line_p = fgets(line, sizeof(line), f);
+		if (line_p == line) {
+			if (strchr(line, '#') == NULL) {
+				fputs(line, fp);
+				lines++;
+			}
+			continue;
+		} else
+			break;
+	}
+
+	rewind(fp);
+	fflush(fp);
+
+	return fp;
+}
diff --git a/reglib.h b/reglib.h
index 7a586a3..885792e 100644
--- a/reglib.h
+++ b/reglib.h
@@ -1,10 +1,12 @@
 #ifndef REG_LIB_H
 #define REG_LIB_H
 
+#include <stdio.h>
 #include <stdlib.h>
 #include <stdint.h>
 #include <stdbool.h>
 #include <sys/stat.h>
+#include <math.h>
 
 #include "regdb.h"
 
@@ -35,6 +37,19 @@ struct ieee80211_regdomain {
 	struct ieee80211_reg_rule reg_rules[];
 };
 
+/* Remove this once upstream nl80211.h gets this */
+#define NL80211_RRF_NO_IR (1<<7)
+
+#define REGLIB_MHZ_TO_KHZ(freq) ((freq) * 1000)
+#define REGLIB_KHZ_TO_MHZ(freq) ((freq) / 1000)
+#define REGLIB_DBI_TO_MBI(gain) ((gain) * 100)
+#define REGLIB_MBI_TO_DBI(gain) ((gain) / 100)
+#define REGLIB_DBM_TO_MBM(gain) ((gain) * 100)
+#define REGLIB_MBM_TO_DBM(gain) ((gain) / 100)
+
+#define REGLIB_MW_TO_DBM(gain) (10 * log10(gain))
+#define REGLIB_MW_TO_MBM(gain) (REGLIB_DBM_TO_MBM(REGLIB_MW_TO_DBM(gain)))
+
 /**
  * struct reglib_regdb_ctx - reglib regdb context
  *
@@ -180,4 +195,33 @@ reglib_intersect_rds(const struct ieee80211_regdomain *rd1,
 const struct ieee80211_regdomain *
 reglib_intersect_regdb(const struct reglib_regdb_ctx *ctx);
 
+/**
+ * @reglib_create_parse_stream - provide a clean new stream for processing
+ *
+ * @fp: FILE stream, could be stdin, or a stream from an open file.
+ *
+ * In order to parse a stream we recommend to create a new stream
+ * using this helper. A new stream is preferred in order to work
+ * with stdin, as otherwise we cannot rewind() and move around
+ * the stream. This helper will create new stream using tmpfile()
+ * and also remove all comments. It will be closed and the file
+ * deleted when the process terminates.
+ */
+FILE *reglib_create_parse_stream(FILE *fp);
+
+/**
+ * @reglib_parse_country - parse stream to build a regulatory domain
+ *
+ * @fp: FILE stream, could be stdin, or a stream from an open file.
+ *
+ * Parse stream and return back a built regulatory domain. Returns
+ * NULL if one could not be built.
+ */
+struct ieee80211_regdomain *reglib_parse_country(FILE *fp);
+
+#define reglib_for_each_country_stream(__fp, __rd)		\
+	for (__rd = reglib_parse_country(__fp);			\
+	     __rd != NULL;					\
+	     __rd = reglib_parse_country(__fp))			\
+
 #endif
-- 
1.8.4.rc3

