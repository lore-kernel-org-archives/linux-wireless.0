Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:46152 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752871AbdLVQiO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 22 Dec 2017 11:38:14 -0500
Received: from mail-io0-f198.google.com ([209.85.223.198])
        by youngberry.canonical.com with esmtps (TLS1.0:RSA_AES_128_CBC_SHA1:16)
        (Exim 4.76)
        (envelope-from <seth.forshee@canonical.com>)
        id 1eSQKr-0002Dg-UW
        for linux-wireless@vger.kernel.org; Fri, 22 Dec 2017 16:38:14 +0000
Received: by mail-io0-f198.google.com with SMTP id s23so7742985ioa.16
        for <linux-wireless@vger.kernel.org>; Fri, 22 Dec 2017 08:38:13 -0800 (PST)
From: Seth Forshee <seth.forshee@canonical.com>
To: wireless-regdb@lists.infradead.org, linux-wireless@vger.kernel.org
Cc: Seth Forshee <seth.forshee@canonical.com>,
        Per Mejdal Rasmussen <pmr@its.aau.dk>
Subject: [PATCH] wireless-regdb: Update rules for Denmark (DK)
Date: Fri, 22 Dec 2017 10:38:08 -0600
Message-Id: <20171222163808.27862-1-seth.forshee@canonical.com> (sfid-20171222_173818_551673_BBA7A289)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Refresh the frequency ranges and power limits based on the
following sources:

 https://erhvervsstyrelsen.dk/sites/default/files/007_interface-datanet_5-6_ghz.pdf.pdf
 https://erhvervsstyrelsen.dk/sites/default/files/radiograenseflader-63.pdf

Cc: Per Mejdal Rasmussen <pmr@its.aau.dk>
Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
---
 db.txt | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/db.txt b/db.txt
index 10c84ee1ca5d..990abf997a12 100644
--- a/db.txt
+++ b/db.txt
@@ -371,13 +371,16 @@ country DE: DFS-ETSI
 	# 60 GHz band channels 1-4 (ETSI EN 302 567)
 	(57000 - 66000 @ 2160), (40)
 
+# Sources:
+# 5GHz: https://erhvervsstyrelsen.dk/sites/default/files/007_interface-datanet_5-6_ghz.pdf.pdf
+# 60GHz: https://erhvervsstyrelsen.dk/sites/default/files/radiograenseflader-63.pdf
 country DK: DFS-ETSI
-	(2402 - 2482 @ 40), (20)
-	(5170 - 5250 @ 80), (20), AUTO-BW
-	(5250 - 5330 @ 80), (20), DFS, AUTO-BW
-	(5490 - 5710 @ 160), (27), DFS
-	# 60 GHz band channels 1-4, ref: Etsi En 302 567
-	(57000 - 66000 @ 2160), (40)
+	(2400 - 2483.5 @ 40), (20)
+	(5150 - 5250 @ 80), (23), AUTO-BW
+	(5250 - 5350 @ 80), (20), DFS, AUTO-BW
+	(5470 - 5725 @ 160), (27), DFS
+	# 60 GHz band channels 1-4 (ETSI EN 302 567)
+	(57000 - 66000 @ 2160), (40), NO-OUTDOOR
 
 # Source:
 # http://www.ntrcdom.org/index.php?option=com_content&view=category&layout=blog&id=10&Itemid=55
-- 
2.14.1
