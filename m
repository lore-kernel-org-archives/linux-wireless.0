Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:39336 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753909Ab0DZTEl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Apr 2010 15:04:41 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Felix Fietkau <nbd@openwrt.org>
Subject: [PATCH 09/13] ath9k_hw: use the configured power limit for AR9003
Date: Mon, 26 Apr 2010 15:04:37 -0400
Message-Id: <1272308681-32396-10-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1272308681-32396-1-git-send-email-lrodriguez@atheros.com>
References: <1272308681-32396-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Felix Fietkau <nbd@openwrt.org>

Since the new AR9003 EEPROM code does tune the card for the configured
tx power level, we need to fill in the correct power limits in the TPC
part of the DMA descriptor.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c |    1 +
 drivers/net/wireless/ath/ath9k/ar9003_mac.c    |    3 +++
 drivers/net/wireless/ath/ath9k/hw.h            |    1 +
 3 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
index 5d92be4..79b0e28 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
@@ -1817,6 +1817,7 @@ static void ath9k_hw_ar9300_set_txpower(struct ath_hw *ah,
 					u8 twiceMaxRegulatoryPower,
 					u8 powerLimit)
 {
+	ah->txpower_limit = powerLimit;
 	ar9003_hw_set_target_power_eeprom(ah, chan->channel);
 	ar9003_hw_calibration_apply(ah, chan->channel);
 }
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_mac.c b/drivers/net/wireless/ath/ath9k/ar9003_mac.c
index 7d111fb..37ba374 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_mac.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_mac.c
@@ -311,6 +311,9 @@ static void ar9003_hw_set11n_txdesc(struct ath_hw *ah, void *ds,
 {
 	struct ar9003_txc *ads = (struct ar9003_txc *) ds;
 
+	if (txpower > ah->txpower_limit)
+		txpower = ah->txpower_limit;
+
 	txpower += ah->txpower_indexoffset;
 	if (txpower > 63)
 		txpower = 63;
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index bc682da..77245df 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -719,6 +719,7 @@ struct ath_hw {
 	u32 *addac5416_21;
 	u32 *bank6Temp;
 
+	u8 txpower_limit;
 	int16_t txpower_indexoffset;
 	int coverage_class;
 	u32 beacon_interval;
-- 
1.6.3.3

