Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ee.oulu.fi ([130.231.61.23]:59452 "EHLO ees2.oulu.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754317Ab0EYNrv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 May 2010 09:47:51 -0400
Date: Tue, 25 May 2010 16:20:35 +0300
From: Pekka Pietikainen <pp@ee.oulu.fi>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Subject: wireless-regdb: FI/CZ updates
Message-ID: <20100525132035.GA863@ee.oulu.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Was looking at the relevant local regulations and noticed the regdb allowed 
less power at 5GHz than is actually allowed. Until I found the "If you don't do TPC you have 
to reduce your power by 3dB sometimes" bit on the next page.

And looks like someone that did the entry for CZ fell into the same trap, they have

"stations in the c and d bands must employ automatic transmitter power
control, which provides, on average, an interference mitigation factor at
least 3 dB on the maximum permitted output power of the systems.  If
automatic power control is not employed, the maximum permitted mean e.i.r.p. 
and the corresponding limit of the mean e.i.r.p.  density for bands c and d
must be reduced by 3 dB;"

Please sanity check, I became very confused while looking into this.
(like some places starting their freq ranges at 2400, others at 2402. Didn't
touch those, regs say 2400-2485,5, 5150-5250, 5250-5350 and 5470-5725)

Signed-off-by: Pekka Pietikäinen <pp@ee.oulu.fi>
diff -up ./db.txt.orig ./db.txt
--- ./db.txt.orig	2010-05-25 15:03:48.812116854 +0300
+++ ./db.txt	2010-05-25 15:58:43.947117884 +0300
@@ -170,11 +170,13 @@ country CY:
 
 # Data from http://www.ctu.eu/164/download/VOR/VOR-12-08-2005-34.pdf
 # and http://www.ctu.eu/164/download/VOR/VOR-12-05-2007-6-AN.pdf
+# Power at 5250 - 5350 MHz and 5470 - 5725 MHz can be doubled if TPC is 
+# implemented.
 country CZ:
 	(2400 - 2483.5 @ 40), (N/A, 100 mW)
 	(5150 - 5250 @ 40), (N/A, 200 mW), NO-OUTDOOR
-	(5250 - 5350 @ 40), (N/A, 200 mW), NO-OUTDOOR, DFS
-	(5470 - 5725 @ 40), (N/A, 1000 mW), DFS
+	(5250 - 5350 @ 40), (N/A, 100 mW), NO-OUTDOOR, DFS
+	(5470 - 5725 @ 40), (N/A, 500 mW), DFS
 
 # Data from "Frequenznutzungsplan" (as published in April 2008),
 # downloaded from http://www.bundesnetzagentur.de/media/archive/13358.pdf
@@ -226,11 +228,15 @@ country ES:
 	(5250 - 5330 @ 40), (N/A, 20), DFS
 	(5490 - 5710 @ 40), (N/A, 27), DFS
 
+# Data from FICORA Regulation 15Z / 2009 M
+# http://www.ficora.fi/attachments/suomiry/5l1x1FIIk/Viestintavirasto15Z2009M.pdf
+# Power at 5250 - 5350 MHz and 5470 - 5725 MHz can be doubled if TPC is 
+# implemented.
 country FI:
-	(2402 - 2482 @ 40), (N/A, 20)
-	(5170 - 5250 @ 40), (N/A, 20)
-	(5250 - 5330 @ 40), (N/A, 20), DFS
-	(5490 - 5710 @ 40), (N/A, 27), DFS
+	(2402 - 2482 @ 40), (N/A, 100mW)
+	(5170 - 5250 @ 40), (N/A, 200mW), NO-OUTDOOR
+	(5250 - 5330 @ 40), (N/A, 100mW), NO-OUTDOOR, DFS
+	(5490 - 5710 @ 40), (N/A, 500mW), DFS
 
 country FR:
 	(2402 - 2482 @ 40), (N/A, 20)
