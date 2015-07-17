Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40091 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751471AbbGQQTL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Jul 2015 12:19:11 -0400
Subject: [PATCH 21/27] sign-file: Generate CMS message as signature instead
 of PKCS#7
From: David Howells <dhowells@redhat.com>
To: mcgrof@gmail.com
Cc: mjg59@srcf.ucam.org, keyrings@linux-nfs.org,
	gregkh@linuxfoundation.org, kyle@kernel.org,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	seth.forshee@canonical.com, linux-security-module@vger.kernel.org,
	zohar@linux.vnet.ibm.com, dwmw2@infradead.org
Date: Fri, 17 Jul 2015 17:19:04 +0100
Message-ID: <20150717161904.2578.48433.stgit@warthog.procyon.org.uk> (sfid-20150717_182135_584096_9CCDCEBE)
In-Reply-To: <20150717161456.2578.95678.stgit@warthog.procyon.org.uk>
References: <20150717161456.2578.95678.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Make sign-file use the OpenSSL CMS routines to generate a message to be
used as the signature blob instead of the PKCS#7 routines.  This allows us
to change how the matching X.509 certificate is selected.  With PKCS#7 the
only option is to match on the serial number and issuer fields of an X.509
certificate; with CMS, we also have the option of matching by subjectKeyId
extension.  The new behaviour is selected with the "-k" flag.

Without the -k flag specified, the output is pretty much identical to the
PKCS#7 output.

Whilst we're at it, don't include the S/MIME capability list in the message
as it's irrelevant to us.

Signed-off-by: David Howells <dhowells@redhat.com>
Reviewed-By: David Woodhouse <David.Woodhouse@intel.com
---

 scripts/sign-file.c |   51 +++++++++++++++++++++++++++------------------------
 1 file changed, 27 insertions(+), 24 deletions(-)

diff --git a/scripts/sign-file.c b/scripts/sign-file.c
index ad0aa21bd3ac..de213e5c0cd3 100755
--- a/scripts/sign-file.c
+++ b/scripts/sign-file.c
@@ -20,7 +20,7 @@
 #include <openssl/bio.h>
 #include <openssl/evp.h>
 #include <openssl/pem.h>
-#include <openssl/pkcs7.h>
+#include <openssl/cms.h>
 #include <openssl/err.h>
 #include <openssl/engine.h>
 
@@ -107,13 +107,14 @@ int main(int argc, char **argv)
 	struct module_signature sig_info = { .id_type = PKEY_ID_PKCS7 };
 	char *hash_algo = NULL;
 	char *private_key_name, *x509_name, *module_name, *dest_name;
-	bool save_pkcs7 = false, replace_orig;
+	bool save_cms = false, replace_orig;
 	bool sign_only = false;
 	unsigned char buf[4096];
-	unsigned long module_size, pkcs7_size;
+	unsigned long module_size, cms_size;
+	unsigned int use_keyid = 0;
 	const EVP_MD *digest_algo;
 	EVP_PKEY *private_key;
-	PKCS7 *pkcs7;
+	CMS_ContentInfo *cms;
 	X509 *x509;
 	BIO *b, *bd = NULL, *bm;
 	int opt, n;
@@ -125,10 +126,11 @@ int main(int argc, char **argv)
 	key_pass = getenv("KBUILD_SIGN_PIN");
 
 	do {
-		opt = getopt(argc, argv, "dp");
+		opt = getopt(argc, argv, "dpk");
 		switch (opt) {
-		case 'p': save_pkcs7 = true; break;
-		case 'd': sign_only = true; save_pkcs7 = true; break;
+		case 'p': save_cms = true; break;
+		case 'd': sign_only = true; save_cms = true; break;
+		case 'k': use_keyid = CMS_USE_KEYID; break;
 		case -1: break;
 		default: format();
 		}
@@ -208,23 +210,24 @@ int main(int argc, char **argv)
 	bm = BIO_new_file(module_name, "rb");
 	ERR(!bm, "%s", module_name);
 
-	/* Load the PKCS#7 message from the digest buffer. */
-	pkcs7 = PKCS7_sign(NULL, NULL, NULL, NULL,
-			   PKCS7_NOCERTS | PKCS7_PARTIAL | PKCS7_BINARY | PKCS7_DETACHED | PKCS7_STREAM);
-	ERR(!pkcs7, "PKCS7_sign");
+	/* Load the CMS message from the digest buffer. */
+	cms = CMS_sign(NULL, NULL, NULL, NULL,
+		       CMS_NOCERTS | CMS_PARTIAL | CMS_BINARY | CMS_DETACHED | CMS_STREAM);
+	ERR(!cms, "CMS_sign");
 
-	ERR(!PKCS7_sign_add_signer(pkcs7, x509, private_key, digest_algo, PKCS7_NOCERTS | PKCS7_BINARY),
-	    "PKCS7_sign_add_signer");
-	ERR(PKCS7_final(pkcs7, bm, PKCS7_NOCERTS | PKCS7_BINARY) < 0,
-	    "PKCS7_final");
+	ERR(!CMS_add1_signer(cms, x509, private_key, digest_algo,
+			     CMS_NOCERTS | CMS_BINARY | CMS_NOSMIMECAP | use_keyid),
+	    "CMS_sign_add_signer");
+	ERR(CMS_final(cms, bm, NULL, CMS_NOCERTS | CMS_BINARY) < 0,
+	    "CMS_final");
 
-	if (save_pkcs7) {
-		char *pkcs7_name;
+	if (save_cms) {
+		char *cms_name;
 
-		ERR(asprintf(&pkcs7_name, "%s.pkcs7", module_name) < 0, "asprintf");
-		b = BIO_new_file(pkcs7_name, "wb");
-		ERR(!b, "%s", pkcs7_name);
-		ERR(i2d_PKCS7_bio_stream(b, pkcs7, NULL, 0) < 0, "%s", pkcs7_name);
+		ERR(asprintf(&cms_name, "%s.p7s", module_name) < 0, "asprintf");
+		b = BIO_new_file(cms_name, "wb");
+		ERR(!b, "%s", cms_name);
+		ERR(i2d_CMS_bio_stream(b, cms, NULL, 0) < 0, "%s", cms_name);
 		BIO_free(b);
 	}
 
@@ -240,9 +243,9 @@ int main(int argc, char **argv)
 	ERR(n < 0, "%s", module_name);
 	module_size = BIO_number_written(bd);
 
-	ERR(i2d_PKCS7_bio_stream(bd, pkcs7, NULL, 0) < 0, "%s", dest_name);
-	pkcs7_size = BIO_number_written(bd) - module_size;
-	sig_info.sig_len = htonl(pkcs7_size);
+	ERR(i2d_CMS_bio_stream(bd, cms, NULL, 0) < 0, "%s", dest_name);
+	cms_size = BIO_number_written(bd) - module_size;
+	sig_info.sig_len = htonl(cms_size);
 	ERR(BIO_write(bd, &sig_info, sizeof(sig_info)) < 0, "%s", dest_name);
 	ERR(BIO_write(bd, magic_number, sizeof(magic_number) - 1) < 0, "%s", dest_name);
 

