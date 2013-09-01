Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh03.mail.saunalahti.fi ([62.142.5.109]:55955 "EHLO
	emh03.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753128Ab3IAHBt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Sep 2013 03:01:49 -0400
Subject: [PATCH v2 3/7] ath10k: remove void pointer from struct
 ath10k_pci_compl
To: ath10k@lists.infradead.org
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Sun, 01 Sep 2013 10:01:46 +0300
Message-ID: <20130901070146.14695.17237.stgit@localhost6.localdomain6> (sfid-20130901_090152_311424_CC43A658)
In-Reply-To: <20130901070020.14695.16694.stgit@localhost6.localdomain6>
References: <20130901070020.14695.16694.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Void pointers are bad, mmkay.

No functional changes.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/pci.c |   12 ++++++------
 drivers/net/wireless/ath/ath10k/pci.h |    2 +-
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index 362814a..418de1e 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -643,7 +643,7 @@ static void ath10k_pci_ce_send_done(struct ath10k_ce_pipe *ce_state,
 		compl->state = ATH10K_PCI_COMPL_SEND;
 		compl->ce_state = ce_state;
 		compl->pipe_info = pipe_info;
-		compl->transfer_context = transfer_context;
+		compl->skb = transfer_context;
 		compl->nbytes = nbytes;
 		compl->transfer_id = transfer_id;
 		compl->flags = 0;
@@ -693,7 +693,7 @@ static void ath10k_pci_ce_recv_data(struct ath10k_ce_pipe *ce_state,
 		compl->state = ATH10K_PCI_COMPL_RECV;
 		compl->ce_state = ce_state;
 		compl->pipe_info = pipe_info;
-		compl->transfer_context = transfer_context;
+		compl->skb = transfer_context;
 		compl->nbytes = nbytes;
 		compl->transfer_id = transfer_id;
 		compl->flags = flags;
@@ -939,7 +939,7 @@ static void ath10k_pci_stop_ce(struct ath10k *ar)
 	 * their associated resources */
 	spin_lock_bh(&ar_pci->compl_lock);
 	list_for_each_entry(compl, &ar_pci->compl_process, list) {
-		skb = (struct sk_buff *)compl->transfer_context;
+		skb = compl->skb;
 		ATH10K_SKB_CB(skb)->is_aborted = true;
 	}
 	spin_unlock_bh(&ar_pci->compl_lock);
@@ -960,7 +960,7 @@ static void ath10k_pci_cleanup_ce(struct ath10k *ar)
 
 	list_for_each_entry_safe(compl, tmp, &ar_pci->compl_process, list) {
 		list_del(&compl->list);
-		netbuf = (struct sk_buff *)compl->transfer_context;
+		netbuf = compl->skb;
 		dev_kfree_skb_any(netbuf);
 		kfree(compl);
 	}
@@ -1014,7 +1014,7 @@ static void ath10k_pci_process_ce(struct ath10k *ar)
 		switch (compl->state) {
 		case ATH10K_PCI_COMPL_SEND:
 			cb->tx_completion(ar,
-					  compl->transfer_context,
+					  compl->skb,
 					  compl->transfer_id);
 			send_done = 1;
 			break;
@@ -1026,7 +1026,7 @@ static void ath10k_pci_process_ce(struct ath10k *ar)
 				break;
 			}
 
-			skb = (struct sk_buff *)compl->transfer_context;
+			skb = compl->skb;
 			nbytes = compl->nbytes;
 
 			ath10k_dbg(ATH10K_DBG_PCI,
diff --git a/drivers/net/wireless/ath/ath10k/pci.h b/drivers/net/wireless/ath/ath10k/pci.h
index 50f3e7b..2a6cb09 100644
--- a/drivers/net/wireless/ath/ath10k/pci.h
+++ b/drivers/net/wireless/ath/ath10k/pci.h
@@ -54,7 +54,7 @@ struct ath10k_pci_compl {
 	enum ath10k_pci_compl_state state;
 	struct ath10k_ce_pipe *ce_state;
 	struct ath10k_pci_pipe *pipe_info;
-	void *transfer_context;
+	struct sk_buff *skb;
 	unsigned int nbytes;
 	unsigned int transfer_id;
 	unsigned int flags;

