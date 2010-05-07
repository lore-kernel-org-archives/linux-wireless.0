Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:38715 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752972Ab0EGClP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 May 2010 22:41:15 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 1/3] ath9k_common: move the rate status setting into ath9k_process_rate()
Date: Thu,  6 May 2010 22:41:12 -0400
Message-Id: <1273200074-9127-2-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1273200074-9127-1-git-send-email-lrodriguez@atheros.com>
References: <1273200074-9127-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This has no real functional change, this just moves the setting the
the mac80211 rate index into ath9k_process_rate(). This allows us
to eventually make ath9k_process_rate() return a negative value
in case we have detected a specific case rate situation which should
have been ignored.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/common.c |   40 +++++++++++++++++++++----------
 1 files changed, 27 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/common.c b/drivers/net/wireless/ath/ath9k/common.c
index b4424a6..9a33c3a 100644
--- a/drivers/net/wireless/ath/ath9k/common.c
+++ b/drivers/net/wireless/ath/ath9k/common.c
@@ -102,11 +102,11 @@ static bool ath9k_rx_accept(struct ath_common *common,
 	return true;
 }
 
-static u8 ath9k_process_rate(struct ath_common *common,
-			     struct ieee80211_hw *hw,
-			     struct ath_rx_status *rx_stats,
-			     struct ieee80211_rx_status *rxs,
-			     struct sk_buff *skb)
+static int ath9k_process_rate(struct ath_common *common,
+			      struct ieee80211_hw *hw,
+			      struct ath_rx_status *rx_stats,
+			      struct ieee80211_rx_status *rxs,
+			      struct sk_buff *skb)
 {
 	struct ieee80211_supported_band *sband;
 	enum ieee80211_band band;
@@ -122,25 +122,33 @@ static u8 ath9k_process_rate(struct ath_common *common,
 			rxs->flag |= RX_FLAG_40MHZ;
 		if (rx_stats->rs_flags & ATH9K_RX_GI)
 			rxs->flag |= RX_FLAG_SHORT_GI;
-		return rx_stats->rs_rate & 0x7f;
+		rxs->rate_idx = rx_stats->rs_rate & 0x7f;
+		return 0;
 	}
 
 	for (i = 0; i < sband->n_bitrates; i++) {
-		if (sband->bitrates[i].hw_value == rx_stats->rs_rate)
-			return i;
+		if (sband->bitrates[i].hw_value == rx_stats->rs_rate) {
+			rxs->rate_idx = i;
+			return 0;
+		}
 		if (sband->bitrates[i].hw_value_short == rx_stats->rs_rate) {
 			rxs->flag |= RX_FLAG_SHORTPRE;
-			return i;
+			rxs->rate_idx = i;
+			return 0;
 		}
 	}
 
-	/* No valid hardware bitrate found -- we should not get here */
+	/*
+	 * No valid hardware bitrate found -- we should not get here
+	 * because hardware has already validated this frame as OK.
+	 */
 	ath_print(common, ATH_DBG_XMIT, "unsupported hw bitrate detected "
 		  "0x%02x using 1 Mbit\n", rx_stats->rs_rate);
 	if ((common->debug_mask & ATH_DBG_XMIT))
 		print_hex_dump_bytes("", DUMP_PREFIX_NONE, skb->data, skb->len);
 
-        return 0;
+	rxs->rate_idx = 0;
+	return 0;
 }
 
 static void ath9k_process_rssi(struct ath_common *common,
@@ -202,13 +210,19 @@ int ath9k_cmn_rx_skb_preprocess(struct ath_common *common,
 	struct ath_hw *ah = common->ah;
 
 	memset(rx_status, 0, sizeof(struct ieee80211_rx_status));
+
+	/*
+	 * everything but the rate is checked here, the rate check is done
+	 * separately to avoid doing two lookups for a rate for each frame.
+	 */
 	if (!ath9k_rx_accept(common, skb, rx_status, rx_stats, decrypt_error))
 		return -EINVAL;
 
 	ath9k_process_rssi(common, hw, skb, rx_stats);
 
-	rx_status->rate_idx = ath9k_process_rate(common, hw,
-						 rx_stats, rx_status, skb);
+	if (ath9k_process_rate(common, hw, rx_stats, rx_status, skb))
+		return -EINVAL;
+
 	rx_status->mactime = ath9k_hw_extend_tsf(ah, rx_stats->rs_tstamp);
 	rx_status->band = hw->conf.channel->band;
 	rx_status->freq = hw->conf.channel->center_freq;
-- 
1.6.3.3

