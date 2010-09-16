Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30f.wh2.ocn.ne.jp ([220.111.41.203]:3893 "HELO
	mail30f.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751498Ab0IPJvM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Sep 2010 05:51:12 -0400
Received: from vs3015.wh2.ocn.ne.jp (125.206.180.247)
	by mail30f.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 4-050430670
	for <linux-wireless@vger.kernel.org>; Thu, 16 Sep 2010 18:51:10 +0900 (JST)
Subject: [PATCH 3/9] ath5k: Fix TX queues stopping
To: linville@tuxdriver.com
From: Bruno Randolf <br1@einfach.org>
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Date: Thu, 16 Sep 2010 18:51:28 +0900
Message-ID: <20100916095128.17637.19897.stgit@tt-desk>
In-Reply-To: <20100916095112.17637.17207.stgit@tt-desk>
References: <20100916095112.17637.17207.stgit@tt-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It does not make sense to stop queues for NF calibration. This will not stop
transmissions from the card, if there are queued packets.

If we run out of TX buffers we need to stop all queues, not only one.

Signed-off-by: Bruno Randolf <br1@einfach.org>
---
 drivers/net/wireless/ath/ath5k/base.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index c105dba..1e3d7b7 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -1493,7 +1493,7 @@ static int ath5k_tx_queue(struct ieee80211_hw *hw, struct sk_buff *skb,
 	if (list_empty(&sc->txbuf)) {
 		ATH5K_ERR(sc, "no further txbuf available, dropping packet\n");
 		spin_unlock_irqrestore(&sc->txbuflock, flags);
-		ieee80211_stop_queue(hw, skb_get_queue_mapping(skb));
+		ieee80211_stop_queues(hw);
 		goto drop_packet;
 	}
 	bf = list_first_entry(&sc->txbuf, struct ath5k_buf, list);
@@ -2142,14 +2142,13 @@ ath5k_tasklet_calibrate(unsigned long data)
 				sc->curchan->center_freq));
 
 	/* Noise floor calibration interrupts rx/tx path while I/Q calibration
-	 * doesn't. We stop the queues so that calibration doesn't interfere
-	 * with TX and don't run it as often */
+	 * doesn't.
+	 * TODO: We should stop TX here, so that it doesn't interfere.
+	 * Note that stopping the queues is not enough to stop TX! */
 	if (time_is_before_eq_jiffies(ah->ah_cal_next_nf)) {
 		ah->ah_cal_next_nf = jiffies +
 			msecs_to_jiffies(ATH5K_TUNE_CALIBRATION_INTERVAL_NF);
-		ieee80211_stop_queues(sc->hw);
 		ath5k_hw_update_noise_floor(ah);
-		ieee80211_wake_queues(sc->hw);
 	}
 
 	ah->ah_cal_mask &= ~AR5K_CALIBRATION_FULL;

