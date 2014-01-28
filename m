Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:49447 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753618AbaA1A5g (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Jan 2014 19:57:36 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	Josh Boyer <jwboyer@fedoraproject.org>
Subject: [PATCH] ath9k: Fix build error on ARM
Date: Tue, 28 Jan 2014 06:21:59 +0530
Message-Id: <1390870319-5054-1-git-send-email-sujith@msujith.org> (sfid-20140128_015739_307153_85900DA7)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Use mdelay instead of udelay to fix this error:

ERROR: "__bad_udelay" [drivers/net/wireless/ath/ath9k/ath9k_hw.ko] undefined!
make[1]: *** [__modpost] Error 1
make: *** [modules] Error 2

Reported-by: Josh Boyer <jwboyer@fedoraproject.org>
Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/hw.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index fbf43c0..11eab9f 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1316,7 +1316,7 @@ static bool ath9k_hw_set_reset(struct ath_hw *ah, int type)
 	if (AR_SREV_9300_20_OR_LATER(ah))
 		udelay(50);
 	else if (AR_SREV_9100(ah))
-		udelay(10000);
+		mdelay(10);
 	else
 		udelay(100);
 
@@ -2051,9 +2051,8 @@ static bool ath9k_hw_set_power_awake(struct ath_hw *ah)
 
 	REG_SET_BIT(ah, AR_RTC_FORCE_WAKE,
 		    AR_RTC_FORCE_WAKE_EN);
-
 	if (AR_SREV_9100(ah))
-		udelay(10000);
+		mdelay(10);
 	else
 		udelay(50);
 
-- 
1.8.5.3

