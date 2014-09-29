Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static.88-198-24-112.clients.your-server.de ([88.198.24.112]:56246
	"EHLO nbd.name" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750968AbaI2Sps (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Sep 2014 14:45:48 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com
Subject: [PATCH 1/3] Revert "ath9k_hw: reduce ANI firstep range for older chips"
Date: Mon, 29 Sep 2014 20:45:40 +0200
Message-Id: <1412016342-21227-1-git-send-email-nbd@openwrt.org> (sfid-20140929_204552_177462_B5A0FE2A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This reverts commit 09efc56345be4146ab9fc87a55c837ed5d6ea1ab

I've received reports that this change is decreasing throughput in some
rare conditions on an AR9280 based device

Cc: stable@vger.kernel.org
Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ar5008_phy.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar5008_phy.c b/drivers/net/wireless/ath/ath9k/ar5008_phy.c
index 00fb8ba..3b3e910 100644
--- a/drivers/net/wireless/ath/ath9k/ar5008_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar5008_phy.c
@@ -1004,9 +1004,11 @@ static bool ar5008_hw_ani_control_new(struct ath_hw *ah,
 	case ATH9K_ANI_FIRSTEP_LEVEL:{
 		u32 level = param;
 
-		value = level;
+		value = level * 2;
 		REG_RMW_FIELD(ah, AR_PHY_FIND_SIG,
 			      AR_PHY_FIND_SIG_FIRSTEP, value);
+		REG_RMW_FIELD(ah, AR_PHY_FIND_SIG_LOW,
+			      AR_PHY_FIND_SIG_FIRSTEP_LOW, value);
 
 		if (level != aniState->firstepLevel) {
 			ath_dbg(common, ANI,
-- 
2.0.4

