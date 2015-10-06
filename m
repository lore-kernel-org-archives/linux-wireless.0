Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:60305 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752567AbbJFXVT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Oct 2015 19:21:19 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: ath10k@lists.infradead.org, Ben Greear <greearb@candelatech.com>
Subject: [PATCH] ath10k:  Fix OFDM rx-rate reporting.
Date: Tue,  6 Oct 2015 16:21:15 -0700
Message-Id: <1444173675-16833-1-git-send-email-greearb@candelatech.com> (sfid-20151007_012124_747460_407CBB58)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

The ath10k hw_rate codes are duplicated for
cck and ofdm modes, so we have to check a flag to
see if rate is cck or not when searching for
the proper bitrate.

This fixes monitor mode reporting invalid rates
on my setup.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
 drivers/net/wireless/ath/ath10k/htt_rx.c | 2 +-
 drivers/net/wireless/ath/ath10k/mac.c    | 8 +++++++-
 drivers/net/wireless/ath/ath10k/mac.h    | 2 +-
 3 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index ca3ff1c..7c634b5 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -671,7 +671,7 @@ static void ath10k_htt_rx_h_rates(struct ath10k *ar,
 		rate &= ~RX_PPDU_START_RATE_FLAG;
 
 		sband = &ar->mac.sbands[status->band];
-		status->rate_idx = ath10k_mac_hw_rate_to_idx(sband, rate);
+		status->rate_idx = ath10k_mac_hw_rate_to_idx(sband, rate, cck);
 		break;
 	case HTT_RX_HT:
 	case HTT_RX_HT_WITH_TXBF:
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 34d47f9..e091c37 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -91,7 +91,7 @@ static u8 ath10k_mac_bitrate_to_rate(int bitrate)
 }
 
 u8 ath10k_mac_hw_rate_to_idx(const struct ieee80211_supported_band *sband,
-			     u8 hw_rate)
+			     u8 hw_rate, u8 cck)
 {
 	const struct ieee80211_rate *rate;
 	int i;
@@ -99,6 +99,12 @@ u8 ath10k_mac_hw_rate_to_idx(const struct ieee80211_supported_band *sband,
 	for (i = 0; i < sband->n_bitrates; i++) {
 		rate = &sband->bitrates[i];
 
+		/* hw_rate values are not unique, have to tie-break with bitrate
+		 * and cck check.
+		 */
+		if (ath10k_mac_bitrate_is_cck(rate->bitrate) && !cck)
+			continue;
+
 		if (rate->hw_value == hw_rate)
 			return i;
 		else if (rate->flags & IEEE80211_RATE_SHORT_PREAMBLE &&
diff --git a/drivers/net/wireless/ath/ath10k/mac.h b/drivers/net/wireless/ath/ath10k/mac.h
index 4497002..7dce7b1 100644
--- a/drivers/net/wireless/ath/ath10k/mac.h
+++ b/drivers/net/wireless/ath/ath10k/mac.h
@@ -71,7 +71,7 @@ void ath10k_mac_handle_tx_pause(struct ath10k *ar, u32 vdev_id,
 				enum wmi_tlv_tx_pause_action action);
 
 u8 ath10k_mac_hw_rate_to_idx(const struct ieee80211_supported_band *sband,
-			     u8 hw_rate);
+			     u8 hw_rate, u8 cck);
 u8 ath10k_mac_bitrate_to_idx(const struct ieee80211_supported_band *sband,
 			     u32 bitrate);
 
-- 
2.4.3

