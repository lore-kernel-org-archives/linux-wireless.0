Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:54720 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751307Ab0DODaw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Apr 2010 23:30:52 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Felix Fietkau <nbd@openwrt.org>
Subject: [PATCH v2 03/97] ath9k_hw: add a macro for abstracting generic timer access
Date: Wed, 14 Apr 2010 23:29:17 -0400
Message-Id: <1271302251-9075-4-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1271302251-9075-1-git-send-email-lrodriguez@atheros.com>
References: <1271302251-9075-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Felix Fietkau <nbd@openwrt.org>

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/reg.h |   38 +++++++++++++++++----------------
 1 files changed, 20 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/reg.h b/drivers/net/wireless/ath/ath9k/reg.h
index 5ab6d6e..68d55a2 100644
--- a/drivers/net/wireless/ath/ath9k/reg.h
+++ b/drivers/net/wireless/ath/ath9k/reg.h
@@ -1610,24 +1610,26 @@ enum {
 #define AR_FIRST_NDP_TIMER                  7
 #define AR_NDP2_PERIOD                      0x81a0
 #define AR_NDP2_TIMER_MODE                  0x81c0
-#define AR_NEXT_TBTT_TIMER                  0x8200
-#define AR_NEXT_DMA_BEACON_ALERT            0x8204
-#define AR_NEXT_SWBA                        0x8208
-#define AR_NEXT_CFP                         0x8208
-#define AR_NEXT_HCF                         0x820C
-#define AR_NEXT_TIM                         0x8210
-#define AR_NEXT_DTIM                        0x8214
-#define AR_NEXT_QUIET_TIMER                 0x8218
-#define AR_NEXT_NDP_TIMER                   0x821C
-
-#define AR_BEACON_PERIOD                    0x8220
-#define AR_DMA_BEACON_PERIOD                0x8224
-#define AR_SWBA_PERIOD                      0x8228
-#define AR_HCF_PERIOD                       0x822C
-#define AR_TIM_PERIOD                       0x8230
-#define AR_DTIM_PERIOD                      0x8234
-#define AR_QUIET_PERIOD                     0x8238
-#define AR_NDP_PERIOD                       0x823C
+
+#define AR_GEN_TIMERS(_i)                   (0x8200 + ((_i) << 2))
+#define AR_NEXT_TBTT_TIMER                  AR_GEN_TIMERS(0)
+#define AR_NEXT_DMA_BEACON_ALERT            AR_GEN_TIMERS(1)
+#define AR_NEXT_SWBA                        AR_GEN_TIMERS(2)
+#define AR_NEXT_CFP                         AR_GEN_TIMERS(2)
+#define AR_NEXT_HCF                         AR_GEN_TIMERS(3)
+#define AR_NEXT_TIM                         AR_GEN_TIMERS(4)
+#define AR_NEXT_DTIM                        AR_GEN_TIMERS(5)
+#define AR_NEXT_QUIET_TIMER                 AR_GEN_TIMERS(6)
+#define AR_NEXT_NDP_TIMER                   AR_GEN_TIMERS(7)
+
+#define AR_BEACON_PERIOD                    AR_GEN_TIMERS(8)
+#define AR_DMA_BEACON_PERIOD                AR_GEN_TIMERS(9)
+#define AR_SWBA_PERIOD                      AR_GEN_TIMERS(10)
+#define AR_HCF_PERIOD                       AR_GEN_TIMERS(11)
+#define AR_TIM_PERIOD                       AR_GEN_TIMERS(12)
+#define AR_DTIM_PERIOD                      AR_GEN_TIMERS(13)
+#define AR_QUIET_PERIOD                     AR_GEN_TIMERS(14)
+#define AR_NDP_PERIOD                       AR_GEN_TIMERS(15)
 
 #define AR_TIMER_MODE                       0x8240
 #define AR_TBTT_TIMER_EN                    0x00000001
-- 
1.6.3.3

