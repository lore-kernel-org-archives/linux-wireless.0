Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f52.google.com ([74.125.83.52]:64957 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758530AbaCSItl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Mar 2014 04:49:41 -0400
Received: by mail-ee0-f52.google.com with SMTP id e49so6336200eek.11
        for <linux-wireless@vger.kernel.org>; Wed, 19 Mar 2014 01:49:39 -0700 (PDT)
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [RFC v2 8/8] ath10k: improve way we play with attention flags
Date: Wed, 19 Mar 2014 09:49:03 +0100
Message-Id: <1395218943-31704-8-git-send-email-janusz.dziedzic@tieto.com> (sfid-20140319_094948_472150_21A9814B)
In-Reply-To: <1395218943-31704-1-git-send-email-janusz.dziedzic@tieto.com>
References: <1395218943-31704-1-git-send-email-janusz.dziedzic@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove almost the same code, and do only once
__le32_to_cpu() conversion.

Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
---
 drivers/net/wireless/ath/ath10k/htt_rx.c |   89 +++++++-----------------------
 1 file changed, 19 insertions(+), 70 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index 8bccba5..665a256 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -994,62 +994,6 @@ static void ath10k_htt_rx_msdu(struct ath10k_htt *htt, struct htt_rx_info *info)
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
@@ -1135,7 +1079,8 @@ static int ath10k_unchain_msdu(struct sk_buff *msdu_head)
 static bool ath10k_htt_rx_amsdu_allowed(struct ath10k_htt *htt,
 					struct sk_buff *head,
 					enum htt_rx_mpdu_status status,
-					bool channel_set)
+					bool channel_set,
+					u32 attention)
 {
 	if (head->len == 0) {
 		ath10k_dbg(ATH10K_DBG_HTT,
@@ -1143,7 +1088,7 @@ static bool ath10k_htt_rx_amsdu_allowed(struct ath10k_htt *htt,
 		return false;
 	}
 
-	if (ath10k_htt_rx_has_decrypt_err(head)) {
+	if (attention & RX_ATTENTION_FLAGS_DECRYPT_ERR) {
 		ath10k_dbg(ATH10K_DBG_HTT,
 			   "htt rx dropping due to decrypt-err\n");
 		return false;
@@ -1156,7 +1101,7 @@ static bool ath10k_htt_rx_amsdu_allowed(struct ath10k_htt *htt,
 
 	/* Skip mgmt frames while we handle this in WMI */
 	if (status == HTT_RX_IND_MPDU_STATUS_MGMT_CTRL ||
-	    ath10k_htt_rx_is_mgmt(head)) {
+	    attention & RX_ATTENTION_FLAGS_MGMT_TYPE) {
 		ath10k_dbg(ATH10K_DBG_HTT, "htt rx mgmt ctrl\n");
 		return false;
 	}
@@ -1185,12 +1130,14 @@ static void ath10k_htt_rx_handler(struct ath10k_htt *htt,
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
-	bool channel_set, fcs_err, mic_err;
+	bool channel_set;
 	int i, j;
 	int ret;
 
@@ -1252,9 +1199,15 @@ static void ath10k_htt_rx_handler(struct ath10k_htt *htt,
 				continue;
 			}
 
+			rxd = container_of((void *) msdu_head->data,
+					   struct htt_rx_desc,
+					   msdu_payload);
+			attention = __le32_to_cpu(rxd->attention.flags);
+
 			if (!ath10k_htt_rx_amsdu_allowed(htt, msdu_head,
 							 status,
-							 channel_set)) {
+							 channel_set,
+							 attention)) {
 				ath10k_htt_rx_free_msdu_chain(msdu_head);
 				continue;
 			}
@@ -1275,21 +1228,17 @@ static void ath10k_htt_rx_handler(struct ath10k_htt *htt,
 						 RX_FLAG_IV_STRIPPED |
 						 RX_FLAG_MMIC_STRIPPED);
 
-			fcs_err = ath10k_htt_rx_has_fcs_err(msdu_head);
-			if (fcs_err)
+			if (attention & RX_ATTENTION_FLAGS_FCS_ERR) {
 				info.rx_status.flag |= RX_FLAG_FAILED_FCS_CRC;
-
-			mic_err = ath10k_htt_rx_has_mic_err(msdu_head);
-			if (mic_err)
-				info.rx_status.flag |= RX_FLAG_MMIC_ERROR;
-
-			if (fcs_err)
 				ath10k_dbg(ATH10K_DBG_HTT,
 					   "htt rx has FCS err\n");
+			}
 
-			if (mic_err)
+			if (attention & RX_ATTENTION_FLAGS_TKIP_MIC_ERR) {
+				info.rx_status.flag |= RX_FLAG_MMIC_ERROR;
 				ath10k_dbg(ATH10K_DBG_HTT,
 					   "htt rx has MIC err\n");
+			}
 
 			hdr = ath10k_htt_rx_skb_get_hdr(msdu_head);
 
-- 
1.7.9.5

