Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f51.google.com ([209.85.160.51]:53380 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751790Ab3EaCJy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 May 2013 22:09:54 -0400
Received: by mail-pb0-f51.google.com with SMTP id jt11so1376399pbb.24
        for <linux-wireless@vger.kernel.org>; Thu, 30 May 2013 19:09:54 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: wireless-regdb@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 04/40] crda: constify usage of struct ieee80211_regdomain
Date: Thu, 30 May 2013 19:08:53 -0700
Message-Id: <1369966169-23640-5-git-send-email-mcgrof@do-not-panic.com> (sfid-20130531_040957_770961_A8DB5473)
In-Reply-To: <1369966169-23640-1-git-send-email-mcgrof@do-not-panic.com>
References: <1369966169-23640-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>

Where we can use const.

Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 crda.c         |   12 ++++++------
 intersect.c    |   33 ++++++++++++++++++---------------
 print-regdom.c |    8 ++++----
 regdbdump.c    |    4 ++--
 reglib.c       |   10 +++++-----
 reglib.h       |    6 +++---
 6 files changed, 38 insertions(+), 35 deletions(-)

diff --git a/crda.c b/crda.c
index cdbc69a..fc7a25f 100644
--- a/crda.c
+++ b/crda.c
@@ -116,10 +116,10 @@ static int error_handler(struct sockaddr_nl __attribute__((unused)) *nla,
 	exit(err->error);
 }
 
