Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:39568 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756274Ab2DSTSg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Apr 2012 15:18:36 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, mcgrof@qca.qualcomm.com
Subject: [PATCH v3 1/8] ath9k_hw: use standard SIFS time as reference for half/quarter channels
Date: Thu, 19 Apr 2012 21:18:22 +0200
Message-Id: <1334863109-95726-1-git-send-email-nbd@openwrt.org> (sfid-20120419_211844_876595_75539D0A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/hw.c |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 72c5bcd..a43934f 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1041,6 +1041,11 @@ void ath9k_hw_init_global_settings(struct ath_hw *ah)
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
@@ -1048,8 +1053,8 @@ void ath9k_hw_init_global_settings(struct ath_hw *ah)
 		if (IS_CHAN_A_FAST_CLOCK(ah, chan))
 		    tx_lat += 11;
 
+		sifstime *= 2;
 		slottime = 13;
-		sifstime = 32;
 	} else if (IS_CHAN_QUARTER_RATE(chan)) {
 		eifs = 340;
 		rx_lat = (rx_lat * 4) - 1;
@@ -1057,8 +1062,8 @@ void ath9k_hw_init_global_settings(struct ath_hw *ah)
 		if (IS_CHAN_A_FAST_CLOCK(ah, chan))
 		    tx_lat += 22;
 
+		sifstime *= 4;
 		slottime = 21;
-		sifstime = 64;
 	} else {
 		if (AR_SREV_9287(ah) && AR_SREV_9287_13_OR_LATER(ah)) {
 			eifs = AR_D_GBL_IFS_EIFS_ASYNC_FIFO;
@@ -1072,10 +1077,6 @@ void ath9k_hw_init_global_settings(struct ath_hw *ah)
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

