Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:63454 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932919Ab0LTRCn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Dec 2010 12:02:43 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 20 Dec 2010 09:02:27 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>
CC: <kathy.giori@atheros.com>, <amod.bodas@atheros.com>,
	<david.quan@atheros.com>, <michael.green@atheros.com>,
	<linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 1/8] wireless-regdb: Add DFS bit fields for countries
Date: Mon, 20 Dec 2010 12:02:27 -0500
Message-ID: <1292864555-28661-2-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1292864555-28661-1-git-send-email-lrodriguez@atheros.com>
References: <1292864555-28661-1-git-send-email-lrodriguez@atheros.com>
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

