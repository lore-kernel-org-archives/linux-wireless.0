Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:36465 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751127AbdBWNxe (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 23 Feb 2017 08:53:34 -0500
Received: by mail-pf0-f193.google.com with SMTP id c193so1630405pfb.3
        for <linux-wireless@vger.kernel.org>; Thu, 23 Feb 2017 05:53:00 -0800 (PST)
From: Ryan Mounce <ryan@mounce.com.au>
To: seth.forshee@canonical.com
Cc: wireless-regdb@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: [PATCH v2] wireless-regdb: Update rules for Australia (AU) and add 60GHz rules
Date: Fri, 24 Feb 2017 00:22:53 +1030
Message-Id: <20170223135253.1681-1-ryan@mounce.com.au> (sfid-20170223_145340_443579_3A32B71E)
In-Reply-To: <20170223130142.GA90803@ubuntu-hedt>
References: <20170223130142.GA90803@ubuntu-hedt>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sourced from the current legislation at
https://www.legislation.gov.au/Details/F2016C00432

The current rules exceed legal limits between 5250-5330MHz, and permit
illegal operation in 5600-5650MHz (disallowed regardless of DFS).

Frequency ranges and EIRP limits for all ranges have been updated to
match items 59-63, 65 in the linked document. As the rules for AU have
never previously mirrored local regulations, changes include a
significant increase in the allowable 2.4GHz EIRP and smaller increases
in most other bands.

In order to allow 80MHz operation between 5650-5730MHz (bordering two
bands) the lower, more restrictive band has been rounded up by 5MHz.

Signed-off-by: Ryan Mounce <ryan@mounce.com.au>
---
 db.txt | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/db.txt b/db.txt
index 05108e0..00e81b6 100644
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
+	(2400 - 2483.5 @ 40), (36)
+	(5150 - 5250 @ 80), (23), NO-OUTDOOR, AUTO-BW
+	(5250 - 5350 @ 80), (23), NO-OUTDOOR, AUTO-BW, DFS
+	(5470 - 5600 @ 80), (30), DFS
+	(5650 - 5730 @ 80), (30), DFS
+	(5730 - 5850 @ 80), (36)
+	(57000 - 66000 @ 2160), (43), NO-OUTDOOR
 
 country AW: DFS-ETSI
 	(2402 - 2482 @ 40), (20)
-- 
2.11.0
