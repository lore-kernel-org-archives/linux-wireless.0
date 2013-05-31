Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f50.google.com ([209.85.160.50]:39330 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751561Ab3EaCMh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 May 2013 22:12:37 -0400
Received: by mail-pb0-f50.google.com with SMTP id wy17so1387594pbc.9
        for <linux-wireless@vger.kernel.org>; Thu, 30 May 2013 19:12:37 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: wireless-regdb@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 40/40] crda: make reglib_for_each_country() use the reglib context
Date: Thu, 30 May 2013 19:09:29 -0700
Message-Id: <1369966169-23640-41-git-send-email-mcgrof@do-not-panic.com> (sfid-20130531_042937_513689_495A9E60)
In-Reply-To: <1369966169-23640-1-git-send-email-mcgrof@do-not-panic.com>
References: <1369966169-23640-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>

This allows users of reglib to iterate over the regdb
with just one open() and mmap() to be kept sharing as
much code as possible. This makes the regdbdump and
intersection code use the context therefore sharing
all that boiler plate code.

Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 intersect.c |   15 +++++++++++++--
 regdbdump.c |   28 ++++++++++++++--------------
 reglib.c    |   23 +++++++++--------------
 reglib.h    |   11 ++++++-----
 4 files changed, 42 insertions(+), 35 deletions(-)

diff --git a/intersect.c b/intersect.c
index 56d0d35..ae9ca1b 100644
--- a/intersect.c
+++ b/intersect.c
@@ -8,21 +8,32 @@
 
 int main(int argc, char **argv)
 {
+	const struct reglib_regdb_ctx *ctx;
 	const struct ieee80211_regdomain *rd;
 
 	if (argc != 2) {
-		fprintf(stderr, "You must specify a file\n");
+		fprintf(stderr, "Usage: %s <regulatory-binary-file>\n", argv[0]);
 		return -EINVAL;
 	}
 
-	rd = reglib_intersect_regdb(argv[1]);
+	ctx = reglib_malloc_regdb_ctx(argv[1]);
+	if (!ctx) {
+		fprintf(stderr, "Invalid or empty regulatory file, note: "
+			"a binary regulatory file should be used.\n");
+		return -EINVAL;
+	}
+
+	rd = reglib_intersect_regdb(ctx);
 	if (!rd) {
 		fprintf(stderr, "Intersection not possible\n");
+		reglib_free_regdb_ctx(ctx);
 		return -ENOENT;
 	}
 
 	reglib_print_regdom(rd);
+
 	free((struct ieee80211_regdomain *) rd);
 
+	reglib_free_regdb_ctx(ctx);
 	return 0;
 }
diff --git a/regdbdump.c b/regdbdump.c
index edf3e7c..cc7eb85 100644
--- a/regdbdump.c
+++ b/regdbdump.c
@@ -2,35 +2,35 @@
 #include <errno.h>
 #include "reglib.h"
 
