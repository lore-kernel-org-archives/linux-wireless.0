Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:47670 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757128AbaJ2VWM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Oct 2014 17:22:12 -0400
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: <wireless-regdb@lists.infradead.org>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH 4/7] wireless-regdb: Add 160 MHz channel bandwidth for Algeria (DZ)
Date: Wed, 29 Oct 2014 23:21:27 +0200
Message-ID: <1414617690-29786-4-git-send-email-jouni@qca.qualcomm.com> (sfid-20141029_222218_660167_BFD54034)
In-Reply-To: <1414617690-29786-1-git-send-email-jouni@qca.qualcomm.com>
References: <1414617690-29786-1-git-send-email-jouni@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This extends regulatory rules for Algeria to allow 160 MHz VHT channels
to be used in 5.15-5.25 GHz, 5.25-5.35 GHz, and 5.47-5.725 GHz ranges.
Since the rules between 5.15-5.25 and 5.25-5.35 GHz ranges are different
in most cases (e.g., DFS requirement), the AUTO-BW flag needs to be used
to allow the maximum channel bandwidth to be determined automatically
based on two rules. The larger 5.47-5.725 GHz range is large enough to
fit the full 160 MHz channel in a single rule, so that does not require
similar handling and can just change the maximum allowed bandwidth to
160 MHz in the rule.

Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>
---
 db.txt | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/db.txt b/db.txt
index d527b54..10aaf44 100644
--- a/db.txt
+++ b/db.txt
@@ -343,9 +343,9 @@ country DO: DFS-FCC
 
 country DZ: DFS-JP
 	(2402 - 2482 @ 40), (20)
-	(5170.000 - 5250.000 @ 80.000), (23.00)
-	(5250.000 - 5330.000 @ 80.000), (23.00), DFS
-	(5490.000 - 5670.000 @ 80.000), (23.00), DFS
+	(5170.000 - 5250.000 @ 80.000), (23.00), AUTO-BW
+	(5250.000 - 5330.000 @ 80.000), (23.00), DFS, AUTO-BW
+	(5490.000 - 5670.000 @ 160.000), (23.00), DFS
 
 country EC: DFS-FCC
 	(2402 - 2482 @ 40), (20)
-- 
1.9.1

