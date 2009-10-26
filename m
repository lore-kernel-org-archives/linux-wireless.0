Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:55685 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751800AbZJZOi5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Oct 2009 10:38:57 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 4/4] ath9k_hw: add some debug print for hw initialization
Date: Mon, 26 Oct 2009 10:39:01 -0400
Message-Id: <1256567941-26859-5-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1256567941-26859-1-git-send-email-lrodriguez@atheros.com>
References: <1256567941-26859-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This helps debugging hw bring up.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/calib.c |    3 +++
 drivers/net/wireless/ath/ath9k/hw.c    |    8 ++++++++
 2 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/calib.c b/drivers/net/wireless/ath/ath9k/calib.c
index 551f880..07b7618 100644
--- a/drivers/net/wireless/ath/ath9k/calib.c
+++ b/drivers/net/wireless/ath/ath9k/calib.c
@@ -1084,6 +1084,9 @@ static bool ar9285_clc(struct ath_hw *ah, struct ath9k_channel *chan)
 {
 	struct ath_common *common = ath9k_hw_common(ah);
 
+	ath_print(common, ATH_DBG_CALIBRATE, "Running carrier leakage "
+		  "calibration fix\n");
+
 	REG_SET_BIT(ah, AR_PHY_CL_CAL_CTL, AR_PHY_CL_CAL_ENABLE);
 	if (IS_CHAN_HT20(chan)) {
 		REG_SET_BIT(ah, AR_PHY_CL_CAL_CTL, AR_PHY_PARALLEL_CAL_ENABLE);
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 50be381..04b6afc 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1005,8 +1005,11 @@ int ath9k_hw_init(struct ath_hw *ah)
 static void ath9k_hw_init_bb(struct ath_hw *ah,
 			     struct ath9k_channel *chan)
 {
+	struct ath_common *common = ath9k_hw_common(ah);
 	u32 synthDelay;
 
+	ath_print(common, ATH_DBG_RESET, "initializing baseband\n");
+
 	synthDelay = REG_READ(ah, AR_PHY_RX_DELAY) & AR_PHY_RX_DELAY_DELAY;
 	if (IS_CHAN_B(chan))
 		synthDelay = (4 * synthDelay) / 22;
@@ -1591,6 +1594,8 @@ static inline void ath9k_hw_set_dma(struct ath_hw *ah)
 {
 	u32 regval;
 
+	ath_print(ath9k_hw_common(ah), ATH_DBG_RESET,
+		  "Configuring DMA read/write settings\n");
 	/*
 	 * set AHB_MODE not to do cacheline prefetches
 	*/
@@ -2145,6 +2150,9 @@ int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 	/*
 	 * For big endian systems turn on swapping for descriptors
 	 */
+	ath_print(common, ATH_DBG_RESET,
+		  "Configuring byte swap settings\n");
+
 	if (AR_SREV_9100(ah)) {
 		u32 mask;
 		mask = REG_READ(ah, AR_CFG);
-- 
1.6.0.4

