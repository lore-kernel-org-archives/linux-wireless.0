Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:52214 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752698Ab3LRE2e (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Dec 2013 23:28:34 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH v2 07/10] ath9k: Remove ath9k_hw_gettsf32()
Date: Wed, 18 Dec 2013 09:53:24 +0530
Message-Id: <1387340607-20045-8-git-send-email-sujith@msujith.org> (sfid-20131218_052900_226290_BDBBF797)
In-Reply-To: <1387340607-20045-1-git-send-email-sujith@msujith.org>
References: <1387340607-20045-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

It is unnecessary and the value is just a simple,
direct register read.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_mci.c |  2 +-
 drivers/net/wireless/ath/ath9k/hw.c         | 10 ----------
 drivers/net/wireless/ath/ath9k/hw.h         |  1 -
 3 files changed, 1 insertion(+), 12 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_mci.c b/drivers/net/wireless/ath/ath9k/ar9003_mci.c
index 7b94a6c..e9cf1de 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_mci.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_mci.c
@@ -1263,7 +1263,7 @@ u32 ar9003_mci_state(struct ath_hw *ah, u32 state_type)
 		ar9003_mci_send_coex_bt_status_query(ah, true, query_type);
 		break;
 	case MCI_STATE_RECOVER_RX:
-		tsf = ath9k_hw_gettsf32(ah);
+		tsf = REG_READ(ah, AR_TSF_L32);
 		if ((tsf - mci->last_recovery) <= MCI_RECOVERY_DUR_TSF) {
 			ath_dbg(ath9k_hw_common(ah), MCI,
 				"(MCI) ignore Rx recovery\n");
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 4797cb2..40cc64b 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -2973,12 +2973,6 @@ static const struct ath_gen_timer_configuration gen_tmr_configuration[] =
 
 /* HW generic timer primitives */
 
-u32 ath9k_hw_gettsf32(struct ath_hw *ah)
-{
-	return REG_READ(ah, AR_TSF_L32);
-}
-EXPORT_SYMBOL(ath9k_hw_gettsf32);
-
 struct ath_gen_timer *ath_gen_timer_alloc(struct ath_hw *ah,
 					  void (*trigger)(void *),
 					  void (*overflow)(void *),
@@ -3137,10 +3131,6 @@ void ath_gen_timer_isr(struct ath_hw *ah)
 }
 EXPORT_SYMBOL(ath_gen_timer_isr);
 
-/********/
-/* HTC  */
-/********/
-
 static struct {
 	u32 version;
 	const char * name;
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 54932d8..ba0059f 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -978,7 +978,6 @@ void ath9k_hw_set_txpowerlimit(struct ath_hw *ah, u32 limit, bool test);
 void ath9k_hw_setopmode(struct ath_hw *ah);
 void ath9k_hw_setmcastfilter(struct ath_hw *ah, u32 filter0, u32 filter1);
 void ath9k_hw_write_associd(struct ath_hw *ah);
-u32 ath9k_hw_gettsf32(struct ath_hw *ah);
 u64 ath9k_hw_gettsf64(struct ath_hw *ah);
 void ath9k_hw_settsf64(struct ath_hw *ah, u64 tsf64);
 void ath9k_hw_reset_tsf(struct ath_hw *ah);
-- 
1.8.5.1

