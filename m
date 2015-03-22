Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:64564 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751888AbbCVSby (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Mar 2015 14:31:54 -0400
From: Oleksij Rempel <linux@rempel-privat.de>
To: linux-wireless@vger.kernel.org, kvalo@codeaurora.org,
	ath9k-devel@lists.ath9k.org
Cc: Oleksij Rempel <linux@rempel-privat.de>
Subject: [PATCH v3 15/18] ath9k: ath9k_hw_4k_set_board_values: use rmw buffer
Date: Sun, 22 Mar 2015 19:30:00 +0100
Message-Id: <1427049003-8443-16-git-send-email-linux@rempel-privat.de> (sfid-20150322_193417_984022_4B38A5BF)
In-Reply-To: <1427049003-8443-1-git-send-email-linux@rempel-privat.de>
References: <1427049003-8443-1-git-send-email-linux@rempel-privat.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

it will reduce exution time from 14ms to 2ms on ar9271

Signed-off-by: Oleksij Rempel <linux@rempel-privat.de>
---
 drivers/net/wireless/ath/ath9k/eeprom_4k.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/eeprom_4k.c b/drivers/net/wireless/ath/ath9k/eeprom_4k.c
index 0600562..291c1d1 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom_4k.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom_4k.c
@@ -930,6 +930,7 @@ static void ath9k_hw_4k_set_board_values(struct ath_hw *ah,
 		}
 	}
 
+	ENABLE_REG_RMW_BUFFER(ah);
 	if (AR_SREV_9271(ah)) {
 		ath9k_hw_analog_shift_rmw(ah,
 					  AR9285_AN_RF2G3,
@@ -1034,6 +1035,7 @@ static void ath9k_hw_4k_set_board_values(struct ath_hw *ah,
 					  AR9285_AN_RF2G4_DB2_4_S,
 					  db2[4]);
 	}
+	REG_RMW_BUFFER_FLUSH(ah);
 
 
 	REG_RMW_FIELD(ah, AR_PHY_SETTLING, AR_PHY_SETTLING_SWITCH,
-- 
1.9.1

