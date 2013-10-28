Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f47.google.com ([74.125.82.47]:62158 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754935Ab3J1BxT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Oct 2013 21:53:19 -0400
Received: by mail-wg0-f47.google.com with SMTP id c11so5839677wgh.26
        for <linux-wireless@vger.kernel.org>; Sun, 27 Oct 2013 18:53:18 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: linux-wireless@vger.kernel.org
Cc: wireless-regdb@lists.infradead.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 4/6] crda: add regulatory domain optimizer
Date: Mon, 28 Oct 2013 02:53:00 +0100
Message-Id: <1382925182-7393-5-git-send-email-mcgrof@do-not-panic.com> (sfid-20131028_025321_911941_00ECC4D0)
In-Reply-To: <1382925182-7393-1-git-send-email-mcgrof@do-not-panic.com>
References: <1382925182-7393-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This adds a regulatory domain optimizer which can be
used with information of a regulatory domain in db.txt
format in stdin. It makes use of the new shiny regulatory
domain stream parser.

The way this works is it iterates over the regulatory domain
computing unions between each frequency, starting from each
frequency as a pivot. If a union leads to a valid regulatory
rule we verify that the pivot and othre frequency rules that
provided that valid union can fit into that union regulatory
rule by computing an intersection. If an intersection is
possible it means two rules can be optimized out. We do
this repetitively.

Screenshot:

mcgrof@frijol ~/devel/crda (git::master)$ cat us
country US: DFS-FCC
        (5170 - 5190 @ 20), (17)
        (5190 - 5210 @ 20), (17)
        (5210 - 5230 @ 20), (17)
        (5230 - 5250 @ 20), (17)
        (5250 - 5270 @ 20), (23), DFS
        (5270 - 5290 @ 20), (23), DFS
        (5290 - 5310 @ 20), (23), DFS
        (5310 - 5330 @ 20), (23), DFS
        (5735 - 5755 @ 20), (30)
        (5755 - 5775 @ 20), (30)
        (5775 - 5795 @ 20), (30)
        (5795 - 5815 @ 20), (30)
        (5815 - 5835 @ 20), (30)
        (5170 - 5210 @ 40), (17)
        (5210 - 5250 @ 40), (17)
        (5250 - 5290 @ 40), (23), DFS
        (5290 - 5330 @ 40), (23), DFS
        (5735 - 5775 @ 40), (30)
        (5775 - 5815 @ 40), (30)
        (5170 - 5250 @ 80), (17)
        (5250 - 5330 @ 80), (23), DFS
        (5735 - 5815 @ 80), (30)

mcgrof@frijol ~/devel/crda (git::master)$ cat us | ./optimize
country US: DFS-UNSET
        (5170.000 - 5250.000 @ 80.000), (17.00)
        (5250.000 - 5330.000 @ 80.000), (23.00), DFS
        (5735.000 - 5835.000 @ 80.000), (30.00)

Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 Makefile   |   8 +-
 optimize.c |  38 ++++++++++
 reglib.c   | 251 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 reglib.h   |  16 ++++
 4 files changed, 311 insertions(+), 2 deletions(-)
 create mode 100644 optimize.c

diff --git a/Makefile b/Makefile
index bd9c220..9e37ccd 100644
--- a/Makefile
+++ b/Makefile
@@ -28,7 +28,7 @@ LDLIBS += -lm
 
 all: all_noverify verify
 
-all_noverify: crda intersect regdbdump db2rd
+all_noverify: crda intersect regdbdump db2rd optimize
 
 ifeq ($(USE_OPENSSL),1)
 CFLAGS += -DUSE_OPENSSL -DPUBKEY_DIR=\"$(RUNTIME_PUBKEY_DIR)\" `pkg-config --cflags openssl`
@@ -126,6 +126,10 @@ db2rd: reglib.o db2rd.o
 	$(NQ) '  LD  ' $@
 	$(Q)$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $^ $(LDLIBS)
 
+optimize: reglib.o optimize.o
+	$(NQ) '  LD  ' $@
+	$(Q)$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $^ $(LDLIBS)
+
 verify: $(REG_BIN) regdbdump
 	$(NQ) '  CHK  $(REG_BIN)'
 	$(Q)./regdbdump $(REG_BIN) >/dev/null
