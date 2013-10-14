Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:58638 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755804Ab3JNTS7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Oct 2013 15:18:59 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, thomas@net.t-labs.tu-berlin.de,
	bvahl@net.t-labs.tu-berlin.de, ben@gowasabi.net
Subject: [PATCH 3.12] ath5k: fix regression in tx status processing
Date: Mon, 14 Oct 2013 21:18:48 +0200
Message-Id: <1381778328-7684-1-git-send-email-nbd@openwrt.org> (sfid-20131014_211902_819366_F24AEAB6)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The regression was introduced in the following commit:

0967e01e8e713ed2982fb4eba8ba13794e9a6e89
"ath5k: make use of the new rate control API"

ath5k_tx_frame_completed saves the intended per-rate retry counts before
they are cleared by ieee80211_tx_info_clear_status, however at this
point the information in info->status.rates is incomplete.

This causes significant throughput degradation and excessive packet loss
on links where high bit rates don't work properly.

Move the copy from bf->rates a few lines up to ensure that the saved
retry counts are updated, and that they are really cleared in
info->status.rates after the call to ieee80211_tx_info_clear_status.

Cc: stable@vger.kernel.org # 3.10+
Cc: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
Cc: Benjamin Vahl <bvahl@net.t-labs.tu-berlin.de>
Reported-by: Ben West <ben@gowasabi.net>
Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath5k/base.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index 48161ed..69f58b0 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -1663,15 +1663,15 @@ ath5k_tx_frame_completed(struct ath5k_hw *ah, struct sk_buff *skb,
 	ah->stats.tx_bytes_count += skb->len;
 	info = IEEE80211_SKB_CB(skb);
 
+	size = min_t(int, sizeof(info->status.rates), sizeof(bf->rates));
+	memcpy(info->status.rates, bf->rates, size);
+
 	tries[0] = info->status.rates[0].count;
 	tries[1] = info->status.rates[1].count;
 	tries[2] = info->status.rates[2].count;
 
 	ieee80211_tx_info_clear_status(info);
 
-	size = min_t(int, sizeof(info->status.rates), sizeof(bf->rates));
-	memcpy(info->status.rates, bf->rates, size);
-
 	for (i = 0; i < ts->ts_final_idx; i++) {
 		struct ieee80211_tx_rate *r =
 			&info->status.rates[i];
-- 
1.8.0.2

