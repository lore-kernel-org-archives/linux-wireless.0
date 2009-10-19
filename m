Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:54703 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754271AbZJSGdm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Oct 2009 02:33:42 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linux-wireless@vger.kernel.org
Cc: ath9k-devel@lists.ath9k.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [RFT 13/15] ath9k_hw: remove unused modesIndex param from ath9k_hw_write_regs()
Date: Mon, 19 Oct 2009 02:33:44 -0400
Message-Id: <1255934026-20686-14-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1255934026-20686-1-git-send-email-lrodriguez@atheros.com>
References: <1255934026-20686-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/hw.c  |    2 +-
 drivers/net/wireless/ath/ath9k/phy.c |    4 +---
 drivers/net/wireless/ath/ath9k/phy.h |    3 +--
 3 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 65c106b..d435369 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1524,7 +1524,7 @@ static int ath9k_hw_process_ini(struct ath_hw *ah,
 		DO_DELAY(regWrites);
 	}
 
-	ath9k_hw_write_regs(ah, modesIndex, freqIndex, regWrites);
+	ath9k_hw_write_regs(ah, freqIndex, regWrites);
 
 	if (AR_SREV_9271_10(ah))
 		REG_WRITE_ARRAY(&ah->iniModes_9271_1_0_only,
diff --git a/drivers/net/wireless/ath/ath9k/phy.c b/drivers/net/wireless/ath/ath9k/phy.c
index 8e4c3bd..a15532e 100644
--- a/drivers/net/wireless/ath/ath9k/phy.c
+++ b/drivers/net/wireless/ath/ath9k/phy.c
@@ -45,15 +45,13 @@
  * ath9k_hw_write_regs - ??
  *
  * @ah: atheros hardware structure
- * @modesIndex:
  * @freqIndex:
  * @regWrites:
  *
  * Used for both the chipsets with an external AR2133/AR5133 radios and
  * single-chip devices.
  */
-void ath9k_hw_write_regs(struct ath_hw *ah, u32 modesIndex,
-			 u32 freqIndex, int regWrites)
+void ath9k_hw_write_regs(struct ath_hw *ah, u32 freqIndex, int regWrites)
 {
 	REG_WRITE_ARRAY(&ah->iniBB_RfGain, freqIndex, regWrites);
 }
diff --git a/drivers/net/wireless/ath/ath9k/phy.h b/drivers/net/wireless/ath/ath9k/phy.h
index 4420f80..a9b9a7d 100644
--- a/drivers/net/wireless/ath/ath9k/phy.h
+++ b/drivers/net/wireless/ath/ath9k/phy.h
@@ -18,8 +18,7 @@
 #define PHY_H
 
 /* Common between single chip and non single-chip solutions */
-void ath9k_hw_write_regs(struct ath_hw *ah, u32 modesIndex,
-			 u32 freqIndex, int regWrites);
+void ath9k_hw_write_regs(struct ath_hw *ah, u32 freqIndex, int regWrites);
 
 /* Single chip radio settings */
 int ath9k_hw_ar9280_set_channel(struct ath_hw *ah, struct ath9k_channel *chan);
-- 
1.6.0.4