@@ -157,6 +161,6 @@ install: crda crda.8.gz regdbdump.8.gz
 	$(Q)$(INSTALL) -m 644 -t $(DESTDIR)/$(MANDIR)/man8/ regdbdump.8.gz
 
 clean:
-	$(Q)rm -f crda regdbdump intersect db2rd \
+	$(Q)rm -f crda regdbdump intersect db2rd optimize \
 		*.o *~ *.pyc keys-*.c *.gz \
 	udev/$(UDEV_LEVEL)regulatory.rules udev/regulatory.rules.parsed
diff --git a/optimize.c b/optimize.c
new file mode 100644
index 0000000..c87371d
--- /dev/null
+++ b/optimize.c
@@ -0,0 +1,38 @@
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
+	struct ieee80211_regdomain *rd = NULL, *rd_opt = NULL;
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
+		rd_opt = reglib_optimize_regdom(rd);
+		if (!rd_opt){
+			fprintf(stderr, "Unable to optimize %c%c\n",
+				rd->alpha2[0],
+				rd->alpha2[1]);
+			free(rd);
+			continue;
+		}
+		reglib_print_regdom(rd_opt);
+		free(rd);
+		free(rd_opt);
+	}
+
+	fclose(fp);
+	return 0;
+}
diff --git a/reglib.c b/reglib.c
index 0793fab..ae4b017 100644
--- a/reglib.c
+++ b/reglib.c
@@ -459,6 +459,43 @@ int reglib_is_valid_rd(const struct ieee80211_regdomain *rd)
 	return 1;
 }
 
