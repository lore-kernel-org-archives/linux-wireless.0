Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:54794 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750866AbaBVNxL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 22 Feb 2014 08:53:11 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com
Subject: [PATCH 1/2] ath9k: do not set half/quarter channel flags in AR_PHY_MODE
Date: Sat, 22 Feb 2014 14:52:48 +0100
Message-Id: <1393077169-65244-1-git-send-email-nbd@openwrt.org> (sfid-20140222_145337_497232_96CB687F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

5/10 MHz channel bandwidth is configured via the PLL clock, instead of
the AR_PHY_MODE register. Using that register is AR93xx specific, and
makes the mode incompatible with earlier chipsets.

In some early versions, these flags were apparently applied at the wrong
point in time and thus did not cause connectivity issues, however now
they are causing problems, as pointed out in this OpenWrt ticket:

https://dev.openwrt.org/ticket/14916

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ar9003_phy.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.c b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
index 09facba..8927fc3 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
@@ -868,10 +868,6 @@ static void ar9003_hw_set_rfmode(struct ath_hw *ah,
 
 	if (IS_CHAN_A_FAST_CLOCK(ah, chan))
 		rfMode |= (AR_PHY_MODE_DYNAMIC | AR_PHY_MODE_DYN_CCK_DISABLE);
-	if (IS_CHAN_QUARTER_RATE(chan))
-		rfMode |= AR_PHY_MODE_QUARTER;
-	if (IS_CHAN_HALF_RATE(chan))
-		rfMode |= AR_PHY_MODE_HALF;
 
 	if (rfMode & (AR_PHY_MODE_QUARTER | AR_PHY_MODE_HALF))
 		REG_RMW_FIELD(ah, AR_PHY_FRAME_CTL,
-- 
1.8.3.4 (Apple Git-47)

