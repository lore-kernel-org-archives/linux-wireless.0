Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:46202 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753382Ab2ECVQN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 May 2012 17:16:13 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>,
	stable@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 3.4] iwlwifi: fix a potential race in receive buffer allocation
Date: Thu,  3 May 2012 14:09:24 -0700
Message-Id: <1336079364-16222-1-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120503_231624_219438_9CCFD711)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>

The driver can potentially unmap pages that
have not been mapped yet. Fix this race
condition.

Cc: stable@vger.kernel.org
Reported-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
this patch will be also available from wireless branch on
 git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi.git

 drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
index aa7aea1..173275f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
@@ -310,7 +310,6 @@ static void iwlagn_rx_allocate(struct iwl_trans *trans, gfp_t priority)
 		spin_unlock_irqrestore(&rxq->lock, flags);
 
 		BUG_ON(rxb->page);
-		rxb->page = page;
 		/* Get physical address of the RB */
 		rxb->page_dma = dma_map_page(trans->dev, page, 0,
 				PAGE_SIZE << hw_params(trans).rx_page_order,
@@ -320,6 +319,9 @@ static void iwlagn_rx_allocate(struct iwl_trans *trans, gfp_t priority)
 		/* and also 256 byte aligned! */
 		BUG_ON(rxb->page_dma & DMA_BIT_MASK(8));
 
+		/* Page *must* be mapped before before updating the rxb. */
+		rxb->page = page;
+
 		spin_lock_irqsave(&rxq->lock, flags);
 
 		list_add_tail(&rxb->list, &rxq->rx_free);
-- 
1.7.0.4

