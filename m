Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:48875 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756994Ab2HHN47 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Aug 2012 09:56:59 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, mcgrof@qca.qualcomm.com
Subject: [PATCH 3.6 1/4] ath9k_hw: do not enable the MIB interrupt in the interrupt mask register
Date: Tue,  7 Aug 2012 15:06:09 +0200
Message-Id: <1344344772-49459-1-git-send-email-nbd@openwrt.org> (sfid-20120808_155704_007880_86FFDD01)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The interrupt is no longer handling it. While it shouldn't fire (wraparound
is highly unlikely), the consequences would be fatal (interrupt storm).
Disable the interrupt to prevent that from happening.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/hw.c |    3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 60b6a9d..d95474e 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -978,9 +978,6 @@ static void ath9k_hw_init_interrupt_masks(struct ath_hw *ah,
 	else
 		imr_reg |= AR_IMR_TXOK;
 
-	if (opmode == NL80211_IFTYPE_AP)
-		imr_reg |= AR_IMR_MIB;
-
 	ENABLE_REGWRITE_BUFFER(ah);
 
 	REG_WRITE(ah, AR_IMR, imr_reg);
-- 
1.7.9.6 (Apple Git-31.1)

