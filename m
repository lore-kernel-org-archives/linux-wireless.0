Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:44676 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752105Ab2DOKPw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Apr 2012 06:15:52 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, mcgrof@qca.qualcomm.com
Subject: [PATCH 1/9] ath9k_hw: use lower rx latency values for half/quarter channels
Date: Sun, 15 Apr 2012 12:15:33 +0200
Message-Id: <1334484941-27673-1-git-send-email-nbd@openwrt.org> (sfid-20120415_121601_845301_8825A0CE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Visibly improves performance on AR9280 and AR9380 - values obtained from
register dumps of UBNT NanoStation M2/M5.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/hw.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 373cef6..c7faf10 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -994,7 +994,7 @@ void ath9k_hw_init_global_settings(struct ath_hw *ah)
 
 	if (IS_CHAN_HALF_RATE(chan)) {
 		eifs = 175;
-		rx_lat *= 2;
+		rx_lat = 10;
 		tx_lat *= 2;
 		if (IS_CHAN_A_FAST_CLOCK(ah, chan))
 		    tx_lat += 11;
@@ -1003,7 +1003,7 @@ void ath9k_hw_init_global_settings(struct ath_hw *ah)
 		sifstime = 32;
 	} else if (IS_CHAN_QUARTER_RATE(chan)) {
 		eifs = 340;
-		rx_lat = (rx_lat * 4) - 1;
+		rx_lat = 20;
 		tx_lat *= 4;
 		if (IS_CHAN_A_FAST_CLOCK(ah, chan))
 		    tx_lat += 22;
-- 
1.7.3.2

