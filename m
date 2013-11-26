Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:50083 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751635Ab3KZBzx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Nov 2013 20:55:53 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH] ath9k: Fix QuickDrop usage
Date: Tue, 26 Nov 2013 07:21:08 +0530
Message-Id: <1385430668-25311-1-git-send-email-sujith@msujith.org> (sfid-20131126_025559_226172_6E3CC878)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Bit 5 in the miscConfiguration field of the base EEPROM
header denotes whether QuickDrop is enabled or not. Fix
the incorrect usage of BIT(1) and also make sure that
this is done only for the required chips.

Cc: stable@vger.kernel.org
Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
index 1ec5235..d96e879 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
@@ -3984,18 +3984,20 @@ static void ar9003_hw_quick_drop_apply(struct ath_hw *ah, u16 freq)
 	int quick_drop;
 	s32 t[3], f[3] = {5180, 5500, 5785};
 
-	if (!(pBase->miscConfiguration & BIT(1)))
+	if (!(pBase->miscConfiguration & BIT(4)))
 		return;
 
-	if (freq < 4000)
-		quick_drop = eep->modalHeader2G.quick_drop;
-	else {
-		t[0] = eep->base_ext1.quick_drop_low;
-		t[1] = eep->modalHeader5G.quick_drop;
-		t[2] = eep->base_ext1.quick_drop_high;
-		quick_drop = ar9003_hw_power_interpolate(freq, f, t, 3);
+	if (AR_SREV_9300(ah) || AR_SREV_9580(ah) || AR_SREV_9340(ah)) {
+		if (freq < 4000) {
+			quick_drop = eep->modalHeader2G.quick_drop;
+		} else {
+			t[0] = eep->base_ext1.quick_drop_low;
+			t[1] = eep->modalHeader5G.quick_drop;
+			t[2] = eep->base_ext1.quick_drop_high;
+			quick_drop = ar9003_hw_power_interpolate(freq, f, t, 3);
+		}
+		REG_RMW_FIELD(ah, AR_PHY_AGC, AR_PHY_AGC_QUICK_DROP, quick_drop);
 	}
-	REG_RMW_FIELD(ah, AR_PHY_AGC, AR_PHY_AGC_QUICK_DROP, quick_drop);
 }
 
 static void ar9003_hw_txend_to_xpa_off_apply(struct ath_hw *ah, bool is2ghz)
-- 
1.8.4.2

