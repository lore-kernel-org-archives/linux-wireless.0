Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay07.ispgateway.de ([134.119.228.101]:44837 "EHLO
        smtprelay07.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726266AbeHROPQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 18 Aug 2018 10:15:16 -0400
Received: from [209.85.214.45] (helo=mail-it0-f45.google.com)
        by smtprelay07.ispgateway.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES128-GCM-SHA256:128)
        (Exim 4.90_1)
        (envelope-from <henrik@laxhuber.com>)
        id 1fqwo1-0003N2-0j
        for linux-wireless@vger.kernel.org; Sat, 18 Aug 2018 10:41:57 +0200
Received: by mail-it0-f45.google.com with SMTP id v71-v6so14710365itb.3
        for <linux-wireless@vger.kernel.org>; Sat, 18 Aug 2018 01:41:56 -0700 (PDT)
MIME-Version: 1.0
From: Henrik Laxhuber <henrik@laxhuber.com>
Date: Sat, 18 Aug 2018 10:41:45 +0200
Message-ID: <CAL0=bNBWox+LV8xym3N5GEVjx0RKfAeYriWedO5FXwsi5M945w@mail.gmail.com> (sfid-20180818_130806_830743_E45F01D9)
Subject: wireless-regdb: Update regulatory rules for Switzerland (CH) on 5GHz
To: seth.forshee@canonical.com
Cc: wireless-regdb@lists.infradead.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This commit doubles the maximum transmission power for
5170-5250MHz in accordance with regulatory information obtained
from Switzerland's national frequency allocation strategy table
[0]. In addition, a note has been added that power on 5GHz for
frequencies greater than 5250MHz may be doubled if TPC is in use.

Since [0] can be cumbersome to navigate, I will note the direct
links to the applicable tables here as well:
5150-5350MHz: [1]
5470-5725MHz: [2]

[0] https://www.ofcomnet.ch/#/fatTable
[1] https://www.ofcomnet.ch/api/rir/1010/05
[2] https://www.ofcomnet.ch/api/rir/1010/04
---
 db.txt | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/db.txt b/db.txt
index 8cf7dee..427af7b 100644
--- a/db.txt
+++ b/db.txt
@@ -265,9 +265,13 @@ country CF: DFS-FCC
  (5490 - 5730 @ 40), (24), DFS
  (5735 - 5835 @ 40), (30)

+# Source:
+# https://www.ofcomnet.ch/#/fatTable
+# Note that the maximum transmitter power can be doubled for 5250-5710MHz if
+# transmitter power control is in use: 5250-5330@23db, 5490-5710@30db
 country CH: DFS-ETSI
  (2402 - 2482 @ 40), (20)
- (5170 - 5250 @ 80), (20), AUTO-BW, wmmrule=ETSI
+ (5170 - 5250 @ 80), (23), AUTO-BW, wmmrule=ETSI
  (5250 - 5330 @ 80), (20), DFS, AUTO-BW, wmmrule=ETSI
  (5490 - 5710 @ 160), (27), DFS, wmmrule=ETSI
  # 60 GHz band channels 1-4, ref: Etsi En 302 567
-- 
2.18.0
