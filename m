Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:47800 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752950Ab1KYSlS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Nov 2011 13:41:18 -0500
Received: by mail-ey0-f174.google.com with SMTP id k14so988641eaa.19
        for <linux-wireless@vger.kernel.org>; Fri, 25 Nov 2011 10:41:18 -0800 (PST)
From: Nick Kossifidis <mickflemm@gmail.com>
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, me@bobcopeland.com, mcgrof@gmail.com,
	nbd@openwrt.org, jirislaby@gmail.com,
	Nick Kossifidis <mickflemm@gmail.com>
Subject: [PATCH v2 12/12] ath5k: Optimize ath5k_cw_validate
Date: Fri, 25 Nov 2011 20:40:31 +0200
Message-Id: <1322246431-10825-13-git-send-email-mickflemm@gmail.com> (sfid-20111125_194129_123811_8C552148)
In-Reply-To: <1322246431-10825-1-git-send-email-mickflemm@gmail.com>
References: <1322246431-10825-1-git-send-email-mickflemm@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Optimize ath5k_cw_validate by using the classic (X & (X - 1)) == 0
check to see if a number is power of 2.

v2: Use functions from log2.h instead

Signed-off-by: Nick Kossifidis <mickflemm@gmail.com>
---
 drivers/net/wireless/ath/ath5k/qcu.c |   17 +++++++++++++----
 1 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/qcu.c b/drivers/net/wireless/ath/ath5k/qcu.c
index e50e64d..30b50f9 100644
--- a/drivers/net/wireless/ath/ath5k/qcu.c
+++ b/drivers/net/wireless/ath/ath5k/qcu.c
@@ -23,6 +23,7 @@ Queue Control Unit, DCF Control Unit Functions
 #include "ath5k.h"
 #include "reg.h"
 #include "debug.h"
+#include <linux/log2.h>
 
 /**
  * DOC: Queue Control Unit (QCU)/DCF Control Unit (DCU) functions
@@ -108,13 +109,21 @@ ath5k_hw_release_tx_queue(struct ath5k_hw *ah, unsigned int queue)
 static u16
 ath5k_cw_validate(u16 cw_req)
 {
-	u32 cw = 1;
 	cw_req = min(cw_req, (u16)1023);
 
-	while (cw < cw_req)
-		cw = (cw << 1) | 1;
+	/* Check if cw_req + 1 a power of 2 */
+	if (is_power_of_2(cw_req + 1))
+		return cw_req;
 
-	return cw;
+	/* Check if cw_req is a power of 2 */
+	if (is_power_of_2(cw_req))
+		return cw_req - 1;
+
+	/* If none of the above is correct
+	 * find the closest power of 2 */
+	cw_req = (u16) roundup_pow_of_two(cw_req) - 1;
+
+	return cw_req;
 }
 
 /**
-- 
1.7.8.rc3

