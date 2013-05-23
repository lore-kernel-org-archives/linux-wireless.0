Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:41488 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758167Ab3EWKVE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 May 2013 06:21:04 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, mcgrof@qca.qualcomm.com
Subject: [PATCH 3.10 1/3] ath9k_hw: fix spur mitigation issues on AR934x
Date: Thu, 23 May 2013 12:20:54 +0200
Message-Id: <1369304456-74526-1-git-send-email-nbd@openwrt.org> (sfid-20130523_122108_618448_063FB648)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Do not subtract spur power from noise floor on this chip, as it can lead
to packet loss and other connectivity issues.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ar9003_phy.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.c b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
index 2bf6548..e1714d7 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
@@ -334,7 +334,8 @@ static void ar9003_hw_spur_ofdm(struct ath_hw *ah,
 	REG_RMW_FIELD(ah, AR_PHY_SPUR_REG,
 		      AR_PHY_SPUR_REG_EN_VIT_SPUR_RSSI, 1);
 
-	if (REG_READ_FIELD(ah, AR_PHY_MODE,
+	if (!AR_SREV_9340(ah) &&
+	    REG_READ_FIELD(ah, AR_PHY_MODE,
 			   AR_PHY_MODE_DYNAMIC) == 0x1)
 		REG_RMW_FIELD(ah, AR_PHY_SPUR_REG,
 			      AR_PHY_SPUR_REG_ENABLE_NF_RSSI_SPUR_MIT, 1);
-- 
1.8.0.2

