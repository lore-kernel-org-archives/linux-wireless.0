Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb05.tieto.com ([131.207.168.36]:54448 "EHLO ebb05.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933997Ab3HHIOU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Aug 2013 04:14:20 -0400
From: Michal Kazior <michal.kazior@tieto.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 3/4] ath10k: clean up PCI completion states
Date: Thu, 8 Aug 2013 10:14:09 +0200
Message-ID: <1375949650-9699-4-git-send-email-michal.kazior@tieto.com> (sfid-20130808_101428_565750_E733FE55)
In-Reply-To: <1375949650-9699-1-git-send-email-michal.kazior@tieto.com>
References: <1375949650-9699-1-git-send-email-michal.kazior@tieto.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Improve code readability by using enum and a
switch-case.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/pci.c |   21 +++++++++++++++------
 drivers/net/wireless/ath/ath10k/pci.h |   13 +++++++------
 2 files changed, 22 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index 1814af1..321cc88 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -538,7 +538,7 @@ static void ath10k_pci_ce_send_done(struct ce_state *ce_state,
 		if (!compl)
 			break;
 
-		compl->send_or_recv = HIF_CE_COMPLETE_SEND;
+		compl->state = ATH10K_PCI_COMPL_SEND;
 		compl->ce_state = ce_state;
 		compl->pipe_info = pipe_info;
 		compl->transfer_context = transfer_context;
@@ -588,7 +588,7 @@ static void ath10k_pci_ce_recv_data(struct ce_state *ce_state,
 		if (!compl)
 			break;
 
-		compl->send_or_recv = HIF_CE_COMPLETE_RECV;
+		compl->state = ATH10K_PCI_COMPL_RECV;
 		compl->ce_state = ce_state;
 		compl->pipe_info = pipe_info;
 		compl->transfer_context = transfer_context;
@@ -810,7 +810,7 @@ static int ath10k_pci_start_ce(struct ath10k *ar)
 				return -ENOMEM;
 			}
 
-			compl->send_or_recv = HIF_CE_COMPLETE_FREE;
+			compl->state = ATH10K_PCI_COMPL_FREE;
 			list_add_tail(&compl->list, &pipe_info->compl_free);
 		}
 	}
@@ -909,12 +909,14 @@ static void ath10k_pci_process_ce(struct ath10k *ar)
 		list_del(&compl->list);
 		spin_unlock_bh(&ar_pci->compl_lock);
 
-		if (compl->send_or_recv == HIF_CE_COMPLETE_SEND) {
+		switch (compl->state) {
+		case ATH10K_PCI_COMPL_SEND:
 			cb->tx_completion(ar,
 					  compl->transfer_context,
 					  compl->transfer_id);
 			send_done = 1;
-		} else {
+			break;
+		case ATH10K_PCI_COMPL_RECV:
 			ret = ath10k_pci_post_rx_pipe(compl->pipe_info, 1);
 			if (ret) {
 				ath10k_warn("Unable to post recv buffer for pipe: %d\n",
@@ -941,9 +943,16 @@ static void ath10k_pci_process_ce(struct ath10k *ar)
 					    nbytes,
 					    skb->len + skb_tailroom(skb));
 			}
+			break;
+		case ATH10K_PCI_COMPL_FREE:
+			ath10k_warn("free completion cannot be processed\n");
+			break;
+		default:
+			ath10k_warn("invalid completion state (%d)\n", compl->state);
+			break;
 		}
 
-		compl->send_or_recv = HIF_CE_COMPLETE_FREE;
+		compl->state = ATH10K_PCI_COMPL_FREE;
 
 		/*
 		 * Add completion back to the pipe's free list.
diff --git a/drivers/net/wireless/ath/ath10k/pci.h b/drivers/net/wireless/ath/ath10k/pci.h
index d3a2e6c..1908d61 100644
--- a/drivers/net/wireless/ath/ath10k/pci.h
+++ b/drivers/net/wireless/ath/ath10k/pci.h
@@ -43,9 +43,15 @@ struct bmi_xfer {
 	u32 resp_len;
 };
 
+enum ath10k_pci_compl_state {
+	ATH10K_PCI_COMPL_FREE = 0,
+	ATH10K_PCI_COMPL_SEND,
+	ATH10K_PCI_COMPL_RECV,
+};
+
 struct ath10k_pci_compl {
 	struct list_head list;
-	int send_or_recv;
+	enum ath10k_pci_compl_state state;
 	struct ce_state *ce_state;
 	struct hif_ce_pipe_info *pipe_info;
 	void *transfer_context;
@@ -54,11 +60,6 @@ struct ath10k_pci_compl {
 	unsigned int flags;
 };
 
-/* compl_state.send_or_recv */
-#define HIF_CE_COMPLETE_FREE 0
-#define HIF_CE_COMPLETE_SEND 1
-#define HIF_CE_COMPLETE_RECV 2
-
 /*
  * PCI-specific Target state
  *
-- 
1.7.9.5

