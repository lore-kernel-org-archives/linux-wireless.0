Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:22661 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751366Ab2BNIjN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Feb 2012 03:39:13 -0500
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20282.7600.287048.11418@gargle.gargle.HOWL> (sfid-20120214_093916_772219_F7F125D3)
Date: Tue, 14 Feb 2012 14:09:12 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>
Subject: [PATCH 3/4] ath9k: Modify CCK spur mitigation for AR9462
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This improves sensitivity for CCK at specific channels.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_phy.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.c b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
index 70e27d2..941b915 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
@@ -171,6 +171,7 @@ static void ar9003_hw_spur_mitigate_mrc_cck(struct ath_hw *ah,
 					    struct ath9k_channel *chan)
 {
 	static const u32 spur_freq[4] = { 2420, 2440, 2464, 2480 };
+	static const u32 spur_freq_AR9462[2] = { 2440, 2464 };
 	int cur_bb_spur, negative = 0, cck_spur_freq;
 	int i;
 	int range, max_spur_cnts, synth_freq;
@@ -198,8 +199,12 @@ static void ar9003_hw_spur_mitigate_mrc_cck(struct ath_hw *ah,
 			range = 10;
 			synth_freq = chan->channel;
 		}
+	} else if (AR_SREV_9462(ah)) {
+		range = 5;
+		max_spur_cnts = 2;
+		synth_freq = chan->channel;
 	} else {
-		range = AR_SREV_9462(ah) ? 5 : 10;
+		range = 10;
 		max_spur_cnts = 4;
 		synth_freq = chan->channel;
 	}
@@ -211,6 +216,8 @@ static void ar9003_hw_spur_mitigate_mrc_cck(struct ath_hw *ah,
 		if (AR_SREV_9485(ah) || AR_SREV_9340(ah) || AR_SREV_9330(ah))
 			cur_bb_spur = FBIN2FREQ(spur_fbin_ptr[i],
 					IS_CHAN_2GHZ(chan)) - synth_freq;
+		else if (AR_SREV_9462(ah))
+			cur_bb_spur = spur_freq_AR9462[i] - synth_freq;
 		else
 			cur_bb_spur = spur_freq[i] - synth_freq;
 
-- 
1.7.9

