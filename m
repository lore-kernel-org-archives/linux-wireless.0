Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f44.google.com ([209.85.160.44]:56620 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751561Ab3EaCMd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 May 2013 22:12:33 -0400
Received: by mail-pb0-f44.google.com with SMTP id wz12so1402268pbc.3
        for <linux-wireless@vger.kernel.org>; Thu, 30 May 2013 19:12:33 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: wireless-regdb@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 39/40] crda: pass struct reglib_regdb_ctx to country2rd()
Date: Thu, 30 May 2013 19:09:28 -0700
Message-Id: <1369966169-23640-40-git-send-email-mcgrof@do-not-panic.com> (sfid-20130531_042937_043133_55A5183A)
In-Reply-To: <1369966169-23640-1-git-send-email-mcgrof@do-not-panic.com>
References: <1369966169-23640-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>

This consolidates the number of arguments.

Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 reglib.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/reglib.c b/reglib.c
index 6f076ff..ff05aaa 100644
--- a/reglib.c
+++ b/reglib.c
@@ -298,18 +298,18 @@ static void reg_rule2rd(uint8_t *db, int dblen,
 
 /* Converts a file regdomain to ieee80211_regdomain, easier to manage */
 const static struct ieee80211_regdomain *
-country2rd(uint8_t *db, int dblen,
+country2rd(const struct reglib_regdb_ctx *ctx,
 	   struct regdb_file_reg_country *country)
 {
 	struct regdb_file_reg_rules_collection *rcoll;
 	struct ieee80211_regdomain *rd;
 	int i, num_rules, size_of_rd;
 
-	rcoll = reglib_get_file_ptr(db, dblen, sizeof(*rcoll),
-				country->reg_collection_ptr);
+	rcoll = reglib_get_file_ptr(ctx->db, ctx->dblen, sizeof(*rcoll),
+				    country->reg_collection_ptr);
 	num_rules = ntohl(rcoll->reg_rule_num);
 	/* re-get pointer with sanity checking for num_rules */
-	rcoll = reglib_get_file_ptr(db, dblen,
+	rcoll = reglib_get_file_ptr(ctx->db, ctx->dblen,
 			sizeof(*rcoll) + num_rules * sizeof(uint32_t),
 			country->reg_collection_ptr);
 
@@ -328,7 +328,7 @@ country2rd(uint8_t *db, int dblen,
 	rd->n_reg_rules = num_rules;
 
 	for (i = 0; i < num_rules; i++) {
-		reg_rule2rd(db, dblen, rcoll->reg_rule_ptrs[i],
+		reg_rule2rd(ctx->db, ctx->dblen, rcoll->reg_rule_ptrs[i],
 			&rd->reg_rules[i]);
 	}
 
@@ -351,7 +351,7 @@ reglib_get_rd_idx(unsigned int idx, const char *file)
 
 	country = ctx->countries + idx;
 
-	rd = country2rd(ctx->db, ctx->dblen, country);
+	rd = country2rd(ctx, country);
 	if (!rd)
 		goto out;
 
@@ -384,7 +384,7 @@ reglib_get_rd_alpha2(const char *alpha2, const char *file)
 	if (!found_country)
 		goto out;
 
-	rd = country2rd(ctx->db, ctx->dblen, country);
+	rd = country2rd(ctx, country);
 	if (!rd)
 		goto out;
 
-- 
1.7.10.4

