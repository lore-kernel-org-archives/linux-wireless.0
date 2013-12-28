Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:57574 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755051Ab3L1EWW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Dec 2013 23:22:22 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 5/7] ath9k: Fix AR9100 chip power-on
Date: Sat, 28 Dec 2013 09:47:13 +0530
Message-Id: <1388204235-14682-5-git-send-email-sujith@msujith.org> (sfid-20131228_052246_827049_265907FB)
In-Reply-To: <1388204235-14682-1-git-send-email-sujith@msujith.org>
References: <1388204235-14682-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

AR9100 requires a larger delay after waking up
the RTC.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/hw.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 8cc44e9..c70ea28 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -2012,7 +2012,11 @@ static bool ath9k_hw_set_power_awake(struct ath_hw *ah)
 
 	REG_SET_BIT(ah, AR_RTC_FORCE_WAKE,
 		    AR_RTC_FORCE_WAKE_EN);
-	udelay(50);
+
+	if (AR_SREV_9100(ah))
+		udelay(10000);
+	else
+		udelay(50);
 
 	for (i = POWER_UP_TIME / 50; i > 0; i--) {
 		val = REG_READ(ah, AR_RTC_STATUS) & AR_RTC_STATUS_M;
-- 
1.8.5.2

