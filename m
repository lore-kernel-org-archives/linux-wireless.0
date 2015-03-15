Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static.88-198-24-112.clients.your-server.de ([88.198.24.112]:43207
	"EHLO nbd.name" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751058AbbCOHHJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Mar 2015 03:07:09 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, lorenzo.bianconi83@gmail.com
Subject: [PATCH 4.0] ath9k: disable TPC support again (for now)
Date: Sun, 15 Mar 2015 08:07:04 +0100
Message-Id: <1426403224-23795-1-git-send-email-nbd@openwrt.org> (sfid-20150315_080716_449547_F00AA0C9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

TPC support has been observed to cause some tx power fluctuations on
some devices with at least AR934x and AR938x chips.
Disable it for now until the bugs have been found and fixed

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/hw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 60aa8d7..8529014 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -424,7 +424,7 @@ static void ath9k_hw_init_defaults(struct ath_hw *ah)
 	ah->power_mode = ATH9K_PM_UNDEFINED;
 	ah->htc_reset_init = true;
 
-	ah->tpc_enabled = true;
+	ah->tpc_enabled = false;
 
 	ah->ani_function = ATH9K_ANI_ALL;
 	if (!AR_SREV_9300_20_OR_LATER(ah))
-- 
2.2.2

