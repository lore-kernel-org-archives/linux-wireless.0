Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53774 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754284AbbE1PrJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 May 2015 11:47:09 -0400
Subject: [PATCH 06/20] sign-file: Add option to only create signature file
 [ver #5]
From: David Howells <dhowells@redhat.com>
To: mcgrof@gmail.com
Cc: mjg59@srcf.ucam.org, keyrings@linux-nfs.org,
	gregkh@linuxfoundation.org, kyle@kernel.org,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	seth.forshee@canonical.com, linux-security-module@vger.kernel.org,
	zohar@linux.vnet.ibm.com, dwmw2@infradead.org
Date: Thu, 28 May 2015 16:47:02 +0100
Message-ID: <20150528154702.1259.19569.stgit@warthog.procyon.org.uk> (sfid-20150528_175228_206563_125C3706)
In-Reply-To: <20150528154605.1259.42518.stgit@warthog.procyon.org.uk>
References: <20150528154605.1259.42518.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luis R. Rodriguez <mcgrof@suse.com>

Make the -d option (which currently isn't actually wired to anything) write
out the PKCS#7 message as per the -p option and then exit without either
modifying the source or writing out a compound file of the source, signature
and metadata.

This will be useful when firmware signature support is added
upstream as firmware will be left intact, and we'll only require
the signature file. The descriptor is implicit by file extension
and the file's own size.

Signed-off-by: Luis R. Rodriguez <mcgrof@suse.com>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 scripts/sign-file.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/scripts/sign-file.c b/scripts/sign-file.c
index 5b8a6dda3235..39aaabe89388 100755
--- a/scripts/sign-file.c
+++ b/scripts/sign-file.c
@@ -86,13 +86,14 @@ int main(int argc, char **argv)
 	char *hash_algo = NULL;
 	char *private_key_name, *x509_name, *module_name, *dest_name;
 	bool save_pkcs7 = false, replace_orig;
+	bool sign_only = false;
 	unsigned char buf[4096];
 	unsigned long module_size, pkcs7_size;
 	const EVP_MD *digest_algo;
 	EVP_PKEY *private_key;
 	PKCS7 *pkcs7;
 	X509 *x509;
-	BIO *b, *bd, *bm;
+	BIO *b, *bd = NULL, *bm;
 	int opt, n;
 
 	ERR_load_crypto_strings();
@@ -102,6 +103,7 @@ int main(int argc, char **argv)
 		opt = getopt(argc, argv, "dp");
 		switch (opt) {
 		case 'p': save_pkcs7 = true; break;
+		case 'd': sign_only = true; save_pkcs7 = true; break;
 		case -1: break;
 		default: format();
 		}
@@ -148,8 +150,10 @@ int main(int argc, char **argv)
 	/* Open the destination file now so that we can shovel the module data
 	 * across as we read it.
 	 */
-	bd = BIO_new_file(dest_name, "wb");
-	ERR(!bd, "%s", dest_name);
+	if (!sign_only) {
+		bd = BIO_new_file(dest_name, "wb");
+		ERR(!bd, "%s", dest_name);
+	}
 
 	/* Digest the module data. */
 	OpenSSL_add_all_digests();
@@ -180,6 +184,9 @@ int main(int argc, char **argv)
 		BIO_free(b);
 	}
 
+	if (sign_only)
+		return 0;
+
 	/* Append the marker and the PKCS#7 message to the destination file */
 	ERR(BIO_reset(bm) < 0, "%s", module_name);
 	while ((n = BIO_read(bm, buf, sizeof(buf))),

