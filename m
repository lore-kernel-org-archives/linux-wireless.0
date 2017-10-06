Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:55690 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751527AbdJFOKA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 6 Oct 2017 10:10:00 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [WIP] regdb: write firmware file format (version code 20)
Date: Fri,  6 Oct 2017 16:09:58 +0200
Message-Id: <20171006140958.478-1-johannes@sipsolutions.net> (sfid-20171006_161004_640436_4BF39FCD)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

TODO: clean up the Makefile stuff ...

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 Makefile  |  53 ++++++++++++++---------------
 db2bin.py | 113 +++++++++++++++++++++-----------------------------------------
 2 files changed, 63 insertions(+), 103 deletions(-)

diff --git a/Makefile b/Makefile
index 907ff282fc92..263e9c08b61c 100644
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
+regulatory.db: db.txt
+	@echo "Generating $@"
+	./db2bin.py regulatory.db db.txt
 
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
diff --git a/db2bin.py b/db2bin.py
index 41d3741728e1..4af0b0e1edfc 100755
--- a/db2bin.py
+++ b/db2bin.py
@@ -7,10 +7,10 @@ from dbparse import DBParser
 import sys
 
 MAGIC = 0x52474442
-VERSION = 19
+VERSION = 20
 
 if len(sys.argv) < 3:
-    print 'Usage: %s output-file input-file [key-file]' % sys.argv[0]
+    print 'Usage: %s output-file input-file' % sys.argv[0]
     sys.exit(2)
 
 def create_rules(countries):
@@ -23,123 +23,86 @@ def create_rules(countries):
 def create_collections(countries):
     result = {}
     for c in countries.itervalues():
-        result[c.permissions] = 1
+        result[(c.permissions, c.dfs_region)] = 1
     return result.keys()
 
 
 def be32(output, val):
     output.write(struct.pack('>I', val))
+def be16(output, val):
+    output.write(struct.pack('>H', val))
 
 class PTR(object):
     def __init__(self, output):
         self._output = output
         self._pos = output.tell()
-        be32(output, 0xFFFFFFFF)
+        be16(output, 0)
+        self._written = False
 
     def set(self, val=None):
         if val is None:
             val = self._output.tell()
+        assert val & 3 == 0
         self._offset = val
         pos = self._output.tell()
         self._output.seek(self._pos)
-        be32(self._output, val)
+        be16(self._output, val >> 2)
         self._output.seek(pos)
+        self._written = True
 
     def get(self):
         return self._offset
 
+    @property
+    def written(self):
+        return self._written
+
 p = DBParser()
 countries = p.parse(file(sys.argv[2]))
-power = []
-bands = []
-for c in countries.itervalues():
-    for perm in c.permissions:
-        if not perm.freqband in bands:
-            bands.append(perm.freqband)
-        if not perm.power in power:
-            power.append(perm.power)
 rules = create_rules(countries)
 rules.sort(cmp=lambda x, y: cmp(x.freqband, y.freqband))
 collections = create_collections(countries)
-collections.sort(cmp=lambda x, y: cmp(x[0].freqband, y[0].freqband))
+collections.sort(cmp=lambda x, y: cmp(x[0][0].freqband, y[0][0].freqband))
 
 output = StringIO()
 
 # struct regdb_file_header
 be32(output, MAGIC)
 be32(output, VERSION)
-reg_country_ptr = PTR(output)
-# add number of countries
-be32(output, len(countries))
-siglen = PTR(output)
-
-power_rules = {}
-for pr in power:
-    power_rules[pr] = output.tell()
-    pr = [int(v * 100.0) for v in (pr.max_ant_gain, pr.max_eirp)]
-    # struct regdb_file_power_rule
-    output.write(struct.pack('>II', *pr))
-
-freq_ranges = {}
-for fr in bands:
-    freq_ranges[fr] = output.tell()
-    fr = [int(f * 1000.0) for f in (fr.start, fr.end, fr.maxbw)]
-    # struct regdb_file_freq_range
-    output.write(struct.pack('>III', *fr))
 
+country_ptrs = {}
+countrynames = countries.keys()
+countrynames.sort()
+for alpha2 in countrynames:
+    coll = countries[alpha2]
+    output.write(struct.pack('>cc', str(alpha2[0]), str(alpha2[1])))
+    country_ptrs[alpha2] = PTR(output)
+output.write('\x00' * 4)
 
 reg_rules = {}
 for reg_rule in rules:
     freq_range, power_rule = reg_rule.freqband, reg_rule.power
     reg_rules[reg_rule] = output.tell()
-    # struct regdb_file_reg_rule
-    output.write(struct.pack('>III', freq_ranges[freq_range], power_rules[power_rule],
-                             reg_rule.flags))
-
-
-reg_rules_collections = {}
+    output.write(struct.pack('>HHIIIIHH', 24, reg_rule.flags,
+                             freq_range.start * 1000, freq_range.end * 1000, freq_range.maxbw * 1000,
+                             0, # cac timeout in ms
+                             power_rule.max_ant_gain * 100, power_rule.max_eirp * 100))
 
 for coll in collections:
-    reg_rules_collections[coll] = output.tell()
-    # struct regdb_file_reg_rules_collection
-    coll = list(coll)
-    be32(output, len(coll))
-    coll.sort(cmp=lambda x, y: cmp(x.freqband, y.freqband))
+    for alpha2 in countrynames:
+        if (countries[alpha2].permissions, countries[alpha2].dfs_region) == coll:
+            assert not country_ptrs[alpha2].written
+            country_ptrs[alpha2].set()
+    slen = 6 + 2 * len(list(coll[0]))
+    output.write(struct.pack('>HHcx', slen, len(list(coll[0])), chr(coll[1])))
+    coll = list(coll[0])
     for regrule in coll:
-        be32(output, reg_rules[regrule])
-
-# update country pointer now!
-reg_country_ptr.set()
+        be16(output, reg_rules[regrule] >> 2)
+    if slen % 4:
+        be16(output, 0)
 
-countrynames = countries.keys()
-countrynames.sort()
 for alpha2 in countrynames:
-    coll = countries[alpha2]
-    # struct regdb_file_reg_country
-    output.write(struct.pack('>ccxBI', str(alpha2[0]), str(alpha2[1]), coll.dfs_region, reg_rules_collections[coll.permissions]))
-
-
-if len(sys.argv) > 3:
-    # Load RSA only now so people can use this script
-    # without having those libraries installed to verify
-    # their SQL changes
-    from M2Crypto import RSA
-
-    # determine signature length
-    key = RSA.load_key(sys.argv[3])
-    hash = hashlib.sha1()
-    hash.update(output.getvalue())
-    sig = key.sign(hash.digest())
-    # write it to file
-    siglen.set(len(sig))
-    # sign again
-    hash = hashlib.sha1()
-    hash.update(output.getvalue())
-    sig = key.sign(hash.digest())
-
-    output.write(sig)
-else:
-    siglen.set(0)
+    assert country_ptrs[alpha2].written
 
 outfile = open(sys.argv[1], 'w')
 outfile.write(output.getvalue())
-- 
2.14.2
