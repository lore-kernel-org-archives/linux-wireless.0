Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:56044 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S933275AbcISHcn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Sep 2016 03:32:43 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Mon, 19 Sep 2016 10:30:28 +0300
Message-Id: <20160919073028.22065-25-luca@coelho.fi> (sfid-20160919_100149_131041_03DAE5F0)
In-Reply-To: <1474270071.5664.89.camel@coelho.fi>
References: <1474270071.5664.89.camel@coelho.fi>
Subject: [PATCH 25/25] iwlwifi: pcie: use LIST_HEAD() macro
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

There's no need to declare a list and then init it manually,
just use the LIST_HEAD() macro.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
index 78cb6d2..6fe5546 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
@@ -487,15 +487,13 @@ static void iwl_pcie_rx_allocator(struct iwl_trans *trans)
 
 	while (pending) {
 		int i;
-		struct list_head local_allocated;
+		LIST_HEAD(local_allocated);
 		gfp_t gfp_mask = GFP_KERNEL;
 
 		/* Do not post a warning if there are only a few requests */
 		if (pending < RX_PENDING_WATERMARK)
 			gfp_mask |= __GFP_NOWARN;
 
-		INIT_LIST_HEAD(&local_allocated);
-
 		for (i = 0; i < RX_CLAIM_REQ_ALLOC;) {
 			struct iwl_rx_mem_buffer *rxb;
 			struct page *page;
-- 
2.9.3
