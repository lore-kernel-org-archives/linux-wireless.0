Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f47.google.com ([74.125.83.47]:36178 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757346AbaCDMwy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Mar 2014 07:52:54 -0500
Received: by mail-ee0-f47.google.com with SMTP id b15so1970940eek.34
        for <linux-wireless@vger.kernel.org>; Tue, 04 Mar 2014 04:52:53 -0800 (PST)
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [RFC 07/14] ath10k: setup rx channel per ppdu
Date: Tue,  4 Mar 2014 13:52:20 +0100
Message-Id: <1393937548-7482-8-git-send-email-janusz.dziedzic@tieto.com> (sfid-20140304_135301_861805_02FFF3EF)
In-Reply-To: <1393937548-7482-1-git-send-email-janusz.dziedzic@tieto.com>
References: <1393937548-7482-1-git-send-email-janusz.dziedzic@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Setup band and frequency in ieee80211_rx_status
only once - for ppdu.

Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
---
 drivers/net/wireless/ath/ath10k/htt_rx.c |   51 +++++++++++++++++++-----------
 1 file changed, 33 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index fa6540b..0c34096 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -749,10 +749,29 @@ static void ath10k_htt_rx_h_rates(struct ath10k *ar, struct htt_rx_info *info,
 	}
 }
 
+static bool ath10k_htt_rx_h_channel(struct ath10k *ar,
+				    struct ieee80211_rx_status *status)
+{
+	struct ieee80211_channel *ch;
+
+	spin_lock_bh(&ar->data_lock);
+	ch = ar->scan_channel;
+	if (!ch)
+		ch = ar->rx_channel;
+	spin_unlock_bh(&ar->data_lock);
+
+	if (!ch)
+		return false;
+
+	status->band = ch->band;
+	status->freq = ch->center_freq;
+
+	return true;
+}
+
 static void ath10k_process_rx(struct ath10k *ar, struct htt_rx_info *info)
 {
 	struct ieee80211_rx_status *status;
-	struct ieee80211_channel *ch;
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)info->skb->data;
 
 	status = IEEE80211_SKB_RXCB(info->skb);
@@ -775,21 +794,7 @@ static void ath10k_process_rx(struct ath10k *ar, struct htt_rx_info *info)
 	if (info->amsdu_more)
 		status->flag |= RX_FLAG_AMSDU_MORE;
 
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
-	ath10k_htt_rx_h_rates(ar, info, ch->band, status);
-	status->band = ch->band;
-	status->freq = ch->center_freq;
+	ath10k_htt_rx_h_rates(ar, info, status->band, status);
 
 	if (info->rate.info0 & HTT_RX_INDICATION_INFO0_END_VALID) {
 		/* TSF available only in 32-bit */
@@ -1085,7 +1090,8 @@ static int ath10k_htt_rx_get_csum_state(struct sk_buff *skb)
 static bool ath10k_htt_rx_amsdu_allowed(struct ath10k_htt *htt,
 					struct sk_buff *head,
 					bool msdu_chaining,
-					struct htt_rx_info *info)
+					struct htt_rx_info *info,
+					bool channel_set)
 {
 	enum htt_rx_mpdu_status status = info->status;
 
@@ -1106,6 +1112,11 @@ static bool ath10k_htt_rx_amsdu_allowed(struct ath10k_htt *htt,
 		return false;
 	}
 
+	if (!channel_set) {
+		ath10k_warn("no channel configured; ignoring frame!\n");
+		return false;
+	}
+
 	/* Skip mgmt frames while we handle this in WMI */
 	if (status == HTT_RX_IND_MPDU_STATUS_MGMT_CTRL ||
 	    ath10k_htt_rx_is_mgmt(head)) {
@@ -1148,6 +1159,7 @@ static void ath10k_htt_rx_handler(struct ath10k_htt *htt,
 	int num_mpdu_ranges;
 	int fw_desc_len;
 	u8 *fw_desc;
+	bool channel_set;
 	int i, j;
 
 	lockdep_assert_held(&htt->rx_ring.lock);
@@ -1165,6 +1177,8 @@ static void ath10k_htt_rx_handler(struct ath10k_htt *htt,
 	info.rx_status.signal  = ATH10K_DEFAULT_NOISE_FLOOR;
 	info.rx_status.signal += rx->ppdu.combined_rssi;
 
+	channel_set = ath10k_htt_rx_h_channel(htt->ar, &info.rx_status);
+
 	info.rate.info0 = rx->ppdu.info0;
 	info.rate.info1 = __le32_to_cpu(rx->ppdu.info1);
 	info.rate.info2 = __le32_to_cpu(rx->ppdu.info2);
@@ -1192,7 +1206,8 @@ static void ath10k_htt_rx_handler(struct ath10k_htt *htt,
 
 			if (!ath10k_htt_rx_amsdu_allowed(htt, msdu_head,
 							 !!msdu_chaining,
-							 &info)) {
+							 &info,
+							 channel_set)) {
 				ath10k_htt_rx_free_msdu_chain(msdu_head);
 				continue;
 			}
-- 
1.7.9.5

