Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.25]:62995 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751139AbYLAM1B (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Dec 2008 07:27:01 -0500
Received: by ey-out-2122.google.com with SMTP id 6so1029871eyi.37
        for <linux-wireless@vger.kernel.org>; Mon, 01 Dec 2008 04:26:59 -0800 (PST)
From: Diego 'Flameeyes' =?utf-8?q?Petten=C3=B2?= <flameeyes@gmail.com>
Subject: [crda PATCH 1/3] Move is_valid_reg_rule() in intersect.c.
To: linux-wireless@vger.kernel.org
Date: Mon, 01 Dec 2008 13:26:57 +0100
Message-ID: <20081201122657.20222.49058.stgit@localhost> (sfid-20081201_132706_477529_928431D5)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The function is only ever used in that translation unit so it makes no
sense to define it for all the binaries.
---

 intersect.c |   20 ++++++++++++++++++++
 reglib.c    |   20 --------------------
 reglib.h    |    1 -
 3 files changed, 20 insertions(+), 21 deletions(-)

diff --git a/intersect.c b/intersect.c
index d6d857d..2f4d416 100644
--- a/intersect.c
+++ b/intersect.c
@@ -19,6 +19,26 @@
 	} \
 	} while (0)
 
+/* Sanity check on a regulatory rule */
+static int is_valid_reg_rule(const struct ieee80211_reg_rule *rule)
+{
+	const struct ieee80211_freq_range *freq_range = &rule->freq_range;
+	__u32 freq_diff;
+
+	if (freq_range->start_freq_khz == 0 || freq_range->end_freq_khz == 0)
+		return 0;
+
+	if (freq_range->start_freq_khz > freq_range->end_freq_khz)
+		return 0;
+
+	freq_diff = freq_range->end_freq_khz - freq_range->start_freq_khz;
+
+	if (freq_diff == 0 || freq_range->max_bandwidth_khz > freq_diff)
+		return 0;
+
+	return 1;
+}
+
 /* Helper for regdom_intersect(), this does the real
  * mathematical intersection fun */
 static int reg_rules_intersect(
diff --git a/reglib.c b/reglib.c
index 2f10d23..e02bd8f 100644
--- a/reglib.c
+++ b/reglib.c
@@ -195,26 +195,6 @@ struct ieee80211_regdomain *country2rd(__u8 *db, int dblen,
 	return rd;
 }
 
-/* Sanity check on a regulatory rule */
-int is_valid_reg_rule(const struct ieee80211_reg_rule *rule)
-{
-	const struct ieee80211_freq_range *freq_range = &rule->freq_range;
-	__u32 freq_diff;
-
-	if (freq_range->start_freq_khz == 0 || freq_range->end_freq_khz == 0)
-		return 0;
-
-	if (freq_range->start_freq_khz > freq_range->end_freq_khz)
-		return 0;
-
-	freq_diff = freq_range->end_freq_khz - freq_range->start_freq_khz;
-
-	if (freq_diff == 0 || freq_range->max_bandwidth_khz > freq_diff)
-		return 0;
-
-	return 1;
-}
-
 static void print_reg_rule(struct ieee80211_reg_rule *rule)
 {
 	struct ieee80211_freq_range *freq;
diff --git a/reglib.h b/reglib.h
index 095090b..f3a76ef 100644
--- a/reglib.h
+++ b/reglib.h
@@ -92,7 +92,6 @@ struct ieee80211_regdomain *country2rd(__u8 *db, int dblen,
 	struct regdb_file_reg_country *country);
 
 /* reg helpers */
-int is_valid_reg_rule(const struct ieee80211_reg_rule *rule);
 void print_regdom(struct ieee80211_regdomain *rd);
 
 #endif

