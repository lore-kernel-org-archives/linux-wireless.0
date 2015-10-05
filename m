Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.csie.ntu.edu.tw ([140.112.30.61]:44560 "EHLO
	smtp.csie.ntu.edu.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752579AbbJEQPY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Oct 2015 12:15:24 -0400
From: Chen-Yu Tsai <wens@csie.org>
To: seth.forshee@canonical.com
Cc: Chen-Yu Tsai <wens@csie.org>, wireless-regdb@lists.infradead.org,
	linux-wireless@vger.kernel.org
Subject: [PATCH v4 3/5] wireless-regdb: Update 5GHz rules for US
Date: Tue,  6 Oct 2015 00:14:56 +0800
Message-Id: <1444061698-16384-4-git-send-email-wens@csie.org> (sfid-20151005_181531_708623_9523F6F5)
In-Reply-To: <1444061698-16384-1-git-send-email-wens@csie.org>
References: <1444061698-16384-1-git-send-email-wens@csie.org>
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

