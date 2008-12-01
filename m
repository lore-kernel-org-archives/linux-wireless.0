Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.25]:62995 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751096AbYLAM1H (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Dec 2008 07:27:07 -0500
Received: by ey-out-2122.google.com with SMTP id 6so1029871eyi.37
        for <linux-wireless@vger.kernel.org>; Mon, 01 Dec 2008 04:27:06 -0800 (PST)
From: Diego 'Flameeyes' =?utf-8?q?Petten=C3=B2?= <flameeyes@gmail.com>
Subject: [crda PATCH 2/3] Split printing functions to their own translation
	unit.
To: linux-wireless@vger.kernel.org
Date: Mon, 01 Dec 2008 13:27:04 +0100
Message-ID: <20081201122704.20222.73459.stgit@localhost> (sfid-20081201_132711_417908_64D69900)
In-Reply-To: <20081201122657.20222.49058.stgit@localhost>
References: <20081201122657.20222.49058.stgit@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This allows to avoid linking them in the crda binary where they are
not used.
---

 Makefile       |    8 ++--
 print-regdom.c |  122 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 reglib.c       |  119 -------------------------------------------------------
 3 files changed, 126 insertions(+), 123 deletions(-)
 create mode 100644 print-regdom.c

diff --git a/Makefile b/Makefile
index a8c0a45..2fb94fc 100644
--- a/Makefile
+++ b/Makefile
@@ -46,13 +46,13 @@ crda: reglib.o crda.o
 	$(NQ) '  LD  ' $@
 	$(Q)$(CC) $(CFLAGS) $(LDFLAGS) -o $@ reglib.o crda.o `pkg-config --libs libnl-1` $(LDLIBS)
 
-regdbdump: reglib.o regdbdump.o
+regdbdump: reglib.o regdbdump.o print-regdom.o
 	$(NQ) '  LD  ' $@
-	$(Q)$(CC) $(CFLAGS) $(LDFLAGS) -o $@ reglib.o regdbdump.o $(LDLIBS)
+	$(Q)$(CC) $(CFLAGS) $(LDFLAGS) -o $@ reglib.o regdbdump.o print-regdom.o $(LDLIBS)
 
-intersect: reglib.o intersect.o
+intersect: reglib.o intersect.o print-regdom.o
 	$(NQ) '  LD  ' $@
-	$(Q)$(CC) $(CFLAGS) $(LDFLAGS) -o $@ reglib.o intersect.o $(LDLIBS)
+	$(Q)$(CC) $(CFLAGS) $(LDFLAGS) -o $@ reglib.o intersect.o print-regdom.o $(LDLIBS)
 
 verify: $(REG_BIN) regdbdump
 	$(NQ) '  CHK  $(REG_BIN)'
diff --git a/print-regdom.c b/print-regdom.c
new file mode 100644
index 0000000..34b5ed4
--- /dev/null
+++ b/print-regdom.c
@@ -0,0 +1,122 @@
+#include <errno.h>
+#include <stdio.h>
+#include <string.h>
+#include <arpa/inet.h>
+#include "reglib.h"
+
+static void reg_rule2rd(__u8 *db, int dblen,
+	__be32 ruleptr, struct ieee80211_reg_rule *rd_reg_rule)
+{
+	struct regdb_file_reg_rule *rule;
+	struct regdb_file_freq_range *freq;
+	struct regdb_file_power_rule *power;
+
+	struct ieee80211_freq_range *rd_freq_range = &rd_reg_rule->freq_range;
+	struct ieee80211_power_rule *rd_power_rule = &rd_reg_rule->power_rule;
+
+	rule  = crda_get_file_ptr(db, dblen, sizeof(*rule), ruleptr);
+	freq  = crda_get_file_ptr(db, dblen, sizeof(*freq), rule->freq_range_ptr);
+	power = crda_get_file_ptr(db, dblen, sizeof(*power), rule->power_rule_ptr);
+
+	rd_freq_range->start_freq_khz = ntohl(freq->start_freq);
+	rd_freq_range->end_freq_khz = ntohl(freq->end_freq);
+	rd_freq_range->max_bandwidth_khz = ntohl(freq->max_bandwidth);
+
+	rd_power_rule->max_antenna_gain = ntohl(power->max_antenna_gain);
+	rd_power_rule->max_eirp = ntohl(power->max_eirp);
+
+	rd_reg_rule->flags = ntohl(rule->flags);
+}
+
+/* Converts a file regdomain to ieee80211_regdomain, easier to manage */
+struct ieee80211_regdomain *country2rd(__u8 *db, int dblen,
+	struct regdb_file_reg_country *country)
+{
+	struct regdb_file_reg_rules_collection *rcoll;
+	struct ieee80211_regdomain *rd;
+	int i, num_rules, size_of_rd;
+
+	rcoll = crda_get_file_ptr(db, dblen, sizeof(*rcoll),
+				country->reg_collection_ptr);
+	num_rules = ntohl(rcoll->reg_rule_num);
+	/* re-get pointer with sanity checking for num_rules */
+	rcoll = crda_get_file_ptr(db, dblen,
+			sizeof(*rcoll) + num_rules * sizeof(__be32),
+			country->reg_collection_ptr);
+
+	size_of_rd = sizeof(struct ieee80211_regdomain) +
+		num_rules * sizeof(struct ieee80211_reg_rule);
+
+	rd = malloc(size_of_rd);
+	if (!rd)
+		return NULL;
+
+	memset(rd, 0, size_of_rd);
+
+	rd->alpha2[0] = country->alpha2[0];
+	rd->alpha2[1] = country->alpha2[1];
+	rd->n_reg_rules = num_rules;
+
+	for (i = 0; i < num_rules; i++) {
+		reg_rule2rd(db, dblen, rcoll->reg_rule_ptrs[i],
+			&rd->reg_rules[i]);
+	}
+
+	return rd;
+}
+
+static void print_reg_rule(struct ieee80211_reg_rule *rule)
+{
+	struct ieee80211_freq_range *freq;
+	struct ieee80211_power_rule *power;
+
+	freq  = &rule->freq_range;
+	power = &rule->power_rule;
+
+	printf("\t(%.3f - %.3f @ %.3f), ",
+	       ((float)(freq->start_freq_khz))/1000.0,
+	       ((float)(freq->end_freq_khz))/1000.0,
+	       ((float)(freq->max_bandwidth_khz))/1000.0);
+
+	printf("(");
+
+	if (power->max_antenna_gain)
+		printf("%.2f, ", ((float)(power->max_antenna_gain)/100.0));
+	else
+		printf("N/A, ");
+
+	if (power->max_eirp)
+		printf("%.2f)", ((float)(power->max_eirp)/100.0));
+	else
+		printf("N/A)");
+
+	if (rule->flags & RRF_NO_OFDM)
+		printf(", NO-OFDM");
+	if (rule->flags & RRF_NO_CCK)
+		printf(", NO-CCK");
+	if (rule->flags & RRF_NO_INDOOR)
+		printf(", NO-INDOOR");
+	if (rule->flags & RRF_NO_OUTDOOR)
+		printf(", NO-OUTDOOR");
+	if (rule->flags & RRF_DFS)
+		printf(", DFS");
+	if (rule->flags & RRF_PTP_ONLY)
+		printf(", PTP-ONLY");
+	if (rule->flags & RRF_PTMP_ONLY)
+		printf(", PTMP-ONLY");
+	if (rule->flags & RRF_PASSIVE_SCAN)
+		printf(", PASSIVE-SCAN");
+	if (rule->flags & RRF_NO_IBSS)
+		printf(", NO-IBSS");
+
+	printf("\n");
+}
+
+void print_regdom(struct ieee80211_regdomain *rd)
+{
+	unsigned int i;
+	printf("country %.2s:\n", rd->alpha2);
+	for (i = 0; i < rd->n_reg_rules; i++)
+		print_reg_rule(&rd->reg_rules[i]);
+	printf("\n");
+}
diff --git a/reglib.c b/reglib.c
index e02bd8f..3bc1da9 100644
--- a/reglib.c
+++ b/reglib.c
@@ -1,6 +1,5 @@
 #include <errno.h>
 #include <stdio.h>
-#include <string.h>
 #include <arpa/inet.h>
 #include "reglib.h"
 
@@ -133,121 +132,3 @@ out:
 	return 1;
 #endif
 }
