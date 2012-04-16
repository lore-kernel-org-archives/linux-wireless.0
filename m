Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:48155 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755073Ab2DPVJe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Apr 2012 17:09:34 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, mcgrof@qca.qualcomm.com
Subject: [PATCH v2 1/8] ath9k_hw: use standard SIFS time as reference for half/quarter channels
Date: Mon, 16 Apr 2012 23:09:18 +0200
Message-Id: <1334610565-37399-1-git-send-email-nbd@openwrt.org> (sfid-20120416_230947_952698_72E141AE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/hw.c |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 373cef6..122447c 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -992,6 +992,11 @@ void ath9k_hw_init_global_settings(struct ath_hw *ah)
 		rx_lat = 37;
 	tx_lat = 54;
 
+	if (IS_CHAN_5GHZ(chan))
+		sifstime = 16;
+	else
+		sifstime = 10;
+
 	if (IS_CHAN_HALF_RATE(chan)) {
 		eifs = 175;
 		rx_lat *= 2;
@@ -999,8 +1004,8 @@ void ath9k_hw_init_global_settings(struct ath_hw *ah)
 		if (IS_CHAN_A_FAST_CLOCK(ah, chan))
 		    tx_lat += 11;
 
+		sifstime *= 2;
 		slottime = 13;
-		sifstime = 32;
 	} else if (IS_CHAN_QUARTER_RATE(chan)) {
 		eifs = 340;
 		rx_lat = (rx_lat * 4) - 1;
@@ -1008,8 +1013,8 @@ void ath9k_hw_init_global_settings(struct ath_hw *ah)
 		if (IS_CHAN_A_FAST_CLOCK(ah, chan))
 		    tx_lat += 22;
 
+		sifstime *= 4;
 		slottime = 21;
-		sifstime = 64;
 	} else {
 		if (AR_SREV_9287(ah) && AR_SREV_9287_13_OR_LATER(ah)) {
 			eifs = AR_D_GBL_IFS_EIFS_ASYNC_FIFO;
@@ -1023,10 +1028,6 @@ void ath9k_hw_init_global_settings(struct ath_hw *ah)
 		tx_lat = MS(reg, AR_USEC_TX_LAT);
 
 		slottime = ah->slottime;
-		if (IS_CHAN_5GHZ(chan))
-			sifstime = 16;
-		else
-			sifstime = 10;
 	}
 
 	/* As defined by IEEE 802.11-2007 17.3.8.6 */
-- 
1.7.3.2

