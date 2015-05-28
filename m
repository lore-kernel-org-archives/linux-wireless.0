Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54001 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754433AbbE1Prq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 May 2015 11:47:46 -0400
Subject: [PATCH 10/20] modsign: Allow password to be specified for signing
 key [ver #5]
From: David Howells <dhowells@redhat.com>
To: mcgrof@gmail.com
Cc: mjg59@srcf.ucam.org, keyrings@linux-nfs.org,
	gregkh@linuxfoundation.org, kyle@kernel.org,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	seth.forshee@canonical.com, linux-security-module@vger.kernel.org,
	zohar@linux.vnet.ibm.com, dwmw2@infradead.org
Date: Thu, 28 May 2015 16:47:39 +0100
Message-ID: <20150528154738.1259.9772.stgit@warthog.procyon.org.uk> (sfid-20150528_175155_571265_F8A42A90)
In-Reply-To: <20150528154605.1259.42518.stgit@warthog.procyon.org.uk>
References: <20150528154605.1259.42518.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: David Woodhouse <David.Woodhouse@intel.com>

We don't want this in the Kconfig since it might then get exposed in
/proc/config.gz. So make it a parameter to Kbuild instead. This also
means we don't have to jump through hoops to strip quotes from it, as
we would if it was a config option.

Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Reviewed-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
---

 Documentation/kbuild/kbuild.txt  |    5 +++++
 Documentation/module-signing.txt |    3 +++
 scripts/sign-file.c              |   27 ++++++++++++++++++++++++++-
 3 files changed, 34 insertions(+), 1 deletion(-)

diff --git a/Documentation/kbuild/kbuild.txt b/Documentation/kbuild/kbuild.txt
index 6466704d47b5..0ff6a466a05b 100644
--- a/Documentation/kbuild/kbuild.txt
+++ b/Documentation/kbuild/kbuild.txt
@@ -174,6 +174,11 @@ The output directory is often set using "O=..." on the commandline.
 
 The value can be overridden in which case the default value is ignored.
 
+KBUILD_SIGN_PIN
+--------------------------------------------------
+This variable allows a passphrase or PIN to be passed to the sign-file
+utility when signing kernel modules, if the private key requires such.
+
 KBUILD_MODPOST_WARN
 --------------------------------------------------
 KBUILD_MODPOST_WARN can be set to avoid errors in case of undefined
diff --git a/Documentation/module-signing.txt b/Documentation/module-signing.txt
index c72702ec1ded..faaa6ea002f7 100644
--- a/Documentation/module-signing.txt
+++ b/Documentation/module-signing.txt
@@ -194,6 +194,9 @@ The hash algorithm used does not have to match the one configured, but if it
 doesn't, you should make sure that hash algorithm is either built into the
 kernel or can be loaded without requiring itself.
 
+If the private key requires a passphrase or PIN, it can be provided in the
+$KBUILD_SIGN_PIN environment variable.
+
 
 ============================
 SIGNED MODULES AND STRIPPING
diff --git a/scripts/sign-file.c b/scripts/sign-file.c
index 39aaabe89388..720b9bc933ae 100755
--- a/scripts/sign-file.c
+++ b/scripts/sign-file.c
@@ -80,6 +80,27 @@ static void drain_openssl_errors(void)
 		}					\
 	} while(0)
 
+static const char *key_pass;
+
+static int pem_pw_cb(char *buf, int len, int w, void *v)
+{
+	int pwlen;
+
+	if (!key_pass)
+		return -1;
+
+	pwlen = strlen(key_pass);
+	if (pwlen >= len)
+		return -1;
+
+	strcpy(buf, key_pass);
+
+	/* If it's wrong, don't keep trying it. */
+	key_pass = NULL;
+
+	return pwlen;
+}
+
 int main(int argc, char **argv)
 {
 	struct module_signature sig_info = { .id_type = PKEY_ID_PKCS7 };
@@ -96,9 +117,12 @@ int main(int argc, char **argv)
 	BIO *b, *bd = NULL, *bm;
 	int opt, n;
 
+	OpenSSL_add_all_algorithms();
 	ERR_load_crypto_strings();
 	ERR_clear_error();
 
+	key_pass = getenv("KBUILD_SIGN_PIN");
+
 	do {
 		opt = getopt(argc, argv, "dp");
 		switch (opt) {
@@ -132,7 +156,8 @@ int main(int argc, char **argv)
 	 */
 	b = BIO_new_file(private_key_name, "rb");
 	ERR(!b, "%s", private_key_name);
-        private_key = PEM_read_bio_PrivateKey(b, NULL, NULL, NULL);
+	private_key = PEM_read_bio_PrivateKey(b, NULL, pem_pw_cb, NULL);
+	ERR(!private_key, "%s", private_key_name);
 	BIO_free(b);
 
 	b = BIO_new_file(x509_name, "rb");

