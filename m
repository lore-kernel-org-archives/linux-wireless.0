Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:65191 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933860Ab1JDXr4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Oct 2011 19:47:56 -0400
Received: by ywb5 with SMTP id 5so1034660ywb.19
        for <linux-wireless@vger.kernel.org>; Tue, 04 Oct 2011 16:47:56 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
To: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Cc: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
Subject: [PATCH 1/8] wireless-regdb: Add master DFS region support
Date: Tue,  4 Oct 2011 16:47:40 -0700
Message-Id: <1317772067-6998-2-git-send-email-mcgrof@qca.qualcomm.com> (sfid-20111005_014800_191667_96247499)
In-Reply-To: <1317772067-6998-1-git-send-email-mcgrof@qca.qualcomm.com>
References: <1317772067-6998-1-git-send-email-mcgrof@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

To support master DFS we add the three known DFS regions which
countries are known to support. In order to modify the regulatory
database schema in a backward compatible way we use one of
the two pad bytes which were unused. By using one of the two pad
bytes we end up keeping new regulatory databases with DFS region
support compatible with older verions of CRDA, the DFS region would
just not be sent to the kernel.

DFS master is only required for modes of operation which iniate
radiation on DFS channels, we will start supporting DFS with AP
mode of operation. Without DFS master support you cannot intiate
radiation on those channels (AP, Mesh, IBSS, P2P). Apart from support
from wireless-regdb, crda and the 802.11 stack you'll also need proper
DFS support on your device driver to use this.

A country can only map to one DFS region at a time for all frequency
regions. After this patch countries can start being mapped to their
own DFS region.

Signed-off-by: Luis R. Rodriguez <mcgrof@qca.qualcomm.com>
---
 db2bin.py  |    2 +-
 dbparse.py |   25 ++++++++++++++++++++-----
 2 files changed, 21 insertions(+), 6 deletions(-)

diff --git a/db2bin.py b/db2bin.py
index 23d3ee2..41d3741 100755
--- a/db2bin.py
+++ b/db2bin.py
@@ -116,7 +116,7 @@ countrynames.sort()
 for alpha2 in countrynames:
     coll = countries[alpha2]
     # struct regdb_file_reg_country
-    output.write(struct.pack('>ccxxI', str(alpha2[0]), str(alpha2[1]), reg_rules_collections[coll.permissions]))
+    output.write(struct.pack('>ccxBI', str(alpha2[0]), str(alpha2[1]), coll.dfs_region, reg_rules_collections[coll.permissions]))
 
 
 if len(sys.argv) > 3:
diff --git a/dbparse.py b/dbparse.py
index 2c0d738..893d64e 100755
--- a/dbparse.py
+++ b/dbparse.py
@@ -18,6 +18,12 @@ flag_definitions = {
     'NO-HT40':		1<<10,
 }
 
+dfs_regions = {
+    'DFS-FCC':		1,
+    'DFS-ETSI':		2,
+    'DFS-JP':		3,
+}
+
 class FreqBand(object):
     def __init__(self, start, end, bw, comments=None):
         self.start = start
@@ -61,6 +67,10 @@ class PowerRestriction(object):
         s = self
         return hash((s.max_ant_gain, s.max_eirp))
 
+class DFSRegionError(Exception):
+    def __init__(self, dfs_region):
+        self.dfs_region = dfs_region
+
 class FlagError(Exception):
     def __init__(self, flag):
         self.flag = flag
@@ -90,9 +100,15 @@ class Permission(object):
         return hash(self._as_tuple())
 
 class Country(object):
-    def __init__(self, permissions=None, comments=None):
+    def __init__(self, dfs_region, permissions=None, comments=None):
         self._permissions = permissions or []
         self.comments = comments or []
+	self.dfs_region = 0
+
+	if dfs_region:
+		if not dfs_region in dfs_regions:
+		    raise DFSRegionError(dfs_region)
+		self.dfs_region = dfs_regions[dfs_region]
 
     def add(self, perm):
         assert isinstance(perm, Permission)
@@ -224,11 +240,10 @@ class DBParser(object):
 
     def _parse_country(self, line):
         try:
-            cname, line = line.split(':', 1)
+            cname, cvals= line.split(':', 1)
+            dfs_region = cvals.strip()
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
+                self._countries[cname] = Country(dfs_region, comments=self._comments)
             self._current_countries[cname] = self._countries[cname]
         self._comments = []
 
-- 
1.7.4.15.g7811d

