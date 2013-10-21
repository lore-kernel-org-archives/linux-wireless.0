Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:60373 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751140Ab3JURly (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Oct 2013 13:41:54 -0400
Received: by mail-wi0-f173.google.com with SMTP id ey11so4353146wid.6
        for <linux-wireless@vger.kernel.org>; Mon, 21 Oct 2013 10:41:53 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, janusz.dziedzic@tieto.com,
	smihir@qti.qualcomm.com, tushnimb@qca.qualcomm.com,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH] wireless-regdb: consolidate passive-scan and no-ibss flags
Date: Mon, 21 Oct 2013 19:41:49 +0200
Message-Id: <1382377309-26349-1-git-send-email-mcgrof@do-not-panic.com> (sfid-20131021_194208_666220_D59906AC)
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

