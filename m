Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.153]:28116 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751551AbYJWXFO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Oct 2008 19:05:14 -0400
Received: by fg-out-1718.google.com with SMTP id 19so742984fgg.17
        for <linux-wireless@vger.kernel.org>; Thu, 23 Oct 2008 16:05:07 -0700 (PDT)
Date: Fri, 24 Oct 2008 01:04:59 +0200
From: Davide Pesavento <davidepesa@gmail.com>
To: mcgrof@gmail.com
Cc: linux-wireless@vger.kernel.org
Subject: [CRDA PATCH 1/6] Consolidate db signature validation in one
	function.
Message-ID: <20081023230459.GA8681@PesaBook.pesa.homelinux.org> (sfid-20081024_010522_652740_31F60F5C)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Both crda.c and dump.c had their own version of the code which
checks the validity of the signature on the regulatory db.
Having a common implementation shared by both files makes
maintenance easier and removes code duplication.

Signed-off-by: Davide Pesavento <davidepesa@gmail.com>
---
 Makefile |   14 ++++----
 crda.c   |  111 +---------------------------------------------------------
 dump.c   |  117 ++-----------------------------------------------------------
 regdb.c  |  119 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 regdb.h  |    4 ++
 5 files changed, 134 insertions(+), 231 deletions(-)
 create mode 100644 regdb.c

diff --git a/Makefile b/Makefile
index 6d2faa6..69a2eba 100644
--- a/Makefile
+++ b/Makefile
@@ -17,23 +17,23 @@ INSTALL ?= install
 
 CRDA_LIB = "/usr/lib/crda/"
 
-all:	regulatory.bin warn crda
+all: regulatory.bin warn crda
 	@$(MAKE) --no-print-directory -f Makefile verify
 
 regulatory.bin:	db2bin.py key.priv.pem db.txt dbparse.py
 	@./db2bin.py regulatory.bin db.txt key.priv.pem
 
-crda: keys-gcrypt.c keys-ssl.c crda.c regdb.h
-	$(CC) $(CFLAGS) $(LDFLAGS) -lnl -o $@ crda.c
+crda: keys-ssl.c keys-gcrypt.c regdb.h regdb.o crda.o
+	$(CC) $(CFLAGS) $(LDFLAGS) -lnl -o $@ regdb.o crda.o
 
 clean:
-	@rm -f regulatory.bin dump *~ *.pyc keys-*.c crda
+	@rm -f regulatory.bin crda dump *.o *~ *.pyc keys-*.c
 	@if test -f key.priv.pem && diff -qNs test-key key.priv.pem >/dev/null ; then \
 	rm -f key.priv.pem;\
 	fi
 
 warn:
-	@if test !  -f key.priv.pem || diff -qNs test-key key.priv.pem >/dev/null ; then \
+	@if test ! -f key.priv.pem || diff -qNs test-key key.priv.pem >/dev/null ; then \
 	echo '**************************************';\
 	echo '**  WARNING!                        **';\
 	echo '**  No key found, using TEST key!   **';\
@@ -46,8 +46,8 @@ key.priv.pem:
 generate_key:
 	openssl genrsa -out key.priv.pem 2048
 
-dump:	dump.c regdb.h keys-ssl.c keys-gcrypt.c
-	$(CC) $(CFLAGS) $(LDFLAGS) dump.c -o dump
+dump: keys-ssl.c keys-gcrypt.c regdb.h regdb.o dump.o
+	$(CC) $(CFLAGS) $(LDFLAGS) -o $@ regdb.o dump.o
 
 keys-ssl.c: key2pub.py $(wildcard *.pem)
 	@./key2pub.py --ssl *.pem > keys-ssl.c
diff --git a/crda.c b/crda.c
index b5e738f..cf493e8 100644
--- a/crda.c
+++ b/crda.c
@@ -21,21 +21,6 @@
 
 #include "regdb.h"
 
