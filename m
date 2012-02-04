Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:54915 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751365Ab2BDBZ4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Feb 2012 20:25:56 -0500
Received: by mail-pz0-f46.google.com with SMTP id p15so3176528dad.19
        for <linux-wireless@vger.kernel.org>; Fri, 03 Feb 2012 17:25:55 -0800 (PST)
From: "Luis R. Rodriguez" <mcgrof@frijolero.org>
To: linux-wireless@vger.kernel.org
Cc: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Subject: [RFC 01/11] crda: move country2rd() and its helper to reglib.c
Date: Fri,  3 Feb 2012 17:25:38 -0800
Message-Id: <1328318748-21044-2-git-send-email-mcgrof@frijolero.org> (sfid-20120204_022605_235126_4D7E01B4)
In-Reply-To: <1328318748-21044-1-git-send-email-mcgrof@frijolero.org>
References: <1328318748-21044-1-git-send-email-mcgrof@frijolero.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Start cleaning the way we deal with reglib.c as the goal
is to make that stuff a library to be shared first in
userspace with the regulatory simulator [0]. We start
off by moving country2rd() and its helper over to
reglib.c.

[0] git://github.com/mcgrof/regsim.git

Signed-off-by: Luis R. Rodriguez <mcgrof@frijolero.org>
---
 print-regdom.c |   61 --------------------------------------------------------
 reglib.c       |   61 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 61 insertions(+), 61 deletions(-)

diff --git a/print-regdom.c b/print-regdom.c
index f34a8db..a3bedeb 100644
--- a/print-regdom.c
+++ b/print-regdom.c
@@ -4,67 +4,6 @@
 #include <arpa/inet.h>
 #include "reglib.h"
 
-static void reg_rule2rd(uint8_t *db, int dblen,
-	uint32_t ruleptr, struct ieee80211_reg_rule *rd_reg_rule)
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
-struct ieee80211_regdomain *country2rd(uint8_t *db, int dblen,
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
-			sizeof(*rcoll) + num_rules * sizeof(uint32_t),
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
 static void print_reg_rule(struct ieee80211_reg_rule *rule)
 {
 	struct ieee80211_freq_range *freq;
diff --git a/reglib.c b/reglib.c
index ebf0fb1..5d66481 100644
--- a/reglib.c
+++ b/reglib.c
@@ -151,3 +151,64 @@ out:
 	return 1;
 #endif
 }
+
+static void reg_rule2rd(uint8_t *db, int dblen,
+	uint32_t ruleptr, struct ieee80211_reg_rule *rd_reg_rule)
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
+struct ieee80211_regdomain *country2rd(uint8_t *db, int dblen,
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
+			sizeof(*rcoll) + num_rules * sizeof(uint32_t),
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
-- 
1.7.4.15.g7811d

