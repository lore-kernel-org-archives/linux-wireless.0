Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:44622 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750872AbZHaM0u (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Aug 2009 08:26:50 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 31 Aug 2009 05:26:53 -0700
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Luis.Rodriguez@atheros.com>,
	<Jouni.Malinen@atheros.com>, <ath9k-devel@lists.ath9k.org>
Subject: [PATCH] ath9k: Do an AHB reset before doing RTC reset
Date: Mon, 31 Aug 2009 17:48:36 +0530
Message-ID: <1251721116-25758-1-git-send-email-vasanth@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Doing an RTC reset when DMA is active may corrupt memory,
make sure no DMA is active at this moment by doing an
AHB reset.

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 drivers/net/wireless/ath/ath9k/hw.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index e340dac..71f27f3 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1712,8 +1712,15 @@ static bool ath9k_hw_set_reset_power_on(struct ath_hw *ah)
 	REG_WRITE(ah, AR_RTC_FORCE_WAKE, AR_RTC_FORCE_WAKE_EN |
 		  AR_RTC_FORCE_WAKE_ON_INT);
 
+	if (!AR_SREV_9100(ah))
+		REG_WRITE(ah, AR_RC, AR_RC_AHB);
+
 	REG_WRITE(ah, AR_RTC_RESET, 0);
 	udelay(2);
+
+	if (!AR_SREV_9100(ah))
+		REG_WRITE(ah, AR_RC, 0);
+
 	REG_WRITE(ah, AR_RTC_RESET, 1);
 
 	if (!ath9k_hw_wait(ah,
-- 
1.5.5.1

