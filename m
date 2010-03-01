Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:37861 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751159Ab0CAJRx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Mar 2010 04:17:53 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 01 Mar 2010 01:17:53 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19339.35510.140938.273448@gargle.gargle.HOWL>
Date: Mon, 1 Mar 2010 15:06:54 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 7/7] ath9k: Use rate processing from library
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

A common routine can be used for processing
rate information, between ath9k and ath9k_htc.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/recv.c |   47 +++------------------------------
 1 files changed, 4 insertions(+), 43 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index a6d347f..a54c6ca 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -469,47 +469,6 @@ static void ath_rx_send_to_mac80211(struct ieee80211_hw *hw,
 		ieee80211_rx(hw, skb);
 }
 
-static u8 ath9k_processrate(struct ath_common *common,
-			    struct ieee80211_hw *hw,
-			    struct ath_rx_status *rx_stats,
-			    struct ieee80211_rx_status *rxs,
-			    struct sk_buff *skb)
-{
-	struct ieee80211_supported_band *sband;
-	enum ieee80211_band band;
-	unsigned int i = 0;
-
-	band = hw->conf.channel->band;
-	sband = hw->wiphy->bands[band];
-
-	if (rx_stats->rs_rate & 0x80) {
-		/* HT rate */
-		rxs->flag |= RX_FLAG_HT;
-		if (rx_stats->rs_flags & ATH9K_RX_2040)
-			rxs->flag |= RX_FLAG_40MHZ;
-		if (rx_stats->rs_flags & ATH9K_RX_GI)
-			rxs->flag |= RX_FLAG_SHORT_GI;
-		return rx_stats->rs_rate & 0x7f;
-	}
-
-	for (i = 0; i < sband->n_bitrates; i++) {
-		if (sband->bitrates[i].hw_value == rx_stats->rs_rate)
-			return i;
-		if (sband->bitrates[i].hw_value_short == rx_stats->rs_rate) {
-			rxs->flag |= RX_FLAG_SHORTPRE;
-			return i;
-		}
-	}
-
-	/* No valid hardware bitrate found -- we should not get here */
-	ath_print(common, ATH_DBG_XMIT, "unsupported hw bitrate detected "
-		  "0x%02x using 1 Mbit\n", rx_stats->rs_rate);
-	if ((common->debug_mask & ATH_DBG_XMIT))
-		print_hex_dump_bytes("", DUMP_PREFIX_NONE, skb->data, skb->len);
-
-        return 0;
-}
-
 static void ath9k_process_rssi(struct ath_common *common,
 			       struct ieee80211_hw *hw,
 			       struct sk_buff *skb,
@@ -646,8 +605,10 @@ static int ath9k_rx_skb_preprocess(struct ath_common *common,
 
 	ath9k_process_rssi(common, hw, skb, rx_stats);
 
-	rx_status->rate_idx = ath9k_processrate(common, hw,
-						rx_stats, rx_status, skb);
+	ath9k_process_rate(hw, rx_status,
+			   rx_stats->rs_rate,
+			   rx_stats->rs_flags);
+
 	rx_status->mactime = ath9k_hw_extend_tsf(ah, rx_stats->rs_tstamp);
 	rx_status->band = hw->conf.channel->band;
 	rx_status->freq = hw->conf.channel->center_freq;
-- 
1.7.0.1

