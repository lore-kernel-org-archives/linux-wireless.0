Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f172.google.com ([209.85.192.172]:56642 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751800Ab3EaCLQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 May 2013 22:11:16 -0400
Received: by mail-pd0-f172.google.com with SMTP id 10so1386538pdi.17
        for <linux-wireless@vger.kernel.org>; Thu, 30 May 2013 19:11:16 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: wireless-regdb@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 21/40] crda: rename crda_get_file_ptr() to reglib_get_file_ptr()
Date: Thu, 30 May 2013 19:09:10 -0700
Message-Id: <1369966169-23640-22-git-send-email-mcgrof@do-not-panic.com> (sfid-20130531_042939_051816_B839BB61)
In-Reply-To: <1369966169-23640-1-git-send-email-mcgrof@do-not-panic.com>
References: <1369966169-23640-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>

Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 reglib.c |   20 ++++++++++----------
 reglib.h |    2 +-
 2 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/reglib.c b/reglib.c
index 333db7a..a957f0e 100644
--- a/reglib.c
+++ b/reglib.c
@@ -37,7 +37,7 @@
 #include "keys-gcrypt.c"
 #endif
 
-void *crda_get_file_ptr(uint8_t *db, int dblen, int structlen, uint32_t ptr)
+void *reglib_get_file_ptr(uint8_t *db, int dblen, int structlen, uint32_t ptr)
 {
 	uint32_t p = ntohl(ptr);
 
@@ -196,9 +196,9 @@ static void reg_rule2rd(uint8_t *db, int dblen,
 	struct ieee80211_freq_range *rd_freq_range = &rd_reg_rule->freq_range;
 	struct ieee80211_power_rule *rd_power_rule = &rd_reg_rule->power_rule;
 
-	rule  = crda_get_file_ptr(db, dblen, sizeof(*rule), ruleptr);
-	freq  = crda_get_file_ptr(db, dblen, sizeof(*freq), rule->freq_range_ptr);
-	power = crda_get_file_ptr(db, dblen, sizeof(*power), rule->power_rule_ptr);
+	rule  = reglib_get_file_ptr(db, dblen, sizeof(*rule), ruleptr);
+	freq  = reglib_get_file_ptr(db, dblen, sizeof(*freq), rule->freq_range_ptr);
+	power = reglib_get_file_ptr(db, dblen, sizeof(*power), rule->power_rule_ptr);
 
 	rd_freq_range->start_freq_khz = ntohl(freq->start_freq);
 	rd_freq_range->end_freq_khz = ntohl(freq->end_freq);
@@ -219,11 +219,11 @@ country2rd(uint8_t *db, int dblen,
 	struct ieee80211_regdomain *rd;
 	int i, num_rules, size_of_rd;
 
-	rcoll = crda_get_file_ptr(db, dblen, sizeof(*rcoll),
+	rcoll = reglib_get_file_ptr(db, dblen, sizeof(*rcoll),
 				country->reg_collection_ptr);
 	num_rules = ntohl(rcoll->reg_rule_num);
 	/* re-get pointer with sanity checking for num_rules */
-	rcoll = crda_get_file_ptr(db, dblen,
+	rcoll = reglib_get_file_ptr(db, dblen,
 			sizeof(*rcoll) + num_rules * sizeof(uint32_t),
 			country->reg_collection_ptr);
 
@@ -279,7 +279,7 @@ reglib_get_rd_idx(unsigned int idx, const char *file)
 		return NULL;
 	}
 
-	header = crda_get_file_ptr(db, dblen, sizeof(*header), 0);
+	header = reglib_get_file_ptr(db, dblen, sizeof(*header), 0);
 
 	if (ntohl(header->magic) != REGDB_MAGIC)
 		goto out;
@@ -299,7 +299,7 @@ reglib_get_rd_idx(unsigned int idx, const char *file)
 		goto out;
 
 	num_countries = ntohl(header->reg_country_num);
-	countries = crda_get_file_ptr(db, dblen,
+	countries = reglib_get_file_ptr(db, dblen,
 			sizeof(struct regdb_file_reg_country) * num_countries,
 			header->reg_country_ptr);
 
@@ -350,7 +350,7 @@ reglib_get_rd_alpha2(const char *alpha2, const char *file)
 		return NULL;
 	}
 
-	header = crda_get_file_ptr(db, dblen, sizeof(*header), 0);
+	header = reglib_get_file_ptr(db, dblen, sizeof(*header), 0);
 
 	if (ntohl(header->magic) != REGDB_MAGIC)
 		goto out;
@@ -370,7 +370,7 @@ reglib_get_rd_alpha2(const char *alpha2, const char *file)
 		goto out;
 
 	num_countries = ntohl(header->reg_country_num);
-	countries = crda_get_file_ptr(db, dblen,
+	countries = reglib_get_file_ptr(db, dblen,
 			sizeof(struct regdb_file_reg_country) * num_countries,
 			header->reg_country_ptr);
 
diff --git a/reglib.h b/reglib.h
index 529772d..3510889 100644
--- a/reglib.h
+++ b/reglib.h
@@ -70,7 +70,7 @@ static inline uint32_t min(uint32_t a, uint32_t b)
 	return (a > b) ? b : a;
 }
 
-void *crda_get_file_ptr(uint8_t *db, int dblen, int structlen, uint32_t ptr);
+void *reglib_get_file_ptr(uint8_t *db, int dblen, int structlen, uint32_t ptr);
 int crda_verify_db_signature(uint8_t *db, int dblen, int siglen);
 
 const struct ieee80211_regdomain *
-- 
1.7.10.4

