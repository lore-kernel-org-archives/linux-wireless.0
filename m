Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:59272 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757441Ab0LBLPF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Dec 2010 06:15:05 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 02 Dec 2010 03:14:51 -0800
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH V2 21/27] ath9k_hw: Program appropriate chianmask for AR9485 before starting AGC/IQ cal
Date: Thu, 2 Dec 2010 03:07:05 -0800
Message-ID: <1291288031-3409-22-git-send-email-vasanth@atheros.com>
In-Reply-To: <1291288031-3409-1-git-send-email-vasanth@atheros.com>
References: <1291288031-3409-1-git-send-email-vasanth@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_calib.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_calib.c b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
index 4c94c9e..f218613 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_calib.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
@@ -723,7 +723,9 @@ static bool ar9003_hw_init_cal(struct ath_hw *ah,
 	val = REG_READ(ah, AR_ENT_OTP);
 	ath_print(common, ATH_DBG_CALIBRATE, "ath9k: AR_ENT_OTP 0x%x\n", val);
 
-	if (val & AR_ENT_OTP_CHAIN2_DISABLE)
+	if (AR_SREV_9485(ah))
+		ar9003_hw_set_chain_masks(ah, 0x1, 0x1);
+	else if (val & AR_ENT_OTP_CHAIN2_DISABLE)
 		ar9003_hw_set_chain_masks(ah, 0x3, 0x3);
 	else
 		/*
-- 
1.7.0.4