-static int reglib_regdbdump(char *regdb_file)
+static void reglib_regdbdump(const struct reglib_regdb_ctx *ctx)
 {
 	const struct ieee80211_regdomain *rd = NULL;
 	unsigned int idx = 0;
 
-	reglib_for_each_country(rd, idx, regdb_file) {
+	reglib_for_each_country(rd, idx, ctx) {
 		reglib_print_regdom(rd);
 		free((struct ieee80211_regdomain *) rd);
 	}
-
-	if (!idx) {
-		fprintf(stderr, "Invalid or empty regulatory file, note: "
-		       "a binary regulatory file should be used.\n");
-		return -EINVAL;
-	}
-
-	return 0;
 }
 
 int main(int argc, char **argv)
 {
-	int r;
+	const struct reglib_regdb_ctx *ctx;
 
 	if (argc != 2) {
 		fprintf(stderr, "Usage: %s <regulatory-binary-file>\n", argv[0]);
-		return 2;
+		return -EINVAL;
+	}
+
+	ctx = reglib_malloc_regdb_ctx(argv[1]);
+	if (!ctx) {
+		fprintf(stderr, "Invalid or empty regulatory file, note: "
+			"a binary regulatory file should be used.\n");
+		return -EINVAL;
 	}
 
-	r = reglib_regdbdump(argv[1]);
+	reglib_regdbdump(ctx);
+	reglib_free_regdb_ctx(ctx);
 
-	return r;
+	return 0;
 }
diff --git a/reglib.c b/reglib.c
index ff05aaa..c4d00f8 100644
--- a/reglib.c
+++ b/reglib.c
@@ -336,28 +336,19 @@ country2rd(const struct reglib_regdb_ctx *ctx,
 }
 
 const struct ieee80211_regdomain *
-reglib_get_rd_idx(unsigned int idx, const char *file)
+reglib_get_rd_idx(unsigned int idx, const struct reglib_regdb_ctx *ctx)
 {
-	const struct reglib_regdb_ctx *ctx;
 	struct regdb_file_reg_country *country;
-	const struct ieee80211_regdomain *rd = NULL;
 
-	ctx = reglib_malloc_regdb_ctx(file);
 	if (!ctx)
 		return NULL;
 
 	if (idx >= ctx->num_countries)
-		goto out;
+		return NULL;
 
 	country = ctx->countries + idx;
 
-	rd = country2rd(ctx, country);
-	if (!rd)
-		goto out;
-
-out:
-	reglib_free_regdb_ctx(ctx);
-	return rd;
+	return country2rd(ctx, country);
 }
 
 const struct ieee80211_regdomain *
@@ -552,14 +543,18 @@ reglib_intersect_rds(const struct ieee80211_regdomain *rd1,
 	return rd;
 }
 
-const struct ieee80211_regdomain *reglib_intersect_regdb(char *regdb_file)
+const struct ieee80211_regdomain *
+reglib_intersect_regdb(const struct reglib_regdb_ctx *ctx)
 {
 	const struct ieee80211_regdomain *rd;
 	struct ieee80211_regdomain *prev_rd_intsct = NULL, *rd_intsct = NULL;
 	int intersected = 0;
 	unsigned int idx = 0;
 
-	reglib_for_each_country(rd, idx, regdb_file) {
+	if (!ctx)
+		return NULL;
+
+	reglib_for_each_country(rd, idx, ctx) {
 		if (reglib_is_world_regdom((const char *) rd->alpha2)) {
 			free((struct ieee80211_regdomain *) rd);
 			continue;
diff --git a/reglib.h b/reglib.h
index f1bd6b8..86087e3 100644
--- a/reglib.h
+++ b/reglib.h
@@ -139,12 +139,12 @@ const struct reglib_regdb_ctx *reglib_malloc_regdb_ctx(const char *regdb_file);
 void reglib_free_regdb_ctx(const struct reglib_regdb_ctx *regdb_ctx);
 
 const struct ieee80211_regdomain *
-reglib_get_rd_idx(unsigned int idx, const char *file);
+reglib_get_rd_idx(unsigned int idx, const struct reglib_regdb_ctx *ctx);
 
-#define reglib_for_each_country(__rd, __idx, __file)		\
-	for (__rd = reglib_get_rd_idx(__idx, __file);		\
+#define reglib_for_each_country(__rd, __idx, __ctx)		\
+	for (__rd = reglib_get_rd_idx(__idx, __ctx);		\
 	     __rd != NULL;					\
-	     __rd = reglib_get_rd_idx(++__idx, __file))		\
+	     __rd = reglib_get_rd_idx(++__idx, __ctx))		\
 
 const struct ieee80211_regdomain *
 reglib_get_rd_alpha2(const char *alpha2, const char *file);
@@ -166,6 +166,7 @@ reglib_intersect_rds(const struct ieee80211_regdomain *rd1,
  * to find rules that fit all regulatory domains it return a regulatory
  * domain with such rules otherwise it returns NULL.
  */
-const struct ieee80211_regdomain *reglib_intersect_regdb(char *regdb_file);
+const struct ieee80211_regdomain *
+reglib_intersect_regdb(const struct reglib_regdb_ctx *ctx);
 
 #endif
-- 
1.7.10.4

