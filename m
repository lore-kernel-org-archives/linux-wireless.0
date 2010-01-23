Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f221.google.com ([209.85.220.221]:45387 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750932Ab0AWMal (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Jan 2010 07:30:41 -0500
Received: by fxm21 with SMTP id 21so236871fxm.29
        for <linux-wireless@vger.kernel.org>; Sat, 23 Jan 2010 04:30:40 -0800 (PST)
Date: Sat, 23 Jan 2010 15:30:21 +0300
From: Paul Fertser <fercerpav@gmail.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linux-wireless@vger.kernel.org, 536502@bugs.debian.org
Subject: Re: [PATCH] Implement runtime loading of RSA public keys
Message-ID: <20100123123021.GA4261@home.pavel.comp>
References: <1264247654-21554-1-git-send-email-fercerpav@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="C7zPtVaVf+AK4Oqc"
In-Reply-To: <1264247654-21554-1-git-send-email-fercerpav@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--C7zPtVaVf+AK4Oqc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Jan 23, 2010 at 02:54:14PM +0300, Paul Fertser wrote:
> +	if (!ok && (pubkey_dir = opendir(PUBKEY_DIR))) {
> +		while (!ok && (nextfile = readdir(pubkey_dir))) {
> +			if ((keyfile = fopen(nextfile->d_name, "rb"))) {

Duh, of course it's wrong but i managed to have that key in the
current directory during testing :(

Amended version attached.

-- 
Be free, use free (http://www.gnu.org/philosophy/free-sw.html) software!
mailto:fercerpav@gmail.com

--C7zPtVaVf+AK4Oqc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="0001-Implement-runtime-loading-of-RSA-public-keys.patch"

>From 3ad6149a22346c2f34224227a580c1424eed6b57 Mon Sep 17 00:00:00 2001
From: Paul Fertser <fercerpav@gmail.com>
Date: Sat, 23 Jan 2010 14:34:14 +0300
Subject: [PATCH] Implement runtime loading of RSA public keys

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
 reglib.c |   23 +++++++++++++++++++++++
 2 files changed, 25 insertions(+), 1 deletions(-)

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
index 6aeadcb..80ae062 100644
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
@@ -48,6 +51,10 @@ int crda_verify_db_signature(__u8 *db, int dblen, int siglen)
 	__u8 hash[SHA_DIGEST_LENGTH];
 	unsigned int i;
 	int ok = 0;
+	DIR *pubkey_dir;
+	struct dirent *nextfile;
+	FILE *keyfile;
+	char filename[PATH_MAX];
 
 	if (SHA1(db, dblen, hash) != hash) {
 		fprintf(stderr, "Failed to calculate SHA1 sum.\n");
@@ -71,6 +78,22 @@ int crda_verify_db_signature(__u8 *db, int dblen, int siglen)
 		rsa->n = NULL;
 		RSA_free(rsa);
 	}
+	if (!ok && (pubkey_dir = opendir(PUBKEY_DIR))) {
+		while (!ok && (nextfile = readdir(pubkey_dir))) {
+			snprintf(filename, PATH_MAX, "%s/%s", PUBKEY_DIR,
+				nextfile->d_name);
+			if ((keyfile = fopen(filename, "rb"))) {
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


--C7zPtVaVf+AK4Oqc--