-static int put_reg_rule(struct ieee80211_reg_rule *rule, struct nl_msg *msg)
+static int put_reg_rule(const struct ieee80211_reg_rule *rule, struct nl_msg *msg)
 {
-	struct ieee80211_freq_range *freq_range;
-	struct ieee80211_power_rule *power_rule;
+	const struct ieee80211_freq_range *freq_range;
+	const struct ieee80211_power_rule *power_rule;
 
 	freq_range = &rule->freq_range;
 	power_rule = &rule->power_rule;
@@ -149,7 +149,7 @@ int main(int argc, char **argv)
 	int finished = 0;
 
 	struct nlattr *nl_reg_rules;
-	struct ieee80211_regdomain *rd = NULL;
+	const struct ieee80211_regdomain *rd = NULL;
 
 	const char *regdb_paths[] = {
 		"/usr/local/lib/crda/regulatory.bin", /* Users/preloads can override */
@@ -199,7 +199,7 @@ int main(int argc, char **argv)
 
 	r = nl80211_init(&nlstate);
 	if (r) {
-		free(rd);
+		free((struct ieee80211_regdomain *) rd);
 		return -EIO;
 	}
 
@@ -267,7 +267,7 @@ nla_put_failure:
 	nlmsg_free(msg);
 out:
 	nl80211_cleanup(&nlstate);
-	free(rd);
+	free((struct ieee80211_regdomain *) rd);
 
 	return r;
 }
diff --git a/intersect.c b/intersect.c
index bd2976f..59fd007 100644
--- a/intersect.c
+++ b/intersect.c
@@ -39,13 +39,14 @@ static int is_valid_reg_rule(const struct ieee80211_reg_rule *rule)
 
 /* Helper for regdom_intersect(), this does the real
  * mathematical intersection fun */
-static int reg_rules_intersect(
-	struct ieee80211_reg_rule *rule1,
-	struct ieee80211_reg_rule *rule2,
-	struct ieee80211_reg_rule *intersected_rule)
+static int reg_rules_intersect(const struct ieee80211_reg_rule *rule1,
+			       const struct ieee80211_reg_rule *rule2,
+			       struct ieee80211_reg_rule *intersected_rule)
 {
-	struct ieee80211_freq_range *freq_range1, *freq_range2, *freq_range;
-	struct ieee80211_power_rule *power_rule1, *power_rule2, *power_rule;
+	const struct ieee80211_freq_range *freq_range1, *freq_range2;
+	struct ieee80211_freq_range *freq_range;
+	const struct ieee80211_power_rule *power_rule1, *power_rule2;
+	struct ieee80211_power_rule *power_rule;
 	uint32_t freq_diff;
 
 	freq_range1 = &rule1->freq_range;
@@ -93,14 +94,15 @@ static int reg_rules_intersect(
  * resulting intersection of rules between rd1 and rd2. We will
  * malloc() this structure for you.
  */
-static struct ieee80211_regdomain *regdom_intersect(
-	struct ieee80211_regdomain *rd1,
-	struct ieee80211_regdomain *rd2)
+static struct ieee80211_regdomain *
+regdom_intersect(const struct ieee80211_regdomain *rd1,
+		 const struct ieee80211_regdomain *rd2)
 {
 	int r, size_of_regd;
 	unsigned int x, y;
 	unsigned int num_rules = 0, rule_idx = 0;
-	struct ieee80211_reg_rule *rule1, *rule2, *intersected_rule;
+	const struct ieee80211_reg_rule *rule1, *rule2;
+	struct ieee80211_reg_rule *intersected_rule;
 	struct ieee80211_regdomain *rd;
 	/* This is just a dummy holder to help us count */
 	struct ieee80211_reg_rule irule;
@@ -174,7 +176,8 @@ static struct ieee80211_regdomain *regdom_intersect(
 int main(int argc, char **argv)
 {
 	int r = 0;
-	struct ieee80211_regdomain *prev_world = NULL, *rd = NULL, *world = NULL;
+	const struct ieee80211_regdomain *rd;
+	struct ieee80211_regdomain *prev_world = NULL, *world = NULL;
 	int intersected = 0;
 	unsigned int idx = 0;
 
@@ -189,13 +192,13 @@ int main(int argc, char **argv)
 			continue;
 
 		if (!prev_world) {
-			prev_world = rd;
+			prev_world = (struct ieee80211_regdomain *) rd;
 			continue;
 		}
 
 		if (world) {
 			free(prev_world);
-			prev_world = world;
+			prev_world = (struct ieee80211_regdomain *) world;
 		}
 
 		world = regdom_intersect(prev_world, rd);
@@ -235,7 +238,7 @@ int main(int argc, char **argv)
 	}
 
 	if (idx == 1) {
-		world = rd;
+		world = (struct ieee80211_regdomain *) rd;
 		rd = NULL;
 	}
 
@@ -255,7 +258,7 @@ out:
 		return r;
 	}
 	if (intersected > 1) {
-		free(rd);
+		free((struct ieee80211_regdomain *)rd);
 		free(prev_world);
 	}
 	free(world);
diff --git a/print-regdom.c b/print-regdom.c
index 9c65872..abd6488 100644
--- a/print-regdom.c
+++ b/print-regdom.c
@@ -23,10 +23,10 @@ static const char *dfs_domain_name(enum nl80211_dfs_regions region)
 	}
 }
 
-static void print_reg_rule(struct ieee80211_reg_rule *rule)
+static void print_reg_rule(const struct ieee80211_reg_rule *rule)
 {
-	struct ieee80211_freq_range *freq;
-	struct ieee80211_power_rule *power;
+	const struct ieee80211_freq_range *freq;
+	const struct ieee80211_power_rule *power;
 
 	freq  = &rule->freq_range;
 	power = &rule->power_rule;
@@ -70,7 +70,7 @@ static void print_reg_rule(struct ieee80211_reg_rule *rule)
 	printf("\n");
 }
 
-void print_regdom(struct ieee80211_regdomain *rd)
+void print_regdom(const struct ieee80211_regdomain *rd)
 {
 	unsigned int i;
 	printf("country %.2s: %s\n", rd->alpha2,
diff --git a/regdbdump.c b/regdbdump.c
index 6f9592a..26cbef7 100644
--- a/regdbdump.c
+++ b/regdbdump.c
@@ -3,7 +3,7 @@
 
 int main(int argc, char **argv)
 {
-	struct ieee80211_regdomain *rd = NULL;
+	const struct ieee80211_regdomain *rd = NULL;
 	unsigned int idx = 0;
 
 	if (argc != 2) {
@@ -13,7 +13,7 @@ int main(int argc, char **argv)
 
 	reglib_for_each_country(rd, idx, argv[1]) {
 		print_regdom(rd);
-		free(rd);
+		free((struct ieee80211_regdomain *) rd);
 	}
 
 	return 0;
diff --git a/reglib.c b/reglib.c
index 1fafd37..0b1599b 100644
--- a/reglib.c
+++ b/reglib.c
@@ -188,7 +188,7 @@ static void reg_rule2rd(uint8_t *db, int dblen,
 }
 
 /* Converts a file regdomain to ieee80211_regdomain, easier to manage */
-static struct ieee80211_regdomain *
+const static struct ieee80211_regdomain *
 country2rd(uint8_t *db, int dblen,
 	   struct regdb_file_reg_country *country)
 {
@@ -226,7 +226,7 @@ country2rd(uint8_t *db, int dblen,
 	return rd;
 }
 
-struct ieee80211_regdomain *
+const struct ieee80211_regdomain *
 reglib_get_rd_idx(unsigned int idx, const char *file)
 {
 	int fd;
@@ -235,7 +235,7 @@ reglib_get_rd_idx(unsigned int idx, const char *file)
 	struct regdb_file_header *header;
 	struct regdb_file_reg_country *countries;
 	int dblen, siglen, num_countries;
-	struct ieee80211_regdomain *rd = NULL;
+	const struct ieee80211_regdomain *rd = NULL;
 	struct regdb_file_reg_country *country;
 
 	fd = open(file, O_RDONLY);
@@ -288,7 +288,7 @@ reglib_get_rd_idx(unsigned int idx, const char *file)
 	return rd;
 }
 
-struct ieee80211_regdomain *
+const struct ieee80211_regdomain *
 reglib_get_rd_alpha2(const char *alpha2, const char *file)
 {
 	int fd;
@@ -297,7 +297,7 @@ reglib_get_rd_alpha2(const char *alpha2, const char *file)
 	struct regdb_file_header *header;
 	struct regdb_file_reg_country *countries;
 	int dblen, siglen, num_countries;
-	struct ieee80211_regdomain *rd = NULL;
+	const struct ieee80211_regdomain *rd = NULL;
 	struct regdb_file_reg_country *country;
 	unsigned int i;
 	bool found_country = false;
diff --git a/reglib.h b/reglib.h
index 9b9bd5c..e5da38b 100644
--- a/reglib.h
+++ b/reglib.h
@@ -73,7 +73,7 @@ static inline uint32_t min(uint32_t a, uint32_t b)
 void *crda_get_file_ptr(uint8_t *db, int dblen, int structlen, uint32_t ptr);
 int crda_verify_db_signature(uint8_t *db, int dblen, int siglen);
 
-struct ieee80211_regdomain *
+const struct ieee80211_regdomain *
 reglib_get_rd_idx(unsigned int idx, const char *file);
 
 #define reglib_for_each_country(__rd, __idx, __file)			\
@@ -82,10 +82,10 @@ reglib_get_rd_idx(unsigned int idx, const char *file);
 	     __rd = reglib_get_rd_idx(__idx, __file),		\
 	     __idx++)
 
-struct ieee80211_regdomain *
+const struct ieee80211_regdomain *
 reglib_get_rd_alpha2(const char *alpha2, const char *file);
 
 /* reg helpers */
-void print_regdom(struct ieee80211_regdomain *rd);
+void print_regdom(const struct ieee80211_regdomain *rd);
 
 #endif
-- 
1.7.10.4

