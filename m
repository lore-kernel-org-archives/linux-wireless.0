Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:60266 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750978Ab2IKFRW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Sep 2012 01:17:22 -0400
From: Sujith Manoharan <c_manoha@qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20558.51496.575142.581841@gargle.gargle.HOWL> (sfid-20120911_071726_916440_28E81247)
Date: Tue, 11 Sep 2012 10:46:24 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 1/2] ath9k_hw: Handle gentimer termination properly
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/hw.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index cb90321..40f57aa 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -3080,6 +3080,16 @@ void ath9k_hw_gen_timer_stop(struct ath_hw *ah, struct ath_gen_timer *timer)
 	REG_CLR_BIT(ah, gen_tmr_configuration[timer->index].mode_addr,
 			gen_tmr_configuration[timer->index].mode_mask);
 
+	if (AR_SREV_9462(ah) || AR_SREV_9565(ah)) {
+		/*
+		 * Need to switch back to TSF if it was using TSF2.
+		 */
+		if ((timer->index >= AR_GEN_TIMER_BANK_1_LEN)) {
+			REG_CLR_BIT(ah, AR_MAC_PCU_GEN_TIMER_TSF_SEL,
+				    (1 << timer->index));
+		}
+	}
+
 	/* Disable both trigger and thresh interrupt masks */
 	REG_CLR_BIT(ah, AR_IMR_S5,
 		(SM(AR_GENTMR_BIT(timer->index), AR_IMR_S5_GENTIMER_THRESH) |
-- 
1.7.12

