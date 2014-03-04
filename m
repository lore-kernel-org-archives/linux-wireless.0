Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f43.google.com ([74.125.83.43]:55726 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757343AbaCDMwt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Mar 2014 07:52:49 -0500
Received: by mail-ee0-f43.google.com with SMTP id e53so4628032eek.30
        for <linux-wireless@vger.kernel.org>; Tue, 04 Mar 2014 04:52:48 -0800 (PST)
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [RFC 03/14] ath10k: move rx related functions to htt_rx.c
Date: Tue,  4 Mar 2014 13:52:16 +0100
Message-Id: <1393937548-7482-4-git-send-email-janusz.dziedzic@tieto.com> (sfid-20140304_135255_311953_A112DB0C)
In-Reply-To: <1393937548-7482-1-git-send-email-janusz.dziedzic@tieto.com>
References: <1393937548-7482-1-git-send-email-janusz.dziedzic@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

No functional changes.

Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
---
 drivers/net/wireless/ath/ath10k/htt_rx.c |  183 ++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/txrx.c   |  183 ------------------------------
 drivers/net/wireless/ath/ath10k/txrx.h   |    1 -
 3 files changed, 183 insertions(+), 184 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index 0d0862d..ad3918c 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -636,6 +636,189 @@ struct amsdu_subframe_hdr {
 	__be16 len;
 } __packed;
 
+static const u8 rx_legacy_rate_idx[] = {
+	3,	/* 0x00  - 11Mbps  */
+	2,	/* 0x01  - 5.5Mbps */
+	1,	/* 0x02  - 2Mbps   */
+	0,	/* 0x03  - 1Mbps   */
+	3,	/* 0x04  - 11Mbps  */
+	2,	/* 0x05  - 5.5Mbps */
+	1,	/* 0x06  - 2Mbps   */
+	0,	/* 0x07  - 1Mbps   */
+	10,	/* 0x08  - 48Mbps  */
+	8,	/* 0x09  - 24Mbps  */
+	6,	/* 0x0A  - 12Mbps  */
+	4,	/* 0x0B  - 6Mbps   */
+	11,	/* 0x0C  - 54Mbps  */
+	9,	/* 0x0D  - 36Mbps  */
+	7,	/* 0x0E  - 18Mbps  */
+	5,	/* 0x0F  - 9Mbps   */
+};
+
+static void process_rx_rates(struct ath10k *ar, struct htt_rx_info *info,
+			     enum ieee80211_band band,
+			     struct ieee80211_rx_status *status)
+{
+	u8 cck, rate, rate_idx, bw, sgi, mcs, nss;
+	u8 info0 = info->rate.info0;
+	u32 info1 = info->rate.info1;
+	u32 info2 = info->rate.info2;
+	u8 preamble = 0;
+
+	/* Check if valid fields */
+	if (!(info0 & HTT_RX_INDICATION_INFO0_START_VALID))
+		return;
+
+	preamble = MS(info1, HTT_RX_INDICATION_INFO1_PREAMBLE_TYPE);
+
+	switch (preamble) {
+	case HTT_RX_LEGACY:
+		cck = info0 & HTT_RX_INDICATION_INFO0_LEGACY_RATE_CCK;
+		rate = MS(info0, HTT_RX_INDICATION_INFO0_LEGACY_RATE);
+		rate_idx = 0;
+
+		if (rate < 0x08 || rate > 0x0F)
+			break;
+
+		switch (band) {
+		case IEEE80211_BAND_2GHZ:
+			if (cck)
+				rate &= ~BIT(3);
+			rate_idx = rx_legacy_rate_idx[rate];
+			break;
+		case IEEE80211_BAND_5GHZ:
+			rate_idx = rx_legacy_rate_idx[rate];
+			/* We are using same rate table registering
+			   HW - ath10k_rates[]. In case of 5GHz skip
+			   CCK rates, so -4 here */
+			rate_idx -= 4;
+			break;
+		default:
+			break;
+		}
+
+		status->rate_idx = rate_idx;
+		break;
+	case HTT_RX_HT:
+	case HTT_RX_HT_WITH_TXBF:
+		/* HT-SIG - Table 20-11 in info1 and info2 */
+		mcs = info1 & 0x1F;
+		nss = mcs >> 3;
+		bw = (info1 >> 7) & 1;
+		sgi = (info2 >> 7) & 1;
+
+		status->rate_idx = mcs;
+		status->flag |= RX_FLAG_HT;
+		if (sgi)
+			status->flag |= RX_FLAG_SHORT_GI;
+		if (bw)
+			status->flag |= RX_FLAG_40MHZ;
+		break;
+	case HTT_RX_VHT:
+	case HTT_RX_VHT_WITH_TXBF:
+		/* VHT-SIG-A1 in info 1, VHT-SIG-A2 in info2
+		   TODO check this */
+		mcs = (info2 >> 4) & 0x0F;
+		nss = ((info1 >> 10) & 0x07) + 1;
+		bw = info1 & 3;
+		sgi = info2 & 1;
+
+		status->rate_idx = mcs;
+		status->vht_nss = nss;
+
+		if (sgi)
+			status->flag |= RX_FLAG_SHORT_GI;
+
+		switch (bw) {
+		/* 20MHZ */
+		case 0:
+			break;
+		/* 40MHZ */
+		case 1:
+			status->flag |= RX_FLAG_40MHZ;
+			break;
+		/* 80MHZ */
+		case 2:
+			status->vht_flag |= RX_VHT_FLAG_80MHZ;
+		}
+
+		status->flag |= RX_FLAG_VHT;
+		break;
+	default:
+		break;
+	}
+}
+
+static void ath10k_process_rx(struct ath10k *ar, struct htt_rx_info *info)
+{
+	struct ieee80211_rx_status *status;
+	struct ieee80211_channel *ch;
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)info->skb->data;
+
+	status = IEEE80211_SKB_RXCB(info->skb);
+	memset(status, 0, sizeof(*status));
+
+	if (info->encrypt_type != HTT_RX_MPDU_ENCRYPT_NONE) {
+		status->flag |= RX_FLAG_DECRYPTED | RX_FLAG_IV_STRIPPED |
+				RX_FLAG_MMIC_STRIPPED;
+		hdr->frame_control = __cpu_to_le16(
+				__le16_to_cpu(hdr->frame_control) &
+				~IEEE80211_FCTL_PROTECTED);
+	}
+
+	if (info->mic_err)
+		status->flag |= RX_FLAG_MMIC_ERROR;
+
+	if (info->fcs_err)
+		status->flag |= RX_FLAG_FAILED_FCS_CRC;
+
+	if (info->amsdu_more)
+		status->flag |= RX_FLAG_AMSDU_MORE;
+
+	status->signal = info->signal;
+
+	spin_lock_bh(&ar->data_lock);
+	ch = ar->scan_channel;
+	if (!ch)
+		ch = ar->rx_channel;
+	spin_unlock_bh(&ar->data_lock);
+
+	if (!ch) {
+		ath10k_warn("no channel configured; ignoring frame!\n");
+		dev_kfree_skb_any(info->skb);
+		return;
+	}
+
+	process_rx_rates(ar, info, ch->band, status);
+	status->band = ch->band;
+	status->freq = ch->center_freq;
+
+	if (info->rate.info0 & HTT_RX_INDICATION_INFO0_END_VALID) {
+		/* TSF available only in 32-bit */
+		status->mactime = info->tsf & 0xffffffff;
+		status->flag |= RX_FLAG_MACTIME_END;
+	}
+
+	ath10k_dbg(ATH10K_DBG_DATA,
+		   "rx skb %p len %u %s%s%s%s%s %srate_idx %u vht_nss %u freq %u band %u flag 0x%x fcs-err %i\n",
+		   info->skb,
+		   info->skb->len,
+		   status->flag == 0 ? "legacy" : "",
+		   status->flag & RX_FLAG_HT ? "ht" : "",
+		   status->flag & RX_FLAG_VHT ? "vht" : "",
+		   status->flag & RX_FLAG_40MHZ ? "40" : "",
+		   status->vht_flag & RX_VHT_FLAG_80MHZ ? "80" : "",
+		   status->flag & RX_FLAG_SHORT_GI ? "sgi " : "",
+		   status->rate_idx,
+		   status->vht_nss,
+		   status->freq,
+		   status->band, status->flag, info->fcs_err);
+	ath10k_dbg_dump(ATH10K_DBG_HTT_DUMP, NULL, "rx skb: ",
+			info->skb->data, info->skb->len);
+
+	ieee80211_rx(ar->hw, info->skb);
+}
+
 static int ath10k_htt_rx_nwifi_hdrlen(struct ieee80211_hdr *hdr)
 {
 	/* nwifi header is padded to 4 bytes. this fixes 4addr rx */
diff --git a/drivers/net/wireless/ath/ath10k/txrx.c b/drivers/net/wireless/ath/ath10k/txrx.c
index 0541dd9..82669a7 100644
--- a/drivers/net/wireless/ath/ath10k/txrx.c
+++ b/drivers/net/wireless/ath/ath10k/txrx.c
@@ -100,189 +100,6 @@ exit:
 		wake_up(&htt->empty_tx_wq);
 }
 
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
-static void process_rx_rates(struct ath10k *ar, struct htt_rx_info *info,
-			     enum ieee80211_band band,
-			     struct ieee80211_rx_status *status)
-{
-	u8 cck, rate, rate_idx, bw, sgi, mcs, nss;
-	u8 info0 = info->rate.info0;
-	u32 info1 = info->rate.info1;
-	u32 info2 = info->rate.info2;
-	u8 preamble = 0;
-
-	/* Check if valid fields */
-	if (!(info0 & HTT_RX_INDICATION_INFO0_START_VALID))
-		return;
-
-	preamble = MS(info1, HTT_RX_INDICATION_INFO1_PREAMBLE_TYPE);
-
-	switch (preamble) {
-	case HTT_RX_LEGACY:
-		cck = info0 & HTT_RX_INDICATION_INFO0_LEGACY_RATE_CCK;
-		rate = MS(info0, HTT_RX_INDICATION_INFO0_LEGACY_RATE);
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
-
-		status->rate_idx = rate_idx;
-		break;
-	case HTT_RX_HT:
-	case HTT_RX_HT_WITH_TXBF:
-		/* HT-SIG - Table 20-11 in info1 and info2 */
-		mcs = info1 & 0x1F;
-		nss = mcs >> 3;
-		bw = (info1 >> 7) & 1;
-		sgi = (info2 >> 7) & 1;
-
-		status->rate_idx = mcs;
-		status->flag |= RX_FLAG_HT;
-		if (sgi)
-			status->flag |= RX_FLAG_SHORT_GI;
-		if (bw)
-			status->flag |= RX_FLAG_40MHZ;
-		break;
-	case HTT_RX_VHT:
-	case HTT_RX_VHT_WITH_TXBF:
-		/* VHT-SIG-A1 in info 1, VHT-SIG-A2 in info2
-		   TODO check this */
-		mcs = (info2 >> 4) & 0x0F;
-		nss = ((info1 >> 10) & 0x07) + 1;
-		bw = info1 & 3;
-		sgi = info2 & 1;
-
-		status->rate_idx = mcs;
-		status->vht_nss = nss;
-
-		if (sgi)
-			status->flag |= RX_FLAG_SHORT_GI;
-
-		switch (bw) {
-		/* 20MHZ */
-		case 0:
-			break;
-		/* 40MHZ */
-		case 1:
-			status->flag |= RX_FLAG_40MHZ;
-			break;
-		/* 80MHZ */
-		case 2:
-			status->vht_flag |= RX_VHT_FLAG_80MHZ;
-		}
-
-		status->flag |= RX_FLAG_VHT;
-		break;
-	default:
-		break;
-	}
-}
-
-void ath10k_process_rx(struct ath10k *ar, struct htt_rx_info *info)
-{
-	struct ieee80211_rx_status *status;
-	struct ieee80211_channel *ch;
-	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)info->skb->data;
-
-	status = IEEE80211_SKB_RXCB(info->skb);
-	memset(status, 0, sizeof(*status));
-
-	if (info->encrypt_type != HTT_RX_MPDU_ENCRYPT_NONE) {
-		status->flag |= RX_FLAG_DECRYPTED | RX_FLAG_IV_STRIPPED |
-				RX_FLAG_MMIC_STRIPPED;
-		hdr->frame_control = __cpu_to_le16(
-				__le16_to_cpu(hdr->frame_control) &
-				~IEEE80211_FCTL_PROTECTED);
-	}
-
-	if (info->mic_err)
-		status->flag |= RX_FLAG_MMIC_ERROR;
-
-	if (info->fcs_err)
-		status->flag |= RX_FLAG_FAILED_FCS_CRC;
-
-	if (info->amsdu_more)
-		status->flag |= RX_FLAG_AMSDU_MORE;
-
-	status->signal = info->signal;
-
-	spin_lock_bh(&ar->data_lock);
-	ch = ar->scan_channel;
-	if (!ch)
-		ch = ar->rx_channel;
-	spin_unlock_bh(&ar->data_lock);
-
-	if (!ch) {
-		ath10k_warn("no channel configured; ignoring frame!\n");
-		dev_kfree_skb_any(info->skb);
-		return;
-	}
-
-	process_rx_rates(ar, info, ch->band, status);
-	status->band = ch->band;
-	status->freq = ch->center_freq;
-
-	if (info->rate.info0 & HTT_RX_INDICATION_INFO0_END_VALID) {
-		/* TSF available only in 32-bit */
-		status->mactime = info->tsf & 0xffffffff;
-		status->flag |= RX_FLAG_MACTIME_END;
-	}
-
-	ath10k_dbg(ATH10K_DBG_DATA,
-		   "rx skb %p len %u %s%s%s%s%s %srate_idx %u vht_nss %u freq %u band %u flag 0x%x fcs-err %i\n",
-		   info->skb,
-		   info->skb->len,
-		   status->flag == 0 ? "legacy" : "",
-		   status->flag & RX_FLAG_HT ? "ht" : "",
-		   status->flag & RX_FLAG_VHT ? "vht" : "",
-		   status->flag & RX_FLAG_40MHZ ? "40" : "",
-		   status->vht_flag & RX_VHT_FLAG_80MHZ ? "80" : "",
-		   status->flag & RX_FLAG_SHORT_GI ? "sgi " : "",
-		   status->rate_idx,
-		   status->vht_nss,
-		   status->freq,
-		   status->band, status->flag, info->fcs_err);
-	ath10k_dbg_dump(ATH10K_DBG_HTT_DUMP, NULL, "rx skb: ",
-			info->skb->data, info->skb->len);
-
-	ieee80211_rx(ar->hw, info->skb);
-}
-
 struct ath10k_peer *ath10k_peer_find(struct ath10k *ar, int vdev_id,
 				     const u8 *addr)
 {
diff --git a/drivers/net/wireless/ath/ath10k/txrx.h b/drivers/net/wireless/ath/ath10k/txrx.h
index 356dc9c..aee3e20 100644
--- a/drivers/net/wireless/ath/ath10k/txrx.h
+++ b/drivers/net/wireless/ath/ath10k/txrx.h
@@ -21,7 +21,6 @@
 
 void ath10k_txrx_tx_unref(struct ath10k_htt *htt,
 			  const struct htt_tx_done *tx_done);
-void ath10k_process_rx(struct ath10k *ar, struct htt_rx_info *info);
 
 struct ath10k_peer *ath10k_peer_find(struct ath10k *ar, int vdev_id,
 				     const u8 *addr);
-- 
1.7.9.5

