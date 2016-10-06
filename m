Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:25388 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S941846AbcJFIkM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 6 Oct 2016 04:40:12 -0400
From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <mohammed@codeaurora.org>, <linux-wireless@vger.kernel.org>,
        "Mohammed Shafi Shajakhan" <mohammed@qti.qualcomm.com>
Subject: [PATCH v2 2/2] ath10k: Remove extraneous error message in tx alloc
Date: Thu, 6 Oct 2016 14:09:48 +0530
Message-ID: <1475743188-12007-2-git-send-email-mohammed@qca.qualcomm.com> (sfid-20161006_104031_624938_4024C92B)
In-Reply-To: <1475743188-12007-1-git-send-email-mohammed@qca.qualcomm.com>
References: <1475743188-12007-1-git-send-email-mohammed@qca.qualcomm.com>
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
[v2 rebased over top of tree]

 drivers/net/wireless/ath/ath10k/htt_tx.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/htt_tx.c b/drivers/net/wireless/ath/ath10k/htt_tx.c
index 786fbd7..4255c1a 100644
--- a/drivers/net/wireless/ath/ath10k/htt_tx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_tx.c
@@ -283,10 +283,8 @@ static int ath10k_htt_tx_alloc_cont_frag_desc(struct ath10k_htt *htt)
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
1.9.1
