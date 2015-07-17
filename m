Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49465 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751599AbbGQQRO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Jul 2015 12:17:14 -0400
Subject: [PATCH 11/27] modsign: Allow signing key to be PKCS#11
From: David Howells <dhowells@redhat.com>
To: mcgrof@gmail.com
Cc: mjg59@srcf.ucam.org, keyrings@linux-nfs.org,
	gregkh@linuxfoundation.org, kyle@kernel.org,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	seth.forshee@canonical.com, linux-security-module@vger.kernel.org,
	zohar@linux.vnet.ibm.com, dwmw2@infradead.org
Date: Fri, 17 Jul 2015 17:17:08 +0100
Message-ID: <20150717161708.2578.44915.stgit@warthog.procyon.org.uk> (sfid-20150717_182306_487890_12CD5B07)
In-Reply-To: <20150717161456.2578.95678.stgit@warthog.procyon.org.uk>
References: <20150717161456.2578.95678.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: David Woodhouse <David.Woodhouse@intel.com>

This is only the key; the corresponding *cert* still needs to be in
$(topdir)/signing_key.x509. And there's no way to actually use this
from the build system yet.

Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 scripts/sign-file.c |   29 ++++++++++++++++++++++++-----
 1 file changed, 24 insertions(+), 5 deletions(-)

diff --git a/scripts/sign-file.c b/scripts/sign-file.c
index 720b9bc933ae..ad0aa21bd3ac 100755
--- a/scripts/sign-file.c
+++ b/scripts/sign-file.c
@@ -22,6 +22,7 @@
 #include <openssl/pem.h>
 #include <openssl/pkcs7.h>
 #include <openssl/err.h>
+#include <openssl/engine.h>
 
 struct module_signature {
 	uint8_t		algo;		/* Public-key crypto algorithm [0] */
@@ -154,11 +155,29 @@ int main(int argc, char **argv)
 	/* Read the private key and the X.509 cert the PKCS#7 message
 	 * will point to.
 	 */
-	b = BIO_new_file(private_key_name, "rb");
-	ERR(!b, "%s", private_key_name);
-	private_key = PEM_read_bio_PrivateKey(b, NULL, pem_pw_cb, NULL);
-	ERR(!private_key, "%s", private_key_name);
-	BIO_free(b);
+	if (!strncmp(private_key_name, "pkcs11:", 7)) {
+		ENGINE *e;
+
+		ENGINE_load_builtin_engines();
+		drain_openssl_errors();
+		e = ENGINE_by_id("pkcs11");
+		ERR(!e, "Load PKCS#11 ENGINE");
+		if (ENGINE_init(e))
+			drain_openssl_errors();
+		else
+			ERR(1, "ENGINE_init");
+		if (key_pass)
+			ERR(!ENGINE_ctrl_cmd_string(e, "PIN", key_pass, 0), "Set PKCS#11 PIN");
+		private_key = ENGINE_load_private_key(e, private_key_name, NULL,
+						      NULL);
+		ERR(!private_key, "%s", private_key_name);
+	} else {
+		b = BIO_new_file(private_key_name, "rb");
+		ERR(!b, "%s", private_key_name);
+		private_key = PEM_read_bio_PrivateKey(b, NULL, pem_pw_cb, NULL);
+		ERR(!private_key, "%s", private_key_name);
+		BIO_free(b);
+	}
 
 	b = BIO_new_file(x509_name, "rb");
 	ERR(!b, "%s", x509_name);

