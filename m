Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:28938 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750910Ab1HYOoz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Aug 2011 10:44:55 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [PATCH 1/2] ath9k_hw: Fix rx latency of 11a mode
Date: Thu, 25 Aug 2011 20:15:21 +0530
Message-ID: <1314283522-6143-1-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20110825_164459_056010_97346788)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rx latecy to start signal(usec) of 11a is 41 not 37 and
also corrected the rx delay in quarter rate.

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/hw.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 88100cc..d4dce6b 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -974,7 +974,10 @@ void ath9k_hw_init_global_settings(struct ath_hw *ah)
 	if (ah->misc_mode != 0)
 		REG_SET_BIT(ah, AR_PCU_MISC, ah->misc_mode);
 
-	rx_lat = 37;
+	if (IS_CHAN_A_FAST_CLOCK(ah, chan))
+		rx_lat = 41;
+	else
+		rx_lat = 37;
 	tx_lat = 54;
 
 	if (IS_CHAN_HALF_RATE(chan)) {
@@ -988,7 +991,7 @@ void ath9k_hw_init_global_settings(struct ath_hw *ah)
 		sifstime = 32;
 	} else if (IS_CHAN_QUARTER_RATE(chan)) {
 		eifs = 340;
-		rx_lat *= 4;
+		rx_lat *= 4 - 1;
 		tx_lat *= 4;
 		if (IS_CHAN_A_FAST_CLOCK(ah, chan))
 		    tx_lat += 22;
-- 
1.7.6.1

