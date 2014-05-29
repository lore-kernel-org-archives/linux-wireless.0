Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f176.google.com ([74.125.82.176]:58062 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756101AbaE2J5b (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 May 2014 05:57:31 -0400
Received: by mail-we0-f176.google.com with SMTP id q59so119911wes.35
        for <linux-wireless@vger.kernel.org>; Thu, 29 May 2014 02:57:30 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH] ath10k: remove unnecessary htt rx corruption check
Date: Thu, 29 May 2014 11:50:08 +0200
Message-Id: <1401357008-16259-1-git-send-email-michal.kazior@tieto.com> (sfid-20140529_115751_462722_922CDF54)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

While fixing a bug reported by Avery I went ahead
and added a warning suspecting there might be
something more to the bug. This ended up with
people reporting they see warnings during heavy
traffic. This bought me some time and helped me
understand the problem better - apparently fw/hw
can report a chained msdus as follows: 1 msdu, 1
chained, 1 msdu (0 length).

The patch removes the extra check but leaves the
other change that fixed the original skb_push
panic bug (msdu_chaining was overwritten in an
unfortunate way which made the above example to
be treated as non-chained case).

Reported-by: Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
Reported-by: Tim Harvey <tharvey@gateworks.com>
Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/htt_rx.c | 18 ------------------
 1 file changed, 18 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index 6c102b1..eebc860 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -312,7 +312,6 @@ static int ath10k_htt_rx_amsdu_pop(struct ath10k_htt *htt,
 	int msdu_len, msdu_chaining = 0;
 	struct sk_buff *msdu;
 	struct htt_rx_desc *rx_desc;
-	bool corrupted = false;
 
 	lockdep_assert_held(&htt->rx_ring.lock);
 
@@ -439,9 +438,6 @@ static int ath10k_htt_rx_amsdu_pop(struct ath10k_htt *htt,
 		last_msdu = __le32_to_cpu(rx_desc->msdu_end.info0) &
 				RX_MSDU_END_INFO0_LAST_MSDU;
 
-		if (msdu_chaining && !last_msdu)
-			corrupted = true;
-
 		if (last_msdu) {
 			msdu->next = NULL;
 			break;
@@ -457,20 +453,6 @@ static int ath10k_htt_rx_amsdu_pop(struct ath10k_htt *htt,
 		msdu_chaining = -1;
 
 	/*
-	 * Apparently FW sometimes reports weird chained MSDU sequences with
-	 * more than one rx descriptor. This seems like a bug but needs more
-	 * analyzing. For the time being fix it by dropping such sequences to
-	 * avoid blowing up the host system.
-	 */
-	if (corrupted) {
-		ath10k_warn("failed to pop chained msdus, dropping\n");
-		ath10k_htt_rx_free_msdu_chain(*head_msdu);
-		*head_msdu = NULL;
-		*tail_msdu = NULL;
-		msdu_chaining = -EINVAL;
-	}
-
-	/*
 	 * Don't refill the ring yet.
 	 *
 	 * First, the elements popped here are still in use - it is not
-- 
1.8.5.3

