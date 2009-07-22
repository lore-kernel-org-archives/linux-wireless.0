Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:45983 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752801AbZGVR50 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jul 2009 13:57:26 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 22 Jul 2009 10:57:27 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>,
	<johannes@sipsolutions.net>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH v2] wireless-regb: make db2bin.py use new hashlib for sha1
Date: Wed, 22 Jul 2009 10:57:23 -0700
Message-ID: <1248285443-10890-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Python now complains about sha module as its deprecated:

./db2bin.py regulatory.bin db.txt ~/.wireless-regdb-mcgrof.key.priv.pem
./db2bin.py:5: DeprecationWarning: the sha module is deprecated; use the hashlib module instead
  import sha

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---

Don't pass along my regulatory.bin changes..

 db2bin.py |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/db2bin.py b/db2bin.py
index e783b3a..23d3ee2 100755
--- a/db2bin.py
+++ b/db2bin.py
@@ -2,7 +2,7 @@
 
 from cStringIO import StringIO
 import struct
-import sha
+import hashlib
 from dbparse import DBParser
 import sys
 
@@ -127,13 +127,13 @@ if len(sys.argv) > 3:
 
     # determine signature length
     key = RSA.load_key(sys.argv[3])
-    hash = sha.new()
+    hash = hashlib.sha1()
     hash.update(output.getvalue())
     sig = key.sign(hash.digest())
     # write it to file
     siglen.set(len(sig))
     # sign again
-    hash = sha.new()
+    hash = hashlib.sha1()
     hash.update(output.getvalue())
     sig = key.sign(hash.digest())
 
-- 
1.6.3.3

