Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f179.google.com ([209.85.192.179]:54756 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751924Ab3EaCLh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 May 2013 22:11:37 -0400
Received: by mail-pd0-f179.google.com with SMTP id q11so1375842pdj.38
        for <linux-wireless@vger.kernel.org>; Thu, 30 May 2013 19:11:37 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: wireless-regdb@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 26/40] crda: move reg print helpers to reglib
Date: Thu, 30 May 2013 19:09:15 -0700
Message-Id: <1369966169-23640-27-git-send-email-mcgrof@do-not-panic.com> (sfid-20130531_042938_101429_48692722)
In-Reply-To: <1369966169-23640-1-git-send-email-mcgrof@do-not-panic.com>
References: <1369966169-23640-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>

Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 Makefile       |    4 +--
 print-regdom.c |   80 --------------------------------------------------------
 reglib.c       |   73 +++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 75 insertions(+), 82 deletions(-)
 delete mode 100644 print-regdom.c

diff --git a/Makefile b/Makefile
index 1d34bde..7d2e33f 100644
--- a/Makefile
+++ b/Makefile
@@ -113,11 +113,11 @@ crda: reglib.o crda.o
 	$(NQ) '  LD  ' $@
 	$(Q)$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $^ $(LDLIBS) $(NLLIBS)
 
-regdbdump: reglib.o regdbdump.o print-regdom.o
+regdbdump: reglib.o regdbdump.o
 	$(NQ) '  LD  ' $@
 	$(Q)$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $^ $(LDLIBS)
 
-intersect: reglib.o intersect.o print-regdom.o
+intersect: reglib.o intersect.o
 	$(NQ) '  LD  ' $@
 	$(Q)$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $^ $(LDLIBS)
 
diff --git a/print-regdom.c b/print-regdom.c
deleted file mode 100644
index 68c7b4e..0000000
--- a/print-regdom.c
+++ /dev/null
@@ -1,80 +0,0 @@
-#include <errno.h>
-#include <stdio.h>
-#include <string.h>
-#include <arpa/inet.h>
-
-#include "reglib.h"
-#include "regdb.h"
-
-static const char *dfs_domain_name(enum regdb_dfs_regions region)
-{
-	switch (region) {
-	case REGDB_DFS_UNSET:
-		return "DFS-UNSET";
-	case REGDB_DFS_FCC:
-		return "DFS-FCC";
-	case REGDB_DFS_ETSI:
-		return "DFS-ETSI";
-	case REGDB_DFS_JP:
-		return "DFS-JP";
-	default:
-		return "DFS-invalid";
-	}
-}
-
-static void print_reg_rule(const struct ieee80211_reg_rule *rule)
-{
-	const struct ieee80211_freq_range *freq;
-	const struct ieee80211_power_rule *power;
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
-void reglib_print_regdom(const struct ieee80211_regdomain *rd)
-{
-	unsigned int i;
-	printf("country %.2s: %s\n", rd->alpha2,
-	       dfs_domain_name(rd->dfs_region));
-	for (i = 0; i < rd->n_reg_rules; i++)
-		print_reg_rule(&rd->reg_rules[i]);
-	printf("\n");
-}
diff --git a/reglib.c b/reglib.c
index 316e201..0d258d8 100644
--- a/reglib.c
+++ b/reglib.c
@@ -553,3 +553,76 @@ reglib_intersect_rds(const struct ieee80211_regdomain *rd1,
 
 	return rd;
 }
+
+static const char *dfs_domain_name(enum regdb_dfs_regions region)
+{
+	switch (region) {
+	case REGDB_DFS_UNSET:
+		return "DFS-UNSET";
+	case REGDB_DFS_FCC:
+		return "DFS-FCC";
+	case REGDB_DFS_ETSI:
+		return "DFS-ETSI";
+	case REGDB_DFS_JP:
+		return "DFS-JP";
+	default:
+		return "DFS-invalid";
+	}
+}
+
+static void print_reg_rule(const struct ieee80211_reg_rule *rule)
+{
+	const struct ieee80211_freq_range *freq;
+	const struct ieee80211_power_rule *power;
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
+void reglib_print_regdom(const struct ieee80211_regdomain *rd)
+{
+	unsigned int i;
+	printf("country %.2s: %s\n", rd->alpha2,
+	       dfs_domain_name(rd->dfs_region));
+	for (i = 0; i < rd->n_reg_rules; i++)
+		print_reg_rule(&rd->reg_rules[i]);
+	printf("\n");
+}
-- 
1.7.10.4

