Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:39723 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751163AbaB1BVZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Feb 2014 20:21:25 -0500
From: greearb@candelatech.com
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Ben Greear <greearb@candelatech.com>
Subject: [PATCH v2] ath10k:  support msdu chaining.
Date: Thu, 27 Feb 2014 17:20:52 -0800
Message-Id: <1393550452-1302-1-git-send-email-greearb@candelatech.com> (sfid-20140228_022129_035434_E4BA2E09)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

Consolidate the list of msdu skbs into the msdu-head skb, delete the
rest of the skbs, pass the msdu-head skb on up the stack as normal.

Tested with high-speed TCP and UDP traffic on modified firmware that
supports raw-rx.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---

v2:  Add note about skb_try_coalesce, though I am not sure it will
     work or not.
     Only grow skb once, which should save on some memory (re)allocation
     and copying when we have more than one chained skb.

 drivers/net/wireless/ath/ath10k/htt_rx.c | 60 +++++++++++++++++++++++++++++---
 1 file changed, 56 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index 9f3def7..a5070a9 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -401,6 +401,7 @@ static int ath10k_htt_rx_amsdu_pop(struct ath10k_htt *htt,
 		msdu_len = MS(__le32_to_cpu(rx_desc->msdu_start.info0),
 			      RX_MSDU_START_INFO0_MSDU_LENGTH);
 		msdu_chained = rx_desc->frag_info.ring2_more_count;
+		msdu_chaining = msdu_chained;
 
 		if (msdu_len_invalid)
 			msdu_len = 0;
@@ -428,7 +429,6 @@ static int ath10k_htt_rx_amsdu_pop(struct ath10k_htt *htt,
 
 			msdu->next = next;
 			msdu = next;
-			msdu_chaining = 1;
 		}
 
 		last_msdu = __le32_to_cpu(rx_desc->msdu_end.info0) &
@@ -1008,14 +1008,66 @@ continue_on:
 				continue;
 			}
 
-			/* FIXME: we do not support chaining yet.
-			 * this needs investigation */
 			if (msdu_chaining) {
-				ath10k_warn("htt rx msdu_chaining is true\n");
+				struct sk_buff *next = msdu_head->next;
+				struct sk_buff *to_free = next;
+				static int do_once = 1;
+				int space;
+				int total_len = 0;
+
+				/* TODO:  Might could optimize this by using
+				 * skb_try_coalesce or similar method to]
+				 * decrease copying.
+				 */
+
+				msdu_head->next = NULL;
+
+				if (unlikely(do_once)) {
+					ath10k_warn("htt rx msdu_chaining detected %d\n",
+						    msdu_chaining);
+					do_once = 0;
+				}
+
+				/* Allocate total length all at once. */
+				while (next) {
+					total_len += next->len;
+					next = next->next;
+				}
+
+				space = total_len - skb_tailroom(msdu_head);
+				if ((space > 0) &&
+				    (pskb_expand_head(msdu_head, 0, space, GFP_ATOMIC) < 0)) {
+					/* TODO:  bump some rx-oom error stat */
+					goto outside_continue;
+				}
+
+				/* Walk list again, copying contents into
+				 * msdu_head
+				 */
+				next = to_free;
+				while (next) {
+					skb_copy_from_linear_data(next, skb_put(msdu_head, next->len),
+								  next->len);
+					next = next->next;
+				}
+
+				/* If here, we have consolidated skb.  Free the
+				 * fragments and pass the main skb on up the
+				 * stack.
+				 */
+				ath10k_htt_rx_free_msdu_chain(to_free);
+				goto have_good_msdu;
+
+			outside_continue:
+				/* put it back together so we can free the
+				 * whole list at once.
+				 */
+				msdu_head->next = to_free;
 				ath10k_htt_rx_free_msdu_chain(msdu_head);
 				continue;
 			}
 
+		have_good_msdu:
 			info.skb     = msdu_head;
 			info.fcs_err = ath10k_htt_rx_has_fcs_err(msdu_head);
 			info.mic_err = ath10k_htt_rx_has_mic_err(msdu_head);
-- 
1.7.11.7

