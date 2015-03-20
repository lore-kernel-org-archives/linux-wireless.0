Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f54.google.com ([209.85.215.54]:33596 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752372AbbCTN45 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Mar 2015 09:56:57 -0400
Received: by ladw1 with SMTP id w1so87619177lad.0
        for <linux-wireless@vger.kernel.org>; Fri, 20 Mar 2015 06:56:56 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 7/9] ath10k: rework legacy rx rate decoding
Date: Fri, 20 Mar 2015 13:54:13 +0000
Message-Id: <1426859655-11797-8-git-send-email-michal.kazior@tieto.com> (sfid-20150320_145706_791206_D265CB9A)
In-Reply-To: <1426859655-11797-1-git-send-email-michal.kazior@tieto.com>
References: <1426859655-11797-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Instead of using a hacky table and magic values
use supported band information advertised to
mac80211.

This may impact performance a little when dealing
with legacy rx rates depending on system
architecture. It's probably negligible.

This also fixes a highly theoretical corner case
when HT/VHT rates weren't reported correctly if
channel frequency wasn't known.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/htt_rx.c | 64 ++++++--------------------------
 drivers/net/wireless/ath/ath10k/mac.c    | 37 ++++++++++++++++--
 drivers/net/wireless/ath/ath10k/mac.h    |  2 +
 3 files changed, 46 insertions(+), 57 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index 01a2b38..0cbd538 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -651,44 +651,15 @@ struct amsdu_subframe_hdr {
 	__be16 len;
 } __packed;
 
