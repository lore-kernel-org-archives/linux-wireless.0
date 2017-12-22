Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:38681 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751602AbdLVGDJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 22 Dec 2017 01:03:09 -0500
Received: from mail-it0-f70.google.com ([209.85.214.70])
        by youngberry.canonical.com with esmtps (TLS1.0:RSA_AES_128_CBC_SHA1:16)
        (Exim 4.76)
        (envelope-from <seth.forshee@canonical.com>)
        id 1eSGQG-0002dY-G7
        for linux-wireless@vger.kernel.org; Fri, 22 Dec 2017 06:03:08 +0000
Received: by mail-it0-f70.google.com with SMTP id p144so9667896itc.9
        for <linux-wireless@vger.kernel.org>; Thu, 21 Dec 2017 22:03:08 -0800 (PST)
From: Seth Forshee <seth.forshee@canonical.com>
To: linux-wireless@vger.kernel.org, wireless-regdb@lists.infradead.org
Cc: Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH 1/6] regdb: write firmware file format (version code 20)
Date: Fri, 22 Dec 2017 00:02:58 -0600
Message-Id: <20171222060303.14478-2-seth.forshee@canonical.com> (sfid-20171222_070344_111931_C7BA33F9)
In-Reply-To: <20171222060303.14478-1-seth.forshee@canonical.com>
References: <20171222060303.14478-1-seth.forshee@canonical.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

TODO: clean up the Makefile stuff ...

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
---
 Makefile |  53 ++++++++++++-------------
 README   |   4 +-
 db2fw.py | 133 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 160 insertions(+), 30 deletions(-)
 create mode 100755 db2fw.py

diff --git a/Makefile b/Makefile
index 907ff282fc92..e708982a453d 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,5 @@
 # Install prefix
 PREFIX ?= /usr
-CRDA_PATH ?= $(PREFIX)/lib/crda
-CRDA_KEY_PATH ?= $(CRDA_PATH)/pubkeys
 
 MANDIR ?= $(PREFIX)/share/man/
 
@@ -30,39 +28,47 @@ REGDB_AUTHOR ?= $(shell if [ -f $(DISTRO_PRIVKEY) ]; then \
 		fi)
 
 REGDB_PRIVKEY ?= ~/.wireless-regdb-$(REGDB_AUTHOR).key.priv.pem
-REGDB_PUBKEY ?= $(REGDB_AUTHOR).key.pub.pem
-
-REGDB_UPSTREAM_PUBKEY ?= sforshee.key.pub.pem
+REGDB_PUBCERT ?= $(REGDB_AUTHOR).x509.pem
 
 REGDB_CHANGED = $(shell $(SHA1SUM) -c --status sha1sum.txt >/dev/null 2>&1; \
         if [ $$? -ne 0 ]; then \
-                echo maintainer-clean $(REGDB_PUBKEY); \
+                echo maintainer-clean $(REGDB_PUBCERT); \
         fi)
 
 .PHONY: all clean mrproper install maintainer-clean install-distro-key
 
-all: $(REGDB_CHANGED) regulatory.bin sha1sum.txt
+all: $(REGDB_CHANGED) regulatory.db.p7s sha1sum.txt
 
 clean:
 	@rm -f *.pyc *.gz
 
 maintainer-clean: clean
-	@rm -f regulatory.bin
+	@rm -f regulatory.db regulatory.db.p7s
 
 mrproper: clean maintainer-clean
-	@echo Removed public key, regulatory.bin and compresed man pages
-	@rm -f $(REGDB_PUBKEY) .custom
+	@echo Removed public key, regulatory.db* and compressed man pages
+	@rm -f $(REGDB_PUBCERT) .custom
+
+regulatory.db: db.txt db2fw.py
+	@echo "Generating $@"
+	./db2fw.py regulatory.db db.txt
 
