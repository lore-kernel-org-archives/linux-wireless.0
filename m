Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:44678 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752116Ab2DOKPw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Apr 2012 06:15:52 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, mcgrof@qca.qualcomm.com
Subject: [PATCH 2/9] ath9k_hw: do not override SIFS time for half/quarter channels
Date: Sun, 15 Apr 2012 12:15:34 +0200
Message-Id: <1334484941-27673-2-git-send-email-nbd@openwrt.org> (sfid-20120415_121601_073128_2F66FB08)
In-Reply-To: <1334484941-27673-1-git-send-email-nbd@openwrt.org>
References: <1334484941-27673-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Significantly improves performance on AR9280/AR9380

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/hw.c |   11 +++++------
 1 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index c7faf10..e408aaf 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1000,7 +1000,6 @@ void ath9k_hw_init_global_settings(struct ath_hw *ah)
 		    tx_lat += 11;
 
 		slottime = 13;
-		sifstime = 32;
 	} else if (IS_CHAN_QUARTER_RATE(chan)) {
 		eifs = 340;
 		rx_lat = 20;
@@ -1009,7 +1008,6 @@ void ath9k_hw_init_global_settings(struct ath_hw *ah)
 		    tx_lat += 22;
 
 		slottime = 21;
-		sifstime = 64;
 	} else {
 		if (AR_SREV_9287(ah) && AR_SREV_9287_13_OR_LATER(ah)) {
 			eifs = AR_D_GBL_IFS_EIFS_ASYNC_FIFO;
@@ -1023,12 +1021,13 @@ void ath9k_hw_init_global_settings(struct ath_hw *ah)
 		tx_lat = MS(reg, AR_USEC_TX_LAT);
 
 		slottime = ah->slottime;
-		if (IS_CHAN_5GHZ(chan))
-			sifstime = 16;
-		else
-			sifstime = 10;
 	}
 
+	if (IS_CHAN_5GHZ(chan))
+		sifstime = 16;
+	else
+		sifstime = 10;
+
 	/* As defined by IEEE 802.11-2007 17.3.8.6 */
 	acktimeout = slottime + sifstime + 3 * ah->coverage_class;
 	ctstimeout = acktimeout;
-- 
1.7.3.2

