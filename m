Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f174.google.com ([209.85.211.174]:51194 "EHLO
	mail-yw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751812AbZIWK5i (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Sep 2009 06:57:38 -0400
Received: by ywh4 with SMTP id 4so690722ywh.33
        for <linux-wireless@vger.kernel.org>; Wed, 23 Sep 2009 03:57:42 -0700 (PDT)
Date: Wed, 23 Sep 2009 16:27:27 +0530
From: Vivek Natarajan <vivek.natraj@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] ath9k: Initialize txgain and rxgain for newer AR9287
	chipsets.
Message-ID: <20090923105727.GA13880@vivek-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Vivek Natarajan <vnatarajan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/hw.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index f74604d..7a4de3d 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -814,7 +814,7 @@ static void ath9k_hw_init_mode_regs(struct ath_hw *ah)
 
 static void ath9k_hw_init_mode_gain_regs(struct ath_hw *ah)
 {
-	if (AR_SREV_9287_11(ah))
+	if (AR_SREV_9287_11_OR_LATER(ah))
 		INIT_INI_ARRAY(&ah->iniModesRxGain,
 		ar9287Modes_rx_gain_9287_1_1,
 		ARRAY_SIZE(ar9287Modes_rx_gain_9287_1_1), 6);
@@ -825,7 +825,7 @@ static void ath9k_hw_init_mode_gain_regs(struct ath_hw *ah)
 	else if (AR_SREV_9280_20(ah))
 		ath9k_hw_init_rxgain_ini(ah);
 
-	if (AR_SREV_9287_11(ah)) {
+	if (AR_SREV_9287_11_OR_LATER(ah)) {
 		INIT_INI_ARRAY(&ah->iniModesTxGain,
 		ar9287Modes_tx_gain_9287_1_1,
 		ARRAY_SIZE(ar9287Modes_tx_gain_9287_1_1), 6);
-- 
1.6.4.4

