Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.27]:39613 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751263AbYLALLU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Dec 2008 06:11:20 -0500
Received: by ey-out-2122.google.com with SMTP id 6so1015296eyi.37
        for <linux-wireless@vger.kernel.org>; Mon, 01 Dec 2008 03:11:18 -0800 (PST)
From: Diego 'Flameeyes' =?utf-8?q?Petten=C3=B2?= <flameeyes@gmail.com>
Subject: [crda PATCH 1/3] Mark functions static when not used outside their
	translation unit.
To: linux-wireless@vger.kernel.org
Date: Mon, 01 Dec 2008 12:11:15 +0100
Message-ID: <20081201111115.20833.78807.stgit@localhost> (sfid-20081201_121123_127335_C24658B6)
In-Reply-To: <20081201111021.20833.42515.stgit@localhost>
References: <20081201111021.20833.42515.stgit@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


---

 intersect.c |    2 +-
 reglib.c    |    4 ++--
 reglib.h    |    3 ---
 3 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/intersect.c b/intersect.c
index 279d807..d6d857d 100644
--- a/intersect.c
+++ b/intersect.c
@@ -75,7 +75,7 @@ static int reg_rules_intersect(
  * resulting intersection of rules between rd1 and rd2. We will
  * malloc() this structure for you.
  */
-struct ieee80211_regdomain *regdom_intersect(
+static struct ieee80211_regdomain *regdom_intersect(
 	struct ieee80211_regdomain *rd1,
 	struct ieee80211_regdomain *rd2)
 {
diff --git a/reglib.c b/reglib.c
index e6b9b3f..c173818 100644
--- a/reglib.c
+++ b/reglib.c
@@ -133,7 +133,7 @@ out:
 #endif
 }
 
-void reg_rule2rd(__u8 *db, int dblen,
+static void reg_rule2rd(__u8 *db, int dblen,
 	__be32 ruleptr, struct ieee80211_reg_rule *rd_reg_rule)
 {
 	struct regdb_file_reg_rule *rule;
@@ -214,7 +214,7 @@ int is_valid_reg_rule(const struct ieee80211_reg_rule *rule)
 	return 1;
 }
 
-void print_reg_rule(struct ieee80211_reg_rule *rule)
+static void print_reg_rule(struct ieee80211_reg_rule *rule)
 {
 	struct ieee80211_freq_range *freq;
 	struct ieee80211_power_rule *power;
diff --git a/reglib.h b/reglib.h
index 65e0ad6..095090b 100644
--- a/reglib.h
+++ b/reglib.h
@@ -88,14 +88,11 @@ void *crda_get_file_ptr(__u8 *db, int dblen, int structlen, __be32 ptr);
 int crda_verify_db_signature(__u8 *db, int dblen, int siglen);
 
 /* File reg db entry -> rd converstion utilities */
-void reg_rule2rd(__u8 *db, int dblen,
-	__be32 ruleptr, struct ieee80211_reg_rule *rd_reg_rule);
 struct ieee80211_regdomain *country2rd(__u8 *db, int dblen,
 	struct regdb_file_reg_country *country);
 
 /* reg helpers */
 int is_valid_reg_rule(const struct ieee80211_reg_rule *rule);
-void print_reg_rule(struct ieee80211_reg_rule *rule);
 void print_regdom(struct ieee80211_regdomain *rd);
 
 #endif

