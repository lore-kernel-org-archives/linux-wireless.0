Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:58245 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751455AbbI2FYy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Sep 2015 01:24:54 -0400
From: miaoqing@codeaurora.org
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com,
	kvalo@qca.qualcomm.com, Miaoqing Pan <miaoqing@codeaurora.org>
Subject: [PATCH 2/2] ath9k: fix QCA9561 XLNA rxgain initial
Date: Tue, 29 Sep 2015 13:24:37 +0800
Message-Id: <1443504277-3482-2-git-send-email-miaoqing@codeaurora.org> (sfid-20150929_072457_312861_4B78934E)
In-Reply-To: <1443504277-3482-1-git-send-email-miaoqing@codeaurora.org>
References: <1443504277-3482-1-git-send-email-miaoqing@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Miaoqing Pan <miaoqing@codeaurora.org>

A small bugfix for commit ede6a5e7b859 ("ath9k: Add QCA956x HW support").
I guess I would have skipped renaming (that initial QCA956x commit has
been there already for almost a year with the "5g" in the name) and move
the call outside AR_SREV_9462_20_OR_LATER() to make it reachable.

Signed-off-by: Miaoqing Pan <miaoqing@codeaurora.org>
---
 drivers/net/wireless/ath/ath9k/ar9003_phy.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.c b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
index 296a69e..201425e 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
@@ -929,16 +929,15 @@ static int ar9003_hw_process_ini(struct ath_hw *ah,
 			REG_WRITE_ARRAY(&ah->ini_modes_rxgain_xlna,
 					modesIndex, regWrites);
 		}
-
-		if (AR_SREV_9561(ah) && (ar9003_hw_get_rx_gain_idx(ah) == 0))
-			REG_WRITE_ARRAY(&ah->ini_modes_rxgain_xlna,
-					modesIndex, regWrites);
 	}
 
 	if (AR_SREV_9550(ah) || AR_SREV_9561(ah))
 		REG_WRITE_ARRAY(&ah->ini_modes_rx_gain_bounds, modesIndex,
 				regWrites);
 
+	if (AR_SREV_9561(ah) && (ar9003_hw_get_rx_gain_idx(ah) == 0))
+		REG_WRITE_ARRAY(&ah->ini_modes_rxgain_xlna,
+				modesIndex, regWrites);
 	/*
 	 * TXGAIN initvals.
 	 */
-- 
1.9.1

