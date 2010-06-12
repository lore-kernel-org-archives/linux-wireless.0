Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:43210 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751603Ab0FLEeF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 Jun 2010 00:34:05 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 08/24] ath9k_hw: enable ANI for AR9003
Date: Sat, 12 Jun 2010 00:33:46 -0400
Message-Id: <1276317242-15540-9-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1276317242-15540-1-git-send-email-lrodriguez@atheros.com>
References: <1276317242-15540-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

AR9003 has been tested with the new ANI implementation
and so ANI can now be enabled for that family.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/hw.c |    8 +-------
 1 files changed, 1 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 739be8f..874c4e9 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -375,13 +375,7 @@ static void ath9k_hw_init_config(struct ath_hw *ah)
 	ah->config.ofdm_trig_high = 500;
 	ah->config.cck_trig_high = 200;
 	ah->config.cck_trig_low = 100;
-
-	/*
-	 * For now ANI is disabled for AR9003, it is still
-	 * being tested.
-	 */
-	if (!AR_SREV_9300_20_OR_LATER(ah))
-		ah->config.enable_ani = 1;
+	ah->config.enable_ani = true;
 
 	for (i = 0; i < AR_EEPROM_MODAL_SPURS; i++) {
 		ah->config.spurchans[i][0] = AR_NO_SPUR;
-- 
1.6.3.3