-regulatory.bin: db.txt $(REGDB_PRIVKEY) $(REGDB_PUBKEY)
-	@echo Generating $@ digitally signed by $(REGDB_AUTHOR)...
-	./db2bin.py regulatory.bin db.txt $(REGDB_PRIVKEY)
+regulatory.db.p7s: regulatory.db $(REGDB_PRIVKEY) $(REGDB_PUBCERT)
+	@echo "Signing regulatory.db (by $(REGDB_AUTHOR))..."
+	@openssl smime -sign \
+		-signer $(REGDB_PUBCERT) \
+		-inkey $(REGDB_PRIVKEY) \
+		-in $< -nosmimecap -binary \
+		-outform DER -out $@
 
 sha1sum.txt: db.txt
 	sha1sum $< > $@
 
-$(REGDB_PUBKEY): $(REGDB_PRIVKEY)
-	@echo "Generating public key for $(REGDB_AUTHOR)..."
-	openssl rsa -in $(REGDB_PRIVKEY) -out $(REGDB_PUBKEY) -pubout -outform PEM
+$(REGDB_PUBCERT): $(REGDB_PRIVKEY)
+	@echo "Generating certificate for $(REGDB_AUTHOR)..."
+	@openssl req -config regulatory.openssl.conf \
+		-key $(REGDB_PRIVKEY) -days 36500 -utf8 -nodes -batch \
+		-x509 -outform PEM -out $(REGDB_PUBCERT)
 	@echo $(REGDB_PUBKEY) > .custom
 
 
@@ -97,16 +103,7 @@ install-distro-key: maintainer-clean $(DISTRO_PRIVKEY)
 #	make maintainer-clean
 #	make
 #	sudo make install
-install: regulatory.bin.5.gz
-	install -m 755 -d $(DESTDIR)/$(CRDA_PATH)
-	install -m 755 -d $(DESTDIR)/$(CRDA_KEY_PATH)
-	if [ -f .custom ]; then \
-		install -m 644 -t $(DESTDIR)/$(CRDA_KEY_PATH)/ $(shell cat .custom); \
-	fi
-	install -m 644 -t $(DESTDIR)/$(CRDA_KEY_PATH)/ $(REGDB_UPSTREAM_PUBKEY)
-	install -m 644 -t $(DESTDIR)/$(CRDA_PATH)/ regulatory.bin
+install: regulatory.db.5.gz
+	install -m 644 -t $(DESTDIR)/$(CRDA_PATH)/ regulatory.db
 	install -m 755 -d $(DESTDIR)/$(MANDIR)/man5/
