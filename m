Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:45557 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752878AbZGVRwW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jul 2009 13:52:22 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 22 Jul 2009 10:52:22 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>,
	<johannes@sipsolutions.net>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH] wireless-regb: make db2bin.py use new hashlib for sha1
Date: Wed, 22 Jul 2009 10:52:20 -0700
Message-ID: <1248285140-10140-1-git-send-email-lrodriguez@atheros.com>
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
 db2bin.py      |    6 +++---
 regulatory.bin |  Bin 3084 -> 3084 bytes
 2 files changed, 3 insertions(+), 3 deletions(-)

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
 
diff --git a/regulatory.bin b/regulatory.bin
index 43797b58453482f01b66050e8bf3905242fd057b..6128687a742cf85f1a39def772cc30dd330e5723 100644
GIT binary patch
delta 273
zcmV+s0q*{c7>pROq6z{A43ne^Xn(*WB)7iO3CS>`!(@G$Lz!m<D*d~E$cm-?G$4JG
zlQ7$|U4nwxskc@T;^&b-26aSNf9O~_4OpX63fw{)N*Pf=4}sj1;y)XEqaw$#lVp-B
z357?vVFd%Xl>!@!$WF;lX_>T&D8sQ0(lprReH4=Bcb=7jTB054r(|Lnz<;Kk{$>V4
zG#)UDNAA*fgKVbPE6G_vSXhDoHgn})ywQ`Bz-SFgPv#S=C<B-FXMKA2BlNpuTt`L?
z)x83hKG?htDH!)09BuV~&j(ShcDLgTt3Puin+0D<O~P8UKb_yGT5$7vjst#k_C<r6
Xe8-M~z&q>}jG#)+zmIlU_X5WP*Mxuh

delta 273
zcmV+s0q*{c7>pROq6z{Bl#`?iXn#;swzPB}=h4)L-^~xBz2}pe;8EET#jZtE*8H3k
zXj)vVHXPR-uQZMzlf@W6S={@A#vJjZtpg@jD}+zKI6DS+GdJNQ?i;!n=ZKWtY>miL
z@U~l;%l7Pt2R+>_RBl-2_6KBM62F&m3;+SIjWY)EP9A8g(&I=;gZe0mH-DO&d)b4J
zRlqyy#|hjK421&i7oK+fJ~2iH?Rt2_iu^|H(dha^Ei{m=y%aEnk$tw#YtaG3bIdi7
z$^x{m;*=7+Qf<K%y4{MNS&!be0H>Y7R0%9MixLB1wp?ADW&&N6+f}b~OtpVpFRLtX
Xv^M30B4gmTdF0UEV~?_e@&czA=`Dq-

-- 
1.6.3.3

