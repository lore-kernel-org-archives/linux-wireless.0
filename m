Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:54915 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753256Ab2BDB0O (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Feb 2012 20:26:14 -0500
Received: by mail-pz0-f46.google.com with SMTP id p15so3176528dad.19
        for <linux-wireless@vger.kernel.org>; Fri, 03 Feb 2012 17:26:14 -0800 (PST)
From: "Luis R. Rodriguez" <mcgrof@frijolero.org>
To: linux-wireless@vger.kernel.org
Cc: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Subject: [RFC 07/11] crda: make crda use reglib_get_country_alpha2()
Date: Fri,  3 Feb 2012 17:25:44 -0800
Message-Id: <1328318748-21044-8-git-send-email-mcgrof@frijolero.org> (sfid-20120204_022623_943606_C3557143)
In-Reply-To: <1328318748-21044-1-git-send-email-mcgrof@frijolero.org>
References: <1328318748-21044-1-git-send-email-mcgrof@frijolero.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This removes all file specific operations over to the
reglib. This also required converting the processing of the
regulatory domain from the mmap'd rules to the standard
ieee80211_regdomain data structure.

Signed-off-by: Luis R. Rodriguez <mcgrof@frijolero.org>
---
 crda.c |  110 +++++++++++++--------------------------------------------------
 1 files changed, 23 insertions(+), 87 deletions(-)

diff --git a/crda.c b/crda.c
index 5a1cd83..344fd60 100644
--- a/crda.c
+++ b/crda.c
@@ -119,22 +119,20 @@ static int error_handler(struct sockaddr_nl __attribute__((unused)) *nla,
 	exit(err->error);
 }
 
-static int put_reg_rule(__u8 *db, int dblen, __be32 ruleptr, struct nl_msg *msg)
+static int put_reg_rule(struct ieee80211_reg_rule *rule, struct nl_msg *msg)
 {
-	struct regdb_file_reg_rule *rule;
-	struct regdb_file_freq_range *freq;
-	struct regdb_file_power_rule *power;
+	struct ieee80211_freq_range *freq_range;
+	struct ieee80211_power_rule *power_rule;
 
-	rule  = crda_get_file_ptr(db, dblen, sizeof(*rule), ruleptr);
-	freq  = crda_get_file_ptr(db, dblen, sizeof(*freq), rule->freq_range_ptr);
-	power = crda_get_file_ptr(db, dblen, sizeof(*power), rule->power_rule_ptr);
+	freq_range = &rule->freq_range;
+	power_rule = &rule->power_rule;
 
-	NLA_PUT_U32(msg, NL80211_ATTR_REG_RULE_FLAGS,		ntohl(rule->flags));
-	NLA_PUT_U32(msg, NL80211_ATTR_FREQ_RANGE_START,		ntohl(freq->start_freq));
-	NLA_PUT_U32(msg, NL80211_ATTR_FREQ_RANGE_END,		ntohl(freq->end_freq));
-	NLA_PUT_U32(msg, NL80211_ATTR_FREQ_RANGE_MAX_BW,	ntohl(freq->max_bandwidth));
-	NLA_PUT_U32(msg, NL80211_ATTR_POWER_RULE_MAX_ANT_GAIN,	ntohl(power->max_antenna_gain));
-	NLA_PUT_U32(msg, NL80211_ATTR_POWER_RULE_MAX_EIRP,	ntohl(power->max_eirp));
+	NLA_PUT_U32(msg, NL80211_ATTR_REG_RULE_FLAGS,		rule->flags);
+	NLA_PUT_U32(msg, NL80211_ATTR_FREQ_RANGE_START,		freq_range->start_freq_khz);
+	NLA_PUT_U32(msg, NL80211_ATTR_FREQ_RANGE_END,		freq_range->end_freq_khz);
+	NLA_PUT_U32(msg, NL80211_ATTR_FREQ_RANGE_MAX_BW,	freq_range->max_bandwidth_khz);
+	NLA_PUT_U32(msg, NL80211_ATTR_POWER_RULE_MAX_ANT_GAIN,	power_rule->max_antenna_gain);
+	NLA_PUT_U32(msg, NL80211_ATTR_POWER_RULE_MAX_EIRP,	power_rule->max_eirp);
 
 	return 0;
 
@@ -145,23 +143,16 @@ nla_put_failure:
 int main(int argc, char **argv)
 {
 	int fd = -1;
-	struct stat stat;
-	__u8 *db;
-	struct regdb_file_header *header;
-	struct regdb_file_reg_country *countries;
-	int dblen, siglen, num_countries, i, j, r;
+	int i = 0, j, r;
 	char alpha2[3] = {}; /* NUL-terminate */
 	char *env_country;
 	struct nl80211_state nlstate;
 	struct nl_cb *cb = NULL;
 	struct nl_msg *msg;
-	int found_country = 0;
 	int finished = 0;
 
-	struct regdb_file_reg_rules_collection *rcoll;
-	struct regdb_file_reg_country *country;
 	struct nlattr *nl_reg_rules;
-	int num_rules;
+	struct ieee80211_regdomain *rd = NULL;
 
 	const char *regdb_paths[] = {
 		"/usr/local/lib/crda/regulatory.bin", /* Users/preloads can override */
@@ -201,66 +192,19 @@ int main(int argc, char **argv)
 		return -ENOENT;
 	}
 
-	if (fstat(fd, &stat)) {
-		perror("failed to fstat db file");
-		return -EIO;
-	}
-
-	dblen = stat.st_size;
-
-	db = mmap(NULL, dblen, PROT_READ, MAP_PRIVATE, fd, 0);
-	if (db == MAP_FAILED) {
-		perror("failed to mmap db file");
-		return -EIO;
-	}
-
-	/* db file starts with a struct regdb_file_header */
-	header = crda_get_file_ptr(db, dblen, sizeof(*header), 0);
-
-	if (ntohl(header->magic) != REGDB_MAGIC) {
-		fprintf(stderr, "Invalid database magic\n");
-		return -EINVAL;
-	}
-
-	if (ntohl(header->version) != REGDB_VERSION) {
-		fprintf(stderr, "Invalid database version\n");
-		return -EINVAL;
-	}
-
-	siglen = ntohl(header->signature_length);
-	/* adjust dblen so later sanity checks don't run into the signature */
-	dblen -= siglen;
-
-	if (dblen <= (int)sizeof(*header)) {
-		fprintf(stderr, "Invalid signature length %d\n", siglen);
-		return -EINVAL;
-	}
-
-	/* verify signature */
-	if (!crda_verify_db_signature(db, dblen, siglen))
-		return -EINVAL;
-
-	num_countries = ntohl(header->reg_country_num);
-	countries = crda_get_file_ptr(db, dblen,
-			sizeof(struct regdb_file_reg_country) * num_countries,
-			header->reg_country_ptr);
-
-	for (i = 0; i < num_countries; i++) {
-		country = countries + i;
-		if (memcmp(country->alpha2, alpha2, 2) == 0) {
-			found_country = 1;
-			break;
-		}
-	}
+	close(fd);
 
-	if (!found_country) {
+	rd = reglib_get_country_alpha2(alpha2, *regdb);
+	if (!rd) {
 		fprintf(stderr, "No country match in regulatory database.\n");
 		return -1;
 	}
 
 	r = nl80211_init(&nlstate);
-	if (r)
+	if (r) {
+		free(rd);
 		return -EIO;
+	}
 
 	msg = nlmsg_alloc();
 	if (!msg) {
@@ -272,16 +216,8 @@ int main(int argc, char **argv)
 	genlmsg_put(msg, 0, 0, genl_family_get_id(nlstate.nl80211), 0,
 		0, NL80211_CMD_SET_REG, 0);
 
-	rcoll = crda_get_file_ptr(db, dblen, sizeof(*rcoll),
-				country->reg_collection_ptr);
-	num_rules = ntohl(rcoll->reg_rule_num);
-	/* re-get pointer with sanity checking for num_rules */
-	rcoll = crda_get_file_ptr(db, dblen,
-				sizeof(*rcoll) + num_rules * sizeof(__be32),
-				country->reg_collection_ptr);
-
 	NLA_PUT_STRING(msg, NL80211_ATTR_REG_ALPHA2, alpha2);
-	NLA_PUT_U8(msg, NL80211_ATTR_DFS_REGION, country->creqs & 0x3);
+	NLA_PUT_U8(msg, NL80211_ATTR_DFS_REGION, rd->dfs_region);
 
 	nl_reg_rules = nla_nest_start(msg, NL80211_ATTR_REG_RULES);
 	if (!nl_reg_rules) {
@@ -289,13 +225,13 @@ int main(int argc, char **argv)
 		goto nla_put_failure;
 	}
 
-	for (j = 0; j < num_rules; j++) {
+	for (j = 0; j < rd->n_reg_rules; j++) {
 		struct nlattr *nl_reg_rule;
 		nl_reg_rule = nla_nest_start(msg, i);
 		if (!nl_reg_rule)
 			goto nla_put_failure;
 
-		r = put_reg_rule(db, dblen, rcoll->reg_rule_ptrs[j], msg);
+		r = put_reg_rule(&rd->reg_rules[j], msg);
 		if (r)
 			goto nla_put_failure;
 
@@ -334,7 +270,7 @@ nla_put_failure:
 	nlmsg_free(msg);
 out:
 	nl80211_cleanup(&nlstate);
-	close(fd);
+	free(rd);
 
 	return r;
 }
-- 
1.7.4.15.g7811d

