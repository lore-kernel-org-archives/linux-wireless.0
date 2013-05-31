Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f47.google.com ([209.85.160.47]:58200 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751800Ab3EaCLU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 May 2013 22:11:20 -0400
Received: by mail-pb0-f47.google.com with SMTP id rr4so1386471pbb.34
        for <linux-wireless@vger.kernel.org>; Thu, 30 May 2013 19:11:20 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: wireless-regdb@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 22/40] crda: rename crda_verify_db_signature() to reglib_verify_db_signature()
Date: Thu, 30 May 2013 19:09:11 -0700
Message-Id: <1369966169-23640-23-git-send-email-mcgrof@do-not-panic.com> (sfid-20130531_042937_655460_82F81BEF)
In-Reply-To: <1369966169-23640-1-git-send-email-mcgrof@do-not-panic.com>
References: <1369966169-23640-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>

Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 reglib.c |   12 ++++++------
 reglib.h |    2 +-
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/reglib.c b/reglib.c
index a957f0e..316e201 100644
--- a/reglib.c
+++ b/reglib.c
@@ -50,7 +50,7 @@ void *reglib_get_file_ptr(uint8_t *db, int dblen, int structlen, uint32_t ptr)
 }
 
 /*
- * crda_verify_db_signature():
+ * reglib_verify_db_signature():
  *
  * Checks the validity of the signature found on the regulatory
  * database against the array 'keys'. Returns 1 if there exists
@@ -59,7 +59,7 @@ void *reglib_get_file_ptr(uint8_t *db, int dblen, int structlen, uint32_t ptr)
  */
 
 #ifdef USE_OPENSSL
-int crda_verify_db_signature(uint8_t *db, int dblen, int siglen)
+int reglib_verify_db_signature(uint8_t *db, int dblen, int siglen)
 {
 	RSA *rsa;
 	uint8_t hash[SHA_DIGEST_LENGTH];
@@ -118,7 +118,7 @@ out:
 #endif /* USE_OPENSSL */
 
 #ifdef USE_GCRYPT
-int crda_verify_db_signature(uint8_t *db, int dblen, int siglen)
+int reglib_verify_db_signature(uint8_t *db, int dblen, int siglen)
 {
 	gcry_mpi_t mpi_e, mpi_n;
 	gcry_sexp_t rsa, signature, data;
@@ -180,7 +180,7 @@ out:
 #endif /* USE_GCRYPT */
 
 #if !defined(USE_OPENSSL) && !defined(USE_GCRYPT)
-int crda_verify_db_signature(uint8_t *db, int dblen, int siglen)
+int reglib_verify_db_signature(uint8_t *db, int dblen, int siglen)
 {
 	return 1;
 }
@@ -295,7 +295,7 @@ reglib_get_rd_idx(unsigned int idx, const char *file)
 		goto out;
 
 	/* verify signature */
-	if (!crda_verify_db_signature(db, dblen, siglen))
+	if (!reglib_verify_db_signature(db, dblen, siglen))
 		goto out;
 
 	num_countries = ntohl(header->reg_country_num);
@@ -366,7 +366,7 @@ reglib_get_rd_alpha2(const char *alpha2, const char *file)
 		goto out;
 
 	/* verify signature */
-	if (!crda_verify_db_signature(db, dblen, siglen))
+	if (!reglib_verify_db_signature(db, dblen, siglen))
 		goto out;
 
 	num_countries = ntohl(header->reg_country_num);
diff --git a/reglib.h b/reglib.h
index 3510889..2f49a32 100644
--- a/reglib.h
+++ b/reglib.h
@@ -71,7 +71,7 @@ static inline uint32_t min(uint32_t a, uint32_t b)
 }
 
 void *reglib_get_file_ptr(uint8_t *db, int dblen, int structlen, uint32_t ptr);
-int crda_verify_db_signature(uint8_t *db, int dblen, int siglen);
+int reglib_verify_db_signature(uint8_t *db, int dblen, int siglen);
 
 const struct ieee80211_regdomain *
 reglib_get_rd_idx(unsigned int idx, const char *file);
-- 
1.7.10.4

