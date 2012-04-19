Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:39567 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756169Ab2DSTSg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Apr 2012 15:18:36 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, mcgrof@qca.qualcomm.com
Subject: [PATCH v3 5/8] ath9k_hw: fix and clean up PHY activation delay
Date: Thu, 19 Apr 2012 21:18:26 +0200
Message-Id: <1334863109-95726-5-git-send-email-nbd@openwrt.org> (sfid-20120419_211842_234523_37F9024A)
In-Reply-To: <1334863109-95726-4-git-send-email-nbd@openwrt.org>
References: <1334863109-95726-1-git-send-email-nbd@openwrt.org>
 <1334863109-95726-2-git-send-email-nbd@openwrt.org>
 <1334863109-95726-3-git-send-email-nbd@openwrt.org>
 <1334863109-95726-4-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The delay calculation is the same for all chips, however some parts of the
code missed the extra delay factor for half/quarter.
Clean up the code and move the delay calculation to a common place.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ar5008_phy.c |   17 ++---------------
 drivers/net/wireless/ath/ath9k/ar9003_phy.c |   20 ++------------------
 drivers/net/wireless/ath/ath9k/hw.c         |   16 ++++++++++++++++
 drivers/net/wireless/ath/ath9k/hw.h         |    2 ++
 4 files changed, 22 insertions(+), 33 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar5008_phy.c b/drivers/net/wireless/ath/ath9k/ar5008_phy.c
index de30cb3..f554bff 100644
--- a/drivers/net/wireless/ath/ath9k/ar5008_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar5008_phy.c
@@ -618,19 +618,10 @@ static void ar5008_hw_init_bb(struct ath_hw *ah,
 	u32 synthDelay;
 
 	synthDelay = REG_READ(ah, AR_PHY_RX_DELAY) & AR_PHY_RX_DELAY_DELAY;
-	if (IS_CHAN_B(chan))
-		synthDelay = (4 * synthDelay) / 22;
-	else
-		synthDelay /= 10;
-
-	if (IS_CHAN_HALF_RATE(chan))
-		synthDelay *= 2;
-	else if (IS_CHAN_QUARTER_RATE(chan))
-		synthDelay *= 4;
 
 	REG_WRITE(ah, AR_PHY_ACTIVE, AR_PHY_ACTIVE_EN);
 
-	udelay(synthDelay + BASE_ACTIVATE_DELAY);
+	ath9k_hw_synth_delay(ah, chan, synthDelay);
 }
 
 static void ar5008_hw_init_chain_masks(struct ath_hw *ah)
@@ -948,12 +939,8 @@ static bool ar5008_hw_rfbus_req(struct ath_hw *ah)
 static void ar5008_hw_rfbus_done(struct ath_hw *ah)
 {
 	u32 synthDelay = REG_READ(ah, AR_PHY_RX_DELAY) & AR_PHY_RX_DELAY_DELAY;
-	if (IS_CHAN_B(ah->curchan))
-		synthDelay = (4 * synthDelay) / 22;
-	else
-		synthDelay /= 10;
 
-	udelay(synthDelay + BASE_ACTIVATE_DELAY);
+	ath9k_hw_synth_delay(ah, ah->curchan, synthDelay);
 
 	REG_WRITE(ah, AR_PHY_RFBUS_REQ, 0);
 }
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.c b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
index 4c8d0d7..a1c0879 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
@@ -526,22 +526,10 @@ static void ar9003_hw_init_bb(struct ath_hw *ah,
 	 * Value is in 100ns increments.
 	 */
 	synthDelay = REG_READ(ah, AR_PHY_RX_DELAY) & AR_PHY_RX_DELAY_DELAY;
-	if (IS_CHAN_B(chan))
-		synthDelay = (4 * synthDelay) / 22;
-	else
-		synthDelay /= 10;
 
 	/* Activate the PHY (includes baseband activate + synthesizer on) */
 	REG_WRITE(ah, AR_PHY_ACTIVE, AR_PHY_ACTIVE_EN);
-
-	/*
-	 * There is an issue if the AP starts the calibration before
-	 * the base band timeout completes.  This could result in the
-	 * rx_clear false triggering.  As a workaround we add delay an
-	 * extra BASE_ACTIVATE_DELAY usecs to ensure this condition
-	 * does not happen.
-	 */
-	udelay(synthDelay + BASE_ACTIVATE_DELAY);
+	ath9k_hw_synth_delay(ah, chan, synthDelay);
 }
 
 static void ar9003_hw_set_chain_masks(struct ath_hw *ah, u8 rx, u8 tx)
@@ -801,12 +789,8 @@ static bool ar9003_hw_rfbus_req(struct ath_hw *ah)
 static void ar9003_hw_rfbus_done(struct ath_hw *ah)
 {
 	u32 synthDelay = REG_READ(ah, AR_PHY_RX_DELAY) & AR_PHY_RX_DELAY_DELAY;
-	if (IS_CHAN_B(ah->curchan))
-		synthDelay = (4 * synthDelay) / 22;
-	else
-		synthDelay /= 10;
 
-	udelay(synthDelay + BASE_ACTIVATE_DELAY);
+	ath9k_hw_synth_delay(ah, ah->curchan, synthDelay);
 
 	REG_WRITE(ah, AR_PHY_RFBUS_REQ, 0);
 }
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 4dddffd..e576a92 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -191,6 +191,22 @@ bool ath9k_hw_wait(struct ath_hw *ah, u32 reg, u32 mask, u32 val, u32 timeout)
 }
 EXPORT_SYMBOL(ath9k_hw_wait);
 
+void ath9k_hw_synth_delay(struct ath_hw *ah, struct ath9k_channel *chan,
+			  int hw_delay)
+{
+	if (IS_CHAN_B(chan))
+		hw_delay = (4 * hw_delay) / 22;
+	else
+		hw_delay /= 10;
+
+	if (IS_CHAN_HALF_RATE(chan))
+		hw_delay *= 2;
+	else if (IS_CHAN_QUARTER_RATE(chan))
+		hw_delay *= 4;
+
+	udelay(hw_delay + BASE_ACTIVATE_DELAY);
+}
+
 void ath9k_hw_write_array(struct ath_hw *ah, struct ar5416IniArray *array,
 			  int column, unsigned int *writecnt)
 {
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index dd4b8f4..2b01e75 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -923,6 +923,8 @@ void ath9k_hw_set_gpio(struct ath_hw *ah, u32 gpio, u32 val);
 void ath9k_hw_setantenna(struct ath_hw *ah, u32 antenna);
 
 /* General Operation */
+void ath9k_hw_synth_delay(struct ath_hw *ah, struct ath9k_channel *chan,
+			  int hw_delay);
 bool ath9k_hw_wait(struct ath_hw *ah, u32 reg, u32 mask, u32 val, u32 timeout);
 void ath9k_hw_write_array(struct ath_hw *ah, struct ar5416IniArray *array,
 			  int column, unsigned int *writecnt);
-- 
1.7.3.2