-
-static void reg_rule2rd(__u8 *db, int dblen,
-	__be32 ruleptr, struct ieee80211_reg_rule *rd_reg_rule)
-{
-	struct regdb_file_reg_rule *rule;
-	struct regdb_file_freq_range *freq;
-	struct regdb_file_power_rule *power;
-
-	struct ieee80211_freq_range *rd_freq_range = &rd_reg_rule->freq_range;
-	struct ieee80211_power_rule *rd_power_rule = &rd_reg_rule->power_rule;
-
-	rule  = crda_get_file_ptr(db, dblen, sizeof(*rule), ruleptr);
-	freq  = crda_get_file_ptr(db, dblen, sizeof(*freq), rule->freq_range_ptr);
-	power = crda_get_file_ptr(db, dblen, sizeof(*power), rule->power_rule_ptr);
-
-	rd_freq_range->start_freq_khz = ntohl(freq->start_freq);
-	rd_freq_range->end_freq_khz = ntohl(freq->end_freq);
-	rd_freq_range->max_bandwidth_khz = ntohl(freq->max_bandwidth);
-
-	rd_power_rule->max_antenna_gain = ntohl(power->max_antenna_gain);
-	rd_power_rule->max_eirp = ntohl(power->max_eirp);
-
-	rd_reg_rule->flags = ntohl(rule->flags);
-}
-
-/* Converts a file regdomain to ieee80211_regdomain, easier to manage */
-struct ieee80211_regdomain *country2rd(__u8 *db, int dblen,
-	struct regdb_file_reg_country *country)
-{
-	struct regdb_file_reg_rules_collection *rcoll;
-	struct ieee80211_regdomain *rd;
-	int i, num_rules, size_of_rd;
-
-	rcoll = crda_get_file_ptr(db, dblen, sizeof(*rcoll),
-				country->reg_collection_ptr);
-	num_rules = ntohl(rcoll->reg_rule_num);
-	/* re-get pointer with sanity checking for num_rules */
-	rcoll = crda_get_file_ptr(db, dblen,
-			sizeof(*rcoll) + num_rules * sizeof(__be32),
-			country->reg_collection_ptr);
-
-	size_of_rd = sizeof(struct ieee80211_regdomain) +
-		num_rules * sizeof(struct ieee80211_reg_rule);
-
-	rd = malloc(size_of_rd);
-	if (!rd)
-		return NULL;
-
-	memset(rd, 0, size_of_rd);
-
-	rd->alpha2[0] = country->alpha2[0];
-	rd->alpha2[1] = country->alpha2[1];
-	rd->n_reg_rules = num_rules;
-
-	for (i = 0; i < num_rules; i++) {
-		reg_rule2rd(db, dblen, rcoll->reg_rule_ptrs[i],
-			&rd->reg_rules[i]);
-	}
-
-	return rd;
-}
-
-static void print_reg_rule(struct ieee80211_reg_rule *rule)
-{
-	struct ieee80211_freq_range *freq;
-	struct ieee80211_power_rule *power;
-
-	freq  = &rule->freq_range;
-	power = &rule->power_rule;
-
-	printf("\t(%.3f - %.3f @ %.3f), ",
-	       ((float)(freq->start_freq_khz))/1000.0,
-	       ((float)(freq->end_freq_khz))/1000.0,
-	       ((float)(freq->max_bandwidth_khz))/1000.0);
-
-	printf("(");
-
-	if (power->max_antenna_gain)
-		printf("%.2f, ", ((float)(power->max_antenna_gain)/100.0));
-	else
-		printf("N/A, ");
-
-	if (power->max_eirp)
-		printf("%.2f)", ((float)(power->max_eirp)/100.0));
-	else
-		printf("N/A)");
-
-	if (rule->flags & RRF_NO_OFDM)
-		printf(", NO-OFDM");
-	if (rule->flags & RRF_NO_CCK)
-		printf(", NO-CCK");
-	if (rule->flags & RRF_NO_INDOOR)
-		printf(", NO-INDOOR");
-	if (rule->flags & RRF_NO_OUTDOOR)
-		printf(", NO-OUTDOOR");
-	if (rule->flags & RRF_DFS)
-		printf(", DFS");
-	if (rule->flags & RRF_PTP_ONLY)
-		printf(", PTP-ONLY");
-	if (rule->flags & RRF_PTMP_ONLY)
-		printf(", PTMP-ONLY");
-	if (rule->flags & RRF_PASSIVE_SCAN)
-		printf(", PASSIVE-SCAN");
-	if (rule->flags & RRF_NO_IBSS)
-		printf(", NO-IBSS");
-
-	printf("\n");
-}
-
-void print_regdom(struct ieee80211_regdomain *rd)
-{
-	unsigned int i;
-	printf("country %.2s:\n", rd->alpha2);
-	for (i = 0; i < rd->n_reg_rules; i++)
-		print_reg_rule(&rd->reg_rules[i]);
-	printf("\n");
-}
-

