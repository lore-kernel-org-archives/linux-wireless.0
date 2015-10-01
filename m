Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.csie.ntu.edu.tw ([140.112.30.61]:35108 "EHLO
	smtp.csie.ntu.edu.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751951AbbJAG55 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Oct 2015 02:57:57 -0400
From: Chen-Yu Tsai <wens@csie.org>
To: seth.forshee@canonical.com
Cc: Chen-Yu Tsai <wens@csie.org>, wireless-regdb@lists.infradead.org,
	linux-wireless@vger.kernel.org
Subject: [PATCH v3 3/5] wireless-regdb: Update 5GHz rules for US
Date: Thu,  1 Oct 2015 14:57:45 +0800
Message-Id: <1443682667-29814-4-git-send-email-wens@csie.org> (sfid-20151001_085804_091824_5F5616DE)
In-Reply-To: <1443682667-29814-1-git-send-email-wens@csie.org>
References: <1443682667-29814-1-git-send-email-wens@csie.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The FCC increased the maximum conducted transmission power for the
U-NII-1 (5150 ~ 5250 MHz) band to 30 dBm or 1 W for master devices
and 24 dBm or 250 mW for mobile/portable
devices.

Since 250 mW is slightly lower than 24 dBm, set the power limit to
a conservative value of 23 dBm.

Effective 6/2/2014.

See FCC KDB 905462 D06.

Signed-off-by: Chen-Yu Tsai <wens@csie.org>
---
 db.txt | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/db.txt b/db.txt
index f6607bc..ee6eaad 100644
--- a/db.txt
+++ b/db.txt
@@ -1159,7 +1159,8 @@ country UG: DFS-FCC
 
 country US: DFS-FCC
 	(2402 - 2472 @ 40), (30)
-	(5170 - 5250 @ 80), (17), AUTO-BW
+	# 5.15 ~ 5.25 GHz: 30 dBm for master mode, 23 dBm for clients
+	(5170 - 5250 @ 80), (23), AUTO-BW
 	(5250 - 5330 @ 80), (23), DFS, AUTO-BW
 	(5490 - 5730 @ 160), (23), DFS
 	(5735 - 5835 @ 80), (30)
-- 
2.5.3

