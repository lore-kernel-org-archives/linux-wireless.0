Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:44356 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753044Ab3IPFK6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Sep 2013 01:10:58 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 1/3] ath9k: Fix NF calibration for single stream cards
Date: Mon, 16 Sep 2013 10:36:59 +0530
Message-Id: <1379308021-20891-1-git-send-email-sujith@msujith.org> (sfid-20130916_071101_862350_FD129A2D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Rather than using the chip ID to read only chain-0 CCA
registers and avoid reading chain-1, use the RX chainmask
instead. There are some 1-stream PCI devices based on AR9287
such as TL-WN751ND. Improper NF calibration might result in
DMA errors/timeouts.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9002_phy.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9002_phy.c b/drivers/net/wireless/ath/ath9k/ar9002_phy.c
index 7a5569b..17970d4 100644
--- a/drivers/net/wireless/ath/ath9k/ar9002_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9002_phy.c
@@ -485,7 +485,7 @@ static void ar9002_hw_do_getnf(struct ath_hw *ah,
 	if (IS_CHAN_HT40(ah->curchan))
 		nfarray[3] = sign_extend32(nf, 8);
 
-	if (AR_SREV_9285(ah) || AR_SREV_9271(ah))
+	if (!(ah->rxchainmask & BIT(1)))
 		return;
 
 	nf = MS(REG_READ(ah, AR_PHY_CH1_CCA), AR9280_PHY_CH1_MINCCA_PWR);
-- 
1.8.4

