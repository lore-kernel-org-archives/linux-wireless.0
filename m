Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:42296 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753969Ab3FFG3v (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Jun 2013 02:29:51 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH] ath9k: Remove redundant code
Date: Thu,  6 Jun 2013 11:57:01 +0530
Message-Id: <1370500021-18722-2-git-send-email-sujith@msujith.org> (sfid-20130606_082956_198943_F4A65D50)
In-Reply-To: <1370500021-18722-1-git-send-email-sujith@msujith.org>
References: <1370500021-18722-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

The phy error mask registers are programmed already
in ath9k_ani_restart(), so there is no need to set them
in ath9k_ani_reset().

Cc: stable@vger.kernel.org
Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ani.c | 11 -----------
 1 file changed, 11 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ani.c b/drivers/net/wireless/ath/ath9k/ani.c
index 3ec4c53..059b756 100644
--- a/drivers/net/wireless/ath/ath9k/ani.c
+++ b/drivers/net/wireless/ath/ath9k/ani.c
@@ -368,18 +368,7 @@ void ath9k_ani_reset(struct ath_hw *ah, bool is_scanning)
 	ath9k_hw_set_ofdm_nil(ah, ofdm_nil, is_scanning);
 	ath9k_hw_set_cck_nil(ah, cck_nil, is_scanning);
 
-	/*
-	 * enable phy counters if hw supports or if not, enable phy
-	 * interrupts (so we can count each one)
-	 */
 	ath9k_ani_restart(ah);
-
-	ENABLE_REGWRITE_BUFFER(ah);
-
-	REG_WRITE(ah, AR_PHY_ERR_MASK_1, AR_PHY_ERR_OFDM_TIMING);
-	REG_WRITE(ah, AR_PHY_ERR_MASK_2, AR_PHY_ERR_CCK_TIMING);
-
-	REGWRITE_BUFFER_FLUSH(ah);
 }
 
 static bool ath9k_hw_ani_read_counters(struct ath_hw *ah)
-- 
1.8.3

