Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:59099 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758102AbaDHVog (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Apr 2014 17:44:36 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com
Subject: [PATCH 3.15 1/2] ath9k_hw: reduce ANI firstep range for older chips
Date: Tue,  8 Apr 2014 23:44:25 +0200
Message-Id: <1396993466-1799-1-git-send-email-nbd@openwrt.org> (sfid-20140408_234446_225935_7E9D0497)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use 0-8 instead of 0-16, which is closer to the old implementation.
Also drop the overwrite of the firstep_low parameter to improve
stability.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ar5008_phy.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar5008_phy.c b/drivers/net/wireless/ath/ath9k/ar5008_phy.c
index 3b3e910..00fb8ba 100644
--- a/drivers/net/wireless/ath/ath9k/ar5008_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar5008_phy.c
@@ -1004,11 +1004,9 @@ static bool ar5008_hw_ani_control_new(struct ath_hw *ah,
 	case ATH9K_ANI_FIRSTEP_LEVEL:{
 		u32 level = param;
 
-		value = level * 2;
+		value = level;
 		REG_RMW_FIELD(ah, AR_PHY_FIND_SIG,
 			      AR_PHY_FIND_SIG_FIRSTEP, value);
-		REG_RMW_FIELD(ah, AR_PHY_FIND_SIG_LOW,
-			      AR_PHY_FIND_SIG_FIRSTEP_LOW, value);
 
 		if (level != aniState->firstepLevel) {
 			ath_dbg(common, ANI,
-- 
1.8.5.2 (Apple Git-48)

