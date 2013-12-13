Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f45.google.com ([74.125.83.45]:52347 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751602Ab3LMMo1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Dec 2013 07:44:27 -0500
Received: by mail-ee0-f45.google.com with SMTP id d49so853161eek.4
        for <linux-wireless@vger.kernel.org>; Fri, 13 Dec 2013 04:44:26 -0800 (PST)
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [PATCH] ath10k: handle TKIP MIC error correctly
Date: Fri, 13 Dec 2013 13:44:16 +0100
Message-Id: <1386938656-5280-1-git-send-email-janusz.dziedzic@tieto.com> (sfid-20131213_134431_727442_C0DC2B62)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We should check MIC error flag base on
rx_attention, to have consistent status
of MIC failure and FCS error.

Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
---
 drivers/net/wireless/ath/ath10k/htt.h    |    1 +
 drivers/net/wireless/ath/ath10k/htt_rx.c |   15 +++++++++++++++
 drivers/net/wireless/ath/ath10k/txrx.c   |    2 +-
 3 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/htt.h b/drivers/net/wireless/ath/ath10k/htt.h
index 7fc7919..b93ae35 100644
--- a/drivers/net/wireless/ath/ath10k/htt.h
+++ b/drivers/net/wireless/ath/ath10k/htt.h
@@ -1183,6 +1183,7 @@ struct htt_rx_info {
 	} rate;
 	bool fcs_err;
 	bool amsdu_more;
+	bool mic_err;
 };
 
 struct ath10k_htt {
diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index fcb534f..fe8bd1b 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -838,6 +838,20 @@ static bool ath10k_htt_rx_has_fcs_err(struct sk_buff *skb)
 	return false;
 }
 
+static bool ath10k_htt_rx_has_mic_err(struct sk_buff *skb)
+{
+	struct htt_rx_desc *rxd;
+	u32 flags;
+
+	rxd = (void *)skb->data - sizeof(*rxd);
+	flags = __le32_to_cpu(rxd->attention.flags);
+
+	if (flags & RX_ATTENTION_FLAGS_TKIP_MIC_ERR)
+		return true;
+
+	return false;
+}
+
 static int ath10k_htt_rx_get_csum_state(struct sk_buff *skb)
 {
 	struct htt_rx_desc *rxd;
@@ -960,6 +974,7 @@ static void ath10k_htt_rx_handler(struct ath10k_htt *htt,
 
 			info.skb     = msdu_head;
 			info.fcs_err = ath10k_htt_rx_has_fcs_err(msdu_head);
+			info.mic_err = ath10k_htt_rx_has_mic_err(msdu_head);
 			info.signal  = ATH10K_DEFAULT_NOISE_FLOOR;
 			info.signal += rx->ppdu.combined_rssi;
 
diff --git a/drivers/net/wireless/ath/ath10k/txrx.c b/drivers/net/wireless/ath/ath10k/txrx.c
index 2282980..74f45fa6 100644
--- a/drivers/net/wireless/ath/ath10k/txrx.c
+++ b/drivers/net/wireless/ath/ath10k/txrx.c
@@ -231,7 +231,7 @@ void ath10k_process_rx(struct ath10k *ar, struct htt_rx_info *info)
 				~IEEE80211_FCTL_PROTECTED);
 	}
 
-	if (info->status == HTT_RX_IND_MPDU_STATUS_TKIP_MIC_ERR)
+	if (info->mic_err)
 		status->flag |= RX_FLAG_MMIC_ERROR;
 
 	if (info->fcs_err)
-- 
1.7.9.5

