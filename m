Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:49030 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752654AbYAOC0z (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Jan 2008 21:26:55 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 02/12] iwlwifi: move iwl4965_get_dma_hi_address function to iwl-helpers.h
Date: Mon, 14 Jan 2008 17:46:15 -0800
Message-Id: <1200361585-31801-3-git-send-email-reinette.chatre@intel.com> (sfid-20080115_022702_947693_40BF6916)
In-Reply-To: <1200361585-31801-2-git-send-email-reinette.chatre@intel.com>
References: <1200361585-31801-1-git-send-email-reinette.chatre@intel.com>
 <1200361585-31801-2-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch moves iwl4965_get_dma_hi_address function to iwl-headers.h
as iwl_get_dma_hi_address. This function will be used in more chipsets
than only 4965.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965.c    |    9 ++-------
 drivers/net/wireless/iwlwifi/iwl-helpers.h |    5 +++++
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index b913c6b..a945788 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -2797,11 +2797,6 @@ int iwl4965_hw_tx_queue_init(struct iwl4965_priv *priv, struct iwl4965_tx_queue
 	return 0;
 }
 
-static inline u8 iwl4965_get_dma_hi_address(dma_addr_t addr)
-{
-	return sizeof(addr) > sizeof(u32) ? (addr >> 16) >> 16 : 0;
-}
-
 int iwl4965_hw_txq_attach_buf_to_tfd(struct iwl4965_priv *priv, void *ptr,
 				 dma_addr_t addr, u16 len)
 {
@@ -2822,7 +2817,7 @@ int iwl4965_hw_txq_attach_buf_to_tfd(struct iwl4965_priv *priv, void *ptr,
 	if (!is_odd) {
 		tfd->pa[index].tb1_addr = cpu_to_le32(addr);
 		IWL_SET_BITS(tfd->pa[index], tb1_addr_hi,
-			     iwl4965_get_dma_hi_address(addr));
+			     iwl_get_dma_hi_address(addr));
 		IWL_SET_BITS(tfd->pa[index], tb1_len, len);
 	} else {
 		IWL_SET_BITS(tfd->pa[index], tb2_addr_lo16,
@@ -3289,7 +3284,7 @@ int iwl4965_tx_cmd(struct iwl4965_priv *priv, struct iwl4965_cmd *out_cmd,
 	scratch_phys = txcmd_phys + sizeof(struct iwl4965_cmd_header) +
 	    offsetof(struct iwl4965_tx_cmd, scratch);
 	tx->dram_lsb_ptr = cpu_to_le32(scratch_phys);
-	tx->dram_msb_ptr = iwl4965_get_dma_hi_address(scratch_phys);
+	tx->dram_msb_ptr = iwl_get_dma_hi_address(scratch_phys);
 
 	/* Hard coded to start at the highest retry fallback position
 	 * until the 4965 specific rate control algorithm is tied in */
diff --git a/drivers/net/wireless/iwlwifi/iwl-helpers.h b/drivers/net/wireless/iwlwifi/iwl-helpers.h
index e2a8d95..5228834 100644
--- a/drivers/net/wireless/iwlwifi/iwl-helpers.h
+++ b/drivers/net/wireless/iwlwifi/iwl-helpers.h
@@ -252,4 +252,9 @@ static inline unsigned long elapsed_jiffies(unsigned long start,
 	return end + (MAX_JIFFY_OFFSET - start);
 }
 
+static inline u8 iwl_get_dma_hi_address(dma_addr_t addr)
+{
+	return sizeof(addr) > sizeof(u32) ? (addr >> 16) >> 16 : 0;
+}
+
 #endif				/* __iwl_helpers_h__ */
-- 
1.5.3.4

