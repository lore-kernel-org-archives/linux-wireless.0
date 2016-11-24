Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:49908 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755878AbcKXGxk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 24 Nov 2016 01:53:40 -0500
From: miaoqing@codeaurora.org
To: kvalo@qca.qualcomm.com
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com,
        Miaoqing Pan <miaoqing@codeaurora.org>
Subject: [PATCH 3/3] ath9k: disable ACK_CTS for SOC chips in PTA mode
Date: Thu, 24 Nov 2016 14:53:22 +0800
Message-Id: <1479970402-13796-3-git-send-email-miaoqing@codeaurora.org> (sfid-20161124_075343_561049_616D67AE)
In-Reply-To: <1479970402-13796-1-git-send-email-miaoqing@codeaurora.org>
References: <1479970402-13796-1-git-send-email-miaoqing@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Miaoqing Pan <miaoqing@codeaurora.org>

If the ACK_CTS is enabled, MAC will send an ACK or CTS in response
to a received frame, but it is a interfering packet for the BT(or other)
in the PTA cycle, which will sufficient corrupt the received packets.

Only disable it for SOC chips in PTA(slotted) mode.

Signed-off-by: Miaoqing Pan <miaoqing@codeaurora.org>
---
 drivers/net/wireless/ath/ath9k/btcoex.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/btcoex.c b/drivers/net/wireless/ath/ath9k/btcoex.c
index 6d15dd3..7e24640 100644
--- a/drivers/net/wireless/ath/ath9k/btcoex.c
+++ b/drivers/net/wireless/ath/ath9k/btcoex.c
@@ -290,6 +290,7 @@ static void ath9k_hw_btcoex_enable_3wire(struct ath_hw *ah)
 	struct ath_btcoex_hw *btcoex = &ah->btcoex_hw;
 	u32  val;
 	int i;
+	int coex_mode = MS(btcoex->bt_coex_mode, AR_BT_MODE);
 
 	/*
 	 * Program coex mode and weight registers to
@@ -319,7 +320,11 @@ static void ath9k_hw_btcoex_enable_3wire(struct ath_hw *ah)
 		REG_WRITE(ah, 0x50040, val);
 	}
 
-	REG_RMW_FIELD(ah, AR_QUIET1, AR_QUIET1_QUIET_ACK_CTS_ENABLE, 1);
+	if (AR_SREV_SOC(ah) && (coex_mode == ATH_BT_COEX_MODE_SLOTTED))
+		REG_RMW_FIELD(ah, AR_QUIET1, AR_QUIET1_QUIET_ACK_CTS_ENABLE, 0);
+	else
+		REG_RMW_FIELD(ah, AR_QUIET1, AR_QUIET1_QUIET_ACK_CTS_ENABLE, 1);
+
 	REG_RMW_FIELD(ah, AR_PCU_MISC, AR_PCU_BT_ANT_PREVENT_RX, 0);
 
 	ath9k_hw_gpio_request_out(ah, btcoex->wlanactive_gpio,
-- 
1.9.1
