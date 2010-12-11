Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:42410 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752193Ab0LKXve (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 11 Dec 2010 18:51:34 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, lrodriguez@atheros.com,
	Felix Fietkau <nbd@openwrt.org>
Subject: [PATCH v3 1/8] ath9k_hw: only use the PCIe disable register write sequence for AR5416
Date: Sun, 12 Dec 2010 00:51:07 +0100
Message-Id: <1292111474-70939-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Newer chips do not need this, and maybe these register writes could have
negative side effects on newer hardware.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/hw.c |    6 +-----
 1 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 516227f..7bc6d22 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -284,11 +284,9 @@ static void ath9k_hw_read_revisions(struct ath_hw *ah)
 
 static void ath9k_hw_disablepcie(struct ath_hw *ah)
 {
-	if (AR_SREV_9100(ah))
+	if (!AR_SREV_5416(ah))
 		return;
 
-	ENABLE_REGWRITE_BUFFER(ah);
-
 	REG_WRITE(ah, AR_PCIE_SERDES, 0x9248fc00);
 	REG_WRITE(ah, AR_PCIE_SERDES, 0x24924924);
 	REG_WRITE(ah, AR_PCIE_SERDES, 0x28000029);
@@ -300,8 +298,6 @@ static void ath9k_hw_disablepcie(struct ath_hw *ah)
 	REG_WRITE(ah, AR_PCIE_SERDES, 0x000e1007);
 
 	REG_WRITE(ah, AR_PCIE_SERDES2, 0x00000000);
-
-	REGWRITE_BUFFER_FLUSH(ah);
 }
 
 /* This should work for all families including legacy */
-- 
1.7.3.2

