Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f54.google.com ([209.85.215.54]:34062 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753376AbaKDOea (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Nov 2014 09:34:30 -0500
Received: by mail-la0-f54.google.com with SMTP id s18so998075lam.13
        for <linux-wireless@vger.kernel.org>; Tue, 04 Nov 2014 06:34:28 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 6/7] ath10k: use rx descriptor for ppdu status extraction
Date: Tue,  4 Nov 2014 15:22:10 +0100
Message-Id: <1415110931-10945-7-git-send-email-michal.kazior@tieto.com> (sfid-20141104_153436_205472_713223FA)
In-Reply-To: <1415110931-10945-1-git-send-email-michal.kazior@tieto.com>
References: <1415110931-10945-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This makes it more in line with the new Rx path.
It also makes the code more reusable because Rx
descriptor is more accessible.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/htt_rx.c | 137 ++++++++++++++++++++++---------
 1 file changed, 96 insertions(+), 41 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index 55e4568..9073a0e 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -631,23 +631,34 @@ static const u8 rx_legacy_rate_idx[] = {
 };
 
 static void ath10k_htt_rx_h_rates(struct ath10k *ar,
-				  enum ieee80211_band band,
-				  u8 info0, u32 info1, u32 info2,
-				  struct ieee80211_rx_status *status)
+				  struct ieee80211_rx_status *status,
+				  struct htt_rx_desc *rxd)
 {
+	enum ieee80211_band band;
 	u8 cck, rate, rate_idx, bw, sgi, mcs, nss;
 	u8 preamble = 0;
+	u32 info1, info2, info3;
 
-	/* Check if valid fields */
-	if (!(info0 & HTT_RX_INDICATION_INFO0_START_VALID))
+	/* Band value can't be set as undefined but freq can be 0 - use that to
+	 * determine whether band is provided.
+	 *
+	 * FIXME: Perhaps this can go away if CCK rate reporting is a little
+	 * reworked?
+	 */
+	if (!status->freq)
 		return;
 
-	preamble = MS(info1, HTT_RX_INDICATION_INFO1_PREAMBLE_TYPE);
+	band = status->band;
+	info1 = __le32_to_cpu(rxd->ppdu_start.info1);
+	info2 = __le32_to_cpu(rxd->ppdu_start.info2);
+	info3 = __le32_to_cpu(rxd->ppdu_start.info3);
+
+	preamble = MS(info1, RX_PPDU_START_INFO1_PREAMBLE_TYPE);
 
 	switch (preamble) {
 	case HTT_RX_LEGACY:
-		cck = info0 & HTT_RX_INDICATION_INFO0_LEGACY_RATE_CCK;
-		rate = MS(info0, HTT_RX_INDICATION_INFO0_LEGACY_RATE);
+		cck = info1 & RX_PPDU_START_INFO1_L_SIG_RATE_SELECT;
+		rate = MS(info1, RX_PPDU_START_INFO1_L_SIG_RATE);
 		rate_idx = 0;
 
 		if (rate < 0x08 || rate > 0x0F)
@@ -674,11 +685,11 @@ static void ath10k_htt_rx_h_rates(struct ath10k *ar,
 		break;
 	case HTT_RX_HT:
 	case HTT_RX_HT_WITH_TXBF:
-		/* HT-SIG - Table 20-11 in info1 and info2 */
-		mcs = info1 & 0x1F;
+		/* HT-SIG - Table 20-11 in info2 and info3 */
+		mcs = info2 & 0x1F;
 		nss = mcs >> 3;
-		bw = (info1 >> 7) & 1;
-		sgi = (info2 >> 7) & 1;
+		bw = (info2 >> 7) & 1;
+		sgi = (info3 >> 7) & 1;
 
 		status->rate_idx = mcs;
 		status->flag |= RX_FLAG_HT;
@@ -689,12 +700,12 @@ static void ath10k_htt_rx_h_rates(struct ath10k *ar,
 		break;
 	case HTT_RX_VHT:
 	case HTT_RX_VHT_WITH_TXBF:
-		/* VHT-SIG-A1 in info 1, VHT-SIG-A2 in info2
+		/* VHT-SIG-A1 in info2, VHT-SIG-A2 in info3
 		   TODO check this */
-		mcs = (info2 >> 4) & 0x0F;
-		nss = ((info1 >> 10) & 0x07) + 1;
-		bw = info1 & 3;
-		sgi = info2 & 1;
+		mcs = (info3 >> 4) & 0x0F;
+		nss = ((info2 >> 10) & 0x07) + 1;
+		bw = info2 & 3;
+		sgi = info3 & 1;
 
 		status->rate_idx = mcs;
 		status->vht_nss = nss;
@@ -742,6 +753,73 @@ static bool ath10k_htt_rx_h_channel(struct ath10k *ar,
 	return true;
 }
 
+static void ath10k_htt_rx_h_signal(struct ath10k *ar,
+				   struct ieee80211_rx_status *status,
+				   struct htt_rx_desc *rxd)
+{
+	/* FIXME: Get real NF */
+	status->signal = ATH10K_DEFAULT_NOISE_FLOOR +
+			 rxd->ppdu_start.rssi_comb;
+	status->flag &= ~RX_FLAG_NO_SIGNAL_VAL;
+}
+
+static void ath10k_htt_rx_h_mactime(struct ath10k *ar,
+				    struct ieee80211_rx_status *status,
+				    struct htt_rx_desc *rxd)
+{
+	/* FIXME: TSF is known only at the end of PPDU, in the last MPDU. This
+	 * means all prior MSDUs in a PPDU are reported to mac80211 without the
+	 * TSF. Is it worth holding frames until end of PPDU is known?
+	 *
+	 * FIXME: Can we get/compute 64bit TSF?
+	 */
+	status->mactime = __le32_to_cpu(rxd->ppdu_end.tsf_timestamp);
+	status->flag |= RX_FLAG_MACTIME_END;
+}
+
+static void ath10k_htt_rx_h_ppdu(struct ath10k *ar,
+				 struct sk_buff_head *amsdu,
+				 struct ieee80211_rx_status *status)
+{
+	struct sk_buff *first;
+	struct htt_rx_desc *rxd;
+	bool is_first_ppdu;
+	bool is_last_ppdu;
+
+	if (skb_queue_empty(amsdu))
+		return;
+
+	first = skb_peek(amsdu);
+	rxd = (void *)first->data - sizeof(*rxd);
+
+	is_first_ppdu = !!(rxd->attention.flags &
+			   __cpu_to_le32(RX_ATTENTION_FLAGS_FIRST_MPDU));
+	is_last_ppdu = !!(rxd->attention.flags &
+			  __cpu_to_le32(RX_ATTENTION_FLAGS_LAST_MPDU));
+
+	if (is_first_ppdu) {
+		/* New PPDU starts so clear out the old per-PPDU status. */
+		status->freq = 0;
+		status->rate_idx = 0;
+		status->vht_nss = 0;
+		status->vht_flag &= ~RX_VHT_FLAG_80MHZ;
+		status->flag &= ~(RX_FLAG_HT |
+				  RX_FLAG_VHT |
+				  RX_FLAG_SHORT_GI |
+				  RX_FLAG_40MHZ |
+				  RX_FLAG_MACTIME_END);
+		status->flag |= RX_FLAG_NO_SIGNAL_VAL;
+
+		ath10k_htt_rx_h_signal(ar, status, rxd);
+		ath10k_htt_rx_h_channel(ar, status);
+		ath10k_htt_rx_h_rates(ar, status, rxd);
+	}
+
+	if (is_last_ppdu) {
+		ath10k_htt_rx_h_mactime(ar, status, rxd);
+	}
+}
+
 static const char * const tid_to_ac[] = {
 	"BE",
 	"BK",
@@ -1358,7 +1436,6 @@ static void ath10k_htt_rx_handler(struct ath10k_htt *htt,
 	int num_mpdu_ranges;
 	int fw_desc_len;
 	u8 *fw_desc;
-	bool channel_set;
 	int i, ret, mpdu_count = 0;
 
 	lockdep_assert_held(&htt->rx_ring.lock);
@@ -1373,29 +1450,6 @@ static void ath10k_htt_rx_handler(struct ath10k_htt *htt,
 			     HTT_RX_INDICATION_INFO1_NUM_MPDU_RANGES);
 	mpdu_ranges = htt_rx_ind_get_mpdu_ranges(rx);
 
-	/* Fill this once, while this is per-ppdu */
-	if (rx->ppdu.info0 & HTT_RX_INDICATION_INFO0_START_VALID) {
-		memset(rx_status, 0, sizeof(*rx_status));
-		rx_status->signal  = ATH10K_DEFAULT_NOISE_FLOOR +
-				     rx->ppdu.combined_rssi;
-	}
-
-	if (rx->ppdu.info0 & HTT_RX_INDICATION_INFO0_END_VALID) {
-		/* TSF available only in 32-bit */
-		rx_status->mactime = __le32_to_cpu(rx->ppdu.tsf) & 0xffffffff;
-		rx_status->flag |= RX_FLAG_MACTIME_END;
-	}
-
-	channel_set = ath10k_htt_rx_h_channel(htt->ar, rx_status);
-
-	if (channel_set) {
-		ath10k_htt_rx_h_rates(htt->ar, rx_status->band,
-				      rx->ppdu.info0,
-				      __le32_to_cpu(rx->ppdu.info1),
-				      __le32_to_cpu(rx->ppdu.info2),
-				      rx_status);
-	}
-
 	ath10k_dbg_dump(ar, ATH10K_DBG_HTT_DUMP, NULL, "htt rx ind: ",
 			rx, sizeof(*rx) +
 			(sizeof(struct htt_rx_indication_mpdu_range) *
@@ -1418,6 +1472,7 @@ static void ath10k_htt_rx_handler(struct ath10k_htt *htt,
 			break;
 		}
 
+		ath10k_htt_rx_h_ppdu(ar, &amsdu, rx_status);
 		ath10k_htt_rx_h_unchain(ar, &amsdu, ret > 0);
 		ath10k_htt_rx_h_filter(ar, &amsdu, rx_status);
 		ath10k_htt_rx_h_mpdu(ar, &amsdu, rx_status);
-- 
1.8.5.3

