Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f44.google.com ([74.125.83.44]:34778 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757349AbaCDMxE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Mar 2014 07:53:04 -0500
Received: by mail-ee0-f44.google.com with SMTP id e49so1966694eek.31
        for <linux-wireless@vger.kernel.org>; Tue, 04 Mar 2014 04:53:02 -0800 (PST)
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [RFC 14/14] ath10k: improve way we play with attention flags
Date: Tue,  4 Mar 2014 13:52:27 +0100
Message-Id: <1393937548-7482-15-git-send-email-janusz.dziedzic@tieto.com> (sfid-20140304_135320_993549_E1DDB13D)
In-Reply-To: <1393937548-7482-1-git-send-email-janusz.dziedzic@tieto.com>
References: <1393937548-7482-1-git-send-email-janusz.dziedzic@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove almost the same code, and do only once
__le32_to_cpu() conversion.

Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
---
 drivers/net/wireless/ath/ath10k/htt_rx.c |   77 ++++++------------------------
 1 file changed, 15 insertions(+), 62 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index e300a74..a70e38e 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -999,62 +999,6 @@ static void ath10k_htt_rx_msdu(struct ath10k_htt *htt, struct htt_rx_info *info)
 	ath10k_process_rx(htt->ar, info);
 }
 
-static bool ath10k_htt_rx_has_decrypt_err(struct sk_buff *skb)
-{
-	struct htt_rx_desc *rxd;
-	u32 flags;
-
-	rxd = (void *)skb->data - sizeof(*rxd);
-	flags = __le32_to_cpu(rxd->attention.flags);
-
-	if (flags & RX_ATTENTION_FLAGS_DECRYPT_ERR)
-		return true;
-
-	return false;
-}
-
-static bool ath10k_htt_rx_has_fcs_err(struct sk_buff *skb)
-{
-	struct htt_rx_desc *rxd;
-	u32 flags;
-
-	rxd = (void *)skb->data - sizeof(*rxd);
-	flags = __le32_to_cpu(rxd->attention.flags);
-
-	if (flags & RX_ATTENTION_FLAGS_FCS_ERR)
-		return true;
-
-	return false;
-}
-
-static bool ath10k_htt_rx_has_mic_err(struct sk_buff *skb)
-{
-	struct htt_rx_desc *rxd;
-	u32 flags;
-
-	rxd = (void *)skb->data - sizeof(*rxd);
-	flags = __le32_to_cpu(rxd->attention.flags);
-
-	if (flags & RX_ATTENTION_FLAGS_TKIP_MIC_ERR)
-		return true;
-
-	return false;
-}
-
-static bool ath10k_htt_rx_is_mgmt(struct sk_buff *skb)
-{
-	struct htt_rx_desc *rxd;
-	u32 flags;
-
-	rxd = (void *)skb->data - sizeof(*rxd);
-	flags = __le32_to_cpu(rxd->attention.flags);
-
-	if (flags & RX_ATTENTION_FLAGS_MGMT_TYPE)
-		return true;
-
-	return false;
-}
-
 static int ath10k_htt_rx_get_csum_state(struct sk_buff *skb)
 {
 	struct htt_rx_desc *rxd;
@@ -1090,7 +1034,8 @@ static bool ath10k_htt_rx_amsdu_allowed(struct ath10k_htt *htt,
 					struct sk_buff *head,
 					bool msdu_chaining,
 					enum htt_rx_mpdu_status status,
-					bool channel_set)
+					bool channel_set,
+					u32 attention)
 {
 	if (head->len == 0) {
 		ath10k_dbg(ATH10K_DBG_HTT,
@@ -1098,7 +1043,7 @@ static bool ath10k_htt_rx_amsdu_allowed(struct ath10k_htt *htt,
 		return false;
 	}
 
-	if (ath10k_htt_rx_has_decrypt_err(head)) {
+	if (attention & RX_ATTENTION_FLAGS_DECRYPT_ERR) {
 		ath10k_dbg(ATH10K_DBG_HTT,
 			   "htt rx dropping due to decrypt-err\n");
 		return false;
@@ -1111,7 +1056,7 @@ static bool ath10k_htt_rx_amsdu_allowed(struct ath10k_htt *htt,
 
 	/* Skip mgmt frames while we handle this in WMI */
 	if (status == HTT_RX_IND_MPDU_STATUS_MGMT_CTRL ||
-	    ath10k_htt_rx_is_mgmt(head)) {
+	    attention & RX_ATTENTION_FLAGS_MGMT_TYPE) {
 		ath10k_dbg(ATH10K_DBG_HTT, "htt rx mgmt ctrl\n");
 		return false;
 	}
@@ -1147,9 +1092,11 @@ static void ath10k_htt_rx_handler(struct ath10k_htt *htt,
 {
 	struct htt_rx_info info;
 	struct htt_rx_indication_mpdu_range *mpdu_ranges;
+	struct htt_rx_desc *rxd;
 	enum htt_rx_mpdu_status status;
 	struct ieee80211_hdr *hdr;
 	int num_mpdu_ranges;
+	u32 attention;
 	int fw_desc_len;
 	u8 *fw_desc;
 	bool channel_set, fcs_err, mic_err;
@@ -1213,23 +1160,29 @@ static void ath10k_htt_rx_handler(struct ath10k_htt *htt,
 				continue;
 			}
 
+			rxd = container_of((void *) msdu_head->data,
+					   struct htt_rx_desc,
+					   msdu_payload);
+			attention = __le32_to_cpu(rxd->attention.flags);
+
 			if (!ath10k_htt_rx_amsdu_allowed(htt, msdu_head,
 							 msdu_chaining > 0,
 							 status,
-							 channel_set)) {
+							 channel_set,
+							 attention)) {
 				ath10k_htt_rx_free_msdu_chain(msdu_head);
 				continue;
 			}
 
 			info.skb     = msdu_head;
 
-			fcs_err = ath10k_htt_rx_has_fcs_err(msdu_head);
+			fcs_err = !!(attention & RX_ATTENTION_FLAGS_FCS_ERR);
 			if (fcs_err)
 				info.rx_status.flag |= RX_FLAG_FAILED_FCS_CRC;
 			else
 				info.rx_status.flag &= ~RX_FLAG_FAILED_FCS_CRC;
 
-			mic_err = ath10k_htt_rx_has_mic_err(msdu_head);
+			mic_err = !!(attention & RX_ATTENTION_FLAGS_TKIP_MIC_ERR);
 			if (mic_err)
 				info.rx_status.flag |= RX_FLAG_MMIC_ERROR;
 			else
-- 
1.7.9.5

