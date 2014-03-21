Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f44.google.com ([74.125.83.44]:53424 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760185AbaCUJcr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Mar 2014 05:32:47 -0400
Received: by mail-ee0-f44.google.com with SMTP id e49so1571629eek.17
        for <linux-wireless@vger.kernel.org>; Fri, 21 Mar 2014 02:32:46 -0700 (PDT)
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [PATCH 4/8] ath10k: setup rx channel per ppdu
Date: Fri, 21 Mar 2014 10:32:17 +0100
Message-Id: <1395394341-3958-5-git-send-email-janusz.dziedzic@tieto.com> (sfid-20140321_103316_695339_CFF15204)
In-Reply-To: <1395394341-3958-1-git-send-email-janusz.dziedzic@tieto.com>
References: <1395394341-3958-1-git-send-email-janusz.dziedzic@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Setup band and frequency in ieee80211_rx_status
only once - for ppdu.

Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
---
 drivers/net/wireless/ath/ath10k/htt_rx.c |   53 +++++++++++++++++++-----------
 1 file changed, 33 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index f18e41c..b37540b 100644
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
@@ -775,23 +794,7 @@ static void ath10k_process_rx(struct ath10k *ar, struct htt_rx_info *info)
 	if (info->amsdu_more)
 		status->flag |= RX_FLAG_AMSDU_MORE;
 
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
-	ath10k_htt_rx_h_rates(ar, info, ch->band, status);
-	status->band = ch->band;
-	status->freq = ch->center_freq;
+	ath10k_htt_rx_h_rates(ar, info, status->band, status);
 
 	if (info->rate.info0 & HTT_RX_INDICATION_INFO0_END_VALID) {
 		/* TSF available only in 32-bit */
@@ -1137,7 +1140,8 @@ static int ath10k_unchain_msdu(struct sk_buff *msdu_head)
 
 static bool ath10k_htt_rx_amsdu_allowed(struct ath10k_htt *htt,
 					struct sk_buff *head,
-					struct htt_rx_info *info)
+					struct htt_rx_info *info,
+					bool channel_set)
 {
 	enum htt_rx_mpdu_status status = info->status;
 
@@ -1158,6 +1162,11 @@ static bool ath10k_htt_rx_amsdu_allowed(struct ath10k_htt *htt,
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
@@ -1193,6 +1202,7 @@ static void ath10k_htt_rx_handler(struct ath10k_htt *htt,
 	int num_mpdu_ranges;
 	int fw_desc_len;
 	u8 *fw_desc;
+	bool channel_set;
 	int i, j;
 
 	lockdep_assert_held(&htt->rx_ring.lock);
@@ -1210,6 +1220,8 @@ static void ath10k_htt_rx_handler(struct ath10k_htt *htt,
 	info.signal  = ATH10K_DEFAULT_NOISE_FLOOR;
 	info.signal += rx->ppdu.combined_rssi;
 
+	channel_set = ath10k_htt_rx_h_channel(htt->ar, &info.rx_status);
+
 	info.rate.info0 = rx->ppdu.info0;
 	info.rate.info1 = __le32_to_cpu(rx->ppdu.info1);
 	info.rate.info2 = __le32_to_cpu(rx->ppdu.info2);
@@ -1236,7 +1248,8 @@ static void ath10k_htt_rx_handler(struct ath10k_htt *htt,
 							 &msdu_tail);
 
 			if (!ath10k_htt_rx_amsdu_allowed(htt, msdu_head,
-							 &info)) {
+							 &info,
+							 channel_set)) {
 				ath10k_htt_rx_free_msdu_chain(msdu_head);
 				continue;
 			}
-- 
1.7.9.5

