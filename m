Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:50204 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933181AbaCUJct (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Mar 2014 05:32:49 -0400
Received: by mail-ee0-f46.google.com with SMTP id t10so1572774eei.19
        for <linux-wireless@vger.kernel.org>; Fri, 21 Mar 2014 02:32:48 -0700 (PDT)
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [PATCH 6/8] ath10k: return error when ath10k_htt_rx_amsdu_pop() fail
Date: Fri, 21 Mar 2014 10:32:19 +0100
Message-Id: <1395394341-3958-7-git-send-email-janusz.dziedzic@tieto.com> (sfid-20140321_103300_062927_A4AB4B14)
In-Reply-To: <1395394341-3958-1-git-send-email-janusz.dziedzic@tieto.com>
References: <1395394341-3958-1-git-send-email-janusz.dziedzic@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Return error when rx_amsdu_pop() will fail.

Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
---
 drivers/net/wireless/ath/ath10k/htt_rx.c |   50 ++++++++++++++++--------------
 1 file changed, 26 insertions(+), 24 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index a994a4f..64abc2a 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -297,6 +297,7 @@ static void ath10k_htt_rx_free_msdu_chain(struct sk_buff *skb)
 	}
 }
 
+/* return: < 0 fatal error, 0 - non chained msdu, 1 chained msdu */
 static int ath10k_htt_rx_amsdu_pop(struct ath10k_htt *htt,
 				   u8 **fw_desc, int *fw_desc_len,
 				   struct sk_buff **head_msdu,
@@ -310,7 +311,7 @@ static int ath10k_htt_rx_amsdu_pop(struct ath10k_htt *htt,
 
 	if (htt->rx_confused) {
 		ath10k_warn("htt is confused. refusing rx\n");
-		return 0;
+		return -1;
 	}
 
 	msdu = *head_msdu = ath10k_htt_rx_netbuf_pop(htt);
@@ -442,6 +443,9 @@ static int ath10k_htt_rx_amsdu_pop(struct ath10k_htt *htt,
 	}
 	*tail_msdu = msdu;
 
+	if (*head_msdu == NULL)
+		msdu_chaining = -1;
+
 	/*
 	 * Don't refill the ring yet.
 	 *
@@ -1139,11 +1143,6 @@ static bool ath10k_htt_rx_amsdu_allowed(struct ath10k_htt *htt,
 					enum htt_rx_mpdu_status status,
 					bool channel_set)
 {
-	if (!head) {
-		ath10k_warn("htt rx no data!\n");
-		return false;
-	}
-
 	if (head->len == 0) {
 		ath10k_dbg(ATH10K_DBG_HTT,
 			   "htt rx dropping due to zero-len\n");
@@ -1199,6 +1198,7 @@ static void ath10k_htt_rx_handler(struct ath10k_htt *htt,
 	u8 *fw_desc;
 	bool channel_set, fcs_err, mic_err;
 	int i, j;
+	int ret;
 
 	lockdep_assert_held(&htt->rx_ring.lock);
 
@@ -1242,15 +1242,21 @@ static void ath10k_htt_rx_handler(struct ath10k_htt *htt,
 
 		for (j = 0; j < mpdu_ranges[i].mpdu_count; j++) {
 			struct sk_buff *msdu_head, *msdu_tail;
-			int msdu_chaining;
 
 			msdu_head = NULL;
 			msdu_tail = NULL;
-			msdu_chaining = ath10k_htt_rx_amsdu_pop(htt,
-							 &fw_desc,
-							 &fw_desc_len,
-							 &msdu_head,
-							 &msdu_tail);
+			ret = ath10k_htt_rx_amsdu_pop(htt,
+						      &fw_desc,
+						      &fw_desc_len,
+						      &msdu_head,
+						      &msdu_tail);
+
+			if (ret < 0) {
+				ath10k_warn("failed to pop amsdu from htt rx ring %d\n",
+					    ret);
+				ath10k_htt_rx_free_msdu_chain(msdu_head);
+				continue;
+			}
 
 			if (!ath10k_htt_rx_amsdu_allowed(htt, msdu_head,
 							 status,
@@ -1259,8 +1265,8 @@ static void ath10k_htt_rx_handler(struct ath10k_htt *htt,
 				continue;
 			}
 
-			if (msdu_chaining &&
-			    (ath10k_unchain_msdu(msdu_head) < 0)) {
+			if (ret > 0 &&
+			    ath10k_unchain_msdu(msdu_head) < 0) {
 				ath10k_htt_rx_free_msdu_chain(msdu_head);
 				continue;
 			}
@@ -1308,7 +1314,7 @@ static void ath10k_htt_rx_frag_handler(struct ath10k_htt *htt,
 	enum rx_msdu_decap_format fmt;
 	struct htt_rx_info info = {};
 	struct ieee80211_hdr *hdr;
-	int msdu_chaining;
+	int ret;
 	bool tkip_mic_err;
 	bool decrypt_err;
 	u8 *fw_desc;
@@ -1322,19 +1328,15 @@ static void ath10k_htt_rx_frag_handler(struct ath10k_htt *htt,
 	msdu_tail = NULL;
 
 	spin_lock_bh(&htt->rx_ring.lock);
-	msdu_chaining = ath10k_htt_rx_amsdu_pop(htt, &fw_desc, &fw_desc_len,
-						&msdu_head, &msdu_tail);
+	ret = ath10k_htt_rx_amsdu_pop(htt, &fw_desc, &fw_desc_len,
+				      &msdu_head, &msdu_tail);
 	spin_unlock_bh(&htt->rx_ring.lock);
 
 	ath10k_dbg(ATH10K_DBG_HTT_DUMP, "htt rx frag ahead\n");
 
-	if (!msdu_head) {
-		ath10k_warn("htt rx frag no data\n");
-		return;
-	}
-
-	if (msdu_chaining || msdu_head != msdu_tail) {
-		ath10k_warn("aggregation with fragmentation?!\n");
+	if (ret) {
+		ath10k_warn("failed to pop amsdu from httr rx ring for fragmented rx %d\n",
+			    ret);
 		ath10k_htt_rx_free_msdu_chain(msdu_head);
 		return;
 	}
-- 
1.7.9.5

