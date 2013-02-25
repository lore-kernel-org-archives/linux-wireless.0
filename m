Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:49163 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754631Ab3BYTvV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Feb 2013 14:51:21 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, mcgrof@qca.qualcomm.com
Subject: [PATCH 3.9] ath9k_hw: improve reset reliability after errors
Date: Mon, 25 Feb 2013 20:51:07 +0100
Message-Id: <1361821867-62278-1-git-send-email-nbd@openwrt.org> (sfid-20130225_205124_759008_084D3FC2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On many different chips, important aspects of the MAC state are not
fully cleared by a warm reset. This can show up as tx/rx hangs, those
annoying "DMA failed to stop in 10 ms..." messages or other quirks.

On AR933x, the chip can occasionally get stuck in a way that only a
driver unload/reload or a reboot would bring it back to life.

With this patch, a full reset is issued when bringing the chip out of
FULL-SLEEP state (after idle), or if either Rx or Tx was not shut down
properly. This makes the DMA related error messages disappear completely
in my tests on AR933x, and the chip does not get stuck anymore.

Cc: stable@vger.kernel.org
Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/hw.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 42cf3c7..7b485e4 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1463,7 +1463,9 @@ static bool ath9k_hw_chip_reset(struct ath_hw *ah,
 			reset_type = ATH9K_RESET_POWER_ON;
 		else
 			reset_type = ATH9K_RESET_COLD;
-	}
+	} else if (ah->chip_fullsleep || REG_READ(ah, AR_Q_TXE) ||
+		   (REG_READ(ah, AR_CR) & AR_CR_RXE))
+		reset_type = ATH9K_RESET_COLD;
 
 	if (!ath9k_hw_set_reset_reg(ah, reset_type))
 		return false;
-- 
1.8.0.2