+static int reg_rules_union(const struct ieee80211_reg_rule *rule1,
+			   const struct ieee80211_reg_rule *rule2,
+			   struct ieee80211_reg_rule *union_rule)
+{
+	const struct ieee80211_freq_range *freq_range1, *freq_range2;
+	struct ieee80211_freq_range *freq_range;
+	const struct ieee80211_power_rule *power_rule1, *power_rule2;
+	struct ieee80211_power_rule *power_rule;
+
+	freq_range1 = &rule1->freq_range;
+	freq_range2 = &rule2->freq_range;
+	freq_range = &union_rule->freq_range;
+
+	power_rule1 = &rule1->power_rule;
+	power_rule2 = &rule2->power_rule;
+	power_rule = &union_rule->power_rule;
+
+	freq_range->start_freq_khz = reglib_min(freq_range1->start_freq_khz,
+					 freq_range2->start_freq_khz);
+	freq_range->end_freq_khz = reglib_max(freq_range1->end_freq_khz,
+				       freq_range2->end_freq_khz);
+	freq_range->max_bandwidth_khz = reglib_max(freq_range1->max_bandwidth_khz,
+					    freq_range2->max_bandwidth_khz);
+
+	power_rule->max_eirp = reglib_max(power_rule1->max_eirp,
+		power_rule2->max_eirp);
+	power_rule->max_antenna_gain = reglib_max(power_rule1->max_antenna_gain,
+		power_rule2->max_antenna_gain);
+
+	union_rule->flags = rule1->flags | rule2->flags;
+
+	if (!is_valid_reg_rule(union_rule))
+		return -EINVAL;
+
+	return 0;
+}
+
 /*
  * Helper for reglib_intersect_rds(), this does the real
  * mathematical intersection fun
@@ -1246,3 +1283,217 @@ FILE *reglib_create_parse_stream(FILE *f)
 
 	return fp;
 }
+
+/*
+ * The idea behind a rule key is that if two rule keys share the
+ * same key they can be merged together if their frequencies overlap.
+ */
+static uint64_t reglib_rule_key(struct ieee80211_reg_rule *reg_rule)
+{
+	struct ieee80211_power_rule *power_rule;
+	uint32_t key;
+
+	power_rule = &reg_rule->power_rule;
+
+	key = ((power_rule->max_eirp ^ 0) << 0) ^
+	      ((reg_rule->flags      ^ 8) << 8);
+
+	return key;
+}
+
+/* XXX: cannot support > 32 rules */
+struct reglib_optimize_map {
+	bool optimized[32];
+	uint32_t keys[32];
+};
+
+/* Does the provided rule suffice both of the other two */
+static int reglib_opt_rule_fit(struct ieee80211_reg_rule *rule1,
+			       struct ieee80211_reg_rule *rule2,
+			       struct ieee80211_reg_rule *opt_rule)
+{
+	struct ieee80211_reg_rule interesected_rule;
+	struct ieee80211_reg_rule *int_rule;
+	int r;
+
+	memset(&interesected_rule, 0, sizeof(struct ieee80211_reg_rule));
+	int_rule = &interesected_rule;
+
+	r = reg_rules_intersect(rule1, opt_rule, int_rule);
+	if (r != 0)
+		return r;
+	r = reg_rules_intersect(rule2, opt_rule, int_rule);
+	if (r != 0)
+		return r;
+
+	return 0;
+}
+
+static int reg_rule_optimize(struct ieee80211_reg_rule *rule1,
+			     struct ieee80211_reg_rule *rule2,
+			     struct ieee80211_reg_rule *opt_rule)
+{
+	int r;
+
+	r = reg_rules_union(rule1, rule2, opt_rule);
+	if (r != 0)
+		return r;
+	r = reglib_opt_rule_fit(rule1, rule2, opt_rule);
+	if (r != 0)
+		return r;
+
+	return 0;
+}
+
+/*
+ * Here's the math explanation:
+ *
+ * This takes each pivot frequency on the regulatory domain, computes
+ * the union between it each regulatory rule on the regulatory domain
+ * sequentially, and after that it tries to verify that the pivot frequency
+ * fits on it by computing an intersection between it and the union, if
+ * a rule exist as a possible intersection then we know the rule can be
+ * subset of the combination of the two frequency ranges (union) computed.
+ */
+static unsigned int reg_rule_optimize_rd(struct ieee80211_regdomain *rd,
+					 unsigned int rule_idx,
+					 struct ieee80211_reg_rule *opt_rule,
+					 struct reglib_optimize_map *opt_map)
+{
+	unsigned int i;
+	struct ieee80211_reg_rule *rule1;
+	struct ieee80211_reg_rule *rule2;
+
+	struct ieee80211_reg_rule tmp_optimized_rule;
+	struct ieee80211_reg_rule *tmp_opt_rule;
+
+	struct ieee80211_reg_rule *target_rule;
+
+	unsigned int optimized = 0;
+	int r;
+
+	if (rule_idx > rd->n_reg_rules)
+		return 0;
+
+	rule1 = &rd->reg_rules[rule_idx];
+
+	memset(&tmp_optimized_rule, 0, sizeof(struct ieee80211_reg_rule));
+	tmp_opt_rule = &tmp_optimized_rule;
+
+	memset(opt_rule, 0, sizeof(*opt_rule));
+
+	for (i = 0; i < rd->n_reg_rules; i++) {
+		if (rule_idx == i)
+			continue;
+		rule2 = &rd->reg_rules[i];
+		if (opt_map->keys[rule_idx] != opt_map->keys[i])
+			continue;
+
+		target_rule = optimized ? opt_rule : rule1;
+		r = reg_rule_optimize(target_rule, rule2, tmp_opt_rule);
+		if (r != 0)
+			continue;
+		memcpy(opt_rule, tmp_opt_rule, sizeof(*tmp_opt_rule));
+
+		if (!opt_map->optimized[i]) {
+			opt_map->optimized[i] = true;
+			optimized++;
+		}
+		if (!opt_map->optimized[rule_idx]) {
+			opt_map->optimized[rule_idx] = true;
+			optimized++;
+		}
+	}
+	return optimized;
+}
+
+struct ieee80211_regdomain *
+reglib_optimize_regdom(struct ieee80211_regdomain *rd)
+{
+	struct ieee80211_regdomain *opt_rd = NULL;
+	struct ieee80211_reg_rule *reg_rule;
+	struct ieee80211_reg_rule *reg_rule_dst;
+	struct ieee80211_reg_rule optimized_reg_rule;
+	struct ieee80211_reg_rule *opt_reg_rule;
+	struct reglib_optimize_map opt_map;
+	unsigned int i, idx = 0, non_opt = 0, opt = 0;
+	size_t num_rules, size_of_regd;
+	unsigned int num_opts = 0;
+
+	memset(&opt_map, 0, sizeof(struct reglib_optimize_map));
+	memset(&optimized_reg_rule, 0, sizeof(struct ieee80211_reg_rule));
+
+	opt_reg_rule = &optimized_reg_rule;
+
+	for (i = 0; i < rd->n_reg_rules; i++) {
+		reg_rule = &rd->reg_rules[i];
+		opt_map.keys[i] = reglib_rule_key(reg_rule);
+	}
+	for (i = 0; i < rd->n_reg_rules; i++) {
+		reg_rule = &rd->reg_rules[i];
+		if (opt_map.optimized[i])
+			continue;
+		num_opts = reg_rule_optimize_rd(rd, i, opt_reg_rule, &opt_map);
+		if (!num_opts)
+			non_opt++;
+		else
+			opt += (num_opts ? 1 : 0);
+	}
+
+	num_rules = non_opt + opt;
+
+	if (num_rules > rd->n_reg_rules)
+		return NULL;
+
+	size_of_regd = reglib_array_len(sizeof(struct ieee80211_regdomain),
+					num_rules + 1,
+					sizeof(struct ieee80211_reg_rule));
+
+	opt_rd = malloc(size_of_regd);
+	if (!opt_rd)
+		return NULL;
+	memset(opt_rd, 0, size_of_regd);
+
+	opt_rd->n_reg_rules = num_rules;
+	opt_rd->alpha2[0] = rd->alpha2[0];
+	opt_rd->alpha2[1] = rd->alpha2[1];
+	opt_rd->dfs_region = rd->dfs_region;
+
+	memset(&opt_map, 0, sizeof(struct reglib_optimize_map));
+	memset(&optimized_reg_rule, 0, sizeof(struct ieee80211_reg_rule));
+
+	opt_reg_rule = &optimized_reg_rule;
+
+	for (i = 0; i < rd->n_reg_rules; i++) {
+		reg_rule = &rd->reg_rules[i];
+		opt_map.keys[i] = reglib_rule_key(reg_rule);
+	}
+
+	for (i = 0; i < rd->n_reg_rules; i++) {
+		reg_rule = &rd->reg_rules[i];
+		reg_rule_dst = &opt_rd->reg_rules[idx];
+		if (opt_map.optimized[i])
+			continue;
+		num_opts = reg_rule_optimize_rd(rd, i, opt_reg_rule, &opt_map);
+		if (!num_opts)
+			memcpy(reg_rule_dst, reg_rule, sizeof(struct ieee80211_reg_rule));
+		else
+			memcpy(reg_rule_dst, opt_reg_rule, sizeof(struct ieee80211_reg_rule));
+		idx++;
+	}
+
+	if (idx != num_rules) {
+		free(opt_rd);
+		return NULL;
+	}
+
+	for (i = 0; i < opt_rd->n_reg_rules; i++) {
+		reg_rule = &opt_rd->reg_rules[i];
+		if (!is_valid_reg_rule(reg_rule)) {
+			free(opt_rd);
+			return NULL;
+		}
+	}
+
+	return opt_rd;
+}
diff --git a/reglib.h b/reglib.h
index 885792e..d570c36 100644
--- a/reglib.h
+++ b/reglib.h
@@ -219,6 +219,22 @@ FILE *reglib_create_parse_stream(FILE *fp);
  */
 struct ieee80211_regdomain *reglib_parse_country(FILE *fp);
 
+/**
+ * @reglib_optimize_regdom - optimize a regulatory domain
+ *
+ * @rd: a regulatory domain to be optimized
+ *
+ * A regulatory domain may exist without optimal expressions
+ * over its rules. This will look for regulatory rules that can
+ * be combined together to reduce the size of the regulatory
+ * domain and its expression.
+ *
+ * Regulatory rules will be combined if their max allowed
+ * bandwidth, max EIRP, and flags all match.
+ */
+struct ieee80211_regdomain *
+reglib_optimize_regdom(struct ieee80211_regdomain *rd);
+
 #define reglib_for_each_country_stream(__fp, __rd)		\
 	for (__rd = reglib_parse_country(__fp);			\
 	     __rd != NULL;					\
-- 
1.8.4.rc3

