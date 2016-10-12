Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:22732 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933110AbcJLN0t (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 12 Oct 2016 09:26:49 -0400
From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <mohammed@codeaurora.org>, <linux-wireless@vger.kernel.org>,
        "Mohammed Shafi Shajakhan" <mohammed@qti.qualcomm.com>
Subject: [PATCH v3 2/2] ath10k: Remove extraneous error message in tx alloc
Date: Wed, 12 Oct 2016 18:56:18 +0530
Message-ID: <1476278778-4253-2-git-send-email-mohammed@qca.qualcomm.com> (sfid-20161012_152652_231699_84DA029C)
In-Reply-To: <1476278778-4253-1-git-send-email-mohammed@qca.qualcomm.com>
References: <1476278778-4253-1-git-send-email-mohammed@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>

Remove extraneous error message in 'ath10k_htt_tx_alloc_cont_frag_desc'
as the caller 'ath10k_htt_tx_alloc' already dumps a proper error
message

Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/htt_tx.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/htt_tx.c b/drivers/net/wireless/ath/ath10k/htt_tx.c
index ab2ee90..ccbc8c03 100644
--- a/drivers/net/wireless/ath/ath10k/htt_tx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_tx.c
@@ -282,10 +282,8 @@ static int ath10k_htt_tx_alloc_cont_frag_desc(struct ath10k_htt *htt)
 	htt->frag_desc.vaddr = dma_alloc_coherent(ar->dev, size,
 						  &htt->frag_desc.paddr,
 						  GFP_KERNEL);
-	if (!htt->frag_desc.vaddr) {
-		ath10k_err(ar, "failed to alloc fragment desc memory\n");
+	if (!htt->frag_desc.vaddr)
 		return -ENOMEM;
-	}
 
 	return 0;
 }
-- 
1.7.9.5
