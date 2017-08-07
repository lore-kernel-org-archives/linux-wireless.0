Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f173.google.com ([209.85.216.173]:36329 "EHLO
        mail-qt0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751442AbdHGIUG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 7 Aug 2017 04:20:06 -0400
Received: by mail-qt0-f173.google.com with SMTP id v29so36360264qtv.3
        for <linux-wireless@vger.kernel.org>; Mon, 07 Aug 2017 01:20:06 -0700 (PDT)
From: Sven Eckelmann <sven.eckelmann@openmesh.com>
To: seth.forshee@canonical.com
Cc: Sven Eckelmann <sven.eckelmann@openmesh.com>,
        wireless-regdb@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: [PATCH] wireless-regdb: Update regulatory rules for Singapore (SG)
Date: Mon,  7 Aug 2017 10:19:50 +0200
Message-Id: <20170807081950.13327-1-sven.eckelmann@openmesh.com> (sfid-20170807_102012_167921_7509EABA)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2.4GHz and the lower 5GHz band can now be use with up to 23dBm. But the DFS
channels in general require TPC to be usable. Only 5150 - 5250 has an
exception which allows the use of it without TPC when reducing the power to
20 dBm.

Signed-off-by: Sven Eckelmann <sven.eckelmann@openmesh.com>
---
Please check this twice because this is my first attempt in converting an
official regulatory document to an wireless-regdb entry.

 db.txt | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/db.txt b/db.txt
index 0bc068e..df30f37 100644
--- a/db.txt
+++ b/db.txt
@@ -1078,12 +1078,17 @@ country SE: DFS-ETSI
 	# 60 GHz band channels 1-4, ref: Etsi En 302 567
 	(57000 - 66000 @ 2160), (40)
 
+# Source
+# https://www.imda.gov.sg/~/media/imda/files/regulation%20licensing%20and%20consultations/ict%20standards/telecommunication%20standards/radio-comms/imdatssrd.pdf?la=en
+# page 12-14
+# The EIRP for 5250 – 5350 can be increased by 3dB if TPC is implemented.
 country SG: DFS-FCC
-	(2402 - 2482 @ 40), (20)
-	(5170 - 5250 @ 80), (17), AUTO-BW
-	(5250 - 5330 @ 80), (24), DFS, AUTO-BW
-	(5490 - 5730 @ 160), (24), DFS
-	(5735 - 5835 @ 80), (30)
+	(2400 - 2483.5 @ 40), (23)
+	(5150 - 5250 @ 80), (23), AUTO-BW
+	(5250 - 5350 @ 80), (20), DFS, AUTO-BW
+	# 5470 - 5725 is only allowed when TPC is implemented
+	# (5470 - 5725 @ 160), (30), DFS
+	(5725 - 5850 @ 80), (30)
 
 country SI: DFS-ETSI
 	(2402 - 2482 @ 40), (20)
-- 
2.11.0
