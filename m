Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:57124 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750780AbdJYErc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 25 Oct 2017 00:47:32 -0400
Received: by mail-pg0-f66.google.com with SMTP id m18so16347368pgd.13
        for <linux-wireless@vger.kernel.org>; Tue, 24 Oct 2017 21:47:31 -0700 (PDT)
From: Ryan Mounce <ryan@mounce.com.au>
To: seth.forshee@canonical.com
Cc: wireless-regdb@lists.infradead.org, linux-wireless@vger.kernel.org,
        Ryan Mounce <ryan@mounce.com.au>
Subject: [PATCH] wireless-regdb: convert remaining values in mW to equivalent dBm
Date: Wed, 25 Oct 2017 15:15:39 +1030
Message-Id: <20171025044539.17877-1-ryan@mounce.com.au> (sfid-20171025_064738_336787_9E6D9F12)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch converts the few remaining rules specified in mW to directly
equivalent rules in dBm, to improve consistency of the regdb.

Signed-off-by: Ryan Mounce <ryan@mounce.com.au>
---
 db.txt | 64 ++++++++++++++++++++++++++++++++--------------------------------
 1 file changed, 32 insertions(+), 32 deletions(-)

diff --git a/db.txt b/db.txt
index 9d129f2..8ea5a66 100644
--- a/db.txt
+++ b/db.txt
@@ -305,7 +305,7 @@ country CR: DFS-FCC
 # - Redes Informáticas
 # Resolución 127, 2011 - Reglamento Banda 2,4 GHz.
 country CU: DFS-FCC
-	(2400 - 2483.5 @ 40), (200 mW)
+	(2400 - 2483.5 @ 40), (23)
 
 country CX: DFS-FCC
 	(2402 - 2482 @ 40), (20)
@@ -327,10 +327,10 @@ country CY: DFS-ETSI
 # Power at 5250 - 5350 MHz and 5470 - 5725 MHz can be doubled if TPC is
 # implemented.
 country CZ: DFS-ETSI
-	(2400 - 2483.5 @ 40), (100 mW)
-	(5150 - 5250 @ 80), (200 mW), NO-OUTDOOR, AUTO-BW
-	(5250 - 5350 @ 80), (100 mW), NO-OUTDOOR, DFS, AUTO-BW
-	(5470 - 5725 @ 160), (500 mW), DFS
+	(2400 - 2483.5 @ 40), (20)
+	(5150 - 5250 @ 80), (23), NO-OUTDOOR, AUTO-BW
+	(5250 - 5350 @ 80), (20), NO-OUTDOOR, DFS, AUTO-BW
+	(5470 - 5725 @ 160), (27), DFS
 	# 60 GHz band channels 1-4, ref: Etsi En 302 567
 	(57000 - 66000 @ 2160), (40)
 
@@ -362,12 +362,12 @@ country CZ: DFS-ETSI
 # https://www.bundesnetzagentur.de/SharedDocs/Downloads/DE/Sachgebiete/Telekommunikation/Unternehmen_Institutionen/Frequenzen/Allgemeinzuteilungen/2011_08_MGWS_pdf.pdf
 
 country DE: DFS-ETSI
-	(2400 - 2483.5 @ 40), (100 mW)
-	(5150 - 5250 @ 80), (100 mW), NO-OUTDOOR, AUTO-BW
-	(5250 - 5350 @ 80), (100 mW), NO-OUTDOOR, DFS, AUTO-BW
-	(5470 - 5725 @ 160), (500 mW), DFS
+	(2400 - 2483.5 @ 40), (20)
+	(5150 - 5250 @ 80), (20), NO-OUTDOOR, AUTO-BW
+	(5250 - 5350 @ 80), (20), NO-OUTDOOR, DFS, AUTO-BW
+	(5470 - 5725 @ 160), (27), DFS
 	# short range devices (ETSI EN 300 440-1)
-	(5725 - 5875 @ 80), (25 mW)
+	(5725 - 5875 @ 80), (14)
 	# 60 GHz band channels 1-4 (ETSI EN 302 567)
 	(57000 - 66000 @ 2160), (40)
 
@@ -427,12 +427,12 @@ country EG: DFS-ETSI
 # http://www.minetur.gob.es/telecomunicaciones/espectro/paginas/cnaf.aspx
 
 country ES: DFS-ETSI
-	(2400 - 2483.5 @ 40), (100 mW)
-	(5150 - 5250 @ 80), (200 mW), NO-OUTDOOR, AUTO-BW
-	(5250 - 5350 @ 80), (100 mW), NO-OUTDOOR, DFS, AUTO-BW
-	(5470 - 5725 @ 160), (500 mW), DFS
+	(2400 - 2483.5 @ 40), (20)
+	(5150 - 5250 @ 80), (23), NO-OUTDOOR, AUTO-BW
+	(5250 - 5350 @ 80), (20), NO-OUTDOOR, DFS, AUTO-BW
+	(5470 - 5725 @ 160), (27), DFS
 	# Short Range Devices (SRD) (ETSI EN 300 440)
