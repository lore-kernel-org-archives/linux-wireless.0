Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:56142 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752831AbZKGUTC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Nov 2009 15:19:02 -0500
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, devel@linuxdriverproject.org,
	mcgrof@gmail.com, "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 15/29] ath9k: move rate descriptor reading into a helper
Date: Sat,  7 Nov 2009 15:18:52 -0500
Message-Id: <1257625146-17971-16-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1257625146-17971-1-git-send-email-lrodriguez@atheros.com>
References: <1257625146-17971-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ath9k_process_rate() now does all the rx status processing to
read the rate the hardware passed and translate it to whatever
mac80211 wants.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/recv.c |   72 +++++++++++++++++++-------------
 1 files changed, 43 insertions(+), 29 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index 9e6dded..9eae946 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -148,6 +148,47 @@ static bool ath9k_rx_accept(struct ath_common *common,
 	return true;
 }
 
+static u8 ath9k_process_rate(struct ath_common *common,
+			     struct ieee80211_hw *hw,
+			     struct ath_rx_status *rx_stats,
+			     struct ieee80211_rx_status *rxs,
+			     struct sk_buff *skb)
+{
+	struct ieee80211_supported_band *sband;
+	enum ieee80211_band band;
+	unsigned int i = 0;
+
+	band = hw->conf.channel->band;
+	sband = hw->wiphy->bands[band];
+
+	if (rx_stats->rs_rate & 0x80) {
+		/* HT rate */
+		rxs->flag |= RX_FLAG_HT;
+		if (rx_stats->rs_flags & ATH9K_RX_2040)
+			rxs->flag |= RX_FLAG_40MHZ;
+		if (rx_stats->rs_flags & ATH9K_RX_GI)
+			rxs->flag |= RX_FLAG_SHORT_GI;
+		return rx_stats->rs_rate & 0x7f;
+	}
+
+	for (i = 0; i < sband->n_bitrates; i++) {
+		if (sband->bitrates[i].hw_value == rx_stats->rs_rate)
+			return i;
+		if (sband->bitrates[i].hw_value_short == rx_stats->rs_rate) {
+			rxs->flag |= RX_FLAG_SHORTPRE;
+			return i;
+		}
+	}
+
+	/* No valid hardware bitrate found -- we should not get here */
+	ath_print(common, ATH_DBG_XMIT, "unsupported hw bitrate detected "
+		  "0x%02x using 1 Mbit\n", rx_stats->rs_rate);
+	if ((common->debug_mask & ATH_DBG_XMIT))
+		print_hex_dump_bytes("", DUMP_PREFIX_NONE, skb->data, skb->len);
+
+        return 0;
+}
+
 /*
  * For Decrypt or Demic errors, we only mark packet status here and always push
  * up the frame up to let mac80211 handle the actual error case, be it no
@@ -173,35 +214,6 @@ static int ath_rx_prepare(struct ath_common *common,
 	if (!ath9k_rx_accept(common, skb, rx_status, rx_stats, decrypt_error))
 		goto rx_next;
 
-	if (rx_stats->rs_rate & 0x80) {
-		/* HT rate */
-		rx_status->flag |= RX_FLAG_HT;
-		if (rx_stats->rs_flags & ATH9K_RX_2040)
-			rx_status->flag |= RX_FLAG_40MHZ;
-		if (rx_stats->rs_flags & ATH9K_RX_GI)
-			rx_status->flag |= RX_FLAG_SHORT_GI;
-		rx_status->rate_idx = rx_stats->rs_rate & 0x7f;
-	} else {
-		struct ieee80211_supported_band *sband;
-		unsigned int i = 0;
-		enum ieee80211_band band;
-
-		band = hw->conf.channel->band;
-		sband = hw->wiphy->bands[band];
-
-		for (i = 0; i < sband->n_bitrates; i++) {
-			if (sband->bitrates[i].hw_value == rx_stats->rs_rate) {
-				rx_status->rate_idx = i;
-				break;
-			}
-			if (sband->bitrates[i].hw_value_short ==
-			    rx_stats->rs_rate) {
-				rx_status->rate_idx = i;
-				rx_status->flag |= RX_FLAG_SHORTPRE;
-				break;
-			}
-		}
-	}
 
 	rcu_read_lock();
 	/* XXX: use ieee80211_find_sta! */
@@ -227,6 +239,8 @@ static int ath_rx_prepare(struct ath_common *common,
 	if (ieee80211_is_beacon(fc))
 		ah->stats.avgbrssi = rx_stats->rs_rssi;
 
+	rx_status->rate_idx = ath9k_process_rate(common, hw,
+						 rx_stats, rx_status, skb);
 	rx_status->mactime = ath9k_hw_extend_tsf(ah, rx_stats->rs_tstamp);
 	rx_status->band = hw->conf.channel->band;
 	rx_status->freq = hw->conf.channel->center_freq;
-- 
1.6.5.2.143.g8cc62

