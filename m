Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:64572 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753075Ab3KANzi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Nov 2013 09:55:38 -0400
Received: by mail-we0-f174.google.com with SMTP id u56so4026531wes.33
        for <linux-wireless@vger.kernel.org>; Fri, 01 Nov 2013 06:55:36 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, wireless-regdb@lists.infradead.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 1/8] wireless-regdb: consolidate passive-scan and no-ibss flags
Date: Fri,  1 Nov 2013 14:55:24 +0100
Message-Id: <1383314131-20774-2-git-send-email-mcgrof@do-not-panic.com> (sfid-20131101_145541_128985_525A7150)
In-Reply-To: <1383314131-20774-1-git-send-email-mcgrof@do-not-panic.com>
References: <1383314131-20774-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These are used interchangeably so just do away
with the redundancy.

Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 db.txt     | 8 ++++----
 dbparse.py | 4 ++--
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/db.txt b/db.txt
index d0d1a3f..b8ddb1b 100644
--- a/db.txt
+++ b/db.txt
@@ -2,14 +2,14 @@
 country 00:
 	(2402 - 2472 @ 40), (3, 20)
 	# Channel 12 - 13.
-	(2457 - 2482 @ 40), (3, 20), PASSIVE-SCAN, NO-IBSS
+	(2457 - 2482 @ 40), (3, 20), NO-IR
 	# Channel 14. Only JP enables this and for 802.11b only
-	(2474 - 2494 @ 20), (3, 20), PASSIVE-SCAN, NO-IBSS, NO-OFDM
+	(2474 - 2494 @ 20), (3, 20), NO-IR, NO-OFDM
 	# Channel 36 - 48
-	(5170 - 5250 @ 80), (3, 20), PASSIVE-SCAN, NO-IBSS
+	(5170 - 5250 @ 80), (3, 20), NO-IR
 	# NB: 5260 MHz - 5700 MHz requies DFS
 	# Channel 149 - 165
-	(5735 - 5835 @ 80), (3, 20), PASSIVE-SCAN, NO-IBSS
+	(5735 - 5835 @ 80), (3, 20), NO-IR
 	# IEEE 802.11ad (60GHz), channels 1..3
 	(57240 - 63720 @ 2160), (N/A, 0)
 
diff --git a/dbparse.py b/dbparse.py
index 32cbce9..29eb9d6 100755
--- a/dbparse.py
+++ b/dbparse.py
@@ -12,8 +12,8 @@ flag_definitions = {
     'DFS':		1<<4,
     'PTP-ONLY':		1<<5,
     'PTMP-ONLY':	1<<6,
-    'PASSIVE-SCAN':	1<<7,
-    'NO-IBSS':		1<<8,
+    'NO-IR':	        1<<7,
+    # hole at bit 8
     # hole at bit 9. FIXME: Where is NO-HT40 defined?
     'NO-HT40':		1<<10,
 }
-- 
1.8.4.rc3

