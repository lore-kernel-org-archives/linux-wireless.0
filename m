Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f50.google.com ([209.85.160.50]:63755 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751561Ab3EaCMU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 May 2013 22:12:20 -0400
Received: by mail-pb0-f50.google.com with SMTP id wy17so1387223pbc.9
        for <linux-wireless@vger.kernel.org>; Thu, 30 May 2013 19:12:20 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: wireless-regdb@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 36/40] crda: move reglib_intersect_regdb() to reglib
Date: Thu, 30 May 2013 19:09:25 -0700
Message-Id: <1369966169-23640-37-git-send-email-mcgrof@do-not-panic.com> (sfid-20130531_042936_536635_9343043B)
In-Reply-To: <1369966169-23640-1-git-send-email-mcgrof@do-not-panic.com>
References: <1369966169-23640-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>

There are no functional changes in this change.

Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 intersect.c |   63 -----------------------------------------------------------
 reglib.c    |   52 ++++++++++++++++++++++++++++++++++++++++++++++++
 reglib.h    |   13 ++++++++++++
 3 files changed, 65 insertions(+), 63 deletions(-)

diff --git a/intersect.c b/intersect.c
index b9e3429..56d0d35 100644
--- a/intersect.c
+++ b/intersect.c
@@ -6,69 +6,6 @@
 
 #include "reglib.h"
 
-/**
- * reglib_intersect_regdb - intersects a regulatory database
- *
- * @regdb_file: the regulatory database to intersect
- *
- * Goes through an entire regulatory database and intersects all regulatory
- * domains. This will skip any regulatory marked with an alpha2 of '00', which
- * is used to indicate a world regulatory domain. If intersection is able
- * to find rules that fit all regulatory domains it return a regulatory
- * domain with such rules otherwise it returns NULL.
- */
-const struct ieee80211_regdomain *reglib_intersect_regdb(char *regdb_file)
-{
-	const struct ieee80211_regdomain *rd;
-	struct ieee80211_regdomain *prev_rd_intsct = NULL, *rd_intsct = NULL;
-	int intersected = 0;
-	unsigned int idx = 0;
-
-	reglib_for_each_country(rd, idx, regdb_file) {
-		if (reglib_is_world_regdom((const char *) rd->alpha2)) {
-			free((struct ieee80211_regdomain *) rd);
-			continue;
-		}
-
-		if (!prev_rd_intsct) {
-			prev_rd_intsct = (struct ieee80211_regdomain *) rd;
-			continue;
-		}
-
-		if (rd_intsct) {
-			free(prev_rd_intsct);
-			prev_rd_intsct = (struct ieee80211_regdomain *) rd_intsct;
-		}
-
-		rd_intsct = reglib_intersect_rds(prev_rd_intsct, rd);
-		if (!rd_intsct) {
-			free(prev_rd_intsct);
-			free((struct ieee80211_regdomain *) rd);
-			return NULL;
-		}
-
-		intersected++;
-		free((struct ieee80211_regdomain *) rd);
-	}
-
-	if (!idx)
-		return NULL;
-
-	if (intersected <= 0) {
-		rd_intsct = prev_rd_intsct;
-		prev_rd_intsct = NULL;
-		if (idx > 1) {
-			free(rd_intsct);
-			return NULL;
-		}
-	}
-
-	if (prev_rd_intsct)
-		free(prev_rd_intsct);
-
-	return rd_intsct;
-}
-
 int main(int argc, char **argv)
 {
 	const struct ieee80211_regdomain *rd;
diff --git a/reglib.c b/reglib.c
index 4643fa8..67f5b2b 100644
--- a/reglib.c
+++ b/reglib.c
@@ -554,6 +554,58 @@ reglib_intersect_rds(const struct ieee80211_regdomain *rd1,
 	return rd;
 }
 
+const struct ieee80211_regdomain *reglib_intersect_regdb(char *regdb_file)
+{
+	const struct ieee80211_regdomain *rd;
+	struct ieee80211_regdomain *prev_rd_intsct = NULL, *rd_intsct = NULL;
+	int intersected = 0;
+	unsigned int idx = 0;
+
+	reglib_for_each_country(rd, idx, regdb_file) {
+		if (reglib_is_world_regdom((const char *) rd->alpha2)) {
+			free((struct ieee80211_regdomain *) rd);
+			continue;
+		}
+
+		if (!prev_rd_intsct) {
+			prev_rd_intsct = (struct ieee80211_regdomain *) rd;
+			continue;
+		}
+
+		if (rd_intsct) {
+			free(prev_rd_intsct);
+			prev_rd_intsct = (struct ieee80211_regdomain *) rd_intsct;
+		}
+
+		rd_intsct = reglib_intersect_rds(prev_rd_intsct, rd);
+		if (!rd_intsct) {
+			free(prev_rd_intsct);
+			free((struct ieee80211_regdomain *) rd);
+			return NULL;
+		}
+
+		intersected++;
+		free((struct ieee80211_regdomain *) rd);
+	}
+
+	if (!idx)
+		return NULL;
+
+	if (intersected <= 0) {
+		rd_intsct = prev_rd_intsct;
+		prev_rd_intsct = NULL;
+		if (idx > 1) {
+			free(rd_intsct);
+			return NULL;
+		}
+	}
+
+	if (prev_rd_intsct)
+		free(prev_rd_intsct);
+
+	return rd_intsct;
+}
+
 static const char *dfs_domain_name(enum regdb_dfs_regions region)
 {
 	switch (region) {
diff --git a/reglib.h b/reglib.h
index d89fcd5..2681164 100644
--- a/reglib.h
+++ b/reglib.h
@@ -90,4 +90,17 @@ struct ieee80211_regdomain *
 reglib_intersect_rds(const struct ieee80211_regdomain *rd1,
 		     const struct ieee80211_regdomain *rd2);
 
+/**
+ * reglib_intersect_regdb - intersects a regulatory database
+ *
+ * @regdb_file: the regulatory database to intersect
+ *
+ * Goes through an entire regulatory database and intersects all regulatory
+ * domains. This will skip any regulatory marked with an alpha2 of '00', which
+ * is used to indicate a world regulatory domain. If intersection is able
+ * to find rules that fit all regulatory domains it return a regulatory
+ * domain with such rules otherwise it returns NULL.
+ */
+const struct ieee80211_regdomain *reglib_intersect_regdb(char *regdb_file);
+
 #endif
-- 
1.7.10.4

