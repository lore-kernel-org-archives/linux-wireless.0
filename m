Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:21629 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760071AbZIQD4J (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Sep 2009 23:56:09 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 16 Sep 2009 20:56:13 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19121.45918.6788.280797@gargle.gargle.HOWL>
Date: Thu, 17 Sep 2009 09:26:14 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 05/12] ath9k: Fix rx data corruption
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Vasanthakumar Thiagarajan <vasanth@atheros.com>

Setting bit 20 and 25 of 0x8344 can cause occasional rx data
corruption, clear them to fix this issue.

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 drivers/net/wireless/ath/ath9k/hw.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index af5bb50..4731ad2 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1273,6 +1273,15 @@ static void ath9k_hw_override_ini(struct ath_hw *ah,
 	 */
 	REG_SET_BIT(ah, AR_DIAG_SW, (AR_DIAG_RX_DIS | AR_DIAG_RX_ABORT));
 
+	if (AR_SREV_9280_10_OR_LATER(ah)) {
+		val = REG_READ(ah, AR_PCU_MISC_MODE2) &
+			       (~AR_PCU_MISC_MODE2_HWWAR1);
+
+		if (AR_SREV_9287_10_OR_LATER(ah))
+			val = val & (~AR_PCU_MISC_MODE2_HWWAR2);
+
+		REG_WRITE(ah, AR_PCU_MISC_MODE2, val);
+	}
 
 	if (!AR_SREV_5416_20_OR_LATER(ah) ||
 	    AR_SREV_9280_10_OR_LATER(ah))
-- 
1.6.4.3

