Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.31]:61206 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754623AbeEALie (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 1 May 2018 07:38:34 -0400
From: Haim Dreyfuss <haim.dreyfuss@intel.com>
To: seth.forshee@canonical.com
Cc: wireless-regdb@lists.infradead.org, linux-wireless@vger.kernel.org,
        johannes.berg@intel.com, Haim Dreyfuss <haim.dreyfuss@intel.com>
Subject: [PATCH 2/2] wireless-regdb: Parse wmm rule data
Date: Tue,  1 May 2018 16:36:12 +0300
Message-Id: <1525181772-30337-2-git-send-email-haim.dreyfuss@intel.com> (sfid-20180501_133838_108789_F5536C3B)
In-Reply-To: <1525181772-30337-1-git-send-email-haim.dreyfuss@intel.com>
References: <1525181772-30337-1-git-send-email-haim.dreyfuss@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add code to parse wmm rule data.
Also write it to the the regulatory.db fw file

Signed-off-by: Haim Dreyfuss <haim.dreyfuss@intel.com>
---
 db2fw.py   |  31 +++++++++++++++--
 dbparse.py | 111 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--
 2 files changed, 136 insertions(+), 6 deletions(-)

diff --git a/db2fw.py b/db2fw.py
index 7b2b141..6d0ae5f 100755
--- a/db2fw.py
+++ b/db2fw.py
@@ -5,6 +5,7 @@ import struct
 import hashlib
 from dbparse import DBParser
 import sys
+from math import log
 
 MAGIC = 0x52474442
 VERSION = 20
@@ -26,6 +27,13 @@ def create_collections(countries):
         result[(c.permissions, c.dfs_region)] = 1
     return result.keys()
 
+def create_wmms(countries):
+    result = {}
+    for c in countries.itervalues():
+        for rule in c.permissions:
+            if rule.wmmrule is not None:
+                result[rule.wmmrule] = 1
+    return result.keys()
 
 def be32(output, val):
     output.write(struct.pack('>I', val))
@@ -63,6 +71,8 @@ rules = create_rules(countries)
 rules.sort(cmp=lambda x, y: cmp(x.freqband, y.freqband))
 collections = create_collections(countries)
 collections.sort(cmp=lambda x, y: cmp(x[0][0].freqband, y[0][0].freqband))
+wmms = create_wmms(countries)
+wmms.sort(cmp=lambda x, y: cmp(x.vo_c, y.vo_c))
 
 output = StringIO()
 
@@ -79,10 +89,19 @@ for alpha2 in countrynames:
     country_ptrs[alpha2] = PTR(output)
 output.write('\x00' * 4)
 
+wmmdb = {}
+for w in wmms:
+    assert output.tell() & 3 == 0
+    wmmdb[w] = output.tell() >> 2
+    for r in w._as_tuple():
+        ecw = int(log(r[0] + 1, 2)) << 4 | int(log(r[1] + 1, 2))
+        ac = (ecw, r[2],r[3])
+        output.write(struct.pack('>BBH', *ac))
+
 reg_rules = {}
 flags = 0
 for reg_rule in rules:
-    freq_range, power_rule = reg_rule.freqband, reg_rule.power
+    freq_range, power_rule, wmm_rule = reg_rule.freqband, reg_rule.power, reg_rule.wmmrule
     reg_rules[reg_rule] = output.tell()
     assert power_rule.max_ant_gain == 0
     flags = 0
@@ -102,13 +121,19 @@ for reg_rule in rules:
     cac_timeout = 0 # TODO
     if not (flags & 1<<2):
         cac_timeout = 0
-    if cac_timeout:
+    if cac_timeout or wmm_rule:
+        rule_len += 2
+    if wmm_rule is not None:
         rule_len += 2
     output.write(struct.pack('>BBHIII', rule_len, flags, power_rule.max_eirp * 100,
                              freq_range.start * 1000, freq_range.end * 1000, freq_range.maxbw * 1000,
                              ))
-    if cac_timeout:
+    if rule_len > 16:
         output.write(struct.pack('>H', cac_timeout))
+
+    if rule_len > 18:
+        be16(output, wmmdb[wmm_rule])
+
     while rule_len % 4:
         output.write('\0')
         rule_len += 1
diff --git a/dbparse.py b/dbparse.py
index b735b6a..409fbb8 100755
--- a/dbparse.py
+++ b/dbparse.py
@@ -1,6 +1,9 @@
 #!/usr/bin/env python
 
 import sys, math
+from math import ceil, log
+from collections import defaultdict, OrderedDict
+import attr
 
 # must match <linux/nl80211.h> enum nl80211_reg_rule_flags
 
@@ -25,6 +28,21 @@ dfs_regions = {
     'DFS-JP':		3,
 }
 
+@attr.s(frozen=True)
+class WmmRule(object):
+    vo_c = attr.ib()
+    vi_c = attr.ib()
+    be_c = attr.ib()
+    bk_c = attr.ib()
+    vo_ap = attr.ib()
+    vi_ap = attr.ib()
+    be_ap = attr.ib()
+    bk_ap = attr.ib()
+
+    def _as_tuple(self):
+        return (self.vo_c, self.vi_c, self.be_c, self.bk_c,
+                self.vo_ap, self.vi_ap, self.be_ap, self.bk_ap)
+
 class FreqBand(object):
     def __init__(self, start, end, bw, comments=None):
         self.start = start
@@ -77,11 +95,13 @@ class FlagError(Exception):
         self.flag = flag
 
 class Permission(object):
-    def __init__(self, freqband, power, flags):
+    def __init__(self, freqband, power, flags, wmmrule):
         assert isinstance(freqband, FreqBand)
         assert isinstance(power, PowerRestriction)
+        assert isinstance(wmmrule, WmmRule) or wmmrule is None
         self.freqband = freqband
         self.power = power
+        self.wmmrule = wmmrule
         self.flags = 0
         for flag in flags:
             if not flag in flag_definitions:
@@ -89,8 +109,11 @@ class Permission(object):
             self.flags |= flag_definitions[flag]
         self.textflags = flags
 
+    def _has_wmmrule(self):
+        return self.wmmrule is not None
+
     def _as_tuple(self):
-        return (self.freqband, self.power, self.flags)
+        return (self.freqband, self.power, self.flags, self.wmmrule)
 
     def __cmp__(self, other):
         if not isinstance(other, Permission):
@@ -100,6 +123,9 @@ class Permission(object):
     def __hash__(self):
         return hash(self._as_tuple())
 
+    def __str__(self):
+        return str(self.freqband) + str(self.power) + str(self.wmmrule)
+
 class Country(object):
     def __init__(self, dfs_region, permissions=None, comments=None):
         self._permissions = permissions or []
@@ -233,6 +259,61 @@ class DBParser(object):
         self._powerrev[p] = pname
         self._powerline[pname] = self._lineno
 
+    def _parse_wmmrule(self, line):
+        regions = line[:-1].strip()
+        if not regions:
+            self._syntax_error("'wmmrule' keyword must be followed by region")
+
+        regions = regions.split(',')
+
+        self._current_regions = {}
+        for region in regions:
+            if region in self._wmm_rules:
+                self._warn("region %s was added already to wmm rules" % region)
+            self._current_regions[region] = 1
+        self._comments = []
+
+    def _validate_input(self, cw_min, cw_max, aifsn, cot):
+        if  cw_min < 1:
+            self._syntax_error("Invalid cw_min value (%d)" % cw_min)
+        if cw_max < 1:
+            self._syntax_error("Invalid cw_max value (%d)" % cw_max)
+        if cw_min > cw_max:
+            self._syntax_error("Inverted contention window (%d - %d)" %
+                    (cw_min, cw_max))
+        if not (bin(cw_min + 1).count('1') == 1 and cw_min < 2**15):
+            self._syntax_error("Invalid cw_min value should be power of 2 - 1 (%d)"
+                    % cw_min)
+        if not (bin(cw_max + 1).count('1') == 1 and cw_max < 2**15):
+            self._syntax_error("Invalid cw_max value should be power of 2 - 1 (%d)"
+                    % cw_max)
+        if aifsn < 1:
+            self._syntax_error("Invalid aifsn value (%d)" % aifsn)
+        if cot < 0:
+            self._syntax_error("Invalid cot value (%d)" % cot)
+
+
+    def _validate_size(self, var, bytcnt):
+        return bytcnt < ceil(len(bin(var)[2:]) / 8.0)
+
+    def _parse_wmmrule_item(self, line):
+        bytcnt = (2.0, 2.0, 1.0, 2.0)
+        try:
+            ac, cval = line.split(':')
+            if not ac:
+                self._syntax_error("wmm item must have ac prefix")
+        except ValueError:
+                self._syntax_error("access category must be followed by colon")
+        p = tuple([int(v.split('=', 1)[1]) for v in cval.split(',')])
+        self._validate_input(*p)
+        for v, b in zip(p, bytcnt):
+            if self._validate_size(v, b):
+                self._syntax_error("unexpected input size expect %d got %d"
+                        % (b, v))
+
+            for r in self._current_regions:
+                self._wmm_rules[r][ac] = p
+
     def _parse_country(self, line):
         try:
             cname, cvals= line.split(':', 1)
@@ -290,6 +371,15 @@ class DBParser(object):
             line = line.split(',')
             pname = line[0]
             flags = line[1:]
+        w = None
+        if flags and 'wmmrule' in flags[-1]:
+            try:
+                region = flags.pop().split('=', 1)[1]
+                if region not in self._wmm_rules.keys():
+                    self._syntax_error("No wmm rule for %s" % region)
+            except IndexError:
+                self._syntax_error("flags is empty list or no region was found")
+            w = WmmRule(*self._wmm_rules[region].values())
 
         if not bname in self._bands:
             self._syntax_error("band does not exist")
@@ -303,7 +393,7 @@ class DBParser(object):
         b = self._bands[bname]
         p = self._power[pname]
         try:
-            perm = Permission(b, p, flags)
+            perm = Permission(b, p, flags, w)
         except FlagError, e:
             self._syntax_error("Invalid flag '%s'" % e.flag)
         for cname, c in self._current_countries.iteritems():
@@ -315,6 +405,7 @@ class DBParser(object):
 
     def parse(self, f):
         self._current_countries = None
+        self._current_regions = None
         self._bands = {}
         self._power = {}
         self._countries = {}
@@ -326,6 +417,7 @@ class DBParser(object):
         self._powerdup = {}
         self._bandline = {}
         self._powerline = {}
+        self._wmm_rules = defaultdict(lambda: OrderedDict())
 
         self._comments = []
 
@@ -337,6 +429,7 @@ class DBParser(object):
                 self._comments.append(line[1:].strip())
             line = line.replace(' ', '').replace('\t', '')
             if not line:
+                self._current_regions = None
                 self._comments = []
             line = line.split('#')[0]
             if not line:
@@ -344,17 +437,29 @@ class DBParser(object):
             if line[0:4] == 'band':
                 self._parse_band(line[4:])
                 self._current_countries = None
+                self._current_regions = None
                 self._comments = []
             elif line[0:5] == 'power':
                 self._parse_power(line[5:])
                 self._current_countries = None
+                self._current_regions = None
                 self._comments = []
             elif line[0:7] == 'country':
                 self._parse_country(line[7:])
                 self._comments = []
+                self._current_regions = None
             elif self._current_countries is not None:
+                self._current_regions = None
                 self._parse_country_item(line)
                 self._comments = []
+            elif line[0:7] == 'wmmrule':
+                self._parse_wmmrule(line[7:])
+                self._current_countries = None
+                self._comments = []
+            elif self._current_regions is not None:
+                self._parse_wmmrule_item(line)
+                self._current_countries = None
+                self._comments = []
             else:
                 self._syntax_error("Expected band, power or country definition")
 
-- 
2.7.4
