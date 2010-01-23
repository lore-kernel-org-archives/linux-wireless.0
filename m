Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.156]:8245 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751671Ab0AWLy6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Jan 2010 06:54:58 -0500
Received: by fg-out-1718.google.com with SMTP id l26so395471fgb.1
        for <linux-wireless@vger.kernel.org>; Sat, 23 Jan 2010 03:54:57 -0800 (PST)
From: Paul Fertser <fercerpav@gmail.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linux-wireless@vger.kernel.org, 536502@bugs.debian.org,
	Paul Fertser <fercerpav@gmail.com>
Subject: [PATCH] Implement runtime loading of RSA public keys
Date: Sat, 23 Jan 2010 14:54:14 +0300
Message-Id: <1264247654-21554-1-git-send-email-fercerpav@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch allows crda to load and use additional keys from a
pre-configured location for the database signature verification. This
provides a convenient way for distro maintainers and card manufacturers to
supply a custom regulatory database along with their public keys, without
the need to recompile crda.

Implemented for USE_OPENSSL=1 case only because libgcrypt lacks PEM parser.

Default location for public keys in PEM format is
/etc/wireless-regdb/pubkeys and can be changed by specifying
RUNTIME_PUBKEY_DIR at the make command line.

Signed-off-by: Paul Fertser <fercerpav@gmail.com>
---
 Makefile |    3 ++-
 reglib.c |   20 ++++++++++++++++++++
 2 files changed, 22 insertions(+), 1 deletions(-)

diff --git a/Makefile b/Makefile
index 3cc61c2..b8bc7d3 100644
--- a/Makefile
+++ b/Makefile
@@ -21,6 +21,7 @@ UDEV_RULE_DIR?=/lib/udev/rules.d/
 # keys are put when building. For example you can run
 # with make PUBKEY_DIR=/usr/lib/crda/pubkeys
 PUBKEY_DIR?=pubkeys
+RUNTIME_PUBKEY_DIR?=/etc/wireless-regdb/pubkeys
 
 CFLAGS += -Wall -g
 
@@ -29,7 +30,7 @@ all: all_noverify verify
 all_noverify: crda intersect regdbdump
 
 ifeq ($(USE_OPENSSL),1)
-CFLAGS += -DUSE_OPENSSL `pkg-config --cflags openssl`
+CFLAGS += -DUSE_OPENSSL -DPUBKEY_DIR=\"$(RUNTIME_PUBKEY_DIR)\" `pkg-config --cflags openssl`
 LDLIBS += `pkg-config --libs openssl`
 
 reglib.o: keys-ssl.c
diff --git a/reglib.c b/reglib.c
index 6aeadcb..d199e13 100644
--- a/reglib.c
+++ b/reglib.c
@@ -1,12 +1,15 @@
 #include <errno.h>
 #include <stdio.h>
 #include <arpa/inet.h>
+#include <sys/types.h>
+#include <dirent.h>
 #include "reglib.h"
 
 #ifdef USE_OPENSSL
 #include <openssl/objects.h>
 #include <openssl/rsa.h>
 #include <openssl/sha.h>
+#include <openssl/pem.h>
 #endif
 
 #ifdef USE_GCRYPT
@@ -48,6 +51,9 @@ int crda_verify_db_signature(__u8 *db, int dblen, int siglen)
 	__u8 hash[SHA_DIGEST_LENGTH];
 	unsigned int i;
 	int ok = 0;
+	DIR *pubkey_dir;
+	struct dirent *nextfile;
+	FILE *keyfile;
 
 	if (SHA1(db, dblen, hash) != hash) {
 		fprintf(stderr, "Failed to calculate SHA1 sum.\n");
@@ -71,6 +77,20 @@ int crda_verify_db_signature(__u8 *db, int dblen, int siglen)
 		rsa->n = NULL;
 		RSA_free(rsa);
 	}
+	if (!ok && (pubkey_dir = opendir(PUBKEY_DIR))) {
+		while (!ok && (nextfile = readdir(pubkey_dir))) {
+			if ((keyfile = fopen(nextfile->d_name, "rb"))) {
+				rsa = PEM_read_RSA_PUBKEY(keyfile,
+					NULL, NULL, NULL);
+				if (rsa) 
+					ok = RSA_verify(NID_sha1, hash, SHA_DIGEST_LENGTH,
+						db + dblen, siglen, rsa) == 1;
+				RSA_free(rsa);
+				fclose(keyfile);
+			}
+		}
+		closedir(pubkey_dir);
+	}
 #endif
 
 #ifdef USE_GCRYPT
-- 
1.6.4.4

