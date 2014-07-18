Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f171.google.com ([74.125.82.171]:43745 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755456AbaGRMxr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Jul 2014 08:53:47 -0400
Received: by mail-we0-f171.google.com with SMTP id p10so4604402wes.16
        for <linux-wireless@vger.kernel.org>; Fri, 18 Jul 2014 05:53:45 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH] ath10k: prevent endless pci rx loop
Date: Fri, 18 Jul 2014 14:45:01 +0200
Message-Id: <1405687501-25917-1-git-send-email-michal.kazior@tieto.com> (sfid-20140718_145356_380763_B4A22A67)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It was possible to enter an endless loop while
processing a single pci copy engine pipe. This
could effectively render ath10k incapable of
responding to any requests.

An example case when this could happen is when
firmware generates a lot of events, e.g. spectral
scan phyerr via WMI.

Reported-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
Janusz was testing spectral scan when he found
ath10k would sometimes stop responding while
flooding dmesg with phyerr prints.

There's another bug he found related to scan code
but we still need to test some stuff before I can
post the fix.

 drivers/net/wireless/ath/ath10k/pci.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index 06840d1..0ffff20 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -726,18 +726,12 @@ static void ath10k_pci_ce_recv_data(struct ath10k_ce_pipe *ce_state)
 	unsigned int nbytes, max_nbytes;
 	unsigned int transfer_id;
 	unsigned int flags;
-	int err;
+	int err, num_replenish = 0;
 
 	while (ath10k_ce_completed_recv_next(ce_state, &transfer_context,
 					     &ce_data, &nbytes, &transfer_id,
 					     &flags) == 0) {
-		err = ath10k_pci_post_rx_pipe(pipe_info, 1);
-		if (unlikely(err)) {
-			/* FIXME: retry */
-			ath10k_warn("failed to replenish CE rx ring %d: %d\n",
-				    pipe_info->pipe_num, err);
-		}
-
+		num_replenish++;
 		skb = transfer_context;
 		max_nbytes = skb->len + skb_tailroom(skb);
 		dma_unmap_single(ar->dev, ATH10K_SKB_CB(skb)->paddr,
@@ -753,6 +747,13 @@ static void ath10k_pci_ce_recv_data(struct ath10k_ce_pipe *ce_state)
 		skb_put(skb, nbytes);
 		cb->rx_completion(ar, skb, pipe_info->pipe_num);
 	}
+
+	err = ath10k_pci_post_rx_pipe(pipe_info, num_replenish);
+	if (unlikely(err)) {
+		/* FIXME: retry */
+		ath10k_warn("failed to replenish CE rx ring %d (%d bufs): %d\n",
+			    pipe_info->pipe_num, num_replenish, err);
+	}
 }
 
 static int ath10k_pci_hif_tx_sg(struct ath10k *ar, u8 pipe_id,
-- 
1.8.5.3

