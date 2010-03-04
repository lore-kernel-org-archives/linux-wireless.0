Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from venema.h4ckr.net ([217.24.1.135]:36451 "EHLO venema.h4ckr.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752845Ab0CDOJD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Mar 2010 09:09:03 -0500
Received: from localhost (localhost [127.0.0.1])
	by venema.h4ckr.net (Postfix) with ESMTP id 2221F33E813
	for <linux-wireless@vger.kernel.org>; Thu,  4 Mar 2010 15:09:01 +0100 (CET)
Received: from venema.h4ckr.net ([127.0.0.1])
	by localhost (venema.h4ckr.net [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id V6RzmjfVSm9c for <linux-wireless@vger.kernel.org>;
	Thu,  4 Mar 2010 15:08:55 +0100 (CET)
Received: from nomad.localnet (CPE-58-174-132-139.mjcz1.woo.bigpond.net.au [58.174.132.139])
	by venema.h4ckr.net (Postfix) with ESMTP id C891133E7E1
	for <linux-wireless@vger.kernel.org>; Thu,  4 Mar 2010 15:08:54 +0100 (CET)
From: Kel Modderman <kel@otaku42.de>
To: linux-wireless@vger.kernel.org
Subject: [PATCH] crda: do not embed crypto data when USE_OPENSSL=1
Date: Fri, 5 Mar 2010 00:08:50 +1000
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201003050008.51066.kel@otaku42.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When USE_OPENSSL=1 do not embed crypto data into binary, use the PUBKEY_DIR
variable just as it is when USE_GCRYPT=1 and just load certs from PUBKEY_DIR
for signature verification at runtime. Remove ssl support from
utils/key2pub.py.

This allows wireless-regdb to be built from source and upgraded independently
of crda and is _crucial_ for distributions who want to build their own
regulatory.bin.

This change does remove support for alternate runtime pubkey dir
/etc/wireless-regdb/pubkeys, but wireless-regdb does not currently install
custom pubkeys to /etc/wireless-regdb/pubkeys, and I couldn't care less
about that feature atm :)

When verification fails provide information about the PUBKEY_DIR variable.

Fix typo (s/make noverify/make all_noverify/).

Signed-off-by: Kel Modderman <kel@otaku42.de>
---
--- a/Makefile
+++ b/Makefile
@@ -16,13 +16,6 @@ UDEV_LEVEL=$(CRDA_UDEV_LEVEL)-
 # a different location.
 UDEV_RULE_DIR?=/lib/udev/rules.d/
 
-# If your distribution requires a custom pubkeys dir
-# you must update this variable to reflect where the
-# keys are put when building. For example you can run
-# with make PUBKEY_DIR=/usr/lib/crda/pubkeys
-PUBKEY_DIR?=pubkeys
-RUNTIME_PUBKEY_DIR?=/etc/wireless-regdb/pubkeys
-
 CFLAGS += -Wall -g
 
 all: all_noverify verify
@@ -30,17 +23,22 @@ all: all_noverify verify
 all_noverify: crda intersect regdbdump
 
 ifeq ($(USE_OPENSSL),1)
-CFLAGS += -DUSE_OPENSSL -DPUBKEY_DIR=\"$(RUNTIME_PUBKEY_DIR)\" `pkg-config --cflags openssl`
+PUBKEY_DIR?=$(PREFIX)/lib/crda/pubkeys
+CFLAGS += -DUSE_OPENSSL -DPUBKEY_DIR=\"$(PUBKEY_DIR)\" `pkg-config --cflags openssl`
 LDLIBS += `pkg-config --libs openssl`
 
-reglib.o: keys-ssl.c
-
 else
+PUBKEY_DIR?=pubkeys
 CFLAGS += -DUSE_GCRYPT
 LDLIBS += -lgcrypt
 
 reglib.o: keys-gcrypt.c
 
+keys-gcrypt.c: utils/key2pub.py $(wildcard $(PUBKEY_DIR)/*.pem)
+	$(NQ) '  GEN ' $@
+	$(NQ) '  Trusted pubkeys:' $(wildcard $(PUBKEY_DIR)/*.pem)
+	$(Q)./utils/key2pub.py $(wildcard $(PUBKEY_DIR)/*.pem) $@
+
 endif
 MKDIR ?= mkdir -p
 INSTALL ?= install
@@ -82,15 +80,10 @@ $(REG_BIN):
 	$(NQ) $(REG_GIT)
 	$(NQ)
 	$(NQ) "Once cloned (no need to build) cp regulatory.bin to $(REG_BIN)"
-	$(NQ) "Use \"make noverify\" to disable verification"
+	$(NQ) "Use \"make all_noverify\" to disable verification"
 	$(NQ)
 	$(Q) exit 1
 
-keys-%.c: utils/key2pub.py $(wildcard $(PUBKEY_DIR)/*.pem)
-	$(NQ) '  GEN ' $@
-	$(NQ) '  Trusted pubkeys:' $(wildcard $(PUBKEY_DIR)/*.pem)
-	$(Q)./utils/key2pub.py --$* $(wildcard $(PUBKEY_DIR)/*.pem) $@
-
 %.o: %.c regdb.h
 	$(NQ) '  CC  ' $@
 	$(Q)$(CC) -c $(CPPFLAGS) $(CFLAGS) -o $@ $<
@@ -109,7 +102,15 @@ intersect: reglib.o intersect.o print-re
 
 verify: $(REG_BIN) regdbdump
 	$(NQ) '  CHK  $(REG_BIN)'
-	$(Q)./regdbdump $(REG_BIN) >/dev/null
+	@if ! ./regdbdump $(REG_BIN) >/dev/null; then \
+		echo; \
+		echo "If your distribution requires a custom pubkeys dir you must set"; \
+		echo "PUBKEY_DIR to path where the keys are installed by wireless-regdb."; \
+		echo "For example:"; \
+		echo "    make PUBKEY_DIR=/lib/crda/pubkeys"; \
+		echo; \
+		exit 1; \
+	fi
 
 %.gz: %
 	@$(NQ) ' GZIP' $<
--- a/reglib.c
+++ b/reglib.c
@@ -18,10 +18,6 @@
 
 #include "reglib.h"
 
-#ifdef USE_OPENSSL
-#include "keys-ssl.c"
-#endif
-
 #ifdef USE_GCRYPT
 #include "keys-gcrypt.c"
 #endif
@@ -49,7 +45,6 @@ int crda_verify_db_signature(__u8 *db, i
 #ifdef USE_OPENSSL
 	RSA *rsa;
 	__u8 hash[SHA_DIGEST_LENGTH];
-	unsigned int i;
 	int ok = 0;
 	DIR *pubkey_dir;
 	struct dirent *nextfile;
@@ -61,24 +56,7 @@ int crda_verify_db_signature(__u8 *db, i
 		goto out;
 	}
 
-	for (i = 0; (i < sizeof(keys)/sizeof(keys[0])) && (!ok); i++) {
-		rsa = RSA_new();
-		if (!rsa) {
-			fprintf(stderr, "Failed to create RSA key.\n");
-			goto out;
-		}
-
-		rsa->e = &keys[i].e;
-		rsa->n = &keys[i].n;
-
-		ok = RSA_verify(NID_sha1, hash, SHA_DIGEST_LENGTH,
-				db + dblen, siglen, rsa) == 1;
-
-		rsa->e = NULL;
-		rsa->n = NULL;
-		RSA_free(rsa);
-	}
-	if (!ok && (pubkey_dir = opendir(PUBKEY_DIR))) {
+	if ((pubkey_dir = opendir(PUBKEY_DIR))) {
 		while (!ok && (nextfile = readdir(pubkey_dir))) {
 			snprintf(filename, PATH_MAX, "%s/%s", PUBKEY_DIR,
 				nextfile->d_name);
--- a/utils/key2pub.py
+++ b/utils/key2pub.py
@@ -9,81 +9,6 @@ except ImportError, e:
        sys.stderr.write('On Debian GNU/Linux the package is called "python-m2crypto".\n')
        sys.exit(1)
 
-def print_ssl_64(output, name, val):
-    while val[0] == '\0':
-        val = val[1:]
-    while len(val) % 8:
-        val = '\0' + val
-    vnew = []
-    while len(val):
-        vnew.append((val[0], val[1], val[2], val[3], val[4], val[5], val[6], val[7]))
-        val = val[8:]
-    vnew.reverse()
-    output.write('static BN_ULONG %s[%d] = {\n' % (name, len(vnew)))
-    idx = 0
-    for v1, v2, v3, v4, v5, v6, v7, v8 in vnew:
-        if not idx:
-            output.write('\t')
-        output.write('0x%.2x%.2x%.2x%.2x%.2x%.2x%.2x%.2x, ' % (ord(v1), ord(v2), ord(v3), ord(v4), ord(v5), ord(v6), ord(v7), ord(v8)))
-        idx += 1
-        if idx == 2:
-            idx = 0
-            output.write('\n')
-    if idx:
-        output.write('\n')
-    output.write('};\n\n')
-
-def print_ssl_32(output, name, val):
-    while val[0] == '\0':
-        val = val[1:]
-    while len(val) % 4:
-        val = '\0' + val
-    vnew = []
-    while len(val):
-        vnew.append((val[0], val[1], val[2], val[3], ))
-        val = val[4:]
-    vnew.reverse()
-    output.write('static BN_ULONG %s[%d] = {\n' % (name, len(vnew)))
-    idx = 0
-    for v1, v2, v3, v4 in vnew:
-        if not idx:
-            output.write('\t')
-        output.write('0x%.2x%.2x%.2x%.2x, ' % (ord(v1), ord(v2), ord(v3), ord(v4)))
-        idx += 1
-        if idx == 4:
-            idx = 0
-            output.write('\n')
-    if idx:
-        output.write('\n')
-    output.write('};\n\n')
-
-def print_ssl(output, name, val):
-    import struct
-    if len(struct.pack('@L', 0)) == 8:
-        return print_ssl_64(output, name, val)
-    else:
-        return print_ssl_32(output, name, val)
-
-def print_ssl_keys(output, n):
-    output.write(r'''
-struct pubkey {
-	struct bignum_st e, n;
-};
-
-#define KEY(data) {				\
-	.d = data,				\
-	.top = sizeof(data)/sizeof(data[0]),	\
-}
-
-#define KEYS(e,n)	{ KEY(e), KEY(n), }
-
-static struct pubkey keys[] = {
-''')
-    for n in xrange(n + 1):
-        output.write('	KEYS(e_%d, n_%d),\n' % (n, n))
-    output.write('};\n')
-    pass
-
 def print_gcrypt(output, name, val):
     while val[0] == '\0':
         val = val[1:]
@@ -118,24 +43,10 @@ static const struct key_params keys[] =
     for n in xrange(n + 1):
         output.write('	KEYS(e_%d, n_%d),\n' % (n, n))
     output.write('};\n')
-    
-
-modes = {
-    '--ssl': (print_ssl, print_ssl_keys),
-    '--gcrypt': (print_gcrypt, print_gcrypt_keys),
-}
 
-try:
-    mode = sys.argv[1]
-    files = sys.argv[2:-1]
-    outfile = sys.argv[-1]
-except IndexError:
-    mode = None
-
-if not mode in modes:
-    print 'Usage: %s [%s] input-file... output-file' % (sys.argv[0], '|'.join(modes.keys()))
-    sys.exit(2)
 
+files = sys.argv[1:-1]
+outfile = sys.argv[-1]
 output = open(outfile, 'w')
 
 # load key
@@ -146,8 +57,8 @@ for f in files:
     except RSA.RSAError:
         key = RSA.load_key(f)
 
-    modes[mode][0](output, 'e_%d' % idx, key.e[4:])
-    modes[mode][0](output, 'n_%d' % idx, key.n[4:])
+    print_gcrypt(output, 'e_%d' % idx, key.e[4:])
+    print_gcrypt(output, 'n_%d' % idx, key.n[4:])
     idx += 1
 
-modes[mode][1](output, idx - 1)
+print_gcrypt_keys(output, idx - 1)
---
