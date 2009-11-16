Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:33464 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751672AbZKPGKR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Nov 2009 01:10:17 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Sun, 15 Nov 2009 22:10:23 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19200.60657.34086.227480@gargle.gargle.HOWL>
Date: Mon, 16 Nov 2009 11:40:57 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 4/4] ath9k: Fix bug in initializing chain masks
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Check for AR5416 ver 1.0 before calibrating 3 chains
for multi-chain. This is a WAR for calibration
failure.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/hw.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index ffcc4f0..53a7b98 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1146,7 +1146,7 @@ static void ath9k_hw_init_chain_masks(struct ath_hw *ah)
 		REG_SET_BIT(ah, AR_PHY_ANALOG_SWAP,
 			    AR_PHY_SWAP_ALT_CHAIN);
 	case 0x3:
-		if (((ah)->hw_version.macVersion <= AR_SREV_VERSION_9160)) {
+		if (ah->hw_version.macVersion == AR_SREV_REVISION_5416_10) {
 			REG_WRITE(ah, AR_PHY_RX_CHAINMASK, 0x7);
 			REG_WRITE(ah, AR_PHY_CAL_CHAINMASK, 0x7);
 			break;
-- 
1.6.5.2

