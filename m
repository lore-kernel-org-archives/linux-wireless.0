Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr1-f65.google.com ([209.85.221.65]:45315 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726334AbeHRPJV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 18 Aug 2018 11:09:21 -0400
Received: by mail-wr1-f65.google.com with SMTP id 20-v6so3214733wrb.12
        for <linux-wireless@vger.kernel.org>; Sat, 18 Aug 2018 05:01:52 -0700 (PDT)
To: seth.forshee@canonical.com
Cc: wireless-regdb@lists.infradead.org, linux-wireless@vger.kernel.org
From: Henrik Laxhuber <henrik@laxhuber.com>
Subject: wireless-regdb: Update regulatory rules for Switzerland (CH), and
 Liechtenstein (LI) on 5GHz
Message-ID: <d7dddf8e-b434-2492-3564-6f35b558d750@laxhuber.com> (sfid-20180818_140156_801774_E15A593A)
Date: Sat, 18 Aug 2018 14:01:50 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

[ My previous message didn't go through because I hadn't signed up to ]
[   the wireless-regdb mailing list; I apologise if anyone receives   ]
[                         this message twice                          ]

As far as I could tell, the regulatory information for Switzerland and
Liechtenstein did not match the information published by the national
regulator. I have gone ahead and updated the information according to
the 'National Frequency Allocation Strategy Table' [0] for both
countries.

On a somewhat related note, are there any plans to properly support TPC?
There are quite a few entries in the database where maximum transmission
power could be increased when TPC is in use. Being able to set a
different maximum antenna gain and/or EIRP when TCP is in use could be
helpful in these cases. I guess what's holding this back is lacking
driver support?

PS: Since [0] can be cumbersome to navigate, I am also providing the
direct links to the applicable tables. It's possible that these links
will rot:
5150 - 5350 MHz: [1]
5470 - 5725 MHz: [2]

[0] https://www.ofcomnet.ch/#/fatTable
[1] https://www.ofcomnet.ch/api/rir/1010/05
[2] https://www.ofcomnet.ch/api/rir/1010/04
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
