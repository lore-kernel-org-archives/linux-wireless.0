Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f179.google.com ([209.85.192.179]:34772 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751800Ab3EaCLY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 May 2013 22:11:24 -0400
Received: by mail-pd0-f179.google.com with SMTP id q11so1381338pdj.10
        for <linux-wireless@vger.kernel.org>; Thu, 30 May 2013 19:11:24 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: wireless-regdb@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 23/40] crda: rename print_regdom() to reglib_print_regdom()
Date: Thu, 30 May 2013 19:09:12 -0700
Message-Id: <1369966169-23640-24-git-send-email-mcgrof@do-not-panic.com> (sfid-20130531_042938_225596_85190C81)
In-Reply-To: <1369966169-23640-1-git-send-email-mcgrof@do-not-panic.com>
References: <1369966169-23640-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>

Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 intersect.c    |    2 +-
 print-regdom.c |    2 +-
 regdbdump.c    |    2 +-
 reglib.h       |    2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/intersect.c b/intersect.c
index 51479e4..22b3225 100644
--- a/intersect.c
+++ b/intersect.c
@@ -68,7 +68,7 @@ int main(int argc, char **argv)
 
 	/* Tada! */
 	printf("== World regulatory domain: ==\n");
-	print_regdom(rd_intsct);
+	reglib_print_regdom(rd_intsct);
 
 	free(rd_intsct);
 	return r;
diff --git a/print-regdom.c b/print-regdom.c
index abd6488..ab122db 100644
--- a/print-regdom.c
+++ b/print-regdom.c
@@ -70,7 +70,7 @@ static void print_reg_rule(const struct ieee80211_reg_rule *rule)
 	printf("\n");
 }
 
-void print_regdom(const struct ieee80211_regdomain *rd)
+void reglib_print_regdom(const struct ieee80211_regdomain *rd)
 {
 	unsigned int i;
 	printf("country %.2s: %s\n", rd->alpha2,
diff --git a/regdbdump.c b/regdbdump.c
index dcbed71..ea14730 100644
--- a/regdbdump.c
+++ b/regdbdump.c
@@ -13,7 +13,7 @@ int main(int argc, char **argv)
 	}
 
 	reglib_for_each_country(rd, idx, argv[1]) {
-		print_regdom(rd);
+		reglib_print_regdom(rd);
 		free((struct ieee80211_regdomain *) rd);
 	}
 
diff --git a/reglib.h b/reglib.h
index 2f49a32..4c0ec6d 100644
--- a/reglib.h
+++ b/reglib.h
@@ -85,7 +85,7 @@ const struct ieee80211_regdomain *
 reglib_get_rd_alpha2(const char *alpha2, const char *file);
 
 /* reg helpers */
-void print_regdom(const struct ieee80211_regdomain *rd);
+void reglib_print_regdom(const struct ieee80211_regdomain *rd);
 struct ieee80211_regdomain *
 reglib_intersect_rds(const struct ieee80211_regdomain *rd1,
 		     const struct ieee80211_regdomain *rd2);
-- 
1.7.10.4

