Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:42258 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757609AbaKTNbp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Nov 2014 08:31:45 -0500
Received: by mail-wi0-f179.google.com with SMTP id ex7so5364502wid.6
        for <linux-wireless@vger.kernel.org>; Thu, 20 Nov 2014 05:31:44 -0800 (PST)
From: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: nbd@openwrt.org, thomas@net.t-labs.tu-berlin.de, adrian@freebsd.org
Subject: [RFC 1/3] ath9k: add chainmask parameter to ath9k_hw_get_scaled_power()
Date: Thu, 20 Nov 2014 14:31:38 +0100
Message-Id: <1416490300-6451-2-git-send-email-lorenzo.bianconi83@gmail.com> (sfid-20141120_143155_665529_8A2B72C7)
In-Reply-To: <1416490300-6451-1-git-send-email-lorenzo.bianconi83@gmail.com>
References: <1416490300-6451-1-git-send-email-lorenzo.bianconi83@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add chainmask parameter to ath9k_hw_get_scaled_power() in order to compute
maximum TX power per rate for different number of tx chains.
ath9k_hw_get_scaled_power() will be used during TPC TX power initialization

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c | 3 ++-
 drivers/net/wireless/ath/ath9k/eeprom.c        | 4 ++--
 drivers/net/wireless/ath/ath9k/eeprom.h        | 2 +-
 drivers/net/wireless/ath/ath9k/eeprom_9287.c   | 3 ++-
 drivers/net/wireless/ath/ath9k/eeprom_def.c    | 3 ++-
 5 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
index e726e40..96d7538 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
@@ -5114,7 +5114,8 @@ static void ar9003_hw_set_power_per_rate_table(struct ath_hw *ah,
 
 	ath9k_hw_get_channel_centers(ah, chan, &centers);
 	scaledPower = ath9k_hw_get_scaled_power(ah, powerLimit,
-						antenna_reduction);
+						antenna_reduction,
+						ah->txchainmask);
 
 	if (is2ghz) {
 		/* Setup for CTL modes */
diff --git a/drivers/net/wireless/ath/ath9k/eeprom.c b/drivers/net/wireless/ath/ath9k/eeprom.c
index 971d770..9304dca 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom.c
@@ -308,7 +308,7 @@ u16 ath9k_hw_get_max_edge_power(u16 freq, struct cal_ctl_edges *pRdEdgesPower,
 }
 
 u16 ath9k_hw_get_scaled_power(struct ath_hw *ah, u16 power_limit,
-			      u8 antenna_reduction)
+			      u8 antenna_reduction, u8 chainmask)
 {
 	u16 reduction = antenna_reduction;
 
@@ -316,7 +316,7 @@ u16 ath9k_hw_get_scaled_power(struct ath_hw *ah, u16 power_limit,
 	 * Reduce scaled Power by number of chains active
 	 * to get the per chain tx power level.
 	 */
-	switch (ar5416_get_ntxchains(ah->txchainmask)) {
+	switch (ar5416_get_ntxchains(chainmask)) {
 	case 1:
 		break;
 	case 2:
diff --git a/drivers/net/wireless/ath/ath9k/eeprom.h b/drivers/net/wireless/ath/ath9k/eeprom.h
index 40d4f62..f83bc0f 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom.h
+++ b/drivers/net/wireless/ath/ath9k/eeprom.h
@@ -684,7 +684,7 @@ void ath9k_hw_get_target_powers(struct ath_hw *ah,
 u16 ath9k_hw_get_max_edge_power(u16 freq, struct cal_ctl_edges *pRdEdgesPower,
 				bool is2GHz, int num_band_edges);
 u16 ath9k_hw_get_scaled_power(struct ath_hw *ah, u16 power_limit,
-			      u8 antenna_reduction);
+			      u8 antenna_reduction, u8 chainmask);
 void ath9k_hw_update_regulatory_maxpower(struct ath_hw *ah);
 int ath9k_hw_eeprom_init(struct ath_hw *ah);
 
diff --git a/drivers/net/wireless/ath/ath9k/eeprom_9287.c b/drivers/net/wireless/ath/ath9k/eeprom_9287.c
index 5ba1385..beb5b6b 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom_9287.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom_9287.c
@@ -584,7 +584,8 @@ static void ath9k_hw_set_ar9287_power_per_rate_table(struct ath_hw *ah,
 
 	ath9k_hw_get_channel_centers(ah, chan, &centers);
 	scaledPower = ath9k_hw_get_scaled_power(ah, powerLimit,
-						antenna_reduction);
+						antenna_reduction,
+						ah->txchainmask);
 
 	/*
 	 * Get TX power from EEPROM.
diff --git a/drivers/net/wireless/ath/ath9k/eeprom_def.c b/drivers/net/wireless/ath/ath9k/eeprom_def.c
index 122b846..8de2874 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom_def.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom_def.c
@@ -1009,7 +1009,8 @@ static void ath9k_hw_set_def_power_per_rate_table(struct ath_hw *ah,
 	ath9k_hw_get_channel_centers(ah, chan, &centers);
 
 	scaledPower = ath9k_hw_get_scaled_power(ah, powerLimit,
-						antenna_reduction);
+						antenna_reduction,
+						ah->txchainmask);
 
 	if (IS_CHAN_2GHZ(chan)) {
 		numCtlModes = ARRAY_SIZE(ctlModesFor11g) -
-- 
2.1.0

