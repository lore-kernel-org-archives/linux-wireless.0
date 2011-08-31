Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:60407 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753145Ab1HaFRG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Aug 2011 01:17:06 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [PATCH v2] ath9k_hw: Fix rx latency of 11a mode
Date: Wed, 31 Aug 2011 10:47:30 +0530
Message-ID: <1314767850-1112-1-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20110831_071710_925464_3919E6E2)
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
index 3a16ba2..308847d 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -975,7 +975,10 @@ void ath9k_hw_init_global_settings(struct ath_hw *ah)
 	if (ah->misc_mode != 0)
 		REG_SET_BIT(ah, AR_PCU_MISC, ah->misc_mode);
 
-	rx_lat = 37;
+	if (IS_CHAN_A_FAST_CLOCK(ah, chan))
+		rx_lat = 41;
+	else
+		rx_lat = 37;
 	tx_lat = 54;
 
 	if (IS_CHAN_HALF_RATE(chan)) {
@@ -989,7 +992,7 @@ void ath9k_hw_init_global_settings(struct ath_hw *ah)
 		sifstime = 32;
 	} else if (IS_CHAN_QUARTER_RATE(chan)) {
 		eifs = 340;
-		rx_lat *= 4;
+		rx_lat = (rx_lat * 4) - 1;
 		tx_lat *= 4;
 		if (IS_CHAN_A_FAST_CLOCK(ah, chan))
 		    tx_lat += 22;
-- 
1.7.6.1

