Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:40027 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751901AbaKKHF7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Nov 2014 02:05:59 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com
Subject: [PATCH 1/6] ath9k: disable overriding AR9340 SLP32 registers
Date: Tue, 11 Nov 2014 12:37:19 +0530
Message-Id: <1415689644-29693-2-git-send-email-sujith@msujith.org> (sfid-20141111_080610_570551_6FB44C8D)
In-Reply-To: <1415689644-29693-1-git-send-email-sujith@msujith.org>
References: <1415689644-29693-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Miaoqing Pan <miaoqing@qca.qualcomm.com>

For AR9340, the correct values for SLP32 registers are present
in the initvals, so overriding them is not needed.

Signed-off-by: Miaoqing Pan <miaoqing@qca.qualcomm.com>
Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_phy.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.c b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
index 2df6d2e..5c9c9a7 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
@@ -668,12 +668,16 @@ static void ar9003_hw_override_ini(struct ath_hw *ah)
 	if (AR_SREV_9340(ah) || AR_SREV_9531(ah) || AR_SREV_9550(ah)) {
 		if (ah->is_clk_25mhz) {
 			REG_WRITE(ah, AR_RTC_DERIVED_CLK, 0x17c << 1);
-			REG_WRITE(ah, AR_SLP32_MODE, 0x0010f3d7);
-			REG_WRITE(ah, AR_SLP32_INC, 0x0001e7ae);
+			if (!AR_SREV_9340(ah)) {
+				REG_WRITE(ah, AR_SLP32_MODE, 0x0010f3d7);
+				REG_WRITE(ah, AR_SLP32_INC, 0x0001e7ae);
+			}
 		} else {
 			REG_WRITE(ah, AR_RTC_DERIVED_CLK, 0x261 << 1);
-			REG_WRITE(ah, AR_SLP32_MODE, 0x0010f400);
-			REG_WRITE(ah, AR_SLP32_INC, 0x0001e800);
+			if (!AR_SREV_9340(ah)) {
+				REG_WRITE(ah, AR_SLP32_MODE, 0x0010f400);
+				REG_WRITE(ah, AR_SLP32_INC, 0x0001e800);
+			}
 		}
 		udelay(100);
 	}
-- 
2.1.3

