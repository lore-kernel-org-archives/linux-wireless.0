Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f177.google.com ([209.85.192.177]:64355 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752496Ab3EaCKu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 May 2013 22:10:50 -0400
Received: by mail-pd0-f177.google.com with SMTP id u11so1382354pdi.36
        for <linux-wireless@vger.kernel.org>; Thu, 30 May 2013 19:10:49 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: wireless-regdb@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 15/40] crda: use gcry_sexp_release() on crda_verify_db_signature()
Date: Thu, 30 May 2013 19:09:04 -0700
Message-Id: <1369966169-23640-16-git-send-email-mcgrof@do-not-panic.com> (sfid-20130531_041052_564372_AAAA624C)
In-Reply-To: <1369966169-23640-1-git-send-email-mcgrof@do-not-panic.com>
References: <1369966169-23640-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>

This fixes 6 of 10 reported valgrind errors when
crda_verify_db_signature() is used through regdbdump.

Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 reglib.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/reglib.c b/reglib.c
index 17e3f31..634525b 100644
--- a/reglib.c
+++ b/reglib.c
@@ -135,13 +135,14 @@ int crda_verify_db_signature(uint8_t *db, int dblen, int siglen)
 	if (gcry_sexp_build(&data, NULL, "(data (flags pkcs1) (hash sha1 %b))",
 			    20, hash)) {
 		fprintf(stderr, "Failed to build data S-expression.\n");
-		goto out;
+		return ok;
 	}
 
 	if (gcry_sexp_build(&signature, NULL, "(sig-val (rsa (s %b)))",
 			    siglen, db + dblen)) {
 		fprintf(stderr, "Failed to build signature S-expression.\n");
-		goto out;
+		gcry_sexp_release(data);
+		return ok;
 	}
 
 	for (i = 0; (i < sizeof(keys)/sizeof(keys[0])) && (!ok); i++) {
@@ -161,12 +162,15 @@ int crda_verify_db_signature(uint8_t *db, int dblen, int siglen)
 		}
 
 		ok = gcry_pk_verify(signature, data, rsa) == 0;
+		gcry_sexp_release(rsa);
 	}
 
 	if (!ok)
 		fprintf(stderr, "Database signature verification failed.\n");
 
 out:
+	gcry_sexp_release(data);
+	gcry_sexp_release(signature);
 	return ok;
 }
 #endif /* USE_GCRYPT */
-- 
1.7.10.4

