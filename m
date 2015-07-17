Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48457 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751471AbbGQQTX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Jul 2015 12:19:23 -0400
Subject: [PATCH 22/27] extract-cert: Cope with multiple X.509 certificates
 in a single file
From: David Howells <dhowells@redhat.com>
To: mcgrof@gmail.com
Cc: mjg59@srcf.ucam.org, keyrings@linux-nfs.org,
	gregkh@linuxfoundation.org, kyle@kernel.org,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	seth.forshee@canonical.com, linux-security-module@vger.kernel.org,
	zohar@linux.vnet.ibm.com, dwmw2@infradead.org
Date: Fri, 17 Jul 2015 17:19:16 +0100
Message-ID: <20150717161916.2578.50112.stgit@warthog.procyon.org.uk> (sfid-20150717_182129_775358_FEE07A04)
In-Reply-To: <20150717161456.2578.95678.stgit@warthog.procyon.org.uk>
References: <20150717161456.2578.95678.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: David Woodhouse <David.Woodhouse@intel.com>

This is not required for the module signing key, although it doesn't do any
harm — it just means that any additional certs in the PEM file are also
trusted by the kernel.

But it does allow us to use the extract-cert tool for processing the extra
certs from CONFIG_SYSTEM_TRUSTED_KEYS, instead of that horrid awk|base64
hack.

Also cope with being invoked with no input file, creating an empty output
file as a result.

Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 scripts/extract-cert.c |   58 ++++++++++++++++++++++++++++++++++++++----------
 1 file changed, 46 insertions(+), 12 deletions(-)

diff --git a/scripts/extract-cert.c b/scripts/extract-cert.c
index 4fd5b2f07b45..fd0db015c65c 100644
--- a/scripts/extract-cert.c
+++ b/scripts/extract-cert.c
@@ -73,17 +73,34 @@ static void drain_openssl_errors(void)
 	} while(0)
 
 static const char *key_pass;
+static BIO *wb;
+static char *cert_dst;
+int kbuild_verbose;
+
+static void write_cert(X509 *x509)
+{
+	char buf[200];
+
+	if (!wb) {
+		wb = BIO_new_file(cert_dst, "wb");
+		ERR(!wb, "%s", cert_dst);
+	}
+	X509_NAME_oneline(X509_get_subject_name(x509), buf, sizeof(buf));
+	ERR(!i2d_X509_bio(wb, x509), cert_dst);
+	if (kbuild_verbose)
+		fprintf(stderr, "Extracted cert: %s\n", buf);
+}
 
 int main(int argc, char **argv)
 {
-	char *cert_src, *cert_dst;
-	X509 *x509;
-	BIO *b;
+	char *cert_src;
 
 	OpenSSL_add_all_algorithms();
 	ERR_load_crypto_strings();
 	ERR_clear_error();
 
+	kbuild_verbose = atoi(getenv("KBUILD_VERBOSE")?:"0");
+
         key_pass = getenv("KBUILD_SIGN_PIN");
 
 	if (argc != 3)
@@ -92,7 +109,13 @@ int main(int argc, char **argv)
 	cert_src = argv[1];
 	cert_dst = argv[2];
 
-	if (!strncmp(cert_src, "pkcs11:", 7)) {
+	if (!cert_src[0]) {
+		/* Invoked with no input; create empty file */
+		FILE *f = fopen(cert_dst, "wb");
+		ERR(!f, "%s", cert_dst);
+		fclose(f);
+		exit(0);
+	} else if (!strncmp(cert_src, "pkcs11:", 7)) {
 		ENGINE *e;
 		struct {
 			const char *cert_id;
@@ -114,19 +137,30 @@ int main(int argc, char **argv)
 			ERR(!ENGINE_ctrl_cmd_string(e, "PIN", key_pass, 0), "Set PKCS#11 PIN");
 		ENGINE_ctrl_cmd(e, "LOAD_CERT_CTRL", 0, &parms, NULL, 1);
 		ERR(!parms.cert, "Get X.509 from PKCS#11");
-		x509 = parms.cert;
+		write_cert(parms.cert);
 	} else {
+		BIO *b;
+		X509 *x509;
+
 		b = BIO_new_file(cert_src, "rb");
 		ERR(!b, "%s", cert_src);
-		x509 = PEM_read_bio_X509(b, NULL, NULL, NULL);
-		ERR(!x509, "%s", cert_src);
-		BIO_free(b);
+
+		while (1) {
+			x509 = PEM_read_bio_X509(b, NULL, NULL, NULL);
+			if (wb && !x509) {
+				unsigned long err = ERR_peek_last_error();
+				if (ERR_GET_LIB(err) == ERR_LIB_PEM &&
+				    ERR_GET_REASON(err) == PEM_R_NO_START_LINE) {
+					ERR_clear_error();
+					break;
+				}
+			}
+			ERR(!x509, "%s", cert_src);
+			write_cert(x509);
+		}
 	}
 
-	b = BIO_new_file(cert_dst, "wb");
-	ERR(!b, "%s", cert_dst);
-	ERR(!i2d_X509_bio(b, x509), cert_dst);
-	BIO_free(b);
+	BIO_free(wb);
 
 	return 0;
 }

