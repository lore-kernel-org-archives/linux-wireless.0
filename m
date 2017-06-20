Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:52402 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752665AbdFTBOF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Jun 2017 21:14:05 -0400
From: miaoqing@codeaurora.org
To: kvalo@qca.qualcomm.com
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com,
        sssa@qti.qualcomm.com, Miaoqing Pan <miaoqing@codeaurora.org>
Subject: [PATCH 2/2] ath9k: fix tx99 bus error
Date: Tue, 20 Jun 2017 09:13:40 +0800
Message-Id: <1497921220-12940-2-git-send-email-miaoqing@codeaurora.org> (sfid-20170620_031409_624070_99FABD4E)
In-Reply-To: <1497921220-12940-1-git-send-email-miaoqing@codeaurora.org>
References: <1497921220-12940-1-git-send-email-miaoqing@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Miaoqing Pan <miaoqing@codeaurora.org>

The hard coded register 0x9864 and 0x9924 are invalid
for ar9300 chips.

Signed-off-by: Miaoqing Pan <miaoqing@codeaurora.org>
---
 drivers/net/wireless/ath/ath9k/ar9003_phy.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.c b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
index ae304355..fe5102c 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
@@ -1821,8 +1821,6 @@ static void ar9003_hw_spectral_scan_wait(struct ath_hw *ah)
 static void ar9003_hw_tx99_start(struct ath_hw *ah, u32 qnum)
 {
 	REG_SET_BIT(ah, AR_PHY_TEST, PHY_AGC_CLR);
-	REG_SET_BIT(ah, 0x9864, 0x7f000);
-	REG_SET_BIT(ah, 0x9924, 0x7f00fe);
 	REG_CLR_BIT(ah, AR_DIAG_SW, AR_DIAG_RX_DIS);
 	REG_WRITE(ah, AR_CR, AR_CR_RXD);
 	REG_WRITE(ah, AR_DLCL_IFS(qnum), 0);
-- 
1.9.1
