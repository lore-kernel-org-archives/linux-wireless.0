Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:44215 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753895Ab1DIThW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 9 Apr 2011 15:37:22 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, ath5k-devel@lists.ath5k.org
Subject: [PATCH] ath5k: fix tx status reporting issues
Date: Sat,  9 Apr 2011 21:37:14 +0200
Message-Id: <1302377834-87774-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

During normal operation, minstrel was showing suspicious EWMA probabilities
exceeding 100%. It looks like the tx status reporting in ath5k was not
properly clearing the rate index for rates which were never attempted.

This is caused by uninitialized stale data in the on-stack tx status
information, which is reused when more frames are received.

To fix this, rely on ts->ts_final_idx to select the last attempted rate,
instead of checking whether ts->ts_rate is set.

Additionally, the conversion from the driver rate index back to the
mac80211 rate index can be dropped, as the mac80211 tx status will still
have the original rate index which was used to set up the descriptor.

Additionally, one more inaccuracy was fixed - the final rate attempt
count only needs to be increased by one if the transmission attempt was
successful.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath5k/base.c |   16 ++++++----------
 1 files changed, 6 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index 4d7f21e..753662f 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -1580,21 +1580,14 @@ ath5k_tx_frame_completed(struct ath5k_softc *sc, struct sk_buff *skb,
 	info = IEEE80211_SKB_CB(skb);
 
 	ieee80211_tx_info_clear_status(info);
-	for (i = 0; i < 4; i++) {
+	for (i = 0; i <= ts->ts_final_idx; i++) {
 		struct ieee80211_tx_rate *r =
 			&info->status.rates[i];
 
-		if (ts->ts_rate[i]) {
-			r->idx = ath5k_hw_to_driver_rix(sc, ts->ts_rate[i]);
-			r->count = ts->ts_retry[i];
-		} else {
-			r->idx = -1;
-			r->count = 0;
-		}
+		r->count = ts->ts_retry[i];
 	}
 
-	/* count the successful attempt as well */
-	info->status.rates[ts->ts_final_idx].count++;
+	info->status.rates[ts->ts_final_idx + 1].idx = -1;
 
 	if (unlikely(ts->ts_status)) {
 		sc->stats.ack_fail++;
@@ -1609,6 +1602,9 @@ ath5k_tx_frame_completed(struct ath5k_softc *sc, struct sk_buff *skb,
 	} else {
 		info->flags |= IEEE80211_TX_STAT_ACK;
 		info->status.ack_signal = ts->ts_rssi;
+
+		/* count the successful attempt as well */
+		info->status.rates[ts->ts_final_idx].count++;
 	}
 
 	/*
-- 
1.7.3.2

