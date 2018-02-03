Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from orthanc.universe-factory.net ([104.238.176.138]:33780 "EHLO
        orthanc.universe-factory.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752708AbeBCXH7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 3 Feb 2018 18:07:59 -0500
From: Matthias Schiffer <mschiffer@universe-factory.net>
To: seth.forshee@canonical.com
Cc: wireless-regdb@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: [PATCH 2/2] wireless-regdb: make scripts compatible with Python 3
Date: Sun,  4 Feb 2018 00:07:50 +0100
Message-Id: <cd62b7598708e7ecd858875021cf9c722dd360b9.1517699270.git.mschiffer@universe-factory.net> (sfid-20180204_000816_402697_0772B7F0)
In-Reply-To: <bdfcead51b64e05f867ba5fe273c196edea35ddd.1517699270.git.mschiffer@universe-factory.net>
References: <bdfcead51b64e05f867ba5fe273c196edea35ddd.1517699270.git.mschiffer@universe-factory.net>
In-Reply-To: <bdfcead51b64e05f867ba5fe273c196edea35ddd.1517699270.git.mschiffer@universe-factory.net>
References: <bdfcead51b64e05f867ba5fe273c196edea35ddd.1517699270.git.mschiffer@universe-factory.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When playing with the generation scripts for OpenWrt development, I noticed
that these scripts still required Python 2. Future-proof them by replacing
deprecated functions with new Python 3 compatible variants. The result
works with both Python 2.7 and Python 3.x; older Python 2.x releases are
not supported anymore.

regulatory.db and regulatory.bin are unchanged and reproducible across
Python versions. Note that there is no stable release of m2crypto for
Python 3 yet; I used the current development branch for testing.

Signed-off-by: Matthias Schiffer <mschiffer@universe-factory.net>
---
 db2bin.py  | 22 ++++++++---------
 db2fw.py   | 28 +++++++++++-----------
 dbparse.py | 81 +++++++++++++++++++++++++++++++++++++-------------------------
 3 files changed, 74 insertions(+), 57 deletions(-)

diff --git a/db2bin.py b/db2bin.py
index ae5f064..9c7fcd7 100755
--- a/db2bin.py
+++ b/db2bin.py
@@ -1,6 +1,6 @@
 #!/usr/bin/env python
 
-from cStringIO import StringIO
+from io import BytesIO, open
 import struct
 import hashlib
 from dbparse import DBParser
@@ -10,21 +10,21 @@ MAGIC = 0x52474442
 VERSION = 19
 
 if len(sys.argv) < 3:
-    print 'Usage: %s output-file input-file [key-file]' % sys.argv[0]
+    print('Usage: %s output-file input-file [key-file]' % sys.argv[0])
     sys.exit(2)
 
 def create_rules(countries):
     result = {}
-    for c in countries.itervalues():
+    for c in countries.values():
         for rule in c.permissions:
             result[rule] = 1
-    return result.keys()
+    return list(result)
 
 def create_collections(countries):
     result = {}
-    for c in countries.itervalues():
+    for c in countries.values():
         result[c.permissions] = 1
-    return result.keys()
+    return list(result)
 
 
 def be32(output, val):
@@ -49,9 +49,9 @@ class PTR(object):
         return self._offset
 
 p = DBParser()
-countries = p.parse(file(sys.argv[2]))
+countries = p.parse(open(sys.argv[2], 'rt'))
 
-countrynames = countries.keys()
+countrynames = list(countries)
 countrynames.sort()
 
 power = []
@@ -67,7 +67,7 @@ rules.sort()
 collections = create_collections(countries)
 collections.sort()
 
-output = StringIO()
+output = BytesIO()
 
 # struct regdb_file_header
 be32(output, MAGIC)
@@ -118,7 +118,7 @@ reg_country_ptr.set()
 for alpha2 in countrynames:
     coll = countries[alpha2]
     # struct regdb_file_reg_country
-    output.write(struct.pack('>ccxBI', str(alpha2[0]), str(alpha2[1]), coll.dfs_region, reg_rules_collections[coll.permissions]))
+    output.write(struct.pack('>BBxBI', alpha2[0], alpha2[1], coll.dfs_region, reg_rules_collections[coll.permissions]))
 
 
 if len(sys.argv) > 3:
@@ -143,5 +143,5 @@ if len(sys.argv) > 3:
 else:
     siglen.set(0)
 
-outfile = open(sys.argv[1], 'w')
+outfile = open(sys.argv[1], 'wb')
 outfile.write(output.getvalue())
diff --git a/db2fw.py b/db2fw.py
index 630e4d6..dd57acc 100755
--- a/db2fw.py
+++ b/db2fw.py
@@ -1,6 +1,6 @@
 #!/usr/bin/env python
 
-from cStringIO import StringIO
+from io import BytesIO, open
 import struct
 import hashlib
 from dbparse import DBParser
@@ -10,21 +10,21 @@ MAGIC = 0x52474442
 VERSION = 20
 
 if len(sys.argv) < 3:
-    print 'Usage: %s output-file input-file' % sys.argv[0]
+    print('Usage: %s output-file input-file' % sys.argv[0])
     sys.exit(2)
 
 def create_rules(countries):
     result = {}
-    for c in countries.itervalues():
+    for c in countries.values():
         for rule in c.permissions:
             result[rule] = 1
-    return result.keys()
+    return list(result)
 
 def create_collections(countries):
     result = {}
-    for c in countries.itervalues():
+    for c in countries.values():
         result[(c.permissions, c.dfs_region)] = 1
-    return result.keys()
+    return list(result)
 
 
 def be32(output, val):
@@ -58,26 +58,26 @@ class PTR(object):
         return self._written
 
 p = DBParser()
-countries = p.parse(file(sys.argv[2]))
+countries = p.parse(open(sys.argv[2], 'rt'))
 rules = create_rules(countries)
 rules.sort()
 collections = create_collections(countries)
 collections.sort()
 
-output = StringIO()
+output = BytesIO()
 
 # struct regdb_file_header
 be32(output, MAGIC)
 be32(output, VERSION)
 
 country_ptrs = {}
-countrynames = countries.keys()
+countrynames = list(countries)
 countrynames.sort()
 for alpha2 in countrynames:
     coll = countries[alpha2]
-    output.write(struct.pack('>cc', str(alpha2[0]), str(alpha2[1])))
+    output.write(struct.pack('>BB', alpha2[0], alpha2[1]))
     country_ptrs[alpha2] = PTR(output)
-output.write('\x00' * 4)
+output.write(b'\x00' * 4)
 
 reg_rules = {}
 flags = 0
@@ -104,8 +104,8 @@ for reg_rule in rules:
         cac_timeout = 0
     if cac_timeout:
         rule_len += 2
-    output.write(struct.pack('>BBHIII', rule_len, flags, power_rule.max_eirp * 100,
-                             freq_range.start * 1000, freq_range.end * 1000, freq_range.maxbw * 1000,
+    output.write(struct.pack('>BBHIII', rule_len, flags, int(power_rule.max_eirp * 100),
+                             int(freq_range.start * 1000), int(freq_range.end * 1000), int(freq_range.maxbw * 1000),
                              ))
     if cac_timeout:
         output.write(struct.pack('>H', cac_timeout))
@@ -129,5 +129,5 @@ for coll in collections:
 for alpha2 in countrynames:
     assert country_ptrs[alpha2].written
 
-outfile = open(sys.argv[1], 'w')
+outfile = open(sys.argv[1], 'wb')
 outfile.write(output.getvalue())
diff --git a/dbparse.py b/dbparse.py
index b735b6a..d73d1bd 100755
--- a/dbparse.py
+++ b/dbparse.py
@@ -1,5 +1,7 @@
 #!/usr/bin/env python
 
+from builtins import bytes
+from functools import total_ordering
 import sys, math
 
 # must match <linux/nl80211.h> enum nl80211_reg_rule_flags
@@ -25,6 +27,7 @@ dfs_regions = {
     'DFS-JP':		3,
 }
 
+@total_ordering
 class FreqBand(object):
     def __init__(self, start, end, bw, comments=None):
         self.start = start
@@ -32,41 +35,49 @@ class FreqBand(object):
         self.maxbw = bw
         self.comments = comments or []
 
-    def __cmp__(self, other):
-        s = self
-        o = other
-        if not isinstance(o, FreqBand):
-            return False
-        return cmp((s.start, s.end, s.maxbw), (o.start, o.end, o.maxbw))
+    def _as_tuple(self):
+        return (self.start, self.end, self.maxbw)
+
+    def __eq__(self, other):
+        return (self._as_tuple() == other._as_tuple())
+
+    def __ne__(self, other):
+        return not (self == other)
+
+    def __lt__(self, other):
+        return (self._as_tuple() < other._as_tuple())
 
     def __hash__(self):
-        s = self
-        return hash((s.start, s.end, s.maxbw))
+        return hash(self._as_tuple())
 
     def __str__(self):
         return '<FreqBand %.3f - %.3f @ %.3f>' % (
                   self.start, self.end, self.maxbw)
 
+@total_ordering
 class PowerRestriction(object):
     def __init__(self, max_ant_gain, max_eirp, comments = None):
         self.max_ant_gain = max_ant_gain
         self.max_eirp = max_eirp
         self.comments = comments or []
 
-    def __cmp__(self, other):
-        s = self
-        o = other
-        if not isinstance(o, PowerRestriction):
-            return False
-        return cmp((s.max_ant_gain, s.max_eirp),
-                   (o.max_ant_gain, o.max_eirp))
+    def _as_tuple(self):
+        return (self.max_ant_gain, self.max_eirp)
 
-    def __str__(self):
-        return '<PowerRestriction ...>'
+    def __eq__(self, other):
+        return (self._as_tuple() == other._as_tuple())
+
+    def __ne__(self, other):
+        return not (self == other)
+
+    def __lt__(self, other):
+        return (self._as_tuple() < other._as_tuple())
 
     def __hash__(self):
-        s = self
-        return hash((s.max_ant_gain, s.max_eirp))
+        return hash(self._as_tuple())
+
+    def __str__(self):
+        return '<PowerRestriction ...>'
 
 class DFSRegionError(Exception):
     def __init__(self, dfs_region):
@@ -76,6 +87,7 @@ class FlagError(Exception):
     def __init__(self, flag):
         self.flag = flag
 
+@total_ordering
 class Permission(object):
     def __init__(self, freqband, power, flags):
         assert isinstance(freqband, FreqBand)
@@ -92,10 +104,14 @@ class Permission(object):
     def _as_tuple(self):
         return (self.freqband, self.power, self.flags)
 
-    def __cmp__(self, other):
-        if not isinstance(other, Permission):
-            return False
-        return cmp(self._as_tuple(), other._as_tuple())
+    def __eq__(self, other):
+        return (self._as_tuple() == other._as_tuple())
+
+    def __ne__(self, other):
+        return not (self == other)
+
+    def __lt__(self, other):
+        return (self._as_tuple() < other._as_tuple())
 
     def __hash__(self):
         return hash(self._as_tuple())
@@ -104,12 +120,12 @@ class Country(object):
     def __init__(self, dfs_region, permissions=None, comments=None):
         self._permissions = permissions or []
         self.comments = comments or []
-	self.dfs_region = 0
+        self.dfs_region = 0
 
-	if dfs_region:
-		if not dfs_region in dfs_regions:
-		    raise DFSRegionError(dfs_region)
-		self.dfs_region = dfs_regions[dfs_region]
+        if dfs_region:
+            if not dfs_region in dfs_regions:
+                raise DFSRegionError(dfs_region)
+            self.dfs_region = dfs_regions[dfs_region]
 
     def add(self, perm):
         assert isinstance(perm, Permission)
@@ -248,6 +264,7 @@ class DBParser(object):
         for cname in cnames:
             if len(cname) != 2:
                 self._warn("country '%s' not alpha2" % cname)
+            cname = bytes(cname, 'ascii')
             if not cname in self._countries:
                 self._countries[cname] = Country(dfs_region, comments=self._comments)
             self._current_countries[cname] = self._countries[cname]
@@ -304,9 +321,9 @@ class DBParser(object):
         p = self._power[pname]
         try:
             perm = Permission(b, p, flags)
-        except FlagError, e:
+        except FlagError as e:
             self._syntax_error("Invalid flag '%s'" % e.flag)
-        for cname, c in self._current_countries.iteritems():
+        for cname, c in self._current_countries.items():
             if perm in c:
                 self._warn('Rule "%s, %s" added to "%s" twice' % (
                               bname, pname, cname))
@@ -360,7 +377,7 @@ class DBParser(object):
 
         countries = self._countries
         bands = {}
-        for k, v in self._bands.iteritems():
+        for k, v in self._bands.items():
             if k in self._bands_used:
                 bands[self._banddup[k]] = v
                 continue
@@ -369,7 +386,7 @@ class DBParser(object):
                 self._lineno = self._bandline[k]
                 self._warn('Unused band definition "%s"' % k)
         power = {}
-        for k, v in self._power.iteritems():
+        for k, v in self._power.items():
             if k in self._power_used:
                 power[self._powerdup[k]] = v
                 continue
-- 
2.16.1
