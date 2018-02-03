Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from orthanc.universe-factory.net ([104.238.176.138]:33776 "EHLO
        orthanc.universe-factory.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752616AbeBCXH7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 3 Feb 2018 18:07:59 -0500
From: Matthias Schiffer <mschiffer@universe-factory.net>
To: seth.forshee@canonical.com
Cc: wireless-regdb@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: [PATCH 1/2] wireless-regdb: do not rely on sorting of dict keys in conversion scripts
Date: Sun,  4 Feb 2018 00:07:49 +0100
Message-Id: <bdfcead51b64e05f867ba5fe273c196edea35ddd.1517699270.git.mschiffer@universe-factory.net> (sfid-20180204_000816_125769_BE315C61)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The iteration order of dicts varies across Python implementations, in
particular Python 2 and 3. Fully sort key lists rather than only taking
the "freqband" field into consideration to make the build of the binary
regdbs fully reproducible.

This commit changes the order of the entries in the generated files; the
output of regdbdump is unchanged.

Signed-off-by: Matthias Schiffer <mschiffer@universe-factory.net>
---
 db2bin.py | 16 +++++++++-------
 db2fw.py  |  4 ++--
 2 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/db2bin.py b/db2bin.py
index 41d3741..ae5f064 100755
--- a/db2bin.py
+++ b/db2bin.py
@@ -50,18 +50,22 @@ class PTR(object):
 
 p = DBParser()
 countries = p.parse(file(sys.argv[2]))
+
+countrynames = countries.keys()
+countrynames.sort()
+
 power = []
 bands = []
-for c in countries.itervalues():
-    for perm in c.permissions:
+for alpha2 in countrynames:
+    for perm in countries[alpha2].permissions:
         if not perm.freqband in bands:
             bands.append(perm.freqband)
         if not perm.power in power:
             power.append(perm.power)
 rules = create_rules(countries)
-rules.sort(cmp=lambda x, y: cmp(x.freqband, y.freqband))
+rules.sort()
 collections = create_collections(countries)
-collections.sort(cmp=lambda x, y: cmp(x[0].freqband, y[0].freqband))
+collections.sort()
 
 output = StringIO()
 
@@ -104,15 +108,13 @@ for coll in collections:
     # struct regdb_file_reg_rules_collection
     coll = list(coll)
     be32(output, len(coll))
-    coll.sort(cmp=lambda x, y: cmp(x.freqband, y.freqband))
+    coll.sort()
     for regrule in coll:
         be32(output, reg_rules[regrule])
 
 # update country pointer now!
 reg_country_ptr.set()
 
-countrynames = countries.keys()
-countrynames.sort()
 for alpha2 in countrynames:
     coll = countries[alpha2]
     # struct regdb_file_reg_country
diff --git a/db2fw.py b/db2fw.py
index 7b2b141..630e4d6 100755
--- a/db2fw.py
+++ b/db2fw.py
@@ -60,9 +60,9 @@ class PTR(object):
 p = DBParser()
 countries = p.parse(file(sys.argv[2]))
 rules = create_rules(countries)
-rules.sort(cmp=lambda x, y: cmp(x.freqband, y.freqband))
+rules.sort()
 collections = create_collections(countries)
-collections.sort(cmp=lambda x, y: cmp(x[0][0].freqband, y[0][0].freqband))
+collections.sort()
 
 output = StringIO()
 
-- 
2.16.1
