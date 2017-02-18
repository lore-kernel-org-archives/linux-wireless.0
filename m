Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:35150 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751008AbdBRGlm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 18 Feb 2017 01:41:42 -0500
Received: by mail-pf0-f196.google.com with SMTP id 68so5614820pfx.2
        for <linux-wireless@vger.kernel.org>; Fri, 17 Feb 2017 22:41:41 -0800 (PST)
From: Ryan Mounce <ryan@mounce.com.au>
To: seth.forshee@canonical.com
Cc: wireless-regdb@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: [PATCH] wireless-regdb: Update rules for Australia (AU) and add 60GHz rules
Date: Sat, 18 Feb 2017 17:05:15 +1030
Message-Id: <20170218063515.16071-1-ryan@mounce.com.au> (sfid-20170218_074158_950702_CFD36DEA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sourced from the latest legislation at
https://www.legislation.gov.au/Details/F2016C0043

The current rules exceed legal limits between 5250-5330MHz, and permit
illegal operation in 5600-5650MHz (reserved for weather radar).

Signed-off-by: Ryan Mounce <ryan@mounce.com.au>
---
 db.txt | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/db.txt b/db.txt
index 05108e0..b951e0c 100644
--- a/db.txt
+++ b/db.txt
@@ -85,12 +85,17 @@ country AT: DFS-ETSI
 	# 60 GHz band channels 1-4, ref: Etsi En 302 567
 	(57000 - 66000 @ 2160), (40)
 
+# Source:
+# https://www.legislation.gov.au/Details/F2016C00432
+# Both DFS-ETSI and DFS-FCC are acceptable per AS/NZS 4268 Appendix B
 country AU: DFS-ETSI
-	(2402 - 2482 @ 40), (20)
-	(5170 - 5250 @ 80), (17), AUTO-BW
-	(5250 - 5330 @ 80), (24), DFS, AUTO-BW
-	(5490 - 5710 @ 160), (24), DFS
-	(5735 - 5835 @ 80), (30)
+	(2402 - 2482 @ 40), (36)
+	(5170 - 5250 @ 80), (23), NO-OUTDOOR, AUTO-BW
+	(5250 - 5330 @ 80), (23), NO-OUTDOOR, AUTO-BW, DFS
+	(5490 - 5590 @ 80), (30), DFS
+	(5650 - 5730 @ 80), (30), DFS
+	(5735 - 5835 @ 80), (36)
+	(57000 - 66000 @ 2160), (43), NO-OUTDOOR
 
 country AW: DFS-ETSI
 	(2402 - 2482 @ 40), (20)
-- 
2.11.0
