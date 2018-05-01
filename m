Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga18.intel.com ([134.134.136.126]:18330 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754623AbeEALi0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 1 May 2018 07:38:26 -0400
From: Haim Dreyfuss <haim.dreyfuss@intel.com>
To: seth.forshee@canonical.com
Cc: wireless-regdb@lists.infradead.org, linux-wireless@vger.kernel.org,
        johannes.berg@intel.com, Haim Dreyfuss <haim.dreyfuss@intel.com>
Subject: [PATCH 1/2] wireless-regdb: Add wmm rule for EEA and EFTA countries
Date: Tue,  1 May 2018 16:36:11 +0300
Message-Id: <1525181772-30337-1-git-send-email-haim.dreyfuss@intel.com> (sfid-20180501_133831_073997_04941103)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The ETSI EN 301 893 v211 (2017-05) standard defines a new channel
access mechanism that all devices (WLAN and LAA) need to comply with.
In previous versions the device was allowed by ETSI to implement
802.11 channel access mechanism based on a set of priority classes
which are taken from 802.11.
According to the new standard there might be some exception
which require the EEA and the EFTA countries, which adhere
ETSI rules, to follow more restrictive rules.
In order to comply with the new standard introduced by ETSI, add
wmmrule global item with the new ETSI channel mechanism rules.
Also add wmmrule flag to EEA and EFTA countries.

Signed-off-by: Haim Dreyfuss <haim.dreyfuss@intel.com>
---
 db.txt | 304 ++++++++++++++++++++++++++++++++++-------------------------------
 1 file changed, 157 insertions(+), 147 deletions(-)

diff --git a/db.txt b/db.txt
index 990abf9..e6cbc35 100644
--- a/db.txt
+++ b/db.txt
@@ -1,3 +1,13 @@
+wmmrule ETSI:
+	vo_c: cw_min=3, cw_max=7, aifsn=2, cot=2
+	vi_c: cw_min=7, cw_max=15, aifsn=2, cot=4
+	be_c: cw_min=15, cw_max=1023, aifsn=3, cot=6
+	bk_c: cw_min=15, cw_max=1023, aifsn=7, cot=6
+	vo_ap: cw_min=3, cw_max=7, aifsn=1, cot=2
+	vi_ap: cw_min=7, cw_max=15, aifsn=1, cot=4
+	be_ap: cw_min=15, cw_max=63, aifsn=3, cot=6
+	bk_ap: cw_min=15, cw_max=1023, aifsn=7, cot=6
+
 # This is the world regulatory domain
 country 00:
 	(2402 - 2472 @ 40), (20)
@@ -19,9 +29,9 @@ country 00:
 
 country AD:
 	(2402 - 2482 @ 40), (20)
-	(5170 - 5250 @ 80), (20)
-	(5250 - 5330 @ 80), (20), DFS
-	(5490 - 5710 @ 80), (27), DFS
+	(5170 - 5250 @ 80), (20), wmmrule=ETSI
+	(5250 - 5330 @ 80), (20), DFS, wmmrule=ETSI
+	(5490 - 5710 @ 80), (27), DFS, wmmrule=ETSI
 	# 60 GHz band channels 1-4, ref: Etsi En 302 567
 	(57000 - 66000 @ 2160), (40)
 
@@ -42,9 +52,9 @@ country AF: DFS-ETSI
 # http://pucanguilla.org/Downloads/January2005-Anguilla%20Table%20of%20Allocations.pdf
 country AI: DFS-ETSI
 	(2402 - 2482 @ 40), (20)
-	(5170 - 5250 @ 80), (20), AUTO-BW
-	(5250 - 5330 @ 80), (20), DFS, AUTO-BW
-	(5490 - 5710 @ 160), (27), DFS
+	(5170 - 5250 @ 80), (20), AUTO-BW, wmmrule=ETSI
+	(5250 - 5330 @ 80), (20), DFS, AUTO-BW, wmmrule=ETSI
+	(5490 - 5710 @ 160), (27), DFS, wmmrule=ETSI
 
 country AL: DFS-ETSI
 	(2402 - 2482 @ 40), (20)
@@ -79,9 +89,9 @@ country AS: DFS-FCC
 
 country AT: DFS-ETSI
 	(2402 - 2482 @ 40), (20)
-	(5170 - 5250 @ 80), (20), AUTO-BW
-	(5250 - 5330 @ 80), (20), DFS, AUTO-BW
-	(5490 - 5710 @ 160), (27), DFS
+	(5170 - 5250 @ 80), (20), AUTO-BW, wmmrule=ETSI
+	(5250 - 5330 @ 80), (20), DFS, AUTO-BW, wmmrule=ETSI
+	(5490 - 5710 @ 160), (27), DFS, wmmrule=ETSI
 	# 60 GHz band channels 1-4, ref: Etsi En 302 567
 	(57000 - 66000 @ 2160), (40)
 
@@ -113,9 +123,9 @@ country AZ: DFS-ETSI
 
 country BA: DFS-ETSI
 	(2402 - 2482 @ 40), (20)
-	(5170 - 5250 @ 80), (20), AUTO-BW
-	(5250 - 5330 @ 80), (20), DFS, AUTO-BW
-	(5490 - 5710 @ 160), (27), DFS
+	(5170 - 5250 @ 80), (20), AUTO-BW, wmmrule=ETSI
+	(5250 - 5330 @ 80), (20), DFS, AUTO-BW, wmmrule=ETSI
+	(5490 - 5710 @ 160), (27), DFS, wmmrule=ETSI
 	# 60 GHz band channels 1-4, ref: Etsi En 302 567
 	(57000 - 66000 @ 2160), (40)
 
@@ -131,9 +141,9 @@ country BD: DFS-JP
 
 country BE: DFS-ETSI
 	(2402 - 2482 @ 40), (20)
-	(5170 - 5250 @ 80), (20), AUTO-BW
-	(5250 - 5330 @ 80), (20), DFS, AUTO-BW
-	(5490 - 5710 @ 160), (27), DFS
+	(5170 - 5250 @ 80), (20), AUTO-BW, wmmrule=ETSI
+	(5250 - 5330 @ 80), (20), DFS, AUTO-BW, wmmrule=ETSI
+	(5490 - 5710 @ 160), (27), DFS, wmmrule=ETSI
 	# 60 GHz band channels 1-4, ref: Etsi En 302 567
 	(57000 - 66000 @ 2160), (40)
 
@@ -163,10 +173,10 @@ country BG: DFS-ETSI
 	(2402 - 2482 @ 40), (20)
 	# 5 GHz Radio Local Area Networks (RLANs), ref:
 	# II.H01 of the List, BDS EN 301 893
-	(5170 - 5250 @ 80), (23), AUTO-BW
-	(5250 - 5330 @ 80), (20), DFS, AUTO-BW
+	(5170 - 5250 @ 80), (23), AUTO-BW, wmmrule=ETSI
+	(5250 - 5330 @ 80), (20), DFS, AUTO-BW, wmmrule=ETSI
 	# II.H01 of the List, I.54 from the List, BDS EN 301 893
-	(5490 - 5710 @ 160), (27), DFS
+	(5490 - 5710 @ 160), (27), DFS, wmmrule=ETSI
 	# Short range devices (SRDs) in the 5725-5875 MHz frequency range, ref:
 	# I.43 of the List, BDS EN 300 440-2, BDS EN 300 440-1
 	(5725 - 5875 @ 80), (14)
@@ -257,9 +267,9 @@ country CF: DFS-FCC
 
 country CH: DFS-ETSI
 	(2402 - 2482 @ 40), (20)
-	(5170 - 5250 @ 80), (20), AUTO-BW
-	(5250 - 5330 @ 80), (20), DFS, AUTO-BW
-	(5490 - 5710 @ 160), (27), DFS
+	(5170 - 5250 @ 80), (20), AUTO-BW, wmmrule=ETSI
+	(5250 - 5330 @ 80), (20), DFS, AUTO-BW, wmmrule=ETSI
+	(5490 - 5710 @ 160), (27), DFS, wmmrule=ETSI
 	# 60 GHz band channels 1-4, ref: Etsi En 302 567
 	(57000 - 66000 @ 2160), (40)
 
@@ -316,9 +326,9 @@ country CX: DFS-FCC
 
 country CY: DFS-ETSI
 	(2402 - 2482 @ 40), (20)
-	(5170 - 5250 @ 80), (20), AUTO-BW
-	(5250 - 5330 @ 80), (20), DFS, AUTO-BW
-	(5490 - 5710 @ 160), (27), DFS
+	(5170 - 5250 @ 80), (20), AUTO-BW, wmmrule=ETSI
+	(5250 - 5330 @ 80), (20), DFS, AUTO-BW, wmmrule=ETSI
+	(5490 - 5710 @ 160), (27), DFS, wmmrule=ETSI
 	# 60 GHz band channels 1-4, ref: Etsi En 302 567
 	(57000 - 66000 @ 2160), (40)
 
@@ -328,9 +338,9 @@ country CY: DFS-ETSI
 # implemented.
 country CZ: DFS-ETSI
 	(2400 - 2483.5 @ 40), (100 mW)
-	(5150 - 5250 @ 80), (200 mW), NO-OUTDOOR, AUTO-BW
-	(5250 - 5350 @ 80), (100 mW), NO-OUTDOOR, DFS, AUTO-BW
-	(5470 - 5725 @ 160), (500 mW), DFS
+	(5150 - 5250 @ 80), (200 mW), NO-OUTDOOR, AUTO-BW, wmmrule=ETSI
+	(5250 - 5350 @ 80), (100 mW), NO-OUTDOOR, DFS, AUTO-BW, wmmrule=ETSI
+	(5470 - 5725 @ 160), (500 mW), DFS, wmmrule=ETSI
 	# 60 GHz band channels 1-4, ref: Etsi En 302 567
 	(57000 - 66000 @ 2160), (40)
 
@@ -363,9 +373,9 @@ country CZ: DFS-ETSI
 
 country DE: DFS-ETSI
 	(2400 - 2483.5 @ 40), (100 mW)
-	(5150 - 5250 @ 80), (100 mW), NO-OUTDOOR, AUTO-BW
-	(5250 - 5350 @ 80), (100 mW), NO-OUTDOOR, DFS, AUTO-BW
-	(5470 - 5725 @ 160), (500 mW), DFS
+	(5150 - 5250 @ 80), (100 mW), NO-OUTDOOR, AUTO-BW, wmmrule=ETSI
+	(5250 - 5350 @ 80), (100 mW), NO-OUTDOOR, DFS, AUTO-BW, wmmrule=ETSI
+	(5470 - 5725 @ 160), (500 mW), DFS, wmmrule=ETSI
 	# short range devices (ETSI EN 300 440-1)
 	(5725 - 5875 @ 80), (25 mW)
 	# 60 GHz band channels 1-4 (ETSI EN 302 567)
@@ -376,9 +386,9 @@ country DE: DFS-ETSI
 # 60GHz: https://erhvervsstyrelsen.dk/sites/default/files/radiograenseflader-63.pdf
 country DK: DFS-ETSI
 	(2400 - 2483.5 @ 40), (20)
-	(5150 - 5250 @ 80), (23), AUTO-BW
-	(5250 - 5350 @ 80), (20), DFS, AUTO-BW
-	(5470 - 5725 @ 160), (27), DFS
+	(5150 - 5250 @ 80), (23), AUTO-BW, wmmrule=ETSI
+	(5250 - 5350 @ 80), (20), DFS, AUTO-BW, wmmrule=ETSI
+	(5470 - 5725 @ 160), (27), DFS, wmmrule=ETSI
 	# 60 GHz band channels 1-4 (ETSI EN 302 567)
 	(57000 - 66000 @ 2160), (40), NO-OUTDOOR
 
@@ -411,9 +421,9 @@ country EC: DFS-FCC
 
 country EE: DFS-ETSI
 	(2402 - 2482 @ 40), (20)
-	(5170 - 5250 @ 80), (20), AUTO-BW
-	(5250 - 5330 @ 80), (20), DFS, AUTO-BW
-	(5490 - 5710 @ 160), (27), DFS
+	(5170 - 5250 @ 80), (20), AUTO-BW, wmmrule=ETSI
+	(5250 - 5330 @ 80), (20), DFS, AUTO-BW, wmmrule=ETSI
+	(5490 - 5710 @ 160), (27), DFS, wmmrule=ETSI
 	# 60 GHz band channels 1-4, ref: Etsi En 302 567
 	(57000 - 66000 @ 2160), (40)
 
@@ -431,9 +441,9 @@ country EG: DFS-ETSI
 
 country ES: DFS-ETSI
 	(2400 - 2483.5 @ 40), (100 mW)
-	(5150 - 5250 @ 80), (200 mW), NO-OUTDOOR, AUTO-BW
-	(5250 - 5350 @ 80), (100 mW), NO-OUTDOOR, DFS, AUTO-BW
-	(5470 - 5725 @ 160), (500 mW), DFS
+	(5150 - 5250 @ 80), (200 mW), NO-OUTDOOR, AUTO-BW, wmmrule=ETSI
+	(5250 - 5350 @ 80), (100 mW), NO-OUTDOOR, DFS, AUTO-BW, wmmrule=ETSI
+	(5470 - 5725 @ 160), (500 mW), DFS, wmmrule=ETSI
 	# Short Range Devices (SRD) (ETSI EN 300 440)
 	(5725 - 5875 @ 80), (25 mW)
 	# 60 GHz band channels 1-4, ref: Etsi En 302 567
@@ -447,9 +457,9 @@ country ET: DFS-ETSI
 
 country FI: DFS-ETSI
 	(2400 - 2483.5 @ 40), (20)
-	(5150 - 5250 @ 80), (23), NO-OUTDOOR, AUTO-BW
-	(5250 - 5350 @ 80), (20), NO-OUTDOOR, DFS, AUTO-BW
-	(5470 - 5725 @ 160), (27), DFS
+	(5150 - 5250 @ 80), (23), NO-OUTDOOR, AUTO-BW, wmmrule=ETSI
+	(5250 - 5350 @ 80), (20), NO-OUTDOOR, DFS, AUTO-BW, wmmrule=ETSI
+	(5470 - 5725 @ 160), (27), DFS, wmmrule=ETSI
 	# 60 GHz band channels 1-4, ref: Etsi En 302 567
 	(57000 - 66000 @ 2160), (40)
 
@@ -462,17 +472,17 @@ country FM: DFS-FCC
 
 country FR: DFS-ETSI
 	(2402 - 2482 @ 40), (20)
-	(5170 - 5250 @ 80), (20), AUTO-BW
-	(5250 - 5330 @ 80), (20), DFS, AUTO-BW
-	(5490 - 5710 @ 160), (27), DFS
+	(5170 - 5250 @ 80), (20), AUTO-BW, wmmrule=ETSI
+	(5250 - 5330 @ 80), (20), DFS, AUTO-BW, wmmrule=ETSI
+	(5490 - 5710 @ 160), (27), DFS, wmmrule=ETSI
 	# 60 GHz band channels 1-4, ref: Etsi En 302 567
 	(57000 - 66000 @ 2160), (40)
 
 country GB: DFS-ETSI
 	(2402 - 2482 @ 40), (20)
-	(5170 - 5250 @ 80), (20), AUTO-BW
-	(5250 - 5330 @ 80), (20), DFS, AUTO-BW
-	(5490 - 5710 @ 160), (27), DFS
+	(5170 - 5250 @ 80), (20), AUTO-BW, wmmrule=ETSI
+	(5250 - 5330 @ 80), (20), DFS, AUTO-BW, wmmrule=ETSI
+	(5490 - 5710 @ 160), (27), DFS, wmmrule=ETSI
 	# 60 GHz band channels 1-4, ref: Etsi En 302 567
 	(57000 - 66000 @ 2160), (40)
 
@@ -492,9 +502,9 @@ country GE: DFS-ETSI
 
 country GF: DFS-ETSI
 	(2402 - 2482 @ 40), (20)
-	(5170 - 5250 @ 80), (20), AUTO-BW
-	(5250 - 5330 @ 80), (20), DFS, AUTO-BW
-	(5490 - 5710 @ 160), (27), DFS
+	(5170 - 5250 @ 80), (20), AUTO-BW, wmmrule=ETSI
+	(5250 - 5330 @ 80), (20), DFS, AUTO-BW, wmmrule=ETSI
+	(5490 - 5710 @ 160), (27), DFS, wmmrule=ETSI
 
 country GH: DFS-FCC
 	(2402 - 2482 @ 40), (20)
@@ -505,21 +515,21 @@ country GH: DFS-FCC
 
 country GL: DFS-ETSI
 	(2402 - 2482 @ 40), (20)
-	(5170 - 5250 @ 80), (20), AUTO-BW
-	(5250 - 5330 @ 80), (20), DFS, AUTO-BW
-	(5490 - 5710 @ 160), (27), DFS
+	(5170 - 5250 @ 80), (20), AUTO-BW, wmmrule=ETSI
+	(5250 - 5330 @ 80), (20), DFS, AUTO-BW, wmmrule=ETSI
+	(5490 - 5710 @ 160), (27), DFS, wmmrule=ETSI
 
 country GP: DFS-ETSI
 	(2402 - 2482 @ 40), (20)
-	(5170 - 5250 @ 80), (20), AUTO-BW
-	(5250 - 5330 @ 80), (20), DFS, AUTO-BW
-	(5490 - 5710 @ 160), (27), DFS
+	(5170 - 5250 @ 80), (20), AUTO-BW, wmmrule=ETSI
+	(5250 - 5330 @ 80), (20), DFS, AUTO-BW, wmmrule=ETSI
+	(5490 - 5710 @ 160), (27), DFS, wmmrule=ETSI
 
 country GR: DFS-ETSI
 	(2402 - 2482 @ 40), (20)
-	(5170 - 5250 @ 80), (20), AUTO-BW
-	(5250 - 5330 @ 80), (20), DFS, AUTO-BW
-	(5490 - 5710 @ 160), (27), DFS
+	(5170 - 5250 @ 80), (20), AUTO-BW, wmmrule=ETSI
+	(5250 - 5330 @ 80), (20), DFS, AUTO-BW, wmmrule=ETSI
+	(5490 - 5710 @ 160), (27), DFS, wmmrule=ETSI
 	# 60 GHz band channels 1-4, ref: Etsi En 302 567
 	(57000 - 66000 @ 2160), (40)
 
@@ -556,9 +566,9 @@ country HN: DFS-FCC
 
 country HR: DFS-ETSI
 	(2400 - 2483.5 @ 40), (20)
-	(5150 - 5250 @ 80), (23), NO-OUTDOOR, AUTO-BW
-	(5250 - 5350 @ 80), (20), NO-OUTDOOR, DFS, AUTO-BW
-	(5470 - 5725 @ 160), (27), DFS
+	(5150 - 5250 @ 80), (23), NO-OUTDOOR, AUTO-BW, wmmrule=ETSI
+	(5250 - 5350 @ 80), (20), NO-OUTDOOR, DFS, AUTO-BW, wmmrule=ETSI
+	(5470 - 5725 @ 160), (27), DFS, wmmrule=ETSI
 	# 60 GHz band channels 1-4, ref: Etsi En 302 567
 	(57000 - 66000 @ 2160), (40)
 
@@ -571,9 +581,9 @@ country HT: DFS-FCC
 
 country HU: DFS-ETSI
 	(2402 - 2482 @ 40), (20)
-	(5170 - 5250 @ 80), (20), AUTO-BW
-	(5250 - 5330 @ 80), (20), DFS, AUTO-BW
-	(5490 - 5710 @ 160), (27), DFS
+	(5170 - 5250 @ 80), (20), AUTO-BW, wmmrule=ETSI
+	(5250 - 5330 @ 80), (20), DFS, AUTO-BW, wmmrule=ETSI
+	(5490 - 5710 @ 160), (27), DFS, wmmrule=ETSI
 	# 60 GHz band channels 1-4, ref: Etsi En 302 567
 	(57000 - 66000 @ 2160), (40)
 
@@ -584,9 +594,9 @@ country ID: DFS-JP
 
 country IE: DFS-ETSI
 	(2402 - 2482 @ 40), (20)
-	(5170 - 5250 @ 80), (20), AUTO-BW
-	(5250 - 5330 @ 80), (20), DFS, AUTO-BW
-	(5490 - 5710 @ 160), (27), DFS
+	(5170 - 5250 @ 80), (20), AUTO-BW, wmmrule=ETSI
+	(5250 - 5330 @ 80), (20), DFS, AUTO-BW, wmmrule=ETSI
+	(5490 - 5710 @ 160), (27), DFS, wmmrule=ETSI
 	# 60 GHz band channels 1-4, ref: Etsi En 302 567
 	(57000 - 66000 @ 2160), (40)
 
@@ -606,17 +616,17 @@ country IR: DFS-JP
 
 country IS: DFS-ETSI
 	(2402 - 2482 @ 40), (20)
-	(5170 - 5250 @ 80), (20), AUTO-BW
-	(5250 - 5330 @ 80), (20), DFS, AUTO-BW
-	(5490 - 5710 @ 160), (27), DFS
+	(5170 - 5250 @ 80), (20), AUTO-BW, wmmrule=ETSI
+	(5250 - 5330 @ 80), (20), DFS, AUTO-BW, wmmrule=ETSI
+	(5490 - 5710 @ 160), (27), DFS, wmmrule=ETSI
 	# 60 GHz band channels 1-4, ref: Etsi En 302 567
 	(57000 - 66000 @ 2160), (40)
 
 country IT: DFS-ETSI
 	(2402 - 2482 @ 40), (20)
-	(5170 - 5250 @ 80), (20), AUTO-BW
-	(5250 - 5330 @ 80), (20), DFS, AUTO-BW
-	(5490 - 5710 @ 160), (27), DFS
+	(5170 - 5250 @ 80), (20), AUTO-BW, wmmrule=ETSI
+	(5250 - 5330 @ 80), (20), DFS, AUTO-BW, wmmrule=ETSI
+	(5490 - 5710 @ 160), (27), DFS, wmmrule=ETSI
 	# 60 GHz band channels 1-4, ref: Etsi En 302 567
 	(57000 - 66000 @ 2160), (40)
 
@@ -721,9 +731,9 @@ country LC: DFS-ETSI
 
 country LI: DFS-ETSI
 	(2402 - 2482 @ 40), (20)
-	(5170 - 5250 @ 80), (20), AUTO-BW
-	(5250 - 5330 @ 80), (20), DFS, AUTO-BW
-	(5490 - 5710 @ 160), (27), DFS
+	(5170 - 5250 @ 80), (20), AUTO-BW, wmmrule=ETSI
+	(5250 - 5330 @ 80), (20), DFS, AUTO-BW, wmmrule=ETSI
+	(5490 - 5710 @ 160), (27), DFS, wmmrule=ETSI
 
 country LK: DFS-FCC
 	(2402 - 2482 @ 40), (20)
@@ -742,25 +752,25 @@ country LS: DFS-ETSI
 
 country LT: DFS-ETSI
 	(2402 - 2482 @ 40), (20)
-	(5170 - 5250 @ 80), (20), AUTO-BW
-	(5250 - 5330 @ 80), (20), DFS, AUTO-BW
-	(5490 - 5710 @ 160), (27), DFS
+	(5170 - 5250 @ 80), (20), AUTO-BW, wmmrule=ETSI
+	(5250 - 5330 @ 80), (20), DFS, AUTO-BW, wmmrule=ETSI
+	(5490 - 5710 @ 160), (27), DFS, wmmrule=ETSI
 	# 60 GHz band channels 1-4, ref: Etsi En 302 567
 	(57000 - 66000 @ 2160), (40)
 
 country LU: DFS-ETSI
 	(2402 - 2482 @ 40), (20)
-	(5170 - 5250 @ 80), (20), AUTO-BW
-	(5250 - 5330 @ 80), (20), DFS, AUTO-BW
-	(5490 - 5710 @ 160), (27), DFS
+	(5170 - 5250 @ 80), (20), AUTO-BW, wmmrule=ETSI
+	(5250 - 5330 @ 80), (20), DFS, AUTO-BW, wmmrule=ETSI
+	(5490 - 5710 @ 160), (27), DFS, wmmrule=ETSI
 	# 60 GHz band channels 1-4, ref: Etsi En 302 567
 	(57000 - 66000 @ 2160), (40)
 
 country LV: DFS-ETSI
 	(2402 - 2482 @ 40), (20)
-	(5170 - 5250 @ 80), (20), AUTO-BW
-	(5250 - 5330 @ 80), (20), DFS, AUTO-BW
-	(5490 - 5710 @ 160), (27), DFS
+	(5170 - 5250 @ 80), (20), AUTO-BW, wmmrule=ETSI
+	(5250 - 5330 @ 80), (20), DFS, AUTO-BW, wmmrule=ETSI
+	(5490 - 5710 @ 160), (27), DFS, wmmrule=ETSI
 	# 60 GHz band channels 1-4, ref: Etsi En 302 567
 	(57000 - 66000 @ 2160), (40)
 
@@ -771,9 +781,9 @@ country MA: DFS-ETSI
 
 country MC: DFS-ETSI
 	(2402 - 2482 @ 40), (20)
-	(5170 - 5250 @ 80), (20), AUTO-BW
-	(5250 - 5330 @ 80), (20), DFS, AUTO-BW
-	(5490 - 5710 @ 160), (27), DFS
+	(5170 - 5250 @ 80), (20), AUTO-BW, wmmrule=ETSI
+	(5250 - 5330 @ 80), (20), DFS, AUTO-BW, wmmrule=ETSI
+	(5490 - 5710 @ 160), (27), DFS, wmmrule=ETSI
 
 # Source:
 # http://www.cnfr.md/index.php?pag=sec&id=117&l=en
@@ -787,15 +797,15 @@ country MD: DFS-ETSI
 # http://www.cept.org/files/1050/Tools%20and%20Services/EFIS%20-%20ECO%20Frequency%20Information%20System/National%20frequency%20tables/Montenegro%20NAFT%20-%202010.pdf
 country ME: DFS-ETSI
 	(2402 - 2482 @ 40), (20)
-	(5170 - 5250 @ 80), (20), AUTO-BW
-	(5250 - 5330 @ 80), (20), DFS, AUTO-BW
-	(5490 - 5710 @ 160), (27), DFS
+	(5170 - 5250 @ 80), (20), AUTO-BW, wmmrule=ETSI
+	(5250 - 5330 @ 80), (20), DFS, AUTO-BW, wmmrule=ETSI
+	(5490 - 5710 @ 160), (27), DFS, wmmrule=ETSI
 
 country MF: DFS-ETSI
 	(2402 - 2482 @ 40), (20)
-	(5170 - 5250 @ 80), (20), AUTO-BW
-	(5250 - 5330 @ 80), (20), DFS, AUTO-BW
-	(5490 - 5710 @ 160), (27), DFS
+	(5170 - 5250 @ 80), (20), AUTO-BW, wmmrule=ETSI
+	(5250 - 5330 @ 80), (20), DFS, AUTO-BW, wmmrule=ETSI
+	(5490 - 5710 @ 160), (27), DFS, wmmrule=ETSI
 
 country MH: DFS-FCC
 	(2402 - 2472 @ 40), (30)
@@ -806,9 +816,9 @@ country MH: DFS-FCC
 
 country MK: DFS-ETSI
 	(2402 - 2482 @ 40), (20)
-	(5170 - 5250 @ 80), (20), AUTO-BW
-	(5250 - 5330 @ 80), (20), DFS, AUTO-BW
-	(5490 - 5710 @ 160), (27), DFS
+	(5170 - 5250 @ 80), (20), AUTO-BW, wmmrule=ETSI
+	(5250 - 5330 @ 80), (20), DFS, AUTO-BW, wmmrule=ETSI
+	(5490 - 5710 @ 160), (27), DFS, wmmrule=ETSI
 	# 60 GHz band channels 1-4, ref: Etsi En 302 567
 	(57000 - 66000 @ 2160), (40)
 
@@ -835,9 +845,9 @@ country MP: DFS-FCC
 
 country MQ: DFS-ETSI
 	(2402 - 2482 @ 40), (20)
-	(5170 - 5250 @ 80), (20), AUTO-BW
-	(5250 - 5330 @ 80), (20), DFS, AUTO-BW
-	(5490 - 5710 @ 160), (27), DFS
+	(5170 - 5250 @ 80), (20), AUTO-BW, wmmrule=ETSI
+	(5250 - 5330 @ 80), (20), DFS, AUTO-BW, wmmrule=ETSI
+	(5490 - 5710 @ 160), (27), DFS, wmmrule=ETSI
 
 # Source:
 # http://www.are.mr/pdfs/telec_freq_TNAbf_2010.pdf
@@ -849,9 +859,9 @@ country MR: DFS-ETSI
 
 country MT: DFS-ETSI
 	(2402 - 2482 @ 40), (20)
-	(5170 - 5250 @ 80), (20), AUTO-BW
-	(5250 - 5330 @ 80), (20), DFS, AUTO-BW
-	(5490 - 5710 @ 160), (27), DFS
+	(5170 - 5250 @ 80), (20), AUTO-BW, wmmrule=ETSI
+	(5250 - 5330 @ 80), (20), DFS, AUTO-BW, wmmrule=ETSI
+	(5490 - 5710 @ 160), (27), DFS, wmmrule=ETSI
 	# 60 GHz band channels 1-4, ref: Etsi En 302 567
 	(57000 - 66000 @ 2160), (40)
 
@@ -909,9 +919,9 @@ country NI: DFS-FCC
 
 country NL: DFS-ETSI
 	(2402 - 2482 @ 40), (20)
-	(5170 - 5250 @ 80), (20), NO-OUTDOOR, AUTO-BW
-	(5250 - 5330 @ 80), (20), NO-OUTDOOR, DFS, AUTO-BW
-	(5490 - 5710 @ 160), (27), DFS
+	(5170 - 5250 @ 80), (20), NO-OUTDOOR, AUTO-BW, wmmrule=ETSI
+	(5250 - 5330 @ 80), (20), NO-OUTDOOR, DFS, AUTO-BW, wmmrule=ETSI
+	(5490 - 5710 @ 160), (27), DFS, wmmrule=ETSI
 	# short range devices (ETSI EN 300 440-1)
 	(5725 - 5875 @ 80), (25 mW)
 	# 60 GHz band channels 1-4, ref: Etsi En 302 567
@@ -924,9 +934,9 @@ country NL: DFS-ETSI
 # which has been merged with 5470 - 5725 MHz to allow wide channels
 country NO: DFS-ETSI
 	(2400 - 2483.5 @ 40), (100 mW)
-	(5150 - 5250 @ 80), (200 mW), AUTO-BW
-	(5250 - 5350 @ 80), (100 mW), DFS, AUTO-BW
-	(5470 - 5795 @ 160), (500 mW), DFS
+	(5150 - 5250 @ 80), (200 mW), AUTO-BW, wmmrule=ETSI
+	(5250 - 5350 @ 80), (100 mW), DFS, AUTO-BW, wmmrule=ETSI
+	(5470 - 5795 @ 160), (500 mW), DFS, wmmrule=ETSI
 	(5815 - 5850 @ 35), (2000 mW), DFS
 	(17100 - 17300 @ 200), (100 mW)
 	# 60 GHz band channels 1-4, ref: Etsi En 302 567
@@ -966,9 +976,9 @@ country PE: DFS-FCC
 
 country PF: DFS-ETSI
 	(2402 - 2482 @ 40), (20)
-	(5170 - 5250 @ 80), (20), AUTO-BW
-	(5250 - 5330 @ 80), (20), DFS, AUTO-BW
-	(5490 - 5710 @ 160), (27), DFS
+	(5170 - 5250 @ 80), (20), AUTO-BW, wmmrule=ETSI
+	(5250 - 5330 @ 80), (20), DFS, AUTO-BW, wmmrule=ETSI
+	(5490 - 5710 @ 160), (27), DFS, wmmrule=ETSI
 
 country PG: DFS-FCC
 	(2402 - 2482 @ 40), (20)
@@ -990,17 +1000,17 @@ country PK: DFS-JP
 
 country PL: DFS-ETSI
 	(2402 - 2482 @ 40), (20)
-	(5170 - 5250 @ 80), (20), AUTO-BW
-	(5250 - 5330 @ 80), (20), DFS, AUTO-BW
-	(5490 - 5710 @ 160), (27), DFS
+	(5170 - 5250 @ 80), (20), AUTO-BW, wmmrule=ETSI
+	(5250 - 5330 @ 80), (20), DFS, AUTO-BW, wmmrule=ETSI
+	(5490 - 5710 @ 160), (27), DFS, wmmrule=ETSI
 	# 60 GHz band channels 1-4, ref: Etsi En 302 567
 	(57000 - 66000 @ 2160), (40)
 
 country PM: DFS-ETSI
 	(2402 - 2482 @ 40), (20)
-	(5170 - 5250 @ 80), (20), AUTO-BW
-	(5250 - 5330 @ 80), (20), DFS, AUTO-BW
-	(5490 - 5710 @ 160), (27), DFS
+	(5170 - 5250 @ 80), (20), AUTO-BW, wmmrule=ETSI
+	(5250 - 5330 @ 80), (20), DFS, AUTO-BW, wmmrule=ETSI
+	(5490 - 5710 @ 160), (27), DFS, wmmrule=ETSI
 
 country PR: DFS-FCC
 	(2402 - 2472 @ 40), (30)
@@ -1011,9 +1021,9 @@ country PR: DFS-FCC
 
 country PT: DFS-ETSI
 	(2402 - 2482 @ 40), (20)
-	(5170 - 5250 @ 80), (20), AUTO-BW
-	(5250 - 5330 @ 80), (20), DFS, AUTO-BW
-	(5490 - 5710 @ 160), (27), DFS
+	(5170 - 5250 @ 80), (20), AUTO-BW, wmmrule=ETSI
+	(5250 - 5330 @ 80), (20), DFS, AUTO-BW, wmmrule=ETSI
+	(5490 - 5710 @ 160), (27), DFS, wmmrule=ETSI
 	# 60 GHz band channels 1-4, ref: Etsi En 302 567
 	(57000 - 66000 @ 2160), (40)
 
@@ -1037,15 +1047,15 @@ country QA: DFS-JP
 
 country RE: DFS-ETSI
 	(2402 - 2482 @ 40), (20)
-	(5170 - 5250 @ 80), (20), AUTO-BW
-	(5250 - 5330 @ 80), (20), DFS, AUTO-BW
-	(5490 - 5710 @ 160), (27), DFS
+	(5170 - 5250 @ 80), (20), AUTO-BW, wmmrule=ETSI
+	(5250 - 5330 @ 80), (20), DFS, AUTO-BW, wmmrule=ETSI
+	(5490 - 5710 @ 160), (27), DFS, wmmrule=ETSI
 
 country RO: DFS-ETSI
 	(2402 - 2482 @ 40), (20)
-	(5170 - 5250 @ 80), (20), AUTO-BW
-	(5250 - 5330 @ 80), (20), DFS, AUTO-BW
-	(5490 - 5710 @ 160), (27), DFS
+	(5170 - 5250 @ 80), (20), AUTO-BW, wmmrule=ETSI
+	(5250 - 5330 @ 80), (20), DFS, AUTO-BW, wmmrule=ETSI
+	(5490 - 5710 @ 160), (27), DFS, wmmrule=ETSI
 	# 60 GHz band channels 1-4, ref: Etsi En 302 567
 	(57000 - 66000 @ 2160), (40)
 
@@ -1083,9 +1093,9 @@ country SA: DFS-ETSI
 
 country SE: DFS-ETSI
 	(2402 - 2482 @ 40), (20)
-	(5170 - 5250 @ 80), (20), AUTO-BW
-	(5250 - 5330 @ 80), (20), DFS, AUTO-BW
-	(5490 - 5710 @ 160), (27), DFS
+	(5170 - 5250 @ 80), (20), AUTO-BW, wmmrule=ETSI
+	(5250 - 5330 @ 80), (20), DFS, AUTO-BW, wmmrule=ETSI
+	(5490 - 5710 @ 160), (27), DFS, wmmrule=ETSI
 	# 60 GHz band channels 1-4, ref: Etsi En 302 567
 	(57000 - 66000 @ 2160), (40)
 
@@ -1103,17 +1113,17 @@ country SG: DFS-FCC
 
 country SI: DFS-ETSI
 	(2402 - 2482 @ 40), (20)
-	(5170 - 5250 @ 80), (20), AUTO-BW
-	(5250 - 5330 @ 80), (20), DFS, AUTO-BW
-	(5490 - 5710 @ 160), (27), DFS
+	(5170 - 5250 @ 80), (20), AUTO-BW, wmmrule=ETSI
+	(5250 - 5330 @ 80), (20), DFS, AUTO-BW, wmmrule=ETSI
+	(5490 - 5710 @ 160), (27), DFS, wmmrule=ETSI
 	# 60 GHz band channels 1-4, ref: Etsi En 302 567
 	(57000 - 66000 @ 2160), (40)
 
 country SK: DFS-ETSI
 	(2402 - 2482 @ 40), (20)
-	(5170 - 5250 @ 80), (20), AUTO-BW
-	(5250 - 5330 @ 80), (20), DFS, AUTO-BW
-	(5490 - 5710 @ 160), (27), DFS
+	(5170 - 5250 @ 80), (20), AUTO-BW, wmmrule=ETSI
+	(5250 - 5330 @ 80), (20), DFS, AUTO-BW, wmmrule=ETSI
+	(5490 - 5710 @ 160), (27), DFS, wmmrule=ETSI
 	# 60 GHz band channels 1-4, ref: Etsi En 302 567
 	(57000 - 66000 @ 2160), (40)
 
@@ -1145,9 +1155,9 @@ country SY:
 # http://www.telecommission.tc/Spectrum-plan20110324-101210.html
 country TC: DFS-FCC
 	(2402 - 2482 @ 40), (20)
-	(5170 - 5250 @ 80), (24), AUTO-BW
-	(5250 - 5330 @ 80), (24), DFS, AUTO-BW
-	(5490 - 5730 @ 160), (24), DFS
+	(5170 - 5250 @ 80), (24), AUTO-BW, wmmrule=ETSI
+	(5250 - 5330 @ 80), (24), DFS, AUTO-BW, wmmrule=ETSI
+	(5490 - 5730 @ 160), (24), DFS, wmmrule=ETSI
 	(5735 - 5835 @ 80), (30)
 
 country TD: DFS-ETSI
@@ -1306,9 +1316,9 @@ country VU: DFS-FCC
 
 country WF: DFS-ETSI
 	(2402 - 2482 @ 40), (20)
-	(5170 - 5250 @ 80), (20), AUTO-BW
-	(5250 - 5330 @ 80), (20), DFS, AUTO-BW
-	(5490 - 5710 @ 160), (27), DFS
+	(5170 - 5250 @ 80), (20), AUTO-BW, wmmrule=ETSI
+	(5250 - 5330 @ 80), (20), DFS, AUTO-BW, wmmrule=ETSI
+	(5490 - 5710 @ 160), (27), DFS, wmmrule=ETSI
 
 country WS: DFS-ETSI
 	(2402 - 2482 @ 40), (20)
@@ -1321,9 +1331,9 @@ country YE:
 
 country YT: DFS-ETSI
 	(2402 - 2482 @ 40), (20)
-	(5170 - 5250 @ 80), (20), AUTO-BW
-	(5250 - 5330 @ 80), (20), DFS, AUTO-BW
-	(5490 - 5710 @ 160), (27), DFS
+	(5170 - 5250 @ 80), (20), AUTO-BW, wmmrule=ETSI
+	(5250 - 5330 @ 80), (20), DFS, AUTO-BW, wmmrule=ETSI
+	(5490 - 5710 @ 160), (27), DFS, wmmrule=ETSI
 
 country ZA: DFS-ETSI
 	(2402 - 2482 @ 40), (20)
-- 
2.7.4
