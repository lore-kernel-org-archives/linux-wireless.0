Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:57633 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932411Ab0FBKYS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Jun 2010 06:24:18 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 02 Jun 2010 03:24:18 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19462.12698.575676.968491@gargle.gargle.HOWL>
Date: Wed, 2 Jun 2010 15:55:30 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 2/8] ath9k_hw: Configure byte swap for non AR9271 chips
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes programming the byte swap registers
for chipsets other than AR9271. This is needed for
AR7010.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/hw.c |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 1c541b4..81239ce 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1429,9 +1429,13 @@ int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 				"Setting CFG 0x%x\n", REG_READ(ah, AR_CFG));
 		}
 	} else {
-		/* Configure AR9271 target WLAN */
-                if (AR_SREV_9271(ah))
-			REG_WRITE(ah, AR_CFG, AR_CFG_SWRB | AR_CFG_SWTB);
+		if (common->bus_ops->ath_bus_type == ATH_USB) {
+			/* Configure AR9271 target WLAN */
+			if (AR_SREV_9271(ah))
+				REG_WRITE(ah, AR_CFG, AR_CFG_SWRB | AR_CFG_SWTB);
+			else
+				REG_WRITE(ah, AR_CFG, AR_CFG_SWTD | AR_CFG_SWRD);
+		}
 #ifdef __BIG_ENDIAN
                 else
 			REG_WRITE(ah, AR_CFG, AR_CFG_SWTD | AR_CFG_SWRD);
-- 
1.7.1