-#ifdef USE_OPENSSL
-#include <openssl/objects.h>
-#include <openssl/bn.h>
-#include <openssl/rsa.h>
-#include <openssl/sha.h>
-
-#include "keys-ssl.c"
-#endif
-
-#ifdef USE_GCRYPT
-#include <gcrypt.h>
-
-#include "keys-gcrypt.c"
-#endif
-
 struct nl80211_state {
 	struct nl_handle *nl_handle;
 	struct nl_cache *nl_cache;
@@ -199,18 +184,6 @@ int main(int argc, char **argv)
 	struct nlattr *nl_reg_rules;
 	int num_rules;
 
-#ifdef USE_OPENSSL
-	RSA *rsa;
-	__u8 hash[SHA_DIGEST_LENGTH];
-	int ok = 0;
-#endif
-#ifdef USE_GCRYPT
-	gcry_mpi_t mpi_e, mpi_n;
-	gcry_sexp_t rsa, signature, data;
-	__u8 hash[20];
-	int ok = 0;
-#endif
-
 	const char regdb[] = "/usr/lib/crda/regulatory.bin";
 
 	if (argc != 1) {
@@ -274,90 +247,8 @@ int main(int argc, char **argv)
 	}
 
 	/* verify signature */
-#ifdef USE_OPENSSL
-	rsa = RSA_new();
-	if (!rsa) {
-		fprintf(stderr, "Failed to create RSA key\n");
-		return -EINVAL;
-	}
-
-	if (SHA1(db, dblen, hash) != hash) {
-		fprintf(stderr, "Failed to calculate SHA sum\n");
-		RSA_free(rsa);
-		return -EINVAL;
-	}
-
-	for (i = 0; i < sizeof(keys)/sizeof(keys[0]); i++) {
-		rsa->e = &keys[i].e;
-		rsa->n = &keys[i].n;
-
-		if (RSA_size(rsa) != siglen)
-			continue;
-
-		ok = RSA_verify(NID_sha1, hash, SHA_DIGEST_LENGTH,
-				db + dblen, siglen, rsa) == 1;
-		if (ok)
-			break;
-	}
-
-	rsa->e = NULL;
-	rsa->n = NULL;
-	RSA_free(rsa);
-
-	if (!ok) {
-		fprintf(stderr, "Database signature wrong\n");
+	if (!crda_verify_db_signature(db, dblen, siglen))
 		return -EINVAL;
-	}
-
-	BN_print_fp(stdout, &keys[0].n);
-#endif
-
-#ifdef USE_GCRYPT
-	/* initialise */
-	gcry_check_version(NULL);
-
-	/* hash the db */
-	gcry_md_hash_buffer(GCRY_MD_SHA1, hash, db, dblen);
-
-	if (gcry_sexp_build(&data, NULL, "(data (flags pkcs1) (hash sha1 %b))",
-			    20, hash)) {
-		fprintf(stderr, "failed to build data expression\n");
-		return 2;
-	}
-
-	if (gcry_sexp_build(&signature, NULL, "(sig-val (rsa (s %b)))",
-			    siglen, db + dblen)) {
-		fprintf(stderr, "failed to build signature expression\n");
-		return 2;
-	}
-
-	for (i = 0; i < sizeof(keys)/sizeof(keys[0]); i++) {
-		if (gcry_mpi_scan(&mpi_e, GCRYMPI_FMT_USG,
-				  keys[0].e, keys[0].len_e, NULL) ||
-		    gcry_mpi_scan(&mpi_n, GCRYMPI_FMT_USG,
-		    		  keys[0].n, keys[0].len_n, NULL)) {
-			fprintf(stderr, "failed to convert numbers\n");
-			return 2;
-		}
-
-		if (gcry_sexp_build(&rsa, NULL,
-				    "(public-key (rsa (n %m) (e %m)))",
-				    mpi_n, mpi_e)) {
-			fprintf(stderr, "failed to build rsa key\n");
-			return 2;
-		}
-
-		if (!gcry_pk_verify(signature, data, rsa)) {
-			ok = 1;
-			break;
-		}
-	}
-
-	if (!ok) {
-		fprintf(stderr, "Database signature wrong\n");
-		return 2;
-	}
-#endif
 
 	num_countries = ntohl(header->reg_country_num);
 	countries = get_file_ptr(db, dblen,
diff --git a/dump.c b/dump.c
index b133915..89f16b2 100644
--- a/dump.c
+++ b/dump.c
@@ -1,29 +1,13 @@
+#include <errno.h>
 #include <stdlib.h>
 #include <stdio.h>
 #include <sys/mman.h>
-#include <sys/types.h>
 #include <sys/stat.h>
-#include <unistd.h>
 #include <fcntl.h>
 #include <arpa/inet.h> /* ntohl */
 
 #include "regdb.h"
 
-#ifdef USE_OPENSSL
-#include <openssl/objects.h>
-#include <openssl/bn.h>
-#include <openssl/rsa.h>
-#include <openssl/sha.h>
-
-#include "keys-ssl.c"
-#endif
-
-#ifdef USE_GCRYPT
-#include <gcrypt.h>
-
-#include "keys-gcrypt.c"
-#endif
-
 static void *get_file_ptr(__u8 *db, int dblen, int structlen, __be32 ptr)
 {
 	__u32 p = ntohl(ptr);
@@ -95,17 +79,6 @@ int main(int argc, char **argv)
 	struct regdb_file_header *header;
 	struct regdb_file_reg_country *countries;
 	int dblen, siglen, num_countries, i, j;
-#ifdef USE_OPENSSL
-	RSA *rsa;
-	__u8 hash[SHA_DIGEST_LENGTH];
-	int ok = 0;
-#endif
-#ifdef USE_GCRYPT
-	gcry_mpi_t mpi_e, mpi_n;
-	gcry_sexp_t rsa, signature, data;
-	__u8 hash[20];
-	int ok = 0;
-#endif
 
 	if (argc != 2) {
 		fprintf(stderr, "Usage: %s <filename>\n", argv[0]);
@@ -153,92 +126,8 @@ int main(int argc, char **argv)
 	}
 
 	/* verify signature */
-#ifdef USE_OPENSSL
-	rsa = RSA_new();
-	if (!rsa) {
-		fprintf(stderr, "Failed to create RSA key\n");
-		return 2;
-	}
-
-	if (SHA1(db, dblen, hash) != hash) {
-		fprintf(stderr, "Failed to calculate SHA sum\n");
-		return 2;
-	}
-
-	for (i = 0; i < sizeof(keys)/sizeof(keys[0]); i++) {
-		rsa->e = &keys[i].e;
-		rsa->n = &keys[i].n;
-
-		if (RSA_size(rsa) != siglen)
-			continue;
-
-		ok = RSA_verify(NID_sha1, hash, SHA_DIGEST_LENGTH,
-				db + dblen, siglen, rsa) == 1;
-		if (ok)
-			break;
-	}
-
-	if (!ok) {
-		fprintf(stderr, "Database signature wrong\n");
-		return 2;
-	}
-
-	rsa->e = NULL;
-	rsa->n = NULL;
-	RSA_free(rsa);
-
-	BN_print_fp(stdout, &keys[0].n);
-
-	return 0;
-#endif
-
-#ifdef USE_GCRYPT
-	/* initialise */
-	gcry_check_version(NULL);
-
-	/* hash the db */
-	gcry_md_hash_buffer(GCRY_MD_SHA1, hash, db, dblen);
-
-	if (gcry_sexp_build(&data, NULL, "(data (flags pkcs1) (hash sha1 %b))",
-			    20, hash)) {
-		fprintf(stderr, "failed to build data expression\n");
-		return 2;
-	}
-
-	if (gcry_sexp_build(&signature, NULL, "(sig-val (rsa (s %b)))",
-			    siglen, db + dblen)) {
-		fprintf(stderr, "failed to build signature expression\n");
-		return 2;
-	}
-
-	for (i = 0; i < sizeof(keys)/sizeof(keys[0]); i++) {
-		if (gcry_mpi_scan(&mpi_e, GCRYMPI_FMT_USG,
-				  keys[0].e, keys[0].len_e, NULL) ||
-		    gcry_mpi_scan(&mpi_n, GCRYMPI_FMT_USG,
-		    		  keys[0].n, keys[0].len_n, NULL)) {
-			fprintf(stderr, "failed to convert numbers\n");
-			return 2;
-		}
-
-		if (gcry_sexp_build(&rsa, NULL,
-				    "(public-key (rsa (n %m) (e %m)))",
-				    mpi_n, mpi_e)) {
-			fprintf(stderr, "failed to build rsa key\n");
-			return 2;
-		}
-
-		if (!gcry_pk_verify(signature, data, rsa)) {
-			ok = 1;
-			break;
-		}
-	}
-
-	if (!ok) {
-		fprintf(stderr, "Database signature wrong\n");
-		return 2;
-	}
-
-#endif
+	if (!crda_verify_db_signature(db, dblen, siglen))
+		return -EINVAL;
 
 	num_countries = ntohl(header->reg_country_num);
 	countries = get_file_ptr(db, dblen,
diff --git a/regdb.c b/regdb.c
new file mode 100644
index 0000000..385ba7d
--- /dev/null
+++ b/regdb.c
@@ -0,0 +1,119 @@
+#ifdef USE_OPENSSL
+#include <stdio.h>
+#include <openssl/objects.h>
+#include <openssl/rsa.h>
+#include <openssl/sha.h>
+#endif
+
+#ifdef USE_GCRYPT
+#include <stdio.h>
+#include <gcrypt.h>
+#endif
+
+#include "regdb.h"
+
+#ifdef USE_OPENSSL
+#include "keys-ssl.c"
+#endif
+
+#ifdef USE_GCRYPT
+#include "keys-gcrypt.c"
+#endif
+
+/*
+ * Checks the validity of the signature found on the regulatory
+ * database against the array 'keys'. Returns 1 if there exists
+ * at least one key in the array such that the signature is valid
+ * against that key; 0 otherwise.
+ */
+int crda_verify_db_signature(__u8 *db, int dblen, int siglen)
+{
+#ifdef USE_OPENSSL
+	RSA *rsa;
+	__u8 hash[SHA_DIGEST_LENGTH];
+	unsigned int i;
+	int ok = 0;
+
+	rsa = RSA_new();
+	if (!rsa) {
+		fprintf(stderr, "Failed to create RSA key.\n");
+		goto out;
+	}
+
+	if (SHA1(db, dblen, hash) != hash) {
+		fprintf(stderr, "Failed to calculate SHA1 sum.\n");
+		RSA_free(rsa);
+		goto out;
+	}
+
+	for (i = 0; (i < sizeof(keys)/sizeof(keys[0])) && (!ok); i++) {
+		rsa->e = &keys[i].e;
+		rsa->n = &keys[i].n;
+
+		if (RSA_size(rsa) != siglen)
+			continue;
+
+		ok = RSA_verify(NID_sha1, hash, SHA_DIGEST_LENGTH,
+				db + dblen, siglen, rsa) == 1;
+	}
+
+	rsa->e = NULL;
+	rsa->n = NULL;
+	RSA_free(rsa);
+#endif
+
+#ifdef USE_GCRYPT
+	gcry_mpi_t mpi_e, mpi_n;
+	gcry_sexp_t rsa, signature, data;
+	__u8 hash[20];
+	unsigned int i;
+	int ok = 0;
+
+	/* initialise */
+	gcry_check_version(NULL);
+
+	/* hash the db */
+	gcry_md_hash_buffer(GCRY_MD_SHA1, hash, db, dblen);
+
+	if (gcry_sexp_build(&data, NULL, "(data (flags pkcs1) (hash sha1 %b))",
+			    20, hash)) {
+		fprintf(stderr, "Failed to build data S-expression.\n");
+		goto out;
+	}
+
+	if (gcry_sexp_build(&signature, NULL, "(sig-val (rsa (s %b)))",
+			    siglen, db + dblen)) {
+		fprintf(stderr, "Failed to build signature S-expression.\n");
+		goto out;
+	}
+
+	for (i = 0; (i < sizeof(keys)/sizeof(keys[0])) && (!ok); i++) {
+		if (gcry_mpi_scan(&mpi_e, GCRYMPI_FMT_USG,
+				keys[0].e, keys[0].len_e, NULL) ||
+		    gcry_mpi_scan(&mpi_n, GCRYMPI_FMT_USG,
+				keys[0].n, keys[0].len_n, NULL)) {
+			fprintf(stderr, "Failed to convert numbers.\n");
+			goto out;
+		}
+
+		if (gcry_sexp_build(&rsa, NULL,
+				    "(public-key (rsa (n %m) (e %m)))",
+				    mpi_n, mpi_e)) {
+			fprintf(stderr, "Failed to build RSA S-expression.\n");
+			goto out;
+		}
+
+		ok = gcry_pk_verify(signature, data, rsa) == 0;
+	}
+#endif
+
+#if defined(USE_OPENSSL) || defined(USE_GCRYPT)
+	if (!ok)
+		fprintf(stderr, "Database signature verification failed.\n");
+
+out:
+	return ok;
+#else
+	return 1;
+#endif
+}
diff --git a/regdb.h b/regdb.h
index 09cc403..bee00a5 100644
--- a/regdb.h
+++ b/regdb.h
@@ -100,6 +100,10 @@ struct regdb_file_reg_country {
 };
 
 
+/* functions */
+int crda_verify_db_signature(__u8 *db, int dblen, int siglen);
+
+
 /*
  * Verify that no unexpected padding is added to structures
  * for some reason.
-- 
1.6.0.2

