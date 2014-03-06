Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f173.google.com ([209.85.215.173]:36161 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752367AbaCFKMY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Mar 2014 05:12:24 -0500
Received: by mail-ea0-f173.google.com with SMTP id r15so1598230ead.4
        for <linux-wireless@vger.kernel.org>; Thu, 06 Mar 2014 02:12:23 -0800 (PST)
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [RFC v2 13/14] ath10k: return error when ath10k_htt_rx_amsdu_pop() fail
Date: Thu,  6 Mar 2014 11:11:45 +0100
Message-Id: <1394100706-7820-1-git-send-email-janusz.dziedzic@tieto.com> (sfid-20140306_111234_756964_9A88B5BA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
---
 drivers/net/wireless/ath/ath10k/htt_rx.c |   48 ++++++++++++++++--------------
 1 file changed, 25 insertions(+), 23 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index 555aecf..c03d2ec 100644
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
@@ -1089,11 +1093,6 @@ static bool ath10k_htt_rx_amsdu_allowed(struct ath10k_htt *htt,
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
@@ -1199,18 +1198,25 @@ static void ath10k_htt_rx_handler(struct ath10k_htt *htt,
 
 		for (j = 0; j < mpdu_ranges[i].mpdu_count; j++) {
 			struct sk_buff *msdu_head, *msdu_tail;
-			int msdu_chaining;
+			int ret;
 
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
-							 !!msdu_chaining,
+							 ret > 0,
 							 status,
 							 channel_set)) {
 				ath10k_htt_rx_free_msdu_chain(msdu_head);
@@ -1260,7 +1266,7 @@ static void ath10k_htt_rx_frag_handler(struct ath10k_htt *htt,
 	enum rx_msdu_decap_format fmt;
 	struct htt_rx_info info = {};
 	struct ieee80211_hdr *hdr;
-	int msdu_chaining;
+	int ret;
 	bool tkip_mic_err;
 	bool decrypt_err;
 	u8 *fw_desc;
@@ -1274,19 +1280,15 @@ static void ath10k_htt_rx_frag_handler(struct ath10k_htt *htt,
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

