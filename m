Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50191 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932182AbbE1PsN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 May 2015 11:48:13 -0400
Subject: [PATCH 13/20] modsign: Extract signing cert from
 CONFIG_MODULE_SIG_KEY if needed [ver #5]
From: David Howells <dhowells@redhat.com>
To: mcgrof@gmail.com
Cc: mjg59@srcf.ucam.org, keyrings@linux-nfs.org,
	gregkh@linuxfoundation.org, kyle@kernel.org,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	seth.forshee@canonical.com, linux-security-module@vger.kernel.org,
	zohar@linux.vnet.ibm.com, dwmw2@infradead.org
Date: Thu, 28 May 2015 16:48:05 +0100
Message-ID: <20150528154805.1259.24786.stgit@warthog.procyon.org.uk> (sfid-20150528_175104_759106_C91ED0F5)
In-Reply-To: <20150528154605.1259.42518.stgit@warthog.procyon.org.uk>
References: <20150528154605.1259.42518.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: David Woodhouse <David.Woodhouse@intel.com>

Where an external PEM file or PKCS#11 URI is given, we can get the cert
from it for ourselves instead of making the user drop signing_key.x509
in place for us.

Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 Documentation/module-signing.txt |   11 +--
 init/Kconfig                     |    8 +-
 kernel/Makefile                  |   38 +++++++++++
 scripts/Makefile                 |    3 +
 scripts/extract-cert.c           |  132 ++++++++++++++++++++++++++++++++++++++
 5 files changed, 181 insertions(+), 11 deletions(-)
 create mode 100644 scripts/extract-cert.c

diff --git a/Documentation/module-signing.txt b/Documentation/module-signing.txt
index 84597c7ea175..693001920890 100644
--- a/Documentation/module-signing.txt
+++ b/Documentation/module-signing.txt
@@ -93,17 +93,16 @@ This has a number of options available:
      Setting this option to something other than its default of
      "signing_key.priv" will disable the autogeneration of signing keys and
      allow the kernel modules to be signed with a key of your choosing.
-     The string provided should identify a file containing a private key
-     in PEM form, or — on systems where the OpenSSL ENGINE_pkcs11 is
-     appropriately installed — a PKCS#11 URI as defined by RFC7512.
+     The string provided should identify a file containing both a private
+     key and its corresponding X.509 certificate in PEM form, or — on
+     systems where the OpenSSL ENGINE_pkcs11 is functional — a PKCS#11 URI
+     as defined by RFC7512. In the latter case, the PKCS#11 URI should
+     reference both a certificate and a private key.
 
      If the PEM file containing the private key is encrypted, or if the
      PKCS#11 token requries a PIN, this can be provided at build time by
      means of the KBUILD_SIGN_PIN variable.
 
-     The corresponding X.509 certificate in DER form should still be placed
-     in a file named signing_key.x509 in the top-level build directory.
-
 
 =======================
 GENERATING SIGNING KEYS
diff --git a/init/Kconfig b/init/Kconfig
index 385181546f6a..a4b4f390d8f2 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1959,10 +1959,10 @@ config MODULE_SIG_KEY
 	default "signing_key.priv"
 	depends on MODULE_SIG
 	help
-         Provide the file name of a private key in PKCS#8 PEM format, or
-         a PKCS#11 URI according to RFC7512. The corresponding X.509
-         certificate in DER form should be present in signing_key.x509
-         in the top-level build directory.
+         Provide the file name of a private key/certificate in PEM format,
+         or a PKCS#11 URI according to RFC7512. The file should contain, or
+         the URI should identify, both the certificate and its corresponding
+         private key.
 
          If this option is unchanged from its default "signing_key.priv",
          then the kernel will automatically generate the private key and
diff --git a/kernel/Makefile b/kernel/Makefile
index 050a55eca566..9fb259d0383c 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -210,5 +210,43 @@ x509.genkey:
 	@echo >>x509.genkey "keyUsage=digitalSignature"
 	@echo >>x509.genkey "subjectKeyIdentifier=hash"
 	@echo >>x509.genkey "authorityKeyIdentifier=keyid"
+else
+# For external (PKCS#11 or PEM) key, we need to obtain the certificate from
+# CONFIG_MODULE_SIG_KEY automatically.
+quiet_cmd_extract_der = CERT_DER $(2)
+      cmd_extract_der = scripts/extract-cert "$(2)" signing_key.x509
+
+# CONFIG_MODULE_SIG_KEY is either a PKCS#11 URI or a filename. It is
+# surrounded by quotes, and may contain spaces. To strip the quotes
+# with $(patsubst) we need to turn the spaces into something else.
+# And if it's a filename, those spaces need to be escaped as '\ ' in
+# order to use it in dependencies or $(wildcard).
+space :=
+space +=
+space_escape := %%%SPACE%%%
+X509_SOURCE_temp := $(subst $(space),$(space_escape),$(CONFIG_MODULE_SIG_KEY))
+# We need this to check for absolute paths or PKCS#11 URIs.
+X509_SOURCE_ONEWORD := $(patsubst "%",%,$(X509_SOURCE_temp))
+# This is the actual source filename/URI without the quotes
+X509_SOURCE := $(subst $(space_escape),$(space),$(X509_SOURCE_ONEWORD))
+# This\ version\ with\ spaces\ escaped\ for\ $(wildcard)\ and\ dependencies
+X509_SOURCE_ESCAPED := $(subst $(space_escape),\$(space),$(X509_SOURCE_ONEWORD))
+
+ifeq ($(patsubst pkcs11:%,%,$(X509_SOURCE_ONEWORD)),$(X509_SOURCE_ONEWORD))
+# If it's a filename, depend on it.
+X509_DEP := $(X509_SOURCE_ESCAPED)
+ifeq ($(patsubst /%,%,$(X509_SOURCE_ONEWORD)),$(X509_SOURCE_ONEWORD))
+ifeq ($(wildcard $(X509_SOURCE_ESCAPED)),)
+ifneq ($(wildcard $(srctree)/$(X509_SOURCE_ESCAPED)),)
+# Non-absolute filename, found in source tree and not build tree
+X509_SOURCE := $(srctree)/$(X509_SOURCE)
+X509_DEP := $(srctree)/$(X509_SOURCE_ESCAPED)
+endif
+endif
+endif
+endif
+
+signing_key.x509: scripts/extract-cert include/config/module/sig/key.h $(X509_DEP)
+	$(call cmd,extract_der,$(X509_SOURCE))
 endif
 endif
diff --git a/scripts/Makefile b/scripts/Makefile
index b12fe020664d..236f683510bd 100644
--- a/scripts/Makefile
+++ b/scripts/Makefile
@@ -16,11 +16,12 @@ hostprogs-$(CONFIG_VT)           += conmakehash
 hostprogs-$(BUILD_C_RECORDMCOUNT) += recordmcount
 hostprogs-$(CONFIG_BUILDTIME_EXTABLE_SORT) += sortextable
 hostprogs-$(CONFIG_ASN1)	 += asn1_compiler
-hostprogs-$(CONFIG_MODULE_SIG)	 += sign-file
+hostprogs-$(CONFIG_MODULE_SIG)	 += sign-file extract-cert
 
 HOSTCFLAGS_sortextable.o = -I$(srctree)/tools/include
 HOSTCFLAGS_asn1_compiler.o = -I$(srctree)/include
 HOSTLOADLIBES_sign-file = -lcrypto
+HOSTLOADLIBES_extract-cert = -lcrypto
 
 always		:= $(hostprogs-y) $(hostprogs-m)
 
diff --git a/scripts/extract-cert.c b/scripts/extract-cert.c
new file mode 100644
index 000000000000..4fd5b2f07b45
--- /dev/null
+++ b/scripts/extract-cert.c
@@ -0,0 +1,132 @@
+/* Extract X.509 certificate in DER form from PKCS#11 or PEM.
+ *
+ * Copyright © 2014 Red Hat, Inc. All Rights Reserved.
+ * Copyright © 2015 Intel Corporation.
+ *
+ * Authors: David Howells <dhowells@redhat.com>
+ *          David Woodhouse <dwmw2@infradead.org>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+#define _GNU_SOURCE
+#include <stdio.h>
+#include <stdlib.h>
+#include <stdint.h>
+#include <stdbool.h>
+#include <string.h>
+#include <getopt.h>
+#include <err.h>
+#include <arpa/inet.h>
+#include <openssl/bio.h>
+#include <openssl/evp.h>
+#include <openssl/pem.h>
+#include <openssl/pkcs7.h>
+#include <openssl/err.h>
+#include <openssl/engine.h>
+
+#define PKEY_ID_PKCS7 2
+
+static __attribute__((noreturn))
+void format(void)
+{
+	fprintf(stderr,
+		"Usage: scripts/extract-cert <source> <dest>\n");
+	exit(2);
+}
+
+static void display_openssl_errors(int l)
+{
+	const char *file;
+	char buf[120];
+	int e, line;
+
+	if (ERR_peek_error() == 0)
+		return;
+	fprintf(stderr, "At main.c:%d:\n", l);
+
+	while ((e = ERR_get_error_line(&file, &line))) {
+		ERR_error_string(e, buf);
+		fprintf(stderr, "- SSL %s: %s:%d\n", buf, file, line);
+	}
+}
+
+static void drain_openssl_errors(void)
+{
+	const char *file;
+	int line;
+
+	if (ERR_peek_error() == 0)
+		return;
+	while (ERR_get_error_line(&file, &line)) {}
+}
+
+#define ERR(cond, fmt, ...)				\
+	do {						\
+		bool __cond = (cond);			\
+		display_openssl_errors(__LINE__);	\
+		if (__cond) {				\
+			err(1, fmt, ## __VA_ARGS__);	\
+		}					\
+	} while(0)
+
+static const char *key_pass;
+
+int main(int argc, char **argv)
+{
+	char *cert_src, *cert_dst;
+	X509 *x509;
+	BIO *b;
+
+	OpenSSL_add_all_algorithms();
+	ERR_load_crypto_strings();
+	ERR_clear_error();
+
+        key_pass = getenv("KBUILD_SIGN_PIN");
+
+	if (argc != 3)
+		format();
+
+	cert_src = argv[1];
+	cert_dst = argv[2];
+
+	if (!strncmp(cert_src, "pkcs11:", 7)) {
+		ENGINE *e;
+		struct {
+			const char *cert_id;
+			X509 *cert;
+		} parms;
+
+		parms.cert_id = cert_src;
+		parms.cert = NULL;
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
+		ENGINE_ctrl_cmd(e, "LOAD_CERT_CTRL", 0, &parms, NULL, 1);
+		ERR(!parms.cert, "Get X.509 from PKCS#11");
+		x509 = parms.cert;
+	} else {
+		b = BIO_new_file(cert_src, "rb");
+		ERR(!b, "%s", cert_src);
+		x509 = PEM_read_bio_X509(b, NULL, NULL, NULL);
+		ERR(!x509, "%s", cert_src);
+		BIO_free(b);
+	}
+
+	b = BIO_new_file(cert_dst, "wb");
+	ERR(!b, "%s", cert_dst);
+	ERR(!i2d_X509_bio(b, x509), cert_dst);
+	BIO_free(b);
+
+	return 0;
+}

