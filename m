Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:47480 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752085AbeCJMUV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 10 Mar 2018 07:20:21 -0500
From: Anilkumar Kolli <akolli@codeaurora.org>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] ath10k: fix recent bandwidth conversion bug
Date: Sat, 10 Mar 2018 17:50:38 +0530
Message-Id: <1520684438-9233-1-git-send-email-akolli@codeaurora.org> (sfid-20180310_132026_561675_09070557)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Christian Lamparter <chunkeey@gmail.com>

The commit "cfg80211: make RATE_INFO_BW_20 the default" changed
the index of RATE_INFO_BW_20, but the updates to ath10k missed
the special bandwidth calculation case in
ath10k_update_per_peer_tx_stats().

This will fix below warning,

 WARNING: CPU: 0 PID: 609 at net/wireless/util.c:1254
 cfg80211_calculate_bitrate+0x174/0x220
 invalid rate bw=1, mcs=9, nss=2

 (unwind_backtrace) from
 (cfg80211_calculate_bitrate+0x174/0x220)
 (cfg80211_calculate_bitrate) from
 (nl80211_put_sta_rate+0x44/0x1dc)from
 (nl80211_put_sta_rate) from
 (nl80211_send_station+0x388/0xaf0)
 (nl80211_get_station+0xa8/0xec)
 [ end trace da8257d6a850e91a ]

Fixes: 842be75c77cb ("cfg80211: make RATE_INFO_BW_20 the default")
Signed-off-by: Christian Lamparter <chunkeey@gmail.com>
Signed-off-by: Anilkumar Kolli <akolli@codeaurora.org>
---
 drivers/net/wireless/ath/ath10k/htt_rx.c |   43 +++++++++++++++++-------------
 1 file changed, 25 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index 6d96f9560950..47d1f2f6c6bb 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -1,6 +1,7 @@
 /*
  * Copyright (c) 2005-2011 Atheros Communications Inc.
  * Copyright (c) 2011-2017 Qualcomm Atheros, Inc.
+ * Copyright (c) 2018, The Linux Foundation. All rights reserved.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
@@ -723,6 +724,28 @@ struct amsdu_subframe_hdr {
 
 #define GROUP_ID_IS_SU_MIMO(x) ((x) == 0 || (x) == 63)
 
+static inline u8 ath10k_bw_to_mac80211_bw(u8 bw)
+{
+	u8 ret = 0;
+
+	switch (bw) {
+	case 0:
+		ret = RATE_INFO_BW_20;
+		break;
+	case 1:
+		ret = RATE_INFO_BW_40;
+		break;
+	case 2:
+		ret = RATE_INFO_BW_80;
+		break;
+	case 3:
+		ret = RATE_INFO_BW_160;
+		break;
+	}
+
+	return ret;
+}
+
 static void ath10k_htt_rx_h_rates(struct ath10k *ar,
 				  struct ieee80211_rx_status *status,
 				  struct htt_rx_desc *rxd)
@@ -825,23 +848,7 @@ static void ath10k_htt_rx_h_rates(struct ath10k *ar,
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
+		status->bw = ath10k_bw_to_mac80211_bw(bw);
 		status->encoding = RX_ENC_VHT;
 		break;
 	default:
@@ -2499,7 +2506,7 @@ static inline bool is_valid_legacy_rate(u8 rate)
 		arsta->txrate.flags |= RATE_INFO_FLAGS_SHORT_GI;
 
 	arsta->txrate.nss = txrate.nss;
-	arsta->txrate.bw = txrate.bw + RATE_INFO_BW_20;
+	arsta->txrate.bw = ath10k_bw_to_mac80211_bw(txrate.bw);
 }
 
 static void ath10k_htt_fetch_peer_stats(struct ath10k *ar,
-- 
1.7.9.5
