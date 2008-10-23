Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.188]:37657 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752760AbYJWXGN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Oct 2008 19:06:13 -0400
Received: by fk-out-0910.google.com with SMTP id 18so373113fkq.5
        for <linux-wireless@vger.kernel.org>; Thu, 23 Oct 2008 16:06:12 -0700 (PDT)
Date: Fri, 24 Oct 2008 01:06:06 +0200
From: Davide Pesavento <davidepesa@gmail.com>
To: mcgrof@gmail.com
Cc: linux-wireless@vger.kernel.org
Subject: [CRDA PATCH 3/6] Unify and share get_file_ptr() too.
Message-ID: <20081023230606.GA8853@PesaBook.pesa.homelinux.org> (sfid-20081024_010616_541604_F04AC46F)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Identical code used by both crda.c and dump.c

Signed-off-by: Davide Pesavento <davidepesa@gmail.com>
---
 crda.c  |   34 ++++++++++------------------------
 dump.c  |   31 ++++++++++---------------------
 regdb.c |   17 +++++++++++++++--
 regdb.h |    1 +
 4 files changed, 36 insertions(+), 47 deletions(-)

diff --git a/crda.c b/crda.c
index cf493e8..a465ead 100644
--- a/crda.c
+++ b/crda.c
@@ -125,30 +125,15 @@ static int is_valid_regdom(const char * alpha2)
 	return 1;
 }
 
-/* ptr is 32 big endian. You don't need to convert it before passing to this
- * function */
-
-static void *get_file_ptr(__u8 *db, int dblen, int structlen, __be32 ptr)
-{
-	__u32 p = ntohl(ptr);
-
-	if (p > dblen - structlen) {
-		fprintf(stderr, "Invalid database file, bad pointer!\n");
-		exit(3);
-	}
-
-	return (void *)(db + p);
-}
-
 static int put_reg_rule(__u8 *db, int dblen, __be32 ruleptr, struct nl_msg *msg)
 {
 	struct regdb_file_reg_rule *rule;
 	struct regdb_file_freq_range *freq;
 	struct regdb_file_power_rule *power;
 
-	rule	= get_file_ptr(db, dblen, sizeof(*rule), ruleptr);
-	freq	= get_file_ptr(db, dblen, sizeof(*freq), rule->freq_range_ptr);
-	power	= get_file_ptr(db, dblen, sizeof(*power), rule->power_rule_ptr);
+	rule  = crda_get_file_ptr(db, dblen, sizeof(*rule), ruleptr);
+	freq  = crda_get_file_ptr(db, dblen, sizeof(*freq), rule->freq_range_ptr);
+	power = crda_get_file_ptr(db, dblen, sizeof(*power), rule->power_rule_ptr);
 
 	NLA_PUT_U32(msg, NL80211_ATTR_REG_RULE_FLAGS,		ntohl(rule->flags));
 	NLA_PUT_U32(msg, NL80211_ATTR_FREQ_RANGE_START,		ntohl(freq->start_freq));
@@ -225,7 +210,7 @@ int main(int argc, char **argv)
 	}
 
 	/* db file starts with a struct regdb_file_header */
