Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30s.wh2.ocn.ne.jp ([125.206.180.198]:14189 "HELO
	mail30s.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756050Ab0ESBcS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 May 2010 21:32:18 -0400
Received: from vs3012.wh2.ocn.ne.jp (125.206.180.183)
	by mail30s.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 5-0536252737
	for <linux-wireless@vger.kernel.org>; Wed, 19 May 2010 10:32:17 +0900 (JST)
Subject: [PATCH v2 05/20] ath5k: Stop queues only for NF calibration
To: linville@tuxdriver.com
From: Bruno Randolf <br1@einfach.org>
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Date: Wed, 19 May 2010 10:31:05 +0900
Message-ID: <20100519013105.22206.74955.stgit@tt-desk>
In-Reply-To: <20100519012528.22206.77550.stgit@tt-desk>
References: <20100519012528.22206.77550.stgit@tt-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

As far as we know, only NF calibration interferes with RX/TX so we can
leave the queues enabled for the other calibrations.

BTW: Stopping the queues is not enough for avoiding transmissions, since there
might be packets in the queue + beacons are also sent regularly! But i leave it
like this until we have a better solution (stopping TX DMA?).

Signed-off-by: Bruno Randolf <br1@einfach.org>
---
 drivers/net/wireless/ath/ath5k/base.c |   11 ++++++-----
 1 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index 88c7314..3206ed6 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -2785,10 +2785,6 @@ ath5k_tasklet_calibrate(unsigned long data)
 	/* Only full calibration for now */
 	ah->ah_cal_mask |= AR5K_CALIBRATION_FULL;
 
-	/* Stop queues so that calibration
-	 * doesn't interfere with tx */
-	ieee80211_stop_queues(sc->hw);
-
 	ATH5K_DBG(sc, ATH5K_DEBUG_CALIBRATE, "channel %u/%x\n",
 		ieee80211_frequency_to_channel(sc->curchan->center_freq),
 		sc->curchan->hw_value);
@@ -2806,8 +2802,13 @@ ath5k_tasklet_calibrate(unsigned long data)
 			ieee80211_frequency_to_channel(
 				sc->curchan->center_freq));
 
+	/* TODO: We don't need to run noise floor calibration as often
+	 * as I/Q calibration.*/
+
+	/* Noise floor calibration interrupts rx/tx path while I/Q calibration
+	 * doesn't. Stop queues so that calibration doesn't interfere with tx */
+	ieee80211_stop_queues(sc->hw);
 	ath5k_hw_update_noise_floor(ah);
-	/* Wake queues */
 	ieee80211_wake_queues(sc->hw);
 
 	ah->ah_cal_mask &= ~AR5K_CALIBRATION_FULL;

