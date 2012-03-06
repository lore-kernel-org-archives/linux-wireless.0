Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:52406 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753198Ab2CFKGq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Mar 2012 05:06:46 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, mickflemm@gmail.com
Subject: [PATCH 1/2] ath5k: do not stop queues for full calibration
Date: Tue,  6 Mar 2012 11:06:37 +0100
Message-Id: <1331028398-27417-1-git-send-email-nbd@openwrt.org> (sfid-20120306_110650_039123_6D65B226)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some calibration types interfere with tx activity, but the queue stop does
not prevent that. In fact, some calibration types need tx activity to properly
function, so stopping the queues for them is counterproductive.
In some tests this patch has been shown to improve stability, especially in
AP or ad-hoc mode.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Acked-by: Nick Kossifidis <mickflemm@gmail.com>
---
 drivers/net/wireless/ath/ath5k/base.c |   14 ++------------
 1 files changed, 2 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index a339693..55e54b5 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -2330,15 +2330,6 @@ ath5k_calibrate_work(struct work_struct *work)
 					"got new rfgain, resetting\n");
 			ieee80211_queue_work(ah->hw, &ah->reset_work);
 		}
-
-		/* TODO: On full calibration we should stop TX here,
-		 * so that it doesn't interfere (mostly due to gain_f
-		 * calibration that messes with tx packets -see phy.c).
-		 *
-		 * NOTE: Stopping the queues from above is not enough
-		 * to stop TX but saves us from disconecting (at least
-		 * we don't lose packets). */
-		ieee80211_stop_queues(ah->hw);
 	} else
 		ah->ah_cal_mask |= AR5K_CALIBRATION_SHORT;
 
@@ -2353,10 +2344,9 @@ ath5k_calibrate_work(struct work_struct *work)
 				ah->curchan->center_freq));
 
 	/* Clear calibration flags */
-	if (ah->ah_cal_mask & AR5K_CALIBRATION_FULL) {
-		ieee80211_wake_queues(ah->hw);
+	if (ah->ah_cal_mask & AR5K_CALIBRATION_FULL)
 		ah->ah_cal_mask &= ~AR5K_CALIBRATION_FULL;
-	} else if (ah->ah_cal_mask & AR5K_CALIBRATION_SHORT)
+	else if (ah->ah_cal_mask & AR5K_CALIBRATION_SHORT)
 		ah->ah_cal_mask &= ~AR5K_CALIBRATION_SHORT;
 }
 
-- 
1.7.3.2

