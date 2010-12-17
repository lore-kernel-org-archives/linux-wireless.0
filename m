Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:12638 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752602Ab0LQDX2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Dec 2010 22:23:28 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 16 Dec 2010 19:23:12 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linux-wireless@vger.kernel.org>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [RFC 1/8] wireless-regdb: Add DFS bit fields for countries
Date: Thu, 16 Dec 2010 19:23:10 -0800
Message-ID: <1292556197-4820-2-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1292556197-4820-1-git-send-email-lrodriguez@atheros.com>
References: <1292556197-4820-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

To support DFS we add the three known DFS regions which countries
can support. In order to not modify the regulatory database scheme
in an incompatible way we use some two pad bytes which were unused
for this. This lets us later also add some more bits for general
country specific regulatory data.

We keep the regulatory database intact as otherwise older CRDA
versions will not read new regulatory file updates. Instead of
requiring new CRDA version out in the field we can treat this
as a regulatory update and simply have users who want DFS master
support to upgrade their CRDA. We'll treat the DFS region assignemnts
as a simple regulatory update.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 db2bin.py  |    2 +-
 dbparse.py |   25 ++++++++++++++++++++-----
 2 files changed, 21 insertions(+), 6 deletions(-)

diff --git a/db2bin.py b/db2bin.py
index 23d3ee2..b8a153c 100755
--- a/db2bin.py
+++ b/db2bin.py
@@ -116,7 +116,7 @@ countrynames.sort()
 for alpha2 in countrynames:
     coll = countries[alpha2]
     # struct regdb_file_reg_country
-    output.write(struct.pack('>ccxxI', str(alpha2[0]), str(alpha2[1]), reg_rules_collections[coll.permissions]))
+    output.write(struct.pack('>cchI', str(alpha2[0]), str(alpha2[1]), coll.cflags, reg_rules_collections[coll.permissions]))
 
 
 if len(sys.argv) > 3:
diff --git a/dbparse.py b/dbparse.py
index 2c0d738..f5087f2 100755
--- a/dbparse.py
+++ b/dbparse.py
@@ -18,6 +18,12 @@ flag_definitions = {
     'NO-HT40':		1<<10,
 }
 
+country_flag_definitions = {
+    'DFS-FCC':		1<<0,
+    'DFS-ETSI':		1<<1,
+    'DFS-JP':		1<<2,
+}
+
 class FreqBand(object):
     def __init__(self, start, end, bw, comments=None):
         self.start = start
@@ -61,6 +67,10 @@ class PowerRestriction(object):
         s = self
         return hash((s.max_ant_gain, s.max_eirp))
 
+class CountryFlagError(Exception):
+    def __init__(self, cflag):
+        self.flag = cflag
+
 class FlagError(Exception):
     def __init__(self, flag):
         self.flag = flag
@@ -90,9 +100,15 @@ class Permission(object):
         return hash(self._as_tuple())
 
 class Country(object):
-    def __init__(self, permissions=None, comments=None):
+    def __init__(self, cflags, permissions=None, comments=None):
         self._permissions = permissions or []
         self.comments = comments or []
+	self.cflags = 0
+	if cflags:
+		for cflag in cflags.split(','):
+		    if not cflag in country_flag_definitions:
+			raise CountryFlagError(cflag)
+		    self.cflags |= country_flag_definitions[cflag]
 
     def add(self, perm):
         assert isinstance(perm, Permission)
@@ -224,11 +240,10 @@ class DBParser(object):
 
     def _parse_country(self, line):
         try:
-            cname, line = line.split(':', 1)
+            cname, cflags = line.split(':', 1)
+            cflags = cflags.strip()
             if not cname:
                 self._syntax_error("'country' keyword must be followed by name")
-            if line:
-                self._syntax_error("extra data at end of country line")
         except ValueError:
             self._syntax_error("country name must be followed by colon")
 
@@ -239,7 +254,7 @@ class DBParser(object):
             if len(cname) != 2:
                 self._warn("country '%s' not alpha2" % cname)
             if not cname in self._countries:
-                self._countries[cname] = Country(comments=self._comments)
+                self._countries[cname] = Country(cflags, comments=self._comments)
             self._current_countries[cname] = self._countries[cname]
         self._comments = []
 
-- 
1.7.3.2.90.gd4c43

