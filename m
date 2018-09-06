Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr1-f67.google.com ([209.85.221.67]:40912 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728905AbeIFStK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 6 Sep 2018 14:49:10 -0400
Received: by mail-wr1-f67.google.com with SMTP id n2-v6so11595532wrw.7
        for <linux-wireless@vger.kernel.org>; Thu, 06 Sep 2018 07:13:25 -0700 (PDT)
To: seth.forshee@canonical.com
Cc: linux-wireless@vger.kernel.org, wireless-regdb@lists.infradead.org
From: Henrik Laxhuber <henrik@laxhuber.com>
Subject: [PATCH] wireless-regdb: update regulatory rules for Switzerland (CH),
 and Liechtenstein (LI) on 5GHz
Message-ID: <2441d0ea-b862-9675-9342-356606d9228d@laxhuber.com> (sfid-20180906_161332_896727_4219C43C)
Date: Thu, 6 Sep 2018 16:13:22 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Update to reflect the current data published in the 'National Frequency
Allocation Strategy Table' [0] for Switzerland and Liechtenstein, which
at the time of writing points to the documents [1] and [2].

[0] https://www.ofcomnet.ch/#/fatTable
[1] https://www.ofcomnet.ch/api/rir/1010/05
[2] https://www.ofcomnet.ch/api/rir/1010/04

Signed-off-by: Henrik Laxhuber <henrik@laxhuber.com>
---
  db.txt | 19 +++++++++++++++----
  1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/db.txt b/db.txt
index 8cf7dee..69cea85 100644
--- a/db.txt
+++ b/db.txt
@@ -265,10 +265,14 @@ country CF: DFS-FCC
      (5490 - 5730 @ 40), (24), DFS
      (5735 - 5835 @ 40), (30)

+# Source:
+# https://www.ofcomnet.ch/#/fatTable
+# Note that the maximum transmitter power can be doubled for 
5250-5710MHz if
+# transmitter power control is in use: 5250-5330@23db, 5490-5710@30db
  country CH: DFS-ETSI
      (2402 - 2482 @ 40), (20)
-    (5170 - 5250 @ 80), (20), AUTO-BW, wmmrule=ETSI
-    (5250 - 5330 @ 80), (20), DFS, AUTO-BW, wmmrule=ETSI
+    (5170 - 5250 @ 80), (23), NO-OUTDOOR, AUTO-BW, wmmrule=ETSI
+    (5250 - 5330 @ 80), (20), NO-OUTDOOR, DFS, AUTO-BW, wmmrule=ETSI
      (5490 - 5710 @ 160), (27), DFS, wmmrule=ETSI
      # 60 GHz band channels 1-4, ref: Etsi En 302 567
      (57000 - 66000 @ 2160), (40)
@@ -743,11 +747,18 @@ country LC: DFS-ETSI
      (5490 - 5710 @ 160), (30), DFS
      (5735 - 5815 @ 80), (30)

+
+# Source:
+# https://www.ofcomnet.ch/#/fatTable
+# Note that the maximum transmitter power can be doubled for 
5250-5710MHz if
+# transmitter power control is in use: 5250-5330@23db, 5490-5710@30db
  country LI: DFS-ETSI
      (2402 - 2482 @ 40), (20)
-    (5170 - 5250 @ 80), (20), AUTO-BW, wmmrule=ETSI
-    (5250 - 5330 @ 80), (20), DFS, AUTO-BW, wmmrule=ETSI
+    (5170 - 5250 @ 80), (23), NO-OUTDOOR, AUTO-BW, wmmrule=ETSI
+    (5250 - 5330 @ 80), (20), NO-OUTDOOR, DFS, AUTO-BW, wmmrule=ETSI
      (5490 - 5710 @ 160), (27), DFS, wmmrule=ETSI
+    # 60 GHz band channels 1-4, ref: Etsi En 302 567
+    (57000 - 66000 @ 2160), (40)

  country LK: DFS-FCC
      (2402 - 2482 @ 40), (20)
-- 
2.18.0
