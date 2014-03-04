Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f173.google.com ([209.85.215.173]:41027 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757219AbaCDMwz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Mar 2014 07:52:55 -0500
Received: by mail-ea0-f173.google.com with SMTP id r15so335681ead.4
        for <linux-wireless@vger.kernel.org>; Tue, 04 Mar 2014 04:52:54 -0800 (PST)
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [RFC 08/14] ath10k: kill rate substruct and tsf from htt_rx_info
Date: Tue,  4 Mar 2014 13:52:21 +0100
Message-Id: <1393937548-7482-9-git-send-email-janusz.dziedzic@tieto.com> (sfid-20140304_135306_714561_D1B4BA10)
In-Reply-To: <1393937548-7482-1-git-send-email-janusz.dziedzic@tieto.com>
References: <1393937548-7482-1-git-send-email-janusz.dziedzic@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Setup rates only once per-ppdu.

Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
---
 drivers/net/wireless/ath/ath10k/htt.h    |    7 -------
 drivers/net/wireless/ath/ath10k/htt_rx.c |   32 +++++++++++++++---------------
 2 files changed, 16 insertions(+), 23 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/htt.h b/drivers/net/wireless/ath/ath10k/htt.h
index 9f5da2b..ea39b87 100644
--- a/drivers/net/wireless/ath/ath10k/htt.h
+++ b/drivers/net/wireless/ath/ath10k/htt.h
@@ -1178,13 +1178,6 @@ struct htt_rx_info {
 	struct ieee80211_rx_status rx_status;
 	enum htt_rx_mpdu_status status;
 	enum htt_rx_mpdu_encrypt_type encrypt_type;
-	struct {
-		u8 info0;
-		u32 info1;
-		u32 info2;
-	} rate;
-
-	u32 tsf;
 	bool fcs_err;
 	bool amsdu_more;
 	bool mic_err;
diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index 0c34096..4eca6e6 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -655,14 +655,12 @@ static const u8 rx_legacy_rate_idx[] = {
 	5,	/* 0x0F  - 9Mbps   */
 };
 
-static void ath10k_htt_rx_h_rates(struct ath10k *ar, struct htt_rx_info *info,
+static void ath10k_htt_rx_h_rates(struct ath10k *ar,
 				  enum ieee80211_band band,
+				  u8 info0, u32 info1, u32 info2,
 				  struct ieee80211_rx_status *status)
 {
 	u8 cck, rate, rate_idx, bw, sgi, mcs, nss;
-	u8 info0 = info->rate.info0;
-	u32 info1 = info->rate.info1;
-	u32 info2 = info->rate.info2;
 	u8 preamble = 0;
 
 	/* Check if valid fields */
@@ -794,14 +792,6 @@ static void ath10k_process_rx(struct ath10k *ar, struct htt_rx_info *info)
 	if (info->amsdu_more)
 		status->flag |= RX_FLAG_AMSDU_MORE;
 
-	ath10k_htt_rx_h_rates(ar, info, status->band, status);
-
-	if (info->rate.info0 & HTT_RX_INDICATION_INFO0_END_VALID) {
-		/* TSF available only in 32-bit */
-		status->mactime = info->tsf & 0xffffffff;
-		status->flag |= RX_FLAG_MACTIME_END;
-	}
-
 	ath10k_dbg(ATH10K_DBG_DATA,
 		   "rx skb %p len %u %s%s%s%s%s %srate_idx %u vht_nss %u freq %u band %u flag 0x%x fcs-err %i\n",
 		   info->skb,
@@ -1177,12 +1167,22 @@ static void ath10k_htt_rx_handler(struct ath10k_htt *htt,
 	info.rx_status.signal  = ATH10K_DEFAULT_NOISE_FLOOR;
 	info.rx_status.signal += rx->ppdu.combined_rssi;
 
+	if (rx->ppdu.info0 & HTT_RX_INDICATION_INFO0_END_VALID) {
+		/* TSF available only in 32-bit */
+		info.rx_status.mactime =
+				__le32_to_cpu(rx->ppdu.tsf) & 0xffffffff;
+		info.rx_status.flag |= RX_FLAG_MACTIME_END;
+	}
+
 	channel_set = ath10k_htt_rx_h_channel(htt->ar, &info.rx_status);
 
-	info.rate.info0 = rx->ppdu.info0;
-	info.rate.info1 = __le32_to_cpu(rx->ppdu.info1);
-	info.rate.info2 = __le32_to_cpu(rx->ppdu.info2);
-	info.tsf = __le32_to_cpu(rx->ppdu.tsf);
+	if (channel_set) {
+		ath10k_htt_rx_h_rates(htt->ar, info.rx_status.band,
+				      rx->ppdu.info0,
+				      __le32_to_cpu(rx->ppdu.info1),
+				      __le32_to_cpu(rx->ppdu.info2),
+				      &info.rx_status);
+	}
 
 	ath10k_dbg_dump(ATH10K_DBG_HTT_DUMP, NULL, "htt rx ind: ",
 			rx, sizeof(*rx) +
-- 
1.7.9.5

