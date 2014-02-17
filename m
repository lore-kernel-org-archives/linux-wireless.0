Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f54.google.com ([74.125.83.54]:37985 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752478AbaBQJhz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Feb 2014 04:37:55 -0500
Received: by mail-ee0-f54.google.com with SMTP id e53so6883910eek.41
        for <linux-wireless@vger.kernel.org>; Mon, 17 Feb 2014 01:37:53 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [RFC/RFT 2/7] ath10k: remove is_aborted from skb_cb
Date: Mon, 17 Feb 2014 10:32:38 +0100
Message-Id: <1392629563-31046-3-git-send-email-michal.kazior@tieto.com> (sfid-20140217_103805_327142_16720AA4)
In-Reply-To: <1392629563-31046-1-git-send-email-michal.kazior@tieto.com>
References: <1392629563-31046-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The flag wasn't used anymore. No need to keep it.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/core.h |  1 -
 drivers/net/wireless/ath/ath10k/pci.c  | 20 --------------------
 2 files changed, 21 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 082fa77..7cf022d 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -62,7 +62,6 @@ struct ath10k;
 
 struct ath10k_skb_cb {
 	dma_addr_t paddr;
-	bool is_aborted;
 	u8 vdev_id;
 
 	struct {
diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index 34f0910..d973975 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -63,7 +63,6 @@ static int ath10k_pci_post_rx(struct ath10k *ar);
 static int ath10k_pci_post_rx_pipe(struct ath10k_pci_pipe *pipe_info,
 					     int num);
 static void ath10k_pci_rx_pipe_cleanup(struct ath10k_pci_pipe *pipe_info);
-static void ath10k_pci_stop_ce(struct ath10k *ar);
 static int ath10k_pci_cold_reset(struct ath10k *ar);
 static int ath10k_pci_warm_reset(struct ath10k *ar);
 static int ath10k_pci_wait_for_target_init(struct ath10k *ar);
@@ -993,22 +992,6 @@ static void ath10k_pci_kill_tasklet(struct ath10k *ar)
 		tasklet_kill(&ar_pci->pipe_info[i].intr);
 }
 
-static void ath10k_pci_stop_ce(struct ath10k *ar)
-{
-	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
-	struct ath10k_pci_compl *compl;
-	struct sk_buff *skb;
-
-	/* Mark pending completions as aborted, so that upper layers free up
-	 * their associated resources */
-	spin_lock_bh(&ar_pci->compl_lock);
-	list_for_each_entry(compl, &ar_pci->compl_process, list) {
-		skb = compl->skb;
-		ATH10K_SKB_CB(skb)->is_aborted = true;
-	}
-	spin_unlock_bh(&ar_pci->compl_lock);
-}
-
 static void ath10k_pci_cleanup_ce(struct ath10k *ar)
 {
 	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
@@ -1339,7 +1322,6 @@ err_stop:
 	ath10k_ce_disable_interrupts(ar);
 	ath10k_pci_free_irq(ar);
 	ath10k_pci_kill_tasklet(ar);
-	ath10k_pci_stop_ce(ar);
 	ath10k_pci_process_ce(ar);
 err_free_compl:
 	ath10k_pci_cleanup_ce(ar);
@@ -1424,7 +1406,6 @@ static void ath10k_pci_tx_pipe_cleanup(struct ath10k_pci_pipe *pipe_info)
 			continue;
 		}
 
-		ATH10K_SKB_CB(netbuf)->is_aborted = true;
 		ar_pci->msg_callbacks_current.tx_completion(ar,
 							    netbuf,
 							    id);
@@ -1482,7 +1463,6 @@ static void ath10k_pci_hif_stop(struct ath10k *ar)
 
 	ath10k_pci_free_irq(ar);
 	ath10k_pci_kill_tasklet(ar);
-	ath10k_pci_stop_ce(ar);
 
 	ret = ath10k_pci_request_early_irq(ar);
 	if (ret)
-- 
1.8.5.3

