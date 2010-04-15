Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:60938 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757263Ab0DOVjm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Apr 2010 17:39:42 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH v3 08/97] ath9k_hw: remove wrapper ath9k_hw_write_regs()
Date: Thu, 15 Apr 2010 17:38:13 -0400
Message-Id: <1271367582-992-9-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1271367582-992-1-git-send-email-lrodriguez@atheros.com>
References: <1271367582-992-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is used only once by ath9k_hw_process_ini() to
write an array of phy registers through REG_WRITE_ARRAY(),
but we already call REG_WRITE_ARRAY() multiple times
on the same caller so just remove this pointless wrapper.
We'll eventually just move the ath9k_hw_process_ini()
caller as an callback to abstract away between different
hardware families.

Although this change is subtle I should note that this
does change the delay pattern on writing the next series
of registers. REG_WRITE_ARRAY() uses a counter for each
register write and does a udelay(1) every 64 writes. By
removing this call it means that the counter is processed
for all the iniBB_RfGain registers and is incremented
on ath9k_hw_process_ini(), before this the after the call
ath9k_hw_write_regs() was made the register counter was
kept at the same index number prior to the call.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/hw.c  |    2 +-
 drivers/net/wireless/ath/ath9k/phy.c |   15 ---------------
 drivers/net/wireless/ath/ath9k/phy.h |    3 ---
 3 files changed, 1 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 0e85a24..f81e273 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1484,7 +1484,7 @@ static int ath9k_hw_process_ini(struct ath_hw *ah,
 					modesIndex, regWrites);
 	}
 
-	ath9k_hw_write_regs(ah, freqIndex, regWrites);
+	REG_WRITE_ARRAY(&ah->iniBB_RfGain, freqIndex, regWrites);
 
 	if (AR_SREV_9280_20(ah) && IS_CHAN_A_5MHZ_SPACED(chan)) {
 		REG_WRITE_ARRAY(&ah->iniModesAdditional, modesIndex,
diff --git a/drivers/net/wireless/ath/ath9k/phy.c b/drivers/net/wireless/ath/ath9k/phy.c
index 2547b3c..c45f5b8 100644
--- a/drivers/net/wireless/ath/ath9k/phy.c
+++ b/drivers/net/wireless/ath/ath9k/phy.c
@@ -44,21 +44,6 @@
 #include "hw.h"
 
 /**
- * ath9k_hw_write_regs - ??
- *
- * @ah: atheros hardware structure
- * @freqIndex:
- * @regWrites:
- *
- * Used for both the chipsets with an external AR2133/AR5133 radios and
- * single-chip devices.
- */
-void ath9k_hw_write_regs(struct ath_hw *ah, u32 freqIndex, int regWrites)
-{
-	REG_WRITE_ARRAY(&ah->iniBB_RfGain, freqIndex, regWrites);
-}
-
-/**
  * ath9k_hw_ar9280_set_channel - set channel on single-chip device
  * @ah: atheros hardware structure
  * @chan:
diff --git a/drivers/net/wireless/ath/ath9k/phy.h b/drivers/net/wireless/ath/ath9k/phy.h
index 0132e4c..4b6e494 100644
--- a/drivers/net/wireless/ath/ath9k/phy.h
+++ b/drivers/net/wireless/ath/ath9k/phy.h
@@ -17,9 +17,6 @@
 #ifndef PHY_H
 #define PHY_H
 
-/* Common between single chip and non single-chip solutions */
-void ath9k_hw_write_regs(struct ath_hw *ah, u32 freqIndex, int regWrites);
-
 /* Single chip radio settings */
 int ath9k_hw_ar9280_set_channel(struct ath_hw *ah, struct ath9k_channel *chan);
 void ath9k_hw_9280_spur_mitigate(struct ath_hw *ah, struct ath9k_channel *chan);
-- 
1.6.3.3

