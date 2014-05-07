Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:41474 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755443AbaEGPPW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 May 2014 11:15:22 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: wireless-regdb@lists.infradead.org
Cc: =?UTF-8?q?Christian=20S=C3=BCnkenberg?=
	<christian.suenkenberg@hfg-karlsruhe.de>,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] wireless-regdb: correct some flag damage...
Date: Wed,  7 May 2014 11:02:00 -0400
Message-Id: <1399474920-19147-1-git-send-email-linville@tuxdriver.com> (sfid-20140507_171530_829804_3D9E1F68)
In-Reply-To: <20140507150032.GB20432@tuxdriver.com>
References: <20140507150032.GB20432@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It seems that commit e56cd9618e3e ("wireless-regdb: remove antenna
gain") accidentally dropped anything beyond the first flag in an entry.
Subsequently, commit d806b5e3ba73 ("wireless-regdb: optimize two of
DE's rules"), commit 788445b48c2e ("wireless-regdb: optimize two of
IL's rules"), and commit 13286f2c259b ("wireless-regdb: optimize two
of NL's rules") dutifully combined the newly/incorrectly compatible
rules with their neighbors...

FWIW, this one-liner was used to find the entries that lost flags:

git show e56cd9618e3e | grep -n '^-[^,]*,[^,]*,[^,]*,[^,]*,'

This patch corrects the damage above, including what is essentially
a revert of the latter three commits.

Reported-by: Christian Sünkenberg <christian.suenkenberg@hfg-karlsruhe.de>
Cc: Luis R. Rodriguez <mcgrof@do-not-panic.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 db.txt | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/db.txt b/db.txt
index fcab208d1813..f4749c228cea 100644
--- a/db.txt
+++ b/db.txt
@@ -4,7 +4,7 @@ country 00:
 	# Channel 12 - 13.
 	(2457 - 2482 @ 40), (20), NO-IR
 	# Channel 14. Only JP enables this and for 802.11b only
-	(2474 - 2494 @ 20), (20), NO-IR
+	(2474 - 2494 @ 20), (20), NO-IR, NO-OFDM
 	# Channel 36 - 48
 	(5170 - 5250 @ 80), (20), NO-IR
 	# NB: 5260 MHz - 5700 MHz requies DFS
@@ -207,7 +207,7 @@ country CY: DFS-ETSI
 country CZ: DFS-ETSI
 	(2400 - 2483.5 @ 40), (100 mW)
 	(5150 - 5250 @ 80), (200 mW), NO-OUTDOOR
-	(5250 - 5350 @ 80), (100 mW), NO-OUTDOOR
+	(5250 - 5350 @ 80), (100 mW), NO-OUTDOOR, DFS
 	(5470 - 5725 @ 80), (500 mW), DFS
 	# 60 gHz band channels 1-4, ref: Etsi En 302 567
 	(57240 - 65880 @ 2160), (40), NO-OUTDOOR
@@ -227,8 +227,10 @@ country CZ: DFS-ETSI
 country DE: DFS-ETSI
 	# entries 279004 and 280006
 	(2400 - 2483.5 @ 40), (100 mW)
-	# entry 303005, 304002 and 305002
-	(5150 - 5350 @ 80), (100 mW), NO-OUTDOOR
+	# entry 303005
+	(5150 - 5250 @ 80), (100 mW), NO-OUTDOOR
+	# entries 304002 and 305002
+	(5250 - 5350 @ 80), (100 mW), NO-OUTDOOR, DFS
 	# entries 308002, 309001 and 310003
 	(5470 - 5725 @ 80), (500 mW), DFS
 	# 60 gHz band channels 1-4, ref: Etsi En 302 567
@@ -277,7 +279,7 @@ country EG: DFS-ETSI
 country ES: DFS-ETSI
 	(2400 - 2483.5 @ 40), (100 mW)
 	(5150 - 5250 @ 80), (100 mW), NO-OUTDOOR
-	(5250 - 5350 @ 80), (100 mW), NO-OUTDOOR
+	(5250 - 5350 @ 80), (100 mW), NO-OUTDOOR, DFS
 	(5470 - 5725 @ 80), (500 mW), DFS
 	# 60 gHz band channels 1-4, ref: Etsi En 302 567
 	(57240 - 65880 @ 2160), (40), NO-OUTDOOR
@@ -398,7 +400,8 @@ country IE: DFS-ETSI
 
 country IL: DFS-ETSI
 	(2402 - 2482 @ 40), (20)
-	(5150 - 5350 @ 80), (200 mW), NO-OUTDOOR
+	(5150 - 5250 @ 80), (200 mW), NO-OUTDOOR
+	(5250 - 5350 @ 80), (200 mW), NO-OUTDOOR, DFS
 
 country IN: DFS-JP
 	(2402 - 2482 @ 40), (20)
@@ -574,7 +577,8 @@ country MX: DFS-FCC
 
 country NL: DFS-ETSI
 	(2402 - 2482 @ 40), (20)
-	(5170 - 5330 @ 80), (20), NO-OUTDOOR
+	(5170 - 5250 @ 80), (20), NO-OUTDOOR
+	(5250 - 5330 @ 80), (20), NO-OUTDOOR, DFS
 	(5490 - 5710 @ 80), (27), DFS
 	# 60 gHz band channels 1-4, ref: Etsi En 302 567
 	(57240 - 65880 @ 2160), (40), NO-OUTDOOR
-- 
1.9.0

