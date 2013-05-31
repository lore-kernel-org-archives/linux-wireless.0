Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f48.google.com ([209.85.160.48]:42247 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751800Ab3EaCLM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 May 2013 22:11:12 -0400
Received: by mail-pb0-f48.google.com with SMTP id md4so1383282pbc.35
        for <linux-wireless@vger.kernel.org>; Thu, 30 May 2013 19:11:11 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: wireless-regdb@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 20/40] crda: rename regdom_intersect() to reglib_intersect_rds()
Date: Thu, 30 May 2013 19:09:09 -0700
Message-Id: <1369966169-23640-21-git-send-email-mcgrof@do-not-panic.com> (sfid-20130531_042936_344576_10BDDB18)
In-Reply-To: <1369966169-23640-1-git-send-email-mcgrof@do-not-panic.com>
References: <1369966169-23640-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>

This fits more in line with the reglib prefix usage.

Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 intersect.c |    2 +-
 reglib.c    |    8 ++++----
 reglib.h    |    4 ++--
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/intersect.c b/intersect.c
index bce7eb3..51479e4 100644
--- a/intersect.c
+++ b/intersect.c
@@ -39,7 +39,7 @@ int main(int argc, char **argv)
 			prev_rd_intsct = (struct ieee80211_regdomain *) rd_intsct;
 		}
 
-		rd_intsct = regdom_intersect(prev_rd_intsct, rd);
+		rd_intsct = reglib_intersect_rds(prev_rd_intsct, rd);
 		if (!rd_intsct) {
 			free(prev_rd_intsct);
 			free((struct ieee80211_regdomain *) rd);
diff --git a/reglib.c b/reglib.c
index 72ea78f..333db7a 100644
--- a/reglib.c
+++ b/reglib.c
@@ -417,7 +417,7 @@ static int is_valid_reg_rule(const struct ieee80211_reg_rule *rule)
 }
 
 /*
- * Helper for regdom_intersect(), this does the real
+ * Helper for reglib_intersect_rds(), this does the real
  * mathematical intersection fun
  */
 static int reg_rules_intersect(const struct ieee80211_reg_rule *rule1,
@@ -463,7 +463,7 @@ static int reg_rules_intersect(const struct ieee80211_reg_rule *rule1,
 }
 
 /**
- * regdom_intersect - do the intersection between two regulatory domains
+ * reglib_intersect_rds - do the intersection between two regulatory domains
  * @rd1: first regulatory domain
  * @rd2: second regulatory domain
  *
@@ -476,8 +476,8 @@ static int reg_rules_intersect(const struct ieee80211_reg_rule *rule1,
  * malloc() this structure for you.
  */
 struct ieee80211_regdomain *
-regdom_intersect(const struct ieee80211_regdomain *rd1,
-		 const struct ieee80211_regdomain *rd2)
+reglib_intersect_rds(const struct ieee80211_regdomain *rd1,
+		     const struct ieee80211_regdomain *rd2)
 {
 	int r, size_of_regd;
 	unsigned int x, y;
diff --git a/reglib.h b/reglib.h
index 8bd9e03..529772d 100644
--- a/reglib.h
+++ b/reglib.h
@@ -87,7 +87,7 @@ reglib_get_rd_alpha2(const char *alpha2, const char *file);
 /* reg helpers */
 void print_regdom(const struct ieee80211_regdomain *rd);
 struct ieee80211_regdomain *
-regdom_intersect(const struct ieee80211_regdomain *rd1,
-		 const struct ieee80211_regdomain *rd2);
+reglib_intersect_rds(const struct ieee80211_regdomain *rd1,
+		     const struct ieee80211_regdomain *rd2);
 
 #endif
-- 
1.7.10.4

