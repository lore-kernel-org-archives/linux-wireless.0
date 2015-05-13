Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f169.google.com ([209.85.192.169]:34298 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933501AbbEMSew (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 May 2015 14:34:52 -0400
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: ming.lei@canonical.com, rusty@rustcorp.com.au
Cc: torvalds@linux-foundation.org, dhowells@redhat.com,
	seth.forshee@canonical.com, linux-kernel@vger.kernel.org,
	pebolle@tiscali.nl, linux-wireless@vger.kernel.org,
	gregkh@linuxfoundation.org, jlee@suse.com, tiwai@suse.de,
	casey@schaufler-ca.com, keescook@chromium.org, mjg59@srcf.ucam.org,
	akpm@linux-foundation.org, "Luis R. Rodriguez" <mcgrof@suse.com>
Subject: [RFC v2 4/6] scripts/sign-file.c: add support to only create signature file
Date: Wed, 13 May 2015 11:23:54 -0700
Message-Id: <1431541436-17007-5-git-send-email-mcgrof@do-not-panic.com> (sfid-20150513_203517_394305_A08D147C)
In-Reply-To: <1431541436-17007-1-git-send-email-mcgrof@do-not-panic.com>
References: <1431541436-17007-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "Luis R. Rodriguez" <mcgrof@suse.com>

You can create a file.pkcs7 file with the -d option right now
but that still modifies the file. If all you want is the signature
file you can use -s now, that will leave the file passed as-is.

This will be useful when firmware signature support is added
upstream as firmware will be left intact, and we'll only require
the signature file. The descriptor is implicit by file extension
and the file's own size.

Signed-off-by: Luis R. Rodriguez <mcgrof@suse.com>
---
 scripts/sign-file.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/scripts/sign-file.c b/scripts/sign-file.c
index 5b8a6dd..b468f73 100755
--- a/scripts/sign-file.c
+++ b/scripts/sign-file.c
@@ -41,7 +41,7 @@ static __attribute__((noreturn))
 void format(void)
 {
 	fprintf(stderr,
-		"Usage: scripts/sign-file [-dp] <hash algo> <key> <x509> <module> [<dest>]\n");
+		"Usage: scripts/sign-file [-dps] <hash algo> <key> <x509> <module> [<dest>]\n");
 	exit(2);
 }
 
@@ -86,22 +86,24 @@ int main(int argc, char **argv)
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
+	BIO *b, *bd=NULL, *bm;
 	int opt, n;
 
 	ERR_load_crypto_strings();
 	ERR_clear_error();
 
 	do {
-		opt = getopt(argc, argv, "dp");
+		opt = getopt(argc, argv, "dps");
 		switch (opt) {
 		case 'p': save_pkcs7 = true; break;
+		case 's': sign_only = true; save_pkcs7 = true; break;
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
-- 
2.3.2.209.gd67f9d5.dirty