-	install -m 644 -t $(DESTDIR)/$(MANDIR)/man5/ regulatory.bin.5.gz
-
-uninstall:
-	rm -rf $(DESTDIR)/$(CRDA_PATH)/
+	install -m 644 -t $(DESTDIR)/$(MANDIR)/man5/ regulatory.db.5.gz
diff --git a/README b/README
index 065b67241c41..4028223725da 100644
--- a/README
+++ b/README
@@ -18,8 +18,8 @@ python module is used by the web viewer (Regulatory.py) which is
 implemented as a MoinMoin macro (and used on http://wireless.kernel.org)
 to allow viewing the database for verification.
 
-The dbparse module is also used by db2bin.py, the `compiler', which
-compiles and signs the binary database.
+The dbparse module is also used by db2bin.py and db2fw.py, the `compilers'
+that compile the database to its binary formats.
 
 For more information, please see the CRDA git repository:
 
diff --git a/db2fw.py b/db2fw.py
new file mode 100755
index 000000000000..7b2b14151e69
--- /dev/null
+++ b/db2fw.py
@@ -0,0 +1,133 @@
+#!/usr/bin/env python
+
+from cStringIO import StringIO
+import struct
+import hashlib
+from dbparse import DBParser
+import sys
+
+MAGIC = 0x52474442
+VERSION = 20
+
+if len(sys.argv) < 3:
+    print 'Usage: %s output-file input-file' % sys.argv[0]
+    sys.exit(2)
+
+def create_rules(countries):
+    result = {}
+    for c in countries.itervalues():
+        for rule in c.permissions:
+            result[rule] = 1
+    return result.keys()
+
+def create_collections(countries):
+    result = {}
+    for c in countries.itervalues():
+        result[(c.permissions, c.dfs_region)] = 1
+    return result.keys()
+
+
+def be32(output, val):
+    output.write(struct.pack('>I', val))
+def be16(output, val):
+    output.write(struct.pack('>H', val))
+
+class PTR(object):
+    def __init__(self, output):
+        self._output = output
+        self._pos = output.tell()
+        be16(output, 0)
+        self._written = False
+
+    def set(self, val=None):
+        if val is None:
+            val = self._output.tell()
+        assert val & 3 == 0
+        self._offset = val
+        pos = self._output.tell()
+        self._output.seek(self._pos)
+        be16(self._output, val >> 2)
+        self._output.seek(pos)
+        self._written = True
+
+    def get(self):
+        return self._offset
+
+    @property
+    def written(self):
+        return self._written
+
+p = DBParser()
+countries = p.parse(file(sys.argv[2]))
+rules = create_rules(countries)
+rules.sort(cmp=lambda x, y: cmp(x.freqband, y.freqband))
+collections = create_collections(countries)
+collections.sort(cmp=lambda x, y: cmp(x[0][0].freqband, y[0][0].freqband))
+
+output = StringIO()
+
+# struct regdb_file_header
+be32(output, MAGIC)
+be32(output, VERSION)
+
+country_ptrs = {}
+countrynames = countries.keys()
+countrynames.sort()
+for alpha2 in countrynames:
+    coll = countries[alpha2]
+    output.write(struct.pack('>cc', str(alpha2[0]), str(alpha2[1])))
+    country_ptrs[alpha2] = PTR(output)
+output.write('\x00' * 4)
+
+reg_rules = {}
+flags = 0
+for reg_rule in rules:
+    freq_range, power_rule = reg_rule.freqband, reg_rule.power
+    reg_rules[reg_rule] = output.tell()
+    assert power_rule.max_ant_gain == 0
+    flags = 0
+    # convert to new rule flags
+    assert reg_rule.flags & ~0x899 == 0
+    if reg_rule.flags & 1<<0:
+        flags |= 1<<0
+    if reg_rule.flags & 1<<3:
+        flags |= 1<<1
+    if reg_rule.flags & 1<<4:
+        flags |= 1<<2
+    if reg_rule.flags & 1<<7:
+        flags |= 1<<3
+    if reg_rule.flags & 1<<11:
+        flags |= 1<<4
+    rule_len = 16
+    cac_timeout = 0 # TODO
+    if not (flags & 1<<2):
+        cac_timeout = 0
+    if cac_timeout:
+        rule_len += 2
+    output.write(struct.pack('>BBHIII', rule_len, flags, power_rule.max_eirp * 100,
+                             freq_range.start * 1000, freq_range.end * 1000, freq_range.maxbw * 1000,
+                             ))
+    if cac_timeout:
+        output.write(struct.pack('>H', cac_timeout))
+    while rule_len % 4:
+        output.write('\0')
+        rule_len += 1
+
+for coll in collections:
+    for alpha2 in countrynames:
+        if (countries[alpha2].permissions, countries[alpha2].dfs_region) == coll:
+            assert not country_ptrs[alpha2].written
+            country_ptrs[alpha2].set()
+    slen = 3
+    output.write(struct.pack('>BBBx', slen, len(list(coll[0])), coll[1]))
+    coll = list(coll[0])
+    for regrule in coll:
+        be16(output, reg_rules[regrule] >> 2)
+    if len(coll) % 2:
+        be16(output, 0)
+
+for alpha2 in countrynames:
+    assert country_ptrs[alpha2].written
+
+outfile = open(sys.argv[1], 'w')
+outfile.write(output.getvalue())
-- 
2.14.1
