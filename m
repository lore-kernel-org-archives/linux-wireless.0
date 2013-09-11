Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:54864 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752265Ab3IKGPA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Sep 2013 02:15:00 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 2/3] ath9k: Fix issue with parsing malformed CFP IE
Date: Wed, 11 Sep 2013 11:40:58 +0530
Message-Id: <1378879859-32290-2-git-send-email-sujith@msujith.org> (sfid-20130911_081509_942870_B87E937E)
In-Reply-To: <1378879859-32290-1-git-send-email-sujith@msujith.org>
References: <1378879859-32290-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

All QCA chips have the ability to parse the CF Parameter Set
IE in beacons. If the IE is malformed in the beacons from some
APs [1], the HW locks up. In AP mode, a beacon stuck would happen
and in client mode, a disconnection usually is the result.

To fix this issue, set the AR_PCU_MISC_MODE2_CFP_IGNORE to ignore
the CFP IE in beacons - this is applicable for all chips. For
AP mode, if this issue happens, the NAV is also corrupted and has
to be reset - this will be done in a subsequent patch.

[1] : http://msujith.org/ath9k/cfp/Malformed-CF-Param.png

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar5008_phy.c | 2 ++
 drivers/net/wireless/ath/ath9k/ar9003_phy.c | 6 ++++--
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar5008_phy.c b/drivers/net/wireless/ath/ath9k/ar5008_phy.c
index 0865647..9e4e2a6 100644
--- a/drivers/net/wireless/ath/ath9k/ar5008_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar5008_phy.c
@@ -626,6 +626,8 @@ static void ar5008_hw_override_ini(struct ath_hw *ah,
 		if (AR_SREV_9287_11_OR_LATER(ah))
 			val = val & (~AR_PCU_MISC_MODE2_HWWAR2);
 
+		val |= AR_PCU_MISC_MODE2_CFP_IGNORE;
+
 		REG_WRITE(ah, AR_PCU_MISC_MODE2, val);
 	}
 
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.c b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
index b8a279e..ec37213 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
@@ -627,8 +627,10 @@ static void ar9003_hw_override_ini(struct ath_hw *ah)
 	 * MAC addr only will fail.
 	 */
 	val = REG_READ(ah, AR_PCU_MISC_MODE2) & (~AR_ADHOC_MCAST_KEYID_ENABLE);
-	REG_WRITE(ah, AR_PCU_MISC_MODE2,
-		  val | AR_AGG_WEP_ENABLE_FIX | AR_AGG_WEP_ENABLE);
+	val |= AR_AGG_WEP_ENABLE_FIX |
+	       AR_AGG_WEP_ENABLE |
+	       AR_PCU_MISC_MODE2_CFP_IGNORE;
+	REG_WRITE(ah, AR_PCU_MISC_MODE2, val);
 
 	REG_SET_BIT(ah, AR_PHY_CCK_DETECT,
 		    AR_PHY_CCK_DETECT_BB_ENABLE_ANT_FAST_DIV);
-- 
1.8.4

