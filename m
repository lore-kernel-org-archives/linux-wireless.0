Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:33462 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752059AbaKKHGG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Nov 2014 02:06:06 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com,
	Kobi Cohen-Arazi <kobic@qti.qualcomm.com>
Subject: [PATCH 6/6] ath9k: Enable TSF2 for generic HW timers
Date: Tue, 11 Nov 2014 12:37:24 +0530
Message-Id: <1415689644-29693-7-git-send-email-sujith@msujith.org> (sfid-20141111_080616_398593_6F66FC21)
In-Reply-To: <1415689644-29693-1-git-send-email-sujith@msujith.org>
References: <1415689644-29693-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

The base TSF is used for HW timers 0..7, but chips
in the AR9003 family and above can support more generic
timers. To use them, however, a second HW TSF needs to
be enabled. This patch allows usage of the extra
timers by starting the second TSF properly.

The extra set of HW timers is apparently also present
in AR9287, but we enable it only for the AR9003 family.

Cc: Kobi Cohen-Arazi <kobic@qti.qualcomm.com>
Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/hw.c  | 23 ++++++++++++++++++++++-
 drivers/net/wireless/ath/ath9k/hw.h  |  2 ++
 drivers/net/wireless/ath/ath9k/reg.h |  3 +++
 3 files changed, 27 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 04ae1f8..11a1fbd 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1941,6 +1941,8 @@ int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 
 	REGWRITE_BUFFER_FLUSH(ah);
 
+	ath9k_hw_gen_timer_start_tsf2(ah);
+
 	ath9k_hw_init_desc(ah);
 
 	if (ath9k_hw_btcoex_is_enabled(ah))
@@ -2905,6 +2907,16 @@ u32 ath9k_hw_gettsf32(struct ath_hw *ah)
 }
 EXPORT_SYMBOL(ath9k_hw_gettsf32);
 
+void ath9k_hw_gen_timer_start_tsf2(struct ath_hw *ah)
+{
+	struct ath_gen_timer_table *timer_table = &ah->hw_gen_timers;
+
+	if (timer_table->tsf2_enabled) {
+		REG_SET_BIT(ah, AR_DIRECT_CONNECT, AR_DC_AP_STA_EN);
+		REG_SET_BIT(ah, AR_RESET_TSF, AR_RESET_TSF2_ONCE);
+	}
+}
+
 struct ath_gen_timer *ath_gen_timer_alloc(struct ath_hw *ah,
 					  void (*trigger)(void *),
 					  void (*overflow)(void *),
@@ -2915,7 +2927,11 @@ struct ath_gen_timer *ath_gen_timer_alloc(struct ath_hw *ah,
 	struct ath_gen_timer *timer;
 
 	if ((timer_index < AR_FIRST_NDP_TIMER) ||
-		(timer_index >= ATH_MAX_GEN_TIMER))
+	    (timer_index >= ATH_MAX_GEN_TIMER))
+		return NULL;
+
+	if ((timer_index > AR_FIRST_NDP_TIMER) &&
+	    !AR_SREV_9300_20_OR_LATER(ah))
 		return NULL;
 
 	timer = kzalloc(sizeof(struct ath_gen_timer), GFP_KERNEL);
@@ -2929,6 +2945,11 @@ struct ath_gen_timer *ath_gen_timer_alloc(struct ath_hw *ah,
 	timer->overflow = overflow;
 	timer->arg = arg;
 
+	if ((timer_index > AR_FIRST_NDP_TIMER) && !timer_table->tsf2_enabled) {
+		timer_table->tsf2_enabled = true;
+		ath9k_hw_gen_timer_start_tsf2(ah);
+	}
+
 	return timer;
 }
 EXPORT_SYMBOL(ath_gen_timer_alloc);
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 10ab060..a4f0f65 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -525,6 +525,7 @@ struct ath_gen_timer {
 struct ath_gen_timer_table {
 	struct ath_gen_timer *timers[ATH_MAX_GEN_TIMER];
 	u16 timer_mask;
+	bool tsf2_enabled;
 };
 
 struct ath_hw_antcomb_conf {
@@ -1036,6 +1037,7 @@ void ath9k_hw_gen_timer_start(struct ath_hw *ah,
 			      struct ath_gen_timer *timer,
 			      u32 timer_next,
 			      u32 timer_period);
+void ath9k_hw_gen_timer_start_tsf2(struct ath_hw *ah);
 void ath9k_hw_gen_timer_stop(struct ath_hw *ah, struct ath_gen_timer *timer);
 
 void ath_gen_timer_free(struct ath_hw *ah, struct ath_gen_timer *timer);
diff --git a/drivers/net/wireless/ath/ath9k/reg.h b/drivers/net/wireless/ath/ath9k/reg.h
index 1c0b1c1..ced36b4 100644
--- a/drivers/net/wireless/ath/ath9k/reg.h
+++ b/drivers/net/wireless/ath/ath9k/reg.h
@@ -1605,6 +1605,7 @@ enum {
 
 #define AR_RESET_TSF        0x8020
 #define AR_RESET_TSF_ONCE   0x01000000
+#define AR_RESET_TSF2_ONCE  0x02000000
 
 #define AR_MAX_CFP_DUR      0x8038
 #define AR_CFP_VAL          0x0000FFFF
@@ -1966,6 +1967,8 @@ enum {
 #define AR_MAC_PCU_ASYNC_FIFO_REG3_SOFT_RESET		0x80000000
 #define AR_MAC_PCU_GEN_TIMER_TSF_SEL			0x83d8
 
+#define AR_DIRECT_CONNECT                              0x83a0
+#define AR_DC_AP_STA_EN                                0x00000001
 
 #define AR_AES_MUTE_MASK0       0x805c
 #define AR_AES_MUTE_MASK0_FC    0x0000FFFF
-- 
2.1.3