-	(5725 - 5875 @ 80), (25 mW)
+	(5725 - 5875 @ 80), (14)
 	# 60 GHz band channels 1-4, ref: Etsi En 302 567
 	(57000 - 66000 @ 2160), (40)
 
@@ -589,8 +589,8 @@ country IE: DFS-ETSI
 
 country IL: DFS-ETSI
 	(2402 - 2482 @ 40), (20)
-	(5150 - 5250 @ 80), (200 mW), NO-OUTDOOR, AUTO-BW
-	(5250 - 5350 @ 80), (200 mW), NO-OUTDOOR, DFS, AUTO-BW
+	(5150 - 5250 @ 80), (23), NO-OUTDOOR, AUTO-BW
+	(5250 - 5350 @ 80), (23), NO-OUTDOOR, DFS, AUTO-BW
 
 country IN:
 	(2402 - 2482 @ 40), (20)
@@ -639,7 +639,7 @@ country JP: DFS-JP
 	(5490 - 5710 @ 160), (23), DFS
 	# 60 GHz band channels 2-4 at 10mW,
 	# ref: http://www.arib.or.jp/english/html/overview/doc/1-STD-T74v1_1.pdf
-	(59000 - 66000 @ 2160), (10 mW)
+	(59000 - 66000 @ 2160), (10)
 
 country KE: DFS-JP
 	(2402 - 2482 @ 40), (20)
@@ -856,10 +856,10 @@ country MU: DFS-FCC
 # Source:
 # http://www.cam.gov.mv/docs/tech_standards/TAM-TS-100-2004-WLAN.pdf
 country MV: DFS-ETSI
-	(2400 - 2483.5 @ 40), (100 mW)
-	(5150 - 5250 @ 80), (200 mW), AUTO-BW
-	(5250 - 5350 @ 80), (100 mW), DFS, AUTO-BW
-	(5725 - 5850 @ 80), (100 mW)
+	(2400 - 2483.5 @ 40), (20)
+	(5150 - 5250 @ 80), (23), AUTO-BW
+	(5250 - 5350 @ 80), (20), DFS, AUTO-BW
+	(5725 - 5850 @ 80), (20)
 
 country MW: DFS-ETSI
 	(2402 - 2482 @ 40), (20)
@@ -904,7 +904,7 @@ country NL: DFS-ETSI
 	(5250 - 5330 @ 80), (20), NO-OUTDOOR, DFS, AUTO-BW
 	(5490 - 5710 @ 160), (27), DFS
 	# short range devices (ETSI EN 300 440-1)
-	(5725 - 5875 @ 80), (25 mW)
+	(5725 - 5875 @ 80), (14)
 	# 60 GHz band channels 1-4, ref: Etsi En 302 567
 	(57000 - 66000 @ 2160), (40)
 
@@ -914,12 +914,12 @@ country NL: DFS-ETSI
 # Up to 2W (or 4W with TPC) is allowed in the 5725 – 5795 MHz band
 # which has been merged with 5470 - 5725 MHz to allow wide channels
 country NO: DFS-ETSI
-	(2400 - 2483.5 @ 40), (100 mW)
-	(5150 - 5250 @ 80), (200 mW), AUTO-BW
-	(5250 - 5350 @ 80), (100 mW), DFS, AUTO-BW
-	(5470 - 5795 @ 160), (500 mW), DFS
-	(5815 - 5850 @ 35), (2000 mW), DFS
-	(17100 - 17300 @ 200), (100 mW)
+	(2400 - 2483.5 @ 40), (20)
+	(5150 - 5250 @ 80), (23), AUTO-BW
+	(5250 - 5350 @ 80), (20), DFS, AUTO-BW
+	(5470 - 5795 @ 160), (27), DFS
+	(5815 - 5850 @ 35), (33), DFS
+	(17100 - 17300 @ 200), (20)
 	# 60 GHz band channels 1-4, ref: Etsi En 302 567
 	(57000 - 66000 @ 2160), (40)
 
@@ -1044,9 +1044,9 @@ country RO: DFS-ETSI
 # Source:
 # http://www.ratel.rs/upload/documents/Plan_namene/Plan_namene-sl_glasnik.pdf
 country RS: DFS-ETSI
-	(2400 - 2483.5 @ 40), (100 mW)
-	(5150 - 5350 @ 40), (200 mW), NO-OUTDOOR
-	(5470 - 5725 @ 20), (1000 mW), DFS
+	(2400 - 2483.5 @ 40), (20)
+	(5150 - 5350 @ 40), (23), NO-OUTDOOR
+	(5470 - 5725 @ 20), (30), DFS
 	# 60 GHz band channels 1-4, ref: Etsi En 302 567
 	(57000 - 66000 @ 2160), (40)
 
-- 
2.13.5 (Apple Git-94)
