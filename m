Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:55383 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751587AbdKAUCB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 1 Nov 2017 16:02:01 -0400
Received: by mail-wm0-f67.google.com with SMTP id y83so6988814wmc.4
        for <linux-wireless@vger.kernel.org>; Wed, 01 Nov 2017 13:02:00 -0700 (PDT)
From: Christian Lamparter <chunkeey@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Kalle Valo <kvalo@qca.qualcomm.com>
Subject: [PATCH] ath10k: fix recent bandwidth conversion bug
Date: Wed,  1 Nov 2017 21:01:57 +0100
Message-Id: <20171101200157.27096-1-chunkeey@gmail.com> (sfid-20171101_210204_431516_219DA7A3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The commit "cfg80211: make RATE_INFO_BW_20 the default" changed
the index of RATE_INFO_BW_20, but the updates to ath10k missed
the special bandwidth calculation case in
ath10k_update_per_peer_tx_stats().

Fixes: 842be75c77cb ("cfg80211: make RATE_INFO_BW_20 the default")
Signed-off-by: Christian Lamparter <chunkeey@gmail.com>
---
 drivers/net/wireless/ath/ath10k/htt_rx.c | 23 +++++------------------
 1 file changed, 5 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index a3f5dc78353f..26b0d201a698 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -592,6 +592,9 @@ struct amsdu_subframe_hdr {
 
 #define GROUP_ID_IS_SU_MIMO(x) ((x) == 0 || (x) == 63)
 
+static const u8 ath10k_bw_to_mac80211[] = { RATE_INFO_BW_20, RATE_INFO_BW_40,
+	RATE_INFO_BW_80, RATE_INFO_BW_160 };
+
 static void ath10k_htt_rx_h_rates(struct ath10k *ar,
 				  struct ieee80211_rx_status *status,
 				  struct htt_rx_desc *rxd)
@@ -694,23 +697,7 @@ static void ath10k_htt_rx_h_rates(struct ath10k *ar,
 		if (sgi)
 			status->enc_flags |= RX_ENC_FLAG_SHORT_GI;
 
-		switch (bw) {
-		/* 20MHZ */
-		case 0:
-			break;
-		/* 40MHZ */
-		case 1:
-			status->bw = RATE_INFO_BW_40;
-			break;
-		/* 80MHZ */
-		case 2:
-			status->bw = RATE_INFO_BW_80;
-			break;
-		case 3:
-			status->bw = RATE_INFO_BW_160;
-			break;
-		}
-
+		status->bw = ath10k_bw_to_mac80211[bw];
 		status->encoding = RX_ENC_VHT;
 		break;
 	default:
@@ -2297,7 +2284,7 @@ ath10k_update_per_peer_tx_stats(struct ath10k *ar,
 		arsta->txrate.flags |= RATE_INFO_FLAGS_SHORT_GI;
 
 	arsta->txrate.nss = txrate.nss;
-	arsta->txrate.bw = txrate.bw + RATE_INFO_BW_20;
+	arsta->txrate.bw = ath10k_bw_to_mac80211[txrate.bw];
 }
 
 static void ath10k_htt_fetch_peer_stats(struct ath10k *ar,
-- 
2.15.0
