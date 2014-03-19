Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f50.google.com ([74.125.83.50]:52452 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753099AbaCSGKM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Mar 2014 02:10:12 -0400
Received: by mail-ee0-f50.google.com with SMTP id c13so6280247eek.9
        for <linux-wireless@vger.kernel.org>; Tue, 18 Mar 2014 23:10:10 -0700 (PDT)
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [PATCH 1/2] ath10k: add ath10k_htt_rx_amsdu_allowed function
Date: Wed, 19 Mar 2014 07:09:40 +0100
Message-Id: <1395209381-26782-1-git-send-email-janusz.dziedzic@tieto.com> (sfid-20140319_071019_521778_8383FBEB)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Introduce ath10k_htt_rx_amsdu_allowed() function, that
group code for checking if skip amsdu packets.

Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
---
 drivers/net/wireless/ath/ath10k/htt_rx.c |   95 ++++++++++++++++--------------
 1 file changed, 51 insertions(+), 44 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index cdcbe2d..9cd54a9 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -952,6 +952,55 @@ static int ath10k_unchain_msdu(struct sk_buff *msdu_head)
 	return 0;
 }
 
+static bool ath10k_htt_rx_amsdu_allowed(struct ath10k_htt *htt,
+					struct sk_buff *head,
+					struct htt_rx_info *info)
+{
+	enum htt_rx_mpdu_status status = info->status;
+
+	if (!head) {
+		ath10k_warn("htt rx no data!\n");
+		return false;
+	}
+
+	if (head->len == 0) {
+		ath10k_dbg(ATH10K_DBG_HTT,
+			   "htt rx dropping due to zero-len\n");
+		return false;
+	}
+
+	if (ath10k_htt_rx_has_decrypt_err(head)) {
+		ath10k_dbg(ATH10K_DBG_HTT,
+			   "htt rx dropping due to decrypt-err\n");
+		return false;
+	}
+
+	/* Skip mgmt frames while we handle this in WMI */
+	if (status == HTT_RX_IND_MPDU_STATUS_MGMT_CTRL ||
+	    ath10k_htt_rx_is_mgmt(head)) {
+		ath10k_dbg(ATH10K_DBG_HTT, "htt rx mgmt ctrl\n");
+		return false;
+	}
+
+	if (status != HTT_RX_IND_MPDU_STATUS_OK &&
+	    status != HTT_RX_IND_MPDU_STATUS_TKIP_MIC_ERR &&
+	    status != HTT_RX_IND_MPDU_STATUS_ERR_INV_PEER &&
+	    !htt->ar->monitor_enabled) {
+		ath10k_dbg(ATH10K_DBG_HTT,
+			   "htt rx ignoring frame w/ status %d\n",
+			   status);
+		return false;
+	}
+
+	if (test_bit(ATH10K_CAC_RUNNING, &htt->ar->dev_flags)) {
+		ath10k_dbg(ATH10K_DBG_HTT,
+			   "htt rx CAC running\n");
+		return false;
+	}
+
+	return true;
+}
+
 static void ath10k_htt_rx_handler(struct ath10k_htt *htt,
 				  struct htt_rx_indication *rx)
 {
@@ -984,7 +1033,6 @@ static void ath10k_htt_rx_handler(struct ath10k_htt *htt,
 
 		for (j = 0; j < mpdu_ranges[i].mpdu_count; j++) {
 			struct sk_buff *msdu_head, *msdu_tail;
-			enum htt_rx_mpdu_status status;
 			int msdu_chaining;
 
 			msdu_head = NULL;
@@ -995,49 +1043,8 @@ static void ath10k_htt_rx_handler(struct ath10k_htt *htt,
 							 &msdu_head,
 							 &msdu_tail);
 
-			if (!msdu_head) {
-				ath10k_warn("htt rx no data!\n");
-				continue;
-			}
-
-			if (msdu_head->len == 0) {
-				ath10k_dbg(ATH10K_DBG_HTT,
-					   "htt rx dropping due to zero-len\n");
-				ath10k_htt_rx_free_msdu_chain(msdu_head);
-				continue;
-			}
-
-			if (ath10k_htt_rx_has_decrypt_err(msdu_head)) {
-				ath10k_dbg(ATH10K_DBG_HTT,
-					   "htt rx dropping due to decrypt-err\n");
-				ath10k_htt_rx_free_msdu_chain(msdu_head);
-				continue;
-			}
-
-			status = info.status;
-
-			/* Skip mgmt frames while we handle this in WMI */
-			if (status == HTT_RX_IND_MPDU_STATUS_MGMT_CTRL ||
-			    ath10k_htt_rx_is_mgmt(msdu_head)) {
-				ath10k_dbg(ATH10K_DBG_HTT, "htt rx mgmt ctrl\n");
-				ath10k_htt_rx_free_msdu_chain(msdu_head);
-				continue;
-			}
-
-			if (status != HTT_RX_IND_MPDU_STATUS_OK &&
-			    status != HTT_RX_IND_MPDU_STATUS_TKIP_MIC_ERR &&
-			    status != HTT_RX_IND_MPDU_STATUS_ERR_INV_PEER &&
-			    !htt->ar->monitor_enabled) {
-				ath10k_dbg(ATH10K_DBG_HTT,
-					   "htt rx ignoring frame w/ status %d\n",
-					   status);
-				ath10k_htt_rx_free_msdu_chain(msdu_head);
-				continue;
-			}
-
-			if (test_bit(ATH10K_CAC_RUNNING, &htt->ar->dev_flags)) {
-				ath10k_dbg(ATH10K_DBG_HTT,
-					   "htt rx CAC running\n");
+			if (!ath10k_htt_rx_amsdu_allowed(htt, msdu_head,
+							 &info)) {
 				ath10k_htt_rx_free_msdu_chain(msdu_head);
 				continue;
 			}
-- 
1.7.9.5

