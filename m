Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:45915 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751899Ab3FDKOa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Jun 2013 06:14:30 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 5/6] ath9k: Remove redundant code
Date: Tue,  4 Jun 2013 15:41:34 +0530
Message-Id: <1370340695-29003-5-git-send-email-sujith@msujith.org> (sfid-20130604_121433_055049_8657BEA1)
In-Reply-To: <1370340695-29003-1-git-send-email-sujith@msujith.org>
References: <1370340695-29003-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

The phy error mask registers are programmed already
in ath9k_ani_restart(), so there is no need to set them
in ath9k_ani_reset().

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ani.c | 11 -----------
 1 file changed, 11 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ani.c b/drivers/net/wireless/ath/ath9k/ani.c
index c8595f4..a68beb1 100644
--- a/drivers/net/wireless/ath/ath9k/ani.c
+++ b/drivers/net/wireless/ath/ath9k/ani.c
@@ -360,18 +360,7 @@ void ath9k_ani_reset(struct ath_hw *ah, bool is_scanning)
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

