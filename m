Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:55852 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751147AbbCTMk7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Mar 2015 08:40:59 -0400
From: Oleksij Rempel <linux@rempel-privat.de>
To: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	kvalo@codeaurora.org, adrian@freebsd.org
Cc: Oleksij Rempel <linux@rempel-privat.de>
Subject: [PATCH 11/18] ath9k: ath9k_hw_set_4k_power_cal_tabl: use rmw buffer
Date: Fri, 20 Mar 2015 13:38:51 +0100
Message-Id: <1426855138-6121-12-git-send-email-linux@rempel-privat.de> (sfid-20150320_134103_045578_5E1E7A25)
In-Reply-To: <1426855138-6121-1-git-send-email-linux@rempel-privat.de>
References: <1426855138-6121-1-git-send-email-linux@rempel-privat.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Oleksij Rempel <linux@rempel-privat.de>
---
 drivers/net/wireless/ath/ath9k/eeprom_4k.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/eeprom_4k.c b/drivers/net/wireless/ath/ath9k/eeprom_4k.c
index e5a78d4..fc54fc7 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom_4k.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom_4k.c
@@ -389,6 +389,7 @@ static void ath9k_hw_set_4k_power_cal_table(struct ath_hw *ah,
 		}
 	}
 
+	ENABLE_REG_RMW_BUFFER(ah);
 	REG_RMW_FIELD(ah, AR_PHY_TPCRG1, AR_PHY_TPCRG1_NUM_PD_GAIN,
 		      (numXpdGain - 1) & 0x3);
 	REG_RMW_FIELD(ah, AR_PHY_TPCRG1, AR_PHY_TPCRG1_PD_GAIN_1,
@@ -396,6 +397,7 @@ static void ath9k_hw_set_4k_power_cal_table(struct ath_hw *ah,
 	REG_RMW_FIELD(ah, AR_PHY_TPCRG1, AR_PHY_TPCRG1_PD_GAIN_2,
 		      xpdGainValues[1]);
 	REG_RMW_FIELD(ah, AR_PHY_TPCRG1, AR_PHY_TPCRG1_PD_GAIN_3, 0);
+	REG_RMW_BUFFER_FLUSH(ah);
 
 	for (i = 0; i < AR5416_EEP4K_MAX_CHAINS; i++) {
 		regChainOffset = i * 0x1000;
-- 
1.9.1