-	header = get_file_ptr(db, dblen, sizeof(*header), 0);
+	header = crda_get_file_ptr(db, dblen, sizeof(*header), 0);
 
 	if (ntohl(header->magic) != REGDB_MAGIC) {
 		fprintf(stderr, "Invalid database magic\n");
@@ -251,7 +236,7 @@ int main(int argc, char **argv)
 		return -EINVAL;
 
 	num_countries = ntohl(header->reg_country_num);
-	countries = get_file_ptr(db, dblen,
+	countries = crda_get_file_ptr(db, dblen,
 				 sizeof(struct regdb_file_reg_country) * num_countries,
 				 header->reg_country_ptr);
 
@@ -282,12 +267,13 @@ int main(int argc, char **argv)
 	genlmsg_put(msg, 0, 0, genl_family_get_id(nlstate.nl80211), 0,
 		0, NL80211_CMD_SET_REG, 0);
 
-	rcoll = get_file_ptr(db, dblen, sizeof(*rcoll), country->reg_collection_ptr);
+	rcoll = crda_get_file_ptr(db, dblen, sizeof(*rcoll),
+				country->reg_collection_ptr);
 	num_rules = ntohl(rcoll->reg_rule_num);
 	/* re-get pointer with sanity checking for num_rules */
-	rcoll = get_file_ptr(db, dblen,
-			     sizeof(*rcoll) + num_rules * sizeof(__be32),
-			     country->reg_collection_ptr);
+	rcoll = crda_get_file_ptr(db, dblen,
+				sizeof(*rcoll) + num_rules * sizeof(__be32),
+				country->reg_collection_ptr);
 
 	NLA_PUT_STRING(msg, NL80211_ATTR_REG_ALPHA2, (char *) country->alpha2);
 
diff --git a/dump.c b/dump.c
index 89f16b2..0580424 100644
--- a/dump.c
+++ b/dump.c
@@ -8,18 +8,6 @@
 
 #include "regdb.h"
 
-static void *get_file_ptr(__u8 *db, int dblen, int structlen, __be32 ptr)
-{
-	__u32 p = ntohl(ptr);
-
-	if (p > dblen - structlen) {
-		fprintf(stderr, "Invalid database file, bad pointer!\n");
-		exit(3);
-	}
-
-	return (void *)(db + p);
-}
-
 static void print_reg_rule(__u8 *db, int dblen, __be32 ruleptr)
 {
 	struct regdb_file_reg_rule *rule;
@@ -27,9 +15,9 @@ static void print_reg_rule(__u8 *db, int dblen, __be32 ruleptr)
 	struct regdb_file_power_rule *power;
 	__u32 flags;
 
-	rule = get_file_ptr(db, dblen, sizeof(*rule), ruleptr);
-	freq = get_file_ptr(db, dblen, sizeof(*freq), rule->freq_range_ptr);
-	power = get_file_ptr(db, dblen, sizeof(*power), rule->power_rule_ptr);
+	rule  = crda_get_file_ptr(db, dblen, sizeof(*rule), ruleptr);
+	freq  = crda_get_file_ptr(db, dblen, sizeof(*freq), rule->freq_range_ptr);
+	power = crda_get_file_ptr(db, dblen, sizeof(*power), rule->power_rule_ptr);
 
 	printf("\t(%.3f - %.3f @ %.3f), ",
 	       ((float)ntohl(freq->start_freq))/1000.0,
@@ -104,7 +92,7 @@ int main(int argc, char **argv)
 		return 2;
 	}
 
-	header = get_file_ptr(db, dblen, sizeof(*header), 0);
+	header = crda_get_file_ptr(db, dblen, sizeof(*header), 0);
 
 	if (ntohl(header->magic) != REGDB_MAGIC) {
 		fprintf(stderr, "Invalid database magic\n");
@@ -130,7 +118,7 @@ int main(int argc, char **argv)
 		return -EINVAL;
 
 	num_countries = ntohl(header->reg_country_num);
-	countries = get_file_ptr(db, dblen,
+	countries = crda_get_file_ptr(db, dblen,
 				 sizeof(struct regdb_file_reg_country) * num_countries,
 				 header->reg_country_ptr);
 
@@ -140,12 +128,13 @@ int main(int argc, char **argv)
 		int num_rules;
 
 		printf("country %.2s:\n", country->alpha2);
-		rcoll = get_file_ptr(db, dblen, sizeof(*rcoll), country->reg_collection_ptr);
+		rcoll = crda_get_file_ptr(db, dblen, sizeof(*rcoll),
+					country->reg_collection_ptr);
 		num_rules = ntohl(rcoll->reg_rule_num);
 		/* re-get pointer with sanity checking for num_rules */
-		rcoll = get_file_ptr(db, dblen,
-				     sizeof(*rcoll) + num_rules * sizeof(__be32),
-				     country->reg_collection_ptr);
+		rcoll = crda_get_file_ptr(db, dblen,
+				sizeof(*rcoll) + num_rules * sizeof(__be32),
+				country->reg_collection_ptr);
 		for (j = 0; j < num_rules; j++)
 			print_reg_rule(db, dblen, rcoll->reg_rule_ptrs[j]);
 		printf("\n");
diff --git a/regdb.c b/regdb.c
index 385ba7d..f786ae3 100644
--- a/regdb.c
+++ b/regdb.c
@@ -1,12 +1,13 @@
-#ifdef USE_OPENSSL
 #include <stdio.h>
+#include <arpa/inet.h>
+
+#ifdef USE_OPENSSL
 #include <openssl/objects.h>
 #include <openssl/rsa.h>
 #include <openssl/sha.h>
 #endif
 
 #ifdef USE_GCRYPT
-#include <stdio.h>
 #include <gcrypt.h>
 #endif
 
@@ -20,6 +21,18 @@
 #include "keys-gcrypt.c"
 #endif
 
+void *crda_get_file_ptr(__u8 *db, int dblen, int structlen, __be32 ptr)
+{
+	__u32 p = ntohl(ptr);
+
+	if (p > dblen - structlen) {
+		fprintf(stderr, "Invalid database file, bad pointer!\n");
+		exit(3);
+	}
+
+	return (void *)(db + p);
+}
+
 /*
  * Checks the validity of the signature found on the regulatory
  * database against the array 'keys'. Returns 1 if there exists
diff --git a/regdb.h b/regdb.h
index bee00a5..773139f 100644
--- a/regdb.h
+++ b/regdb.h
@@ -101,6 +101,7 @@ struct regdb_file_reg_country {
 
 
 /* functions */
+void *crda_get_file_ptr(__u8 *db, int dblen, int structlen, __be32 ptr);
 int crda_verify_db_signature(__u8 *db, int dblen, int siglen);
 
 
-- 
1.6.0.2

