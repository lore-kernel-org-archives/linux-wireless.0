Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f182.google.com ([209.85.217.182]:48397 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753376AbaKDOeZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Nov 2014 09:34:25 -0500
Received: by mail-lb0-f182.google.com with SMTP id f15so12485510lbj.27
        for <linux-wireless@vger.kernel.org>; Tue, 04 Nov 2014 06:34:24 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 3/7] ath10k: refactor htt->rx_confused
Date: Tue,  4 Nov 2014 15:22:07 +0100
Message-Id: <1415110931-10945-4-git-send-email-michal.kazior@tieto.com> (sfid-20141104_153431_963266_59218147)
In-Reply-To: <1415110931-10945-1-git-send-email-michal.kazior@tieto.com>
References: <1415110931-10945-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Make the rx_confused be handled by the rx
indication handlers instead of the buffer popping
function.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/htt_rx.c | 29 ++++++++++++-----------------
 1 file changed, 12 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index cba2f3b..651028e 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -316,20 +316,13 @@ static int ath10k_htt_rx_amsdu_pop(struct ath10k_htt *htt,
 
 	lockdep_assert_held(&htt->rx_ring.lock);
 
-	if (htt->rx_confused) {
-		ath10k_warn(ar, "htt is confused. refusing rx\n");
-		return -1;
-	}
-
 	for (;;) {
 		int last_msdu, msdu_len_invalid, msdu_chained;
 
 		msdu = ath10k_htt_rx_netbuf_pop(htt);
 		if (!msdu) {
-			ath10k_err(ar, "failed to pop msdu\n");
 			__skb_queue_purge(amsdu);
-			htt->rx_confused = true;
-			break;
+			return -ENOENT;
 		}
 
 		__skb_queue_tail(amsdu, msdu);
@@ -351,10 +344,8 @@ static int ath10k_htt_rx_amsdu_pop(struct ath10k_htt *htt,
 		 */
 		if (!(__le32_to_cpu(rx_desc->attention.flags)
 				& RX_ATTENTION_FLAGS_MSDU_DONE)) {
-			ath10k_err(ar, "popped an incomplete msdu\n");
 			__skb_queue_purge(amsdu);
-			htt->rx_confused = true;
-			break;
+			return -EIO;
 		}
 
 		*attention |= __le32_to_cpu(rx_desc->attention.flags) &
@@ -422,10 +413,8 @@ static int ath10k_htt_rx_amsdu_pop(struct ath10k_htt *htt,
 		while (msdu_chained--) {
 			msdu = ath10k_htt_rx_netbuf_pop(htt);
 			if (!msdu) {
-				ath10k_warn(ar, "failed to pop chained msdu\n");
 				__skb_queue_purge(amsdu);
-				htt->rx_confused = true;
-				break;
+				return -ENOENT;
 			}
 
 			__skb_queue_tail(amsdu, msdu);
@@ -1201,6 +1190,9 @@ static void ath10k_htt_rx_handler(struct ath10k_htt *htt,
 
 	lockdep_assert_held(&htt->rx_ring.lock);
 
+	if (htt->rx_confused)
+		return;
+
 	fw_desc_len = __le16_to_cpu(rx->prefix.fw_rx_desc_bytes);
 	fw_desc = (u8 *)&rx->fw_desc;
 
@@ -1246,10 +1238,13 @@ static void ath10k_htt_rx_handler(struct ath10k_htt *htt,
 					      &fw_desc_len, &amsdu,
 					      &attention);
 		if (ret < 0) {
-			ath10k_warn(ar, "failed to pop amsdu from htt rx ring %d\n",
-				    ret);
+			ath10k_warn(ar, "rx ring became corrupted: %d\n", ret);
 			__skb_queue_purge(&amsdu);
-			continue;
+			/* FIXME: It's probably a good idea to reboot the
+			 * device instead of leaving it inoperable.
+			 */
+			htt->rx_confused = true;
+			break;
 		}
 
 		if (!ath10k_htt_rx_amsdu_allowed(htt, skb_peek(&amsdu),
-- 
1.8.5.3

