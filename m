Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f170.google.com ([209.85.215.170]:36374 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753481AbaBLSyn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Feb 2014 13:54:43 -0500
Received: by mail-ea0-f170.google.com with SMTP id g15so2867624eak.29
        for <linux-wireless@vger.kernel.org>; Wed, 12 Feb 2014 10:54:42 -0800 (PST)
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, mcgrof@do-not-panic.com,
	linville@tuxdriver.com, Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [PATCH] wireless-regdb: add DFS CAC time parameter
Date: Wed, 12 Feb 2014 19:54:24 +0100
Message-Id: <1392231266-28479-5-git-send-email-janusz.dziedzic@tieto.com> (sfid-20140212_195456_063790_0615105A)
In-Reply-To: <1392231266-28479-1-git-send-email-janusz.dziedzic@tieto.com>
References: <1392231266-28479-1-git-send-email-janusz.dziedzic@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Introduce support for setting DFS CAC time
in milliseconds.

Eg.
(5250 - 5330 @ AUTO), (20), (60000), DFS

will setup CAC 60 seconds CAC time.

Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
---
 db2bin.py  |    6 +++---
 dbparse.py |   17 +++++++++++++----
 2 files changed, 16 insertions(+), 7 deletions(-)

diff --git a/db2bin.py b/db2bin.py
index 41d3741..f6c3bc1 100755
--- a/db2bin.py
+++ b/db2bin.py
@@ -7,7 +7,7 @@ from dbparse import DBParser
 import sys
 
 MAGIC = 0x52474442
-VERSION = 19
+VERSION = 20
 
 if len(sys.argv) < 3:
     print 'Usage: %s output-file input-file [key-file]' % sys.argv[0]
@@ -93,8 +93,8 @@ for reg_rule in rules:
     freq_range, power_rule = reg_rule.freqband, reg_rule.power
     reg_rules[reg_rule] = output.tell()
     # struct regdb_file_reg_rule
-    output.write(struct.pack('>III', freq_ranges[freq_range], power_rules[power_rule],
-                             reg_rule.flags))
+    output.write(struct.pack('>IIII', freq_ranges[freq_range], power_rules[power_rule],
+                             reg_rule.flags, reg_rule.cac_time))
 
 
 reg_rules_collections = {}
diff --git a/dbparse.py b/dbparse.py
index 7c7bc19..f79de2a 100755
--- a/dbparse.py
+++ b/dbparse.py
@@ -76,12 +76,13 @@ class FlagError(Exception):
         self.flag = flag
 
 class Permission(object):
-    def __init__(self, freqband, power, flags):
+    def __init__(self, freqband, power, flags, cac_time):
         assert isinstance(freqband, FreqBand)
         assert isinstance(power, PowerRestriction)
         self.freqband = freqband
         self.power = power
         self.flags = 0
+        self.cac_time = cac_time
         for flag in flags:
             if not flag in flag_definitions:
                 raise FlagError(flag)
@@ -89,7 +90,7 @@ class Permission(object):
         self.textflags = flags
 
     def _as_tuple(self):
-        return (self.freqband, self.power, self.flags)
+        return (self.freqband, self.power, self.flags, self.cac_time)
 
     def __cmp__(self, other):
         if not isinstance(other, Permission):
@@ -256,6 +257,7 @@ class DBParser(object):
         self._comments = []
 
     def _parse_country_item(self, line):
+        cac_time = 0
         if line[0] == '(':
             try:
                 band, line = line[1:].split('),', 1)
@@ -284,7 +286,14 @@ class DBParser(object):
                 flags = []
             else:
                 pname = items[0]
-                flags = items[1].split(',')
+                pcac = items[1]
+                if pcac[0] == '(':
+                    cac, flags = pcac.split('),', 1)
+                    flags = flags.split(',')
+                    cac_time = int(cac[1:])
+                else:
+                    flags = items[1].split(',')
+
             power = pname[1:]
             pname = 'UNNAMED %d' % self._lineno
             self._parse_power_def(pname, power, dupwarn=False)
@@ -305,7 +314,7 @@ class DBParser(object):
         b = self._bands[bname]
         p = self._power[pname]
         try:
-            perm = Permission(b, p, flags)
+            perm = Permission(b, p, flags, cac_time)
         except FlagError, e:
             self._syntax_error("Invalid flag '%s'" % e.flag)
         for cname, c in self._current_countries.iteritems():
-- 
1.7.9.5

