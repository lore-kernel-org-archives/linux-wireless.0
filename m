Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:53687 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752719Ab3LRE2i (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Dec 2013 23:28:38 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH v2 09/10] ath9k: Fix RTC reset delay
Date: Wed, 18 Dec 2013 09:53:26 +0530
Message-Id: <1387340607-20045-10-git-send-email-sujith@msujith.org> (sfid-20131218_052856_386245_F5C76ABB)
In-Reply-To: <1387340607-20045-1-git-send-email-sujith@msujith.org>
References: <1387340607-20045-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

The delay that is required after issuing a RTC reset
varies for each chip. Handle this properly.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/hw.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index f58868c..2a511c6 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1363,7 +1363,12 @@ static bool ath9k_hw_set_reset(struct ath_hw *ah, int type)
 
 	REGWRITE_BUFFER_FLUSH(ah);
 
-	udelay(50);
+	if (AR_SREV_9300_20_OR_LATER(ah))
+		udelay(50);
+	else if (AR_SREV_9100(ah))
+		udelay(10000);
+	else
+		udelay(100);
 
 	REG_WRITE(ah, AR_RTC_RC, 0);
 	if (!ath9k_hw_wait(ah, AR_RTC_RC, AR_RTC_RC_M, 0, AH_WAIT_TIMEOUT)) {
-- 
1.8.5.1

