Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:12131 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752278AbZAJAQz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Jan 2009 19:16:55 -0500
Subject: [PATCH] crda: prevent key2pub.py from generating bogus output on
	failure
To: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless@vger.kernel.org
From: Pavel Roskin <proski@gnu.org>
Date: Fri, 09 Jan 2009 19:16:50 -0500
Message-ID: <20090110001650.3681.35686.stgit@dv.roinet.com> (sfid-20090110_011658_798956_8E73BD5F)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Specify output file on the command line, so that it's not created in
case of fatal errors, such as asbence of M2Crypto.

Signed-off-by: Pavel Roskin <proski@gnu.org>
---
 Makefile         |    2 +-
 utils/key2pub.py |   57 ++++++++++++++++++++++++++++--------------------------
 2 files changed, 31 insertions(+), 28 deletions(-)

diff --git a/Makefile b/Makefile
index c871182..292dad0 100644
--- a/Makefile
+++ b/Makefile
@@ -64,7 +64,7 @@ $(REG_BIN):
 
 keys-%.c: utils/key2pub.py $(wildcard $(PUBKEY_DIR)/*.pem)
 	$(NQ) '  GEN ' $@
-	$(Q)./utils/key2pub.py --$* $(wildcard $(PUBKEY_DIR)/*.pem) > $@
+	$(Q)./utils/key2pub.py --$* $(wildcard $(PUBKEY_DIR)/*.pem) $@
 
 %.o: %.c regdb.h
 	$(NQ) '  CC  ' $@
diff --git a/utils/key2pub.py b/utils/key2pub.py
index 40c60eb..47f50e3 100755
--- a/utils/key2pub.py
+++ b/utils/key2pub.py
@@ -3,7 +3,7 @@
 import sys
 from M2Crypto import RSA
 
-def print_ssl(name, val):
+def print_ssl(output, name, val):
     while val[0] == '\0':
         val = val[1:]
     while len(val) % 4:
@@ -13,22 +13,22 @@ def print_ssl(name, val):
         vnew.append((val[0], val[1], val[2], val[3], ))
         val = val[4:]
     vnew.reverse()
-    sys.stdout.write('static BN_ULONG %s[%d] = {\n' % (name, len(vnew)))
+    output.write('static BN_ULONG %s[%d] = {\n' % (name, len(vnew)))
     idx = 0
     for v1, v2, v3, v4 in vnew:
         if not idx:
-            sys.stdout.write('\t')
-        sys.stdout.write('0x%.2x%.2x%.2x%.2x, ' % (ord(v1), ord(v2), ord(v3), ord(v4)))
+            output.write('\t')
+        output.write('0x%.2x%.2x%.2x%.2x, ' % (ord(v1), ord(v2), ord(v3), ord(v4)))
         idx += 1
         if idx == 4:
             idx = 0
-            sys.stdout.write('\n')
+            output.write('\n')
     if idx:
-        sys.stdout.write('\n')
-    sys.stdout.write('};\n\n')
+        output.write('\n')
+    output.write('};\n\n')
 
-def print_ssl_keys(n):
-    sys.stdout.write(r'''
+def print_ssl_keys(output, n):
+    output.write(r'''
 struct pubkey {
 	struct bignum_st e, n;
 };
@@ -43,29 +43,29 @@ struct pubkey {
 static struct pubkey keys[] = {
 ''')
     for n in xrange(n + 1):
-        sys.stdout.write('	KEYS(e_%d, n_%d),\n' % (n, n))
-    sys.stdout.write('};\n')
+        output.write('	KEYS(e_%d, n_%d),\n' % (n, n))
+    output.write('};\n')
     pass
 
-def print_gcrypt(name, val):
+def print_gcrypt(output, name, val):
     while val[0] == '\0':
         val = val[1:]
-    sys.stdout.write('static const __u8 %s[%d] = {\n' % (name, len(val)))
+    output.write('static const __u8 %s[%d] = {\n' % (name, len(val)))
     idx = 0
     for v in val:
         if not idx:
-            sys.stdout.write('\t')
-        sys.stdout.write('0x%.2x, ' % ord(v))
+            output.write('\t')
+        output.write('0x%.2x, ' % ord(v))
         idx += 1
         if idx == 8:
             idx = 0
-            sys.stdout.write('\n')
+            output.write('\n')
     if idx:
-        sys.stdout.write('\n')
-    sys.stdout.write('};\n\n')
+        output.write('\n')
+    output.write('};\n\n')
 
-def print_gcrypt_keys(n):
-    sys.stdout.write(r'''
+def print_gcrypt_keys(output, n):
+    output.write(r'''
 struct key_params {
 	const __u8 *e, *n;
 	__u32 len_e, len_n; 
@@ -79,8 +79,8 @@ struct key_params {
 static const struct key_params keys[] = {
 ''')
     for n in xrange(n + 1):
-        sys.stdout.write('	KEYS(e_%d, n_%d),\n' % (n, n))
-    sys.stdout.write('};\n')
+        output.write('	KEYS(e_%d, n_%d),\n' % (n, n))
+    output.write('};\n')
     
 
 modes = {
@@ -90,14 +90,17 @@ modes = {
 
 try:
     mode = sys.argv[1]
-    files = sys.argv[2:]
+    files = sys.argv[2:-1]
+    outfile = sys.argv[-1]
 except IndexError:
     mode = None
 
 if not mode in modes:
-    print 'Usage: %s [%s] files' % (sys.argv[0], '|'.join(modes.keys()))
+    print 'Usage: %s [%s] input-file... output-file' % (sys.argv[0], '|'.join(modes.keys()))
     sys.exit(2)
 
+output = open(outfile, 'w')
+
 # load key
 idx = 0
 for f in files:
@@ -106,8 +109,8 @@ for f in files:
     except RSA.RSAError:
         key = RSA.load_key(f)
 
-    modes[mode][0]('e_%d' % idx, key.e[4:])
-    modes[mode][0]('n_%d' % idx, key.n[4:])
+    modes[mode][0](output, 'e_%d' % idx, key.e[4:])
+    modes[mode][0](output, 'n_%d' % idx, key.n[4:])
     idx += 1
 
-modes[mode][1](idx - 1)
+modes[mode][1](output, idx - 1)
