Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:38215 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750856AbbJMSb6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Oct 2015 14:31:58 -0400
Received: by wieq12 with SMTP id q12so45987164wie.1
        for <linux-wireless@vger.kernel.org>; Tue, 13 Oct 2015 11:31:57 -0700 (PDT)
From: Andrej Vlasic <andrej.vlasic0@gmail.com>
To: seth.forshee@canonical.com
Cc: wireless-regdb@lists.infradead.org, linux-wireless@vger.kernel.org,
	Andrej Vlasic <andrej.vlasic0@gmail.com>
Subject: [PATCH] wireless-regdb: Update regulatory rules for Croatia (HR)
Date: Tue, 13 Oct 2015 20:31:24 +0200
Message-Id: <1444761084-4399-1-git-send-email-andrej.vlasic0@gmail.com> (sfid-20151013_203201_628828_C9584B00)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Update frequency allocation rules to mach data from table [1].

Also increase allowed power limit for range 5150-5250 Mhz to 200mW.

[1] http://tablice.hakom.hr:8280/vis?lang=en

Signed-off-by: Andrej Vlasic <andrej.vlasic0@gmail.com>
---
 db.txt | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/db.txt b/db.txt
index d57ea84..3b36616 100644
--- a/db.txt
+++ b/db.txt
@@ -504,11 +504,17 @@ country HN: DFS-FCC
 	(5490 - 5730 @ 160), (24), DFS
 	(5735 - 5835 @ 80), (30)
 
+# Data from table of frequency allocations: http://tablice.hakom.hr:8280/vis?lang=en
+# For 5ghz range see http://www.hakom.hr/UserDocsImages/op%C4%87e%20dozvole%20prosinac%202009.g/Opca_dozvola_85.pdf
+# and http://www.hakom.hr/UserDocsImages/op%C4%87e%20dozvole%20prosinac%202009.g/Opca_dozvola_86.pdf
+# and http://www.hakom.hr/UserDocsImages/op%C4%87e%20dozvole%20prosinac%202009.g/Opca_dozvola_87.pdf
+# TPC devices on range 5250-5350 can use 200mW, and 1W on range 5470-5725.
+
 country HR: DFS-ETSI
-	(2402 - 2482 @ 40), (20)
-	(5170 - 5250 @ 80), (20), AUTO-BW
-	(5250 - 5330 @ 80), (20), DFS, AUTO-BW
-	(5490 - 5710 @ 160), (27), DFS
+	(2400 - 2483.5 @ 40), (100 mW)
+	(5150 - 5250 @ 80), (200 mW), NO-OUTDOOR, AUTO-BW
+	(5250 - 5350 @ 80), (100 mW), NO-OUTDOOR, DFS, AUTO-BW
+	(5470 - 5725 @ 160), (500 mW), DFS
 	# 60 gHz band channels 1-4, ref: Etsi En 302 567
 	(57000 - 66000 @ 2160), (40)
 
-- 
2.6.1

