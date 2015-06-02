Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:35784 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752854AbbFBHOy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Jun 2015 03:14:54 -0400
From: Raja Mani <rmani@qti.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath10k@lists.infradead.org>,
	Raja Mani <rmani@qti.qualcomm.com>
Subject: [PATCH] ath10k: remove unused variable 'id' in ath10k_pci_tx_pipe_cleanup()
Date: Tue, 2 Jun 2015 12:44:27 +0530
Message-ID: <1433229267-11314-1-git-send-email-rmani@qti.qualcomm.com> (sfid-20150602_091457_429016_0F9A87DB)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

mete_data is extracted from ce descriptor and stored in variable 'id'.
later, id is not used anywhere in the same function.

Signed-off-by: Raja Mani <rmani@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/pci.c |    3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index 969a123..bbc349a 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -1275,7 +1275,6 @@ static void ath10k_pci_tx_pipe_cleanup(struct ath10k_pci_pipe *pci_pipe)
 	struct ath10k_ce_ring *ce_ring;
 	struct ce_desc *ce_desc;
 	struct sk_buff *skb;
-	unsigned int id;
 	int i;
 
 	ar = pci_pipe->hif_ce_state;
@@ -1299,8 +1298,6 @@ static void ath10k_pci_tx_pipe_cleanup(struct ath10k_pci_pipe *pci_pipe)
 			continue;
 
 		ce_ring->per_transfer_context[i] = NULL;
-		id = MS(__le16_to_cpu(ce_desc[i].flags),
-			CE_DESC_FLAGS_META_DATA);
 
 		ar_pci->msg_callbacks_current.tx_completion(ar, skb);
 	}
-- 
1.7.10.4

