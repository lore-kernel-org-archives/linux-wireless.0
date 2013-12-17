Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:56239 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755301Ab3LQSLv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Dec 2013 13:11:51 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 2/4] ath9k: Add a delay between RTC reset/clear for AR9003
Date: Tue, 17 Dec 2013 23:36:46 +0530
Message-Id: <1387303608-31356-3-git-send-email-sujith@msujith.org> (sfid-20131217_191156_980644_B03B878A)
In-Reply-To: <1387303608-31356-1-git-send-email-sujith@msujith.org>
References: <1387303608-31356-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

The small delay that is present between a RTC reset/clear
operation is required for the chip to settle and this is
needed for all chips, not just the AR9002 family.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/hw.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 40cc64b..f58868c 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1399,8 +1399,7 @@ static bool ath9k_hw_set_reset_power_on(struct ath_hw *ah)
 
 	REGWRITE_BUFFER_FLUSH(ah);
 
-	if (!AR_SREV_9300_20_OR_LATER(ah))
-		udelay(2);
+	udelay(2);
 
 	if (!AR_SREV_9100(ah) && !AR_SREV_9300_20_OR_LATER(ah))
 		REG_WRITE(ah, AR_RC, 0);
-- 
1.8.5.1

