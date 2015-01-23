Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:3047 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750870AbbAWLvj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jan 2015 06:51:39 -0500
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: Seth Forshee <seth.forshee@canonical.com>
CC: <wireless-regdb@lists.infradead.org>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH] wireless-regdb: Disable VHT80 where 40/80 MHz on 5 GHz is not allowed
Date: Fri, 23 Jan 2015 13:51:12 +0200
Message-ID: <1422013872-9732-1-git-send-email-jouni@qca.qualcomm.com> (sfid-20150123_125143_123549_72FE920B)
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

VHT80 was incorrectly enabled for number of countries.

40 and 80 MHz channels are not allowed on 5 GHz for these:
- Armenia (AM)
- Bahrain (BH)
- Costa Rica (CR)
- Ecuador (EC)
- Guam (GU)
- Indonesia (ID) (also remove 40 MHz from 2.4 GHz)
- North Korea (KP)
- Sri Lanka (LK)
- El Salvador (SV)

80 MHz channels are not allowed on 5 GHz for these:
- Egypt (EG)
- Russia (RU)

Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>
---
 db.txt | 74 +++++++++++++++++++++++++++++++++---------------------------------
 1 file changed, 37 insertions(+), 37 deletions(-)

diff --git a/db.txt b/db.txt
index df7f7b1..ae8a216 100644
--- a/db.txt
+++ b/db.txt
@@ -54,8 +54,8 @@ country AL: DFS-ETSI
 
 country AM: DFS-ETSI
 	(2402 - 2482 @ 40), (20)
-	(5170 - 5250 @ 80), (18)
-	(5250 - 5330 @ 80), (18), DFS
+	(5170 - 5250 @ 20), (18)
+	(5250 - 5330 @ 20), (18), DFS
 
 country AN: DFS-ETSI
 	(2402 - 2482 @ 40), (20)
@@ -146,9 +146,9 @@ country BG: DFS-ETSI
 
 country BH: DFS-JP
 	(2402 - 2482 @ 40), (20)
-	(5170 - 5250 @ 80), (20)
-	(5250 - 5330 @ 80), (20), DFS
-	(5735 - 5835 @ 80), (20)
+	(5170 - 5250 @ 20), (20)
+	(5250 - 5330 @ 20), (20), DFS
+	(5735 - 5835 @ 20), (20)
 
 country BL: DFS-ETSI
 	(2402 - 2482 @ 40), (20)
@@ -263,10 +263,10 @@ country CO: DFS-FCC
 
 country CR: DFS-FCC
 	(2402 - 2482 @ 40), (20)
-	(5170 - 5250 @ 80), (17)
-	(5250 - 5330 @ 80), (24), DFS
-	(5490 - 5730 @ 80), (24), DFS
-	(5735 - 5835 @ 80), (30)
+	(5170 - 5250 @ 20), (17)
+	(5250 - 5330 @ 20), (24), DFS
+	(5490 - 5730 @ 20), (24), DFS
+	(5735 - 5835 @ 20), (30)
 
 country CX: DFS-FCC
 	(2402 - 2482 @ 40), (20)
@@ -349,10 +349,10 @@ country DZ: DFS-JP
 
 country EC: DFS-FCC
 	(2402 - 2482 @ 40), (20)
-	(5170 - 5250 @ 80), (17)
-	(5250 - 5330 @ 80), (24), DFS
-	(5490 - 5730 @ 80), (24), DFS
-	(5735 - 5835 @ 80), (30)
+	(5170 - 5250 @ 20), (17)
+	(5250 - 5330 @ 20), (24), DFS
+	(5490 - 5730 @ 20), (24), DFS
+	(5735 - 5835 @ 20), (30)
 
 country EE: DFS-ETSI
 	(2402 - 2482 @ 40), (20)
@@ -364,8 +364,8 @@ country EE: DFS-ETSI
 
 country EG: DFS-ETSI
 	(2402 - 2482 @ 40), (20)
-	(5170 - 5250 @ 80), (20)
-	(5250 - 5330 @ 80), (20), DFS
+	(5170 - 5250 @ 40), (20)
+	(5250 - 5330 @ 40), (20), DFS
 
 # Orden IET/787/2013, de 25 de abril, por la que se aprueba
 # el cuadro nacional de atribución de frecuencias.
