Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:56123 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752792AbZKGUTC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Nov 2009 15:19:02 -0500
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, devel@linuxdriverproject.org,
	mcgrof@gmail.com, "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 28/29] ath9k_common: remove ath9k_compute_qual()
Date: Sat,  7 Nov 2009 15:19:05 -0500
Message-Id: <1257625146-17971-29-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1257625146-17971-1-git-send-email-lrodriguez@atheros.com>
References: <1257625146-17971-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is now deprecated and unused within mac80211, so time
to remove it as otherwise we'd be doing some unecessary
computations for nothing.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/common.c |   42 -------------------------------
 1 files changed, 0 insertions(+), 42 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/common.c b/drivers/net/wireless/ath/ath9k/common.c
index 5fb164e..80edf7a 100644
--- a/drivers/net/wireless/ath/ath9k/common.c
+++ b/drivers/net/wireless/ath/ath9k/common.c
@@ -142,47 +142,6 @@ static u8 ath9k_process_rate(struct ath_common *common,
         return 0;
 }
 
-/*
- * Theory for reporting quality:
- *
- * At a hardware RSSI of 45 you will be able to use MCS 7  reliably.
- * At a hardware RSSI of 45 you will be able to use MCS 15 reliably.
- * At a hardware RSSI of 35 you should be able use 54 Mbps reliably.
- *
- * MCS 7  is the highets MCS index usable by a 1-stream device.
- * MCS 15 is the highest MCS index usable by a 2-stream device.
- *
- * All ath9k devices are either 1-stream or 2-stream.
- *
- * How many bars you see is derived from the qual reporting.
- *
- * A more elaborate scheme can be used here but it requires tables
- * of SNR/throughput for each possible mode used. For the MCS table
- * you can refer to the wireless wiki:
- *
- * http://wireless.kernel.org/en/developers/Documentation/ieee80211/802.11n
- *
- */
-static int ath9k_compute_qual(struct ieee80211_hw *hw,
-			      struct ath_rx_status *rx_stats)
-{
-	int qual;
-
-	if (conf_is_ht(&hw->conf))
-		qual =  rx_stats->rs_rssi * 100 / 45;
-	else
-		qual =  rx_stats->rs_rssi * 100 / 35;
-
-	/*
-	 * rssi can be more than 45 though, anything above that
-	 * should be considered at 100%
-	 */
-	if (qual > 100)
-		qual = 100;
-
-	return qual;
-}
-
 static void ath9k_process_rssi(struct ath_common *common,
 			       struct ieee80211_hw *hw,
 			       struct sk_buff *skb,
@@ -256,7 +215,6 @@ int ath9k_cmn_rx_skb_preprocess(struct ath_common *common,
 	rx_status->noise = common->ani.noise_floor;
 	rx_status->signal = ATH_DEFAULT_NOISE_FLOOR + rx_stats->rs_rssi;
 	rx_status->antenna = rx_stats->rs_antenna;
-	rx_status->qual = ath9k_compute_qual(hw, rx_stats);
 	rx_status->flag |= RX_FLAG_TSFT;
 
 	return 0;
-- 
1.6.5.2.143.g8cc62

