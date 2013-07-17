Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f171.google.com ([209.85.192.171]:42329 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751044Ab3GQBcg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Jul 2013 21:32:36 -0400
Received: by mail-pd0-f171.google.com with SMTP id y14so1266909pdi.16
        for <linux-wireless@vger.kernel.org>; Tue, 16 Jul 2013 18:32:35 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: linville@tuxdriver.com
Cc: wireless-regdb@lists.infradead.org, linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH] reglib: add reglib_is_valid_rd() and verify data upon build
Date: Tue, 16 Jul 2013 18:32:30 -0700
Message-Id: <1374024750-16455-1-git-send-email-mcgrof@do-not-panic.com> (sfid-20130717_033238_908119_271D663C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>

This will verify the sanity of a regulatory domain upon build
time. This is useful if you are making modifications to
wireless-regdb and need to verify the regulatory domains
won't be rejected by a similar checker. In the case of the
Linux kernel regulatory domain data structures that get
a complaint would have been rejected completely.

Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 regdbdump.c |    5 +++++
 reglib.c    |   16 ++++++++++++++++
 reglib.h    |   10 ++++++++++
 3 files changed, 31 insertions(+)

diff --git a/regdbdump.c b/regdbdump.c
index cc7eb85..bb83af9 100644
--- a/regdbdump.c
+++ b/regdbdump.c
@@ -8,6 +8,11 @@ static void reglib_regdbdump(const struct reglib_regdb_ctx *ctx)
 	unsigned int idx = 0;
 
 	reglib_for_each_country(rd, idx, ctx) {
+		if (!reglib_is_valid_rd(rd)) {
+			fprintf(stderr, "country %.2s: invalid\n", rd->alpha2);
+			free((struct ieee80211_regdomain *) rd);
+			continue;
+		}
 		reglib_print_regdom(rd);
 		free((struct ieee80211_regdomain *) rd);
 	}
diff --git a/reglib.c b/reglib.c
index 224821b..64584f4 100644
--- a/reglib.c
+++ b/reglib.c
@@ -427,6 +427,22 @@ static int is_valid_reg_rule(const struct ieee80211_reg_rule *rule)
 	return 1;
 }
 
+int reglib_is_valid_rd(const struct ieee80211_regdomain *rd)
+{
+	const struct ieee80211_reg_rule *reg_rule = NULL;
+	unsigned int i;
+
+	if (!rd->n_reg_rules)
+		return 0;
+
+	for (i = 0; i < rd->n_reg_rules; i++) {
+		reg_rule = &rd->reg_rules[i];
+		if (!is_valid_reg_rule(reg_rule))
+		return 0;
+	}
+	return 1;
+}
+
 /*
  * Helper for reglib_intersect_rds(), this does the real
  * mathematical intersection fun
diff --git a/reglib.h b/reglib.h
index 57082fe..7a586a3 100644
--- a/reglib.h
+++ b/reglib.h
@@ -150,6 +150,16 @@ reglib_get_rd_idx(unsigned int idx, const struct reglib_regdb_ctx *ctx);
 const struct ieee80211_regdomain *
 reglib_get_rd_alpha2(const char *alpha2, const char *file);
 
+/**
+ * reglib_is_valid_rd - validate regulatory domain data structure
+ *
+ * @rd: regulatory domain data structure to validate
+ *
+ * You can use this to validate regulatory domain data structures
+ * for possible inconsistencies.
+ */
+int reglib_is_valid_rd(const struct ieee80211_regdomain *rd);
+
 /* reg helpers */
 void reglib_print_regdom(const struct ieee80211_regdomain *rd);
 struct ieee80211_regdomain *
-- 
1.7.10.4

