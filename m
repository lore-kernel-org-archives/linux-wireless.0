Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:54972 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727434AbeIDLHF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 4 Sep 2018 07:07:05 -0400
From: akolli@codeaurora.org
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
        Anilkumar Kolli <akolli@codeaurora.org>
Subject: [PATCHv2 1/4] ath10k: get the legacy rate index to update the txrate table
Date: Tue,  4 Sep 2018 12:15:13 +0530
Message-Id: <1536043516-12462-2-git-send-email-akolli@codeaurora.org> (sfid-20180904_084326_712643_51072521)
In-Reply-To: <1536043516-12462-1-git-send-email-akolli@codeaurora.org>
References: <1536043516-12462-1-git-send-email-akolli@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Anilkumar Kolli <akolli@codeaurora.org>

Get the legacy rate index to update the pkts/bytes counter
against each possible tx rate.

Signed-off-by: Anilkumar Kolli <akolli@codeaurora.org>
---
 drivers/net/wireless/ath/ath10k/htt_rx.c |   24 ++++++++++--------------
 1 file changed, 10 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index 4d1cd90d6d27..01eb4a7f4a69 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -2488,7 +2488,7 @@ void ath10k_htt_htc_t2h_msg_handler(struct ath10k *ar, struct sk_buff *skb)
 		dev_kfree_skb_any(skb);
 }
 
-static inline bool is_valid_legacy_rate(u8 rate)
+static inline int ath10k_get_legacy_rate_idx(struct ath10k *ar, u8 rate)
 {
 	static const u8 legacy_rates[] = {1, 2, 5, 11, 6, 9, 12,
 					  18, 24, 36, 48, 54};
@@ -2496,10 +2496,11 @@ static inline bool is_valid_legacy_rate(u8 rate)
 
 	for (i = 0; i < ARRAY_SIZE(legacy_rates); i++) {
 		if (rate == legacy_rates[i])
-			return true;
+			return i;
 	}
 
-	return false;
+	ath10k_warn(ar, "Invalid legacy rate %hhd peer stats", rate);
+	return -EINVAL;
 }
 
 static void
@@ -2508,7 +2509,7 @@ static inline bool is_valid_legacy_rate(u8 rate)
 				struct ath10k_per_peer_tx_stats *peer_stats)
 {
 	struct ath10k_sta *arsta = (struct ath10k_sta *)sta->drv_priv;
-	u8 rate = 0, sgi;
+	u8 rate = 0, rate_idx = 0, sgi;
 	struct rate_info txrate;
 
 	lockdep_assert_held(&ar->data_lock);
@@ -2536,17 +2537,12 @@ static inline bool is_valid_legacy_rate(u8 rate)
 	if (txrate.flags == WMI_RATE_PREAMBLE_CCK ||
 	    txrate.flags == WMI_RATE_PREAMBLE_OFDM) {
 		rate = ATH10K_HW_LEGACY_RATE(peer_stats->ratecode);
-
-		if (!is_valid_legacy_rate(rate)) {
-			ath10k_warn(ar, "Invalid legacy rate %hhd peer stats",
-				    rate);
-			return;
-		}
-
 		/* This is hacky, FW sends CCK rate 5.5Mbps as 6 */
-		rate *= 10;
-		if (rate == 60 && txrate.flags == WMI_RATE_PREAMBLE_CCK)
-			rate = rate - 5;
+		if (rate == 6 && txrate.flags == WMI_RATE_PREAMBLE_CCK)
+			rate = 5;
+		rate_idx = ath10k_get_legacy_rate_idx(ar, rate);
+		if (rate_idx < 0)
+			return;
 		arsta->txrate.legacy = rate;
 	} else if (txrate.flags == WMI_RATE_PREAMBLE_HT) {
 		arsta->txrate.flags = RATE_INFO_FLAGS_MCS;
-- 
1.7.9.5