-static const u8 rx_legacy_rate_idx[] = {
-	3,	/* 0x00  - 11Mbps  */
-	2,	/* 0x01  - 5.5Mbps */
-	1,	/* 0x02  - 2Mbps   */
-	0,	/* 0x03  - 1Mbps   */
-	3,	/* 0x04  - 11Mbps  */
-	2,	/* 0x05  - 5.5Mbps */
-	1,	/* 0x06  - 2Mbps   */
-	0,	/* 0x07  - 1Mbps   */
-	10,	/* 0x08  - 48Mbps  */
-	8,	/* 0x09  - 24Mbps  */
-	6,	/* 0x0A  - 12Mbps  */
-	4,	/* 0x0B  - 6Mbps   */
-	11,	/* 0x0C  - 54Mbps  */
-	9,	/* 0x0D  - 36Mbps  */
-	7,	/* 0x0E  - 18Mbps  */
-	5,	/* 0x0F  - 9Mbps   */
-};
-
 static void ath10k_htt_rx_h_rates(struct ath10k *ar,
 				  struct ieee80211_rx_status *status,
 				  struct htt_rx_desc *rxd)
 {
-	enum ieee80211_band band;
-	u8 cck, rate, rate_idx, bw, sgi, mcs, nss;
+	struct ieee80211_supported_band *sband;
+	u8 cck, rate, bw, sgi, mcs, nss;
 	u8 preamble = 0;
 	u32 info1, info2, info3;
 
-	/* Band value can't be set as undefined but freq can be 0 - use that to
-	 * determine whether band is provided.
-	 *
-	 * FIXME: Perhaps this can go away if CCK rate reporting is a little
-	 * reworked?
-	 */
-	if (!status->freq)
-		return;
-
-	band = status->band;
 	info1 = __le32_to_cpu(rxd->ppdu_start.info1);
 	info2 = __le32_to_cpu(rxd->ppdu_start.info2);
 	info3 = __le32_to_cpu(rxd->ppdu_start.info3);
@@ -697,31 +668,18 @@ static void ath10k_htt_rx_h_rates(struct ath10k *ar,
 
 	switch (preamble) {
 	case HTT_RX_LEGACY:
+		/* To get legacy rate index band is required. Since band can't
+		 * be undefined check if freq is non-zero.
+		 */
+		if (!status->freq)
+			return;
+
 		cck = info1 & RX_PPDU_START_INFO1_L_SIG_RATE_SELECT;
 		rate = MS(info1, RX_PPDU_START_INFO1_L_SIG_RATE);
-		rate_idx = 0;
-
-		if (rate < 0x08 || rate > 0x0F)
-			break;
-
-		switch (band) {
-		case IEEE80211_BAND_2GHZ:
-			if (cck)
-				rate &= ~BIT(3);
-			rate_idx = rx_legacy_rate_idx[rate];
-			break;
-		case IEEE80211_BAND_5GHZ:
-			rate_idx = rx_legacy_rate_idx[rate];
-			/* We are using same rate table registering
-			   HW - ath10k_rates[]. In case of 5GHz skip
-			   CCK rates, so -4 here */
-			rate_idx -= 4;
-			break;
-		default:
-			break;
-		}
+		rate &= ~RX_PPDU_START_RATE_FLAG;
 
-		status->rate_idx = rate_idx;
+		sband = &ar->mac.sbands[status->band];
+		status->rate_idx = ath10k_mac_hw_rate_to_idx(sband, rate);
 		break;
 	case HTT_RX_HT:
 	case HTT_RX_HT_WITH_TXBF:
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 877afde..e1902e3 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -35,10 +35,20 @@
 /*********/
 
 static struct ieee80211_rate ath10k_rates[] = {
-	{ .bitrate = 10, .hw_value = ATH10K_HW_RATE_CCK_LP_1M },
-	{ .bitrate = 20, .hw_value = ATH10K_HW_RATE_CCK_LP_2M },
-	{ .bitrate = 55, .hw_value = ATH10K_HW_RATE_CCK_LP_5_5M },
-	{ .bitrate = 110, .hw_value = ATH10K_HW_RATE_CCK_LP_11M },
+	{ .bitrate = 10,
+	  .hw_value = ATH10K_HW_RATE_CCK_LP_1M },
+	{ .bitrate = 20,
+	  .hw_value = ATH10K_HW_RATE_CCK_LP_2M,
+	  .hw_value_short = ATH10K_HW_RATE_CCK_SP_2M,
+	  .flags = IEEE80211_RATE_SHORT_PREAMBLE },
+	{ .bitrate = 55,
+	  .hw_value = ATH10K_HW_RATE_CCK_LP_5_5M,
+	  .hw_value_short = ATH10K_HW_RATE_CCK_SP_5_5M,
+	  .flags = IEEE80211_RATE_SHORT_PREAMBLE },
+	{ .bitrate = 110,
+	  .hw_value = ATH10K_HW_RATE_CCK_LP_11M,
+	  .hw_value_short = ATH10K_HW_RATE_CCK_SP_11M,
+	  .flags = IEEE80211_RATE_SHORT_PREAMBLE },
 
 	{ .bitrate = 60, .hw_value = ATH10K_HW_RATE_OFDM_6M },
 	{ .bitrate = 90, .hw_value = ATH10K_HW_RATE_OFDM_9M },
@@ -74,6 +84,25 @@ static u8 ath10k_mac_bitrate_to_rate(int bitrate)
 	       (ath10k_mac_bitrate_is_cck(bitrate) ? BIT(7) : 0);
 }
 
+u8 ath10k_mac_hw_rate_to_idx(const struct ieee80211_supported_band *sband,
+			     u8 hw_rate)
+{
+	const struct ieee80211_rate *rate;
+	int i;
+
+	for (i = 0; i < sband->n_bitrates; i++) {
+		rate = &sband->bitrates[i];
+
+		if (rate->hw_value == hw_rate)
+			return i;
+		else if (rate->flags & IEEE80211_RATE_SHORT_PREAMBLE &&
+			 rate->hw_value_short == hw_rate)
+			return i;
+	}
+
+	return 0;
+}
+
 /**********/
 /* Crypto */
 /**********/
diff --git a/drivers/net/wireless/ath/ath10k/mac.h b/drivers/net/wireless/ath/ath10k/mac.h
index 3b64d99..e615490 100644
--- a/drivers/net/wireless/ath/ath10k/mac.h
+++ b/drivers/net/wireless/ath/ath10k/mac.h
@@ -47,6 +47,8 @@ bool ath10k_mac_is_peer_wep_key_set(struct ath10k *ar, const u8 *addr,
 				    u8 keyidx);
 void ath10k_mac_handle_beacon(struct ath10k *ar, struct sk_buff *skb);
 void ath10k_mac_handle_beacon_miss(struct ath10k *ar, u32 vdev_id);
+u8 ath10k_mac_hw_rate_to_idx(const struct ieee80211_supported_band *sband,
+			     u8 hw_rate);
 
 static inline struct ath10k_vif *ath10k_vif_to_arvif(struct ieee80211_vif *vif)
 {
-- 
2.1.4

