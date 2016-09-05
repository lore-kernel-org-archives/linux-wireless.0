Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f65.google.com ([209.85.220.65]:36522 "EHLO
        mail-pa0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932541AbcIENjp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 5 Sep 2016 09:39:45 -0400
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: kvalo@qca.qualcomm.com
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH] ath10k: remove unused variable ar_pci
Date: Mon,  5 Sep 2016 22:38:02 +0900
Message-Id: <20160905133802.18755-1-chaehyun.lim@gmail.com> (sfid-20160905_153952_220324_98BB635F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Trival fix to remove unused variable ar_pci in ath10k_pci_tx_pipe_cleanup
when building with W=1:
drivers/net/wireless/ath/ath10k/pci.c:1696:21: warning: variable
'ar_pci' set but not used [-Wunused-but-set-variable]

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/net/wireless/ath/ath10k/pci.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index 1b841ad..afd5ef7 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -1693,14 +1693,12 @@ static void ath10k_pci_rx_pipe_cleanup(struct ath10k_pci_pipe *pci_pipe)
 static void ath10k_pci_tx_pipe_cleanup(struct ath10k_pci_pipe *pci_pipe)
 {
 	struct ath10k *ar;
-	struct ath10k_pci *ar_pci;
 	struct ath10k_ce_pipe *ce_pipe;
 	struct ath10k_ce_ring *ce_ring;
 	struct sk_buff *skb;
 	int i;
 
 	ar = pci_pipe->hif_ce_state;
-	ar_pci = ath10k_pci_priv(ar);
 	ce_pipe = pci_pipe->ce_hdl;
 	ce_ring = ce_pipe->src_ring;
 
-- 
2.9.2
