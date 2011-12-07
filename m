Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:35375 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755631Ab1LGMfi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Dec 2011 07:35:38 -0500
Cc: Jouni Malinen <jouni@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>,
	Rodriguez Luis <rodrigue@qca.qualcomm.com>,
	Balasubramanian senthilkumar <senthilb@qca.qualcomm.com>,
	Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>,
	Vivek Natarajan <nataraja@qualcomm.com>,
	<ath9k-devel@lists.ath9k.org>,
	Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [RFC] ath9k_hw: Fix handling of MCI interrupt
Date: Wed, 7 Dec 2011 18:05:12 +0530
Message-ID: <1323261312-20093-1-git-send-email-mohammed@qca.qualcomm.com> (sfid-20111207_133542_599015_67D6F552)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>

with the MCI code the MCI interrupt was not handled, as the interrupt
mask is zeroed out in the below code, fix thi

Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_mac.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_mac.c b/drivers/net/wireless/ath/ath9k/ar9003_mac.c
index 95587e3..962b52b 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_mac.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_mac.c
@@ -179,6 +179,8 @@ static bool ar9003_hw_get_isr(struct ath_hw *ah, enum ath9k_int *masked)
 	struct ath9k_hw_mci *mci = &ah->btcoex_hw.mci;
 	u32 sync_cause = 0, async_cause;
 
+	*masked = 0;
+
 	async_cause = REG_READ(ah, AR_INTR_ASYNC_CAUSE);
 
 	if (async_cause & (AR_INTR_MAC_IRQ | AR_INTR_ASYNC_MASK_MCI)) {
@@ -218,7 +220,6 @@ static bool ar9003_hw_get_isr(struct ath_hw *ah, enum ath9k_int *masked)
 
 	sync_cause = REG_READ(ah, AR_INTR_SYNC_CAUSE) & AR_INTR_SYNC_DEFAULT;
 
-	*masked = 0;
 
 	if (!isr && !sync_cause)
 		return false;
@@ -259,7 +260,7 @@ static bool ar9003_hw_get_isr(struct ath_hw *ah, enum ath9k_int *masked)
 			return false;
 		}
 
-		*masked = isr & ATH9K_INT_COMMON;
+		*masked |= isr & ATH9K_INT_COMMON;
 
 		if (ah->config.rx_intr_mitigation)
 			if (isr & (AR_ISR_RXMINTR | AR_ISR_RXINTM))
-- 
1.7.0.4

