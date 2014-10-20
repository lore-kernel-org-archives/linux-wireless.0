Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f178.google.com ([209.85.217.178]:49590 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752868AbaJTNyX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Oct 2014 09:54:23 -0400
Received: by mail-lb0-f178.google.com with SMTP id w7so3972774lbi.9
        for <linux-wireless@vger.kernel.org>; Mon, 20 Oct 2014 06:54:22 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 6/9] ath10k: don't drop frames aggressively
Date: Mon, 20 Oct 2014 15:40:35 +0200
Message-Id: <1413812438-14640-7-git-send-email-michal.kazior@tieto.com> (sfid-20141020_155428_553184_B0B9FC1F)
In-Reply-To: <1413812438-14640-1-git-send-email-michal.kazior@tieto.com>
References: <1413812438-14640-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There's little point in dropping, e.g. frames with
FCS error early in ath10k.

This simplifies amsdu_allowed() and gets rid of
htt_rx_mpdu_status usage finally.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/htt_rx.c | 15 ---------------
 1 file changed, 15 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index 41a2803..7fa4d87 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -1171,7 +1171,6 @@ static int ath10k_unchain_msdu(struct sk_buff *msdu_head)
 
 static bool ath10k_htt_rx_amsdu_allowed(struct ath10k_htt *htt,
 					struct sk_buff *head,
-					enum htt_rx_mpdu_status status,
 					bool channel_set,
 					u32 attention)
 {
@@ -1200,16 +1199,6 @@ static bool ath10k_htt_rx_amsdu_allowed(struct ath10k_htt *htt,
 		return false;
 	}
 
-	if (status != HTT_RX_IND_MPDU_STATUS_OK &&
-	    status != HTT_RX_IND_MPDU_STATUS_TKIP_MIC_ERR &&
-	    status != HTT_RX_IND_MPDU_STATUS_ERR_INV_PEER &&
-	    !htt->ar->monitor_started) {
-		ath10k_dbg(ar, ATH10K_DBG_HTT,
-			   "htt rx ignoring frame w/ status %d\n",
-			   status);
-		return false;
-	}
-
 	if (test_bit(ATH10K_CAC_RUNNING, &htt->ar->dev_flags)) {
 		ath10k_dbg(ar, ATH10K_DBG_HTT,
 			   "htt rx CAC running\n");
@@ -1225,7 +1214,6 @@ static void ath10k_htt_rx_handler(struct ath10k_htt *htt,
 	struct ath10k *ar = htt->ar;
 	struct ieee80211_rx_status *rx_status = &htt->rx_status;
 	struct htt_rx_indication_mpdu_range *mpdu_ranges;
-	enum htt_rx_mpdu_status status;
 	struct ieee80211_hdr *hdr;
 	int num_mpdu_ranges;
 	u32 attention;
@@ -1273,8 +1261,6 @@ static void ath10k_htt_rx_handler(struct ath10k_htt *htt,
 				num_mpdu_ranges));
 
 	for (i = 0; i < num_mpdu_ranges; i++) {
-		status = mpdu_ranges[i].mpdu_range_status;
-
 		for (j = 0; j < mpdu_ranges[i].mpdu_count; j++) {
 			struct sk_buff *msdu_head, *msdu_tail;
 
@@ -1296,7 +1282,6 @@ static void ath10k_htt_rx_handler(struct ath10k_htt *htt,
 			}
 
 			if (!ath10k_htt_rx_amsdu_allowed(htt, msdu_head,
-							 status,
 							 channel_set,
 							 attention)) {
 				ath10k_htt_rx_free_msdu_chain(msdu_head);
-- 
1.8.5.3

