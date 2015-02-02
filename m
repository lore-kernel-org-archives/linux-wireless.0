Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:54292 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755314AbbBBMsW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Feb 2015 07:48:22 -0500
Received: from [117.216.55.194] (port=15247 helo=sujith-pixel.qualcomm.com)
	by server72.web-hosting.com with esmtpsa (UNKNOWN:AES128-SHA256:128)
	(Exim 4.82)
	(envelope-from <sujith@msujith.org>)
	id 1YIGQP-002djK-0R
	for linux-wireless@vger.kernel.org; Mon, 02 Feb 2015 07:48:21 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 5/6] ath9k: Clear TSF2 properly
Date: Mon,  2 Feb 2015 18:21:12 +0530
Message-Id: <1422881473-24580-6-git-send-email-sujith@msujith.org> (sfid-20150202_135443_563523_1C6ABF40)
In-Reply-To: <1422881473-24580-1-git-send-email-sujith@msujith.org>
References: <1422881473-24580-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Chips in the AR9003 family have a second TSF, which
needs to be cleared when putting the card to
sleep.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_wow.c | 9 +++++++++
 drivers/net/wireless/ath/ath9k/reg.h        | 2 ++
 2 files changed, 11 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_wow.c b/drivers/net/wireless/ath/ath9k/ar9003_wow.c
index cf45b91..2dc50a0 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_wow.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_wow.c
@@ -35,6 +35,15 @@ static void ath9k_hw_set_powermode_wow_sleep(struct ath_hw *ah)
 		return;
 	}
 
+	if (AR_SREV_9462(ah) || AR_SREV_9565(ah)) {
+		if (!REG_READ(ah, AR_MAC_PCU_GEN_TIMER_TSF_SEL))
+			REG_CLR_BIT(ah, AR_DIRECT_CONNECT, AR_DC_TSF2_ENABLE);
+	} else if (AR_SREV_9485(ah)){
+		if (!(REG_READ(ah, AR_NDP2_TIMER_MODE) &
+		      AR_GEN_TIMERS2_MODE_ENABLE_MASK))
+			REG_CLR_BIT(ah, AR_DIRECT_CONNECT, AR_DC_TSF2_ENABLE);
+	}
+
 	REG_WRITE(ah, AR_RTC_FORCE_WAKE, AR_RTC_FORCE_WAKE_ON_INT);
 }
 
diff --git a/drivers/net/wireless/ath/ath9k/reg.h b/drivers/net/wireless/ath/ath9k/reg.h
index b1b803d..9587ec6 100644
--- a/drivers/net/wireless/ath/ath9k/reg.h
+++ b/drivers/net/wireless/ath/ath9k/reg.h
@@ -1883,6 +1883,7 @@ enum {
 #define AR_FIRST_NDP_TIMER                  7
 #define AR_NDP2_PERIOD                      0x81a0
 #define AR_NDP2_TIMER_MODE                  0x81c0
+#define AR_GEN_TIMERS2_MODE_ENABLE_MASK     0x000000FF
 
 #define AR_GEN_TIMERS(_i)                   (0x8200 + ((_i) << 2))
 #define AR_NEXT_TBTT_TIMER                  AR_GEN_TIMERS(0)
@@ -1978,6 +1979,7 @@ enum {
 
 #define AR_DIRECT_CONNECT                              0x83a0
 #define AR_DC_AP_STA_EN                                0x00000001
+#define AR_DC_TSF2_ENABLE                              0x00000001
 
 #define AR_AES_MUTE_MASK0       0x805c
 #define AR_AES_MUTE_MASK0_FC    0x0000FFFF
-- 
2.2.2

