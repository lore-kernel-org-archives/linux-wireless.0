Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:47797 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753685AbcC3OFp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Mar 2016 10:05:45 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Sara Sharon <sara.sharon@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 07/43] iwlwifi: pcie: fix global table size
Date: Wed, 30 Mar 2016 17:04:39 +0300
Message-Id: <1459346715-7954-7-git-send-email-emmanuel.grumbach@intel.com> (sfid-20160330_160808_568782_7EC67DD1)
In-Reply-To: <1459346667.4731.9.camel@intel.com>
References: <1459346667.4731.9.camel@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

My patch resized the pool size, but neglected to resize
the global table, which is obviously wrong since the global
table maps the pool's rxb to vid one to one. This results
in a panic in 9000 devices.
Add a build bug to avoid such a case in the future.

Fixes: 7b5424361ec9 ("iwlwifi: pcie: fine tune number of rxbs")
Reported-by: Haim Dreyfuss <haim.dreyfuss@intel.com>
Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/pcie/internal.h | 2 +-
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c       | 2 ++
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/internal.h b/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
index dadafbd..34bf7ce 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
@@ -348,7 +348,7 @@ struct iwl_tso_hdr_page {
 struct iwl_trans_pcie {
 	struct iwl_rxq *rxq;
 	struct iwl_rx_mem_buffer rx_pool[RX_POOL_SIZE];
-	struct iwl_rx_mem_buffer *global_table[MQ_RX_TABLE_SIZE];
+	struct iwl_rx_mem_buffer *global_table[RX_POOL_SIZE];
 	struct iwl_rb_allocator rba;
 	struct iwl_trans *trans;
 	struct iwl_drv *drv;
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
index 4be3c35..e379dba 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
@@ -908,6 +908,8 @@ int iwl_pcie_rx_init(struct iwl_trans *trans)
 	allocator_pool_size = trans->num_rx_queues *
 		(RX_CLAIM_REQ_ALLOC - RX_POST_REQ_ALLOC);
 	num_alloc = queue_size + allocator_pool_size;
+	BUILD_BUG_ON(ARRAY_SIZE(trans_pcie->global_table) !=
+		     ARRAY_SIZE(trans_pcie->rx_pool));
 	for (i = 0; i < num_alloc; i++) {
 		struct iwl_rx_mem_buffer *rxb = &trans_pcie->rx_pool[i];
 
-- 
2.5.0

