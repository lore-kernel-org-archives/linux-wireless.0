Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:60041 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753701Ab2BDB00 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Feb 2012 20:26:26 -0500
Received: by mail-pw0-f46.google.com with SMTP id u11so3334452pbd.19
        for <linux-wireless@vger.kernel.org>; Fri, 03 Feb 2012 17:26:26 -0800 (PST)
From: "Luis R. Rodriguez" <mcgrof@frijolero.org>
To: linux-wireless@vger.kernel.org
Cc: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Subject: [RFC 11/11] crda: rename reglib_get_*() routines
Date: Fri,  3 Feb 2012 17:25:48 -0800
Message-Id: <1328318748-21044-12-git-send-email-mcgrof@frijolero.org> (sfid-20120204_022634_624332_25CFBA39)
In-Reply-To: <1328318748-21044-1-git-send-email-mcgrof@frijolero.org>
References: <1328318748-21044-1-git-send-email-mcgrof@frijolero.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

reglib_get_country_idx() --> reglib_get_rd_alpha2()
reglib_get_country_alpha2() --> reglib_get_rd_alpha2()

This reflects better what we provide back out.

Signed-off-by: Luis R. Rodriguez <mcgrof@frijolero.org>
---
 crda.c   |    2 +-
 reglib.c |    4 ++--
 reglib.h |    8 ++++----
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/crda.c b/crda.c
index c6dc3d4..cdbc69a 100644
--- a/crda.c
+++ b/crda.c
@@ -191,7 +191,7 @@ int main(int argc, char **argv)
 
 	close(fd);
 
-	rd = reglib_get_country_alpha2(alpha2, *regdb);
+	rd = reglib_get_rd_alpha2(alpha2, *regdb);
 	if (!rd) {
 		fprintf(stderr, "No country match in regulatory database.\n");
 		return -1;
diff --git a/reglib.c b/reglib.c
index 12698fa..bc81974 100644
--- a/reglib.c
+++ b/reglib.c
@@ -226,7 +226,7 @@ country2rd(uint8_t *db, int dblen,
 }
 
 struct ieee80211_regdomain *
-reglib_get_country_idx(unsigned int idx, const char *file)
+reglib_get_rd_idx(unsigned int idx, const char *file)
 {
 	int fd;
 	struct stat stat;
@@ -288,7 +288,7 @@ reglib_get_country_idx(unsigned int idx, const char *file)
 }
 
 struct ieee80211_regdomain *
-reglib_get_country_alpha2(const char *alpha2, const char *file)
+reglib_get_rd_alpha2(const char *alpha2, const char *file)
 {
 	int fd;
 	struct stat stat;
diff --git a/reglib.h b/reglib.h
index 99e6c76..9b9bd5c 100644
--- a/reglib.h
+++ b/reglib.h
@@ -74,16 +74,16 @@ void *crda_get_file_ptr(uint8_t *db, int dblen, int structlen, uint32_t ptr);
 int crda_verify_db_signature(uint8_t *db, int dblen, int siglen);
 
 struct ieee80211_regdomain *
-reglib_get_country_idx(unsigned int idx, const char *file);
+reglib_get_rd_idx(unsigned int idx, const char *file);
 
 #define reglib_for_each_country(__rd, __idx, __file)			\
-	for (__rd = reglib_get_country_idx(__idx, __file);		\
+	for (__rd = reglib_get_rd_idx(__idx, __file);		\
 	     __rd != NULL;						\
-	     __rd = reglib_get_country_idx(__idx, __file),		\
+	     __rd = reglib_get_rd_idx(__idx, __file),		\
 	     __idx++)
 
 struct ieee80211_regdomain *
-reglib_get_country_alpha2(const char *alpha2, const char *file);
+reglib_get_rd_alpha2(const char *alpha2, const char *file);
 
 /* reg helpers */
 void print_regdom(struct ieee80211_regdomain *rd);
-- 
1.7.4.15.g7811d

