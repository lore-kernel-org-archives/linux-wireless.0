Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f42.google.com ([209.85.160.42]:52207 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751561Ab3EaCKq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 May 2013 22:10:46 -0400
Received: by mail-pb0-f42.google.com with SMTP id uo1so1385145pbc.29
        for <linux-wireless@vger.kernel.org>; Thu, 30 May 2013 19:10:45 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: wireless-regdb@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 14/40] crda: separate crda_verify_db_signature() implementations
Date: Thu, 30 May 2013 19:09:03 -0700
Message-Id: <1369966169-23640-15-git-send-email-mcgrof@do-not-panic.com> (sfid-20130531_041048_750624_68CBBFE9)
In-Reply-To: <1369966169-23640-1-git-send-email-mcgrof@do-not-panic.com>
References: <1369966169-23640-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>

This will allow us to handle the error codes more cleanly
and in a readible manner. This change should have no
functional change.

Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 reglib.c |   27 +++++++++++++++++++++------
 1 file changed, 21 insertions(+), 6 deletions(-)

diff --git a/reglib.c b/reglib.c
index cbe9676..17e3f31 100644
--- a/reglib.c
+++ b/reglib.c
@@ -50,14 +50,17 @@ void *crda_get_file_ptr(uint8_t *db, int dblen, int structlen, uint32_t ptr)
 }
 
 /*
+ * crda_verify_db_signature():
+ *
  * Checks the validity of the signature found on the regulatory
  * database against the array 'keys'. Returns 1 if there exists
  * at least one key in the array such that the signature is valid
  * against that key; 0 otherwise.
  */
+
+#ifdef USE_OPENSSL
 int crda_verify_db_signature(uint8_t *db, int dblen, int siglen)
 {
-#ifdef USE_OPENSSL
 	RSA *rsa;
 	uint8_t hash[SHA_DIGEST_LENGTH];
 	unsigned int i;
@@ -105,9 +108,18 @@ int crda_verify_db_signature(uint8_t *db, int dblen, int siglen)
 		}
 		closedir(pubkey_dir);
 	}
-#endif
+
+	if (!ok)
+		fprintf(stderr, "Database signature verification failed.\n");
+
+out:
+	return ok;
+}
+#endif /* USE_OPENSSL */
 
 #ifdef USE_GCRYPT
+int crda_verify_db_signature(uint8_t *db, int dblen, int siglen)
+{
 	gcry_mpi_t mpi_e, mpi_n;
 	gcry_sexp_t rsa, signature, data;
 	uint8_t hash[20];
@@ -150,18 +162,21 @@ int crda_verify_db_signature(uint8_t *db, int dblen, int siglen)
 
 		ok = gcry_pk_verify(signature, data, rsa) == 0;
 	}
-#endif
 
-#if defined(USE_OPENSSL) || defined(USE_GCRYPT)
 	if (!ok)
 		fprintf(stderr, "Database signature verification failed.\n");
 
 out:
 	return ok;
-#else
+}
+#endif /* USE_GCRYPT */
+
+#if !defined(USE_OPENSSL) && !defined(USE_GCRYPT)
+int crda_verify_db_signature(uint8_t *db, int dblen, int siglen)
+{
 	return 1;
-#endif
 }
+#endif
 
 static void reg_rule2rd(uint8_t *db, int dblen,
 	uint32_t ruleptr, struct ieee80211_reg_rule *rd_reg_rule)
-- 
1.7.10.4

