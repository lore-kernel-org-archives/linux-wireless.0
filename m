Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f41.google.com ([209.85.218.41]:36225 "EHLO
	mail-oi0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753275AbbGVFVh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jul 2015 01:21:37 -0400
Received: by oibn4 with SMTP id n4so137215345oib.3
        for <linux-wireless@vger.kernel.org>; Tue, 21 Jul 2015 22:21:36 -0700 (PDT)
From: ahmed.taahir@gmail.com
To: linux-wireless@vger.kernel.org
Cc: Taahir Ahmed <ahmed.taahir@gmail.com>
Subject: [PATCH 1/2] Support python 3 in utils/key2pub.py.
Date: Wed, 22 Jul 2015 00:21:23 -0500
Message-Id: <1437542484-23409-2-git-send-email-ahmed.taahir@gmail.com> (sfid-20150722_072142_438085_5E3B829E)
In-Reply-To: <1437542484-23409-1-git-send-email-ahmed.taahir@gmail.com>
References: <1437542484-23409-1-git-send-email-ahmed.taahir@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Taahir Ahmed <ahmed.taahir@gmail.com>

utils/key2pub.py can now be run under either python 2.7 or python 3.x.
This required some minor syntactical changes as well as switching from
M2Crypto to pycrypto, since M2Crypto doesn't support python 3.x.

The generate source files have been renamed to keys-*.h, to prevent a
pattern rule from attempting to build the generated file.

In addition, some errors in the generated source file keys-ssl.h are
fixed:

  * The correct OpenSSL header for BN_ULONG is included.

  * The generated constants are given the 'ull' suffix to prevent
    warnings about constants that are too large.
---
 Makefile         |  14 ++--
 reglib.c         |   4 +-
 utils/key2pub.py | 195 +++++++++++++++++++++++++++----------------------------
 3 files changed, 106 insertions(+), 107 deletions(-)
 mode change 100755 => 100644 utils/key2pub.py

diff --git a/Makefile b/Makefile
index a3ead30..4ce900c 100644
--- a/Makefile
+++ b/Makefile
@@ -25,6 +25,10 @@ UDEV_RULE_DIR?=/lib/udev/rules.d/
 PUBKEY_DIR?=pubkeys
 RUNTIME_PUBKEY_DIR?=/etc/wireless-regdb/pubkeys
 
+# Handle for the user to change the python interpreter that runs
+# utils/key2pub.py.  Python 2.7 and 3.x are supported.
+BUILDTIME_PYTHON ?= python
+
 CFLAGS += -O2 -fpic
 CFLAGS += -std=gnu99 -Wall -Werror -pedantic
 CFLAGS += -Wall -g
@@ -42,13 +46,13 @@ ifeq ($(USE_OPENSSL),1)
 CFLAGS += -DUSE_OPENSSL -DPUBKEY_DIR=\"$(RUNTIME_PUBKEY_DIR)\" `pkg-config --cflags openssl`
 LDLIBS += `pkg-config --libs openssl`
 
-$(LIBREG): keys-ssl.c
+$(LIBREG): keys-ssl.h
 
 else
 CFLAGS += -DUSE_GCRYPT
 LDLIBS += -lgcrypt
 
-$(LIBREG): keys-gcrypt.c
+$(LIBREG): keys-gcrypt.h
 
 endif
 MKDIR ?= mkdir -p
@@ -109,10 +113,10 @@ $(REG_BIN):
 	$(NQ)
 	$(Q) exit 1
 
-keys-%.c: utils/key2pub.py $(wildcard $(PUBKEY_DIR)/*.pem)
+keys-%.h: utils/key2pub.py $(wildcard $(PUBKEY_DIR)/*.pem)
 	$(NQ) '  GEN ' $@
 	$(NQ) '  Trusted pubkeys:' $(wildcard $(PUBKEY_DIR)/*.pem)
-	$(Q)./utils/key2pub.py --$* $(wildcard $(PUBKEY_DIR)/*.pem) $@
+	$(Q) $(BUILDTIME_PYTHON) utils/key2pub.py --$* $(wildcard $(PUBKEY_DIR)/*.pem) $@
 
 $(LIBREG): regdb.h reglib.h reglib.c
 	$(NQ) '  CC  ' $@
@@ -187,5 +191,5 @@ install: install-libreg install-libreg-headers crda crda.8.gz regdbdump.8.gz
 
 clean:
 	$(Q)rm -f $(LIBREG) crda regdbdump intersect db2rd optimize \
-		*.o *~ *.pyc keys-*.c *.gz \
+		*.o *~ *.pyc keys-*.h *.gz \
 	udev/$(UDEV_LEVEL)regulatory.rules udev/regulatory.rules.parsed
diff --git a/reglib.c b/reglib.c
index e00e9b8..aecff96 100644
--- a/reglib.c
+++ b/reglib.c
@@ -31,11 +31,11 @@
 #include "reglib.h"
 
 #ifdef USE_OPENSSL
-#include "keys-ssl.c"
+#include "keys-ssl.h"
 #endif
 
 #ifdef USE_GCRYPT
-#include "keys-gcrypt.c"
+#include "keys-gcrypt.h"
 #endif
 
 int debug = 0;
diff --git a/utils/key2pub.py b/utils/key2pub.py
old mode 100755
new mode 100644
index 3e84cd2..d6adefe
--- a/utils/key2pub.py
+++ b/utils/key2pub.py
@@ -1,126 +1,118 @@
 #!/usr/bin/env python
 
+import io
 import sys
 try:
-       from M2Crypto import RSA
-except ImportError, e:
-       sys.stderr.write('ERROR: Failed to import the "M2Crypto" module: %s\n' % e.message)
-       sys.stderr.write('Please install the "M2Crypto" Python module.\n')
-       sys.stderr.write('On Debian GNU/Linux the package is called "python-m2crypto".\n')
-       sys.exit(1)
-
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
+    from Crypto.PublicKey import RSA
+except ImportError as e:
+    sys.stderr.write('ERROR: Failed to import the "Crypto.PublicKey" module: %s\n' % e.message)
+    sys.stderr.write('Please install the "Crypto.PublicKey" Python module.\n')
+    sys.stderr.write('On Debian GNU/Linux the package is called "python-crypto".\n')
+    sys.exit(1)
+
+def bitwise_collect(value, radix_bits):
+    words = []
+    radix_mask = (1 << radix_bits) - 1
+    while value != 0:
+        words.append(value & radix_mask)
+        value >>= radix_bits
+    return words
+
+def print_c_table(words, bits_per_word):
+    # 4 bits per hex char.
+    chars_per_word = bits_per_word // 4
+
+    # If the word size is not a multiple of four (surely impossible) round up.
+    if bits_per_word % 4:
+        chars_per_word += 1
+
+    # 2 chars for the 0x, 2 chars for the 'ul'
+    chars_per_literal = chars_per_word + 4
+
+    # 2 chars for the trailing ', '
+    chars_per_field = chars_per_literal + 2
+
+    # How many fields fit on an 80 char line (with leading tab).
+    fields_per_line = (80 - 8) // chars_per_field
+
+    for i in range(len(words)):
+
+        if i % fields_per_line == 0:
+            if i != 0:
+                output.write(u', ')
+            output.write(u'\n\t')
+        else:
+            output.write(u', ')
+
+        output.write(u'0x{0:0{1}x}ul'.format(words[i], chars_per_word))
+
+    output.write(u'\n')
 
 def print_ssl(output, name, val):
+    output.write(u'#include <stdint.h>\n')
+    output.write(u'#include <openssl/bn.h>\n')
+
     import struct
-    output.write('#include <stdint.h>\n')
     if len(struct.pack('@L', 0)) == 8:
-        return print_ssl_64(output, name, val)
+        bits_per_word = 64
     else:
-        return print_ssl_32(output, name, val)
+        bits_per_word = 32
+
+    # OpenSSL expects 'wordbit'-bit words given least-significant-word first.
+    vwords = bitwise_collect(val, bits_per_word)
+
+    output.write(u'static BN_ULONG {}[] = {{'.format(name))
+    print_c_table(vwords, bits_per_word)
+    output.write(u'};\n\n')
 
 def print_ssl_keys(output, n):
-    output.write(r'''
+    output.write(u'''
 struct pubkey {
-	struct bignum_st e, n;
+        struct bignum_st e, n;
 };
 
-#define KEY(data) {				\
-	.d = data,				\
-	.top = sizeof(data)/sizeof(data[0]),	\
+#define KEY(data) {                          \\
+        .d = data,                           \\
+        .top = sizeof(data)/sizeof(data[0]), \\
 }
 
-#define KEYS(e,n)	{ KEY(e), KEY(n), }
+#define KEYS(e,n)    { KEY(e), KEY(n), }
 
 static struct pubkey keys[] = {
 ''')
-    for n in xrange(n + 1):
-        output.write('	KEYS(e_%d, n_%d),\n' % (n, n))
-    output.write('};\n')
+    for n in range(n + 1):
+        output.write(u'	KEYS(e_{0}, n_{0}),\n'.format(n))
+    output.write(u'};\n')
     pass
 
 def print_gcrypt(output, name, val):
-    output.write('#include <stdint.h>\n')
-    while val[0] == '\0':
-        val = val[1:]
-    output.write('static const uint8_t %s[%d] = {\n' % (name, len(val)))
-    idx = 0
-    for v in val:
-        if not idx:
-            output.write('\t')
-        output.write('0x%.2x, ' % ord(v))
-        idx += 1
-        if idx == 8:
-            idx = 0
-            output.write('\n')
-    if idx:
-        output.write('\n')
-    output.write('};\n\n')
+    # gcrypt expects 8-bit words most-significant-word first
+    vwords = bitwise_collect(val, 8)
+    vwords.reverse()
+
+    output.write(u'#include <stdint.h>\n')
+    output.write(u'static const uint8_t {}[] = {{'.format(name))
+    print_c_table(vwords, 8)
+    output.write(u'};\n\n')
 
 def print_gcrypt_keys(output, n):
-    output.write(r'''
+    output.write(u'''
 struct key_params {
-	const uint8_t *e, *n;
-	uint32_t len_e, len_n;
+        const uint8_t *e, *n;
+        uint32_t len_e, len_n;
 };
 
-#define KEYS(_e, _n) {			\
-	.e = _e, .len_e = sizeof(_e),	\
-	.n = _n, .len_n = sizeof(_n),	\
+#define KEYS(_e, _n) {                \\
+        .e = _e, .len_e = sizeof(_e), \\
+        .n = _n, .len_n = sizeof(_n), \\
 }
 
 static const struct key_params keys[] = {
 ''')
-    for n in xrange(n + 1):
-        output.write('	KEYS(e_%d, n_%d),\n' % (n, n))
-    output.write('};\n')
-    
+    for n in range(n + 1):
+        output.write(u'	KEYS(e_{0}, n_{0}),\n'.format(n))
+    output.write(u'};\n')
+
 
 modes = {
     '--ssl': (print_ssl, print_ssl_keys),
@@ -135,21 +127,24 @@ except IndexError:
     mode = None
 
 if not mode in modes:
-    print 'Usage: %s [%s] input-file... output-file' % (sys.argv[0], '|'.join(modes.keys()))
+    print('Usage: {} [{}] input-file... output-file'.format(sys.argv[0], '|'.join(modes.keys())))
     sys.exit(2)
 
-output = open(outfile, 'w')
+output = io.open(outfile, 'w')
+output.write(u'/* This file was generated by utils/key2pub.py. */\n\n')
 
 # load key
 idx = 0
 for f in files:
-    try:
-        key = RSA.load_pub_key(f)
-    except RSA.RSAError:
-        key = RSA.load_key(f)
 
-    modes[mode][0](output, 'e_%d' % idx, key.e[4:])
-    modes[mode][0](output, 'n_%d' % idx, key.n[4:])
+    key_contents = io.open(f, 'rb').read()
+    key = RSA.importKey(key_contents)
+
+    modes[mode][0](output, 'e_{}'.format(idx), key.e)
+    modes[mode][0](output, 'n_{}'.format(idx), key.n)
+
     idx += 1
 
 modes[mode][1](output, idx - 1)
+
+output.write(u'\n/* End output of utils/key2pub.py. */\n')
-- 
2.3.6