@@ -474,10 +474,10 @@ country GT: DFS-FCC
 
 country GU: DFS-FCC
 	(2402 - 2472 @ 40), (30)
-	(5170 - 5250 @ 80), (17)
-	(5250 - 5330 @ 80), (24), DFS
-	(5490 - 5730 @ 80), (24), DFS
-	(5735 - 5835 @ 80), (30)
+	(5170 - 5250 @ 20), (17)
+	(5250 - 5330 @ 20), (24), DFS
+	(5490 - 5730 @ 20), (24), DFS
+	(5735 - 5835 @ 20), (30)
 
 country GY:
 	(2402 - 2482 @ 40), (30)
@@ -522,8 +522,8 @@ country HU: DFS-ETSI
 
 country ID: DFS-JP
 	# ref: http://www.postel.go.id/content/ID/regulasi/standardisasi/kepdir/bwa%205,8%20ghz.pdf
-	(2402 - 2482 @ 40), (20)
-	(5735 - 5815 @ 80), (23)
+	(2402 - 2482 @ 20), (20)
+	(5735 - 5815 @ 20), (23)
 
 country IE: DFS-ETSI
 	(2402 - 2482 @ 40), (20)
@@ -607,11 +607,11 @@ country KN: DFS-ETSI
 	(5735 - 5815 @ 80), (30)
 
 country KP: DFS-JP
-	(2402 - 2482 @ 40), (20)
-	(5170 - 5250 @ 80), (20), AUTO-BW
-	(5250 - 5330 @ 80), (20), DFS, AUTO-BW
-	(5490 - 5630 @ 80), (30), DFS
-	(5735 - 5815 @ 80), (30)
+	(2402 - 2482 @ 20), (20)
+	(5170 - 5250 @ 20), (20)
+	(5250 - 5330 @ 20), (20), DFS
+	(5490 - 5630 @ 20), (30), DFS
+	(5735 - 5815 @ 20), (30)
 
 country KR: DFS-JP
 	(2402 - 2482 @ 40), (20)
@@ -659,10 +659,10 @@ country LI: DFS-ETSI
 
 country LK: DFS-FCC
 	(2402 - 2482 @ 40), (20)
-	(5170 - 5250 @ 80), (17)
-	(5250 - 5330 @ 80), (24), DFS
-	(5490 - 5730 @ 80), (24), DFS
-	(5735 - 5835 @ 80), (30)
+	(5170 - 5250 @ 20), (17)
+	(5250 - 5330 @ 20), (24), DFS
+	(5490 - 5730 @ 20), (24), DFS
+	(5735 - 5835 @ 20), (30)
 
 # Source:
 # http://lca.org.ls/images/documents/lesotho_national_frequency_allocation_plan.pdf
@@ -971,10 +971,10 @@ country RS: DFS-ETSI
 
 country RU: DFS-ETSI
 	(2402 - 2482 @ 40), (20)
-	(5170 - 5250 @ 80), (20)
-	(5250 - 5330 @ 80), (20), DFS
-	(5650 - 5730 @ 80), (30), DFS
-	(5735 - 5835 @ 80), (30)
+	(5170 - 5250 @ 40), (20)
+	(5250 - 5330 @ 40), (20), DFS
+	(5650 - 5730 @ 40), (30), DFS
+	(5735 - 5835 @ 40), (30)
 
 country RW: DFS-FCC
 	(2402 - 2482 @ 40), (20)
@@ -1037,9 +1037,9 @@ country SR: DFS-ETSI
 
 country SV: DFS-FCC
 	(2402 - 2482 @ 40), (20)
-	(5170 - 5250 @ 80), (17)
-	(5250 - 5330 @ 80), (23), DFS
-	(5735 - 5835 @ 80), (30)
+	(5170 - 5250 @ 20), (17)
+	(5250 - 5330 @ 20), (23), DFS
+	(5735 - 5835 @ 20), (30)
 
 country SY:
 	(2402 - 2482 @ 40), (20)
-- 
1.9.1

