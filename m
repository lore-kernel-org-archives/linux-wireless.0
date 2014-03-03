Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:57758 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754906AbaCCWHo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Mar 2014 17:07:44 -0500
From: greearb@candelatech.com
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Ben Greear <greearb@candelatech.com>
Subject: [PATCH v3] ath10k:  support msdu chaining.
Date: Mon,  3 Mar 2014 14:07:09 -0800
Message-Id: <1393884429-8426-1-git-send-email-greearb@candelatech.com> (sfid-20140303_230749_960707_6166D40F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

Consolidate the list of msdu skbs into the msdu-head skb, delete the
rest of the skbs, pass the msdu-head skb on up the stack as normal.

Tested with high-speed TCP and UDP traffic on modified firmware that
supports raw-rx.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---

v3:  Use helper function to make main rx code simpler to read,
  and to get rid of checkpatch warnings.

 drivers/net/wireless/ath/ath10k/htt_rx.c | 59 +++++++++++++++++++++++++++++---
 1 file changed, 54 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index 99ae8bb..56e5d5e 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -399,6 +399,7 @@ static int ath10k_htt_rx_amsdu_pop(struct ath10k_htt *htt,
 		msdu_len = MS(__le32_to_cpu(rx_desc->msdu_start.info0),
 			      RX_MSDU_START_INFO0_MSDU_LENGTH);
 		msdu_chained = rx_desc->frag_info.ring2_more_count;
+		msdu_chaining = msdu_chained;
 
 		if (msdu_len_invalid)
 			msdu_len = 0;
@@ -426,7 +427,6 @@ static int ath10k_htt_rx_amsdu_pop(struct ath10k_htt *htt,
 
 			msdu->next = next;
 			msdu = next;
-			msdu_chaining = 1;
 		}
 
 		last_msdu = __le32_to_cpu(rx_desc->msdu_end.info0) &
@@ -902,6 +902,57 @@ static int ath10k_htt_rx_get_csum_state(struct sk_buff *skb)
 	return CHECKSUM_UNNECESSARY;
 }
 
+static int ath10k_unchain_msdu(struct sk_buff *msdu_head)
+{
+	struct sk_buff *next = msdu_head->next;
+	struct sk_buff *to_free = next;
+	int space;
+	int total_len = 0;
+
+	/* TODO:  Might could optimize this by using
+	 * skb_try_coalesce or similar method to
+	 * decrease copying, or maybe get mac80211 to
+	 * provide a way to just receive a list of
+	 * skb?
+	 */
+
+	msdu_head->next = NULL;
+
+	/* Allocate total length all at once. */
+	while (next) {
+		total_len += next->len;
+		next = next->next;
+	}
+
+	space = total_len - skb_tailroom(msdu_head);
+	if ((space > 0) &&
+	    (pskb_expand_head(msdu_head, 0, space, GFP_ATOMIC) < 0)) {
+		/* TODO:  bump some rx-oom error stat */
+		/* put it back together so we can free the
+		 * whole list at once.
+		 */
+		msdu_head->next = to_free;
+		return -1;
+	}
+
+	/* Walk list again, copying contents into
+	 * msdu_head
+	 */
+	next = to_free;
+	while (next) {
+		skb_copy_from_linear_data(next, skb_put(msdu_head, next->len),
+					  next->len);
+		next = next->next;
+	}
+
+	/* If here, we have consolidated skb.  Free the
+	 * fragments and pass the main skb on up the
+	 * stack.
+	 */
+	ath10k_htt_rx_free_msdu_chain(to_free);
+	return 0;
+}
+
 static void ath10k_htt_rx_handler(struct ath10k_htt *htt,
 				  struct htt_rx_indication *rx)
 {
@@ -1014,10 +1065,8 @@ continue_on:
 				continue;
 			}
 
-			/* FIXME: we do not support chaining yet.
-			 * this needs investigation */
-			if (msdu_chaining) {
-				ath10k_warn("htt rx msdu_chaining is true\n");
+			if (msdu_chaining &&
+			    (ath10k_unchain_msdu(msdu_head) < 0)) {
 				ath10k_htt_rx_free_msdu_chain(msdu_head);
 				continue;
 			}
-- 
1.7.11.7

