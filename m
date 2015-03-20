Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:60741 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751934AbbCTMlD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Mar 2015 08:41:03 -0400
From: Oleksij Rempel <linux@rempel-privat.de>
To: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	kvalo@codeaurora.org, adrian@freebsd.org
Cc: Oleksij Rempel <linux@rempel-privat.de>
Subject: [PATCH 13/18] ath9k: ath9k_hw_4k_set_board_values: use rmw buffer
Date: Fri, 20 Mar 2015 13:38:53 +0100
Message-Id: <1426855138-6121-14-git-send-email-linux@rempel-privat.de> (sfid-20150320_140418_296164_8A191279)
In-Reply-To: <1426855138-6121-1-git-send-email-linux@rempel-privat.de>
References: <1426855138-6121-1-git-send-email-linux@rempel-privat.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Oleksij Rempel <linux@rempel-privat.de>
---
 drivers/net/wireless/ath/ath9k/eeprom_4k.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/eeprom_4k.c b/drivers/net/wireless/ath/ath9k/eeprom_4k.c
index fc54fc7..0600562 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom_4k.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom_4k.c
@@ -1082,6 +1082,7 @@ static void ath9k_hw_4k_set_board_values(struct ath_hw *ah,
 		mask = BIT(0)|BIT(5)|BIT(10)|BIT(15)|BIT(20)|BIT(25);
 		pwrctrl = mask * bb_desired_scale;
 		clr = mask * 0x1f;
+		ENABLE_REG_RMW_BUFFER(ah);
 		REG_RMW(ah, AR_PHY_TX_PWRCTRL8, pwrctrl, clr);
 		REG_RMW(ah, AR_PHY_TX_PWRCTRL10, pwrctrl, clr);
 		REG_RMW(ah, AR_PHY_CH0_TX_PWRCTRL12, pwrctrl, clr);
@@ -1096,6 +1097,7 @@ static void ath9k_hw_4k_set_board_values(struct ath_hw *ah,
 		clr = mask * 0x1f;
 		REG_RMW(ah, AR_PHY_CH0_TX_PWRCTRL11, pwrctrl, clr);
 		REG_RMW(ah, AR_PHY_CH0_TX_PWRCTRL13, pwrctrl, clr);
+		REG_RMW_BUFFER_FLUSH(ah);
 	}
 }
 
-- 
1.9.1

