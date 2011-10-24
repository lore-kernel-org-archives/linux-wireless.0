Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:27338 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754813Ab1JXMnu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Oct 2011 08:43:50 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [PATCH] ath9k_hw: Update CCK spur mitigation for AR9462
Date: Mon, 24 Oct 2011 18:14:39 +0530
Message-ID: <1319460279-6898-1-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20111024_144354_064887_3E6BB156)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

To improve CCK sensitivity for AR9462 chips, performing
spur mitigation at 2440, 2464 frequencies alone is sufficient.

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_phy.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.c b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
index fe96997..04b060a 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
@@ -198,12 +198,14 @@ static void ar9003_hw_spur_mitigate_mrc_cck(struct ath_hw *ah,
 			synth_freq = chan->channel;
 		}
 	} else {
-		range = 10;
+		range = AR_SREV_9462(ah) ? 5 : 10;
 		max_spur_cnts = 4;
 		synth_freq = chan->channel;
 	}
 
 	for (i = 0; i < max_spur_cnts; i++) {
+		if (AR_SREV_9462(ah) && (i == 0 || i == 3))
+			continue;
 		negative = 0;
 		if (AR_SREV_9485(ah) || AR_SREV_9340(ah) || AR_SREV_9330(ah))
 			cur_bb_spur = FBIN2FREQ(spur_fbin_ptr[i],
-- 
1.7.7

