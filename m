Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30t.wh2.ocn.ne.jp ([125.206.180.136]:13789 "HELO
	mail30t.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753285Ab0IQCgZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Sep 2010 22:36:25 -0400
Received: from vs3016.wh2.ocn.ne.jp (125.206.180.189)
	by mail30t.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 5-012028983
	for <linux-wireless@vger.kernel.org>; Fri, 17 Sep 2010 11:36:23 +0900 (JST)
Subject: [PATCH 05/11] ath5k: Fix TX queues stopping
To: linville@tuxdriver.com
From: Bruno Randolf <br1@einfach.org>
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Date: Fri, 17 Sep 2010 11:36:46 +0900
Message-ID: <20100917023646.24997.49868.stgit@tt-desk>
In-Reply-To: <20100917023543.24997.48466.stgit@tt-desk>
References: <20100917023543.24997.48466.stgit@tt-desk>
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

