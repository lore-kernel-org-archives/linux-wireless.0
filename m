Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:54749 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756750Ab0DODax (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Apr 2010 23:30:53 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Senthil Balasubramanian <senthilkumar@atheros.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH v2 24/97] ath9k_hw: update the chip tests for AR9003
Date: Wed, 14 Apr 2010 23:29:38 -0400
Message-Id: <1271302251-9075-25-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1271302251-9075-1-git-send-email-lrodriguez@atheros.com>
References: <1271302251-9075-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Senthil Balasubramanian <senthilkumar@atheros.com>

The AR9003 family requires a change on the loop and can also skip
testing the PHY timing registers. This chip test can now be used
by all Atheros hardware families, including legacy. We can
eventually move this out to the generic ath module.

Signed-off-by: Senthil Balasubramanian <senthilkumar@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/hw.c |   13 ++++++++++---
 1 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 0b89605..bf7a85f 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -298,18 +298,25 @@ static void ath9k_hw_disablepcie(struct ath_hw *ah)
 	REG_WRITE(ah, AR_PCIE_SERDES2, 0x00000000);
 }
 
+/* This should work for all families including legacy */
 static bool ath9k_hw_chip_test(struct ath_hw *ah)
 {
 	struct ath_common *common = ath9k_hw_common(ah);
-	u32 regAddr[2] = { AR_STA_ID0, AR_PHY_BASE + (8 << 2) };
+	u32 regAddr[2] = { AR_STA_ID0 };
 	u32 regHold[2];
 	u32 patternData[4] = { 0x55555555,
 			       0xaaaaaaaa,
 			       0x66666666,
 			       0x99999999 };
-	int i, j;
+	int i, j, loop_max;
 
-	for (i = 0; i < 2; i++) {
+	if (!AR_SREV_9300_20_OR_LATER(ah)) {
+		loop_max = 2;
+		regAddr[1] = AR_PHY_BASE + (8 << 2);
+	} else
+		loop_max = 1;
+
+	for (i = 0; i < loop_max; i++) {
 		u32 addr = regAddr[i];
 		u32 wrData, rdData;
 
-- 
1.6.3.3

