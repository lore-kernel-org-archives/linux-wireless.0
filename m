Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:60041 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753573Ab2BDB0U (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Feb 2012 20:26:20 -0500
Received: by mail-pw0-f46.google.com with SMTP id u11so3334452pbd.19
        for <linux-wireless@vger.kernel.org>; Fri, 03 Feb 2012 17:26:20 -0800 (PST)
From: "Luis R. Rodriguez" <mcgrof@frijolero.org>
To: linux-wireless@vger.kernel.org
Cc: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Subject: [RFC 09/11] crda: make country2rd() static
Date: Fri,  3 Feb 2012 17:25:46 -0800
Message-Id: <1328318748-21044-10-git-send-email-mcgrof@frijolero.org> (sfid-20120204_022637_010020_B7F1308E)
In-Reply-To: <1328318748-21044-1-git-send-email-mcgrof@frijolero.org>
References: <1328318748-21044-1-git-send-email-mcgrof@frijolero.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Luis R. Rodriguez <mcgrof@frijolero.org>
---
 reglib.c |    5 +++--
 reglib.h |    4 ----
 2 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/reglib.c b/reglib.c
index 759c676..3cb7f72 100644
--- a/reglib.c
+++ b/reglib.c
@@ -186,8 +186,9 @@ static void reg_rule2rd(uint8_t *db, int dblen,
 }
 
 /* Converts a file regdomain to ieee80211_regdomain, easier to manage */
-struct ieee80211_regdomain *country2rd(uint8_t *db, int dblen,
-	struct regdb_file_reg_country *country)
+static struct ieee80211_regdomain *
+country2rd(uint8_t *db, int dblen,
+	   struct regdb_file_reg_country *country)
 {
 	struct regdb_file_reg_rules_collection *rcoll;
 	struct ieee80211_regdomain *rd;
diff --git a/reglib.h b/reglib.h
index bec6359..42c7999 100644
--- a/reglib.h
+++ b/reglib.h
@@ -75,10 +75,6 @@ static inline uint32_t min(uint32_t a, uint32_t b)
 void *crda_get_file_ptr(uint8_t *db, int dblen, int structlen, uint32_t ptr);
 int crda_verify_db_signature(uint8_t *db, int dblen, int siglen);
 
-/* File reg db entry -> rd converstion utilities */
-struct ieee80211_regdomain *country2rd(uint8_t *db, int dblen,
-	struct regdb_file_reg_country *country);
-
 struct ieee80211_regdomain *
 reglib_get_country_idx(unsigned int idx, const char *file);
 
-- 
1.7.4.15.g7811d

