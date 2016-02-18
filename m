Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:58359 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1425542AbcBRJUP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Feb 2016 04:20:15 -0500
From: miaoqing@codeaurora.org
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com,
	kvalo@qca.qualcomm.com, Miaoqing Pan <miaoqing@codeaurora.org>
Subject: [PATCH] ath9k: clear bb filter calibration power threshold
Date: Thu, 18 Feb 2016 17:20:02 +0800
Message-Id: <1455787202-8194-1-git-send-email-miaoqing@codeaurora.org> (sfid-20160218_102023_472895_FE8F63C6)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Miaoqing Pan <miaoqing@codeaurora.org>

JP WiFi certification for bandwidth of channel 14 failed, the OBW
is lower than the requirement. Clear the bb filter calibration power
threshold to increase OBW(+2). The fix only for qca9531 chip now.

Signed-off-by: Miaoqing Pan <miaoqing@codeaurora.org>
---
 drivers/net/wireless/ath/ath9k/ar9003_phy.c | 7 ++++++-
 drivers/net/wireless/ath/ath9k/ar9003_phy.h | 3 +++
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.c b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
index 201425e..ac1586a 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
@@ -976,9 +976,14 @@ static int ar9003_hw_process_ini(struct ath_hw *ah,
 	/*
 	 * JAPAN regulatory.
 	 */
-	if (chan->channel == 2484)
+	if (chan->channel == 2484) {
 		ar9003_hw_prog_ini(ah, &ah->iniCckfirJapan2484, 1);
 
+		if (AR_SREV_9531(ah))
+			REG_RMW_FIELD(ah, AR_PHY_FCAL_2_0,
+				      AR_PHY_FLC_PWR_THRESH, 0);
+	}
+
 	ah->modes_index = modesIndex;
 	ar9003_hw_override_ini(ah);
 	ar9003_hw_set_channel_regs(ah, chan);
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.h b/drivers/net/wireless/ath/ath9k/ar9003_phy.h
index c5f8bc4..566da78 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.h
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.h
@@ -487,6 +487,9 @@
 #define AR_PHY_ADDAC_PARA_CTL    (AR_SM_BASE + 0x150)
 #define AR_PHY_XPA_CFG           (AR_SM_BASE + 0x158)
 
+#define AR_PHY_FLC_PWR_THRESH		7
+#define AR_PHY_FLC_PWR_THRESH_S		0
+
 #define AR_PHY_FRAME_CTL_CF_OVERLAP_WINDOW  3
 #define AR_PHY_FRAME_CTL_CF_OVERLAP_WINDOW_S    0
 
-- 
1.9.1

