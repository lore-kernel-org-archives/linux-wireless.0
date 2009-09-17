Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:21651 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760657AbZIQD5y (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Sep 2009 23:57:54 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 16 Sep 2009 20:57:58 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19121.46023.94384.92577@gargle.gargle.HOWL>
Date: Thu, 17 Sep 2009 09:27:59 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 09/12] ath9k: Fix AHB reset for AR9280
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Vivek Natarajan <vnatarajan@atheros.com>

The commit "ath9k: Do an AHB reset before doing RTC reset"
fixed RTC reset issue for AR9280 2.0 chipsets and above.
The fix is valid for all AR9280 chipsets.

Signed-off-by: Vivek Natarajan <vnatarajan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/hw.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 323df96..8146826 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1793,7 +1793,7 @@ static void ath9k_hw_set_regs(struct ath_hw *ah, struct ath9k_channel *chan,
 static bool ath9k_hw_chip_reset(struct ath_hw *ah,
 				struct ath9k_channel *chan)
 {
-	if (OLC_FOR_AR9280_20_LATER) {
+	if (AR_SREV_9280(ah) && ah->eep_ops->get_eeprom(ah, EEP_OL_PWRCTRL)) {
 		if (!ath9k_hw_set_reset_reg(ah, ATH9K_RESET_POWER_ON))
 			return false;
 	} else if (!ath9k_hw_set_reset_reg(ah, ATH9K_RESET_WARM))
-- 
1.6.4.3

